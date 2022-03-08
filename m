Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE44D1F2E
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbiCHRhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiCHRhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:37:31 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AD754FA8
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:36:34 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id fs4-20020a17090af28400b001bf5624c0aaso30143pjb.0
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ilNtvLV0LkLBCJ4u2ZvgTuBzfH8DdAUiWYvR9CsaB0=;
        b=lPZ0Fq+AmHR0fTK4mu8Q11Kovw3c6jHNs6F6X4OH54L/w7QkcggF77SqUOPGLAcGH3
         +UgdQqp+wa78LSbS/fNS9vf9RvjsMN6DyRyOAun0UMHec+eTuEfbvBjYniF9yBGyBSFY
         c/ASL9DGT7p5ZJu3RQZ7nxdN9CsBz4fa1I52dqIRZGbnytCrNCrJjIcOcaeoa18Jx2NZ
         HGTS+kQdevKIA4td7Wcjp0nhwG64obnBLLUSjhyOHyYVX92TFuhU2QfsyIRQnsL8gnjb
         nkUZlfB+DlpTIqjXwU3PjvAIR03uxb7KOKqq4J7nJsfH4B2WcVKlRlqbLvWiZGqzBtDK
         uB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ilNtvLV0LkLBCJ4u2ZvgTuBzfH8DdAUiWYvR9CsaB0=;
        b=RYYWZeeGFhHj3OaBBaPlQU1ixK4rkk4q0KU61l//rPKmAnZfQJ+r6OK6FPu6ECsaMY
         GQmp5AoBj9i2kE+/uPeWRSQwbjandrfBEYNaH3vGPqV5EBBePHmUiowzP5BhPDehxl3k
         gM5SBvEx5piUUR0LOaLZ/ICleA4xF6uzi6YeEw7dsdP2mz5VOnAjP5NUll+crMFLCuyQ
         reB3B3CjHoMkdtXZk2Y2E4b0L4yE9hHlHDXCtxcw13nrAT2FLVg41W8tvZpccS98Ri2Z
         biftYFgR8ymAmr66XpIf4GFu8gJsd2FVdr+a5e/q2cx5hFFsaVyHuDhR10AoWoAA6e7T
         HuHA==
X-Gm-Message-State: AOAM532yG5srsaFCjdDfkwzhwWcOmK5wsESAHDbALox8RDYO5d4hojZY
        5b1/yE2ltp4RSLjlhVopmvfy9Q==
X-Google-Smtp-Source: ABdhPJxKUjH6zqhOjdi9bTErD28lYIvnwk+e2mH2PTxOoSNMCM/QK9pdthKb9G+DZMtS/mXlDN5CGA==
X-Received: by 2002:a17:90b:4c8f:b0:1bc:a64b:805 with SMTP id my15-20020a17090b4c8f00b001bca64b0805mr5861663pjb.156.1646760993687;
        Tue, 08 Mar 2022 09:36:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b004f140515d56sm20407660pfh.46.2022.03.08.09.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:36:33 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:36:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Message-ID: <YieUHVgFxOo3LAa8@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-9-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> Snapshot the state of the processor registers that govern page walk into
> a new field of struct kvm_mmu.  This is a more natural representation
> than having it *mostly* in mmu_role but not exclusively; the delta
> right now is represented in other fields, such as root_level.
> 
> The nested MMU now has only the CPU mode; and in fact the new function
> kvm_calc_cpu_mode is analogous to the previous kvm_calc_nested_mmu_role,
> except that it has role.base.direct equal to CR0.PG.  It is not clear
> what the code meant by "setting role.base.direct to true to detect bogus
> usage of the nested MMU".

The idea was to trigger fireworks due to a incoherent state (e.g. direct mmu_role with
non-direct hooks) if the nested_mmu was ever used as a "real" MMU (handling faults,
installing SPs/SPTEs, etc...).  For a walk-only MMU, "direct" has no meaning and so
rather than arbitrarily leave it '0', I arbitrarily set it '1'.

Maybe this?

  The nested MMU now has only the CPU mode; and in fact the new function
  kvm_calc_cpu_mode is analogous to the previous kvm_calc_nested_mmu_role,
  except that it has role.base.direct equal to CR0.PG.  Having "direct"
  track CR0.PG has the serendipitious side effect of being an even better
  sentinel than arbitrarily setting direct to true for the nested MMU, as
  KVM will run afoul of sanity checks for both direct and indirect MMUs if
  KVM attempts to use the nested MMU as a "real" MMU, e.g. for page faults.
 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/mmu/mmu.c          | 107 ++++++++++++++++++++------------
>  arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
>  3 files changed, 68 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 92855d3984a7..cc268116eb3f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -433,6 +433,7 @@ struct kvm_mmu {
>  			 struct kvm_mmu_page *sp);
>  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
>  	struct kvm_mmu_root_info root;
> +	union kvm_mmu_role cpu_mode;
>  	union kvm_mmu_role mmu_role;
>  	u8 root_level;
>  	u8 shadow_root_level;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7c835253a330..1af898f0cf87 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -221,7 +221,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
>  #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
>  static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
>  {								\
> -	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
> +	return !!(mmu->cpu_mode. base_or_ext . reg##_##name);	\
>  }
>  BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
>  BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
> @@ -4680,6 +4680,39 @@ static void paging32_init_context(struct kvm_mmu *context)
>  	context->direct_map = false;
>  }
>  
> +static union kvm_mmu_role
> +kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)

I strongly prefer we avoid putting the return type on a different line unless
absolutely "necessary".

static union kvm_mmu_role kvm_calc_cpu_mode(struct kvm_vcpu *vcpu,
					    const struct kvm_mmu_role_regs *regs)

> +{
> +	union kvm_mmu_role role = {0};
> +
> +	role.base.access = ACC_ALL;
> +	role.base.smm = is_smm(vcpu);
> +	role.base.guest_mode = is_guest_mode(vcpu);
> +	role.base.direct = !____is_cr0_pg(regs);
> +	if (!role.base.direct) {

Can we check ____is_cr0_pg() instead of "direct"?  IMO that's more intuitive for
understanding why the bits below are left zero.  I was scratching my head trying
to figure out whether or not this was safe/correct for direct MMUs...

And this indentation is quite nasty, and will only get worse.  An early return or
a goto would solve that nicely.  I think I have a slight preference for an early
return?

	role.ext.valid = 1;
	
	if (!____is_cr0_pg(regs))
		return role;

	role.base.efer_nx = ____is_efer_nx(regs);
	role.base.cr0_wp = ____is_cr0_wp(regs);
	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
	role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
	role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
	role.base.level = role_regs_to_root_level(regs);

	role.ext.cr0_pg = 1;
	role.ext.cr4_pae = ____is_cr4_pae(regs);
	role.ext.cr4_smep = ____is_cr4_smep(regs);
	role.ext.cr4_smap = ____is_cr4_smap(regs);
	role.ext.cr4_pse = ____is_cr4_pse(regs);

	/* PKEY and LA57 are active iff long mode is active. */
	role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
	role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
	role.ext.efer_lma = ____is_efer_lma(regs);

	return role;
