Return-Path: <kvm+bounces-11592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E031D878961
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 21:23:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D9B51C209F6
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 20:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA22156760;
	Mon, 11 Mar 2024 20:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QL8DstTu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728844D9E7
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710188605; cv=none; b=QXUnIxiJQd+tG9GAfCq4OpiJ4fcMmq4FH/WJcKFGg/8448mo58gEHS+h3VCf4nW+Np/DUrNkPIJ//m7SCrgmb8F7ZovNepcAFDXtfHRY/fO9Jb8i+cPS8NV7aXrgKLo8SDz9ssVG+1B0h8/vL2qXtvqycRGSeAnUFPls6HgXuZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710188605; c=relaxed/simple;
	bh=hsPgk25OQvRjAzh0e1mK5VvQ1gHRpv3U/6nLPGY6c4I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crXwRkjodxvDki96DXMEnceSxjomoVtweJ0x3V1KxXJQGZWxZVjqtZ2gUg5v8H+z4kMrz6m5tPJUp8eS9X3dcJHPQSv18hGYmCYQDY/72iwQNmVfDQHV3IO41KPWac4weEA030m+Hu2MGsOoVetuZ+R6I/sURFUcjTwvJXfDIoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QL8DstTu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710188602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IF4Yf8UPVouonx+uypANx40YxcO8AimTiTMmv9PB8BI=;
	b=QL8DstTuVFtBgMn+NpETAF+bwdEUo2p5cJu4Z9BXHT007cECWYE2Q5WoxBx9sIiv7f8pwz
	2zwMfkpEkK+X35ajiuboTavs2f58mPV5/h56n1vAA3JEW5TBODy6FahrYnH7BuqzF4ZdR2
	rvR0p4LI5I2nUog0VM/lN3lxr+v+4hc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-uQ7fb5rfNKioZsyHeaPNLg-1; Mon, 11 Mar 2024 16:23:20 -0400
X-MC-Unique: uQ7fb5rfNKioZsyHeaPNLg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36630680c5dso36691465ab.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 13:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710188600; x=1710793400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IF4Yf8UPVouonx+uypANx40YxcO8AimTiTMmv9PB8BI=;
        b=W8WPgnJxrYBCQA2qpOSIFHRUdhWau2rVdZRlJ4JYOuFHIiyuvSq8Sj6J+3hVboJkQz
         7PzAvKztpFoYx+v2Lz+A8EK2IulraqYRxyc72uakqosQ6JvIUJFVAlvipBANvYwC174u
         RjX7Aee9vXzCJ7GvKIOhxhL2IPSQ0L5rtBPBDJk+C8T1JIL9pk4LU4k5jIjCZaCCaeW4
         pVUVQPzb2wmrDnAqBTLmQm2f9tgjoGPjuKJ2Ca1zB2kfg0l7F2+SUuIyY0xRG83qS/X0
         jFJQGniZGeaFkJ6v158WgNPaAhh41mUW3st7h0TBljNCbXfo0gnZSRIJilbH5gMuYhCC
         5z+A==
X-Forwarded-Encrypted: i=1; AJvYcCUA78I6LbaLuDFf05DlihPzemikH0izayJQhONkiEyzVPFC/l+Sgm1JUenE9RzuDmMmdPcV2RnwuO/TmhCGVT/CNpFK
X-Gm-Message-State: AOJu0Yy/7KQjkMeGTrpImmq/dacxyprNeujXIzlRni+CcNHTENnjmUiQ
	FkPFF9L/SXjVFMoKntJFFkR6NgVqzMUkKNcm8J0lgM+J+O+7thZvWRMOvXeN1e5rXBPyVw2dn/O
	31Thkix7Qz73l7+I/qgDHblQ2EqplZYf18RISusljz1aOuXKIag==
X-Received: by 2002:a05:6e02:2148:b0:365:fe19:4a05 with SMTP id d8-20020a056e02214800b00365fe194a05mr9345921ilv.22.1710188599852;
        Mon, 11 Mar 2024 13:23:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaQKNbrfo3rrAF+2VaMAWTzZiLHFJ+nJOl8ITvTDpcIh9aGIq/C9l1216ckFzKVt/yrNS7LQ==
X-Received: by 2002:a05:6e02:2148:b0:365:fe19:4a05 with SMTP id d8-20020a056e02214800b00365fe194a05mr9345907ilv.22.1710188599583;
        Mon, 11 Mar 2024 13:23:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id fx22-20020a0566381e1600b00474895385c0sm1926361jab.109.2024.03.11.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 13:23:19 -0700 (PDT)
Date: Mon, 11 Mar 2024 14:23:18 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <shannon.nelson@amd.com>
Subject: Re: [PATCH vfio 0/2] vfio/pds: Reset related fixes/improvements
Message-ID: <20240311142318.7c6bb476.alex.williamson@redhat.com>
In-Reply-To: <20240308182149.22036-1-brett.creeley@amd.com>
References: <20240308182149.22036-1-brett.creeley@amd.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 8 Mar 2024 10:21:47 -0800
Brett Creeley <brett.creeley@amd.com> wrote:

> This mini-series adds a fix for a patch that was recently accepted that
> I missed during initial testing. The link can be found here:
> https://lore.kernel.org/kvm/20240228003205.47311-2-brett.creeley@amd.com/
> 
> Also, remove the unnecessary deferred reset logic.
> 
> Brett Creeley (2):
>   vfio/pds: Make sure migration file isn't accessed after reset
>   vfio/pds: Refactor/simplify reset logic
> 
>  drivers/vfio/pci/pds/dirty.c    |  6 ++---
>  drivers/vfio/pci/pds/lm.c       | 13 ++++++++++
>  drivers/vfio/pci/pds/lm.h       |  1 +
>  drivers/vfio/pci/pds/pci_drv.c  | 27 ++++----------------
>  drivers/vfio/pci/pds/vfio_dev.c | 45 +++++++--------------------------
>  drivers/vfio/pci/pds/vfio_dev.h |  8 ++----
>  6 files changed, 33 insertions(+), 67 deletions(-)
> 

Applied to vfio next branch for v6.9.  Thanks,

Alex


