Return-Path: <kvm+bounces-66640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EC84BCDAE2F
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 90A2230365AC
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EE841C72;
	Wed, 24 Dec 2025 00:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMKS1vzf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jds33bok"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118A137932
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535183; cv=none; b=pHhdvsNp8WdZFdNq1gOZtCQmcbXjR5xshg6onAb7niuGZVwFGS0Qlic4tPqgYUL0HMzYsPgtcYkI41ZAdIChzooQSi8P9MWqZk8jCLg5mBwvLHZHLhjXvEuwfuLN8WfYWSTM1a2HgJrfmdCVv8jhYZaJhyZIh1gaCkr1c+y3AjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535183; c=relaxed/simple;
	bh=SUxMB9io5kUL3hiZuCM9QEc8yZLw0GrSlV7GpF2gspc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTMCOk27C07mqcoQev3fdJEIWpouOkT93zotqyUVD72Juy2Gdr4Z2vG4CfsYbUCe9IWabrZGG6QSjUcLgWG6iysQcm3Pm3gS5SZEXtR5AScnTL9F165UyJiMJlvX2mJt4dQn1m8k91vwWhbCcQoz19RXugMJhP3ZpLtkLHsJ+sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMKS1vzf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jds33bok; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cd2rAlHvk2Fc3rUlxPP7c9W8eyWSusr3FNKcOYNwGnk=;
	b=NMKS1vzfrtsh31CTW0ktQvl7KEif3n3aG51xi+JwWhDM8D2/TlZRyEA1okC/IeL9DPCE9b
	5lVqsfBAiPX27rOobDCOpBsZwikFWyq8U4+Yx65fKy//wT31Ch7WCQjGH9rkwv4wZY5Tc9
	IfHmxAwJhWUaYmpiubwSZwlJ4JksVNE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-IEY_nD5wOT2bVZS0GGabhQ-1; Tue, 23 Dec 2025 19:12:58 -0500
X-MC-Unique: IEY_nD5wOT2bVZS0GGabhQ-1
X-Mimecast-MFC-AGG-ID: IEY_nD5wOT2bVZS0GGabhQ_1766535177
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43100a07eb1so2867168f8f.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535177; x=1767139977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cd2rAlHvk2Fc3rUlxPP7c9W8eyWSusr3FNKcOYNwGnk=;
        b=Jds33bok7nUlvbx3in6cNYI1t3Y/UP3b64r+trS8YhRuZTRPdxuDPvS3c+zTdlgoP/
         f06T9gAreEMqjiHvbJevRoUeFkyrDArh/7m8FN7m21myh01DTvO8jsXmj2GqQUies7gr
         hrIpcXJOF2U7ersStViJ2+WEJtsribg1dgDLKU+qRrin4XSUDutcyJLr177FXr8ULYhR
         0RaWgUmnQgN6T2uvihETJ/BEnG1wVM5fcEaTPxr0rqdxcwfXJraa9TVPnyvSDOcIJIFJ
         RF7gHBcwMvqWi5kbHo/ruItPqvDl2DGsleEtjNKXLatmzdD665M0MhKYyWcZBpbxc/l2
         1pNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535177; x=1767139977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cd2rAlHvk2Fc3rUlxPP7c9W8eyWSusr3FNKcOYNwGnk=;
        b=q2Jh/qiockISUMMArzTf5xUZdn16q2V23RqQkGVfJ5gkSz63XNAZltFskNvRdVFizx
         dyEekpkDe9++f1+Zj5xIwSZvddkjZdix7KKMHJi8Nedn851v9BHwOW1dVBMa6QjQLffr
         KYuWdENQ9YV3l65R/mW0LxnS9YOl4c5mrB6qaaZG6dkqIuvu+vgSXc1dDmoEGZ23DLs9
         6OG0fxCMmVEmDzX1VUSvHJdsoSo4OMLlHR65U/hFE7xYyE6Em1uUguJnHa+3nHK76ZS+
         nLgJQZRoiijY2au6fLgrFMKXQW7qYTSCiVfhqNc3D5lrP4zbl0kB/xV2d3QUfDur6i3K
         Z6Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXeBS3qy6slv6ErrjfKA2N3moAPa/hgqv25Mz3tco8jN9Kyzzj8XNisY3Qo2p9UlrlIfA8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHgt08+2jHje6qr3AhR29ooyaGoN6JeIK+8Z9WYgSCVOtpFEvZ
	h1oIn2XqZrDWA2ajiVTiNwCYfqyPHqvIf1DqEOYQZN9N785Lwq/hTdxl+ROblSp92hYvucHtSSq
	1pdpmr/kZhTN4ZqK2CEeBHLdUFKjk17PxLTlFFOvmmjw618SjG/5LrkhB8XLHTg==
X-Gm-Gg: AY/fxX45aPQ2KgzfbB5OPeRrzlokEk1TvocaSOuEpO8vFOtOE/KP1OEI4j9v2ngsIJU
	xAOykplpNLhQ4YHywG7D7vmc8/8tpOpYm9rlIDBC0h51IIqubK3E6jDbFsH7e3oxpGzruLtAUNR
	GJUwIBCFYwanq3xigd76DfeGvljtQxFNCCPAOuOirTkWiXPZqQc6GxbREIArSdz7q+0IUOC5NSS
	2vXHhyDSyjBRlelYieoZCKAvOrsAzCP8k6GzS6jJdpJm3zI4sAFQo47uwsufrfwvFq2xS0qwmKZ
	ralUDALaJ56Lzxk0C2Z2wFbtp02ADoybMQcAbey8rwnSIXTGsb7ombPFFu2uVN5RkYDv/siWbiv
	F78RaW2wGKaa2QIkpLd4ft5DZKIayBhAkXa0yGRNNYHQRQQBwBrBODkToFPFTYcMPbR6/zN1W5l
	ecmzMGth+An8RR9+g=
X-Received: by 2002:a05:600c:628c:b0:47a:7fbf:d5c8 with SMTP id 5b1f17b1804b1-47d1958296bmr142012595e9.26.1766535176818;
        Tue, 23 Dec 2025 16:12:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7q/9gwLnCQEkdKpL0Em0GJ2ocZ6ifEAr9yGLRCJjag6irdREePfiliIJO9d7U2xigRdDUJA==
X-Received: by 2002:a05:600c:628c:b0:47a:7fbf:d5c8 with SMTP id 5b1f17b1804b1-47d1958296bmr142012415e9.26.1766535176377;
        Tue, 23 Dec 2025 16:12:56 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa0908sm30285139f8f.31.2025.12.23.16.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:12:54 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/5] x86, fpu: separate fpstate->xfd and guest XFD
Date: Wed, 24 Dec 2025 01:12:46 +0100
Message-ID: <20251224001249.1041934-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251224001249.1041934-1-pbonzini@redhat.com>
References: <20251224001249.1041934-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Until now, fpstate->xfd has acted as both the guest value and the value
that the host used when executing XSAVES and XRSTORS.  This is wrong: the
data in the guest's FPU might not be initialized even if a bit is
set in XFD and, when that happens, XRSTORing the guest FPU will fail
with a #NM exception *on the host*.

Instead, store the value of XFD together with XFD_ERR in struct
fpu_guest; it will still be synchronized in fpu_load_guest_fpstate(), but
the XRSTOR(S) operation will be able to load any valid state of the FPU
independent of the XFD value.

Cc: stable@vger.kernel.org
Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h   |  6 ++----
 arch/x86/include/asm/fpu/types.h |  7 +++++++
 arch/x86/kernel/fpu/core.c       | 19 ++++---------------
 arch/x86/kernel/fpu/xstate.h     | 18 ++++++++++--------
 arch/x86/kvm/x86.c               |  6 +++---
 5 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 0820b2621416..ee9ba06b7dbe 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -152,11 +152,9 @@ extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
 
 #ifdef CONFIG_X86_64
-extern void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd);
-extern void fpu_sync_guest_vmexit_xfd_state(void);
+extern void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu);
 #else
-static inline void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd) { }
-static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
+static inline void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu) { }
 #endif
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 93e99d2583d6..7abe231e2ffe 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -545,6 +545,13 @@ struct fpu_guest {
 	 */
 	u64				xfeatures;
 
+	/*
+	 * @xfd:			Save the guest value.  Note that this is
+	 *				*not* fpstate->xfd, which is the value
+	 *				the host uses when doing XSAVE/XRSTOR.
+	 */
+	u64				xfd;
+
 	/*
 	 * @xfd_err:			Save the guest value.
 	 */
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index a480fa8c65d5..ff17c96d290a 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -317,16 +317,6 @@ int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures)
 EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
 
 #ifdef CONFIG_X86_64
-void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
-{
-	fpregs_lock();
-	guest_fpu->fpstate->xfd = xfd;
-	if (guest_fpu->fpstate->in_use)
-		xfd_update_state(guest_fpu->fpstate);
-	fpregs_unlock();
-}
-EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
-
 /**
  * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
  *
@@ -339,14 +329,12 @@ EXPORT_SYMBOL_FOR_KVM(fpu_update_guest_xfd);
  * Note: It can be invoked unconditionally even when write emulation is
  * enabled for the price of a then pointless MSR read.
  */
-void fpu_sync_guest_vmexit_xfd_state(void)
+void fpu_sync_guest_vmexit_xfd_state(struct fpu_guest *gfpu)
 {
-	struct fpstate *fpstate = x86_task_fpu(current)->fpstate;
-
 	lockdep_assert_irqs_disabled();
 	if (fpu_state_size_dynamic()) {
-		rdmsrq(MSR_IA32_XFD, fpstate->xfd);
-		__this_cpu_write(xfd_state, fpstate->xfd);
+		rdmsrq(MSR_IA32_XFD, gfpu->xfd);
+		__this_cpu_write(xfd_state, gfpu->xfd);
 	}
 }
 EXPORT_SYMBOL_FOR_KVM(fpu_sync_guest_vmexit_xfd_state);
@@ -890,6 +878,7 @@ void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
 		fpregs_restore_userregs();
 
 	fpregs_assert_state_consistent();
+	xfd_set_state(gfpu->xfd);
 	if (gfpu->xfd_err)
 		wrmsrq(MSR_IA32_XFD_ERR, gfpu->xfd_err);
 }
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 52ce19289989..c0ce05bee637 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -180,26 +180,28 @@ static inline void xfd_validate_state(struct fpstate *fpstate, u64 mask, bool rs
 #endif
 
 #ifdef CONFIG_X86_64
-static inline void xfd_set_state(u64 xfd)
+static inline void __xfd_set_state(u64 xfd)
 {
 	wrmsrq(MSR_IA32_XFD, xfd);
 	__this_cpu_write(xfd_state, xfd);
 }
 
+static inline void xfd_set_state(u64 xfd)
+{
+	if (__this_cpu_read(xfd_state) != xfd)
+		__xfd_set_state(xfd);
+}
+
 static inline void xfd_update_state(struct fpstate *fpstate)
 {
-	if (fpu_state_size_dynamic()) {
-		u64 xfd = fpstate->xfd;
-
-		if (__this_cpu_read(xfd_state) != xfd)
-			xfd_set_state(xfd);
-	}
+	if (fpu_state_size_dynamic())
+		xfd_set_state(fpstate->xfd);
 }
 
 extern int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu);
 #else
 static inline void xfd_set_state(u64 xfd) { }
-
+static inline void __xfd_set_state(u64 xfd) { }
 static inline void xfd_update_state(struct fpstate *fpstate) { }
 
 static inline int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01d95192dfc5..56fd082859bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4261,7 +4261,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~kvm_guest_supported_xfd(vcpu))
 			return 1;
 
-		fpu_update_guest_xfd(&vcpu->arch.guest_fpu, data);
+		vcpu->arch.guest_fpu.xfd = data;
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
@@ -4617,7 +4617,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
-		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
+		msr_info->data = vcpu->arch.guest_fpu.xfd;
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
@@ -11405,7 +11405,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * in #NM irqoff handler).
 	 */
 	if (vcpu->arch.xfd_no_write_intercept)
-		fpu_sync_guest_vmexit_xfd_state();
+		fpu_sync_guest_vmexit_xfd_state(&vcpu->arch.guest_fpu);
 
 	kvm_x86_call(handle_exit_irqoff)(vcpu);
 
-- 
2.52.0


