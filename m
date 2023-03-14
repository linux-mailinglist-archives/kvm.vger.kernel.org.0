Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D01E6BA390
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 00:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCNXdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 19:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCNXdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 19:33:32 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3648A75
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 16:33:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pa10-20020a17090b264a00b0023b4d15f656so1243238pjb.1
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 16:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678836811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2KvA3lMDim3CX0h+gsvpJ3uyyPCUJzwX07Qq5BQnRY=;
        b=KykLmoBx8cxRmOBFjmZK9EvA8XtwCX1z48cteOxHPDTXEl+uEHr6qphS/6cUJhx48R
         wdyWp/FmZCWorhsXsLrmUGAEHfWLN8vZdB/Di51l/ZZlwp8ByadbZfdENOcK1GCyZVu9
         P42UPB1x7g4RSy9U/MINEhMiD04IYQndoEwUkl8l2x8cviKOBUnKDCPRz/Ux8yIUiL1o
         qGHLC5P4n8Y+sUE8I47iPFNIDpZ4nilhUbL+FqAdCI5U4gOSiPIQCcx7UtXY5YdLK/hj
         lQHRsuyCgfP+RiFZq+/lZMiDQ/OqlyKfENIyUd51+pYwO5rYOa7DKiyN7UXTHxm5XgU5
         oaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678836811;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2KvA3lMDim3CX0h+gsvpJ3uyyPCUJzwX07Qq5BQnRY=;
        b=WWI0pKmchJnXWUqE3yAbnMy4ncgPKRGbZxN5hWx7CBbp0fK5nVJyRedQVQMg+dnl1a
         PXX++BPKgklRO9zAGRBUfMSc5ZpV25cI6Pj/o2FFD81vgUWNmFjXgGjLs77KwU7Hmyah
         U58JScnXyqWi6i+I00/4MZAZjqiwfE2q4ZVXQhe68mmk9jGjLCFFO+wqsuhsY07UxWDY
         QaIRvUfh5q38peSfm+nly6E5oFHmQbuOrUbCE5zFsQWaIgME1WhJ+Z5v4B9S8mG/rKLZ
         2FCTh4Q3USY3dUwFFtESAbW3ZC6TSPoI+qu1Nxtl0He9qwZrZvrZcuJU8sGlPwhNNztc
         k7aQ==
X-Gm-Message-State: AO0yUKXV01Zxa7g+yCiG3cKZ/APlcvegDpoekn5afDhdBsWdfbFujDEK
        2/Mt1uWvo3KIGIsCysBtwyRVqFYpNv4=
X-Google-Smtp-Source: AK7set9OkZRmMr5yow3vEBhqEnPgqzzXXAmJgrpyeF4oM2gj15NogK4Gr0ve/eJg78Ooz/XGgB+UPWVf6AE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:df93:b0:23d:4e9b:8f90 with SMTP id
 p19-20020a17090adf9300b0023d4e9b8f90mr520061pjv.4.1678836810895; Tue, 14 Mar
 2023 16:33:30 -0700 (PDT)
Date:   Tue, 14 Mar 2023 16:33:22 -0700
In-Reply-To: <20230127044500.680329-1-stevensd@google.com>
Mime-Version: 1.0
References: <20230127044500.680329-1-stevensd@google.com>
Message-ID: <ZBEEQtmtNPaEqU1i@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: replace kvm_vcpu_map usage in vmx
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> This series replaces the usage of kvm_vcpu_map in vmx with
> gfn_to_pfn_cache. See [1] for details on why kvm_vcpu_map is broken.
> 
> The presence of kvm_vcpu_map blocks another series I would like to
> try to merge [2]. Although I'm not familiar with the internals of vmx,
> I've gone ahead and taken a stab at this cleanup. I've done some manual
> testing with nested VMs, and KVM selftests pass, but thorough feedback
> would be appreciated. Once this cleanup is done, I'll take a look at
> removing kvm_vcpu_map from svm.

First off, thank you for writing this code and posting the series.  Seeing the
actual impact on the nVMX code was super helpful.  Second, this response is likely
going to be very critical, but the criticism is not directed at you, it's directed
at the existing mess in KVM.  On to the review...

I went fairly deep into review before coming to the conclusion that adding generic
support for mapping unpinned pages outside of the MMU is likely a waste of time
and effort, and will saddle KVM with a pile of complexity that has no real usage
outside of KVM selftests.

There are bugs all over the nVMX code in this series.  Some are due to subtleties
in nVMX that aren't super difficult to resolve, but many of them are because the
core gfn_to_pfn_cache code is half-baked.  E.g. KVM_REQ_OUTSIDE_GUEST_MODE is
completely useless as kicking the guest does absolutely nothing to guarantee KVM
refreshes the cache before re-entering the guest.  That's not too horrible to
solved, e.g. the gpc struct could be expanded to track the KVM request associated
with guest usage so that nVMX (and nSVM) could trigger KVM_REQ_GET_NESTED_STATE_PAGES.

But then nested_get_vmcs12_pages() becomes even more complex because only some of
the pages/pfns it manages are actually plugged into vmcs02.  E.g. the vmcs12 MSR
bitmap is read only at VM-Enter, what gets stuffed into vmcs02 is a KVM-allocated
bitmap.  Using kvm_vcpu_map() is purely an optimization+simplification that allows
KVM to use a common set of helpers for accessing MSR bitmaps, e.g. as opposed to
having to do a big pile of uaccesses or copy the entire bitmaps into kernel memory.
The PDPTRs, which aren't actually managed through a gpc cache, would also need to
be separated out.

More problems arise in the use of kvm_gpc_check().  In hindsight, not adding a
lockdep assertion that gpc->lock is held in kvm_gpc_check() is a glaring flaw.
vmx_get_nested_state_pages() and vmx_complete_nested_posted_interrupt() fail to
take the gpc->lock when checking the cache.  Again, not super difficult to resolve,
but the complexity continues to amount, especially when trying to reason about what
will happen if an invalidation occurs and sets KVM_REQ_GET_NESTED_STATE_PAGES while
vmx_get_nested_state_pages() is refreshing a cache (and thus has dropped gpc->lock).

Even more subtly broken is nested.pi_desc, which is snapshot from
vmx->nested.pi_desc_gpc.khva, but is not protected by the gpc stuff.  I honestly
don't even want to think about what vmx_get_nested_state_pages() would look like
if it were fully protected.

Lastly, the number of nasty, fatal bugs we had to fix in the KVM Xen code just to
get KVM usage of gfn_to_pfn_cache healthy doesn't exactly instill me with confidence
that stabilizing guest usage will be all rainbows and butterflies.

So, I propose that we scrap this series along with the entire concept of
KVM_GUEST_USES_PFN, and instead add an off-by-default module param (could be a
per-VM capability in the future if necessary) that controls whether or not
kvm_vcpu_map() is allowed to map non-refcounted memory.

AIUI, AWS cares about mapping arbitrary memory via kvm_vcpu_map(), but uses a
static setup and trusts userspace, at least to the extent where guarding against
userspace unmapping (or moving, etc.) memory that is mapped via kvm_vcpu_map() is
a non-goal.

And on the ChromeOS side, the use case doesn't require playing nice with
kvm_vcpu_map(), the goal is purely to allow mapping non-refcounted "struct page"
memory into the guest so that it can be accessed by a vGPU (or some oddball
pass-through GPU setup?).

Unless I'm missing something, that approach would even give us something that is
consumable for stable backports, e.g. I believe the diff at the bottom is all that
is needed to close the existing holes (feel free to suggest a less scary name).

Then the only thing David S. and company need to sort out for their GPU use case
is teaching KVM to do the right thing with non-refcounted struct page memory.
And I don't feel guilty for asking them to do that work because it's actually
germane to their use case, as opposed to fixing the nVMX/nSVM mess.

And if anyone comes along with a use for unmapping/migrating/swapping memory that
is plugged directly into vmcs02, they get to have the honor of adding support and
convincing everyone that it's worth maintaining.

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..c7669807cf73 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -93,6 +93,9 @@ unsigned int halt_poll_ns_shrink;
 module_param(halt_poll_ns_shrink, uint, 0644);
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 
+static bool allow_unsafe_kmap;
+module_param(allow_unsafe_kmap);
+
 /*
  * Ordering of locks:
  *
@@ -2838,7 +2841,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
                page = pfn_to_page(pfn);
                hva = kmap(page);
 #ifdef CONFIG_HAS_IOMEM
-       } else {
+       } else if (allow_unsafe_kmap) {
                hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
 #endif
        }
