Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D81288D48
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 17:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389486AbgJIPs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 11:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389144AbgJIPs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 11:48:29 -0400
Received: from forward105o.mail.yandex.net (forward105o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55277C0613D2;
        Fri,  9 Oct 2020 08:48:28 -0700 (PDT)
Received: from mxback14j.mail.yandex.net (mxback14j.mail.yandex.net [IPv6:2a02:6b8:0:1619::90])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 308CA420191C;
        Fri,  9 Oct 2020 18:48:24 +0300 (MSK)
Received: from myt6-efff10c3476a.qloud-c.yandex.net (myt6-efff10c3476a.qloud-c.yandex.net [2a02:6b8:c12:13a3:0:640:efff:10c3])
        by mxback14j.mail.yandex.net (mxback/Yandex) with ESMTP id WAnDOLR12X-mNkSxxve;
        Fri, 09 Oct 2020 18:48:24 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1602258504;
        bh=nE34g5pkiv+lyAv8KGYmFqhMePEwK7biDs9eZPxRsC4=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=sKY1w1KQeRWoVPIxkWPy2BuJ0QArwURKhswJVOWva5qLqdXebdWa+pyW98QiNsN0m
         sUKGAFBlPX1kRAxyRI+3amc4syVHoDxt2jmtpyWnd4EYHo0WOMBJ/bHN2nN98/5cUT
         Kfc0P0cZp0LSrM5QEtJe380YrynzJkSmrPHs4TGY=
Authentication-Results: mxback14j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-efff10c3476a.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TnvO1WRrh9-mNIuqjPx;
        Fri, 09 Oct 2020 18:48:23 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <5bf99bdf-b16f-8caf-ba61-860457606b8e@yandex.ru>
Date:   Fri, 9 Oct 2020 18:48:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009153053.GA16234@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

09.10.2020 18:30, Sean Christopherson пишет:
> On Fri, Oct 09, 2020 at 05:11:51PM +0300, stsp wrote:
>> 09.10.2020 07:04, Sean Christopherson пишет:
>>>> Hmm. But at least it was lying
>>>> similarly on AMD and Intel CPUs. :)
>>>> So I was able to reproduce the problems
>>>> myself.
>>>> Do you mean, any AMD tests are now useless, and we need to proceed with Intel
>>>> tests only?
>>> For anything VMXE related, yes.
>> What would be the expected behaviour on Intel, if it is set? Any difference
>> with AMD?
> On Intel, userspace should be able to stuff CR4.VMXE=1 via KVM_SET_SREGS if
> the 'nested' module param is 1, e.g. if 'modprobe kvm_intel nested=1'.  Note,
> 'nested' is enabled by default on kernel 5.0 and later.

So if I understand you correctly, we
need to test that:
- with nested=0 VMXE gives EINVAL
- with nested=1 VMXE changes nothing
visible, except probably to allow guest
to read that value (we won't test guest
reading though).

Is this correct?


> With AMD, setting CR4.VMXE=1 is never allowed as AMD doesn't support VMX,

OK, for that I can give you a
Tested-by: Stas Sergeev <stsp@users.sourceforge.net>

because I confirm that on AMD it now
consistently returns EINVAL, whereas
without your patches it did random crap,
depending on whether it is a first call to
KVM_SET_SREGS, or not first.


>> But we do not use unrestricted guest.
>> We use v86 under KVM.
> Unrestricted guest can kick in even if CR0.PG=1 && CR0.PE=1, e.g. there are
> segmentation checks that apply if and only if unrestricted_guest=0.  Long story
> short, without a deep audit, it's basically impossible to rule out a dependency
> on unrestricted guest since you're playing around with v86.

You mean "unrestricted_guest" as a module
parameter, rather than the similar named CPU
feature, right? So we may depend on
unrestricted_guest parameter, but not on a
hardware feature, correct?


>> The only other effect of setting VMXE was clearing VME. Which shouldn't
>> affect anything either, right?
> Hmm, clearing VME would mean that exceptions/interrupts within the guest would
> trigger a switch out of v86 and into vanilla protected mode.  v86 and PM have
> different consistency checks, particularly for segmentation, so it's plausible
> that clearing CR4.VME inadvertantly worked around the bug by avoiding invalid
> guest state for v86.

Lets assume that was the case.
With those github guys its not possible
to do any consistent checks. :(

