Return-Path: <kvm+bounces-58729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3996B9EA4F
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF0864C782D
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8FE2EAB93;
	Thu, 25 Sep 2025 10:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOwFSbMf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED66C2EA729
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796075; cv=none; b=LHXzz4GQ8MD8BUwmTzD/tT9TUg6X6LESf8A3eJ4SkRvNGLy3e4UfEHucjH6W+G5prJIWKpaoUNES2ezOqRpqMdCPvBGyFwQMqakNWBMikH+V6Z2+1hiqFwel3FPBEBlzqTE3tYB3HFLbtWqn3X13NZSFNnNxlVFSWDlam5FTKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796075; c=relaxed/simple;
	bh=9aHXXx+1F5HOMtyaoplqvf/ofDWhN91Htcmm6SX+cpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ucYyEKI2qB8autgO4KBzHSoAHlk/h2R/X5auP21ZeRGQnxM/fJJ5s1WPFr+ii3bOvTTVPouO8UZwMcVu49gDahmY4SFeTlyfSVRCpMcfs/HZuaxLZlgzzFQLuJ1HDoSPvSVtqV6bs9PLudJ3BhozQ1xikY7d7DNQn03MAoG/NRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOwFSbMf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8B9C4CEF0;
	Thu, 25 Sep 2025 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758796074;
	bh=9aHXXx+1F5HOMtyaoplqvf/ofDWhN91Htcmm6SX+cpM=;
	h=From:To:Cc:Subject:Date:From;
	b=lOwFSbMfuBFxtrZiLZCjDS/WFCgU/qZZQQBiUgVw5AIz8UZx3BvL9g6+Ot8XXmnmc
	 0i6CpbdB+s5uvYjbJMQrsFwid6iumMGoiWfEXngFxFLRjYoXHDXIqy9IfgZDauPRER
	 2ZBpAP6vjNNczCV+BBmusRvvMLxy5wlfYGtViy2xjJuVcQHrWE5miJ7CFeohKrBaB3
	 3JPD3LkritE5WeDH3n+NmWxS3+OhZOGlnu9MlSX+pTcCrLY4+VgF2jdaGj4Q7iOIK0
	 5fHJkmoITER3YWlcq6CxyqAhdpki36GJ3P/Qv1Hl7FKQ8mba6VEGf01woqCTBdRiUO
	 ea36qa4iQxoxQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [PATCH v2 0/9] target/i386: SEV: Add support for enabling VMSA SEV features
Date: Thu, 25 Sep 2025 15:47:29 +0530
Message-ID: <cover.1758794556.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for enabling VMSA SEV features for SEV-ES and
SEV-SNP guests. Since that is already supported for IGVM files, some of
that code is moved to generic path and reused.

Debug-swap is already supported in KVM today, while patches for enabling
Secure TSC have been accepted for the upcoming kernel release.

Roy,
I haven't been able to test IGVM, so would be great if that is tested to 
confirm there are no unintended changes there.

Changes since v1 (*):
- Move patch enabling use of KVM_SEV_INIT2 for SEV-ES guests before 
  patch enabling use of debug-swap VMSA SEV feature (Tom)
- Only issue KVM_SET_TSC_KHZ if user has specified a tsc-frequency for 
  Secure TSC (Tom)
- Patch 9/9 is new and refactors check_sev_features in preparation for 
  future SEV feature support (Tom)
- Minor updates to commit log and comments (Tom)
- Collect review tags from Tom

(*) http://lkml.kernel.org/r/cover.1758189463.git.naveen@kernel.org


- Naveen

Naveen N Rao (AMD) (9):
  target/i386: SEV: Generalize handling of SVM_SEV_FEAT_SNP_ACTIVE
  target/i386: SEV: Ensure SEV features are only set through qemu cli or
    IGVM
  target/i386: SEV: Consolidate SEV feature validation to common init
    path
  target/i386: SEV: Validate that SEV-ES is enabled when VMSA features
    are used
  target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
  target/i386: SEV: Add support for enabling debug-swap SEV feature
  target/i386: SEV: Add support for enabling Secure TSC SEV feature
  target/i386: SEV: Add support for setting TSC frequency for Secure TSC
  target/i386: SEV: Refactor check_sev_features()

 target/i386/sev.h |   4 +-
 target/i386/sev.c | 170 +++++++++++++++++++++++++++++++++++++---------
 qapi/qom.json     |  16 ++++-
 3 files changed, 155 insertions(+), 35 deletions(-)


base-commit: 95b9e0d2ade5d633fd13ffba96a54e87c65baf39
-- 
2.51.0


