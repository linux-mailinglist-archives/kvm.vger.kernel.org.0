Return-Path: <kvm+bounces-32968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 738E39E3063
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 01:27:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3BC6B2A662
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 00:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B28523A;
	Wed,  4 Dec 2024 00:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VEq+fYpp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703710F9
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 00:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733271925; cv=none; b=oVneW4JVlKH1iPLrWXA1pKAMBd6KKalTloptvN03BVNz7ZzA8Ev00yEGdGxHLSFgfmc7xkwxYQYF8vYz7FCEBD6ah3bVKzN+F0AoiOoa2+DF8B6gKo9qZzhCn8e3JKc0fHRHYfHog9RTC2FbxSlEWMDjzuV0AqjFBjhDhimRSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733271925; c=relaxed/simple;
	bh=Lo4binRsBPqUS9D7ps9nWAoRIkP/rPdP6eMaYI/rZXk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yhh2rzvZgt1JqCm2FYue8Pqz+jmETHqWTtbdCGlFhD55e88ov3wN43ng9kYqMIF5hKTQkgfFS4wgq+DckCsucVNR0elGDsxQyl08kMvxTz6vDNT6yDSvk9fQewlIL9GxakVLwW1mMkW5FDhvgwPH3SF0zMulx/MnqQO5rKq8tms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VEq+fYpp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733271922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4CwFWi8FnvUArl8TpMTnNDME1h0hBhCfwwVFx5ADtG4=;
	b=VEq+fYppt2nN+jYLX2lOVVcbfrSsxQFT74oZQVBBIswZ/pnVdNiQGMbief5rKIqr1qaucr
	6jalJQNzZdwej1GYzG6Ooy8yf/Yfh09k6a4Fr+AVw0ZGnOLm4KLa5vvIitM8tM0P3PCN5G
	GUKCX9LfhLDNtLOG1dlLcHdTUFysFk8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-bi1gxgd7PRmC79zLLnOOqg-1; Tue, 03 Dec 2024 19:25:20 -0500
X-MC-Unique: bi1gxgd7PRmC79zLLnOOqg-1
X-Mimecast-MFC-AGG-ID: bi1gxgd7PRmC79zLLnOOqg
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d88cde9cedso64499906d6.2
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 16:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733271920; x=1733876720;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4CwFWi8FnvUArl8TpMTnNDME1h0hBhCfwwVFx5ADtG4=;
        b=sZcwYMrzoKsjDv1F8EHD2ho1RW9u3LUiYz1G+QVo+8/SR/Wt5trsG8aYkwxUNkOYsd
         f1GRqLNaIfJ4A+aC0wilLAVwBW1fvwvl+HoWYqyolBH78n58a/RBnr0vqXLRqRBPY276
         HSM59chDexc6yJkU5O+3RbwCsxa+t/yQs4cKSF+05DjJCsLAQnq6dqclovt6wBNrctqg
         gt/hFStW7x2ZUcJPpsVwufSSaJKlGkzucxYXZo88P0GELgx5U4RZ5mJIKwGP+SF4X39e
         7NkgBGuoXWnuQ68wXPW44O/OACELwsrRZbUSiJ/j4+bPSkLPvmpKfYaxbZA5641k4dVY
         jAYg==
X-Gm-Message-State: AOJu0YzRWKoYFAl1xW6IbeCmqQlDxgE41UYd7iKKANospk9LWMBzkAfR
	wpH95D0csp2jFwS7qCbT5DVaFWE+3THbg+EuuvR+Ln6u1C3i1HSxXda59aD7HHqZje0v1vZBTLt
	GB+AmsLVDnU+uQOWYExZVSfyBLLOOt4cmPzOaODJgZoWsEUaGDg==
X-Gm-Gg: ASbGncsh76vRgfKQ7wJ+U1wsuGhQg/AxfR4zCfj0YfxaYuD7sU1w5I2r+DeEFQ2Jdrg
	KyjN3sw2nt3GIb3+ouZ2v8IfGtl5QmqyV0ZitMakoMkip7h6r1khvA9iR+MrCj1bxn7FzV6rL3a
	c39tRFpkEtgNMMQP/K3gYvB6gz3Dn/Iep0B8tfHjwjZqW2s+X160RIWxOqzL7TP6WIT46YS7KWz
	ydZ+DIReWAk6U41RSinahXfO/WnRygZmYDWxgAN5PQfpSqfqQ==
X-Received: by 2002:ad4:5c88:0:b0:6d8:9002:bdd4 with SMTP id 6a1803df08f44-6d8b73c3e99mr89495546d6.28.1733271920439;
        Tue, 03 Dec 2024 16:25:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoezrTh1LfZQDXek3/OWCukqKJgO2GNowhr0mwrxAz8KSLIusKbWlk8PbDDhkEiuliYGIwDw==
X-Received: by 2002:ad4:5c88:0:b0:6d8:9002:bdd4 with SMTP id 6a1803df08f44-6d8b73c3e99mr89495216d6.28.1733271920141;
        Tue, 03 Dec 2024 16:25:20 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d89ef77c12sm37422936d6.81.2024.12.03.16.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 16:25:19 -0800 (PST)
Message-ID: <5bc32310f882c45d8713e324dd30cc1ca41ed20a.camel@redhat.com>
Subject: Re: [PATCH] net: mana: Fix memory leak in mana_gd_setup_irqs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Simon Horman <horms@kernel.org>, Michael Kelley <mhklinux@outlook.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shradha Gupta
 <shradhagupta@linux.microsoft.com>, Wei Liu <wei.liu@kernel.org>, Haiyang
 Zhang <haiyangz@microsoft.com>, Konstantin Taranov
 <kotaranov@microsoft.com>, Yury Norov <yury.norov@gmail.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Eric Dumazet <edumazet@google.com>,
 "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, Long Li
 <longli@microsoft.com>, Jakub Kicinski <kuba@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Leon Romanovsky <leon@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Souradeep
 Chakrabarti <schakrabarti@linux.microsoft.com>, Dexuan Cui
 <decui@microsoft.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Date: Tue, 03 Dec 2024 19:25:17 -0500
In-Reply-To: <20241203162107.GF9361@kernel.org>
References: <20241128194300.87605-1-mlevitsk@redhat.com>
	 <SN6PR02MB4157DBBACA455AC00A24EA08D4292@SN6PR02MB4157.namprd02.prod.outlook.com>
	 <20241203162107.GF9361@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2024-12-03 at 16:21 +0000, Simon Horman wrote:
> On Thu, Nov 28, 2024 at 09:49:35PM +0000, Michael Kelley wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com> Sent: Thursday, November 28, 2024 11:43 AM
> > > Commit 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > > added memory allocation in mana_gd_setup_irqs of 'irqs' but the code
> > > doesn't free this temporary array in the success path.
> > > 
> > > This was caught by kmemleak.
> > > 
> > > Fixes: 8afefc361209 ("net: mana: Assigning IRQ affinity on HT cores")
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > >  drivers/net/ethernet/microsoft/mana/gdma_main.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > > b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > > index e97af7ac2bb2..aba188f9f10f 100644
> > > --- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > > +++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
> > > @@ -1375,6 +1375,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
> > >  	gc->max_num_msix = nvec;
> > >  	gc->num_msix_usable = nvec;
> > >  	cpus_read_unlock();
> > > +	kfree(irqs);
> > >  	return 0;
> > > 
> > >  free_irq:
> > 
> > FWIW, there's a related error path leak. If the kcalloc() to populate
> > gc->irq_contexts fails, the irqs array is not freed. Probably could
> > extend this patch to fix that leak as well.
> 
> Yes, as that problem also appears to be introduced by the cited commit
> I agree it would be good to fix them both in one patch.
> 
I'll send a v2 tomorrow. Thanks for the review!

Best regards,
	Maxim Levitsky


