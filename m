Return-Path: <kvm+bounces-66863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E59CEAB39
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 66DA4306434B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 21:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A907532B9B5;
	Tue, 30 Dec 2025 21:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RTLKa4iJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F831320A04
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129243; cv=none; b=o8yo3y4ORzX7VLQ3dct9YWyOgn0bubE1vLjzjz+b901v8wIlOqlT1Z9uYdqwTMqIwqZWFDbfzRxLDT4tc19PvRp26Ypigplm3cEVe7/uRD9glHCLfAXOIME4Pi0pSQ7ypwNMy+5FEZ1PhP9gwJ54/m7QXWnpRSIXw/0X/TGNumA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129243; c=relaxed/simple;
	bh=tZZOSec6/iCpiyzfAUT+ddNkhTixOC1p46bySbF1Lsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AtDiYfg7DK8wlPyoj2wEfCh9/bUaApcWf+lZvYGPfXzfL82EzNdd3aYHlhV0cBb+v+pQwxmQpwUWTCo6CAw9yU1FREV85vIW477J6NG+i6J5PifS2Vfar+WkEoD/03PP6byXW+IaxfVdDgKo2vKCSx8BLvc1AYt9JSG3wQQQyjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RTLKa4iJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b9208e1976so18992537b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129241; x=1767734041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1VNAutqDSG+oAcPpulLkMbiDreEONHN5ynm2RRYnZD4=;
        b=RTLKa4iJxEMv0kdR7Ci+DS7Nhisl5cJKuff7pbFxhVp7jOx2HdQ6xE4XOAapvXnFPg
         8KhAHFyw8CqW84ukJPUbEOmXcgwHU+g3JDpuze6lXIlPGUySdHsyxTnB2kEw4OLW/Bla
         Tn+iLc25UgTDRW1nKZ08N+Ks261MSEed73sFPoZ/O8d9W2zXtcg2k4mcYvZTcd/3Aaht
         tPT/+x7ZF/WJOeWTEpxLopFFJyzwq+WRXvGTAgWuLN3TiTUkLaqWgzxliqYhS1k86J/k
         nIPtZOBiooVjd5XYitgZigwgia/XgIQ5w4JN8Z4IlMqWnWDtF2Q+gFi+Ett3JyzpOLT6
         iVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129241; x=1767734041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VNAutqDSG+oAcPpulLkMbiDreEONHN5ynm2RRYnZD4=;
        b=RB2T3nhjeQRi556e/tkh6+7+FjYl2JqWXn2qAJL7JgbLZAtgqKG66Tn7TcclvFr4W+
         2RcoOTiD5OgXR884sXeUQJ+hmqknxPt193GWsCrPVKHlc4gceKKLkS0u3CXNhhiWUrMq
         8NyxeI9B7OpmTmlIjXnC6bawXSRsV4qEOVK0rKbvpndVWrGCs+wLn7puBvUnmBowFjQq
         Z1GbN7+rWL+T1jgq4o1PnmJahp1vAyIz9xqCE5upDAXG0xY1A5u/DsKsxAJdPUfMNrze
         4OX11dkXf2Ys07eOoSFzTymCVNrB4GKP9KZHwvnn6eR98LGPlV7EzoNh9wdJz+rSEX0A
         RQKQ==
X-Gm-Message-State: AOJu0Yy40/Yh2/ColOe+O0ajPqKoiACSk/C6wip+a0BMXW+4Lk4zvCx/
	YZNBC+PAVQzjgOSaUfxlaweAQJtXGhaftLEEpZo13hC7Qre5PZtoWHMSOJ3O4l+bV6LfIsLb6va
	PvIMV0A==
X-Google-Smtp-Source: AGHT+IH7+mef/Yt8vBYVv2MwxPLoJav7Z17cT1/FRzx/Cb02MsEGBMNYfWKFBUDmhPe7ZcDuK/w4obJ/XLg=
X-Received: from pjwx15.prod.google.com ([2002:a17:90a:c2cf:b0:34c:64d5:2aa1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2591:b0:366:14af:9bbe
 with SMTP id adf61e73a8af0-376ab2e78f3mr34274847637.72.1767129240895; Tue, 30
 Dec 2025 13:14:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 13:13:45 -0800
In-Reply-To: <20251230211347.4099600-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230211347.4099600-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230211347.4099600-7-seanjc@google.com>
Subject: [PATCH v2 6/8] KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to
 running as a VM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Limit KVM's incorrect check for VMXEXIT_INVALID, a.k.a. SVM_EXIT_ERR, to
running as a VM, as detected by X86_FEATURE_HYPERVISOR.  The exit_code and
all failure codes, e.g. VMXEXIT_INVALID, are 64-bit values, and so checking
only bits 31:0 could result in false positives when running on non-broken
hardware, e.g. in the extremely unlikely scenario exit code 0xffffffffull
is ever generated by hardware.

Keep the 32-bit check to play nice with running on broken KVM (for years,
KVM has not set bits 63:32 when synthesizing nested SVM VM-Exits).

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 105f1394026e..f938679c0231 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -425,7 +425,10 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 
 static inline bool svm_is_vmrun_failure(u64 exit_code)
 {
-	return (u32)exit_code == (u32)SVM_EXIT_ERR;
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return (u32)exit_code == (u32)SVM_EXIT_ERR;
+
+	return exit_code == SVM_EXIT_ERR;
 }
 
 /*
-- 
2.52.0.351.gbe84eed79e-goog


