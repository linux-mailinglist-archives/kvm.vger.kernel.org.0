Return-Path: <kvm+bounces-37138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90128A2610A
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 18:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DAA318877BB
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 17:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC1320D4E1;
	Mon,  3 Feb 2025 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/rXVJDi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA120C489;
	Mon,  3 Feb 2025 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738602619; cv=none; b=nsvDpWkx9cgdUkmWQDZ4FxFhCc2TFleIKwJi6uCxF9Hiz5Yzc5+DvRLWltvuow+ytE0K4QmvtuVr3eCRjdlWEim+uhDdvYYArtnpLs0Z66fiPq9i12h5lqMjgfkzr8IHvWfA7zqimcqM7hPpjMGR+wUgtWmxo83hox87DMNRjdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738602619; c=relaxed/simple;
	bh=utjwF5TAI1j+BW8lJ183o8CpV+JJKwbc0qtJfMxaU7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV2DiIslpFmMnDhYMcc1ZrokrVZi3pU4kEl9peu7fCvt1OMR3apCl3lkny3q1bJM5B9/6SjJtIYfa7U0x6J+unRVSTDXjwfTPyVLKwTyBoB5iHX6cWvWE1gxwhRQQHYYx7gWMYCaeIuRLVLn8kRC9bnIH7/OD7mA8fUuW/I6cfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/rXVJDi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1C6C4CED2;
	Mon,  3 Feb 2025 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738602618;
	bh=utjwF5TAI1j+BW8lJ183o8CpV+JJKwbc0qtJfMxaU7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/rXVJDiVYAu4dnomSCrmBgsng1ay7cGe6tW9UPQwrT+9PSZpXTEhsvMR7dfEa+4x
	 Ul7hlsp0nO+w4nLDRJ0ClMAJLVaQU8q0tFjcsabzK1V/+bI9htS+iEtSDxSd8Ix2Tu
	 CrcOIpU0YhhWKfowxpEe71hp6QUOs8+Zre0kOcUCAGUk/WoQ8Tcb76DRV1jdum+caE
	 ClUah/P5bDlnmI68sVtR3SzvDR5CJAsqeQiRegINUKszQ4BF6yostibJEeZsx7Ahay
	 2HhBZufoKwPTxPozryw0cvK2W35EREpHZB4BriliHQxMomCyrO5ycTAMnKsuTPvq91
	 47AQmaNQjSUHw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 1/3] KVM: x86: hyper-v: Convert synic_auto_eoi_used to an atomic
Date: Mon,  3 Feb 2025 22:33:01 +0530
Message-ID: <3d8ed6be41358c7635bd4e09ecdfd1bc77ce83df.1738595289.git.naveen@kernel.org>
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

apicv_update_lock is primarily meant for protecting updates to the apicv
state, and is not necessary for guarding updates to synic_auto_eoi_used.
Convert synic_auto_eoi_used to an atomic and use
kvm_set_or_clear_apicv_inhibit() helper to simplify the logic.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  7 ++-----
 arch/x86/kvm/hyperv.c           | 17 +++++------------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..fb93563714c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1150,11 +1150,8 @@ struct kvm_hv {
 	/* How many vCPUs have VP index != vCPU index */
 	atomic_t num_mismatched_vp_indexes;
 
-	/*
-	 * How many SynICs use 'AutoEOI' feature
-	 * (protected by arch.apicv_update_lock)
-	 */
-	unsigned int synic_auto_eoi_used;
+	/* How many SynICs use 'AutoEOI' feature */
+	atomic_t synic_auto_eoi_used;
 
 	struct kvm_hv_syndbg hv_syndbg;
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6a6dd5a84f22..7a4554ea1d16 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -131,25 +131,18 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
 	if (auto_eoi_old == auto_eoi_new)
 		return;
 
-	if (!enable_apicv)
-		return;
-
-	down_write(&vcpu->kvm->arch.apicv_update_lock);
-
 	if (auto_eoi_new)
-		hv->synic_auto_eoi_used++;
+		atomic_inc(&hv->synic_auto_eoi_used);
 	else
-		hv->synic_auto_eoi_used--;
+		atomic_dec(&hv->synic_auto_eoi_used);
 
 	/*
 	 * Inhibit APICv if any vCPU is using SynIC's AutoEOI, which relies on
 	 * the hypervisor to manually inject IRQs.
 	 */
-	__kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
-					 APICV_INHIBIT_REASON_HYPERV,
-					 !!hv->synic_auto_eoi_used);
-
-	up_write(&vcpu->kvm->arch.apicv_update_lock);
+	kvm_set_or_clear_apicv_inhibit(vcpu->kvm,
+				       APICV_INHIBIT_REASON_HYPERV,
+				       !!atomic_read(&hv->synic_auto_eoi_used));
 }
 
 static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
-- 
2.48.1


