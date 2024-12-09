Return-Path: <kvm+bounces-33316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A84439E97CB
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 14:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 086021885E11
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 13:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C1A1A23AF;
	Mon,  9 Dec 2024 13:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EW3FOZCY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BBB233143
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733752282; cv=none; b=rVN6F2gGFvcdx73JhvfoVQM4bs2eTDsBK0LuTnGePx5u1SAb8rIkRWMfgkB8NDdnOjdgTQf+mV3oUS2yK3rpy2RhIs0B5WBd3PHqiEzETG81nUUUd47tfOklz5OWPSA6JuN497NaBluStUqGA0zr1uB+G3sSh1uvE8Gh/FaUOY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733752282; c=relaxed/simple;
	bh=G+NgakMEDsw39gt5RazNkQV4/6Me2lGpcV505Fl98PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joVQARsVrc7QF4OJwaKiXvwY9C2wBNQo8YStPg/5NxjTjqphAPt4RhY17RNwGu4zkZfqrQamJaXuDV88aXezHGJ6Sj9DuF1UyYyVP6sZqsLEWEvl9RIk1mD3PqboMFR7/TyP3JEeMt0Xl0YuB6/EqW37dqBQLEO7ZeiiL/WKAMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=EW3FOZCY; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7b6c36490e5so138427485a.3
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 05:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1733752280; x=1734357080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R7oEv/kWOQJwYOJS1T6x11V4qC7qnoI5kWJVO2djWrI=;
        b=EW3FOZCYN/soW1gKj051PgDzyH6oX+VDiKbqtFCNOCPD1SbJWofLIxyKp3z1e6Eg8N
         P4o7ChDgh6et5q3M+h0NcfRlPMz1YkBYTSV/aN5OhXev5xW3juMojoqaHFVJZGlN8LQK
         guIXmH+ksq5IWIfyJqFPAMsZilrSA97tqKuBWsh31JUlMVrOo9p5/NCzQVjqRsz2FIhy
         CNAvaBjQ2z0+lVL+T+wiOcyrFPmxDgfMNXs9Z1MZNxiBx4vnq37XIbCa02xySCe9I1/6
         1gNSO63Xlg/YGxgKBP9M9s3j4FDyHdERhtDv9L6i4yMIZZmLUbuRtTOItiXAfJpFcx83
         9zPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733752280; x=1734357080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R7oEv/kWOQJwYOJS1T6x11V4qC7qnoI5kWJVO2djWrI=;
        b=FrXA86r75V/2D2hS5B8ofABKtJfC+NjbFMg++S7JrsBMnoNFONHwiw9rzEzh1LrQ/0
         q+0xrAssBhqCGGLzEAYtO5fdD9ocT7uPiLoWlg44mBsCZuE2U3o2Pq1IqMtj/QTVKmh4
         62pxG4VXW0yBCRvxovTTa0l3x6q96UC0wk3dR7kPivZ42+qGBEikBettje93LpUum/6Q
         imvbrcCkzwEFNq6bRsrijOaM4nNATx7hwkoQ08za6EhY4lD+E6ABilvsaUKTIYi34Dac
         WIqJy8XeOKV3XIY+pM3t7rm9xtfKS0K79UomvOdtXxZjg9iRks22AYYngB0jXiZSrCQn
         wruA==
X-Forwarded-Encrypted: i=1; AJvYcCX75KfqDFBO/Xf/eQVW3fIpJSYsUvlBXbiAjkngrHs2N0thgKpFVEGcTNHrbTPEC8BnZEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDKqpcJIE5za3HZAhOjgvMS0xK3rCtaKZyxCTlUyT3pYaJ7aeZ
	lB0v4eQuTPwhrhlXYs8pm9uJCFY7Jt7fAuqaKdcM3hlfLetmXe7KGZwlMya1mQ4=
X-Gm-Gg: ASbGncthli77i5YLfOfESUKle2x9hf44qmQicbPfDErSLXDW/mCvRyebp8UqTSpzhMq
	BuEl5ltDVCOhHs+ApngqpIY0IJr1hAWGlYxO6hmeEY1a14CJFDdnwvJ9UXtciJ0xZnXtOBVlLAr
	uGq27LSjzquU5WhLNiCtSCG6Rhx9rEqefZSWxsm96nlhPsVkxfPJPFahoulEsDxd3PuPvGpRHAk
	+JnAS7DBZe0UQ80hKTTq+o9EjyyCVmZaM05RKxm4jUZNAJg+59j1O0g9oU50koVybqBSDklNHcv
	pFvor+cFpb7+w+fUb3C2JFo=
X-Google-Smtp-Source: AGHT+IGRyqXoR5cNxX5xvO4n15YRROPv7PJXVPH2i6fLRL31UgLra1GXmWLsON0vFVsKduu7O03lrw==
X-Received: by 2002:a05:620a:2994:b0:7b6:d383:3cca with SMTP id af79cd13be357-7b6dce79d7dmr60890585a.35.1733752279943;
        Mon, 09 Dec 2024 05:51:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b6dd1b6cd6sm5754785a.64.2024.12.09.05.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 05:51:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tKeAR-00000009s0Q-07tC;
	Mon, 09 Dec 2024 09:51:19 -0400
Date: Mon, 9 Dec 2024 09:51:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Longfang Liu <liulongfang@huawei.com>
Cc: alex.williamson@redhat.com, shameerali.kolothum.thodi@huawei.com,
	jonathan.cameron@huawei.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Message-ID: <20241209135119.GB1888283@ziepe.ca>
References: <20241206093312.57588-1-liulongfang@huawei.com>
 <20241206093312.57588-6-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206093312.57588-6-liulongfang@huawei.com>

On Fri, Dec 06, 2024 at 05:33:12PM +0800, Longfang Liu wrote:
> If the driver of the VF device is not loaded in the Guest OS,
> then perform device data migration. The migrated data address will
> be NULL.
> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
> 
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.

This seems very strange, why can't you migrate over the null DMA addr?
Shouldn't this be fixed on the receiving side?

Jason

