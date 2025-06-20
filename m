Return-Path: <kvm+bounces-50025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C49AE1591
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 10:13:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 107011897C37
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 08:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3416F235043;
	Fri, 20 Jun 2025 08:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OBWBCHAR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3h0+eN6V";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fUdcnFrp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ojMZvkR0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931DF1E1E0C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 08:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750407131; cv=none; b=lOJXnoAo3SPfzg1MVF2rVxBlFW47tB+dQY466pV7Qa7o2yWV8cawr9VPtmh5hi1N2Eu3+r4887OiRnhf4MO84vkYoiQeOOO8gTUbCVwzTUPf0fZB6ju0JSh+85xF7Zj+TOVBVTyidJ1C+5TNkUQXw1a5pE7QrcgN/0rf6UC8sTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750407131; c=relaxed/simple;
	bh=IySXIDBYq4vmS4M9SKbQdvVBQkhfmrzbRdY90uiaR30=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XS+ji+wcaMJaF+bEDzKKeBLSkXFUrUzrDHPx/sML6dq2rXEkYPJ92WC3bKWRzZ2MhLDRgifFq+7fL0wSTwaHd3LCOjrDcfVcrAZWSNe/tsfJAJH+rLYNQUGm1iEt4q0ARvV+xa8KeZ+uv8JOCQT5ouJZCFj+c4NOjc7juZlie28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OBWBCHAR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3h0+eN6V; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fUdcnFrp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ojMZvkR0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6217211A3;
	Fri, 20 Jun 2025 08:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750407128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7kW58skzLpE69Ly01+iLIrtetXieZGB3GPtzPrrsLQ=;
	b=OBWBCHAR9o85tR369wgyeXRrAFc65qZxA6/aRe5NVKwB4M9kR+bb+FuggKiQb0RIU0vphY
	tBOzo8rK3Zq2Otmp9uVt83ctMUVHe7qVP6aFWLkqy83ygZGV/zIKF1JK3pa5MPVlyf73rG
	AYmAS/pLpK9KL7N0C4tglNg1969UNGU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750407128;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7kW58skzLpE69Ly01+iLIrtetXieZGB3GPtzPrrsLQ=;
	b=3h0+eN6Vr4J1zm94U2714SSwhes1Ne9QsCFk2Q8ZlvfZzxhzUpjh3Tf8odTelmjVanFuLO
	PhRaoJzRhhX4ANDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fUdcnFrp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ojMZvkR0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1750407127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7kW58skzLpE69Ly01+iLIrtetXieZGB3GPtzPrrsLQ=;
	b=fUdcnFrpRttKc1DoD4Ijo2314YkjuN2bOCfB8yJh4FGfmbvK4eXQWpccrPHiWyKsS40cMr
	wcY9dBZ+37WgJJURknz7x7OovFjUbtcEprgeJLmHxNs6Od67FLgfD82K73wMu2qc3YZ1x1
	3wOFU+fsLKjbuW3xhhvMMAX4JwrfRlk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1750407127;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i7kW58skzLpE69Ly01+iLIrtetXieZGB3GPtzPrrsLQ=;
	b=ojMZvkR0JXsCOSBrQFCIISZmcGBVKlmps9Qlj2W9WhozsiIHjtrQiqvVDSCfIuriNXRa/9
	OUbu/ECvCvYcwwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27CB313A9C;
	Fri, 20 Jun 2025 08:12:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QeeUCNcXVWiZXAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 20 Jun 2025 08:12:07 +0000
Date: Fri, 20 Jun 2025 10:12:06 +0200
Message-ID: <87msa2x25l.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Mario Limonciello <superm1@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,	Alex Deucher
 <alexander.deucher@amd.com>,	Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>,	David Airlie <airlied@gmail.com>,	Simona Vetter
 <simona@ffwll.ch>,	Lukas Wunner <lukas@wunner.de>,	Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>,	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,	David Woodhouse
 <dwmw2@infradead.org>,	Lu Baolu <baolu.lu@linux.intel.com>,	Joerg Roedel
 <joro@8bytes.org>,	Will Deacon <will@kernel.org>,	Robin Murphy
 <robin.murphy@arm.com>,	Alex Williamson <alex.williamson@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>,	Takashi Iwai <tiwai@suse.com>,
	dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
	linux-kernel@vger.kernel.org (open list),	iommu@lists.linux.dev (open
 list:INTEL IOMMU (VT-d)),	linux-pci@vger.kernel.org (open list:PCI
 SUBSYSTEM),	kvm@vger.kernel.org (open list:VFIO DRIVER),
	linux-sound@vger.kernel.org (open list:SOUND),	Daniel Dadap
 <ddadap@nvidia.com>,	Mario Limonciello <mario.limonciello@amd.com>,	Simona
 Vetter <simona.vetter@ffwll.ch>,	Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v3 5/7] ALSA: hda: Use pci_is_display()
In-Reply-To: <20250620024943.3415685-6-superm1@kernel.org>
References: <20250620024943.3415685-1-superm1@kernel.org>
	<20250620024943.3415685-6-superm1@kernel.org>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[google.com,amd.com,gmail.com,ffwll.ch,wunner.de,linux.intel.com,kernel.org,suse.de,infradead.org,8bytes.org,arm.com,redhat.com,perex.cz,suse.com,lists.freedesktop.org,vger.kernel.org,lists.linux.dev];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	R_RATELIMIT(0.00)[to_ip_from(RL19doqawnwjg494dhy1bqfax3)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email,nvidia.com:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: C6217211A3
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -3.51

On Fri, 20 Jun 2025 04:49:41 +0200,
Mario Limonciello wrote:
> 
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The inline pci_is_display() helper does the same thing.  Use it.
> 
> Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
> Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
> Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Reviewed-by: Takashi Iwai <tiwai@suse.de>


thanks,

Takashi

> ---
>  sound/hda/hdac_i915.c     | 2 +-
>  sound/pci/hda/hda_intel.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/hda/hdac_i915.c b/sound/hda/hdac_i915.c
> index e9425213320ea..44438c799f957 100644
> --- a/sound/hda/hdac_i915.c
> +++ b/sound/hda/hdac_i915.c
> @@ -155,7 +155,7 @@ static int i915_gfx_present(struct pci_dev *hdac_pci)
>  
>  	for_each_pci_dev(display_dev) {
>  		if (display_dev->vendor != PCI_VENDOR_ID_INTEL ||
> -		    (display_dev->class >> 16) != PCI_BASE_CLASS_DISPLAY)
> +		    !pci_is_display(display_dev))
>  			continue;
>  
>  		if (pci_match_id(denylist, display_dev))
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index e5210ed48ddf1..a165c44b43940 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -1465,7 +1465,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
>  				 * the dGPU is the one who is involved in
>  				 * vgaswitcheroo.
>  				 */
> -				if (((p->class >> 16) == PCI_BASE_CLASS_DISPLAY) &&
> +				if (pci_is_display(p) &&
>  				    (atpx_present() || apple_gmux_detect(NULL, NULL)))
>  					return p;
>  				pci_dev_put(p);
> @@ -1477,7 +1477,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
>  			p = pci_get_domain_bus_and_slot(pci_domain_nr(pci->bus),
>  							pci->bus->number, 0);
>  			if (p) {
> -				if ((p->class >> 16) == PCI_BASE_CLASS_DISPLAY)
> +				if (pci_is_display(p))
>  					return p;
>  				pci_dev_put(p);
>  			}
> -- 
> 2.43.0
> 

