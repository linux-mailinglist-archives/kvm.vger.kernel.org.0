Return-Path: <kvm+bounces-57992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FA1B841B6
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8854758715C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4723B221FD2;
	Thu, 18 Sep 2025 10:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ht73uFWH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659D12F3614
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191417; cv=none; b=KOTbVg1phl/rwLlAbfLa5GX6x5Ac2Wz9kDLx92r04Y18Jwd13U9N4V3LbfI+sa+PD27mOfEOpVQrZefA+zzPyafmGtgHEaGaAF3Z4J0gk5KL+r7js7xjKIiYwRn0ISxmBarVdDOdkFnj6SwPeg00ndq37Jx/LGGeqA1VXQcG6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191417; c=relaxed/simple;
	bh=/t/seh31KV2q7u6Vwfa5Gxj43/rdwqpf1rIihSlnvCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E+lAcNp+NxPjIlPf1pmAJzRPInjW1Ey5zQLIq/OLhS4mkMI+qk2bg9U/BaVAhMP6MWBJS23cb1jvJE+sZP+6q9HjWNiIrKsvc+D3s1aMS4+oxJLK9DCjLL0/CzYxMTm/rcENr8qYbyYScHPWjtKDnb4bIjYXJDMskvunz5xIY/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ht73uFWH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B65C4CEEB;
	Thu, 18 Sep 2025 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191415;
	bh=/t/seh31KV2q7u6Vwfa5Gxj43/rdwqpf1rIihSlnvCQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ht73uFWHumP9sqZf0Q6V5C3CalsbAfdhf5abUfVeZG3a3V8fqTd/WashvS2gg0W7P
	 19m9SI8rqK/iAkzVy4igdtwCxUgv8s1NogzXzwuBy+Y8lDRUyj79iGdUOAR+nk4ubH
	 sEsutPxzp7i7FahkkYpt3NKvyBWxT9/hIuqPKQtqSk2vJPBhKe3U+xsOW3r6dc8IQp
	 9dQYawVxDykXH7pW0FgYUsYaQ8MQ5Y3XAyPpEn1SrZ0oQ0aQsecepMmQAcFEdXg4D6
	 Bz6AasXbVuJRoxEP+2ISNeNqjMYEeb32vBh3zh70Bqo3sa0+p5vyzi0R8d0YrcpS0f
	 OmCqP/EDQygdQ==
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
Subject: [PATCH 0/8] target/i386: SEV: Add support for enabling VMSA SEV features
Date: Thu, 18 Sep 2025 15:56:58 +0530
Message-ID: <cover.1758189463.git.naveen@kernel.org>
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

Changes since RFC (http://lkml.kernel.org/r/cover.1757589490.git.naveen@kernel.org):
- Split the first patch up into the initial three patches (Tom)
- Fix up indents in qom.json (Markus)
- Drop Secure-AVIC flag enablement pending KVM enablement (Tom)
- Collect Tom's reviewed-by tag for patch 4


- Naveen

Naveen N Rao (AMD) (8):
  target/i386: SEV: Generalize handling of SVM_SEV_FEAT_SNP_ACTIVE
  target/i386: SEV: Ensure SEV features are only set through qemu cli or
    IGVM
  target/i386: SEV: Consolidate SEV feature validation to common init
    path
  target/i386: SEV: Validate that SEV-ES is enabled when VMSA features
    are used
  target/i386: SEV: Add support for enabling debug-swap SEV feature
  target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
  target/i386: SEV: Add support for enabling Secure TSC SEV feature
  target/i386: SEV: Add support for setting TSC frequency for Secure TSC

 target/i386/sev.h |   4 +-
 target/i386/sev.c | 126 ++++++++++++++++++++++++++++++++++++++++------
 qapi/qom.json     |  16 +++++-
 3 files changed, 128 insertions(+), 18 deletions(-)


base-commit: 6a9fa5ef3230a7d51e0d953a59ee9ef10af705b8
-- 
2.51.0


