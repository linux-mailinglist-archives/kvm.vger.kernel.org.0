Return-Path: <kvm+bounces-66326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A8ACCFAEC
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 665B430F9546
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17224327214;
	Fri, 19 Dec 2025 11:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ouaaDgrJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ePPflok1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ouaaDgrJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ePPflok1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC852327202
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144641; cv=none; b=X0EY3lFBbE3zYklTI7WREg6tTqgSEnYb/EvJ2YPxkqwcnC9LW1QdU16+GmDmQJXyGp3PdKCXY08zJAhlDhWaNbXM0LX8x/6QSISfYb6jDFZfoD4WJjObZmKazIQ9JO6KtfBXHyc1JNxWwbJgQS15GfvqudhqdOT04ZccDNebhjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144641; c=relaxed/simple;
	bh=nvs45k15qSAWwP1D7aAueT0+dvZrviq0GNvjz2sG5tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GShPvFccLPb2zNk997yPpIpJOq7uVS/DJXey5G0x4iEpkd1sLfSxADjmu1v6RL1aCEuMjrDfhUjY85/5sYPSLJCTFC5jDi/hwBUlQ7ry43Y1Wc+MyopNESf3+OEvVnfBcGuSBnCSnV6iAb19GkaQEV3UbNrH/ewah/Gwdo1BDDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ouaaDgrJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ePPflok1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ouaaDgrJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ePPflok1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91E5333724;
	Fri, 19 Dec 2025 11:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tO0WDPTe4/z8U6jBoNRvL38G7tChL/kSg8GOpQTpU0Y=;
	b=ouaaDgrJhWYJrOMuYVP1uwQiiSOvcWJIXX0soTbMu8DSGUHSo4FtqztSJ3lDhFHmptAyoq
	btODCkRJnlEk9qgXQHNusEQb1SnCSM+lqdw1Z81IAXuTC/b9f+WU90qirAgNMdY+BuAkvE
	KbpOzMuOVi+ZelM9hs6LiMqfiyUW5bE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tO0WDPTe4/z8U6jBoNRvL38G7tChL/kSg8GOpQTpU0Y=;
	b=ePPflok1V4RIc68JZYKYuWHt+D6wuVKaCy/E25PEi+aX97okqK4HMkf4s8EBjs98kEjxLW
	heD/Q4rweAUz3DCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tO0WDPTe4/z8U6jBoNRvL38G7tChL/kSg8GOpQTpU0Y=;
	b=ouaaDgrJhWYJrOMuYVP1uwQiiSOvcWJIXX0soTbMu8DSGUHSo4FtqztSJ3lDhFHmptAyoq
	btODCkRJnlEk9qgXQHNusEQb1SnCSM+lqdw1Z81IAXuTC/b9f+WU90qirAgNMdY+BuAkvE
	KbpOzMuOVi+ZelM9hs6LiMqfiyUW5bE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tO0WDPTe4/z8U6jBoNRvL38G7tChL/kSg8GOpQTpU0Y=;
	b=ePPflok1V4RIc68JZYKYuWHt+D6wuVKaCy/E25PEi+aX97okqK4HMkf4s8EBjs98kEjxLW
	heD/Q4rweAUz3DCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3AD43EA63;
	Fri, 19 Dec 2025 11:43:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGHcOGw6RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:40 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Subject: [PATCH 4/6] KVM: SEV: use mutex guard in sev_mem_enc_unregister_region()
Date: Fri, 19 Dec 2025 12:41:59 +0100
Message-ID: <20251219114238.3797364-5-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251219114238.3797364-1-clopez@suse.de>
References: <20251219114238.3797364-1-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.26
X-Spam-Level: 
X-Spamd-Result: default: False [-3.26 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.803];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLtm3bmjtwwfkzb5ddzerbmdsq)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]

Simplify the error paths in sev_mem_enc_unregister_region() by using a
mutex guard, allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 253f2ae24bfc..47ff5267ab01 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2746,35 +2746,25 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 				  struct kvm_enc_region *range)
 {
 	struct enc_region *region;
-	int ret;
 
 	/* If kvm is mirroring encryption context it isn't responsible for it */
 	if (is_mirroring_enc_context(kvm))
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	guard(mutex)(&kvm->lock);
 
-	if (!sev_guest(kvm)) {
-		ret = -ENOTTY;
-		goto failed;
-	}
+	if (!sev_guest(kvm))
+		return -ENOTTY;
 
 	region = find_enc_region(kvm, range);
-	if (!region) {
-		ret = -EINVAL;
-		goto failed;
-	}
+	if (!region)
+		return -EINVAL;
 
 	sev_writeback_caches(kvm);
 
 	__unregister_enc_region_locked(kvm, region);
 
-	mutex_unlock(&kvm->lock);
 	return 0;
-
-failed:
-	mutex_unlock(&kvm->lock);
-	return ret;
 }
 
 int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
-- 
2.51.0


