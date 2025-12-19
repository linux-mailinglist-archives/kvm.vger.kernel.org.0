Return-Path: <kvm+bounces-66338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C7036CCFFBE
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D835300AB20
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA36330665;
	Fri, 19 Dec 2025 13:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuUUFM6+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="skgG4IzW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C2121C160
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149899; cv=none; b=qTvhzqNtwjrS8LjPT1H+o7Y6JnlCosdfI5H4eMthghGiCwz5XaF1uU2Iq/bEUUdcJRqEk/ru3k0oOmSdEmgPmKN8Aeuq4XZA3LkC32jg91XGv2FJ8T8PxOZswmeZBWnnL58Zg5PX/9HiVYZeBb+iBwGboP2nm9Cd2+URNNWYxQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149899; c=relaxed/simple;
	bh=LbzkCTgQFUQt5ueNpO43HD8gVMSmbNhvdIww3jq57Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PrSjeOUngVFafWuodvipeOTeK5Fn50v011b4g5ysTOcv5eVLrIli9JYLCsttUz5momL41lFlIz/UDTUPkuA5AAK3AqDOt1w1NFYoGxHgidI5ywKJP/t76cKbd1TGHg7DluElW1YF+/L531N9jh2o+cDLxr/FFcNaqGhglWn6Vn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuUUFM6+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=skgG4IzW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766149896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jYg4C0Y+vy2EI0U5vnKJZRQma1mzxYrD3EEW4GyC+Tk=;
	b=NuUUFM6+OwlnSA0nNRX0vAHv8YXfOaoCz8DXjtqvje+MZ0r114yutplxUFhJEnJ2oB5Xjw
	0WJsXecknUaVw2JnngMcueSelJhzCNTE245vWz/EhRuOZG4s0BznreHpzN9NXq+XAilqDK
	GfprqIRTphdHuuqG1IvzVAK3dEdrMQ8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-K_H9ZSxaMY2xMkg1y_C9Mw-1; Fri, 19 Dec 2025 08:11:35 -0500
X-MC-Unique: K_H9ZSxaMY2xMkg1y_C9Mw-1
X-Mimecast-MFC-AGG-ID: K_H9ZSxaMY2xMkg1y_C9Mw_1766149894
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477771366cbso11263815e9.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 05:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766149894; x=1766754694; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jYg4C0Y+vy2EI0U5vnKJZRQma1mzxYrD3EEW4GyC+Tk=;
        b=skgG4IzWCviPIpVuwgZim0Zc8hQy8Jo0Jb9Yx4tCwSe0okdryUQGEnfGmzdJqsp3sH
         fFF8ktgdEU15pSeOGigFHI2SCRA0AJEgmTbFU5hTfLtPNpUaJtkzGMGIqaOnBnM29lG1
         NIWQX4mjjIA5PWX0LJMyir2Fb+7U3EEdPugzfa1sdB+9VFf7pBACTGVM5QQQ5aO+G6RL
         CKpEtifuaRk3n2hAF1WWWUaw+FymeX4CsbKzBNECpiBtDVovZDZe04AWBICx2JyvKGwj
         XKd8hqZiCPm0DvDQ1CJht3OzFKXW4xI7/Sva7i6+ORXrptyIoZ/PEQJrbHg+wxaZrCJa
         yaHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766149894; x=1766754694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYg4C0Y+vy2EI0U5vnKJZRQma1mzxYrD3EEW4GyC+Tk=;
        b=WbUpWRcSB/kS0HQUL5a9hlxoNAULqLIxjawKyKPrfK/eVYz8mjs+7HR4zPHsitFqcs
         sk4bL6jClS4RTNMuPFTtdm0I6qWwS5w2ZMd2mfvBnjYBgr/MvzqIaiwmiJ6GltdVAUWU
         EeiezWqeiLaBPEeYDWBqrMB0ymhTwVkJK5J9xfHerkMVSx4OCX3Zx3FnXry9RdhpNuPJ
         CqMR5LGocuCW+pvqNsT5r246yXSCUPu9RtW/kntMVtmXGsRHByJ7mir0BtkAZwiw453P
         iknJVmvJl673X97iO4oXPPKYCaWyo7SA06if7NhtcHPZ4FInkptVb7YMm13yMxH7SzXc
         y6Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUh531jJBmmf9o3llOxG8Jivfhb6fiKY1aQiXYN2WuvJy0fCg1R2hqPzvK4TNN5o+T07qg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7fHXX5N3tjd5W1otyP4GSu3ihhXEXI2+rI17XtiXhzpP4Pds8
	MM8KkXXbiVAzP+QZR3pea/vsEQsgpVlLihXZnkPxyIowWLZSqZgtk5aiUQFG28szlwRq9fpdWM2
	irxEH5+yIrEVZtw0gaP9fE/kvn0hSTQczUlhI/QFFOOmiPfU+4u0AzQ==
X-Gm-Gg: AY/fxX4pNjEu08NH3Xijp+WZJbpQTLNisx9QC4iy1nZp214YXlNrgAIIGyRgtWkhnLe
	tQmhbc7B9YLNg1jyzy2InXDOcVXwirNlAEsta3mztA6OoD2y19/HdOJC5E1xAUSHJGjnhxs+oI7
	UpIdBNTO+8toHLPEiS1I3bo3cQqhHiB5F39L387pW1ZJDKangpkwX8TWOZe6oDWD0JFbjU/0NJo
	pr2BeXmRott/plJc1ypqUe6RNbQ5en8oIctq8MVeMf6QNWlaJQA/TT5ChmXXGI+6m5VLCm6Lzx6
	yIdgkpPTTRc1Bx52agcXWvHjromo262wPnVzfqTEX6ypo97eYtVfszi7bDZLU+pdteXA3KD11Ba
	/E8+fnUM8P8aDi97C1dLMvDkRLnQR9MdPwtuTwJ4E7pFDcIXct7G1P82WH73bhaut2rnsr7ZFeQ
	dOJmd1OXR+pJ1rVfg=
X-Received: by 2002:a05:600c:154b:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-47d1958e7b9mr26077235e9.35.1766149893793;
        Fri, 19 Dec 2025 05:11:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6L7m2TIf/2nk8sCdKJ1nql5It4uOymAJknBlHpJb9rw5I2jvdfvVREAHIzNzgYT4SdvQGMQ==
X-Received: by 2002:a05:600c:154b:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-47d1958e7b9mr26076885e9.35.1766149893386;
        Fri, 19 Dec 2025 05:11:33 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193d5372sm46196555e9.14.2025.12.19.05.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 05:11:32 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.19-rc2
Date: Fri, 19 Dec 2025 14:11:31 +0100
Message-ID: <20251219131131.52272-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus,

The following changes since commit ea1013c1539270e372fc99854bc6e4d94eaeff66:

  Merge tag 'bpf-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2025-12-17 15:54:58 +1200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 0499add8efd72456514c6218c062911ccc922a99:

  Merge tag 'kvm-x86-fixes-6.19-rc1' of https://github.com/kvm-x86/linux into HEAD (2025-12-18 18:38:45 +0100)

----------------------------------------------------------------
x86 fixes.  Everyone else is already in holiday mood apparently.

- Add a missing "break" to fix param parsing in the rseq selftest.

- Apply runtime updates to the _current_ CPUID when userspace is setting
  CPUID, e.g. as part of vCPU hotplug, to fix a false positive and to avoid
  dropping the pending update.

- Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot, as it's not
  supported by KVM and leads to a use-after-free due to KVM failing to unbind
  the memslot from the previously-associated guest_memfd instance.

- Harden against similar KVM_MEM_GUEST_MEMFD goofs, and prepare for supporting
  flags-only changes on KVM_MEM_GUEST_MEMFD memlslots, e.g. for dirty logging.

- Set exit_code[63:32] to -1 (all 0xffs) when synthesizing a nested
  SVM_EXIT_ERR (a.k.a. VMEXIT_INVALID) #VMEXIT, as VMEXIT_INVALID is defined
  as -1ull (a 64-bit value).

- Update SVI when activating APICv to fix a bug where a post-activation EOI
  for an in-service IRQ would effective be lost due to SVI being stale.

- Immediately refresh APICv controls (if necessary) on a nested VM-Exit
  instead of deferring the update via KVM_REQ_APICV_UPDATE, as the request is
  effectively ignored because KVM thinks the vCPU already has the correct
  APICv settings.

----------------------------------------------------------------
Dongli Zhang (2):
      KVM: VMX: Update SVI during runtime APICv activation
      KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Exit

Gavin Shan (1):
      KVM: selftests: Add missing "break" in rseq_test's param parsing

Paolo Bonzini (1):
      Merge tag 'kvm-x86-fixes-6.19-rc1' of https://github.com/kvm-x86/linux into HEAD

Sean Christopherson (6):
      KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
      KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtime updates
      KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
      KVM: Harden and prepare for modifying existing guest_memfd memslots
      KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
      KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)

 arch/x86/kvm/cpuid.c                         | 11 +++++++++--
 arch/x86/kvm/svm/nested.c                    |  4 ++--
 arch/x86/kvm/svm/svm.c                       |  2 ++
 arch/x86/kvm/svm/svm.h                       |  7 ++++---
 arch/x86/kvm/vmx/nested.c                    |  3 ++-
 arch/x86/kvm/vmx/vmx.c                       |  9 ---------
 arch/x86/kvm/x86.c                           |  7 +++++++
 tools/testing/selftests/kvm/rseq_test.c      |  1 +
 tools/testing/selftests/kvm/x86/cpuid_test.c | 15 +++++++++++++++
 virt/kvm/kvm_main.c                          | 17 ++++++++++++++++-
 10 files changed, 58 insertions(+), 18 deletions(-)


