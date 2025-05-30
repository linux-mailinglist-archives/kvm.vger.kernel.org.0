Return-Path: <kvm+bounces-48116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A50BAAC95D6
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 20:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5033C1C20720
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4B12797AF;
	Fri, 30 May 2025 18:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2IIVqNFT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41523278E5D
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748631172; cv=none; b=Rlv8GbClhG0y+7vN+95qYZlHuHtrwxwwBmZ7woX0St9B00EHNi9o2Ea3vAdkg4wUo+n/zlOtXAqX2C0m7RcoVU35eD0LzwtV8mwEhO429c8dwuWM5oH4bc7K0VUpp+DVrvKvwiVVPkkM6PKHVfb8mk7QgdwdijeHdH81CDtMgAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748631172; c=relaxed/simple;
	bh=DOB8fqOOZ+nSh40yrnI3oifjq6hR5ylYBAFURXRDnh8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pC1V/wckzlnUoBKInxKRBhsTUm/REd11OOJPNke/M8no6lYF8mm74qwTqGSdFpPfsb4T4r8ff6vQcFJMFssOWeYnAcVxNdcbZsMy2OMAODUQAwzYpVEzcu7P94Gpy9XOBbsCoKfKdZslgTwYMVjQza3gMf1eo3nMPstTfQF+sno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2IIVqNFT; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-312436c2224so1708233a91.0
        for <kvm@vger.kernel.org>; Fri, 30 May 2025 11:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748631170; x=1749235970; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uUv/RTjh91CEtJSYSuz7ab6/srgFsjOXdoBg1u5u6t4=;
        b=2IIVqNFTEF+PaIPWeiynwhvTGj0gBkWM548mfFdhq4BKGzg4eZWfhuutxboT+udVJi
         WWVsU2RVxDia2JxI0d1ziH69uNXG1m1EWU5q1sr4Yg4JYCqqo5wqihwC6lPmVjVl14/W
         2i5VXCnFyPQaeUA1W7MCrNaaGXMv/kgHa21l8Z4QXes3iykd3XtByT5Ww/FomUSPZHSa
         m6PzHoRGpnDDOtEfQaOcqlMAzCaObK7EQ+p82+dxrSeQbEaYpEgwXUulfnfHA/M1uWUq
         K2m2L/ilkUXqtgKnNM67uD2eyEOS6KeaD9OHfE37pJHOkyR7hHyKzYIcVEhpYWQLO0uo
         LB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748631170; x=1749235970;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uUv/RTjh91CEtJSYSuz7ab6/srgFsjOXdoBg1u5u6t4=;
        b=VI6vtGFAYqsqHNZ5rsqvH3tLK5h0CFsjYTq/ATLpEbDU9IpknFBWXbHNnbecQAiV1X
         KrTJ4NW5Sn6nENd7gSedTuWU1PilWnT5e1TAWpcz4Pj4zcL/8NGnmRfEFMSSqlM6N/0x
         4f+vY9xhI4xhXMUF/sf8Da/vc+07vzV6+zdppdQga42j4qaFYgjuaLiz9JMjUggJFYJt
         h5+PI8FxIrNT9qCq24zHyZu2lpVsEfbKvYFHZKybNz3qR/vnTAcjLrGASTDR/tcAmcBP
         bpkJ0R7ggqg9VV4nbvrKYiHZltbW26yy5Jcwje8RYxJ81G6q2XVyvqaWt2yc9/v2r0yO
         HGag==
X-Forwarded-Encrypted: i=1; AJvYcCU1411OS2NYiwK4hoBvzcAqIFONCTaq1vVcipO+N86lRdfKWg3lxfOgMJ3ghDX/q5W3lms=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOwJcUsVf14hSmH3OcHq/7v+xeG62Rj9l5Vl/JrWbzIPBkyGnE
	kU/ulYrpmAn/v4uOKwZ2XSe0ef+MmIoGs+QuYyyK0nlkkvW5IS/uctbpCqiikMcNYYPABrVeTzO
	tyXfklngMxINe6Q==
X-Google-Smtp-Source: AGHT+IGwdiKLI1x4pb5kVZDwHzn2zgcS8gBEAXzxms3PRqiHevVl6CoD0Ciw3kXlOHxiRZmo6nvYLya7fcOefw==
X-Received: from pjbnw2.prod.google.com ([2002:a17:90b:2542:b0:2f9:dc36:b11])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:ec8b:b0:312:1c83:58ea with SMTP id 98e67ed59e1d1-31241511fcemr8333346a91.14.1748631170549;
 Fri, 30 May 2025 11:52:50 -0700 (PDT)
Date: Fri, 30 May 2025 11:52:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250530185239.2335185-1-jmattson@google.com>
Subject: [PATCH v4 0/3] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
From: Jim Mattson <jmattson@google.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow a guest to read IA32_APERF and IA32_MPERF, so that it can
determine the effective frequency multiplier for the physical LPU.

Commit b51700632e0e ("KVM: X86: Provide a capability to disable cstate
msr read intercepts") allowed the userspace VMM to grant a guest read
access to four core C-state residency MSRs. Do the same for IA32_APERF
and IA32_MPERF.

While this isn't sufficient to claim support for
CPUID.6:ECX.APERFMPERF[bit 0], it may suffice in a sufficiently
restricted environment (i.e. vCPUs pinned to LPUs, no TSC multiplier,
and no suspend/resume).

v1 -> v2: Add {IA32_APERF,IA32_MPERF} to vmx_possible_passthrough_msrs[]
v2 -> v3: Add a selftest
v3 -> v4: Collect all disabled_exit flags in a u64 [Sean]
          Improve documentation [Sean]
	  Add pin_task_to_one_cpu() to kvm selftests library [Sean]


Jim Mattson (3):
  KVM: x86: Replace growing set of *_in_guest bools with a u64
  KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
  KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF

 Documentation/virt/kvm/api.rst                |  23 +++
 arch/x86/include/asm/kvm_host.h               |   5 +-
 arch/x86/kvm/svm/svm.c                        |   9 +-
 arch/x86/kvm/svm/svm.h                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |   8 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 arch/x86/kvm/x86.c                            |  16 ++-
 arch/x86/kvm/x86.h                            |  18 ++-
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/uapi/linux/kvm.h                |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +++
 .../selftests/kvm/x86/aperfmperf_test.c       | 132 ++++++++++++++++++
 14 files changed, 220 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

-- 
2.49.0.1204.g71687c7c1d-goog


