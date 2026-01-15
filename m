Return-Path: <kvm+bounces-68266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 078EAD293A1
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D985A30640C4
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30C032ED5C;
	Thu, 15 Jan 2026 23:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fNTD8VKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8419289E06
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768519333; cv=none; b=C+nI9M/5Vc/Q0cRTrRc7pwPeS2/UIqPOge6xxc2oad/UxANPWAWsNeHricmwWxRSh0EMZPtAXW2CWr2ZurOX4k3cLIP42mNVJXVWI5lKD2JwHgwrBt4CnwxFPgbYvrdY+j9nrzzP4prZkOHuX3+UxW6mfeKlEM0PDIiciFVOtw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768519333; c=relaxed/simple;
	bh=W1qB9LQBXMeUfzf2Pv2RG2HRtCPQdMLMtOyLJeq5ur4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=bZJZUVAjH7xMwRD8RVy0tMnNPbcCgUxXbhwr0Vf8erpz4nYDZxsSS3sDmw2H76f7X3ukzvQn87h2evtWSkp4+cxXqY7JhIhlXAwxyqlZwKcgpyrKJDriD4ss/LCMFUpayu1sw2fP8eWZdJVm2hV392ezMiwihdAZ53H4DtHmG2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fNTD8VKb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81dd077ca65so1082173b3a.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 15:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768519332; x=1769124132; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mUjBGLWGHTwZbLi39rVIOBV5qrsnmjBUvPK620tiSyQ=;
        b=fNTD8VKbIGkRp+mYxwEb2w5N1bSrDGeENKTvJXE/OOEZsKIKzQ1DfLKvyLlQ6H6Y5n
         yG2RV8YLQgdxZXFoisMxzgbPKkOXj/sptYJrxiqdsGdzYm+OB1ChXUD/NiJZoun/bUhk
         ibiDieqMJZvwXyQR+NUNxHFg5CqRgfjOUJsfGCsrxzm5CY8olarab7YzNd68cuRO9PKv
         zKQSXkhQfoCuepGzwJjBlIEmNuRNuiOzx42hAcRkuJV1FNmXwp49MYcfn4KHH4NB2oCb
         yFlDtnAp5MFg7vCMKDcwHf6iAVq9v8yFg2lRSroGiQkbYjjLRjYZqe+gAoC9MUlYPDRY
         7ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768519332; x=1769124132;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUjBGLWGHTwZbLi39rVIOBV5qrsnmjBUvPK620tiSyQ=;
        b=CjCbP91Kzf7bWQS/ATL2Af3s08feNDg3GKBxjE3uqsiTOmjnrKE9py2erAjC+XLs3s
         RFNpOtx+rirpxCgcto8HmDTsejZYnT0RBCyldlNHad4qsK/S6e+osfBM0BbI0h1Wwg5f
         IKUO2C1XGBYI00fJuejgVgxR6Da8pRe7kczTmWWpGsMgotYfAKjmpJsCFPVGM1rZhy9h
         41caMJu8dcFJuwHUQyOmKuZ++RmQPr8/xe8ukPmbjyTvvmZHFz3jQkFuhDqzgNWx9otl
         SRPLCFOUTqdQs8nilZRDH41KhyLpwy6t4ewDC1zCypW4e/c7NYaPvj7nlW8wR2WXlueO
         Cpmw==
X-Forwarded-Encrypted: i=1; AJvYcCUvrWpHqnEdxvhqUte2BdFGEZPaj0F0paZgimuCwwJQLhfSiTCisa7o52su6+iZKJfgJVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbT6eCDBqKgYJvp9TieCh4vHVQGh/CTME14hXR/+1HuNqneKiY
	27dZsMABFZCdu5eFv/5UHAeifxUOtzI+Sd5ylMLvaecg7Zq5MsEC93/7FcshL5NxAf1emxGB816
	v2MTEq66BJWuDLQ==
X-Received: from pfst41.prod.google.com ([2002:aa7:8fa9:0:b0:77e:32f7:68cd])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:f8f:b0:81f:473e:e8d8 with SMTP id d2e1a72fcca58-81fa182746emr657554b3a.36.1768519331975;
 Thu, 15 Jan 2026 15:22:11 -0800 (PST)
Date: Thu, 15 Jan 2026 15:21:39 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115232154.3021475-1-jmattson@google.com>
Subject: [PATCH v2 0/8] KVM: x86: nSVM: Improve PAT virtualization
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, KVM's implementation of nested SVM treats the PAT MSR the same
way whether or not nested NPT is enabled: L1 and L2 share a single
PAT. However, the APM specifies that when nested NPT is enabled, the host
(L1) and the guest (L2) should have independent PATs: hPAT for L1 and gPAT
for L2. This patch series implements the architectural specification in
KVM.

The existing PAT MSR (vcpu->arch.pat) is used for hPAT, and the
vmcb02.save.g_pat field is used for gPAT. With nested NPT enabled, guest
accesses to the IA32_PAT MSR are redirected to gPAT, which is stored in
vmcb02->save.g_pat. All other accesses, including userspace accesses via
KVM_{GET,SET}_MSRS, continue to reference hPAT.

The special handling of userspace accesses ensures save/restore forward
compatibility (i.e. resuming a new checkpoint on an older kernel). When an
old kernel restores a checkpoint from a new kernel, the gPAT will be lost,
and L2 will simply use L1's PAT, which is the behavior of the old kernel
anyway.

v1 -> v2:
  Adhere to the architectural specification
  Drop the preservation of vmcb01->g_pat across virtual SMM
  Store the gPAT rather than the hPAT in the nested state (save.g_pat)
  Fix forward compatibility
  Handle backward compatibility when MSRs are restored after nested state
  (setq-default fill-column 75) [Sean]
  Or the KVM_STATE_SVM_VALID_GPAT bit into flags [Sean]
  
Jim Mattson (8):
  KVM: x86: nSVM: Redirect IA32_PAT accesses to either hPAT or gPAT
  KVM: x86: nSVM: Cache g_pat in vmcb_save_area_cached
  KVM: x86: nSVM: Add validity check for vmcb12 g_pat
  KVM: x86: nSVM: Set vmcb02.g_pat correctly for nested NPT
  KVM: x86: nSVM: Save gPAT to vmcb12.g_pat on VMEXIT
  KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
  KVM: x86: nSVM: Handle restore of legacy nested state
  KVM: selftests: nSVM: Add svm_nested_pat test

 arch/x86/include/uapi/asm/kvm.h               |   3 +
 arch/x86/kvm/svm/nested.c                     |  49 ++-
 arch/x86/kvm/svm/svm.c                        |  39 +-
 arch/x86/kvm/svm/svm.h                        |   7 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_pat_test.c   | 357 ++++++++++++++++++
 6 files changed, 442 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_pat_test.c


base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.52.0.457.g6b5491de43-goog


