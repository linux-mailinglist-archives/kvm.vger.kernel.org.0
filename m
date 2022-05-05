Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8AD51CCC8
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 01:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386814AbiEEXgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 19:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiEEXgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 19:36:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5D35EDD5
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 16:33:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so9372546pjq.0
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 16:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Rru4EvM+XN9fli3rN5SHjuT5guNThoc36o1YydC9Qw=;
        b=an3wpmzQDMQBkQXqJoOqd+t3py56kyzvH6SCFffNtjcFenp5AuLHGLxJnfURCGI1+n
         uE9X/0H1kj/PRv/Zo127tJTpx031+RG5G+7idyXKOfNS3/LCuHdR9TUGlCDOd2fTX0GR
         uSnL5URALBUeYYhd47aPiBvJwAR9rvRdJWWN+pTORArwRgWnJN74zQM9jtsAVEWrk3tW
         jHehIdevXXhdPspJtGMRa5MhmK8Mn0J0TAT99JodxRypVQgnwiCjbvlZimpERRb4P9ea
         Rl7p+mvefRVHBNMXq2ADk/r/yGexaUrT12X7Oh2dzI6i8jRl2bzD5sU6OP8DMLHciHaO
         UDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Rru4EvM+XN9fli3rN5SHjuT5guNThoc36o1YydC9Qw=;
        b=OoufRBhiGE8oawmpwHY2IFBibdMRP0UOwaAQxQ/sF4hgUTq7spTFDPnmLqgxxgdikm
         WltTfXs+jScZSaW9s07U9Ho/zr1QbNMrXVufWBTmAPOCKk+64DUF/ErHFIXXwVGU5d7T
         +EKEvhnKT8mWkhlL2L1lfXZIefWeIh+kXhRhOT1o81xCxwKvXmgpWOQChikwPu5eURjh
         BGLFKamVUB/jEaWh3971k6Zl9oCodHO+EPXVxuLLaUdPosEJnblg1YZBI6PwCmpnNR6w
         WMGcrAGsOl6LnzQ3YCUpImufgSj3WimfTVk5VktBHsbCTujKvroGIVglQFx+W35WuZXy
         6/AA==
X-Gm-Message-State: AOAM533hM+4CuXpTQiRuVHoNm4sic0WcrZVZlUSHcM8FP2if2qH1wNnC
        tb6YZbN2F/BbcAAODXQFd1/c+w==
X-Google-Smtp-Source: ABdhPJz15lbM0bMDWimOz5AKmg1zx67gRQwuIdcs+TBruzTwqhiF+UyOijI/QMMMoovS4rb8KIF7Lg==
X-Received: by 2002:a17:902:b704:b0:156:624:934b with SMTP id d4-20020a170902b70400b001560624934bmr671141pls.116.1651793584418;
        Thu, 05 May 2022 16:33:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w131-20020a627b89000000b0050dc762815fsm1931440pfc.57.2022.05.05.16.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 16:33:04 -0700 (PDT)
Date:   Thu, 5 May 2022 23:33:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
Message-ID: <YnRerE5+FpwkUdQE@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-12-dmatlack@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> it to vcpu_or_null to prevent future commits from accidentally taking
> dependency on it without first considering the NULL case.
> 
> The vcpu pointer is only used for syncing indirect shadow pages in
> kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> correctness since unsync pages can simply be zapped. But this should
> never occur in practice, since the only use-case for passing a NULL vCPU
> pointer is eager page splitting which will only request direct shadow
> pages (which can never be unsync).
> 
> Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> called to get an indirect shadow page with a NULL vCPU pointer, since
> zapping unsync SPs is a performance overhead that should be considered.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 04029c01aebd..21407bd4435a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
>  		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
>  
> -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			 struct list_head *invalid_list)
> +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> +			   struct kvm_mmu_page *sp,
> +			   struct list_head *invalid_list)
>  {
> -	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> +	int ret = -1;
> +
> +	if (vcpu_or_null)

This should never happen.  I like the idea of warning early, but I really don't
like that the WARN is far removed from the code that actually depends on @vcpu
being non-NULL. Case in point, KVM should have bailed on the WARN and never
reached this point.  And the inner __kvm_sync_page() is completely unnecessary.

I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
really help because understand why/when it's NULL.

I played around with casting, e.g. to/from an unsigned long or void *, to prevent
usage, but that doesn't work very well because 'unsigned long' ends up being
awkward/confusing, and 'void *' is easily lost on a function call.  And both
lose type safety :-(

All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
no real loss in robustness, e.g. we'd really have to screw up code review and
testing to introduce a null vCPU pointer dereference in this code.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d102522804a..5aed9265f592 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2041,6 +2041,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
                        goto out;

                if (sp->unsync) {
+                       /*
+                        * Getting indirect shadow pages without a vCPU pointer
+                        * is not supported, i.e. this should never happen.
+                        */
+                       if (KVM_BUG_ON(!vcpu, kvm))
+                               break;
+
                        /*
                         * The page is good, but is stale.  kvm_sync_page does
                         * get the latest guest state, but (unlike mmu_unsync_children)

