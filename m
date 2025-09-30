Return-Path: <kvm+bounces-59107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 765F1BABFD1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A083C5948
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D2D2F3C03;
	Tue, 30 Sep 2025 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="icrSK1qD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692B52BE037
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220514; cv=none; b=UiaaJ9PyHS0aYm/u7GkxC/XHz5U3jP80U/GB0kxzauW4rDImjJAK136IM22rd9UnRv6uMkZFTveE8zHZJK/kLYmxyN/ExP3NhNbJqGR/EWHYbWzRmBYyClcfxtPOfIgvMH9MkSPEv9+Rbf2sCSUMW40rOItgLQ8O5AdDgsHLeDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220514; c=relaxed/simple;
	bh=4ijS8QI8JPVn2RfjDSD5HXVxDXtq0+sHN630Ou+jRUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJkPCaHnU8nGtMt1aT6Pmo194nttmlG+S+BszZn2zS/HgYQoeThJpWh5ah1K5IDNMQoRuNqd+KrAxIb6nZN0KLj+Rnk6yMCnj+bgvlZhaQYj4p9Q22f34LtwgI1o3wevsfvZUgh3sgB8wWiHMAU3BzM3Im/HaTNG2n8cGE6F1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=icrSK1qD; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so679592f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220511; x=1759825311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPaFfZE+Vm6W3t7QC31lKwf41cuqTfJ0BWTKMrsHvkU=;
        b=icrSK1qDgYuAZj5lHoecTfWBfKAtf0ubSwLilgp64JU43/848LAp+XyF7VkDl5bRt9
         Wz1CkPwlagk2Vpz7OTjn5v8RSPojfaGUVvbnlKQwUBSZqEgzPZPyNP8rtoMjzHHdiViO
         voiPUDdiyixaj5IqWBeF2QZe584RPFuFOJQArII/P5d4Xb2jPDcMWB9JS66WhPVBvv3D
         RTnV+lkiLdkzb8QraQhIyVGAWPBwVPhyltwIsRZ/ksQ2/RT2sODPjylWuujabGWvlFjw
         6Z1efYAl5wPKekvpW4XK2z6r23TWaHEfQqF5HL9yJPZq6PWH0O5WeZiH0mN3amsnZ0ww
         6/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220511; x=1759825311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPaFfZE+Vm6W3t7QC31lKwf41cuqTfJ0BWTKMrsHvkU=;
        b=be21j0doM3z44uP+J86yHvJnNwllgfbAIHA1T+34iUODZQ78cDtSghLuj0n7oibrrO
         ZMu5jks/NG6d/kNM/QashN+TCsDAG0H8niCbAXZZWzIRRfzpQZ0PXsR02GssTsqxFel9
         rQgnwsF4S5y+KpMz2WOyzjB5F18AhICslJ2/NnWxqiCfCOfjQdpDEsogtlVyjG442p/L
         SmclJl6C1PbXJwLguorUmUdI+b5ER7avI0r8STuAXffBbwmEqRJEAhqSWHUNyk0DdXSW
         BEw9oaGCEN5n/CIbF+P97/3rMbOqsCYgTBt5Yw+YMtjKgeOoPg74wMbbh07j8ZujTDE5
         WI1g==
X-Forwarded-Encrypted: i=1; AJvYcCUyc1lH5OuLqEguabIfv6KfpYG0jFEuYZMEtnAtcTJZMAtnnQObVilzGnI7wZd62sANsrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDH8BffZ4fBY2KWeJE11OqQgdkbhZ69zwZQKs1Dqc+wpSUWWay
	Ro6tBzTedL816Gt7KNQAYMZupbYXUGyiRtMtuOoOSHBm3ZOcq+nTEw/nUwO4LmY4GNw=
X-Gm-Gg: ASbGnct2fa+tCLNdyvtfnEoMZJQYCrv3Cwu/8YmAsyA8ovwdx2jxlXrXjM6HOThz9EH
	8t7uIJefe8rQMDT19LYO2CuZBrRvOl4ImA8k4IpHXjPUIitsr4joy8YY3YxrM2gorjVQsCfFKUc
	mGmIhrHbK+gHU9AhuOSb8lYBmk+aG37DTBejE8uvQvbH1YhiO4B/C3IuIs5jRoWt39coyymK0rb
	xditTx0R7ztPnrEgYvp1XIkP5LfxohlUHm5WPhWU/9wJc+hI1BxWnwD72g9xzdNhNi4BuhjIeRa
	Tyk3+QeydoTtvSofGZ9/8ROM4HQZx2oukrpT9jcU2C6cPMNviuPLW77Ukj/Ul8C0KJdpw18d9uZ
	ydiNRQKCDM7woI9leRhJwddYwZso6rMzmXTL5EwZ3naTwys/GHkOy0IZ5Bo5WCSNFe9Q+9lnUMN
	3EUM8V+PDrtI+loGBFqHau
X-Google-Smtp-Source: AGHT+IEB8eNGO8ibaj4OUUkCL1Gk/lot4nZRiwg5YPnw3XMPBC9mULq1peqy0gUd0OsdrauuTBslPQ==
X-Received: by 2002:a05:6000:2511:b0:3d8:3eca:a978 with SMTP id ffacd0b85a97d-40e44682229mr16305754f8f.21.1759220510700;
        Tue, 30 Sep 2025 01:21:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602f15sm21609359f8f.39.2025.09.30.01.21.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 04/18] target/i386/arch_memory_mapping: Use address_space_memory_is_io()
Date: Tue, 30 Sep 2025 10:21:11 +0200
Message-ID: <20250930082126.28618-5-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
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


