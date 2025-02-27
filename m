Return-Path: <kvm+bounces-39425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89AC9A47090
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A693A7044
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3E128373;
	Thu, 27 Feb 2025 00:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7yuKGcB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7316270042
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740617638; cv=none; b=WHxdjmGIAx3SJA6JoYzKKQ4B3XNu70mnkxL1FgkPnB1sKTD/x/mbK/ZD7UHglPcnuI/GUOHUcvByd94HcVHR5C/TPt3USVxatzPscFdmoGXm4MmQMDYezERCm33nzgzWDDtp8ltVpk6j+DVIuHuuNPa5izgEEWomKs5s7IiD5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740617638; c=relaxed/simple;
	bh=hnNjM79mm1Ukma7nk1LTyfW5jRqHea0/AuBBXbmbBW4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o5m/hFY5GxvQuybioxT1BfnxCJn0D89GBza9KlZ0lxOJBlxB8XCvREvCQ5Z8GXlYCJE2usG7vHsPBulKTsFnQM3BDmh11D1PiJ03upLKD+I2CZD8EKRYwfGNAO7q/MN7pBokKkzx2TT1B7J85d5gYImUvthoAsRr5tCPAR0N49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7yuKGcB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22350e4b7baso4073595ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740617636; x=1741222436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+etY2CwjqBwAK6Hx5ncpi27ffF6S3xqkUYaVvoUqScA=;
        b=i7yuKGcBZzhhramdsI0llDjar1TQYNrgHXomLJx/I7G8GeX0Wc9y6VA1SgwvwQxaTW
         FgVgRT+8L8gsDGIYFhbwd7ciZ0J+jzU9FpxtaJm9waEFoPBfiR/C1OjETDaA+f7wEIb8
         lzfoXA5QmKj8GGFqKX3ijac6hji7T+5bZhas0h7R/sG76JCExVWI5lVz1y0kKgpXH5R0
         s5EmyxtAgH2ew1TiNf6L//oR+s/ORa6wFL+nzIO01zpaWDqtT7GiIXl0T1rNcgdeyrRL
         b2AUfdUZDHq4DFA1XbXpOHYya5GhycOf2E9cIYUzjuQEn3cnx/QO3DXVX55KTBb9uiQA
         L6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740617636; x=1741222436;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+etY2CwjqBwAK6Hx5ncpi27ffF6S3xqkUYaVvoUqScA=;
        b=MPWvANCDdwZ9FbHCSfBvvvHjsO5LfFD3gAydvsYeUirongr5avtqhde0oyv/smPErN
         x9xMYsSJB9pC1cWirlc3ccIkTLPqshdwocjP2VcGsRfGWqSg2KNv7ddvfrW34ZojznoT
         d8HVXAYr60TVtUCBJwwolBo6VgwhNUNG4bMd+pXU76zSu5L4Pi4xmK6CE+aPmHYSiFkR
         OveiJHl+FsUblRco0sq7N5euN13VwI09fh2IaqTonlXyFb93Iwj/JA176EG6JgnsxpqZ
         8QtMuZihKmEw2jdQA9ev0qNyATfdxcZVt9WxLU1fbKZJwiX3aydVvol5yz6APWe/Uhk+
         GVxg==
X-Gm-Message-State: AOJu0Yzqt40vVusdQ2kmRk3Zbw5DBAKtim183S+Xte9jubRD4BZhrOzr
	2DGyh0z6N6hcRhx/9OZ4sB05BwHCXEqyLxnlf1Nhdv9/ebb11Gqu3RZGwyUcpz9Ba4UxRVqSaBu
	Cvw==
X-Google-Smtp-Source: AGHT+IFAGlSFb6vxw6t08FFVj1P9iXRFuf7eY8Yt2XENxkd5K+QLYD1u+86cXFrRf0pvBHh2r9kyK08oChs=
X-Received: from pjc6.prod.google.com ([2002:a17:90b:2f46:b0:2fa:2891:e310])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41d0:b0:21f:ba77:c45e
 with SMTP id d9443c01a7336-22307e791f2mr132253655ad.45.1740617636044; Wed, 26
 Feb 2025 16:53:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 16:53:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227005353.3216123-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Extract checks on entry/exit control pairs to a
 helper macro
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Extract the checking of entry/exit pairs to a helper macro so that the
code can be reused to process the upcoming "secondary" exit controls (the
primary exit controls field is out of bits).  Use a macro instead of a
function to support different sized variables (all secondary exit controls
will be optional and so the MSR doesn't have the fixed-0/fixed-1 split).
Taking the largest size as input is trivial, but handling the modification
of KVM's to-be-used controls is much trickier, e.g. would require bitmap
games to clear bits from a 32-bit bitmap vs. a 64-bit bitmap.

Opportunistically add sanity checks to ensure the size of the controls
match (yay, macro!), e.g. to detect bugs where KVM passes in the pairs for
primary exit controls, but its variable for the secondary exit controls.

To help users triage mismatches, print the control bits that are checked,
not just the actual value.  For the foreseeable future, that provides
enough information for a user to determine which fields mismatched.  E.g.
until secondary entry controls comes along, all entry bits and thus all
error messages are guaranteed to be unique.

To avoid returning from a macro, which can get quite dangerous, simply
process all pairs even if error_on_inconsistent_vmcs_config is set.  The
speed at which KVM rejects module load is not at all interesting.

Keep the error message a "once" printk, even though it would be nice to
print out all mismatching pairs.  In practice, the most likely scenario is
that a single pair will mismatch on all CPUs.  Printing all mismatches
generates redundant messages in that situation, and can be extremely noisy
on systems with large numbers of CPUs.  If a CPU has multiple mismatches,
not printing every bad pair is the least of the user's concerns.

Cc: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 48 +++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71392989609..678c91762dc9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2582,6 +2582,34 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
+#define vmx_check_entry_exit_pairs(pairs, entry_controls, exit_controls)	\
+({										\
+	int i, r = 0;								\
+										\
+	BUILD_BUG_ON(sizeof(pairs[0].entry_control) != sizeof(entry_controls));	\
+	BUILD_BUG_ON(sizeof(pairs[0].exit_control)  != sizeof(exit_controls));	\
+										\
+	for (i = 0; i < ARRAY_SIZE(pairs); i++) {				\
+		typeof(entry_controls) n_ctrl = pairs[i].entry_control;		\
+		typeof(exit_controls) x_ctrl = pairs[i].exit_control;		\
+										\
+		if (!(entry_controls & n_ctrl) == !(exit_controls & x_ctrl))	\
+			continue;						\
+										\
+		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, "		\
+			     "entry = %llx (%llx), exit = %llx (%llx)\n",	\
+			     (u64)(entry_controls & n_ctrl), (u64)n_ctrl,	\
+			     (u64)(exit_controls & x_ctrl), (u64)x_ctrl);	\
+										\
+		if (error_on_inconsistent_vmcs_config)				\
+			r = -EIO;						\
+										\
+		entry_controls &= ~n_ctrl;					\
+		exit_controls &= ~x_ctrl;					\
+	}									\
+	r;									\
+})
+
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
@@ -2593,7 +2621,6 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u32 _vmentry_control = 0;
 	u64 basic_msr;
 	u64 misc_msr;
-	int i;
 
 	/*
 	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
@@ -2697,22 +2724,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_vmentry_control))
 		return -EIO;
 
-	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
-		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
-		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
-
-		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
-			continue;
-
-		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
-			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
-
-		if (error_on_inconsistent_vmcs_config)
-			return -EIO;
-
-		_vmentry_control &= ~n_ctrl;
-		_vmexit_control &= ~x_ctrl;
-	}
+	if (vmx_check_entry_exit_pairs(vmcs_entry_exit_pairs,
+				       _vmentry_control, _vmexit_control))
+		return -EIO;
 
 	/*
 	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they

base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


