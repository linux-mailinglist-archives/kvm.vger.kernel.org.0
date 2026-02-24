Return-Path: <kvm+bounces-71603-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4CPyE5N2nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71603-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:59:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F15A11850D0
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69CD7313E9A2
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433F836B07C;
	Tue, 24 Feb 2026 09:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uCUyw9Al"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363F436C0CF
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 09:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771927147; cv=none; b=YjCrzRvHqnX1gun1bkH6FRb4AjXv1GxI8xBw7p/eQkDDvM5TVdBnOexJ/zCG5uyJWCeBOYhx/Bjyd5teEiI6sQX0PLYB2dg3DWfTRl1b8jTTucR0yReAxroqpB9pNyuoBXl8Qw3fUQ1KZ/jG/NGxdOPguuB7CEzfuPlK7p8Dru4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771927147; c=relaxed/simple;
	bh=cYr0xUn2xpNr3LTiRgwKnDqbAR7IqxyWqSNGui5urxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8YcZnabJdWEcWETgpaeAryS/6hjkuKgGk9QzBnKBnXikeOO5eYDpkxlkRUOO02f8sANwqipU/m1SG3uS3nhAEawnXq2XFmeRgdytDgge2pTyBBckdjqvqD/Wo9bGaxlQKcoN4vBxOjNxVtR4WC4Kmng1QqmTvSvg3HLSkdzCPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uCUyw9Al; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so17165ad.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 01:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771927145; x=1772531945; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eblwuyUmTR+DmwKKXt5BlH8l1BOeREzivs7XkohPLYU=;
        b=uCUyw9AlNwbRuefdrpUdTPOvI0KUShaOZjAi7J5omIczWc8043+ENP0tCQNs1txptr
         y2SwDWgW1a+2ql/GvKM+vPj67HhE7FwMXWzdDL0iPK61tIQE2j0ecqhKy/2nigz6bifF
         1jG3mGs365+IfLNiqm26WlB45gmRxGnMOMksatYvwkc1g3gJLti1Zh9t01CuilIFwbll
         1TgM61cfNydIcqELmjZlSSyNol8WsKYCT58Uik8kxkR2a68cq8hsrQGEqT1Svp7yhmzc
         jDDsPJlX7gu+BssVVgHwqU0DGqQ9FvlhZz29o0ii1/ZxY7ZMUU9XapbwWY76J1slcqGQ
         iL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771927145; x=1772531945;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eblwuyUmTR+DmwKKXt5BlH8l1BOeREzivs7XkohPLYU=;
        b=F/vdoIPrLzwm7oRnk8F0HVc5XrwIwQ99MnsCV4EBy/yb+P/bSL6CTwv4+y9w7Adtig
         GXU+YVyzRsENYxXz4lkfGDWucktk+4P2tkoAFINzirxbPYZ3mjqCSOEuIjsH06/mm61i
         np295JYrMNUHlQ1f0FnrBXnU8vYj4ooO3JMKbdzIp/sAfAN1TbhCrWyqjHrRMSq5shOg
         Jqvk/wRVx2xYXXidKcL8XGOnV1RQ9jsnMpBr7+8B+XwmraffYZt0sB4cc/aBL1/qIDdB
         tI0iMzqY30CpK/5R9aRkTSqMPk8rEGn4uBz5+QlQUdYXnBASuuRKhwCyb6KhUgCwnqYd
         wi1A==
X-Forwarded-Encrypted: i=1; AJvYcCXHk1dOBVh1U2eK8h3l5SYqlZAyxrT2kdKmP3vZk1x6lwviIt4Zt+xdCyKIf83nFSykO+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YylP2Kf7qEsOqyvRwf6bw1wn4Vaj+2F35CtZAuciPdZ00Fz7B8B
	0jwut93GMldslnjDK6njKkXx3PJjmnRePr/7ZMpNOAruzSGk8DNO3zf7c7O3A7aIXw==
X-Gm-Gg: ATEYQzwUGgYBjb/AwmN2/SsKcMUjBM7LPL6Ht9TE4R/K5GM7ys8DGdDkRuZUmL+6222
	8lEbEYyNJHjDhWttR/WiWTDi0qsif16d2DFUOHtrK9pVtfYV4KUs3O/FgyerYP+gzVU/fkZ7HaS
	yxYEzQhAOJxnNsH2Yxum8cHtGI4OCunVM3FphyRHMXEg8+SjbN/0X+zJqjcTB4x+lav03idc/g1
	yeCqsUO8fbszDbdnSnMArBW9e2xf048uQNS/PHFRgJ2YTCsB6VX7a/Ms8WzZn5+7GCroMtbRMng
	sedyspBOVBjb+aSi65RFopWTtBv8lnkx76vdzFxlpCYWXPrExW5Uqsji8+iFHwwnYqb1DaW8jnt
	KzDaqIwdwvENH374sqgJM/tD3TRL8i1x1wAOEecTlN50yCdC5+4on18Ws5R/dpHZhyTEJXO2Trt
	M1ZXy+UQLpeZ7LcSzZmfZOG/57AgjI5zS/DLYaTNCn7fAe+fIXJ57/+o3wxZuFULSX+bI2ZxM=
X-Received: by 2002:a17:902:ec89:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2ada3497c30mr1333915ad.19.1771927145136;
        Tue, 24 Feb 2026 01:59:05 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd47c737sm9949341b3a.0.2026.02.24.01.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 01:59:04 -0800 (PST)
Date: Tue, 24 Feb 2026 09:58:55 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: "Yanjun.Zhu" <yanjun.zhu@linux.dev>, Alex Williamson <alex@shazbot.org>,
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
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ12X3tGn3W7YP4I@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
 <aYZ15u120FEa8Qw2@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYZ15u120FEa8Qw2@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linux.dev,shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-71603-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: F15A11850D0
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 11:14:46PM +0000, David Matlack wrote:
> On 2026-02-06 02:37 PM, Yanjun.Zhu wrote:
> > On 1/29/26 1:24 PM, David Matlack wrote:
> 
> > > +int __init vfio_pci_liveupdate_init(void)
> > > +{
> > > +	if (!liveupdate_enabled())
> > > +		return 0;
> > 813 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> > 814 {
> > 815         struct liveupdate_file_handler *fh_iter;
> > 816         int err;
> > 817
> > 818         if (!liveupdate_enabled())
> > 
> > 819                 return -EOPNOTSUPP;
> > 
> > In the function liveupdate_register_file_handler, liveupdate_enabled is also checked.
> > as such, it is not necessary to check here?
> 
> Yeah that is a bit odd. I see that memfd_luo_init() just checks for
> -EOPNOTSUPP. We can do the same thing here.

If we move to checking the return value for -EOPNOTSUPP, we should
ensure the pattern is consistent for the upcoming PCI registration in
Patch 7 as well. With this addressed:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

