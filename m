Return-Path: <kvm+bounces-58651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2586AB9A2F1
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5F761B25A10
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADF47305E2F;
	Wed, 24 Sep 2025 14:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="KMvi9Cx6"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9879F17A303;
	Wed, 24 Sep 2025 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.158.153.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723170; cv=none; b=kiD4iQ1ed8jCoXsxvclXS2LWbyCZJolnAWZiKmSYdcw4o4FL4OFvEvFOkpLVoRayrj4pGb7YrLg86DLpixNOp1oQ3g3vmBvSWYyW8R0WRgN5NONFPyDZhJxvI4jX4NADeuzLj1gIxc+fWHiw3NO/xKh7czQKzHFbsGajbsQFSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723170; c=relaxed/simple;
	bh=H99QDTEIlY+DDELnzVOKberX3exoJMAsICZA/wPsE5s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VcMB2UceVZAx7m6vWgR8JMVpHcEjI3ixUOkejobL/yrnzGEU6f+qHn4pH9rPCV6Dx9JB9WRrYCZaip+R6weiliPwWiuD5YVrIMqIuPwNRhgtnDfNji9RhPp/upnHuXzXhsdavR6k3ylVcVX8HnDv1gjMf/CkJ1WAbOIQFopfb9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=KMvi9Cx6; arc=none smtp.client-ip=18.158.153.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723169; x=1790259169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=38/mJ3wiOfJfNpSSHx+xaos5reN6f9BIE/olJW3PDIw=;
  b=KMvi9Cx6ivrY3OhrWJ/FRdvgRv98e5M6Ljw5cOrworE4Jad9RVDpYwyo
   VLv1XNvsJc1+sjIDqH0cVmI+0Id6IJ7Tq/OodU5SnM8avUBMv0rztm/OM
   /Eu4QRb/3lgFsB8/TVzO5U/0HXeNFslqCzc3TLRVuTz+F6UzC1SZHRX1Z
   FGkAeKyR/DawGA/831pPmCWct0Ul6ODeFgWTJ4utrK3BlmOQDAJzQbIhp
   ne1Aq4hh89ynhh/dsn9lslGAogLwyYVeh4pMZGsPoZutjWbctA4B2tKtb
   +L7OOtnUzIE+o44ZEmM2vyL6v00MEYNgOSrgYyQGZ+qXIXMopSJ3MiKLl
   w==;
X-CSE-ConnectionGUID: x/TRL3pHQZ67WB6qLR3e1Q==
X-CSE-MsgGUID: uA9D7gzeQn+A4SdIs9M2Xg==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2498795"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:12:36 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:18731]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id 1eb9aafd-c834-41b1-8ff1-e0a20105f74a; Wed, 24 Sep 2025 14:12:36 +0000 (UTC)
X-Farcaster-Flow-ID: 1eb9aafd-c834-41b1-8ff1-e0a20105f74a
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:12:36 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:12:32 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 5/7] vfio_pci_core: allow regions with no release op
Date: Wed, 24 Sep 2025 16:09:56 +0200
Message-ID: <20250924141018.80202-6-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow regions to not to have a release op. This could be helpful with
alias regions. These regions wouldn't need to implement release ops.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
With the initial implementnation purposed in this RFC, there is
nothing to release for the alias regions. I wasn't sure if we should
force regions to implement release ops, If this is the case then an
empty function might be the better solution here.
 drivers/vfio/pci/vfio_pci_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 78e18bfd973e5..04b93bd55a5c2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -605,7 +605,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	vdev->virq_disabled = false;
 
 	for (i = 0; i < vdev->num_regions; i++)
-		vdev->region[i].ops->release(vdev, &vdev->region[i]);
+		if (vdev->region[i].ops && vdev->region[i].ops->release)
+			vdev->region[i].ops->release(vdev, &vdev->region[i]);
 
 	vdev->num_regions = 0;
 	kfree(vdev->region);
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


