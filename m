Return-Path: <kvm+bounces-26887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A33978C64
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B41181C2264C
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011AB7E76D;
	Sat, 14 Sep 2024 01:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHbRyYqq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726F4AEF5
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276447; cv=none; b=C/8pbVCf42TE6dmlJnpIjnAhadli8GkAbW7XNevtr+/ZWmDT9pPl05oAjivKJSo5cZNkD/hIQlMmrJpjaP/Pkx2iDLxsiGJ/DLywHWyvsQ3oyN/oZNMK2uypOPG3oVL8iDlQORELGrysdOIWxc6+1/rY26vbdsDwkmWJCsyi9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276447; c=relaxed/simple;
	bh=ueTthrEQY4cNvAirvvTM1EwBWy+xGQEqZyqx9AKteTI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LSsIgFenhbaHep3qHfuCgJ0rQ9yT5XA9Oe6MLxAKJiIwmHJL0JgqIgHnQogfcvucjjpAq36QIqQkZo/DUm6mMp3AYPZOskh9LyXamVNKNQK1DOqRfwRcF2FwXllKNSLiECAIMRxCv3Za33tNkEvbcDwP3BJMTWgwSMUSd97FBBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHbRyYqq; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d50c3d0f1aso1235512a12.3
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276445; x=1726881245; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bua2CGp90GMqWxyby2eury6z0g1PZdHKdvB/SsXzYTk=;
        b=kHbRyYqqOkQBM2DmRsziLrd4A6/DtxZzBPpryu8uLJbbD/eVvxAJrAQEV91wlnGYCZ
         YOZwJqGP30LoboeUt90v59lUx6AAot6EoSfb6m5AAM8StLlGxpb3opxAabjMN7H2qJaQ
         qB3si5v+cFspqRzSY1oGz8mFegdf+Vc8kKhLiFxxt2IPXaP+bv61+zwbZBUPCRM3/6il
         uTMT3HsEyCeBvOIfXEbnTOLQ/M1/oBISRcQqYOl13RSjQLWHc+RLmHd0uMLjxq4Ym12/
         q3xHosPDJwUCOupdJxIYZI77eGTYN0rwk3JSUEbL9tqpwFIiYVxBCeTJxyEVhOmyDYqw
         kQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276445; x=1726881245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bua2CGp90GMqWxyby2eury6z0g1PZdHKdvB/SsXzYTk=;
        b=ODviGaVwRniaHwjswLkCzsVJuAen6asyBWba8qiLbLS1PqYS06XMNIn9dqFB+GSRgO
         QMZGlQ9j6j9eB6fQxP3tw1FTHID0kGm8JuewxrfAiWYjNJGEuqnVADq3a5fSl1TrgzF/
         fNGg1vIq1a2YqaPzyTZZDXja1npaFVgUEysa01TYtSfqqLWA98vswKhpfEC2R4UWOSTi
         NwHsOdS3NrQLMjQ4YuNtxPSPyzGBYgo9tpKIn8LGzcFOkM9xWjPADpk8KEIK5Uxs/0Wt
         v9c8wn+AlkklKtpY3oPs0+eGIlb9yzYGzWWSWmHRkGGMUUbPwhvGjzegYP01s3VgF4v3
         zm0A==
X-Gm-Message-State: AOJu0YxOwtKYCY7lofMd4QXu2g+yDV6Gr2aZEfXsYNLpx2deYHIouA/K
	06Zo8NmZC60rMNL3XJf8ukrfuHyp8oR/hoiCydxk6WgH4NxonfNH4wBUrV7o8WH/5NwMG/vLDvO
	pjQ==
X-Google-Smtp-Source: AGHT+IH1qTrcj2HMLhVi3ezfOjPimwI0P7CmQRAFQ43pU1GOSoiXdDDc8TSs3tVwUpDNu2HV+s0zQEbJQzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:f88:b0:7d5:e79:3a99 with SMTP id
 41be03b00d2f7-7db2f6f4a38mr9908a12.1.1726276444956; Fri, 13 Sep 2024 18:14:04
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:48 -0700
In-Reply-To: <20240914011348.2558415-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914011348.2558415-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The highlight is a fix for nested posted interrupts that shows up on CPUs with
IPI virtualization.  If KVM ends up handling an L1 virtual IRQ for L2's posted
interrupt notification vector, KVM will incorrectly synthesize a VM-Exit to L1
instead of processing pending posted interrupts.

I am very confident in the fix itself.  The refactorings to land the fix without
creating a TOCTOU bug on the other hand...  I did my best to test that I didn't
botch anything, but my first attempt went poorly, and as a result the changes
haven't been in -next for as long as I'd normally prefer.

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.12

for you to fetch changes up to f3009482512eb057e7161214a068c6bd7bae83a4:

  KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid (2024-09-09 20:33:22 -0700)

----------------------------------------------------------------
KVM VMX changes for 6.12:

 - Set FINAL/PAGE in the page fault error code for EPT Violations if and only
   if the GVA is valid.  If the GVA is NOT valid, there is no guest-side page
   table walk and so stuffing paging related metadata is nonsensical.

 - Fix a bug where KVM would incorrectly synthesize a nested VM-Exit instead of
   emulating posted interrupt delivery to L2.

 - Add a lockdep assertion to detect unsafe accesses of vmcs12 structures.

 - Harden eVMCS loading against an impossible NULL pointer deref (really truly
   should be impossible).

 - Minor SGX fix and a cleanup.

----------------------------------------------------------------
Kai Huang (2):
      KVM: VMX: Do not account for temporary memory allocation in ECREATE emulation
      KVM: VMX: Also clear SGX EDECCSSA in KVM CPU caps when SGX is disabled

Maxim Levitsky (1):
      KVM: nVMX: Use vmx_segment_cache_clear() instead of open coded equivalent

Qiang Liu (1):
      KVM: VMX: Modify the BUILD_BUG_ON_MSG of the 32-bit field in the vmcs_check16 function

Sean Christopherson (9):
      KVM: nVMX: Honor userspace MSR filter lists for nested VM-Enter/VM-Exit
      KVM: x86: Move "ack" phase of local APIC IRQ delivery to separate API
      KVM: nVMX: Get to-be-acknowledge IRQ for nested VM-Exit at injection site
      KVM: nVMX: Suppress external interrupt VM-Exit injection if there's no IRQ
      KVM: nVMX: Detect nested posted interrupt NV at nested VM-Exit injection
      KVM: x86: Fold kvm_get_apic_interrupt() into kvm_cpu_get_interrupt()
      KVM: nVMX: Explicitly invalidate posted_intr_nv if PI is disabled at VM-Enter
      KVM: nVMX: Assert that vcpu->mutex is held when accessing secondary VMCSes
      KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid

Vitaly Kuznetsov (1):
      KVM: VMX: hyper-v: Prevent impossible NULL pointer dereference in evmcs_load()

 Documentation/virt/kvm/api.rst  | 23 ++++++++++---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/irq.c              | 10 ++++--
 arch/x86/kvm/lapic.c            |  9 +++---
 arch/x86/kvm/lapic.h            |  2 +-
 arch/x86/kvm/vmx/nested.c       | 72 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.h       |  6 ++++
 arch/x86/kvm/vmx/sgx.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 17 ++++++----
 arch/x86/kvm/vmx/vmx.h          |  5 +++
 arch/x86/kvm/vmx/vmx_onhyperv.h |  8 +++++
 arch/x86/kvm/vmx/vmx_ops.h      |  2 +-
 arch/x86/kvm/x86.c              |  6 ++--
 13 files changed, 124 insertions(+), 41 deletions(-)

