Return-Path: <kvm+bounces-59106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4467BABFCE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 337861922C4F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B851E2F3C13;
	Tue, 30 Sep 2025 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WwL1grxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2AC2D24B1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220508; cv=none; b=uIkMFJxIpc1qmxkkCwXuRnoQotdBLH9maXfpSjmRiV68AOEtlhWZgq1AZTm9j/l+ZMUgDvrWNd79KGrMZaJyYGcrtWUodI39Ry1WXWs7dyVu1iW74I+rrOnLeXhMgs9lyUDDOU+I9n1MbLR6H7oLlNuC84MSehBgRTu2ahdYDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220508; c=relaxed/simple;
	bh=V7YTTK3DadZF/66Yk4V5kuHtpRQG5xx88T1upr8EniY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TXBMoGYqfMeSFKG3fxyuOz5DWCfJgFvjvE8sX1qE77jjfgyTg9D/NEmdSi20KA5OWck9cVbQnuAqP2ga6LL2lMY+B0ihmZwIJztbGfwiKRyXS3igIi9QY8M+LYJ8RDnCmdikh2I2QGNkwPPj8L7Uv0ckkCT4tUy2rNEqPr3a8Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WwL1grxA; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e2c3b6d4cso41510855e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220505; x=1759825305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uVuWODNllLBcWHkHdEzk+20qcWtQ6YA1oYWBzMhXpCQ=;
        b=WwL1grxAdj3BB4e+FHGCJlA/3euOZEs7qdQxpsj0wAsKhPqDOF9JXMYJPReOiDMJHE
         1lsFiRX8W7PJjxO6q++3SZDLTUhRvcpfz+VZWSZhfRzQfrsn/NLLcNutXICYSTUDC48j
         U1LCDWAv2cEW5ycxpCW9li1L0QjWZ/8OPppkXeNGx0d3gwkTblk+oAEeFL43JMXhPW9V
         onRDzJ/5PtWy0CnjuttkDW3sYIdA6lFHoEVHP2PstK5q6bnwrLsP+57J9BPO65e9LStW
         u5zT3FOe1z7VGreTveoPLu6MSN/8NasPdmQhYgT59ZRANSlp5rJ+53/M40b0J7NobXG0
         ZHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220505; x=1759825305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uVuWODNllLBcWHkHdEzk+20qcWtQ6YA1oYWBzMhXpCQ=;
        b=a1DF3zo4bHU0R1QOhDv7YnUEbH+Jx8Wc7O6RWNBWRy0WEIoNGnWC+ieHmuBC8gaa3a
         9ae6h++0a10hAjp/LwCtHMrr1vG1+PErbC4g9iglT1avu4bLb5xCWOMAMg5Kgqbsw7dR
         7pJB05jjpKDNzXaxkXoIMnxtjCmsT6v03jV8Gs6U7rS6Shm8sM2MapnrJIqYqiqyrIv8
         H3ndJcAg15P2oGFlexUN0x+Z9u5G5WnUF5Yoz8fjRDWHEOP4qBx7zHe5xuKwrUZxwFWz
         mTStI3J3xhWusGRp4M9aZdZiVPtBwODbGVsXA7XYqYpk3Vc/6MwNRMYEwJZWvDpZ8JTH
         bN0g==
X-Forwarded-Encrypted: i=1; AJvYcCXD3oXBvOsddS2KhzXBeQ4F1A9ZPu7FKqwfc8s5MXPtpm1R+XO0BKNsTkY2V2/cCqb2CI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAk86rjHUAWlL3ABpHSZuS611izz+Eo1e5vwLokgMn9PW5GQl4
	dfOx6IEoUruDtcTfEru0OKibTOxwzBS3h63UZ0bGxG5rGOVi3MreUvzpXkPNSNoUDnU=
X-Gm-Gg: ASbGncs3j/GWcNgtzaHr2cOLQhqZZSkSog/98iksqDg/USFwHp5NnT3f9UzEr9drNgF
	i8CViQaS7p7WtcxWRzM0IJeupGBpNO6Iq7zLkdRkbA5Cz3mQ1fDOXhtVpbzlkn5PpEEzUliGMXk
	SlG9bIah+O3huDfMeviA/OBh+SjNFekwZfHXp8F8yn6SP5+7+cSXPMRXFrpRtMWUQ72W/7Q90oR
	Q1rORzXp0uo1rfNu9niTV9yOrSjCX8UF1Ohs7hTdFy8R1COxxUZ4TNvIqQPyUfkFhVWssKTq1ji
	QUk/RTMR+OfCThmDQxFTTJNahe0aN5dRZyq+sfNnT1NR/7dbJ4gA8wrs8WQdDt3ipKzrtrFOta4
	sBXeWhL0brCrrkl3jUtJ8auGDB1ZErEwXfwtZzJYXciLvnbK73xKQRWeyMVz/JaiBhlzzUxu2XY
	ciAdt6fAh3h5vJGKi80A1Rd8Mv8IZKTyw=
X-Google-Smtp-Source: AGHT+IEnN1+Dj0G5eE22oo/LVcWK6MF1t2TvnNSxkl29p00iMJks8dqgYIqx9W0IIiNQ+maQ1TKmXg==
X-Received: by 2002:a05:600c:1e85:b0:45d:d5df:ab2d with SMTP id 5b1f17b1804b1-46e32a03456mr188255845e9.26.1759220505370;
        Tue, 30 Sep 2025 01:21:45 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e5c3cad50sm8272675e9.3.2025.09.30.01.21.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:44 -0700 (PDT)
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
Subject: [PATCH v3 03/18] system/memory: Factor address_space_is_io() out
Date: Tue, 30 Sep 2025 10:21:10 +0200
Message-ID: <20250930082126.28618-4-philmd@linaro.org>
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

Factor address_space_is_io() out of cpu_physical_memory_is_io().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 include/system/memory.h |  9 +++++++++
 system/physmem.c        | 21 ++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index 3e5bf3ef05e..546c643961d 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -3030,6 +3030,15 @@ static inline MemoryRegion *address_space_translate(AddressSpace *as,
 bool address_space_access_valid(AddressSpace *as, hwaddr addr, hwaddr len,
                                 bool is_write, MemTxAttrs attrs);
 
+/**
+ * address_space_is_io: check whether an guest physical addresses
+ *                      whithin an address space is I/O memory.
+ *
+ * @as: #AddressSpace to be accessed
+ * @addr: address within that address space
+ */
+bool address_space_is_io(AddressSpace *as, hwaddr addr);
+
 /* address_space_map: map a physical memory region into a host virtual address
  *
  * May map a subset of the requested range, given by and returned in @plen.
diff --git a/system/physmem.c b/system/physmem.c
index 86422f294e2..84d7754ccab 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3359,6 +3359,17 @@ bool address_space_access_valid(AddressSpace *as, hwaddr addr,
     return flatview_access_valid(fv, addr, len, is_write, attrs);
 }
 
+bool address_space_is_io(AddressSpace *as, hwaddr addr)
+{
+    MemoryRegion *mr;
+
+    RCU_READ_LOCK_GUARD();
+    mr = address_space_translate(as, addr, &addr, NULL, false,
+                                 MEMTXATTRS_UNSPECIFIED);
+
+    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
+}
+
 static hwaddr
 flatview_extend_translation(FlatView *fv, hwaddr addr,
                             hwaddr target_len,
@@ -3755,15 +3766,7 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
 
 bool cpu_physical_memory_is_io(hwaddr phys_addr)
 {
-    MemoryRegion*mr;
-    hwaddr l = 1;
-
-    RCU_READ_LOCK_GUARD();
-    mr = address_space_translate(&address_space_memory,
-                                 phys_addr, &phys_addr, &l, false,
-                                 MEMTXATTRS_UNSPECIFIED);
-
-    return !(memory_region_is_ram(mr) || memory_region_is_romd(mr));
+    return address_space_is_io(&address_space_memory, phys_addr);
 }
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
-- 
2.51.0


