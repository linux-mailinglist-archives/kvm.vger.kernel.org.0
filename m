Return-Path: <kvm+bounces-9577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF8E861DEB
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:45:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92DC1F24B99
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD9414939B;
	Fri, 23 Feb 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NXcNC4yv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CF148FF7
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 20:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708720957; cv=none; b=fRzkp5U4vqfeeHNlmX2vAnvV0oRz4dvqbNfug03CnVAf1Mk/AblucvJMUdvXO4vhehag2F52voERZlv/+Ko+Ej37bexE5xfUJ3v1aDQAse2jcTqw0kudHASDBAIv4PpW/pnxQ/ZZ5re0nHXd/unM4ETvlj1xJseJ0SCxGNHevEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708720957; c=relaxed/simple;
	bh=03LEbyvlPP9ONJFI36nX6ThJGYS2WW2I5IdwOVy46dc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NEImd5pJDx+9YMc3GWpZoxtfMuwWqT1ggFI3Vv9M9/ztKn9IUQXdjw8QK33vlRZdZ+ZtD/HuoXi925K9dsw/KhOOyugEd3e6I7U+/LaMmfcK/9RkAD8L96wdVNh6dL3FGRUUAmi2M27G/hf8JCd5zwOnPkk811SRjs0zFbUIosk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NXcNC4yv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6047fed0132so18966097b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 12:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708720955; x=1709325755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShNOY58sLrgiK0CyMcd0tgKu75G8ItZGdxtrhL1QiTw=;
        b=NXcNC4yvBSojEOhdBPeqmOYyaLpS6LHPYdR9TXfiGZysYo/eC+UXBHBz5TIC/odLWO
         iDKtfF0OoWP+T5WhGkVkELigMfn+ObPpA6npomvxSUWqKpjEKfY44VWMwvyDBlMGExTu
         0JU11ednM1kBl7Dc0gwU9QhLAl40t3J7Rd+c7OzB7UvrZxFGNpASCQUH+YJNJ5mEwaHL
         DNf/N1S0JzcKf5xEETB7ThBlIdWP5wtSrHkJJr66lWcG5TuMdVvYdVrMho4/dyDSeZ7S
         ikwl6TygulnSN5rJAoLGSPZtaWclQxzarJ/RXo9bqULjfJAYnaH8waF8i15XUJJGUaC3
         vObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708720955; x=1709325755;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ShNOY58sLrgiK0CyMcd0tgKu75G8ItZGdxtrhL1QiTw=;
        b=samam3FVhOjr3hx76FNLLL6VkgZF4Wi7Ui6X0lYbzpUref1uYaukrKG0bPWS8O64KM
         fHQbIkPLi4+V5VJ/DA5APPqsVVso9MmOc3gnr36yoNMjTKyWu1vr9XTrlnxeNPgN4zQP
         S4p+jzr8BDB6q+vHjMx+vb6Z2Ae8ZfDkHjtfVN/gl0U6rNuzcNLWmC0cyDJysZDmenqF
         UjRlFq9tCb86sg8Usy//xn571VlNHDPJXqwiGxkheo6cCuW6AYwpm02iN/xt2eEBZXjZ
         /M0RM+dMzvi+Dsc6IMo/atvmVowBOckIWVHFZH+KukLKlWovU77zkeWGJjH3XPYun2RI
         +o1g==
X-Gm-Message-State: AOJu0YyHEFMUxL4BvwNXH7Xo/tDO+sYE9QOjKWlXWFEYfNm3vZAJtrQo
	9eHTJQbBjy1M7+jUW/lJGVJaIE+OV9L3M93sZKKB96zk6e41cA2ft7JLG0Dd5XgmpzgY76ZToFu
	nbQ==
X-Google-Smtp-Source: AGHT+IGLTkDREk76fxqLRWWwPxQvD2uw/rOzHnJxjZGQMqJNtQJt92M/64u6CKyUs8ejq/smEmVkfaw48NA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:6d8d:0:b0:608:801a:e66e with SMTP id
 i135-20020a816d8d000000b00608801ae66emr185636ywc.3.1708720955355; Fri, 23 Feb
 2024 12:42:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 12:42:25 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223204233.3337324-1-seanjc@google.com>
Subject: [PATCH 0/8] KVM: SVM: Clean up VMRUN=>#VMEXIT assembly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

Clean up SVM's enter/exit assembly code so that it can be compiled
without OBJECT_FILES_NON_STANDARD.  The "standard" __svm_vcpu_run() can't
be made 100% bulletproof, as RBP isn't restored on #VMEXIT, but that's
also the case for __vmx_vcpu_run(), and getting "close enough" is better
than not even trying.

As for SEV-ES, after yet another refresher on swap types, I realized KVM
can simply let the hardware restore registers after #VMEXIT, all that's
missing is storing the current values to the host save area (I learned the
hard way that they are swap Type B, *sigh*).  Unless I'm missing something,
this provides 100% accuracy when using stack frames for unwinding, and
requires less assembly (though probably not fewer code bytes; I didn't check).

In between, build the SEV-ES code iff CONFIG_KVM_AMD_SEV=y, and yank out
"support" for 32-bit kernels, which was unncessarily polluting the code.

I'm pretty sure I actually managed to test all of this, thanks to the SEV-ES
smoke selftests, and a bit of hacking to disable V_SPEC_CTRL, passthrough
SPEC_CTRL unconditionally, and have the selftests W/R SPEC_CTRL from its
guest.

Sean Christopherson (8):
  KVM: SVM: Create a stack frame in __svm_vcpu_run() for unwinding
  KVM: SVM: Wrap __svm_sev_es_vcpu_run() with #ifdef CONFIG_KVM_AMD_SEV
  KVM: SVM: Drop 32-bit "support" from __svm_sev_es_vcpu_run()
  KVM: SVM: Clobber RAX instead of RBX when discarding
    spec_ctrl_intercepted
  KVM: SVM: Save/restore non-volatile GPRs in SEV-ES VMRUN via host save
    area
  KVM: SVM: Save/restore args across SEV-ES VMRUN via host save area
  KVM: SVM: Create a stack frame in __svm_sev_es_vcpu_run()
  KVM: x86: Stop compiling vmenter.S with OBJECT_FILES_NON_STANDARD

 arch/x86/kvm/Makefile      |  4 --
 arch/x86/kvm/svm/svm.c     | 17 ++++---
 arch/x86/kvm/svm/svm.h     |  3 +-
 arch/x86/kvm/svm/vmenter.S | 97 +++++++++++++++++---------------------
 4 files changed, 56 insertions(+), 65 deletions(-)


base-commit: ec1e3d33557babed2c2c2c7da6e84293c2f56f58
-- 
2.44.0.rc0.258.g7320e95886-goog


