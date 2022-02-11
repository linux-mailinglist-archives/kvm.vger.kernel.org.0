Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD05D4B1B54
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 02:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346847AbiBKBfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 20:35:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346840AbiBKBfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 20:35:46 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C485F48
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:35:46 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id a39so12657263pfx.7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m7OTZN6MMJaOtWh3GEnwnLzNFllEBgIohS86VWKpGKg=;
        b=pwTr6XihNQSpOrHNa73cPDI9LUWGbCjQmOTkYSAUF4oHhAL6nnH1MPWpx0PWgO13zw
         hZQ3dtKXaI+WL0N8yW65h4Gak8Xb9Ojg+TxwGAqzEaj6yB+13WtQRqRn8WKqjtRuAPWw
         Cwamfr7Gn7rcKUiGHGtprSiAieYVaTRUaAy4wBTh70sYVlIgdwAMxw1u2s10X2KulZ8o
         SQyabb3il4e7E/NrDxw5k7bFQ40uxVKLYLuPDxGZbjm2g8oxu6TLSeW77Ym1VOvHa5eD
         v7gTEZ+uu2PNbaZiJ0Nbmg7xaiU8RWfiqgWcyWaYJW0srHhPxIwJDqFnyjKRgW/qPXqW
         8TrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m7OTZN6MMJaOtWh3GEnwnLzNFllEBgIohS86VWKpGKg=;
        b=njiQt5Q9knX3PZkrzRg+nFPxJc1cOVnofGWT1QZRoS5EaV5MVi4E9b2pa4aB985rOU
         Dffpt1TSDcxYXsErXpwnLCvPltBb/vkpiTOD9lgjIbz6iEXcIUmUG1gE6hF7ZXap/nre
         jBdDB6nBfVSkpfx/wRS3VtwZN/LPMcrB84Ge1VN0uux7o02pQFWL9mEhmHGSUy+H9Lcy
         5MLjlb/7rfkOWO1b4hlKEO2g3RBOBNPUyYPm0bu5rMzA+T39nvoJju8b4M3G2VOU7+NQ
         8nKFjdNXz4+oP6Q4Okx2DnbNUW9EbIyPHzh+UMWD8KwtqIR/YkDqX3risR7DRicptxXe
         bkXg==
X-Gm-Message-State: AOAM533z9PIPPpGE6jFWzWj9cTaqkNVXUFdg08jBaELVYDDwexsiUu2g
        0RBtWHFyynLV8j6emB9njrRU/FO8L4/SoQ==
X-Google-Smtp-Source: ABdhPJxdym9QXrbD8SY5hJ202JdMfDsCGHjo7Bl0bto7Qh08A17Zfp+LuzUE/d9K6rNIhhxMR+Hmjg==
X-Received: by 2002:a05:6a00:c83:: with SMTP id a3mr10367017pfv.36.1644543346299;
        Thu, 10 Feb 2022 17:35:46 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u25sm2905415pgf.42.2022.02.10.17.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:35:45 -0800 (PST)
Date:   Fri, 11 Feb 2022 01:35:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Message-ID: <YgW9bqM1M/zJEzqy@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-9-pbonzini@redhat.com>
 <YgWwrG+EQgTwyt8v@google.com>
 <YgWzyBbAZe89ljqO@google.com>
 <ba9e1a56-f769-01c1-607f-3630a62a1b5d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba9e1a56-f769-01c1-607f-3630a62a1b5d@redhat.com>
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

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> On 2/11/22 01:54, Sean Christopherson wrote:
> > > 	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT) &&
> > > 			   VALID_PAGE(mmu->root.hpa);
> > > 
> > > Isn't this a separate bug fix?  E.g. call kvm_mmu_unload() without a valid current
> > > root, but with valid previous roots?  In which case we'd try to free garbage, no?
> 
> mmu_free_root_page checks VALID_PAGE(*root_hpa).  If that's what you meant,
> then it wouldn't be a preexisting bug (and I think it'd be a fairly common
> case).

Ahh, yep.

> > > > +
> > > > +	if (!free_active_root) {
> > > >   		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> > > >   			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
> > > >   			    VALID_PAGE(mmu->prev_roots[i].hpa))
> > > > @@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > >   					   &invalid_list);
> > > >   	if (free_active_root) {
> > > > -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> > > > -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> > > > +		if (to_shadow_page(mmu->root.hpa)) {
> > > >   			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> > > >   		} else if (mmu->pae_root) {
> > 
> > Gah, this is technically wrong.  It shouldn't truly matter, but it's wrong.  root.hpa
> > will not be backed by shadow page if the root is pml4_root or pml5_root, in which
> > case freeing the PAE root is wrong.  They should obviously be invalid already, but
> > it's a little confusing because KVM wanders down a path that may not be relevant
> > to the current mode.
> 
> pml4_root and pml5_root are dummy, and the first "real" level of page tables
> is stored in pae_root for that case too, so I think that should DTRT.

Ugh, completely forgot that detail.  You're correct.  Probably worth a comment?

> That's why I also disliked the shadow_root_level/root_level/direct check:
> even though there's half a dozen of cases involved, they all boil down to
> either 4 pae_roots or a single root with a backing kvm_mmu_page.
> 
> It's even more obscure to check shadow_root_level/root_level/direct in
> fast_pgd_switch, where it's pretty obvious that you cannot cache 4 pae_roots
> in a single (hpa, pgd) pair...

Heh, apparently not obvious enough for me :-)
