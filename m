Return-Path: <kvm+bounces-71658-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GZQMsT2nWlzSwQAu9opvQ
	(envelope-from <kvm+bounces-71658-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:06:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7588018BABD
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86C99310612E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA0A2EDD6B;
	Tue, 24 Feb 2026 19:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C5BRflp7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D7C2DB798
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771959790; cv=none; b=oikSIqBqnYO0eZl3q82G07PJ6TEiMHbgLWbQiNRy6zUQ7Xp7MuZNrYDkoxKUcCmsxTnPcb+d2QuS6HFMZeU3rV8QXrRmCj5tqVSgYnZL9JXOFhWAj2oobyEKQzdb1N1WeoPqwx3Agi1V2lEBS9GjKJ4O16sdLCK9kBHTgFFpjiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771959790; c=relaxed/simple;
	bh=BPzlPvPufPvOXP3pdB2UQNj5Uct014GMnFkHawwDFwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grrbVqxZIanDmnY/GAMa7CG9BfRLDkMuPQXcpHrtJFNJJwdif2wOjJJdv/p26h28o353El+D9o08HoGHiyGJgiqXfsBIemxifD6k72GjK+TE/b/QYRD5fzjQ7HREvQU6iWAafItFhd/ekH5XtL2PDXN6htUfL9jyszUd3nPDSpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C5BRflp7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a964077671so10645ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 11:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771959788; x=1772564588; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X93b96xDCWqbNSn/Osk0k6D0QiHzoDXCBhSgmB8C344=;
        b=C5BRflp7hBmvCOLgrrC9JjY3twQOp4qCXCTstDD4ptm7eSR2E39Bks8f90j+qmqyxI
         bjtiYPVwZe4NHktOTYXcr0b8fH5F8qYur5JC/kMuGDe6cPPGvS8fW92HDMornloiLHh/
         wHyxwKd4palG6NtIRkDe5crr/Ut5WU9PuGXX16ETlj0XPCLKUB1NakSUvLXhHbzUBLS+
         bYCF1ZPn3cEbF9lllRIOwLpr5Kuq3R7mKBAsKWT5JVone/CG6Y0QazPDWDLyCqos0fBn
         0Zg8CwS2nVL64xRMZmqKPXpQgwI2QthEsePUWb2xp9uFFsR5WidLPPMzgnw18m2A5BSO
         HJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771959788; x=1772564588;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X93b96xDCWqbNSn/Osk0k6D0QiHzoDXCBhSgmB8C344=;
        b=iweNQdXQcR0NBvilTAaOL9OhMs5MXDUe5bxNsoM0PMkPqXrU0iDL39qdKhlf+UDeKY
         umsTxg0l+JlbMFl3v69zLY64DDudNt2f/t+8f1zEquTndnS8OpbEg6U1e9RGUHxPh34K
         8hSjLi29TcXpxSj8ogaLkyiv25rEci/vgW3KjCVSM+8ZaqCUjTInsTMP1G8FPdyN8Th2
         2+UHTSAh2jNYbvZM1m7QHej0nny/UddwiL8htyuPOkWSuOsbKlLv8dq6m8PCiBi6y7aM
         8ki7fhiZMhMQMi6bpu4Anmo0LZLxLpn8v6qpyrqqZk52NKe+n3MExqIcsroYrG0dWWtd
         D1Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVhgj5wDnF6GmM71QujsEZlOxq9eim4sYtoabBDA/BWNpB2RMptpdcEVj8CEqAL7qrjNrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ/MCwtvhaeYqzb0+greHEncFoWuZ0UDBLrxdxKnQhiQfrzErv
	55W7/OBTwywPaVM0wsOqi0fNvVUqSoz58XP/bWi04Vkv108tqfVegkRwOLCAJ+vW8w==
X-Gm-Gg: ATEYQzxD7OefPJN8pNn7/tbo6HIxsrGKw4LD1Al2hzAMv1Avz5njeQBNCY+hVmo7aDB
	Ko76CouGk00BFeU4Erb8EsIbL/ZM2NoNkPCDivLETQ4TT91gFG14JuXRBpd0NIewSw5R7JtHdxD
	YM29WvmlmhuowwkUe6mzippIebLNjmH8Z6JHZ7iD/r4WIveea5vbLcOejhLYSR9eGoRVYcOb7pg
	AaZO+ISR4BVn8SUw7wMW94ZSKr+RZ2flu/gNHfzwh74UFDoUHzGRuhp0lCoZTM9WuvdwfM1TRbV
	WS4+ZsX/owe59V8UGrulbWgxPCBCBxlHqC9+JESrTnFqpuOvv22j/+biEKzSdkSO7cY5cjz2awF
	UAW6LpFlpr7cGV7rruwykj4tWXMGShXqHXKwFk41vJ3FPH7vUjuLQZqmJlWRAZ8UAm2pfIC2rOw
	1jpuLOu5QI6tYrxXTRyN02uEEmIkUvqjSOhdxK3xm9yZTmkwWnjy41JZJ0CjVq
X-Received: by 2002:a17:902:c412:b0:2a9:5bfa:54ef with SMTP id d9443c01a7336-2adca6c8e0amr234085ad.10.1771959787309;
        Tue, 24 Feb 2026 11:03:07 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74d36911sm114902575ad.0.2026.02.24.11.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:03:06 -0800 (PST)
Date: Tue, 24 Feb 2026 19:02:56 +0000
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
Message-ID: <aZ314HSRnYtGinTU@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
 <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71658-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7588018BABD
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 09:33:28AM -0800, David Matlack wrote:
> On Tue, Feb 24, 2026 at 1:18 AM Pranjal Shrivastava <praan@google.com> wrote:
> > On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > > + * Copyright (c) 2025, Google LLC.
> >
> > Nit: Should these be 2026 now?
> 
> Yes! Thanks for catching that.
> 
> > > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > > +{
> > > +     struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
> > > +     struct pci_ser *ser;
> > > +     int i, ret;
> > > +
> > > +     /* Preserving VFs is not supported yet. */
> > > +     if (dev->is_virtfn)
> > > +             return -EINVAL;
> > > +
> > > +     guard(mutex)(&pci_flb_outgoing_lock);
> > > +
> > > +     if (dev->liveupdate_outgoing)
> > > +             return -EBUSY;
> > > +
> > > +     ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > +             return -E2BIG;
> >
> > I'm wondering how (or if) this handles hot-plugged devices?
> > max_nr_devices is calculated based on for_each_pci_dev at the time of
> > the first preservation.. what happens if a device is hotplugged after
> > the first device is preserved but before the second one is, does
> > max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> > the actual possible device count, potentially leading to an unnecessary
> > -E2BIG failure?
> 
> Yes, it's possible to run out space to preserve devices if devices are
> hot-plugged and then preserved. But I think it's better to defer
> handling such a use-case exists (unless you see an obvious simple
> solution). So far I am not seeing preserving hot-plugged devices
> across Live Update as a high priority use-case to support.
> 

Ack. If we aren't supporting preservation for hot-plug at this point.
Let's mention that somewhere? Maybe just a little comment or the kdoc?

> > > +u32 pci_liveupdate_incoming_nr_devices(void)
> > > +{
> > > +     struct pci_ser *ser;
> > > +     int ret;
> > > +
> > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return 0;
> >
> > Masking this error looks troubled, in the following patch, I see that
> > the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> > BDF might still be preserved? Which could lead to DMA aliasing issues,
> > without a hint of what happened since we don't even log anything.
> 
> All fo the non-0 errors indicate there are 0 incoming devices at the
> time of the call, so I think returning 0 is appropriate.
> 
>  - EOPNOTSUPP: Live Update is not enabled.
>  - ENODATA: Live Update is finished (all incoming devices have been restored).
>  - ENOTENT: No PCI data was preserved across the Live Update.
> 
> None of these cover the case where an IOMMU mapping for BDF X is
> preserved, but device X is not preserved. This is a case we should
> handle in some way... but here is not that place.
> 
> >
> > Maybe we could have something like the following:
> >
> > int pci_liveupdate_incoming_nr_devices(void)
> > {
> >         struct pci_ser *ser;
> >         int ret;
> >
> >         ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> >         if (ret) {
> >                 if (ret != -ENOENT)
> >                         pr_warn("PCI: Failed to retrieve preservation list: %d\n", ret);
> 
> This would cause this warning to get printed if Live Update was
> disabled, or if no PCI devices were preserved. But both of those are
> not error scenarios.
> 

I agree, the snippet was just an example. What I'm trying to say here
is, what if the retval is -ENOMEM / -ENODATA, the existing code will
treat it as a fresh boot because it believes there are no incoming 
devices. However, since this was an incoming device which failed to be
retrieved, there's a chance that it's IOMMU mapping was preserved too.
By returning 0, the PCI core will feel free to rebalance bus numbers or
reassign BARs. For instance, if the IOMMU already inherited mappings for
BDF 02:00.0, but the PCI core (due to this masked error) reassigns a 
different device to that BDF, we face DMA aliasing or IOMMU faults.
Am I missing some context here?

> > > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > > +{
> > > +     struct pci_ser *ser;
> > > +     int ret;
> > > +
> > > +     ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&ser);
> > > +     if (ret)
> > > +             return;
> >
> > We should log something here either at info / debug level since the
> > error isn't bubbled up and the luo_core doesn't scream about it either.
> 
> Any error from liveupdate_flb_get_incoming() simply means there are no
> incoming devices. So I don't think there's any error to report in
> dmesg.
> 
> > > +     dev->liveupdate_incoming = !!pci_ser_find(ser, dev);
> >
> > This feels a little hacky, shall we go for something like:
> >
> > dev->liveupdate_incoming = (pci_ser_find(ser, dev) != NULL); ?
> 
> In my experience in the kernel (mostly from KVM), explicity comparison
> to NULL is less preferred to treating a pointer as a boolean. But I'm
> ok with following whatever is the locally preferred style for this
> kind of check.
> 

No strong feelings there, I see both being used in drivers/pci.

> > > @@ -582,6 +583,10 @@ struct pci_dev {
> > >       u8              tph_mode;       /* TPH mode */
> > >       u8              tph_req_type;   /* TPH requester type */
> > >  #endif
> > > +#ifdef CONFIG_LIVEUPDATE
> > > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous kernel */
> > > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next kernel */
> > > +#endif
> > >  };
> >
> > This would start another anon bitfield container, should we move this
> > above within the existing bitfield? If we've run pahole and found this
> > to be better, then this should be fine.
> 
> Yeah I simply appended these new fields to the very end of the struct.
> If we care about optimizing the packing of struct pci_dev I can find a
> better place to put it.

If you have pahole handy, it would be great to see if these can slide 
into an existing hole. If not, no big deal for v3.. we can keep it as is

Thanks,
Praan

