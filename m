Return-Path: <kvm+bounces-12105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 151DC87F8C2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38C481C2189E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489E27C0A4;
	Tue, 19 Mar 2024 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYqvh5hg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E470B7C093
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 08:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710835297; cv=none; b=KZzmiHu7/4xdzYcqBSh3FvxT7bp5RuhpG9Xg6BMCASGwylngGzaV2uytEYDF3obk0qhmRPDW7l5yerLMCXEVHz9yp6W5SE3u21fYL3DWyf1Dj0aMQ7wFME/KeZbvqC7o2zMtr17o3iUSd+zcqqYDwffezL2LqB/ETmW07ns2uLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710835297; c=relaxed/simple;
	bh=07JYzYsv06irTNmcqBIIAZqtMcbuuZN0/bDujVpd5zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yyh5VoJrNt9KLNIDvqXAbjzZpuGf411G4TwwoirxHZqSAWAB8SjLsI1kufWgbpgKZPl04nbkfKcdGkNFW+YEPzEHQ1+5MPQYQXJf8hH1eiOlTb5fz/1zUWLJblkU4nDXwRaEaT14HkdortPpVeGkD+wqbsmp/ty7kKVDs4B6NS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UYqvh5hg; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a470320194so2466686eaf.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 01:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710835295; x=1711440095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpZgTnYuZKPgrO02ZjnJJrbhmA4KtBA17GzWdnvK/1M=;
        b=UYqvh5hgGd2wnHzx+6I9iinDKFExopaXzle2MPdhAZUzk26Mhpc6kbGqsxK8867RKq
         N4P+HHByKYsXIuBLpoIXrEoTUn5FzlmqWsjLJbUcVbEE0XvHri9Yq6uPaMbYcU5c5dXi
         DSpR7DawufbrDea0l3pg3A2lRs2nTWteoMt6gqRtcEo1RqNkbOBKoHdMIYjoxCV7pbMj
         ElIdKukBWBcc5Z52JS2N0LTv9TQaCDoKLNKAp4Myevb76sHyPQye/u5vjH3VOLB8p1Vc
         eA6lOATvrAFx81ikwXIMpsrmoq0ndB97KYtcGbekGQlLiXrcOfKHY5rqXS02eYkBJ48b
         JQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710835295; x=1711440095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpZgTnYuZKPgrO02ZjnJJrbhmA4KtBA17GzWdnvK/1M=;
        b=eYZTS46VhJHvGE/NvpzZFZwCJz82ZOCJ3xHlMeBEwpHpKAuC9zEcKPxu8qbRwbbrNp
         bHCfV/xUzERjr5DKkkR7sYCmBlWZl2h0FkyxcHk8SDkAMgA//yhAI4U5dV1rn/q/sMQa
         vWX5e0QHSFKdPwvaFe39F3NeDCthUeOqNVJUtf2fq3eSNjPDKkA67d4hCp5/ijl6gsF7
         fbcMZqbkQ1yOSHbWYQDH/MbsGPtk8UtL0t7bOD7JNgRuJSRZz4tvMaWiE80c2qExXS1n
         KYxARQ1uui9inPAuuskzH7NVxf2dYUdNbwO9KS/y56e/WIKRfmp+RoAVJ1aU4Xv43gDA
         G36g==
X-Forwarded-Encrypted: i=1; AJvYcCWX4D6KeBtOcLsNkDPyZeqgRgaVa+n5LECJIf/kvusFddiKVPns4uLBWHVkWDXktdEv/ibmJLs/fp4FoB/oiw7AkG+t
X-Gm-Message-State: AOJu0YxdlqUZN4tvYE9LDU4ebffRV4tZNyKT617QzRzsl2guur7sLQRo
	0Md3nyM9tHL1QcCI++iQJowjuv+p5UyN/F1A56yIz0jV6Aw0bbn1
X-Google-Smtp-Source: AGHT+IERNdDPUTYaefvVXw56YB3Bqcd2KOnOd0Tcbbwlalm3iIbsADM2+wRouKxCGs7kkgkSLuGLrA==
X-Received: by 2002:a05:6358:199d:b0:17e:6a4d:777 with SMTP id v29-20020a056358199d00b0017e6a4d0777mr1597844rwn.19.1710835294996;
        Tue, 19 Mar 2024 01:01:34 -0700 (PDT)
Received: from wheely.local0.net (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id q23-20020a62ae17000000b006e5c464c0a9sm9121283pff.23.2024.03.19.01.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 01:01:34 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 29/35] common/sieve: Support machines without MMU
Date: Tue, 19 Mar 2024 17:59:20 +1000
Message-ID: <20240319075926.2422707-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240319075926.2422707-1-npiggin@gmail.com>
References: <20240319075926.2422707-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all powerpc CPUs provide MMU support. Define vm_available() that is
true by default but archs can override it. Use this to run VM tests.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 common/sieve.c      | 14 ++++++++------
 lib/ppc64/asm/mmu.h |  1 -
 lib/ppc64/mmu.c     |  2 +-
 lib/vmalloc.c       |  7 +++++++
 lib/vmalloc.h       |  2 ++
 5 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/common/sieve.c b/common/sieve.c
index 8fe05ef13..db084691a 100644
--- a/common/sieve.c
+++ b/common/sieve.c
@@ -40,12 +40,14 @@ int main(void)
 
     printf("starting sieve\n");
     test_sieve("static", static_data, STATIC_SIZE);
-    setup_vm();
-    test_sieve("mapped", static_data, STATIC_SIZE);
-    for (i = 0; i < 3; ++i) {
-	v = malloc(VSIZE);
-	test_sieve("virtual", v, VSIZE);
-	free(v);
+    if (vm_available()) {
+	    setup_vm();
+	    test_sieve("mapped", static_data, STATIC_SIZE);
+	    for (i = 0; i < 3; ++i) {
+		v = malloc(VSIZE);
+		test_sieve("virtual", v, VSIZE);
+		free(v);
+	    }
     }
 
     return 0;
diff --git a/lib/ppc64/asm/mmu.h b/lib/ppc64/asm/mmu.h
index fadeee4bc..eaff0f1f7 100644
--- a/lib/ppc64/asm/mmu.h
+++ b/lib/ppc64/asm/mmu.h
@@ -3,7 +3,6 @@
 
 #include <asm/pgtable.h>
 
-bool vm_available(void);
 bool mmu_enabled(void);
 void mmu_enable(pgd_t *pgtable);
 void mmu_disable(void);
diff --git a/lib/ppc64/mmu.c b/lib/ppc64/mmu.c
index 7e445fdaf..ac9c0a285 100644
--- a/lib/ppc64/mmu.c
+++ b/lib/ppc64/mmu.c
@@ -23,7 +23,7 @@
 
 static pgd_t *identity_pgd;
 
-bool vm_available(void)
+bool vm_available(void) /* weak override */
 {
 	return cpu_has_radix;
 }
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 572682576..cf2ef7a70 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -206,10 +206,17 @@ void init_alloc_vpage(void *top)
 	spin_unlock(&lock);
 }
 
+bool __attribute__((__weak__)) vm_available(void)
+{
+	return true;
+}
+
 void __setup_vm(void *opaque)
 {
 	phys_addr_t base, top;
 
+	assert_msg(vm_available(), "Virtual memory not available. Must check vm_available() before calling setup_vm()");
+
 	if (alloc_ops == &vmalloc_ops)
 		return;
 
diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 0269fdde9..e81be39f4 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -17,6 +17,8 @@ extern void setup_vm(void);
 /* As above, plus passes an opaque value to setup_mmu(). */
 extern void __setup_vm(void *opaque);
 
+/* common/ tests must check availability before calling setup_vm() */
+extern bool vm_available(void);
 /* Set up paging */
 extern void *setup_mmu(phys_addr_t top, void *opaque);
 /* Walk the page table and resolve the virtual address to a physical address */
-- 
2.42.0


