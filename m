Return-Path: <kvm+bounces-63084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAEEC5A82E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5DE574F3069
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39CC1329E4B;
	Thu, 13 Nov 2025 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tOQsHA75"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00D6329387
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763075673; cv=none; b=RUepp30W3HYxLRRJIMsDNXfLUC1jW90MbhhB/bRunnDrOOFiF1dU0ttWtScF0fSJM5jxFkr9t1N0TT/MLsa4cIgH5RhRiSh4xpVQpQyALRpqGY+tYNIZQf4y+1lRUyvjZCtOGs4u80hmoHOJs5sD1DGMaBEw281QtVzIJqvNNUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763075673; c=relaxed/simple;
	bh=P+OJqik9ELv7a5k4QNvOSwAoDfd9OPM8bY2qW6HDbEs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mIS4EZZNsD6v0kDUHd8igiA4u/Y3KEDjnRJn0Dc5xJcObnDbl9ETmqHpAcX/bFgch6aalP8ZqclQfQdhWiuPqXvOhjqlkLOtgLL7n9GYO8b/M1sUkr3MYXjJXwi3u3Co9TlKskBamEmT7hvu2/5kPRpnYMtJsQV4yB/qbnHoN9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tOQsHA75; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-ba265ee0e34so1316519a12.2
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763075671; x=1763680471; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TN3Gz+SnUx6ts0S3LVmTQf3v0hlfTP4ojWwkYuFAiE8=;
        b=tOQsHA75YhsuySLqJBj1WCb2Zhvaixhz0KU7MH0BiYoKQEy/nMI5l2Dr/usXGVvocC
         SQZ2BNmH7cd0ZDpmErLQHYLCTr9poGzDlJJavKlTw5xCoKjdOath/xjwdnGxWK/RAnRX
         s2o32miCwQjfzvGN5BtaLngUxdWpunhjFZERRCm+zQP+eV/ugyxO9O2wjUmwk47arWUP
         4NYJU5wn+XnU8ivitKdGdx/ItB1a9GA6wwy1hRGeUkjwEz1yOowzhG3CtP8b05gbJIBz
         kFD3UH3OAKhjdD5XB488sSFtuFxX2YUaKOHrbt3zgPZnT4UOzjtEodAaYJavjT2FZq2s
         EPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763075671; x=1763680471;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TN3Gz+SnUx6ts0S3LVmTQf3v0hlfTP4ojWwkYuFAiE8=;
        b=ersSMmHlVUAOONyj8xORcj6QqjrHt7SN4pilOGtjvsUcTtMuGtim81mptXY3yp7VCg
         IT1/rLL7lAmeIKWeZYvTDqYbSC7DULguXiSjzFSescFuOMaSg6UQzM/Kt5p01aXW3Sj9
         iepDAT3p1FR3Q2rEQ7cUm3+bb/86gj2U7HUxh4ZpQJBDmeYTo0+jw932wX7pWsLEe2D+
         L666ZZ61d13qocddJ3x3zud0V+96kvgvtOS+ahT/2h+/7vEGgwd7juye4Xv873hPV+j0
         cgumFdiVoYC4eywfGsER2FTcgRtLwtxf6pTh9fgl2lwgc0aUaTpkVPs+prANXmZo498/
         Ep8A==
X-Gm-Message-State: AOJu0YxrD+wvUll5Uqq+CfRd5JSeUZk/5LoTz7o8Ayn4HmmbHd0SMRGE
	zgvOlpEquDXuRbCmYpm84QKLvE9m78JlJXC51TbnJb5gm2CZBdK2AxEtLKEDFq17HC74+kSrs4h
	9aOkkkg==
X-Google-Smtp-Source: AGHT+IGsJGw/14zN18rRPH3wKxEKEDFEVCkWQhGO7Os9e3BEOVxC7uxgOOQmYQe+NasF0ihKKEpUyvJUhZE=
X-Received: from pjtn21.prod.google.com ([2002:a17:90a:c695:b0:340:c625:b238])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f0c:b0:340:d06d:ea73
 with SMTP id 98e67ed59e1d1-343fa525a24mr862143a91.19.1763075671338; Thu, 13
 Nov 2025 15:14:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:14:20 -0800
In-Reply-To: <20251113231420.1695919-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113231420.1695919-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113231420.1695919-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: SVM: Skip OSVW MSR reads if current CPU doesn't
 support the feature
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Skip the OSVW RDMSRs if the current CPU doesn't enumerate support for the
MSRs.  In practice, checking only the boot CPU's capabilities is
sufficient, as the RDMSRs should fault when unsupported, but there's no
downside to being more precise, and checking only the boot CPU _looks_
wrong given the rather odd semantics of the MSRs.  E.g. if a CPU doesn't
support OVSW, then KVM must assume all errata are present.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 152c56762b26..c971a15453be 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -443,12 +443,8 @@ static void svm_init_os_visible_workarounds(void)
 	if (!osvw_len)
 		return;
 
-	if (!boot_cpu_has(X86_FEATURE_OSVW)) {
-		osvw_status = osvw_len = 0;
-		return;
-	}
-
-	if (native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len) ||
+	if (!this_cpu_has(X86_FEATURE_OSVW) ||
+	    native_read_msr_safe(MSR_AMD64_OSVW_ID_LENGTH, &len) ||
 	    native_read_msr_safe(MSR_AMD64_OSVW_STATUS, &status))
 		len = status = 0;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


