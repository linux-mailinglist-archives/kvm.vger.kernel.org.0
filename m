Return-Path: <kvm+bounces-26053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BD596FEC5
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 02:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E370FB22BDF
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 00:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178A6F50F;
	Sat,  7 Sep 2024 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HaHrKCRi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2480A955
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725670491; cv=none; b=q7c6Av+9FEC7o2Tt1829h6s9Iuu3T70pg31w16H47b9GdbHkZtZl2mVPhOqLYfH79JUdi2NAFWJkPuP8qfxiLLMUek38xt0+VpDaWjbrN/C4VCoLSrG1b0o3KY/no3RpAbckQuyJ7DLFyZ407HdhBjhGh2MPRxJc/GYTkpPRZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725670491; c=relaxed/simple;
	bh=nBzQQeqPoijkXHBzuHJkYQhj0AQCnRnBaJJLJt/TSMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X/foW5zAB9WhuNJXFrFzXLSy4e0ItfN08n0zEjP/olvL8+qNiwSeeP8hPLi/hMX9c/pCsliVw3VS9W5FoyFNuv6zif80baiaydi61GLw3naGi8UI+vxF4MPwjgdBz18kRLYxJjSXzx+XvpRFBFx06QNDkW41bJBHrL0RjWtzURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HaHrKCRi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725670488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjQA3iE37qNV/MLoVQx3n4C5CMw2Ex62y0UtX6RoYjY=;
	b=HaHrKCRiLrNYK8s6hPglNaeLfTxHQza8nMKCvkPSrrZI9BEXEV/kcEWWgJjyeb6ttWtmSA
	tfrLBLbSNnjScHnmvAQy13OLYDes7U7Uo1KUU+hdkOY4j2tyf3hPuiJYd7AI1NOavLrwK8
	/WhpQap9iFsM84C46lMyWwwrX18rIPU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-gHI43MC4Orenhh3d3T6IPw-1; Fri,
 06 Sep 2024 20:54:46 -0400
X-MC-Unique: gHI43MC4Orenhh3d3T6IPw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F4B919560AB
	for <kvm@vger.kernel.org>; Sat,  7 Sep 2024 00:54:45 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.51])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58FCF19560AA;
	Sat,  7 Sep 2024 00:54:44 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [kvm-unit-tests PATCH 3/5] x86: move struct invpcid_desc descriptor to processor.h
Date: Fri,  6 Sep 2024 20:54:38 -0400
Message-Id: <20240907005440.500075-4-mlevitsk@redhat.com>
In-Reply-To: <20240907005440.500075-1-mlevitsk@redhat.com>
References: <20240907005440.500075-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Move struct invpcid_desc descriptor to processor.h so that
it can be used in tests that are external to pcid.c

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/processor.h | 7 ++++++-
 x86/pcid.c          | 6 ------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9248a06b2..bb54ec610 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -836,8 +836,13 @@ static inline void invlpg(volatile void *va)
 	asm volatile("invlpg (%0)" ::"r" (va) : "memory");
 }
 
+struct invpcid_desc {
+	u64 pcid : 12;
+	u64 rsv  : 52;
+	u64 addr : 64;
+};
 
-static inline int invpcid_safe(unsigned long type, void *desc)
+static inline int invpcid_safe(unsigned long type, struct invpcid_desc *desc)
 {
 	/* invpcid (%rax), %rbx */
 	return asm_safe(".byte 0x66,0x0f,0x38,0x82,0x18", "a" (desc), "b" (type));
diff --git a/x86/pcid.c b/x86/pcid.c
index c503efb83..7425e0fe8 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -4,12 +4,6 @@
 #include "processor.h"
 #include "desc.h"
 
-struct invpcid_desc {
-    u64 pcid : 12;
-    u64 rsv  : 52;
-    u64 addr : 64;
-};
-
 static void test_pcid_enabled(void)
 {
     int passed = 0;
-- 
2.26.3


