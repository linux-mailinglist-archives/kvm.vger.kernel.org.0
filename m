Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89C5FCCD8
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 23:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiJLVOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 17:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJLVOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 17:14:06 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 1FBA7115C28
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 14:14:04 -0700 (PDT)
Received: (qmail 1011241 invoked by uid 1000); 12 Oct 2022 17:14:04 -0400
Date:   Wed, 12 Oct 2022 17:14:04 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [BUG] KVM USB passthrough did not claim interface before use
Message-ID: <Y0cuHHWL3r7+mpcq@rowland.harvard.edu>
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
 <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
 <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
 <Y0QzrI92f9BL+91W@rowland.harvard.edu>
 <CAMdYzYpdLEKMSytGStvM2Gi+gkBY7GTUHZfoBt5X-2BEzLrfOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYpdLEKMSytGStvM2Gi+gkBY7GTUHZfoBt5X-2BEzLrfOw@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 02:49:09PM -0400, Peter Geis wrote:
> On Mon, Oct 10, 2022 at 11:01 AM Alan Stern <stern@rowland.harvard.edu> wrote:

> > > The bug is the device is unusable in passthrough, this is the only
> > > direction as to why. The question is which piece of software is
> > > causing it. I figure qemu is the most likely suspect, but they request
> > > bugs that are possibly in kvm start here. The cdc-acm driver is the
> > > least likely in my mind, as the other device that works also uses it.
> > > I just tested removing the other working device and only passing
> > > through the suspect device, and it still triggers the bug. So whatever
> > > the problem is, it's specific to this one device.
> >
> > Does anything of interest about the device show up in the virtual
> > machine's kernel log?
> 
> Nothing in regards to this no. The device enumerates, but any attempt
> to access it triggers the warning on the host only.

That's odd.  I don't see anything in the usbmon trace corresponding to 
the warning messages about interface 1.  In fact, I don't see anything 
at all in the trace relating to interface 1.

> > You can collect a usbmon trace on the host system to gather more
> > information about what the virtual machine is trying to do.  Your
> > previous post shows that the device is on bus 3, so before starting
> > qemu-kvm you would do:
> >
> >         cat /sys/kernel/debug/usb/usbmon/3u >mon.txt
> >
> > in a separate window.  Kill the cat process when the test is over and
> > post the output file.
> >
> > It'll help if you unplug the working device (and in fact as many devices
> > on bus 3 as is practical) before running the test, so that the trace
> > includes only traffic to the non-working device.
> >
> > For comparison, you could also acquire a usbmon trace of what happens
> > when you try using the device on a real, non-virtual machine.  For this
> > test you would start the trace before plugging in the device.
> 
> I've attached the requested file, but I have no idea how to read this.
> The file consists of the host when the device is plugged in until
> enumeration, left to idle for a few moments, then the guest is started
> and permitted to claim it.

Actually the device was plugged in and enumerated, and then about four 
seconds later it spontaneously disconnected for a moment.  It was 
enumerated again, and about three minutes after that it looks like the 
virtual guest started up.  The guest reset the device and enumerated it, 
but did nothing more.  In particular, the guest did not try to install 
configuration 1, which is odd.  Or if it did try this, the attempt 
wasn't visible in the usbmon trace.

I'm inclined to agree that the fault appears to lie in qemu-kvm.

>  No other device is on the bus.

In fact one other device was.  It identified itself with the strings
"PbAcid" and "CPS", but I can't tell more than that.  A UPS device,
perhaps?

There's one other thing you might try, although I'm not sure that it
will provide any useful new information.  Instead of collecting a
usbmon trace, collect a usbfs snoop log.  Before starting qemu, do:

	echo 1 >/sys/module/usbcore/parameters/usbfs_snoop

This will cause the accesses performed via usbfs, including those 
performed by the qemu process, to be printed in the kernel log.  (Not 
all of the accesses, but the more important ones.)  Let's see what shows 
up.

Alan Stern
