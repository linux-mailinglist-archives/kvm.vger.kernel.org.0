Return-Path: <kvm+bounces-46697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3C2AB8A9A
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 17:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CED641BA0FE7
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 15:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87771B0F0A;
	Thu, 15 May 2025 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEsSq2So"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5192135A0;
	Thu, 15 May 2025 15:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747322827; cv=none; b=r3bJJQ9HfDoK5JuwRj0PmK6XcZWBTvwFTFJB9Cj0+SrjUXOuv5ZJWD3OYbAT7JxVbPm43BC+Hcs/01SFiWb5xq13UGX07TVWLKtRy/poWalfTHUe0k9tsLLKKdb+yzdHG2BEAMuqH9cARxQlg25SE0bUxY0ZcRoTyGhMfV/HkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747322827; c=relaxed/simple;
	bh=itLZIIGexigkwk2Xwqiu3iD8wN6OqH6zY6bwJXMsol8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iXaRfQrnw1dzEDsD10MX1wMmjFj1njUj584ebu+PXJ/xbqq+DnxTiQuBfpMWQnuKTHbf1C9qDLaaQ6r0thQ8E4ffz0J4qc5zdmxlOn0zYts0cvnGNS7mT2Dn0PSgp9hSSt3cHPrn97Kj/wwVo8Zs7icrOiG/ftn2XzY7a8a4cEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEsSq2So; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4AAC4CEE7;
	Thu, 15 May 2025 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747322827;
	bh=itLZIIGexigkwk2Xwqiu3iD8wN6OqH6zY6bwJXMsol8=;
	h=From:To:Cc:Subject:Date:From;
	b=aEsSq2SojFum53/vUNedhNti1RS+EWJ5FeTQbqQK7oiWotihfZP5Vm1nolDJRq96o
	 RsyYgTHEnDJ3caPC4UhCI5cFFaVBvbGap23S8fVboHpCHnvmqo25Q21vhDsBb8ny25
	 ckpuHb1mJxBM+U4qJi0suAEz7lbgs1t7CQobEwkX18lCHTq3YtO9Sr7SLJyIJC429Y
	 nDZU/C7/KGmgzE4xdwiyi6LugSFUgyqmLSg6G8UDjL4pMJtkTcjAdosck22M8z3VDh
	 Kf8HKQDT0VWt68qZQMB6HghwToskrBc+jeIyodTfmoSQTamoSqYu+3L4LQR5G+Ycqf
	 w5dfHMi2Ou41g==
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
Subject: [PATCH v5 0/1] KVM: Add support for the ERAPS feature
Date: Thu, 15 May 2025 17:26:20 +0200
Message-ID: <20250515152621.50648-1-amit@kernel.org>
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
exposed to guests.  This patch adds the support to enable guests to drop their
software mitigations in favour of the hardware one.

The feature isn't yet part of an APM update that details its working, and
previous versions of the patch were RFC for that reason.  I'm now dropping the
RFC tag, because these patches have been out for a while, and I also have this
writeup:

https://amitshah.net/2024/11/eraps-reduces-software-tax-for-hardware-bugs/

which may be more detailsl than what will eventually appear in the APM anyway.

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
 arch/x86/kvm/cpuid.c               | 10 +++++++++-
 arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h             | 20 ++++++++++++++++++++
 5 files changed, 49 insertions(+), 2 deletions(-)

-- 
2.49.0


