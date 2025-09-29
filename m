Return-Path: <kvm+bounces-59028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EDABBAA4CF
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A5A43A52F8
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8381E23BF9E;
	Mon, 29 Sep 2025 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HvprJZJ2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D638022F76F
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170791; cv=none; b=FNuXzPh8/+8Ur+uyCYmjCygYREXMEZX6lOg5tmCjYYwMjiUZLUmDB1yOXwPfoa3uSrKMIKMK/E/SE4yVZp9cQYAJF191Pc0kzOG57qsK9rEVk+WDCtpBxiVUWSmNVGedfmxLGF1xiaBG+B5I8FNH3BEcMB2RTmmE+yS9UJhM0Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170791; c=relaxed/simple;
	bh=ZTrpx0sou7mRYOJW1wVkfXj6P09ehJsYhboexBIBreg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qf82+mG7rofBBqqHHj0FSB1evEdD5mx4jmRdvq1TUnio9iD0HX6FFYsxd6ez6wmxBso6R1lB3/qymuz5NQXObegcNlRsT6NaRBGYr1+iSvqdw4dFTLfBLFAsS5/OI9AedYeQd3U/lvvlsnFT11H44g6insVuqeoMFVx4rgYK3xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HvprJZJ2; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-46e52279279so10841515e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170788; x=1759775588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGMp7t36URRQSytZ84th6z88iiyCKyUd2WF0ymWy9Sc=;
        b=HvprJZJ2IipcPLxuzamprKe6GFCvMoSUAldsnmo8tfq+8TD79suYSse+vMsDEb0Agc
         bMJagWprgLewA33fROubusVpzglXQHVynsG8Zd4SQbrqhG5B0nb8nusIucMo4nWpkTJr
         Q09daJXpLEKjRfG6zxb3CwlMkWbT01omh6oA8TKr0/kU3VrhADebPmqAI8CKMlWogu4l
         HivneWpW1eilBYA/0DJreZL+dU93YljGSdyAMrCrIpOZQjflBpl36gdRMVwOZX1ubtFZ
         fSfELIeL0S6pU6aIiISg5+/du0sFR7+i/bUewqDcFBV6O5DIELNeV54LFY9BIVStMCf4
         /NWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170788; x=1759775588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGMp7t36URRQSytZ84th6z88iiyCKyUd2WF0ymWy9Sc=;
        b=PJWJ+jZuuKQWuKGpvIQ9WuGkBZ2gbhQPizvTOPZnikzJA2Tmk1f3nU0ZpEp3KRBRPF
         Qlzaw4iGUAcwNh3QEABp5OpmLJsCHIVS8wyH7Yk2V0KjZW/5C1n8uKjyVY7yQ8fPvrVS
         SPJcbGu4Xtf41Dep52d1PfZNvRLuRLzUctAXSxtaokmr0cnmLqUkGCDr+m2tk043FZ5M
         AoFwYgVQrJDQxLucUxpav6qbSOC/GwmZBc87Ty8ihLlR1uxxY+pXNCTeYBE6gR3c44+n
         OEpQEqnSxJMG4aaqyocz8Fx8IdxyNe2FNcIxUc7dTU09YPFaL7PpKD2TpyXlqZ9f1PQo
         dPYg==
X-Forwarded-Encrypted: i=1; AJvYcCUqg2HJRBLLQepCLuubpISb0uQz612a1wJAKz34ZojhuRhcKrVd8c/ilPcOlXk21E7swGM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq8cF6RpsDLNgcurESyLgkxJBbWHGrMgpB4TellDObbk4Mzq3l
	XNzS93VxPIDs7p7XIJPE3qd3L76CbW43/FycUl2zwq7lo8oCYK2+qGBxcEhzW+St5CrXVRK3Car
	M8vw7egQokQ==
X-Gm-Gg: ASbGncu3C6bo4knQHrr1RvBjtVgh5kcXFrCub4TlCz+99Zp8bgTlyvRNu+/U8LAY7vK
	m96PdTg3+39QwKZGMRk6dDn3CG+YGEF2hrl0TiAz8xDnvBQNfx2U+uJt5GdylsQU7xURhK/yumZ
	vXnfkYI0KO9MGSmRjXvQNFKcZEF4exDKPgc98f2hMyG2nqMcH20Wb364IjY4L9BVIK1+nZS2A97
	ry4kJrGCL8slZaGn3weWyTuYjhneuY7pe0qPlOYzQOg0/6aKuZh4mVoaKtUYp3cMUmcOB60G0OS
	jbmxkl7M9YYchHQhmRlg9tiy2KiZ6sG7y2z0qfBN0Hu/GZPPG4zQJwYRbTvV95R7Hx2PLZOptBq
	gUl5bX04eIA6xyYHOTjRfFADkJJxJTdChfqu8cQnEQklaNCgUa7s7e5FbSkJWEBHndcDakp8r
X-Google-Smtp-Source: AGHT+IHywbu3bHq36g4SNbzTfpiE+7B23z7rbV7w73oeTvg9ANkjyrRL+PYW3W+Y3jHxmFSC/MGdsQ==
X-Received: by 2002:a05:600c:6303:b0:46e:376c:b1f0 with SMTP id 5b1f17b1804b1-46e376cb318mr142020765e9.7.1759170788090;
        Mon, 29 Sep 2025 11:33:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602f15sm19310452f8f.39.2025.09.29.11.33.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:07 -0700 (PDT)
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
Subject: [PATCH 02/15] system/memory: Factor address_space_memory_is_io() out
Date: Mon, 29 Sep 2025 20:32:41 +0200
Message-ID: <20250929183254.85478-3-philmd@linaro.org>
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

Factor address_space_memory_is_io() out of cpu_physical_memory_is_io()
passing the address space and range length as argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/memory.h | 10 ++++++++++
 system/physmem.c        | 21 ++++++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index aa85fc27a10..6cfa22d7a80 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -3029,6 +3029,16 @@ static inline MemoryRegion *address_space_translate(AddressSpace *as,
 bool address_space_access_valid(AddressSpace *as, hwaddr addr, hwaddr len,
                                 bool is_write, MemTxAttrs attrs);
 
+/**
+ * address_space_memory_is_io: check whether an address space range is
+ *                             I/O memory.
+ *
+ * @as: #AddressSpace to be accessed
+ * @addr: address within that address space
+ * @len: length of the area to be checked
+ */
+bool address_space_memory_is_io(AddressSpace *as, hwaddr addr, hwaddr len);
+
 /* address_space_map: map a physical memory region into a host virtual address
  *
  * May map a subset of the requested range, given by and returned in @plen.
diff --git a/system/physmem.c b/system/physmem.c
index 8a8be3a80e2..18b3d38dc0c 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3358,6 +3358,17 @@ bool address_space_access_valid(AddressSpace *as, hwaddr addr,
     return flatview_access_valid(fv, addr, len, is_write, attrs);
 }
 
+bool address_space_memory_is_io(AddressSpace *as, hwaddr addr, hwaddr len)
+{
+    MemoryRegion*mr;
+
+    RCU_READ_LOCK_GUARD();
+    mr = address_space_translate(as, addr, &addr, &len, false,
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
+    return address_space_memory_is_io(&address_space_memory, phys_addr, 1);
 }
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
-- 
2.51.0


