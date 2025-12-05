Return-Path: <kvm+bounces-65320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 543BACA6CCB
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BEDC7352E232
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6433302167;
	Fri,  5 Dec 2025 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V6UcEPZy";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V6UcEPZy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908FA31AF22
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920756; cv=none; b=UulJFAlSJngGcYAKB8RYM9FHl9wBLamN3sOgR/Hl58H92LpEFP5ZFLFI3D4bGG4LSGfY7eOfXkpY1UwtY0bhY3cpv60es8jfqWPE3MCzlaIWZqjlygYoNbzun6tg4KZSQHvq5u8DoLPAVp5gxcKs4VlB6/830xdPA6epwGxFJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920756; c=relaxed/simple;
	bh=kGcpNNUgWOUYgW5sZQpTtofU3/dtzWieBe8mCgv9i/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEC9qdugwB7+J7H4GL9bKpKAgrczspFil2XqnsZmFWw95YEAO9XyVa32xxVfdvRrWATlOyWNxRnY1Ep5CVkSvFAnL/WRVTNX3ACzxfKaewR650HzRMemhay+8q/80UBPrTSqr9gr6YbPTdjYXt5ESRUxjCX7SLKx9GslT1JEKXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V6UcEPZy; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V6UcEPZy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 01337336CD;
	Fri,  5 Dec 2025 07:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do1MJinNWJ0YCo5j1qrbCZX4SqeWMMwTVSTkct0yedE=;
	b=V6UcEPZyuCEQwXgmavghOV/uEUwxMRPx7fHDhpUlQICoEE/KY6mRIunre1kp8D2xEJyRca
	l2T2Fy1MWbTmIlPAR8jCDFahWKEXhoHmZnt9TFc3+RWTJJnT+6ZqWQINHa5cIqs8aCXgKa
	mVEN1COI7FEKGZmFyUlV5iPMGE7BATg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do1MJinNWJ0YCo5j1qrbCZX4SqeWMMwTVSTkct0yedE=;
	b=V6UcEPZyuCEQwXgmavghOV/uEUwxMRPx7fHDhpUlQICoEE/KY6mRIunre1kp8D2xEJyRca
	l2T2Fy1MWbTmIlPAR8jCDFahWKEXhoHmZnt9TFc3+RWTJJnT+6ZqWQINHa5cIqs8aCXgKa
	mVEN1COI7FEKGZmFyUlV5iPMGE7BATg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD7293EA65;
	Fri,  5 Dec 2025 07:45:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mdPTLKmNMmlkEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:45:45 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 01/10] KVM: Switch coalesced_mmio_in_range() to return bool
Date: Fri,  5 Dec 2025 08:45:28 +0100
Message-ID: <20251205074537.17072-2-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.985];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]

Instead of 0 and 1 let coalesced_mmio_in_range() return false or
true.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 virt/kvm/coalesced_mmio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 375d6285475e..bc022bd45863 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -22,22 +22,22 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
 }
 
-static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
-				   gpa_t addr, int len)
+static bool coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
+				    gpa_t addr, int len)
 {
 	/* is it in a batchable area ?
 	 * (addr,len) is fully included in
 	 * (zone->addr, zone->size)
 	 */
 	if (len < 0)
-		return 0;
+		return false;
 	if (addr + len < addr)
-		return 0;
+		return false;
 	if (addr < dev->zone.addr)
-		return 0;
+		return false;
 	if (addr + len > dev->zone.addr + dev->zone.size)
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
-- 
2.51.0


