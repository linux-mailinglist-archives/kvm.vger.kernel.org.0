Return-Path: <kvm+bounces-66639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B8ACDAE1A
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5D26C30078A4
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F73A13C8EA;
	Wed, 24 Dec 2025 00:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DjXFD2Xi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mT79PEif"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EE941760
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766535179; cv=none; b=sqWOSRcXjDRuex1ht877cqw85PXlJB4kJOBQj4gAy9+NubIdKDyD/wK4Bli+32ReTgHs0NPgLzVSYw8KSlNYOBrMDqaVe/ylCLXSMwNY/0Aby+7Cv2frcosgP2AvHjvEx91Ho4nRH0PZ5uVInIagO0anXy/QxjORsZ/khFij3hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766535179; c=relaxed/simple;
	bh=hWlCqxxO4rNeS3u3z5E066XItSLKm9DA4Bx5w9CplKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5s4NKWTZw9M5DWL7v/EhYduwj/OOfI8iUpZWa9plO7sl03fxnlI9j7O6oKXUkPvS8Pl2EBHDJ0M+7L+0fim11/UKaqlzxa28OdXCiko4+CazgOp+AnGjgY8QZLfoZZ3+1TVAgwRgOUCOYabySXQclOqdiuqi4932nMwfF8ByLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DjXFD2Xi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mT79PEif; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766535177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wpa7TThaJI94/M4NKCUGmC4bcd1iUcwxLhMpe/Pmu+I=;
	b=DjXFD2XiDCi8PdwpIJykKnJjaav3BdgcAPU8mYtDTkE5mEXdX8hE1dkL7fZzp+ejz9SfW+
	GeruasQIPXa+SA3bdNoCCfxb8b8PsCDDl50xD/Z8MoeNc9ebFwwHmApjkEPbeQ/eiGyZhZ
	IyNvGLMgyLe7Va4bWKcgAxmhzb2tr38=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-5LxJThalMs6ovNH-sxTNpw-1; Tue, 23 Dec 2025 19:12:55 -0500
X-MC-Unique: 5LxJThalMs6ovNH-sxTNpw-1
X-Mimecast-MFC-AGG-ID: 5LxJThalMs6ovNH-sxTNpw_1766535174
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso76760355e9.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766535174; x=1767139974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wpa7TThaJI94/M4NKCUGmC4bcd1iUcwxLhMpe/Pmu+I=;
        b=mT79PEifZOE7VN1nrXdpzsqaA4NEd1eDjFI5JrOBCzE8YsHk/JesPwSGBq1i07jdXq
         KQTx7dlYz7k9JElo+T8lgTqJT6z/KRJnCeQaAP9jfn/Pv44xM/sAnkJAVAcPiFbemt9q
         PgwYrwL5Oo5IZp7jM4oGsLUL3genNE85QtV7N6r4WFoVXaVUvbWzJcl1v5yIwYgS0ZaH
         Ob4HqMISAqGDkNx//JSNH6ogNo85gLlQSGruzbSc/nJO6IUXv7lkCCtp5MNtm/vqUd9K
         Tjxjy5Qho6QeyvKx9tQT8Jcg8fwTkvuHKdTRBAPjXSltSPj7HKy49RfhuBnw5AfEkv19
         UHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766535174; x=1767139974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wpa7TThaJI94/M4NKCUGmC4bcd1iUcwxLhMpe/Pmu+I=;
        b=Wh1Axx6VaRKN8bWiX3oZOsBzLLqXFKiDyFfUJUqLcwqq5838xhqB55SNOsbOHqBezw
         o5RE6OmMhqeHzDb0corN7xvFhh8BrOxZ5hiBnShAMXznZYw+a82JiDGxQSV+IbetbBmq
         7UGdyZM7zHyZ/ym2YKDdQglLBoFa9TWXPvR3I31Pl2lBN+UTFC3G5AFACz3kJ05OQovX
         39ZAHCKr+DelnqeZkuf7V+4dvKD9qvNiCy2LzXO99IeUwP3Q+hev7U0xHDZdBOS0fSnT
         A/L9OhasPBLlTR2t3qv2B2iTXAvaS75Xbv7oIwADAQrCmo2PrsjsE4mpu0EaGWaEh2XJ
         t5sA==
X-Forwarded-Encrypted: i=1; AJvYcCW3thjpAHxMWjFeNdVgZINbho0o9qePUgCRTC1heB6C2taafnDGTzXAbyeh6xcK1AIa/ek=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw23Yp4UxI0IhwaO8jcmH+/iz2446LiZ1cp75khhmBEo2G0SXzW
	ZCrYx7XloSnw5hwQrWEEqY/9JThwiVL5yxMVjGQ9ovO5ahVy6FenHqRcj8cI913Z3sn9zwBRSrQ
	t1f92+khuqFoa+W+gNkyiPmDlm2XFwCAQf6aSTljAbh2wx+Tym0eQ/A==
X-Gm-Gg: AY/fxX69rvLRtAD8yzyaGd4VyWb52xeOjh2Hpct+8L+lvjprheMv7gv+QCCfxuSo88M
	u4kdarEWiySbyrBHanpg8qh/n5Nqo8PmBX86nY3UMkCNRxqI3ux+ukxktvrKoPEHZPjOmtZIwbc
	XmohuKGRdem3RzOPc1aE4H9qdKbVb+Yfubtfior2AtdfY5fhLwe+u61jv0e3bNUlg0bn+H8wtFK
	l9BZSxw0awN85XXcewBV4Jx62RSTAe5UbZqExTW6KE3/IbEXHmvMFw9JVMHrlkJjnqYrKrFYMww
	Xmg9CpiaXebhPDJhiKhZlRtji9bCAMmHVc9I1+KHgvIq60leQi9kKl5h30tZUpQjHcqJo1d5o++
	ySAP1lmpWADAdH6Lok+AMv25LM+LaAAMe75KUCFA3GR/hRiuBbaDkgsMUiSjnHIgJNsprJhAqw9
	X3x7cYPgee+7CONN8=
X-Received: by 2002:a05:600c:4709:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-47d220b7f4dmr127797225e9.9.1766535174413;
        Tue, 23 Dec 2025 16:12:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4shwSxKh09RXUVkp89RPVC5AHTfJRsb/m35JDsGHtZiPzxZLORNyA9500LRq6dFLONLymXg==
X-Received: by 2002:a05:600c:4709:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-47d220b7f4dmr127797055e9.9.1766535174069;
        Tue, 23 Dec 2025 16:12:54 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c5f8sm302090195e9.9.2025.12.23.16.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:12:52 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/5] x86, fpu: introduce fpu_load_guest_fpstate()
Date: Wed, 24 Dec 2025 01:12:45 +0100
Message-ID: <20251224001249.1041934-2-pbonzini@redhat.com>
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

Create a variant of fpregs_lock_and_load() that KVM can use in its
vCPU entry code after preemption has been disabled.  While basing
it on the existing logic in vcpu_enter_guest(), ensure that
fpregs_assert_state_consistent() always runs and sprinkle a few
more assertions.

Cc: stable@vger.kernel.org
Fixes: 820a6ee944e7 ("kvm: x86: Add emulation for IA32_XFD", 2022-01-14)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h |  1 +
 arch/x86/kernel/fpu/core.c     | 17 +++++++++++++++++
 arch/x86/kvm/x86.c             |  8 +-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index cd6f194a912b..0820b2621416 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -147,6 +147,7 @@ extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
+extern void fpu_load_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 extern int fpu_enable_guest_xfd_features(struct fpu_guest *guest_fpu, u64 xfeatures);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 3ab27fb86618..a480fa8c65d5 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -878,6 +878,23 @@ void fpregs_lock_and_load(void)
 	fpregs_assert_state_consistent();
 }
 
+void fpu_load_guest_fpstate(struct fpu_guest *gfpu)
+{
+#ifdef CONFIG_X86_DEBUG_FPU
+	struct fpu *fpu = x86_task_fpu(current);
+	WARN_ON_ONCE(gfpu->fpstate != fpu->fpstate);
+#endif
+
+	lockdep_assert_preemption_disabled();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		fpregs_restore_userregs();
+
+	fpregs_assert_state_consistent();
+	if (gfpu->xfd_err)
+		wrmsrq(MSR_IA32_XFD_ERR, gfpu->xfd_err);
+}
+EXPORT_SYMBOL_FOR_KVM(fpu_load_guest_fpstate);
+
 #ifdef CONFIG_X86_DEBUG_FPU
 /*
  * If current FPU state according to its tracking (loaded FPU context on this
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..01d95192dfc5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11300,13 +11300,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 	}
 
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
-
-	if (vcpu->arch.guest_fpu.xfd_err)
-		wrmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
-
+	fpu_load_guest_fpstate(&vcpu->arch.guest_fpu);
 	kvm_load_xfeatures(vcpu, true);
 
 	if (unlikely(vcpu->arch.switch_db_regs &&
-- 
2.52.0


