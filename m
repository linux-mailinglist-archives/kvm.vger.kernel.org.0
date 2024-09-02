Return-Path: <kvm+bounces-25652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EF7967EB2
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 07:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9962A28220F
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 05:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74B514F132;
	Mon,  2 Sep 2024 05:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+cRk6C+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BF436D;
	Mon,  2 Sep 2024 05:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725254036; cv=none; b=RYWn/s+43h4xiPJN+MMC2cT00Oy4hP4hYhlg0V+KnNj0K1HU4BG5GgGfbUgLROiJtN0FoVMbhITR0Vwiti5ylw7Z7RkpuEOy0ZesUYD547H1I1s6XhT0unrOYiOUJq0Gy6Y6+xf4sWAl3ni3EnpkPLwN4qI4vrsOMsMJaNw5WfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725254036; c=relaxed/simple;
	bh=TPpkqPR8V96Q4pNrawsjjZ2uf1OIDvvR3Rbrdkwd92U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LvjCSq+RUS/Vrw1oueLSZ3hL7YL7njxa3YWl8kV7Zpy027N/jH4c+A591PeK4fR4uw6JJeLMy7Iqa/B8IOtTxtheMDmC4jfx+Gw6J/KBu7xChzkcuZI8Z7XR5ayYd7V+74BcszsgsN//rgo3J9IeBSijedgL6OP+8P0ALwfXWM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+cRk6C+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27587C4CEC2;
	Mon,  2 Sep 2024 05:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725254035;
	bh=TPpkqPR8V96Q4pNrawsjjZ2uf1OIDvvR3Rbrdkwd92U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F+cRk6C+jqe45JXc4w0ECr/xyLVyKeWB5ttckCESjF9gnaHUrOZIp8Cmy+ADMZKhT
	 tvJ/Mj1jcRGsNTD2I3ilGlwKnBJxhytLCKBTOL88ChzM/p4dk4bFnL1IXmikmLOPpg
	 IKe0ZuJqsVLJ4gssWyapKhx+alqZeAa0cJUFNn7R6ydE3J8Y8b6om477nBFwLlQFNF
	 u7856rqq+XyEfM7IHFLpz/kGK3C49BoRt829dJs7gXtEVGT0Fr6Z2lKet8BsO/OX9g
	 Gf8EslHcIoX9C/L3qe+ov4ALSnSN/wERdqmBqy5UEgkJugvvdXRHwRF3SmeLUr59/C
	 Mfrf3Gj2qRKdA==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v4 43/43] KVM: arm64: Allow activating realms
In-Reply-To: <20240821153844.60084-44-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-44-steven.price@arm.com>
Date: Mon, 02 Sep 2024 10:43:43 +0530
Message-ID: <yq5afrqieiyg.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> Add the ioctl to activate a realm and set the static branch to enable
> access to the realm functionality if the RMM is detected.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 9f415411d3b5..1eeef9e15d1c 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -1194,6 +1194,20 @@ static int kvm_init_ipa_range_realm(struct kvm *kvm,
>  	return realm_init_ipa_state(realm, addr, end);
>  }
>  
> +static int kvm_activate_realm(struct kvm *kvm)
> +{
> +	struct realm *realm = &kvm->arch.realm;
> +
> +	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
> +		return -EINVAL;
> +
> +	if (rmi_realm_activate(virt_to_phys(realm->rd)))
> +		return -ENXIO;
> +
> +	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
> +	return 0;
> +}
> +
>  /* Protects access to rme_vmid_bitmap */
>  static DEFINE_SPINLOCK(rme_vmid_lock);
>  static unsigned long *rme_vmid_bitmap;
> @@ -1343,6 +1357,9 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  		r = kvm_populate_realm(kvm, &args);
>  		break;
>  	}
> +	case KVM_CAP_ARM_RME_ACTIVATE_REALM:
> +		r = kvm_activate_realm(kvm);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> @@ -1599,5 +1616,5 @@ void kvm_init_rme(void)
>  	if (rme_vmid_init())
>  		return;
>  
> -	/* Future patch will enable static branch kvm_rme_is_available */
> +	static_branch_enable(&kvm_rme_is_available);
>

like rsi_present, we might want to use this outside kvm, ex: for TIO.
Can we move this outside module init so that we can have a helper
like is_rme_supported()


-aneesh

