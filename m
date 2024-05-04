Return-Path: <kvm+bounces-16587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8BD98BBB50
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 14:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F34E282B7A
	for <lists+kvm@lfdr.de>; Sat,  4 May 2024 12:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D466224A19;
	Sat,  4 May 2024 12:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkQdHg3R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69CE39FED
	for <kvm@vger.kernel.org>; Sat,  4 May 2024 12:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714825827; cv=none; b=qwh8Wki2MY3e/8F1LRTup17Ogg8SVNh89/6W1p0/wyA7NEa+epOOTqnlepxZ72y6UVPfH450vlRVhya3+w3PFM2ZgSa4fhBplWnXlpNGWfrpKhWGU6UX1LxdPK0Cwu6ima7lSeZZ5G73FZ7VBUdxjnozDKkAhYrWJ8rHShfGO4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714825827; c=relaxed/simple;
	bh=pJeo4pwcA9lalmG/Qxg0dYsEHgiJKgBrY3J7VxNeV20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwAF6gBTnd9icTHplUHHFz6zV8LCSFY02pWc+lS+QRnYWPWo0kTlXsBc2CE3x3VPNvvF6NSEP/1eQsG/2UPmYiqqr4+P3EU4nzgzTvz6PYjsSABtVFns1gMO5RwJ3rELRf8WQoHtquLDsL8pg3BKElYVN+IbReN9ECyqkUnES3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hkQdHg3R; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ee13f19e7eso479873b3a.1
        for <kvm@vger.kernel.org>; Sat, 04 May 2024 05:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714825825; x=1715430625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVFESOjcVNNLos51ELml5v9t1FTREA6sVge5yqZTLzY=;
        b=hkQdHg3RtBN4fGwN2EIQDtEyFA9lZqAnSbOQjB5/3xcqHztPHRMVbCgMdM96r+5Dcc
         vQx8ie2Oo3PQsZMAg1phPplOifW8GdB5TjbRIkpnrucGouLqKpxwYCT+a24uHtAVbHGE
         fhSnmfkT3SvC3dw2zBeBygkDlWXfXQBJCGbC2PEKDXBxeH87Vc6kzKLm7dqsMcv5NQNE
         Nv+JlDZDDGIrsahsLIPUMylk7odQT7qHkugiF7PTKQQKKFF8PxWzNcEztsV6t2OMJZ7k
         G2RYwtG14NuurE0A4ik1VKdgXB7ttZmuFyi46Zxlk9OdmS6bT5q8OCloncABhLVKgakA
         /AoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714825825; x=1715430625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVFESOjcVNNLos51ELml5v9t1FTREA6sVge5yqZTLzY=;
        b=rUGrXeDEg5veGTG7cbk1nQpRBYZvl1h6Gsgfy6XBktrBkEbDihZQuFyyvdgEC7Jk0o
         pIMU5z9NjFJWg9SLVWbSr3gp4IklJOcireH8UJ9p56POUXDcHkQo3jJrJ0PVaxrUCOAw
         4Z2j8pAF6JG1J4zqDl9G0c3VlY2spfj4yQhQ+gVhJOwm/A8ceGC3AlLGFcdB9u+hVWs5
         JZu+O93LzuEPZHkdBjy0jXJ95AoOfKiAsO5JggAynmaBzIxggQNpJI+ih1uUI9kbn/pb
         FUWIfjd41yDnLdKSaYLV6tTBIxDuXTJ74ObsCN8DK9hPRV37lDvX26GvY8sOoH4gEq69
         /etg==
X-Forwarded-Encrypted: i=1; AJvYcCWY1iCJu2T5mInA7z20l1CsbB6EHntcAxoXnITk9m9l9kLCzE/50fucVxk+gU+P+D09eSUy2eUYcZsiwcFfybcFpYg9
X-Gm-Message-State: AOJu0Yw/p44iC4wQbl4Ck7UYyNfnEuw9H2Lh6PT2LTBDvd4nYou6+4uZ
	Nbi+g5uJfDT8+1Xs4VrajNFO0GRIbXoIDXaJ6Fji8gSzY1kRC1Ad
X-Google-Smtp-Source: AGHT+IFNPB2LJzAL2EtaSCfApNzeDsWtfIPNo5BFF8lVC4OEt9gdTEGRt1GpzrnYCaDmZ9s+o8lryg==
X-Received: by 2002:a05:6a00:3982:b0:6ea:7b29:3ab7 with SMTP id fi2-20020a056a00398200b006ea7b293ab7mr5992043pfb.23.1714825825102;
        Sat, 04 May 2024 05:30:25 -0700 (PDT)
Received: from wheely.local0.net (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id b16-20020a056a000a9000b006f4473daa38sm3480068pfl.128.2024.05.04.05.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 05:30:24 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v9 24/31] common/sieve: Support machines without MMU
Date: Sat,  4 May 2024 22:28:30 +1000
Message-ID: <20240504122841.1177683-25-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240504122841.1177683-1-npiggin@gmail.com>
References: <20240504122841.1177683-1-npiggin@gmail.com>
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
index 5307cd862..84be31752 100644
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
2.43.0


