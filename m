Return-Path: <kvm+bounces-43415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A2CA8B673
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DE313BEDB1
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A4D2459F2;
	Wed, 16 Apr 2025 10:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="WZm3GADV"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023FE2356C3;
	Wed, 16 Apr 2025 10:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744798194; cv=none; b=mBZBKxZ90Htgly/BWlOJyNbkxd22ZAzNX3WsD7nZF5ZHHKz0aN6Qc6DXoFAp8WtjkrRLNwLlje1Lk2KYuNSQ9Hd7qdAVp/fCe9UaRAhUjqAZkHkYmSQ4sm/uN2W00JRQoftR3iF4UR33lqlenEbZ9Mx/xxDxRp32qmXXxp+qqZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744798194; c=relaxed/simple;
	bh=K5EIWptPNf+bD6TCzDb13Bmy9OoJJigove2+9RXxBVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pc9MTVycW1JqBQKQqdcw//aLpNM6wY6Gl+O5ReRCSFcJoFh0PeFEsSIRXzsA8BsHGw5Wux2NYdnmriK6KkOjlNkit169QJ8TT2AmLWpzxts/OV0+Mfs+ama19es8WY40XZqqDRM0KXR8Oo02si5wEaXx+u+1001pSGweI48usDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=WZm3GADV; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1744798183;
	bh=K5EIWptPNf+bD6TCzDb13Bmy9OoJJigove2+9RXxBVM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To;
	b=WZm3GADVESCnAroIeYZi/nahlkQFax41qiE4mcZ6xMLfvyr4jmGCEpWkn78ok6u/j
	 rhZC/DKRCmqUfZMC4Pxuuyeg/WJnpzzkJHPwyLtkPNzhTRit7JXcH/hW+vGCd0tHbI
	 sC2fHwcLZa0B1SeoTmN41ZOwlqUiJhW0G7fmvV8U=
X-QQ-mid: izesmtp89t1744798177tddffd40c
X-QQ-Originating-IP: IAw1cIU82zcANWNqP9cwnXdyjXOMwHhFQGwmSZFWUH4=
Received: from mail-yb1-f178.google.com ( [209.85.219.178])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 16 Apr 2025 18:09:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 11619989835513742780
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e455bf1f4d3so5004404276.2;
        Wed, 16 Apr 2025 03:09:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUDssVnHXTmTKE76dF+ycPeT2C1n0lWYyuKMsJ6Zopu6JMmx3lEZu4qgY/Gvr1BxP1MtIO2iEF1/b7eUg==@vger.kernel.org, AJvYcCUVYiDE+f7EJohP0Cr50H2psJzqaa9zecSa1UCOmqsOOcBJn5rl4jrtvve67YVTbUyxHftXQ4BZI4/WSNGG0RRw@vger.kernel.org, AJvYcCUzTGDRBIeJgEfn4EWlehaJ9uaorx9uEj+qe+hTsxMrhP/O7nEctjFR3JoLHMk/1qsf4rA=@vger.kernel.org, AJvYcCVX3wYdV/83TDnW3npDxdAlvKd9cNTo88QrUWLqnk7fvkBWVK2pf4VAna+2zy78+BMzANTdxjt6KX23G3IR@vger.kernel.org, AJvYcCW6vuKnAIf4hcUPxARsn5Wfdhoj41HNYr65MOKTgKEuGeq5WM3WjuxiLMczTrqk6Woh21Jdp0fH4XEMhWoR@vger.kernel.org
X-Gm-Message-State: AOJu0YzcvIREjmhYSjoUfAdhYHLxezMnlg1QXV8BTY7NUBtV3Wl9Je+c
	+r+bFR8azXex1PkElhhJYQH8j70n2wITtFk6b1bloX7XTFHs6BdUpOU+C0Rr1AfN92Vzhjv1wT7
	asVrgHTDHyvL9cx0QMXbjscx0tSg=
X-Google-Smtp-Source: AGHT+IFxOQerwyXR4s01cKj1FQCmW5mZBGS8EUkxg2eBy2yn8PQm4fMpJOhxMxu+WrXOTx3w5ulHOeUcX04b8xnFFTA=
X-Received: by 2002:a05:6902:2b8a:b0:e6d:eb74:272 with SMTP id
 3f1490d57ef6-e7275967af8mr1257382276.22.1744798174393; Wed, 16 Apr 2025
 03:09:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <E9B8B40E39453E89+20250411105306.89756-1-chenlinxuan@uniontech.com>
 <20250416044827.GA24153@lst.de>
In-Reply-To: <20250416044827.GA24153@lst.de>
From: Chen Linxuan <chenlinxuan@uniontech.com>
Date: Wed, 16 Apr 2025 18:09:22 +0800
X-Gmail-Original-Message-ID: <45D187D71349584D+CAC1kPDPYiUKqRmqW=hzOyGudvUXcwxo0kgDU_j40+t7rYHsU-g@mail.gmail.com>
X-Gm-Features: ATxdqUHphIIrq227AoMvNzUOdxFn7upg3kfvytoiynDmEPipLLJsDaFiQeVe_To
Message-ID: <CAC1kPDPYiUKqRmqW=hzOyGudvUXcwxo0kgDU_j40+t7rYHsU-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] kernel-hacking: introduce CONFIG_NO_AUTO_INLINE
To: Christoph Hellwig <hch@lst.de>
Cc: Chen Linxuan <chenlinxuan@uniontech.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Chengchang Tang <tangchengchang@huawei.com>, 
	Junxian Huang <huangjunxian6@hisilicon.com>, Leon Romanovsky <leon@kernel.org>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-QQ-SENDSIZE: 520
Feedback-ID: izesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: MMkVjSP788VvLbybX6NpprCLcQm8mjDJIS8k878BicYIRvKMIDe/VTDc
	iEpiPOOa9xcLEBj1SJPG4bYpWVQZTHk7cjwvvv6SVEjicZmBxG/GBdPXd4u3SoTRip0JWp/
	KU3tZwSmB4IwQDD8AZYBnOnzDQO8vljy62RTQqhgK2Btl/Nh7BambwRS7VrjWgnGrAIXFrw
	cM9pRcUXaChbxDJO6XBkHeZ4xM84nGdVfLN6GB/DhryioTZZHqg67s0n/TvZsAZaljDcUbL
	ZmNj6MUqS33rBTuIATwMGt0+lJQEko4QRqwWbcf5YzMj5o+wR1vDK2vY3WauKzsEI58GhR/
	b2mIYcBhyVZouv0rcCJuslQ5IpPZLNCYwPZdsfkfCRPjyfCTNdUbseu6WFnJXXI2dxcn+UC
	hsQZTPPKX0hIynPouR+pm9or537nHmII9ROVtnAxOYSG4tNVn4UtFJVdXxVcFhHuHJ/JITM
	SmPA4yrg4oroBQK9ZmX8FlV+Jo85y2BVJbTVnqRQkzRK+OOb7/oYcF3yy1AR2NYFVPaP2Ta
	FRcrzcnXWockyTCPUjT1dqDZPK/UIFGwq04BH8G2lT3G5066Ma0577TCfn2qKX/2hGJPAIZ
	HmaXejIa1N1hQ+LVlbCT6DssUCiMtl3SHe5v4h7zB44OiS/+Wk7j/EPF9QULWBGcAB87/Sq
	QsyrREB1zNhZH65anAy+3H3Q6x1NGUVl3q9kHN8/cdv/BbQ51CfpNc5c75Pyx+2LYthN5hg
	mlxog3tIeBXrERIwi1t2AaZTtmFVUQDGDRkzbu8zUmJWNU5gSO/THHhjzicEL+i0bYMk2uO
	EHQ5K4lFW5iSLVr1M9ilwwYu7tSDLX7myE5gL56l4HY7BM5Y9sOfJDuJjCTofHhdm6kKDAl
	xdwUuC3XD/PG1/iOn5ok+BqdN/BMS3aYCQ4PS2rUSVHD93ft22OYVeQkcELHT6UqBW4ZNn7
	VIIPt9LNuhNxBlHqGWTcrHDWHsyGtWBZXCX3vfsVG6Y7a1MIiEqm0LrXUfEtByfeLLJYak0
	RrPnoTzPYnablhrE+87u7mquNIvo3f0lT8pW8yoLNPgVhDkYxnHYtHo67zob0tTnEOijS4n
	LgWvsHPuaj1
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Sorry for the mistake, v2 has been send:

https://lore.kernel.org/all/20250416-noautoinline-v2-0-e69a2717530f@uniontech.com/

