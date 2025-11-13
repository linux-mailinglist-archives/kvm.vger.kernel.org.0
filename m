Return-Path: <kvm+bounces-63083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F50C5A82B
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E084B4EE7BE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CADE329398;
	Thu, 13 Nov 2025 23:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wqBHUXTi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BFD328B45
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075671; cv=none; b=Js7AJO3AMIdmdhJBtRx6mv3wE6U/R54jzKpxZXqxcfSfesKh9B4ldFgM6qc4f8D3ssqDyKaHJ1msJu3NNWKhCun9Q4tD4MtjU2xe/2XAtzUmw0TPecbeYZxRGDwjI4UmE2i3au1wxjDed+sFZFCQJ02mJcEG0MKrv8wHeXUfz20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075671; c=relaxed/simple;
	bh=vjdcnE9j6DWj5tt+geNrMXKpk9jVp5Vfl/GVdQFul+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OT8KJSvkUJvIINuzsxqONofq153wS6Z2fDZzC3iZQD432RTXanPIWF4C+xTquQL79++tgEDGzxpzhyeDPI5kW9w10+rCCwhtd3PU0kqk3pPcCPz71WJqTFTwEf/RSS/CZ5WWNXetr5NCJX4TcYTCsQUDxQ4AHkitgjp+ajtYq7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wqBHUXTi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2980ef53fc5so42647715ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075669; x=1763680469; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4LiByP2+jsRRbpzgg8uE1tGPH47KWMDv0M5tBso2MkY=;
        b=wqBHUXTiqexaL896p1IOxWNfO6d0huE35qIZyfgnTay9bGhxeOZWLtfLoMhaoLD5Gd
         TLCq02fmnhUAVnDwNW6KqDl2+JyworagETyA4ZXSdZRJBRDlByK9KiNb1EBgbSNQrNTK
         FBMBxYgmuDJ8jFWf5SqpwqaRSrNHx8TRQqbcl+CG84be8eAegRn3MvbX9arz+aX09Erg
         ydgrY4qnkb6n71F4+wN+c3/jeU5UeB+ZyWgs9IRkKUU97Ay+JG+QGfRWpFr3ESqRNeps
         IEZsfIDjGfJvp+MgWDpxWylAe66P3HbCZtB5WmDt4mtEDkf0OguzC6m/0bMHZTWd3Pkg
         b4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075669; x=1763680469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LiByP2+jsRRbpzgg8uE1tGPH47KWMDv0M5tBso2MkY=;
        b=BxcgzXK1FAwPmHoKeVTuj4vhZV80qzFS/GBGjxvEcRLZM6wTuxKJP1ieph8umao8X3
         bA4AKyhItrZnQUsOqAU2KWSN/EA36h/pEyDiSZIvKiKQZ8UFw/EZ5VaEYIIcxyTQ5DWZ
         V3TN830mty50zj81drZL3UIL95W0vN5yXw7iukjUq9IeKbyp9lL85tR7dIJ0Mv00NPoI
         2vSwf+cxVPDFBwF6pQRmeKNYE2PHpyRVXsFhN9CfDCUT7WPg6++AKtBvl8p0wQnUJyU1
         RsTaPbrw1CdzJ/Z7Z17NYCn/qOQQWdLSXnYySEr+Z52R0iYHHjhKsBxVU7ulTFCUl1bo
         fUfw==
X-Gm-Message-State: AOJu0YzRRuZho36kqbBZSiMTnrNYTQ02ujgZzsoUSLp8nke8KHELCu5r
	kPpBfCtBym0fG+QwH9dNL2V1Gs1xX/snnMkElKcsCnqsDbMVw8HdQcx9VmYBFasBwi8bLNmeshp
	nn1f8BQ==
X-Google-Smtp-Source: AGHT+IFbx98nfw2mf982cjJrcNUrD3h03uR2zGX33yHs/oArPayGaQuFP+5p/PFmyJVh6nb7XuKhxfjvcUE=
X-Received: from plbka8.prod.google.com ([2002:a17:903:3348:b0:295:377d:bfc5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:46c8:b0:295:50cd:e759
 with SMTP id d9443c01a7336-2986a76f495mr7488025ad.58.1763075669481; Thu, 13
 Nov 2025 15:14:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:19 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: SVM: Skip OSVW variable updates if current CPU's
 errata are a subset
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Elide the OSVW variable updates if the current CPU's set of errata are a
subset of the errata tracked in the global values, i.e. if no update is
needed.  There's no danger of under-reporting errata due to bailing early
as KVM is purely reducing the set of "known fixed" errata.  I.e. a racing
update on a different CPU with _more_ errata doesn't change anything if
the current CPU has the same or fewer errata relative to the status quo.

If another CPU is writing osvw_len, then "len" is guaranteed to be larger
than the new osvw_len and so the osvw_len update would be skipped anyways.

If another CPU is setting new bits in osvw_status, then "status" is
guaranteed to be a subset of the new osvw_status and the bitwise-OR would
be an effective nop anyways.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d3f0cc5632d1..152c56762b26 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -420,7 +420,6 @@ static void svm_init_osvw(struct kvm_vcpu *vcpu)
 static void svm_init_os_visible_workarounds(void)
 {
 	u64 len, status;
-	int err;
 
 	/*
 	 * Get OS-Visible Workarounds (OSVW) bits.
@@ -449,20 +448,19 @@ static void svm_init_os_visible_workarounds(void)
 		return;
 	}
 
-	err = native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len);
-	if (!err)
-		err = native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status);
+	if (native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len) ||
+	    native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status))
+		len = status = 0;
+
+	if (status == READ_ONCE(osvw_status) && len >= READ_ONCE(osvw_len))
+		return;
 
 	guard(spinlock)(&osvw_lock);
 
-	if (err) {
-		osvw_status = osvw_len = 0;
-	} else {
-		if (len < osvw_len)
-			osvw_len = len;
-		osvw_status |= status;
-		osvw_status &= (1ULL << osvw_len) - 1;
-	}
+	if (len < osvw_len)
+		osvw_len = len;
+	osvw_status |= status;
+	osvw_status &= (1ULL << osvw_len) - 1;
 }
 
 static bool __kvm_is_svm_supported(void)
-- 
2.52.0.rc1.455.g30608eb744-goog


