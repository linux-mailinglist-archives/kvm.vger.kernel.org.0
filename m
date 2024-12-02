Return-Path: <kvm+bounces-32818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4659E0259
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 13:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C54DEB34D66
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA16201277;
	Mon,  2 Dec 2024 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWj3QDTN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C931FE473;
	Mon,  2 Dec 2024 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733141061; cv=none; b=mYg7g1kk9bAI7o6m4MCf/wj8xfOVZ6ncJTyeC7GiGOBcQOB5fPzku+zE4e8wNUD79fIVnGBL2/CTO7X/VthrAsMy60XhSTqsOmyhmkK5JBAhz22GEl7+cXXFQ+8qtK+dnUIBtDy0pVX0zSPDIWknrAwaEAml+ANdb8JjrTdEP84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733141061; c=relaxed/simple;
	bh=vR+qv2NB8nsfTisJ2Ckp7+Knn+5xHm36+cK3KWkfffA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VG3H3IgAtVWRnaOaPRCp0LMm+CEkt8qN+J4hpCLkWSXuJFNae6kZ34zmWrnZlOKBx71y0Zhbqb1Vzt27egOz0BJexZElFTt9Q+YcDLHhxeXSlgmZOXMACJcmqSbhKAsagey3kEFif6GvqPp7m3Ir1xg3sI/AOSP4rs/HZTVPvaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWj3QDTN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB8C4CED1;
	Mon,  2 Dec 2024 12:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733141061;
	bh=vR+qv2NB8nsfTisJ2Ckp7+Knn+5xHm36+cK3KWkfffA=;
	h=From:To:Cc:Subject:Date:From;
	b=iWj3QDTNe+PwJ8oP81ALjCqoWbgddTryiiaccgDAZaqTFCbhAvvJXmypdgPtH8WUU
	 BWNq3xTBt/WES7ZRSv47zejwqH+wdujSk7Yl1oaAgZJTHfFsDpe69496Gm8O+yaTGz
	 PDaRRv0fAGv0bN3gcxPQMDLop2Y+gY/dV3zyuZNanpHRFKq3TstE/fhWGaHUpApXwR
	 HnDBCuMnVEVXqJfTkQIiK52J9QdVC+mnedhAuh7o4Q1vFtV1IqDSt9ErqgJGCqYuZi
	 quRl7ZALadxoXnenRLe7W7LFRwxg34+UKqmZH21ieQYESoYJcndDmPh154bHj2MOtD
	 ESjzdwheEd+yg==
From: Borislav Petkov <bp@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	X86 ML <x86@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH v2 0/4] x86/bugs: Adjust SRSO mitigation to new features
Date: Mon,  2 Dec 2024 13:04:12 +0100
Message-ID: <20241202120416.6054-1-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Hi,

here's the next revision, with hopefully all review feedback addressed.

Changelog:
v1:

https://lore.kernel.org/r/20241104101543.31885-1-bp@kernel.org

Thx.

Borislav Petkov (AMD) (4):
  x86/bugs: Add SRSO_USER_KERNEL_NO support
  KVM: x86: Advertise SRSO_USER_KERNEL_NO to userspace
  x86/bugs: KVM: Add support for SRSO_MSR_FIX
  Documentation/kernel-parameters: Fix a typo in kvm.enable_virt_at_load
    text

 Documentation/admin-guide/hw-vuln/srso.rst      | 10 ++++++++++
 Documentation/admin-guide/kernel-parameters.txt |  2 +-
 arch/x86/include/asm/cpufeatures.h              |  2 ++
 arch/x86/include/asm/msr-index.h                |  1 +
 arch/x86/kernel/cpu/bugs.c                      | 16 +++++++++++++++-
 arch/x86/kernel/cpu/common.c                    |  1 +
 arch/x86/kvm/cpuid.c                            |  2 +-
 arch/x86/kvm/svm/svm.c                          |  6 ++++++
 arch/x86/lib/msr.c                              |  2 ++
 9 files changed, 39 insertions(+), 3 deletions(-)


base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.43.0


