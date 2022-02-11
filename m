Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258B94B1B6F
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 02:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346966AbiBKBoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 20:44:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346055AbiBKBoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 20:44:10 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E5F5F93
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:44:10 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z17so3421250plb.9
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 17:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zFYMirPh/eR5GwuGXASD2X9MTPiihD/L5+hpXzIMHiI=;
        b=GmdTpGFKQzioEF0Jf0JcBEozVqOU2xVWey7zx7lp3v2gy8AEE5yrjDHxjaw0vQSUz9
         +/pNQtpS/5rn1OVHRoUnXI/ZRHTCSbR8HJulhBjXEZ+LVfyyV16SSQcYB7XbW2QMx3+J
         AmpnVhmiryCEejtJVxeAxgAKVHR/LAy0pTpfMeX9oGx+1Ghf8e7Q0tkVBCkcbPT3DIEI
         iuRvTtaqY6UaXn/ThIGKEg1wBGeR6Ay19O66DevB2cSvDQDTXEVOIJraaISQTaMciFC8
         +TWgHta9TH6w02B2Eu3AfZjfFJINLBFvkl5W4oeHMrw0MvcKojsNsU/M5XjkK1gIXAcx
         eFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zFYMirPh/eR5GwuGXASD2X9MTPiihD/L5+hpXzIMHiI=;
        b=owbKuiWR1RwCwNwZm0yARcsBQMdvvMUhxLp5968qhtuOcTaGDbEzB7S69P5rmZrgM7
         Sc6tUHodzKVrNl5y99CPM8+13y+QJ/GXBoG1Np6lAjKI7wv+D3Okferis33k3GMxOUYS
         Wz18rCty2kG/LqhzieS37nBs1v6WgEJrmWT/9fq6PYgAWZFP0CqxUNhaeDa4aBQsi7O6
         cqgmpyuE81RsAGmasaj5K8Db5G/q8D6VNpWeFuk9JWynO0bGx2287QNxyRCGBX6tMZpL
         QRP1cNFm7rFb/Uj9UMv4HKHFEx/UENraiZZcDFWjt0Q2s2unMaNCkrhiXUIbAs9vtYN3
         ZJig==
X-Gm-Message-State: AOAM532mB2vbvJs+WecaRVefUexyecT/w3fKnmQJcfN03fPL2XV9x5w4
        Q0LutEz9y+IUA5Zci2Scl/NSjnJhjdyRFQ==
X-Google-Smtp-Source: ABdhPJwRDTYmEVxd6eI4oS0+B3NsHy6+EBsvEaPdupHQ9iogPGY0X79JuyiAIUwlFlUqS+kApgvQYw==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr243914pjd.61.1644543850056;
        Thu, 10 Feb 2022 17:44:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f12sm25108727pfv.30.2022.02.10.17.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 17:44:09 -0800 (PST)
Date:   Fri, 11 Feb 2022 01:44:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Message-ID: <YgW/ZiURGlh5+nUr@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-9-pbonzini@redhat.com>
 <YgWwrG+EQgTwyt8v@google.com>
 <YgWzyBbAZe89ljqO@google.com>
 <ba9e1a56-f769-01c1-607f-3630a62a1b5d@redhat.com>
 <YgW9bqM1M/zJEzqy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgW9bqM1M/zJEzqy@google.com>
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

On Fri, Feb 11, 2022, Sean Christopherson wrote:
> On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> > On 2/11/22 01:54, Sean Christopherson wrote:
> > > > > @@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> > > > >   					   &invalid_list);
> > > > >   	if (free_active_root) {
> > > > > -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> > > > > -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> > > > > +		if (to_shadow_page(mmu->root.hpa)) {
> > > > >   			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> > > > >   		} else if (mmu->pae_root) {
> > > 
> > > Gah, this is technically wrong.  It shouldn't truly matter, but it's wrong.  root.hpa
> > > will not be backed by shadow page if the root is pml4_root or pml5_root, in which
> > > case freeing the PAE root is wrong.  They should obviously be invalid already, but
> > > it's a little confusing because KVM wanders down a path that may not be relevant
> > > to the current mode.
> > 
> > pml4_root and pml5_root are dummy, and the first "real" level of page tables
> > is stored in pae_root for that case too, so I think that should DTRT.
> 
> Ugh, completely forgot that detail.  You're correct.  Probably worth a comment?

Actually, can't this be

			if (to_shadow_page(mmu->root.hpa)) {
				...
			else if (!WARN_ON(!mmu->pae_root)) {
				...
			}

now that it's wrapped with VALID_PAGE(root.hpa)?
