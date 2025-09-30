Return-Path: <kvm+bounces-59066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 686B7BAB4C9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 234E01C30F1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4048E24BD1A;
	Tue, 30 Sep 2025 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="voK6tR1a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D668247284
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205664; cv=none; b=V6L3w9ibtCRJ1x75TCPHItkQEl5wGCe1lvHmL2T3EURtdHCHj5rCrODMTebmO23wIQNfnagHESo+jTXqdaB1oR9I6BVUo8JFDY0TfLZFeY9o8cWxkoMB3kmAg9+rXjewfAwVutc1wrudBNyRlYjAVQE/dK0+F6ZJc+YXSQs2tnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205664; c=relaxed/simple;
	bh=tk1fcCe2uc8SQWNfNZeaf5rjjKf8QrHgGyefv91DT28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GAOX1m/8vWp9I8Jvv1pBwkfRnmdGXbBdieg1p3NcdPJa6h0SWiEWzeAk4s4mQk4cgI3rr1zoD5Sn/v7DRqFFXxQuswOXwBL5xHA30Sl0cnUniMiEhvWXK1m3/NvgkNvZK49FWPNtaupwoNQUBPiaBqDVK56iOZQAG1zLHDeqyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=voK6tR1a; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42421b1514fso232243f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205661; x=1759810461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRsfrHQBMjnrXhlxfeiXrXfyISPq/9LUWh417J9QSAY=;
        b=voK6tR1azRJ8Z5Z85SVVZHj6sFwrNROz2+YbAQ65k7J5QWtn45dH9Lwj05CBpfgnMO
         olFC3+otFWQcIN4xESX0xCIpRkbOBvLBdvRGQcF7bAqdwqGQ0ctQVjW0GN4EMDU0QGoi
         lBiq2yfXlK3XsWGVRsl9aeE9rffNhFoJ1Fgl22MOkyvHd0N/P9Nx25oVgFsCANVoK3bM
         CtWP6RY4yPRohlk1XlXmHqlDnO/PLV0ntvKK/tMTwR87DaeqOwJcBqSFOuoqvCAr1Kr4
         MkkAuNuMZjTC/96qRhJeNgd0EBezEhE7b/TMSgXaFNywWUgeH/jPAHJjzk+imB8m2LPm
         3EkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205661; x=1759810461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRsfrHQBMjnrXhlxfeiXrXfyISPq/9LUWh417J9QSAY=;
        b=InIofase2Dl2iGTYMUuo1UbHs6FGTN5yvI6m8Rd465dmxAzll67heASjOoFsiSjYKb
         ip4Q2OL0C9kzyWvnlWTL9uyM+s6t4RmCxjtTHHtfRtgYz3+jlOw0c0Lzooyjwjv6yrbU
         RZByTcrApAbJtJsQdFKENz/k4ab6m2N9xAapaEV61Vx0gHHPBFocXHGp7L44L/GLDdNT
         Snk+DonHKxNP/2q77KJwiyNB6RvS3/9GtipBs6Cerx5bJeJfMTqhGMQ7+nGZ/EY6Fw1d
         zLhoUy+E1ZCv5XwLuIHvt5shzXWUqADnNyJr9R83p0ConMTaEdpIzhPDAMulnhrSYUL0
         ptHg==
X-Forwarded-Encrypted: i=1; AJvYcCX/LcEZN5n6Os6k/bOBxBJ1vIYZ/+AXzuGQZU4HEKvQ/deXzvkMPVBmYOrVBlKCVCAu+6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGO6uzJvSyrzUYfnwv1qlXKchv2nXUvnme6O7OB0Ct0ZAR2I+O
	UqRKUY5tq4fSZyfkxf+2ElZBhEHNrWKL3D38QOLSmzlxNaP2sgTLlZ82RInnpdm/UyA=
X-Gm-Gg: ASbGncsyfzV9c9QbyB6uTv/nbnhRRYyw4q/Ap76CwIEGF4KPkQbeQFnd34LU6Vh6e6C
	jjHLYD8tV1yEA/sY/RkJ9XjwDYECWWnY2RBong0necYXc0X5FVrGhhvlEnrDw0UjS9pxpmrA8Ik
	KtPNYk+P/0j9AYEms69EQjoLWCXdGZxaDiBb0BzELRL5voPd1NwI1GVLTM0a8HbDLUGt7UwEihv
	PyQ2AtmZ0rYiGTAgAUMFszHluU3bb9uTQ8d939AdfNuGOWvoaIm/I1ohGu10ceWV54RZd+GLX7D
	eeQ3GmVmStnH4pX8n81FDGJENBfAU615ZsYEpLwjD4b9djzW8Px72ErhNXBIpxr6fHm+49VII2R
	996u+EZnhKNCDOt3EatPRKTqGMp2zndrISsCS2th46Il16xccXwP822cGPw1pWzU/AglVWNzLow
	YoPBiiXC3qbVIjcGLkEopzuqTjbmqaCEU=
X-Google-Smtp-Source: AGHT+IEAmcRaAQ7y3JKYkZc+1B3lBRPGfbSyTbOeVCtcFaGQrh4be0IXziHu3DKBh/h2DslEMGPKwA==
X-Received: by 2002:a05:6000:2dc9:b0:3eb:c276:a362 with SMTP id ffacd0b85a97d-40e3d69c099mr16747038f8f.0.1759205660946;
        Mon, 29 Sep 2025 21:14:20 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm20884752f8f.8.2025.09.29.21.14.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:19 -0700 (PDT)
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
Subject: [PATCH v2 09/17] target/s390x/mmu: Replace [cpu_physical_memory -> address_space]_rw()
Date: Tue, 30 Sep 2025 06:13:17 +0200
Message-ID: <20250930041326.6448-10-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_rw() by the semantically
equivalent address_space_rw() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/s390x/mmu_helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/s390x/mmu_helper.c b/target/s390x/mmu_helper.c
index 00946e9c0fe..4e2f31dc763 100644
--- a/target/s390x/mmu_helper.c
+++ b/target/s390x/mmu_helper.c
@@ -23,6 +23,7 @@
 #include "kvm/kvm_s390x.h"
 #include "system/kvm.h"
 #include "system/tcg.h"
+#include "system/memory.h"
 #include "exec/page-protection.h"
 #include "exec/target_page.h"
 #include "hw/hw.h"
@@ -522,6 +523,7 @@ int s390_cpu_pv_mem_rw(S390CPU *cpu, unsigned int offset, void *hostbuf,
 int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
                          int len, bool is_write)
 {
+    AddressSpace *as = cpu_get_address_space(CPU(cpu), 0);
     int currlen, nr_pages, i;
     target_ulong *pages;
     uint64_t tec;
@@ -545,8 +547,8 @@ int s390_cpu_virt_mem_rw(S390CPU *cpu, vaddr laddr, uint8_t ar, void *hostbuf,
         /* Copy data by stepping through the area page by page */
         for (i = 0; i < nr_pages; i++) {
             currlen = MIN(len, TARGET_PAGE_SIZE - (laddr % TARGET_PAGE_SIZE));
-            cpu_physical_memory_rw(pages[i] | (laddr & ~TARGET_PAGE_MASK),
-                                   hostbuf, currlen, is_write);
+            address_space_rw(as, pages[i] | (laddr & ~TARGET_PAGE_MASK),
+                             MEMTXATTRS_UNSPECIFIED, hostbuf, currlen, is_write);
             laddr += currlen;
             hostbuf += currlen;
             len -= currlen;
-- 
2.51.0


