Return-Path: <kvm+bounces-65381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D19B7CA9999
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6F17430268B3
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C272DEA77;
	Fri,  5 Dec 2025 23:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UxMZLPD7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2642C158538
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976762; cv=none; b=iMsx3utvZMJ6JlA/cIsnYdfd/RyClLuaIeExDeDj6uvw4caGzhQozTVvQrnla+NJbGHf8GHQ3sgHfGDj7qetgM6A+iSfeItTWi+Z2F0K+31lJW6qUFgkg8grPHqTqTZ5MW2GmipuijZf5Wc+CsDtQIzTqbRTiD+jTw4nyO0Lg64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976762; c=relaxed/simple;
	bh=F4qmd0OW6egoY7GqSuYsPLXHpTzAKIfKTvqeLP44kPw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kJ1vN4iGdiPH/vBWFwuN26U8KV8IZE3yprdng9SrpfiJqdPVNEctWhHvRioO28pFitwSb1POFv8GkkyoXO0rQDJnFAr3ZTRzhkIjhXmX0G9Sh5EvJAVjJOVEOpZeuloRVIevFZXgsY8NlXVQVYp2u/7wvPdmTB5UInrgOsBgWYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UxMZLPD7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-342701608e2so2881697a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976757; x=1765581557; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2XQCiijHW2n4dUEHTnUIINf5DMpBs1wfkBUUXyMiLU=;
        b=UxMZLPD7KbcZ1LLSRuOC1BEARher8Tisoy10Gi4jMJo0xMd4DIjgDZ34btckags1pm
         MWjEnMN9iG821q2YzSmZHX+2cmLU8wibZ5AmueRHkna2s49KNGa60l8G/tAu1uuHPp9j
         1ZG3pIj5CdmOtSYJdJzREvTzdDzf6fNpav2uMlSjsWpWU6fl4dcKayjUq8m2357v0hgp
         InMBiRZJJ5KTHOa5k+J3/ojKnFJLwW0Cp75HEJMaJSE1jF9Git+85EP0SFEGDTFES7OZ
         x2svaGYRsqI7D1LoFKorwpALWYPVIcEewn/oWRXdGNyORr19dKWWAVaUbZS2Lqla8GXg
         43wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976757; x=1765581557;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k2XQCiijHW2n4dUEHTnUIINf5DMpBs1wfkBUUXyMiLU=;
        b=H3OXC2p/eT5H6dA5quQ/+glrTqvDVj7NDVk5/LnydihhpXj0FjFahkizjTCETg3+av
         mj5Zt8GVNYqkoc+AF6Zw92KaxkwDblnCSmXenAK83idcPIXT4dloEhOp4/j5FjfvXp3+
         ZZNqy4O/hDCeQJg0RChtdTVkA39bt914p/dGG0FlGNFyEDP5BPU1UOLPMb+y9ZAW7qhd
         hFhWd/wGuEdmyh5OdfNwKFxCPEukxdtoRZpgLxH16Oe7EdYUMJUG1hVjqIQCT8U7iPCU
         IEhrtpCrfzDc66ZXd3MnVzhaRxqVNVFWTrdQIKk638WLPbiyuXt5HufCaAEC3CPClt+R
         CnhQ==
X-Gm-Message-State: AOJu0Yx5BqGMY+D4JxobRPJ93HURt+QfJ+xbE4i96mVIy94ykuQRyron
	4o+nIxUD97/loBsG6dLF+QvCfb6+Zd9qDKLym3js5mN/8rgei26xzmNyKD2/XqL2yHKew6xS9qo
	EzUgXig==
X-Google-Smtp-Source: AGHT+IFSsAEr2/cYfi1CtvUqufOortDcW1lHxVDrPqOoZdu9sVDjZBHwAyXJEniJEwoAwyYIUCV901X27hs=
X-Received: from pgac21.prod.google.com ([2002:a05:6a02:2955:b0:bc0:ea34:538])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d0b:b0:345:e30f:d6e6
 with SMTP id adf61e73a8af0-36617ea92famr778354637.15.1764976757538; Fri, 05
 Dec 2025 15:19:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:03 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-1-seanjc@google.com>
Subject: [PATCH v3 00/10] KVM: VMX: Fix APICv activation bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fix two bugs related to updating APICv state, add a regression test, and
then rip out the "defer updates until nested VM-Exit" that contributed to
bug #2, and eliminated a number ideas for fixing bug #1 (ignoring that my
ideas weren't all that great).

The only thing that gives me pause is the TLB flushing logic in
vmx_set_virtual_apic_mode(), mainly because I don't love open coding things
like that.  But for me, it's a much lesser evil than the mounting pile of
booleans related to tracking deferred updates, and the mental gymnastics
needed to understanding the interactions and ordering.

The fixes are tagged for stable@, and I'll probably land the selftest in
6.19 as well.  Everything else is most definitely 6.20+ material.

v3:
 - Add a selftest.
 - Rip out the deferred updates stuff.
 - Collect Chao's review.
 - Add Dongli's fix for bug #2. [Chao]

v2:
 - https://lore.kernel.org/all/20251110063212.34902-1-dongli.zhang@oracle.com
 - Add support for guest mode (suggested by Chao Gao).
 - Add comments in the code (suggested by Chao Gao).
 - Remove WARN_ON_ONCE from vmx_hwapic_isr_update().
 - Edit commit message "AMD SVM APICv" to "AMD SVM AVIC"
   (suggested by Alejandro Jimenez).

Dongli Zhang (2):
  KVM: VMX: Update SVI during runtime APICv activation
  KVM: nVMX: Immediately refresh APICv controls as needed on nested
    VM-Exit

Sean Christopherson (8):
  KVM: selftests: Add a test to verify APICv updates (while L2 is
    active)
  KVM: nVMX: Switch to vmcs01 to update PML controls on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to update TPR threshold on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to update SVI on-demand if L2 is active
  KVM: nVMX: Switch to vmcs01 to refresh APICv controls on-demand if L2
    is active
  KVM: nVMX: Switch to vmcs01 to update APIC page on-demand if L2 is
    active
  KVM: nVMX: Switch to vmcs01 to set virtual APICv mode on-demand if L2
    is active
  KVM: x86: Update APICv ISR (a.k.a. SVI) as part of
    kvm_apic_update_apicv()

 arch/x86/kvm/lapic.c                          |  21 +-
 arch/x86/kvm/lapic.h                          |   1 -
 arch/x86/kvm/vmx/nested.c                     |  30 +--
 arch/x86/kvm/vmx/vmx.c                        | 104 +++++-----
 arch/x86/kvm/vmx/vmx.h                        |   9 -
 arch/x86/kvm/x86.c                            |   5 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   4 +
 .../kvm/x86/vmx_apicv_updates_test.c          | 181 ++++++++++++++++++
 9 files changed, 257 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c


base-commit: 5d3e2d9ba9ed68576c70c127e4f7446d896f2af2
-- 
2.52.0.223.gf5cc29aaa4-goog


