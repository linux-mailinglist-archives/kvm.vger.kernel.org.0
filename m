Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8297288A75
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 16:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbgJIOMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 10:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388664AbgJIOMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 10:12:02 -0400
Received: from forward102o.mail.yandex.net (forward102o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::602])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB661C0613D6
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 07:12:01 -0700 (PDT)
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward102o.mail.yandex.net (Yandex) with ESMTP id 5295A66800B3;
        Fri,  9 Oct 2020 17:11:54 +0300 (MSK)
Received: from mxback10q.mail.yandex.net (mxback10q.mail.yandex.net [IPv6:2a02:6b8:c0e:1b4:0:640:b6ef:cb3])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id 401B9CF40005;
        Fri,  9 Oct 2020 17:11:54 +0300 (MSK)
Received: from vla5-47b3f4751bc4.qloud-c.yandex.net (vla5-47b3f4751bc4.qloud-c.yandex.net [2a02:6b8:c18:3508:0:640:47b3:f475])
        by mxback10q.mail.yandex.net (mxback/Yandex) with ESMTP id zrKwLBa7XU-BrCWgPYm;
        Fri, 09 Oct 2020 17:11:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1602252714;
        bh=QnZ5DRgh9AnhoAJPFzwxk5KVV2gYGi2dmlD6DyGmKEA=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=qoKSWL5Irds4zNXcW8OIvqGV4gZzGvoG2OmbmAMTCDT1pqnaUdmIY2x40VbGZzzpp
         4453f/zbW/P8CxB8UzfTi7s8Wm5x8Q9QC351yAXaHn7HqUXt24/0ogN/QjF+cevzG7
         AQHePYzIR91g2SWD1/RPArp9eu5h4fNpP+fJhQ/E=
Authentication-Results: mxback10q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-47b3f4751bc4.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id DI6R0U7krW-Brnm8Vah;
        Fri, 09 Oct 2020 17:11:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <5dfa55f3-ecdf-9f8d-2d45-d2e6e54f2daa@yandex.ru>
Date:   Fri, 9 Oct 2020 17:11:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009040453.GA10744@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

09.10.2020 07:04, Sean Christopherson пишет:
>> Hmm. But at least it was lying
>> similarly on AMD and Intel CPUs. :)
>> So I was able to reproduce the problems
>> myself.
>> Do you mean, any AMD tests are now useless, and we need to proceed with Intel
>> tests only?
> For anything VMXE related, yes.

What would be the expected behaviour
on Intel, if it is set? Any difference with AMD?


>> Then additional question.
>> On old Intel CPUs we needed to set VMXE in guest to make it to work in
>> nested-guest mode.
>> Is it still needed even with your patches?
>> Or the nested-guest mode will work now even on older Intel CPUs and KVM will
>> set VMXE for us itself, when needed?
> I'm struggling to even come up with a theory as to how setting VMXE from
> userspace would have impacted KVM with unrestricted_guest=n, let alone fixed
> anything.
>
> CR4.VMXE must always be 1 in _hardware_ when VMX is on, including when running
> the guest.  But KVM forces vmcs.GUEST_CR4.VMXE=1 at all times, regardless of
> the guest's actual value (the guest sees a shadow value when it reads CR4).
>
> And unless I grossly misunderstand dosemu2, it's not doing anything related to
> nested virtualization, i.e. the stuffing VMXE=1 for the guest's shadow value
> should have absolutely zero impact.
>
> More than likely, VMXE was a red herring.

Yes, it was. :(
(as you can see from the end of the
github thread)


>    Given that the reporter is also
> seeing the same bug on bare metal after moving to kernel 5.4, odds are good
> the issue is related to unrestricted_guest=n and has nothing to do with nVMX.

But we do not use unrestricted guest.
We use v86 under KVM.
The only other effect of setting VMXE
was clearing VME. Which shouldn't affect
anything either, right?

