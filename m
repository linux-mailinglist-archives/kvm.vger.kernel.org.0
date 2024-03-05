Return-Path: <kvm+bounces-10945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2FE871C63
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2735D1C22F4A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60B15C5F0;
	Tue,  5 Mar 2024 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyxHk7C5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE135C04C
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709635958; cv=none; b=hD5K0fLXFdlGjZU9wzSLUwacDiKMAzWKy7idK/vgN0r7aVDX5ZZMGrbPEjDIUAers0xK+gsIL86Bs5ydEyhVJcSthLgF9KCVha31yQhwXr9avIhVQiI2aA4EB/8iPy6EMAcF1YsKLIth269BLXe26b4bJltcI8FnaCoNccLLns4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709635958; c=relaxed/simple;
	bh=e82X24i8iDjAe4bG8WK8mlWnlQKqxF+lsJvKiFGgrow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NocKsNOcIxTNyIi+O8umkuU/66uDw7EaHyROCrjslOPCGMt9p1Se9UGIfXjOEc/pHiNfcYcyjlPEPtKMk0YqAvP6Es8yd7e9UMcyhuR42Sal1FEeYSKmVlRDYhfvvLcEVVC3wrQ+rsTLTFYt0z8H6M6mQLWai9DHA7E8k2Qabrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyxHk7C5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709635956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KbJZNEr9warbU0/vfDnU1gqt6ZRkEXy95/pYSOCZa0=;
	b=RyxHk7C5ildM9kUfxroxxwa/yBPgQIGE5zcPo9j7EjNQjHCe/HZZVqAFnPVlfWt0V1oyoY
	urFFszovy3vHd5wVW79PwazJ9cIkz29HTutazKqN+RSjHlfkBZWhdk4aNMAsI2VdM8J2wS
	Mtuy90s9oU7khGqm9I6CaEOyDSBwAo0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-rzcLyZL0Mueab07tdBuiAw-1; Tue, 05 Mar 2024 05:52:35 -0500
X-MC-Unique: rzcLyZL0Mueab07tdBuiAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C31048007AB;
	Tue,  5 Mar 2024 10:52:34 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59B54C04221;
	Tue,  5 Mar 2024 10:52:34 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 414AC18009DB; Tue,  5 Mar 2024 11:52:33 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 1/2] [debug] log kvm supported cpuid
Date: Tue,  5 Mar 2024 11:52:32 +0100
Message-ID: <20240305105233.617131-2-kraxel@redhat.com>
In-Reply-To: <20240305105233.617131-1-kraxel@redhat.com>
References: <20240305105233.617131-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

---
 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 42970ab046fa..7298822cb511 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -276,6 +276,20 @@ static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
             exit(1);
         }
     }
+
+    {
+        int i;
+
+        for (i = 0; i < cpuid->nent; i++) {
+            fprintf(stderr, "cpuid: %8x/%d - %8x %8x %8x %8x\n",
+                    cpuid->entries[i].function,
+                    cpuid->entries[i].index,
+                    cpuid->entries[i].eax,
+                    cpuid->entries[i].ebx,
+                    cpuid->entries[i].ecx,
+                    cpuid->entries[i].edx);
+        }
+    }
     return cpuid;
 }
 
-- 
2.44.0


