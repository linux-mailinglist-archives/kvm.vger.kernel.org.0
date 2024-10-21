Return-Path: <kvm+bounces-29281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 728269A67A2
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 14:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CFC64B2276A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD8E61EE029;
	Mon, 21 Oct 2024 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TIPSoaVi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645AB1EBA1E
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512535; cv=none; b=TmaCLe1DeqMcd6dobs/ksxSrszmixCUm/gbf36/N1yj9zjwlAHtq8xEpOc2okGZFsfCy8DSCBVT4D9+SzaFD/CRsnIEW9bByXJSCtfejwcMuXWj9aB5Up0OorlPjDdBQfRsIlX4GAnZgHbNb/k+AkKd1Of7U7K330iQkOZSmQfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512535; c=relaxed/simple;
	bh=3bSMN63SS0O1JqxMVL2Km5ADBcS94qUikfjIm2ZiteY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b1AnECAIKosp5FyTVICl+XTPBc7nouRyRT7xYw1hU4EXAIbh4XjrA+dFifGfWCXyHv+0fWoABCstZvDKo8TThR+HHrtiRp3gi4SB18OJgDHKYEAIml1bknn8/wv+elMvTuL5NJ5J11wq2eBkWVVnfKaGSRxWAB6mBfCag5BoTAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TIPSoaVi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49L8P3dr001682;
	Mon, 21 Oct 2024 05:08:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=5NaK/CokaNbKYqs5HlYd8Jt
	Q1ROW7axkdLFpvxIYc08=; b=TIPSoaVif1Y+kjXiMyuZ4zobfe6RilXsYuMEUMM
	5wPeutaSBoLtrfaOwHjK+9TAKJWnUHr0vZLFfm/eKi1Zv0INAhteKkxelRPUpExK
	GT2CDOyggBbspOUK4XV2o5osx/Sy9g6EJ8Gw4+w0OqNtLaEndvi73ssHDOp5V+2c
	ZmeFw3PA6q+Ubqv2fYhgIrTjcql0DlHrLkFRblqNao6ddUjCE4NN90jnwXXrYOed
	F48wZTpP+DzVsF2fGl75XY2SQaFV4l9ABuW++a7h0Bk6h7VvR7yx3+FU8e4FZssf
	z7ANZVqCph6dLLK8aliFnFHY5dGWcPXZ4VW22ZzAjJI8hFQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42dke60dby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Oct 2024 05:08:42 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 21 Oct 2024 05:08:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 21 Oct 2024 05:08:40 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 4B1843F7052;
	Mon, 21 Oct 2024 05:08:38 -0700 (PDT)
From: Srujana Challa <schalla@marvell.com>
To: <virtualization@lists.linux.dev>, <kvm@vger.kernel.org>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <eperezma@redhat.com>,
        <ndabilpuram@marvell.com>, <jerinj@marvell.com>
Subject: [PATCH v3 0/2] vhost-vdpa: Add support for NO-IOMMU mode
Date: Mon, 21 Oct 2024 17:38:35 +0530
Message-ID: <20241021120837.1438628-1-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Qo4ARWR9KKoUMu5Lyqf9LpcM4rmK9peE
X-Proofpoint-ORIG-GUID: Qo4ARWR9KKoUMu5Lyqf9LpcM4rmK9peE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01

This patchset introduces support for an UNSAFE, no-IOMMU mode in the
vhost-vdpa driver. When enabled, this mode provides no device isolation,
no DMA translation, no host kernel protection, and cannot be used for
device assignment to virtual machines. It requires RAWIO permissions
and will taint the kernel.

This mode requires enabling the "enable_vhost_vdpa_unsafe_noiommu_mode"
option on the vhost-vdpa driver and also negotiate the feature flag
VHOST_BACKEND_F_NOIOMMU. This mode would be useful to get
better performance on specifice low end machines and can be leveraged
by embedded platforms where applications run in controlled environment.

First patch introduces a module parameter
"enable_vhost_vdpa_unsafe_noiommu_mode", while the second patch
introduces a feature flag VHOST_BACKEND_F_NOIOMMU to the vhost vdpa
driver to support NO-IOMMU mode.

This feature flag indicates to userspace that the driver can safely
operate in NO-IOMMU mode. If the flag is not present, userspace should
assume NO-IOMMU mode is unsupported and must not proceed.

v1->v2:
- Introduced new feature flag to vhost backend features for negotiating
  NO-IOMMU feature.
v1->v3:
- Resolved the sparse error reported by kernel test robot.

Srujana Challa (2):
  vhost-vdpa: introduce module parameter for no-IOMMU mode
  vhost-vdpa: introduce NO-IOMMU backend feature bit

 drivers/vhost/vdpa.c             | 39 +++++++++++++++++++++++++++++++-
 include/uapi/linux/vhost_types.h |  2 ++
 2 files changed, 40 insertions(+), 1 deletion(-)

-- 
2.25.1


