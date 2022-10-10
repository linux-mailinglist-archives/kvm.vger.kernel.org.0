Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19655FA0D2
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 17:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJJPBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 11:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJJPBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 11:01:03 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 869234E878
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 08:01:01 -0700 (PDT)
Received: (qmail 921302 invoked by uid 1000); 10 Oct 2022 11:01:00 -0400
Date:   Mon, 10 Oct 2022 11:01:00 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [BUG] KVM USB passthrough did not claim interface before use
Message-ID: <Y0QzrI92f9BL+91W@rowland.harvard.edu>
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
 <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
 <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 10:22:55AM -0400, Peter Geis wrote:
> On Mon, Oct 10, 2022 at 10:07 AM Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > On Mon, Oct 10, 2022 at 09:56:53AM -0400, Peter Geis wrote:
> > > Good Morning,
> > >
> > > I've run into a bug with a new usb device when attempting to pass
> > > through using qemu-kvm. Another device is passed through without
> > > issue, and qemu spice passthrough does not exhibit the issue. The usb
> > > device shows up in the KVM machine, but is unusable. I'm unsure if
> > > this is a usbfs bug, a qemu bug, or a bug in the device driver.
> > >
> > > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > > before use
> > > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > > before use
> > > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 1
> > > before use
> > > usb 3-6.2: usbfs: process 365671 (CPU 2/KVM) did not claim interface 0
> > > before use
> > > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> > > before use
> > > usb 3-6.2: usbfs: process 365672 (CPU 3/KVM) did not claim interface 0
> > > before use
> >
> > These are warnings, not bugs, although one could claim that the warnings
> > are caused by a bug in qemu-kvm.
> 
> The bug is the device is unusable in passthrough, this is the only
> direction as to why. The question is which piece of software is
> causing it. I figure qemu is the most likely suspect, but they request
> bugs that are possibly in kvm start here. The cdc-acm driver is the
> least likely in my mind, as the other device that works also uses it.
> I just tested removing the other working device and only passing
> through the suspect device, and it still triggers the bug. So whatever
> the problem is, it's specific to this one device.

Does anything of interest about the device show up in the virtual 
machine's kernel log?

You can collect a usbmon trace on the host system to gather more 
information about what the virtual machine is trying to do.  Your 
previous post shows that the device is on bus 3, so before starting 
qemu-kvm you would do:

	cat /sys/kernel/debug/usb/usbmon/3u >mon.txt

in a separate window.  Kill the cat process when the test is over and 
post the output file.

It'll help if you unplug the working device (and in fact as many devices 
on bus 3 as is practical) before running the test, so that the trace 
includes only traffic to the non-working device.

For comparison, you could also acquire a usbmon trace of what happens 
when you try using the device on a real, non-virtual machine.  For this 
test you would start the trace before plugging in the device.

Alan Stern
