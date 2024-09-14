Return-Path: <kvm+bounces-26885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7EC978C60
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BFE3B248D4
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72DB40BF5;
	Sat, 14 Sep 2024 01:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pFc5eU9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064D1D551
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276443; cv=none; b=XGdgCA08ODe8F66ZznA9hSxXzOdbJ1s07vFMCvZWrLWDP5dYEO1H5POnGTiue+8Ii3AkCFUnULob4qyxOcJzed7zYagwJ79fnjy6VcJuaR65H3KrEHYtMEAu4VSAM5G4z0sR7xp7xXNiPhcGa8L6P9NHP0hemlZ1KqANAraol8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276443; c=relaxed/simple;
	bh=xppevfAptevbPbqwJcKDzvBsXUxo8t6URwOvrGr+ZLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqdw2Kw06PvnOhwJhRxr9EavMMJG/f3WPKFpiziF+NkTZHEIR+CetCMCgSoKlKqIylcU4WSBeIEfdj7siATbZAmmFNS34fELc5m98yWwVcIp/dVaKQ8MRQVN6TClbOQZdL051fIU5TTqzMiu/zs9CBIFDtuLGm2oqJHUeQabLYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pFc5eU9l; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7db493ff1b2so381749a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276441; x=1726881241; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xvgZPW09Nbm9lucb1cC9o89RtyC6+MnMH79yvO/ZkH8=;
        b=pFc5eU9lBvIYFpZSLZ1hBjEe+ImhfjmLdZVLD29ptgJ2aYkNU73B2EBjmDVu2a+E0O
         NyrN6ib9Ya1q0S+GV3+bWpn224zRaYwF5XYJBL0KMRXylyHg0Jl2v+iHE/P/bQ3wbPJI
         dP+brSXwAyKHgPSlXTgyiL9Bb0hUMMvMuYOXTFDr+/HHTMUH78JaRUtwHFzUcgLwyZBr
         HdaopKC1spqinjdM08gvgshZRh++7kBQhy+bq5d2XBaeUq5T3FRJ7m1OFwILeyxW9if7
         GAdovqaPbP5c8R6uNw16uM2sRM4uWk082DQxijRoMZThi4CBqwPag8xGaMVBgxbN7cTD
         ew7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276441; x=1726881241;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvgZPW09Nbm9lucb1cC9o89RtyC6+MnMH79yvO/ZkH8=;
        b=X8rPXVB6EMaQiaNsTXuNpaz0+E1Xek/s8VAPj7fhJr6migBX1Ibi5CTPcRvmILpTQe
         mSFbCmCKyHYfF2X5rxAmi+Kb9QpOWmlsxpOXQCbFwgkHKT1EW4UvZLJypl7Mxul33xTp
         P+Jxuz9MidLeshO/vGFQsyvqzvltWUlZhws04zplawAMyOywQdRsnSOefr4hZaQg/zP+
         ij2PhVnDe2+hrMv/rE/17yudDbZnocVhJ7SwC7A4x7QFi66Qz4MY1NujC9DOn1+Rzkgs
         PrxfMc5KLOnGZR/YZiuHKV6aDJisDHzYzb5ZjABB3k0ASBA91oR1mRIcbN/lKBax4P0M
         IUxg==
X-Gm-Message-State: AOJu0YwNkkgXqHQn3c3hOB3+dWzxZAtwNx/LTUJcoDhZuvn1xP75piau
	v8P8SYsDCwUaBKADmDNUnozIMJB6J3ZJ8nA3EKelkHWx4JEmhWqmnUluBr6q1RMsy8rPRWFvBpr
	kqw==
X-Google-Smtp-Source: AGHT+IGqhtyTzHA8ggkpcGPQZe82d4lJz0N00TofL2u4pqglGjOyN6tA6m9TlHbYiXhEZF/xylViCACsCvI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5c54:0:b0:7d8:449f:148d with SMTP id
 41be03b00d2f7-7db2f7a88f5mr8187a12.8.1726276440680; Fri, 13 Sep 2024 18:14:00
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:46 -0700
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-6-seanjc@google.com>
Subject: [GIT PULL] KVM: Selftests changes for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

As mentioned in the cover letter, the tools/testing/selftests/kvm/.gitignore
change will conflict with the s390 pull request.  Easiest solution should be to
just take my changes (they're a strict superset).

The other notable selftests related change isn't part of this pull request.  I
posted a mini-series to use the canonical $(ARCH) paths for KVM selftests
directories[*], e.g. arm64 instead of aarch64.  My plan is to send a v2 after
all the arch pull requests are merged and try to squeeze it into the back half
of the merge window (I kinda forgot about LPC and KVM Forum, but I'm crossing
my fingers here will be minimal conflicts).

[*] https://lore.kernel.org/all/20240826190116.145945-1-seanjc@google.com

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-6.12

for you to fetch changes up to c32e028057f144f15c06e2f09dfec49b14311910:

  KVM: selftests: Verify single-stepping a fastpath VM-Exit exits to userspace (2024-09-09 20:12:12 -0700)

----------------------------------------------------------------
KVM selftests changes for 6.12:

 - Fix a goof that caused some Hyper-V tests to be skipped when run on bare
   metal, i.e. NOT in a VM.

 - Add a regression test for KVM's handling of SHUTDOWN for an SEV-ES guest.

 - Explicitly include one-off assets in .gitignore.  Past Sean was completely
   wrong about not being able to detect missing .gitignore entries.

 - Verify userspace single-stepping works when KVM happens to handle a VM-Exit
   in its fastpath.

 - Misc cleanups

----------------------------------------------------------------
Peter Gonda (1):
      KVM: selftests: Add SEV-ES shutdown test

Sean Christopherson (4):
      KVM: selftests: Remove unused kvm_memcmp_hva_gva()
      KVM: selftests: Always unlink memory regions when deleting (VM free)
      KVM: selftests: Explicitly include committed one-off assets in .gitignore
      KVM: selftests: Verify single-stepping a fastpath VM-Exit exits to userspace

Vitaly Kuznetsov (2):
      KVM: selftests: Move Hyper-V specific functions out of processor.c
      KVM: selftests: Re-enable hyperv_evmcs/hyperv_svm_test on bare metal

 tools/testing/selftests/kvm/.gitignore             |  4 +
 tools/testing/selftests/kvm/include/kvm_util.h     |  2 -
 .../testing/selftests/kvm/include/x86_64/hyperv.h  | 18 +++++
 .../selftests/kvm/include/x86_64/processor.h       |  7 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 85 ++--------------------
 tools/testing/selftests/kvm/lib/x86_64/hyperv.c    | 67 +++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 61 ----------------
 tools/testing/selftests/kvm/x86_64/debug_regs.c    | 11 ++-
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |  2 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/sev_smoke_test.c  | 32 ++++++++
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |  1 +
 12 files changed, 141 insertions(+), 151 deletions(-)

