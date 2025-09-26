Return-Path: <kvm+bounces-58861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E87BA36CE
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:03:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91A84624F61
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2856C2F546D;
	Fri, 26 Sep 2025 11:03:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824BD2F4A00;
	Fri, 26 Sep 2025 11:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884590; cv=none; b=Ds2GRo1FZTxGL6cBFQLMzGfr2AqEo/NhACfz9YivcGxprE94laJdnWzz1Isl7ffN7O4KDjiTwD4HBhu7/UTdjhtDtLgXCjeY7euMQfrp61cfd5J2xWO7Osp0Sa5/85+LF9k0CIBO1b1/tVIisJ2li3TBUWHy5SqlsWB9xLL3yT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884590; c=relaxed/simple;
	bh=I3zdDiLpb1/S8WfIi/oX2seJwOqM7GqHkmoX3rtHv30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=joVCDkzvqO4C9za0/g6l77ExUUsNTlyig+Bmh9grEYPCagxVr/UIlK2Pfc5Ij3zNAkKw3NKUwZkhvFYvNnD38b5hfak8ObvQf4v1COgCXqtAyDeeZ4MRXpYvejEB32CzRKCeZOAwBUGLKLnX8N3UCsme1W/m2/5RLtMZE0UQ0gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A90E01655;
	Fri, 26 Sep 2025 04:02:59 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 878073F66E;
	Fri, 26 Sep 2025 04:03:03 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 0/5] Arm CCA planes support
Date: Fri, 26 Sep 2025 12:02:49 +0100
Message-ID: <20250926110254.55449-1-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Arm CCA (Confidential Compute Architecture) RMM version 1.1
specification[1] adds support for a concept of "planes". This allows a
realm to be divided into multiple execution environments with memory
separation between them (while still sharing the same IPA to PA
translations). There's an overview on the Arm website[2].

The TF-RMM project[3] recently merged support for planes to their "main"
branch and this an early preview of the corresponding Linux changes to
support the feature. Note you need to enable the (experimental) RMM_V1_1
configuration option to enable this feature.

This series is based on the v10 posting of the CCA host support
series[4] and is also available as a git tree:

  https://gitlab.arm.com/linux-arm/linux-cca.git/ cca/planes/rfc-v1

A hacked up version of kvmtool to launch a realm guest with an extra
plan is available here:

  https://gitlab.arm.com/linux-arm/kvmtool-cca.git/ cca/planes/rfc-v1

Note:
   The kvmtool support is a hack - it simply (unconditionally) enables a
   single extra plane (for a total of two planes: P0 and P1). This
   should obviously be a configuration option and should support other
   numbers of planes. But it gives an easy way of testing the support
   for auxiliary RTTs while running a single guest image (i.e. leaving
   P1 empty).

This series was written against the RMM v1.1 alp14 specification. Those
who are following things closely will know we're up to alp16, however
there are no major changes affecting planes between these two versions.
The spec is still alpha, so there may well be changes in the future.

[1] https://developer.arm.com/-/cdn-downloads/permalink/Architectures/Armv9/DEN0137_1.1-alp14.zip
[2] https://developer.arm.com/documentation/den0125/400/Arm-CCA-Extensions#md239-arm-cca-extensions__realm-planes
[3] https://www.trustedfirmware.org/projects/tf-rmm/
[4] https://lore.kernel.org/r/20250820145606.180644-1-steven.price%40arm.com

Steven Price (5):
  arm64: RME: Add SMC definitions introduced in RMM v1.1
  arm64: RME: Handle auxiliary RTT trees
  arm64: RME: Support RMI_EXIT_S2AP_CHANGE
  arm64: rme: Allocate AUX RTT PGDs and VMIDs
  arm64: RME: Support num_aux_places & rtt_tree_pp realm parameters

 arch/arm64/include/asm/kvm_rme.h  |   13 +-
 arch/arm64/include/asm/rmi_cmds.h | 1104 +++++++++++++++++++++++++++--
 arch/arm64/include/asm/rmi_smc.h  |  121 +++-
 arch/arm64/include/uapi/asm/kvm.h |   12 +
 arch/arm64/kvm/mmu.c              |   15 +-
 arch/arm64/kvm/rme-exit.c         |   33 +-
 arch/arm64/kvm/rme.c              |  441 +++++++++++-
 7 files changed, 1618 insertions(+), 121 deletions(-)

-- 
2.43.0


