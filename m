Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779AAB17CA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 06:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfIMEqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 00:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfIMEqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 00:46:20 -0400
Received: from localhost (unknown [84.241.200.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E110E20644;
        Fri, 13 Sep 2019 04:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568349979;
        bh=t3fz3+C+Rszs5v117iwBq01Z8XVjIxQhv9Gun6u8tMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nAxqE1jeHzcBqj7vt2s31JX2mZM36TzeeTNCnxyL124j8DT8qYynyf9uvPTX1WWBE
         C75UMsP2UwpAl28q5wSIIUIlBB6QPBGHaqSDmsd2y2Zh6WjEoo/yKgvSstp7N1vntj
         xDZK3JeX1rIm8lqy0gvUtH0FvxXLVy4WRzEMdS+c=
Date:   Fri, 13 Sep 2019 05:46:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        bp@alien8.de, carlo@caione.org, catalin.marinas@arm.com,
        devicetree@vger.kernel.org, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, khilman@baylibre.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, narmstrong@baylibre.com,
        rkrcmar@redhat.com, robh+dt@kernel.org,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, wanpengli@tencent.com, will.deacon@arm.com,
        x86@kernel.org,
        syzbot <syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: KASAN: slab-out-of-bounds Read in handle_vmptrld
Message-ID: <20190913044614.GA120223@kroah.com>
References: <000000000000a9d4f705924cff7a@google.com>
 <87lfutei1j.fsf@vitty.brq.redhat.com>
 <5218e70e-8a80-7c5f-277b-01d9ab70692a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5218e70e-8a80-7c5f-277b-01d9ab70692a@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 06:49:26PM +0200, Paolo Bonzini wrote:
> [tl;dr: there could be a /dev/usb bug only affecting KASAN
> configurations, jump to the end to skip the analysis and get to the bug
> details]
> 
> On 12/09/19 15:54, Vitaly Kuznetsov wrote:
> > Hm, the bisection seems bogus but the stack points us to the following
> > piece of code:
> > 
> >  4776)              if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmptr), &map)) {
> > <skip>
> >  4783)                      return nested_vmx_failValid(vcpu,
> >  4784)                              VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
> >  4785)              }
> >  4786) 
> >  4787)              new_vmcs12 = map.hva;
> >  4788) 
> > *4789)              if (new_vmcs12->hdr.revision_id != VMCS12_REVISION ||
> >  4790)                  (new_vmcs12->hdr.shadow_vmcs &&
> >  4791)                   !nested_cpu_has_vmx_shadow_vmcs(vcpu))) {
> > 
> > the reported problem seems to be on VMCS12 region access but it's part
> > of guest memory and we successfuly managed to map it. We're definitely
> > within 1-page range. Maybe KASAN is just wrong here?
> 
> Here is the relevant part of the syzkaller repro:
> 
> syz_kvm_setup_cpu$x86(r1, 0xffffffffffffffff,
> &(0x7f0000000000/0x18000)=nil, 0x0, 0x133, 0x0, 0x0, 0xff7d)
> r3 = syz_open_dev$usb(&(0x7f0000000080)='/dev/bus/usb/00#/00#\x00',
> 0x40000fffffd, 0x200800000000042)
> mmap$IORING_OFF_SQES(&(0x7f0000007000/0x2000)=nil, 0x2000, 0x4, 0x13,
> r3, 0x10000000)
> syz_kvm_setup_cpu$x86(0xffffffffffffffff, r2,
> &(0x7f0000000000/0x18000)=nil, 0x0, 0xfefd, 0x40, 0x0, 0xfffffffffffffdd4)
> ioctl$KVM_RUN(r2, 0xae80, 0x0)
> 
> The mmap$IORING_OFF_SQES is just a normal mmap from a device, which
> replaces the previous mapping for guest memory and in particular
> 0x7f0000007000 which is the VMCS (from the C reproducer: "#define
> ADDR_VAR_VMCS 0x7000").
> 
> The previous mapping is freed with do_munmap and then repopulated in
> usbdev_mmap with remap_pfn_range.  In KVM this means that kvm_vcpu_map
> goes through hva_to_pfn_remapped, which correctly calls get_page via
> kvm_get_pfn.  (Note that although drivers/usb/core/devio.c's usbdev_mmap
> sets VM_IO *after* calling remap_pfn_range, remap_pfn_range itself
> helpfully sets it before calling remap_p4d_range.  And anyway KVM is
> looking at vma->vm_flags under mmap_sem, which is held during mmap).
> 
> So, KVM should be doing the right thing.  Now, the error is:
> 
> > Read of size 4 at addr ffff888091e10000 by task syz-executor758/10006
> > The buggy address belongs to the object at ffff888091e109c0 
> > The buggy address is located 2496 bytes to the left of
> >  8192-byte region [ffff888091e109c0, ffff888091e129c0) 
> 
> And given the use of remap_pfn_range in devusb_mmap, the simplest
> explanation could be that USB expects kmalloc-8k to return 8k-aligned
> values, but this is not true anymore with KASAN.  CCing Dmitry, Greg and
> linux-usb.

USB drivers expect kmalloc to return DMA-able memory.  I don't know
about specific alignment issues, that should only an issue for the host
controller being used here, which you do not say in the above list.

We have had some reports that usbdev_mmap() does not do the "correct
thing" for all host controllers, but a lot of the DMA work that is in
linux-next for 5.4-rc1 should have helped resolve those issues.  What
tree are you seeing these bug reports happening from?

thanks,

greg k-h
