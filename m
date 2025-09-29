Return-Path: <kvm+bounces-59031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F728BAA4E7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B03616B8C9
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF91323C8C5;
	Mon, 29 Sep 2025 18:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yrLKC/VR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8EC78F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170807; cv=none; b=upgfrGn5VwXJVL4l9smJKdaDwWM2b5sBIwmX+2pEtzJd0l8hjL9g02kBcfBCM5F8D9bDBdvHs/GuxabWU3cZ5QjDQmnJrP3GNoFvt1DfJQ5FptX9bsHG7UtI0Mcvsh9bDBr1DIFWA1jnW9tsAT272j78jDKIuyk1to1WMIJLS/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170807; c=relaxed/simple;
	bh=323JsK3GAKnQZiV/3QUyWiIiFox/E9oRtvihvQWRHiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6nVb4Vj45EHRCbHZ+z6rK3eaB/zUfHVecR7OVFUNUlrmwa/xXLZsSq1oBdOxTwmKwv6s1qKAdeyui0jNVRLwWjVsgg16/8wFOr+8TYRPmQ9hgNC0OQWV8KPWJAqBzCaoI6Pbqs3KRz6XpJSU3C8qteKOj3j4Kec7HIKUZysoyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yrLKC/VR; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e3cdc1a6aso27634135e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170804; x=1759775604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VjyCCW7HHI1dG8y1m+qgvriOV7CMEgsHNpX6hQdnX2g=;
        b=yrLKC/VR729J/yfKy/pVnQB0ZtrDsJv0N45lmrvW6X3i0TwHWepN/dcCLdZ5hv0wsH
         zrM1F5K5y2jn/4z5OwmHA5orQSIOD4Ys62jO7PIM5R3eKNaa/syV7h5ylsGwI8hEyfb0
         5OcQEJknJto3j3KFQ010mvMeWHAj0G+1cdskEj/HXNEdw8v3DfLXJcUqZawWcigGcAJb
         p7BoxM6GDS/1wKbqNJu5rTCyfNeWxetYUDtaqSwiIEDifz8JV6pLGnnkeKIRFuZJGfIt
         qPVCbebErsQOATu9+Mjv0ZOSFk4/4oZhQawCIMe6FCFF5Baqd5JXjkIdCi8i4VrOCjLF
         Pbhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170804; x=1759775604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VjyCCW7HHI1dG8y1m+qgvriOV7CMEgsHNpX6hQdnX2g=;
        b=oGy6NUMlTQ1Taz72eBEwWU2CBLsGRd3RZ2kaVIyIpoBaN+EHCAEyWEAWD6fGvbD0Yd
         4YWNizJTxtrxD1hrjMCXJdK4cd+p/1NkIqmyArkKf5utkedMTUhvpAnz+uMPiuPAYEkq
         MtpZWGpKGt/8FMNej2IOht1pQpUUICrO5UivPF0ybfu1hdg5pw17RBWQaDUOvSuqIFV3
         ZtvqN5CArnYHgNvZKzT8uL3EIyb8LV2kOmHMFbJWIQzzpelsQlhxlPJ9yY9ssGCXQKwT
         LSKfV/VrJJAm5ADC3f1zZFtrYmjRw9Hkc71Hn3dKfINtMx7BYu02kh4mM0i+NdjMevc5
         L9gg==
X-Forwarded-Encrypted: i=1; AJvYcCUXQfm1+rt/JeaaZ4XlKosVxnqDBJOtq3cfdsNeLeYrngqJTOPDQr3WawvRR2lyH5WPxX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOHExaTROuka8rAdiIqdXKEzFzfHmglZbANJEg7JQT5EtP6wX8
	3uARLjrtU8Z+AZ18mVgbuvGIRZuqgEjxNylwvT8lmhtCfm5yJ6zGda80hRkWW3zJZDgyucRnEI7
	jzoWPxwLR/g==
X-Gm-Gg: ASbGncvCB3nM5x9SDMtX4WMyNyZOqOVSQAtdFlvG4ps+D9+r1EHhOMG9lZpowCVdrSz
	FfWDSZH8OS8cH/hrnttHgtpkmjN5O1qmFnEttLUlhJz3Mceb+vigYhBw3GZciDGk6s+o6qUaKpi
	JNigJKYYcu2gCEVIZoYjO5TqifsZq0A1FjEY4lMcMQ1Paez/DLu+xRDBz/o57nABCyD5yxP+rTe
	J2reI0hB9zNzA1xcXJHJZ80AeYa1ClaUWeX8sdP/ioezXpyzUNsTTq1AjcZfHPcPHG1UeoV0Y5f
	NJaEcAQj1l9rSvMPJOV8bB6XlhIvYuopq7mTuQ9xl0+sWZiz3cJ6caXlhpjVzjBDLMGpeWmwFxe
	TEpWtzDaunn2PxB8mEDsAUjIoCco/hI2u9XPUUhnWwUD01ZmVcfU+CedmXwyYSkFHbId7qPTb
X-Google-Smtp-Source: AGHT+IHQ2XCQX3HS0p3adUQdcJQXlpyRbo0k/r6XrZhzUXT4d+zZkT16mDlxSIQ19wUJoBTgikwi5g==
X-Received: by 2002:a05:600c:c10b:b0:46e:33ed:bca4 with SMTP id 5b1f17b1804b1-46e58cea408mr12664365e9.15.1759170804364;
        Mon, 29 Sep 2025 11:33:24 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e59ac769asm2811925e9.4.2025.09.29.11.33.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:23 -0700 (PDT)
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
Subject: [PATCH 05/15] system/physmem: Remove cpu_physical_memory_is_io()
Date: Mon, 29 Sep 2025 20:32:44 +0200
Message-ID: <20250929183254.85478-6-philmd@linaro.org>
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

There are no more uses of the legacy cpu_physical_memory_is_io()
method. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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
index 18b3d38dc0c..fd2331c8d01 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3763,11 +3763,6 @@ int cpu_memory_rw_debug(CPUState *cpu, vaddr addr,
     return 0;
 }
 
-bool cpu_physical_memory_is_io(hwaddr phys_addr)
-{
-    return address_space_memory_is_io(&address_space_memory, phys_addr, 1);
-}
-
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
 {
     RAMBlock *block;
-- 
2.51.0


