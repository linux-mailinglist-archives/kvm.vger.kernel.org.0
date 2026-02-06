Return-Path: <kvm+bounces-70522-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GOgUBBJ2hmn/NQQAu9opvQ
	(envelope-from <kvm+bounces-70522-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:15:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B374210415D
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CE91A3018F23
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096B531354F;
	Fri,  6 Feb 2026 23:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g3tRWC1l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BE5313291
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770419693; cv=none; b=JB5jSbqiPhqn6qPuw0It6cxb0bw4ZVX1PT/6YgJ8KYozTloTLFsaOjR9kVbNnLZIo3VUg+lqUKpYVaeh2p3/9veqmSh8l6S2UqLb3LN6mCs/dT4VVCrFoDAKeDXnADpAFY1gSfk7CU75E/STYKDskfr/GpIm5UFmRQoJ8NEiKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770419693; c=relaxed/simple;
	bh=//lXxvGzvwvRX8TAWjBtg2RwKbUnQc3RJsVA6A3Oyik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdehFWRwf4HpIebLyKJ4HnxkLX0iI3KQ+1dwMlvs6QfGGVc2psPjVFxATIjQ1P3rH9OgpWoe5Wc7ZrGh8puIHXEBOSQVZkOZVyfDBTlGm/TvsZeGWzSYJCPeLTBfXmzwTnOZ3ZXa6wYo3fnKvaYA3JC6r4ixu17N3dF3rnmsUMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g3tRWC1l; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c0ec27cad8cso933364a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 15:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770419692; x=1771024492; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xORO1Htmm6YxNYM1C9oAOOlxqgAaEPMiLYXG8QXy21k=;
        b=g3tRWC1lBp4G6v57OMNJH/IWhVnKhZkgx/YZiytE6h7F/GblmQyEeomg0JeF945imr
         3DB0TWRGaESQe070W0BWOsUsHHgvWnyNF6EEwR5gbcMaxsCWtsRq1Fe05Wodqe+0qye2
         LBmPBBEaSzUa/6BVN4mGd5ytwg0pv9jYELANMZypZY/N1Rk4NZK0jaWANUovaQTw19Op
         /8LEugHReBQZGwa4owCg//1Vcv3ViHo6xmE5eGqCTRiTfYejf8j7ME+YpxzTkLA9rqSr
         Q2sFeCKKNGRwrLl2prU/fOIUJF/CpaYN2BHv2qZMRrBdGsbsQA9CbV1GnPE3RBNl1TaN
         FKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770419692; x=1771024492;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xORO1Htmm6YxNYM1C9oAOOlxqgAaEPMiLYXG8QXy21k=;
        b=upJQ0ZWtvsHPx0cxdaWdeF657IaNINPQBV1hxVhk8PnvIa7SQ+WgLehn8V3VUSYN/X
         +SRrCrNZQUwQUoo+g0NGm4JJOAoPduVsVJT9af2OsxhX25qKiSirAnOq/0NJytvtwFiU
         HjNKKAkg/++HzQXzioOkX3XQct+kcNkRM3/ErOFzyKNpf8lmoh7OESlaeAJOKzSeUX/9
         oYgbmTcaykUB0ZNd6g9DPFWQa6guRkmMD958s9DUgNfcNDe0C93r8+Sl1uWoDxi8cVgZ
         5tSR/2yHizCzearGoOKOGFWsuLHMptlGMYgdYZzTnugLkKXZPRlCHv0Khg+7MreJR8Oj
         j2PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa6tTjlBj020uwF1WaqkAibSYQ/mDmtHcm8uFc0pVxzI+HwyvZJNQK9QO92VzbGA/Ee9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzV2Wx9PO7mhJ/iviKxyEAV8UR0YQ/T2RcY+wV93nXb4iq/4gNv
	HwEL8Nlyzv7o1+MY/OKr8k6+LpIdORJ6VlASJ3kzmazSk1jGeUIhydI0UpD0skujlw==
X-Gm-Gg: AZuq6aLwUFArHgJHLCkwCWMLpd430nZzSO1LnoELWMDXxlDUkJe4aIxCRx/B+j8ovoi
	nGKCOonrD2g/eIpQcvPyHP21sVl4qHgRUECQS8QNRxFgdf/WSRvkt0JhPYMTCydAgDd5EE79uRB
	uuz3m3VVCr9YRa0np8802IXrwL5xNRsGskXCfr0PKcM0dyFBXepPiwOwOqj0XUYIVM4Sb+PRKkb
	YGFIwjw4tmEH8HJSdObqN8bpqI32do8QY9oE0bFT0sYhZ+71wlKKwSVn6XGacW3j/cpAL+vGd0e
	AVLiA2soYAhUtsDDvnNvIYmBir1/JnWqiQE8vejO+jwCvfMA9kt7v2qKMN7yg+XP5y+cu2VG0Nt
	gW7sZSLkIRuJ1cXzAwRxYnqB2e92/WxZ1E61eVPpKaB/HxbARygRaEN95zXF3IHcqajgCFxxL6b
	4lAS5YaJXezGC8MhWkFv8p67JWIkLD9AOjUt46sUm7BlARgyhzlg==
X-Received: by 2002:a17:903:3bcb:b0:2a0:c1ed:c8c2 with SMTP id d9443c01a7336-2a95191f76emr38694515ad.55.1770419692202;
        Fri, 06 Feb 2026 15:14:52 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521eb87fsm33865195ad.71.2026.02.06.15.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 15:14:51 -0800 (PST)
Date: Fri, 6 Feb 2026 23:14:46 +0000
From: David Matlack <dmatlack@google.com>
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
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
	Pranjal Shrivastava <praan@google.com>,
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
Message-ID: <aYZ15u120FEa8Qw2@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-70522-lists,kvm=lfdr.de];
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
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B374210415D
X-Rspamd-Action: no action

On 2026-02-06 02:37 PM, Yanjun.Zhu wrote:
> On 1/29/26 1:24 PM, David Matlack wrote:

> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> 813 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 814 {
> 815         struct liveupdate_file_handler *fh_iter;
> 816         int err;
> 817
> 818         if (!liveupdate_enabled())
> 
> 819                 return -EOPNOTSUPP;
> 
> In the function liveupdate_register_file_handler, liveupdate_enabled is also checked.
> as such, it is not necessary to check here?

Yeah that is a bit odd. I see that memfd_luo_init() just checks for
-EOPNOTSUPP. We can do the same thing here.

