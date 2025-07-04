Return-Path: <kvm+bounces-51610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5377AF997E
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 19:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3030B5636CE
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3FE2D836C;
	Fri,  4 Jul 2025 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NrmoZvWA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26CB285CB2
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751649087; cv=none; b=GhmKdxGokufr5M3a9OWlIbKzQ4FCeUdpp/dhcfMrTSW4BgCW6rwdiYeGG9rwJWw7SGWYDMiLBjxEhdon3tGbRNSrLH8n/lGKzmxS5bWn5BF7yW2CXCMQZYge+IR0KhcQhdWSQPeBPakQMIdnhuFAHbpEbJCPJtCjM4euXEZnhGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751649087; c=relaxed/simple;
	bh=vahKKOsLIDOZ64bsLWsKQ3P4MU1oQ5S1vZDGJVQDQVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AuTO/HkAZ0leg/Yv/vd0mfrYKZhVrqsJudZwiqrMfgcs5qiNA3ScLMh0qW8FYdolpc24pw2YkOcdb+OzUxWCGdXDMr5jQ/RXFDV0mcorrjYwLxc8unMmC7sxXEZ6TS+3DqJk2UXppg8sbT9e75DfJB1F5LzyLBl38UJJcMlBR8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=NrmoZvWA; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fd0a3cd326so14650266d6.1
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 10:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1751649085; x=1752253885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dy7722iywegXhOE4714PEcfy4nzS/kIHDwpfpiOiUEQ=;
        b=NrmoZvWA500mPNzxqheXYGWO9E2fUtpGYVMc3pd/majVdiSqWgO9MsZW3F9zNj8Jcb
         2Xs6gxlJg38lVAM7SJIUgaMREdmFjnnfIYNGp3/C+kKoW1FvrBvDUQ7RFQWj/J+fFwix
         Lay/gDzTCZ1Kw9bIeAF60/1WnrBfz67RtEj+nsbhkPeUSLxdltGYiK9yyMNdERBsmyHd
         a2wzrqKmm6oLQRYLy3fumtKiF8TGPsFUngFokEUYsBtSVqfteUYXPKwP8k9IrmjIGT6v
         E1JO4+BfqdSBCU0hL4dL/Fp/qpVqDSVcj9GTGEBrlae0pFTwDt4hjLeF5iKnIlv/0gUh
         RhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751649085; x=1752253885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dy7722iywegXhOE4714PEcfy4nzS/kIHDwpfpiOiUEQ=;
        b=Gi4NLOXAO+oxBGXeizw/jTyYCf3VFDVyyFlw6BZJS/ToQSaqG9qJE+NeAi4EE3pGEJ
         NvMfseIT3kqtAPkR0tvBkSrJEI5cfGwVcMv5dPHdhvEVNykZTBjxXRu+QTVzMhLNx2tv
         O18jYSzGjjsOBp0HXIAz24Hpsgh+4O4dsciCBEjleu4Iph5SPjdXjQcex05Y8cu1NBhV
         kFhpUb8E3Sg3RWrl5DXfoVTDmFWEiMkB8qudgHLstmjFBTA+e7x3ornstVCiDlmhhOX5
         YCIHf7C6SFT0fhNfYdN+B7kQ/wNUgPF2Rrd6ZESUVC6Azy1pyT+YBniw0ospxM45zxsd
         hAxg==
X-Forwarded-Encrypted: i=1; AJvYcCXNi1mzyny27N1MpNTQdUXK4H2HALrilVdtMOgLgmd6THHqEsTJ4kIo0Ca/1G1hK8U1yOU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf5C58Wf91ox96xXVWhDC7JcFRlKDb5yMLOqNRxEvi3lMaGW3i
	jPxshzNYMyUcGisUAxF7Cguj4c+SPZ1EKrhiAOMrMYFDy2+Hxa/Ui5kWV1d7bua5gFY=
X-Gm-Gg: ASbGncse3qT69WVrrAXK67V5H18wMwwHHkVfVknU4jvOcs9xBj0Xg8faneLqDHyDyig
	r+hlq7jU0m3ACX/91leY92jJOKyqDNwysjFQl1koAeQEs1ZMJ2ZbcDUnqOwfGWM7k1JFVcKFGDp
	LFzlGx+piXcoifXq/JSxFtqmuBChU2Riym18xNHTEFCEcOc6svdhkYcHoETg9Q4BmByBvmlWTB0
	3VCCbiyK1OF6wooZ3Y2s3ihvIgG8cjbUZSO8wx1A59J/1AFj69BwAfIwjLYyEMxmoMvWs7S4BgF
	U7Lxgqh3c58TUfyEbmN78Fib/N3h7cksSRWf
X-Google-Smtp-Source: AGHT+IHUyP8Jk6Ior57ZnKsObhf10XeF3HAK2GWVA5IP8bfBE/gUEt+nc/2G02wLrOp5ynhFeb6YBQ==
X-Received: by 2002:a05:6214:5346:b0:6ed:19d1:212f with SMTP id 6a1803df08f44-702c6cdfc66mr46822446d6.5.1751649084732;
        Fri, 04 Jul 2025 10:11:24 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d5ab9csm15480956d6.87.2025.07.04.10.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 10:11:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uXjwZ-00000005zCd-2nMQ;
	Fri, 04 Jul 2025 14:11:23 -0300
Date: Fri, 4 Jul 2025 14:11:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Hildenbrand <david@redhat.com>
Cc: lizhe.67@bytedance.com, alex.williamson@redhat.com,
	akpm@linux-foundation.org, peterx@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Message-ID: <20250704171123.GK904431@ziepe.ca>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
 <20250704062602.33500-6-lizhe.67@bytedance.com>
 <77d99da0-10eb-4a4d-8ad9-c6ec83cb4540@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77d99da0-10eb-4a4d-8ad9-c6ec83cb4540@redhat.com>

On Fri, Jul 04, 2025 at 10:47:00AM +0200, David Hildenbrand wrote:
> >   static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> >   				    unsigned long pfn, unsigned long npage,
> >   				    bool do_accounting)
> >   {
> >   	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > -	long i;
> > -	for (i = 0; i < npage; i++)
> > -		if (put_pfn(pfn++, dma->prot))
> > -			unlocked++;
> > +	if (dma->has_rsvd) {
> > +		long i;
> 
> No need to move "long i" here, but also doesn't really matter.

It should also be unsigned long as npage is unsigned

Jason

