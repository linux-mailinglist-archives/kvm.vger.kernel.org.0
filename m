Return-Path: <kvm+bounces-11426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 84263876E83
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E65D1B210B7
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC05E20317;
	Sat,  9 Mar 2024 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EufGMTVU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0E14F6C
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709947653; cv=none; b=N9+oJ/5pZa8aUY+efHHPB4SQIGbpT+eKctG2mhCX3j3lqWP4LGOIApR7sCZOPWsKYz8p6CG/9n57OWM6bdgP1BhKKDiUhxW2Fzp5lV8NOggKMX9lEsN1X3Jckn8hbb4bvT+DT5/4r2DGB0RqRgjPKS4y8KXKhx/+O+NA+tN6M6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709947653; c=relaxed/simple;
	bh=/z9WO3T7UxV1xWwTZYbWLfjV6SC4EMAbgW+sVJri+h8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SXhTTnh7yunK7Y+Mf2FeQlbXLRgeiEjzpNbTlqQCuYqZ0IA0rcOQkCyA9tgVCq1OhdHAmEYMI8x2DWhaoD5/puNCq4nhxrZl2E3xdORBSiAC6iHst11en63ExRqgDACPnwfSXR6AtGrm+dAhdjRcEDzEoVsMxfKGYqPYuTZFZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EufGMTVU; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so2428710a12.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709947651; x=1710552451; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YkJCUPSdZND13kjwjotZrywaVk8AfVos37r2ySgZ4U=;
        b=EufGMTVUDkrSKFcEtZxrvg9HQoh1pvxQKsyIAMcnqEVmEjx06B+TD0IqlIAVOU/9J0
         W+uHcGOa/lx+sQr5g8eewvLtd/fy+ATVihItqvdZ8mOS9qhzBBT10FFaXQM0ceNueXu7
         ANKK77eX5fOcuhTbLc4geVkIDAqZcSVvIG8ydsyenv1OEHEbiHAfOd0LuExm8sgsuS6O
         WZfMLydF5cskqeb12ZHj1yp6N5CUbgBJSIUe1k/yIvuWBhDG1SUjVgFIWFxgQXCSgmuG
         RDxIstLn0rFjezkSNNhlpDVgptAmr4p6gpYHlqd1dFL/8RSj+zZu5ahpY8hrmA5ygGNS
         9OFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709947651; x=1710552451;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YkJCUPSdZND13kjwjotZrywaVk8AfVos37r2ySgZ4U=;
        b=QEJd+PfamShjc6iOZ7ADYPP0KGAwM7xGmtFPsWVYR4tPit3nVahRqzmzWaCsT+7gBC
         /R7KV4gvsVfmCGEZtDLpRu8v52Te1arblpC/oeeLgaosnC8Z0gu2dvudOeLEmpY/ySBA
         0+/kU7hLE/G4GtnDsyQFr2G3DwyxE1J7yfyC1KUU1d/Ebeb3TVulZleMtC6VULzSLgzc
         MDcOTIXqNI5tl5QX8ASj9VyCNZB1YUH9jumLrgfe6I8T4DKgIFUJyB3rFcugECWX2VFA
         yqP4hAV0vImAjfv2YHETgoJ3dsyWaHlTeek6wk1sqAyY8C0/SgqRUb/M3FbnARYHCL7z
         dawg==
X-Forwarded-Encrypted: i=1; AJvYcCXC5AFSJlh4nMBKVWHb5yMcNaC5RhqCsvArVztJWgf0gcXLkGiptw/D32sB1jNBjHkU4myd4CcmepY5JLoYzxksG97k
X-Gm-Message-State: AOJu0YzzTeiVCQQCxeyjAr6PNijrf28Cr2y8XpezPAnIx5n3FBVs8Q+r
	AmzFnrwDNQgmFkZG3G5JmL/FXWxi74QbZv9PjlOZ1P9N2ZSDrtadFHEWPLADMgOwIbQe7EGpOOe
	nzw==
X-Google-Smtp-Source: AGHT+IFj77UZuwdIPprMpQbJyuJ4s6qzGCcUZUE3s6OFTlyN3jyemkumJPo3H3Vwu2fCOq66+bIg8UwGxCg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1b48:0:b0:5dc:97e:6981 with SMTP id
 b8-20020a631b48000000b005dc097e6981mr1639pgm.3.1709947650777; Fri, 08 Mar
 2024 17:27:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:27:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309012725.1409949-1-seanjc@google.com>
Subject: [PATCH v6 0/9] x86/cpu: KVM: Clean up PAT and VMX macros
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

This is v6 of Xin's series to clean up a variety of KVM's VMX macros, but
this version obviously goes beyond cleaning up the VMX macros.

While reviewiing the VMX changes, we realized that (a) KVM was defining
VMX specific macros for the architectural memtypes, (b) the PAT and MTRR
code define similar, yet different macros, and (c) that the PAT code not
only has macros for the types (well, enums), it also has macros for
encoding the entire PAT MSR.

The first half of the series moves as much of the memtype stuff to
common code as is reasonably possible.

The second half is Xin's cleanup (though split into more patches than
what were posted in v5).

Based on:

    https://github.com/kvm-x86/linux next

v6:
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
  KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single 64-bit value
  KVM VMX: Move MSR_IA32_VMX_MISC bit defines to asm/vmx.h

Xin Li (4):
  KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to asm/vmx.h
  KVM: nVMX: Use macros and #defines in vmx_restore_vmx_basic()
  KVM: VMX: Open code VMX preemption timer rate mask in its accessor
  KVM: nVMX: Use macros and #defines in vmx_restore_vmx_misc()

 arch/x86/include/asm/msr-index.h | 34 +++++++++++--------
 arch/x86/include/asm/vmx.h       | 37 +++++++++++++++------
 arch/x86/kernel/cpu/mtrr/mtrr.c  |  6 ++++
 arch/x86/kvm/vmx/capabilities.h  | 10 +++---
 arch/x86/kvm/vmx/nested.c        | 56 +++++++++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h        |  2 +-
 arch/x86/kvm/vmx/vmx.c           | 30 ++++++++---------
 arch/x86/kvm/x86.c               |  4 +--
 arch/x86/kvm/x86.h               |  3 +-
 arch/x86/mm/pat/memtype.c        | 35 ++++++--------------
 10 files changed, 127 insertions(+), 90 deletions(-)


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.44.0.278.ge034bb2e1d-goog


