Return-Path: <kvm+bounces-7222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A123D83E485
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 23:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B1D9B229E5
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 22:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF2325573;
	Fri, 26 Jan 2024 22:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="siVVOoy/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3518425555
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 22:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706306702; cv=none; b=WfR7vI7YKpVtwSqxQMbPBqC0xMfkevDa+swBXR5ivz+vQSV4H3RvnC4h+ypLT8ULKUtyvDTwUPpVgF1acDDAS3lQH+JXF/J8O4UsHFznMnFt8giSSR1V+j7OKrw9A65wtA9Q75dN2dLd+qYrofxAzF+MymdHGTONKL4oJGmSeg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706306702; c=relaxed/simple;
	bh=2GS7TXzbs4gOQsz7dlHPRJAuYqmooFHjTPUqUNkreas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IkDyfv6yg7VfCVxMvnSuRmglOnoqyMRA672KYbZpMBglISLi4ARkk67yHiNojPTsrBE7H/Htht80O7Fnr2FqbAqcwJoZtckvsBPmzyKWyfTepHbc6NZHHpn2cvuMuMYvCJlz0TEIptegLSKD+3HEw+mvJJ++l2g+V0t8zWRGPi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=siVVOoy/; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40eeadb7151so3493935e9.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706306698; x=1706911498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPu55INOwoo+R5I4TkxjPDT1q0XH169I9oVKNyLzarM=;
        b=siVVOoy/tBK2weCRk193CJJxVvAvScKqTyrHpA6YRqEwop2nHBuvpT+b78IzexwCay
         PEN6LlVWOh3LXjsO89AmFU67qS5HiWKFMPvMSZlGYw9ML3BfbqzKSBnLjdcPN+aXaGhI
         XA3z0LtadZlt8+3PGdsN+2+NS0P/LZUiiT2Sr8U130wNQ6V/C7XVVBzJSO2YncGCuWj6
         rxRej8hHhYD3N67vfnrKTK02Qrt/v4AG6J4roJhkEp4cmG+S2IdClGqFeUz5zeT0/BmR
         IKJhISqDaIIKuzwPaax6ytqi0KXzatdxgJgMDOshHCICWnOHHOgaSrgDRz+wmbrPTpL2
         +7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706306698; x=1706911498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cPu55INOwoo+R5I4TkxjPDT1q0XH169I9oVKNyLzarM=;
        b=f6f7M6ezU2ylAHhXWf0sTykeRjxj7cQuDpVy8f5S+swujm1odaEq21qhLKgBJjBBOL
         K8MkGEk2ys0W/+1/PBsR7KlombfqNFj2HQI50I6ILaT+GNg4lWIcidNY8w+nv9htzOgN
         APbeJnh2B2rgoYegiqcCuWKHg2d3R+D3OQPAVd24XLbiBK+9guy+rt/bJ2wlYbl6JlcP
         jDQa96lkNer+EVVz4K00ZOV3XSciV/jYAjU7ch+fx1u3idAvEW29vcwwr0boFpVuia0X
         X2k+rmiIpv+JH6FFFI6TSQyTCIM+6p+ZMgmbHWEAwD+trDzQpxi+S5hrIW5DEuza0BAd
         V+8Q==
X-Gm-Message-State: AOJu0Yw+F0uURwgEDW+BBoqYxc46oXfDeFu4TacTOll/TC9ybyv48rrD
	s1+p85gDnmasOXrCd6ZSosrxnZDurdy8tRzwoQJzK1pcI8wEpIF/8Ns1QgqmPZA=
X-Google-Smtp-Source: AGHT+IFz1Gm3pWnHWJtepFYUd+mHJkbx4hd3qM79tYeiKpusAyuve3swffXhdA6yAfiWQSALIRnIQw==
X-Received: by 2002:a05:600c:1f91:b0:40c:610d:c2bf with SMTP id je17-20020a05600c1f9100b0040c610dc2bfmr319162wmb.16.1706306698503;
        Fri, 26 Jan 2024 14:04:58 -0800 (PST)
Received: from m1x-phil.lan ([176.176.142.39])
        by smtp.gmail.com with ESMTPSA id fi5-20020a056402550500b005583e670df7sm1016030edb.73.2024.01.26.14.04.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Jan 2024 14:04:58 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	qemu-riscv@nongnu.org,
	Eduardo Habkost <eduardo@habkost.net>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 08/23] target/hppa: Prefer fast cpu_env() over slower CPU QOM cast macro
Date: Fri, 26 Jan 2024 23:03:50 +0100
Message-ID: <20240126220407.95022-9-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240126220407.95022-1-philmd@linaro.org>
References: <20240126220407.95022-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mechanical patch produced running the command documented
in scripts/coccinelle/cpu_env.cocci_template header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/hppa/cpu.c        | 8 ++------
 target/hppa/int_helper.c | 8 ++------
 target/hppa/mem_helper.c | 3 +--
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
index 14e17fa9aa..3200de0998 100644
--- a/target/hppa/cpu.c
+++ b/target/hppa/cpu.c
@@ -106,11 +106,8 @@ void hppa_cpu_do_unaligned_access(CPUState *cs, vaddr addr,
                                   MMUAccessType access_type, int mmu_idx,
                                   uintptr_t retaddr)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
-
     cs->exception_index = EXCP_UNALIGN;
-    hppa_set_ior_and_isr(env, addr, MMU_IDX_MMU_DISABLED(mmu_idx));
+    hppa_set_ior_and_isr(cpu_env(cs), addr, MMU_IDX_MMU_DISABLED(mmu_idx));
 
     cpu_loop_exit_restore(cs, retaddr);
 }
@@ -145,8 +142,7 @@ static void hppa_cpu_realizefn(DeviceState *dev, Error **errp)
 static void hppa_cpu_initfn(Object *obj)
 {
     CPUState *cs = CPU(obj);
-    HPPACPU *cpu = HPPA_CPU(obj);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(CPU(obj));
 
     cs->exception_index = -1;
     cpu_hppa_loaded_fr0(env);
diff --git a/target/hppa/int_helper.c b/target/hppa/int_helper.c
index efe638b36e..d072ad2af7 100644
--- a/target/hppa/int_helper.c
+++ b/target/hppa/int_helper.c
@@ -99,8 +99,7 @@ void HELPER(write_eiem)(CPUHPPAState *env, target_ulong val)
 
 void hppa_cpu_do_interrupt(CPUState *cs)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
     int i = cs->exception_index;
     uint64_t old_psw;
 
@@ -268,9 +267,6 @@ void hppa_cpu_do_interrupt(CPUState *cs)
 
 bool hppa_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
-
     if (interrupt_request & CPU_INTERRUPT_NMI) {
         /* Raise TOC (NMI) interrupt */
         cpu_reset_interrupt(cs, CPU_INTERRUPT_NMI);
@@ -280,7 +276,7 @@ bool hppa_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     }
 
     /* If interrupts are requested and enabled, raise them.  */
-    if ((env->psw & PSW_I) && (interrupt_request & CPU_INTERRUPT_HARD)) {
+    if ((cpu_env(cs)->psw & PSW_I) && (interrupt_request & CPU_INTERRUPT_HARD)) {
         cs->exception_index = EXCP_EXT_INTERRUPT;
         hppa_cpu_do_interrupt(cs);
         return true;
diff --git a/target/hppa/mem_helper.c b/target/hppa/mem_helper.c
index bb85962d50..7e73b80788 100644
--- a/target/hppa/mem_helper.c
+++ b/target/hppa/mem_helper.c
@@ -357,8 +357,7 @@ bool hppa_cpu_tlb_fill(CPUState *cs, vaddr addr, int size,
                        MMUAccessType type, int mmu_idx,
                        bool probe, uintptr_t retaddr)
 {
-    HPPACPU *cpu = HPPA_CPU(cs);
-    CPUHPPAState *env = &cpu->env;
+    CPUHPPAState *env = cpu_env(cs);
     HPPATLBEntry *ent;
     int prot, excp, a_prot;
     hwaddr phys;
-- 
2.41.0


