Return-Path: <kvm+bounces-32744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9664C9DB89F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AB45283C50
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FEFC1A9B47;
	Thu, 28 Nov 2024 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6NziUs4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C35E158527;
	Thu, 28 Nov 2024 13:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732800529; cv=none; b=tsF9XL4iw/KabA8+McbYO4Ag7+3MqXvVVUctW/SQPqVew5Njat0WMRcB2BdlogMAX2v3beHcTeoBG3t3DhOv8fTgsSHK979UALN6RVhITFScIVbekCzCjnFYXeAWxiL1hJwgLMj11x1FiMB88B+tKYCBNLcpw8PB4w7sGOenICg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732800529; c=relaxed/simple;
	bh=o87fqi8R6sY+SVCkOs0LGzGnlkNcJffWS0dFY3Lc8as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4My5RcZtJtZXKj2UyCoIFhVJ69cs35f0DDHg1RlPtBkgqKaFkVDVsx4wfyG/pikx3CmN2gJfc4YvV8psl51zXv+QmnPDGRhG7UnIrl2mAbCm7u6vCCZRFbyM8lHN/mXFSUbZT9VTs/sNwBa7/KYNeUWYEnxg4vfv3I18ORWMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6NziUs4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE28C4CECE;
	Thu, 28 Nov 2024 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732800529;
	bh=o87fqi8R6sY+SVCkOs0LGzGnlkNcJffWS0dFY3Lc8as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6NziUs4TSO5cu2ftHncNe2lxlNS62LUdh4fnlesjW5X8X2A9V2mzGWY7/qc+w+IS
	 PRAea5G7I0EuhH4szdaftlIfJri7Q8o4h3AIJoWK8rvNLdjduF2V7cxn4/Ukd5RPlA
	 xsv77s9CSZ4SyrzbipDcHLO+a4GI9t+Rncpdt+CKQrRPm9s1UgcuZGqNvTwylmW+24
	 VvV1kvx9RC0Z08JEhhYyN1hDpot7MiHERpCvwXp4WtkjqPYW5qMukLZjemDd4ZTACq
	 oGMbqnoYZC3MfMndQhbHd9q2P08gDAM1jbgQ6uS9lYhOevexXwsbTzMqXvx40y9ajx
	 TyqWTCbHdCu7Q==
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
Subject: [RFC PATCH v3 0/2] Add support for the ERAPS feature
Date: Thu, 28 Nov 2024 14:28:32 +0100
Message-ID: <20241128132834.15126-1-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1732219175.git.jpoimboe@kernel.org>
References: <cover.1732219175.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Newer AMD CPUs (Zen5+) have the ERAPS feature bit that allows us to remove the
RSB filling loops required during context switches and VM exits.

This patchset implements the feature to:
* remove the need for RSB filling on context switches and VMEXITs in host and
  guests
* allow KVM guests to use the full default RSB stack

The feature isn't yet part of an APM update that details its working, so this
is still tagged as RFC.  The notes at

https://amitshah.net/2024/11/eraps-reduces-software-tax-for-hardware-bugs/

may help follow along till the APM is public.

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
  x86: cpu/bugs: add AMD ERAPS support; hardware flushes RSB
  x86: kvm: svm: advertise ERAPS (larger RSB) support to guests

 Documentation/admin-guide/hw-vuln/spectre.rst |  5 ++--
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/svm.h                    |  6 +++-
 arch/x86/kernel/cpu/bugs.c                    |  6 +++-
 arch/x86/kvm/cpuid.c                          | 18 ++++++++++--
 arch/x86/kvm/svm/svm.c                        | 29 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        | 15 ++++++++++
 7 files changed, 74 insertions(+), 6 deletions(-)

-- 
2.47.0


