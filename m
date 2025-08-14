Return-Path: <kvm+bounces-54674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 764C0B26B48
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 17:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09C88AA2BF9
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE7023815C;
	Thu, 14 Aug 2025 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JUZxW4yo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A4221F11
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 15:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755185837; cv=none; b=oHyF3/Ed7wEueL/PKAaCwYKJs4IGqBfCYOYI8nE0rQTU2nFe+LK1R3FJCJ7W2Sq+WaryKTAoLhXvTocld4BS/nhqD7HBJt+tpM5Oa62CFIGdIb2ExcxbZHDBeAD3k07/5EUrgM3CyC730QUCN0msAln3NlwrZIiVoATSXI/Pg84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755185837; c=relaxed/simple;
	bh=hxSIafXsx9an4E+vcQeVB9G4uYPF3+kWdjB3T1mRY1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M2iMfoi/IC5ZMZoTBZCDuC/5ARTGQLqBg9yO/zzJmJjqmY+eOCirGzeHbNY/vY+RQb3USVWxkO/CYO4zTaBIMvBhchchXm6fvIc9SrNCqjc57zs/bHSHMI0IhuqzqSBh/lEIVaR5nr+i+Evcdjwj47k/icl0UCOAPln0sF2sCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JUZxW4yo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755185835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BWVZNpJ+a0PIHspgQN4Czmo/fHV9NZtAaa91nIG8i0A=;
	b=JUZxW4yoXlWmg6dVGQNMnhGw27TtcKhKpNFsg6pWl3GE75OsY5asF2/LhZZu/RfhgmC1RO
	ITLge4uxYA7OsOMSDXHabwFFqNm0ntrcNcGi24/aYwiN0VB5pEPRrfWLgFWnqrnu0OTtRy
	JWifLfJ7ZBxvA166SppqLe3B82q96MI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-31-ygL-BbCSODGIqeFBMxv3QQ-1; Thu,
 14 Aug 2025 11:37:12 -0400
X-MC-Unique: ygL-BbCSODGIqeFBMxv3QQ-1
X-Mimecast-MFC-AGG-ID: ygL-BbCSODGIqeFBMxv3QQ_1755185831
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 099DF1977681;
	Thu, 14 Aug 2025 15:37:11 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.79])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 812A719327C0;
	Thu, 14 Aug 2025 15:37:09 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: kvm@vger.kernel.org
Cc: Cristian Marussi <cristian.marussi@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH kvmtool] virtio/pci: explicit zero unknown devices features
Date: Thu, 14 Aug 2025 17:37:02 +0200
Message-ID: <ed62443b8fd3fef87bd313a54f821cf363f647a5.1755185758.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The linux kernel implementation for the virtio_net driver recently
gained support for virtio features above the 64th bit.

It relies on the hypervisor to clear the features data for unknown /
unsupported features range.

The current pci-modern implementation, in such scenario, leaves the
data memory untouched, which causes the guest kernel assuming "random"
features are supported (and possibly leaks host memory contents).

Explicitly clear the features data for unsupported range.

Reported-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 virtio/pci-modern.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
index c5b4bc5..ef2f3e2 100644
--- a/virtio/pci-modern.c
+++ b/virtio/pci-modern.c
@@ -156,8 +156,10 @@ static bool virtio_pci__common_read(struct virtio_device *vdev,
 		ioport__write32(data, val);
 		break;
 	case VIRTIO_PCI_COMMON_DF:
-		if (vpci->device_features_sel > 1)
+		if (vpci->device_features_sel > 1) {
+			ioport__write32(data, 0);
 			break;
+		}
 		features |= vdev->ops->get_host_features(vpci->kvm, vpci->dev);
 		val = features >> (32 * vpci->device_features_sel);
 		ioport__write32(data, val);
-- 
2.50.1


