Return-Path: <kvm+bounces-38646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E00A3D279
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B37B1899592
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C441E9B2E;
	Thu, 20 Feb 2025 07:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gH2iFLqS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942E1E5734;
	Thu, 20 Feb 2025 07:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740037298; cv=none; b=oMHLopruFIc7wPCdtT9DY8ptSSi4Rs5nXbXGahNEE5U850DIvMI6BderADN+4NUpjilHZ6FETPBSzZuPufn0nwtPrmf2JTO7u6y9PtpdA8OkNvJIKP77ePSGQVymu3YejetMdpcgh+RqAEIdG55qhlWgKne837y5/D8/yYjh83o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740037298; c=relaxed/simple;
	bh=8qOPuIrpCkpLTX/ohjxufRRmyg1pZ3CQTJ7DCrnsPWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JVtvcrGwMezMeB5BVIxpnLpG590CpXMD/V9RdTQ4QvKgO2QenETQzjEfJmAADvVN9yyVp2aaSuqE2f93H7w7n6Exri6OVGwc0kXjy9l2ZdjOXrq5/WTNUEFXs4RiOpebgNx+QqAO8LNIUnXawjOkSxpFCCNdIbC3sp5mWZlJ48Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gH2iFLqS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5F5C4CEDD;
	Thu, 20 Feb 2025 07:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740037298;
	bh=8qOPuIrpCkpLTX/ohjxufRRmyg1pZ3CQTJ7DCrnsPWU=;
	h=From:To:Cc:Subject:Date:From;
	b=gH2iFLqSlLCzhuX2Vs8FVRcpai4Ya52i07ivSC1HJbMBEDDx96hxo6xE/QGU+wLWJ
	 cNYtVUjQBweBxXbqN1cXL1i7mdF9TdFiJhyThRdmPDRaMP3t2Zwki6VsXt395iMl9L
	 S1HtIXtqkDvm0ApW2rMnT94DQ3gEU9A7dmTinjKRaK2uWkcCz+nD9JImDmN2JQdKu5
	 +C8EMZnulFydoa3ywzM2RQWJwhaxz3jEn14kufp8tDPEo7/okKaqrLNqD4iukoC4YO
	 YL3U8bLJdp1bJv78qCgzvb7wfWaP7eCdqFYcayZtHB7zlulIIHthsrNbJJHMmITmrH
	 53xTVDcOYgrlQ==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v3 0/2] KVM: SVM: Add support for 4096 vcpus with x2AVIC
Date: Thu, 20 Feb 2025 13:08:01 +0530
Message-ID: <cover.1740036492.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v3 of the series posted at:
http://lkml.kernel.org/r/cover.1738563890.git.naveen@kernel.org

The first patch adds support for up to 4096 vcpus with x2AVIC, while the 
second patch limits the value that is programmed into 
AVIC_PHYSICAL_MAX_INDEX in the VMCB based on the max APIC ID indicated 
by the VMM.

Changes since v2:
- Patch 1: Free allocated pages in avic_vm_destroy()
- Patch 2: Rename x2apic_mode parameter of avic_get_max_physical_id() to 
  just x2apic to avoid build issue with similarly named global variable.


- Naveen


Naveen N Rao (AMD) (1):
  KVM: SVM: Limit AVIC physical max index based on configured
    max_vcpu_ids

Suravee Suthikulpanit (1):
  KVM: SVM: Increase X2AVIC limit to 4096 vcpus

 arch/x86/include/asm/svm.h |  4 ++
 arch/x86/kvm/svm/avic.c    | 82 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.c     |  6 +++
 arch/x86/kvm/svm/svm.h     |  1 +
 4 files changed, 73 insertions(+), 20 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1


