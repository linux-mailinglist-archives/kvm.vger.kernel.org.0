Return-Path: <kvm+bounces-66325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 890C5CCFAEF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:59:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 326F431064E0
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81152326959;
	Fri, 19 Dec 2025 11:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AAyICD07";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qu9nfYH9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AAyICD07";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qu9nfYH9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D9D326946
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144635; cv=none; b=IyHTTSvNTXK+VTVdDQb3hj1Yzqc2puZQTTo81cR4D1LLqumQ5T9Fk2xy62tTdiDTZ/jbF7fb0+IgbhXg1pRJapvgCIoKxG5u5drWs5iwJQqpEGyjKmZV7woPD3me6fRsRz6Q2l0D/YVFhoGigCOtgzhfPL9rdG068UhiAH2ngg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144635; c=relaxed/simple;
	bh=0llsXn1km+v1kZCm7eAn8T4M52/DVBBZTXvc9qbwkT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpyjDLGZ61HNNBwS/uDyPd/vSiFc/d+TzM6+r1M89iNSTeH/VvLzbI14S1fngztKJJ0zQQi3BS4lQn73Nj4rzUN4JQp8KQ+bCWC/Eh47Kg516wc6eUTrr+VkBt57RV8+gHhuLXy4aKRhbYU+JcTBnz1nybxh7F/z0h3KFg1+JtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AAyICD07; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qu9nfYH9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AAyICD07; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qu9nfYH9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C027F33714;
	Fri, 19 Dec 2025 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7AGDWWK7oj01hSc4RtgIJ4/P00xw0qz4cWje4kcoRI=;
	b=AAyICD07buC4+3LonyP+rCf7tMB3bqoogye5stxAG/B7vZvgxU6PaIjNQXETGlv+CO6J6N
	YuR0nkqg2JxegpOKZzO0J4UdAAf8U9xa1FZbIUNUYUDMJ0uq5aQd5Ue7B0JCvmzaCrPJUK
	lR59kiWM7V5UCijJ54ZKRrBHWpue3Pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7AGDWWK7oj01hSc4RtgIJ4/P00xw0qz4cWje4kcoRI=;
	b=Qu9nfYH9mf4no93L99E6Oans8SBNGJmmQIavNWjweKy721xOjdxyltXMDR7CjNU7YFk1Tt
	5EDsfrJyUwuDMhAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7AGDWWK7oj01hSc4RtgIJ4/P00xw0qz4cWje4kcoRI=;
	b=AAyICD07buC4+3LonyP+rCf7tMB3bqoogye5stxAG/B7vZvgxU6PaIjNQXETGlv+CO6J6N
	YuR0nkqg2JxegpOKZzO0J4UdAAf8U9xa1FZbIUNUYUDMJ0uq5aQd5Ue7B0JCvmzaCrPJUK
	lR59kiWM7V5UCijJ54ZKRrBHWpue3Pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7AGDWWK7oj01hSc4RtgIJ4/P00xw0qz4cWje4kcoRI=;
	b=Qu9nfYH9mf4no93L99E6Oans8SBNGJmmQIavNWjweKy721xOjdxyltXMDR7CjNU7YFk1Tt
	5EDsfrJyUwuDMhAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A2E33EA63;
	Fri, 19 Dec 2025 11:43:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEOfB2w6RWnWGgAAD6G6ig
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
Subject: [PATCH 3/6] KVM: SEV: use mutex guard in sev_mem_enc_register_region()
Date: Fri, 19 Dec 2025 12:41:58 +0100
Message-ID: <20251219114238.3797364-4-clopez@suse.de>
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
X-Spamd-Result: default: False [-3.26 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.796];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.26

Simplify the error paths in sev_mem_enc_register_region() by using a
mutex guard, allowing early return instead of using a goto.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0ee1b77aeec5..253f2ae24bfc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2691,13 +2691,13 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	if (!region)
 		return -ENOMEM;
 
-	mutex_lock(&kvm->lock);
+	guard(mutex)(&kvm->lock);
 	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages,
 				       FOLL_WRITE | FOLL_LONGTERM);
 	if (IS_ERR(region->pages)) {
 		ret = PTR_ERR(region->pages);
-		mutex_unlock(&kvm->lock);
-		goto e_free;
+		kfree(region);
+		return ret;
 	}
 
 	/*
@@ -2714,13 +2714,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
 	region->size = range->size;
 
 	list_add_tail(&region->list, &sev->regions_list);
-	mutex_unlock(&kvm->lock);
 
 	return ret;
-
-e_free:
-	kfree(region);
-	return ret;
 }
 
 static struct enc_region *
-- 
2.51.0


