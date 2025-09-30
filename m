Return-Path: <kvm+bounces-59119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA538BAC016
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F01748025D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D99255F27;
	Tue, 30 Sep 2025 08:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xd0/UlS2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3509E2F3636
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220580; cv=none; b=KpbllXXoPzFglVE/9si5b4tLG9ywt2WIrS49s0hl2mg1/nCVFAP+HWCCI05vxrQh8Dt1IfeoRRU0XnXcWcz8CTvrrvIkSwsuAGPPu7N2M05zBVB6mlvbR1W/3l8nhtMovue1lbZ0qVWayEwJVry4yheROMH4z8LD04zKy3uhVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220580; c=relaxed/simple;
	bh=dgRgjyJS6aKLKaUpFa7fxZug8aLVdgor+wulnAbZzSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9/wRyYNojubYZiMIoWRnIxZthEOSjxn5rrgCk3IedZydcmCsDDsimKnMwI/mvPQocD4ckOx8LS9QnCDUlq6K/6VGwFyrAMuKqwwv2YeprJ0pJKU7rVhL17GjaBnmMu6jwPD6tsZ1qQmqkUhmLzKPqloIjGK5bb2NcnIXpcM0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xd0/UlS2; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so3732147f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220576; x=1759825376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+NTzU/IHsRou1TdenwZChnEmNZiK1YgxaNrzj3kN60=;
        b=Xd0/UlS2U0tNsSJnL6EplSwD6VFJribA5LXfg1rgqYqkpx0I21zfUYWVl61E0EuBiC
         m7goez6qCn51oIW/HdUglPgEwytwxOWOtwIVjzqub9qYnIzNnVxM/fZWhjg2VkNczw7o
         FvPdua6tIhfbBmrnhCcomn7TJOqkMpTV2eWrzy8sVpxSVXp6a3stFWGuYKx8CkhrFsi8
         A+fFkt2paJSD7YK//CH8xk73M9DE6R2SJQ2xN9Hsh9I+M//tioXMbApaSQgiIpHmU0fV
         b6jJURROGxuO0IS9cwhksjgdMHEVuwJ9m+llfxfMGd1o4vCW0rqdeU+sXVhfZp7PF1Ki
         msPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220576; x=1759825376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+NTzU/IHsRou1TdenwZChnEmNZiK1YgxaNrzj3kN60=;
        b=wrivUHXN2CkQJ+mLV4e7eJBN7A1toNAbwygYZbClbh74/MhQpYow6uTl9RYadGvdbx
         iCxmjbd6masiLPnvgSbJzYaEXIByrgi4sCJ7jpBK+b1G99NIiI43L/JZusvMv89EDK2q
         8CbNaUBQZ7LpliP/C2BTBfp1bKgRio8Vc6H1bzWvew3Zznw2dyO4nsuGmB0HmVgOeQdl
         URFwxwjZezO7xaXRQ/kS1mLulhZBRNs8OBTKqNoZB3Qlle/pdrJF9KE8sn0PQEHJ3mVJ
         97a45PzH3MVcvruTSB1NTLpyjsK947SbwD6AaGwCs7dPzRH5P8Cl5fHE7tqvt7Dq1QZL
         LvTA==
X-Forwarded-Encrypted: i=1; AJvYcCVWHjadi9885Z5OLjl8Chfmj8YW3EDTkcDhY2e7FNQxtCi6SkPnDfA3cABrHekzpEarwv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaJBTmmPy3iiXwtgnE5LjbgbkeQ210cGFT1WN6rR9uNxMt/4m+
	2BWR1OSTafvFBXG2ubRLYLkjn9MHBJ74TlHKZ3c/r7tRnXnXnCBIZjSg6lTeqdwYEGI=
X-Gm-Gg: ASbGnctfUthx4rHI+9+V2OtWHLAKkyiMP+zqwCly23yW3Aap5qlmCfcoIK9qvIAssyl
	cjOA3wCvoE9gmWfhN28uOm8m9Pk+piKVscw1+J3Gb+DAHTqo3dl1i27ONLMGJiu92YwYAHnW/X6
	8Bk920ePd5jEhuhYnd9J76d24hDIdo/SS9OPMqSvh4typEhH9dqK/QxRD5AohIrqGeo5jPw0h+x
	ou2BhUjjH83oErZgRWTYSzW3tFO/yhHG5/q1tkGHQwwPQGHgasHpWtL9CAn+iU/+5hNk6YE3EmH
	kPkvCuHxVX/Y2PA7xHSQ2+Z3qo2HqzTGv6Jn/raz2HWvvBkxrAeG0YqB3c8Q8ZktczzDXqPuGb8
	buGGMKx/xS9ijS52d72wUeTVkE1Mwpwet1meBBaAPwy4bQIC3E2R9d8UVsHLQfNR9kZarqeuSYJ
	hZiHQsIxTu92wL7YTm514C
X-Google-Smtp-Source: AGHT+IF6MOWO4c82B+adWYsw2taxPQCQZ7xaYbsT9FR7waxJpKF5wSL8PK2fRqDT9d11Kh1Y1Hd+uw==
X-Received: by 2002:a05:6000:2509:b0:40d:86d8:a180 with SMTP id ffacd0b85a97d-40e4a71159emr18168445f8f.20.1759220576446;
        Tue, 30 Sep 2025 01:22:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm257299105e9.13.2025.09.30.01.22.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:55 -0700 (PDT)
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
Subject: [PATCH v3 16/18] system/physmem: Remove legacy cpu_physical_memory_rw()
Date: Tue, 30 Sep 2025 10:21:23 +0200
Message-ID: <20250930082126.28618-17-philmd@linaro.org>
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

The legacy cpu_physical_memory_rw() method is no more used,
remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/loads-stores.rst            |  4 +---
 scripts/coccinelle/exec_rw_const.cocci | 10 ----------
 include/exec/cpu-common.h              |  2 --
 system/physmem.c                       |  7 -------
 4 files changed, 1 insertion(+), 22 deletions(-)

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
index 35ab79e6d74..4c02c94e04e 100644
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
@@ -81,9 +74,6 @@ type T;
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
index 51abc4cae96..000bde90c2e 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3182,13 +3182,6 @@ MemTxResult address_space_set(AddressSpace *as, hwaddr addr,
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
     address_space_read(&address_space_memory, addr,
-- 
2.51.0


