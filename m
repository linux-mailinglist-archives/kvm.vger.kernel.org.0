Return-Path: <kvm+bounces-32764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29779DBE91
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 03:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 898252824D4
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2024 02:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A16B14F12D;
	Fri, 29 Nov 2024 02:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgvBI4xJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F043922EE4;
	Fri, 29 Nov 2024 02:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732846410; cv=none; b=s4igcodpUerfko0sJut1YCOmxZaIy3r3PagHiV9T57dXgMDUXBYpw396p/xmgZDG7FZo/3M62p0ZgsY7g259FUe36W1jn7P0GDil7XlnQ2tiVnDr1WmdiUvUglxYTTpgZ4McP+3OU/usL1yElH/egY9UtjpdGBMOJYl46uUvvI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732846410; c=relaxed/simple;
	bh=tlX6/XQDENq68SPtN7Fe1eSVuzsBAK7YJwk0y5vXzRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SG2uIST8v8tQWZ+a5iKu7fiY9Yo8ruNRvLUGZSVznTPpk65GOJ5mIetcj/QdfU+E2N1mftFzWBGnAhqAWlyP50TOxYkw+sYV5eX9TKoesK8jfOrBYQv9PAudSdJQM9N+FQduegOB0+HDFgcTOwHyfI5z30JbW+NedmXult2CBho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PgvBI4xJ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720c286bcd6so1177757b3a.3;
        Thu, 28 Nov 2024 18:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732846408; x=1733451208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5D5xIlc/ZBMWEK/AcW6+gAFQKxMNC/t84nQ8vJYuSU=;
        b=PgvBI4xJHTJfyZatuXm89e3+yMaTbry/fd75Ii8m6AaSP8iRwmEtwPc/PlrJD0P0Dn
         0QjKXAAXx/LSJ37bwdrkBN2TNqig0SIy35sTvDi/nke0H+QE3t6gU4kA3b+H/o0KLDUs
         19e9ftdEWGExloRYzZTDq0q/3AZrTEOhQiV/mzi38IFO/7Rr1EcGomfzBhP82Ydgdaie
         FCFwURZ96pQjHxZF3KbjKQz5WRue832tYTfkjeQStKq2J7GD260mMqwWKj3TDBBdjSC3
         VKsj2GUjnoOZF5Viu892RgyvvEIJhOF3LCtwg7vJhaRsZIR7XC+HvQ3rIN/yX2kaVof5
         A9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732846408; x=1733451208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5D5xIlc/ZBMWEK/AcW6+gAFQKxMNC/t84nQ8vJYuSU=;
        b=AUkfPrFKfU39FBTg42bGa1NOI61FGy3UTSQlAklgE3mv+fq+Cp6EbuzOX2hMOoF4LJ
         +arUJXDIWOh2kozPKb07cxunCw5dEPZG5W+iG1H995ArJ2ti9BVUkIE8iotwyQZfa4xe
         IxOdVpGO83KiM8piidRNBhVj0CO3NW8jpA/eotqeMgs5UvAoGCxYr1FSOkC/TS26SYul
         JMga1OC0MBbzoBNVnvaxMAdZIM6daFMsGlVzZF9+Ol/TjUpYMxusoLZaFLR355ISdrnW
         04f6dXhevzkkZ0PyDMwXPXqBLpCNcKMs/7O3isNHMrJ4AdErNYeAqOzqxrnCKGti+5rY
         M7mQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0LJ3/aLyFIbiCN/7ztrOdwQ1XrsKka1+E41jouZiDoYqVJaxhMYWmECgTy5tgyLBjAmPcsPwB@vger.kernel.org, AJvYcCVSmg4u8ekQkuOhTn4GjP4r84bwjZ/0i5klI3DL0ZqGeocXvbvPl2QxhlzTDpY8y2QXnxCqmHJwdXCXFeni@vger.kernel.org, AJvYcCVVMFhQF/4hWZJZOv/pa9wocBasaYwq3cYHvknONpwwS/funvFrtye5vI6Gwuzx8wqsjZQ=@vger.kernel.org, AJvYcCXufN+wgEqsRGq3D80p47Npc/S+RZTl9+oe24zynQ8BOVRsmGfBOQEVfxLyel4ajr8v1OPk5fV41RVau1Qr@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6VP+MSesCzxEcaiU6/9+B8q1idCYC2pE6RnADsv25t9L2xmej
	93lbAniZ+TzPYdUMd4oT+mgQKITMgMr6RTcwKjCj4fv8nmUo3QZf
X-Gm-Gg: ASbGncsHpXMd/s0s1q2nSqEJS9KqhF0VjKftxsZcXb5bPoAxCkJYfn/hILJHBmDzsGj
	5cgxNeg2HONh6T2F/bo5RhiPWNeBY7lqk6ejXxVm7h2Uw3x/y6NtPbtxe0qI9JQrFQmYFgtY+sY
	5lDM9wbW1muVu5Dr0P80g4vXvh0WAMr+1cnUsa2pmfRJaes35NbQ9vrhrP+dod0woY8W5IYUy5R
	0IOGsYdSt17nNhXEQbCUPU8ozuACt3yTMd1wIPNuGSAmw3mPA==
X-Google-Smtp-Source: AGHT+IGqFTiYoTjvaLKfmNfHn95RvWItWMTQ6GkGXRx6Dzs/7816TwnR2BQ/RSHj0KT2VsnPH5AQoQ==
X-Received: by 2002:a05:6a00:1d89:b0:725:3bd4:9b96 with SMTP id d2e1a72fcca58-7253bd49d87mr9451378b3a.2.1732846408083;
        Thu, 28 Nov 2024 18:13:28 -0800 (PST)
Received: from localhost ([216.228.125.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72541762411sm2380319b3a.20.2024.11.28.18.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 18:13:27 -0800 (PST)
Date: Thu, 28 Nov 2024 18:13:25 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Eric Dumazet <edumazet@google.com>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	Long Li <longli@microsoft.com>, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Leon Romanovsky <leon@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
Message-ID: <Z0kjRcX1hXYQhw2Q@yury-ThinkPad>
References: <20241128194300.87605-1-mlevitsk@redhat.com>
 <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>

On Thu, Nov 28, 2024 at 09:49:35PM +0000, Michael Kelley wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com> Sent: Thursday, November 28, 2024 11:43 AM
> > 
> > Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> > doesn't free this temporary array in the success path.
> > 
> > This was caught by kmemleak.
> > 
> > Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > index e97af7ac2bb2..aba188f9f10f 100644
> > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
> >  	gc->max_num_msix = nvec;
> >  	gc->num_msix_usable = nvec;
> >  	cpus_read_unlock();
> > +	kfree(irqs);
> >  	return 0;
> > 
> >  free_irq:
> 
> FWIW, there's a related error path leak. If the kcalloc() to populate
> gc->irq_contexts fails, the irqs array is not freed. Probably could
> extend this patch to fix that leak as well.
> 
> Michael

That's why we've got a __free() macro in include/linux/cleanup.h

