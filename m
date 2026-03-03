Return-Path: <kvm+bounces-72465-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNuAGNUspmncLgAAu9opvQ
	(envelope-from <kvm+bounces-72465-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:35:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 131B11E72B6
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 556143031226
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D153563D4;
	Tue,  3 Mar 2026 00:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPQ5YqMq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C175734888F;
	Tue,  3 Mar 2026 00:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498075; cv=none; b=H2cdDByskqiolu+g25c/xAVhXztkua+OMiYkXc3l8rx3ZHChvOCcDWMv1URf9hjXQSo+oZ5BL4bVVBCCyHn9ZHD75oQxAgAWTRp8GOWK12zP8SBKntoEP/iIxB24HWutgQ1GPio42aia5u2xvU3EL1nTFjMUQoZrin1uEkDt25U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498075; c=relaxed/simple;
	bh=VkfpgkqyrVASRWFgTqoJ+zrG9g4hxcm1sZ6qMUOlIw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwWrLtdqYOlMyAu3Tyf9INSdvy00DsToFv7fSyLX/GdsEBBul2OG3xYsB3ethMqsqXr98kZwRluauj99sfbUiV+nWlAyW4GcF/I4aCfbaVMUAMJUE1NAfeNtIFmd3BquPaxFbQJdA6a6OuT4xJdy8zOwQ1m/2EyFw0svQmNCZXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPQ5YqMq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634CBC2BC9E;
	Tue,  3 Mar 2026 00:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498075;
	bh=VkfpgkqyrVASRWFgTqoJ+zrG9g4hxcm1sZ6qMUOlIw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPQ5YqMq5kAVWLctOu4C7K/9R6VbenvpgTnHxVjVcCXBuLdifNOCQwq0Dz70sjp87
	 76jWeuT1xJmIkDo19oeYOcdnMBmKdql00vk3KYSyxoOCMgChxGbiyDHBhHCunSCBVx
	 GHxIZS9/ZnltXRhX1ur8dzOjJAWbNSOqPU1eUDo4aSRR1jHI85lG4bhu5I4tsAJ0dC
	 Cc5BngjJ4kvBvxjT76/3EhXQjrxNsfDuOQq6G6AChQ7AizNTPJvoAmTkDcpLLzjJKi
	 McT+SE1I9b0B+N813G3P32lPOkPokc7aKJpsFYDwKmXuw03aG8YkaFBxiPQznebnqq
	 cxOhn0ICQvkGg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v7 10/26] KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)
Date: Tue,  3 Mar 2026 00:34:04 +0000
Message-ID: <20260303003421.2185681-11-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260303003421.2185681-1-yosry@kernel.org>
References: <20260303003421.2185681-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 131B11E72B6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72465-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

According to the APM, GIF is set to 0 on any #VMEXIT, including
an #VMEXIT(INVALID) due to failed consistency checks. Clear GIF on
consistency check failures.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bb2cec5fd0434..04ccab887c5ec 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1036,6 +1036,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		vmcb12->control.exit_code    = SVM_EXIT_ERR;
 		vmcb12->control.exit_info_1  = 0;
 		vmcb12->control.exit_info_2  = 0;
+		svm_set_gif(svm, false);
 		goto out;
 	}
 
-- 
2.53.0.473.g4a7958ca14-goog


