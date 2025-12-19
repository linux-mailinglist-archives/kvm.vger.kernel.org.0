Return-Path: <kvm+bounces-66321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C241CCFAC1
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B0A23087D6E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5410F31A7F2;
	Fri, 19 Dec 2025 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bGK8jW1X";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z4c40GeC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bGK8jW1X";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="z4c40GeC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D7D30100B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144623; cv=none; b=H8HPj9hf+HvefaDgq5sdoHCrSotrTPfmPV3MWGmnjMPksQFPoBeMkI5RgnJenwh/5+sGFyUScnJ/1VMCJVwUmHDWstsk7GCOH+v1Nz7Um3duMwjOfLHQhhlqXcG1I4j6GxK9oyVu4LgGgxiHkiR5IR4GqjYAiJt9duB08s97cEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144623; c=relaxed/simple;
	bh=spCH2RG+AhZVozNevZ6i3mngQBX2bSM3d9ry14WgBX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kno0NgYWUFeUfXpp/x70gamzLJ2SjowBGNCiEvZtg4nDJuJoO9nTac3vVlRVBt69zM23ZV/NWMsB9eybL5OL7wYdP1gSLqYiRyUjNm6cSZkqw4DSxZmx3ErTCv8DQ4q3vjyU04r0+TV5WTRBP5ck0/hRsAEXD4ITustRZIye08I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bGK8jW1X; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z4c40GeC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bGK8jW1X; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=z4c40GeC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2482C33700;
	Fri, 19 Dec 2025 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Zv71gwQn0bju/h7RL9kNTPKzfgg8WZO15eDlR04yHM=;
	b=bGK8jW1XSsWaxFvYMTdc3acVUOMF8q8aKrEgs2hzK8A4gFvAiwtc/vLIdjTicEp+4rVIWh
	dRfeuLpoGB1CmMg+L9VTpgfEwPmXMUSZMlbGAxRSQZQwDbFoFimUdsxp69bqnKf3fL/88t
	VtT8XhqqLMVwHOGtSj/fzL1TJLGVI0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Zv71gwQn0bju/h7RL9kNTPKzfgg8WZO15eDlR04yHM=;
	b=z4c40GeCEMr/TW1oHB73U4B5WcnJSedcurQAE94MyBo6WFgK42HxcKhqjmp2lpb5ZdWbVi
	7277un7GXALgZjCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bGK8jW1X;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z4c40GeC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Zv71gwQn0bju/h7RL9kNTPKzfgg8WZO15eDlR04yHM=;
	b=bGK8jW1XSsWaxFvYMTdc3acVUOMF8q8aKrEgs2hzK8A4gFvAiwtc/vLIdjTicEp+4rVIWh
	dRfeuLpoGB1CmMg+L9VTpgfEwPmXMUSZMlbGAxRSQZQwDbFoFimUdsxp69bqnKf3fL/88t
	VtT8XhqqLMVwHOGtSj/fzL1TJLGVI0A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Zv71gwQn0bju/h7RL9kNTPKzfgg8WZO15eDlR04yHM=;
	b=z4c40GeCEMr/TW1oHB73U4B5WcnJSedcurQAE94MyBo6WFgK42HxcKhqjmp2lpb5ZdWbVi
	7277un7GXALgZjCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8027B3EA65;
	Fri, 19 Dec 2025 11:43:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gMqOHGo6RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:38 +0000
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
Subject: [PATCH 1/6] KVM: SEV: use mutex guard in snp_launch_update()
Date: Fri, 19 Dec 2025 12:41:56 +0100
Message-ID: <20251219114238.3797364-2-clopez@suse.de>
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
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Queue-Id: 2482C33700
X-Spam-Flag: NO
X-Spam-Score: -4.51

Simplify the error paths in snp_launch_update() by using a mutex guard,
allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..1b325ae61d15 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -8,6 +8,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cleanup.h>
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/kernel.h>
@@ -2367,7 +2368,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct kvm_memory_slot *memslot;
 	long npages, count;
 	void __user *src;
-	int ret = 0;
 
 	if (!sev_snp_guest(kvm) || !sev->snp_context)
 		return -EINVAL;
@@ -2407,13 +2407,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	 * initial expected state and better guard against unexpected
 	 * situations.
 	 */
-	mutex_lock(&kvm->slots_lock);
+	guard(mutex)(&kvm->slots_lock);
 
 	memslot = gfn_to_memslot(kvm, params.gfn_start);
-	if (!kvm_slot_has_gmem(memslot)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!kvm_slot_has_gmem(memslot))
+		return -EINVAL;
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
@@ -2425,22 +2423,18 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		argp->error = sev_populate_args.fw_error;
 		pr_debug("%s: kvm_gmem_populate failed, ret %ld (fw_error %d)\n",
 			 __func__, count, argp->error);
-		ret = -EIO;
-	} else {
-		params.gfn_start += count;
-		params.len -= count * PAGE_SIZE;
-		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
-			params.uaddr += count * PAGE_SIZE;
-
-		ret = 0;
-		if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
-			ret = -EFAULT;
+		return -EIO;
 	}
 
-out:
-	mutex_unlock(&kvm->slots_lock);
+	params.gfn_start += count;
+	params.len -= count * PAGE_SIZE;
+	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+		params.uaddr += count * PAGE_SIZE;
 
-	return ret;
+	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
-- 
2.51.0


