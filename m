Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFA54A1CC
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243784AbiFMVvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiFMVvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:51:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8805E18B38;
        Mon, 13 Jun 2022 14:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A3C8614A3;
        Mon, 13 Jun 2022 21:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D2BC34114;
        Mon, 13 Jun 2022 21:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655157107;
        bh=DCjyDdz9XYX5R8qanr7z720XrBNBAxLhIEwjktiLU3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufD63Beez0sbUqWjHqSRuRzUM3wI+6aAZlh1bK20GbnupnMOR0wVBO/ywvRFxQ4ut
         6n4ABCHvgK9RZkoWgY1TMIBxnXndt4Msa2/NR4+ep30Wly+k1odvnzo6EMTAp6Np9W
         H+HCbf78dvTgeIw6kgtdy3Kavy+QJFRlNBN/62WkOXZ+AhnBW4HYft42wOzgJtSxV6
         qXE20pNb4cPUTyRdSgcpnpxgDsi1IehVvDQvJgbpkXpGEMWpFBnAAeUxp73fJK1iCl
         pSYpvVUqg/InWfwMOv5Z6h2XMeKe3s80Jxfs9UiIwGaHkit3iXD8IB6abzzjrmRUa/
         qCj4vll7VWYJQ==
Date:   Mon, 13 Jun 2022 14:51:45 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Tom Rix <trix@redhat.com>,
        kvm@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH] KVM: SVM: Hide SEV migration lockdep goo behind
 CONFIG_DEBUG_LOCK_ALLOC
Message-ID: <Yqexcdad6oghl8sv@dev-arch.thelio-3990X>
References: <20220613214237.2538266-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613214237.2538266-1-seanjc@google.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 13, 2022 at 09:42:37PM +0000, Sean Christopherson wrote:
> Wrap the manipulation of @role and the manual mutex_{release,acquire}()
> invocations in CONFIG_PROVE_LOCKING=y to squash a clang-15 warning.  When
> building with -Wunused-but-set-parameter and CONFIG_DEBUG_LOCK_ALLOC=n,
> clang-15 seees there's no usage of @role in mutex_lock_killable_nested()
> and yells.  PROVE_LOCKING selects DEBUG_LOCK_ALLOC, and the only reason
> KVM manipulates @role is to make PROVE_LOCKING happy.
> 
> To avoid true ugliness, use "i" and "j" to detect the first pass in the
> loops; the "idx" field that's used by kvm_for_each_vcpu() is guaranteed
> to be '0' on the first pass as it's simply the first entry in the vCPUs
> XArray, which is fully KVM controlled.  kvm_for_each_vcpu() passes '0'
> for xa_for_each_range()'s "start", and xa_for_each_range() will not enter
> the loop if there's no entry at '0'.
> 
> Fixes: 0c2c7c069285 ("KVM: SEV: Mark nested locking of vcpu->lock")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Compile tested only, still haven't figured out why SEV is busted on our
> test systems with upstream kernels.  I also haven't verified this squashes
> the clang-15 warning, so a thumbs up on that end would be helpful.

I can confirm that with the config that the kernel test robot provided,
the warning disappears with this patch. If it is useful:

Tested-by: Nathan Chancellor <nathan@kernel.org> # build

>  arch/x86/kvm/svm/sev.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 51fd985cf21d..309bcdb2f929 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1606,38 +1606,35 @@ static int sev_lock_vcpus_for_migration(struct kvm *kvm,
>  {
>  	struct kvm_vcpu *vcpu;
>  	unsigned long i, j;
> -	bool first = true;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (mutex_lock_killable_nested(&vcpu->mutex, role))
>  			goto out_unlock;
>  
> -		if (first) {
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (!i)
>  			/*
>  			 * Reset the role to one that avoids colliding with
>  			 * the role used for the first vcpu mutex.
>  			 */
>  			role = SEV_NR_MIGRATION_ROLES;
> -			first = false;
> -		} else {
> +		else
>  			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> -		}
> +#endif
>  	}
>  
>  	return 0;
>  
>  out_unlock:
>  
> -	first = true;
>  	kvm_for_each_vcpu(j, vcpu, kvm) {
>  		if (i == j)
>  			break;
>  
> -		if (first)
> -			first = false;
> -		else
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (j)
>  			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
> -
> +#endif
>  
>  		mutex_unlock(&vcpu->mutex);
>  	}
> 
> base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
> -- 
> 2.36.1.476.g0c4daa206d-goog
> 
> 
