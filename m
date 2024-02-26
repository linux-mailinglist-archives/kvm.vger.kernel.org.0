Return-Path: <kvm+bounces-9910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE9D867A39
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FCFBB31EF6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A416213F001;
	Mon, 26 Feb 2024 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iaUtwL3H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24C13DB90;
	Mon, 26 Feb 2024 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958232; cv=none; b=YpOYci3PazI3ktCmaYD6Y01eRCZ/esQ5abmVZqX1ox/fLM785zIKlI6PIWWQO5Jj+L/R4rSeMjA0RHBNTtg0pAxavDFZcFttsLfiB2pZsR2cb29VBUpw/Eq+Jd9BaWXEThTIpOCUe/+v/yMgAQp+8hONHvdIVPNju6BB+plWUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958232; c=relaxed/simple;
	bh=dbue2J2vSwgwnN6frugUZa4aGyoh+CRYUv+AVhY+tPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EGZBVyMSUb4LBTqpvxC+cwtmf2E4WNO3NVmY8v9pNJEyAINaX4euqgjZyHP70xBJ2fDQEk0l0K0XQ3WJMo3pI77IPvvw2WcCwm5cXAqHKrEJ7HckSLXwhC8NYg2WKhJy73REtk0GhNU6Fao16w3RTUuhvRCvpcIhuz+2axkxDdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iaUtwL3H; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dc91d2384cso10130245ad.1;
        Mon, 26 Feb 2024 06:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958230; x=1709563030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/RvrWbn9sfOzdiVMPXkxTdPgTjoBGXeTTjPXRznq0o=;
        b=iaUtwL3HBWkfZLhgia7eVWky2Bt1q+VRnkOI03i6l4+Kq6Tbt+ov80oSUJ9w/l5lAw
         vgYUdRcSbxj1qb6fZaalm0yBeLchpfEkOjqrFCw7sJPJms55QV+IqhRXrE+YSgtBuQOs
         IrSDpDpdZQOL9gl0gJu9S3+wQmj7yuMOGePnz09jU79JhEH448YOW6EC5J3biu1BI6q8
         a3JO5ea47znvj2Vwja+A2m+2cqUNFemKfPIs3wwE/lINLv/teIpP4otQQMHaWioWpjZZ
         QT1sF5UpDGR0NHqHFDvZ8tQCSk5TtGPdFRfc13XcX2A0BFnbcSUPNoXRBcMqgvSPDpXq
         eYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958230; x=1709563030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/RvrWbn9sfOzdiVMPXkxTdPgTjoBGXeTTjPXRznq0o=;
        b=nT1hYfKW/lVFbcnyFPIcv8nYRiImdWtwpm6IOcnxNGxSxvvFWEMplAYHmg3wlBN/IV
         QjYx5CCH85Cf5NLOhAj6Bg8Gdj9GJ7W70CuwGA5/Bm8mLjBtuCSKmBXCBy5yrRADgaGT
         QJ9bng1DjQ69GatF63ItbfFeflZnSJdsKzVzd7Iqo3DNpyW4r+V/c5jhQXyuE4n3aSjw
         I72BdXn48j59lsmghwnr9EuUesjPTOuzWDmZPLC2Zq3IgwHbiq4B5szfGgQFlk6pZCRB
         Per7py1tFz3tvELGZepHrbAFk+ubswtS7zYjpKGP6HP2Et2jKfbRlhtEZX/xN+q2Qm/x
         5PPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUIrqEFkrH/cH9XnRc6uQQ6YAl5xwWKqdHXbsAIevstkU9i3luGfYcUjJn3qlPXZpv4F/WGFn7D6FT9/xyUwKzzNOZ
X-Gm-Message-State: AOJu0YyFE59fUxicBFi0VSx63hP0KY2/9AAem1wMT88xeE818ZkFskzQ
	rztK6tHqcWToPy5kU17LoTGUteH3lHDWihkeRpxYozskGg5So2VBXwirA2/T
X-Google-Smtp-Source: AGHT+IE0Yc9xW1Lt/LivWzFFfjqGKYtZxLFt9+CYuEpG7BYUPujv+WKZLnxBBFYicjNxCLlGbqrD0w==
X-Received: by 2002:a17:902:ec85:b0:1dc:652d:708f with SMTP id x5-20020a170902ec8500b001dc652d708fmr8356122plg.15.1708958230553;
        Mon, 26 Feb 2024 06:37:10 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902eb4600b001dc3c3be4a4sm4031243pli.304.2024.02.26.06.37.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:10 -0800 (PST)
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
Subject: [RFC PATCH 47/73] KVM: x86/PVM: Handle the left supported MSRs in msrs_to_save_base[]
Date: Mon, 26 Feb 2024 22:36:04 +0800
Message-Id: <20240226143630.33643-48-jiangshanlai@gmail.com>
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

The MSR_TSC_AUX is allowed to be modified by the guest to support
RDTSCP/RDPID in the guest. However, the MSR_IA32_FEAT_CTRL is not fully
supported for the guest at this time; only the FEAT_CTL_LOCKED bit is
valid for the guest.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index fd3d6f7301af..a32d2728eb02 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -854,6 +854,32 @@ static void pvm_msr_filter_changed(struct kvm_vcpu *vcpu)
 	/* Accesses to MSRs are emulated in hypervisor, nothing to do here. */
 }
 
+static inline bool is_pvm_feature_control_msr_valid(struct vcpu_pvm *pvm,
+						    struct msr_data *msr_info)
+{
+	/*
+	 * currently only FEAT_CTL_LOCKED bit is valid, maybe
+	 * vmx, sgx and mce associated bits can be valid when those features
+	 * are supported for guest.
+	 */
+	u64 valid_bits = pvm->msr_ia32_feature_control_valid_bits;
+
+	if (!msr_info->host_initiated &&
+	    (pvm->msr_ia32_feature_control & FEAT_CTL_LOCKED))
+		return false;
+
+	return !(msr_info->data & ~valid_bits);
+}
+
+static void pvm_update_uret_msr(struct vcpu_pvm *pvm, unsigned int slot,
+				u64 data, u64 mask)
+{
+	preempt_disable();
+	if (pvm->loaded_cpu_state)
+		kvm_set_user_return_msr(slot, data, mask);
+	preempt_enable();
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'msr_info'.
  * Returns 0 on success, non-0 otherwise.
@@ -899,9 +925,15 @@ static int pvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		msr_info->data = pvm->unused_MSR_IA32_SYSENTER_ESP;
 		break;
+	case MSR_TSC_AUX:
+		msr_info->data = pvm->msr_tsc_aux;
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = 0;
 		break;
+	case MSR_IA32_FEAT_CTL:
+		msr_info->data = pvm->msr_ia32_feature_control;
+		break;
 	case MSR_PVM_VCPU_STRUCT:
 		msr_info->data = pvm->msr_vcpu_struct;
 		break;
@@ -988,9 +1020,18 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		pvm->unused_MSR_IA32_SYSENTER_ESP = data;
 		break;
+	case MSR_TSC_AUX:
+		pvm->msr_tsc_aux = data;
+		pvm_update_uret_msr(pvm, 1, data, -1ull);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		/* It is ignored now. */
 		break;
+	case MSR_IA32_FEAT_CTL:
+		if (!is_intel || !is_pvm_feature_control_msr_valid(pvm, msr_info))
+			return 1;
+		pvm->msr_ia32_feature_control = data;
+		break;
 	case MSR_MISC_FEATURES_ENABLES:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		if (!ret)
-- 
2.19.1.6.gb485710b


