Return-Path: <kvm+bounces-24802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD1B95ABEC
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 05:32:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9937728269F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 03:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6D91F959;
	Thu, 22 Aug 2024 03:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTUKwrig"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0931BC39;
	Thu, 22 Aug 2024 03:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724297533; cv=none; b=eH5TL2Fnpk/DA82lUK8HkMeMJeCyLNbtD03Xf2PTCQlzM1um6ZnLQrHtXpEdSaV7xAcDCePi09I5i2dmsc0VNAB+93xBfSN3o2wj2xFl0mW03Vc4VGST37orTM20qS5PAJgrw/Ljfqu+7WCpQwkS8+kGH4iT7JjaxpxtshCOO9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724297533; c=relaxed/simple;
	bh=EUR9oo2bOuT8CZglnOhT9XwulidBfPQJemFZwLJ8lIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mBRHN3vyRInHEuhsvRFHzSjqW1Hn6rHmRoyH7FQ6+4ksG6fBPtXo1Jfj8lB7GCBfGtecnEAY4FJKEu/CA7yQiEWJN1u+aUVRDUe4VjN73Y1nHuW9RbUoiyjPbHfVLnmwUCAKnsNskDdVd5y5FoQNqXElU+PfABJ7jymxn0wk/2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTUKwrig; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562F9C4AF09;
	Thu, 22 Aug 2024 03:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724297532;
	bh=EUR9oo2bOuT8CZglnOhT9XwulidBfPQJemFZwLJ8lIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DTUKwrigV+YgcDIMbKDEm9Ty3d/Fn5MQIDnW5D1v/J41f4yPWrk4t3DNP+bDZ/4M4
	 8OV9BJmuKmNRNMvDxOiRKWc1ZgsY8QagxXr6t6kn+iJUsFrrE55Fm6vzdMpHNh1uqY
	 lZohaPsRYfRFZzX8povg3J8rg7N366nF99+4XTBDBMSOmZzY/v2mGvZbaab9Pr0syS
	 uiwYWTVrlGZrChyUnzAKXb8p4rPNxc1NS9TCzi4u8kkow8wzfkz3OLUhOtbKZOf0n2
	 Et355enqRwY1Cz3wtgTWxOTVHeVbS72vjBv0auJkEGt3RRrPpavkcnf83hBDGZPqH2
	 ZtOV+cnMyxOiA==
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
Subject: Re: [PATCH v4 21/43] arm64: RME: Runtime faulting of memory
In-Reply-To: <20240821153844.60084-22-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-22-steven.price@arm.com>
Date: Thu, 22 Aug 2024 09:02:00 +0530
Message-ID: <yq5afrqx2pxr.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> At runtime if the realm guest accesses memory which hasn't yet been
> mapped then KVM needs to either populate the region or fault the guest.
>
> For memory in the lower (protected) region of IPA a fresh page is
> provided to the RMM which will zero the contents. For memory in the
> upper (shared) region of IPA, the memory from the memslot is mapped
> into the realm VM non secure.
>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>  * Avoid leaking memory if failing to map it in the realm.
>  * Correctly mask RTT based on LPA2 flag (see rtt_get_phys()).
>  * Adapt to changes in previous patches.
>

....

> -	gfn = ipa >> PAGE_SHIFT;
> +	gfn = (ipa & ~gpa_stolen_mask) >> PAGE_SHIFT;
>  	memslot = gfn_to_memslot(vcpu->kvm, gfn);
> +
> +	if (kvm_slot_can_be_private(memslot)) {
> +		ret = private_memslot_fault(vcpu, fault_ipa, memslot);
> +		if (ret != -EAGAIN)
> +			goto out;
> +	}
>

Shouldn't this be s/fault_ipa/ipa ?

	ret = private_memslot_fault(vcpu, ipa, memslot);

-aneesh

