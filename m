Return-Path: <kvm+bounces-53438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F11D6B11B45
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 11:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 085B4188B230
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074C9231C9F;
	Fri, 25 Jul 2025 09:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GY7cLItr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E962D4B5B
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437282; cv=none; b=nqpUd4CFSZt6HSt+kH5EzufdYPuBUpntfv+IATlEEfUB5IqBxyJx8JgqKck9kylxmzrZTOIJfO8tNgHwnX3R7aSxoiB5maiWS/8ibBXAypMKusGOMxGC0fO5SiAjyZzAzeKcAG1zXireKUvJ14QKQeYVDo9XcKlR4EKWq/0lle4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437282; c=relaxed/simple;
	bh=cpwRATrF9uofXpAm34Mx9vlD3LM4JwnslFFbvnZtKNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vml+I5KnnqeY4dQz7NLDzj5wlbpxwFlOmwFwVTCqKS6tOZqahACRBSQp/2yHcOhz1xUHt/gX/bC9zalYYA0AwnCgGgnwb6QhKnIbUTpUX99NCBvlOgySPjmBG24iRD4Hj+YagT8FDcyA20iD+au5oUF2NXvA/LNy77SnqANuqF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GY7cLItr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753437279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qu/tn0XAanq0KRtKGJ5/4vUA8WfaMfyMnsyZhQJ1DD8=;
	b=GY7cLItr1A2i4bvle1JTmiICvZOV9b9pz58ytCfuaqi6ELuCUMR1oOCeJGi7Pc0CeRfKTo
	4SoyfStUR9KjXBJCArmUF0SKp+LTf9DxDmryLbpCgbK6AvZe3Zrc36Yo7gqeW4TrA80yMK
	l4slFWdsEDtA4ODVlL+GdcMcKYvrOjg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-YQTtZqlvOkebSFNrb7CkOw-1; Fri,
 25 Jul 2025 05:54:37 -0400
X-MC-Unique: YQTtZqlvOkebSFNrb7CkOw-1
X-Mimecast-MFC-AGG-ID: YQTtZqlvOkebSFNrb7CkOw_1753437277
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7CDA1800370
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:36 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EC02619560AA;
	Fri, 25 Jul 2025 09:54:35 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	peterx@redhat.com
Subject: [kvm-unit-tests PATCH v4 3/5] x86: move USERBASE to 32Mb in smap/pku/pks tests
Date: Fri, 25 Jul 2025 11:54:27 +0200
Message-ID: <20250725095429.1691734-4-imammedo@redhat.com>
In-Reply-To: <20250725095429.1691734-1-imammedo@redhat.com>
References: <20250725095429.1691734-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If number of CPUs is increased up to 2048, it will push
available pages above 16Mb range and make smap/pku/pks
tests fail with 'Could not reserve memory' error.

Move pages used by tests to 32Mb to fix it.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 x86/pks.c  | 2 +-
 x86/pku.c  | 2 +-
 x86/smap.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/pks.c b/x86/pks.c
index f4d6ac83..9b9519ba 100644
--- a/x86/pks.c
+++ b/x86/pks.c
@@ -6,7 +6,7 @@
 #include "x86/msr.h"
 
 #define PTE_PKEY_BIT     59
-#define SUPER_BASE        (1 << 23)
+#define SUPER_BASE        (2 << 24)
 #define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + SUPER_BASE)))
 
 volatile int pf_count = 0;
diff --git a/x86/pku.c b/x86/pku.c
index 6c0d72cc..544c6f24 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -6,7 +6,7 @@
 #include "x86/msr.h"
 
 #define PTE_PKEY_BIT     59
-#define USER_BASE        (1 << 23)
+#define USER_BASE        (2 << 24)
 #define USER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + USER_BASE)))
 
 volatile int pf_count = 0;
diff --git a/x86/smap.c b/x86/smap.c
index 9a823a55..53c9f4ce 100644
--- a/x86/smap.c
+++ b/x86/smap.c
@@ -45,7 +45,7 @@ asm ("pf_tss:\n"
         "jmp pf_tss\n\t");
 
 
-#define USER_BASE	(1 << 23)
+#define USER_BASE	(2 << 24)
 #define USER_VAR(v)	(*((__typeof__(&(v))) (((unsigned long)&v) + USER_BASE)))
 #define USER_ADDR(v)   ((void *)((unsigned long)(&v) + USER_BASE))
 
-- 
2.47.1


