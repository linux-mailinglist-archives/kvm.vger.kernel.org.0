Return-Path: <kvm+bounces-53901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B7C8B19FE0
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6486716D869
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8ACE24DFE6;
	Mon,  4 Aug 2025 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="rRZ+h1lm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7533622D7B6
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304215; cv=none; b=fls1BgbcvqYLgdTme181Q2DRdvdA6pl2iYN78WEHnltXY2wSHlWmiATjepUZxDqJwRhlnY9M0uTvzJqcGEjK2nbYyzMMZ/UyoelMyVwqdk7Rb9SacUFsTVd/KE+1TNpi56wQf6ObocxL2H0QEct50epi7f2OC3oQ84hWudEQoss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304215; c=relaxed/simple;
	bh=QVPN/cIzACLoha8RDEpbhsQ21ZmwzpJKqlK9IGy/jTw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLJg1qk4hOB19etSp2LMpnGv32w/mXw3KDCBD95Yik2MfUz/sJPRuuP5QtzwcmoOz3aDcevzYi9YGoBYGPhY+l8xC2PdrsNojYpCGGgsUyZ3Rdv6JZI6rNoKYPIuMiludaJ9M657yz4DuGAy4dTieDvafHMgLTXQ7cZiNhe+Dno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=rRZ+h1lm; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304214; x=1785840214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uOknI3+8ZqNwHg09PWEsKGsL5o/6D14mz1AhqOms3bs=;
  b=rRZ+h1lmlBZyO7LCqtMTXh+VgUJ9SttvIR3Oa8sW/Y5ZJoHJsXYLk0xr
   E3P7Fia85MEkZSxCVlBtQU8a3TjzwW8wUgTRBsfL4kAjA3agwSccztCKP
   ExBGAVSRDZDhlf+ntEQY2leb5xiIbEAuv5D9Fv3pKuR34ejlVOTkd+8ai
   xJuG5VHyoxwhhU6LmXvrgTrCcYMFNVriJtSHWi24/iIgBo1K3mGuIgQeV
   MWT+jjJv1JvWdA4nFhxA4joi5maFd+dudrIoeRvbcqnZNuWf1QwBJM2p0
   w2xBixRvYZL18Uj94DBdoKNg7KI2eIZE/hk4r4VMj3FzJdjNjA8F/OJx3
   Q==;
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="542600111"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:43:33 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:62194]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.9.131:2525] with esmtp (Farcaster)
 id 4d1784df-074b-4d0b-ad00-b0b903c4d69c; Mon, 4 Aug 2025 10:43:31 +0000 (UTC)
X-Farcaster-Flow-ID: 4d1784df-074b-4d0b-ad00-b0b903c4d69c
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:43:31 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:43:28 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 7/9] vfio-pci: use the new vfio ops
Date: Mon, 4 Aug 2025 12:40:00 +0200
Message-ID: <20250804104012.87915-8-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D045UWA001.ant.amazon.com (10.13.139.83) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

changing vfio-pci vfio ops to use the new ioctl and mmap is enough to
make this migrated, and it gives a initial example of the migration of
vfio-pci devices.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 5ba39f7623bb7..73d3eded7f95d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -131,11 +131,11 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.release	= vfio_pci_core_release_dev,
 	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
-	.ioctl		= vfio_pci_core_ioctl,
+	.ioctl2		= vfio_pci_core_ioctl2,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read		= vfio_pci_core_read,
 	.write		= vfio_pci_core_write,
-	.mmap		= vfio_pci_core_mmap,
+	.mmap2		= vfio_pci_core_mmap2,
 	.request	= vfio_pci_core_request,
 	.match		= vfio_pci_core_match,
 	.bind_iommufd	= vfio_iommufd_physical_bind,
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


