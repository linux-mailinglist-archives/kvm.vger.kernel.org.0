Return-Path: <kvm+bounces-34657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B75A1A03700
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 05:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BF021883E3B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 04:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808421DDC06;
	Tue,  7 Jan 2025 04:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B9Ibbhai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7621D90D7
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 04:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736223968; cv=none; b=nOU5OiG5Ej00+fbZp/LEjZCCpnVOEILrHe4AUYZvxygM+vebrj+go4iT4MXrvImEflCoCdQq0yeqWzEJPlIRlJ/JgIvuElnh+szlSI87U6UEhK29EQuwNI/R9Kz0rGP2fKgMmagthizwV7kt/Zs8uBAnYk51WvS/uHuc4XahHis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736223968; c=relaxed/simple;
	bh=Oo5Czc4SbZT4Ha1Gp+D2fmjEvq65Mb4ymvqBOVaBP1U=;
	h=Date:In-Reply-To:Message-Id:Mime-Version:References:Subject:From:
	 To:Cc:Content-Type; b=qnhjEGvNPExTu3EA6cvRLLPB7XMau3N2JE6eWpe61UOVDFjXCM62hT0CnXvobIa9XRaXSoagJ0PqP4Cn72vCCuiQgTlFBsYaUl6MRoxTOtVPwg6IHPLou1Zo822vZI1Zra7HX/iTMDhLwGbLPpkzCBz9EGveg+XUgCZUcIUUnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B9Ibbhai; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--suleiman.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e4bed6c9151so30921441276.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 20:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736223966; x=1736828766; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+THoeasM42BCk1KQnN9W/5urUBLqOEIVbbKevhlfFUk=;
        b=B9IbbhainZOCLYfcktnDFj6i+G/u01ldv/s4fDXGRoocHp65x19GyjwJCpCFnt+1XN
         6uSWPEj3feEAbYjnQDrBJLFq/fRc/X8rKm5On5rR24+UeX6Twh0LmEud0KE1icZDjJnH
         fPAM9MiWug8cuGaFAjL49DdinacsYP5Mn3d4eUT5FIOaRvDSLy1ZF1ST8fgZxa0LKk6c
         IyrWL0OdIIWKgJML0hKr6UKhUpCUtz9JWeEeq3mlMsfaAkU61ftF8NyHkyuoRIWKhsEU
         3K/403V7uhj6u4U9427AfJaLSdUSGCW89lPPcS5OXoqVph3MX0AOus3tKnAEkBmfLsyn
         ickg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736223966; x=1736828766;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+THoeasM42BCk1KQnN9W/5urUBLqOEIVbbKevhlfFUk=;
        b=oRLFp0b0jrYvYYrn3NnMqLytp//qs4UUdnh41ISacBm1H6APl626rln3PnUvGbaIlf
         B/kyxSoasHktyaejyqawH1FRtnaRoE4rAMoYnSWfzKQ2K9qGafdDeo8uFHaqS9qnNuix
         keowdPtTrXb7P6vjWqVT5OwOeNHIz49GVpjw/d2Wz7KMEorfpU0sbeU33yNfDgH/C3o8
         C7s7HIZw8o0Pbg3d2vuTC8nqjNx9jWwwpR6ROwMEBiCx7tNmY4B9fcOv0XrnfqH00hci
         lpPSiHgI6n9ZmJENnPZHSsc/IuGkrTTTiMLRJxNPxKd93cjEOhZ/0NXRm9IK5CRZVhe7
         LbUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVabE2jGRo9Bha41+tKdtZiKzXLbKWnspk8qV2URretGgwkKaMKZpKP9N3wMhryyxqwsbY=@vger.kernel.org
X-Gm-Message-State: AOJu0YztZJDU4EhIVlsD0bsyOQFSatCfDQD+Qn2iCQnS+PHQEDm5GySO
	t4f8GAk7NVrU6ThR8GUNkejfu8qiNbysFXnZCpRRNcpKHgHEKupxCP7k1odM1M+KmSMiptwuaT0
	o+0/EI7Gg0w==
X-Google-Smtp-Source: AGHT+IGgNdDXJm39KCxJUsMtCDg+NtjT+Tuiwe+F9K1F2HLuSWB3gCkqA0t3EFGQwF6paadenujiL1dh4Z+w5A==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:66b9:6412:4213:e30a])
 (user=suleiman job=sendgmr) by 2002:a05:690c:3392:b0:6ee:4d97:9091 with SMTP
 id 00721157ae682-6f3f8261c62mr1692887b3.7.1736223966172; Mon, 06 Jan 2025
 20:26:06 -0800 (PST)
Date: Tue,  7 Jan 2025 13:22:00 +0900
In-Reply-To: <20250107042202.2554063-1-suleiman@google.com>
Message-Id: <20250107042202.2554063-3-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Subject: [PATCH v3 2/3] KVM: x86: Include host suspended time in steal time.
From: Suleiman Souhlal <suleiman@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"

When the host resumes from a suspend, the guest thinks any task
that was running during the suspend ran for a long time, even though
the effective run time was much shorter, which can end up having
negative effects with scheduling. This can be particularly noticeable
if the guest task was RT, as it can end up getting throttled for a
long time.

To mitigate this issue, we include the time that the host was
suspended in steal time, which lets the guest can subtract the
duration from the tasks' runtime.

Note that the case of a suspend happening during a VM migration
might not be accounted.

Change-Id: I18d1d17d4d0d6f4c89b312e427036e052c47e1fa
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b61..01d44d527a7f88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -897,6 +897,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
+		u64 last_suspend_ns;
 		struct gfn_to_hva_cache cache;
 	} st;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8160baf383851..12439edc36f83a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3650,7 +3650,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
-	u64 steal;
+	u64 steal, suspend_ns;
 	u32 version;
 
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
@@ -3677,6 +3677,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 			return;
 	}
 
+	suspend_ns = kvm_total_suspend_ns();
 	st = (struct kvm_steal_time __user *)ghc->hva;
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
@@ -3731,6 +3732,13 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	/*
+	 * Include the time that the host was suspended in steal time.
+	 * Note that the case of a suspend happening during a VM migration
+	 * might not be accounted.
+	 */
+	steal += suspend_ns - vcpu->arch.st.last_suspend_ns;
+	vcpu->arch.st.last_suspend_ns = suspend_ns;
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
@@ -12299,6 +12307,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r)
 		goto free_guest_fpu;
 
+	vcpu->arch.st.last_suspend_ns = kvm_total_suspend_ns();
 	kvm_xen_init_vcpu(vcpu);
 	vcpu_load(vcpu);
 	kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
-- 
2.47.1.613.gc27f4b7a9f-goog


