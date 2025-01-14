Return-Path: <kvm+bounces-35382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E055A10848
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B998F167C94
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A2670815;
	Tue, 14 Jan 2025 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RXy3+xSO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF7E382
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863252; cv=none; b=PhuLX+q7nTXgop+A+lV3Vd0EJR3/69LRvOW0lxlZagjvmq7aJEVAeoFCzeRmVwSlG5wDO3+695qJLWde18taYPu9/09rYUu/opewfYu7OFypbndfUjHlk6VI9Ucfj/tHRmcuFduo0MJZNlpO4/w9JrbjXgbZ3tyzYPLUrrhw+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863252; c=relaxed/simple;
	bh=8BMyxqgW05QO2qOZqj7+cLCABXc+0jxdHZgaV+tYc28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNv67/4c9WtFPwvbUm0UBZTju6Jpj2nDmAO6dtLJcIxEnI3G0bPJ6rhfMpmvSua1fuIl8jiPxkosWAiN1u+J0NO4PAxQRRIlhMLCB5sgx8+5pNP4JwuICM/EfwVMktex+RYVSxkWB3hStfqZSX8jbDmXp2x9DxatmrF2Mphs+cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RXy3+xSO; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7b6e5c74cb7so404840485a.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1736863249; x=1737468049; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8BMyxqgW05QO2qOZqj7+cLCABXc+0jxdHZgaV+tYc28=;
        b=RXy3+xSOL32wSUbFj6xg2bQUM1c55tS8tkIuihybUYk85bAEOdjr2yaCWM3+ucdhcD
         90lBeFftpmXDqKetf4iSNAErn2i6QbQ2WZU6G3YGMYWA967RlQVoTCzuDGrdtd+CWV0l
         w/31TAeiWQMCxovjseEjyHYB1FA/yi+qixs3rKx0QX0/JdG+MpEvzghtOC+9y27nd7lc
         NuwPq84C+6BREsYElnDByKz3chK85a1LI6pdjZXS8vnosoH6mbE8jX2gb/NYiem36wWf
         ihHP1+AxanDQHRUehZ/Yjyih3+bzLI1WBfVx0Ozq7ZHWvzTIDJ+CDnELwzjYoZiWEBGD
         4yxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863249; x=1737468049;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BMyxqgW05QO2qOZqj7+cLCABXc+0jxdHZgaV+tYc28=;
        b=egQ8PojyOLgKArRBcFwPw/xUGDBczs7I/CW+JjiP3Sf269SNae2ruIiLBje0j8jlJO
         LJNGgyLWL5hc/+d1P2ErojK4tcXx/VKPWhMUnI4lglykHEZ7bGnDi/9xbDH9PfU5dGHs
         nEzeePcTAeWbtxrn5k59LLlhTuOrNBMLwFLpJ6TaZmF/gFUzak60y6+dcYAyd+tJF1ml
         sF1wrrjbD6KsstydVDVwuwlhKPRBuAYu19NVQluFzcj4Z7xkbN6sqPTW2p9N6j97m0lV
         inERtxMM22FVN8bTuy1llDz9gsHH8u0va3cPzisEOUEzXrPKXmx5yZtrKutUsy7F9eLb
         JtVg==
X-Forwarded-Encrypted: i=1; AJvYcCXRjD7bnQAkdK96j8r81i9KP9Ad8ZlBaPoCwGvl06zgHoBOpQCyZ+I7FvpJK3ODd6/aHDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNiuyR9dGephnsimj15omZKMpPVkco5O+CTQG7FsTHf6yJHJjo
	ln5tlsHAJ4LQiTiLb2KPOrKAPKOuECf1HaodVinVobHPdVwBQDOH0wHJzF8qsY8=
X-Gm-Gg: ASbGncviZ5bMOkr6eLpcuPbhJQUfL3qfeQPHHAEvXQDiOl01u6KH1l1iZtUGwt692Sm
	rNfFCdqWKlWgpn77juLjLNpNTWeDbGUhWNmr+YCCilKQTyU6h58paiVBZXFp2lwPXkd02nwV0rz
	6FwpgNUVMOSDYy/IdW2a8TglvBTqySu9BN9qMptUcFDRc8tcVX1/lIrB0DL4iwYJ0e0W23ylWZZ
	PcnmIkyU5IgZ+7feJldnZZUMx4h4E8/Wzis+ZpfL3oBhw092Tizo2RKrT+HN0LWfwGZOPMat1V5
	r3HSAwySly8fSg3iKrQ58iheDdVYgg==
X-Google-Smtp-Source: AGHT+IFj5cUPNoxRyfUWi0cImeX0GWcItYpZG35ar0KkJS9wbKlRrbxMrHxKd4f6xh8danPhpKYIIQ==
X-Received: by 2002:a05:6214:2349:b0:6d4:1f86:b1e6 with SMTP id 6a1803df08f44-6df9b2328b9mr311869086d6.22.1736863249548;
        Tue, 14 Jan 2025 06:00:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dfadeb40eesm52571936d6.123.2025.01.14.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 06:00:48 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tXhTL-00000002NSf-1rSB;
	Tue, 14 Jan 2025 10:00:47 -0400
Date: Tue, 14 Jan 2025 10:00:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v6 0/5] vfio-pci support pasid attach/detach
Message-ID: <20250114140047.GK26854@ziepe.ca>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219133534.16422-1-yi.l.liu@intel.com>

On Thu, Dec 19, 2024 at 05:35:29AM -0800, Yi Liu wrote:
> This adds the pasid attach/detach uAPIs for userspace to attach/detach
> a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
> enabled in this series. After this series, PASID-capable devices bound
> with vfio-pci can report PASID capability to userspace and VM to enable
> PASID usages like Shared Virtual Addressing (SVA).

It looks like all the dependencies are merged now, so we should be
able to consider merging this and the matching iommufd series for the
next cycle. Something like week of Feb 10 if things are OK with the
series?

Jason

