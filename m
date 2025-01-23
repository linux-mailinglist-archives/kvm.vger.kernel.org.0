Return-Path: <kvm+bounces-36443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE1AA1AD60
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D149188D078
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3FC1D5CFE;
	Thu, 23 Jan 2025 23:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uXeQO0jQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3D1D54FA
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675887; cv=none; b=MAnBhJTvfYRVlif1Vyp2shZI/LMmJJvW+TPYa4SPHhrpsk+4aOjFgrOU15HCDTozUOHIZD6hWO0yHEevMrHhb5ajuNA93baFQFC5Rlu2duNv6SR06JwqPp6KodlAeMydtcPpIm6Jk6Lcdjr06ZEMcSKbHDG3apjGfwoKS9zZf7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675887; c=relaxed/simple;
	bh=7grupjrAN4h3Wqn2lUGXS0WyifK3HjLlFi/Y64G9+3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGbsnS0nT/4Ujrml5Hw8TnItd4DZp6g6l3JfDK6YJ/MgpSoEhAm8YOJYuKwlaeNzrfjV+pbf5jUMK5U2Gq6iveZbMnDh4YwUnKe6JWH9O029AzRxqtwMDUSIRV3jak6ZZzTpgyTiOeuVBdXr6pWaMy/cRceHPF+S5qadYX8kC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uXeQO0jQ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-38a8b35e168so1073181f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675884; x=1738280684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89WHzW+ji4rB+60gFYzeRD9ADgUNDHjcXvYSPMINgc0=;
        b=uXeQO0jQRsLrlM9Ynh4b+FajjSpEtTRSZKH62dVWTZ8tCeSBQ8rkhui29FiN7RV1U8
         RMSxvldmMbZvj/w0bXkfqnzHfMJUffC+u1Z6kuLilGqWaRedFvZg/nOMfSRwlMPrAJ3/
         SMqKkni57YznHppcroTLUAUuULbr2ZSDT/MQzAQcugpkorBiAIpttYGpskf17i0rPYVV
         v+gWZZZ67D94+YvzU/L8HneeNrWXVovLJH5r6uQxU8AzRKyBtLA0F64kWZOzyOhYWXAC
         jqXQ8i/CbBWkY3RjsNOZqK3Y2dM68m2qltDiqFml/2kjP/W0fi0xmYfrPtInF1PDdEYb
         U4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675884; x=1738280684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=89WHzW+ji4rB+60gFYzeRD9ADgUNDHjcXvYSPMINgc0=;
        b=wTzXpryz1ssPperDJyMYoD0GgfFeXFrYxlftctd6jpXzboGplIQH/uaMK8rMNvKsS4
         NP6HIpFUJNZ5VsHHihqvOfJ1bDSvI21UhptmZeTKpWgoaj9izsr61Zuuy5cpt9GkZ/tI
         OSdJwkaqhLhPjLyNzeqy1gbARX5zPdz016CNpa7Ts2cgCE+3DfppvrqyldKur5T/ASKQ
         iJixAifZiGCxPmH8905yTACj68TvmIJwr1eb/yk+JNjdFXOsiYPxzmqlp0FR0gsKlraU
         EogJSEgqdxT8eBwlnMUWN0QiiYoKaeUZ3u4bj8ezsWprFstQcGqcihsvCh4d9EqRLB4R
         KaTg==
X-Forwarded-Encrypted: i=1; AJvYcCUx39+qzq4MZFZFGW+gFAxMlr0WFSHMZjR+YqyVJxS0iVSs/ugfYUZpn9hgdL2MwkRJMhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyS/HwjOKHuRA6RDXDg2+70X86zYs/nL9pm97n9ZXGJiIMGTyU
	I8TpVDsvu1Km8TOxpxzFemFJ1rGEb5EgOyOT5/0PA0WZlWFKxfDwlKS9vMOijEA=
X-Gm-Gg: ASbGncutX88RftmvRaRbeEOv94iKWDgb6liv0njYNK9sB845nTsy1Ze/5+GcR1TO+2m
	asXa2POQqsxKjD2uJ6A/LRyXGsaSLlbEIjazBQDykHlIusvpQO8NF6MyWvVhr6Ku5t+5+OSbM1/
	dH0LHLJpy6o5jgs9rGSyzaDBXOrCkhIWTuo4wMb1KuMxbBd58STag9J165dvlW9NgGUoCT7dCKL
	39tMw0yHG5ferIxchhebr1oVidxYdYVfsmHvy1imELHOgnx8D961lxW6fLuunYmbNnPLg/IzPnr
	OEOTmPXTxdiR0tDsWIR4pInUoa3am11x4yYUlIzDnwHEU3Z479JzDI8=
X-Google-Smtp-Source: AGHT+IHfcp2D5aSm8Sn0VT4IidLdBYhD/KSzWcZHka724j1qpNfMP/dVIsxPCprx8nPoBb5TgAtEpw==
X-Received: by 2002:a05:6000:1fa9:b0:38b:f4dc:44ad with SMTP id ffacd0b85a97d-38c2b65ebf8mr997845f8f.5.1737675884076;
        Thu, 23 Jan 2025 15:44:44 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4d29cesm6991745e9.35.2025.01.23.15.44.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:44:43 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 05/20] cpus: Keep default fields initialization in cpu_common_initfn()
Date: Fri, 24 Jan 2025 00:43:59 +0100
Message-ID: <20250123234415.59850-6-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

cpu_common_initfn() is our target agnostic initializer,
while cpu_exec_initfn() is the target specific one.

The %as and %num_ases fields are not target specific,
so initialize them in the common helper.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-target.c         | 3 ---
 hw/core/cpu-common.c | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index 89874496a41..75501a909df 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -234,9 +234,6 @@ void cpu_class_init_props(DeviceClass *dc)
 
 void cpu_exec_initfn(CPUState *cpu)
 {
-    cpu->as = NULL;
-    cpu->num_ases = 0;
-
 #ifndef CONFIG_USER_ONLY
     cpu->memory = get_system_memory();
     object_ref(OBJECT(cpu->memory));
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index ff605059c15..71425cb7422 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -244,6 +244,8 @@ static void cpu_common_initfn(Object *obj)
     gdb_init_cpu(cpu);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu->cluster_index = UNASSIGNED_CLUSTER_INDEX;
+    cpu->as = NULL;
+    cpu->num_ases = 0;
     /* user-mode doesn't have configurable SMP topology */
     /* the default value is changed by qemu_init_vcpu() for system-mode */
     cpu->nr_threads = 1;
-- 
2.47.1


