Return-Path: <kvm+bounces-21983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 766E6937E23
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FB211F21EAA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60ABA149019;
	Fri, 19 Jul 2024 23:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CWL7IC8l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392FC1487FF
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433071; cv=none; b=XyuxCOQsWPBY0wXxTkqrM8fO6IFbzfgrGN/sQOFJBl2IP35PbLLQ/XJysubCbHKDasl1TRKHiQlsuwnfQ5XRIe+sgXVgdslXgap8BODRMVZ9uElbg+QySioIflaAzj4aQlW1iVV/uYah39QuZoBBThxKLafN+SRYRE6qTLtYtI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433071; c=relaxed/simple;
	bh=FyX1Xgj3fNg/YrI6oeFtEibrbeQf4Z27fJwh2HZVlS8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IzSXMoJ2LgcOr7Ar50iTsBbu7jDm91biNj/d/a6BimMUgr3x4fmvqzCpgLMWyo1/fv/snL+FZSfBdwSVOZaomHrALNJtSyPeGuR1mdVbx33LnxynwIVvzgcq1KVSBfbv5pxdQUa7KEK4AJIJ7QjqoH6FdLjfLGnASJi32sfabj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CWL7IC8l; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-71cdcb122e8so2276441a12.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721433069; x=1722037869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQJLhJt+1v3X0AxqN/F0tmRwTbToicxjNz2Hd7wYOIk=;
        b=CWL7IC8leNkfbIAD1RVX2pm7RdUhaQAlfgnWVqtUhF7Mfi4mGK0dhHMijRsqt90YNT
         Jtz9rx+DLHbLaju1w23VM12uwqfPkpA/BbuL3aa8d9r65Dun4tzbrq3sftYNs3Ys9w+2
         OFhLNoGRHk2ze3Tt1LwVzFNH07bQvqcOafd8wPmTcnPDEqLY90B7iW8CT1aRaeYcmQ1e
         SQEUYkrRoGsJhtcE7idmY+jSycptCBikIupWFdM1blmgc1pCQpM9M5rbXqkEEPcz4oGk
         o6j6IGMmcowMosS96jnq0Sxw5PN0Wd2Pw03MC8LWTBtBZv9rnVMh+b3RFbvHmyH+uM6H
         YHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433069; x=1722037869;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nQJLhJt+1v3X0AxqN/F0tmRwTbToicxjNz2Hd7wYOIk=;
        b=cL5ps2T9eKFA7uTVSFutacLb0GOTc1SePebQrSnWHaUzzValW9QuuY+ZjaNCW6aWlb
         sXNdkIAM6KeYsNepylC7exJDduVfHLWabFly8zPzT2LLo2EalRhtDTchcK2DbqNVNe2q
         xAtgabTftnV3goe7grReQtDrH5KD/4Fdk9J5zyMgf+3v+ZY3/P/2WNH+MoyUYEWg6gHa
         CwuApwW90IsrU9UBPiBI72kWKJQ6m6BUMdcBTzrjtSCsCnWrwWSDRxgGCJjfnl8BSU1A
         /jRwoNp1HDXESDqnpRJbfGZxkiw1valMWMHcwjb2mk4QNyO93jfueGj+Q+VP9o6vePpm
         kz/Q==
X-Gm-Message-State: AOJu0YyxZF5eca7DenYGDz7w/KPlbDQvdqlfln9JAAYMBfgJGKyDbUHV
	Q2gp0Iy8xQJZXAL5GZLj+GKWUzRbD2H0j89+HyJg/UmKcL8Z+WjhB3mILuzRrvciDw+EEgewlix
	HXQ==
X-Google-Smtp-Source: AGHT+IHA4uFOX6R8gDEoOdxVxC3aj3ohqbTJdG43loopxhosAVlg2my7BLXNDlYk3WWyGS51f3CGp+OjeTc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:dc54:0:b0:719:8067:6bca with SMTP id
 41be03b00d2f7-79f9d72bcb9mr2878a12.1.1721433069304; Fri, 19 Jul 2024 16:51:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Jul 2024 16:50:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240719235107.3023592-1-seanjc@google.com>
Subject: [PATCH v2 00/10] KVM: x86: Fix ICR handling when x2AVIC is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"

I made the mistake of expanding my testing to run with and without AVIC
enabled, and to my surprise (wow, sarcasm), x2AVIC failed hard on the
xapic_state_test due to ICR issues.

AFAICT, the issue is that AMD splits the 64-bit ICR into the legacy ICR
and ICR2 fields when storing the ICR in the vAPIC (apparently "it's a
single 64-bit register" is open to intepretation).  Aside from causing
the selftest failure and potential live migration issues, botching the
format is quite bad, as KVM will mishandle incomplete virtualized IPIs,
e.g. generate IRQs to the wrong vCPU, drop IRQs, etc.

Patch 1 fixes are rather annoying wart where the xapic_state *deliberately*
skips reserved bit tests to work around a KVM bug.  *sigh*

I couldn't find anything definitive in the APM, my findings are based on
testing on Genoa.

v2: Actually send the whole series.

Sean Christopherson (10):
  KVM: x86: Enforce x2APIC's must-be-zero reserved ICR bits
  KVM: x86: Move x2APIC ICR helper above kvm_apic_write_nodecode()
  KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)
  KVM: selftests: Open code vcpu_run() equivalent in guest_printf test
  KVM: selftests: Report unhandled exceptions on x86 as regular guest
    asserts
  KVM: selftests: Add x86 helpers to play nice with x2APIC MSR #GPs
  KVM: selftests: Skip ICR.BUSY test in xapic_state_test if x2APIC is
    enabled
  KVM: selftests: Test x2APIC ICR reserved bits
  KVM: selftests: Verify the guest can read back the x2APIC ICR it wrote
  KVM: selftests: Play nice with AMD's AVIC errata

 arch/x86/include/asm/kvm_host.h               |  2 +
 arch/x86/kvm/lapic.c                          | 73 +++++++++++++------
 arch/x86/kvm/svm/svm.c                        |  2 +
 arch/x86/kvm/vmx/main.c                       |  2 +
 .../testing/selftests/kvm/guest_print_test.c  | 19 ++++-
 .../selftests/kvm/include/x86_64/apic.h       | 21 +++++-
 .../selftests/kvm/lib/x86_64/processor.c      |  8 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   | 54 +++++++++-----
 8 files changed, 135 insertions(+), 46 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.45.2.1089.g2a221341d9-goog


