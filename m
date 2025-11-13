Return-Path: <kvm+bounces-63080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C7ABC5A7DF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0A754354CDE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5175319617;
	Thu, 13 Nov 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z/zFbC4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2B62E1747
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075666; cv=none; b=iHQCia1hlag3jEW5ybBxHoRlFSRCXKop2zx7GanNWy2lWw2h91AscvrtX3emj1a6Dv/6FXn+JguEwujcTGIWgRDZwy7VqUKyJ2JNSJSKFZPjsLlQbO5ysC1DNsIoKeh4KZY9c/Z7woX+/A7R3WYs3twy2Sw4nggCNd0cS78ZrbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075666; c=relaxed/simple;
	bh=1Ug4NZTEkBDsYl1zyrkpie035MkE/Yu9FxatwqEx2Yg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YAT6/60niSDegM6WktaRMCzeMAV5G1vv7RLBPwKJrxs/uz4g5100IgxXJ/D6T4EyZQ+BitHiYqfUICZ9bVuMgJImo9Dl6o3cel/QBWSPIcV956/etC7/6MZaAW/jRX1YcCpqCRa9/PvDgKGi9+uwGLy8iav0KKl/+6QTUQssOSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z/zFbC4x; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3437b43eec4so2355447a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075665; x=1763680465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vCo8Zg1Lol/2z7vSj/8+cq61xRbdddn2wswjFAmZyfk=;
        b=Z/zFbC4xEuj32qWbtHHdBcsbo2YCaxNfqf2o9QDf/Z9X2E0k2h7iicw9on8bLQ7BXG
         XTTox7ZkQRNrjGPvRJkdA0IBBqDYf2epKsfrUkrXNfRLVh/ZY3uN1Ejr2kkQ4dCbdBLd
         qasUEpRdhCFFPJgKBEdc3LalBwbpwcxLSSjUBpjIWGI+yJIRv4MO3InBH1UpT5iF8RGJ
         8P6+N0H9a/hlHLoU3DAWXxP118NYxB8Hd/1KLG9CM5jpY/fvAC8+wRvKAmrG1SedBK15
         gfDIzP9syq0ay/A5FvhLCrlG6cSWT5rX61TJ2wci9fLJrCb/o+KKcZ/3hNUt3yOzxrff
         z8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075665; x=1763680465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vCo8Zg1Lol/2z7vSj/8+cq61xRbdddn2wswjFAmZyfk=;
        b=iQyq2PrzSYuqZQxa/welAXQHk7VBpBxrbyLr4bcRHR/DkxLkGhj3Z/eI8q4CVT5WFj
         tOm9Ak4G/8coIdsURUGiYjcTW3sMpdtPGbcFkwk2rbOYj3/N+0tVm/5iy3ZRUqLMWdnV
         t06CVBp9/ADynFdeE3gHXVd8En9cGEhmB1rh53YNvWA2/yLOGNO2jdao6ftkQFw1R5w/
         TyO1SjEipG5XTJazfBupKAl1M880r6W92PJDNvdWiKfeIw7VjeEGXtSCCt6t9t/ZDRMF
         bdDUx8xkeJoevg4WqEdH2zNPzsYGg+qYOKWeC+7fkCH+/wb+AK2/uTKNxb/HL+3hEAJX
         0Nzw==
X-Gm-Message-State: AOJu0YwhvIN+XEI9WZVsp1P+oVF3shhd9999o46px/IWIsjGzcNQVOx4
	la2Uf6WjBIlOo2f/MBOEyRFMcS8Wn/OUnPUT6Wy449QOEMkphvWhBXmhh+QKF0aA70/NhsZcbw2
	z18QNOA==
X-Google-Smtp-Source: AGHT+IEFwvnN7d2SCi3Xn3bEw9b3VihFAGbMKQStxBMCtqnE7tAxZvBuVANAwKnHuBD3pCb1qrR0SthNMvM=
X-Received: from pjbha6.prod.google.com ([2002:a17:90a:f3c6:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:43:b0:343:6a79:6c75
 with SMTP id 98e67ed59e1d1-343fa75c570mr989265a91.29.1763075664710; Thu, 13
 Nov 2025 15:14:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:16 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: SVM: Serialize updates to global OS-Visible
 Workarounds variables
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Guard writes to the global osvw_status and osvw_len variables with a
spinlock to ensure enabling virtualization on multiple CPUs in parallel
doesn't effectively drop any writes due to writing back stale data.  Don't
bother taking the lock when the boot CPU doesn't support the feature, as
that check is constant for all CPUs, i.e. racing writes will always write
the same value (zero).

Note, the bug was inadvertently "fixed" by commit 9a798b1337af ("KVM:
Register cpuhp and syscore callbacks when enabling hardware"), which
effectively serialized calls to enable virtualization due to how the cpuhp
framework "brings up" CPU.  But KVM shouldn't rely on the mechanics of
cphup to provide serialization.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fc42bcdbb520..5612e46e481c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -77,6 +77,7 @@ static bool erratum_383_found __read_mostly;
  * are published and we know what the new status bits are
  */
 static uint64_t osvw_len = 4, osvw_status;
+static DEFINE_SPINLOCK(osvw_lock);
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
@@ -554,16 +555,19 @@ static int svm_enable_virtualization_cpu(void)
 		if (!err)
 			err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
 
-		if (err)
+		guard(spinlock)(&osvw_lock);
+
+		if (err) {
 			osvw_status = osvw_len = 0;
-		else {
+		} else {
 			if (len < osvw_len)
 				osvw_len = len;
 			osvw_status |= status;
 			osvw_status &= (1ULL << osvw_len) - 1;
 		}
-	} else
+	} else {
 		osvw_status = osvw_len = 0;
+	}
 
 	svm_init_erratum_383();
 
-- 
2.52.0.rc1.455.g30608eb744-goog


