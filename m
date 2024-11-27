Return-Path: <kvm+bounces-32587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC1F9DAE6E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:19:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2B3167106
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56A4E202F95;
	Wed, 27 Nov 2024 20:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QMjiYUaf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2DD202F92
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738786; cv=none; b=CXdGwN4q6kAmZ53R1ZkJ9+KCj1nUPtcnEZl/dUGRtMys7WK/0/Waj/k1sau0u282GJSLSIe+hQFZ5abhNMyZwoW+Ip3w/dfXghowBvAz/cIZJbnvlbXT5FlSfvlGC6PVr4RZuuTFv/GRz0lgnsSJ2YbP0rGGQzyfNJ8DRzLVtuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738786; c=relaxed/simple;
	bh=8R+UAJrB3nGcG9KbtGYvVJlRE7sXnKMwDSHzpdOQT08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CPAOn8sCFH2AKilCbymXdZEuTjhC466kmRaZYER7N6473g1QMetcgcDp8cUO/2wU6l4GU1qVZEwW+/aYf2ZPgjbb89GxbmAn+A0PQRrxWpyGAmIde0bDUqu114yfPbKAy8sQrrA0x0YAzcYmDumJIZfacMYd8XGWr04ay3pXaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QMjiYUaf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbe1a5b5b3so60050a12.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738784; x=1733343584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QeQudC1DydBYOOCm+tDoCUoQUBaQ511Zu4EsGbhYDkU=;
        b=QMjiYUafgmuFBZczaX957md38LjXdPh697/3v0TT6lyeZhvhHHafjFyJbBOoeTalkh
         xTmD2uJhiIx/HBZcpR/WivL8quUSG98NOMgEH7XC20eBKJMJYjR2zZunoppCS+YcPQyU
         R/zOuEi6HA5voJpeKxYx4Q8x7f3LARG2DXlzvsEcXtZQbi6+3i3oWaMFJgnlo8eq5Unt
         QmQYrFTIxRlJZ98Guj5nm9710HunsGhILvHUyYq1WPp6npsQFaqp6EUifDNm8dF9UfHR
         azRSdU7d9Rhmm6gb+Pf21RjGee5rWY1nALdhEE0vlNoJ4hfV89tuaar81dmyzmArI6Di
         n3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738784; x=1733343584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QeQudC1DydBYOOCm+tDoCUoQUBaQ511Zu4EsGbhYDkU=;
        b=Sst944+zENElQ7jdu/pb/1ZW1qeL3ab21/eWRa2LcHrnz0ypJcZwupckrDChxC1UlJ
         BN2Qrf8FRhkfV3p4h7RBDqoion0bND5h4h51jmmlFYSPwUEap3eHtCRbd4No0LjDrTSA
         p++MXT1emdSJlg74P9rq8tuT6jujnT7qWTUX6UlNwbdTaVZY3udKGupUs3UsqGGLCzKF
         VpHW0zlvRYj8BlaCmnDgXr41KZn4vG/0Ea/rQ+R2fhLDAX+hlG2kihrcCw4C1gNcOVdV
         W9ckifsTJt/1NrS/gV/DeSbumsuG0WNcTIwmgBbfqwSYSmFFuwl22vF1fyyz2Km7oC0B
         MVQw==
X-Gm-Message-State: AOJu0Yxn8kkWzIOfmpsyqo3t1dwGoFrz4A3M/xAu/0X9pnSVWkiRlvjn
	BWrZJmMGf52MUktIfsds2sHJlciCt+epOB42ZtyuAmSLWQlFldhaOOVL1WLD4JHl6x9hhjE27J7
	nBMJbGTzV06nWr282Kf+p9fh6OEFWPBOvgrOTGaYexZRKNaHRGlYDe3DYfH8IzfEfRRI3CnD5vK
	ZMt373TMjiRTWCSLCSmdjQW7iUmhUUystf+6IOO3op1ly5fm9S+g==
X-Google-Smtp-Source: AGHT+IHLs2UzbEZvSFKH6jHmKeRjD7NZxiMiv36yszF2SZ7cKLnh6QHaOXkd/zO1s7Hyy8+TCvbgZuh68UsozJbl
X-Received: from pfbbd40.prod.google.com ([2002:a05:6a00:27a8:b0:725:1ef3:c075])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3289:b0:1e0:d14b:d54c with SMTP id adf61e73a8af0-1e0e0b58d0fmr6986078637.30.1732738784179;
 Wed, 27 Nov 2024 12:19:44 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:15 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-2-aaronlewis@google.com>
Subject: [PATCH 01/15] KVM: x86: Use non-atomic bit ops to manipulate "shadow"
 MSR intercepts
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 arch/x86/kvm/vmx/vmx.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd15cc6356553..35bcf3a63b606 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -781,14 +781,14 @@ static void set_shadow_msr_intercept(struct kvm_vcpu *vcpu, u32 msr, int read,
 
 	/* Set the shadow bitmaps to the desired intercept states */
 	if (read)
-		set_bit(slot, svm->shadow_msr_intercept.read);
+		__set_bit(slot, svm->shadow_msr_intercept.read);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.read);
+		__clear_bit(slot, svm->shadow_msr_intercept.read);
 
 	if (write)
-		set_bit(slot, svm->shadow_msr_intercept.write);
+		__set_bit(slot, svm->shadow_msr_intercept.write);
 	else
-		clear_bit(slot, svm->shadow_msr_intercept.write);
+		__clear_bit(slot, svm->shadow_msr_intercept.write);
 }
 
 static bool valid_msr_intercept(u32 index)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3d4a8d5b0b808..0577a7961b9f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4015,9 +4015,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			clear_bit(idx, vmx->shadow_msr_intercept.read);
+			__clear_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			clear_bit(idx, vmx->shadow_msr_intercept.write);
+			__clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -4057,9 +4057,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			set_bit(idx, vmx->shadow_msr_intercept.read);
+			__set_bit(idx, vmx->shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			set_bit(idx, vmx->shadow_msr_intercept.write);
+			__set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
-- 
2.47.0.338.g60cca15819-goog


