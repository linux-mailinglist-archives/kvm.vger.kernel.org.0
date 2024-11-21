Return-Path: <kvm+bounces-32312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F102F9D53B3
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 21:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A41DB22908
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5921C9B9A;
	Thu, 21 Nov 2024 20:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zq9dPK9n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8775343AA1;
	Thu, 21 Nov 2024 20:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732219648; cv=none; b=q7Y57FGtj2HK4UZBEjFmsstehnZjOKl+WB1AH4lD8oWEqAWF7ZfMi39Fmq+Etk8bdcTfYgTuZALbZY8OTnoPPvSWCfFn/dPf4lccCuITbXAa1TgLy/DOBxjdRbS6eVE5WXjEXo8ioe628FJ5bRtUi7Iu/OCTtsUHMiyZ2EWTpwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732219648; c=relaxed/simple;
	bh=4jqNVkjKXj0tI3VLwwv6dAMuc4AIDX9y3ARmUZS5gXs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aoqEpN3NHtrALos1K2rsO/Y/ugTO5cZIK5ukeCDZjYZHO+FFf2ook3PPHqkQzrhPiPIf1w5tFqJHENYaJ9f0CH8gVVopSJtCD01RCJRj50Uqypuv/y0V57UHoJeXave0poxQIL4tfrDJiMORPKOLuG1xH0eGDkA1YRE8Oci2V0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zq9dPK9n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EECC4CECC;
	Thu, 21 Nov 2024 20:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732219647;
	bh=4jqNVkjKXj0tI3VLwwv6dAMuc4AIDX9y3ARmUZS5gXs=;
	h=From:To:Cc:Subject:Date:From;
	b=Zq9dPK9nsD4ZEYtJyueTZf0T0JkgzhUGG6NkYZV6KgdKGCzDSDY9RxnK2t3Fu8W0W
	 m3nqMrkj0tgQI7rAz5Zfl6/TwFPpfpaOygbDqL9qZjcqlHcbKN+7UKmjtZBuwRufGw
	 spV2dWjrawU/z4v5g5epSRQiHLmsai4m9JLcVQcM5ECUHjVhtOAkekpKM1+lsqxeNh
	 6I6UybZ41nnxct8M+hTMWkUpq3DZCki9SrZ5V/aWwhy6IozEZyZtZCcFOFtj/D4Bhc
	 fVhPHs/wXo73D8DJSiEAYVgSKJhgp5y6IPaW5K/NlScJEv0n7lDnywoHo/b+wjndZ5
	 DMTgCpaeGJ1Og==
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
Subject: [PATCH v2 0/2] x86/bugs: RSB tweaks
Date: Thu, 21 Nov 2024 12:07:17 -0800
Message-ID: <cover.1732219175.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- remove stray whitespace in printk
- clarify patch 2 comment message about prev/next tasks
- move error path to default switch case in spectre_v2_mitigate_rsb()
- add Reviewed-bys

Some RSB filling tweaks as discussed in the following thread:

  [RFC PATCH v2 0/3] Add support for the ERAPS feature
  https://lore.kernel.org/20241111163913.36139-1-amit@kernel.org

Josh Poimboeuf (2):
  x86/bugs: Don't fill RSB on VMEXIT with eIBRS+retpoline
  x86/bugs: Don't fill RSB on context switch with eIBRS

 arch/x86/kernel/cpu/bugs.c | 115 +++++++++++++++----------------------
 arch/x86/mm/tlb.c          |   2 +-
 2 files changed, 48 insertions(+), 69 deletions(-)

-- 
2.47.0


