Return-Path: <kvm+bounces-68646-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHjpNGvtb2m+UQAAu9opvQ
	(envelope-from <kvm+bounces-68646-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:02:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7084BEAD
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 22:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 489538EC8AD
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5650F3AA193;
	Tue, 20 Jan 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xrf3i+35";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yAbdrTTL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Xrf3i+35";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yAbdrTTL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFA73A7F7C
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 20:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939985; cv=none; b=LcSXXsXfaZpnTf5o3qSematSLrAixctOJeDsERjUylD8eWrW9LpJjZH4vHhG18OSrofm5D9FstCZd0yLlOlGe+UU+TI7zIJMcxfQywWZxics6lMTXeIkk7YnYapFwuqIvbkxjvQ4pv6OYcntghzd2PbLlQlR4S8ZJmZB9PemDyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939985; c=relaxed/simple;
	bh=L6B1PVMX+6Q2yKq5yKMtijiLk5ugPodGLJx1L0SxCQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZsc/St7mbWH9UY5iz670mXnXeDTW7xyRMuM6XkdKa+gvSuMAJ26wyDR2xs5fyvsFyUioMSl/7SvIn8iVSGyRKSSXbH5gGoCnJ6bUPHqSiXGoc7fAE5mNdEgBaFA87cXEu+OagE/C3txbc7gdc8ldn/7WYq923BUJGY1n9z1RuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xrf3i+35; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yAbdrTTL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Xrf3i+35; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yAbdrTTL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4C5CB5BCCE;
	Tue, 20 Jan 2026 20:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMimroRh4FFx5J8bvF8KVufVmKCBnQVJentzhJONIag=;
	b=Xrf3i+35yvhTti2zOjb/VbkMR98OxMvmHOPyqFU02wuW36IfTqT6bCYFKlwOCy/SyI77uG
	uX10UZ/LPorehpLpK5DgxpuD9i4ljeYVc/UdeC4cdP4eTNEAEcrMuI5D4bFTkyG54FKvtl
	h0Ev5Qv+1PrtT37Y8N1HvOVkII6cex4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMimroRh4FFx5J8bvF8KVufVmKCBnQVJentzhJONIag=;
	b=yAbdrTTLblcuyhH2NNhbgEo+AK+eHmxDG39//O3gd/NxT42hBJC2D8dOuzh/z7emy1qmV6
	5pZKaN2gKYETbsCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Xrf3i+35;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yAbdrTTL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMimroRh4FFx5J8bvF8KVufVmKCBnQVJentzhJONIag=;
	b=Xrf3i+35yvhTti2zOjb/VbkMR98OxMvmHOPyqFU02wuW36IfTqT6bCYFKlwOCy/SyI77uG
	uX10UZ/LPorehpLpK5DgxpuD9i4ljeYVc/UdeC4cdP4eTNEAEcrMuI5D4bFTkyG54FKvtl
	h0Ev5Qv+1PrtT37Y8N1HvOVkII6cex4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMimroRh4FFx5J8bvF8KVufVmKCBnQVJentzhJONIag=;
	b=yAbdrTTLblcuyhH2NNhbgEo+AK+eHmxDG39//O3gd/NxT42hBJC2D8dOuzh/z7emy1qmV6
	5pZKaN2gKYETbsCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E3013EA63;
	Tue, 20 Jan 2026 20:12:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOB+F8nhb2nRMAAAD6G6ig
	(envelope-from <clopez@suse.de>); Tue, 20 Jan 2026 20:12:57 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: pankaj.gupta@amd.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 1/6] KVM: SEV: use mutex guard in snp_launch_update()
Date: Tue, 20 Jan 2026 21:10:09 +0100
Message-ID: <20260120201013.3931334-4-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120201013.3931334-3-clopez@suse.de>
References: <20260120201013.3931334-3-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spamd-Result: default: False [-0.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	DMARC_POLICY_ALLOW(0.00)[suse.de,none];
	TAGGED_FROM(0.00)[bounces-68646-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 7B7084BEAD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Simplify the error paths in snp_launch_update() by using a mutex guard,
allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..59a0ad3e0917 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2367,7 +2367,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	struct kvm_memory_slot *memslot;
 	long npages, count;
 	void __user *src;
-	int ret = 0;
 
 	if (!sev_snp_guest(kvm) || !sev->snp_context)
 		return -EINVAL;
@@ -2407,13 +2406,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
@@ -2425,22 +2422,18 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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


