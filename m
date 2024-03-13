Return-Path: <kvm+bounces-11732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ACD987A84C
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CC0D1C20B28
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364AD41208;
	Wed, 13 Mar 2024 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcUbYIJh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF33F9CC
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710336448; cv=none; b=jhwtG1X/LNvq3fO8ON+Cni91P1nTDkUqAulOSlun/8wXydLUA3hiLAzZUqK0wgq8KfKzbqIvTH5jg78FYLoF1jByoYARMH1+eqF2MXBgalKXvT0ZEtmYvlpIUn4pv93E4yRSwOPsIaFSNTFsLwcuHDzKSHBC6H0xSL3VOwIYsNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710336448; c=relaxed/simple;
	bh=ipJ2ddmdU37zMJS0xMKJBk1Nzw5iI4t7RnYVcS1ceIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsSbOrywfNBtDElLJTcmIoaHxmhyNBoW+Mnu8kHVc/p5f6UgUiD3KFHUTrzWTEqSaKwt/w4kL2fLENUXuJwdISaT3HUfhD+KywiZTXG4ls+u39w2UjUjhzsZ5G0zIM7njMId4Br52Egaaixy1pEfOfBfJ2KB8dfzrcCJokSZNC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcUbYIJh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710336445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BI4HOo+y1OP8vwXu8d5yJLtE+j/ub4ZbV4dHw5pceEE=;
	b=OcUbYIJhRskYGmfksOKELZX8F+SB9jN1jWqoutiEqtQ1gQTGuOIIyvS5B9MXLsXax4Nr9d
	FR9EbA0WK07vTAyHYOd2icjf6kSkr3MMpw1ucGIXPOx+v+fSjevadHsSAbO6zoNCQHujOG
	HNDwkyO7Zl3syDXjJxgm7OY8c2RDIlw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-tMChy2nSOiOsiOd68MVPKA-1; Wed, 13 Mar 2024 09:27:22 -0400
X-MC-Unique: tMChy2nSOiOsiOd68MVPKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AD9E800281;
	Wed, 13 Mar 2024 13:27:21 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.160])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E97A3C54;
	Wed, 13 Mar 2024 13:27:20 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 814851800D6A; Wed, 13 Mar 2024 14:27:19 +0100 (CET)
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v3 1/3] [debug] log kvm supported cpuid
Date: Wed, 13 Mar 2024 14:27:17 +0100
Message-ID: <20240313132719.939417-2-kraxel@redhat.com>
In-Reply-To: <20240313132719.939417-1-kraxel@redhat.com>
References: <20240313132719.939417-1-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

---
 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e68cbe929302..2f5e3b9febf9 100644
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


