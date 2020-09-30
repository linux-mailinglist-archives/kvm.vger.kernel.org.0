Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4327E111
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgI3G2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:28:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI3G2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 02:28:33 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601447312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BwOGlT03+O2Qxwll2h+vS4+zjJZTv/yunKOwB1Myxg=;
        b=Up6iKoB8XzlDs1XuAnAgYJcm13JND16hB9AjR0ZshKBzyQue85SdXg1zkrmTTCL45Czejh
        ah/NSDeEGqiTpTv640hu4/bncCww7O2A4lm1ENptaeSsr7vn7Q769LP3zBRmczPKfQnZcB
        QTzQA1edJunieCje9CtoJNiMxT0syEY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-9z7kMyYPNv29-OIt5hPPwg-1; Wed, 30 Sep 2020 02:28:30 -0400
X-MC-Unique: 9z7kMyYPNv29-OIt5hPPwg-1
Received: by mail-wr1-f72.google.com with SMTP id f18so210091wrv.19
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 23:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BwOGlT03+O2Qxwll2h+vS4+zjJZTv/yunKOwB1Myxg=;
        b=e3m0S5nmCSMJnbjCl4Z0cUps7QHoZ1w/anDCgLgxTnZdgQUO7dU9JGjUrSpgwDZv/1
         l0UVdRYp29gbsHKvolEuY5Hq7uLDl55bggPG7jQbhEEU885nowlaRTgb16M4/haZBfD8
         14gsG8HOzYs11rMNktSU6FrjsoB4WRWANBbCYbtNmhpleJA8rqLqq8QT0FgsX+qDVZjh
         PPipWuA5YoME+hmNRooQ3X5/0jZ1uLSd7zBy+2aTjqLuTZruknoOyQxB6EhOhrzDofQg
         tGjX7pauXqcwkB/P9pDvk3tIgnF1l2UlQpxDHrnprX2IESz5fta4C9mTTLFvBPrbRAPB
         0iwQ==
X-Gm-Message-State: AOAM531S8/3kQNrmW1hlSK7rK2lzESpl4clmwbAL5imPx/kSGvbzV2SS
        EOXlK8cpgTqeveg5LM7hXNsoO7oprspjY9SxQ689jWaTRR8EVcWaJsXGgi1+3gX/Es9MILKkZDn
        aCnAMG2X11bxB
X-Received: by 2002:adf:a4cc:: with SMTP id h12mr1216872wrb.123.1601447308821;
        Tue, 29 Sep 2020 23:28:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxVRJxA5m+5/To7h+eAmeCUoez+96/AozIpkb01wEXPjw2ON1nW5nd6ZJBCmTeix6Z9rTReA==
X-Received: by 2002:adf:a4cc:: with SMTP id h12mr1216853wrb.123.1601447308585;
        Tue, 29 Sep 2020 23:28:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id d18sm1146388wrm.10.2020.09.29.23.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 23:28:27 -0700 (PDT)
Subject: Re: [PATCH 07/22] kvm: mmu: Support zapping SPTEs in the TDP MMU
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
 <20200925212302.3979661-8-bgardon@google.com>
 <20200930061533.GC29659@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40a793f9-c58f-7b0e-5835-d83eed9f6ba0@redhat.com>
Date:   Wed, 30 Sep 2020 08:28:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930061533.GC29659@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 08:15, Sean Christopherson wrote:
>>  	kvm_zap_obsolete_pages(kvm);
>> +
>> +	if (kvm->arch.tdp_mmu_enabled)
>> +		kvm_tdp_mmu_zap_all(kvm);
> 
> Haven't looked into how this works; is kvm_tdp_mmu_zap_all() additive to
> what is done by the legacy zapping, or is it a replacement?

It's additive because the shadow MMU is still used for nesting.

>> +
>>  	spin_unlock(&kvm->mmu_lock);
>>  }
>> @@ -57,8 +58,13 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
>>  	return root->tdp_mmu_page;
>>  }
>>  
>> +static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
>> +			  gfn_t start, gfn_t end);
>> +
>>  static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
>>  {
>> +	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
> 
> BIT_ULL(...)

Not sure about that.  Here the point is not to have a single bit, but to
do a power of two.  Same for the version below.

>> + * If the MMU lock is contended or this thread needs to yield, flushes
>> + * the TLBs, releases, the MMU lock, yields, reacquires the MMU lock,
>> + * restarts the tdp_iter's walk from the root, and returns true.
>> + * If no yield is needed, returns false.
>> + */
>> +static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
>> +{
>> +	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
>> +		kvm_flush_remote_tlbs(kvm);
>> +		cond_resched_lock(&kvm->mmu_lock);
>> +		tdp_iter_refresh_walk(iter);
>> +		return true;
>> +	} else {
>> +		return false;
>> +	}
> 
> Kernel style is to not bother with an "else" if the "if" returns.

I have rewritten all of this in my version anyway. :)

Paolo

