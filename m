Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760654ACBF0
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbiBGWRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 17:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244082AbiBGWRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 17:17:23 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B915C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 14:17:22 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id i17so15422709pfq.13
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 14:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BhxzVjZr2SNzqHU8dl3WZkOg+9n73v4zh51iEiFYkNg=;
        b=jx4XAzAUQTqRAztXU98sKZ6bOQXbAIjv4M+D3fDMo4P6/vN0Uag8uadVd5UIRITSeh
         SRTu4nFI5Yv07DbbXV7RUSj6bsPNRQHWcVdnkkXb5VQ6AkMO5t9uq03nA8iKzIyl5wSd
         W36GUSH5eXvPWu3HwO4lob7qsG6nNRF/1NE22gj3Q3n3gThgVFIt1Ti81f9TvZWiq+Nh
         IhD6WCOWwMIp8kLcIoAXhOHts6QqnIgLuZkFygsKNqmpRumaq90YO7A2pbMs87+AF0d6
         ONDi4uVJ4lkC9uNgXzRnEyJqIkHy6V9uilRDo4H2J9yqackqX1TRa3VmfGOZPv12ILK3
         qaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BhxzVjZr2SNzqHU8dl3WZkOg+9n73v4zh51iEiFYkNg=;
        b=OxH/BhPgbOeggv5OkPz+osy8Lxh7f8nfR5UK5k9ULsEe80Mcvo1OQqJaecXOKY0kXC
         gnovtb9GYU08Kq+dGqoGdO81QUptaAhjgmnYJnjMtlIw1vRk62j5cSguHjoNLvRqUUEe
         IxO/fyWbUmGk0Bxoo2yDqwvBqEJ5f5aQapsr37pGA/tRlC5aLgwQNVf2HYPUxDQiLFt7
         Fn+YckMVuhRdFJuV6+w6uzSoaDhTjcMOzvig4jzYmsKTmAI/p2h0KnDJ2yT11wHRutcs
         9JpHerCxC3kBVTQLDaFpwpv6wab4DWLx6d1baOjeRouMUXvsPdPYk2iFQhfou3Kk7K4V
         QKRA==
X-Gm-Message-State: AOAM532aW+m93EklxVU8fB3KeIIALV5DosTsb3m3kiLPCKOO8EGr/loy
        jRdFexjT3DANTKZACUwLy1dGYQ==
X-Google-Smtp-Source: ABdhPJyKz2osJT4TXap5I7JQMzStcQPXhLplRkSszv5PaYNO6kMp/V/NTEkRjX+m/WAowbKLQmkbwA==
X-Received: by 2002:a63:6983:: with SMTP id e125mr1180405pgc.574.1644272241901;
        Mon, 07 Feb 2022 14:17:21 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id j4sm13274215pfc.217.2022.02.07.14.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 14:17:21 -0800 (PST)
Date:   Mon, 7 Feb 2022 22:17:17 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
Subject: Re: [PATCH 11/23] KVM: MMU: do not recompute root level from
 kvm_mmu_role_regs
Message-ID: <YgGabVGxzMw2lcMf@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-12-pbonzini@redhat.com>
 <YgGY31hso29mbQ2E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgGY31hso29mbQ2E@google.com>
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

On Mon, Feb 07, 2022 at 10:10:39PM +0000, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:57:06AM -0500, Paolo Bonzini wrote:
> > The root_level can be found in the cpu_role (in fact the field
> > is superfluous and could be removed, but one thing at a time).
> > Since there is only one usage left of role_regs_to_root_level,
> > inline it into kvm_calc_cpu_role.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 23 ++++++++---------------
> >  1 file changed, 8 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index f98444e1d834..74789295f922 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -253,19 +253,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
> >  	return regs;
> >  }
> >  
> > -static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
> > -{
> > -	if (!____is_cr0_pg(regs))
> > -		return 0;
> > -	else if (____is_efer_lma(regs))
> > -		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
> > -					       PT64_ROOT_4LEVEL;
> > -	else if (____is_cr4_pae(regs))
> > -		return PT32E_ROOT_LEVEL;
> > -	else
> > -		return PT32_ROOT_LEVEL;
> > -}
> > -
> >  static inline bool kvm_available_flush_tlb_with_range(void)
> >  {
> >  	return kvm_x86_ops.tlb_remote_flush_with_range;
> > @@ -4673,7 +4660,13 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> >  		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
> >  		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
> >  		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
> > -		role.base.level = role_regs_to_root_level(regs);
> > +
> > +		if (____is_efer_lma(regs))
> > +			role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
> > +		else if (____is_cr4_pae(regs))
> > +			role.base.level = PT32E_ROOT_LEVEL;
> > +		else
> > +			role.base.level = PT32_ROOT_LEVEL;
> 
> Did you mean to drop the !CR0.PG case?

Oh never mind I see the !CR0.PG case is handled above.

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> >  
> >  		role.ext.cr0_pg = 1;
> >  		role.ext.cr4_pae = ____is_cr4_pae(regs);
> > @@ -4766,7 +4759,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
> >  	context->get_guest_pgd = get_cr3;
> >  	context->get_pdptr = kvm_pdptr_read;
> >  	context->inject_page_fault = kvm_inject_page_fault;
> > -	context->root_level = role_regs_to_root_level(regs);
> > +	context->root_level = cpu_role.base.level;
> >  
> >  	if (!is_cr0_pg(context))
> >  		context->gva_to_gpa = nonpaging_gva_to_gpa;
> > -- 
> > 2.31.1
> > 
> > 
