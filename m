Return-Path: <kvm+bounces-40730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9356A5B7D5
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D202189641B
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632F5215178;
	Tue, 11 Mar 2025 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WggEpciq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1857E1EB1B2
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666150; cv=none; b=FPdk/tkWnbp/iZUqUGlR8ggpt95KBP442Qfzk+V3mVH70ApDqfNNnKO/8on0bgqZi212RdA66ae7AjkvJKgVR/8qpkl7rA63xv+6uNDVgv5zrUNX7KGQLaNegYbLVgzfASuXckFdB3VxKLS1ouXK5Ya7QqdBRFEUlfM5DNMd1Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666150; c=relaxed/simple;
	bh=eZxW1HUQDLqOK64QD3ZvyFTEod5DwQVKTFd8dmVQepY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O3P6QEd5mgC9YJ2nsB6zWg/sMsUcw7tIZKXlUbosFqKbqaax/l3xnVrxOfUjguZp3sZVgCRH7w96CMYoIXPT8StGpY26Nh/PoeDhyTMlyXwvo/wHv1P2rp+9kKyW2n5lpgqAfppVDyJcHoPrsuICbJJ5sgTaHeI0c3hE61USqUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WggEpciq; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22580c9ee0aso23111045ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666148; x=1742270948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=WggEpciqf1cr78kDPx6R9kzNnuFjPxHh1Xe6qqa3fVmXMtLHXqP2faqHWuslopgBjj
         0As845ll82F2DkStW1BbBj22GyFxfJuKF5143gc1Cb8pW+ZnP75L7RE5HrE0qY4TyBBd
         XSXvnXwerXKifpECoY7+tT9TQvQo7vn5QNVMzILGVmnthCikjsCpq+tjui7JsCt/MwS9
         m5KZDd5vFFGX5dMxNSH96983Omjl7h9zvhufxIP84Dn+b1agiuFTzYOFcNHLIkGtQtDO
         RqQYHpBywIH44RfLHTAKZuNjsGuFlopBVMrqjE4otkm12+uQgSRYWeknor3zaciOW1uW
         WRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666148; x=1742270948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BsftdeZcZ0LsVJ43Vlgc1kB7SrUHDvnjwuIeYSteybs=;
        b=RtjKmh5GT/DWObEd/lb81rXk/6DrRJYvC0Krzrj9+WMq4nGFUvYpqJbH0hlifHR8f7
         SPvgGPzqRgH6YikjjzoBv/2ZKyiaQdJbXOznAbsUPTW3tW2apuzvUYIHLAh14Rh1LQkt
         DMYA/rUz0fscDm7R5wTUjKAlGRtbWbzt8mpHMTzRZdKzyo5Yl+zqx7GHyegErrztgpPN
         20Of8TVjRyUac+Nj9sEwJFGEJEfY5EVJ0Wl0Nm8Y/DhRuCjnNjI7sKqLU7sYltrVuyby
         oRJBnQAJrnK/cybxWmth8rhOkwaHOUqBMKWGbWO+OjYaUxK0EbPjsR2g1z398I3ELhUI
         B8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCX1VNdbbyxNdHxLq/sfPHT104zYUZOXEyOcp7FXiVYhJu+E0v0ComQg4+uBEuUAMAYFmYg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3xss8cIaNhRQg7i/mjV6WknLaJEV+1FjpMrYEJc7njU6XbrP0
	zym7mWA+PwSKxBhpmXlK520cJPmp7ozHpCpH3CrVQM+7OXKxuL7ALSVJZSDZ8bc=
X-Gm-Gg: ASbGncuMFaxC/S6f3syEpoRW4/HBVE+IvVxwGW3e4VucGOEh+5uUzu7tTdBzFbiiaCd
	Ii50WHfFj15JjczEYRb0NfCeW8N3aa+UWXexBWWxaOcmB1GOR6SSvbCsdYqw6baeAGG/OczWatB
	hWZuubSNl9yfrsfJpucLEmOK5OFLVVgmUXzKuUVgX2mnmfvEMSvSNwvDlycEH1Pv5uShW61MV/n
	oc4FaWVWzNOEVYxSKIqMsLNWdXwDdQ3PcVh0OFywACrVgSq2Uyhl0INujzyw7hMDzfLJODGXlnd
	2NEiC5bAWT4jFLOgTJbRiztPJSR+1QqmrXpa6hE3+NvH
X-Google-Smtp-Source: AGHT+IHS2PJ+/kxwhPkSsqZSy1Lcoi2dOdo4gLmR9Sx1nH5mZxTPaitClYNterYld+kjauOZ34q9lw==
X-Received: by 2002:a05:6a21:164a:b0:1f5:60fb:8d9 with SMTP id adf61e73a8af0-1f560fb098fmr15311166637.33.1741666148378;
        Mon, 10 Mar 2025 21:09:08 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:08 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 10/16] system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for common code
Date: Mon, 10 Mar 2025 21:08:32 -0700
Message-Id: <20250311040838.3937136-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
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


