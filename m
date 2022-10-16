Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB685FFCE5
	for <lists+kvm@lfdr.de>; Sun, 16 Oct 2022 03:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiJPBdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Oct 2022 21:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJPBdV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Oct 2022 21:33:21 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C965741D1D
        for <kvm@vger.kernel.org>; Sat, 15 Oct 2022 18:33:19 -0700 (PDT)
Received: (qmail 1125367 invoked by uid 1000); 15 Oct 2022 21:33:18 -0400
Date:   Sat, 15 Oct 2022 21:33:18 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     kvm@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [BUG] KVM USB passthrough did not claim interface before use
Message-ID: <Y0tfXv2U7Izx5boj@rowland.harvard.edu>
References: <CAMdYzYrUOoTmBL2c_+=xLBMXg38Pp4hANnzqxoe1cVDDrFvqTA@mail.gmail.com>
 <Y0QnFHqrX2r/7oUz@rowland.harvard.edu>
 <CAMdYzYodS7Y4bZ+fzzAXMSiCfQHwMkmV8-C=b3FVUXDExavXgA@mail.gmail.com>
 <Y0QzrI92f9BL+91W@rowland.harvard.edu>
 <CAMdYzYpdLEKMSytGStvM2Gi+gkBY7GTUHZfoBt5X-2BEzLrfOw@mail.gmail.com>
 <Y0cuHHWL3r7+mpcq@rowland.harvard.edu>
 <CAMdYzYockLYigqgX+R28a_Xy=wGExGj-MXL79Jrc7Jv7B6Qh3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYockLYigqgX+R28a_Xy=wGExGj-MXL79Jrc7Jv7B6Qh3w@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 15, 2022 at 08:36:19PM -0400, Peter Geis wrote:
> On Wed, Oct 12, 2022 at 5:14 PM Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > There's one other thing you might try, although I'm not sure that it
> > will provide any useful new information.  Instead of collecting a
> > usbmon trace, collect a usbfs snoop log.  Before starting qemu, do:
> >
> >         echo 1 >/sys/module/usbcore/parameters/usbfs_snoop
> >
> > This will cause the accesses performed via usbfs, including those
> > performed by the qemu process, to be printed in the kernel log.  (Not
> > all of the accesses, but the more important ones.)  Let's see what shows
> > up.
> 
> So I built and tested the newest version of QEMU, and it exhibits the
> same issue. I've also captured the log as requested and attached it
> here.

Here's what appears to be the relevant parts of the log.

> [93190.933026] usb 3-6.2: opened by process 149607: rpc-libvirtd
> [93191.006429] usb 3-6.2: opened by process 149605: qemu-system-x86

The device is opened by proces 194605, which is probably the main qemu
process (or the main one in charge of USB I/O).  I assume this is the
process which goes ahead with initialization and enumeration, because
there are no indications of other processes opening the device.

> [93195.712484] usb 3-6.2: usbdev_do_ioctl: RESET
> [93195.892482] usb 3-6.2: reset full-speed USB device number 70 using xhci_hcd
> [93196.095050] cdc_acm 3-6.2:1.0: ttyACM0: USB ACM device

As part of initialization, qemu resets the device and its interfaces
then get claimed by the cdc_acm driver on the host.  This may be the
problem; there's no indication in the log that cdc_acm ever releases
those interfaces.

> [93196.482584] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> [93196.482589] usb 3-6.2: usbfs: process 149617 (CPU 3/KVM) did not claim interface 0 before use
> [93209.729484] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> [93209.729489] usb 3-6.2: usbfs: process 149616 (CPU 2/KVM) did not claim interface 0 before use
> [93209.729574] usb 3-6.2: usbdev_do_ioctl: CLEAR_HALT
> [93209.729577] usb 3-6.2: usbfs: process 149617 (CPU 3/KVM) did not claim interface 1 before use
> [93209.729632] usb 3-6.2: usbdev_do_ioctl: SUBMITURB
> [93209.729635] usb 3-6.2: usbfs: process 149614 (CPU 0/KVM) did not claim interface 0 before use

Unforunately these warning messages don't indicate directly whether
the attempts to use the interfaces were successful.  But it's clear
that something went wrong with those URB submissions because the snoop
log doesn't include the contents of the URBs or their results.

My guess is that the attempts failed because the interfaces were
already claimed by cdc_acm in the host.  I would expect qemu to unbind
cdc_acm when it starts up, but apparently it doesn't.  And there are
no CLAIM_PORT messages in the log.

Perhaps it will help if you do the unbind by hand before starting
qemu.  Try doing:

	echo 3-6.2:1.0 >/sys/bus/usb/drivers/cdc_acm/unbind
	echo 3-6.2:1.1 >/sys/bus/usb/drivers/cdc_acm/unbind

Or better yet, blacklist the cdc_acm driver on the host if you can.

Alan Stern
