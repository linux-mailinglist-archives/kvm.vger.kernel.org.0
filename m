Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58F84B2BE8
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352277AbiBKRiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:38:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352261AbiBKRiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:38:12 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F44AB87
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:38:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id on2so8721860pjb.4
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=31WXEtNem9gDE7QTRA9SonhwVjBCyz+p2rqK3D2sGGU=;
        b=dU/3B4Fo9darPqSSrUz1zLT1vpNqKT1vkn7X+utRHFkgIQOezdeVsoWlYRswUNXQj5
         I/NAwe1wD2B3R3oHMsjLCkiTKtISujMdurYNpAtsaZ3trY8Hzp8jpeuGvouwPt5+60mw
         XVhcPtDi/7CWNQfs6h9DbfZhSSe1Z0TzQXUfx7m7tEM8fgiCQDYpdFr9usq3zgW6dQ/h
         9KL292gK1YoVlSOkZ/RJAERpO4osrFj30RGaFIK5IrUuaBZ0ZWmcfNigR4L4mZP5hkIw
         EwClZJaztQsZnZy72gYVCjvAQTp4k55ZXZd8CZc0oLPPbCDOkM9EaF7luXbkf9wPSEWn
         NuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=31WXEtNem9gDE7QTRA9SonhwVjBCyz+p2rqK3D2sGGU=;
        b=y9lxVzT8Zl2NoEOMOGtDA0S8FeViPDQZvjU1wH0UIHMiWHMbu8BZJLTMFivOrnifc2
         /4g7hZuYNBbrCkJJuhN8Z3mXk2BoWPE9+BXwrSQYDElYXlPJuevqNH07vgi1lMedkOt8
         lk7Uw49JV53MoqdkNwbngTmSbwbkq5gTQffBcXbb3MEyE+XWjZ8OHMJffJMKtVm73/ii
         tKkO7xfiX2nSIgavAwB/aHd766bfWKAo+nZnYZXvU9t1A7IR2hS/PyIODqF9uI/GOD2e
         65+TqYXk+C4x3EoYNwsNz3kM0vewgl4AUQq4vraUfauc8McPVI29aHPojJLFIT9abqSV
         hoAg==
X-Gm-Message-State: AOAM530RlMoeKHSErZuzJ9qiGx1tscgUAPjJw9tX1tdkN73Pu4URk7Y1
        KLR5q4NMPIzHIRptfUkbBAMfeQ==
X-Google-Smtp-Source: ABdhPJxiTJxp7ZsT+fYmpI+xrlg9ysC/lAiYRtpL8wjjBFlEb4G5pawDR+vfltdYJpnkfKgT2tFv1g==
X-Received: by 2002:a17:903:1108:: with SMTP id n8mr2626684plh.94.1644601089552;
        Fri, 11 Feb 2022 09:38:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y42sm27832633pfa.5.2022.02.11.09.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 09:38:08 -0800 (PST)
Date:   Fri, 11 Feb 2022 17:38:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 09/12] KVM: MMU: look for a cached PGD when going from
 32-bit to 64-bit
Message-ID: <Ygae/V/UxD6axX2G@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-10-pbonzini@redhat.com>
 <YgW8ySdRSWjPvOQx@google.com>
 <51fcfb88-417b-e638-78b7-bbca82d8bd8b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51fcfb88-417b-e638-78b7-bbca82d8bd8b@redhat.com>
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

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> On 2/11/22 02:32, Sean Christopherson wrote:
> > Maybe cached_root_find_and_rotate() or cached_root_find_and_age()?
> 
> I'll go for cached_root_find_and_keep_current() and
> cached_root_find_without_current(), respectively.
> 
> > 
> > Hmm, while we're refactoring this, I'd really prefer we not grab vcpu->arch.mmu
> > way down in the helpers.  @vcpu is needed only for the request, so what about
> > doing this?
> > 
> > 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
> > 		/*
> > 		 * <whatever kvm_mmu_reload() becomes> will set up a new root
> > 		 * prior to the next VM-Enter.  Free the current root if it's
> > 		 * valid, i.e. if a valid root was evicted from the cache.
> > 		 */
> > 		if (VALID_PAGE(vcpu->arch.mmu->root.hpa))
> > 			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> > 		return;
> > 	}
> 
> I tried, but it's much easier to describe the cache functions if their
> common postcondition is "vcpu->arch.mmu->root.hpa is never stale"; which
> requires not a struct kvm_vcpu* but at least a struct kvm*, for the MMU
> lock.
> 
> I could change kvm_mmu_free_roots and cached_root_* to take a struct kvm*
> plus a struct kvm_mmu*.  Does that sound better?

Ya, works for me, thanks!
