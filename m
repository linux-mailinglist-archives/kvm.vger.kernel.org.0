Return-Path: <kvm+bounces-66327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6137FCCFAAF
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:52:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 14FAF302B16B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FD33246F3;
	Fri, 19 Dec 2025 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LsE4AYZK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eX3tYUeM";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LsE4AYZK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eX3tYUeM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3703327BF7
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 11:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766144649; cv=none; b=eJe0MgVSS+9hfBzZi4cEeCeLZJwUE/r4/gkqFz2waSQF7bIHFKky+Nwn3QJThphOb8hhrzoaVIPmrtWbBlOLQMiH8jWQNIRvQzT5M9mXWXkSm1xUi83CyEdwhCwVeUBGveJWnsHh6Gfgu2OsVwOhvvrjj8R94HKTjsCaCD70wA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766144649; c=relaxed/simple;
	bh=ZmJW1XHRh7J6YAgXrs205TH4OgyX9T2zXUIMScXP4dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqlZpLO+ODGxbQ3VjOlyKRMSb4CCO7YuzohMNDvj+FS0GpqYx0DtI+3D6lx4liVFMJrTvAW6Acpf7jLqBuTU7cq3vVmVhaxjRzYERm8mx1ez6m3rbkxiU4Y9M7Jay3sRH67FI/JHq+QhqMwHDVx3QR0QTtBNxCownRxZGdGvbn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LsE4AYZK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eX3tYUeM; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LsE4AYZK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eX3tYUeM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 70B1833729;
	Fri, 19 Dec 2025 11:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdYd+JxqfFxsAWL3QZlRpvclOaJf7rcIjlPpiEXRzHU=;
	b=LsE4AYZKc1S6Sq3gkpVitGL0ZEWyCtQNeGPK/J3zk5tXrTy8MRG3/EGyT9hRllr+mtnZ+/
	8NSzxArdkDgYDFjjG9unFOBMPeXKiRMSZoLvHNEmVNSx9eiCOiE6MydQ2zBcAQiUrm5H3e
	LTcYheiRWlZcWY8paLRBrY+64aqcmv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdYd+JxqfFxsAWL3QZlRpvclOaJf7rcIjlPpiEXRzHU=;
	b=eX3tYUeMeG3IcOj25YI3QY9f1QMdr0eaPIy95R26k7BvGxITG7iTBpZE/2scOR8L3UXCNJ
	UJgSrdSs0DwvlkBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LsE4AYZK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eX3tYUeM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1766144622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdYd+JxqfFxsAWL3QZlRpvclOaJf7rcIjlPpiEXRzHU=;
	b=LsE4AYZKc1S6Sq3gkpVitGL0ZEWyCtQNeGPK/J3zk5tXrTy8MRG3/EGyT9hRllr+mtnZ+/
	8NSzxArdkDgYDFjjG9unFOBMPeXKiRMSZoLvHNEmVNSx9eiCOiE6MydQ2zBcAQiUrm5H3e
	LTcYheiRWlZcWY8paLRBrY+64aqcmv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1766144622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pdYd+JxqfFxsAWL3QZlRpvclOaJf7rcIjlPpiEXRzHU=;
	b=eX3tYUeMeG3IcOj25YI3QY9f1QMdr0eaPIy95R26k7BvGxITG7iTBpZE/2scOR8L3UXCNJ
	UJgSrdSs0DwvlkBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C99063EA63;
	Fri, 19 Dec 2025 11:43:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gFmdLm06RWnWGgAAD6G6ig
	(envelope-from <clopez@suse.de>); Fri, 19 Dec 2025 11:43:41 +0000
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
Subject: [PATCH 5/6] KVM: SEV: use mutex guard in snp_handle_guest_req()
Date: Fri, 19 Dec 2025 12:42:00 +0100
Message-ID: <20251219114238.3797364-6-clopez@suse.de>
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
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 70B1833729
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	R_RATELIMIT(0.00)[to_ip_from(RLh4pfje1bfbim5oauyuywcp9b)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

Simplify the error paths in snp_handle_guest_req() by using a mutex
guard, allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 47ff5267ab01..5f46b7f073b0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4090,12 +4090,10 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	if (!sev_snp_guest(kvm))
 		return -EINVAL;
 
-	mutex_lock(&sev->guest_req_mutex);
+	guard(mutex)(&sev->guest_req_mutex);
 
-	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE)) {
-		ret = -EIO;
-		goto out_unlock;
-	}
+	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE))
+		return -EIO;
 
 	data.gctx_paddr = __psp_pa(sev->snp_context);
 	data.req_paddr = __psp_pa(sev->guest_req_buf);
@@ -4108,21 +4106,16 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	 */
 	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
 	if (ret && !fw_err)
-		goto out_unlock;
+		return ret;
 
-	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE)) {
-		ret = -EIO;
-		goto out_unlock;
-	}
+	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE))
+		return -EIO;
 
 	/* No action is requested *from KVM* if there was a firmware error. */
 	svm_vmgexit_no_action(svm, SNP_GUEST_ERR(0, fw_err));
 
-	ret = 1; /* resume guest */
-
-out_unlock:
-	mutex_unlock(&sev->guest_req_mutex);
-	return ret;
+	/* resume guest */
+	return 1;
 }
 
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
-- 
2.51.0


