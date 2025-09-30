Return-Path: <kvm+bounces-59063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FD0BAB4AB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B463C0DA2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78FCE24BBEE;
	Tue, 30 Sep 2025 04:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aDAwGFIc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99D123496F
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205646; cv=none; b=JjP1I5fNp/FumrXsT+9hseOrUK5tWUkMFzFzS4p8AYkDV/IiEtH01RpmQAvH2usznBZw5l8c4+J7egMkF/fFMX5TISGGNKRH2S+cTJ691nflBMRYsmyFKPzMnu57WkpCLOabUD2obX1xX5O2lm2R21cIg7NF3e8TzTNZOeY3lv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205646; c=relaxed/simple;
	bh=OFQTedBFcnI+ih5Vhp3ZqaFgfombXPkwJ02mArVRhdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1ilHHizLkbQW/aNCFmZ8NUBLB7GQjeEwCvXPQSmlInXrk9QDz4bZy4hJuQZ5DF9j9Xtv/SsQr050NWCPptJwLBuLawz09AigsEn9Kp8balNx5RHOTX2+JQQbcrr663JlN2hYo26Buvw09SJvkvYd4z9Pb+xzIWgCPv0WNDGL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aDAwGFIc; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3f0308469a4so3076625f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205643; x=1759810443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJHuzj8i65yKq7/CrLnIUXqdpZj8DIZ6OJzdCMb/6CI=;
        b=aDAwGFIc4ACmZ7qJ+/Iwn5KW20yxIMRM8dcyhnAvFCL1ruA09U+hUM3kvcFDq159ty
         2t15l3AntUvesI4CRaHLwPflEOcTDj/wj1SGg53XMHTvhX9DBub6tVCQoItF0RZQG+kl
         JDoKIuukY5cUk2CwfPy/XPX0/r7spdcwFLH86U8mneeNSjm25yP/7jYyEOAPsvxdZtw6
         P3+OOthavm5kIrtl1HhkNl3JvvV0W22+o43fUoI5oJzJI9dSO1GwQAD3nt+UAm4TUAs4
         8L3lzazQ/tQKKb5A3PyQfmAet5dr+IUXSPd7h8xDmdxYjzmM6h454Vy8stInMLJ8YYL2
         t4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205643; x=1759810443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJHuzj8i65yKq7/CrLnIUXqdpZj8DIZ6OJzdCMb/6CI=;
        b=aYD1yxa76HJkKyGi1eXvWltpKhg831QsKVOWgbZYaUPWsMYA03Gt0vHnY9MHXWM3V/
         ReFNism4DFsE+kSlDbitQg+HReM0sRd7wQ+19yMvmD5FDmjYPIZXyGLmy3gm74ExVtBU
         QdTq6BR8Rk1WagBnkd7Ibz6nt9IWF9oWDWYUgpvzUmSitmmZK3LW1UaFZmOxOs/ktqSH
         fpXKqKXMJR8vVBN8u0LFjUprxHJf21WurtyWGfNtz/zNKqQ3uLag9nhDp5FMXq+rwMCp
         EzUx8tDYLYwLQfqLG2ryB5D4WTFgMYLHmBxIPn5J2Es4+y9FRxBjSsHSMDBEzI49Feo9
         GIQw==
X-Forwarded-Encrypted: i=1; AJvYcCXNNzIiwKRRX3Vegbrcn7VNbfy8rsdWHysxnS+WUZbJM+x7/COMgCrllQ/qi8CJi1N6EaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDSaiuRN+7tldFSkDYWn9LJ0vuID1Nf9LISgQzmf4zjUvn9Gt7
	VXNzyas9RLeY1GrtkKsvGIe4coXIjcClMwSRdyLMieFun1k17mePqd1ars9r7q2IF78=
X-Gm-Gg: ASbGncsdaHQ+SKcgchRn1+F5NNM94PXwII1yaxtf9WJ7Rfg6LkONAuosCNhx5jPjPm6
	Q9VEl+w5crPQgRrnfIi7hLkWbvF1NtaKnkNP3nq2jsD2wT+ElqzPSoXdCKakQlVmyxNVRqjJC0h
	zyyppIlM7SYeHJfXU15pakSgON83MjqSROPuylA3o1OYhol8BcEtgBCbnrvNDACoD/pOdmEjFju
	yZVX9G9IsoRqWTZuC+YWRDS1HfcGWM9YKxznObtDZ/kIQ/cK20UQTIQSWbJJoEF7nk60varX1l8
	xkwWAkeztKXl4LvjQ+ij1MS4Ws3SytHXWbN44UDRNlBmMTTNAlThT8HnqqSyygUB2lYPf/OdQy6
	CFA0t2D4S+uMiaPe0BlupLGGOYShOnWuIcKhDze89SzlKqBmHDAi/DosBj3s8fIYIII8HmVDUPn
	rbs/0uyBDh5A+tSOo0Mm3n6zD2ecOhgRc=
X-Google-Smtp-Source: AGHT+IFzoydC/PtH1+zccfqdIbgaSIsqjwZE3Y6j7iXWudBl2KZiSFlGWhLtg5m0yJ4ctRkRXODKlQ==
X-Received: by 2002:a5d:588c:0:b0:3f9:fd59:7a5f with SMTP id ffacd0b85a97d-40e4a05bf52mr18187688f8f.33.1759205643111;
        Mon, 29 Sep 2025 21:14:03 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6cf3835sm20954191f8f.46.2025.09.29.21.14.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:01 -0700 (PDT)
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
Subject: [PATCH v2 06/17] system/physmem: Remove cpu_physical_memory_is_io()
Date: Tue, 30 Sep 2025 06:13:14 +0200
Message-ID: <20250930041326.6448-7-philmd@linaro.org>
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

There are no more uses of the legacy cpu_physical_memory_is_io()
method. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/exec/cpu-common.h | 2 --
 system/physmem.c          | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index e413d8b3079..a73463a7038 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -149,8 +149,6 @@ void *cpu_physical_memory_map(hwaddr addr,
 void cpu_physical_memory_unmap(void *buffer, hwaddr len,
                                bool is_write, hwaddr access_len);
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr);
-
 /* Coalesced MMIO regions are areas where write operations can be reordered.
  * This usually implies that write operations are side-effect free.  This allows
  * batching which can make a major impact on performance when using
diff --git a/system/physmem.c b/system/physmem.c
index be8e66dfe02..573e5bb1adc 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3763,11 +3763,6 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
     return 0;
 }
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr)
-{
-    return address_space_is_io(&address_space_memory, phys_addr);
-}
-
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
 {
     RAMBlock *block;
-- 
2.51.0


