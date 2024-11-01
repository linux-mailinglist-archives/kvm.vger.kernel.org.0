Return-Path: <kvm+bounces-30346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0104D9B97B2
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 19:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8AFBCB22909
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 18:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887F51D0144;
	Fri,  1 Nov 2024 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0KSDPFR6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3849B1CF7AD
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730486165; cv=none; b=icnUjc6FacGDd9aAf+w0lO9d9Fw2drBeQbs9mNlH2TB4wLANO5GkjdrcLEKfS+mFdzRm+7UVmQU5ZqTPt7WUOza3LxQeLAXeIenWwbmITbuXmCpWR1gRwX1qRKFWQPaUCf8vFx2SgrGpX7+NzHZJGK/U5vZU+8iq4NBNVKexhcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730486165; c=relaxed/simple;
	bh=AQHWFIKx05Q6I0khQtg6qx7F98/ChoeEEBN+Jwsa0Kw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MG4sBx5KNlt2O0x1eFXwO33iUJ/0Xo3W0onjHbmoWIbV2DAoAZWJQcWZutDrkC3EllPYImpFaNTIY3r8BpHxHbGckleFsBE+81FRbhwI43EnaHmmxICZ8mO6jmlbgPB/+wh2IiQVJYAqJl3XzYyj2yKiX1dyi/8xyAv/6SQ6H9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0KSDPFR6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e6241c002so2264563b3a.1
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 11:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730486163; x=1731090963; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RrKAd/LcvqmweQgUO1Es4Qu822f05reWQBoEwGCwlQ0=;
        b=0KSDPFR6um5WtgOJ7qSEae2UXGBxY/TDQB/5vHKRrMMH/xh3mStNnYsO+xf0S+hDpD
         dfvy+NaDT4vx3JqfSU8/HlyGy2OuZ8IzoKivhc1CIeR/u0hKgTlsMSR90Fz+cq2TmXsz
         gQ01OTBqwrbEdoG2z/CUz2Sp3CtFMn9T+Dg208L0clmPXyTaHeF0jh0si6gCEGcVG4mc
         9C8wKRKYf6bn69IftvpM7LvZ1NFj5MpubuNDUfFmDjdaDx7wm3qpHMnG77hGbwjIIGjH
         TjqxLBfSlZpWrf6ZRofPlUbq3gKEVo5Rbi2Bl8PVPESU8wWqTCKvJB0SRXxx3esSx7ko
         dKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730486163; x=1731090963;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RrKAd/LcvqmweQgUO1Es4Qu822f05reWQBoEwGCwlQ0=;
        b=BZlJA60M1TN/Ab8nKOlmBmwrcDf/JRSklNRBQ3QdLH8ac5cHyY38UXw6xUQa7PYL+8
         HM39OeYrZLeRQaNtOq66EjR4dU5ETeDTjx+JAbhGI8FfjILOpXUEVYy0MDEepy5m5lYr
         vOf7thUqG58Xxzrgb89NxvRHMFE+3sISEQKuNR/ydXq/DbE3Qd7Wu8g2ulHvyI1nPkgl
         RMzkRHCB38Sni+jtndOvcqjrN6GNq1nm17pRKEcSKCaFjeZJbjMHlOX55cC3vb29zs3s
         B7eziKZG9zfSSUlfIu9siIepjG9QRKH9LN3WG2ScBSwGYhFF7Mc3Kh9EQlMdxc2Xb8eB
         cDAg==
X-Gm-Message-State: AOJu0Yy3Cs/tZ9MXGeS8FsQi5DffeUGjX1D7oWi48Wm+sXCvz2yBJDez
	jNI9Gf5lSBn/sNB6vzp89KQkAZuVYJepgqqDSVnNvfqAVmdcIiA2rWC6icaKhoaFVE0G9BwF+AF
	crw==
X-Google-Smtp-Source: AGHT+IEfb7kN1e0CSUsCamBepUoGEaAPZKajSLl220fb2ebC5QNlJYvpwQhj814gCEnvIJyCqu1f9UL5Ir8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2790:b0:71e:6b3b:9f2d with SMTP id
 d2e1a72fcca58-720bc83e022mr26129b3a.1.1730486163504; Fri, 01 Nov 2024
 11:36:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Nov 2024 11:35:49 -0700
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241101183555.1794700-4-seanjc@google.com>
Subject: [PATCH v2 3/9] KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Access KVM's emulated APIC base MSR value directly instead of bouncing
through a helper, as there is no reason to add a layer of indirection, and
there are other MSRs with a "set" but no "get", e.g. EFER.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   | 13 ++++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1b8ef9856422..441abc4f4afd 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -117,7 +117,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e45040c2bf03..118e6eba35ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -668,14 +668,9 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.apic_base;
-}
-
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu)
 {
-	return kvm_apic_mode(kvm_get_apic_base(vcpu));
+	return kvm_apic_mode(vcpu->arch.apic_base);
 }
 EXPORT_SYMBOL_GPL(kvm_get_apic_mode);
 
@@ -4315,7 +4310,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 1 << 24;
 		break;
 	case MSR_IA32_APICBASE:
-		msr_info->data = kvm_get_apic_base(vcpu);
+		msr_info->data = vcpu->arch.apic_base;
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
@@ -10173,7 +10168,7 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 
 	kvm_run->if_flag = kvm_x86_call(get_if_flag)(vcpu);
 	kvm_run->cr8 = kvm_get_cr8(vcpu);
-	kvm_run->apic_base = kvm_get_apic_base(vcpu);
+	kvm_run->apic_base = vcpu->arch.apic_base;
 
 	kvm_run->ready_for_interrupt_injection =
 		pic_in_kernel(vcpu->kvm) ||
@@ -11725,7 +11720,7 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	sregs->cr4 = kvm_read_cr4(vcpu);
 	sregs->cr8 = kvm_get_cr8(vcpu);
 	sregs->efer = vcpu->arch.efer;
-	sregs->apic_base = kvm_get_apic_base(vcpu);
+	sregs->apic_base = vcpu->arch.apic_base;
 }
 
 static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-- 
2.47.0.163.g1226f6d8fa-goog


