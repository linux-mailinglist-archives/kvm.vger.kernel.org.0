Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3C42F85E
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241381AbhJOQj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237264AbhJOQj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 12:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E79760C41;
        Fri, 15 Oct 2021 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634315840;
        bh=8LWLtU5MsDMIiCJt5B3N0eQ4f38xv5T64z+uouIjPqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuOWNW/9d/yILeOIudf6QnHudofjEwQbNvu+151t5rDkfsJZZP6Wa5K73Rj1uKFMl
         E6P0fObOfJeqdQOmNeXW52J1Cv5UIfJmAp/03B6jddkWmb+Zn0VhJjU/frzRVNIJ6I
         kB6FgdMo2poNmz93dlPi6LTyHxfdloclo2wgtp42/6jgT9oNpw/jD+IZMDqyVOconN
         AkFz8AdFTMi9yjvUw489D7OFO1wo2qC6UMZxUiBnpHRguS067sQFnmKVHYq2Ii9j8C
         SQb87pemf6gAoQLsvp3aGYYI4r0gBuHZdVMT0+1nTqFj36csFLDK0gKrRISwwbkT0Z
         LY7Vos8Ac1cwg==
Date:   Fri, 15 Oct 2021 09:37:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, torvic9@mailbox.org,
        Jim Mattson <jmattson@google.com>, llvm@lists.linux.dev
Subject: Re: [PATCH] KVM: x86: avoid warning with -Wbitwise-instead-of-logical
Message-ID: <YWmuPOB6/rXWqXBH@archlinux-ax161>
References: <20211015085148.67943-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015085148.67943-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 04:51:48AM -0400, Paolo Bonzini wrote:
> This is a new warning in clang top-of-tree (will be clang 14):
> 
> In file included from arch/x86/kvm/mmu/mmu.c:27:
> arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>         return __is_bad_mt_xwr(rsvd_check, spte) |
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                  ||
> arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning
> 
> Reported-by: torvic9@mailbox.org
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  arch/x86/kvm/mmu/spte.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index eb7b227fc6cf..32bc7268c9ea 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -314,9 +314,12 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>  	 * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
>  	 * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
>  	 * (this is extremely unlikely to be short-circuited as true).
> +	 *
> +	 * (int) avoids clang's "use of bitwise '|' with boolean operands"
> +	 * warning.
>  	 */
> -	return __is_bad_mt_xwr(rsvd_check, spte) |
> -	       __is_rsvd_bits_set(rsvd_check, spte, level);
> +	return (int)__is_bad_mt_xwr(rsvd_check, spte) |
> +	       (int)__is_rsvd_bits_set(rsvd_check, spte, level);
>  }
>  
>  static inline bool spte_can_locklessly_be_made_writable(u64 spte)
> -- 
> 2.27.0
> 
> 
