Return-Path: <kvm+bounces-47599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3115AAC2793
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD6FD3AEAAF
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035C5298C2B;
	Fri, 23 May 2025 16:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJl6um9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18102980DE
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748017517; cv=none; b=J4mPY1mFsX/6TyoYWIqkyiZBKfFNz/Wq9uRED+HBtYMww8FXLj6wJSrawo3ZDucKaCIG4eQs5cYAOP9rIKYyt9PkUeSxijHFPkIYOQGqrPdTpX5cQTGsxJBVL/VLGtC2Fv+XLv6Rf61c0bvnEsnMA8bOuLo+butwFy1mBO8C1e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748017517; c=relaxed/simple;
	bh=V401EgHVE78JUYmYU948oRUbRI9ZKADht4kST8jBJXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BQtUgWOQlvxqhEhYsrAXJw9nN3/7mKSziD8HRv87QtWho7YTFNNnFmPwto/OIcW7WLgMWylkLVNx79APAStBSgZt/zs8sJdncRuGL3XE2KZ+OZ8Iqu6Rat992RBflxcHngl/WcaWDsgTyrkiyJ6ECwYO9/SWyYHpLRG0HYDVx4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJl6um9Y; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26f30486f0so18470a12.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748017515; x=1748622315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fp5iNCuCvsDrxTMi6sCpDlvK9G322dljoTXNpRNareg=;
        b=UJl6um9Y5qDIc3+6ipGqPAXKUoH7egecNWxGNjs2/k34YXJoZ/52We/8XRvreE+9zW
         M+T3uHtcFKcFUmzQyT2QtcIlrpnVxzs8WKiDJw5arZ0dG7ZUltagWrI26iZ9YOM12rTs
         94cizvo3XdghGhfjFMctHBOHijss/glzSp0qvXcbkkvGCh2OhMTycfGf8xDX+nNkgrH4
         1swngHH6yJ7oTh4EZA8Yn7J0ujdAIpPL/VpQ3sZQkMtJFU+LCO95V4753LiF7O1Mt+wx
         MoutczI/5YXXyCknG2tFJ3tJz3yIhst63k6TuUM8og5bt3NLwVvXYxLzQh9mqAu6+c78
         bqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748017515; x=1748622315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fp5iNCuCvsDrxTMi6sCpDlvK9G322dljoTXNpRNareg=;
        b=GAvXrSMYxG01R6yBLRxgT3/i3+toZZirQHPZsQDGTLFUzjWWSeKU58zyXYQd56awU4
         l+SCBdNy2ynaDpYYfEnhIWLIQFtOMJtG4EgTlJ+vHpmrFXxbWLdr/Tr6HJqeMp92WANl
         wXxwayBhxEqEJ5QzxGbzXXtIL+ZhiqYqxRmPqLpQlfn3tvhKf22GNVBuwN5AzRSiAqYM
         yNLZrc7APGEMpkEb+1gF82tE4w2RDA2pqKoKJmFTTwC/tnH3l6a2ZIsRqaOWF3MFs3+k
         YiXhuxZYx+TGz5zCTszfMXaKUUiHnwPade8Ma2YDe3T30fBOkyMu+RNkXxlcHXKH29hH
         k+Dw==
X-Gm-Message-State: AOJu0Yzv0bnNGqwUxNKGbaWQBdWSKER//RXRbbEALTL5H/EDJlxJwcoB
	Yfjmy5hdQBX4zEkVopVSMkinE5iujqAaXVtx9SC0gfh3ij65IqqQfYrOyoy+2EZ8mGnDKdnx5fT
	0gSjT3g==
X-Google-Smtp-Source: AGHT+IHdDr07A7qyjR+jCdfmBGyg58wYOy0S5EE7ElsmvZQs+jFmS79API67vRpUyXcIngY3yRb6Bdoa6xw=
X-Received: from pjbsu5.prod.google.com ([2002:a17:90b:5345:b0:30a:4874:5389])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d888:b0:30e:823f:ef3c
 with SMTP id 98e67ed59e1d1-30e823ff09dmr48347056a91.25.1748017515105; Fri, 23
 May 2025 09:25:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 May 2025 09:25:02 -0700
In-Reply-To: <20250523162504.3281680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523162504.3281680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523162504.3281680-6-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: SVM changes for 6.16
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A variety of SEV changes, and support for BUS_LOCK_EXIT (Bus Lock Threshold).

The following changes since commit 45eb29140e68ffe8e93a5471006858a018480a45:

  Merge branch 'kvm-fixes-6.15-rc4' into HEAD (2025-04-24 13:39:34 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.16

for you to fetch changes up to 72df72e1c6ddfb6e0c2bce174d5879bc095540c8:

  KVM: selftests: Add test to verify KVM_CAP_X86_BUS_LOCK_EXIT (2025-05-19 11:05:19 -0700)

----------------------------------------------------------------
KVM SVM changes for 6.16:

 - Wait for target vCPU to acknowledge KVM_REQ_UPDATE_PROTECTED_GUEST_STATE to
   fix a race between AP destroy and VMRUN.

 - Decrypt and dump the VMSA in dump_vmcb() if debugging enabled for the VM.

 - Add support for ALLOWED_SEV_FEATURES.

 - Add #VMGEXIT to the set of handlers special cased for CONFIG_RETPOLINE=y.

 - Treat DEBUGCTL[5:2] as reserved to pave the way for virtualizing features
   that utilize those bits.

 - Don't account temporary allocations in sev_send_update_data().

 - Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM, via Bus Lock Threshold.

----------------------------------------------------------------
Kim Phillips (1):
      KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB Field

Kishon Vijay Abraham I (1):
      x86/cpufeatures: Add "Allowed SEV Features" Feature

Manali Shukla (3):
      KVM: x86: Make kvm_pio_request.linear_rip a common field for user exits
      x86/cpufeatures: Add CPUID feature bit for the Bus Lock Threshold
      KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs

Nikunj A Dadhania (2):
      KVM: SVM: Add architectural definitions/assets for Bus Lock Threshold
      KVM: selftests: Add test to verify KVM_CAP_X86_BUS_LOCK_EXIT

Peng Hao (2):
      KVM: SVM: avoid frequency indirect calls
      x86/sev: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables

Sean Christopherson (1):
      KVM: SVM: Treat DEBUGCTL[5:2] as reserved

Tom Lendacky (6):
      KVM: SVM: Fix SNP AP destroy race with VMRUN
      KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled
      KVM: SVM: Dump guest register state in dump_vmcb()
      KVM: SVM: Add the type of VM for which the VMCB/VMSA is being dumped
      KVM: SVM: Include the vCPU ID when dumping a VMCB
      KVM: SVM: Add a mutex to dump_vmcb() to prevent concurrent output

 Documentation/virt/kvm/api.rst                     |   5 +
 arch/x86/include/asm/cpufeatures.h                 |   2 +
 arch/x86/include/asm/kvm_host.h                    |   5 +-
 arch/x86/include/asm/svm.h                         |  10 +-
 arch/x86/include/uapi/asm/svm.h                    |   2 +
 arch/x86/kvm/svm/nested.c                          |  34 ++++++
 arch/x86/kvm/svm/sev.c                             | 113 ++++++++++++++++-
 arch/x86/kvm/svm/svm.c                             | 135 +++++++++++++++++++--
 arch/x86/kvm/svm/svm.h                             |  12 ++
 arch/x86/kvm/x86.c                                 |   8 +-
 include/linux/kvm_host.h                           |  19 ++-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/x86/kvm_buslock_test.c | 135 +++++++++++++++++++++
 virt/kvm/kvm_main.c                                |  19 ++-
 14 files changed, 469 insertions(+), 31 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/kvm_buslock_test.c

