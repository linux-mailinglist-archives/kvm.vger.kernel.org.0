Return-Path: <kvm+bounces-48406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37072ACDF57
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FADB165822
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A3328FFE6;
	Wed,  4 Jun 2025 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlAlwaCM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66FB33DF;
	Wed,  4 Jun 2025 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749044251; cv=none; b=oNTXDvVdU3mrib6CF/WyynhnNc9om2xQvs3+/URPLnTyd22ZC2BIYmRkhcU2oa4MWad0/Tq+aogI/1heOCRfkKjYmbfCZWVXmqzAyU2kXdo6RPwEodvktSPi0lNxOdSwPRsh2k1m3jx8/lI50Uai8bavBKQTJTkB4k3JlBF6pB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749044251; c=relaxed/simple;
	bh=LjylLgqkF7sXPvwM5QH3T3a2T3r7WcEDyImVKYKRfn0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D/g6elXLS+XvDg2y4MXowBFBdFdFDIKmePkRi3+RlbMd/kCe51R230Odz8QrGzpPLG4lIlRg+YHRKV6Z7T3tIVKGvJP0o3iCc0Wgtu3RDoPz4jm/zyAk3+36jJBnh8qEa/yG9OOwDAiZUo9h8IwaSrT8L6FIKDde2h6clYUj7j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlAlwaCM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6C5C4CEE7;
	Wed,  4 Jun 2025 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749044251;
	bh=LjylLgqkF7sXPvwM5QH3T3a2T3r7WcEDyImVKYKRfn0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mlAlwaCMs9tHjv6nEt7U+Ibg65b3CKJlPhs4lgVIQ1VKcvjCSAYuvfpS6hBIjw3OV
	 XQ8nvezt/8lN48FPFZnaaeJIhrV3+e2znePItViM9AaToBMfrO64NF1hBlaB1QvO6z
	 7z7MBsz2PgK1NDMFfsSxgSmZA49I1drxjPSJm2OqbmDUcdp5q8e2z3fTc3QtLqzj60
	 FMvKPAK09UXyZ9zGUdOOQOWfA/LvFF06aPr//yfBeeocNL+rWHokKBimR3tSr5zb+U
	 n5Po3J89DI/7AuC4qrESmIyKo8Bw3bZzX2U3Uds/QpUkap7crcVwBjgXNvjtoiQHDZ
	 UCS7+3qRu7fTw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	vivek.kasireddy@intel.com, yilun.xu@intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 19/30] vfio/pci: Add TSM TDI bind/unbind IOCTLs for
 TEE-IO support
In-Reply-To: <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-20-yilun.xu@linux.intel.com>
 <yq5aplfn210z.fsf@kernel.org> <aD24r44v0g1NgeZs@yilunxu-OptiPlex-7050>
Date: Wed, 04 Jun 2025 19:07:18 +0530
Message-ID: <yq5ajz5r8w6p.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Xu Yilun <yilun.xu@linux.intel.com> writes:

> On Sun, Jun 01, 2025 at 04:15:32PM +0530, Aneesh Kumar K.V wrote:
>> Xu Yilun <yilun.xu@linux.intel.com> writes:
>> 
>> > Add new IOCTLs to do TSM based TDI bind/unbind. These IOCTLs are
>> > expected to be called by userspace when CoCo VM issues TDI bind/unbind
>> > command to VMM. Specifically for TDX Connect, these commands are some
>> > secure Hypervisor call named GHCI (Guest-Hypervisor Communication
>> > Interface).
>> >
>> > The TSM TDI bind/unbind operations are expected to be initiated by a
>> > running CoCo VM, which already have the legacy assigned device in place.
>> > The TSM bind operation is to request VMM make all secure configurations
>> > to support device work as a TDI, and then issue TDISP messages to move
>> > the TDI to CONFIG_LOCKED or RUN state, waiting for guest's attestation.
>> >
>> > Do TSM Unbind before vfio_pci_core_disable(), otherwise will lead
>> > device to TDISP ERROR state.
>> >
>> 
>> Any reason these need to be a vfio ioctl instead of iommufd ioctl?
>> For ex: https://lore.kernel.org/all/20250529133757.462088-3-aneesh.kumar@kernel.org/
>
> A general reason is, the device driver - VFIO should be aware of the
> bound state, and some operations break the bound state. VFIO should also
> know some operations on bound may crash kernel because of platform TSM
> firmware's enforcement. E.g. zapping MMIO, because private MMIO mapping
> in secure page tables cannot be unmapped before TDI STOP [1].
>
> Specifically, for TDX Connect, the firmware enforces MMIO unmapping in
> S-EPT would fail if TDI is bound. For AMD there seems also some
> requirement about this but I need Alexey's confirmation.
>
> [1] https://lore.kernel.org/all/aDnXxk46kwrOcl0i@yilunxu-OptiPlex-7050/
>

According to the TDISP specification (Section 11.2.6), clearing either
the Bus Master Enable (BME) or Memory Space Enable (MSE) bits will cause
the TDI to transition to an error state. To handle this gracefully, it
seems necessary to unbind the TDI before modifying the BME or MSE bits.

If I understand correctly, we also need to unmap the Stage-2 mapping due
to the issue described in commit
abafbc551fddede3e0a08dee1dcde08fc0eb8476. Are there any additional
reasons we would want to unmap the Stage-2 mapping for the BAR (as done
in vfio_pci_zap_and_down_write_memory_lock)?

Additionally, with TDX, it appears that before unmapping the Stage-2
mapping for the BAR, we should first unbind the TDI (ie, move it to the
"unlock" state?) Is this step related Section 11.2.6 of the TDISP spec,
or is it driven by a different requirement?

-aneesh

