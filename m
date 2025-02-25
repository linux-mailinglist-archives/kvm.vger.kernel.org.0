Return-Path: <kvm+bounces-39114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D8FA44166
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F27EE7A843F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4020526A1B9;
	Tue, 25 Feb 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Npx2DlPh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583EB2698A2
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740491558; cv=none; b=VPwBcI96V7QPdcOup5sKnX8S8+AwVN7HukSceYq90zqv8t6m7wiQ+BQKXkDiRec0uuAJbDomvUrqL++u9yClw0k7sLqUZvbaGudHw6I206n28vMx3BXsz0MaqCDgFOY9wwoJsXNXo7OoPZRKaD4n7VfcWJFLJFVIipMnjG+q2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740491558; c=relaxed/simple;
	bh=04DTe4ZbF8RWqojsW2aRPJDtp4uzdvc7rSSGqG0IRSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+RrAJ3FtXsS3znAhQXc1Vw4HYeW/H1wlIix6ugclVStV6FevkL9k0a2lT2KHTT1hPCpBWE6+c1YdgYVFTXf3wSFdORGTrAqJCYwnrD4Mtlx/TZoliXQCI8CY+BkveWHEq4152XVIe9fMLzueBfiXiGK3WUg409MU0UMcLWC4eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Npx2DlPh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F4FC4CEDD;
	Tue, 25 Feb 2025 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740491557;
	bh=04DTe4ZbF8RWqojsW2aRPJDtp4uzdvc7rSSGqG0IRSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Npx2DlPhd/glu/0z/YOMn8lcfICVM3QjzbqvZI2rZi2xEji/1YWBOpBxl4mZN43ir
	 n4KOk/EsS7+e5qpTzFYXyCh2qloZw1rl0un9KdasosqSI2o2gTiSuV2J1Lyp0wLpVx
	 Y/4Wad04CJzUfL0DKBTVN9f4b4rJcB0ZfObKH14hnBHeS8ow6Vv+DJP62D0dPfIq+M
	 91hPPSwagP1gNIF66cf4sMhTFRc2pYYYzFyV7XvKZm+SBAooOvapQ91w8SP60oBr9R
	 /qcADYdRNROhNYB5qnKLIxEbDJkGx/x4cTwHUhPFhdvWFz6Zlsv2pezX8PVVROrxKx
	 Sege5X/XJUsrg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC kvm-unit-tests PATCH 4/4] x86/apic: Add test for xapic-split
Date: Tue, 25 Feb 2025 16:10:52 +0530
Message-ID: <c13882ced3c713058c9a1ccf425f396319832b5d.1740479886.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740479886.git.naveen@kernel.org>
References: <cover.1740479886.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current apic-split test actually uses x2apic. Rename the same, and
add a separate test for xapic in split irqchip mode.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 x86/unittests.cfg | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index b057b59b1e30..35646e320620 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -7,7 +7,7 @@
 # arch = i386|x86_64
 ##############################################################################
 
-[apic-split]
+[x2apic-split]
 file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
@@ -23,6 +23,13 @@ arch = x86_64
 timeout = 30
 groups = apic
 
+[xapic-split]
+file = apic.flat
+smp = 2
+extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine kernel_irqchip=split
+arch = x86_64
+groups = apic
+
 # Hide x2APIC and don't create a Programmable Interval Timer (PIT, a.k.a 8254)
 # to allow testing SVM's AVIC, which is disabled if either is exposed to the guest.
 [xapic]
-- 
2.48.1


