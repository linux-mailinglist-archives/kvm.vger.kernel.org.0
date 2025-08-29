Return-Path: <kvm+bounces-56256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A463FB3B437
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A2E7362118
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 07:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B4A26B0B3;
	Fri, 29 Aug 2025 07:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YLnmlNaR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB8326A1A3
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 07:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756452448; cv=none; b=ZtDoosGbwaIksLRci/ZRuOhaiHVzvsxPr/iIMouef/8IBcHWpgBOdRnochENqj1LPnD6yJ9NaBcOAsyA2ajIKcH4vzuflXdZ/e/nuzTNajK5bwP0tGQQJzs5fzx5ysJVmN1qr8if2lQp2ZHhmEzxNr8KyUk783pOQUYrNgOjSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756452448; c=relaxed/simple;
	bh=Pc/dPQ459IqwCahzHXFvqDdvdMe5WtGmeTDxhph0vPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAeGRGC7YKxBgJGjvzbyZIrlYcZKO+X0XqqEEqDuk/65IcJI4IIufLpIELTdLSiV9ni8epfINWFxtZETpRORLUu15TU155D38rAs7aPW6WOHVTtuK1KTV8vO0u8VrVUSq1xwpNN2iDIWhH2mhvYQM/0tT95VUEk3ZaujkxH8ey4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YLnmlNaR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756452448; x=1787988448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pc/dPQ459IqwCahzHXFvqDdvdMe5WtGmeTDxhph0vPE=;
  b=YLnmlNaRmHW61QCPuPUdQIYzzm4eROJApZp4nOCeUKF3aR3I+SHZWomT
   mGEBE8Y05r0XQnTMV6eO14IMrwLTE9fcSicAtHOt0wDdRKZxx8RY8wgd4
   ZnR3s5cKPZBwgTSjUzaX8JrgdexjYkOegtkZs9FikNpyUWNwrlYESu1uK
   B8OF6XlhGfmNWngp/RpLOdyFXQnY4csy1reHDkdUVQMCjC/K8z3JzfpP2
   wW0CR82P6XQOKdvjEHZ9NtKayi2aYoeBfAhwY9Qy500W78AvmiGAFcdFd
   DRFO8iBI8dmwKD/xBSvXUDMIlHCoLAJYmDB+464HNkEJkfTWwnjZ2sK3M
   w==;
X-CSE-ConnectionGUID: hrMNiovHQDeANh7HI1bghA==
X-CSE-MsgGUID: Mq8jZh6MSvqykCPyJwOwHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62379825"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62379825"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 00:27:27 -0700
X-CSE-ConnectionGUID: X5FYqx+IQpOInZxaJVvyjQ==
X-CSE-MsgGUID: g0Q3RUDAQySQHvKQt50Hqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="193976134"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa002.fm.intel.com with ESMTP; 29 Aug 2025 00:27:25 -0700
Date: Fri, 29 Aug 2025 15:49:12 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
	kvm@vger.kernel.org, aharivel@redhat.com
Subject: Re: [PATCH 1/2] i386/kvm/vmsr_energy: Plug memory leak on failure to
 connect socket
Message-ID: <aLFbeCthx53qkq8e@intel.com>
References: <20250723133257.1497640-1-armbru@redhat.com>
 <20250723133257.1497640-2-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723133257.1497640-2-armbru@redhat.com>

On Wed, Jul 23, 2025 at 03:32:56PM +0200, Markus Armbruster wrote:
> Date: Wed, 23 Jul 2025 15:32:56 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: [PATCH 1/2] i386/kvm/vmsr_energy: Plug memory leak on failure to
>  connect socket
> 
> vmsr_open_socket() leaks the Error set by
> qio_channel_socket_connect_sync().  Plug the leak by not creating the
> Error.
> 
> Fixes: 0418f90809ae (Add support for RAPL MSRs in KVM/Qemu)
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  target/i386/kvm/vmsr_energy.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


