Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060BB27E10A
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgI3G0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725554AbgI3G0g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 02:26:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601447194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3WeK/ai1FaE8kljJN83SJh1WLATx3v+i63KVrGQh/Os=;
        b=CW3WCiAJKJSvRZvtKYs5b2s/TEPXWZbz67w/Rku9hEFPbYa/Siv0NiLTGW29HKXJkzFMPr
        k6s26cFDOioVtZNKPq27FaL7+Q2C+F10vHCRaI+QhbkhYZwdsthH3qvurrj1Uf1BvwWlyP
        Z1r5c2HRl94dS9YSNi00bJrbZj3wYGs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-FNGm9N0bP4mBZJhAx_YmdQ-1; Wed, 30 Sep 2020 02:26:31 -0400
X-MC-Unique: FNGm9N0bP4mBZJhAx_YmdQ-1
Received: by mail-wm1-f70.google.com with SMTP id x6so226133wmi.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 23:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3WeK/ai1FaE8kljJN83SJh1WLATx3v+i63KVrGQh/Os=;
        b=fMW3HbOfGEGbnLnk4+SVGMznLP1ZISkh5uz7pcCPTmE3Qh0z86FO4k9mHqTYAQ6Cjh
         /OiVD5fgEYQwQ2h71UkAQfAZrvmU6CPgDs110QLNGenuhisj0DAjMd3F/VECTNiH4xOo
         KAF/TeKeoapwBUZ+YiDRLZpk5KNmcXaLTr8riYoER884DzWyxm7flOOND+XfHEAmnRPN
         uijGmij0uHWTqOPWlN5GjC3TTZcRE0iGcwuUnwFFtaBZII6vgFHPsTt6rm6CTpsAjcy6
         IyX5CIYP9DwazoLFHJZ3xHDY6XiFRrTE6aHurKziLRrJgSZAW6HluN/A0DTeLI33Bz7K
         1uMA==
X-Gm-Message-State: AOAM533JBMtHkeU6PGxQPqPeKvwuO9K6nHiXVMNNV8lxqcUqs/MI+G4M
        3A/eAEG//VJMJTjqozdGsr9/MSkxL5Wm/xvjBMYTt00Lz8JOf41awodWkX0dIYcEy2C3uvDHmgG
        RqjmJsPd6My7g
X-Received: by 2002:a1c:9885:: with SMTP id a127mr1162560wme.8.1601447189774;
        Tue, 29 Sep 2020 23:26:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvqjiUpMIJOhKv2tvSdAmxKGq42O+mBn//u3munwVFfgyW0xatKeVN7IEGsjIATANn7hHwOQ==
X-Received: by 2002:a1c:9885:: with SMTP id a127mr1162537wme.8.1601447189543;
        Tue, 29 Sep 2020 23:26:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id y18sm728527wmc.24.2020.09.29.23.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 23:26:28 -0700 (PDT)
Subject: Re: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
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
 <20200925212302.3979661-5-bgardon@google.com>
 <20200930060610.GA29659@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6a5b78f8-0fbe-fbec-8313-f7759e2483b0@redhat.com>
Date:   Wed, 30 Sep 2020 08:26:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930060610.GA29659@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 08:06, Sean Christopherson wrote:
>> +static struct kvm_mmu_page *alloc_tdp_mmu_root(struct kvm_vcpu *vcpu,
>> +					       union kvm_mmu_page_role role)
>> +{
>> +	struct kvm_mmu_page *new_root;
>> +	struct kvm_mmu_page *root;
>> +
>> +	new_root = kvm_mmu_memory_cache_alloc(
>> +			&vcpu->arch.mmu_page_header_cache);
>> +	new_root->spt = kvm_mmu_memory_cache_alloc(
>> +			&vcpu->arch.mmu_shadow_page_cache);
>> +	set_page_private(virt_to_page(new_root->spt), (unsigned long)new_root);
>> +
>> +	new_root->role.word = role.word;
>> +	new_root->root_count = 1;
>> +	new_root->gfn = 0;
>> +	new_root->tdp_mmu_page = true;
>> +
>> +	spin_lock(&vcpu->kvm->mmu_lock);
>> +
>> +	/* Check that no matching root exists before adding this one. */
>> +	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
>> +	if (root) {
>> +		get_tdp_mmu_root(vcpu->kvm, root);
>> +		spin_unlock(&vcpu->kvm->mmu_lock);
> Hrm, I'm not a big fan of dropping locks in the middle of functions, but the
> alternatives aren't great.  :-/  Best I can come up with is
> 
> 	if (root)
> 		get_tdp_mmu_root()
> 	else
> 		list_add();
> 
> 	spin_unlock();
> 
> 	if (root) {
> 		free_page()
> 		kmem_cache_free()
> 	} else {
> 		root = new_root;
> 	}
> 
> 	return root;
> 
> Not sure that's any better.
> 
>> +		free_page((unsigned long)new_root->spt);
>> +		kmem_cache_free(mmu_page_header_cache, new_root);
>> +		return root;
>> +	}
>> +
>> +	list_add(&new_root->link, &vcpu->kvm->arch.tdp_mmu_roots);
>> +	spin_unlock(&vcpu->kvm->mmu_lock);
>> +
>> +	return new_root;
>> +}
>> +
>> +static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_mmu_page *root;
>> +	union kvm_mmu_page_role role;
>> +
>> +	role = vcpu->arch.mmu->mmu_role.base;
>> +	role.level = vcpu->arch.mmu->shadow_root_level;
>> +	role.direct = true;
>> +	role.gpte_is_8_bytes = true;
>> +	role.access = ACC_ALL;
>> +
>> +	spin_lock(&vcpu->kvm->mmu_lock);
>> +
>> +	/* Search for an already allocated root with the same role. */
>> +	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
>> +	if (root) {
>> +		get_tdp_mmu_root(vcpu->kvm, root);
>> +		spin_unlock(&vcpu->kvm->mmu_lock);
> Rather than manually unlock and return, this can be
> 
> 	if (root)
> 		get_tdp_mmju_root();
> 
> 	spin_unlock()
> 
> 	if (!root)
> 		root = alloc_tdp_mmu_root();
> 
> 	return root;
> 
> You could also add a helper to do the "get" along with the "find".  Not sure
> if that's worth the code.

All in all I don't think it's any clearer than Ben's code.  At least in
his case the "if"s clearly point at the double-checked locking pattern.

Paolo

