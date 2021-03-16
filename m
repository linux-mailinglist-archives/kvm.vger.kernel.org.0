Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2433D3C5
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhCPMYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 08:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231397AbhCPMYK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 08:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615897445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f+velte/fa3kpJGZogNSMgY/6Q8TU5X9HHuGgoFSDow=;
        b=QHwGIyzCt6awTbU5WSVmtnsoL3GhOTF+mPmmFmaBRmchswjMgHvYtkhKHqXbiDPJ1LgGl1
        Ex/zL3jfHTk/JkDti4xigqnzM3oHDp3aARe0LPqt/ickhkWjCsuiNsKv4qVDCyrR5kIBgm
        SLeYVDJ9coNvBwpEhpCK9f25XrRAEw8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-BnkJIvedMcG2yzjPZY8NXw-1; Tue, 16 Mar 2021 08:24:04 -0400
X-MC-Unique: BnkJIvedMcG2yzjPZY8NXw-1
Received: by mail-ed1-f69.google.com with SMTP id q25so2797117eds.16
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 05:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=f+velte/fa3kpJGZogNSMgY/6Q8TU5X9HHuGgoFSDow=;
        b=neWViE+41Fzspb4X16wSG3Sxjh7Q/j6re9pyDe9bingdd1QCnVd7JzYkzv4inCV4RV
         A+gzc+4qjTE0I3FikTS+JSMbNYpHEvWiYNCX/WOYAPV6RnSilQ3iwSz7HRkMPXj4UGsD
         LfCkHhQp+o7vKlcOPXcYurDmV8klnO9i90/XH7jDmKg4rj6u+o0EYZZMZX2LhrMvmZuj
         ztkYIlYWmMfhH7g1DEqgpeRaXH7e2QYbUOl2ApmgCi5mRMOItlyoJ5PYxYMn+ceP8sTj
         1KoLjK3FFD6lbZgPL4Jd2QtZNRphhaHFIK3xSKOidI3vjRw0AiS7eNAsL9pbY6Ht0MIX
         4hXw==
X-Gm-Message-State: AOAM530KnQzBA4wz+UXXxDFEKUNwiyB2cZyh0bLywYZtMvbbsTOFcQtC
        bej2KQYquSO55Z2pD7mxUw3Bn7KlRKe/QLm+vsuJuxlqiELfI+In0LiLTVaUJsPxUMz11aKY2DE
        EP9wAC6F/eri5
X-Received: by 2002:a17:906:8a65:: with SMTP id hy5mr29970886ejc.250.1615897442960;
        Tue, 16 Mar 2021 05:24:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygiymhAP2eMHj6Ubnmds4z/SbDItno3AkEo622Y3zkesWILS7TdSu7M90fTn4cbPMcExbUQA==
X-Received: by 2002:a17:906:8a65:: with SMTP id hy5mr29970878ejc.250.1615897442821;
        Tue, 16 Mar 2021 05:24:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q25sm6299288edt.51.2021.03.16.05.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 05:24:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
In-Reply-To: <87lfao8m7s.fsf@vitty.brq.redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-4-vkuznets@redhat.com>
 <YE96DDyEZ3zVgb8p@google.com> <87lfao8m7s.fsf@vitty.brq.redhat.com>
Date:   Tue, 16 Mar 2021 13:24:01 +0100
Message-ID: <87a6r38exq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Sean Christopherson <seanjc@google.com> writes:
>
>> On Mon, Mar 15, 2021, Vitaly Kuznetsov wrote:
>>> Create an infrastructure for tracking Hyper-V TSC page status, i.e. if it
>>> was updated from guest/host side or if we've failed to set it up (because
>>> e.g. guest wrote some garbage to HV_X64_MSR_REFERENCE_TSC) and there's no
>>> need to retry.
>>> 
>>> Also, in a hypothetical situation when we are in 'always catchup' mode for
>>> TSC we can now avoid contending 'hv->hv_lock' on every guest enter by
>>> setting the state to HV_TSC_PAGE_BROKEN after compute_tsc_page_parameters()
>>> returns false.
>>> 
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>> ---
>>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>>> index eefb85b86fe8..2a8d078b16cb 100644
>>> --- a/arch/x86/kvm/hyperv.c
>>> +++ b/arch/x86/kvm/hyperv.c
>>> @@ -1087,7 +1087,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>>>  	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
>>>  	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
>>>  
>>> -	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
>>> +	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN)
>>>  		return;
>>>  
>>>  	mutex_lock(&hv->hv_lock);
>>
>> ...
>>
>>> @@ -1133,6 +1133,12 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>>>  	hv->tsc_ref.tsc_sequence = tsc_seq;
>>>  	kvm_write_guest(kvm, gfn_to_gpa(gfn),
>>>  			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
>>> +
>>> +	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
>>> +	goto out_unlock;
>>> +
>>> +out_err:
>>> +	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
>>>  out_unlock:
>>>  	mutex_unlock(&hv->hv_lock);
>>>  }
>>> @@ -1193,8 +1199,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>>>  	}
>>>  	case HV_X64_MSR_REFERENCE_TSC:
>>>  		hv->hv_tsc_page = data;
>>> -		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
>>> +		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
>>> +			if (!host)
>>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_GUEST_CHANGED;
>>> +			else
>>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
>>
>> Writing the status without taking hv->hv_lock could cause the update to be lost,
>> e.g. if a different vCPU fails kvm_hv_setup_tsc_page() at the same time, its
>> write to set status to HV_TSC_PAGE_BROKEN would race with this write.
>>
>
> Oh, right you are, the lock was somewhere in my brain :-) Will do in
> v2.

Actually no, kvm_hv_set_msr_pw() is only called from
kvm_hv_set_msr_common() with hv->hv_lock held so we're already
synchronized.

... and of course I figured that our by putting another
mutex_lock()/mutex_unlock() here and then wondering why everything hangs
:-)

>
>>>  			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>>> +		}
>>>  		break;
>>>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>>>  		return kvm_hv_msr_set_crash_data(kvm,
>>> -- 
>>> 2.30.2
>>> 
>>

-- 
Vitaly

