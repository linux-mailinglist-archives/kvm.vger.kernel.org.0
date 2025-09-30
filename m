Return-Path: <kvm+bounces-59118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAA0BBAC013
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84FAE3C5EA1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306F42F39CC;
	Tue, 30 Sep 2025 08:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uFI+FzKV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35E72F3636
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220574; cv=none; b=MPqgrbP04wNntSWNEMxfRpYJP8GGrXa1Z8aRfZ71WhHvhdfUxk8lxaGCmZO+uB4CiolKedUFDdwATUVVSk4GARsEQkTKL3k2jjGdO+eBfL89oiWGrUse5cr5eHiPTKEIOupGhIlzA8JeYFM6xhaQ1BWfTSUsmrHWK5AQNF6pGNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220574; c=relaxed/simple;
	bh=FVFJ57f+mFZUNXNQBy40e+6Qu+AIX/NJgUBfqVYN9R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOpKm5SOg+MwoMSdNHic4UqMHtGy18DDTSGghTWJaoh/pO+Nb2EAz3CF4S8SeGT1BoJ2ZxlvB0+4WloKAwGCxF/4ZuhinS6TqbTYqw3i3FF/+uVhHqsM5CaZ6+zJVmsrmvbw3z6J2wF2ad42pjeRKMIKhFFQjD+ygeICNNz6nEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uFI+FzKV; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so3303233f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220571; x=1759825371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5u2B/lBOO+ZT0vBm0zXHtehU3SXYck4J+kjqZup+Gg=;
        b=uFI+FzKVuEB0GmPBdejzKRd09mZPLk7B6kiZRIYBiI8tX+HWe83RMeTTinCGUjypNV
         691RtrKu30nLp4WDQ3n5f2VZx8xI7VDdLMNOWTUPQ3IQEpg4014n7ES3GcYe1322culY
         E+ZvMic0uAlvF7ye9vKH97Piy0xtd9WD8R6G0bl6rUVHeW9BoCpfJDeqN7QIB70o16vv
         240rtFl1cVM4gG8cfZIlghvSWzlzyymQH3v/15A9oj9QmrNuv8yuqX7koIXLxEAowYpP
         qADx4tfvyKFIgWZQpY61eP9nsy8/NfF16V75muq68SLfvZJpooHB5Tky8UCWb/xwhJpe
         JTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220571; x=1759825371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5u2B/lBOO+ZT0vBm0zXHtehU3SXYck4J+kjqZup+Gg=;
        b=deSefHoPQbbBwhgFybe3rv83zhTRHsNTOcxXP4irHiRZDIHt6TmEjVKg9R8SwE3Xju
         SU/uVXcADG1QTSXxSpC19a+o1AsKe8p1fwdg9Tp5Qd/gqfaoNFu1IRYjZ2Ud0zEk5jor
         7azk4qCZXSqCp89BT1XEJ0J2mkBvNrdGeL65jWNQi9sBLsdAJzzlY8ZL8vm/ok+s20j/
         Rj+yKxMHRkR2PijaQXL3hklg+Ph4/0JLYXaAW7QSW4EhUWTu+fWs7I5x6m4g6HPeOMv6
         ynGtMdCEJTnf8PscGXKkWEq8+uPNRtlVv3E67qYsoVqDj9RV191lDIsSOB3obIPeHovm
         JY3g==
X-Forwarded-Encrypted: i=1; AJvYcCUdo5pBtl7gj8D08+Y3L4sfpxLh8KdEsJ0Fn6JKxxGSeHoYN3IwvNkTNOG81MzjaGySiWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEQ39RsJXqCbU/ITYfJVGPWUAQGKiNOJFj6Okk5779fnpQSjuE
	TzjbhYxtP2b1LWgkkCFlQYEiqWdIEkBb1TyQvceHhSKn/P9FDtaZH+kdwcEAKhsg6POzD3Slj7y
	Adcs0r6r7lQ==
X-Gm-Gg: ASbGncs3WfpINF0rv/pEkadQaSdK+1WeuzFvTa0TJXNDy7JyU2FqjUJ0rrjWIbpFNV/
	E6BZuYXnqQHinEijNUlEi823mTuMFPnSUGPqdN3I/RUk9Htd+KoMbPbxfnJQiR5SCt36CzqboPt
	SOU9P4GsSMH0KbNyykk1q4aSxNJxV5VGjkPYbI7GR5xQDpC+jczO4TmwagrlYFkBUqoltSjUgfR
	k3aYIIH94t3sNlZxQcsZ5vjPqRamkUwtmjvLR2kynCdla7DV+s3jMD3Gq8Xf1OztiZr1l/MLV4I
	psjklb8J+LRA727snL7x+dAauj1mm++zwZH1I1QsyeDvY+UHfRXLTBZoGOU2dJEKQpXi2rOCZrF
	0IEDHdXLYrEJwU5ZiUkBvKdbqb0sLCapBU9QNOYHDf5sAKzK+PgTEgUBrRwJyt4SoPEgJJ67VRS
	uoguyhnL7cbPXh/SW0nFrp
X-Google-Smtp-Source: AGHT+IF27z6BNMVinFPf1IUIruLrE/uTdfyqnRZ7rQ19Ax6aGtKGHkRUD8xTP4t1vKCXsfORDSUoIQ==
X-Received: by 2002:a05:6000:2507:b0:403:e61e:82e6 with SMTP id ffacd0b85a97d-40e4b1a07admr17394709f8f.46.1759220571045;
        Tue, 30 Sep 2025 01:22:51 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-41855fc661esm13882477f8f.45.2025.09.30.01.22.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:22:50 -0700 (PDT)
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
Subject: [PATCH v3 15/18] system/physmem: Avoid cpu_physical_memory_rw when is_write is constant
Date: Tue, 30 Sep 2025 10:21:22 +0200
Message-ID: <20250930082126.28618-16-philmd@linaro.org>
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

Following the mechanical changes of commit adeefe01671 ("Avoid
cpu_physical_memory_rw() with a constant is_write argument"),
replace:

 - cpu_physical_memory_rw(, is_write=false) -> address_space_read()
 - cpu_physical_memory_rw(, is_write=true)  -> address_space_write()

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 scripts/coccinelle/exec_rw_const.cocci | 12 ------------
 system/physmem.c                       |  6 ++++--
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
index 1a202969519..35ab79e6d74 100644
--- a/scripts/coccinelle/exec_rw_const.cocci
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -62,18 +62,6 @@ symbol true, false;
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
diff --git a/system/physmem.c b/system/physmem.c
index 033285fe812..51abc4cae96 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3191,12 +3191,14 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
 
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


