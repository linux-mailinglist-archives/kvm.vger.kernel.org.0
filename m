Return-Path: <kvm+bounces-47084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FD5ABD208
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:33:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5FE97A2FCE
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A9B264FA0;
	Tue, 20 May 2025 08:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YgkV93AW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="46djWSt1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pLOmC0iK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fM59v9qA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE5B264A88
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747730001; cv=none; b=Z+ZBqv+zVzI3e1tZ19FJ0wdA3cpKpngruIuyHiULeVRaRCFrtqAnaMxhANBv8A8AyOumphRN/bpDV1fb0UEfXNcL8XnoGNs7wdVwx0BAu+BklOCqtHf2XKnLZvNA8fD905yMhNG5b0UC55ZqRYzn1LCp27pMJq6USHwZcObUZHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747730001; c=relaxed/simple;
	bh=gZlYFM7lX7TkWpTV+6o7guEG13fRDeniCefNu4L8P0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmcCbGU8TcNPQIwnn5KFe4SjEa9gU/zqd9w9dU31teowViqngUMl6b1C2gscWsKINA4uG6gDim/nhVHZknHgu1B2OF/bOtod6vb7MZR28GRGRgnq/AreJWjEUTkr+5Rdtx0ldDhEQSkKQqxIyLIyQd+v6TKvcYmveiddAUL3rB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YgkV93AW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=46djWSt1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pLOmC0iK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fM59v9qA; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B1F520634;
	Tue, 20 May 2025 08:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747729997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpHAVQCkyfQV4gQBT/q8vfa5AfukF+uSKRXPvXO1Lv8=;
	b=YgkV93AWk6oYNSn25eCgMYDr8t1OCQ4txtEZ2sKqcECD/u9pVVpVbCgK5TcyYFIp2Jue87
	AOt8wHWCvU4adEg8yo761/iB+DZD7iU2wiet0ctnoYazU9IkU94Bb1edgbdzVmY5qFUtDm
	FsRKpiNStVf09B/RzgvyfMYAh+/REuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747729997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpHAVQCkyfQV4gQBT/q8vfa5AfukF+uSKRXPvXO1Lv8=;
	b=46djWSt1BoTOT6Cv0KTWEL/4WlR2fmp/LmDL89W20itXHCjvfRUmHdgoF7rYbJbKKto+oc
	VzIcPPfETmVJGDAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747729996; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpHAVQCkyfQV4gQBT/q8vfa5AfukF+uSKRXPvXO1Lv8=;
	b=pLOmC0iKY2mRPJQI1/PeDaLdNWGpD5FSB+G3N/EQV4r12Y0Ys3gIH4x3Wi7Q1kw2rIDhgj
	17Y+wTZSpycakeX0Y6vUjMZqlMqq0aQtoFqPAbRKMFLxSWFPBlUoVAbdeGvBASNGsD5CFl
	tlyMOnN++hpQC89Pfg/Vvksw8GkUiPA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747729996;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpHAVQCkyfQV4gQBT/q8vfa5AfukF+uSKRXPvXO1Lv8=;
	b=fM59v9qAb/+UTZ9o2j0slAPoTnvUK96heiGHwn7fGjj+02VfMjLTLdaKgE8vMQGg1/9KmV
	TxJYIsvdJPNU+KAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C66013888;
	Tue, 20 May 2025 08:33:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8T36EUw+LGihSwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 20 May 2025 08:33:16 +0000
Date: Tue, 20 May 2025 10:33:15 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Janosch Frank <frankja@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <aCw-S8Fj-OCSsPqW@localhost.localdomain>
References: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -1.30
X-Spamd-Result: default: False [-1.30 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[19];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,localhost.localdomain:mid,suse.de:email,intel.com:email]

On Mon, May 19, 2025 at 03:56:57PM +0100, Lorenzo Stoakes wrote:
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
> 
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
> 
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
> 
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Acked-by: Yang Shi <yang@os.amperecomputing.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

