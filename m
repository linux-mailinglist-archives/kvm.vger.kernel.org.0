Return-Path: <kvm+bounces-49436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 849B2AD909B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC48B188A54E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0893F1D61BC;
	Fri, 13 Jun 2025 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DRB2lav7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ebGAWNgc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DRB2lav7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ebGAWNgc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4DD15573F
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826780; cv=none; b=I+anZx7jySX1rhsveDOD+m0wEDV2iVzn4FmV0d+f269xn+Trz97UqHl8g3jOT617RPwvLAT+nteHNdh7EDWC51KVkhzJ+pYYnstKBJZ7xqbt1p6k4FrFUFu5zxyfHv8BCh3jGwER0lXlXUY7AeyNhOJYL6MPDPcP/Y+CH4A/dVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826780; c=relaxed/simple;
	bh=MmyLM8DJ6ZajYhJ1weJ4SzVz7NMfCQoekwqtAsHewcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNBa5BiPqOvkmGPC1MtES11L+AxuIe3KOVZxM8c21RO+0Es5Rm2XaX3+h/CB3nh6R/hF9IEU40La92oh9F7KbCgn963oT+T+xW96Ms4VKUP8O+5Kvh3RBZUDJgABjryl9uWc/CSnGf90XF/Z9kt5ncFqRlKFctlfSjgyXYrDhXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DRB2lav7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ebGAWNgc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DRB2lav7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ebGAWNgc; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A4CD921999;
	Fri, 13 Jun 2025 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749826776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGf26eMCz/kECkymDKLsChj1GeY6PzVVA9HrTn1uepM=;
	b=DRB2lav7BsqeEMr0xFqL9bfCuFZHxJRmeHEl9trtQTXuvWrSXidRA4DyaXHASm7Id2Pp7x
	aQ18I73kmGL5mgEsNvtTB3f+v5Rohy4SqQtfxgqxg0ZjgoukN2JSVQHKpECEfDbIkT0CmJ
	vAwcPTcfi3OTna8OLRm1NBzm9onjUk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749826776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGf26eMCz/kECkymDKLsChj1GeY6PzVVA9HrTn1uepM=;
	b=ebGAWNgcCHhecAr6NymFW7Mnf1tgU0FxGKMuwiFaJU1DYOxpixVUvbRahcRXWwIS+1DogX
	0h9U4uJsmKIzFFAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DRB2lav7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ebGAWNgc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749826776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGf26eMCz/kECkymDKLsChj1GeY6PzVVA9HrTn1uepM=;
	b=DRB2lav7BsqeEMr0xFqL9bfCuFZHxJRmeHEl9trtQTXuvWrSXidRA4DyaXHASm7Id2Pp7x
	aQ18I73kmGL5mgEsNvtTB3f+v5Rohy4SqQtfxgqxg0ZjgoukN2JSVQHKpECEfDbIkT0CmJ
	vAwcPTcfi3OTna8OLRm1NBzm9onjUk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749826776;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VGf26eMCz/kECkymDKLsChj1GeY6PzVVA9HrTn1uepM=;
	b=ebGAWNgcCHhecAr6NymFW7Mnf1tgU0FxGKMuwiFaJU1DYOxpixVUvbRahcRXWwIS+1DogX
	0h9U4uJsmKIzFFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D76FF13782;
	Fri, 13 Jun 2025 14:59:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FbTyMdc8TGixIAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Fri, 13 Jun 2025 14:59:35 +0000
Date: Fri, 13 Jun 2025 16:59:34 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Muchun Song <muchun.song@linux.dev>, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Message-ID: <aEw81libg2OQAiYc@localhost.localdomain>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-3-peterx@redhat.com>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: A4CD921999
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.51

On Fri, Jun 13, 2025 at 09:41:08AM -0400, Peter Xu wrote:
> Only mips and loongarch implemented this API, however what it does was
> checking against stack overflow for either len or addr.  That's already
> done in arch's arch_get_unmapped_area*() functions, hence not needed.
> 
> It means the whole API is pretty much obsolete at least now, remove it
> completely.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: loongarch@lists.linux.dev
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Peter Xu <peterx@redhat.com>

I think I forgot to clean these up when I unified the unmapped_area for
hugetlb.

Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks Peter!
 

-- 
Oscar Salvador
SUSE Labs

