Return-Path: <kvm+bounces-27882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CC0198FAE7
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 01:46:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96111B20917
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 23:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0DE1D1F5C;
	Thu,  3 Oct 2024 23:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tQMSKbCT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CEE1D221B
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 23:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727999034; cv=none; b=P6DjTsVrQ7O/IL7q9yBzghllay+FOP1ORf6ZAIxSKhaffyUTZigBPMwe4HgT6MJvrv1Lb2vJa5vJERdlNccNbCSHdjOH+EZMEqCzFtLpA1wD1g76/UDtXp1dUt+lB2njlj/z0rEXEBfhNfq0CtcLYhKn32z2sdaqXvJT0I+vSuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727999034; c=relaxed/simple;
	bh=YWaZS/REFKJMLevlqrMIo/CR/NX3I+PwQJV5TvOBW+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HZIF0R8fWgfTotEkyYFaCdRAjTdUbJRLQGTx/DFozs02knrufIDLdOew9kjfPJGn+wSPKQUUaaVJIzR1AgR7YpyAY8XSFs/yfQ4fRqQxtLsNGLN+utovhFilvBD/5lUOHoN6x7hwlJmXggrskij5OQUNLGfr9ysb02Cr2yc0zlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tQMSKbCT; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7d4f9974c64so1055198a12.1
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 16:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727999032; x=1728603832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xgBcuvGk3o3ZhJ5eerG862wxsCgl+dqWJVsjJCQrLX8=;
        b=tQMSKbCTN833z8PFmSr0bP6Be9Ipa2H0X8P+Nfmi+zYAJM6Iduuok3T9oHynd6H/Tw
         iGu2Mq+3sUWbtl5XYOOa6ybifHd/wOi/tCmvbCjjBbtwQ7bQHuwBcYPM6L/01IolCExF
         CatAu7x/VpsrRu1Gj0a0nDrO3FsFuAIfTl0KO8L+h04vdcEK4MgMPD3dvSTejB/9KwhA
         qB4yTZSOtnHpk49Slm6OkZWSWCYnFRManXCh7rMf9Zw3y5+PJASirc+MDNIw6lBHy1h6
         rOE1gsaoeeRyPWhFhpSQ280QsTRfq3KwGHNsc6GA2t50ZQZNXYoES8JaAbKwDvd5UP/S
         VwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727999032; x=1728603832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xgBcuvGk3o3ZhJ5eerG862wxsCgl+dqWJVsjJCQrLX8=;
        b=K3m1dkOvNBqjGDN/I9BqmM/Doo/G0YslgCoXrWYZvrCevCdHd3D+ObtDwz2bXm6e4x
         3z6sEaSFv9loBuFxJU4zwPsina7lg/wfLAK0VsGcJKFERxUxKBZUfFX2fND+CWtLfPWw
         fblaYfeQ2XLgVLaylZx12RHOfVi/qc/vPe0vcIc+qfeAjdG05Ga3qNBinQuO49zww74K
         hMT8qT5jSYpwQxUIRpQinn7qJYL1tgzYT/NLboRUxXrj+N8whJojwbkPnSx1zh0KYTfa
         asl6t6cnGulX7HSrl8xKVpfgYS/jzd1PfoKzkeEP0Tu0r7mjHB4xEQvidZLM5MUjMHc6
         piaQ==
X-Gm-Message-State: AOJu0YzT9cwnzOe4dSh68BMthquK+y0AsSoTjlIl+CWwACY9hZyb7JfV
	rENq/72O1krNdncJY+2sA37wmzSw4FghsK8PWX+nIWZSrmfLglc5wodb8QX5YFLFzV0tXP3A4Sw
	7Kw==
X-Google-Smtp-Source: AGHT+IFXq9RCb6WRkwMAtMcPJ9IUSeE+59BJekmESI3c/ddtcupPuWgRFNALH1TsU96CuFHtqHa2A7atpFQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:8c07:0:b0:7db:16b4:7a2a with SMTP id
 41be03b00d2f7-7e9e59a8976mr1289a12.2.1727999031876; Thu, 03 Oct 2024 16:43:51
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  3 Oct 2024 16:43:32 -0700
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241003234337.273364-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241003234337.273364-7-seanjc@google.com>
Subject: [PATCH 06/11] KVM: selftests: Verify XCR0 can be "downgraded" and "upgraded"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM selftests enable all supported XCR0 features by default, add
a testcase to the XCR0 vs. CPUID test to verify that the guest can disable
everything except the legacy FPU in XCR0, and then re-enable the full
feature set, which is kinda sorta what the test did before XCR0 was setup
by default.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index a4aecdc77da5..c8a5c5e51661 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -79,6 +79,11 @@ static void guest_code(void)
 	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
 				    XFEATURE_MASK_XTILE);
 
+	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
+	__GUEST_ASSERT(!vector,
+		       "Expected success on XSETBV(FP), got vector '0x%x'",
+		       vector);
+
 	vector = xsetbv_safe(0, supported_xcr0);
 	__GUEST_ASSERT(!vector,
 		       "Expected success on XSETBV(0x%lx), got vector '0x%x'",
-- 
2.47.0.rc0.187.ge670bccf7e-goog


