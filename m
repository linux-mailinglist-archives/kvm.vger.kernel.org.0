Return-Path: <kvm+bounces-27201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 203C297D22E
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 10:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99A831F2566E
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 08:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFAF136658;
	Fri, 20 Sep 2024 08:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adQyDcw7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E346BFCA;
	Fri, 20 Sep 2024 08:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726819257; cv=none; b=ISY3ZPUvgIwJlhX56X5Br/PrcwmfSkL/V2DUg5+Z2OXQstfB7mZR9zN6xoUOGRfhcm61chUIi9hEbm7hQmnqq4S23uideWl7RvLxZduMA+rZ9QL/6ggSWRswDov4j9V175xNtJV60p1vHQbmYVJ8LGCzILhgTw4P2B6EFiQ2I+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726819257; c=relaxed/simple;
	bh=FP8V9FE3quXHgtKd8N7ubCN8ICkoOdkN5v51n5N+VSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7uhz2e0CoH0Zd7gMljLQEnDEWI+8dgPi8RKiWfl7MbpfcLpoF1Nxc0pkfHyLRJUve38uREY5FyRT3BE97KdAPjqkI+zrMpmbJVK9t6EHZBH1Bah0+nhQaq2TY+9h43mTQ7qU6uU0oITNpaGCM3cVDPtWa0bqcJREog5oVyLFNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adQyDcw7; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53661ac5ba1so1800252e87.2;
        Fri, 20 Sep 2024 01:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726819253; x=1727424053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjFCFoukJYVr8e7ixtkyrqDFf1DCsdegWZ2J5huFjNA=;
        b=adQyDcw797RYI5uz/ICJRcl7G99O6ul3HoHg1pilQhEiXogj9W67b7yLYTQuTHoGbz
         zc3lT0CPmMDpLig0Kgt1C86J46IajKlgU5B67O1P1WOT70UYP9MZ6HwZlZBw2hR9RDcL
         OpRTMcmHw/A3sUR9V3X/EvqCatM7N6gulQ0CaDkaaKaI+swa26qxsn8t+Q2MTm9qepXg
         geihGQDkaVNsEwYRiY+Qxsq3PTNMyHaL9FvziiTUTTQGfFHUw9lvNeWa3cTh5WhVoKwi
         OcMSl96ebQL0IBAxXB7NRiaFfXuwcShRYlyyiVX5nm5r0XRVpMrHbXFtRM2Ut0H4X0cm
         qSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726819253; x=1727424053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XjFCFoukJYVr8e7ixtkyrqDFf1DCsdegWZ2J5huFjNA=;
        b=i/0WWT+dH4VhjujZJJKiYC6Ep+Dqbfe36QG/iJKNF8i2aaSBVu2fyNs7p6X2TT7sgE
         RneSt3kAtM6uwFZUn2ucBjKEWDjZCySz0SDiPM1Y/Kr6zoLYRAwhjQb6K5SvppYVUQku
         fFBqf/VvASOz0kZVeQGObbspXZCKiJieICRkvy9iZDWrajnKvlqnoM3J+Hwk6oBrcyex
         O1djmo0Ck9V6ZAZfI1hOWa4g24vWEBXKfsfDujIvcmVw54umS/mgbcmJ3ivgqIDztswc
         sMPit+MAFbJkgRm2cnRXzg3BjchNlA6XNCpivDPhjDRzYRBT8ReUWXENtjnfD0hu4axb
         8wWA==
X-Forwarded-Encrypted: i=1; AJvYcCUKVWe9b22+WthEw8OJ5EbmOswUXC8iBDyqdwhFYvr/+qNzpsQ0k8LLZ8DPRHhrHimkRTM=@vger.kernel.org, AJvYcCW71qXfOuOkA9n+LlS5mC4gCXY45/l9BSPqjD+MbLhBI5zBddFcVKtyX0v+s5HtV6hDHtC6rL4/xI2OBb+H@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8/uswPb7/37BI9G/kF0L4j3tbHRdMZpeEL4GwK3E9LNz30jjL
	CV3QaEIHESbz4or/RFoCWQoz/GR33fcZOwPF/8o0+l7q5F0AWqLD
X-Google-Smtp-Source: AGHT+IGhQHYidMkaZzuMDf6phq55jUr9WtdP3LkYw6wKyUd4sfZpM7gUf5kqMgxMR/bGN4328LcLyQ==
X-Received: by 2002:a05:6512:124e:b0:530:b76c:65df with SMTP id 2adb3069b0e04-536ac2f4e55mr1129237e87.35.1726819252924;
        Fri, 20 Sep 2024 01:00:52 -0700 (PDT)
Received: from localhost.localdomain (2001-14ba-7262-6300-2e4b-7b61-96a9-b101.rev.dnainternet.fi. [2001:14ba:7262:6300:2e4b:7b61:96a9:b101])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870c55d1sm2070030e87.305.2024.09.20.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 01:00:52 -0700 (PDT)
From: =?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: mankku@gmail.com,
	janne.karhunen@gmail.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
Date: Fri, 20 Sep 2024 10:59:43 +0300
Message-ID: <20240920080012.74405-2-mankku@gmail.com>
X-Mailer: git-send-email 2.44.1
In-Reply-To: <20240920080012.74405-1-mankku@gmail.com>
References: <20240920080012.74405-1-mankku@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Running certain hypervisors under KVM on VMX suffered L1 hangs after
launching a nested guest. The external interrupts were not processed on
vmlaunch/vmresume due to stale VPPR, and L2 guest would resume without
allowing L1 hypervisor to process the events.

The patch ensures VPPR to be updated when checking for pending
interrupts.

Signed-off-by: Markku Ahvenjärvi <mankku@gmail.com>
Signed-off-by: Janne Karhunen <janne.karhunen@gmail.com>
---
 arch/x86/kvm/lapic.c      | 9 +++++----
 arch/x86/kvm/lapic.h      | 1 +
 arch/x86/kvm/vmx/nested.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5bb481aefcbc..7747c7d672ea 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -952,7 +952,7 @@ static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 	return highest_irr;
 }
 
-static bool __apic_update_ppr(struct kvm_lapic *apic, u32 *new_ppr)
+bool __kvm_apic_update_ppr(struct kvm_lapic *apic, u32 *new_ppr)
 {
 	u32 tpr, isrv, ppr, old_ppr;
 	int isr;
@@ -973,12 +973,13 @@ static bool __apic_update_ppr(struct kvm_lapic *apic, u32 *new_ppr)
 
 	return ppr < old_ppr;
 }
+EXPORT_SYMBOL_GPL(__kvm_apic_update_ppr);
 
 static void apic_update_ppr(struct kvm_lapic *apic)
 {
 	u32 ppr;
 
-	if (__apic_update_ppr(apic, &ppr) &&
+	if (__kvm_apic_update_ppr(apic, &ppr) &&
 	    apic_has_interrupt_for_ppr(apic, ppr) != -1)
 		kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 }
@@ -2895,7 +2896,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
-	__apic_update_ppr(apic, &ppr);
+	__kvm_apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
 EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
@@ -2954,7 +2955,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 		 * triggered KVM_REQ_EVENT already.
 		 */
 		apic_set_isr(vector, apic);
-		__apic_update_ppr(apic, &ppr);
+		__kvm_apic_update_ppr(apic, &ppr);
 	}
 
 	return vector;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ef8ae73e82d..1d0bc13a6794 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -106,6 +106,7 @@ int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
 void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
+bool __kvm_apic_update_ppr(struct kvm_lapic *apic, u32 *new_ppr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
 		     struct dest_map *dest_map);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254d..dacc92b150dd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3431,10 +3431,11 @@ static int nested_vmx_check_permission(struct kvm_vcpu *vcpu)
 
 static u8 vmx_has_apicv_interrupt(struct kvm_vcpu *vcpu)
 {
+	u32 vppr;
 	u8 rvi = vmx_get_rvi();
-	u8 vppr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_PROCPRI);
+	__kvm_apic_update_ppr(vcpu->arch.apic, &vppr);
 
-	return ((rvi & 0xf0) > (vppr & 0xf0));
+	return ((rvi & 0xf0) > (u8) (vppr & 0xf0));
 }
 
 static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
-- 
2.44.1


