Return-Path: <kvm+bounces-38605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE96A3CC08
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 23:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AA0F3BA88E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 22:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6D52586D3;
	Wed, 19 Feb 2025 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J8rTIIp3"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC39E253351
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002920; cv=none; b=hpEZVBbe+/ChhrUurM9ee2yULsdBkEPhb3DGgn1d4bgDRN6tbiMwCv1rpLqrNHfp8/G9vOAPa+D9O1aOThM2LTYdrrFWvGQx0LBFdpQ+NDdlkQoQqec4d5bjaWLAym4CqCfqQHVGBSubuX9C6RmWFM6IRGub3FWfT32twBrDa4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002920; c=relaxed/simple;
	bh=1DkxmY1rL0GUdbS9L1VLRdF7myOzSpNI0SwNs8PmIJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2PlZxemhC9GWawwyLYFxcbAZaLCtevMc7A4KTLnsQVDOaViqDd3+F/6ELzA6wFp1hm/H9FwZ9y9oJYOWFN1WKLnA9YzWaP8vAVW0R5uKA4SIiLhIi/Ms8ChtOnEaXdrXHnLmAkwphkD0HT2fnjHM/x7L0v797E9uEEXwD222WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J8rTIIp3; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740002916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WpU0rD3isYp66Xrj39ql+pIHZxVt4wKqru3PsTc0tjQ=;
	b=J8rTIIp381speMGCZ/B3bR7+4yHQUUjGoGfy1ufGp7SN5t3qm4cJ58zNLZCDs/vkx8P5Ry
	awp4pCTuTeKAERsjHhx/Yne7Z28ndlRDaiRR8S4flkPyuue+8d8HTPRUWNBLjcwEgvks8M
	bOJ2SaO/SsNduS64NP9sg45bS9cQ9h4=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] IBPB cleanups and a fixup
Date: Wed, 19 Feb 2025 22:08:20 +0000
Message-ID: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This series removes X86_FEATURE_USE_IBPB, and fixes a KVM nVMX bug in
the process. The motivation is mostly the confusing name of
X86_FEATURE_USE_IBPB, which sounds like it controls IBPBs in general,
but it only controls IBPBs for spectre_v2_mitigation. A side effect of
this confusion is the nVMX bug, where virtualizing IBRS correctly
depends on the spectre_v2_user mitigation.

The feature bit is mostly redundant, except in controlling the IBPB in
the vCPU load path. For that, a separate static branch is introduced,
similar to switch_mm_*_ibpb.

I wanted to do more, but decided to stay conservative. I was mainly
hoping to merge indirect_branch_prediction_barrier() with entry_ibpb()
to have a single IBPB primitive that always stuffs the RSB if the IBPB
doesn't, but this would add some overhead in paths that currently use
indirect_branch_prediction_barrier(), and I was not sure if that's
acceptable.

For the record, my measurements of the latency of
indirect_branch_prediction_barrier() and entry_ibpb() on Rome and Milan
(both do not have X86_FEATURE_AMD_IBPB_RET) are as follows:

Rome:
400ns (indirect_branch_prediction_barrier) vs 500ns (entry_ibpb)

Milan:
220ns (indirect_branch_prediction_barrier) vs 280ns (entry_ibpb)

I also wanted to move controlling the IBPB on vCPU load from
being under spectre_v2_user to spectre_v2, because "user" in a lot of
mitigation contexts does not include VMs.

Just laying out these thoughts in case others have any comments.

Yosry Ahmed (6):
  x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
  x86/mm: Remove X86_FEATURE_USE_IBPB checks in cond_mitigation()
  x86/bugs: Remove the X86_FEATURE_USE_IBPB check in ib_prctl_set()
  x86/bugs: Use a static branch to guard IBPB on vCPU load
  KVM: nVMX: Always use IBPB to properly virtualize IBRS
  x86/bugs: Remove X86_FEATURE_USE_IBPB

 arch/x86/include/asm/cpufeatures.h       | 1 -
 arch/x86/include/asm/nospec-branch.h     | 4 +++-
 arch/x86/kernel/cpu/bugs.c               | 7 +++++--
 arch/x86/kvm/svm/svm.c                   | 3 ++-
 arch/x86/kvm/vmx/vmx.c                   | 3 ++-
 arch/x86/mm/tlb.c                        | 3 +--
 tools/arch/x86/include/asm/cpufeatures.h | 1 -
 7 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.48.1.601.g30ceb7b040-goog


