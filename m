Return-Path: <kvm+bounces-31290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 015E19C21BB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4F5E28283E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3079192D89;
	Fri,  8 Nov 2024 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IRfce1ks";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IRfce1ks"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AE11922F8;
	Fri,  8 Nov 2024 16:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082400; cv=none; b=ViqaeDJy7CghNs1wWWM0ppjZd8yT7sptX8Q32qojuLQUGuRBtXi05BXCrSWZoZVgcFuA2OuSob9Edhi/7UNvIOGKajEwj8FdX5/rrWYSG2F8V36UDKHcnjWP8V2LCjlY22hJxEcJGgrTbGD9CrPU8nXO4zhJfK+5mYA4YxaoB3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082400; c=relaxed/simple;
	bh=P16zUvmp9FuP5lZG+UzUVJKJxo1ckRtfTsTaqKlreXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMJ1pbv/eZ8h42l9/HgwS9xbGJCQ8mKM1AjoMveziU5IjOv1AZyXNhXrX/g31oFK/Pf3XZobFV9Fo/R5J0pZGPEW0tdLAiVb3X6OCuTt2mprkh5gXyaFVCSAjCfwl/48kX2hOPFEerkPo6UioQBHK6FFFf7MaUVoXbUmf3uSQ2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IRfce1ks; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IRfce1ks; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7781821F9F;
	Fri,  8 Nov 2024 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731082395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GRTQxAK0mpVhV/3iqi+7fyL9H1Xt6gQVJ4v2YxgK/8U=;
	b=IRfce1ksKVadgpYNw8+DFJCDgVm+iiRhOxCfwuAJ7qIynZSsUB5ft2WeVLfv3jDbDQ1xkv
	lfKt/Y/n8TN6gkNrckU4OueF1zIalryF7Q0qA28z6ZdtNC2/3nbazP9Lkse3Dm5bpKMuVP
	YAsUcuJR8opz1ZjT004wYZVVTKxoFzA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1731082395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GRTQxAK0mpVhV/3iqi+7fyL9H1Xt6gQVJ4v2YxgK/8U=;
	b=IRfce1ksKVadgpYNw8+DFJCDgVm+iiRhOxCfwuAJ7qIynZSsUB5ft2WeVLfv3jDbDQ1xkv
	lfKt/Y/n8TN6gkNrckU4OueF1zIalryF7Q0qA28z6ZdtNC2/3nbazP9Lkse3Dm5bpKMuVP
	YAsUcuJR8opz1ZjT004wYZVVTKxoFzA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14E9213967;
	Fri,  8 Nov 2024 16:13:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ec6UA5s4LmelJwAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 08 Nov 2024 16:13:15 +0000
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
Subject: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
Date: Fri,  8 Nov 2024 17:13:12 +0100
Message-ID: <20241108161312.28365-1-jgross@suse.com>
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

Using a literal 1 instead of RET_PF_RETRY is not nice, fix that.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e853a5fc867..d4a9f845b373 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6157,7 +6157,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		vcpu->stat.pf_spurious++;
 
 	if (r != RET_PF_EMULATE)
-		return 1;
+		return RET_PF_RETRY;
 
 emulate:
 	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
-- 
2.43.0


