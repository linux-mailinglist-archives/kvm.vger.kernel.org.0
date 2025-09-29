Return-Path: <kvm+bounces-59039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD347BAA50C
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5934617916F
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD7823C4F3;
	Mon, 29 Sep 2025 18:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LRR1ZyvJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1122222F76F
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170851; cv=none; b=H9x9rQKLQp2ez522nIXbk/r7EygyLRMkfMH9CMRoJ5suM/xc1UvfOAAmR4gMofb3R3Zfej7E+0njdeZ7B83oVkC22/x88iUm/jXgYFx9Pr/WYxo58cMXkf0D5yoiBSyJM6Z++9csznfr/wYD3rFUUzlnRpkXxb/Gyel7NOWpDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170851; c=relaxed/simple;
	bh=hnuALrVnjHNaZheXWNppWccSovJdX4yJf187fH2gPbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfLWZacLEA6+xyxkt8zktQq8qXGENwCkCki0rZN+r6YuOE27mk7McWLsWotBUWYjqjFHAYNfe7rNuxnzmpsl0Og844sibbfaOJdiXKpoemlAWquVyzdiARfl3enpIhhs1TCATsHZrDZTiINjqKuaYFBRMLEdD+edaTxsqk2f63E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LRR1ZyvJ; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3ee15b5435bso2864206f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170848; x=1759775648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IprTsHK83+//o00MiFkngA2W2onv/YPnwzWQKra2w8=;
        b=LRR1ZyvJ+o4XwHb1nQp/NrgK5rl29hWrwTjC0z3DratHDbXRUQSAhHM8ZP2PvlXwYE
         WdAXOjCtxk+XIxMeBmDgTyks/nSANpflXQe5uFXDNxYzTbkRQzlwR24Y6WNGVKVaLZ+0
         yhzucJzoXwkKVSgjS8m64o5cWOaT+K9NWyfdeUyRrExQbDezKeNZ7C1pOqpIeHXmJfWu
         IWjRAFAPSXL05/dIbB2R6BZks92QCopVSr1/CsYD7jbByZcvh5Mdn8M6lXz0tuDMm3/H
         zafYzsPcHCCSRn0wAUNP0ksuQ7qvn4TIQG0Ba+4JG1eo8ZDpV/nZ0NEsMLRv0QUahg07
         0i1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170848; x=1759775648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IprTsHK83+//o00MiFkngA2W2onv/YPnwzWQKra2w8=;
        b=Lc+7os4wNiRzdYLh7BmtpgqY42i1rMsALfBjrkfxy/ExqJt8riAq/oSch8GlcFlgyn
         kR3rhmwX3rFUYMF7uLJ6LWFlie9z6n1YBfIT/B+8AuZ0opnK60qFfsYKVzqyRb7OZfUQ
         QxjT/y6O3xIqgocmv4tzaArQc8He8gzYgtAxE9fTQkOIpDubwc3qaKtHc5mKXeLvX6F9
         fuKgN31flvu3JqBN/HjkFuRrPArilOxwHlo2E4Rm34v/G28XlTP9XslxyGo1YGQ06O3m
         nEOFk6qsxBY7JrFjiKP/LH7dg+0Pww7OQFZeAG6mn1zH8godd6qBSLAAiKGR7eEqzaIC
         j/2A==
X-Forwarded-Encrypted: i=1; AJvYcCWNgJPuogAE05nWh30mYPM5I25Ug6PDn1ctf8ZMF4jHOM7rCXVj7p+5A7nlW4Fo2puGGk0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfZzyYwxP8SZXXd7gziewHpMbFKM0fXXB2HUEJXkN+bV4bYpup
	vkIHU1/1xggvGT13QSxgSXZaNpoaC1ww//Vgpm4ShvN4EV6booc2vKJT6GPnvpLIDHU=
X-Gm-Gg: ASbGncvv9VZ7jveCHDhuVLiVqa//+EoWBOhBBChKH7EHm3MLwgi8jLwVOMxpU+DuQ/V
	i4e1k/Z0UksZuH3XSTv5XYHOdOu2lp7QiLVtkuNbqw2RRYX6VHlJDU71PHskAN1dLVDxpJClO61
	S9Vq3MmP9fNFvpOVZ716qxUDz4ltVP92Bg7qx9TS4RzQo/8PVkxHZ1aupFC+3dClO+Ey2PO/1dE
	1RCrWIzTI7YPYA2zjpjcCdbwS7GsKapzWUlH7kRNVKMZ2GVrM2/pFXn1pHHm0aD6drqYHvSlFDn
	u4NtYymSxRhYIuSJQaQeNf3+Jg6+jgtxiVx+qpLcDhuO8EYBnyhZd9pJC8L/E7ZlUE6XItZyR8B
	C8JiLWJdcjrhQjnj3ooy2s1m6RglAnQ2Wodu92yAFBYN2vi8PaeOawWpkdLezdoJ7MdMsR14x
X-Google-Smtp-Source: AGHT+IF/C6oWT8UwF1sEc7lk12OQ3847JVrL7Xi1bCnoAAIGAt33I27+pHrZ0wCfK5j980LBTwOBoA==
X-Received: by 2002:a05:6000:1846:b0:3ee:15b4:846c with SMTP id ffacd0b85a97d-40e44682b8dmr16577132f8f.28.1759170848080;
        Mon, 29 Sep 2025 11:34:08 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab4897bsm234657245e9.17.2025.09.29.11.34.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:34:07 -0700 (PDT)
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
Subject: [PATCH 13/15] system/physmem: Inline cpu_physical_memory_rw() and remove it
Date: Mon, 29 Sep 2025 20:32:52 +0200
Message-ID: <20250929183254.85478-14-philmd@linaro.org>
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

After inlining the legacy cpu_physical_memory_rw() in the 2 functions
using it (cpu_physical_memory_read and cpu_physical_memory_write), we
removed all its use: remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/loads-stores.rst            |  4 +---
 scripts/coccinelle/exec_rw_const.cocci | 22 ----------------------
 include/exec/cpu-common.h              |  2 --
 system/physmem.c                       | 13 ++++---------
 4 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/docs/devel/loads-stores.rst b/docs/devel/loads-stores.rst
index f9b565da57a..c906c6509ee 100644
--- a/docs/devel/loads-stores.rst
+++ b/docs/devel/loads-stores.rst
@@ -460,10 +460,8 @@ For new code they are better avoided:
 
 ``cpu_physical_memory_write``
 
-``cpu_physical_memory_rw``
-
 Regexes for git grep:
- - ``\<cpu_physical_memory_\(read\|write\|rw\)\>``
+ - ``\<cpu_physical_memory_\(read\|write\)\>``
 
 ``cpu_memory_rw_debug``
 ~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 1a202969519..4c02c94e04e 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -21,13 +21,6 @@ expression E1, E2, E3, E4, E5;
 + address_space_rw(E1, E2, E3, E4, E5, true)
 |
 
-- cpu_physical_memory_rw(E1, E2, E3, 0)
-+ cpu_physical_memory_rw(E1, E2, E3, false)
-|
-- cpu_physical_memory_rw(E1, E2, E3, 1)
-+ cpu_physical_memory_rw(E1, E2, E3, true)
-|
-
 - cpu_physical_memory_map(E1, E2, 0)
 + cpu_physical_memory_map(E1, E2, false)
 |
@@ -62,18 +55,6 @@ symbol true, false;
 + address_space_write(E1, E2, E3, E4, E5)
 )
 
-// Avoid uses of cpu_physical_memory_rw() with a constant is_write argument.
-@@
-expression E1, E2, E3;
-@@
-(
-- cpu_physical_memory_rw(E1, E2, E3, false)
-+ cpu_physical_memory_read(E1, E2, E3)
-|
-- cpu_physical_memory_rw(E1, E2, E3, true)
-+ cpu_physical_memory_write(E1, E2, E3)
-)
-
 // Remove useless cast
 @@
 expression E1, E2, E3, E4, E5, E6;
@@ -93,9 +74,6 @@ type T;
 + address_space_write_rom(E1, E2, E3, E4, E5)
 |
 
-- cpu_physical_memory_rw(E1, (T *)(E2), E3, E4)
-+ cpu_physical_memory_rw(E1, E2, E3, E4)
-|
 - cpu_physical_memory_read(E1, (T *)(E2), E3)
 + cpu_physical_memory_read(E1, E2, E3)
 |
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6e8cb530f6e..910e1c2afb9 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -131,8 +131,6 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
  */
 void cpu_address_space_destroy(CPUState *cpu, int asidx);
 
-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write);
 void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
 void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
 void *cpu_physical_memory_map(hwaddr addr,
diff --git a/system/physmem.c b/system/physmem.c
index 5a0ee3b8e58..93e9550338f 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3181,21 +3181,16 @@ MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
     return error;
 }
 
-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write)
-{
-    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
-                     buf, len, is_write);
-}
-
 void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, buf, len, false);
+    address_space_read(&address_space_memory, addr,
+                       MEMTXATTRS_UNSPECIFIED, buf, len);
 }
 
 void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
 {
-    cpu_physical_memory_rw(addr, (void *)buf, len, true);
+    address_space_write(&address_space_memory, addr,
+                        MEMTXATTRS_UNSPECIFIED, buf, len);
 }
 
 /* used for ROM loading : can write in RAM and ROM */
-- 
2.51.0


