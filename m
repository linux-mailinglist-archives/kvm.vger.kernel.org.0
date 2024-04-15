Return-Path: <kvm+bounces-14702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E75428A5DEF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A40982837C6
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9794158A10;
	Mon, 15 Apr 2024 22:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCZYd0An"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CAC15749B;
	Mon, 15 Apr 2024 22:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713221893; cv=none; b=KWoxA1FwuQX0N8cHfJUYkHpagLjggMwcOXS7d4ozpBbzdPwDqoLwCrpa2MDAXudzSnHyYaxL9Y0QJXnKJPI60dlqsaCddTWZPmIrWqCCDluqO1RsMnIcGTy53em1Pb7qUUmCMV+y36Y/hCb0FjHp1r2PtH02jNnBMhipyCJ3x8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713221893; c=relaxed/simple;
	bh=8xg3lHEX96OsyycWj5VvvgcPRZjhyPji75DsUK3pshc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKYMp1boULu5yrmrkqb5DG9OkzqIs4spuLqtvsVITLdrXEoPNabfjbagileURQG0fx2cup3U9lMbMIN3QHHi5iMuQfMnL55XLCMg7VBIhBw67qJHypxtawfCg/doH7cgRMiS746ms0XW1HgNPVVqekYBnGToVVyNMcX8PndQX9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCZYd0An; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713221892; x=1744757892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8xg3lHEX96OsyycWj5VvvgcPRZjhyPji75DsUK3pshc=;
  b=mCZYd0AnR+XNVAC9px23rgNjNSR1dSnmJWX8xujNzgJOsn3jh2B0kFs0
   ljs4a1hI5rGeDkhl/m9Gk/kr5zMeTLSkMYUr3RjJ9H6y3pd80VDRKkvud
   Lkckof+juKDoHvT9q1uqj372kM1rZbCyB25QvrZvhHebAGvx1QTzfk6nc
   PaUSu/T/JrKWGof7EPHDmvv/YdpOxSsFfK15UNX2+IFGFDS2CuGl1HmZE
   WiYS6IAnd6/Xfs+BEwiOHVXyZugJXr/Tbqr2ThdQpa9cQsZsTdNR5qcQr
   a4ITjzA6PQa2ApzxUe9gEIVv2L082OorFRL8znSqDDJqup5pr6IbRZGIA
   g==;
X-CSE-ConnectionGUID: gWpQbf4nTze9JYXBzddsYw==
X-CSE-MsgGUID: /Q8X/sZGSWqJPZ8BWbwC1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8492593"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="8492593"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:58:12 -0700
X-CSE-ConnectionGUID: +ISCB+qZQs6Sn3NIeHcdNg==
X-CSE-MsgGUID: RD7tPUfdT2G8JbQWCyRmxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22141432"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:58:12 -0700
Date: Mon, 15 Apr 2024 15:58:11 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 098/130] KVM: TDX: Add a place holder to handle TDX
 VM exit
Message-ID: <20240415225811.GU3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <88920c598dcb55c15219642f27d0781af6d0c044.1708933498.git.isaku.yamahata@intel.com>
 <4ccb3a98-d732-421e-a013-8912b46d8107@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ccb3a98-d732-421e-a013-8912b46d8107@linux.intel.com>

On Tue, Apr 09, 2024 at 06:36:01PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +		return 1;
> > +
> > +	/*
> > +	 * TDH.VP.ENTRY
> 
> "TDH.VP.ENTRY" -> "TDH.VP.ENTER"
> 
> >   checks TD EPOCH which contend with TDH.MEM.TRACK and
> > +	 * vcpu TDH.VP.ENTER.
> Do you mean TDH.VP.ENTER on one vcpu can contend with TDH.MEM.TRACK and
> TDH.VP.ENTER on another vcpu?

Yes.  The caller of TDH.MEM.TRACK() must ensure that other vCPUS go through
inactive (not running vCPU) after TDH.MEM.TRACK().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

