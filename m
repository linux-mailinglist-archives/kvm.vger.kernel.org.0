Return-Path: <kvm+bounces-29560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5049ACE24
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 238891F22527
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FAC1C9B91;
	Wed, 23 Oct 2024 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2ItZ1jDF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yBKR04wg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fWmPOTyF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YuZHxXn8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B1E1AD41F;
	Wed, 23 Oct 2024 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695725; cv=none; b=JFIVbuLY/wv7PK5iEyaPOERAN9Di3Trpye76gXoxOtz6r+rImmLStPX6Dj30PBY8A2aYQK65VUAf/m8fWlVf2yamdDEAw5V99M2j0ypgoFh3J2uHkVIW96qfzM+H4O1rHCU+0aeHbPUjHyShQHt/imv2H7gKF4piBw98dG+q9bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695725; c=relaxed/simple;
	bh=3xEw+UXfsGP26z4Sgtrqe6P0a/swHKk3oKUuT9CCyZY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=es/Xve1o3XSGgEgF9ttu+R1l1mgvsjjub3a/o1YPo6LqkiW0YDtM4K76ZMtf9C6U6J8iIPQBmArNCla6/oGwaW0faJEteRFlkwQiZ38hzlztjAvVggIR4dQkPSIohG6RIRQkrjKJAZGjLlx/Wfdohw5Yjz/CKMNyi5uNQNUFRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2ItZ1jDF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yBKR04wg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fWmPOTyF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YuZHxXn8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E4C0922003;
	Wed, 23 Oct 2024 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729695722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45xK/8+G8mZGVAAi4hFp9PxMXe5ylZqkKcyee7y5QO0=;
	b=2ItZ1jDFGk8fncyzUjOD6XP1yUrNx0clEVu6vx5PlWgY0pzhWkTG+ZtGuTuCRk8o3opkVR
	dfMKygDgm3Jq5vAgizfUaf8cKtsAeQ4XF/G6TOOvoC1PCvT0gXtIJ6o1YtCFBpqgxn1lRp
	fSH3oUU/jApkJIS3ff7Z5Hf6ZDSyVCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729695722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45xK/8+G8mZGVAAi4hFp9PxMXe5ylZqkKcyee7y5QO0=;
	b=yBKR04wgmFIDNWBjE5QW+Hnw1mB3+YpLhbGyrDlSE5v42/Wn0oqwJTXtDYuSVV5bI/aQHq
	NeWZpYvZRGkV4xCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729695720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45xK/8+G8mZGVAAi4hFp9PxMXe5ylZqkKcyee7y5QO0=;
	b=fWmPOTyFFK+VxPBZQ27E8g8Odi0gvPqUHrkqQ2QKeK3e96V7dTVsrUlTrX8fBfFIRYP2SR
	9X8KyTWE0pPVrtX25EqinQG9f1t/MMtZPc4BYI42RYSDXTHUEdo2fpuxgIh4wXKOC6E8vP
	AtQwg7XXJKV2vlZYgc+r1cxzrlGkyFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729695720;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45xK/8+G8mZGVAAi4hFp9PxMXe5ylZqkKcyee7y5QO0=;
	b=YuZHxXn8vf1q/VffvvFlmQV8HJADESPXQVyITePngDv64EqgM+RiZEQG2jZ271+0TbFBkM
	esX+WixusA/YvVCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68CEE13A63;
	Wed, 23 Oct 2024 15:01:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NCtrGOcPGWeBIAAAD6G6ig
	(envelope-from <tiwai@suse.de>); Wed, 23 Oct 2024 15:01:59 +0000
Date: Wed, 23 Oct 2024 17:03:00 +0200
Message-ID: <87ttd2276j.wl-tiwai@suse.de>
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
In-Reply-To: <6f3db65fe9a5dcd1a7a8d9bd5352ecb248ef57b1.camel@redhat.com>
References: <20241015185124.64726-1-pstanner@redhat.com>
	<20241015185124.64726-3-pstanner@redhat.com>
	<87v7xk2ps5.wl-tiwai@suse.de>
	<6f3db65fe9a5dcd1a7a8d9bd5352ecb248ef57b1.camel@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[yahoo.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_GT_50(0.00)[67];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,kernel.org,omp.ru,amd.com,arndb.de,linuxfoundation.org,yahoo.com,marvell.com,davemloft.net,google.com,redhat.com,quantenna.com,gmail.com,kudzu.us,intel.com,suse.com,epam.com,perex.cz,iscas.ac.cn,realtek.com,zeniv.linux.org.uk,debian.org,linutronix.de,linux.intel.com,ziepe.ca,nvidia.com,huawei.com,invisiblethingslab.com,linux.dev,vger.kernel.org,lists.linux.dev,lists.xenproject.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 23 Oct 2024 15:50:09 +0200,
Philipp Stanner wrote:
> 
> On Tue, 2024-10-22 at 16:08 +0200, Takashi Iwai wrote:
> > On Tue, 15 Oct 2024 20:51:12 +0200,
> > Philipp Stanner wrote:
> > > 
> > > pci_intx() is a hybrid function which can sometimes be managed
> > > through
> > > devres. To remove this hybrid nature from pci_intx(), it is
> > > necessary to
> > > port users to either an always-managed or a never-managed version.
> > > 
> > > hda_intel enables its PCI-Device with pcim_enable_device(). Thus,
> > > it needs
> > > the always-managed version.
> > > 
> > > Replace pci_intx() with pcim_intx().
> > > 
> > > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
> > > ---
> > >  sound/pci/hda/hda_intel.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> > > index b4540c5cd2a6..b44ca7b6e54f 100644
> > > --- a/sound/pci/hda/hda_intel.c
> > > +++ b/sound/pci/hda/hda_intel.c
> > > @@ -786,7 +786,7 @@ static int azx_acquire_irq(struct azx *chip,
> > > int do_disconnect)
> > >  	}
> > >  	bus->irq = chip->pci->irq;
> > >  	chip->card->sync_irq = bus->irq;
> > > -	pci_intx(chip->pci, !chip->msi);
> > > +	pcim_intx(chip->pci, !chip->msi);
> > >  	return 0;
> > >  }
> > >  
> > 
> > Hm, it's OK-ish to do this as it's practically same as what
> > pci_intx()
> > currently does.  But, the current code can be a bit inconsistent
> > about
> > the original intx value.  pcim_intx() always stores !enable to
> > res->orig_intx unconditionally, and it means that the orig_intx value
> > gets overridden at each time pcim_intx() gets called.
> 
> Yes.
> 
> > 
> > Meanwhile, HD-audio driver does release and re-acquire the interrupt
> > after disabling MSI when something goes wrong, and pci_intx() call
> > above is a part of that procedure.  So, it can rewrite the
> > res->orig_intx to another value by retry without MSI.  And after the
> > driver removal, it'll lead to another state.
> 
> I'm not sure that I understand this paragraph completely. Still, could
> a solution for the driver on the long-term just be to use pci_intx()?

pci_intx() misses the restore of the original value, so it's no
long-term solution, either.

What I meant is that pcim_intx() blindly assumes the negative of the
passed argument as the original state, which isn't always true.  e.g.
when the driver calls it twice with different values, a wrong value
may be remembered.

That said, I thought of something like below.


thanks,

Takashi

-- 8< --
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -438,8 +438,17 @@ static void pcim_intx_restore(struct device *dev, void *data)
 	__pcim_intx(pdev, res->orig_intx);
 }
 
-static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
+static void save_orig_intx(struct pci_dev *pdev)
 {
+	u16 pci_command;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &pci_command);
+	res->orig_intx = !(pci_command & PCI_COMMAND_INTX_DISABLE);
+}
+
+static struct pcim_intx_devres *get_or_create_intx_devres(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
 	struct pcim_intx_devres *res;
 
 	res = devres_find(dev, pcim_intx_restore, NULL, NULL);
@@ -447,8 +456,10 @@ static struct pcim_intx_devres *get_or_create_intx_devres(struct device *dev)
 		return res;
 
 	res = devres_alloc(pcim_intx_restore, sizeof(*res), GFP_KERNEL);
-	if (res)
+	if (res) {
+		save_orig_intx(pdev);
 		devres_add(dev, res);
+	}
 
 	return res;
 }
@@ -467,11 +478,10 @@ int pcim_intx(struct pci_dev *pdev, int enable)
 {
 	struct pcim_intx_devres *res;
 
-	res = get_or_create_intx_devres(&pdev->dev);
+	res = get_or_create_intx_devres(pdev);
 	if (!res)
 		return -ENOMEM;
 
-	res->orig_intx = !enable;
 	__pcim_intx(pdev, enable);
 
 	return 0;

