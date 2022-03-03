Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A24CB347
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 01:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiCCANR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 19:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiCCANO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 19:13:14 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AFACB93A
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 16:12:30 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ay5so3032223plb.1
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 16:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Td4OZ3CGd5qbdkbgU7FY+nlkAv7YQKpmIhrzx/kUjzU=;
        b=K1LcK7iCnXuheBWswh9IK28RiGD6oNWwq9sVu+D7heKHTJ4ArDuYccdpbxGNoDQ43z
         rXucgFRTFwpkDDKm5q8FHQlbT0RXSWsJmBRhCeJJSoObX5ISY20k1epb5uXEBQZYsTJb
         52fvKPWsR193DmcZ5aAKb8BoscIkjXmPWuQXX/lOKH5RWZMS2BnAJGOEFQpske8qx+Cc
         dDHOja0t1ObCNHaLze4mbZjXZV1606kGCYyU7SZonkicuaWQhYa0vj0uuzdtryUta6HR
         WawmlaAyb2plPEIyi/9iw1mS4soHJ7Xj7itbwm1xuWD/cr8F8Bua5JC7QN0AF4OE/GVX
         ukUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Td4OZ3CGd5qbdkbgU7FY+nlkAv7YQKpmIhrzx/kUjzU=;
        b=zubH5Dhz/WE/wk8CrzP6Dwnui7tOaaP51GCdvQl+MdynU/bZY1itt4MrAWAx2J9GMF
         xwulab0SPL4fGJZthf2tm5vza4clJH56MEfQ5Ey9w+k48DkbD9YZxCbrEbRINO+/KWSp
         f2MeWPUGqLohEz44n/Lft9YCtCVBJ6TxGXsIzHDCkTfrqHKmhviybWv3ZBOizU2eaTlt
         x6mVmUO2VXvjGjw3iThKebe+/Ce/KlKdi1FEItZkuNgwmMJlSc7bGBY0bxlgEm9A7Pfa
         A1whosHJieYgWMmUT4t+stp8WIHEeIoC06Ot4IjBGUhrzexuu0IrRI9+P/RlFL/4irWp
         xzlg==
X-Gm-Message-State: AOAM533g6lg7g2Lm7If0pSE7K/3P0gs9ovmBs74fTTMGV4uc4ZvCLKf0
        qeWz28aD6vFwRvgkWoO9iathtg==
X-Google-Smtp-Source: ABdhPJwR7M4jonsW7a9xPbncoCR2AjvLpdLl9OviFtzwYaKQ+z+yJXD3Am1fuqU3JpL/ica97nb7ig==
X-Received: by 2002:a17:90b:3d02:b0:1bc:85fa:e24 with SMTP id pt2-20020a17090b3d0200b001bc85fa0e24mr2354281pjb.239.1646266349430;
        Wed, 02 Mar 2022 16:12:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00180500b004e1bea9c587sm323943pfa.67.2022.03.02.16.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 16:12:28 -0800 (PST)
Date:   Thu, 3 Mar 2022 00:12:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 04/28] KVM: x86/mmu: Formalize TDP MMU's (unintended?)
 deferred TLB flush logic
Message-ID: <YiAH6UfSDyHeMP+s@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-5-seanjc@google.com>
 <YiAE4ju0a3MWXr31@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiAE4ju0a3MWXr31@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Mingwei Zhang wrote:
> On Sat, Feb 26, 2022, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 12866113fb4f..e35bd88d92fd 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -93,7 +93,15 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> >  	list_del_rcu(&root->link);
> >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >  
> > -	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> > +	/*
> > +	 * A TLB flush is not necessary as KVM performs a local TLB flush when
> > +	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
> > +	 * to a different pCPU.  Note, the local TLB flush on reuse also
> > +	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
> > +	 * intermediate paging structures, that may be zapped, as such entries
> > +	 * are associated with the ASID on both VMX and SVM.
> > +	 */
> > +	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
> 
> Understood that we could avoid the TLB flush here. Just curious why the
> "(void)" is needed here? Is it for compile time reason?

Nope, no functional purpose, though there might be some "advanced" warning or
static checkers that care.

The "(void)" is to communicate to human readers that the result is intentionally
ignored, e.g. to reduce the probability of someone "fixing" the code by acting on
the result of zap_gfn_range().  The comment should suffice, but it's nice to have
the code be self-documenting as much as possible.
