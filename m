Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E14B1C1C
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 03:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347183AbiBKCUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 21:20:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbiBKCUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 21:20:22 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3735EB30
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 18:20:22 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y17so3482363plg.7
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 18:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IO2ZpcAtYXMrjlM61WFlDXdotEwcy2m14gn1xrwbE5c=;
        b=cofBBUBML8Xp8mOt3FYpkYsBWRS3bMUJgqhIy9SOHztUWAp46a8QvcAkXumzS3yidc
         RoeSXQAV9UA6e7oUVGWaR6zEcUMiYyNat3fEDg0+73gngPKG4/6wa8BI9VIskLSuHCS5
         JN4t2jN+DhqqZxqrSiyljEc0JP4uZQmtqRDNF8wL4wwxzHY587JzfJFmVt9QrTIqBsCT
         D+6hAtRakoCv+5LSNLLveurnm6sKgNbkyesiZk6nSmdUboqo+d56Y6ZqtqiR4P50Lneu
         vi2YXIxtVKNBxB4S7E7ly3DXochUZ7JQmMe+GC/e/wh+3wWAQOg3dGDweBO+DIYbEHBW
         NMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IO2ZpcAtYXMrjlM61WFlDXdotEwcy2m14gn1xrwbE5c=;
        b=ohOspO7WA6MRkDB5BVYitHNtOnsW9JHFRGtv5E3jQuliAsWHabqsB121hYe+ED9FWT
         eVOBsfTTPkTwnnnLfX6Es1ROUT74AylRLCKelAe4Up0Vnz0qeMOMbE0CEyrCichN5jJP
         KbE4QYjLCublRD5+ZC7i+j40aWahWciK4a7POAVX/WB/GxiAVcptYFVE5vxLoiKrlpJd
         d0GKx9Ufou+cu3cOYRPFCA9hjCK+Er4R8YkF1LBnVPBinFYucslcIqe6BjqDLgDQ1Nbj
         AiYGu48onDCpbCzOgMxGStNPv+VF24EXjL8x/6Cw1movCzNn1GnoU6/gw1QkYtz/X1Js
         /cdg==
X-Gm-Message-State: AOAM531I1DA+HOQSeneruVimFcKF8yXxeQ18nbLY4eNmWiA/1DYZj4IL
        9C5ophIpsqNOPc3j6Vf3pA8jeQ==
X-Google-Smtp-Source: ABdhPJy1W/2v7ptrOHpMu208d46eloVJuLXEPVpBejfy60uM8QUkHGoJzHueTRcmdde7GOZJ/T/IBQ==
X-Received: by 2002:a17:902:694c:: with SMTP id k12mr10462860plt.98.1644546021525;
        Thu, 10 Feb 2022 18:20:21 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j8sm26393351pfc.48.2022.02.10.18.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 18:20:20 -0800 (PST)
Date:   Fri, 11 Feb 2022 02:20:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Message-ID: <YgXH4eM8inTvDdgT@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-9-pbonzini@redhat.com>
 <YgWwrG+EQgTwyt8v@google.com>
 <YgWzyBbAZe89ljqO@google.com>
 <ba9e1a56-f769-01c1-607f-3630a62a1b5d@redhat.com>
 <YgW9bqM1M/zJEzqy@google.com>
 <YgW/ZiURGlh5+nUr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgW/ZiURGlh5+nUr@google.com>
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

On Fri, Feb 11, 2022, Sean Christopherson wrote:
> On Fri, Feb 11, 2022, Sean Christopherson wrote:
> > On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> > > On 2/11/22 01:54, Sean Christopherson wrote:
> > > > > > @@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > > > >   					   &invalid_list);
> > > > > >   	if (free_active_root) {
> > > > > > -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> > > > > > -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> > > > > > +		if (to_shadow_page(mmu->root.hpa)) {
> > > > > >   			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> > > > > >   		} else if (mmu->pae_root) {
> > > > 
> > > > Gah, this is technically wrong.  It shouldn't truly matter, but it's wrong.  root.hpa
> > > > will not be backed by shadow page if the root is pml4_root or pml5_root, in which
> > > > case freeing the PAE root is wrong.  They should obviously be invalid already, but
> > > > it's a little confusing because KVM wanders down a path that may not be relevant
> > > > to the current mode.
> > > 
> > > pml4_root and pml5_root are dummy, and the first "real" level of page tables
> > > is stored in pae_root for that case too, so I think that should DTRT.
> > 
> > Ugh, completely forgot that detail.  You're correct.

Mostly correct.  The first "real" level will be PML4 in the hCR4.LA57=1, gCR4.LA57=0
nested NPT case.  Ditto for shadowing PAE NPT with 4/5-level NPT, though in that
case KVM still allocates pae_root entries, it just happens to be a "real" level.

And now I realize why I'm so confused, mmu_alloc_shadow_roots() is also broken
with respect to 5-level shadowing 4-level.  I believe the part that got fixed
was 5-level with a 32-bit guest.  Ugh.

For the stuff that actually works in KVM, this will do just fine.  5-level nNPT
can be punted to the future.
