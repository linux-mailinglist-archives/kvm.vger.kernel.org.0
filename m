Return-Path: <kvm+bounces-52443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F29B053E9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 10:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8246B4E5810
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBCF2741D4;
	Tue, 15 Jul 2025 07:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mGYc/83S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F9C157493;
	Tue, 15 Jul 2025 07:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752566390; cv=none; b=HhQsStGZaeTGZyjuT5wk78zGruViIo34ZdPkBKlXV4CoCd1v22LLP0UW98xFIjDAu1WiCIkfO+nSMO2OtSUjLQD6jzXtwqPiMd+6F5gICRqUZPAgctv/Rn0QTNZoivmM6/7GkXNCw63afmSs4OXfiQ89o+d3pVlF1OZXv5qhKHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752566390; c=relaxed/simple;
	bh=UeR90blzl1UkanLlvwh7Gs4nuz3Jzfvnov9b2Px8QHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8wFwPLCrjYaYuLbmgcsFBFl7syIg4nb6OoUH++3kb/jbPsnTXvxlyXNax2DwNh6kPmOVbylETot7CgCsB2mGM0MTDTj7lV8bvZvHA2JIx2xw0RqbpZ9ExbWyypX2p0Np8oIXGWRbKxP4TwPEkcOEgAhNjrzmh7xAalqPx+TMU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mGYc/83S; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752566389; x=1784102389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UeR90blzl1UkanLlvwh7Gs4nuz3Jzfvnov9b2Px8QHk=;
  b=mGYc/83S4Pw4MSj0CRlVhgvIOB6Bghe9OIi0MCL5XKR68PfG7fdKMoBn
   GDdzxL4EqkHjVmqJuglu5rpFCa2/fLxF6w9MRWlICh0Aaxrf5a4EII6II
   +TmAaNiVUMCkPnofLsX2bbwZgb/6j1LKp8IL8TNBcsyLl50Te/LrEVA6q
   wAabd73OcaUhvpAPuPpSNxWZ8NCC0EgkOvB5todD1AZkHuRrNeJZ/IpaW
   uELWvSxuTQzVvpcEyNYWm76SQJU8B0hN90iBOkIGPCriZYoa8OpeRY/x/
   MPIgX10NTXIWPzOtzf+/EtWCIM5ApG0FAfDieBevctSrlBtNdZale8vox
   g==;
X-CSE-ConnectionGUID: Kr12rtJ7Q4uXJy/+ThIsZA==
X-CSE-MsgGUID: 0PqRyTODQd2wmec84yPADw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54920732"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54920732"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 00:59:47 -0700
X-CSE-ConnectionGUID: LAglGVJPSx+FTNAdNBYyDw==
X-CSE-MsgGUID: ZxagDbPCR3a8lGaD4xN+/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="156565039"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 00:59:32 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1ubaZS-0000000Fadw-49Fb;
	Tue, 15 Jul 2025 10:59:26 +0300
Date: Tue, 15 Jul 2025 10:59:26 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: WangYuli <wangyuli@uniontech.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, seanjc@google.com,
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com, rodrigo.vivi@intel.com,
	airlied@gmail.com, simona@ffwll.ch, marcin.s.wojtas@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, arend.vanspriel@broadcom.com,
	ilpo.jarvinen@linux.intel.com, jirislaby@kernel.org,
	jgross@suse.com, sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com, akpm@linux-foundation.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	ming.li@zohomail.com, linux-cxl@vger.kernel.org,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org, kvalo@kernel.org, johannes.berg@intel.com,
	quic_ramess@quicinc.com, ragazenta@gmail.com,
	jeff.johnson@oss.qualcomm.com, mingo@kernel.org, j@jannau.net,
	linux@treblig.org, linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org,
	shenlichuan@vivo.com, yujiaoliang@vivo.com, colin.i.king@gmail.com,
	cvam0000@gmail.com, zhanjun@uniontech.com, niecheng1@uniontech.com,
	guanwentao@uniontech.com
Subject: Re: [PATCH] treewide: Fix typo "notifer"
Message-ID: <aHYKXgc2k5wDY32c@smile.fi.intel.com>
References: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>
 <2025071545-endnote-imprison-2b98@gregkh>
 <5D06C25920559D71+06c9ce34-9867-495c-9842-dcfe9f1d51bb@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D06C25920559D71+06c9ce34-9867-495c-9842-dcfe9f1d51bb@uniontech.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jul 15, 2025 at 03:53:18PM +0800, WangYuli wrote:
> On 2025/7/15 15:22, Greg KH wrote:
> > Please break this up into one-patch-per-subsystem, like is required for
> > things like this.

> Honestly, I've always been quite unsure how to handle situations like this.
> 
> It seems every subsystem maintainer has different preferences.

True, but at least if you see the specific driver in the MAINTAINERS, split for
that driver. For instance, 8250_dw in this patch is exactly the case.

> I've previously encountered some maintainers who suggested I split such
> patches by subsystem so each maintainer could merge them into their tree
> without contention. However, other ones have argued that fixing spelling
> errors isn't worth multiple commits, claiming it would create chaos.

> Since I genuinely discover these spelling errors by chance each time, and to
> avoid giving the impression I'm "spamming" the kernel tree for some ulterior
> motive, I've opted to squash them into a single commit.
> 
> That said, I personally don't have any strong feelings or preferences on
> this matter. Since you've requested it, I'll go ahead and split it up and
> send a v2 patchset.

-- 
With Best Regards,
Andy Shevchenko



