Return-Path: <kvm+bounces-15692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD638AF4AC
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43B381C22B45
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D9113DDDE;
	Tue, 23 Apr 2024 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XgZ44Gix"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F05E13DB96
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 16:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713891216; cv=none; b=tyqZMpVppTrGgbApgnadxTTGvC0cihjv+9AtcxVrZnvE63Hd0emHvWiAyqN2oAcHRBxRxWEWdzMBZDZfQmFaxK5On5LsQp22GwgEM31uhviXtoLWJ+SDB5Y6PQ58QcyJVnZ255VPBzSHKtMOh0qX+CX/mWp8nDPzLaMjyFjbImk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713891216; c=relaxed/simple;
	bh=ub/c4lMzNuQE/ASob0hO2P7pr3tW5fJO73ybbxmtQhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lkuQMXuS8pPoH308bIg5Hiwy0SF75+M1bazns1uSc9DmkE0OqZOJ+iz6kE+YFEe/nMBqZPc7lScNpFZwwtwbxVv1a/QQVd8gnGvFfDTCG7J+kn7XFv75818JiDIdXmGY/OyE6h4/f0cKPGPAZ5fisFka85nvGIvjrRCDilCyvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XgZ44Gix; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6ed0e1f8faeso22740b3a.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 09:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713891214; x=1714496014; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vs27nCM79m201+PPivEr2AY28j47w3WHEEMcLDKrspA=;
        b=XgZ44GixJQ56Rr1DZ8+JUONi1f4avXxmyBl2ogq4Me4fhOEAZxoCd+3MCGKyF/B26c
         dJ4Y1zPD17A5Tfpeyr5Beuk+DUmZFsmBunhpd4SOM2DPRsArfxlVd8NxxqXGZBYJdymT
         yolZhpjMscF0OYTyWidp6Goj/Jvmzl9V4xtupqPrKRy94IsX4DehR7wj8t7NxM4dM7fS
         2QIvN7h9Tm+baWyNRrNYHNiECgVvqC55mU7xocTTLC6DKzm8uNMOd9LtH1E3a4wwsOxV
         qDpRJqSdttdlNRUokduMT4td83RjlEPIRpaaFmDSBlqxNtMSfvxoKeMB1cKbkqS2mFZk
         Hc0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713891214; x=1714496014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vs27nCM79m201+PPivEr2AY28j47w3WHEEMcLDKrspA=;
        b=PuVJNDi1VVOe9KSjkA8GVhh1HHvdV+naGvmFiq+k1fTxKb6WWYtIuQ6e88a+s9iwiU
         LB/q7JziqSDrinwEHsrqk2y8YoO0uAMlyNqK6TcAMbXzTHG56xX7rCrhAbsxJWqKe2sr
         IQip0oTQ1TTulJ8nllHaKqJxloDC8n9hLAiZX7EkozXbkOLNPDypjYbHWpeBtw5SW6Bn
         iQdq6BkNmUV2n3wMnf+RB2YYWLqhof/+xudD1U8cT7hKiYSu4v1tuVoRyqg1hgbf8nFG
         Y+/Rt3AANvaLDMGPZVmywoPiMmyGXm8Wj8diswP8JJVoIRr9zfdKrUGWdFsZT6LJuYk5
         ONJA==
X-Gm-Message-State: AOJu0Yw/2hJoQ24QXAgo+I8vy3M95j7xEFHfbKOYdCrtlAiALHjhyxBn
	fJ1nkZ6agcdBoIy0Ubrp50BL3WgPxtI6JuVCQ7QX9gYm71ZquUguH5lC0vDCUmIByy/wnP1PnWg
	aUw==
X-Google-Smtp-Source: AGHT+IHHss4tWuFp3utLNINOqa+jKnoNwBJ+RlJYWs9fS6z+DNT3QK/uQRUw/WQrJokPWQezfnz2mAbl10I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4ba4:b0:6ea:e009:1815 with SMTP id
 kt4-20020a056a004ba400b006eae0091815mr33967pfb.3.1713891214344; Tue, 23 Apr
 2024 09:53:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 09:53:27 -0700
In-Reply-To: <20240423165328.2853870-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423165328.2853870-3-seanjc@google.com>
Subject: [PATCH 2/3] KVM: x86: Fully re-initialize supported_mce_cap on vendor
 module load
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Effectively reset supported_mce_cap on vendor module load to ensure that
capabilities aren't unintentionally preserved across module reload, e.g.
if kvm-intel.ko added a module param to control LMCE support, or if
someone somehow managed to load a vendor module that doesn't support LMCE
after loading and unloading kvm-intel.ko.

Practically speaking, this bug is a non-issue as kvm-intel.ko doesn't have
a module param for LMCE, and there is no system in the world that supports
both kvm-intel.ko and kvm-amd.ko.

Fixes: c45dcc71b794 ("KVM: VMX: enable guest access to LMCE related MSRs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a65a1012d878..44ce187bad89 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,9 +92,7 @@
 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
 
-struct kvm_caps kvm_caps __read_mostly = {
-	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
-};
+struct kvm_caps kvm_caps __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_caps);
 
 #define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
@@ -9776,6 +9774,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		goto out_free_percpu;
 
 	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
+	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
-- 
2.44.0.769.g3c40516874-goog


