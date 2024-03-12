Return-Path: <kvm+bounces-11671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B6E087974A
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 16:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 299A728203B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A2A7C0B4;
	Tue, 12 Mar 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EcXKC1CL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JAe0qVzb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EcXKC1CL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JAe0qVzb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577767BB16;
	Tue, 12 Mar 2024 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256605; cv=none; b=pZqtgBgIybdUhCpBA3j7HkKn13mJ8vZIESfPspp+bfa5kxZSywyaF1kyw+xUiNn2H0kU7hbIcVF2Nycgb6e0AqxOuzsd5ibloCP+LkwdQML5F7Ss5Vy9jcNBustKR6j9yY5wnqgoqfZoHuIvRQK0H8V1Loz10DL2RLqpVvUuuU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256605; c=relaxed/simple;
	bh=AeExeGN+wDjOLKqYJs7IrVaPcAZMhUvQdnV9d1mWiGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sC7Uv9YiIhr3f+2JBJKtGchGg9xS/vtDar5eNW4pLp6KWeJo1JVHsVHHj94smrO/OLMiO42MlgZGRwLGVF/NvRyCvpXTEal0sT5XaoOOAnlQG4EOOUfl3OBv57AFCln367CYr6Yp1A2hArXs7jL2XqX/I0maZquzm6Ar7jXbIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EcXKC1CL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JAe0qVzb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EcXKC1CL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JAe0qVzb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 89A125D666;
	Tue, 12 Mar 2024 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710256602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BQk1AYXpxqnAnevl0wbO8bx38n5uosNZevuvD043lpQ=;
	b=EcXKC1CL/YQKQnY0zdB6+U5X5kNJ5+cG0o+ZSEHD0RfKNPh9fP04c7xuDqn7uM7+ZfC7yZ
	+fCo9LP6p09xNxmys/iB1qOyAl/dc1xYCchvmTxV7p74UeLv6IKjxDgDaBzdy2g/q8RU4/
	HKUdNBtgUbM/U0x8wUwXKCFu5sCtSLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710256602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BQk1AYXpxqnAnevl0wbO8bx38n5uosNZevuvD043lpQ=;
	b=JAe0qVzbWGU8kGVz+EtiebkYSvj4bn/eyZ692mQS7kkV5pbUpoz5ueDNmadp6tm6GM+d9B
	4r2UvKHFLMIpXAAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710256602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BQk1AYXpxqnAnevl0wbO8bx38n5uosNZevuvD043lpQ=;
	b=EcXKC1CL/YQKQnY0zdB6+U5X5kNJ5+cG0o+ZSEHD0RfKNPh9fP04c7xuDqn7uM7+ZfC7yZ
	+fCo9LP6p09xNxmys/iB1qOyAl/dc1xYCchvmTxV7p74UeLv6IKjxDgDaBzdy2g/q8RU4/
	HKUdNBtgUbM/U0x8wUwXKCFu5sCtSLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710256602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BQk1AYXpxqnAnevl0wbO8bx38n5uosNZevuvD043lpQ=;
	b=JAe0qVzbWGU8kGVz+EtiebkYSvj4bn/eyZ692mQS7kkV5pbUpoz5ueDNmadp6tm6GM+d9B
	4r2UvKHFLMIpXAAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 393A91364F;
	Tue, 12 Mar 2024 15:16:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mbBuDdpx8GX6MwAAD6G6ig
	(envelope-from <vkarasulli@suse.de>); Tue, 12 Mar 2024 15:16:42 +0000
Date: Tue, 12 Mar 2024 16:16:41 +0100
From: Vasant Karasulli <vkarasulli@suse.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vasant k <vsntk18@gmail.com>, x86@kernel.org, joro@8bytes.org,
	cfir@google.com, dan.j.williams@intel.com,
	dave.hansen@linux.intel.com, ebiederm@xmission.com,
	erdemaktas@google.com, hpa@zytor.com, jgross@suse.com,
	jslaby@suse.cz, keescook@chromium.org, kexec@lists.infradead.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, luto@kernel.org,
	martin.b.radev@gmail.com, mhiramat@kernel.org, mstunes@vmware.com,
	nivedita@alum.mit.edu, peterz@infradead.org, rientjes@google.com,
	seanjc@google.com, stable@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 0/9] x86/sev: KEXEC/KDUMP support for SEV-ES guests
Message-ID: <ZfBx2ewmB06qQajs@vasant-suse>
References: <20240311161727.14916-1-vsntk18@gmail.com>
 <f1ff678d-88fd-4893-b01a-04e1a60670ce@amd.com>
 <CAF2zH5qZKEmECy=9vG4sLmdDt5k7nC=MwjKvJLyVfPyFzt+0hA@mail.gmail.com>
 <c8c88a28-30be-4034-9fe7-9c9de5247c53@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8c88a28-30be-4034-9fe7-9c9de5247c53@amd.com>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.70
X-Spamd-Result: default: False [0.70 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.00)[22.84%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 R_RATELIMIT(0.00)[to_ip_from(RLdz9bntmsbxsz5ozaiow1ygjn)];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_TWELVE(0.00)[27];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[gmail.com,kernel.org,8bytes.org,google.com,intel.com,linux.intel.com,xmission.com,zytor.com,suse.com,suse.cz,chromium.org,lists.infradead.org,vger.kernel.org,lists.linux.dev,vmware.com,alum.mit.edu,infradead.org,lists.linux-foundation.org];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

On Di 12-03-24 09:04:13, Tom Lendacky wrote:
> On 3/11/24 15:32, Vasant k wrote:
> > Hi Tom,
> >
> >         Right,  it just escaped my mind that the SNP uses the secrets page
> > to hand over APs to the next stage.  I will correct that in the next
>
> Not quite... The MADT table lists the APs and the GHCB AP Create NAE event
> is used to start the APs.

Alright. So AP Jump Table is not used like in the case of SEV-ES. Thanks,
I will keep the changes in the patch set exclusively for SEV-ES then.

- Vasant

