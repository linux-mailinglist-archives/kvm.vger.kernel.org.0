Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF674C19E6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243402AbiBWR2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiBWR2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9966A47388;
        Wed, 23 Feb 2022 09:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C620B8210A;
        Wed, 23 Feb 2022 17:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDDCC340E7;
        Wed, 23 Feb 2022 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645637273;
        bh=BZ72Cv96SDULoZqRBhdwvA8X1c4BIfcsSZ5Rny2PuLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQmygXJJt2g54V+d9trXkiWWQ7HNa3uYnsgmfTn6/B4dZ5SMh4YaGrrt7GRNds8ZH
         ca94NfYv9xzDeUgKAYn/mqUPhvs9wEgDQiy99FDhAToFjjXygK6KA5tHDwXET17R8J
         hnpD2jrwkrz1jh5ZXtC8WX04Ts76+WfixivAPUt+DFgzd1sW4Gi3qmGOwnloxEyMJM
         E5LK4j8dUD6tK9xdFNsM8ZvmzDx4RmaQuNGu9DESaHaqoN7eYNMs1kIN2Iufkwdv0V
         xaCpPFNhNQWPQyVz1MncyaBU8arQl/1WA01U6Cjjr0wmX/xgLJqjIsNYfMbilN4xLd
         5fsrqlEinDLPg==
Date:   Wed, 23 Feb 2022 10:27:47 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Fix pointer mistmatch warning when patching
 RET0 static calls
Message-ID: <YhZuk8eA6rsDuJkd@dev-arch.archlinux-ax161>
References: <20220223162355.3174907-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223162355.3174907-1-seanjc@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Wed, Feb 23, 2022 at 04:23:55PM +0000, Sean Christopherson wrote:
> Cast kvm_x86_ops.func to 'void *' when updating KVM static calls that are
> conditionally patched to __static_call_return0().  clang complains about
> using mismatching pointers in the ternary operator, which breaks the
> build when compiling with CONFIG_KVM_WERROR=y.
> 
>   >> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch
>   ('bool (*)(struct kvm_vcpu *)' and 'void *') [-Wpointer-type-mismatch]
> 
> Fixes: 5be2226f417d ("KVM: x86: allow defining return-0 static calls")
> Reported-by: Like Xu <like.xu.linux@gmail.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thank you for the patch! Is this a bug in clang? I ended up creating a
small reproducer in case we need to file a bug with clang upstream:

https://godbolt.org/z/P7nEdzejE

This does shut up the warning and I can still spawn guests on my AMD and
Intel systems so:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 713e08f62385..f285ddb8b66b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1547,8 +1547,8 @@ static inline void kvm_ops_static_call_update(void)
>  	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
>  #define KVM_X86_OP_OPTIONAL __KVM_X86_OP
>  #define KVM_X86_OP_OPTIONAL_RET0(func) \
> -	static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
> -			   (void *) __static_call_return0);
> +	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
> +					   (void *)__static_call_return0);
>  #include <asm/kvm-x86-ops.h>
>  #undef __KVM_X86_OP
>  }
> 
> base-commit: f4bc051fc91ab9f1d5225d94e52d369ef58bec58
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
