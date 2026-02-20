Return-Path: <kvm+bounces-71424-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJvRE+7ZmGkSNgMAu9opvQ
	(envelope-from <kvm+bounces-71424-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:02:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C09D416B183
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B88EF301CC4C
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 22:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B604C30F7EA;
	Fri, 20 Feb 2026 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWT8XZeA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F32F3C30;
	Fri, 20 Feb 2026 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771624938; cv=none; b=F9jnaRCnf0tBTny+BU+O/44bTppj+XULlxTwqHsLA6tRm+DHKpxiofPh+qW2zTHwgvj7J06rDhs+mXJavC6BvsD/zYel382r6QxiSxO6Gdda+uOtZQ34kO/f5OLdScFBVdFT7w+2bd6AnspWSGUpoeK/ECk4MRaFnawI/MDLGTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771624938; c=relaxed/simple;
	bh=+TWplxVmvADYMWmiBeKtnOgdg45bWJKpSpSk8iXAv0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mpejNOmZ1MKeGQzj+TMtKPSgMCWOoixCw9Bt1r8noE1cKomheSwqpIic4Eo9mwXlDncoyW2icU1GO9z4+EsFKhrK6fI+oVACSG3m58EtZ/V9/ai4NSRjoSZkmrRm+AX+67rNHJCGtXCh8AEBcCLCRwsXCTojFLigQJbGHnkveIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWT8XZeA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52089C116C6;
	Fri, 20 Feb 2026 22:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771624937;
	bh=+TWplxVmvADYMWmiBeKtnOgdg45bWJKpSpSk8iXAv0s=;
	h=From:To:Cc:Subject:Date:From;
	b=HWT8XZeA7h32O4+4VcP73r6j7DSBCsvI/vekrcP9IFrmU1vqTyVgsbc/9Qpil8IY9
	 qIxL3eEglGtWpvwvKsDLafvadzvA6tU3YDmBhsZg53F3Wj/TTNsqpLUF4mEw3hPGWv
	 YmUKPuODE6p4oIDK8lBksDip7XgIKgiPOHMuuAc4ZnrRBT+d6Lv1JYGqtE9ORcsNLP
	 g8jRw113NoOiBnOzrnl98LlOgDKiynIOaIN9KiY3UQbLzr/qDeNjqowCFgIdHWQYta
	 f0j5zD+u//A7fjHJlwrvWqTfddgeXV6/E0OfVhrn2CIFdPG1DZh+AuqbvW70naiKTi
	 bft0cIVbEkcDg==
From: Namhyung Kim <namhyung@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kvm@vger.kernel.org,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH] KVM: VMX: Fix a wrong MSR update in add_atomic_switch_msr()
Date: Fri, 20 Feb 2026 14:02:16 -0800
Message-ID: <20260220220216.389475-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71424-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[namhyung@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C09D416B183
X-Rspamd-Action: no action

The previous change had a bug to update a guest MSR with a host value.

Fixes: c3d6a7210a4de9096 ("KVM: VMX: Dedup code for adding MSR to VMCS's auto list")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d0d47..83d057cfa8164937 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1149,7 +1149,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 	}
 
 	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
-	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
+	vmx_add_auto_msr(&m->host, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
 }
 
 static bool update_transition_efer(struct vcpu_vmx *vmx)
-- 
2.53.0.371.g1d285c8824-goog


