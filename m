Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1765355B7
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344713AbiEZVi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbiEZVi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:38:56 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE37E2770
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:38:55 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h13so2739908pfq.5
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 14:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mB+0L5ZW4xRVA9Uby65kPSBoLCd3GkHd7PmK18bo5s=;
        b=AzsF3dlCrQwtiic1o/h4Js8usYbXf8/d8Q2SUPSntQ2M1/QaYMPdv7jFssitqpOw1Z
         S7EIgiLUSZ978HBRxyPzqPUXFfyOVvlL2dMr+8s/rMLqcjk42HOvxn8n2yEn58YAgdR1
         xAit8gEN5LokvDy2vLBSf8Dg4nPOhNTUXMC0fy/K7bwml14jXG2oCIp9mQCyPai+Kn/A
         u/JKcFelLI4eJORfKobzq11ZYbSOwID+Zfq5f5zeFDAcYb0dnprBNOPvoMKb8ByRePKK
         2p+Kn7DueZHjKCIbiyWKBaneR5jR5w2E1qWV9jwCW3qgv/vCJ+65JNsU8tFPyf+GPqga
         AB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mB+0L5ZW4xRVA9Uby65kPSBoLCd3GkHd7PmK18bo5s=;
        b=tBxWqx/TO2fbUP6lVfisXlKsMhInXrmhVgc5YYmM8lYnKU0+/9Yxa9o1T4EFOEn0wU
         P6jKLgEx1T1lsqwlkkjP/DMqySEjtMc/ohJGisiAi8PF2CJbV0q0wKmQIQN8R+q7z3LJ
         KY5yCPwJiid0VkAPyJazPnRVAp36QVJi5KZQRxzRmIVRzxpD2tUf6CYN0FuxjoAGHqNk
         A7uNId+hUSxFte/4OttpPkmq7FOHcYbTqNQzRHep46uh+pYCLcC5Th9nLkXywlA/KZpE
         SfErKp+pKRqSux7Ji4ediiH5S+1wWsZ17uM5GZiKrp039QmKwdCQFBIXLyYxGMn90+rk
         nr0A==
X-Gm-Message-State: AOAM531UGlPgRVnYV9gK+S1wzSHt7225tbX4ACYmaJt7zpqbFPuD5DH9
        QW+MDj4Su9LCNxhTf0nrkaRpzw==
X-Google-Smtp-Source: ABdhPJzVE3a2g19vLdIpMMssvikF3P8nHOR0Z/iS8V4VGu2nK8XGV/2inP87YOdWYgzyrb3Y/RNzrA==
X-Received: by 2002:a63:4525:0:b0:3db:8a4d:8a77 with SMTP id s37-20020a634525000000b003db8a4d8a77mr35189688pga.542.1653601134986;
        Thu, 26 May 2022 14:38:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p19-20020a17090ad31300b001d97f7fca06sm121659pju.24.2022.05.26.14.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 14:38:54 -0700 (PDT)
Date:   Thu, 26 May 2022 21:38:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 02/12] KVM: X86/MMU: Add using_local_root_page()
Message-ID: <Yo/za2jnWUHvoLQg@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-3-jiangshanlai@gmail.com>
 <Yo/xEirUJBLLQqCf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo/xEirUJBLLQqCf@google.com>
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

On Thu, May 26, 2022, David Matlack wrote:
> On Sat, May 21, 2022 at 09:16:50PM +0800, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > 
> > In some cases, local root pages are used for MMU.  It is often using
> > to_shadow_page(mmu->root.hpa) to check if local root pages are used.
> > 
> > Add using_local_root_page() to directly check if local root pages are
> > used or needed to be used even mmu->root.hpa is not set.
> > 
> > Prepare for making to_shadow_page(mmu->root.hpa) returns non-NULL via
> > using local shadow [root] pages.
> > 
> > Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 40 +++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 37 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index efe5a3dca1e0..624b6d2473f7 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1690,6 +1690,39 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >  	mmu_spte_clear_no_track(parent_pte);
> >  }
> >  
> > +/*
> > + * KVM uses the VCPU's local root page (vcpu->mmu->pae_root) when either the
> > + * shadow pagetable is using PAE paging or the host is shadowing nested NPT for
> > + * 32bit L1 hypervisor.
> 
> How about using the terms "private" and "shared" instead of "local" and
> "non-local"? I think that more accurately conveys what is special about
> these pages: they are private to the vCPU using them. And then "shared"
> is more intuitive to understand than "non-local" (which is used
> elsewhere in this series).

Please avoid "private" and "shared".  I haven't read the full context of the
discussion, but those terms have already been claimed by confidential VMs.

FWIW, I believe similar discussions happened around mm/ and kmap(), and they ended
up with thread_local and kmap_local().  Maybe "vCPU local" and "common"?
