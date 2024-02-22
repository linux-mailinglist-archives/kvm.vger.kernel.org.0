Return-Path: <kvm+bounces-9432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53B7986023A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 852CF1C26C4B
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6EC26E61F;
	Thu, 22 Feb 2024 19:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufJbKBJn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDB548E9
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 19:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708628792; cv=none; b=fiIgQC8VHaUR86kJtRoZ068OKzgsQIc1dKA/D2dSTEifBbLOmrzMNXaPRYCE+VLPim64zyD2Qf1RrHLtthLCk7exfcGqT6Lbu8FOFZsmvRlVAGWZ9r2BQExuFWmq/jkGpy/o2nr+uR09Sj8Oax5gS4kZqmy8hz4qJPFf7+QlYAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708628792; c=relaxed/simple;
	bh=odNY7brJIrKGXbB0NYiJ5L+h7CgQvY8SV9Jl9b0OOjY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aNIw52BSAyadQ0yS8yeseU94imvQdi4EsI9sMs8l0Oaew7SNincMr6kYEqI2YnU3ZHtaNnFW0T2pW4ar5Q8d9v12gIhXwjMH4uR3EIf5ygl9xlweKb3JeA0LbXVzQbwrvPAcocGKNDDgi2XDoZsbUrv93uLpk7labJpp0qr2V1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ufJbKBJn; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-602dae507caso1556107b3.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 11:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708628774; x=1709233574; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gezQaNgBY+02TfMTErrgdnbl2WvP4PLw6JtipxuzYjc=;
        b=ufJbKBJnbvcFgF3ydOn4HVlVCiRAGRQLPZ1ntzxGiIdTx9OzKstSArZB7f3NhS2/nE
         SMXznTzQnjaRpGvNnbAhsaMLxlHzkfNBARGlSkOaN9qjTFvVg+z53Cxw0fOtdwEArdmJ
         bG8iqxpErPjfZel2FupNvpPeQGp5WxOZHs3j0v5WyrvqBI1wxNOZ0KRTbScG/1dym85d
         H7t3r4nSz6F7wFm7kNm3MQhzKSrhS3HcKMa3hGM4UoM8uSh4r3y0bcvryl2oHhq6tNN9
         nnwEtgFJnM44/L4U1aw16gS5XHRKGuX3w/SiKxAhaatDKT0xFPqiNS5HEY0LN80+IKbu
         Vx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708628774; x=1709233574;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gezQaNgBY+02TfMTErrgdnbl2WvP4PLw6JtipxuzYjc=;
        b=UYB9lsZpcox2iBzu9pBJAT5nHRNIr9d5pDjfGCnxf1AFP802m4EU/vDFZ0kPZCQ0Cu
         8/PFz0+moK9Y9CA2Bhwpr0+kWBvDheldMMV6UTnkVtgfVE6NG+HLpbq/UAsNZe5ia0jS
         kj1XSc+5txDe4QZcgdwBOTlG9oY5wFol2ENrgjEFxpG6CaIx2pfgGk7CASCrCLxZQ6Cm
         1RscpefGFxY8Tf6U5mV9WOSiZzVJdDoIIUzfDcEoxHJ8M76a9bRDZ6JZQbcal3xvdu6z
         +4HRzwAcVbgCJurpnn7MHJxnLHJEGUNKYZZJIyse7J7bkg9/plFcAQJal5EbIJqzZT0s
         3KZA==
X-Gm-Message-State: AOJu0YwNDQDLw7l8oz4pfMyvZhsAK/NM29JVx3vE/vYbgqd6Vb8G1qF8
	bcrakxRif1Rc47meQHC7CQHRwI7fC84uAh/MDPcIvWAdcXmktN33bDzmnnoHAjVm2WT7RwyKsuQ
	mpg==
X-Google-Smtp-Source: AGHT+IGCEmm+bR6WbX74vZG4JukfcdEsqNN2Vrq+SSgVOGsL202tIGvg4gu4PSMs3fYUVbQ0dpd+lDjh9PA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:eb44:0:b0:608:4e77:9397 with SMTP id
 u65-20020a0deb44000000b006084e779397mr10627ywe.2.1708628774709; Thu, 22 Feb
 2024 11:06:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 11:06:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240222190612.2942589-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: GUEST_MEMFD fixes/restrictions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Fuad Tabba <tabba@google.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

A few minor-ish fixes related to GUEST_MEMFD that I am hoping to squeeze
into 6.8 as the they affect KVM's ABI (especially patch 1).

Sean Christopherson (5):
  KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY
  KVM: x86: Update KVM_SW_PROTECTED_VM docs to make it clear they're a
    WIP
  KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
  KVM: selftests: Create GUEST_MEMFD for relevant invalid flags
    testcases
  KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are
    exclusive

 Documentation/virt/kvm/api.rst                       |  5 +++++
 arch/x86/kvm/Kconfig                                 |  7 ++++---
 arch/x86/kvm/x86.c                                   |  2 +-
 tools/testing/selftests/kvm/set_memory_region_test.c | 12 +++++++++++-
 virt/kvm/kvm_main.c                                  |  8 +++++++-
 5 files changed, 28 insertions(+), 6 deletions(-)


base-commit: 21dbc438dde69ff630b3264c54b94923ee9fcdcf
-- 
2.44.0.rc0.258.g7320e95886-goog


