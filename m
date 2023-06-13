Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347AC72EB9A
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 21:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjFMTIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 15:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjFMTID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 15:08:03 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006BC1BE9
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:07:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-25bd1522ad3so1702677a91.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686683279; x=1689275279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ct/zCCuATaNWjKBHPNvd1UYStLS589z7ctJXd+vLMd0=;
        b=LIZ+nGa1lsYeKo+vmN3HOVpp7WlP7vCX1VRj5ai1od0ZGNsZHTg3CwKFvY+vj9eMPI
         OE5bAkwBXgHAteYRd2QcUSeU7gP21lkHp2dKYCabOO8dY/4GDyhkDNSvQNwni9ycxVqB
         AUfZ5AiAGrKcUlCVIYad/m3fNHkCJ2V/AaI3wquli7yIbTT1/TzzAWXncmZHmcVYozWW
         A63B2Ih8NWk/owpcQnNKX9ZLocgZmR2KnaxvYcibnhfSuNk51jEny5EzD0zSyniayGEK
         Lxcj9GfeQygM26nJILvkJTqOS2CxSQU8Pffa6hkASsUZ6HCYKGK0Vt37yfYhBXP5V10C
         tz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686683279; x=1689275279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ct/zCCuATaNWjKBHPNvd1UYStLS589z7ctJXd+vLMd0=;
        b=PGA9dN3Wi/mCCnt3aDJhiiw95JAR89BEF4mO9gI0kNzXCOifGM4kuVdqT8+l7Mwk1y
         y079qL/BFyLKFA5OBFTRkhKsqraQDre8kviJwpFoWzDwkye/t3PKmiGBF3S0kah178LJ
         qH94vfPjTu3H5irkCL9TtoXQoboTSn41lx0Y5xEZRkVd1udfQTgrGG5Ji51br9OMpqhr
         4P8BwB6YCEtnJTgcMXzojQdxtSH72AfWE1G9bvzpnZqTc7gWgP+MsBKZr3CJXO5+BDxT
         W0uvX036scCKZVAzjjQAASssfROVL2eNukliG14IusQO4jjXTLLrJztVwigTBoTy7ykb
         yyHQ==
X-Gm-Message-State: AC+VfDzu1GqD3BHcoJCJS/GRuXFEoRDZzkws6L5n9Ld7e9l+llOin9OS
        yHx2cBqf8F0SQ2axx94G+Ne/96MrZR8=
X-Google-Smtp-Source: ACHHUZ6d1BOYCoi6GCk7T5M7Q6vTFZUS5zB71Lz2smCCIMdH+Mas5IRfBTx9AjJBjbb5YRQpkgbhrC2TMTA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c297:b0:25b:cb86:b13e with SMTP id
 f23-20020a17090ac29700b0025bcb86b13emr1434508pjt.2.1686683279301; Tue, 13 Jun
 2023 12:07:59 -0700 (PDT)
Date:   Tue, 13 Jun 2023 12:07:57 -0700
In-Reply-To: <20230608070016.f3dz6dhvdkxsomdb@linux.intel.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com> <20230602011518.787006-2-seanjc@google.com>
 <20230607073728.vggwcoylibj3cp6s@linux.intel.com> <ZICUbIF2+Cvbb9GM@google.com>
 <20230607172243.c2bkw43hcet4sfnb@linux.intel.com> <ZIDENf2vzwUjzcl2@google.com>
 <20230608070016.f3dz6dhvdkxsomdb@linux.intel.com>
Message-ID: <ZIi+jWxYg/UhKpr1@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if
 invalidation is in-progress
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 08, 2023, Yu Zhang wrote:
> > 
> > Flushing when KVM zaps SPTEs is definitely necessary.  But the flush in
> > vmx_set_apic_access_page_addr() *should* be redundant.
> > 
> > > Could we try to return false in kvm_unmap_gfn_range() to indicate no more
> > > flush is needed, if the range to be unmapped falls within guest APIC base,
> > > and leaving the TLB invalidation work to vmx_set_apic_access_page_addr()?
> > 
> > No, because vmx_flush_tlb_current(), a.k.a. KVM_REQ_TLB_FLUSH_CURRENT, flushes
> > only the current root, i.e. on the current EP4TA.  kvm_unmap_gfn_range() isn't
> > tied to a single vCPU and so needs to flush all roots.  We could in theory more
> > precisely track which roots needs to be flushed, but in practice it's highly
> > unlikely to matter as there is typically only one "main" root when TDP (EPT) is
> > in use.  In other words, KVM could avoid unnecessarily flushing entries for other
> > roots, but it would incur non-trivial complexity, and the probability of the
> > precise flushing having a measurable impact on guest performance is quite low, at
> > least outside of nested scenarios.
> 
> Well, I can understand the invalidation shall be performed for both current EP4TA,
> and the nested EP4TA(EPT02) when host retries to reclaim a normal page, because L1
> may assign this page to L2. But for APIC base address, will L1 map this address to
> L2?

L1 can do whatever it wants.  E.g. L1 could passthrough its APIC to L2, in which
case, yes, L1 will map its APIC base into L2.  KVM (as L0) however doesn't support
mapping the APIC-access page into L2.  KVM *could* support utilizing APICv to
accelerate L2 when L1 has done a full APIC passthrough, but AFAIK no one has
requested such support.  Functionally, an APIC passthrough setup for L1=>L2 will
work, but KVM will trap and emulate APIC accesses from L2 instead of utilizing
hardware acceleration.

More commonly, L1 will use APICv for L2 and thus have an APIC-access page for L2,
and KVM will map _that_ page into L2.

> Also, what if the virtualize APIC access is to be supported in L2,

As above, KVM never maps the APIC-access page that KVM (as L0) manages into L2.

> and the backing page is being reclaimed in L0? I saw
> nested_get_vmcs12_pages() will check vmcs12 and set the APIC access address
> in VMCS02, but not sure if this routine will be triggered by the mmu
> notifier...

Pages from vmcs12 that are referenced by physical address in the VMCS are pinned
(where "pinned" means KVM holds a reference to the page) by kvm_vcpu_map().  I.e.
the page will not be migrated, and if userspace unmaps the page, userspace might
break its VM, but that's true for any guest memory that userspace unexpectedly
unmaps, and there won't be any no use-after-free issues.
