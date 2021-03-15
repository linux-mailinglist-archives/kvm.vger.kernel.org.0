Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4133BFFA
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhCOPfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:35:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhCOPeg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 11:34:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615822476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAY8RWv6lusUZHQmEpQMI0BV4LG43ZJCZoyFS8d8UBw=;
        b=TR3pWRCt17Ts/TB7kV5i4Ks3Rgeg25tgwYVOZjFYJr0TMyWgiKNy7RaNQHs8BX/aj2iCO/
        cW2iJte00UgWgrpHVh6keH+Z3KlC1qZmDTuSaoXO+LNcE6QHLwl88MayCxCJBnKeb4N/bP
        eynyiK5Oiw3L1zgKDE90wlXw7VwICHM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-LbImmedkMgyJH88F4xROdg-1; Mon, 15 Mar 2021 11:34:34 -0400
X-MC-Unique: LbImmedkMgyJH88F4xROdg-1
Received: by mail-wr1-f70.google.com with SMTP id e13so15236125wrg.4
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 08:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QAY8RWv6lusUZHQmEpQMI0BV4LG43ZJCZoyFS8d8UBw=;
        b=F0INemaagQdzueNB6pSCZJN/5xMdbisLkeNTOyApOpwF0ljDkwerk23Yjv0aUDgz34
         jxr/8f+Sxo0JRfe6Psk9DRq2OkQJz9drbQuE5z+09oFraOfnlWY+sV8316KGXBAORQc+
         9lD8THEmE6F4B5oylEElxsZ/BEfvSa3gkvxyO3u0LsJdSBlWODq+0Ui2ncbdQPOUFCnB
         EwucDSXXvxsJ9QzAWpI5wYpJqG6AZkw8Tz7vUqvnLWr+wpZiyMCCmxJWWaPYu4RE8+NT
         lK92ZpPdKfZVsLz7UQ1hpzbeZkp5QUWNBMjD/B2qxnap6LNDm0AepqVM5ezrMeYvgJPi
         SQzQ==
X-Gm-Message-State: AOAM531PIrJ8KCE/YF2IN5NB0BWpPlYZ4EMMHn2LDIisXAUl2iQUoiyc
        dm7P/4qaIL8QKwt3DmcZmnv/jKtliuH0+iWMJS+lF7Ic9cVdYKL3lm83j186S/80p9NJcCJJffG
        g1rzgRkgSPnan
X-Received: by 2002:adf:e412:: with SMTP id g18mr240969wrm.159.1615822473064;
        Mon, 15 Mar 2021 08:34:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEI2gEAVCRe6lkMzzHRC/qUpPSO+TnXKE+CHTyPDh0ctgY6INUvGtk2xc8+jY4I1Uy5zWzyQ==
X-Received: by 2002:adf:e412:: with SMTP id g18mr240953wrm.159.1615822472775;
        Mon, 15 Mar 2021 08:34:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v6sm18855386wrx.32.2021.03.15.08.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:34:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: hyper-v: Track Hyper-V TSC page status
In-Reply-To: <YE96DDyEZ3zVgb8p@google.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-4-vkuznets@redhat.com>
 <YE96DDyEZ3zVgb8p@google.com>
Date:   Mon, 15 Mar 2021 16:34:31 +0100
Message-ID: <87lfao8m7s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Mar 15, 2021, Vitaly Kuznetsov wrote:
>> Create an infrastructure for tracking Hyper-V TSC page status, i.e. if it
>> was updated from guest/host side or if we've failed to set it up (because
>> e.g. guest wrote some garbage to HV_X64_MSR_REFERENCE_TSC) and there's no
>> need to retry.
>> 
>> Also, in a hypothetical situation when we are in 'always catchup' mode for
>> TSC we can now avoid contending 'hv->hv_lock' on every guest enter by
>> setting the state to HV_TSC_PAGE_BROKEN after compute_tsc_page_parameters()
>> returns false.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index eefb85b86fe8..2a8d078b16cb 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -1087,7 +1087,7 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>>  	BUILD_BUG_ON(sizeof(tsc_seq) != sizeof(hv->tsc_ref.tsc_sequence));
>>  	BUILD_BUG_ON(offsetof(struct ms_hyperv_tsc_page, tsc_sequence) != 0);
>>  
>> -	if (!(hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE))
>> +	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN)
>>  		return;
>>  
>>  	mutex_lock(&hv->hv_lock);
>
> ...
>
>> @@ -1133,6 +1133,12 @@ void kvm_hv_setup_tsc_page(struct kvm *kvm,
>>  	hv->tsc_ref.tsc_sequence = tsc_seq;
>>  	kvm_write_guest(kvm, gfn_to_gpa(gfn),
>>  			&hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence));
>> +
>> +	hv->hv_tsc_page_status = HV_TSC_PAGE_SET;
>> +	goto out_unlock;
>> +
>> +out_err:
>> +	hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
>>  out_unlock:
>>  	mutex_unlock(&hv->hv_lock);
>>  }
>> @@ -1193,8 +1199,13 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>>  	}
>>  	case HV_X64_MSR_REFERENCE_TSC:
>>  		hv->hv_tsc_page = data;
>> -		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE)
>> +		if (hv->hv_tsc_page & HV_X64_MSR_TSC_REFERENCE_ENABLE) {
>> +			if (!host)
>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_GUEST_CHANGED;
>> +			else
>> +				hv->hv_tsc_page_status = HV_TSC_PAGE_HOST_CHANGED;
>
> Writing the status without taking hv->hv_lock could cause the update to be lost,
> e.g. if a different vCPU fails kvm_hv_setup_tsc_page() at the same time, its
> write to set status to HV_TSC_PAGE_BROKEN would race with this write.
>

Oh, right you are, the lock was somewhere in my brain :-) Will do in v2.

>>  			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>> +		}
>>  		break;
>>  	case HV_X64_MSR_CRASH_P0 ... HV_X64_MSR_CRASH_P4:
>>  		return kvm_hv_msr_set_crash_data(kvm,
>> -- 
>> 2.30.2
>> 
>

-- 
Vitaly

