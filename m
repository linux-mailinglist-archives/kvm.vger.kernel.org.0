Return-Path: <kvm+bounces-50113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCBAAE1F0B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:44:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D2F21BC166C
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06482D5431;
	Fri, 20 Jun 2025 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="TNV/ff+m"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3323C28B3E2;
	Fri, 20 Jun 2025 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433994; cv=none; b=nrWgveYnYYcLYwYhVlsQ1C8pytO0VuUsZvB9iqf9T0lQEBgENVgVyO36P9uccDHJZnK3I2l2E4czQbge/PbcL7gj8R2Jqt15J1n67AI1W5jsPFtiOuo0hQZO3BpnVGoa/1whBdH8Xp1P9Ieeel02xu5b43gaTM7xVJRf+5Uh5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433994; c=relaxed/simple;
	bh=VfsPGuEjqXcBsg9RvSh06ru5pxcJQVGthExdWYPZvBo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PJm0G82Tc5HSAbE2P/S89iexO2Wf4Gczh2tRWwZpm2V3C+14HT0P2dLCltm4sFxWSuUv9HY+l8GvvAxtl0E3SOCvFVabpf+jjcgxelmLzwOMBx12GPr1os0+kbKHHdx48vV0a4H6OldiVPgYWRoG06p8RyO8PQseZ6PcxTNZGb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=TNV/ff+m; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from LAPTOP-I1KNRUTF.home (unknown [40.68.205.236])
	by linux.microsoft.com (Postfix) with ESMTPSA id CF07E2117589;
	Fri, 20 Jun 2025 08:39:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF07E2117589
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1750433992;
	bh=i4K0lmrsYGvyT8FPcTPS32aag7itn+Eq0ksyOKJ7odQ=;
	h=From:To:Cc:Subject:Date:From;
	b=TNV/ff+mXTEzVQxOpBmqtPVUa8ny7aK1sKVTSlUACRqVMrfa+iDelQ8//5D8fXAQi
	 q7s1iYZ86nJESzPx/9Ny0fA6XaSteBuoJWGJesE7v+GqkuQhlnYLM0wji6F1OFlp4w
	 UpjafgTXICwm4v5PZ7kPbDarpCw+0hwNDzoAxGE4=
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To: "Sean Christopherson" <seanjc@google.com>,
	"Vitaly Kuznetsov" <vkuznets@redhat.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: "Dave Hansen" <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	alanjiang@microsoft.com,
	chinang.ma@microsoft.com,
	andrea.pellegrini@microsoft.com,
	"Kevin Tian" <kevin.tian@intel.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Haiyang Zhang" <haiyangz@microsoft.com>,
	"Wei Liu" <wei.liu@kernel.org>,
	"Dexuan Cui" <decui@microsoft.com>,
	linux-hyperv@vger.kernel.org,
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Subject: [RFC PATCH 0/1] Tweak TLB flushing when VMX is running on Hyper-V
Date: Fri, 20 Jun 2025 17:39:13 +0200
Message-Id: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sean/Parolo/Vitaly,

Wanted to get your opinion on this change. Let me first introduce the scenario:

We have been testing kata containers (containers wrapped in VM) in Azure, and
found some significant issues with TLB flushing. This is a popular workload and
requires launching many nested VMs quickly. When testing on a 64 core Intel VM
(D64s_v5 in case someone is wondering), spinning up some 150-ish nested VMs in
parallel, performance starts getting worse the more nested VMs are already
running, CPU usage spikes to 100% on all cores and doesn't settle even when all
nested VMs boot up. On an idle system a single nested VMs boots within seconds,
but once we have a couple dozen running or so (doing nothing inside), boot time
gets longer and longer for each new nested VM, they start hitting startup
timeout etc. In some cases we never reach the point where all nested VMs are
up and running.

Investigating the issue we found that this can't be reproduced on AMD and on
Intel when EPT is disabled. In both these cases the scenario completes within
20s or so. TPD_MMU or not doesn't make a difference. With EPT=Y the case takes
minutes.Out of curiousity I also ran the test case on an n4-standard-64 VM on
GCP and found that EPT=Y runs in ~30s, while EPT=N runs in ~20s (which I found
slightly interesting).

So that's when we starting looking at the TLB flushing code and found that
INVEPT.global is used on every CPU migration and that it's an expensive
function on Hyper-V. It also has an impact on every running nested VM, so we
end up with lots of INVEPT.global calls - we reach 2000 calls/s before we're
essentially stuck in 100% guest ttime.  That's why I'm looking at tweaking the
TLB flushing behavior to avoid it. I came across past discussions on this topic
([^1]) and after some thinking see two options:

1. Do you see a way to optimize this generically to avoid KVM_REQ_TLB_FLUSH on
migration in current KVM? In nested (as in: KVM running nested) I think we
rarely see CPU pinning used the way we it is on baremetal so it's not a rare of
an operation. Much has also changed since [^1] and with kvm_mmu_reset_context()
still being called in many paths we might be over flushing. Perhaps a loop
flushing individual roots with roles that do not have a post_set_xxx hook that
does flushing?

2. We can approach this in a Hyper-V specific way, using the dedicated flush
hypercall, which is what the following RFC patch does. This hypercall acts as a
broadcast INVEPT.single. I believe that using the flush hypercall in
flush_tlb_current() is sufficient to ensure the right semantics and correctness.
The one thing I haven't made up my mind about yet is whether we could still use
a flush of the current root on migration or not - I can imagine at most an
INVEPT.single, I also haven't yet figured out how that could be plumbed in if
it's really necessary (can't put it in KVM_REQ_TLB_FLUSH because that would
break the assumption that it is stronger than KVM_REQ_TLB_FLUSH_CURRENT).

With 2. the performance is comparable to EPT=N on Intel, roughly 20s for the
test scenario.

Let me know what you think about this and if you have any suggestions.

Best wishes,
Jeremi

[^1]: https://lore.kernel.org/kvm/YQljNBBp%2FEousNBk@google.com/

Jeremi Piotrowski (1):
  KVM: VMX: Use Hyper-V EPT flush for local TLB flushes

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++++++++---
 arch/x86/kvm/vmx/vmx_onhyperv.h |  6 ++++++
 arch/x86/kvm/x86.c              |  3 +++
 4 files changed, 27 insertions(+), 3 deletions(-)

-- 
2.39.5


