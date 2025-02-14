Return-Path: <kvm+bounces-38164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A6BA35E7A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 645DE3B1A7C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732E5264A64;
	Fri, 14 Feb 2025 13:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVLzYB0Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542677102;
	Fri, 14 Feb 2025 13:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538597; cv=none; b=m3Cdc4zeVx+u70uusoFAuVGvXIm6OfxkXdQepOXwn9QOISABRop3VTVh3uDJofVb/+3YK3oSUjPvCuOTFOPLLr+2oail+8NmNR722cTK9GcGq2bdsjZZjW0DouJptT5r2mUgj+M0zia/khwYf51l15f5fjq/QJ9Zf9mOuafiFd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538597; c=relaxed/simple;
	bh=Vrd2PQQb0NRk/ZiGaKxhtfp+UzgmaQxFr0hfRHPz/jA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fRB3xmd9kpYtnOzM5GqLCKxorlYKXPbLcxMLyclzVmNrnWQ0DHiwyB3eo9DNuNLtyR1oGlgPNjJSaeb7dd8Y5Xvi03ziIHUVmKummn6qMDgV1qocCVhxS3UQDf1vymQuZFzuMGOcYe2vzpCQN3IeL6tyWb7weLnUc7WSdariIfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVLzYB0Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09DAC4CED1;
	Fri, 14 Feb 2025 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739538596;
	bh=Vrd2PQQb0NRk/ZiGaKxhtfp+UzgmaQxFr0hfRHPz/jA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JVLzYB0YjKDsqbGXroz9+cez2JO7fR0RS7SHsaH5eDJmOdVWNfnCKMDRCBar09B5u
	 Yh8mTg8p+foaEAJ0FXtSZS89AGf9nhfuc3XfU+PgiNeOkDNZlmWU2s98a3VYU2x2r2
	 7g8es20LHJwJN/hsCYwYOcGlrWSusrghBjplTpPX3uXkDZp1zfnjoA5ASMTfgjfTbG
	 fchGumDOFK9rj94cLOOvuvOxppNeqC5Vjwi1sAYAAptVvg7bs76EO7PiNLgT3NZa/8
	 FI0KIZcHtjGusptXMZ8OViUe/JkAKIFhMydhW6UwaYjJO0d+oU8baonVXx9c5wsW1k
	 eWJqOrX5yOsbg==
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
Subject: Re: [PATCH v7 07/45] arm64: RME: Define the user ABI
In-Reply-To: <20250213161426.102987-8-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-8-steven.price@arm.com>
Date: Fri, 14 Feb 2025 18:39:45 +0530
Message-ID: <yq5aldu8wu3q.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

....

> +/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
> +struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +};
> +
> +/* FIXME: Update nr (0xd2) when merging */
> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd2, struct kvm_arm_rmm_psci_complete)
> +

This needs an update?

-aneesh

