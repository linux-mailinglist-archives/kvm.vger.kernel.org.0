Return-Path: <kvm+bounces-42455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BC8A789D8
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F3FC1690D6
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9310F235341;
	Wed,  2 Apr 2025 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewWuH8e3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8845235345;
	Wed,  2 Apr 2025 08:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743582536; cv=none; b=YU4qkZSCKIFqOKHz/9oon4RTqpmSOtT2uCL7E187pdIS85Vl09p7J7NXUMcxURnCbKXKpPKqxfSLkA5Oyvc0HRbHaE5AQdRIAaUd2qjRtWCq0O8pUw7879j1aBqUOlozuVH5E5xMT7k3SOrhLHVUc0Dtq87LkQN6KpODzFlATck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743582536; c=relaxed/simple;
	bh=+NyrcvDxQWdvL5vOazz3qtBbzZp5lT92VivrZpEL9WI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRZQDbybW2AKwMrPvHQTWBkTT1wnkxg3EBUA/yycBEuBwJPPWG8StTfIIxuBQ4dMHY7cB1vf6C+QTznRdJTpiVFbceMdKd2iT9HB4+34xZoPJhbQONg+gRHj5LaQzzTSqGVSKTUdK3U9cP1DYoXs0UUqlBNfiKcF4iiOUE/HD8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewWuH8e3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B84C4CEDD;
	Wed,  2 Apr 2025 08:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743582535;
	bh=+NyrcvDxQWdvL5vOazz3qtBbzZp5lT92VivrZpEL9WI=;
	h=From:To:Cc:Subject:Date:From;
	b=ewWuH8e31m7iceYWeMziIqSMnau8JyiuAUIpino64Lb697g5m/HSkgG+8QoxGRAkU
	 3tW+KVeGjVYqmqTKy3mzoqaVS8VEXNcbXy0xrd4A2jbJ2VS6j1U5OY9fwfC2VFzNev
	 yblo6BU9wAzztCX1MobafPuTvegJNn5Ro/ZJE3J9yySZHfukQRaD0t4Vpn8bVWGkWa
	 umjB9v+6+DiHz7Vq+Jdj5eE+GOhXc2wrNuwGvtGaJWBZSCGeVRUUTkiuT7tURz3MJy
	 Y6Hqyf/LzgrMCI19pbjV6HWUBuGyETGw5X+y2etQMZn26k7yEnADxBHR2ptL1qAe6l
	 v2mU2FcuBGU+g==
From: Amit Shah <amit@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com,
	Amit Shah <amit@kernel.org>
Subject: [RFC PATCH v4 0/2] KVM: Add support for the ERAPS feature
Date: Wed,  2 Apr 2025 10:28:31 +0200
Message-ID: <20250402082833.9835-1-amit@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zen5+ AMD CPUs have a larger RSB (64 entries on Zen5), and use all of it in
the host context.  The hypervisor needs to set up a couple things before it's
exposed to guests.  Patch 1 adds that support.

The feature also adds host/guest tagging to entries in the RSB, which helps
with preserving RSB entries instead of flushing them across VMEXITs.  The
patches at

https://lore.kernel.org/kvm/cover.1732219175.git.jpoimboe@kernel.org/ 

address that.

The feature isn't yet part of an APM update that details its working, so this
is still tagged as RFC.  The notes at

https://amitshah.net/2024/11/eraps-reduces-software-tax-for-hardware-bugs/

may help follow along till the APM is public.

Patch 2 is something I used for development and debugging, I don't intend to
submit it for inclusion, but let me know if you think it's useful and I'll
prepare it for final inclusion as well.

One thing I'm not sure about, though, and would like clarification.  Quoting
from my reply to the v3 series:

When EPT/NPT is disabled, and shadow MMU is used by kvm, the CR3
register on the CPU holds the PGD of the qemu process.  So if a task
switch happens within the guest, the CR3 on the CPU is not updated, but
KVM's shadow MMU routines change the page tables pointed to by that
CR3.  Contrasting to the NPT case, the CPU's CR3 holds the guest PGD
directly, and task switches within the guest cause an update to the
CPU's CR3.

Am I misremembering and misreading the code?

v4:
* Address Sean's comments from v3
  * remove a bunch of comments in favour of a better commit message
* Drop patch 1 fromt the series - Josh's patches handle the most common case,
  and the AutoIBRS-disabled case can be tackled later if required after Josh's
  patches have been merged upstream.

v3:
* rebase on top of Josh's RSB tweaks series
  * with that rebase, only the non-AutoIBRS case needs special ERAPS support.
    AutoIBRS is currently disabled when SEV-SNP is active (commit acaa4b5c4c8)

* remove comment about RSB_CLEAR_LOOPS and the size of the RSB -- it's not
  necessary anymore with the rework

* remove comment from patch 2 in svm.c in favour of the commit message

v2:
* reword comments to highlight context switch as the main trigger for RSB
  flushes in hardware (Dave Hansen)
* Split out outdated comment updates in (v1) patch1 to be a standalone
  patch1 in this series, to reinforce RSB filling is only required for RSB
  poisoning cases for AMD
  * Remove mentions of BTC/BTC_NO (Andrew Cooper)
* Add braces in case stmt (kernel test robot)
* s/boot_cpu_has/cpu_feature_enabled (Boris Petkov)



Amit Shah (2):
  x86: kvm: svm: set up ERAPS support for guests
  debug: add tracepoint for flush_rap_on_vmrun

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               | 10 +++++++++-
 arch/x86/kvm/svm/svm.c             |  9 +++++++++
 arch/x86/kvm/svm/svm.h             | 15 +++++++++++++++
 arch/x86/kvm/trace.h               | 16 ++++++++++++++++
 arch/x86/kvm/x86.c                 |  1 +
 7 files changed, 56 insertions(+), 2 deletions(-)

-- 
2.49.0


