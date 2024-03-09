Return-Path: <kvm+bounces-11420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC946876E61
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DF3EB216F0
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C19C184F;
	Sat,  9 Mar 2024 01:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwJhfx5Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7AAA34
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946576; cv=none; b=KTLq8ydYHz8vyXb1GuDlpiwSHgf9L1HB+N4T7Z4UKB6pOLFS2VPhNyND1e6qWZobVzb6b5Vkg1dVYdZtgOhj4DfNOPd3fIIfpotxW7pZHaCtbCh9Tw3bsUc7O6paMPz7dv93rV7jiUtFUDkVCaZLRX9LAa2o+W1nv9DD0H6ktK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946576; c=relaxed/simple;
	bh=o/dHrg4W/2Qu7LhXHcnBR4PyxF3Ttwy46Ocol2kgU+w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZmARX1M1MamcKVUtTNvVuInvM4tKdhG7N9npzvXGRm/G+gsEJrMITWFgR9YnGdo4YR6vSEbG4Z3BSD4yRIkIGOoKtiSrQhKgReg45JqHEjynJDT/vmzKVL4qozdk4A4HtA6EjMXmnE14nbbjeRA5V4V6ywNXys8etLuY0pGULdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwJhfx5Z; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso1096037a12.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709946574; x=1710551374; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DWrZ/Y6O9dtVdJ6fn791rDIK6aHa8oXbKQewTP1zRw=;
        b=qwJhfx5ZH2VDMhdp6veR4n8SnPSYw+A10yfBjPkKl8gnpu+uXtrxox1G+WcT2fJgCy
         HFeAg3GjlQS8uy+d/gF+tYLm8FPHlmYk+opRK5tRtHOV6XhuIJS6fMTJksw2pep1Kt0d
         7xa0wWuBq6Oux0DeaJHlc2j2QV2aLFgJGOAmlhLE3MEiKsfQecLy5xhQGr8kkPDQFapE
         Svo0rncoqbW5rzkLpPJEjenaiaZNT2bxuOySOK9CCvClJB1aI5QqccfENNpgcbLGgcuv
         iCXFVcSl9yDcL56Ak0SbXw7MQV3t4r93F63QIfHq7WqUvSYzOOwRQ6eRg02PnN3/quRv
         Tiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946574; x=1710551374;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DWrZ/Y6O9dtVdJ6fn791rDIK6aHa8oXbKQewTP1zRw=;
        b=NLjAtNsppMvH86Wl1JiDSulb1jG5pIPeAlFN7eYro/tIzzWWWhlH5j5h1cvE2K+UpW
         BDCPdNZEMjDmh8cyopXvkPeSvsDDZvCD4glt3lVv+DnTS9eoy8sL6GpGgYUH05BcI2Kb
         vpUtIiXzqBZ1So+1wBSlb7ocrjch+XElyJ/K2z09ClKxCbI/n/nc7XbIO7iOB/cJtVoc
         +RbEVFSyEFsW4c9j3yfVwCUkgaT3KDTbjFUahDgi3EWaW5P+tYW5H6zISWQZkbfFVDcT
         b0GSk8lS4JFSG6N7UsJW1CH273VPjdqUpa3KgUlEWmavm/+JzPSykTEEtFEc56555lbl
         jfDg==
X-Gm-Message-State: AOJu0YwlRZsY0ZfnyWjSKNQ0mLwnn3eM4xQBtA86RatudkUEKR2OaSlu
	49VQFQ6qpV0lFv7SI00azc7ye3EMXi6IER0g8XBDZ3fkmEaBewvu2O7QdihSb/D7LvIteGPusRa
	KEw==
X-Google-Smtp-Source: AGHT+IEj3pG5ofKXZEqws9DjqT4BkVYkLBXjhj3PglQMYC5OQznB5l3CPPuqHtoMiPRbHPynuQY+Asfi0aA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5347:0:b0:5d5:e46f:d39c with SMTP id
 t7-20020a635347000000b005d5e46fd39cmr1463pgl.12.1709946574438; Fri, 08 Mar
 2024 17:09:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:09:24 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309010929.1403984-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="UTF-8"

First, rip out KVM's support for virtualizing guest MTRRs on VMX.  The
code is costly to main, a drag on guest boot performance, imperfect, and
not required for functional correctness with modern guest kernels.  Many
details in patch 1's changelog.

With MTRR virtualization gone, always honor guest PAT on Intel CPUs that
support self-snoop, as such CPUs are guaranteed to maintain coherency
even if the guest is aliasing memtypes, e.g. if the host is using WB but
the guest is using WC.  Honoring guest PAT is desirable for use cases
where the guest must use WC when accessing memory that is DMA'd from a
non-coherent device that does NOT bounce through VFIO, e.g. for mediated
virtual GPUs.

The SRCU patch adds an API that is effectively documentation for the
memory barrier in srcu_read_lock().  Intel CPUs with self-snoop require
a memory barrier after VM-Exit to ensure coherency, and KVM always does
a srcu_read_lock() before reading guest memory after VM-Exit.  Relying
on SRCU to provide the barrier allows KVM to avoid emitting a redundant
barrier of its own.

This series needs a _lot_ more testing; I arguably should have tagged it
RFC, but I'm feeling lucky.

Sean Christopherson (3):
  KVM: x86: Remove VMX support for virtualizing guest MTRR memtypes
  KVM: VMX: Drop support for forcing UC memory when guest CR0.CD=1
  KVM: VMX: Always honor guest PAT on CPUs that support self-snoop

Yan Zhao (2):
  srcu: Add an API for a memory barrier after SRCU read lock
  KVM: x86: Ensure a full memory barrier is emitted in the VM-Exit path

 Documentation/virt/kvm/api.rst        |   6 +-
 Documentation/virt/kvm/x86/errata.rst |  18 +
 arch/x86/include/asm/kvm_host.h       |  15 +-
 arch/x86/kvm/mmu.h                    |   7 +-
 arch/x86/kvm/mmu/mmu.c                |  35 +-
 arch/x86/kvm/mtrr.c                   | 644 ++------------------------
 arch/x86/kvm/vmx/vmx.c                |  40 +-
 arch/x86/kvm/x86.c                    |  24 +-
 arch/x86/kvm/x86.h                    |   4 -
 include/linux/srcu.h                  |  14 +
 10 files changed, 105 insertions(+), 702 deletions(-)


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.44.0.278.ge034bb2e1d-goog


