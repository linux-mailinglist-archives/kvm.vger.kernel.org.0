Return-Path: <kvm+bounces-29476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 964009AC745
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560B728295D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 733D719F118;
	Wed, 23 Oct 2024 10:02:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EE519B5A7;
	Wed, 23 Oct 2024 10:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729677732; cv=none; b=EebaFK9sUAEZeRLjbp4LNoiJ21HCvdLKIYQv6+aSWufD92Gv99TE5H8Pzii8rdZFfLTZa5T65+RIbaSfxDcJXcOAeVykkZ702O0kK69udgvT3FcatnHZSCSKdiZvGpOKIRa/TnbMAEYbXfAEPVnEbJVOj1DIGpLAPB6bD6Mfhgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729677732; c=relaxed/simple;
	bh=VF72SbQafd1brM4nP5NE7TVxgFoirD5rMKb7ZQh2UMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ng71s0hBbQqrfkdT0olbSiQogpApppyJwUQOK5G2Wb4dQh7TSI6qeEvPw001by4xj80LJ52ZW7sPLjckuF87mrXwLnTzOSKPHyLBtKZMNOp4cb1YXlpGiHJfi7Yw7V0ofaAZ+enbqcsX3hUPVVRQn5eSrsgGdxBfPbM6+CnSazE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC1BC4CEC6;
	Wed, 23 Oct 2024 10:02:08 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Steven Price <steven.price@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v7 00/11] arm64: Support for running as a guest in Arm CCA
Date: Wed, 23 Oct 2024 11:02:06 +0100
Message-Id: <172967739783.1412028.8494484908145931121.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241017131434.40935-1-steven.price@arm.com>
References: <20241017131434.40935-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 17 Oct 2024 14:14:23 +0100, Steven Price wrote:
> This series adds support for running Linux in a protected VM under the
> Arm Confidential Compute Architecture (CCA). This is a minor update
> following the feedback from the v6 posting[1]. Thanks for the feedback!
> 
> Individual patches have a change log. The biggest changes are in patch
> 10 where Gavin gave some great feedback to tidy things up a bit.
> 
> [...]

Applied to arm64 (for-next/guest-cca), thanks!

Note that this branch cannot be tested in isolation as it doesn't have
the irqchip CCA changes. I pulled tip irq/core into the arm64
for-kernelci. Please give the latter branch a go (or linux-next when the
patches turn up).

[01/11] arm64: rsi: Add RSI definitions
        https://git.kernel.org/arm64/c/b880a80011f5
[02/11] arm64: Detect if in a realm and set RIPAS RAM
        https://git.kernel.org/arm64/c/c077711f718b
[03/11] arm64: realm: Query IPA size from the RMM
        https://git.kernel.org/arm64/c/399306954996
[04/11] arm64: rsi: Add support for checking whether an MMIO is protected
        https://git.kernel.org/arm64/c/371589437616
[05/11] arm64: rsi: Map unprotected MMIO as decrypted
        https://git.kernel.org/arm64/c/3c6c70613956
[06/11] efi: arm64: Map Device with Prot Shared
        https://git.kernel.org/arm64/c/491db21d8256
[07/11] arm64: Enforce bounce buffers for realm DMA
        https://git.kernel.org/arm64/c/fbf979a01375
[08/11] arm64: mm: Avoid TLBI when marking pages as valid
        https://git.kernel.org/arm64/c/0e9cb5995b25
[09/11] arm64: Enable memory encrypt for Realms
        https://git.kernel.org/arm64/c/42be24a4178f
[10/11] virt: arm-cca-guest: TSM_REPORT support for realms
        https://git.kernel.org/arm64/c/7999edc484ca
[11/11] arm64: Document Arm Confidential Compute
        https://git.kernel.org/arm64/c/972d755f0195

-- 
Catalin


