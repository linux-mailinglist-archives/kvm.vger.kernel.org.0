Return-Path: <kvm+bounces-17551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEFF8C7BAC
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 19:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA8B51C22174
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 17:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5FF154BF0;
	Thu, 16 May 2024 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EU15gqy6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6051A2C07
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715881722; cv=none; b=q4MHY7mhaugPAeygENKUfcUWp+eQ82jJniRVAJcACpEieMP0Oaic9wTAXjOZ3e97LyQ/R4NNqQllFfLxtMGj9eYKNDYgx3YLxU7bXgZNhRmCXWNK2lysbyrSMhP+UJk8tkD3Vhmdr4hG0o0sFdWNfC1e6BcWWl8j0dHhN3ixGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715881722; c=relaxed/simple;
	bh=PsO3dmGqBhOQcVBpXuoK2/zWeVAcoyGLItKzca/FWEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CfC486ClPkJ0NoXo9UFAHh7/45b0r0yoyiHHZFvIGFhAt/C4ercOUptNIYu1gcTbXhTRGGDyhXdPw1whmpp5QP4FYU1flOgr9nrvU5QyUQqGIA1QgMjrlzBObfFXMVe2J+1fm1xdlLC7PDtZCa69yttkgehb9MbSYaH3W+FJvRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EU15gqy6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715881719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jx1NcIAeCnZ7Owj1g2GxNB8lwJB0yMEmi/V/YRlxOqI=;
	b=EU15gqy6peZEgzw1bWfVBU7M1WMA4WdO0mrxpI0EyDU4CRX9IgBT/ICSDOuPYBr49Raxd2
	rIBnAIcr+/PTzLBkTFOp29icdplchBLUYDi/eTpaJ5nV2QtDCdQN9pANsniUgK9rnBDvG3
	W0McT7u3hYyOH+1JoIGScrd/nTPg2Zk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-EYmceYFsN5OkAyCBVfQaow-1; Thu, 16 May 2024 13:48:36 -0400
X-MC-Unique: EYmceYFsN5OkAyCBVfQaow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EED8A80028D;
	Thu, 16 May 2024 17:48:35 +0000 (UTC)
Received: from omen.lan (unknown [10.22.18.88])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B312F6BC0;
	Thu, 16 May 2024 17:48:35 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH] vfio/pci: Restore zero affected bus reset devices warning
Date: Thu, 16 May 2024 11:48:30 -0600
Message-ID: <20240516174831.2257970-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Yi notes relative to commit f6944d4a0b87 ("vfio/pci: Collect hot-reset
devices to local buffer") that we previously tested the resulting
device count with a WARN_ON, which was removed when we switched to
the in-loop user copy in commit b56b7aabcf3c ("vfio/pci: Copy hot-reset
device info to userspace in the devices loop").  Finding no devices in
the bus/slot would be an unexpected condition, so let's restore the
warning and trigger a -ERANGE error here as success with no devices
would be an unexpected result to userspace as well.

Suggested-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d8c95cc16be8..80cae87fff36 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1281,6 +1281,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	if (ret)
 		return ret;
 
+	if (WARN_ON(!count)) /* Should always be at least one */
+		return -ERANGE;
+
 	if (count > (hdr.argsz - sizeof(hdr)) / sizeof(*devices)) {
 		hdr.count = count;
 		ret = -ENOSPC;
-- 
2.44.0


