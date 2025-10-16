Return-Path: <kvm+bounces-60218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA569BE52C5
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 21:07:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8115188CA85
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC17122D4FF;
	Thu, 16 Oct 2025 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AqmNKDUA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC923EAB7
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 19:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641612; cv=none; b=qW1G4qa8qVClHXUxsrZbQB9ZUocYGFShn+XT70DbCH9Tl/p6M0LFwvnnmjk289jNjCLoNl915NnGq2z4903PeXDyssLupaIEQuf2CzJQvg2jEM3Tb6vuvxXOfchStpPZjbuFHWDGUnDEzlaf2PBojv2zFQOJfjeLLdU9VRbJ8n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641612; c=relaxed/simple;
	bh=JW7z3gtYmIQD/6S+niMhVW/nJMbFcqzAxLFUZZrB7nI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a6iN2IGLYbAtiy1UuT/iX+dBVau3ZiE5M2JP5epYgiqtCcbp4BQ9+JCZVGWWpiJ2xtz/Qnu1B5j3cx+FWYqu4WjHMXUGNrREoekSaff38UwT6svaA1FaNo9PrKHsNAPr3KsxTqIkW6qV/v2+p9nCfm6QyUd7Ga6eDUnbt3fjBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AqmNKDUA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so1019147a91.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 12:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760641610; x=1761246410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5P6dDSNCmzKxfhpp1ZNZBmUurWs72xNNugKaW5ETdDE=;
        b=AqmNKDUAW0Yq01tklGDt1TRrkGpb0Z/9sfIqtTXAE3ex8JpLrWhF5IY2z7wEXSD/1w
         iiBiavOfPZjp6kkDuxHcxTwQSTMzxxQ/fyTJr7PqCIQdXkp/7ZqNn9vMnyTTyNzL/okF
         6g89H6/mWp6mAL+m6YUTVd5HQf8rU561UDTPy3HFm54zaYi7gaPMsuHOkuyIV+sK6KLi
         jqIVE1iEOTUQI8OcyZzz9drcfmz8u62mMTuG3IgY6qpT9k9fKsZRM6va/3YwswmtwYIg
         1TR6tZhe/dCwg/ncWtDb+kzMa3rMdu8sVyyGaLQ8E+qOA3m1yZNfPsTI+z7zcXWxOzyh
         bjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641610; x=1761246410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5P6dDSNCmzKxfhpp1ZNZBmUurWs72xNNugKaW5ETdDE=;
        b=tU9SWrwELEggvEdS3hOrm5KFhGdntfUwzLnnE3KThWODEMVcfAkdy/Ie5WsuMimL2r
         KopWJrjdGcsTHZz3v41CvDqNm6qIkqz4bmpERZdkbi+lK4NvlG5pLICy3TSS7CRQV1XM
         xe/n3835MlmhX+n6c3iJe9iT7BZ42iNpWIrsP1kmOoKbHjxOhzlRVgpZTPqZT12UKx14
         /b87Xou8Koex1GlHkP/coJ99FzpPVbExx/Jrip5c4FQRrOrvroVUY5gK5R048cPM3nT6
         Q38ey2tuL1zqw3ZiSoa1VOZt03N0z1SNWNQof+tAnLslS2/K7ln+NJ5H5R+X/LIqJSDx
         41qg==
X-Gm-Message-State: AOJu0Yx/l1m2Qnsihet/rVZFdbikobz+DvAfY9SLlnMoZrNhE/lS9LhI
	O+7xbTuqeOZlAt8t0KUObMecelZvstvPSRX47X/XhJi8BF7mYknVMiQs8BOpAZ0ZZS30wg9zzfN
	iHlqTCg==
X-Google-Smtp-Source: AGHT+IEMLXxrebXUQYBUfsHF/iy3T21DrB/adBG7La2FMSta2+1nwRvulay3zG1CBGfpRlpxfBI2SicAWfc=
X-Received: from pjzm20.prod.google.com ([2002:a17:90b:694:b0:33b:9e40:1a48])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8b:b0:32b:6145:fa63
 with SMTP id 98e67ed59e1d1-33bcf860229mr1201741a91.4.1760641609799; Thu, 16
 Oct 2025 12:06:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 12:06:42 -0700
In-Reply-To: <20251016190643.80529-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016190643.80529-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016190643.80529-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: SVM: Unregister KVM's GALog notifier on kvm-amd.ko exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"

Unregister the GALog notifier (used to get notified of wake events for
blocking vCPUs) on kvm-amd.ko exit so that a KVM or IOMMU driver bug that
results in a spurious GALog event "only" results in a spurious IRQ, and
doesn't trigger a use-after-free due to executing unloaded module code.

Fixes: 5881f73757cc ("svm: Introduce AMD IOMMU avic_ga_log_notifier")
Reported-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Closes: https://lore.kernel.org/all/20250918130320.GA119526@k08j02272.eu95sqa
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++++++
 arch/x86/kvm/svm/svm.c  | 2 ++
 arch/x86/kvm/svm/svm.h  | 1 +
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f286b5706d7c..3ab74f2bd584 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1243,3 +1243,9 @@ bool __init avic_hardware_setup(void)
 
 	return true;
 }
+
+void avic_hardware_unsetup(void)
+{
+	if (avic)
+		amd_iommu_register_ga_log_notifier(NULL);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index efc3a7adebef..76055c0ba177 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -921,6 +921,8 @@ static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
+	avic_hardware_unsetup();
+
 	sev_hardware_unsetup();
 
 	for_each_possible_cpu(cpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e4b04f435b3d..b0fe40c21728 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -805,6 +805,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 )
 
 bool __init avic_hardware_setup(void);
+void avic_hardware_unsetup(void);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.51.0.858.gf9c4a03a3a-goog


