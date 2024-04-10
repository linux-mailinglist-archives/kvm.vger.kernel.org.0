Return-Path: <kvm+bounces-14086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BE389ED98
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 326A41F22C5C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0545113DBA4;
	Wed, 10 Apr 2024 08:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gG76D+bS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598213D8A3
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737727; cv=none; b=s7OOVaLA+jqDL2YZtsaFCakNCTXyQoie23p15mP3jcf5azYTQc5V6jOa9Vs8WWDlZ5gawjV8zxftvHtsPwRMX8sYIQv169lvm4bh1RUwv/lBS02rPdYFxr/ASqMOhnfgc2EQr2pBazNTaVa/E0JYNhTigA8MeaX1NQqQmIhklKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737727; c=relaxed/simple;
	bh=HHFQuNlgwp5z5UY2GtW1vIEvCtXKdaIbP6MhEmpQwXA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iGICBhnJERCIDS4xDpFh1FtBMlXtPEe4eyqcer+isJyqk/He5QkYkIEHosvMOtwoSFM676nKauEQSZJ//ffgPNrcadFsjEpT0aLuxkBtRDZFYWc5+5+Zn7T805Mg9LdxixKQ5weZR+lz7RK6GcxUSeNAFOxUc3KK/A4p3EGGWyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gG76D+bS; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56829f41f81so9285816a12.2
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737724; x=1713342524; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJqNA1qEKMw3ceQcUL51OvRwoS/u84Dci9ztH9xxHDk=;
        b=gG76D+bSL0LlwpSYAgeC27V+4JSbnMEItFH9zy+Xm/sb6HpMAzavxJJnuCTAUSk2BS
         gRxfKq73zPFjX6hzfwYNNo5uSt3rgNrHsdSDjR1lsMzUPLeyibeBt8k964xq79tOf8IX
         GZBL1XjP1moT2jOieXzSBt/9VVYNay1Rf5YrdXD8X4YnBpWKw7Lc1n6AtGSeZt4gT3C0
         4uypCY3fBzoxDV2lCGQaSFSxOOmmdV2ZWpoD8N6ogydba9ypnh4SEOZmt3F7KrrS8/wf
         t99f9ICfZtxEFwfRNAmLtvIn2N4NFqqqh3JVbONyCYDSckd1iE/0ZzUeJmOqFvUIj4lr
         dg7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737724; x=1713342524;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJqNA1qEKMw3ceQcUL51OvRwoS/u84Dci9ztH9xxHDk=;
        b=unqZpYaxwl1v+165gPJub+TAEC/ztmLWl+mWfa5Sqa4GIj7GS0thoyDEA+zU6QHfUs
         q/RmeM1rkKjL30+RHmhHRUIPelVqAmL1UwUJmDjgP8FsN8ZyyhKQIM3HGRVNO67UtyVe
         ZpK87JmF09/0QjajGl2oF8d0wdIMTnR8IIlpbDU49K1Pw7KF17Cmprt0kTh1elM2vLpb
         GNtt5RAnEyVNIk6H5pEMCo3BCzPHuveckaW+24ek9jaltsyP43RMyuevvARVn8GA+/pl
         MbRHyoKB788IOj1yV71ftHJSFiDPTE0l3/3acOBpibrluC9a8a8IgmFXcskNZaPYHpWy
         7F4w==
X-Forwarded-Encrypted: i=1; AJvYcCUerM00RUao77Jk+o6ZQ1qlFtA6WfwSHn7wOrtaMsXziiuZ5+AXPVG2S+mTSQGQriMt+ybSPNQLWKxkYnIkAbVKcbbk
X-Gm-Message-State: AOJu0YyS+5FnaYs4nvhlNDl1LoNcRqazUVeZ95y6xEd2pAr6fnog5dEF
	14KOyRktaUCknxsxz5hWB+luBh874DZo7b6x0OUTAI8pR2CuBdn8ljhDFZH/W7vTrrpEEU1A6cs
	c2A==
X-Google-Smtp-Source: AGHT+IETbmAd/CnDZsb5LGXlCF0alK/wvVK3k2FJoggB8JQHOb1ojR1ZUaJ70prv5IB1E7a0E9CJ/g==
X-Received: by 2002:a50:d656:0:b0:56e:246b:2896 with SMTP id c22-20020a50d656000000b0056e246b2896mr1440708edj.3.1712737723651;
        Wed, 10 Apr 2024 01:28:43 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id p6-20020a05640210c600b0056e719a9a1bsm1754061edu.16.2024.04.10.01.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:28:43 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:28:39 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 04/12] KVM: arm64: nVHE: Simplify __guest_exit_panic path
Message-ID: <qw5au6bikvkeutkwbsbzlyrlue3yt44si7a2ehzzoliramekjg@ijifwx4fhomq>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Immediately jump to __guest_exit_panic when taking an invalid EL2
exception with the nVHE host vector table instead of first duplicating
the vCPU context check that __guest_exit_panic will also perform.

Fix the wrong (probably bitrotten) __guest_exit_panic ABI doc to reflect
how it is used by VHE and (now) nVHE and rename the routine to
__hyp_panic to better reflect that it might not exit through the guest
but will always (directly or indirectly) end up executing hyp_panic().

Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/entry.S              | 14 +++++++++-----
 arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/host.S          |  8 +-------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index bcaaf1a11b4e..6a1ce9d21e5b 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,7 +83,7 @@ alternative_else_nop_endif
 	eret
 	sb
 
-SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
+SYM_INNER_LABEL(__hyp_restore_elr_and_panic, SYM_L_GLOBAL)
 	// x0-x29,lr: hyp regs
 
 	stp	x0, x1, [sp, #-16]!
@@ -92,13 +92,15 @@ SYM_INNER_LABEL(__guest_exit_restore_elr_and_panic, SYM_L_GLOBAL)
 	msr	elr_el2, x0
 	ldp	x0, x1, [sp], #16
 
-SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
-	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
+SYM_INNER_LABEL(__hyp_panic, SYM_L_GLOBAL)
+	// x0-x29,lr: vcpu regs
+
+	stp	x0, x1, [sp, #-16]!
 
 	// If the hyp context is loaded, go straight to hyp_panic
 	get_loaded_vcpu x0, x1
 	cbnz	x0, 1f
+	ldp	x0, x1, [sp], #16
 	b	hyp_panic
 
 1:
@@ -110,10 +112,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	// accurate if the guest had been completely restored.
 	adr_this_cpu x0, kvm_hyp_ctxt, x1
 	adr_l	x1, hyp_panic
-	str	x1, [x0, #CPU_XREG_OFFSET(30)]
+	str	x1, [x0, #CPU_LR_OFFSET]
 
 	get_vcpu_ptr	x1, x0
 
+	// Keep x0-x1 on the stack for __guest_exit
+
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
 	// x1: vcpu
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 03f97d71984c..7e65ef738ec9 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -122,7 +122,7 @@ el2_error:
 	eret
 	sb
 
-.macro invalid_vector	label, target = __guest_exit_panic
+.macro invalid_vector	label, target = __hyp_panic
 	.align	2
 SYM_CODE_START_LOCAL(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 19a7ca2c1277..9387e3a0b680 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -753,7 +753,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __kvm_unexpected_el2_exception(void)
 {
-	extern char __guest_exit_restore_elr_and_panic[];
+	extern char __hyp_restore_elr_and_panic[];
 	unsigned long addr, fixup;
 	struct kvm_exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
@@ -776,7 +776,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 
 	/* Trigger a panic after restoring the hyp context. */
 	this_cpu_ptr(&kvm_hyp_ctxt)->sys_regs[ELR_EL2] = elr_el2;
-	write_sysreg(__guest_exit_restore_elr_and_panic, elr_el2);
+	write_sysreg(__hyp_restore_elr_and_panic, elr_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 135cfb294ee5..7397b4f1838a 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -196,19 +196,13 @@ SYM_FUNC_END(__host_hvc)
 	tbz	x0, #PAGE_SHIFT, .L__hyp_sp_overflow\@
 	sub	x0, sp, x0			// x0'' = sp' - x0' = (sp + x0) - sp = x0
 	sub	sp, sp, x0			// sp'' = sp' - x0 = (sp + x0) - x0 = sp
-
 	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	b	__hyp_panic
 
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

