Return-Path: <kvm+bounces-25388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F666964B3B
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 18:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9004EB2510F
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6361B654E;
	Thu, 29 Aug 2024 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QRWMbX0C"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207641B5318
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 16:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948022; cv=none; b=c7fje2d7+TCJGHEE8291GCTzWOjgiiVDLvzTIoVHFGQv76QStz1Xf4btDBCGBN42B8XNknL3QNYu5053/EM0pBEoo0RB4tBBYhQTYY500Zqo/omOX4ophpt88kpzmJhx1ozPDOuGRUx6/pWG2M7c0piEU2n6oFNEfPOcFWm1Mnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948022; c=relaxed/simple;
	bh=cOkyuS/zD7QL6cWoaY/bqydY0jYXRoKOvV7Ranrv/Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/zgnqMIb9Gi8j2xhJk5aSeVcQHud9rKb5T0DqqkK4W/Y79LNtC2QtgiDHO6duXAWFjJ1CCj7Jf/xBQKJK8v5pNdjk4X97MWt6AUlWzITlGpyz4aLug6hCUSP4MNR7zyWGqcfkXKl0AJpvmLiy5H/EAkkmtgaXxshdbky3BeI/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QRWMbX0C; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724948019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PtSiYz+D15CV1ChqO1OH2LgkiaCj9sIiJpBCK1lkoa4=;
	b=QRWMbX0C6fNvrMdRdfR5bHeVt5ioBwIEvI7/80Pv3WGDR+bSS4fs+aOBXcXQgcjb8p68ME
	lHdgxiKOX7DasXvq2sW4iWMvHA/Wmqsaai/NA2Abu9C3/Ph46VeVTsksR1xPOZBIJY9w8i
	WjKIMG30VkE4Ff2iKYqG0MvcFMTXoHo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-b-hN3lV4OrapPRMNLgy-NA-1; Thu,
 29 Aug 2024 12:13:35 -0400
X-MC-Unique: b-hN3lV4OrapPRMNLgy-NA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 692D51955D4C;
	Thu, 29 Aug 2024 16:13:30 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.194.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BC5F19560AA;
	Thu, 29 Aug 2024 16:13:24 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH 4/5] vfio-platform: Add a new handle to store reset data
Date: Thu, 29 Aug 2024 18:11:08 +0200
Message-ID: <20240829161302.607928-5-eric.auger@redhat.com>
In-Reply-To: <20240829161302.607928-1-eric.auger@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add a new field to store data used by the reset modules.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/vfio_platform_private.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 528b01c56de6..0d689241be23 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -68,6 +68,8 @@ struct vfio_platform_device {
 
 	const struct vfio_platform_reset_ops *reset_ops;
 	bool				reset_required;
+	/* This field can be used by reset driver to store some data */
+	void		*reset_opaque;
 };
 
 /**
-- 
2.41.0


