Return-Path: <kvm+bounces-59060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 004B7BAB4A8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90FCB16221A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7942475C8;
	Tue, 30 Sep 2025 04:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uZLzpnEN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06A223496F
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205629; cv=none; b=McX9EOHAHbvmXBqTSfEpagDFQqAS/KAm5l0Nl7DXRWI86lhQ+f2cqY49o6Xg1HrM0cDEat+Q2lFvQLwRS9u73ZTYzJyzv/9JPtBjBLJ7A1YoVOnsYMyN8eGu1pczGWIVzaG4p05V+Cwz1PhBPmYFADPkD9P6J7Q0xzZo05/9bns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205629; c=relaxed/simple;
	bh=Zg21XAw9H5p93jdkySjzwwNnLgQS+PDuHOUdYgz4DsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agyhn+ZrQfEdJ1YpLKkoDffQX2ekYl3cOI6KLFTkqFlmxQitAeR5zebEh6a6l/ytfYoKdAiumyP+EAdHpuD3MTfNb330Ka/A0t31A+cPR9RHo2py3kANxPAIsfgLhk3b/USaSY96r6W6oTaPBgB4OZijajE0g9JqD3+eAxNLou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uZLzpnEN; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso34835345e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205626; x=1759810426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6XZQA4g1t2k7eXHW7Di/TUkQvEa/xc7WHxCnzJSKoM=;
        b=uZLzpnENdflEHeBxyaq0afOEKDYEaIBoIgRynryhx+Iyer2ZaaEz0eiQYX5agm5Gt9
         R+Ps4YCqKXZd6ZtVv3Th5e0OgwzWmFA3YMn7h+575Xiw00THaUGFYRDxuUWz91luVB2u
         ES96ZLyoqZqHSNJVORZF/oKu3W6he2ehk/72G1B2unbVPSm7026r9t3ug/QKi7gAM9kG
         ZV5h2LJud/yRlJZ3yoOhqX8tSly4O2emuW/m0I1kkiWkJH6bnvPgDLnpSQ5NCkYl8mlj
         Wxhq4HaoKSpoCn3giEqojgpWyL0MAKLVOGhMVV0zrUThWD4RMpFZncAcLJdpw6ii8xI2
         giyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205626; x=1759810426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6XZQA4g1t2k7eXHW7Di/TUkQvEa/xc7WHxCnzJSKoM=;
        b=NamQnF+mWV13E5LoV0e1DO0qNwK0JJDgcclJkkagzIEZPRtyQL6SrCM2bVgmhbnQr6
         7+gdE5WdOWt0q8VHtcZIPxrcfqnQnPArfcvZijH7MkMWQGe2nwIbCmyZeLZX0vAle9Fm
         gKsd+RFCIyCV15mnc1iROA2ZYIiIl+TBSb/AQno5Njb5zLH7jbbVLUMPUpNPqMe4vE0w
         g/wTFxXHZPxHzX5hUHcfCqRoRaESE0r+bYKDfB6Dns/IBE7Ll7FbsBnb/zCYu7BqO38G
         Jruy9GsoLkxxYfh4xd6ox00HeebiA+zv7EOwAp7RxQTXMbP3s1ElZr2iJ1Yq5klr6ca5
         JHHA==
X-Forwarded-Encrypted: i=1; AJvYcCU9STwiivbcP5K9m/oJCwCLYANIyGWWiDKedNlDRnE0Pq2K4tJPTqwxkruTp8hRhl/7pcU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxITo2RwoAhbKisfXslIqiYGwkDpkeU1L00bIYTDN7ConiPSisC
	2K5MTcre4OB/A0XkcGddJJwGGWc8z15bV0AyF4LNRXvmhOAZu3rM/TMqx8x+cRxULZg=
X-Gm-Gg: ASbGncuIMOBzfJ0mvKKukJteDFa4B6v/JNpOaukPA2cI4WDqJiTMVhMixa14JXy14ky
	H9jQa7yI/4v08lcc8RiSFnXCEy8lN5baVLVnvKaQyjyaSijYz31k4GsKod2MUz1cg0D+NONWFOF
	BrF6T5d/JQBHUOEB+R2U4AaKKZ2oGUDzxJV1nnkVsLQ+yoq0MDlo220mOWz9sg2q5gR1gqGO8GU
	n0Az6Q8eSZPawhnjCijAD5X0mexJJo/n28oY3Jnch00cJXYYAtukbYgK1OVTMhag4eVTNz0y4rX
	yhU5YpfCCu7b36pH0oEjTSMw0t9lbO7QOwmx+T9FwxXPCfWiEfDFyIzutoztBzEOasmE5fTvMyo
	ZfEsYD9E2NLxsIoHAExA/eJw98KVY0iF2NrCeNyieZHeBm/SGBgo4jEpICG1cFTdInoGJbk4BMo
	DBEqMpcd8bvXNlo9h1eMDcvA2Ki9785L38sKkeagLCrQ==
X-Google-Smtp-Source: AGHT+IH4qhPqaNC0ZqE7vVzxj8tSipzOFCi7y5DLl309Ye1K/9debpwVgj0eZ2sdSCTFy4WRMq+1ZQ==
X-Received: by 2002:a05:6000:2901:b0:3ef:42fe:8539 with SMTP id ffacd0b85a97d-40e47ee0a37mr19502672f8f.25.1759205626154;
        Mon, 29 Sep 2025 21:13:46 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc56f7badsm20596977f8f.29.2025.09.29.21.13.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:45 -0700 (PDT)
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
Subject: [PATCH v2 03/17] system/memory: Factor address_space_is_io() out
Date: Tue, 30 Sep 2025 06:13:11 +0200
Message-ID: <20250930041326.6448-4-philmd@linaro.org>
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

Factor address_space_is_io() out of cpu_physical_memory_is_io().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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
index 2d1697fce4c..be8e66dfe02 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3358,6 +3358,17 @@ bool address_space_access_valid(AddressSpace *as, hwaddr addr,
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
@@ -3754,15 +3765,7 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
 
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


