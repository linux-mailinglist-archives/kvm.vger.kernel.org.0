Return-Path: <kvm+bounces-59677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB058BC7185
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 03:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0E8F19E35C2
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 01:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A8BD81724;
	Thu,  9 Oct 2025 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Buntc0/f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78C010FD
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 01:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759972539; cv=none; b=UzLWjQ3IIeYfuGI/MeHAajpy4/xrNIHwiEBoYThUI4axvFBzishPcNbGVfjFXz92UgeW0EObAzksfMpe2SUTW/BTODcZhoz55YDDXn+Ktsz7DN+AXRE5lRl/k/gJ6nzDzOQX6Z5d9oP5lQT1PGURUY3smSnLDaD97ZNnMJZdgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759972539; c=relaxed/simple;
	bh=6NlSKkxZlVO5WTh8oEYqMjakzlLE08JnCxCMdojLM0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHM2PX3lXNz7rbpvPcowp5tDxxkozUStKNlVihUnY+QI3BFyZWIIcNM68rZ05hjs1l0W5IlKtMIe/IFM4wQmU+3KBPyJ0Ft2YqR4HBWhwcKBdPzhETIM3raWhI9lF/Ds0ffyZP8J6OGXzYSDeE8ddxf6xRgg92UiEiBrWTdMUno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Buntc0/f; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-856328df6e1so44364585a.0
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 18:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759972536; x=1760577336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X+50x3SuEDTQMHbMrZRx1tSrxHENkGNKFoxPTbcoO7Y=;
        b=Buntc0/fb13M4oijdSbbiT1OCU5SW0r30JoG7YUD2byjeAFt0pfs/T0lkZ34A9C4Nr
         wa9UKjjl4u861OkRG8MPp8PUYIYXAVvJlusAoaXSMRYIBL4ZZYhOEfdOD2o1meHSDLsF
         60TlMD+6Ptq3CJ752KcY4MvowAyR2yoe3Sv1FOEwWgooukxiuEa6BxffOfgTPFVmTmjT
         LcizFBWSNyb5Kve7vso07pOW9eTcBBy7RicgJzQc0uPAMjlb5VuatzQYHMmq0c9v2oq8
         C0RR3gqT745Xxh3z6JOlcBBcvcbUqHYaBUjuhjAZK6WfNBAS5/MpUdz8/xNhNX0gNpOn
         XWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759972536; x=1760577336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+50x3SuEDTQMHbMrZRx1tSrxHENkGNKFoxPTbcoO7Y=;
        b=QECQAV2oCMwDThWLrDrq1EplQ/M1XNGlaCh/LjR+TjdHN/MmH0f9aCoqRDGZxatNGS
         bJwl8Qe8EaBAyQrTfQKZ5g0SXpg+A4PBcOY6VwKDOiQ3h28b2yWNvFpnOvmf4UOAY7rB
         +fT35Mhcf3K/uHMqd3i6EkqXT9ypAUoKttFIGb+Z9fSpyR02RnMJlxgvd1BPElfdCJab
         G0+vHNzXQKvhW5b9enVh63ZKQa3AEfItvLiZMq4Vg0S/yTv38tdVJSeAI6onk4sWHCe0
         wvSAtApFsCWp93Z3OHgA7P9XttRCfcp/85fq6NGfjTN6/LsYBfubhKpBa4HWQuS0DYua
         QbZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyDb+iFg3NQIXT26sRR/ZDefDha7fpsBo5TGS9rqwYlEN6BfNffkaB+/tWFHEdteUAam8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy76NeTOUtWrsle+vOUUiSDP4QsYtO0k7i5SGz8FjBB60htctlw
	po+IkL42s7eFSeJxc08GNuimmMtQb/AGyVTpyIKxcc8kgBMlMI2zQdRUh4/22n91iMCC+dLPB+z
	up3Z1C8s=
X-Gm-Gg: ASbGnctZFGBjZBtVNbfMDIK7GzvxCDJ7ik9jHSRBuxMmJJ7FORAV9TrlRND/8Mp9nvU
	frK/FIWfiDS14j/7rL6RWIJGVGni/aOQ/xfSeaUIlJIrXnYPrVwKNGqyWguJ+EC6XzjSpUdtCsp
	q1VLTP87e13H8Yasd/l2QymZ662m56HVGAwyzcuAsvRYzI/oGUQGIZ+AMgVjQ1zM6lnZ0CMhnR4
	AXwoEAVMLxFsqOWG5WmzhU32NnCUadNVPPO51S2XQ2fPexxvLCO1kKJBZBTap7XP2KdSmhoXES8
	p5SK9mXhLaJm0840gdeQWYB/HTRGDV1PxYsWjv+fkFwT/dHRK/zjKqVDdS4p+s3k63SBfJB4++J
	ejNeZfj9dFjTutT6iXDFSaQ==
X-Google-Smtp-Source: AGHT+IFYnvoWW9Ct2gqjPcp1GG/GlxQ2K5VY9T33xZfe+kDiDclwBD57GYhyabKLuQmZsWKoqGGFng==
X-Received: by 2002:a05:620a:6914:b0:860:e823:887d with SMTP id af79cd13be357-88352babc71mr840838685a.71.1759972536584;
        Wed, 08 Oct 2025 18:15:36 -0700 (PDT)
Received: from ziepe.ca ([140.209.225.78])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a1ca3defsm98772985a.38.2025.10.08.18.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:15:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v6fFn-0000000GEZH-0Pfw;
	Wed, 08 Oct 2025 22:15:35 -0300
Date: Wed, 8 Oct 2025 22:15:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vfio/type1: sanitize for overflow using
 check_*_overflow
Message-ID: <20251009011535.GB3833649@ziepe.ca>
References: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
 <20251007-fix-unmap-v2-1-759bceb9792e@fb.com>
 <20251008121930.GA3734646@ziepe.ca>
 <aOaFqZ5cPgeRyoNS@devgpu015.cco6.facebook.com>
 <aObjW9VxYMkFQ1KB@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aObjW9VxYMkFQ1KB@devgpu015.cco6.facebook.com>

On Wed, Oct 08, 2025 at 03:19:07PM -0700, Alex Mastro wrote:
> On Wed, Oct 08, 2025 at 08:39:21AM -0700, Alex Mastro wrote:
> > On Wed, Oct 08, 2025 at 09:19:30AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 07, 2025 at 09:08:46PM -0700, Alex Mastro wrote:
> > > > +	if (check_add_overflow(user_iova, iova_size - 1, &iova_end))
> > > > +		return -EINVAL;
> > > 
> > > Let's be consistent with iommufd/etc, 'end' is start+size 'last' is start+size-1
> > > 
> > > Otherwise it is super confusing :(
> > 
> > 
> > Both suggestions SGTM.
> 
> I'm not sure about the latter anymore. There's somewhat pervasive precedent for
> using 'end' as the inclusive limit in vfio_iommu_type1.c. I am all for making
> things less confusing. I don't think I can introduce 'end' 'last' convention
> without preparing the existing code first.
> 
> Thoughts? Spend another commit renaming this to 'last'? Tolerate inconsistency
> between vfio and iommufd?

IDK, if it is actually internally consistent and not using end
interchangably then it is probably Ok to keep doing it. If it is
already inconsistent then use last for new code and leave the old as
is?

Jason

