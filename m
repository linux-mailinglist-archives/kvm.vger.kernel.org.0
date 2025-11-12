Return-Path: <kvm+bounces-62904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E9BC53BA7
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 579D43447E4
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9244C348877;
	Wed, 12 Nov 2025 17:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gO8rYmsX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CDA346FB9
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969189; cv=none; b=eKimAdvHg4A7bxGpkEIdXxtxL1+YYkHTlxIz6MPuv7U0vMnxPyiY6L6vf0TRfZBQIWEqovcTOyil+lsHJHsgD2JyyPE93LD08SHxLVQxhGsZMHWtKUxjghHlxEe5KELUdCZidTR046qGiw1Xb8jrl9e7KAOoQ2KCHRmGbWHLCVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969189; c=relaxed/simple;
	bh=cQTvfgJcnon9Tazw0uXymglv7tr+UGFUUQGDrTC8H5s=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BArDFVbcaGgN430gu+zsNUYbK7m+QXg688NJv4a0SWmgl7n/sGV2d4mXN4tKiomd0IGW3g0neIfcb71Y0mE0WePzCEj2cmIlqvSVCVlLSjschrAezGiGiJDiFRyHNt0Cc8oERHqSvixE+2lD4aB+ODaLeusblHtnl+WH7/QjI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gO8rYmsX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3439fe6229aso1470285a91.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 09:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969187; x=1763573987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Al8Jq0oWPVD59rhTUTD0bttySyzqdJx7uMImvbMrtTk=;
        b=gO8rYmsXYqP16oDY9GqSBsWpQRrYgK9+s/Sgnvaqo1md50DnX4oEtQpTxWKe2nBAbD
         a0FkAtgn9g+pZwBZXyti1UOkZKFJi2p64MFpqXdjGfeXo3tXA1Rq+6SckjQd9l/pHhGP
         vdE++uICVE/mq39pVcaym2rYA0Wu2Zi8eon//em5ye/4YM5QQx5P1iUByCtPybut7+Gg
         0VYj0hJhgeTDSU3ulcjlm/Zhz/vC85tL8clVzX67aLigwm4fDkmSz0Q+ct9Xta4BPeeM
         rrJ9T6LoZZ2XnNOFXMIDpJXqdtmqMTJ2lbv/NDhn0OP0qXy2h9UJj+rCvgxIMGOWAWoM
         SjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969187; x=1763573987;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Al8Jq0oWPVD59rhTUTD0bttySyzqdJx7uMImvbMrtTk=;
        b=BqS1pWvc2cW9HTOHlb5QLF8DsQogrFBadE5UgebsXsnAHE2/Uhq6s8LXscy8UOxfWP
         qT8eIlnJH/A3ykundIuVBm8uI225CcnGtSSSq/XraMdMANmEfS5RJGNyC6jfxNvNMgv7
         yQ31keOqD3JiY9rVGkcSFJu8fsIymIOMc5YxoSebIK4scvwaZfxU8BrMJFWDONTukmzl
         l1CC4CzvOoy0wJdUfhUXwH7sJ7DnN4URISe2gMkNLugSOMZsCqZ4Ou2+nks9p+Puokf3
         0OGKohru09P88izyr3gP5RLD2LmOMFYoO7dfXnZzjuRI/Z+yBIMnXwW5uSWC26M1Ek7O
         KNcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOkeqcfyh0uMy6LyH5vcnBqABjBCBBUIWhbMpa1r3gVyj2Y9vRtFvWlE35BuZ+zzijCZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+DsDR5X+TG6q8FdzIMb32hfEXqDAtd2AT291qiF0vxolneE29
	LI+7ccik3UGCj5svyLfGU+A+FcEnTAqFkrN67FXXzsVuEAUy+0XjS9J5WeblfiuxmhUtS+Y3YEj
	0W1ypmQ==
X-Google-Smtp-Source: AGHT+IFPhXy58yihQJ69w+xNEF4NV2MXVm+vSkkcvlcTqNBe2Kw+QHSUNQCz0RwaERkCFBa+qLKJT/z5qkw=
X-Received: from pjnx3.prod.google.com ([2002:a17:90a:8a83:b0:340:e8f7:1b44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5201:b0:32e:3592:581a
 with SMTP id 98e67ed59e1d1-343eaca9dbfmr208175a91.17.1762969187027; Wed, 12
 Nov 2025 09:39:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:40 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-1-seanjc@google.com>
Subject: [PATCH 0/4] x86: Restrict KVM-induced symbol exports to KVM
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Leverage and extend KVM's macro shenanigans to export symbols for KVM if
and only if kvm{,-amd,intel}.ko is being built as a module, and only for
the KVM modules that are being built.

Note, this approach isn't 100% precise, as exports that are only strictly
necessary for one of KVM's modules will get exported for all KVM modules.
But I don't see any value in being super precise as it's not like kvm.ko is
any more trustworthy tha kvm-{amd,intel}.ko (and it's easy to circumvent
"for module" exports by abusing module names (in out-of-tree code)).  And
maintaining precise exports would likely be a nightmare (as would writing
the macros to get the exports right).

Patches 1-3 drop superfluous exports that I found while digging around for
KVM-only exports.

Sean Christopherson (4):
  x86/bugs: Drop unnecessary export of "x86_spec_ctrl_base"
  x86/mtrr: Drop unnecessary export of "mtrr_state"
  x86/mm: Drop unnecessary export of "ptdump_walk_pgd_level_debugfs"
  x86: Restrict KVM-induced symbol exports to KVM modules where
    obvious/possible

 arch/x86/entry/entry.S             |  7 ++-
 arch/x86/entry/entry_64.S          |  3 +-
 arch/x86/entry/entry_64_fred.S     |  3 +-
 arch/x86/events/amd/core.c         |  5 ++-
 arch/x86/events/core.c             |  7 +--
 arch/x86/events/intel/lbr.c        |  3 +-
 arch/x86/events/intel/pt.c         |  7 +--
 arch/x86/include/asm/kvm_types.h   |  5 +++
 arch/x86/kernel/apic/apic.c        |  3 +-
 arch/x86/kernel/apic/apic_common.c |  3 +-
 arch/x86/kernel/cpu/amd.c          |  4 +-
 arch/x86/kernel/cpu/bugs.c         | 18 ++++----
 arch/x86/kernel/cpu/bus_lock.c     |  3 +-
 arch/x86/kernel/cpu/common.c       |  7 +--
 arch/x86/kernel/cpu/mtrr/generic.c |  1 -
 arch/x86/kernel/cpu/sgx/main.c     |  3 +-
 arch/x86/kernel/cpu/sgx/virt.c     |  5 ++-
 arch/x86/kernel/e820.c             |  3 +-
 arch/x86/kernel/fpu/core.c         | 21 ++++-----
 arch/x86/kernel/fpu/xstate.c       |  7 +--
 arch/x86/kernel/hw_breakpoint.c    |  3 +-
 arch/x86/kernel/irq.c              |  3 +-
 arch/x86/kernel/kvm.c              |  5 ++-
 arch/x86/kernel/nmi.c              |  5 +--
 arch/x86/kernel/process_64.c       |  5 +--
 arch/x86/kernel/reboot.c           |  5 ++-
 arch/x86/kernel/tsc.c              |  1 +
 arch/x86/lib/cache-smp.c           |  9 ++--
 arch/x86/lib/msr.c                 |  5 ++-
 arch/x86/mm/dump_pagetables.c      |  1 -
 arch/x86/mm/pat/memtype.c          |  3 +-
 arch/x86/mm/tlb.c                  |  5 ++-
 arch/x86/virt/vmx/tdx/tdx.c        | 69 +++++++++++++++---------------
 include/linux/kvm_types.h          | 14 ++++++
 34 files changed, 144 insertions(+), 107 deletions(-)


base-commit: 19e2126bba55df9de15d9100b922df1dad6d39a4
-- 
2.51.2.1041.gc1ab5b90ca-goog


