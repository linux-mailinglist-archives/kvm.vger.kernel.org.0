Return-Path: <kvm+bounces-56836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECF8B44502
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F01B27BDC1A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0B254654;
	Thu,  4 Sep 2025 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sjMBUInH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D703340DBF
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009142; cv=none; b=U2dxboMA/i2402PHg3wnMeaYHG96oDQsEagU/+Gp/L1fIBId1MjDoUJeQdUGgW7FO5aDtDgFfxDuvUS3MK/SCP+hJw7fJhZl7Osjo7TbmKMkdU+CDetIVaNjZh26PzoKK/veb9Y+RkWU1TOM4YtVo6aAIg8Ihyzq4NKRfy8xnYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009142; c=relaxed/simple;
	bh=XWExoyl3DsudkysvmWVI1Lyi/mSsj1I8CYY5Rpe2Tt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SeWMYzPF6SqC+dI3AbBR36iChNeK8Sfo+d02jNuM1LISWHRGZrUlhE1SoObOwRAuCdJCRTLZSFD2gF3dOEWGwmeR+3tn0C6TAvKyPQRE9v2jaWekgEgRYVRcO/El/bYetAw1Mv9c+HigojfpzcwgF8/Hst1A/Tm3/I4vq36e9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sjMBUInH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2158CC4CEF0;
	Thu,  4 Sep 2025 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009142;
	bh=XWExoyl3DsudkysvmWVI1Lyi/mSsj1I8CYY5Rpe2Tt0=;
	h=From:To:Cc:Subject:Date:From;
	b=sjMBUInHUy+n8DUlBGO9eJdUgV2682Yqf6+oQwl628Uw2sJA7OQymziZ+tESOrfco
	 g7U+lbusi2WlLHJDgMXxjOWdGKLKxrNqKkFAiHD2xbne/WNHgtq5ljRBcCNo8BEK3U
	 VLIW+zUrklFMCi23pAfGXCK47+TBmHWraE+uerd3UuMPdoJQYpmdb2jymXUkv1CLe0
	 RK6T0qbHco3ZHjK8gniUoXyjkRCmFPb1R+j7fxtdGWGtsnnqroqlS4pwU1MttWya0m
	 1CwCaKUzigUqvIFeHfyTVQ35ztloK8MZGAtBlhQWTYz0221aV3r/KjjAUxafr/JVXp
	 ksR5qsEmtqlXA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RFC PATCH v2 0/5] KVM: SVM: Enable AVIC by default on Zen 4+
Date: Thu,  4 Sep 2025 23:30:37 +0530
Message-ID: <cover.1756993734.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2 of the RFC posted here:
http://lkml.kernel.org/r/20250626145122.2228258-1-naveen@kernel.org

I have split up the patches and incorporated feedback on the RFC. This 
still depends on at least two other fixes:
- Reducing SVM IRQ Window inhibit lock contention: 
  http://lkml.kernel.org/r/cover.1752819570.git.naveen@kernel.org
- Fixing TPR handling when AVIC is active: 
  http://lkml.kernel.org/r/cover.1756139678.git.maciej.szmigiero@oracle.com


- Naveen


Naveen N Rao (AMD) (5):
  KVM: SVM: Stop warning if x2AVIC feature bit alone is enabled
  KVM: SVM: Simplify the message printed with 'force_avic'
  KVM: SVM: Move all AVIC setup to avic_hardware_setup()
  KVM: SVM: Move 'force_avic' module parameter to svm.c
  KVM: SVM: Enable AVIC by default from Zen 4

 arch/x86/kvm/svm/svm.h  |  3 ++-
 arch/x86/kvm/svm/avic.c | 48 ++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.c  | 22 +++++++++++++------
 3 files changed, 38 insertions(+), 35 deletions(-)


base-commit: ecbcc2461839e848970468b44db32282e5059925
-- 
2.50.1


