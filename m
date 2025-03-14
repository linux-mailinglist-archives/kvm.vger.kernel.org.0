Return-Path: <kvm+bounces-41097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C29A617C5
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9031739D8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E21A2054E1;
	Fri, 14 Mar 2025 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AYna/S9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4C4204F7F
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973518; cv=none; b=tQDKtiWHpDhypD7SrAmk5LpZuMOHmkgaR5PIEwbGJrcYxzungF00aroRjPkGjgUsBeXvGhNmSX+F3z4mo6qJbTt1caLv7VR6nPYLeELvghAHhbr4nWEZ5GumXE4x0/78AxRN+quMjyFPCqHbZLEtb08FKPbaW8mowUbJSmpc8q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973518; c=relaxed/simple;
	bh=eZxW1HUQDLqOK64QD3ZvyFTEod5DwQVKTFd8dmVQepY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qhc+dqAFmDPa/+wNa2kD+h3FfBGS8VjJIbK8YNghb2PYQKrVvxjtGG1Lh3BQZumv2VowbLmxH5vI31KH4EIJF2dd2X4GigkgsYswj8AmMo/CiXoIrZ3Ob9Q0Ro3Ol85KLKEAwoqsMAzzKoLxXhWiTa0foQQc/TBBvuq1nnFAqF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AYna/S9H; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-224191d92e4so49004175ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973516; x=1742578316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=AYna/S9Hv0ML3+/PA7OOwPxnpzcF9/3f+prYuEEerbSDWje6k3r5NjTSI831Yuavvr
         HGGBCDRs/2P69IkateY01cqnutA4hoqYVhOvTuElT5M6awgPWCT0dpfux5H2Mx7Ev/4M
         VKtNSC/vcmiPpeiZAtB5DZ6HY6rgvecBUjP8EhbJsnDwIxl3bk575mYtWqdP+7K2GYWP
         4KTF9v3xGuhXuGVy0W+JWNgP9awRwbXs//leKRj5iAhEUdilUDxSMLdShR3+AgPVGVVp
         Fm/gAD6FrdCOJ+2X1uSI9yCPdbbbsq4snqaHio/Cvkkm6iO46kjJyTMEgtG9x73B/zFq
         pqlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973516; x=1742578316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=EZ1cUalST8L+g8IOjpVIHECYW5g66EcGOSyhKeM/oTbVq4nsTWa33SClNWTwkYlXYX
         vWLqhoCsgtIAkj3JItbocUu5nr2LzHarrxQtnQrs8uwUe8Pi06s4bwMDinysZD6rrV/T
         zDcVqIDvyyHQrPidrbOOTZXRbQcRVQJG4XImJfI1cxPEOT309cankgZEHaPNPWITcbzV
         hgKFDc/umyqHiSkniSkOvfLXbTFSnIo1uzq4z10SjA8wsPseQFQqmMu1YTFi6HPGx3kT
         /RxkbYfJnfNNu+jaYFqV7OYrMIO/0MHFgAGQD8Yrh4tf9qWx5MKVkZBVKMUWfZz9EcF/
         /3aw==
X-Forwarded-Encrypted: i=1; AJvYcCUNRxqosAOIuVFT7c93Cp6w7ZGEXjwAeimQVmRhGMC5wrfm4ELJ/G/gG9QGqqpWxg6xw7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuo5OEBxpRL8bi3r/X85nHQ3cGrm5Bn/qTYh1ITz9PsEoDtnMS
	nNOSPSr7y6TnQjbmkKGui4snKQyjozEelVFCeTyRRztH0bA3rIgnDJHE8Jmhc9o=
X-Gm-Gg: ASbGncu+HZhrI6C02OG3Gef4WwFGKVzb97ioYZfxbTXUtJv4awoBXj55JRGFZcT5FVd
	kWO7qXhquUneS7jk9+wGqhbVC88qM5xx4moQL8HSwlM8jDSYShGXfD9a32oY9S01o0PuwYRUvD9
	2AkJMgWtacoFOm6NFOdTQYtQvazt5VD56+xenoKGaVhhT7qJqXn2ZMiGMEEbqrGfRYzFUr1cddo
	Lsa5bVhBcOpD3Xp7kWMtADUFICtvnmHfSEEz4YaogOZlGRscqR8euDCFoWZP11EVtc9GcMapESS
	KIiGCoctjMQX5XCFJKa1FqvSqRfI1O3a6I8whHwEa1fe
X-Google-Smtp-Source: AGHT+IHMleMJwhfQuIw2SImS8wKBtMic5A4ELNmhk5zJYoh3vglYg1/X+SLV/IgTuYLv0/Y4ZISJug==
X-Received: by 2002:a05:6a20:1595:b0:1f5:8622:5ecd with SMTP id adf61e73a8af0-1f5c12c78aamr4816767637.32.1741973516583;
        Fri, 14 Mar 2025 10:31:56 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:56 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 10/17] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Fri, 14 Mar 2025 10:31:32 -0700
Message-Id: <20250314173139.2122904-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is used by system/physmem.c will be turn into common code
in next commit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/kvm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index ab17c09a551..21da3b8b052 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -210,11 +210,11 @@ bool kvm_arm_supports_user_irq(void);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
-#ifdef COMPILING_PER_TARGET
-#include "cpu.h"
-
 void kvm_flush_coalesced_mmio_buffer(void);
 
+#ifdef COMPILING_PER_TARGET
+#include "cpu.h"
+
 /**
  * kvm_update_guest_debug(): ensure KVM debug structures updated
  * @cs: the CPUState for this cpu
-- 
2.39.5


