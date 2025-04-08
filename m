Return-Path: <kvm+bounces-42963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA54A817D5
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9177E4678ED
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02F92550D5;
	Tue,  8 Apr 2025 21:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJJWuO/y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E07824A075;
	Tue,  8 Apr 2025 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148882; cv=none; b=Z+bG03W7xwyEVQf1e4KH1/+yjNVCLXGYwAYkNJrfmtnlnnR/p/hTJUaWu3IxqwMxMGgvLa6JwVK0yJzxxDjRsuwueiNdjIqeNYPxCiO0VYoittMMK3dYX60HK6XMYzVBHO4OeVH4AYzH4yqP/dRf9WtVb2x2Z3kzX8JqiOhRLUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148882; c=relaxed/simple;
	bh=6COeFnaQgN3qls/u+Yq5ZtwKJF9Vw4Z42v5LKtiDZzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PwUUhya6HAcjaZATDMPOUB1H23hzirG3g4UQFOnJqKKj7WZE9wnSpiAXoumYZaM7xumxPwWtq7ya1OnOxHy3DOs0lkj0en8EOSEJSm+SEWeuuLfOTmlTucVWrHgOcmbIcRSu6eg/RGUA4pmQPH5UycoQMPqlkJSgd0WH3aIpKTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJJWuO/y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91CEC4CEE5;
	Tue,  8 Apr 2025 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744148881;
	bh=6COeFnaQgN3qls/u+Yq5ZtwKJF9Vw4Z42v5LKtiDZzk=;
	h=From:To:Cc:Subject:Date:From;
	b=tJJWuO/yEomXExrdB/E8GR2veu7Li5zKPfZ561v3TzNYrIrXjkBDgHGBONCoCCIXh
	 tKkqxCuMgSyWsUWItNFLbhffFGpdwNOSiyKSPiK3rmuAse3fE/uTaAtpyZ40a5wdkG
	 ILvoOT9SSoWc4pdCu2ZBDfKB38X/27ISo7lJY7N1sXRvJos3yTVlnT7h2ILv8Q1/Yw
	 YovlEJMFAuyjNrYRVYCK4X6HvFR7HyAxqHiCX3zBCPIQh6DFVIfv+Sy23ZN/DY41iQ
	 bVvZr5T73h2oCTHTxJAvKsd8rzD3W7+YpEaNpZku69VJD57LcHtDdv3a9T1U9FNk5y
	 mZ4VyqhuiBEew==
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
	andrew.cooper3@citrix.comm,
	nik.borisov@suse.com
Subject: [PATCH v4 0/6] x86/bugs: RSB mitigation fixes and documentation
Date: Tue,  8 Apr 2025 14:47:29 -0700
Message-ID: <cover.1744148254.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4:
- improve document
- remove C++ comment
- "__write_ibpb" -> "write-ibpb"
- improve commit logs

v3: https://lore.kernel.org/cover.1743617897.git.jpoimboe@kernel.org

Josh Poimboeuf (6):
  x86/bugs: Rename entry_ibpb() to write_ibpb()
  x86/bugs: Use SBPB in write_ibpb() if applicable
  x86/bugs: Fix RSB clearing in indirect_branch_prediction_barrier()
  x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
  x86/bugs: Don't fill RSB on context switch with eIBRS
  x86/bugs: Add RSB mitigation document

 Documentation/admin-guide/hw-vuln/index.rst |   1 +
 Documentation/admin-guide/hw-vuln/rsb.rst   | 268 ++++++++++++++++++++
 arch/x86/entry/entry.S                      |   9 +-
 arch/x86/include/asm/nospec-branch.h        |  12 +-
 arch/x86/kernel/cpu/bugs.c                  | 107 +++-----
 arch/x86/mm/tlb.c                           |   6 +-
 6 files changed, 317 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/admin-guide/hw-vuln/rsb.rst

-- 
2.49.0


