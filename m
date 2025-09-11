Return-Path: <kvm+bounces-57309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C64E7B5318E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 802CD584E3A
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DEF831DDAE;
	Thu, 11 Sep 2025 11:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/FNLQXD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D9031B806
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757591850; cv=none; b=u+PJqrINOHI2m2NPuKG2K8qBk97KUEd/Vyp3uT1SmsPNDdgmntdeoQnXTbNZwGOv77Y7qT3BsQUZeRZhQzGvdemaQsG7gXhttntQISIgDSSGPYx+R2MX5sv1BnrElyKfbJNROLxui6AkmF2BmwYldJh2T/PQCc27rYfZT7GJEqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757591850; c=relaxed/simple;
	bh=CSzllqS1dlwgFiif2Sq7vyEsfYTDBSjBnppZcpm7Kts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V28uN5qjSnqw07S0kItQiUbrmE8h7dWWZw9Dtwg3RvUAmW3ctF9ARnSxFcR8flFOtzNSocOyuj37hJycF/RcOoouT2YDt0GrvUOzpXa6JrbpEg7sL/9CLOM42RoUM+EY38fpbBnuoiTz54MrD/61omL6788FN9r+6TF7Y9XkInQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/FNLQXD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC1BC4CEF0;
	Thu, 11 Sep 2025 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757591850;
	bh=CSzllqS1dlwgFiif2Sq7vyEsfYTDBSjBnppZcpm7Kts=;
	h=From:To:Cc:Subject:Date:From;
	b=Y/FNLQXDGtsiJlinu7l9KyUyYJkq1G+cJWlLoZ8iq90w7B1JE84+n8xezxpWxaxlQ
	 Q0QpWWJMWzt/HLpiSoFht/M+vToiqDc638Cn9K3azU8WhKuxxJSpjXCXMdsqHyErak
	 cr8Ifz+VZJCExKItC61542pKB8wOF8UZa8tu0AwcCXmd4oIaiWPo4hkQ5QAvvf9Ztt
	 djrNXAwatSKfH2cibwVC7QGm7tolEadVSxHf6NOik5UMkMC3n9XY0oU9EDnzRzZlHo
	 oSmWI/A2gd0sRMRhKtKmB8+upB5FqBXXN/MjOZFEYJFDMwBl7p4EZHKgDo3VuN1GeE
	 53ndjSAdqTP7g==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [RFC PATCH 0/7] target/i386: SEV: Add support for enabling VMSA SEV features
Date: Thu, 11 Sep 2025 17:24:19 +0530
Message-ID: <cover.1757589490.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
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
Secure TSC and Secure AVIC have been posted. 


- Naveen



Naveen N Rao (AMD) (7):
  target/i386: SEV: Consolidate SEV feature validation to common init
    path
  target/i386: SEV: Validate that SEV-ES is enabled when VMSA features
    are used
  target/i386: SEV: Add support for enabling debug-swap SEV feature
  target/i386: SEV: Enable use of KVM_SEV_INIT2 for SEV-ES guests
  target/i386: SEV: Add support for enabling Secure TSC SEV feature
  target/i386: SEV: Add support for setting TSC frequency for Secure TSC
  target/i386: SEV: Add support for enabling Secure AVIC SEV feature

 target/i386/sev.h |   5 +-
 target/i386/sev.c | 139 +++++++++++++++++++++++++++++++++++++++++-----
 qapi/qom.json     |  18 +++++-
 3 files changed, 144 insertions(+), 18 deletions(-)


base-commit: 6a9fa5ef3230a7d51e0d953a59ee9ef10af705b8
-- 
2.50.1


