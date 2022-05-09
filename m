Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61083520207
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbiEIQOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbiEIQOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:14:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CE2C3EBA
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:10:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j14so14303968plx.3
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cu/jiZxH6OGpEZOL+PQieADiAgi9jfOz/B++XfNJktg=;
        b=mhnslXdEZD4iLSuPRVVDxjSn6+FvXzI4Bcai5sRw8fKKc3MLOz0UYsczXlk1PHsKbC
         THfEA22X/nb+xS6QBIvswdYFZeqHqn+dEjYGdEmxr7d4It/gdFXtvmWw8IZatYmd9ueh
         XnrwFPDDqz0UzPc8YVMEq1gDwmmx9mQyJC4o6U45EhhxSrPodB/cz0hPWmwd4Ltd+Zma
         9hkQZ+42gt2tPedeVqnrBRXKhHSDcGbPfs4XEdFvlZsKUhBKr6Dqb1dOGMlryalSjaQA
         +PJmeJyD7rJpRm6so4lClPmND19dMoeaqEnPBys3Jd2/NsX29i9JNwJPQiF4BGOsu8Tq
         3JjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cu/jiZxH6OGpEZOL+PQieADiAgi9jfOz/B++XfNJktg=;
        b=jzAePQMzUt7D9oA8nH4a+vrWJfhGF0ays7dgzOEtb4w8z8M6P0O10C+s1Y2Eatcc2l
         vvCzjASD80fhAXjECN3znj1njAK/j4CNxfpa0fuRmpYwKEZpMxVu3s88nHwAsWgCic3y
         Qq5edHZrY82u2rzNjWZViBL6x8MXIRn8gbG7hNIKWje5yGFIet0nAWfV5hPw2gbfxFwr
         1+jycaAuT5yXBw9dNszVW23dei/y7pttfQcqZwKmPzVc9tf+EwxTCyNZzziZOcUv25hs
         V1eDvLqRZ6lChToYQEP3UZIBqDXnpQJJCWczVGai8Syn/EzQ2Sb8Yjjb8VsdbcxTp/dR
         NxTw==
X-Gm-Message-State: AOAM533X/r8hLWzKYYGQt8+IJog2Hw9Fuefgdfor2tZkaT36sAOXpSj0
        LFaITfDP+nMTYcb3k9r/CyxMvw==
X-Google-Smtp-Source: ABdhPJw25Pjuh0E3wte+D0++UVsLqfNoyFyxpKkkTJFLfZkGy695uMwCI3FkNxQhcC97eHo59R4/Og==
X-Received: by 2002:a17:90b:4c88:b0:1dc:60c2:25b2 with SMTP id my8-20020a17090b4c8800b001dc60c225b2mr27045719pjb.133.1652112615226;
        Mon, 09 May 2022 09:10:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b29-20020aa7951d000000b0050dc762819asm8852722pfp.116.2022.05.09.09.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:10:14 -0700 (PDT)
Date:   Mon, 9 May 2022 16:10:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 15/20] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <Ynk84xydEn4/3xkT@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-16-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022, David Matlack wrote:
> @@ -2820,7 +2861,10 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  
>  	if (!was_rmapped) {
>  		WARN_ON_ONCE(ret == RET_PF_SPURIOUS);
> -		rmap_add(vcpu, slot, sptep, gfn);
> +		rmap_add(vcpu, slot, sptep, gfn, pte_access);
> +	} else {
> +		/* Already rmapped but the pte_access bits may have changed. */
> +		kvm_mmu_page_set_access(sp, sptep - sp->spt, pte_access);
>  	}
>  
>  	return ret;

...

> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index a8a755e1561d..97bf53b29b88 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -978,7 +978,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  }
>  
>  /*
> - * Using the cached information from sp->gfns is safe because:
> + * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()
> + * and kvm_mmu_page_get_access()) is safe because:
>   * - The spte has a reference to the struct page, so the pfn for a given gfn
>   *   can't change unless all sptes pointing to it are nuked first.
>   *
> @@ -1052,12 +1053,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
>  			continue;
>  
> -		if (gfn != sp->gfns[i]) {
> +		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {
>  			drop_spte(vcpu->kvm, &sp->spt[i]);
>  			flush = true;
>  			continue;
>  		}
>  
> +		if (pte_access != kvm_mmu_page_get_access(sp, i))

I think it makes sense to do this unconditionally, same as mmu_set_spte().  Or
make the mmu_set_spte() case conditional.  I don't have a strong preference either
way, but the two callers should be consistent with each other.

> +			kvm_mmu_page_set_access(sp, i, pte_access);
> +
>  		sptep = &sp->spt[i];
>  		spte = *sptep;
>  		host_writable = spte & shadow_host_writable_mask;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
