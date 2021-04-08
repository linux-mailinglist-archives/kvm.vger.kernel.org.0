Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BBD358480
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhDHNUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 09:20:14 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35578 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHNUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 09:20:13 -0400
Received: from [192.168.86.30] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 45C8720B5680;
        Thu,  8 Apr 2021 06:20:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 45C8720B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617888002;
        bh=m4XVZsDylx1Y5K0Go69fD64RY1hsejCeHkGzzgzsFQ8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LxpyCra7ur90dkmIxfrLR6kFWFtxsclh3w9C7DtEWzagA0pdp4wmQsLNRecBCONHf
         TmbUldMBJ4X9b0OxUbx0paIrizUrm6IGc+z3fxJpApYT+h5j4LKyQTrsMEC41A/Klm
         Rm6A5P1g3JyBkAUAO43YXF/2xlQeyVNXOkieP0S8=
Subject: Re: [PATCH 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <1c754fe1ad8ae797b4045903dab51ab45dd37755.1617804573.git.viremana@linux.microsoft.com>
 <87ft01ausu.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <b3eba256-fb3f-abda-cd83-df0c8f773314@linux.microsoft.com>
Date:   Thu, 8 Apr 2021 09:19:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <87ft01ausu.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/8/21 7:18 AM, Vitaly Kuznetsov wrote:
>
>>   	enable_gif(svm);
>> @@ -3967,6 +3999,9 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
>>   		svm->vmcb->control.nested_cr3 = cr3;
>>   		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>>   
>> +		if (kvm_x86_ops.tlb_remote_flush)
>> +			kvm_update_arch_tdp_pointer(vcpu->kvm, vcpu, cr3);
>> +
> VMX has "#if IS_ENABLED(CONFIG_HYPERV)" around this, should we add it
> here too?
Agreed. Will fix.

Thanks,
Vineeth

