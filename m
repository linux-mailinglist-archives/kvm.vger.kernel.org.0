Return-Path: <kvm+bounces-68645-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yE39Hjnrb2m+UQAAu9opvQ
	(envelope-from <kvm+bounces-68645-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:53:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1520F4BC93
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:53:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2BE4C8EC494
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 20:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673703A9DA4;
	Tue, 20 Jan 2026 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XI1myI03";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ax/outQG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XI1myI03";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ax/outQG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91013A89CB
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939983; cv=none; b=ZiWQkp9+rtZNDJBxbV+nh8/0K08wW3D3PqboViLR/ih0GuWpLlRvASuCHU9OepJRGWiyg3EdN7ykHl0pdB9hHv8X+LWrT4CShlwNzqM6gcRnRHW45+eQ6YoSGOE4QS/Ri1AWvTcEjgxvARVrjB2Hob6MuWvQ1hnc7uzaTr21y8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939983; c=relaxed/simple;
	bh=M+klrKG7t6pUf/GO4ORX5lUzkHkLnHeEVL/FJGabe+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESa1b1Pk833bIfjhI/KjStETHMI1CiPZDCzWqbshfxDGpi9WqTYKeEs+jhsNvNFa3avNota0oTiAt3K3gZPeJk9cOM4RLlakGRpW4kXEX/byYj2fuxZF7IfRIoF+gPGQ4Lq3ehgXrjSZ+UfKWfdeR6h9Y59/yhKLSJkiahdTvUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XI1myI03; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ax/outQG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XI1myI03; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ax/outQG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 639E1336B7;
	Tue, 20 Jan 2026 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6LsTZnO3E2g9e664OS7z1GS6NXqdu2qUpw+E2fuKwA=;
	b=XI1myI031B5QFIfaILYmYTP9qrAsMk4UIIuC5mPtyG/PH19b5qAK23LF4/7uDPmEXWphII
	VNyxGtsq7Vq64ps0friXTyoI59xpxVEkYKcWIfEwzoC1qoUgqpcQPm4vWtl3Jcvy+NRebH
	Rk41W+t9r9D4VpvRC/AWLwJ5Tlj2eDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6LsTZnO3E2g9e664OS7z1GS6NXqdu2qUpw+E2fuKwA=;
	b=ax/outQGqaK4uRnMTfLgfXR5sOFO0X8VhFRb7NceA11m8HI9acnxRP9JWUr+ezMDndt6Be
	sU7IYZPfZGc3dxDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768939979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6LsTZnO3E2g9e664OS7z1GS6NXqdu2qUpw+E2fuKwA=;
	b=XI1myI031B5QFIfaILYmYTP9qrAsMk4UIIuC5mPtyG/PH19b5qAK23LF4/7uDPmEXWphII
	VNyxGtsq7Vq64ps0friXTyoI59xpxVEkYKcWIfEwzoC1qoUgqpcQPm4vWtl3Jcvy+NRebH
	Rk41W+t9r9D4VpvRC/AWLwJ5Tlj2eDU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768939979;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6LsTZnO3E2g9e664OS7z1GS6NXqdu2qUpw+E2fuKwA=;
	b=ax/outQGqaK4uRnMTfLgfXR5sOFO0X8VhFRb7NceA11m8HI9acnxRP9JWUr+ezMDndt6Be
	sU7IYZPfZGc3dxDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 854163EA63;
	Tue, 20 Jan 2026 20:12:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KB1NHcrhb2nRMAAAD6G6ig
	(envelope-from <clopez@suse.de>); Tue, 20 Jan 2026 20:12:58 +0000
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
Subject: [PATCH v2 2/6] KVM: SEV: use mutex guard in sev_mem_enc_ioctl()
Date: Tue, 20 Jan 2026 21:10:10 +0100
Message-ID: <20260120201013.3931334-5-clopez@suse.de>
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
X-Spam-Score: -3.30
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
	TAGGED_FROM(0.00)[bounces-68645-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,sev_cmd.id:url]
X-Rspamd-Queue-Id: 1520F4BC93
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Simplify the error paths in sev_mem_enc_ioctl() by using a mutex guard,
allowing early return instead of using gotos.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/svm/sev.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 59a0ad3e0917..bede01fc9086 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2574,30 +2574,24 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
@@ -2666,15 +2660,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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


