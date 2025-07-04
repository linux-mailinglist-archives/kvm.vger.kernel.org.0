Return-Path: <kvm+bounces-51535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4CBAF8583
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 04:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 986866E0E68
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 02:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3830B1DE889;
	Fri,  4 Jul 2025 02:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="j1J9cO7a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749DB4315F
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 02:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751595634; cv=none; b=g4qF4hBBF7s49D3Gtjf3h23sydEPvcpgHIEGTOF09sXISzon7V7i+WDhUakHMpizkns5FHam74jgBG9FtlJ9AZs3Wca3QY/jTUYa5N1Y3KYh1lpEz9GVctRox9lZTJmmyMC1k5LUZQ7iQf9I2ll7EnDHAJgpckHJz7035v2BByU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751595634; c=relaxed/simple;
	bh=ycIHSnGYILJIPVpfKHa7ftGdGsIB8TwD8cX2/vQx/UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeCgTAOIKeS8GKbHe4k+5zPfwT4iIBJy7QzDvihTFyxDfDRsBKd7ZOtcBp8X3s4KnzYykQkdJ1WL0IVrYQgQE57MhIT821vZ0AYN2A4u3p+BcPeRhJC+3h2Au1hCD9YfKBiNv2YqQBOHomYNg6vKuJjwO6SGIz/672jwhRVl+qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=j1J9cO7a; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748f5a4a423so372185b3a.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751595631; x=1752200431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nB2mhHfPsdN/BAHed7HqkYTpkP4d7ANXryStYAUTRgU=;
        b=j1J9cO7aMDyQmkhusxG8aMeLib4pH2ViQfhYNhQjK2l7KpX3P3V6sZs0WOGgf81Tdk
         6mw5r72IRloqSqxM9cZC1jux+4WOnA98YcT5pNpn9wu5SZoKZJ0RWq1s6I0KKQkOlUi5
         yyA9izam0GT9ilPkO6FbOVCjkuOFKofjwhZMzm0GRbxiIsGiKc1HIvJVO72qudLjEP9/
         fSIr8FFGgBzwkpVB2uDvvkabXc1hOTWuXrvBadyhzEsgTOZeaBWH1Xq47UGhjnNSloNh
         Wkpyx16gp/c7sD4TtKAkBoEyTi0Zlah+ywfq0KKgPT3Rp24NqwQYA5PfeNKp14mNSrvz
         Zv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751595631; x=1752200431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nB2mhHfPsdN/BAHed7HqkYTpkP4d7ANXryStYAUTRgU=;
        b=RpAJV9uCvUU/cYo7dYfhQP/S5cLTW7DcwyuQG7UmauiKcfNW1cUnxi0mmGGWHDalYE
         Ehgpiax+Y77g2mDAXHLT2z8CHiuoThhfAiEI3Pet9Tz3C2Kf5zpx1cNDGacYeMKW9V61
         J1k3BowBRz/kbMtmYd0+sfA63IFdP4bhDSX4ouYsvQQbqxSjtYEz9DM8Wr8Pu4IVSQL+
         /iRJKmhHodaECUYNKsDGZyb7qhnEqLd2p2j2nSpBkHdOpV4RzUuqvfO/YX0Fg/nGu2y5
         mBa0Tyr1OkcbCVGUWJEam8uzXKD+N7s6Pizm2IlasirV/QRUMfFl+wrJg3F4WdJccOCz
         csXw==
X-Forwarded-Encrypted: i=1; AJvYcCVxIql9To43zqz6kJ885Iz31V47WoI2yC3OEP/qG+J1H8UPZUgMBI1zoUAPU6J/o9N14/g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7a3+NGA2b//ZtZCIs4MGNOgiX0qOWYOXqiEkly009ozOzjpGX
	pwMwCCKBhnZcgGMQjZiGhpSfDM1ZUYMx4akEM6vKhNeIcXlB+7nWWLxdaKPCLLB5ZyI=
X-Gm-Gg: ASbGncu4iVJ/c/0u7VJFJPPYndmXk2r4b8c8k5TEUm96PsYky+ySjgaccy0odk45ol/
	C/IvNEk2/fnbC/SBWxtG2r/rLfPWgfi6/qanPWsW9AAGYIXwEZBhs8pI+UvDdI8J5atH9wNtzW3
	RCjIlONJKq/xo2dhBrwxQKQ+CyhC3JRg5praqTOPCmMNwfz2YM9cGdYhuIE2K9T3KN6SqBeg1Y/
	AZWnwa5rgx7vvmAuUuyM2ucpcKYJ8n6DNOz9KSfPIqLTpDka1Fhv620Ew6SNc/MXacCP1wr1NuN
	tk4Ug6njo9cZUqnW0WA6y9Y3jk9nDjMlOqfCPbTfwfDrUAeMdqzptnG7x44TqfLnXXZa4ZY+fOk
	E839zfNVPIYWwPBkh4g8qaV8a
X-Google-Smtp-Source: AGHT+IF5FgaG48Lz7SQabgqQ96oyxCzyELFi6hJD/bR45TR94ijLKiZUWTQ6L0DOK/RO4NSLyKHLaQ==
X-Received: by 2002:a05:6a00:3e21:b0:749:8c3:873e with SMTP id d2e1a72fcca58-74ce8ad900emr652873b3a.24.1751595630812;
        Thu, 03 Jul 2025 19:20:30 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce35cc722sm799335b3a.49.2025.07.03.19.20.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 19:20:30 -0700 (PDT)
From: lizhe.67@bytedance.com
To: jgg@nvidia.com
Cc: alex.williamson@redhat.com,
	david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH 2/4] vfio/type1: batch vfio_find_vpfn() in function vfio_unpin_pages_remote()
Date: Fri,  4 Jul 2025 10:20:24 +0800
Message-ID: <20250704022024.14481-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250703122756.GB1209783@nvidia.com>
References: <20250703122756.GB1209783@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 3 Jul 2025 09:27:56 -0300, jgg@nvidia.com wrote:

> On Thu, Jul 03, 2025 at 12:18:22PM +0800, lizhe.67@bytedance.com wrote:
> > On Wed, 2 Jul 2025 15:27:59 -0300, jgg@ziepe.ca wrote:
> > 
> > > On Mon, Jun 30, 2025 at 03:25:16PM +0800, lizhe.67@bytedance.com wrote:
> > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > 
> > > > The function vpfn_pages() can help us determine the number of vpfn
> > > > nodes on the vpfn rb tree within a specified range. This allows us
> > > > to avoid searching for each vpfn individually in the function
> > > > vfio_unpin_pages_remote(). This patch batches the vfio_find_vpfn()
> > > > calls in function vfio_unpin_pages_remote().
> > > > 
> > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > ---
> > > >  drivers/vfio/vfio_iommu_type1.c | 10 +++-------
> > > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > > index a2d7abd4f2c2..330fff4fe96d 100644
> > > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > > @@ -804,16 +804,12 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> > > >  				    unsigned long pfn, unsigned long npage,
> > > >  				    bool do_accounting)
> > > >  {
> > > > -	long unlocked = 0, locked = 0;
> > > > +	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
> > > >  	long i;
> > > 
> > > The logic in vpfn_pages?() doesn't seem quite right? Don't we want  to
> > > count the number of pages within the range that fall within the rb
> > > tree?
> > > 
> > > vpfn_pages() looks like it is only counting the number of RB tree
> > > nodes within the range?
> > 
> > As I understand it, a vfio_pfn corresponds to a single page, am I right?
> 
> It does look that way, it is not what I was expecting iommufd holds
> ranges for this job..
> 
> So this is OK then

Thank you. It seems that we have reached a consensus on all the comments.
I will send out a v2 patchset soon.

Thanks,
Zhe

