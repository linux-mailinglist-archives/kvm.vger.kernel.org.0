Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EF3DF198
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbhHCPck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 11:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236801AbhHCPcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 11:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D53C60EC0;
        Tue,  3 Aug 2021 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628004748;
        bh=NFlhqOplTZXAI0Dyb+KjHTbgLHGA5lnFEt+p2z6v+iM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMjfeRMxIT3SvO+bti5OjoKO6PpmEsNLCtlzo44iZnfZsZofDvb7xoPDD4mkX4OJ+
         Vn1gECcUm5dFIKbOty+raoD0bQ2mGIpg0mn2LhKlxihBKhFQHpf/Wa+04Lhcun2RV9
         +jLyYBAEyDfgAZcWaCKrrOB5xsYz/SLLNIhSI2PZqCefhYdhJIPa43GLPh6pd9Fpcl
         lvrLTNw2bXyyb4O3A4EgZi+Ca9VP56F2sajgBUbOlye7o/a7IwSNtvu4yxNafAnO81
         32FjyCa5SeOQJFqM1E8kSYM4HddZQ6G4LUIiTEVCwLS4gYLq3hh8bKATjTG26qsYPO
         IvChdLdqlxrtw==
Date:   Tue, 3 Aug 2021 16:32:22 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 10/15] KVM: arm64: Guest exit handlers for nVHE hyp
Message-ID: <20210803153222.GB31125@willie-the-truck>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-11-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-11-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:41PM +0100, Fuad Tabba wrote:
> Add an array of pointers to handlers for various trap reasons in
> nVHE code.
> 
> The current code selects how to fixup a guest on exit based on a
> series of if/else statements. Future patches will also require
> different handling for guest exists. Create an array of handlers
> to consolidate them.
> 
> No functional change intended as the array isn't populated yet.
> 
> Acked-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 35 ++++++++++++++++++++
>  2 files changed, 78 insertions(+)

Definitely keep my Ack on this, but Clang just chucked out a warning due to:

> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a0e78a6027be..5a2b89b96c67 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);
> +
> +exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);

and:

> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 86f3d6482935..36da423006bd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -158,6 +158,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
>  		write_sysreg(pmu->events_host, pmcntenset_el0);
>  }
>  
> +typedef int (*exit_handle_fn)(struct kvm_vcpu *);

Which leads to:

arch/arm64/kvm/hyp/nvhe/switch.c:189:15: warning: redefinition of typedef 'exit_handle_fn' is a C11 feature [-Wtypedef-redefinition]
typedef int (*exit_handle_fn)(struct kvm_vcpu *);
              ^
./arch/arm64/kvm/hyp/include/hyp/switch.h:416:15: note: previous definition is here
typedef int (*exit_handle_fn)(struct kvm_vcpu *);
              ^
1 warning generated.

So I guess just pick your favourite?

Will
