Return-Path: <kvm+bounces-60330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1E8BE95BD
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 72D494EEB39
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE76F20A5E5;
	Fri, 17 Oct 2025 14:55:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D19337107;
	Fri, 17 Oct 2025 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712910; cv=none; b=qZWp2zZKjlVrWxDAeblxXGyV+4oFx1wSN1nvS0EsTI+y3J8qxmE4otUyndc7EJ58once5vTZfB+TgeOkTuoGr4o0Jo6hhiqHzTy+vqDxjCvOP1122IwgqRDCBXzThEcekk3TPsGVVPzo9QRShcKA8NR2kqgJEVN2xJHeNnYRbLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712910; c=relaxed/simple;
	bh=Vp8HhGM8KTiB8jGFS7+z9LvVlE4Sj+m2pqa3oGGzWCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sBcCkYrHyoFPCTd6YZj8Pq+yYD8jsx00erVUZAuja1ttPoQE0+nYa1gei+5nZ36EvdtF677mmGhcIIevX2JeuZYn0WaREseR7bz7AJcPVmIRKUOGw2YJNnRATTEbZ//mmTfdC/xDeX3OjuUMO809VDhWjzM0h0V8RiNy5tYEPSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 522A7153B;
	Fri, 17 Oct 2025 07:55:00 -0700 (PDT)
Received: from [10.57.36.104] (unknown [10.57.36.104])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C9463F66E;
	Fri, 17 Oct 2025 07:55:03 -0700 (PDT)
Message-ID: <461fa23f-9add-40e5-a0d0-759030e7c70b@arm.com>
Date: Fri, 17 Oct 2025 15:55:01 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v11 00/42] arm64: Support for Arm CCA in KVM
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

v6.18-rc1 is out, so I've rebased and refreshed the series. Branches are
below:

kernel: https://gitlab.arm.com/linux-arm/linux-cca cca-host/v11
kvmtool: https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v9

However I'm not going to spam you all with the patches because there are
some significant changes that are still to be worked out which Marc has
pointed out (thanks for the review!). Specifically:

 * We've agreed that the uAPI should be more like "normal" KVM. So
   rather than expose the underlying operations (create RECs, init
   RIPAS, populate memory, activate), the VMM should set this up 'as
   normal' (but using the guestmem_fd capabilities to mark the memory
   private) and then on first vcpu run the realm should be configured,
   RIPAS set based on the memslots/guestmem_fd and any data written in
   the guestmem_fd populated into the realm.

   The upshot of which is that a VMM will require only minimal changes
   to support CCA, and the ordering requirements (for attestation of
   setting up the realm will be handled by KVM).

   Since this is a big change in the uAPI it's going to take a while to
   prototype and figure out all the details, so please bear with me
   while I work on an updated version.

 * There are issues with the PMU handling where the host is not provided
   with as much flexibility it should. For the PMU it's not possible for
   the host to maintain a PMU counter while the realm is executing. This
   means that sensible uses like getting an overflow interrupt on the
   cycle counter break with the use of a realm. This, however, will
   require a spec update to fix as the RMM will need to in some cases
   emulate the PMU registers.

 * The GIC handling is also more restrictive then it should be. Although
   the host is responsible for emulating the GIC, it is unable to set
   trap bits, restricting the host's ability to do this. There is
   concern that this could limit the ability to implement hardware
   workarounds in the future. Again a spec update is needed to fix this.

However, changes that you can see (in the branch) include:

 * Fixing the naming of various symbols. There were previously a lot of
   instances of "rme" in functions which were not directly related to
   the hardware extension. These are now renamed to "rmi" reflecting
   that they are part of the interface to the RMM.
   (This is the only change affecting kvmtool, although it is also
   binary compatible)

 * The code now checks with the hardware feature (RME) before probing
   for RMI.

 * There is now an allowlist for CAPs rather than individually disabling
   the ones known to be an issue with realms. (This also simplified the
   code, dropping one patch).

 * Fixes for the vgic handling: make sure the VGIC v4 state is
   synchronised and only populate valid lrs.

 * A few other minor updates from reviews, and some minor changes from
   rebasing.

Thanks,
Steve


