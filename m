Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B97590741
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiHKUMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 16:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiHKUMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 16:12:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF80E9926C
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 13:12:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so6161600pjl.0
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 13:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=J6XJTtC/0ZZznXds9lO5+FIfn1/ZZY6xTpOd5utreKU=;
        b=WTapKI2wdWL9/IeH/nDGI9PBvCMzF7oKPrrHKxKfIf/OREqtcHKiTD0YN2Er/sukD7
         SRMXM8koRrze0x1MfzbbS47TcAEey9HQiA4LpdxNSrR9Ot81wTj9aj+L+4q8fp7qUWPm
         XF26K6/w1ppXhOR3adrhkipkqOvGE94mF2di/EGoQf0D6Y4GtMlzsBNKJCIZ1pypfa6V
         9rDiJUYVcDvW8t8CbNlZ9TvQs+bw3EBcax4AJRKAMP32hbhZmT+GVGG7vFsd/HxVoVM9
         h6X1mY70Dxak9fiX2chYgvfgzki8PoM4ZWLE/OCpWLPKiI/IukFx1g3xqWaaea85A291
         SXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=J6XJTtC/0ZZznXds9lO5+FIfn1/ZZY6xTpOd5utreKU=;
        b=u71xBZs3JdkGhpaDwqN49ceDlsAnMPOonhGWQgzai+tC3HHxS1OxM4diA/B2uHmQ3v
         S5c1jTrZmJYa6494GcN48IAG3kQS1C9bU+HWTgszdSYU5a+jg75CtYbHZtDt82d7ZHwj
         EUARYzCngCfT8nFs4RZndjMrP5mNZA1OFuqaSQ9H+ozoKCGt/BEayXd6Ygo8hjonejP7
         +wN2+LU+K8sMT0P2t6slhFk9uv8nA3HWz2watjxwNXq1L9XodAzCRbpuOAk8OeJpkAcH
         BnsPmEWgtyArqFGnl4lMTyOn/dTdtOtML9P5dmCIi/ZZtGLGNjZrGKw4tVAaGkrdEfn1
         zBWg==
X-Gm-Message-State: ACgBeo21p20NzKkKV7Gfp9tRiwTCTGqniSqYahnQwFiBFA1mF3MTetIr
        dBLZwrEOtRD+rbRj58gGgbsbJg==
X-Google-Smtp-Source: AA6agR5fvGG4iLPirmWk6yFAFl2p9rQ7RnkfVpD9XaxEXeYVv/sCb+r3A8GOKBakrsGU/A3D+/pQ+w==
X-Received: by 2002:a17:90a:fe9:b0:1f5:c9c:72bf with SMTP id 96-20020a17090a0fe900b001f50c9c72bfmr10190076pjz.69.1660248762210;
        Thu, 11 Aug 2022 13:12:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v11-20020a17090a00cb00b001f50e4c43c4sm4066347pjd.22.2022.08.11.13.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 13:12:41 -0700 (PDT)
Date:   Thu, 11 Aug 2022 20:12:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] kvm/x86: Allow to respond to generic signals
 during slow page faults
Message-ID: <YvVitqmmj7Y0eggY@google.com>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721000318.93522-4-peterx@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Peter Xu wrote:
> All the facilities should be ready for this, what we need to do is to add a
> new "interruptible" flag showing that we're willing to be interrupted by
> common signals during the __gfn_to_pfn_memslot() request, and wire it up
> with a FOLL_INTERRUPTIBLE flag that we've just introduced.
> 
> Note that only x86 slow page fault routine will set this to true.  The new
> flag is by default false in non-x86 arch or on other gup paths even for
> x86.  It can actually be used elsewhere too but not yet covered.
> 
> When we see the PFN fetching was interrupted, do early exit to userspace
> with an KVM_EXIT_INTR exit reason.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/arm64/kvm/mmu.c                   |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
>  arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++++++--
>  include/linux/kvm_host.h               |  4 ++--
>  virt/kvm/kvm_main.c                    | 30 ++++++++++++++++----------
>  virt/kvm/kvm_mm.h                      |  4 ++--
>  virt/kvm/pfncache.c                    |  2 +-
>  8 files changed, 41 insertions(+), 21 deletions(-)

I don't usually like adding code without a user, but in this case I think I'd
prefer to add the @interruptible param and then activate x86's kvm_faultin_pfn()
in a separate patch.  It's rather difficult to tease out the functional x86
change, and that would also allow other architectures to use the interruptible
support without needing to depend on the functional x86 change.

And maybe squash the addition of @interruptible with the previous patch?  I.e.
add all of the infrastructure for KVM_PFN_ERR_SIGPENDING in patch 2, then use it
in x86 in patch 3.

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 17252f39bd7c..aeafe0e9cfbf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  			       unsigned int access)
>  {
> +	/* NOTE: not all error pfn is fatal; handle sigpending pfn first */
> +	if (unlikely(is_sigpending_pfn(fault->pfn))) {

Move this into kvm_handle_bad_page(), then there's no need for a comment to call
out that this needs to come before the is_error_pfn() check.  This _is_ a "bad"
PFN, it just so happens that userspace might be able to resolve the "bad" PFN.

> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> +		++vcpu->stat.signal_exits;
> +		return -EINTR;

For better or worse, kvm_handle_signal_exit() exists and can be used here.  I
don't love that KVM details bleed into xfer_to_guest_mode_work(), but that's a
future problem.

I do think that the "return -EINTR" should be moved into kvm_handle_signal_exit(),
partly for code reuse and partly because returning -EINTR is very much KVM ABI.
Oof, but there are a _lot_ of paths that can use kvm_handle_signal_exit(), and
some of them don't select KVM_XFER_TO_GUEST_WORK, i.e. kvm_handle_signal_exit()
should be defined unconditionally.  I'll work on a series to handle that separately,
no reason to take a dependency on that cleanup.

So for now,

static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
{
	if (pfn == KVM_PFN_ERR_SIGPENDING) {
		kvm_handle_signal_exit(vcpu);
		return -EINTR;
	}

	...
}
