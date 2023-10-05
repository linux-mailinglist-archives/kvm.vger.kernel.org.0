Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262167B99C7
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbjJEBwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbjJEBwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:52:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147C69E
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:52:15 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d8b2eec15d3so617562276.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470734; x=1697075534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=acQKbJZD+RcbWw3BnnpBc5Z7IgVcU3OSCyBSABN5PtQ=;
        b=JsSC2xjJQqA6vp/2WewCFSU5ObyXJs6bu2B1zo4ksz6V9RHlXY6sAPS+uuVIlNHFo5
         81IqivYJ1JNA3Ze/AHESWFMevzIv1lxJMngF5rDAf+TK7kpzS0PFx0R6TOM9q9X2jp62
         +ZS4IJBIfooTZAEAjpvpyRXIg8M/k8SoNE4WXNGFGprZ4yEzPK5uAbGaM+9uIR6ItVDu
         katsl2XPAQembhsxvYF8+65fdkYLCD6Hb9x19PKn4ldjnFfaCHVUIWeIUg5Lhf75Lnfs
         gb5NjiID+X+C/yovtcQcdNZIrt/CSZEChVuGU86YscOy3xw1AyEU/fPya++u5CYl9M2p
         sWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470734; x=1697075534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=acQKbJZD+RcbWw3BnnpBc5Z7IgVcU3OSCyBSABN5PtQ=;
        b=o9nPVl6WMR7KNZMcmqI/wXJGXWnhT/gWbpeOnxFFr0niZ1kPcFcrcng4K6qG/mnPoi
         I+h0gfFsfN/8egBK0QE/l6plf98mR71nnKqzp/voSZVdGA+UDRpYiF99TvQrFQ/uoAfs
         DETiY+cMubgrKR4eEas/F7YqLRrL0ns5d9HYRQaKMVYK3UjhaIlyaBJXojUyz3ZnaCPg
         YPiuAoQ9R87mJHqPirQZ3uUg/5oUmOFRE1zlLz5BwFJvyHUjm0yk+AUpZPLn4BYT4UZ9
         9DtnIJ+RvwgSlmu9rbVLlIfE5cd9snh0BedOxwP3so/28mNM5IMs9gud6yGBq+swHdX/
         kWjQ==
X-Gm-Message-State: AOJu0YxGw/tBE1bYizYI4UKX8/0kHangZVTGHEXtxkvCX/ZcZRZsaDDy
        KYVBTB6x9SPji9Ce5JB32ZkabzUG/+M=
X-Google-Smtp-Source: AGHT+IEyC/8z97IOmWK7ZeU1qdb5G7XIAtLDmWxMyLS8OggYv8wqS/qg9vyIFhJjSFP18hZDQ3v1opASl/8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:fe0a:0:b0:d78:215f:ba5f with SMTP id
 k10-20020a25fe0a000000b00d78215fba5fmr66372ybe.9.1696470734238; Wed, 04 Oct
 2023 18:52:14 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:52:12 -0700
In-Reply-To: <20230908222905.1321305-12-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-12-amoorthy@google.com>
Message-ID: <ZR4WzE1JOvq_0dhE@google.com>
Subject: Re: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
> already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

--verbose

> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  arch/x86/kvm/Kconfig           | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c2eaacb6dc63..a74d721a18f6 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7788,7 +7788,7 @@ error/annotated fault.
>  7.35 KVM_CAP_USERFAULT_ON_MISSING
>  ---------------------------------
>  
> -:Architectures: None
> +:Architectures: x86
>  :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
>  
>  The presence of this capability indicates that userspace may set the
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ed90f148140d..11d956f17a9d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -49,6 +49,7 @@ config KVM
>  	select INTERVAL_TREE
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
> +        select HAVE_KVM_USERFAULT_ON_MISSING


Hmm, I vote to squash this patch with

  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()

or rather, squash that code into this patch.  Ditto for the ARM patches.

Since we're making KVM_EXIT_MEMORY_FAULT informational-only for flows that KVM
isn't committing to supporting, I think it makes sense to enable the arch specific
paths that *need* to return KVM_EXIT_MEMORY_FAULT at the same time as the feature
that adds the requirement.

E.g. without HAVE_KVM_USERFAULT_ON_MISSING support, per the contract we are creating,
it would be totally fine for KVM to not use KVM_EXIT_MEMORY_FAULT for the page
fault paths.  And that obviously has to be the case since KVM_CAP_MEMORY_FAULT_INFO
is introduced before the arch code is enabled.

But as of this path, KVM *must* return KVM_EXIT_MEMORY_FAULT, so we should make
it impossible to do a straight revert of that dependency.  That should also help
with the changelogs, e.g. it'll give you a prompt for why only kvm_handle_error_pfn()
is getting treatment.
