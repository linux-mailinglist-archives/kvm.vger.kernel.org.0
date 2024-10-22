Return-Path: <kvm+bounces-29355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67BF59A9FA4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 886831C22047
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E2519993C;
	Tue, 22 Oct 2024 10:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J+DCi0ow";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J+DCi0ow"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53498145B24;
	Tue, 22 Oct 2024 10:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729591698; cv=none; b=M4OWV5IdoS3iZWy0V83Qf1s8peaxDkM7xLKRMRf6X4LoE39Pxf0HJFNgS3PsG8MOr6fXJ4VkEEALJ4jPVImiZVBLribECvfTrGQRpfDWZcA+rXtUXYygwcF0vw70Be9nCDIeZOT3UmhfHWB7w/G2RfGBSJePflsdlEcBErSQBSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729591698; c=relaxed/simple;
	bh=t6th0mob8gstI1rzG1JnaZ2g9CAZoZsgyiKifgrHybI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mOglSmJjPsCNFqB+JXDEY+YZLvR5D1+OyF5/VzzLMOLIGMvwp8iTtbPBbu45ag+8zRadqeFWiOt35HnQ4pUIoRiaxcdBnDEMpLvUzlEIZn7Nqn0Ul0r6HlAeJhmXzGQbD9YeKuabwNNfZAo75dJ7BhdU7ZQrtBVpwai7mX3mMZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J+DCi0ow; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J+DCi0ow; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7118E1FBAB;
	Tue, 22 Oct 2024 10:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1729591694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WtxN72IlcYz/BWCQ0zqCtJ3Z0vWTVDAayPutpwTk1jo=;
	b=J+DCi0owGnFbR9TWiddOWl3YUiMSGZs9wAdPlpyx22QlhUze6CtwYP5rTa2caDhuYWdfcs
	zYyK9+egFjH+cP597y1+baOKwDXFyukhUEd2WCqgfX+Hv7eHa62qzxQa9cKfeKDo9/26NF
	PYheBobFhIPgfzGFQXoPqQw+UzrYqhk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=J+DCi0ow
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1729591694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WtxN72IlcYz/BWCQ0zqCtJ3Z0vWTVDAayPutpwTk1jo=;
	b=J+DCi0owGnFbR9TWiddOWl3YUiMSGZs9wAdPlpyx22QlhUze6CtwYP5rTa2caDhuYWdfcs
	zYyK9+egFjH+cP597y1+baOKwDXFyukhUEd2WCqgfX+Hv7eHa62qzxQa9cKfeKDo9/26NF
	PYheBobFhIPgfzGFQXoPqQw+UzrYqhk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A97C13894;
	Tue, 22 Oct 2024 10:08:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Lse5BI55F2f4HAAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 22 Oct 2024 10:08:14 +0000
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
Subject: [PATCH] kvm/x86: simplify kvm_mmu_do_page_fault() a little bit
Date: Tue, 22 Oct 2024 12:08:12 +0200
Message-ID: <20241022100812.4955-1-jgross@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7118E1FBAB
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Testing whether to call kvm_tdp_page_fault() or
vcpu->arch.mmu->page_fault() doesn't make sense, as kvm_tdp_page_fault()
is selected only if vcpu->arch.mmu->page_fault == kvm_tdp_page_fault.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c98827840e07..6eae54aa1160 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -322,10 +322,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
-	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
-		r = kvm_tdp_page_fault(vcpu, &fault);
-	else
-		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+	r = vcpu->arch.mmu->page_fault(vcpu, &fault);
 
 	/*
 	 * Not sure what's happening, but punt to userspace and hope that
-- 
2.43.0


