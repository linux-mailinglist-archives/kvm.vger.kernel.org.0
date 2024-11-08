Return-Path: <kvm+bounces-31291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCABA9C21C4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:14:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DE64B24E0F
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C59B192D6A;
	Fri,  8 Nov 2024 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hhT8WW97";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hhT8WW97"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E895146D40;
	Fri,  8 Nov 2024 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082464; cv=none; b=DBrLuoEJLq40BcdsLkTDTXz9NCRY4Jto85M5bkEyHG6QnCcsO/h9wJvB/rhLoB3IdSu6qz637Yqc//WzNISdq2jqKy46RIorXJi2oxG+UeOIGJySCH9xSoWZLySsUlFu0TumJ1k2ThhNc+ok13eEmfknmqv9A4z8Jjo6SHiKe8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082464; c=relaxed/simple;
	bh=3EYmXkYP/Qj/4z/W4YN8vKjr+xc/ULE5FKKshU85Bh4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AioZm5oKLIEQ84WwOwcC+VVnNs7fvyZsFv4Ulx4c9ggimlFjbItifzycAzqSzj5Vkn64XsnsFBjewBrxSHKHcQLdWh6thpP2BBqn3FXbRDIXm3hf/hSzb+n+A9RoBYCBwktmBvp/worzzjAPIED1K7qGBtKksE9wGn7/PwRbfas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hhT8WW97; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hhT8WW97; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B173B1F390;
	Fri,  8 Nov 2024 16:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731082459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KDc8Qe63VDrMDgGXXY09GLl/fVW2SgObjohuMPhXSBA=;
	b=hhT8WW97kelM6FXEq5n5jR2jEj2XR8cMT/JCG4fFxnpvykG229SSk+xDbMr14pkKvHs0dw
	FT0vjVkuxXbBMNdp45/gCFAwQRmgSDYUdKOGnBoz1mgQcqb4nmYF0bpMaBrtF1b3Dezn8R
	ahGBLZfPFbyoa6Mks3nJBfC4SW1IiSo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731082459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=KDc8Qe63VDrMDgGXXY09GLl/fVW2SgObjohuMPhXSBA=;
	b=hhT8WW97kelM6FXEq5n5jR2jEj2XR8cMT/JCG4fFxnpvykG229SSk+xDbMr14pkKvHs0dw
	FT0vjVkuxXbBMNdp45/gCFAwQRmgSDYUdKOGnBoz1mgQcqb4nmYF0bpMaBrtF1b3Dezn8R
	ahGBLZfPFbyoa6Mks3nJBfC4SW1IiSo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A10E13967;
	Fri,  8 Nov 2024 16:14:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6gdxFNs4LmfwJwAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 08 Nov 2024 16:14:19 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM/x86: add comment to kvm_mmu_do_page_fault()
Date: Fri,  8 Nov 2024 17:14:16 +0100
Message-ID: <20241108161416.28552-1-jgross@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On a first glance it isn't obvious why calling kvm_tdp_page_fault() in
kvm_mmu_do_page_fault() is special cased, as the general case of using
an indirect case would result in calling of kvm_tdp_page_fault()
anyway.

Add a comment to explain the reason.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c98827840e07..a49cd0c438a1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -322,6 +322,10 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
+	/*
+	 * With retpoline being active an indirect call is rather expensive,
+	 * so do a direct call in the most common case.
+	 */
 	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
 		r = kvm_tdp_page_fault(vcpu, &fault);
 	else
-- 
2.43.0


