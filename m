Return-Path: <kvm+bounces-42965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56DC2A817D9
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 23:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D990D425995
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 21:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 114502561DC;
	Tue,  8 Apr 2025 21:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPkXl8P2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFE2255E38;
	Tue,  8 Apr 2025 21:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744148884; cv=none; b=gG9iIb480abHj+RIm1fPbAwV3/qIuZ5sL8qsU6sseGCYmEr6xjUzZBZDGngUyuXFBPCPCl1VvgEEbKufXpYaCTb8TrMkeC608UaNL8Nw0o2jXizQh5jHIQ/KhKry59Zo+q4dd2mXeGU7RnDCmV9jGJxNzPs2H8XRaqhWW3j/kuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744148884; c=relaxed/simple;
	bh=onU3+ECl+OTDa1KAxjJzsuEBWFm7MzPnUVp8eNwUSvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBIwhQ/SRyHQ4yxzReAHZQqpPQHsMaj0IymLHmlpMEGZI45vEq95BZpgxZmOFyG30sKlgN25j+x+Sc6/HPZDpYFPGA0X/mJ9be/RsOiFqmkZKY/2KBGMHudcdZL1T5DM3MdJAAYhLnC0CWPRdeqEvU11LMX57LquSnSZ0X/j8nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPkXl8P2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB83EC4CEEF;
	Tue,  8 Apr 2025 21:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744148883;
	bh=onU3+ECl+OTDa1KAxjJzsuEBWFm7MzPnUVp8eNwUSvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPkXl8P2dBfNOLAb+hcnyOiRDwVkaDoCb0KWaDSOKYUZWRwUUwt89ookLdGneY+3q
	 acUAn9cKlMDMSccEKpzaaSFen8T9fZ8wOdu91YBsHcl2DRH8cH9S99bQOCNLxcDHnD
	 OImLbZOYHt3/OrSDib/k9IShd1kP9FjKyybpX+nwqdvax126CTisztVCiOrOe9DkHa
	 M3ZM+j1BDGKlMehKcikEIdAFOyafDLkwStirGzSbMOFCgU82fOtM+K2Zqy/vAxB2Tk
	 ghaQl9kvZ9aZLQOfCgzeMgbcie53391Z/00LgX1i97SC9/NJXesYyWRQGt0v7T9NNy
	 Kzv9RuVenjJqA==
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
Subject: [PATCH v4 2/6] x86/bugs: Use SBPB in write_ibpb() if applicable
Date: Tue,  8 Apr 2025 14:47:31 -0700
Message-ID: <17c5dcd14b29199b75199d67ff7758de9d9a4928.1744148254.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1744148254.git.jpoimboe@kernel.org>
References: <cover.1744148254.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

write_ibpb() does IBPB, which (among other things) flushes branch type
predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
has been disabled, branch type flushing isn't needed, in which case the
lighter-weight SBPB can be used.

The 'x86_pred_cmd' variable already keeps track of whether IBPB or SBPB
should be used.  Use that instead of hardcoding IBPB.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/entry/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index cabe65ac8379..175958b02f2b 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -21,7 +21,7 @@
 SYM_FUNC_START(write_ibpb)
 	ANNOTATE_NOENDBR
 	movl	$MSR_IA32_PRED_CMD, %ecx
-	movl	$PRED_CMD_IBPB, %eax
+	movl	_ASM_RIP(x86_pred_cmd), %eax
 	xorl	%edx, %edx
 	wrmsr
 
-- 
2.49.0


