Return-Path: <kvm+bounces-30199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A97A99B7EA8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E52828165E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E076B1A2872;
	Thu, 31 Oct 2024 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+YhqSSH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEAC13342F;
	Thu, 31 Oct 2024 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389175; cv=none; b=R2DIafUdsprzGds2DlHO6B7N6PqZMqCAuKTt0Hx4Q2f0COuMDas8ZpOKMb4Fs3Tn/fwAYxF+UcKqtULKyGo+bjqI07+UchkIbzDc6sAqLORJ0f6Ege+hAd8g+u30d5xLNlDX7xcAOxJ6WWAViTOWp8jc1pnAMAyz+3z6EbRLygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389175; c=relaxed/simple;
	bh=L/jo7eEUG/2qnsFRBi6LvWPQN/SEKlGqLGlWa/pbcQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TVGReKyxTIsGxrI6WK79R9VqT1gv/qpGk48MDXmNVdfSn8L3oHNGIPUmxlin+5RTUOE7dHJz3l7d773oWmT+X/4LD5tQWrxiaac13ppj3YW8tEYjafML7RoRIm2b3Uy0vKYknfVhf+EWKvsoTFIIDWt7w2nAJqNvnA9mPUZByTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+YhqSSH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19A1C4CEEA;
	Thu, 31 Oct 2024 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730389174;
	bh=L/jo7eEUG/2qnsFRBi6LvWPQN/SEKlGqLGlWa/pbcQk=;
	h=From:To:Cc:Subject:Date:From;
	b=p+YhqSSH7AS+oMTz9uU2WP+xSV6ulp7+x84gFq9BNmPMFYjIMv0N8CMqL/mR89scn
	 EI+wENo/9J7DLMj7Ym2v/l6RmtlV43+mZTtUD/bCYHyRdAWxNJ4hL8oUrpo7Bp7txd
	 uSe5AbBpuor78ELdjBcV5OFMpa9FckqGXEb2kW9AUAZ4edHqCkweo321ZHKuhHFTmO
	 xFxlsTL0jYlH/Sf2JOXrsX3QPWmXtTM4cdG8cQeMqBedcteDiIiuSf8+d0tX1+FPy1
	 MDbrpmNi5JY+WPewMur27x5NBd0PE3tmJJdz0FguXQX1+OX9yCZdltJrm9DAk4epDE
	 gGpk/2hk1erBA==
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
	david.kaplan@amd.com
Subject: [PATCH 0/2] Add support for the ERAPS feature
Date: Thu, 31 Oct 2024 16:39:23 +0100
Message-ID: <20241031153925.36216-1-amit@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

Newer AMD CPUs (Turin+) have the ERAPS feature bit that allows us to remove
the RSB filling loops required during context switches and VM exits.

This patchset implements the feature to:
* remove the need for RSB filling on context switches and VMEXITs in host and
  guests
* allow KVM guests to use the full default RSB stack

Amit Shah (2):
  x86: cpu/bugs: add support for AMD ERAPS feature
  x86: kvm: svm: add support for ERAPS and FLUSH_RAP_ON_VMRUN

 Documentation/admin-guide/hw-vuln/spectre.rst |  5 ++-
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/nospec-branch.h          | 11 +++++
 arch/x86/include/asm/svm.h                    |  6 ++-
 arch/x86/kernel/cpu/bugs.c                    | 36 ++++++++++-----
 arch/x86/kvm/cpuid.c                          | 15 ++++++-
 arch/x86/kvm/svm/svm.c                        | 44 +++++++++++++++++++
 arch/x86/kvm/svm/svm.h                        | 15 +++++++
 8 files changed, 118 insertions(+), 15 deletions(-)

-- 
2.47.0


