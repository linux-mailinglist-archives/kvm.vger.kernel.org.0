Return-Path: <kvm+bounces-70539-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBNtH8q7hmkEQgQAu9opvQ
	(envelope-from <kvm+bounces-70539-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:12:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA395104D9D
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 05:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C9793307BB85
	for <lists+kvm@lfdr.de>; Sat,  7 Feb 2026 04:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D152C21DF;
	Sat,  7 Feb 2026 04:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yV395FpA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA4B332901
	for <kvm@vger.kernel.org>; Sat,  7 Feb 2026 04:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770437423; cv=none; b=CecPaq0C0J6rJovxD96n3x078V70CQ7BkRRPKHGh6htSAOrSumggKPUdZVYi2PdJENH/7gfQFq5tQT9TZjBd3urZ2IzpGxSQ2Df4Uk/n6m1ydaoHMX9iA3tS9PfKUE4x0Kqx1OEhzbsWKGI4q2FvID09Dt377N/HObMHYMjbzng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770437423; c=relaxed/simple;
	bh=rOROJGvPCEPzOWAqMf5MRNjNGJydhI+lyttEtylFZI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Velahr2LE9hSrKwtoigxeLm49/HVmbSjvCOiNed304BFExHPqipYd5mRPumfHINoFxBUH9iwGhDfENyzw5dZ95hwH2QDuYYIcx0kesSNRpbBDMZ+F0K4GHQu5Y5g3bZY3t3Ujn7pG5FJUbAB22aDqTsNtmh/r5HY5SABTTf3OIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yV395FpA; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354e7e705e3so238885a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 20:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770437421; x=1771042221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1AowVblkqagzbzM8Tx2Y14o60T6tXfbxiInvAlXBy8E=;
        b=yV395FpAMBD/aNjASi55LAZDUwyrEKkHoRp4/1eugWoQLx/b4iYRr9TV87a1p8InPX
         FNGBl+FsNEfSAVZlaH5e6Q61f37RDTRQgkZ3CJ9vOW1+lbCmC+r84OCSa7gCaHEK27+K
         jjAH5K+rCFCIfP3icQCWLs+SOWqPuJfD0DSE3jVnn/6DmRmGnMCymfffdP9lGeyL6ywY
         NuawsZso9kL3yR27phVBipUE8CH9PDG35fMqkcEmolT4JWGHQjKNb4JytEC8XD+P3Hhv
         v272Lkww0WC2AWQovXPz3gc4M/bCl+TQdUop8IkvtL6zK76U4tA+jpheb86kqcdMf0WG
         0fjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770437421; x=1771042221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1AowVblkqagzbzM8Tx2Y14o60T6tXfbxiInvAlXBy8E=;
        b=oF2lLzrwXHNwyixaNtAZdjoJOM6FhZUYFJ4BY+RWhgk2uwneIXBZ0/811EmR3HrGIa
         RN33w4RG48b6XBKpQUwXuSrSlkP2wxVkKsFk1cIHTOSzZHx6jwzjgfDe1Y+R5cNfYBFC
         snc8eGeSTJLfXTGNT2CFSLC1Loq6pxtCqkVLceqKlJVyy46Eem3uutW0POjT97TAmVdC
         /nmJH4tN98+B8eRjshl0B8/So+nW6ZHzwCWGEPTLunTg6kMW9QuBu+9bgQAl6BlAqUU9
         U206kQtSc2DYkxOeAOJrYsV5PlVWRiURwVuO1jxy0KuNUNf4u76tFkLkqOvs7LxDPe8A
         tHeQ==
X-Gm-Message-State: AOJu0Yw3/5E/Wq3rTkxElKiFdXItqodayRW9LbzyjFCTZRb4nzFEOdn+
	SCXbLGlxYQBCxgU5bYhPpT+n6j2FAq6ksY3QVUrm+KtbSAGmP8j20QIofkHLDzsIcpDhiGnk0OU
	TeFgjhQ==
X-Received: from pjtl24.prod.google.com ([2002:a17:90a:c598:b0:354:c16d:17b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a04:b0:34a:4a8d:2e2e
 with SMTP id 98e67ed59e1d1-354b3cae0b8mr4379330a91.17.1770437421200; Fri, 06
 Feb 2026 20:10:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  6 Feb 2026 20:10:06 -0800
In-Reply-To: <20260207041011.913471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260207041011.913471-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.20
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70539-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: CA395104D9D
X-Rspamd-Action: no action

No real theme here, truly a misc set of changes.  The most notable change is
the Suppress EOI Broadcast quirk (not actually implemented as a quirk), which
generated a _lot_ of discussion (David W. still isn't thrilled that in-kernel
I/O APIC support isn't included[*]), but overall I think we ended up with a
solid implementation.

[*] https://lore.kernel.org/all/83f9b0a5dd0bc1de9d1e61954f6dd5211df45163.camel@infradead.org

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.20

for you to fetch changes up to 6517dfbcc918f970a928d9dc17586904bac06893:

  KVM: x86: Add x2APIC "features" to control EOI broadcast suppression (2026-01-30 13:28:35 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.20

 - Disallow changing the virtual CPU model if L2 is active, for all the same
   reasons KVM disallows change the model after the first KVM_RUN.

 - Fix a bug where KVM would incorrectly reject host accesses to PV MSRs that
   were advertised as supported to userspace when running with
   KVM_CAP_ENFORCE_PV_FEATURE_CPUID enabled.

 - Fix a bug where KVM would attempt to read protect guest state (CR3) when
   configuring an async #PF entry.

 - Fail the build if EXPORT_SYMBOL_GPL or EXPORT_SYMBOL is used in KVM (for x86
   only) to enforce usage of EXPORT_SYMBOL_FOR_KVM_INTERNAL.  Explicitly allow
   the few exports that are intended for external usage.

 - Ignore -EBUSY when checking nested events after a vCPU exits blocking as
   the WARN is user-triggerable, and because exiting to userspace on -EBUSY
   does more harm than good in pretty much every situation.

 - Throw in the towel and drop the WARN on INIT/SIPI being blocked when vCPU is
   in Wait-For-SIPI, as playing whack-a-mole with syzkaller turned out to be an
   unwinnable game.

 - Add support for new Intel instructions that don't require anything beyond
   enumerating feature flags to userspace.

 - Grab SRCU when reading PDPTRs in KVM_GET_SREGS2.

 - Add WARNs to guard against modifying KVM's CPU caps outside of the intended
   setup flow, as nested VMX in particular is sensitive to unexpected changes
   in KVM's golden configuration.

 - Add a quirk to allow userspace to opt-in to actually suppress EOI broadcasts
   when the suppression feature is enabled by the guest (currently limited to
   split IRQCHIP, i.e. userspace I/O APIC).  Sadly, simply fixing KVM to honor
   Suppress EOI Broadcasts isn't an option as some userspaces have come to rely
   on KVM's buggy behavior (KVM advertises Supress EOI Broadcast irrespective
   of whether or not userspace I/O APIC supports Directed EOIs).

 - Minor cleanups.

----------------------------------------------------------------
Jun Miao (1):
      KVM: x86: align the code with kvm_x86_call()

Khushit Shah (1):
      KVM: x86: Add x2APIC "features" to control EOI broadcast suppression

Sean Christopherson (6):
      KVM: x86: Disallow setting CPUID and/or feature MSRs if L2 is active
      KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR
      KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
      KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()
      KVM: x86: Drop WARN on INIT/SIPI being blocked when vCPU is in Wait-For-SIPI
      KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps

Vasiliy Kovalev (1):
      KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()

Xiaoyao Li (1):
      KVM: x86: Don't read guest CR3 when doing async pf while the MMU is direct

Zhao Liu (4):
      KVM: x86: Advertise MOVRS CPUID to userspace
      KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
      KVM: x86: Advertise AVX10.2 CPUID to userspace
      KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace

 Documentation/virt/kvm/api.rst     | 28 ++++++++++++-
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  9 +++++
 arch/x86/include/uapi/asm/kvm.h    |  6 ++-
 arch/x86/kvm/Makefile              | 49 +++++++++++++++++++++++
 arch/x86/kvm/cpuid.c               | 75 +++++++++++++++++++++++++++++------
 arch/x86/kvm/cpuid.h               | 12 +++++-
 arch/x86/kvm/ioapic.c              |  2 +-
 arch/x86/kvm/lapic.c               | 77 +++++++++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.h               |  2 +
 arch/x86/kvm/mmu/mmu.c             | 11 +++---
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/reverse_cpuid.h       | 19 +++++++++
 arch/x86/kvm/svm/svm.c             |  4 +-
 arch/x86/kvm/vmx/vmx.c             |  4 +-
 arch/x86/kvm/x86.c                 | 81 +++++++++++++++++++++++---------------
 arch/x86/kvm/x86.h                 | 15 ++++++-
 17 files changed, 328 insertions(+), 69 deletions(-)

