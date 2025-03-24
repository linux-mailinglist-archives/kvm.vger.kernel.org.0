Return-Path: <kvm+bounces-41794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D862A6D8A7
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 11:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A06416C762
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 10:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C441425DD02;
	Mon, 24 Mar 2025 10:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t6Tsjqmr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1DD1C8605
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742813494; cv=none; b=PkNve3JOw/SCQFKC5AQYFwpMPccbzzv3t2Bphzym46wuTBqDhAlhiaPlDmVOYTGbFR/JN0lxL88tQ5BNiG7Fmv3BX4iwp+CvK6M4DdY7O3uH8ssCDjknGMEbQ70pJsfhJ1ORE36gZdBDzDAY/6pz70Z1p/QpL1Y8fkwtSm2KNF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742813494; c=relaxed/simple;
	bh=DcUNwbRdPnow83kHtle77XVYOEVPg7rrZhWsXAiAdvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MpGr6wl+H7eOoVQqIwvaAS0tn+V5WuM7C+gpUN3qsKFobAkV9qgbd0VYixl5nHHRLSkl/TgHrTh/CubgiVzqh/txFPV8Gsa5j1i+WiAOFu/K6L9Azi3d26ijRe7zSy5/RBTNubDTyzG1gXgHQZji+e3hFD6BWCkwakN2Dn9zPsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t6Tsjqmr; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso26435175e9.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 03:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742813491; x=1743418291; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XBugaXb0XfXOq/Pw2aaFS10qYW8sYB+YovrYm1of0M=;
        b=t6TsjqmraRQZ1DQ8ONd6zW7pki7uVKNfXUwsL437JhTlQwqIq0RMdRbyNy4xytvPEl
         7oD41CupVEoD0yVlTN+zsc8lDK4JSZv03fEa5+YyTQECNbuIalkO8qgUidVKQ8XhrUjq
         iWtf2yOs/xKPqby6UBGvZye3JN/RFVOpTHpp++r/ObWVy0T/5zqtBlLXT2sU5LQvIAaQ
         9YrQc8qipWXkSlMOUMTv/Yxp7skz/IE+me6yF4s3M9SIgPOsm700JAY5gGsm2XORpbNd
         DTtgSbybDr1T8zFKoS7NcXg6xD17e7tDcaPBS8OmNU8EiXT8qubAlBCljZwucTpnPWL0
         WbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742813491; x=1743418291;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XBugaXb0XfXOq/Pw2aaFS10qYW8sYB+YovrYm1of0M=;
        b=ZpS9QdW96POeSW1oDHvFzPXnx0TBxNvqb2vh9uiDmMBgBF1bNpytpPw0bLyKus9FOi
         RZfLLLTHVjFIs0Uwh7cy1MhqWR7h2DvMnc22WmW/BIx4fTWZEgotDYESQk+BGljzEbRV
         pQb04P35usLDXaS9F5g/3J/2XDQO8FtU3nJCsEXU2xzMiMZUxfNZw8zkXw53p/pNLub8
         9ndllwQAUFSCMWXU08YonvLz7Vp3e9tD4sgGJAvCZZtnbKZoaOpOxNMz6eFrHRzp6hei
         rQmIM7Z1qvR9a/wVPbhSvAVztB4pGQCoJg+6J7dpoEZzyOq/JIT1tN8OQo0uwJ+VIvT2
         W7RA==
X-Forwarded-Encrypted: i=1; AJvYcCU+2jVYJ3+HcsuplpbH+bl2Qi1AHK4n8VlFzE2DZsL0PZEN7aJsm0QQaneXBmUz/IP/nQc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk4wAvez+wu6b4w9bysjvK9r2HBROc/viQFwppz7uVwPGPhsf5
	zUc1fWkWdi/SJb3HhAS/PcZL2/he2pFzQplTJENGSMo0n1M+dh89mlrY84Y0fdk=
X-Gm-Gg: ASbGncvISRUp3/n6qIoFGdaYPis96pYA+AuA1Q0K8ACP1L/1MEAmjF8xi5SdDtt2/QT
	20+AxcTjcKlIsRk6Ki96F2XxXGdbl5yphaWrsTAuofx7asYz2eCvVuyi02tHl+7po6uCrArR9Rn
	v9bhDj2wq5NmYaHXO/hrV+LWUDaFYAgdG7D7ekzcxTiGReJry+FvWHEmgQFIutqtmCBreYnlMDL
	vM+Kx+PVAmpX4Klkom2bmgC8osCEKjgxcDi51RSfogLlqO6A6rTx30GEupWBR/ay2RaQkx4YO62
	EsIMBPf9fWBCqnyZ0TTk60fgyAgQWAvh7lNglJCaBHp0K6YYuw==
X-Google-Smtp-Source: AGHT+IExcAE5hR9WRBPjbbJe1A3tT2LgZRn6kn5d7CfZGvAe25QU3/LL5pLa+ilmFxLgUVsdLqKbPg==
X-Received: by 2002:a5d:64cb:0:b0:391:42f2:5c7b with SMTP id ffacd0b85a97d-3997f8fea8bmr12460729f8f.16.1742813491455;
        Mon, 24 Mar 2025 03:51:31 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3997f9e65casm10745004f8f.69.2025.03.24.03.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 03:51:30 -0700 (PDT)
Date: Mon, 24 Mar 2025 13:51:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] KVM: x86: Check that the high 32bits are clear in
 kvm_arch_vcpu_ioctl_run()
Message-ID: <ec25aad1-113e-4c6e-8941-43d432251398@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "kvm_run->kvm_valid_regs" and "kvm_run->kvm_dirty_regs" variables are
u64 type.  We are only using the lowest 3 bits but we want to ensure that
the users are not passing invalid bits so that we can use the remaining
bits in the future.

However "sync_valid_fields" and kvm_sync_valid_fields() are u32 type so
the check only ensures that the lower 32 bits are clear.  Fix this by
changing the types to u64.

Fixes: 74c1807f6c4f ("KVM: x86: block KVM_CAP_SYNC_REGS if guest state is protected")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..c734ec0d809b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4597,7 +4597,7 @@ static bool kvm_is_vm_type_supported(unsigned long type)
 	return type < 32 && (kvm_caps.supported_vm_types & BIT(type));
 }
 
-static inline u32 kvm_sync_valid_fields(struct kvm *kvm)
+static inline u64 kvm_sync_valid_fields(struct kvm *kvm)
 {
 	return kvm && kvm->arch.has_protected_state ? 0 : KVM_SYNC_X86_VALID_FIELDS;
 }
@@ -11492,7 +11492,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
 	struct kvm_run *kvm_run = vcpu->run;
-	u32 sync_valid_fields;
+	u64 sync_valid_fields;
 	int r;
 
 	r = kvm_mmu_post_init_vm(vcpu->kvm);
-- 
2.47.2


