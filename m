Return-Path: <kvm+bounces-59072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A088BAB4DB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F61A3C2B36
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBB423496F;
	Tue, 30 Sep 2025 04:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lI8ybbzF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713362EB10
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205702; cv=none; b=iV02KsNiLbrsvxGq7NzKGV9EIgt8//6ckkUVdv6klc1V7rwq4dMiU/uni5iIENqdVMAF2omifCxyFfuAM/NP0AQ5sLf3/TlJdfLEdGngtDBEQug33elFOaRwUONU/+R+6ZqEZw9cmvlh3tgYaopIsGi9Fgf6+VwyspUr469xzRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205702; c=relaxed/simple;
	bh=D6uWF5gHfimLEtm6wuWGN2ijXj5YLI6I+PXAY0ScjKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldJYzu0cdIBNJSBv+5siHl3oqiPksvqJxqXkkDpccow367HfM/r3DD1lUkVnIyboebLyxkoCzBRANH+CDofaYKHDNb+u8ki9iuuMm07wx+IxoaVYcDVj9OD6aXPbgMXfhPTkpaO2yOMZGF1P9wlNb6UpMiugpIi+JbK00rKISfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lI8ybbzF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42421b1514fso232414f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205699; x=1759810499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwO23E8zQD3tYxR1qcdfXict3HnZqpkDFtM6ocAlj5I=;
        b=lI8ybbzFPOJrIPzR8P8iSatNAGXOPHn3VDQHNCG6yMReCxwRwNM5VWKth89hiYgTji
         /QK8Mw37b6LyW3umgy7Tj/7j7tFLOeOYPHAakrn8ko8ytIfU6w6Ffx7LwJTgpo/NLM1v
         iF0H0PkNqgtzxBs/UI8K1se73XYq6KeikcpPrT2i92pakIFY2Sd9QnKTfUe1Z3v1t7sM
         y/9o6tc+eDQXjehkMZlbbERzh1Fn5A5WUSkEHcYs9iPSRn4yHc4JZqTKi+z4Iv5Xpdpy
         /ecvEgDT9G/y1F1iIWLHHK2Sz2bSr9u5IIwROpB6T06XU8Xm9B+aVL5kQIG+a2Jt5sPN
         2Ukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205699; x=1759810499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwO23E8zQD3tYxR1qcdfXict3HnZqpkDFtM6ocAlj5I=;
        b=rL9khIFTjBnpIYpwDLLW3c0sPeuBcYCEVn5mCewYZATmmZWba90AscPQhaAXWQxrV8
         iGldss7d4yfm5tOOkIT/4n6ZzEEGRz5mmft9+VnYBnEqSx8qYK+cZZ0pqfP2OlkR3vSM
         5xm+TraP43WNl5YbefBmNaW4jBRYL3DPzCrZTMIJvDULnRiMTwNSI3ZgtYziQ6YjxUBL
         oUphqNVz/zHO6kD4JH1GEz0N72jM7MqWaihr+VnYQSMvyUfeNYmhuEaRdwONLZVzS5+S
         v6Fa2CXBmB0Z3pEDOoddkRsoi5jnu5CB3TIVys2fTIf6GCxyekPd7o1BRoNd75vSgkbn
         E4Iw==
X-Forwarded-Encrypted: i=1; AJvYcCV9JiGItBRPFvpo/WPbRyi2thfvy2SXy64+0ZBGqas+VMsLfU2jdl8E3m5sIBL78MZkLhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpcdqfWl2hAGtDb0XN/joqY772wa7/3r6RTqPLG4GE0sETlclC
	RofZRT0gjIp3rhbr5PwrE77C19AIaQNFs9ZMboOQvxISFkZAY/Pb7r+wdWKMCbL46WQ=
X-Gm-Gg: ASbGncuoa2zLsbxqV8B4WX5BCUIos8lunL0DTyfVFmcgvlJ2XDa/A531iYyvobuG6zd
	DwFD7s6U0EhdW00HGSgH0CboTKq7mxH2KsI7CjHRBROxInNzH0cWlti9OqltoGDTvcsP0R/CNY0
	lwlEgBWUIf/+N3UEy8oAg2wPQwC80ad9/OmzwRLYhYPhUirtSpDaBRCBkgr0sGlSQtSEGqmtc1q
	UqZZEvNeUILbExbopMybYCWwnPkV5C1QNLkJZbmPiUH6mi7AUzRCT5xg10xqAmSiSjcB7MKPnW2
	P3TskVVqfnW5zUHvPmh8kVCTYmY1PLCPS8tLrBiuSeyYYA2ooJcd0RNywhq7/MvST+wcJ0kGO8s
	q3EjA8PU9sDBXjvYr6+XzdfL10tBitJWQjyaLB/mBhLku/E9f6KhqQxKk128+cVTGyzpak+DKaI
	Y3MQqzOVJd7qZ/A25w2JVcF5zttB3cSClsBKRA7Ln1Qg==
X-Google-Smtp-Source: AGHT+IHQUeMIWrPOvhxUlcXifIoWvE3/8AU9Ob5ucePyts2g6/ZGYEFjge5tsRgBwyw13Vrh3DLZdg==
X-Received: by 2002:a05:6000:430d:b0:3ed:a43d:e8c4 with SMTP id ffacd0b85a97d-40e458a9856mr16110543f8f.6.1759205698778;
        Mon, 29 Sep 2025 21:14:58 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fbb27sm20526091f8f.4.2025.09.29.21.14.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:58 -0700 (PDT)
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
Subject: [PATCH v2 15/17] system/physmem: Inline cpu_physical_memory_rw() and remove it
Date: Tue, 30 Sep 2025 06:13:23 +0200
Message-ID: <20250930041326.6448-16-philmd@linaro.org>
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
index 6d6bc449376..a654b2af2a3 100644
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


