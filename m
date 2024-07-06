Return-Path: <kvm+bounces-21063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 228339295D1
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 01:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FB071F21A1F
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 23:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E50113D888;
	Sat,  6 Jul 2024 23:13:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7478013790B;
	Sat,  6 Jul 2024 23:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720307589; cv=none; b=BOSOseEATi/NEXEKePNKkUw8tpY3D3BhPZ4JCTxadrjf6wsCVT2ieF1AseRFYeY54aiEF2PtbNVhRODbOGGiyiTWytcGkC7I/Cjm6VGbsne7aZRCfG2FYJ/ZrtUJz+igVIy8ZCuKnBGCWJoVYMDiGY9vMOb7wei61sAH8ySKK18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720307589; c=relaxed/simple;
	bh=+7Q38uJHrNsOYRaVMVxrspaOTQyWNxvjndN9JnzkfWg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nz5M2a1psRk/3xdqG/E6mA5dEZUbq4FXLm/T4mKpxgUACG8EZIbinHN7MGCT3LUDtU52NbG31klYizKXpdKw7yxRhHYVhUAXUHVnB2uLzx0elw5Q06bYaAKJMo//jIF/YL87x+OIAiDNJJWdlqXfTlJjzqQj2VRHLABrSisRqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WGmQ74gwWz4xQM;
	Sun,  7 Jul 2024 09:13:03 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com, alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com, Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, gbatra@linux.ibm.com, brking@linux.ibm.com, aik@ozlabs.ru, jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org, sanastasio@raptorengineering.com, linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org, msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com, jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
In-Reply-To: <171923268781.1397.8871195514893204050.stgit@linux.ibm.com>
References: <171923268781.1397.8871195514893204050.stgit@linux.ibm.com>
Subject: Re: [PATCH v4 0/6] powerpc: pSeries: vfio: iommu: Re-enable support for SPAPR TCE VFIO
Message-Id: <172030740409.964765.9717587564748516161.b4-ty@ellerman.id.au>
Date: Sun, 07 Jul 2024 09:10:04 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 24 Jun 2024 12:38:07 +0000, Shivaprasad G Bhat wrote:
> The patches reimplement the iommu table_group_ops for pSeries
> for VFIO SPAPR TCE sub-driver thereby bringing consistency with
> PowerNV implementation and getting rid of limitations/bugs which
> were emanating from these differences on the earlier approach on
> pSeries.
> 
> Structure of the patchset:
> -------------------------
> The first and fifth patches just code movements.
> 
> [...]

Applied to powerpc/next.

[1/6] powerpc/iommu: Move pSeries specific functions to pseries/iommu.c
      https://git.kernel.org/powerpc/c/b09c031d9433dda3186190e5845ba0d720212567
[2/6] powerpc/pseries/iommu: Fix the VFIO_IOMMU_SPAPR_TCE_GET_INFO ioctl output
      https://git.kernel.org/powerpc/c/6af67f2ddfcbbca551d786415beda14c48fb6ddf
[3/6] powerpc/pseries/iommu: Use the iommu table[0] for IOV VF's DDW
      https://git.kernel.org/powerpc/c/aed6e4946ed9654fc965482b045b84f9b9572bb8
[4/6] vfio/spapr: Always clear TCEs before unsetting the window
      https://git.kernel.org/powerpc/c/4ba2fdff2eb174114786784926d0efb6903c88a6
[5/6] powerpc/iommu: Move dev_has_iommu_table() to iommu.c
      https://git.kernel.org/powerpc/c/35146eadcb81d72153a1621f3cc0d5588cae19d3
[6/6] powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries
      https://git.kernel.org/powerpc/c/f431a8cde7f102fce412546db6e62fdbde1131a7

cheers

