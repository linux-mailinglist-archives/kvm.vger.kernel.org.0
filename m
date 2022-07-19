Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF257A0D9
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiGSOL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238777AbiGSOLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:11:36 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD7A804B4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:32:24 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r14so21657218wrg.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FrozUrwgIOtPZPU7Vt+EwKFtk6342ujDLZysxCGk/2U=;
        b=S5+hpwih6SZVqj/aZj22GkTtB6kZfbDkhiG9Hf++s/M60OXgNZ/J9S/iUKontqxajh
         OzXnE52J9XzWdiwGbTqN1ITAQKNwzA4v3az0hShMM6Va2ngQvc5JMkF4xEx34Jek+4hX
         xqIY6w51YepwMJdLLJUAeAc+jbuEZPdqniB9QcMW0l12HW6bgo5C0nE5rvUq5oSo93eZ
         MgfZljgodBz8jCjeI/ve6kl4ger6fvg1/P9WWN/hiiTxkThSTx5Uc9CpWqBpwNbmYBkb
         YMB6utRhH5yLR2qAIvbA/yi19l14EDbTsMIcnboJI/3gyW6RtBzaRL/gtAshqmzTkcXa
         2b3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FrozUrwgIOtPZPU7Vt+EwKFtk6342ujDLZysxCGk/2U=;
        b=TN/R5tuaXO1dFmvVceYL59N+znPki66XOS6gVBFVezPMNMbDqi1nzOA4KM9N7Jjwm6
         UzSUXXc59gbDUPpW2RU0DVn8nV2ef2LVexTECYAvjZFTh194ZoXngvuU/SfCR3AdSsmh
         eWGd2BweDCNjeppg0hBCnLWq9iNxl5OWbRsNXs55VuEIzfWamzIhnyuZBJgt3aRtKYfU
         iJ/5k1qf6K2EW/ei5QlAVfeFYKqvJkkkEHPK3L2h3cx8YngAGo2K2oVFvEoO6gLiSEjP
         UIcgErZPLEiBEpJNTZawZcOcjoPY0N0DwUwGMrA6YrjIPIkI0CEOSLVkL5/IpsLLOX8U
         FAsg==
X-Gm-Message-State: AJIora94lm4VItA/0Q0a2wJjAwdFhshJv0doVnIxgr6J1bVI0fPvbbLi
        YJuSMoC4okbd3N98wke5vBi39Q==
X-Google-Smtp-Source: AGRyM1tBOCHh1mly6SNagRp9Dh5EU1Ka18SIzDcfqYtAbUecvNXPxURgsOuO1nVIX4WV8COO/Prb7A==
X-Received: by 2002:a05:6000:1081:b0:21d:6b27:b12d with SMTP id y1-20020a056000108100b0021d6b27b12dmr25759245wrw.504.1658237543035;
        Tue, 19 Jul 2022 06:32:23 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id i4-20020a05600c354400b003a2c7bf0497sm17206016wmq.16.2022.07.19.06.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:32:22 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:32:18 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 18/24] KVM: arm64: Instantiate guest stage-2
 page-tables at EL2
Message-ID: <YtayYuo2qBplXcdi@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-19-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-19-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[...]

>  }
>  
>  void reclaim_guest_pages(struct kvm_shadow_vm *vm)
>  {
> -	unsigned long nr_pages;
> +	unsigned long nr_pages, pfn;
>  
>  	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
> -	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
> +	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
> +
> +	guest_lock_component(vm);
> +	kvm_pgtable_stage2_destroy(&vm->pgt);
> +	vm->kvm.arch.mmu.pgd_phys = 0ULL;
> +	guest_unlock_component(vm);
> +
> +	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
>  }

The pfn introduction being removed in a subsequent patch, this is probably
unecessary noise.
