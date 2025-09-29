Return-Path: <kvm+bounces-59029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 91055BAA4D2
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8DA19223DF
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657D723D2A1;
	Mon, 29 Sep 2025 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BeFWsRts"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E5B225A29
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170797; cv=none; b=ptlyOw6DCwWt5gvN3NHiG2ZeN0hpoehD3HjsgvDvCwGX7NYpqEyDyuc2gk7myHtqQGs4O6lhCbDzCxsu58qgVxMIMva6XYUD2muIPPiVYYDsUZumB1kGqqgcgIUk4LetBwFxBe6OF9Keua58gn8JpZuxxhMgCD3Bu9jspSkNuPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170797; c=relaxed/simple;
	bh=H7OhAWFNR3Hcxh6zo0zlIt2saGzPZ2ILuwbNGNk3Bro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FT4PuWqWNVelu7yEm3vORk70684dEk72s3Y25CyGkEqmhv4opB0hOo+p/5BigIyB0IbIMywXgHzSYZLvLcxddRH/WDyXe0lCW1piKlCLy1IHDMLbLirjpcitmPySSUOr/vf0cFZmO4rXAKgmZHr1rEmC+bzTP/MGJCFuRlB+5Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BeFWsRts; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-414f48bd5a7so3185165f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170793; x=1759775593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23QTyPjiy3YtVC18SQIGMGuPQmXq870ERJAMX9bHv6E=;
        b=BeFWsRtsn6RBJxi77UiBot+sZEGKEuZTxNsxGFVaH2DQtzOAG8cEzJJBSSV1RL+Lky
         3I8Q9EfJgngLRUq2YX5d8bG11lGPyEVOHH70HS7g2XR1yFVHlsWbfkaeLQvCCZ/lIdWj
         jpcCZOKFBItNpoyoNYEqC4u41AbIavygzfe+5b+Oj68yrpd4BHn+MxhsfSWzz6NYs8To
         KJfE4FQRswOZTa4r5idPgMVhcJANTcn620tg1vc09bPZmTc3Ly4HqV/jSU6pslOMO2hB
         B+QNjDqs13HAEKCWAWvqkEMzNrr8xCXcG44V++4ZfEcSpti7tfJV9zF/MFcAjl5QUd3O
         CZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170793; x=1759775593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=23QTyPjiy3YtVC18SQIGMGuPQmXq870ERJAMX9bHv6E=;
        b=gSoVKWl4MyYTGZ/HUZWLubUlVnF53CK7jnGeZyjmdSu9D4zl++iYCYfQGOWTg5epRh
         Dl99VxNnfB6HpJUJ06xI3dDAEs6BgNLcnrNbfT3XrmFH9F+mdY0MtZGwAb2ja6CPj595
         6mELyHS595jk2/aqg6qM+btS/beTDtbCB0pjqupUwjIjM3DjcDt3mHee1YGDtxjNI2pg
         bR2Qn4h7vZEHffL9AA25zehoka0A3TFhkDNtU0C6qXIIdkzph97vglZK1vBIzLS82dUx
         +rJKQeVvh2oxvVSjowN94fvJBciMCciDV5G9pdbO+b4ZbE2r2Rr4xZbXZI2tS4mbVynj
         5KUA==
X-Forwarded-Encrypted: i=1; AJvYcCVHlBciOh0nQaHViWlMYOSkJUY3ZlvfDZgFXpoMDcMYosBbKHtwVUe7CeOZh5Jp9pzB3dE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHNeRTlM/a+4cFdnAOPEIEZRpAnzvTQkBm+m5ZZUQU5kLFeQ7r
	GN/5BqAg+7sJXK9W6GvusAU/6NOfEUNctWNDJBkV3vcuMPWsSzM8NlnDvhWGtG9RGWU=
X-Gm-Gg: ASbGncutsfXC2kepKnjY3ctgp748nbE1JzqoNkMFN7ox8GCFOphVkqrjp31oRuc/6ay
	HRVarwLFmGZe+CQV7rIIs3RoSJ/2YFOzgajF3eYwsGCJZe3xYTGUktDZXxehSLvA6cdGnxPck0t
	3IqIVbkRMFaLxyVT/On3Kl0+iZpCF3Nwd5ozjyQSK19SJxUR8/eU7qqcW/C2kb5rX58PAXSsdTU
	eT8CLgWci6ZdFeDFaVY+q8ZQGG5LcjqHvrK6GEUBfbbQXmiTqHEVPRX/H0Gv5ZOqkHYSNM6glZw
	EDQx9WbKfZH48wIHs5vAFOmlvqVwRY6LZwo0YPmdf3l7WcVjc36OqA5zhkdTzunRAraIXr/jJUu
	U3NCs4gbEhKqpp1dTUUNmD0C+zdG6fo65fs1iiXiVewN2QmURU1Z/pkoaQ10p6fiOqDUHsTtC1i
	FEx5IhWko=
X-Google-Smtp-Source: AGHT+IEcDsohAJY1q22fsASxxAoYQtWlMdbA7XCLoeuebdYNdITcBiYeKjk+UAJn3Z9pxuCxt6ME3A==
X-Received: by 2002:a05:6000:2586:b0:3e7:65a6:dbf with SMTP id ffacd0b85a97d-40e429c9c42mr14229584f8f.6.1759170793465;
        Mon, 29 Sep 2025 11:33:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb8811ae8sm19065012f8f.19.2025.09.29.11.33.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 03/15] target/i386/arch_memory_mapping: Use address_space_memory_is_io()
Date: Mon, 29 Sep 2025 20:32:42 +0200
Message-ID: <20250929183254.85478-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since all functions have an address space argument, it is
trivial to replace cpu_physical_memory_is_io() by
address_space_memory_is_io().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/arch_memory_mapping.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/i386/arch_memory_mapping.c b/target/i386/arch_memory_mapping.c
index a2398c21732..d596aa91549 100644
--- a/target/i386/arch_memory_mapping.c
+++ b/target/i386/arch_memory_mapping.c
@@ -35,7 +35,7 @@ static void walk_pte(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = (pte & ~0xfff) & ~(0x1ULL << 63);
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_memory_is_io(as, start_paddr, 1)) {
             /* I/O region */
             continue;
         }
@@ -65,7 +65,7 @@ static void walk_pte2(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = pte & ~0xfff;
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_memory_is_io(as, start_paddr, 1)) {
             /* I/O region */
             continue;
         }
@@ -100,7 +100,7 @@ static void walk_pde(MemoryMappingList *list, AddressSpace *as,
         if (pde & PG_PSE_MASK) {
             /* 2 MB page */
             start_paddr = (pde & ~0x1fffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_memory_is_io(as, start_paddr, 1)) {
                 /* I/O region */
                 continue;
             }
@@ -142,7 +142,7 @@ static void walk_pde2(MemoryMappingList *list, AddressSpace *as,
              */
             high_paddr = ((hwaddr)(pde & 0x1fe000) << 19);
             start_paddr = (pde & ~0x3fffff) | high_paddr;
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_memory_is_io(as, start_paddr, 1)) {
                 /* I/O region */
                 continue;
             }
@@ -203,7 +203,7 @@ static void walk_pdpe(MemoryMappingList *list, AddressSpace *as,
         if (pdpe & PG_PSE_MASK) {
             /* 1 GB page */
             start_paddr = (pdpe & ~0x3fffffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_memory_is_io(as, start_paddr, 1)) {
                 /* I/O region */
                 continue;
             }
-- 
2.51.0


