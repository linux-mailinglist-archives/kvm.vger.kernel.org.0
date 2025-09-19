Return-Path: <kvm+bounces-58097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5346CB878CC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 03:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 044081CC1450
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624A91F3D58;
	Fri, 19 Sep 2025 01:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhN5csWE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C121F5617
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758243601; cv=none; b=Wz8feKwZ97QZEGZ8r3YAX17ADv7+MA4Y59uaUPZEj+/Btcjw93YkZ3TQGYkX6xhVbbhhp0NzgaiHERfHo8aCU1My76qc/lCvmTVH+ic2DSsO3TKIwpZQxFabAYGDzYwWEcz04Vorx2JZfIO8iss8GpPboVBPws2lpfFnrLw+seA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758243601; c=relaxed/simple;
	bh=FfCh13Q+m92+CymbRlQmSA5l2N0xV/rmT0iRiDdm/D4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e53TAmQEWLkVTZNfoGQoSg+3Lj9XkmIkgHcinAKuZrhAsiQ3YyaPHAa9c9hzTKYDGzRo3ezKa2iJz+GUAiPr+zA4WEYoiVlsPkCKMtc5GKC1DXX0mzq+tbKpZgfExfALRGw2rxjrnQlyFs72i1MgWj4rQrHtVruUFkmSGVyz1xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhN5csWE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f59889so18461935ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758243599; x=1758848399; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OvlGI1x2xd9nnaxn6+YbYZ5V941T2eRm4PgITqh2qd4=;
        b=vhN5csWEC1zq5+4TiEGdenNHhy2vI3koxy08I2MTowtxFAArPMaqWPtAmH0J9emdeS
         A5je756RXM2gs64Zpgoslhu3iNOQQYChwj7+McQ6r+716CRsp5e7Xk+C9H6EE/O5+VWZ
         H7wH8rvFuCLJtu4aZzs0/mOmuk1EOSMafoYuavabUFKYi0qFZBmtLCXTfqNqwi7AxKhS
         SXfjKBMw0Wj1Ke26N0gUerm0ce4Mxh850wTJqDiucBE5RRNrkZRyOscOcjmv7mNEIgAH
         YyUNuTp3tz9+uxwrKRnU2zjeUmrMU7KEQV1cCbCirwqrx/Qb9/akj1GRb3doXG/hxS+j
         JkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758243599; x=1758848399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvlGI1x2xd9nnaxn6+YbYZ5V941T2eRm4PgITqh2qd4=;
        b=XWvRfttGZUgjzPAQxkMpU6/KIVO2lQgSkACNNbGz4ssDL4ZLWo8wrtKl2kLp52sUox
         B/1vq4eyu4ajEQu+VhZpU0aOOrJULv62oXmt9fgFUY1+zQ6xSViJGk345k0K2mfQ4jcB
         g+EwHW/i4u7EDJ8eX/l3SF9xp6O3dRPHiGVsFJgIxDwiuXlrmGGlAzNlstJ7MtG2qo8K
         UHUmzPlWaFECFcdAFiMw6lidye+UxDjobfNz/DZrZPztk4t+CJT3V2Ixkrl3MbeWX6GA
         NXaZEUW8G3BfrizIC2Tri97W6yY2zrFIWHY+jzzxG9kj+L7PTTnFdEaJxGSe1r7gSkM/
         czlQ==
X-Gm-Message-State: AOJu0Yw1lY0YB34zdwwtrntw+NNLTi3sI3d0xtRcpYriB+x/FWAL4elr
	3G5YY+xxDPoa/ubecbk4JY+0RLqeWn9a6/af5s//rgHM1W8n7zHPRZ2Ah/n5jrOZxlaQNjY4icm
	okf9Otw==
X-Google-Smtp-Source: AGHT+IF9CdEIDOE/UKd3QCqc4VwIlDG3jXKLfgBVhQjS9OcGyBwSpjhRCVv6E83o2ykIT0BdPjNtPktfrEY=
X-Received: from pjvv5.prod.google.com ([2002:a17:90b:5885:b0:32b:58d1:a610])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef44:b0:25c:343a:12eb
 with SMTP id d9443c01a7336-269ba402095mr18635305ad.4.1758243599336; Thu, 18
 Sep 2025 17:59:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:59:47 -0700
In-Reply-To: <20250919005955.1366256-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919005955.1366256-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919005955.1366256-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: VMX: Hoist construct_eptp() "up" in vmx.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move construct_eptp() further up in vmx.c so that it's above
vmx_flush_tlb_current(), its "first" user in vmx.c.  This will allow a
future patch to opportunistically make construct_eptp() local to vmx.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 35037fc326e5..3c622c91cbc5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3201,6 +3201,20 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->vpid;
 }
 
+u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
+{
+	u64 eptp = VMX_EPTP_MT_WB;
+
+	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
+
+	if (enable_ept_ad_bits &&
+	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
+		eptp |= VMX_EPTP_AD_ENABLE_BIT;
+	eptp |= root_hpa;
+
+	return eptp;
+}
+
 void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -3378,20 +3392,6 @@ static int vmx_get_max_ept_level(void)
 	return 4;
 }
 
-u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
-{
-	u64 eptp = VMX_EPTP_MT_WB;
-
-	eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
-
-	if (enable_ept_ad_bits &&
-	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
-		eptp |= VMX_EPTP_AD_ENABLE_BIT;
-	eptp |= root_hpa;
-
-	return eptp;
-}
-
 void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.51.0.470.ga7dc726c21-goog


