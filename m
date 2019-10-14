Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FFDD5E88
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfJNJSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 05:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbfJNJSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 05:18:43 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE50A73A69
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 09:18:41 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id l12so8216285wrm.6
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 02:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=I4lbvaq6vVdEN7xa2xYOpTCkhvY6ZkuoHSMKJd3XSac=;
        b=KahFVC35gwATITFn0RVMJBGvnFupT5qUjDWFaIArqFJmmgHQlt3RiDDT297yTooLYE
         cAex7kIAreWoqDzTxbvFGg6Vo3tUDtCM0znIH2A9LrDUoyWW1SfQZ5T+qjmO8VE0xYKP
         neYXq+1AbKBRZZwgm4LMmGDGZEfky8qN6bxEiNLx0cDp6K8acQ3xkjOWW1Hui8PBvTq0
         BImaoOdz17DhRZOQz8IthQx1VzrYwhL+XLGhQOLbsLZznImc2tzl98+OBBJJbkGOZxBP
         cAeZUOcVShGwYqWQ8az9uztDpkCRyTEcuY0o1wr0KzEOSrJYlJf7eEpXlfEbUO6+AWYf
         of0g==
X-Gm-Message-State: APjAAAXKjZ0KWYL160oHF8umzkd03kCx4oIz7589BYSN9SUI6zvceh/B
        XPQNnIX7UCBng1s88/tC7bTVXEmVQ+e5cSg02s3EpqASqyqlzWYw1SQjE5t+Cdb5UVR37Z5mdix
        3IKPibqhbd7fU
X-Received: by 2002:a5d:4b09:: with SMTP id v9mr23805269wrq.127.1571044720418;
        Mon, 14 Oct 2019 02:18:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwar4f7SJRAHyQ+5Z2fHgpCWGXj/TXfvOHxHfn21TXUp6RnIgTR2a5itwE7yCxFrOcXsEFiVg==
X-Received: by 2002:a5d:4b09:: with SMTP id v9mr23805240wrq.127.1571044720157;
        Mon, 14 Oct 2019 02:18:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z125sm20070555wme.37.2019.10.14.02.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 02:18:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 3/5] x86/kvm: Add "nopvspin" parameter to disable PV spinlocks
In-Reply-To: <4e1ef1d3-527b-bb70-5536-d9daeb50b7c7@oracle.com>
References: <1570439071-9814-1-git-send-email-zhenzhong.duan@oracle.com> <1570439071-9814-4-git-send-email-zhenzhong.duan@oracle.com> <87o8yl587f.fsf@vitty.brq.redhat.com> <4e1ef1d3-527b-bb70-5536-d9daeb50b7c7@oracle.com>
Date:   Mon, 14 Oct 2019 11:18:38 +0200
Message-ID: <878spn65xt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zhenzhong Duan <zhenzhong.duan@oracle.com> writes:

> On 2019/10/13 17:02, Vitaly Kuznetsov wrote:
>> Zhenzhong Duan <zhenzhong.duan@oracle.com> writes:
> ...snip
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index ef836d6..6e14bd4 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -825,18 +825,31 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>>    */
>>   void __init kvm_spinlock_init(void)
>>   {
>> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>> +	/*
>> +	 * Disable PV qspinlocks if host kernel doesn't support
>> +	 * KVM_FEATURE_PV_UNHALT feature or there is only 1 vCPU.
>> +	 * virt_spin_lock_key is enabled to avoid lock holder
>> +	 * preemption issue.
>> +	 */
>> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
>> +	    num_possible_cpus() == 1) {
>> +		pr_info("PV spinlocks disabled\n");
>> Why don't we need static_branch_disable(&virt_spin_lock_key) here?
>
> Thanks for review.
>
> I have a brief explanation in above comment area.
>
> Boris also raised the same question in v4 and see my detailed explanation
>
> in https://lkml.org/lkml/2019/10/6/39
>
>>
>> Also, as you're printing the exact reason for PV spinlocks disablement
>> in other cases, I'd suggest separating "no host support" and "single
>> CPU" cases.
>
> Will do after reaching a consensus on your first question.

Oh, sorry I missed v4 discussion. As I'm not the first to ask why we
don't do static_branch_disable(&virt_spin_lock_key) here I suggest we do
the followin:

- Split !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) and
  num_possible_cpus() == 1 cases
- Do static_branch_disable(&virt_spin_lock_key) for UP case (just for
  consistency).
- Add a comment why we don't do that for
  !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) case (basically, what you
  replied to Boris)

This will also allow us to print the exact reason.

>
>>
>>>   		return;
>>> +	}
>>>   
>>>   	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
>>>   		static_branch_disable(&virt_spin_lock_key);
>>>   		return;
>>>   	}
>>>   
>>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>>> -	if (num_possible_cpus() == 1)
>>> +	if (nopvspin) {
>>> +		pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");
>> Nit: to make it sound better a comma is missing between 'disabled' and
>> 'forced', or
>>
>> "PV spinlocks forcefully disabled by ..." if you prefer.
>
> Will do.
>
> Zhenzhong
>
>

-- 
Vitaly
