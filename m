Return-Path: <kvm+bounces-9874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7A68678CB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F6A29015D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E8912BE84;
	Mon, 26 Feb 2024 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bf9JCjqC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A212FB24;
	Mon, 26 Feb 2024 14:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958115; cv=none; b=j6ADMZK8gXmd+nsuMvxdTSe6wafA03dYDenjEBBKlultfbw6DM0pG/lu+uhJ8mGcReO2/KSzUTCs4UjQ2SXctr8TVoml/IFwayxt+3YOxbwci6xK/2qYdWUwDUj7HE7cwzoU+Uo1d5CO00Qd8OKz4XBHVB+Ow+ZCFvR90GAGFgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958115; c=relaxed/simple;
	bh=MIk0n5o4+C50ulodEC5+4A8eHcWwizVFpO2CWdaU2Yc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hx8jy9ooHMR0Vl7BwSv37zg4BAF7dDAeJ8QQ7yeTlajiIh3kvFv1PKiQwA5YCThTmwGo+ntjRCdEysoMapmpTOoV1AyWbme/1tF+QUWwnHtXhqzUjDHXazGJ/w2c1ubjyG/RqPYBeOcbS9wmqfLI0dRUMJmf3pEqnyNwTKaDu0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bf9JCjqC; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6e4f45d4369so744491b3a.0;
        Mon, 26 Feb 2024 06:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958113; x=1709562913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EXD5rGmwv6zXLURl1tisTGOYWsO2XTKjX2ulEK0E4M=;
        b=Bf9JCjqC5s2VRAAs7xxrHHc9ip6qSCwHMZmOFZegKXSkEG8o57J1gtnMcv2hEnVvfg
         KuhUDTnOqgf62BxCqUIMABoYYuTSAQTQi6Ie4fM8wXQhThuAJP9Gw85DFBQhZO7RA9/r
         fCKAZ9idDZrF03C9l9rEIqQZUQEze8lBdXgU8BY1HXgUTZIl6Yt4nySBKcHhBQnDHFbh
         lEkShKvuWrONiEN/HxHwOkTUPAk/Gu1iDBzu0b6YeJEZCDOv479NAsFqwcoKe76G73W8
         2sa+DB+G5+rvU2pSBynp06LYrvE+L/cBLwrz9tWuDGzhygEIP0b2hVK9eH2X3VSzIha/
         Oalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958113; x=1709562913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9EXD5rGmwv6zXLURl1tisTGOYWsO2XTKjX2ulEK0E4M=;
        b=YtrnMOKXncBoHxLzLiCpqqBLw43FqNhdUOGQBJ5qxYLv2o8x+g/y3bpHCeXi6Gilh7
         huzm5LDy4cIUtX2ImJBzNdXSjzosS124Ba1n7k/2OiGLDO5nyCBh9K1bO1mTpTK47BjS
         BD04Ry1Dx3QUwtnYFM+/JfB3jyDWsUUwMZzTD9gEJScTvcLV8+4O2uINH7raFShod96G
         939bBfiuBL3PrNh4LrfpcffTw61TW9DBbsMahrqvekp4TfMSyTEX4EHkdtOp6LMV2FW6
         Y6aamfm646XBgUGUH0dufuvtNLT/gwcJGrY9xy+fO+VI1smCTxuneM38lV0F38mHE1T4
         C8VA==
X-Forwarded-Encrypted: i=1; AJvYcCXVYzu+PqL+oYllIjVITo/ePKPQKspuwo3+vAr1EPko3BX3qG1cmWX2f7nfUaM2V51VfEGKY7R+g+8Zy4/5wJ3b2qx2
X-Gm-Message-State: AOJu0Yy/HBqL9KxluxmG3zWt/hTr4JNGn04gLk9YOj+pxtkqhSPs8Xf7
	Ni0YTyVbbBLD5cbEcFv45P4c6DR9drsVznnM4yn+vzgsAk6DVxfibl5D0Vq3
X-Google-Smtp-Source: AGHT+IFofjGPN31+0LX8dDXmoFM6o8f3Gqf5ulADBej6kpr2ajxjNY65fM6XeEamxOZIfV8ZpecV5Q==
X-Received: by 2002:a05:6a00:23cb:b0:6e4:7b26:3f28 with SMTP id g11-20020a056a0023cb00b006e47b263f28mr8149200pfc.21.1708958112888;
        Mon, 26 Feb 2024 06:35:12 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id g3-20020a62f943000000b006e537f3c487sm1241269pfm.127.2024.02.26.06.35.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:12 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
Subject: [RFC PATCH 11/73] KVM: x86: Implement gpc refresh for guest usage
Date: Mon, 26 Feb 2024 22:35:28 +0800
Message-Id: <20240226143630.33643-12-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

PVM uses pfncache to share the PVCS structure between the guest and
host. The flag of pfncache of PVCS is initialized as
KVM_GUEST_AND_HOST_USE_PFN because the PVCS is used inside the
vcpu_run() callback, even in the switcher, where the vcpu is in guest
mode. However, there is no real usage for GUEST_USE_PFN, so the request
in mmu_notifier only kicks the vcpu out of guest mode and no refresh is
done before the next vcpu_run(). Therefore, a new request type is
introduced to request the refresh, and a new callback is used to service
the request.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             |  1 +
 arch/x86/kvm/x86.c                 |  3 +++
 include/linux/kvm_host.h           | 10 ++++++++++
 virt/kvm/pfncache.c                |  2 +-
 6 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 32e5473b499d..0d9b21988943 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,6 +94,7 @@ KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL_RET0(disallowed_va)
+KVM_X86_OP_OPTIONAL(vcpu_gpc_refresh);
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d17d85106d6f..9223d34cb8e3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1683,6 +1683,8 @@ struct kvm_x86_ops {
 
 	bool (*disallowed_va)(struct kvm_vcpu *vcpu, u64 la);
 
+	void (*vcpu_gpc_refresh)(struct kvm_vcpu *vcpu);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
@@ -1839,6 +1841,7 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 }
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+#define __KVM_HAVE_GUEST_USE_PFN_USAGE
 
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 80406666d7da..7bd88f7ace51 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6741,6 +6741,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
 	kvm_mmu_zap_all_fast(kvm);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_GPC_REFRESH);
 }
 
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be8fdae942d1..89bf368085a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10786,6 +10786,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_GPC_REFRESH, vcpu))
+			static_call_cond(kvm_x86_vcpu_gpc_refresh)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..b7c490e74704 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_GPC_REFRESH		(5 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -1367,6 +1368,15 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
  */
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc);
 
+static inline unsigned int kvm_gpc_refresh_request(void)
+{
+#ifdef __KVM_HAVE_GUEST_USE_PFN_USAGE
+	return KVM_REQ_GPC_REFRESH;
+#else
+	return KVM_REQ_OUTSIDE_GUEST_MODE;
+#endif
+}
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..f7b7a2f75ec7 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -59,7 +59,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 		 * KVM needs to ensure the vCPU is fully out of guest context
 		 * before allowing the invalidation to continue.
 		 */
-		unsigned int req = KVM_REQ_OUTSIDE_GUEST_MODE;
+		unsigned int req = kvm_gpc_refresh_request();
 		bool called;
 
 		/*
-- 
2.19.1.6.gb485710b


