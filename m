Return-Path: <kvm+bounces-31498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B61789C42BD
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D40E2845FC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDCA1A256F;
	Mon, 11 Nov 2024 16:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9sdQfw6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE71A0B13;
	Mon, 11 Nov 2024 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343171; cv=none; b=RT/7f3pLjaIdQ8sMabWvYitDv7f+vu7KsOo2O3CcbOeYCwzBhDjaxJ9YWKGb62UlZjC+CJzdOBC1wX0rKzbEoiuFNJK1H6Ile7VvAnd4g8Ycp7OmQSDre+Ybtjvlw9ivQ36dWQlrZeqDnDPYtJ7ddgXdGXqrgfeIojiGzeZxRKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343171; c=relaxed/simple;
	bh=CPBhudnuPHjnrtj9sZ573qgLAxZlwozAgd+JQpg1yFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gdzRnvRqj0JbKG1RzNGD9HODbLNWu+XsF5fgUUL5ck7sVrPnASc4UQovChSYXf2Rw8NwA/RYcv6p06xT/HkiJa5VPlozO4c9+7taJZoedfDZyrbZ4oVHgtZiKLAgR90HdeHzucog8Uhlk0/l5ijpvVXVRwP6LZ3TvnEzc4cQL3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9sdQfw6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADCCC4CECF;
	Mon, 11 Nov 2024 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731343171;
	bh=CPBhudnuPHjnrtj9sZ573qgLAxZlwozAgd+JQpg1yFs=;
	h=From:To:Cc:Subject:Date:From;
	b=J9sdQfw6h82dzj6t7DC4KAkU2I1UcRYN4yzN3Go4Ek3Da/Zt1U0z5z7abUfjS0lzk
	 oAF+c+SPqCXYG9PcZKW8e4zUK5OG/05CFRMUjsGmhernuqpSK6NCDkPPNBWcdvCaoZ
	 qEspsYXuFXgDTgIQ5InrqV/A2YS1BCqMlaJ2WGRwzgQgLO8xJrf/tLKyK/09nApGec
	 2JFK6amypbNcXFA0XMHjoo5ZCPztfHCRBiSomriZujxwVKTirNkNn3LFlggVBeZgZ7
	 s+oFX3PLIu53VGSjX3qmq4lQ6n2ntp5Dj4eUv2doJFC6WxS5OZ5JLIZ3CO8v/x7/NU
	 S3xekm48pG0nQ==
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
Subject: [RFC PATCH v2 0/3] Add support for the ERAPS feature
Date: Mon, 11 Nov 2024 17:39:10 +0100
Message-ID: <20241111163913.36139-1-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
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
is still tagged as RFC.

The v1 posting resulted in some questions on patch 1 -- I've included the
context and comments in the commit text for patch 1 in this posting.

v2:
* reword comments to highlight context switch as the main trigger for RSB
  flushes in hardware (Dave Hansen)
* Split out outdated comment updates in (v1) patch1 to be a standalone
  patch1 in this series, to reinforce RSB filling is only required for RSB
  poisoning cases for AMD
  * Remove mentions of BTC/BTC_NO (Andrew Cooper)
* Add braces in case stmt (kernel test robot)
* s/boot_cpu_has/cpu_feature_enabled (Boris Petkov)

Amit Shah (3):
  x86: cpu/bugs: update SpectreRSB comments for AMD
  x86: cpu/bugs: add support for AMD ERAPS feature
  x86: kvm: svm: add support for ERAPS and FLUSH_RAP_ON_VMRUN

 Documentation/admin-guide/hw-vuln/spectre.rst |  5 ++-
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/nospec-branch.h          | 12 +++++
 arch/x86/include/asm/svm.h                    |  6 ++-
 arch/x86/kernel/cpu/bugs.c                    | 34 ++++++++------
 arch/x86/kvm/cpuid.c                          | 18 +++++++-
 arch/x86/kvm/svm/svm.c                        | 44 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        | 15 +++++++
 8 files changed, 117 insertions(+), 18 deletions(-)

-- 
2.47.0


