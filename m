Return-Path: <kvm+bounces-71660-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aAyGAJb2nWlzSwQAu9opvQ
	(envelope-from <kvm+bounces-71660-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:05:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B30AF18BA97
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EABA2301E993
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DF32DB791;
	Tue, 24 Feb 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XjJ57PV6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A707F2ED860
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959954; cv=none; b=dF59kn+XlViVs1UOZRRP5EZbxq9ORFcdN3hhNx9J8lKSY8tzuC4ZEmc6LroJ9NHrFb5jQ5oZ3i4UWysDwecwgJpbBCn+JCCCtpBpyoeHHTbzOkr25CjXoWfulOE0OJ+bhcNqUjuRJQtFgpnbKYeoSWM43WZs8iK5cOogpquPx3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959954; c=relaxed/simple;
	bh=zLqgOJeQ8HcmcMPj/D6Uk1/9jsKVA5Yl6xqHM2G/ipc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JK7rLv5mHSAn4zLdrUkEdKV3FeVfIffYowgILkUkzR3sk8Z7WmRNd46KNPdi0YLV/Ut7xPWRNvjNcFIWZ73GDK32F311B72lJAFJw9RXQddymwtO+lV+7QPoDMUDjOgLWRqVUH8ABpyZt0qUlaDRN4+ohapc6bMH3mhz5n4wvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XjJ57PV6; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so12175ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771959952; x=1772564752; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y+nxktJgrzlaK8SQflM75E9Ffs6HGnnvzkBNJC6O+O8=;
        b=XjJ57PV6eCuG03bEGDsZ1mTTjXgW7DqNA+G3Le3UkilUzXAv/s2ILGXnncw7uhLBON
         6H4jE55Vnvcs8sMeNPgYXGftRYR1zsLUreXAjpXUvr94HRn8C4cJB7h0tUiQ4kyFRtp2
         C59fePh3kba907GAjgNdxlBxVtaxXJ+H6mySqd4tp6OWS9K/TUMoqL0hCiOLW48HmDIn
         WN72WF1QNt3QnJyHC7/kNKUgdjY5uJRsFkbIH2brkdsogt/KTVWXN5vExTvt7jHCBoro
         aD6c0fZdh6rpnWV4vqLZTCa5um8CwPMjpuLzBdpWhc8kI0VbcXzKDr5vWjnNkusM1txX
         jVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959952; x=1772564752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+nxktJgrzlaK8SQflM75E9Ffs6HGnnvzkBNJC6O+O8=;
        b=KJiAiKI1u16YDqSCS+EdAgEx0nuN2Twi9Wg93mr0lVmerRq0qs8nE3jlR7/ANqZ2ro
         n8fnmp0nuTYYFpvBAD7PATq1G/M2QcfBQ1RFYWH6VmkPIAg3X87dhMgtbWg00WnJ2IuB
         Q2KrL4VDfSd2oLAkH2cMHXTLEc51161OzZVh3Xx3MhdpRcezAYXwvfc5KK2ND4zMqbG1
         AoSEqkZzWCh0yDV5wOpbWgMWUYj75KIYGAh3b9J3kOcvZMGkqBV6wW+cAxGGcbdM2+oY
         x+CrS4LmYZhB7pxLb9nehcZux2kg+D9jLuw5FO/aTR2ymLPg8292BOqfMU63XtZZlWug
         5kWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWpliS2dQHV8oSvH0lAc0RX3X8sh5oZaCpPE2quq2xsASrLuhSh+Y9TcYjn0MCbXztlWo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxodeWxM5aOKqP+GD7O1AaKhRb/yCCBMA0twHYVNc6yFIHkZgix
	TM72nFTdmcdf2CYBdGfp29X2ZRB2EO8LLjkat5ZpjDj77oulUPecLpAPfGZgQOcC2A==
X-Gm-Gg: ATEYQzx/wUJMC2wT4QTFcYMiibJcjMDhuZjCjZEXUvJBLmpGQzTAYPOr8YWwOv62YRS
	kwOyPHvQ5l8JLgctvU3t4Ul/uc/mSIcOIk6e13aZctS3XMUQjTRbS9o0Y2+oe+WsKQEau6w9hyE
	mXbsNR43BkWuEcnlodzaYl3+cKnU5bgZUIXG0AQ3HX2EvC1Eaxf6qrbZ7wV39YvkSTlYDK/hhfk
	wORTtH0aoKpoDz4r5ljgMqJjtltcWthFb1lcUjj0CcHaAEk5Jv+EdFl+EIm2Dl7cdjdGlT46FD+
	E68MHKhbxzHYbI+hz2BuFnYtvfdReq4bamY/RZWY8BMB1BVsY+CxtyXvAttte2j+lD4en7nCqR9
	9BPH5nzth4+yVNHOult7fahZXOTxMGlifNecxrHgSvl90p+6DdACh6c6RynlDtDvb6mBcmTh1g/
	REqpvxeBEqA7Yxv8UYVYZBsUza7m7k/3TqvWYYxqOeCS+cQDDjoI79r36cPGqP
X-Received: by 2002:a17:903:3d0c:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2adca83b652mr139205ad.11.1771959951330;
        Tue, 24 Feb 2026 11:05:51 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3590241e8a2sm595715a91.12.2026.02.24.11.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:05:50 -0800 (PST)
Date: Tue, 24 Feb 2026 19:05:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
Message-ID: <aZ32hf3dHibfb4B5@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
 <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
 <aZ314HSRnYtGinTU@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZ314HSRnYtGinTU@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71660-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B30AF18BA97
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 07:02:56PM +0000, Pranjal Shrivastava wrote:
> On Tue, Feb 24, 2026 at 09:33:28AM -0800, David Matlack wrote:
> > On Tue, Feb 24, 2026 at 1:18 AM Pranjal Shrivastava <praan@google.com> wrote:
> > > On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > > > + * Copyright (c) 2025, Google LLC.
> > >
> > > Nit: Should these be 2026 now?
> > 
> > Yes! Thanks for catching that.
> > 
> > > > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > > > +{
> > > > +     struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> > > > +     struct pci_ser *ser;
> > > > +     int i, ret;
> > > > +
> > > > +     /* Preserving VFs is not supported yet. */
> > > > +     if (dev->is_virtfn)
> > > > +             return -EINVAL;
> > > > +
> > > > +     guard(mutex)(&pci_flb_outgoing_lock);
> > > > +
> > > > +     if (dev->liveupdate_outgoing)
> > > > +             return -EBUSY;
> > > > +
> > > > +     ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > > +             return -E2BIG;
> > >
> > > I'm wondering how (or if) this handles hot-plugged devices?
> > > max_nr_devices is calculated based on for_each_pci_dev at the time of
> > > the first preservation.. what happens if a device is hotplugged after
> > > the first device is preserved but before the second one is, does
> > > max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> > > the actual possible device count, potentially leading to an unnecessary
> > > -E2BIG failure?
> > 
> > Yes, it's possible to run out space to preserve devices if devices are
> > hot-plugged and then preserved. But I think it's better to defer
> > handling such a use-case exists (unless you see an obvious simple
> > solution). So far I am not seeing preserving hot-plugged devices
> > across Live Update as a high priority use-case to support.
> > 
> 
> Ack. If we aren't supporting preservation for hot-plug at this point.
> Let's mention that somewhere? Maybe just a little comment or the kdoc?
> 
> > > > +u32 pci_liveupdate_incoming_nr_devices(void)
> > > > +{
> > > > +     struct pci_ser *ser;
> > > > +     int ret;
> > > > +
> > > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return 0;
> > >
> > > Masking this error looks troubled, in the following patch, I see that
> > > the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> > > BDF might still be preserved? Which could lead to DMA aliasing issues,
> > > without a hint of what happened since we don't even log anything.
> > 
> > All fo the non-0 errors indicate there are 0 incoming devices at the
> > time of the call, so I think returning 0 is appropriate.
> > 
> >  - EOPNOTSUPP: Live Update is not enabled.
> >  - ENODATA: Live Update is finished (all incoming devices have been restored).
> >  - ENOTENT: No PCI data was preserved across the Live Update.
> > 

The flb_retrive_one seems to call:

 err = flb->ops->retrieve(&args);

which could be anything honestly.. since the luo_core doesn't scream
about it, maybe the caller should?

Thanks,
Praan

> > None of these cover the case where an IOMMU mapping for BDF X is
> > preserved, but device X is not preserved. This is a case we should
> > handle in some way... but here is not that place.
> > 
> > >
> > > Maybe we could have something like the following:
> > >
> > > int pci_liveupdate_incoming_nr_devices(void)
> > > {
> > >         struct pci_ser *ser;
> > >         int ret;
> > >
> > >         ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > >         if (ret) {
> > >                 if (ret != -ENOENT)
> > >                         pr_warn("PCI: Failed to retrieve preservation list: %d\n", ret);
> > 
> > This would cause this warning to get printed if Live Update was
> > disabled, or if no PCI devices were preserved. But both of those are
> > not error scenarios.
> > 
> 
> I agree, the snippet was just an example. What I'm trying to say here
> is, what if the retval is -ENOMEM / -ENODATA, the existing code will
> treat it as a fresh boot because it believes there are no incoming 
> devices. However, since this was an incoming device which failed to be
> retrieved, there's a chance that it's IOMMU mapping was preserved too.
> By returning 0, the PCI core will feel free to rebalance bus numbers or
> reassign BARs. For instance, if the IOMMU already inherited mappings for
> BDF 02:00.0, but the PCI core (due to this masked error) reassigns a 
> different device to that BDF, we face DMA aliasing or IOMMU faults.
> Am I missing some context here?
> 
> > > > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > > > +{
> > > > +     struct pci_ser *ser;
> > > > +     int ret;
> > > > +
> > > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > > +     if (ret)
> > > > +             return;
> > >
> > > We should log something here either at info / debug level since the
> > > error isn't bubbled up and the luo_core doesn't scream about it either.
> > 
> > Any error from liveupdate_flb_get_incoming() simply means there are no
> > incoming devices. So I don't think there's any error to report in
> > dmesg.
> > 
> > > > +     dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> > >
> > > This feels a little hacky, shall we go for something like:
> > >
> > > dev->liveupdate_incoming = (pci_ser_find(ser, dev) != NULL); ?
> > 
> > In my experience in the kernel (mostly from KVM), explicity comparison
> > to NULL is less preferred to treating a pointer as a boolean. But I'm
> > ok with following whatever is the locally preferred style for this
> > kind of check.
> > 
> 
> No strong feelings there, I see both being used in drivers/pci.
> 
> > > > @@ -582,6 +583,10 @@ struct pci_dev {
> > > >       u8              tph_mode;       /* TPH mode */
> > > >       u8              tph_req_type;   /* TPH requester type */
> > > >  #endif
> > > > +#ifdef CONFIG_LIVEUPDATE
> > > > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous kernel */
> > > > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next kernel */
> > > > +#endif
> > > >  };
> > >
> > > This would start another anon bitfield container, should we move this
> > > above within the existing bitfield? If we've run pahole and found this
> > > to be better, then this should be fine.
> > 
> > Yeah I simply appended these new fields to the very end of the struct.
> > If we care about optimizing the packing of struct pci_dev I can find a
> > better place to put it.
> 
> If you have pahole handy, it would be great to see if these can slide 
> into an existing hole. If not, no big deal for v3.. we can keep it as is
> 
> Thanks,
> Praan

