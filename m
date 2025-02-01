Return-Path: <kvm+bounces-37040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32387A24663
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAE57167B7F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2057139D05;
	Sat,  1 Feb 2025 01:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mzEZ5Vs9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA051474A5
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374931; cv=none; b=oBrtpQ5zbDxPB6XpGIdGZ6dzqyq6fwIg8Q8AEv9NeC9DzpLWC2yxCfV9fxyziuDZG6J76xStw7a7MJhQUwWqajTFiKwg/39qJF0UuHvy6r7kbSBq5RWArrl4uHn+lV6tBxIdEuK+5lMjNnAN3sTL/HxkS3VvGa/tJZ468yHw6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374931; c=relaxed/simple;
	bh=UVo6Z/4dhiFoOhJN3891jfwkXaQHO7XmA6oXNp4w27k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qu8nSi5KTVK52U/an7rD+32z/0id1j5/4Pr2LN6G/bUIlGbL/C5uitjlF3b/HPEKnKZNKAx1NuMNUixM5CJZXDyVg6XKomQYzu4BlXGT837wQQRuU+fjBGMu9jQDqYqyjINUBYNL0jNks8pyQrXRRuZ7Zbq2zj65DYMUaKDNca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mzEZ5Vs9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2165433e229so55771165ad.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374930; x=1738979730; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0INf1hRV37RA1+YvoWbzTJR4dkVI99fKTSGmyPC5dJU=;
        b=mzEZ5Vs97O31l/9kt1fkZuYauIIbpjCeKMbgYDDnqRfI7tAH+JqYZ7JiGKepum6kSi
         sMsAOjezG5AT61e8Sg8y7+ftKjTF9N/hO2BQ75xLpS48efhBTLhQkwkxAZMLFcchmTVo
         ouFvVRijd2AWPVIlEMouW+lTPLJNoVKec7+QduM6BMSgOY/8SXx+1SC+RHtBqguaNAK6
         AGTM07VsC/rThvxKV81U6zKgpmlzJUnIRPi+2244yPkt9VGKLBichYKOALxXe314sncB
         uz23Qfyz4miMcqqCCghzvIECRTgmtlkXasa46tNwY+J46+quTwNxPw+9hwKmOdRfLxCU
         gy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374930; x=1738979730;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0INf1hRV37RA1+YvoWbzTJR4dkVI99fKTSGmyPC5dJU=;
        b=VZaoB85vksfOPGYrn64nzIw2XAM2dNrJpKt+7h1uAEgM+kO0A/9rBk3NfLeOdJ8RcT
         RkNQZCasLpcvzLQpiqT+dLY9e5pGb6uzYQWsjUUTISRJQgqyjU3qQv1THOewVKdC0U3i
         QZ3CL9xHTcYze5NHyTpre8PH42TG6blfZxbGETCJi2J/KVkD2wCZXJjFPtASCnIlhp+s
         3z/PR5e+Sv7N399HSX26LWVbsCbImPJ/m4UHY838Xc36kbKW1StiAXecVwJ9h2v8xXG/
         pNlT4QhIEEMHjKsLEfstQDx6/tPWaWr/dWV+QImTHXK2vtyudwSRLHe/urkj5iwh4E2d
         bHNw==
X-Gm-Message-State: AOJu0YxG/sJvSFi+cz7A6VKfyH1Kab3dMyTEyc66eHM+d6tORXK9geb7
	TqBzntHBTUebyVmPMNePmNf2+SVbqLX/nEJ8OhHotrm1la2rEoMgsb+ND4Fn4qFbP8HjY1T3+nS
	PLg==
X-Google-Smtp-Source: AGHT+IGLVsvqFq/nTpkDat1Ox1psJO6hj3GlefNPyyLrelICESYBuGk1uv8jjM8KmSylaMLfqRUmiTgQ0Cw=
X-Received: from pjbov11.prod.google.com ([2002:a17:90b:258b:b0:2ef:7352:9e97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d582:b0:215:19ae:77bf
 with SMTP id d9443c01a7336-21dd7c66949mr218457115ad.19.1738374929971; Fri, 31
 Jan 2025 17:55:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:13 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-7-seanjc@google.com>
Subject: [PATCH v2 06/11] KVM: x86: Plumb the src/dst operand types through to .check_intercept()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When checking for intercept when emulating an instruction on behalf of L2,
forward the source and destination operand types to vendor code so that
VMX can synthesize the correct EXIT_QUALIFICATION for port I/O VM-Exits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c     | 2 ++
 arch/x86/kvm/kvm_emulate.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0915b5e8aa71..ca613796b5af 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -477,6 +477,8 @@ static int emulator_check_intercept(struct x86_emulate_ctxt *ctxt,
 		.dst_val    = ctxt->dst.val64,
 		.src_bytes  = ctxt->src.bytes,
 		.dst_bytes  = ctxt->dst.bytes,
+		.src_type   = ctxt->src.type,
+		.dst_type   = ctxt->dst.type,
 		.ad_bytes   = ctxt->ad_bytes,
 		.next_rip   = ctxt->_eip,
 	};
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 73072585e164..49ab8b060137 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -44,6 +44,8 @@ struct x86_instruction_info {
 	u64 dst_val;            /* value of destination operand         */
 	u8  src_bytes;          /* size of source operand               */
 	u8  dst_bytes;          /* size of destination operand          */
+	u8  src_type;		/* type of source operand		*/
+	u8  dst_type;		/* type of destination operand		*/
 	u8  ad_bytes;           /* size of src/dst address              */
 	u64 next_rip;           /* rip following the instruction        */
 };
-- 
2.48.1.362.g079036d154-goog


