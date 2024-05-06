Return-Path: <kvm+bounces-16671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B448BC7B5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01C4BB21020
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 06:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A784CB58;
	Mon,  6 May 2024 06:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="Eyholpta"
X-Original-To: kvm@vger.kernel.org
Received: from out0-205.mail.aliyun.com (out0-205.mail.aliyun.com [140.205.0.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDC3BBE8;
	Mon,  6 May 2024 06:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.205.0.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714977635; cv=none; b=Ubl06JecTqwV3oEdUHHZhnWzqYfGozv/cRFRuEZDAQq5X6/vpLEx8DmyaKqvlwIuzZvaE/c6rJn1YTos1d3gb5iZjhNxrLVU9FQIcmMe5ywHEIThiEQ+Cjmdyqfqn9y20HWw0ooDmLC6EDnA33OUKAaDYy/S7I83XkgRlmSXpJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714977635; c=relaxed/simple;
	bh=b4NdyE1ZnxlIwsmiHmeEWfBCM1vM+RJZsgiLZoYAbQw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bHxnIDDTXRLpDsQwQBSDCvvkwk8OVsD4ZVPQPNuxD24IQT/ag4Vngi1uuYyBdMQLKgLVfaIc9Twdh3WpVHPT6DNu/C0dgiNZq0TzY+jeGGKHWGanCfkGvFYTqeatlhJaL2JzwvKpCRdOtQUosEQELxSH8rVLtL8iZ6NEgvsSawQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=Eyholpta; arc=none smtp.client-ip=140.205.0.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1714977624; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=+vIiNGz7/nSUnyUkrfDgHWmF9A2JC2J9lYHADP4TXOk=;
	b=EyholptaJoMYwC+thC3AixeIRt59BN07d6tRSlhLiU0q7Qo2s1K9NsfXNJH9fNLoz1CwmFQOxUb8+HhxsiUM7nm2u1Gaz7X1A0TBdCKZblNll7MWV49ajIgfEzifydtx7EZoL0PfdVHkJqC6niDk/QFNgfSbEvxAduBJm+nBt5s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.XTE-yLh_1714977303;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.XTE-yLh_1714977303)
          by smtp.aliyun-inc.com;
          Mon, 06 May 2024 14:35:04 +0800
From: "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Drop unused check_apicv_inhibit_reasons() callback definition
Date: Mon, 06 May 2024 14:35:02 +0800
Message-Id: <54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check_apicv_inhibit_reasons() callback implementation was dropped in
the commit b3f257a84696 ("KVM: x86: Track required APICv inhibits with
variable, not callback"), but the definition removal was missed in the
final version patch (it was removed in the v4). Therefore, it should be
dropped, and the vmx_check_apicv_inhibit_reasons() function declaration
should also be removed.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/x86_ops.h      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..a10d7f75c126 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1702,7 +1702,6 @@ struct kvm_x86_ops {
 	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
-	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
 	const unsigned long required_apicv_inhibits;
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 502704596c83..4cea42bcb11f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -46,7 +46,6 @@ bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
 void vmx_migrate_timers(struct kvm_vcpu *vcpu);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
-bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
 bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu);
-- 
2.31.1


