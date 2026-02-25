Return-Path: <kvm+bounces-71811-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8By4F/6snmntWgQAu9opvQ
	(envelope-from <kvm+bounces-71811-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:04:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 053DA193E60
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 09:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 793C7305E98E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 08:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E53310635;
	Wed, 25 Feb 2026 08:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QEN4BMRI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931A73101B4
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 08:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772006611; cv=none; b=eS2YxSHBkbgE/P3m6AcRmFM32cqXj7jsmy8f9WT87F8Gr97FXVFa9HIWzjTzNoJavhn2+WiJ8bWY1QW/Fp8fb1ZL4R5/2pLw+A14G24Be4mVveSPI8A1aZLmqLjscCkzJXcV/zvD8nutYBmw5Yyo6eg0h/ULYhJ3pU/vouzHnJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772006611; c=relaxed/simple;
	bh=bq6zwXtFCcnqrhZIHxjGnvBS+KlyTU9xlpYaT604hrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cI2PfnG6cqG/mflVMPuNCKQeWQuldH2BOvfgVTmrnUvvIW9zKJsJ3OrQEYl7zFxZjuOJicc7su9hMm82KRQlxqW3tUhsVjcNR/0MjbdfsOU4bmRF0gRc7i+cWW0nvY13vLeeH9cWVKBOev4YxmlewvGxrt/uFBUt04Dg41e/eZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QEN4BMRI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ada9e4ea32so56005ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 00:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772006610; x=1772611410; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sCJxVjDFn9Nx1ZVu0w3V3L8nPN74ZP9DglkzEBV+/BI=;
        b=QEN4BMRI3NcE4s4dHITuXTcZZePBS1pa5N7KS5NPIL0HW2SIO+xI7LqmE+gzxENW1t
         db5f3juWENY4Cn13Po/FHPGa2PSZML3rqQLoVgVs0ZW5e+H4Ke+OnwrhtSAtlGK2FVqo
         i+68/6axzRRuCqzk/1Ot2WM0e7XUc0VpfbGTUl/ATa6rLoZMx/nwxjQUcxtY3TYaiNIM
         aG8kHl3ipr/WLb0kjr6y4FjsD9tOj1Nr+nngKm3+etCnD/jXOL9VJXjVPi/OOQB038JG
         0rYUrOs8KTU0z/pHYb4Bkd3RhtzvNoqjEbwBimPDUcF87cY2BemjgWPUfvPP7XkqWXrK
         hfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772006610; x=1772611410;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCJxVjDFn9Nx1ZVu0w3V3L8nPN74ZP9DglkzEBV+/BI=;
        b=iElTMgMDFzht8uDvgSqIuh87OlyWNRuultOyKKCsjJ3RM2VPZ1T3YK35EyAIUub3VB
         aGO96n+z4aVNGStmH3UOGQN/MlEIsDOkuRg+VpuSl/p9kdhdBlf7T7U+/l69KIZPy3m7
         PHc5r87ENxG/VwVgJlyK+oj4ICyo06QG9n897SQF/9HxHHRZ6NtqwhvNuRlvmpEnqd2/
         iVyrmY+302MMjxjwdhunjSfNSYSb5HoPyYpZOp1PDSP6ti1U2pIp4zk3BIUXH1akzd1c
         oOU8CKW24XYLdDOY6ZS+gq+MB92LbT5HvynD9NJzP3cSaVQYTSNdPFpQOV5N4XzVL84q
         +Cfw==
X-Forwarded-Encrypted: i=1; AJvYcCVXi4CQj+yIC+XV8lBu8AooWRqlIiKO/gT5n1bzbGoryMIiShqHhC0QKct8LmMftUf4ifI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjkNI8/b7zLYFaWW1s83jT2/S0F0UzMV1MIp/SLZvCWDcY910J
	CSFsR+tOY3RsFn/9BcwOyIhATiv8320OPN0vVKq/91Ltb+HiFrycdnoqUwVkvyferw==
X-Gm-Gg: ATEYQzx6Jb/je0cr3qwo8hPVLnchoMdvErFapIie6TZ3wRRVyUHfLvL2GFZ1c3nOsDr
	F6aGSPMmLFbMNm97OpMPqVQRfAEC6yGPC1/ZWYHULDQa9qJIhpSqFIv08uVrRtpAh1/PBUJDhrQ
	QkKBLChNijXwAIx3ffFycP62+/yoJlXRpvSeMi/JJO/QvqQ9P/bGGkWiASEdkeTao0T3+1LUCy8
	+0t9GmqFwzbg3XzqyTvT2XtOCV7RIVDP+U8kml4z633rS2W5ZAXmfkyoeUUn2qw62AuVIx2wd5H
	XZ4+vY8wKdR0LZEcH7ClwZDHVuKZyvtjH7YD+hLmssQmZkiJb/AhvrVF6xrcYAxsWH3lg02YII7
	YfUAQtk5dcKkw5phFQyWkZOCPDb8FvtHZHeLcK/q5zwsC3fB15zCj212RVplCActatZodRixuKT
	5zqBwZSDseDWaB1gOBD7HtY4HvTg5gnRE2h5Fbrbx2TYLi1NffZ500AetiXXZa
X-Received: by 2002:a17:902:ecc2:b0:2a7:7f07:340e with SMTP id d9443c01a7336-2adca6c9d85mr1313215ad.4.1772006609152;
        Wed, 25 Feb 2026 00:03:29 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3591342f19fsm421683a91.10.2026.02.25.00.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:03:28 -0800 (PST)
Date: Wed, 25 Feb 2026 08:03:18 +0000
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <aZ6sxhNeHqy-hqhK@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-9-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-9-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	TAGGED_FROM(0.00)[bounces-71811-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 053DA193E60
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:55PM +0000, David Matlack wrote:
> Enforce that files for incoming (preserved by previous kernel) VFIO
> devices are retrieved via LIVEUPDATE_SESSION_RETRIEVE_FD rather than by
> opening the corresponding VFIO character device or via
> VFIO_GROUP_GET_DEVICE_FD.
> 
> Both of these methods would result in VFIO initializing the device
> without access to the preserved state of the device passed by the
> previous kernel.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/device_cdev.c |  4 ++++
>  drivers/vfio/group.c       |  9 +++++++++
>  include/linux/vfio.h       | 18 ++++++++++++++++++
>  3 files changed, 31 insertions(+)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

