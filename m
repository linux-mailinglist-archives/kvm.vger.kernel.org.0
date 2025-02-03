Return-Path: <kvm+bounces-37136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A587A26102
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:11:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCF31162793
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810C120E313;
	Mon,  3 Feb 2025 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqZnS+l6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1620ADE0;
	Mon,  3 Feb 2025 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738602607; cv=none; b=iaIJOo0dStZQngJ7KHuof/K56k9/WMCk5uDEno2x47b/IvBqFnBp59IA/23H47+Sii36IfbAhOfrP6z7JG+2WVTveVbnQBClJE+5QQYhVgkOe70FgDDIczq6/3D5K79/aHVQCMuFPlEWOiD9AHQwYtPs4xh1ZpbipaLxmUMBIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738602607; c=relaxed/simple;
	bh=8Mc+BGP11CmKsckKZSbGP97r2utDifUGHIerjkonr3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbJZIv2jTtKMIaFPRAXaCLHCzbAEnAvWab5n+Ctg8CU8OuMwz3e1Q/i8ga7/KvE4BRaPd3R1feepFsqxMD/Y2QdDUbeDQ3c2LfLylSz5i/x6Qf62l6WczGMuduCT1S6pRgqlVZ/tXXv2bBFvtzmm37878goPH8k1vBYAERgOeC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqZnS+l6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EB4C4CED2;
	Mon,  3 Feb 2025 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738602607;
	bh=8Mc+BGP11CmKsckKZSbGP97r2utDifUGHIerjkonr3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqZnS+l6pbHuEiyP9pxqSMR2PHAi6C/wUU0Xz2rmupE9hcqzw6XnVboLr4PgulDI9
	 6gm+bAj+DZ73mobRhIl6Pe1zawe8S1R4n6uuFqmHuzAzx05+rs89j+iO4LkVQrJjuL
	 VdWrMsB74TMXQ/CpY96E0BVc13V0HOsW3avqAADblVDXhBlOqegIb23A8mGN7PPDC0
	 awOmjrC0x7K5dXRlUKOsqncqJZS1qOpRM9OF382NzYGSx3gnuka+GqwGL1w6uU19hE
	 2ZBW3FvlGBwrvTiWLbqrjSlpeRKWAooIGOLEtX9FYU0jlYC9nlE5W/TCoBxW7fo0xv
	 pMCd3rXHpvyzw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when toggling guest debug state
Date: Mon,  3 Feb 2025 22:33:02 +0530
Message-ID: <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1738595289.git.naveen@kernel.org>
References: <cover.1738595289.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

apicv_update_lock is not required when querying the state of guest
debug in all the vcpus. Remove usage of the same, and switch to
kvm_set_or_clear_apicv_inhibit() helper to simplify the code.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/x86.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..11235e91ae90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12038,19 +12038,14 @@ static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
-	if (!enable_apicv)
-		return;
-
-	down_write(&kvm->arch.apicv_update_lock);
-
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
 			set = true;
 			break;
 		}
 	}
-	__kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
-	up_write(&kvm->arch.apicv_update_lock);
+
+	kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_BLOCKIRQ, set);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-- 
2.48.1


