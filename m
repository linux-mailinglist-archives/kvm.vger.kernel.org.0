Return-Path: <kvm+bounces-71729-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAivAJhOnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71729-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4F318E992
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 280E63063B58
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FEC25A357;
	Wed, 25 Feb 2026 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XuKtMXMQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329781D5ABA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982454; cv=none; b=FNlLt29Xzf+7tBzNjyVKBFPypK87Ep46gytAo4Rh5Sq+OTy8+8j386+cuOQZEY9AxxBxbPy8+d4bnzV5UYbY19ykXnKieGJnyS6N8dkDE/4HeNMlSUVzw64Ankn9yJZb+0wPa390gu10A3wiLelM/s9d5hKkCSqDQ+bOLj1Re2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982454; c=relaxed/simple;
	bh=rIfQEdmFShSU/hfE1nBXkImYGxL0rG4etafqHLncUjo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MINevDEP5nqV7M/h/05TUURR5eEW4MWaWjC3Jg14XKucn9toWmPCnpfWM6rcdwpv44y+9rHgqDDqkWhy9FcC0rA+Yi50Y/PQ3Nzo1PchD7G3bJe1ggcYFkBsena0ubBiDX7PGumFGQ7ix5OKY//yQToJFEqvnLmzZqBryR+njEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XuKtMXMQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fec175so252239655ad.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982451; x=1772587251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOLZOHpBY9NF13p+U0yWvHRv6RzqdAH2//7LWxAyLYY=;
        b=XuKtMXMQwuVDzVaWSYxnAXUr6jccZO2UaPmziJ6ViqqfGs4/P2dHtWCbgtGn4HKAyT
         lmccF9wDbyWY5ZQXlCLnQyBzncFufagqFaantTufcq2rljmOGDnb299Tv227WOjv7Bi7
         KhlQifaqKy23q/Nx9BJbk1IOpnu9sOkna1uTN7lFYdSpoVEAKoo9/XdTHDsA1S5FDnla
         A211k5SwS1lLv9RHUhAeOmZ6orxE5Q/hmf7KSSq0kIbHFl2nMG5vKVj9Gyykimi5etW9
         sKM/hVoKMNb4WN7PJKNaHUqe7QYuQyF7iIPnCCiBfAcwLixB98NBOlC/6ifXm7TZgVyf
         CPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982451; x=1772587251;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOLZOHpBY9NF13p+U0yWvHRv6RzqdAH2//7LWxAyLYY=;
        b=YNrW0svb9o6F37myGIws5yF7mT+Tiw44Z0Vq93JlYu+6sv2bspMG5yqI/9LEFCDVgJ
         9v5Ou11J7jgcwkWXCGJuhDAgwdkGYJAa3kQGDmRTmszj4RwDdTWnCVQPBO9+K+AEmNSr
         6Tu2FeUWGb/jiaS5csmGItXzdJqiBAQM7D3O+1nGYEN9MqQFWQYvhEvefWYxsRffHKyM
         wsEG0vK7tMfx1wUMojVjBiByxTjkGxLurWX/R3KefKPcSkxpuxedF6NFH7/xL1B94fj6
         FAcoFfaw0yKZzoADltExBbnZL8HCnTbIbnZFcobhsGur1M28afNCjyalaOHjCbMEB1vi
         owQw==
X-Gm-Message-State: AOJu0Yx0dS3GJvvSe6smHsZ5wxpiAfys5T75mQDS5XpaZQHU0S3o+dS9
	v53mCkrm3nSuotYpe+bj8kEXHEQTJ2Hvi4YvDEojrQFIxCAveafWG9arVr6BSN3+yTTi0t/+F2y
	3ECamEQ==
X-Received: from plct10.prod.google.com ([2002:a17:902:d28a:b0:2a9:8200:498b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2c7:b0:2a9:47d0:12cf
 with SMTP id d9443c01a7336-2ad743fbdf1mr128338145ad.4.1771982451342; Tue, 24
 Feb 2026 17:20:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 24 Feb 2026 17:20:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225012049.920665-1-seanjc@google.com>
Subject: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71729-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 5A4F318E992
X-Rspamd-Action: no action

Fix a UAF stack bug where KVM references a stack pointer around an exit to
userspace, and then clean up the related code to try to make it easier to
maintain (not necessarily "easy", but "easier").

The SEV-ES and TDX changes are compile-tested only.

Sean Christopherson (14):
  KVM: x86: Use scratch field in MMIO fragment to hold small write
    values
  KVM: x86: Open code handling of completed MMIO reads in
    emulator_read_write()
  KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
  KVM: x86: Use local MMIO fragment variable to clean up
    emulator_read_write()
  KVM: x86: Open code read vs. write userspace MMIO exits in
    emulator_read_write()
  KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
  KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
  KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
  KVM: x86: Consolidate SEV-ES MMIO emulation into a single public API
  KVM: x86: Bury emulator read/write ops in
    emulator_{read,write}_emulated()
  KVM: x86: Fold emulator_write_phys() into write_emulate()
  KVM: x86: Rename .read_write_emulate() to .read_write_guest()
  KVM: x86: Don't panic the kernel if completing userspace I/O / MMIO
    goes sideways
  KVM: x86: Add helpers to prepare kvm_run for userspace MMIO exit

 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/emulate.c          |  13 ++
 arch/x86/kvm/svm/sev.c          |  20 +--
 arch/x86/kvm/vmx/tdx.c          |  14 +-
 arch/x86/kvm/x86.c              | 287 ++++++++++++++------------------
 arch/x86/kvm/x86.h              |  30 +++-
 include/linux/kvm_host.h        |   3 +-
 7 files changed, 178 insertions(+), 192 deletions(-)


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.414.gf7e9f6c205-goog


