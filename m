Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8831DC1DED
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 11:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfI3JZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 05:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfI3JZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 05:25:30 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 94D9458
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:25:29 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id 124so7010419wmz.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 02:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=elleWBjapRv/SRNfStbFm2hrsIA22Dw2zFzlMndtvgA=;
        b=THTJNxPtPeh7a9XP8+ZMAKZLnP0q8JqnOn+1d2p7e+1GSDoed4OJi+SOPOk6AKD4oo
         jcoCSJmzZTtK/ScGL0EkbOAGwY0wpkNoa0isJs07jrUcW5BE1xuHBaoeNNIjHpr4ajM6
         mxsMKVKj3Oj95qmHOVeI8DplnUWcdlYNjXBGKPzG/JlkRNBwIHeTV/0Fao0dk6kqj4B/
         BVMrYwNWBcWZ1saaPEsYYh523o1bwOz4LJu86adw9uKeD+vFur819YGFZ9QsxTiHA7kb
         RWqPopYrPrzDwXBpEAQHZBfc9lmJXcHuABZqf9wAw2O3N3e3xzdNETWTDvamyCevO+pn
         JzKw==
X-Gm-Message-State: APjAAAWK7p6dA+7l1cEZYkOYNSL05b0s8mX4eT2buA16EUPjQLZvS2oU
        jEgEuuWHrs4DOQlwMYRdalhUgzX7tl3eOxYlTDn+KjIn0waAOTfUAel4+5h8I6qUs/cKCQMN/ho
        ridaDwUdLXLbT
X-Received: by 2002:adf:c504:: with SMTP id q4mr224235wrf.266.1569835528368;
        Mon, 30 Sep 2019 02:25:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxtTJN3vz/8TiV/fTqGWvZo4gzgxPj5c8e5WEjBPH3N2by94rvs8/eTwNjk8z5NFIB7s/377Q==
X-Received: by 2002:adf:c504:: with SMTP id q4mr224218wrf.266.1569835528170;
        Mon, 30 Sep 2019 02:25:28 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b5sm12134886wmj.18.2019.09.30.02.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:25:27 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: Fold 'enum kvm_ex_reg' definitions into 'enum kvm_reg'
In-Reply-To: <20190927214523.3376-7-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-7-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 11:25:26 +0200
Message-ID: <87ftke3zll.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Now that indexing into arch.regs is either protected by WARN_ON_ONCE or
> done with hardcoded enums, combine all definitions for registers that
> are tracked by regs_avail and regs_dirty into 'enum kvm_reg'.  Having a
> single enum type will simplify additional cleanup related to regs_avail
> and regs_dirty.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 +---
>  arch/x86/kvm/kvm_cache_regs.h   | 2 +-
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 23edf56cf577..a27f7f6b6b7a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -156,10 +156,8 @@ enum kvm_reg {
>  	VCPU_REGS_R15 = __VCPU_REGS_R15,
>  #endif
>  	VCPU_REGS_RIP,
> -	NR_VCPU_REGS
> -};
> +	NR_VCPU_REGS,
>  
> -enum kvm_reg_ex {
>  	VCPU_EXREG_PDPTR = NR_VCPU_REGS,

(Personally, I would've changed that to NR_VCPU_REGS + 1)

>  	VCPU_EXREG_CR3,
>  	VCPU_EXREG_RFLAGS,
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 3972e1b65635..b85fc4b4e04f 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -95,7 +95,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
>  
>  	if (!test_bit(VCPU_EXREG_PDPTR,
>  		      (unsigned long *)&vcpu->arch.regs_avail))
> -		kvm_x86_ops->cache_reg(vcpu, (enum kvm_reg)VCPU_EXREG_PDPTR);
> +		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
>  
>  	return vcpu->arch.walk_mmu->pdptrs[index];
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
