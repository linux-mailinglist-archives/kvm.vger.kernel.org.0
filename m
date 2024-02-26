Return-Path: <kvm+bounces-9888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 842208678E4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 243EF1F2790E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD9DF12C7F7;
	Mon, 26 Feb 2024 14:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXBfCvkY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE4A13399F;
	Mon, 26 Feb 2024 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958162; cv=none; b=EMUWJqLhN62GUxv3++vPOL/j61Ub923cDG2tRAFOONJz3UhtYxdNTErtZhVkL+9IaCbJJxNhJMePAaOAbY9tcwKwq/qmbOIm7wWm3n8m4NciaSir0j1vVXDWHpo/v14GCwGUzfGUJmFueqLzfCoMzg5Vv4icW7nrdCJwveEnylI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958162; c=relaxed/simple;
	bh=pkXKcagVoUrfls8IZw2n6mmAXzIWVwR2aUX+9PNq4Ls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eodqSTfeuuP3TuUdDvUtmyNGCs4c09SWZYcfOSgZw4bFI4YIVkTQkIUhu6clYIPi+Ihaft1QlAhr2GZUiO8jNkuZDsqm5LTVm3mXmHXbG1X236XfEVVdYcnRQ4npX+y9tFR5Qrcme5CZiLA6E3GowPeR9o0/m1tRaG4oKIZjOk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXBfCvkY; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so2021669a12.3;
        Mon, 26 Feb 2024 06:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958160; x=1709562960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0jozFDje0mLN9coijYdqOvVfSSMDTpV9h2OeBFaDVOU=;
        b=UXBfCvkYIvmIvIACUAcHD7+X/wXG9DEXmEpNshxYTOvRnKa+OsjmwvwEEgo8A91pJb
         b2fU7/N6YFUbrDcFynuHLJSoPQjSeRvsW1zkhIPfMKU5tNg8KMg52Th5c0s8jYtCpBeW
         NwkS3TRNdeI0MhUT5e0E/BtYeIMmOHeH9Ia4uJY5Hy5NY4QmFE8YsaHvLekc3Y09mNIu
         qwy2lJXgCNwEh6bxJzvrgNJtRyMlVooCjBEUgsshBzM3JzOklkhe8R1rK+9A0HaTAjUH
         /gPZ/Trn4cDtR4ZeP/yDKeNQV8QwqN/+92WCwm8lItYHdaBNZfFTXuYgeom2+pOiDdq8
         8mqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958160; x=1709562960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jozFDje0mLN9coijYdqOvVfSSMDTpV9h2OeBFaDVOU=;
        b=TjnvCL9zJFCYTAqYTgbNT9OfCCWUtKCesrY/g1lbDZeyAKspdK1svCsOoZW39PttX+
         spe4jEVH7m2Q8Uye+sZU1SdNw6LPI7UXsn4Gsi4aaX3EE/Y5FaMvBi96lw2cDZNbZ+c7
         rOgNlQE1hF47I0LHOe6johOWRuEIYQkIDbtyW4AAHUU2uoWQ848JrJ8U4jt+0rk7STKz
         a43LX5CXnOEwqdnrftcpi33moON9z498vk2ql9xFy5weAXAdUYDuMcS/HWNSG5P9eROa
         u3d9/Ia0Js5t7auJkQrI8k1K0UondgR6DMroh4yc+RLHKdFugppkrEX8RayD7xQee3uF
         N/Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXvi39gVkVMzgOziQuOjdc32ps17mAZ7pYFZw9mwMMUI8hqgcOoBDAyHG1GbTrfs27PLL/SNgH4X5E6jnspARQKUL6A
X-Gm-Message-State: AOJu0YxsUs+3dmGACIU4wh0XtRcU/UogleGxtX42P9VciWgnTQtUNbSn
	MppvpGHktw9wy9k+IOeMw8uUWy5zpf19s2F28uvJYk8GkRn5YSIuyoPE5ZTI
X-Google-Smtp-Source: AGHT+IFYLWbfH3g6LFVQ3GaEXvFm9BatfltE1NholegVyczA8+K3NeZcIQavpkYWVcIHl7qwAcIEcQ==
X-Received: by 2002:a17:90a:db86:b0:29a:2860:28b9 with SMTP id h6-20020a17090adb8600b0029a286028b9mr4563991pjv.48.1708958159681;
        Mon, 26 Feb 2024 06:35:59 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id sw8-20020a17090b2c8800b0029abf47ec7fsm2333867pjb.0.2024.02.26.06.35.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:59 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 25/73] KVM: x86/PVM: Implement APIC emulation related callbacks
Date: Mon, 26 Feb 2024 22:35:42 +0800
Message-Id: <20240226143630.33643-26-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

For PVM, APIC virtualization for the guest is supported by reusing APIC
emulation.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 3735baee1d5f..ce047d211657 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -566,6 +566,25 @@ static int pvm_get_cpl(struct kvm_vcpu *vcpu)
 	return 3;
 }
 
+static void pvm_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+				  int trig_mode, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+
+	kvm_lapic_set_irr(vector, apic);
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+static void pvm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
+{
+}
+
+static bool pvm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
@@ -1083,19 +1102,25 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.vcpu_pre_run = pvm_vcpu_pre_run,
 	.vcpu_run = pvm_vcpu_run,
 	.handle_exit = pvm_handle_exit,
+	.refresh_apicv_exec_ctrl = pvm_refresh_apicv_exec_ctrl,
+	.deliver_interrupt = pvm_deliver_interrupt,
 
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
 	.handle_exit_irqoff = pvm_handle_exit_irqoff,
 
+	.request_immediate_exit = __kvm_request_immediate_exit,
+
 	.sched_in = pvm_sched_in,
 
 	.nested_ops = &pvm_nested_ops,
 
 	.setup_mce = pvm_setup_mce,
 
+	.apic_init_signal_blocked = pvm_apic_init_signal_blocked,
 	.msr_filter_changed = pvm_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
+	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
 static struct kvm_x86_init_ops pvm_init_ops __initdata = {
-- 
2.19.1.6.gb485710b


