Return-Path: <kvm+bounces-62278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B62D4C3F2B2
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 10:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A34244E243E
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 09:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4351130170C;
	Fri,  7 Nov 2025 09:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpNZq1p6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF80184;
	Fri,  7 Nov 2025 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762507986; cv=none; b=CJOKS+oBnERk1Q5MNlCW+pg/1aqBfiKriiuSl2Ktg6xMCx5V8aTI5sB2tutQQ5w/LVKSH/byZtXcT8XEr/cpN0DzQeJ9gssbFqnMW/gbbfFI18ydR5vpTteAS5HNZcM2YmSBOTAsMUGSU7FCKYI6HdI3JML1bD/10LqkXUL641A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762507986; c=relaxed/simple;
	bh=hYJFe8wbCEuDRtL78WQJxfmZD34jnN50iScx9Q9Ft5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EAfDvnHY4XyNfvJ/VmIXn8yxfMURxjCEosVFVlDU+A9g8f9UW7prs1wWDqW1Un8iUhPaD+qIu70iQH5GnVEs9wE3rMGr1b/Nk5ypUToJcjp+KQWOe264DWXwbCZDV8OpJ/N5PpGdsFP68s0ePwEJ0JfWG6+QxwnBvjkIGEDRvmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpNZq1p6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEEFC19423;
	Fri,  7 Nov 2025 09:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762507982;
	bh=hYJFe8wbCEuDRtL78WQJxfmZD34jnN50iScx9Q9Ft5w=;
	h=From:To:Cc:Subject:Date:From;
	b=cpNZq1p6IOt76cieSxy5pmfNAYengqtkwvmCZyPP/xsD0eA2E4cRisZQg/zBykxIp
	 PfLww6zfx9bl0wwxX6aZ5suG48B0SPEjsB68/f4jfKSRK15E/7Ubeh8jHSGQxaOi+W
	 exU75Eg4P+QBJwG1vHv4MkwzQ/g4Yxb1jYXyy0pNZna819xmbJoqmdV5Brmt584zmB
	 PcfRgqzr0Lzre6h1hDnEfH9SRylNKJ0voMT/gk6EOAFeZeyU//yBNSIYlW+oVDYiuU
	 H3loHM+H6Noz4nqhCRFrUBeQQ2ebPzRv7bITJkWdksHDQ169agZggR0mqav9mwtrxI
	 W+zXjYRrtDzBw==
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
Subject: [PATCH v6 0/1] KVM: Add support for the ERAPS feature
Date: Fri,  7 Nov 2025 10:32:38 +0100
Message-ID: <20251107093239.67012-1-amit@kernel.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zen5+ AMD CPUs have a larger RSB (64 entries on Zen5), and use all of it in
the host context.  The hypervisor needs to set up a couple things before the
extra 32 entries are exposed to guests.  Add hypervisor support to let the
hardware use the entire RSB in VM contexts as well.

The APM has now been published with details of this feature - and I finally
got around to sending this updated version based on the previous
round. Apologies for the long delays in getting this out; I ended up spending
a bunch of time looking at the NPT=off case:

In the previous round, Sean suggested some emulation for also handling the
NPT=off case.  After discussions on the PUCK call (and some tracing to confirm
what we had wasn't sufficient), I decided to just drop it all and send this
patch for NPT=off.

      	  Amit

v6:
* APM update is out as of July 2025.  Reference it in the commit msg.
* Update commit msg from review comments (Sean)
* Move cpuid enablement to svm.c from x86.c (Tom Lendacky)
* Update bitfield names to reflect what's in the APM
* Update VMCB bits for all nested exits (Sean)
* Drop helper functions and set bitfields directly instead (Sean)

v5:
* Drop RFC tag
* Add separate VMCB01/VMCB02 handling to ensure both L1 and L2 guests are not
  affected by each other's RSB entries
* Rename vmcb_flush_guest_rap() back to vmcb_set_flush_guest_rap().  The
  previous name did not feel right because the call to the function only sets
  a bit in the VMCB which the CPU acts on much later (at VMRUN).

v4:
* Address Sean's comments from v3
  * remove a bunch of comments in favour of a better commit message
* Drop patch 1 from the series - Josh's patches handle the most common case,
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

Amit Shah (1):
  x86: kvm: svm: set up ERAPS support for guests

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  6 +++++-
 arch/x86/kvm/cpuid.c               |  8 +++++++-
 arch/x86/kvm/svm/nested.c          |  6 ++++++
 arch/x86/kvm/svm/svm.c             | 11 +++++++++++
 5 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.51.1


