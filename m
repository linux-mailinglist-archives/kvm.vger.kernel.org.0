Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4185127F2C3
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 21:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgI3T4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 15:56:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3T4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 15:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601495789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiRKs0Clr8v5oRzEIlgXjnei64gU5IYQ5ROkgBIjBFs=;
        b=I+EsgtcAGLJTI6wYEv3zdE/h841NLE4ch206S9skIJOe/jzNB2m25Ze3gjETcHl+JpqT0I
        oGn0pMhoQbltLycO2tjDx/OuGSu+sPQBGZbQyboHTXtp2520STJ7lflfiYxK3X4mKwxWr4
        UZE6RpoEEuyeOkd5hyhq6WgZlmQfWDY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-HRnwoIO9N5uXX47VoV41eg-1; Wed, 30 Sep 2020 15:56:26 -0400
X-MC-Unique: HRnwoIO9N5uXX47VoV41eg-1
Received: by mail-wm1-f69.google.com with SMTP id a25so219574wmb.2
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 12:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KiRKs0Clr8v5oRzEIlgXjnei64gU5IYQ5ROkgBIjBFs=;
        b=TbkfgsLSjXwKLRChLMRcCwDfNzqueNbGQFu+TOtvwCadLdv+MBvoqaXKazoWDbdda0
         IfrzfOGzQ8B6Hi8CEZVykNSL15JoaRntkje7Etpm5pdsU42uXM6OfrhUGj755EB+xWd1
         M3omIE8c9kALuMQ1ma+OKYr9KDSaZV5zjYUjQp6UbdNi9mQrd/wzvuaSd5eqfeZ5pfyE
         0rwdJ/jaSoKHUP4fHHwwSqxEyomQKZcHZpkpxf1o5zYW6no80mLu5A7Kn9B+YkoS7t30
         IzggC1zyCiXW+ISvv7/6Hlt+S1srh9n+nVHYdGDcc/ra6ZlsmL1vur8WqgBtephg3Xs+
         r/VA==
X-Gm-Message-State: AOAM53268Th6aNhSz5ciOd+7MVoJm3jqHWNRVJ/CDwPhb0ohIO78n39s
        EKV8rnarzntV15awRKFHvnepuib17E+bWNCcFYqD0ZEA60HMD3TjK6h0eqAiZerxKNWoYVyY+DJ
        ETwD6fG1Ptgnh
X-Received: by 2002:a5d:404b:: with SMTP id w11mr4836132wrp.24.1601495785204;
        Wed, 30 Sep 2020 12:56:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoeY9gCFdd6lmLP9yCSQgOBUPvIz8LqZ9OAeqzkdWz0g0yG5JRiD107C4tSpbsKVyfxZ/ArA==
X-Received: by 2002:a5d:404b:: with SMTP id w11mr4836106wrp.24.1601495784933;
        Wed, 30 Sep 2020 12:56:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id d6sm5017986wrq.67.2020.09.30.12.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 12:56:24 -0700 (PDT)
Subject: Re: [PATCH 20/22] kvm: mmu: NX largepage recovery for TDP MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-21-bgardon@google.com>
 <20200930181556.GJ32672@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d2bcf512-00f3-8499-420d-b31690bdb511@redhat.com>
Date:   Wed, 30 Sep 2020 21:56:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930181556.GJ32672@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 20:15, Sean Christopherson wrote:
> On Fri, Sep 25, 2020 at 02:23:00PM -0700, Ben Gardon wrote:
>> +/*
>> + * Clear non-leaf SPTEs and free the page tables they point to, if those SPTEs
>> + * exist in order to allow execute access on a region that would otherwise be
>> + * mapped as a large page.
>> + */
>> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm)
>> +{
>> +	struct kvm_mmu_page *sp;
>> +	bool flush;
>> +	int rcu_idx;
>> +	unsigned int ratio;
>> +	ulong to_zap;
>> +	u64 old_spte;
>> +
>> +	rcu_idx = srcu_read_lock(&kvm->srcu);
>> +	spin_lock(&kvm->mmu_lock);
>> +
>> +	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
>> +	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
> 
> This is broken, and possibly related to Paolo's INIT_LIST_HEAD issue.  The TDP
> MMU never increments nx_lpage_splits, it instead has its own counter,
> tdp_mmu_lpage_disallowed_page_count.  Unless I'm missing something, to_zap is
> guaranteed to be zero and thus this is completely untested.

Except if you do shadow paging (through nested EPT) and then it bombs
immediately. :)

> I don't see any reason for a separate tdp_mmu_lpage_disallowed_page_count,
> a single VM can't have both a legacy MMU and a TDP MMU, so it's not like there
> will be collisions with other code incrementing nx_lpage_splits.   And the TDP
> MMU should be updating stats anyways.

This is true, but having two counters is necessary (in the current
implementation) because otherwise you zap more than the requested ratio
of pages.

The simplest solution is to add a "bool tdp_page" to struct
kvm_mmu_page, so that you can have a single list of
lpage_disallowed_pages and a single thread.  The while loop can then
dispatch to the right "zapper" code.

Anyway this patch is completely broken, so let's kick it away to the
next round.

Paolo

>> +
>> +	while (to_zap &&
>> +	       !list_empty(&kvm->arch.tdp_mmu_lpage_disallowed_pages)) {
>> +		/*
>> +		 * We use a separate list instead of just using active_mmu_pages
>> +		 * because the number of lpage_disallowed pages is expected to
>> +		 * be relatively small compared to the total.
>> +		 */
>> +		sp = list_first_entry(&kvm->arch.tdp_mmu_lpage_disallowed_pages,
>> +				      struct kvm_mmu_page,
>> +				      lpage_disallowed_link);
>> +
>> +		old_spte = *sp->parent_sptep;
>> +		*sp->parent_sptep = 0;
>> +
>> +		list_del(&sp->lpage_disallowed_link);
>> +		kvm->arch.tdp_mmu_lpage_disallowed_page_count--;
>> +
>> +		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sp->gfn,
>> +				    old_spte, 0, sp->role.level + 1);
>> +
>> +		flush = true;
>> +
>> +		if (!--to_zap || need_resched() ||
>> +		    spin_needbreak(&kvm->mmu_lock)) {
>> +			flush = false;
>> +			kvm_flush_remote_tlbs(kvm);
>> +			if (to_zap)
>> +				cond_resched_lock(&kvm->mmu_lock);
>> +		}
>> +	}
>> +
>> +	if (flush)
>> +		kvm_flush_remote_tlbs(kvm);
>> +
>> +	spin_unlock(&kvm->mmu_lock);
>> +	srcu_read_unlock(&kvm->srcu, rcu_idx);
>> +}
>> +
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
>> index 2ecb047211a6d..45ea2d44545db 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.h
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
>> @@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
>>  
>>  bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>>  				   struct kvm_memory_slot *slot, gfn_t gfn);
>> +
>> +void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm);
>>  #endif /* __KVM_X86_MMU_TDP_MMU_H */
>> -- 
>> 2.28.0.709.gb0816b6eb0-goog
>>
> 

