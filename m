Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77352D0EF4
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgLGLZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:46 -0500
Received: from forward106j.mail.yandex.net ([5.45.198.249]:50935 "EHLO
        forward106j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbgLGLZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:45 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2020 06:25:44 EST
Received: from mxback15o.mail.yandex.net (mxback15o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::66])
        by forward106j.mail.yandex.net (Yandex) with ESMTP id 6B1A511A003F;
        Mon,  7 Dec 2020 14:25:00 +0300 (MSK)
Received: from iva8-174eb672ffa9.qloud-c.yandex.net (iva8-174eb672ffa9.qloud-c.yandex.net [2a02:6b8:c0c:b995:0:640:174e:b672])
        by mxback15o.mail.yandex.net (mxback/Yandex) with ESMTP id F3p372zXRV-Ox0GMB6X;
        Mon, 07 Dec 2020 14:25:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1607340300;
        bh=WkCLy0tEm4DRKSedDpaWHz4yU7pfFcAGCFB6ILXL01s=;
        h=In-Reply-To:To:Subject:From:Message-ID:Cc:Date:References;
        b=OQlC/Sjgtbb3oiJPUDuf1yik8GICC1Oralb6edXAK3ZbvUBzKSFsnZxiIBIrhujTR
         3k8mlS3yVkgBZuMP59vq0MSrKRGYMNczaPtz6DivLV3RP7PP3/a1osYwoi3IBcjXSE
         zPy+GlWsgHvcFwuGK4S0dujjGEhjBRXZ0wuKZz4s=
Authentication-Results: mxback15o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva8-174eb672ffa9.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id xZGsQV4Ihi-OwIaUimb;
        Mon, 07 Dec 2020 14:24:58 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   stsp <stsp2@yandex.ru>
Subject: KVM_SET_CPUID doesn't check supported bits (was Re: [PATCH 0/6] KVM:
 x86: KVM_SET_SREGS.CR4 bug fixes and cleanup)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
 <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
 <20201009040453.GA10744@linux.intel.com>
 <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
 <20201009153053.GA16234@linux.intel.com>
Message-ID: <b38dff0b-7e6d-3f3e-9724-8e280938628a@yandex.ru>
Date:   Mon, 7 Dec 2020 14:24:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201009153053.GA16234@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[re-send because of bad formatting]

09.10.2020 18:30, Sean Christopherson пишет:
>> The only other effect of setting VMXE was clearing VME. Which shouldn't
>> affect anything either, right?
> Hmm, clearing VME would mean that exceptions/interrupts within the 
> guest would
> trigger a switch out of v86 and into vanilla protected mode. v86 and 
> PM have
> different consistency checks, particularly for segmentation, so it's 
> plausible
> that clearing CR4.VME inadvertantly worked around the bug by avoiding 
> invalid
> guest state for v86.

Almost.

So with your patch set (thanks!) and a
bit of further investigations, it now became
clear where the problem is.
We have this code:
---

|cpuid->nent = 2; // Use the same values as in emu-i386/simx86/interp.c 
// (Pentium 133-200MHz, "GenuineIntel") cpuid->entries[0] = (struct 
kvm_cpuid_entry) { .function = 0, .eax = 1, .ebx = 0x756e6547, .ecx = 
0x6c65746e, .edx = 0x49656e69 }; // family 5, model 2, stepping 12, fpu 
vme de pse tsc msr mce cx8 cpuid->entries[1] = (struct kvm_cpuid_entry) 
{ .function = 1, .eax = 0x052c, .ebx = 0, .ecx = 0, .edx = 0x1bf }; ret 
= ioctl(vcpufd, KVM_SET_CPUID, cpuid); free(cpuid); if (ret == -1) { 
perror("KVM: KVM_SET_CPUID"); return 0; }|

---


It tries to enable VME among other things.
qemu appears to disable VME by default,
unless you do "-cpu host". So we have a situation where
the host (which is qemu) doesn't have VME,
and guest (dosemu) is trying to enable it.
Now obviously KVM_SET_CPUID doesn't check anyting
at all and returns success. That later turns
into an invalid guest state.


Question: should KVM_SET_CPUID check for
supported bits, end return error if not everything
is supported?
