Return-Path: <kvm+bounces-40797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60CFA5D02D
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82CE53B9F8C
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7F6264FA4;
	Tue, 11 Mar 2025 19:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bxAVxG4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86EA264F8A
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723104; cv=none; b=TJ65OZRmRMEQdSXthTfMYIDmOjGjMC6AAhvDn0Hxom0hWYyvfNJhITJfZXIYKtwGWG/qIcNYK97xNByWcvHHkKtNYQES45JrLtfCIXgo55zFoGELHidHS/zEkewQktA8K6rb7i7HaBhBFYB5pd2Ovt/bgYipRRcr5dIo6NdOaVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723104; c=relaxed/simple;
	bh=eZxW1HUQDLqOK64QD3ZvyFTEod5DwQVKTFd8dmVQepY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iwVTYMSzv5T5tr6N7YG1SY/ywWpfccELmWGDxZsjszcWgO2/r0tNo1eWh8jwSw+Osod32wZy2s0Dfq3Wt3lKLhcr3G039NmsZuaIsgVUX0+9i4908RmRjqERW2hYFfsJausONz7oifJvVDJwvVA+MUFqWAgbJGT9J48Z71O/08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bxAVxG4Q; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fa8ac56891so8939922a91.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723102; x=1742327902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=bxAVxG4QhB8ut4YekY4ZD6qPoBmUcBbjkEjypu/F6Ypct26zU8o9Komizpgh0FzVPA
         u6uSmLlV18XLC0MT9ghnvsU5BF7W9CjG7qeWuRa7BHikQkZ+YfnEZ4jQuOtAHn8fEaE1
         UdPfHhfGZfu0ChTGJAffkOCe5bnAH/UfT6q0UkFoQ94UZKFYtfQV/Q9QcSOfYE/2r67z
         c/i1MHhbqBvFT4qlWQ4GFIZw8g1NWfctWSVNoX7XFZdJa7KK2UKoGGH9Oue1OLeQGEFo
         kOVWTDLS0AhhYJTMbDip4ebcgYYwKIHY2QbTRQ80S0mm3Sgb8BcLS8Ow9KmgSdcFI+4L
         ThbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723102; x=1742327902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=Qb4tLY60aKAWERje/l75uKZg8MrUQnbdvFnMRFNqDbwOGb7g9m8dtap4FhVxYSoUCe
         AWJHab3NxGY9c0g4IHphD/bD9wLizr8QbXwfQB7qxxtqoA9MimStURrIik4pkryzG5ci
         08R/54fA1665EpbF8xk1DCj6siyjZZwg8zWQ14erbvJUeuxcrk8/DHKToUcB3ly/hISR
         eMIgbDtfAiyCxXcI6tcuJ2Khstuu0HIcaRD0UJvTlV0ZzpiFy10b0ltH6hssuQ8Rpas2
         4Gf2SrgkDpJ6dtMQi4z5tLUcrN6vmXmJBLx/8L5ANwHWvdXnNSAUaEJALwuOhbx4RTU1
         WaSg==
X-Forwarded-Encrypted: i=1; AJvYcCWwG4bdb2caPhsNL42WJXJJMDTM4U2RBYhFTA8APuFlmLTk1aoRtYgcyHA4vQln/NPLVCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwakeXOPpvgwUsX/xV9FmM8eSfPtHRi2SiC04BgKkC4DGR/2im
	8QeW5qIJIszT8EVHxqWNs0ICmjJjMBEx245VyxLLB8VGmsozXS/K7zLZn0QeEhA=
X-Gm-Gg: ASbGnct6a4Ht6ApTTg28mP6mHG2WJ0zSBVaP5zkdbJgNyIIPiBFnwiFfDbVCODHq55a
	kZTwlVyMh8LsdAkstOvb/pi7jV78qyEI6b24FwCPXSs6uBOzgo59XCTlFCbaRpnvJbK9bGwP1on
	pszfhHtac/ZQFGfHWHy/y1QzPyXdJ9vFh55Lk8hGhxaQdBJuTS+lwCw8ZpAwSoh0grUG3PnvOBi
	fE8ZYiZwmY7aDtO6ClkM9fa6kecdn3ygZpOIIVTxfFWHwS11c0QJxQZV8aNAQSPnfBtqk0gMWTV
	ujnn/Hts1VgjvT+U7mkBvW0kegzF2BtaJ1ViwgKGlzCT
X-Google-Smtp-Source: AGHT+IFuSUSQsgKDn+cb31pnjdNEblE2NjRflSuEeU68kg8s8JFfsQQJsGkDTEhj0ycbJp3/pjIRHA==
X-Received: by 2002:a05:6a20:6f90:b0:1f3:397d:86f1 with SMTP id adf61e73a8af0-1f544afa185mr29488018637.16.1741723102158;
        Tue, 11 Mar 2025 12:58:22 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 10/17] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Tue, 11 Mar 2025 12:57:56 -0700
Message-Id: <20250311195803.4115788-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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


