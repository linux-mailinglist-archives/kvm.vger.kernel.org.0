Return-Path: <kvm+bounces-67877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A941AD16035
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E28773019C7B
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEA228D8FD;
	Tue, 13 Jan 2026 00:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kUF2KvF0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E32868AB
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264248; cv=none; b=ZBXAGQCZKbYqeDZMQPcFYfzJ1hRO0mXeqKiRYeoLAcpJGVjlNiXR7DbTu6ztnnAshrnabSpZ2RgMz2YSZMUmaGU5yE/pEeXWGlPZ0exApGkHL6uKddL9gaBaHECFpj851WERk1veiZrotqXs+gR6e/rtgxlDz/sD1rAZANLA7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264248; c=relaxed/simple;
	bh=hX4XPV9AeeVtqdf1qUwScjy5RPlzHKp24xAasklIFrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ue7x8NvOh5F5MMtjyWYX4o3SDuyCsVT4H7MMBhNU6qS8Sg+Let0Ju8FE8O5wWvwkwuihHC4JYDHdJPjCv6VGUYqAbc1oRVfiAb6jRIT8MNkG3F/iMPOVo4oQnAuKE3oZszQt3GZvJdW69I2dYAK10uDngO+IJcGkAAahRFg15Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kUF2KvF0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso14220956a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264246; x=1768869046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6EcXdxHH4rwGl4QLydVFW9PObH3AsANvQWjOw22pmtw=;
        b=kUF2KvF0XYoZhiJ5VJMUG5IpgxcxdTRZn4DfrkSWK+1KRrvP+TA0AhxsKPWyi/bSPZ
         jNDHmj3/831EXUfnduxLAx78bWs5rhaa6sYQE7gZMn1MmFuKBCanY0PyZemiiRYjM45Z
         f/x3th3MH/W8Jgh/ldiBNcXCzM7szao/KVpm12AWmLuoI9s805hUSy4hyr6P+pxl2PwM
         cHfb9aFKgsSnvzFAlpjjy5z/8ugwOyGpe1JJAESln0v3MM37AYC0Z4EDuhr40cAlKIAv
         20Nc2+5dysKmqOdtyF9lt+wbXVjLaRYbfxRQxqTCG1PXKgBREp93T259wIJyNak7ysjP
         Uymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264246; x=1768869046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6EcXdxHH4rwGl4QLydVFW9PObH3AsANvQWjOw22pmtw=;
        b=fkuDte+1hhX+2Re/LnSC7zGYcYA/aFWgVeP7nuVIRWDxaUr3YGt4N9+WXh34skIrXS
         35SN/9G9v4T/m2BD5pm2wMQJWVPGX68D9qfN3/AWHnz3FFsjdLUBFgTVb4IeL2XLCpTg
         O6SUUQJBslGEuY8ghyjuWNWdw9dGzEHOP2VFndZ8uhKbzUkgNjw+C3vkL+lNJDv8ZUzY
         7MqpjO7C4d+znjDcWMKuQtifc7wO89SmveFRRojJAhmll8Lr2SZ8Bn/JaYEH4vXYKl0E
         EiKBM6wuCqmnHS0hcTVRH1N4JVNKcNE6QqRK7boWQRZtb63gx5FeFoisSvOXmxyRUSvQ
         +flw==
X-Forwarded-Encrypted: i=1; AJvYcCUqB99cqXPcSZ/82f3ppIp/c6oOyh/N6zZP99JVOMAq164eG3xy7R1qDymclprIENi2fZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/ujuXCynrR4NRnAzLW9zOk/9GX5Tf9rCduLCdaaSavy4s9Wrw
	eKIilou7axzXs1HPTx/W5kHo1ZsL7nHsTj4JsiYANZQkTBKzqj1yOm0Zi0PmOr/W4odDFo/XRAg
	g+s9Oakh2DBjRgw==
X-Google-Smtp-Source: AGHT+IFhcO4kGUHRcas1ziWGAEnxOQWCZYsu3xXdMqr8zv3PecxeckJ8llCyD0ioPh/h/8s0btpYHCooQHVdTQ==
X-Received: from pjqz12.prod.google.com ([2002:a17:90a:b10c:b0:34c:2156:9de7])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4a07:b0:339:ec9c:b275 with SMTP id 98e67ed59e1d1-34f68c308camr18893414a91.6.1768264246387;
 Mon, 12 Jan 2026 16:30:46 -0800 (PST)
Date: Mon, 12 Jan 2026 16:30:02 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003016.3511895-8-jmattson@google.com>
Subject: [PATCH 07/10] KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>, 
	"=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>, David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When nested NPT is enabled in VMCB12, copy the (cached and validated)
VMCB12 g_pat field to the IA32_PAT MSR and to the VMCB02 g_pat
field. (The latter can be skipped if the VMCB02 g_pat field already
has the correct value.)

When NPT is enabled, but nested NPT is disabled, copy L1's IA32_PAT
MSR to the VMCB02 g_pat field (L1 and L2 share the same IA32_PAT MSR
in this scenario).

When NPT is disabled, the VMCB02 g_pat field is ignored by hardware.

Fixes: 15038e147247 ("KVM: SVM: obey guest PAT")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 501102625f69..90edea73ec58 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -656,9 +656,6 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	nested_vmcb02_compute_g_pat(svm);
-	vmcb_mark_dirty(vmcb02, VMCB_NPT);
-
 	/* Load the nested guest state */
 	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
 		new_vmcb12 = true;
@@ -666,6 +663,26 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		svm->nested.force_msr_bitmap_recalc = true;
 	}
 
+	if (npt_enabled) {
+		if (nested_npt_enabled(svm)) {
+			/*
+			 * KVM doesn't implement a separate guest PAT
+			 * register. Instead, the guest PAT lives in
+			 * vcpu->arch.pat while in guest mode with
+			 * nested NPT enabled.
+			 */
+			vcpu->arch.pat = svm->nested.save.g_pat;
+			if (unlikely(new_vmcb12 ||
+				     vmcb_is_dirty(vmcb12, VMCB_NPT))) {
+				vmcb02->save.g_pat = svm->nested.save.g_pat;
+				vmcb_mark_dirty(vmcb02, VMCB_NPT);
+			}
+		} else {
+			vmcb02->save.g_pat = vcpu->arch.pat;
+			vmcb_mark_dirty(vmcb02, VMCB_NPT);
+		}
+	}
+
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
 		vmcb02->save.es = vmcb12->save.es;
 		vmcb02->save.cs = vmcb12->save.cs;
-- 
2.52.0.457.g6b5491de43-goog


