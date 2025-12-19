Return-Path: <kvm+bounces-66322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 044DCCD00C3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 14:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D6D130C3422
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 13:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC28322A24;
	Fri, 19 Dec 2025 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LYRSNgcf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c4UYOcss";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fG5CggXi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9EYX1+lm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4D031AF16
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144623; cv=none; b=ZHVdBx1WUyk5TNctU19MEHcjI08pdFTWxlAERXdLWaip9SJBHcVtOrQHOb+UvWX7hHFJp/S8erALslxnfMIWveOxuO0jP8T/escy4q+bR5x2Z7FtgHeDBR1ASjWlWGyW3oCeGwVeAOFELUTuF8C273i1UOldVwQehpTL8tAZCEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144623; c=relaxed/simple;
	bh=WT+AweqE2BkW0lbQLjFvfZBROAT0sQXjWX6h2baii5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIIdECB/UjB8nu8dEMN/O0SVbTiF7S9FzLKiN2L9zJ3teDRIzS3SrR1Tpy7Usg9WXlYqBWjqZOU4fZTE8zha9jo8id1xIceCI4tD/jpOMbdAiWO4UCLkLmP4oC5iaIkaFo7y1c5sorH1sPZ3BCpbpmyhvKyIpOi6aRoBZv0JjlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LYRSNgcf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c4UYOcss; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fG5CggXi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9EYX1+lm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAF875BD33;
	Fri, 19 Dec 2025 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5oSZZT48jCa2l0/DziD5ficyj8DE33K7X9MsZAk4m/A=;
	b=LYRSNgcfbQM8UXqrL8N5JA9GcPz/SR0pRzmqrXO+gmbIcOWBTjwZdDdD92HGvTv/ItjJjJ
	lAzRnUxBAGBE7Ujh5/wSTF0Qrso+eFcaVPWb6p0rY3mSWM2wBftVzKUmouvXnnDJ4Bd/5M
	U1+5LouATv7hsa0OeLGuZGV5JeGNvCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5oSZZT48jCa2l0/DziD5ficyj8DE33K7X9MsZAk4m/A=;
	b=c4UYOcss3t+vJorOAV9OlUSaX3kPqvXlCAvmlT+eS7bk4OTKXJhF8sUZ20HH+fAeeznlRD
	8IlQNNQ0M4EmuaBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5oSZZT48jCa2l0/DziD5ficyj8DE33K7X9MsZAk4m/A=;
	b=fG5CggXi+aW9NMAZqGfLrZ1N494WAmjRTmFVS1Bp3zH+faWy0Z5xP1uOM4EcIjXy6y6YTZ
	1cyeJjWw1OMLGZtcgvZOcpjNJPxczEpdKRh0kJ861eAhmfE5ct3jgdzrcDLzM97ozaKzcY
	duXZyfpRfJFMakTSCp2D0nSVmFKfq/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5oSZZT48jCa2l0/DziD5ficyj8DE33K7X9MsZAk4m/A=;
	b=9EYX1+lmjcPOVVzOxv+QZnDx1zsAu4Eh73G5Y6kFz0saMPpCjbX9DR8CFlFHN2ixO5SCGR
	fjzkS6PYdHykieAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 553913EA66;
	Fri, 19 Dec 2025 11:43:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SIIjEms6RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:39 +0000
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
Subject: [PATCH 2/6] KVM: SEV: use mutex guard in sev_mem_enc_ioctl()
Date: Fri, 19 Dec 2025 12:41:57 +0100
Message-ID: <20251219114238.3797364-3-clopez@suse.de>
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
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.955];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,sev_cmd.id:url]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.29

Simplify the error paths in sev_mem_enc_ioctl() by using a mutex guard,
allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1b325ae61d15..0ee1b77aeec5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2575,30 +2575,24 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
 		return -EFAULT;
 
-	mutex_lock(&kvm->lock);
+	guard(mutex)(&kvm->lock);
 
 	/* Only the enc_context_owner handles some memory enc operations. */
 	if (is_mirroring_enc_context(kvm) &&
-	    !is_cmd_allowed_from_mirror(sev_cmd.id)) {
-		r = -EINVAL;
-		goto out;
-	}
+	    !is_cmd_allowed_from_mirror(sev_cmd.id))
+		return -EINVAL;
 
 	/*
 	 * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, only
 	 * allow the use of SNP-specific commands.
 	 */
-	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START) {
-		r = -EPERM;
-		goto out;
-	}
+	if (sev_snp_guest(kvm) && sev_cmd.id < KVM_SEV_SNP_LAUNCH_START)
+		return -EPERM;
 
 	switch (sev_cmd.id) {
 	case KVM_SEV_ES_INIT:
-		if (!sev_es_enabled) {
-			r = -ENOTTY;
-			goto out;
-		}
+		if (!sev_es_enabled)
+			return -ENOTTY;
 		fallthrough;
 	case KVM_SEV_INIT:
 		r = sev_guest_init(kvm, &sev_cmd);
@@ -2667,15 +2661,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 		r = snp_launch_finish(kvm, &sev_cmd);
 		break;
 	default:
-		r = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (copy_to_user(argp, &sev_cmd, sizeof(struct kvm_sev_cmd)))
 		r = -EFAULT;
 
-out:
-	mutex_unlock(&kvm->lock);
 	return r;
 }
 
-- 
2.51.0


