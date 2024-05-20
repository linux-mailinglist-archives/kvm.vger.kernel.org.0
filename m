Return-Path: <kvm+bounces-17778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3BB8CA19F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 19:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90A441F22540
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 17:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE98B137C48;
	Mon, 20 May 2024 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfj/W0gA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FC513398E
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227974; cv=none; b=JfgUd2wj5C6N5E8k2UPvqNScfVFmu3/L+fDoOBrvRb9QkZfp+MFMNPWfHJIvFocorgpGTmt7ToPM75DwnUxpCpEYfe0+Bvkp/6p/aODxv+x1pKuf/XWht1+OM4dVzqid4LXzUJXT6/M+r6AA4D1bNerdUTY6z0C++0RVEvsPi1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227974; c=relaxed/simple;
	bh=AsxPKNARpXRNviMqudutLRYQTcU1bTFjcspQZ+x3v9s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=gNVXYJxmrbtRTv7FgIvCx/fni7m3no6jDtM9b6ap5exFWR0blfptnqnZ6OH98cF3vZGgvBW+P3IcCQmnwLc1ekLhsleAQYCHUUbtVmoVE/C41/qRrBkOU8VbD9S4hoYmUcSR1sPpvohqAqdfLB9tgP2+z0JoB2f52n6uNa5xdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfj/W0gA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dee601899c5so16734177276.3
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227971; x=1716832771; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/GnZMYTDY7gkoXtRjM5gJMHXnymrbwpWeITINywdKFo=;
        b=bfj/W0gAM4PMl01L70cob+Ssz5Y7vKslv/8fSyJdtXXvwLdgCcwUnGiGwiU7ma4Jwp
         YYvu7ABhLCXUxTO9ayzLA9szHsm/iCLHG2lrMnGSw5IVaTFwx8ecZr1trYgDxmYJl1IE
         8H1z+i5LjJIniteaUIab1RJjzFaot0W3cg9Jw3H7TxigMyWcfd1Tcit4vkl9EIqREnh4
         Hqjr+u1RMsnsTHaDz3FfCCiocHEzqQu8gK8ddmddmIn5rUYjOr3ZD+oa6OQJvG/3+wyi
         ghP+GCo9+Sb7S6RtJy8Zl9Q7P1POPvNkOST0fmGGLKGgCielzVnHZXy1Ht0hsr22E2sS
         qahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227971; x=1716832771;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GnZMYTDY7gkoXtRjM5gJMHXnymrbwpWeITINywdKFo=;
        b=X9L8dbu9EH8F30rrnbq2mMwNWm3lyT0fvQMUuLL2hLEwJDtnp0Dm8DDbd7YzLBKuy2
         5kxss8/V1/QstXHyGWCDEQBhwr4P9dYBHivnbOu6UOcu+286u2pRqjDDWG/8TJnjMOPy
         26EkJTrmmcyCWivBYnWt7Uz7OAfe7zZ8v5dKadw/MaWE9DAPVppYHsXJl1WfcYSaCX/q
         xgzE+kKC9kGnSBKMezPseSmfrLVfT4jf6pAvKi3Kn7kyRUY17tThFBz2CT7KphxHwoLf
         a7kX89td232TBqJ0O4d7iWw4JZeIXvGMLo2mh9xykjnvzsqkFMfQWLjvFEvXA1GD4ZW+
         vkJw==
X-Gm-Message-State: AOJu0YzJzIrZ4e40KQIk5LtfTR+qbnDz4Y/N3S9zyTJUOrLESy5Rx12B
	BHrwmz4SmsYoq5/SJa6tlPvgtHKDMqJFf4puTre651Ha3Bkx9ulN5Rflfq25GGyREntmuQh5d0k
	TlA==
X-Google-Smtp-Source: AGHT+IErAclYXPpBw712ginJqPQhQouGO1QEb7Y90m4CJpjie9HOnAm2zRjKLKULN5s7hIHJflLykiB4lW4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:dee:7621:19d9 with SMTP id
 3f1490d57ef6-dee76211f20mr6997989276.13.1716227971692; Mon, 20 May 2024
 10:59:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:15 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-1-seanjc@google.com>
Subject: [PATCH v7 00/10] x86/cpu: KVM: Clean up PAT and VMX macros
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

The primary goal of this series is to clean up the VMX MSR macros and their
usage in KVM.

The first half of the series touches memtype code that (obviously) impacts
areas well outside of KVM, in order to address several warts:

  (a) KVM is defining VMX specific macros for the architectural memtypes
  (b) the PAT and MTRR code define similar, yet different macros
  (c) that the PAT code not only has macros for the types (well, enums),
      it also has macros for encoding the entire PAT MSR that can be used
      by KVM.

The memtype changes aren't strictly required for the KVM-focused changes in
the second half of the series, but splitting this into two series would
generating a number of conflicts that would be cumbersome to resolve after
the fact.

I would like to take this through the KVM tree, as I don't expect the PAT/MTRR
code to see much change in the near future, and IIRC the original motiviation
of the VMX MSR cleanups was to prepare for KVM feature enabling (FRED maybe?).

Based on:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git queue

v7:
 - Collect reviews.
 - Fix an Author misattribution issue. [Xiaoyao]
 - Add vmx_basic_encode_vmcs_info() to avoid ending up with a mix of open-coded
   shift/masks and #defined shift/masks. [Xiaoyao]
 - Remove an "#undef PAT" that got left behind. [Kai]

v6:
 - https://lore.kernel.org/all/20240309012725.1409949-1-seanjc@google.com
 - Add all the PAT/memtype patches.
 - Split the VMX changes into more appropriately sized chunks.
 - Multiple minor modifications to make the macro mess more maintainable
   (and yes, I edited that sentence to use "modifications" specifically
   for alliteration purposes).

v5:
* https://lore.kernel.org/all/20240206182032.1596-1-xin3.li@intel.com
* Do not split VMX_BASIC bit definitions across multiple files (Kai
  Huang).
* Put some words to the changelog to justify changes around memory
  type macros (Kai Huang).
* Remove a leftover ';' (Kai Huang).

v4:
* Remove vmx_basic_vmcs_basic_cap() (Kai Huang).
* Add 2 macros VMX_BASIC_VMCS12_SIZE and VMX_BASIC_MEM_TYPE_WB to
  avoid keeping 2 their bit shift macros (Kai Huang).

v3:
* Simply save the full/raw value of MSR_IA32_VMX_BASIC in the global
  vmcs_config, and then use the helpers to extract info from it as
  needed (Sean Christopherson).
* Move all VMX_MISC related changes to the second patch (Kai Huang).
* Commonize memory type definitions used in the VMX files, as memory
  types are architectural.

v2:
* Don't add field shift macros unless it's really needed, extra layer
  of indirect makes it harder to read (Sean Christopherson).
* Add a static_assert() to ensure that VMX_BASIC_FEATURES_MASK doesn't
  overlap with VMX_BASIC_RESERVED_BITS (Sean Christopherson).
* read MSR_IA32_VMX_BASIC into an u64 rather than 2 u32 (Sean
  Christopherson).
* Add 2 new functions for extracting fields from VMX basic (Sean
  Christopherson).
* Drop the tools header update (Sean Christopherson).
* Move VMX basic field macros to arch/x86/include/asm/vmx.h.

Sean Christopherson (5):
  x86/cpu: KVM: Add common defines for architectural memory types (PAT,
    MTRRs, etc.)
  x86/cpu: KVM: Move macro to encode PAT value to common header
  KVM: x86: Stuff vCPU's PAT with default value at RESET, not creation
  KVM: nVMX: Add a helper to encode VMCS info in MSR_IA32_VMX_BASIC
  KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h

Xin Li (5):
  KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
  KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single 64-bit value
  KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
  KVM: VMX: Open code VMX preemption timer rate mask in its accessor
  KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()

 arch/x86/include/asm/msr-index.h | 34 ++++++++++--------
 arch/x86/include/asm/vmx.h       | 40 +++++++++++++++------
 arch/x86/kernel/cpu/mtrr/mtrr.c  |  6 ++++
 arch/x86/kvm/vmx/capabilities.h  | 10 +++---
 arch/x86/kvm/vmx/nested.c        | 62 +++++++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           | 30 ++++++++--------
 arch/x86/kvm/x86.c               |  4 +--
 arch/x86/kvm/x86.h               |  3 +-
 arch/x86/mm/pat/memtype.c        | 36 ++++++-------------
 10 files changed, 132 insertions(+), 95 deletions(-)


base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
-- 
2.45.0.215.g3402c0e53f-goog


