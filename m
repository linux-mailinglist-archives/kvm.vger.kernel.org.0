Return-Path: <kvm+bounces-53436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBBCB11B49
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 11:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BB0D7B78B4
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240A72D3734;
	Fri, 25 Jul 2025 09:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HiqJ+T5D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD223231C9F
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753437279; cv=none; b=QcI7ErTXSErCQfasGgMIaaivElGOJlk0ROCyU/z4N1NwTR5drgqsJuq9pOMtDAcb3Wm1dCHYKy3MiOSKnsGzdElOAmmUGyZrg8IICMyy9yo/QD89qb3s46tJ5FLjjnO0Pe5YAbTfEVbqmutLPRRCW3dsLafReO3OUvaK5mSa0p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753437279; c=relaxed/simple;
	bh=XA+XKr1jsqj/q060EkOEGHoKY6MENEZ8pmhk4r2zN6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aw1IFHxlUwnpH/2BGYm8pBjijWzhqjc32blJFgJVkSb4hgqdBZ2RD+4fkxue3el277PEmFiLzQBPcT+pQ+zj0kOoERbwJlXbur+j/rIo4GQf23wagf3JN+wuzD8fKLhEnRcjHkbtv7S/nFMtC2BKbX1VTm/0evJZMCwxZf91FPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HiqJ+T5D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753437276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BXJaoiJwu0ujau+twQcri9o/s+FJKenDj0A37IkX68c=;
	b=HiqJ+T5Dal81EE6j5m+bIZDgHRGs/4RMKvdtv2BcW198nHDcVu8luDjLsPN86J3JqcUxJF
	zSfDX6BcN5on/W9ii8Ivqb+vQONUHb9gGogl0Mn9uN0IcU0Zr2WmDJBYk17foMxff+BMv9
	63dj8JlU+FLGBf7IPIQk/t2uOUrOgp4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-NG7UoPCKMwGZpr3PVZVMMw-1; Fri,
 25 Jul 2025 05:54:35 -0400
X-MC-Unique: NG7UoPCKMwGZpr3PVZVMMw-1
X-Mimecast-MFC-AGG-ID: NG7UoPCKMwGZpr3PVZVMMw_1753437274
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 346F41800446
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 09:54:34 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EA0119560AA;
	Fri, 25 Jul 2025 09:54:32 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	peterx@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/5] x86: resize id_map[] elements to u32
Date: Fri, 25 Jul 2025 11:54:25 +0200
Message-ID: <20250725095429.1691734-2-imammedo@redhat.com>
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

currently item size is u8, which would truncate APIC IDs that are
greater than 255.
Make it u32 so that it  cna hold x2apic IDs as well.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 lib/x86/apic.h | 2 +-
 lib/x86/apic.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic.h b/lib/x86/apic.h
index cac6eab1..a76b1138 100644
--- a/lib/x86/apic.h
+++ b/lib/x86/apic.h
@@ -8,7 +8,7 @@
 #include "processor.h"
 #include "smp.h"
 
-extern u8 id_map[MAX_TEST_CPUS];
+extern u32 id_map[MAX_TEST_CPUS];
 
 typedef struct {
     uint8_t vector;
diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 0d151476..c538fb5f 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -9,7 +9,7 @@
 static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
 static void *g_ioapic = (void *)IO_APIC_DEFAULT_PHYS_BASE;
 
-u8 id_map[MAX_TEST_CPUS];
+u32 id_map[MAX_TEST_CPUS];
 
 struct apic_ops {
 	u32 (*reg_read)(unsigned reg);
-- 
2.47.1


