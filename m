Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36FC55A151
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiFXSue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiFXSuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:50:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6FE81732
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 11:50:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g10-20020a17090a708a00b001ea8aadd42bso3688485pjk.0
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 11:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q6rfr27frAJafJqMgSkhsqEES6anfv72cn5sJOShRWg=;
        b=lPyBwFVYgDgojYMZLm9K8IQPLtILllrC448H9vIQl3PSY85Fupyk+joMMWGmQWeXM1
         r6g3XYa4mmW7wl1K7Qc5wuG+6orRfx6xbxL/kjd0Jr2xvu1A23uNXxf1FZCV5FDbxEaI
         7MC/9tN3CuFTEN9hcWQaXskKO0E0YJtuPqiQizFjQxacdy4wIJRwsd85RSKcu3sSsQL7
         +/XTTvfs6rQ4WlQ2AoasmMQUPFgwcUAxiR4z2NtuqIK5HPXmQYy1bql/kKFX34sCcUXv
         UzS56h0LHHR/FLDpXLp1wFaD18eOUla2KoP4Twi3xX6E1p1hpQefwow0f1Pl9DrhC6zT
         u3YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q6rfr27frAJafJqMgSkhsqEES6anfv72cn5sJOShRWg=;
        b=hsn5ofqQfdB99ZFVLsIxcVwxI209jHoEum0xnkF005QOlcPJkAppjQ+31jiMaoU6yv
         v+y3QxGFYAyXFqr25uYzdqUZAJx/sD7eLaDscRb98yk4aBbIELHyz9HRWEhwXfkKSUpy
         FNRRBZH2uEjGXS0UJAn/URsEnX2Zrhl5o3g6iUIZH9Vmj4XtavKhvu78w0w0s3T9DeJO
         q8reqLTFuMj1+1SrBLpMRz/fhUs+6Agsgns/eNSiFyLJmG+IUV4C4wlHpHGBnc5IvM2Y
         42PnhqHL8z9C8HenVq/zz81A+Jhtq5mqlsKgx+K32YnCyyHF65xu41Pwu8HDlJXDVN/m
         wNKA==
X-Gm-Message-State: AJIora/puV1yRdxrtwZCPgw9fUvgmdD4EfUrbwV6URjtxGOmK/uIw3Vp
        iSv27cCg5a1+67Q5xXBFrJv2CQ==
X-Google-Smtp-Source: AGRyM1t+BrMAJc3FK1feaNJwIwRFADdLm2Q1Y7zAR1oGUMoY80j1jfgCOLrhQPq3RgTaBuQrnNQw6Q==
X-Received: by 2002:a17:90a:410a:b0:1ec:7fc8:6d15 with SMTP id u10-20020a17090a410a00b001ec7fc86d15mr326047pjf.236.1656096631204;
        Fri, 24 Jun 2022 11:50:31 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h8-20020a056a00170800b0050dc762819bsm2041961pfc.117.2022.06.24.11.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 11:50:30 -0700 (PDT)
Date:   Fri, 24 Jun 2022 18:50:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Avoid subtle pointer arithmetic in
 kvm_mmu_child_role()
Message-ID: <YrYHc4BIAf+pGRhW@google.com>
References: <20220624171808.2845941-1-seanjc@google.com>
 <20220624171808.2845941-2-seanjc@google.com>
 <YrX1WB1FZzXiR+Io@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrX1WB1FZzXiR+Io@google.com>
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

On Fri, Jun 24, 2022, David Matlack wrote:
> On Fri, Jun 24, 2022 at 05:18:06PM +0000, Sean Christopherson wrote:
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2168,7 +2168,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
> >  	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> >  }
> >  
> > -static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
> > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
> > +						  unsigned int access)
> >  {
> >  	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> >  	union kvm_mmu_page_role role;
> > @@ -2195,13 +2196,19 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsig
> >  	 * uses 2 PAE page tables, each mapping a 2MiB region. For these,
> >  	 * @role.quadrant encodes which half of the region they map.
> >  	 *
> > -	 * Note, the 4 PAE page directories are pre-allocated and the quadrant
> > -	 * assigned in mmu_alloc_root(). So only page tables need to be handled
> > -	 * here.
> > +	 * Concretely, a 4-byte PDE consumes bits 31:22, while an 8-byte PDE
> > +	 * consumes bits 29:21.  To consume bits 31:30, KVM's uses 4 shadow
> > +	 * PDPTEs; those 4 PAE page directories are pre-allocated and their
> > +	 * quadrant is assigned in mmu_alloc_root().   A 4-byte PTE consumes
> > +	 * bits 21:12, while an 8-byte PTE consumes bits 20:12.  To consume
> > +	 * bit 21 in the PTE (the child here), KVM propagates that bit to the
> > +	 * quadrant, i.e. sets quadrant to '0' or '1'.  The parent 8-byte PDE
> > +	 * covers bit 21 (see above), thus the quadrant is calculated from the
> > +	 * _least_ significant bit of the PDE index.
> >  	 */
> >  	if (role.has_4_byte_gpte) {
> >  		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
> > -		role.quadrant = (sptep - parent_sp->spt) % 2;
> > +		role.quadrant = ((unsigned long)sptep / sizeof(*sptep)) & 1;
> >  	}
> 
> I find both difficult to read TBH.

No argument there.  My objection to the pointer arithmetic is that it's easy to
misread.

> And "sptep -> sp->spt" is repeated in other places.

> 
> How about using this oppotunity to introduce a helper that turns an
> sptep into an index to use here and clean up the other users?
> 
> e.g.
> 
> static inline int spte_index(u64 *sptep)
> {
>         return ((unsigned long)sptep / sizeof(*sptep)) & (SPTE_ENT_PER_PAGE - 1);
> }
> 
> Then kvm_mmu_child_role() becomes:
> 
>         if (role.has_4_byte_gpte) {
>         	WARN_ON_ONCE(role.level != PG_LEVEL_4K);
>         	role.quadrant = spte_index(sptep) & 1;
>         }

Nice!  I like this a lot.  Will do in v2.
