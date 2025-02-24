Return-Path: <kvm+bounces-39003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE8EDA427CF
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:24:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D86BC16D6DD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 16:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8C8262D07;
	Mon, 24 Feb 2025 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ffvY7N0p";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y67nHpQK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ffvY7N0p";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="y67nHpQK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BD318B46C
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740414204; cv=none; b=DYDnE3vV7Sblma2qIU0z2s1aRuf98pIUXka+xPhBSQkWjxp3Nr5Uqs24FZVkhCVnqX9O4n2LZiGun7zYYoWAZw/0gRwXNQzk3vABiAcMIW8ZAVHRp1+esprUKOwSXqq83baIeBd03csY9VPasS8K9tkwSTuVsyt2LPlSuwE2Wjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740414204; c=relaxed/simple;
	bh=MRVXIfI9UG2BXzOG7tv7V/b1GbukpjVr4eoLmQQzA1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jF4xxjMt3HlUoHXtrRFggHQnGkHfe7LsHCHPmmxHHorgMNozuEauGdqdgqku2wveMZd1bDSXJ2zu+6hTxffmaEbeQWitp0EVo3LcKhVV1NXM9kvuLjacscEDWmPLOeXsZJ5lCi5ioz/PfeTg2ED+H9Z48kGAffKx6nCMjBsqf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ffvY7N0p; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y67nHpQK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ffvY7N0p; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=y67nHpQK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0DC331F44F;
	Mon, 24 Feb 2025 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1740414201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PAktyz2Hln0u1wP32xCnt0b/m1o4I8DHrPaK7s3SeXw=;
	b=ffvY7N0pIsMHXBWzK/7TCFsjF57cMzfXSdmxHflB10fTjf2nI3Gv8/LMYFArDh1zhyDp2L
	p5QzGpRkEbrtqiYXrxohREzzTbtPftteaDEzHbq9msRUdXRG9n8vm+cwAjGVzikRzCa1fW
	xk5Q+5R1xrhUsnFOgTtiE3bgCbMwAqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1740414201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PAktyz2Hln0u1wP32xCnt0b/m1o4I8DHrPaK7s3SeXw=;
	b=y67nHpQKZ6A37WCLnocVuAPvBNsF5ldexO64bHfLe+MwZzDNiSqa0WvrZSFLctQkWtB/uN
	X2Pi8A15ykI+LdBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ffvY7N0p;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y67nHpQK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1740414201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PAktyz2Hln0u1wP32xCnt0b/m1o4I8DHrPaK7s3SeXw=;
	b=ffvY7N0pIsMHXBWzK/7TCFsjF57cMzfXSdmxHflB10fTjf2nI3Gv8/LMYFArDh1zhyDp2L
	p5QzGpRkEbrtqiYXrxohREzzTbtPftteaDEzHbq9msRUdXRG9n8vm+cwAjGVzikRzCa1fW
	xk5Q+5R1xrhUsnFOgTtiE3bgCbMwAqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1740414201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PAktyz2Hln0u1wP32xCnt0b/m1o4I8DHrPaK7s3SeXw=;
	b=y67nHpQKZ6A37WCLnocVuAPvBNsF5ldexO64bHfLe+MwZzDNiSqa0WvrZSFLctQkWtB/uN
	X2Pi8A15ykI+LdBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4AED13707;
	Mon, 24 Feb 2025 16:23:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TB2GKvicvGd1bQAAD6G6ig
	(envelope-from <jroedel@suse.de>); Mon, 24 Feb 2025 16:23:20 +0000
Date: Mon, 24 Feb 2025 17:23:15 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	seanjc@google.com, thomas.lendacky@amd.com, ashish.kalra@amd.com,
	liam.merwick@oracle.com, pankaj.gupta@amd.com,
	dionnaglaze@google.com, huibo.wang@amd.com
Subject: Re: [PATCH v5 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP
 certificate-fetching
Message-ID: <Z7yc8-QXXVPzr2K8@suse.de>
References: <20250219151505.3538323-1-michael.roth@amd.com>
 <20250219151505.3538323-2-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250219151505.3538323-2-michael.roth@amd.com>
X-Rspamd-Queue-Id: 0DC331F44F
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,suse.com:url];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi Michael,

On Wed, Feb 19, 2025 at 09:15:05AM -0600, Michael Roth wrote:
> +  - If some other error occurred, userspace must set `ret` to ``EIO``.
> +    (This is to reserve special meaning for unused error codes in the
> +    future.)

[...]

> +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_control_area *control = &svm->vmcb->control;
> +
> +	if (vcpu->run->snp_req_certs.ret) {
> +		if (vcpu->run->snp_req_certs.ret == ENOSPC) {
> +			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
> +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
> +		} else if (vcpu->run->snp_req_certs.ret == EAGAIN) {
> +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
> +		} else {
> +			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> +						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
> +		}

According to the documentation above, there should be a block checking
for EIO which injects SNP_GUEST_VMM_ERR_GENERIC and the else block
should return with EINVAL to user-space, no?

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany
https://www.suse.com/

Geschäftsführer: Ivo Totev, Andrew McDonald, Werner Knoblich
(HRB 36809, AG Nürnberg)

