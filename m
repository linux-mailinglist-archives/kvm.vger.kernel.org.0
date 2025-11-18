Return-Path: <kvm+bounces-63563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB73C6AE6E
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1AE734E1880
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED1F31ED6B;
	Tue, 18 Nov 2025 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RvPdnyOA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6055C3A9C02
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485888; cv=none; b=bFSeYpKxK4nzZcMDro3n5s8A3mnKvm3EGhF6uBPE+CkNFxlfCWNFYU6bcHB5qttjUkiJy4NNK1RAf9ARPtWMOllWq4CuTjS/B5DiqMhdWVcOYJcESuil1dB+4hArw7zpyLKwCK/PN6W39vAhgid1oTeqLGQZ2d8yNa3TG1rVlUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485888; c=relaxed/simple;
	bh=PJXfOYUgQ/koH9RKoJHaRKsC+CsEh7NIL8+BGeZYdZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV5QI/TdXmqe/Dx41CrnziZNH4JpuAQWdNmG5VSQrVPH5j8L/br3gUjKSWlVbcMiFWBO5HoGJHzS2ilbYnoGk1z2Qfa++iqTPGV7Aq9bJKdI3q29xme/Gp9J1lKc+PJacqXu7+B535FoOH9pzzlbj2Mz+/LAazZIxJadd2TeuDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RvPdnyOA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4779a637712so23584915e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485883; x=1764090683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siFHznuHrhv1xGgfDI5kE0TqLDfCEZnyaPZRcY6rR3Y=;
        b=RvPdnyOAMSIXCg5BDXB3EL0IDKorAWnXWdHbzUL1zfrhBE2SH6Gr1tQMOaAPZSpL0d
         BZ3pgqQGlIZ7jAfr210ymmjdgR4oXmcJfral+ZZltiShQ/I6N9GqUICh4ZmmG3za9d96
         J7z0lpAdxumeseY7d7yixRueQJwxMgE+P5TSeH2B4mhiPON4uWYkpvUTWM1miCz/IDB0
         Q6LusKbL0ipdyigAkAheslEztooOaYJXHPFlohznGC22MxSjRiWD5BjsElMUIqDIrn85
         PlFeQM+oGAPHUAQ1XEfHmz6vrtaodVwV+2B6fyPAW2IfAi9TDD2JK0lRnkEwXjwrXvqB
         AS9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485883; x=1764090683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=siFHznuHrhv1xGgfDI5kE0TqLDfCEZnyaPZRcY6rR3Y=;
        b=aSuASiDHP+zp+SISgnGLEOfPvQ7QUooF9MdFeufm+eQp/hRHK5/9PLii+ZgjEOj38Q
         3WEgnskGigOP1pOrb3LupPHJTWcxB5gofU8tawhDJ1WDMG7ISJhC1Wn0S2gsVs9op/Sy
         JMKvlr99kwdrzmfxqgEjMZI1VLpjW1Hcu3ZFpvqe2Y4y1eHTgpzdP+W5m0Tksx+jbHKW
         /I6J+/VDNxuXJ3ixd/vJTfvkOmwa+ha5TMjA76J5t9VkEUzTdy+zMvXvDvtRJtTatYT+
         4I0p+0AB+U9MNgzmNC6EOYmd/0iZN9Fzxhu/nYRWx1WJVn8E+KngftjpUD7rBxl/kYFQ
         CJDg==
X-Gm-Message-State: AOJu0Yw0f9QMvUXGMRMf8NFT4/H2/TO4Nnham5pDz4IUTqGR/gG0pw2w
	3SsDdxhlOluDbvhskrITm5Ij+ojHr+OOzJaiDSGbv6SYgKpkFNhyqH/IlwMK5sYDthbcpQ==
X-Gm-Gg: ASbGncsG7V7Z+OspcmO9vjJxD8jTKR9afBWOiOMTZ/64DAfHLR1nVSQDgdsr1DnU7zy
	JA2xVLqUcQT4E5+AHZMRg0SYvFgGW2hwjIEXrX3NaC7hR710lxxuh43fXmOZ9QfnQX0jZK+FuLI
	TLETGnLQ1Zce/W8h7qUfm8AVNZtEhbrtB1YxCfEHtXkDtuqOiiG0KmqnJ7KVC+mxn6mGRPhmA3S
	O3O6Fw9AnJJkIeqDJ9S8jOGhOnktQR+jGWUeo+L6NhY4x7bB+OvBZsQLHO8hpuRn0/XGiXIbcaH
	kfaU7TJ9VGY2fMf23gyq6ugqI/nAoCB15nqA9trfxtZAblTzcgiWu/p4WJqBHn1ALzFab1ZvGuG
	4cWLiDSNE+Yc8wpECj6jXTsg6N7pyzM9GOHpV6YAbiy8VNsNBVzqWsY5P8bqs4TiLsTt78C+v7V
	TDHhB7Q+ZifXppKZHGhWRTBGmBpi88i35wovCxjTGoYwy5h7p/RF3TMocR3/C4d3nk1Dd9xiztW
	7xPubHwa0VHoFXHhNCVI3jzR9UnZqccL/8yytNpMdI=
X-Google-Smtp-Source: AGHT+IEsc9qshXMo1MZ9h5TXUYy1hPn5Z+YQvhGiarIKg24AewgPdrGERLkgj3wJlAvljKWYB9vjUg==
X-Received: by 2002:a05:600c:45d5:b0:477:7af8:c88b with SMTP id 5b1f17b1804b1-4778fe57241mr164751365e9.11.1763485883079;
        Tue, 18 Nov 2025 09:11:23 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:22 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 03/10] KVM: x86: Add nested state validation for pfncache support
Date: Tue, 18 Nov 2025 17:11:06 +0000
Message-ID: <20251118171113.363528-4-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Implement state validation for nested virtualization to enable pfncache
support for L1 guest pages.

This adds a new nested_ops callback 'is_nested_state_invalid()' that
detects when KVM needs to reload nested virtualization state. A
KVM_REQ_GET_NESTED_STATE_PAGES request is triggered to reload affected
pages before L2 execution when it detects invalid state. The callback
monitors L1 guest pages during guest entry/exit while the vCPU runs in
IN_GUEST_MODE.

Currently, VMX implementations return false, with full support planned
for the next patch.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/nested.c       |  6 ++++++
 arch/x86/kvm/x86.c              | 14 +++++++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..4675e71b33a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1960,6 +1960,7 @@ struct kvm_x86_nested_ops {
 			 struct kvm_nested_state __user *user_kvm_nested_state,
 			 struct kvm_nested_state *kvm_state);
 	bool (*get_nested_state_pages)(struct kvm_vcpu *vcpu);
+	bool (*is_nested_state_invalid)(struct kvm_vcpu *vcpu);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0de84b30c41d..627a6c24625d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3588,6 +3588,11 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static bool vmx_is_nested_state_invalid(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
@@ -7527,6 +7532,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
 	.get_nested_state_pages = vmx_get_nested_state_pages,
+	.is_nested_state_invalid = vmx_is_nested_state_invalid,
 	.write_log_dirty = nested_vmx_write_pml_buffer,
 #ifdef CONFIG_KVM_HYPERV
 	.enable_evmcs = nested_enable_evmcs,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd4857..1a9c1171df49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2262,12 +2262,24 @@ int kvm_emulate_monitor(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_emulate_monitor);
 
+static inline bool kvm_invalid_nested_state(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu) &&
+	    kvm_x86_ops.nested_ops->is_nested_state_invalid &&
+	    kvm_x86_ops.nested_ops->is_nested_state_invalid(vcpu)) {
+		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+		return true;
+	}
+	return false;
+}
+
 static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
 	xfer_to_guest_mode_prepare();
 
 	return READ_ONCE(vcpu->mode) == EXITING_GUEST_MODE ||
-	       kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending();
+	       kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending() ||
+	       kvm_invalid_nested_state(vcpu);
 }
 
 static fastpath_t __handle_fastpath_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
-- 
2.43.0


