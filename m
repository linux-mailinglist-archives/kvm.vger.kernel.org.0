Return-Path: <kvm+bounces-42495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 231C2A794F9
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3922E16ED38
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6E51C863F;
	Wed,  2 Apr 2025 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6q0/WSF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC0386353;
	Wed,  2 Apr 2025 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617996; cv=none; b=p3WzGMbZ98ljuNEzjHIEQXqshFORTlIIOlrRk3VGYvvH4DtMYzl1cAPjhy7upHr5ZIHSHMRTPuVn4wIJsMZA0IsaGArvH2jhnlmDxhrX6B6bFOYeWVoSIejC1iahnPLbQUmJxLjFMTqoTe0fVouU+7JloN9jYzbL3oedfJRWXL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617996; c=relaxed/simple;
	bh=kefRhqCrFpmjOLWqhKGmTdOUYk72ZAe+lcsM2G2Z1ig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SJXyGbuHEoHTFDSItZa4j/Imfu+6qSUwgaIAxa4d1beN7a76gX0zMtOnQ7NzIY9fWL7iyBSQbw8tD2MzWY6FViUhs23iO9IeRShJ5aiGh7FSC18ReDss+GuAY7xJVjeo5aB6ZzxstxJ/e/Q6UHich8dB70ETTVibjg6chOb68n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6q0/WSF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3521CC4CEDD;
	Wed,  2 Apr 2025 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743617996;
	bh=kefRhqCrFpmjOLWqhKGmTdOUYk72ZAe+lcsM2G2Z1ig=;
	h=From:To:Cc:Subject:Date:From;
	b=Q6q0/WSFJNkbNzMD8XXu4CqTD7nBQzRA9YVqRbRnYVIhJcLQqbw1/qzAoaL+Oz0NK
	 eqND/jxM+LymV0dACJ7ZK+CaGT3ClwOe5oTRw9hgPrfh9hVAm5jJvczMjtcMDpkLKQ
	 QyPH9+gS9ZeyldZVjbc4NS7nSFy1aeeniTf/Y3NjWYpvhYX8NXUNH7EgHt5d0nZPFq
	 eZpYmqhgVFBsD8B12mUpDgK4eI8JwJ7lSqsmlj/0cLqgmn5q9pC2jikq86+hWjsXTK
	 gDfAXWlirx+LOL6niYZsYpmFmblOMOQbGMai2lLhXM7GKswyTp386ocxQDREY88WGi
	 LF1T6xe0ol1Fw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	amit@kernel.org,
	kvm@vger.kernel.org,
	amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
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
	andrew.cooper3@citrix.com
Subject: [PATCH v3 0/6] x86/bugs: RSB mitigation fixes and documentation
Date: Wed,  2 Apr 2025 11:19:17 -0700
Message-ID: <cover.1743617897.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v3:
- fancy new doc
- more fixes

v2: https://lore.kernel.org/cover.1732219175.git.jpoimboe@kernel.org

Josh Poimboeuf (6):
  x86/bugs: Rename entry_ibpb()
  x86/bugs: Use SBPB in __write_ibpb() if applicable
  x86/bugs: Fix RSB clearing in indirect_branch_prediction_barrier()
  x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
  x86/bugs: Don't fill RSB on context switch with eIBRS
  x86/bugs: Add RSB mitigation document

 Documentation/admin-guide/hw-vuln/index.rst |   1 +
 Documentation/admin-guide/hw-vuln/rsb.rst   | 241 ++++++++++++++++++++
 arch/x86/entry/entry.S                      |   9 +-
 arch/x86/include/asm/nospec-branch.h        |  12 +-
 arch/x86/kernel/cpu/bugs.c                  | 109 +++------
 arch/x86/mm/tlb.c                           |   6 +-
 6 files changed, 291 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/admin-guide/hw-vuln/rsb.rst

-- 
2.48.1


