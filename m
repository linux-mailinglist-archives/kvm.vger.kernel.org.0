Return-Path: <kvm+bounces-60848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC4BBFDB82
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 19:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A12304F2C31
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 17:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DAF2327A3;
	Wed, 22 Oct 2025 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XFRZjc4d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1532DF14B
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761155620; cv=none; b=Ntgd7/mkNwKiKns/tdsVHQ1nPwonsqRtB2dRwtir+M4nYH+O9Xoxw3CsW+xtSc7Y/qdZt4ALIgM7Kz8IpyOGUrVNmcNfShvqyJOpnX9kf8mUtJ+SzEZa9DQ79ZB1LSBvoxlJtdSeGYlk16Nj0y8Mgl4891iFORtxp7aHaHvpSQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761155620; c=relaxed/simple;
	bh=pGtfMoapvO4lMb9UP8A/7JylUYzvwsLtdOLf+pqTo7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iubaLZCZkeeIscxU1O+YeR/MVXdnIDpqysdy12VWL5r4HnJcy688111E9bf4RbSLloRv5IqimC6//F2LySMkbOFG2y5vXCh8SQSNdVdZtv8qOQJf6/sUDnkEQYwHW4PevdpzGR72n5t33O0RWdLOyZAyPFGHjb133UL/2lzgee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XFRZjc4d; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-88f79ae58d9so893124685a.2
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 10:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761155618; x=1761760418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pGtfMoapvO4lMb9UP8A/7JylUYzvwsLtdOLf+pqTo7Q=;
        b=XFRZjc4dn1dqyWNIkWB8Tx1CrewYzSWip7C/wmjgHrr2R8/c9k+4iyaZhjPvIuw1SG
         ToVdoHWe5C7jmPhYVbrsBU7rORp/xhfzjJPFNgEMhpQM22ALzX0cSoUSTyTnl+2xfpwa
         1e+HpXUCn/E8+svkpZQpqoPC6oSLalFiAYug3BtbZLtyX5MnolRHRURjIHCuRZJECle9
         YEbLFupEy/F/F2bfcVMFZuAgF9113koiDU7PODAL7hjq+rHzXjeqhMvL4hIig3tG4SsN
         PFM4TlkoipPKjtLISb5rZMrzB5o2PVppJwh00wnrIw+S/uVMWJsNgjqvrNU7HFVXA1Op
         RUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761155618; x=1761760418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGtfMoapvO4lMb9UP8A/7JylUYzvwsLtdOLf+pqTo7Q=;
        b=tkFRJpbcmlLRG7Gz5sKPwABReLI13J+vRm6XtsUo93cqByyj/wDchy5K0JHt0uUbwI
         E+bhWileI7brEEMDZh7+KhHQgMF1E5x5ZOtCXWuqCGoWFAbDNfgj2PspSdDQTEb1YfZJ
         cDmKHSeD17axB1biUBdGlntV7FTuclo2cgt3v5yW/l505X7NSMW8IwCqxxRX5m9zyYDl
         8NFCPI+w7VqaLgpKnRoQpvGXmHU7Bds3x2FbQRJQu6wQKmoT+XhdETBLt0vpI72KbiQx
         t33X820DAPwqLJIdIzfaOxPLcURBOB0Z37R8k0C7Zo301xp23bZ0dO60kzxttXEYccxI
         NwoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSGy7BTchVdBElO4pVyjuuMlLv6X4flvGF99ArJD/93h8ioGxs2dIGmK3PLUf4/ajC3uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+gG20lmbMjZXs72y0/gCnL3uc6iN2WJUCIqEJVGC9uLuYGbm9
	J0+rZs7Hs1dQnfl7fIyu2ms4TIlFSwSSynf1C+kriPajffteV+2bhKiRiwWonV9ESFo=
X-Gm-Gg: ASbGncvvuCLHcgq2gwnTyF8ps7UQwsC9DJCSW6FVsg8pdEmPhHOEYpw0ik4P7E9Ng/8
	gh+s+dH3z1aGcVfGjLW0drqUCL6gJjV+KoqAiuzipp6luV5vR6AZsB5uFFfcRg0hJ+rgujUEdhw
	VAa/3QX55VqTcANs3t6edwrx3kHxxk/J18FA3DyE6r18dIzay1OENp0wTj9i8DyMxgxCL9nGWJ2
	fF7s9tl5vm8tng7H3qUINBWdegMi9Rkxn6Kt5nWm84Eq12qdwtX7gC56fo10zrqBjot50MwewtG
	Pt19rGOyrWMLHEFA3oF0PvsX5xeESbl60HkElD4ryNbiB45PWet73KOed9VsFA0gSFZ7wbua7Cw
	yWZrZ7eAWLgPH11N9zNTJRlE3GhQDHUU43pDVolmNqt3Z1/sWUYv2xhW6co969/J8zK9stvNap+
	Jbwpk5Apz/VfiXO0Z9QOvCjcJ+V2Lxvj465StF7UWLec50TQ==
X-Google-Smtp-Source: AGHT+IESyeCC2FHKHN/7kLpkB57MVkKkUGNI8wUHjKLJgKkzjDVQUo6gHR7luBSwV2cWSylpPLwNZA==
X-Received: by 2002:a05:620a:172c:b0:891:c59a:a9c1 with SMTP id af79cd13be357-891c59aad1emr2195885285a.39.1761155617879;
        Wed, 22 Oct 2025 10:53:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cfa623d0sm1012199885a.60.2025.10.22.10.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 10:53:36 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBd1j-00000002rQd-39Fm;
	Wed, 22 Oct 2025 14:53:35 -0300
Date: Wed, 22 Oct 2025 14:53:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Vipin Sharma <vipinsh@google.com>
Cc: Lukas Wunner <lukas@wunner.de>, bhelgaas@google.com,
	alex.williamson@redhat.com, pasha.tatashin@soleen.com,
	dmatlack@google.com, graf@amazon.com, pratyush@kernel.org,
	gregkh@linuxfoundation.org, chrisl@kernel.org, rppt@kernel.org,
	skhawaja@google.com, parav@nvidia.com, saeedm@nvidia.com,
	kevin.tian@intel.com, jrhilke@google.com, david@redhat.com,
	jgowans@amazon.com, dwmw2@infradead.org, epetron@amazon.de,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 15/21] PCI: Make PCI saved state and capability
 structs public
Message-ID: <20251022175335.GF21554@ziepe.ca>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018000713.677779-16-vipinsh@google.com>
 <aPM_DUyyH1KaOerU@wunner.de>
 <20251018223620.GD1034710.vipinsh@google.com>
 <20251018231126.GS3938986@ziepe.ca>
 <20251020234934.GB648579.vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020234934.GB648579.vipinsh@google.com>

On Mon, Oct 20, 2025 at 04:49:34PM -0700, Vipin Sharma wrote:

> May be serialization and deserialization logic can be put in PCI and
> that way it can stay in PCI?

This does seem better

vfio should call something and get back a token it can store.

Jason

