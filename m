Return-Path: <kvm+bounces-9872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E658678C5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57A091F2D9E2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BB712F59F;
	Mon, 26 Feb 2024 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FNECOgvY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CF512F586;
	Mon, 26 Feb 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958108; cv=none; b=eLxYE0ptXUef4QG5QguP1BSN+1jCfIineckgltKKLtSUqJoCh5TubYr2RXMACGfP0/S0EmFSoyz/YJw+OurK/G5VR0gPHWzRXQ3zMpM24zpwr9NXMUS5p9Uyjmq9Z6jWXcJC49tDynw2A9Zv/8bQZdsTR7JUsWzUGTifIz8vods=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958108; c=relaxed/simple;
	bh=vB6QlPmmK8kXwQBtLPQg8xVtiKf4ZcuKJbsohLPdMp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=brdWIHY6xnyQsdNFouorpVGtaJZMqHxDN9bJZq/MM/cMfOl771UfMKmDBPIJ/C6m2xwkq0kngy14V6wIvACo1t4Xmh+EeD7cqmU+TaDqwgf+W8U0lDwfLt2mnP9goO3jKsEJ7KlQQQ497fkMZRvcGWYri0xw0K4gudeqjRVUsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FNECOgvY; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e4670921a4so1636112b3a.0;
        Mon, 26 Feb 2024 06:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958106; x=1709562906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7Hh2Afn1QJ5FCuqDR4QoSv7xeyDbeCLAUAuNj6SkwU=;
        b=FNECOgvYh310vlvBfQ+tKGCeoPCzB8p2NsBa9PH2P2EC32kLiLaGC2u2LT9HDBdwtW
         Mh5GwmeO0NWsUzTE9QddK4BdQe2vBwehGMxu8hnb97FKWcYvlDWlUxsRUaBs6LmwcD4F
         Q8K5QFqGTm8p2TwgrNTk7Ti7E0QaeNfOFeiZl8kj3hMycHop5P7eGOLd1hRkfeiVsllp
         6GFEmNJYZ1E8ldlyTjvmpKdLcgiAXA9LOEMzMUsf0uWt9Ew19cMtMCqAQLmRoC1bRqyX
         4KQC0yEQV6Js1i12/M/bsK2ZwjumeuYZgEt0309DcfGTmhnuD2JyHmnAhoWlkpy6jV4w
         30gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958106; x=1709562906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7Hh2Afn1QJ5FCuqDR4QoSv7xeyDbeCLAUAuNj6SkwU=;
        b=nuQW4BGTO8nzewN8ywfbflW2F4MFeRiQUn1zmO/uv+g2Msf94q2akftCLb2/kOSqEE
         pf0DQi0oGSFDNNxRMi2asyg321pOhBRrjNdkGHfHlcXxynuw6y3dtcjvZ5mJ1HLBzFy/
         eTORJ9UrJjnzx/72L2tYp3WEE/3PRNb3SS/skbpoqs/Xc4wOzRw9j6iOwNoJtDfSLhUy
         2WT9FyvtWz1xbcsQbMrrzRTW89M51sotsAKfU07L/j6Q7wEupYirMx8BJg8XzQipPR5d
         IdZ7gqlWVTVpeNWi+lwDBiIwaZcHv8VeVrwi/EHdAm5aAbD1hQVnAeh2gZ0qkbob/DjO
         Ro/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU2dD9tkfIELgKn7N3f0q0QA+mFvc6ju4XJQV97OF7pYjj7SZL6IJuXW3oZ/dC8UzxIv59WUagO4VD0QIxhfzU86ZWS
X-Gm-Message-State: AOJu0YwOXo4EFW0SuHB68uEU3yx+eF5H+TfB7iAaDOctLYU3iKO+BQwi
	W5PSiI9Kg84do2rZfhhd3Vil0SW3MAedQ4RO36VWURcEjya9Pwqd/GQIwZUW
X-Google-Smtp-Source: AGHT+IEv7XU1rNRba9oMMqkV+6qN+XVjpodubAS8NJsRtUG59QJZkNQNkRTDYqCvVVP66O5TiXM94A==
X-Received: by 2002:a05:6a21:3183:b0:1a0:ea31:c34f with SMTP id za3-20020a056a21318300b001a0ea31c34fmr9518737pzb.38.1708958106285;
        Mon, 26 Feb 2024 06:35:06 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id t30-20020a62d15e000000b006e375ac0d8dsm4276032pfl.138.2024.02.26.06.35.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:06 -0800 (PST)
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
Subject: [RFC PATCH 09/73] KVM: x86: Add PVM virtual MSRs into emulated_msrs_all[]
Date: Mon, 26 Feb 2024 22:35:26 +0800
Message-Id: <20240226143630.33643-10-jiangshanlai@gmail.com>
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

Add PVM virtual MSRs to emulated_msrs_all[], enabling the saving and
restoration of VM states.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/svm/svm.c |  4 ++++
 arch/x86/kvm/vmx/vmx.c |  4 ++++
 arch/x86/kvm/x86.c     | 10 ++++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3bb30b40876..91ab7cbbe813 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -31,6 +31,7 @@
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
+#include <asm/pvm_para.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
 #include <asm/debugreg.h>
@@ -4281,6 +4282,9 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_MCG_EXT_CTL:
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		return false;
+	case PVM_VIRTUAL_MSR_BASE ... PVM_VIRTUAL_MSR_MAX:
+		/* This is PVM only. */
+		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
 			return false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fca47304506e..e20a566f6d83 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -43,6 +43,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/reboot.h>
 #include <asm/perf_event.h>
+#include <asm/pvm_para.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
 #include <asm/mwait.h>
@@ -7004,6 +7005,9 @@ static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_AMD64_TSC_RATIO:
 		/* This is AMD only.  */
 		return false;
+	case PVM_VIRTUAL_MSR_BASE ... PVM_VIRTUAL_MSR_MAX:
+		/* This is PVM only. */
+		return false;
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ec7a36cdf3e..be8fdae942d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -84,6 +84,7 @@
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
+#include <asm/pvm_para.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -1525,6 +1526,15 @@ static const u32 emulated_msrs_all[] = {
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
 
+	MSR_PVM_LINEAR_ADDRESS_RANGE,
+	MSR_PVM_VCPU_STRUCT,
+	MSR_PVM_SUPERVISOR_RSP,
+	MSR_PVM_SUPERVISOR_REDZONE,
+	MSR_PVM_EVENT_ENTRY,
+	MSR_PVM_RETU_RIP,
+	MSR_PVM_RETS_RIP,
+	MSR_PVM_SWITCH_CR3,
+
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
 	MSR_IA32_ARCH_CAPABILITIES,
-- 
2.19.1.6.gb485710b


