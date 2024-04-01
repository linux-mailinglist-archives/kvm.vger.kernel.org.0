Return-Path: <kvm+bounces-13284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E1F894357
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 19:02:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B21EA1C21D78
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 17:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C4A4AEFD;
	Mon,  1 Apr 2024 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O4d7K4T8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25471DFF4
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990953; cv=none; b=Vl7hsaBNIPscC8RXyvSTJaU1AByjSesXKh+TwDQW2VZOdSxXGLBLow9S6W0UifFE1pb1uNfFMBI/UV7tcgBdWAapM3oEP99yhPg+xdT033xfDGn6z8TV+6bUYJNoWOH3O/Lu95+Pd39iSDUPYZV0VQXL5PDWwrXtV+rRYQ2m4Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990953; c=relaxed/simple;
	bh=gHXOIciBqQ6wprtUu7CjPVwxedH7pbovmNhlGaxfBd8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJt8yyyDgufxd5UN7fMWqSnhee4/eSHUNTguhT3yVSMHY90z4dkLg8kAGVbHgtiO4aKxQyjnh7gT0MDtOdml923W2r5+ZxXcMnmTZo4LY8Azyv/1WT7xAXJIR/8uK9CF7yti5UhzIKhSsMdLuOILq+YOQKRoF5iYLQHxvrH7yCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O4d7K4T8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711990949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E4Cz+7mco06FwwGLqIkPLfTkmMOllEjzHSuD7oJ3t1E=;
	b=O4d7K4T860VVhpDOYHZHy8giFDEKaza0btvAoAy7xo+R9PW8PC2SqH/YJciN/R52yVluDv
	I7SFUuK8BUci2xOEUdWQb1CWxO0DsU/uMauBLgWfavcwBBW7CzCGCw6qfakO3J+4OJed4g
	BFa22GwMa7ipV+I2xgRIFhnDO1CTAW0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-192-PWFDdFF6O52nzfpa07p4oA-1; Mon, 01 Apr 2024 13:02:27 -0400
X-MC-Unique: PWFDdFF6O52nzfpa07p4oA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40BCD185A78E;
	Mon,  1 Apr 2024 17:02:27 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.34.212])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91664C15773;
	Mon,  1 Apr 2024 17:02:26 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
	diana.craciun@oss.nxp.com,
	stuyoder@gmail.com,
	laurentiu.tudor@nxp.com
Subject: [PATCH] MAINTAINERS: Orphan vfio fsl-mc bus driver
Date: Mon,  1 Apr 2024 11:02:22 -0600
Message-ID: <20240401170224.3700774-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Email to Diana is bouncing.  I've reached out through other channels
but not been successful for a couple months.  Lore shows no email from
Diana for approximately 18 months.  Mark this driver as orphaned.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa3b947fb080..04b7b737be32 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23185,9 +23185,8 @@ F:	include/linux/vfio_pci_core.h
 F:	include/uapi/linux/vfio.h
 
 VFIO FSL-MC DRIVER
-M:	Diana Craciun <diana.craciun@oss.nxp.com>
 L:	kvm@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/vfio/fsl-mc/
 
 VFIO HISILICON PCI DRIVER
-- 
2.44.0


