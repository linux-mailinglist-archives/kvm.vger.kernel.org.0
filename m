Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C33A82B5
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhFOO1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:27:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43360 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFOO0W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 10:26:22 -0400
Received: from [192.168.86.35] (c-73-38-52-84.hsd1.vt.comcast.net [73.38.52.84])
        by linux.microsoft.com (Postfix) with ESMTPSA id 46E8720B6C50;
        Tue, 15 Jun 2021 07:24:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 46E8720B6C50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1623767057;
        bh=cTHCck5KxKI/CP9LuHPjfsJBbv22Q8bxdprLpu918Iw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gVGORou0bGGK/tDWC+ScR4xEWsbnBBcs7/CdN1MOHGlJIH94UjEqOAvgBSDKHS35O
         ceRtBHHCZbXj840On4Gh5lNTG9vo8IO0hh39xOjN8gOoSv2dGDgXnASaf84hDDoEPT
         HtxukizWCqySB5fOlL+ii6Hx3XawlTf52rssJQWI=
Subject: Re: [PATCH v5 7/7] KVM: SVM: hyper-v: Direct Virtual Flush support
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <fc8d24d8eb7017266bb961e39a171b0caf298d7f.1622730232.git.viremana@linux.microsoft.com>
 <878s3c65nr.fsf@vitty.brq.redhat.com>
From:   Vineeth Pillai <viremana@linux.microsoft.com>
Message-ID: <73508c14-3ca6-1d20-8f9e-14bd966c849a@linux.microsoft.com>
Date:   Tue, 15 Jun 2021 10:24:14 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <878s3c65nr.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,
>> +
>> +static inline void svm_hv_update_vp_id(struct vmcb *vmcb,
>> +		struct kvm_vcpu *vcpu)
>> +{
>> +	struct hv_enlightenments *hve =
>> +		(struct hv_enlightenments *)vmcb->control.reserved_sw;
>> +
>> +	if (hve->hv_vp_id != to_hv_vcpu(vcpu)->vp_index) {
>> +		hve->hv_vp_id = to_hv_vcpu(vcpu)->vp_index;
>> +		vmcb_mark_dirty(vmcb, VMCB_HV_NESTED_ENLIGHTENMENTS);
>> +	}
> This blows up in testing when no Hyper-V context was created on a vCPU,
> e.g. when running KVM selftests (to_hv_vcpu(vcpu) is NULL when no
> Hyper-V emulation features were requested on a vCPU but
> svm_hv_update_vp_id() is called unconditionally by svm_vcpu_run()).
>
> I'll be sending a patch to fix the immediate issue but I was wondering
> why we need to call svm_hv_update_vp_id() from svm_vcpu_run() as VP
> index is unlikely to change; we can probably just call it from
> kvm_hv_set_msr() instead.
Thanks a lot for catching this.

I think you are right, updating at kvm_hv_set_msr() makes sense. I was
following the vmx logic where it also sets the vp_id in vmx_vcpu_run. But it
calls a wrapper "kvm_hv_get_vpindex" which actually checks if hv_vcpu is not
null before the assignment. I should have used that instead, my mistake.
I will look a bit more into it and send out a patch for vmx and svm 
after little
more investigation.

Thanks,
Vineeth

