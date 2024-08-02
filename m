Return-Path: <kvm+bounces-23120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AED0946415
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C8C71C2163D
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E3DE8248D;
	Fri,  2 Aug 2024 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gRfxlCDL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8DB6F068
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628288; cv=none; b=Iq0NAjIzrBxQIDl2owFCvPHLDiNQt8NxmLClmJrNuZsik19xvRevgLn75VSgNCgTx5eqA0gQLy2Z7J1tHk/7hMMah0PE3ZPggL33QgckcvfNbSxM5d62eRiNOi4TetzAkzikMvSuGV/hBlYpkWraDCcaToB3gn3eJ9L7NwOTITA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628288; c=relaxed/simple;
	bh=TlVRiUICJX5iI1P2EisP0czzGlPcN/R9pgkv0nTLVyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d6ZQljIJEiMkFjG/C6maW03jBCpHOCMyEmbGH+1SSlCCoq9cPuBBM6BV/wqK+wgC9pUQSI7+nP8KCttEboS9C9u6USQS8aKCBvxC6957/JK8YYDTwqFNJHa7kP29ypy9RF5UKGluTsP1DrMSfXouqTrCYzqk/qLycO3ozW6RnuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gRfxlCDL; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6886cd07673so47268007b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628286; x=1723233086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iMEFOq5Tk4KyJyaLBMXv5gnfBdOhdNIzblrVnJpsjo0=;
        b=gRfxlCDL95WQMFsto3I01rjyW+WQ3sYDWiGzxuUpkwFgpmdMEYgqPmYRE8VH7vYuTM
         Tq26s1pmLTmT8OUfMFkPFRmvu6l4P3ex/mPUobuH2Qnx/SIkWGQ8QztQjJCwNQ4BR0Di
         k5ybn97zdOfP717Id8ZKa1HsoNnqj32PU5ksWkqJwiZbtftrffS1AnGVksu/hoCaoYaF
         KZ2Q6xSJfNy9hDnq9FuSMEyPLsEw4gpJB001kcjNl5cgtFRHwuEwHwBmjQT6s4zitsX7
         H1YftSItbuxZjBHHIazGIuezsJMoH1tGEyRiZ3TvqVNcjCfVYjQ2kL1422+h/G0sVsrN
         5Vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628286; x=1723233086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iMEFOq5Tk4KyJyaLBMXv5gnfBdOhdNIzblrVnJpsjo0=;
        b=uA9weqa9lob3YRePxZDNsw4JbYFQ1ceThi6lbl7hVC2q0rvw2xVh6eFfa7v9QaNN2L
         eI9F3qPFth7Uj3F4/l4k2o/NfOw7wjymOR3Mv1CLPfxGbS4gA+uaE0Je8rWosbB1Boww
         QOBHi62gEeezaavsET1ayNNWx+lup7X138p9C6BBM9xuUn41ajgTTXiIjDEByA6uPavU
         SX26Xtt3JsZlR7jxD5OsWCcV5voObbXDsYZ/MlBTHfEr0X58FKp/vxAMPhv9N/M8CDif
         ZvMSBOfs+IVn7ot/t1BeHrF1Gc21USfuZdKU1Xu+i8MQ1G5x+e2mhUXAUBFpNMzWf5gA
         7ULg==
X-Gm-Message-State: AOJu0Yz2qEOkI3BTsxyARQ4zg8XJoKNPVaVHq1g5uTV55TM9MqW7KgRv
	dqpW1c0a/pZHFKhJ7CGVarGNwkEQ7d6SDWuA3B8pCkhWGSUUmxVzhklpCKP87nPqvNhNCoSKmvH
	dBA==
X-Google-Smtp-Source: AGHT+IEMQIhmUdXTQxP5VzE0A3c9BCZw8dM8LR647TTNv36aIGWuOmIV2yy9svYvy4E20onflnwZ7K40qLM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:113:b0:62c:f6fd:5401 with SMTP id
 00721157ae682-68963bd9bb6mr1995527b3.6.1722628285936; Fri, 02 Aug 2024
 12:51:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:17 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86: Dedup fastpath MSR post-handling logic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Now that the WRMSR fastpath for x2APIC_ICR and TSC_DEADLINE are identical,
ignoring the backend MSR handling, consolidate the common bits of skipping
the instruction and setting the return value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf397110953f..332584476129 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2164,31 +2164,32 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	fastpath_t ret = EXIT_FASTPATH_NONE;
+	fastpath_t ret;
+	bool handled;
 
 	kvm_vcpu_srcu_read_lock(vcpu);
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		data = kvm_read_edx_eax(vcpu);
-		if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
-			kvm_skip_emulated_instruction(vcpu);
-			ret = EXIT_FASTPATH_REENTER_GUEST;
-		}
+		handled = !handle_fastpath_set_x2apic_icr_irqoff(vcpu, data);
 		break;
 	case MSR_IA32_TSC_DEADLINE:
 		data = kvm_read_edx_eax(vcpu);
-		if (!handle_fastpath_set_tscdeadline(vcpu, data)) {
-			kvm_skip_emulated_instruction(vcpu);
-			ret = EXIT_FASTPATH_REENTER_GUEST;
-		}
+		handled = !handle_fastpath_set_tscdeadline(vcpu, data);
 		break;
 	default:
+		handled = false;
 		break;
 	}
 
-	if (ret != EXIT_FASTPATH_NONE)
+	if (handled) {
+		kvm_skip_emulated_instruction(vcpu);
+		ret = EXIT_FASTPATH_REENTER_GUEST;
 		trace_kvm_msr_write(msr, data);
+	} else {
+		ret = EXIT_FASTPATH_NONE;
+	}
 
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


