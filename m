Return-Path: <kvm+bounces-29697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF6A9AFCEE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 10:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAA661F23222
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 08:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBA01D2F4E;
	Fri, 25 Oct 2024 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="clx2zOsi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="g3bikHGi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="clx2zOsi";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="g3bikHGi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A68722B666;
	Fri, 25 Oct 2024 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729845951; cv=none; b=EmylY3FnCWxZvscTP2Knrh3XNJF6SvFE4heBr4UfhVlF9uftYO8rA0TWSxZGFAanlQKleD2vbRSVzRMGBzxWyBj+DPqFlTAT8H1LAwonte+TKlC3P+8KjIWJ8qPqJPEtPn/dYLQbh5iWd0c6oVC460uMm/b+klciX/62pDzoeCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729845951; c=relaxed/simple;
	bh=C4fWJFLdEqfmiCwfG0ijR0otCuRMO6pfGtCX8B1l6tQ=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=grYqiJWp3kxKbkVhN8OSROr9lOi60dxAhWBuWuq2on7fM6aZbAbzM4QIGBawwwgJYcjfkm8xdrkNgSz883BwEO49D0xfRlS4FC5MgKtuKQOuGq25xFGS9sGs7n1q9BAmnoeFTLyrB5bgy1SuHvP4IxGdoSFtKaLOdnMufjlfAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=clx2zOsi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=g3bikHGi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=clx2zOsi; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=g3bikHGi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA66B1FDD6;
	Fri, 25 Oct 2024 08:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729845946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLLgMgD1WuFn/eZRfUUwEempoL5IxybItGs0mIW5a9c=;
	b=clx2zOsiRnAuc/eTROpKVLO0ZG2bWwOUHl34fY82qjlAR59nmmv9gR3LTJjwI7qQYdy+Va
	+L4ZLvLaaLX3fgCTVEAvLvlG8BUUEfsdsnwqtRtQXjsQzc/CTJMC5EoXs1I0X1WuxtBHMj
	SGDUlg6cg2a43qISAqaOgFi37jxdQE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729845946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLLgMgD1WuFn/eZRfUUwEempoL5IxybItGs0mIW5a9c=;
	b=g3bikHGiSMvF/vrKNbyrTxKTQLKBT4FQ0i45X842GsWYwukqgd4FAz50GQEct1VSruaxQ8
	VZrEyDx/K8YlfIAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=clx2zOsi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=g3bikHGi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729845946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLLgMgD1WuFn/eZRfUUwEempoL5IxybItGs0mIW5a9c=;
	b=clx2zOsiRnAuc/eTROpKVLO0ZG2bWwOUHl34fY82qjlAR59nmmv9gR3LTJjwI7qQYdy+Va
	+L4ZLvLaaLX3fgCTVEAvLvlG8BUUEfsdsnwqtRtQXjsQzc/CTJMC5EoXs1I0X1WuxtBHMj
	SGDUlg6cg2a43qISAqaOgFi37jxdQE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729845946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fLLgMgD1WuFn/eZRfUUwEempoL5IxybItGs0mIW5a9c=;
	b=g3bikHGiSMvF/vrKNbyrTxKTQLKBT4FQ0i45X842GsWYwukqgd4FAz50GQEct1VSruaxQ8
	VZrEyDx/K8YlfIAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B42513B18;
	Fri, 25 Oct 2024 08:45:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0kI8DblaG2dPaAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Fri, 25 Oct 2024 08:45:45 +0000
Date: Fri, 25 Oct 2024 10:46:46 +0200
Message-ID: <878quctvrd.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Philipp Stanner <pstanner@redhat.com>
Cc: Takashi Iwai <tiwai@suse.de>,	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,	Jiri Kosina
 <jikos@kernel.org>,	Benjamin Tissoires <bentiss@kernel.org>,	Arnd Bergmann
 <arnd@arndb.de>,	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,	Alex
 Dubov <oakad@yahoo.com>,	Sudarsana Kalluru <skalluru@marvell.com>,	Manish
 Chopra <manishc@marvell.com>,	"David S. Miller" <davem@davemloft.net>,	Eric
 Dumazet <edumazet@google.com>,	Jakub Kicinski <kuba@kernel.org>,	Paolo
 Abeni <pabeni@redhat.com>,	Rasesh Mody <rmody@marvell.com>,
	GR-Linux-NIC-Dev@marvell.com,	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,	Kalle Valo <kvalo@kernel.org>,
	Sanjay R Mehta <sanju.mehta@amd.com>,	Shyam Sundar S K
 <Shyam-sundar.S-k@amd.com>,	Jon Mason <jdmason@kudzu.us>,	Dave Jiang
 <dave.jiang@intel.com>,	Allen Hubbe <allenbh@gmail.com>,	Bjorn Helgaas
 <bhelgaas@google.com>,	Alex Williamson <alex.williamson@redhat.com>,
	Juergen Gross <jgross@suse.com>,	Stefano Stabellini
 <sstabellini@kernel.org>,	Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>,	Jaroslav Kysela <perex@perex.cz>,	Takashi
 Iwai <tiwai@suse.com>,	Chen Ni <nichen@iscas.ac.cn>,	Mario Limonciello
 <mario.limonciello@amd.com>,	Ricky Wu <ricky_wu@realtek.com>,	Al Viro
 <viro@zeniv.linux.org.uk>,	Breno Leitao <leitao@debian.org>,	Kevin Tian
 <kevin.tian@intel.com>,	Thomas Gleixner <tglx@linutronix.de>,	Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,	Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>,	Mostafa Saleh
 <smostafa@google.com>,	Jason Gunthorpe <jgg@ziepe.ca>,	Yi Liu
 <yi.l.liu@intel.com>,	Christian Brauner <brauner@kernel.org>,	Ankit Agrawal
 <ankita@nvidia.com>,	Eric Auger <eric.auger@redhat.com>,	Reinette Chatre
 <reinette.chatre@intel.com>,	Ye Bin <yebin10@huawei.com>,	Marek
 =?ISO-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,	Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>,	Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>,	Kai Vehmanen
 <kai.vehmanen@linux.intel.com>,	Rui Salvaterra <rsalvaterra@gmail.com>,
	linux-ide@vger.kernel.org,	linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org,	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,	ntb@lists.linux.dev,
	linux-pci@vger.kernel.org,	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,	linux-sound@vger.kernel.org
Subject: Re: [PATCH 02/13] ALSA: hda_intel: Use always-managed version of pcim_intx()
In-Reply-To: <ae081c36c49733b007a8946dceeec0af94fc449a.camel@redhat.com>
References: <20241015185124.64726-1-pstanner@redhat.com>
	<20241015185124.64726-3-pstanner@redhat.com>
	<87v7xk2ps5.wl-tiwai@suse.de>
	<6f3db65fe9a5dcd1a7a8d9bd5352ecb248ef57b1.camel@redhat.com>
	<87ttd2276j.wl-tiwai@suse.de>
	<aec23bb79b9ff7dd7f13eb67460e0605eac22912.camel@redhat.com>
	<875xphzeun.wl-tiwai@suse.de>
	<ae081c36c49733b007a8946dceeec0af94fc449a.camel@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA66B1FDD6
X-Spam-Score: -3.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[yahoo.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,kernel.org,omp.ru,amd.com,arndb.de,linuxfoundation.org,yahoo.com,marvell.com,davemloft.net,google.com,redhat.com,quantenna.com,gmail.com,kudzu.us,intel.com,suse.com,epam.com,perex.cz,iscas.ac.cn,realtek.com,zeniv.linux.org.uk,debian.org,linutronix.de,linux.intel.com,ziepe.ca,nvidia.com,huawei.com,invisiblethingslab.com,linux.dev,vger.kernel.org,lists.linux.dev,lists.xenproject.org];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_GT_50(0.00)[67];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, 25 Oct 2024 10:37:57 +0200,
Philipp Stanner wrote:
> 
> On Thu, 2024-10-24 at 17:43 +0200, Takashi Iwai wrote:
> > On Thu, 24 Oct 2024 10:02:59 +0200,
> > Philipp Stanner wrote:
> > > 
> > > On Wed, 2024-10-23 at 17:03 +0200, Takashi Iwai wrote:
> > > > On Wed, 23 Oct 2024 15:50:09 +0200,
> > > > Philipp Stanner wrote:
> > > > > 
> > > > > On Tue, 2024-10-22 at 16:08 +0200, Takashi Iwai wrote:
> > > > > > On Tue, 15 Oct 2024 20:51:12 +0200,
> > > > > > Philipp Stanner wrote:
> > > > > > > 
> > > > > > > pci_intx() is a hybrid function which can sometimes be
> > > > > > > managed
> > > > > > > through
> > > > > > > devres. To remove this hybrid nature from pci_intx(), it is
> > > > > > > necessary to
> > > > > > > port users to either an always-managed or a never-managed
> > > > > > > version.
> > > > > > > 
> > > > > > > hda_intel enables its PCI-Device with pcim_enable_device().
> > > > > > > Thus,
> > > > > > > it needs
> > > > > > > the always-managed version.
> > > > > > > 
> > > > > > > Replace pci_intx() with pcim_intx().
> > > > > > > 
> > > > > > > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > > > > > > ---
> > > > > > >  sound/pci/hda/hda_intel.c | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > 
> > > > > > > diff --git a/sound/pci/hda/hda_intel.c
> > > > > > > b/sound/pci/hda/hda_intel.c
> > > > > > > index b4540c5cd2a6..b44ca7b6e54f 100644
> > > > > > > --- a/sound/pci/hda/hda_intel.c
> > > > > > > +++ b/sound/pci/hda/hda_intel.c
> > > > > > > @@ -786,7 +786,7 @@ static int azx_acquire_irq(struct azx
> > > > > > > *chip,
> > > > > > > int do_disconnect)
> > > > > > >  	}
> > > > > > >  	bus->irq = chip->pci->irq;
> > > > > > >  	chip->card->sync_irq = bus->irq;
> > > > > > > -	pci_intx(chip->pci, !chip->msi);
> > > > > > > +	pcim_intx(chip->pci, !chip->msi);
> > > > > > >  	return 0;
> > > > > > >  }
> > > > > > >  
> > > > > > 
> > > > > > Hm, it's OK-ish to do this as it's practically same as what
> > > > > > pci_intx()
> > > > > > currently does.  But, the current code can be a bit
> > > > > > inconsistent
> > > > > > about
> > > > > > the original intx value.  pcim_intx() always stores !enable
> > > > > > to
> > > > > > res->orig_intx unconditionally, and it means that the
> > > > > > orig_intx
> > > > > > value
> > > > > > gets overridden at each time pcim_intx() gets called.
> > > > > 
> > > > > Yes.
> > > > > 
> > > > > > 
> > > > > > Meanwhile, HD-audio driver does release and re-acquire the
> > > > > > interrupt
> > > > > > after disabling MSI when something goes wrong, and pci_intx()
> > > > > > call
> > > > > > above is a part of that procedure.  So, it can rewrite the
> > > > > > res->orig_intx to another value by retry without MSI.  And
> > > > > > after
> > > > > > the
> > > > > > driver removal, it'll lead to another state.
> > > > > 
> > > > > I'm not sure that I understand this paragraph completely.
> > > > > Still,
> > > > > could
> > > > > a solution for the driver on the long-term just be to use
> > > > > pci_intx()?
> > > > 
> > > > pci_intx() misses the restore of the original value, so it's no
> > > > long-term solution, either.
> > > 
> > > Sure that is missing – I was basically asking whether the driver
> > > could
> > > live without that feature.
> > > 
> > > Consider that point obsolete, see below
> > > 
> > > > 
> > > > What I meant is that pcim_intx() blindly assumes the negative of
> > > > the
> > > > passed argument as the original state, which isn't always true. 
> > > > e.g.
> > > > when the driver calls it twice with different values, a wrong
> > > > value
> > > > may be remembered.
> > > 
> > > Ah, I see – thoguh the issue is when it's called several times with
> > > the
> > > *same* value, isn't it?
> > > 
> > > E.g.
> > > 
> > > pcim_intx(pdev, 1); // 0 is remembered as the old value
> > > pcim_intx(pdev, 1); // 0 is falsely remembered as the old value
> > > 
> > > Also, it would seem that calling the function for the first time
> > > like
> > > that:
> > > 
> > > pcim_intx(pdev, 0); // old value: 1
> > > 
> > > is at least incorrect, because INTx should be 0 per default,
> > > shouldn't
> > > it? Could then even be a 1st class bug, because INTx would end up
> > > being
> > > enabled despite having been disabled all the time.
> > 
> > Yeah, and the unexpected restore can happen even with a single call
> > of
> > pcim_intx(), if the driver calls it unnecessarily.
> > 
> > > > That said, I thought of something like below.
> > > 
> > > At first glance that looks like a good idea to me, thanks for
> > > working
> > > this out!
> > > 
> > > IMO you can submit that as a patch so we can discuss it separately.
> > 
> > Sure, I'm going to submit later.
> 
> I just took a look into the old implementation of pci_intx() (there was
> no pcim_intx() back then), before I started cleaning up PCI's devres.
> This what it looked like before
> 25216afc9db53d85dc648aba8fb7f6d31f2c8731:
> 
> void pci_intx(struct pci_dev *pdev, int enable)
> {
> 	u16 pci_command, new;
> 
> 	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
> 
> 	if (enable)
> 		new = pci_command & ~PCI_COMMAND_INTX_DISABLE;
> 	else
> 		new = pci_command | PCI_COMMAND_INTX_DISABLE;
> 
> 	if (new != pci_command) {
> 		struct pci_devres *dr;
> 
> 		pci_write_config_word(pdev, PCI_COMMAND, new);
> 
> 		dr = find_pci_dr(pdev);
> 		if (dr && !dr->restore_intx) {
> 			dr->restore_intx = 1;
> 			dr->orig_intx = !enable;
> 		}
> 	}
> }
> EXPORT_SYMBOL_GPL(pci_intx);
> 
> If I'm not mistaken the old version did not have the problem because
> the value to be restored only changed if new != pci_command.
> 
> That should always be correct, what do you think?
> 
> If so, only my commit 25216afc9db53d85dc648aba8fb7f6d31f2c8731 needs to
> be fixed.

Yes, it looks so.  Fortunately my submitted patch pointed to the right
Fixes tag :)


thanks,

Takashi

