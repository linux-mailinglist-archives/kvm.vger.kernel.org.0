Return-Path: <kvm+bounces-59061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFB4BAB4A2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 191851924D19
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EBA248F47;
	Tue, 30 Sep 2025 04:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w1b/dXgS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E41247284
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205635; cv=none; b=RNMtRh46XJOcNyp3+6MMOQMSSQ/7nq/YjqGIbVLQZYVUygn5Bbs51gmXmanW7H83UdS0QIgmP6+MNVEOnh1XFi/SJ7MK0Df3KUirxpVdSPqsD4INyLrD5BGjlc2AfNNcEQlW/gOU6aWipvQgvmo2l8yc09MujoZ+QiLTKdMCYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205635; c=relaxed/simple;
	bh=4ijS8QI8JPVn2RfjDSD5HXVxDXtq0+sHN630Ou+jRUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LAkXNVyO3zIKnLe3bn7Rv9eALLaXdyvZTOOhj319VwED8vlsJPKWYoAy30RmUazq/dqndl4N6kBCzPskSuFXHTBuh3RMcbm2bM6zqOl7YSVbnOFvAAhks9GIsish41jez0NJOScsdVrXzKyHjAV3yGAyJPp6tNu4hHc7j5xrUJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w1b/dXgS; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e37d10f3eso40467285e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205631; x=1759810431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPaFfZE+Vm6W3t7QC31lKwf41cuqTfJ0BWTKMrsHvkU=;
        b=w1b/dXgSB4VBne6rUfBNAGX2HPo1vuDOhYBv1GSNN2fdwHjtBqOMA7r5z3BGIICvOd
         IhCmcNBcqdFIwWcTGRJ7pNjj/N74cbislL8dkIyYD+dXYJ1tCqqqWIUIBDJHNilK6Dw/
         69/fufKDBGFlkWiqZEsgtPOrQ/G3bKPvxiI+8JHZnEGJokrZp3CVcSkBIVUiCGpH7Kjq
         ZJavMv356C1GLDtRrOvb+HCJZbNjvCmrkN3+TwqaxAsUfOFgoCJFPRIHZDPpalKNkh+s
         JKHrv7ZUgqpBt9FYxBKCMme8hH71zIRWvm4Q/7O8WG/Xe+QFL3x8u7r/v1rApIv+zYbr
         IcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205631; x=1759810431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPaFfZE+Vm6W3t7QC31lKwf41cuqTfJ0BWTKMrsHvkU=;
        b=Cv9BPdXgkwmIC1ZjTaMCvui0IFNEaYi7aHREgjqRLzvkOzz/Tndg1xN1BugYtUouDW
         m3QqbyikFSnxG9xtHVtrPkgBl6HEerDSzl1oXJeDQSOlEEJ1J5GfyK5R0hblgJDN1Lge
         WeKSBesL9RMR6gBlGwOoJLn3SZdeuxPxZSrsAoU1f8hGVScIQK7XMcTnRwkiOafYZvfw
         4+1rftVf1OzXLMRmS4wOR19CUuJOTtMDYwAtJ7g0yMRcFqMAJS6QzcO7gxJdkxwSrtY5
         tKzFukwC7ghaO/788kv+5gucOwW0Ot+BsslzEGOBt/FvPUS1nyXRK0QKd/6VsfAMPDRQ
         7SAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd97si2lgzP4QEKYkJ2s0uQXgW/SCr6VQkUHTG2p542M+cJW/Fv7JyiEvXCO8x5C2eR7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEqGEq2eR7XZJACrE0Y0W7w1cv0JCL3rLvrJsYmTinFkkgUejZ
	dgYqbMMGbNo52BUmly5C18DQQJ0jezBjGfLyqW569vUaQt8fTeLqAYUJPF6Tc3VPlFc=
X-Gm-Gg: ASbGncskvzyw4XrzAa2B6BAJASyy4co3wcGrLor7xzXWVSTclCI1V9A//cN103B5DSH
	c7/50+xt4GYCL/LinE6rxhLe6MQMyD2fkM/WN4uyVPauY/BzHSozde+756nqK877OAW8MxPg63G
	4emjCa033GvhByA5Ds3W/eIms/arrFlA55jnY0cvpGTO3/vCsk+28wNGNejICXmIa/KisdUgDko
	8Py34aSa6PJgp1x7Pj5TPxf0kh3vTcT2P/TuIlAol8AWncg6Vw2FpdVjr04P+e+pMw1zkrGgfT4
	cyl/2ZmPkWeUNFyACiQia2zzA1oGRLHyhuDYSI0lDxkr9xOw02UvzTTIaz9VNoI5CjRKVHDZN+8
	MVsdKHIUCpR9UNOPSceqvGD1696zVs5HOkRQ4SBDMoWpxB4vhb9vHnm8EqBl82D2pKI5BE/3gza
	mWtiODdK2eRq3Rn5C/0oXbHCI47TpB4UU=
X-Google-Smtp-Source: AGHT+IGcac+YiZIcZSnCrqiaQ5DwkBXJUwHzOeJuSpEQu46EHairXFh+p7pa80eZkns9YIhZ38oTxg==
X-Received: by 2002:a05:600c:444d:b0:45f:2cd5:5086 with SMTP id 5b1f17b1804b1-46e3299f4f3mr172171215e9.3.1759205631445;
        Mon, 29 Sep 2025 21:13:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f536a3sm43891685e9.8.2025.09.29.21.13.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:51 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 04/17] target/i386/arch_memory_mapping: Use address_space_memory_is_io()
Date: Tue, 30 Sep 2025 06:13:12 +0200
Message-ID: <20250930041326.6448-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
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
index a2398c21732..560f4689abc 100644
--- a/target/i386/arch_memory_mapping.c
+++ b/target/i386/arch_memory_mapping.c
@@ -35,7 +35,7 @@ static void walk_pte(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = (pte & ~0xfff) & ~(0x1ULL << 63);
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_is_io(as, start_paddr)) {
             /* I/O region */
             continue;
         }
@@ -65,7 +65,7 @@ static void walk_pte2(MemoryMappingList *list, AddressSpace *as,
         }
 
         start_paddr = pte & ~0xfff;
-        if (cpu_physical_memory_is_io(start_paddr)) {
+        if (address_space_is_io(as, start_paddr)) {
             /* I/O region */
             continue;
         }
@@ -100,7 +100,7 @@ static void walk_pde(MemoryMappingList *list, AddressSpace *as,
         if (pde & PG_PSE_MASK) {
             /* 2 MB page */
             start_paddr = (pde & ~0x1fffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
@@ -142,7 +142,7 @@ static void walk_pde2(MemoryMappingList *list, AddressSpace *as,
              */
             high_paddr = ((hwaddr)(pde & 0x1fe000) << 19);
             start_paddr = (pde & ~0x3fffff) | high_paddr;
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
@@ -203,7 +203,7 @@ static void walk_pdpe(MemoryMappingList *list, AddressSpace *as,
         if (pdpe & PG_PSE_MASK) {
             /* 1 GB page */
             start_paddr = (pdpe & ~0x3fffffff) & ~(0x1ULL << 63);
-            if (cpu_physical_memory_is_io(start_paddr)) {
+            if (address_space_is_io(as, start_paddr)) {
                 /* I/O region */
                 continue;
             }
-- 
2.51.0


