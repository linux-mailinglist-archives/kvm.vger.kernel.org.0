Return-Path: <kvm+bounces-27038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AA697AE1A
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0228D2810D4
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142C4174EFA;
	Tue, 17 Sep 2024 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOMVJjse"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFFD170A3A
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565971; cv=none; b=RUachkcpnp/L4PewJg/igldarkPZhtUrhModCfXSabCyJZKylQQFPG5iHhb3ngcqwEPO65iCW+N+AThfrhhr8QB5LbvhcbLMP2xGwC3F8yYxhCMdTRFwdoICtgALoiFZlqBfffzTaUfhIer6XkGIPxZTMFqttz4MKZBJt11qGtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565971; c=relaxed/simple;
	bh=tOlw+0SpkXvqDfEuVO4XzD3JyEACideS3j8tZUxF4Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpWzE2TChyC/vweDz/9rOdDXtamlIgh30f5OIRY9gYehweNjqgtMUfY0KPJEdikoxxNSvwz0JVWPHyhsrIuz+SUhO6ZOes14EYPnXg1kgbqq4cx+NWJPMp/JfjC7DivaosoVSY4GN4eD2Gf0UEno4TTClv7NsIoiycozxzh4mZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOMVJjse; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vAawFAb52fCqX52IPWL8KVnHoQv/EF5r6l5LZxJMwgM=;
	b=EOMVJjseAdZAv8/ypYQNx8IsPF3bSIxm5cmlRSuRk99X5gRxQZ2tqIRcjSzr6nAc8rc/bG
	aEZQ4XBLybbsRwv2e6S482E3GwQ+pvK3BLVNeQ33QM0LJvJoBAu/l3vxOvwTk56nEWscpR
	+CKkaOW4kgeDnKo7fb7AUXaisXDymes=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-378--XUP5QaxNu-cauuQcGDg7g-1; Tue,
 17 Sep 2024 05:39:23 -0400
X-MC-Unique: -XUP5QaxNu-cauuQcGDg7g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B0F61956096;
	Tue, 17 Sep 2024 09:39:22 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 327CE30001A1;
	Tue, 17 Sep 2024 09:39:17 +0000 (UTC)
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
Subject: [RFC PATCH v2 5/6] vfio-platform: Add a new handle to store reset data
Date: Tue, 17 Sep 2024 11:38:13 +0200
Message-ID: <20240917093851.990344-6-eric.auger@redhat.com>
In-Reply-To: <20240917093851.990344-1-eric.auger@redhat.com>
References: <20240917093851.990344-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add a new field to store data used by the reset modules.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/vfio_platform_private.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 33183addd235..3e50d48005a2 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -68,6 +68,8 @@ struct vfio_platform_device {
 
 	const struct vfio_platform_of_reset_ops *of_reset_ops;
 	bool				reset_required;
+	/* This field can be used by reset driver to store some data */
+	void		*reset_opaque;
 };
 
 /**
-- 
2.41.0


