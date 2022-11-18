Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25362F898
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiKRPAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 10:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbiKRO7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:59:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A60B9ACAE;
        Fri, 18 Nov 2022 06:56:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 053D7B822F6;
        Fri, 18 Nov 2022 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A0CC433C1;
        Fri, 18 Nov 2022 14:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668783404;
        bh=kQqNwIRTX/hMdAUkbPpnbCbz6J1Qz8mIuBGg79EWriQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAcGcNO717vxcqR6gw7hPCPkskQj2wFxDzeuW9mROwlkdTfHvsj313IATnooRiuH7
         tggG//xkOzUdbhHJi9RH5nUHr7JyjuEL8To04GZkGxQ+NqDdJYuK0xU8yvqQm2SnY5
         Gv9xoQAQQwMXscRow5tS3mEG0waNLDXKKDfLUaCfkyCYxD/MDglLWUCFLE8+3Dp8iv
         0mSr5zAFkl6F8Wv3JRf0R4kjtOsD7JHBNfgBGcKygeKngjWkZ4TPuc+YarzIdVBPqn
         55sMg9/gLjLP2+8k17o7zmujzTy38yupQVAQHhdgtLRalXIq0dYP63UmSdSl8lUPu9
         OZ4b8PrPzo3Mg==
Date:   Fri, 18 Nov 2022 14:56:38 +0000
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC
 sub-ranges
Message-ID: <20221118145637.GC4624@willie-the-truck>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
 <20221110015327.3389351-3-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110015327.3389351-3-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Oliver,

On Thu, Nov 10, 2022 at 01:53:26AM +0000, Oliver Upton wrote:
> As the SMCCC (and related specifications) march towards an
> 'everything and the kitchen sink' interface for interacting with a
> system, it is less likely that KVM will implement every supported
> feature.
> 
> Add a capability that allows userspace to trap hypercall ranges,
> allowing the VMM to mix-and-match between calls handled in userspace vs.
> KVM.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 ++++
>  arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
>  arch/arm64/kvm/arm.c              | 10 +++++++
>  arch/arm64/kvm/hypercalls.c       | 48 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  1 +
>  5 files changed, 79 insertions(+)

[...]

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 6f0b56e7f8c7..6e8a222fc295 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -100,6 +100,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = 0;
>  		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
>  		break;
> +	case KVM_CAP_ARM_USER_HYPERCALLS:
> +		if (cap->args[0] & ~KVM_ARM_USER_HYPERCALL_FLAGS)
> +			return -EINVAL;

Why not use KVM_CAP_EXIT_HYPERCALL for this? At some point during pKVM
development, we used that to notify the VMM about memory being shared
back from the guest but we eventually dropped it as the notification to
userspace ended up not being needed:

https://android-kvm.googlesource.com/linux/+/dbd2861832dfc4c8a3103214b3c212ee7ace1c44%5E%21/
https://android-kvm.googlesource.com/linux/+/2a3afc6da99c0e0cb62be1687153ee572903aa80%5E%21/

I'm not saying that what we did was necessarily better, but it seems a bit
simpler and I figured it might be useful to point you to it.

Will
