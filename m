Return-Path: <kvm+bounces-71704-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4O0jIgIpnmn5TgQAu9opvQ
	(envelope-from <kvm+bounces-71704-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE7F18D8BD
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9512B30B9BC4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 22:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D073AEF3F;
	Tue, 24 Feb 2026 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgsKovIz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED793AE6E2;
	Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771972472; cv=none; b=s3dJm5j/tb8hqdbhIYr39Dxv+TuQkEzKN5/zSXdyg8iUQOt+vx3GeteDpWiI3tq2GzEQqWuuHQVy3acx0/b5Kc5S/0azhPNZco3oWuLOAbS4sUMBF+67dTZ0Yf+BnObMlRklt+rQkjN4qXkcSNHnMfFZDjjctd8ZuLlS0ksSxus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771972472; c=relaxed/simple;
	bh=iE/e2/DcJolfWaFpaNXrD2k53hM94zPMsuIvNRn7BlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvQyvfTKzyPQnqzCPYzPjhuAAHVqUyuODvrqcjZDxsiPlrGn87gI+dvSsU+9kW/f+hJN1jfuR/mI/53zIu0eIjdRZkPdR3ywspLwplLFfMTdUEHmIujIDVQu/E8+YiN1NL/51izmGbTYGsqhjKmr3yWk786GYbHzEaIiMmzQOH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgsKovIz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0B5C19423;
	Tue, 24 Feb 2026 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771972472;
	bh=iE/e2/DcJolfWaFpaNXrD2k53hM94zPMsuIvNRn7BlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgsKovIzcan0SWOAK88n1VBFRnDb2G98wYW+sTFWGcPvBJzchk3i8u95BRpUw7+k3
	 QJv1Io6Sa0Kob0ucd2D7Wpf0tTvkUXmui7lNBT58y8ylf8v2EgRkAN+bwnOgHVTQBc
	 HEX2mj2dQAV0QbZujAXOk91SHhcb7xwRJLTfL79aQlHB/aOKh3YUKzzdvGaR44ZxH2
	 yBMDxtpi+SSCkwg26xZZ1LWuSg2b50WMwTqGuJSHJITqjmr+VAIlU/YMtWui3M6ceh
	 96PV5bk8XZIJo1lMYc6qvsnRkTezhkOVCW51d3KhlC/R9KKK7w69YTfHdsFNQSw3Ke
	 4efM30TsITnDg==
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v6 28/31] KVM: nSVM: Sanitize TLB_CONTROL field when copying from vmcb12
Date: Tue, 24 Feb 2026 22:34:02 +0000
Message-ID: <20260224223405.3270433-29-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260224223405.3270433-1-yosry@kernel.org>
References: <20260224223405.3270433-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-71704-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5BE7F18D8BD
X-Rspamd-Action: no action

The APM defines possible values for TLB_CONTROL as 0, 1, 3, and 7 -- all
of which are always allowed for KVM guests as KVM always supports
X86_FEATURE_FLUSHBYASID. Only copy bits 0 to 2 from vmcb12's
TLB_CONTROL, such that no unhandled or reserved bits end up in vmcb02.

Note that TLB_CONTROL in vmcb12 is currently ignored by KVM, as it nukes
the TLB on nested transitions anyway (see
nested_svm_transition_tlb_flush()). However, such sanitization will be
needed once the TODOs there are addressed, and it's minimal churn to add
it now.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 arch/x86/include/asm/svm.h | 2 ++
 arch/x86/kvm/svm/nested.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index c169256c415fb..16cf4f435aebd 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -182,6 +182,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define TLB_CONTROL_MASK GENMASK(2, 0)
+
 #define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
 #define ERAP_CONTROL_CLEAR_RAP BIT(1)
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 28a8bfc632ef5..d7c353ac42d88 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -502,7 +502,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
 	to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
 	to->tsc_offset          = from->tsc_offset;
-	to->tlb_ctl             = from->tlb_ctl;
+	to->tlb_ctl             = from->tlb_ctl & TLB_CONTROL_MASK;
 	to->erap_ctl            = from->erap_ctl;
 	to->int_ctl             = from->int_ctl;
 	to->int_vector          = from->int_vector;
-- 
2.53.0.414.gf7e9f6c205-goog


