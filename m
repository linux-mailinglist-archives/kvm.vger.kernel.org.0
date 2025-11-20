Return-Path: <kvm+bounces-63808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E3164C72F61
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 09:51:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B6F35350F7A
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 08:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C6F306D3D;
	Thu, 20 Nov 2025 08:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kAjOjJmS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495451547E7;
	Thu, 20 Nov 2025 08:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763628552; cv=none; b=oUOIT3C7MluVJ17OXmD5mCep2khepY0/26iJY/5y1933AOkx3Pd3AG1Cohb8o3ITvcoxbR9hVqp/YYO3iwACYIR2GlehfPmCr5CPyVJlQ4uEPW88JirUxkFhjaR3pMjaIzpzhfsiUaZ+sYIkU9jVySXNgOkvZV7EF7l+iNIp5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763628552; c=relaxed/simple;
	bh=r2CIPLhiA6JPzxOj6cAUwiLlNE++3SGHoWEo2uz2MiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sazu2MhPDKxpBZKpg9nsnyztKu0uYxkzj9TWZn6/AdxgeA1U3VAIdWZV9toIJOAcQoFpT/PYl+VBt0t1kz9TTFZi3ScYXJ0cMCx2RS5gQQ4BV04Kd67KXsqfH+nfjIhz+ScWQVjg2cCiMF+XDm9wQJReJ5wrrHpvQ+NYZIo+J10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kAjOjJmS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763628550; x=1795164550;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r2CIPLhiA6JPzxOj6cAUwiLlNE++3SGHoWEo2uz2MiY=;
  b=kAjOjJmSH+hZ6lTyMyTvHUxpk3x9XIvd/kdvGLyvJFilcpshghUTQG9Z
   bHJDVyro0S1j5BBalE6wd30hKDJ0Srwd6Fu4etv1DFKhsSGJvKm3W2HE6
   XFNAmF+yW6AmfYx0Brj2NVmfHdHsQP1aADYX0HB1nIe9DwZf2VB9DZ9fu
   1T4yeP3goqQLos+lBNqRKcrfzrqooDN5wLyJYF7WivF1/hT23QkYiyKRu
   lmK4c7R/tICMSXQeRJYNgoPis/0+4MlqX6SpLmGgVpRmR/swgh1GFmRj4
   dIflwxjqrfFXq0Ui0CTiKjr534Gg/nQtdidLfvfo+87qdC9Zx9l95acwO
   w==;
X-CSE-ConnectionGUID: OyWvu6AqSSCV5aCij7l3oA==
X-CSE-MsgGUID: 1FSCnK7RQEGh6SIe7OwAZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65727973"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65727973"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 00:49:09 -0800
X-CSE-ConnectionGUID: PRw+E/LkT1aeEkJ9tfNNnw==
X-CSE-MsgGUID: 98TSXgQXTsmr5dEkNq5igw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196270644"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa004.fm.intel.com with ESMTP; 20 Nov 2025 00:49:06 -0800
Date: Thu, 20 Nov 2025 16:34:15 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: Dave Hansen <dave.hansen@intel.com>, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org, chao.gao@intel.com, dave.jiang@intel.com,
	baolu.lu@linux.intel.com, yilun.xu@intel.com,
	zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	kas@kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <aR7ShzIfs6fQaCX2@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-7-yilun.xu@linux.intel.com>
 <70056924-1702-4020-b805-014efb87afdd@intel.com>
 <691dee3f569dc_1aaf41001e@dwillia2-mobl4.notmuch>
 <e3830b06-dac8-4f22-bd07-98073886678a@intel.com>
 <691e16318f5ea_1eb85100ce@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <691e16318f5ea_1eb85100ce@dwillia2-mobl4.notmuch>

> For clarity for Yilun, be circumspect on scope-based-cleanup usage for
> arch/x86/virt/,

Yes. I think I should drop __free() here. But allow me to keep the kAPIs
definitions like:

 void tdx_page_array_free(struct tdx_page_array *array);
 DEFINE_FREE(tdx_page_array_free, struct tdx_page_array *, if (_T) tdx_page_array_free(_T))

So I can use __free() elsewhere.

> but for TSM driver bits in drivers/virt/, do feel free
> to continue aggressive avoidance of goto.

Yes.

