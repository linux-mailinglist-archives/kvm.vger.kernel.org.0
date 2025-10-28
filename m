Return-Path: <kvm+bounces-61361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C61DCC1741D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B25F4F164D
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4E136A5F6;
	Tue, 28 Oct 2025 22:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rg5BM50R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882DD36A5E4
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692334; cv=none; b=b/SkdJIXAMVKC6qe9v+5b9BmlO4NfAtJONc2r9iG1UcK6WHP2vSUGwe3L/SbTAOBDUIU2c2gLgAJwKbPZO8uXPW1uE4BlFY932odEwemZ1hs6hil+iVdsdZc4/dbNkrjKV2rGpeyStgZPKopgWqZMHA/kSarEYnphKR9mMcYCYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692334; c=relaxed/simple;
	bh=NmfTEh2w90Vx1EUJhCoQ1DnPlLs96QxCb3TH8vg/crY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=fBmj/JSuTW7oIMyZ5KMhD1eT5PgWzENJt/YJNrzDkhprp/45eeCunspxtJWJrMhBwVudh5fMKnVUssWiyu+72XjBr0u0dj31V/G78RG05wGZgsQJTetwEvB/8YkZsK57Q7lENYiIVv991hihqz0NdK0K+pyTXWoy2SzCBKfkiKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rg5BM50R; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290c9724deeso58322975ad.2
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 15:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692332; x=1762297132; darn=vger.kernel.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bafyIACgjKK14wqI7+UpK/XBf9Tl8hwNLLXvm7vBUiQ=;
        b=rg5BM50RbDfzDUoax+0Rg/P1gDZJHGNwZo+CuD7g5t4F0GRiwLg66Hy4/obTCnfM/8
         p2i1WBzwE5OR1dfm9erzIPV4PNgQzq0Z9+/OYVJQDGnYZYCiLOfqArpB4iTke4edxBOi
         /GWhXs8sa5RITns1Pu4+qo+eUpC3LKSKKHlJnFigfjyOqW4oYELByesmYjOzfYLQwYMp
         D0YyQO//FfiiHS52u/zh+LmI8o1Dnjg+jqUGYRGgG3olOFyGc/ONGVPLm2/No/FAzdqK
         Zyuxrnp4/oxOQ7E4Qb1tQXUWFdyBVK57loc9EY/y01FOGGRAfWQ76UFE+Yuef6xEg2dJ
         Op1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692332; x=1762297132;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bafyIACgjKK14wqI7+UpK/XBf9Tl8hwNLLXvm7vBUiQ=;
        b=dMTkCHbB72wXC9BguU/floVK78yJXFAN8lXCVR1mNjfTxU14K6Bn2d0Ac3O1kGTjuv
         OGIQfpoVv8Wf3LuHqLCQ1eMdbsBBWbbzKMLExD85zABsXvUmdQgSbCFI61IM7r0wYUwE
         eqH8VWOZsdLxrC4wRHYMd/BIR/khnXSiDybn4lmf7kQY3Km3r+5xx8SCadKWN4ZADWx5
         eZRTY9g9IOIQO5GZ8lIM0pr02vFTF8lYvL1rQ+8NTRCwTJgWNtJJ4/9WmpzE66WR+rOw
         RYXNzE8EV9n/c7snPHFeKS/Bgw95KlqEtcXnkw0OH3jgFkA7PC7HRehRLDAHRrABi+Cf
         ztMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxyF9JgmyDPaYMbtOLssbMYd7K6WTbiYQjQrp3m6ket0NJ+fZo03l8KK57rcLHqaP+Z2k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/fyzBqJ8cjZ4z8Viqt67GoiL4EHZ786P8TmEgJ+hSoT9nbi/A
	BzpjHGGkj2JhpackGkr0I4hl6M6jtDk2Flw53nfCzAc8B0lbs+s9qMJlR21bPh6mpAJ58frnVmm
	3/ANwVI6J9/QusA==
X-Google-Smtp-Source: AGHT+IHKY2pClvohg4IWDjCOvNKT01DkzF2lTStYT3sIYIsj1O8Psfszn4vksBsANMyqzlJojr3dGZ1p5DLaig==
X-Received: from pjbgq17.prod.google.com ([2002:a17:90b:1051:b0:33d:acf4:5aac])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e847:b0:293:e5f:85d7 with SMTP id d9443c01a7336-294def69091mr8641645ad.55.1761692331928;
 Tue, 28 Oct 2025 15:58:51 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-1-jmattson@google.com>
Subject: [PATCH v2 0/4] KVM: selftests: Test SET_NESTED_STATE with 48-bit L2
 on 57-bit L1
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Jim Mattson <jmattson@google.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Prior to commit 9245fd6b8531 ("KVM: x86: model canonical checks more
precisely"), KVM_SET_NESTED_STATE would fail if the state was captured
with L2 active, L1 had CR4.LA57 set, L2 did not, and the
VMCS12.HOST_GSBASE (or other host-state field checked for canonicality)
had an address greater than 48 bits wide.

Add a regression test that reproduces the KVM_SET_NESTED_STATE failure
conditions. To do so, the first three patches add support for 5-level
paging in the selftest L1 VM.

v1 -> v2
  Ended the page walking loops before visiting 4K mappings [Yosry]
  Changed VM_MODE_PXXV48_4K into VM_MODE_PXXVYY_4K;
    use 5-level paging when possible                       [Sean] 
  Removed the check for non-NULL vmx_pages in guest_code() [Yosry]

Jim Mattson (4):
  KVM: selftests: Use a loop to create guest page tables
  KVM: selftests: Use a loop to walk guest page tables
  KVM: selftests: Change VM_MODE_PXXV48_4K to VM_MODE_PXXVYY_4K
  KVM: selftests: Add a VMX test for LA57 nested state

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/include/x86/processor.h     |   2 +-
 .../selftests/kvm/lib/arm64/processor.c       |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  30 ++--
 .../testing/selftests/kvm/lib/x86/processor.c |  80 +++++------
 tools/testing/selftests/kvm/lib/x86/vmx.c     |   6 +-
 .../kvm/x86/vmx_la57_nested_state_test.c      | 134 ++++++++++++++++++
 8 files changed, 197 insertions(+), 62 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c

-- 
2.51.1.851.g4ebd6896fd-goog


