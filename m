Return-Path: <kvm+bounces-66324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C75CD008D
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B347A3042AC4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9658D325721;
	Fri, 19 Dec 2025 11:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oKT3BvZl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Noc9Ym+3";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oKT3BvZl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Noc9Ym+3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFBA31A802
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144630; cv=none; b=IfDDyXod9hqCP+Az3f7K11Ai8FtQmBZ5d8aubWojGnN2pHTEoyyF8S/ZDElVTc3e3cy0nSuurddQlfzeTp04iBUxbqeDpyzSd7CjmtdIPEAr+ZZeC4mNxsd7rzY+utcaljhLja7XEelNfoPX4SiiqyX8B8HtWeZ9Bq5CneScHOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144630; c=relaxed/simple;
	bh=Wo/Ela2ilLDFT8XBQJ2ywxMks4RZu3xs5fuwQRV5+xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VN7JMeP1KMnYfeI1b1uHCpGfS5oRBt8r6Yfif/2CBcrAK64O7hfbpLGn/jIx5rQ09ePhicnAZwn4EGu6kY6tdG+XfC2CHcJjAzJX4UxCXH46Ot1wHtNEAUX6pi3UZ6xHo8xzmgE4VJzKzY9c+IRojn7I811S2sCPxt1eBZB4g5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oKT3BvZl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Noc9Ym+3; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oKT3BvZl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Noc9Ym+3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 37B2D5BD3A;
	Fri, 19 Dec 2025 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOU5S/XpMPdboICzM5MHFHsCug3RScTZ+tMl6SAx3c=;
	b=oKT3BvZlKRqgg7mu6PhRQEZtmYP0w/JCQ54csGRrLNlt3Y6yYHdNMboDLAu80cGtciswFS
	gnQ+RdVkH6FP7zh+4zECCK/2bDGnL/PeoxPVs9dr/wksaFgRYwQdhwjl8FKVzF3UY8pj1O
	6Ww2NPn9j0h/0c5L318+u3wdb0Fo/rI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOU5S/XpMPdboICzM5MHFHsCug3RScTZ+tMl6SAx3c=;
	b=Noc9Ym+35CzxB4Ky2KZ+ZckmMcYWqEBBV3aNFQnwQJWNHdOVFPE7x5JqAwkjEDWVPYI1bp
	mDfdMFqUq0+AW8Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oKT3BvZl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Noc9Ym+3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOU5S/XpMPdboICzM5MHFHsCug3RScTZ+tMl6SAx3c=;
	b=oKT3BvZlKRqgg7mu6PhRQEZtmYP0w/JCQ54csGRrLNlt3Y6yYHdNMboDLAu80cGtciswFS
	gnQ+RdVkH6FP7zh+4zECCK/2bDGnL/PeoxPVs9dr/wksaFgRYwQdhwjl8FKVzF3UY8pj1O
	6Ww2NPn9j0h/0c5L318+u3wdb0Fo/rI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOU5S/XpMPdboICzM5MHFHsCug3RScTZ+tMl6SAx3c=;
	b=Noc9Ym+35CzxB4Ky2KZ+ZckmMcYWqEBBV3aNFQnwQJWNHdOVFPE7x5JqAwkjEDWVPYI1bp
	mDfdMFqUq0+AW8Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AD9D3EA63;
	Fri, 19 Dec 2025 11:43:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qA02I246RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:42 +0000
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
Subject: [PATCH 6/6] KVM: SEV: use scoped mutex guard in sev_asid_new()
Date: Fri, 19 Dec 2025 12:42:01 +0100
Message-ID: <20251219114238.3797364-7-clopez@suse.de>
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
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	R_RATELIMIT(0.00)[to_ip_from(RLh4pfje1bfbim5oauyuywcp9b)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 37B2D5BD3A
X-Spam-Flag: NO
X-Spam-Score: -4.51

Simplify the lock management in sev_asid_new() by using a mutex guard,
automatically releasing the mutex when following the goto.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5f46b7f073b0..95430d456a6f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -232,24 +232,20 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
 		return ret;
 	}
 
-	mutex_lock(&sev_bitmap_lock);
-
+	scoped_guard(mutex, &sev_bitmap_lock) {
 again:
-	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
-	if (asid > max_asid) {
-		if (retry && __sev_recycle_asids(min_asid, max_asid)) {
-			retry = false;
-			goto again;
+		asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
+		if (asid > max_asid) {
+			if (retry && __sev_recycle_asids(min_asid, max_asid)) {
+				retry = false;
+				goto again;
+			}
+			ret = -EBUSY;
+			goto e_uncharge;
 		}
-		mutex_unlock(&sev_bitmap_lock);
-		ret = -EBUSY;
-		goto e_uncharge;
+		__set_bit(asid, sev_asid_bitmap);
 	}
 
-	__set_bit(asid, sev_asid_bitmap);
-
-	mutex_unlock(&sev_bitmap_lock);
-
 	sev->asid = asid;
 	return 0;
 e_uncharge:
-- 
2.51.0


