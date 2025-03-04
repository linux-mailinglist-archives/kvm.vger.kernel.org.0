Return-Path: <kvm+bounces-39993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43145A4D6E4
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE9F83A83A2
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 08:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE12F1F5853;
	Tue,  4 Mar 2025 08:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKknB6l0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618461EEA54;
	Tue,  4 Mar 2025 08:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741077939; cv=none; b=pHcWdunxuFNagTFYsBp7fFw6OWVfjwdebfrryMWiK3I0WxqUKtiiIAJXqNNxhkB97P5Ig3ymkbdAXOJ44etiZTBQ5CpZJWkPDP4VY/Ednu+H8E8e3gvA8hiuvbTsOqDF982M5Zze2XMtWq/rAlFct3unzqi0bQiSZWVbz6YrZKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741077939; c=relaxed/simple;
	bh=/ZT66LxzZws3uPtWH3EfG34DGIlMuHvvJHT8oAY0/8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NekdGLwZQP40jLfngOtCqDfYkbIMmOsDPDZTFPPTOFgwiVeeZ46RFHIuJ0CoExxrWSKpJUoKkycPxQGB0pwjljwZ+BGqvIo/1qfvndQRLVHwSu3G5/h84IQd/r3kqYLbujDuNlmDg8+GcDGcn3T9l8QsSwXqC2Dh6byMYuu2Sno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EKknB6l0; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741077938; x=1772613938;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ZT66LxzZws3uPtWH3EfG34DGIlMuHvvJHT8oAY0/8Q=;
  b=EKknB6l0xWBaqnO3pQo6/GX/oSwRMshaUGptEhQvfM3S/GmE/zM2FJaD
   AViRGcAWkGqBg2jsDOnE8MYrZnqGmQyQZ2AZkBSypWnHmEfM8WMhJuCOW
   Z0iskTlOkt1NGW7kLbQhL7EhnEwCWIvVxBPY9uor1ga7NQ7zUALUMifXK
   45gN4zyAVjqaWqs/9W25Xa7x1dAsECVcXPOmIBOHLzq0XFLryVGmOxAU5
   XshZ3AFQXA/BKs42Ad3kPDJHRCUL8Bh+hSZ33jnhGHQgAG7Nvxoq62hhl
   4X06jMyD8FSs2mqhLVPs2MPWnKG9yY0gp45HPdl23QbfpUvqhSBouVNH6
   g==;
X-CSE-ConnectionGUID: E4/cYfPHT9i3LvPnITskkg==
X-CSE-MsgGUID: tFtYd8jRQmaxfMGZ+GPCqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41162157"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="41162157"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 00:45:37 -0800
X-CSE-ConnectionGUID: PxBCRQzWQ6e41xrrFlcfdQ==
X-CSE-MsgGUID: DHG1xNFbTdu4nF5+xP9QmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118042217"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa009.jf.intel.com with ESMTP; 04 Mar 2025 00:45:34 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 957D118F; Tue, 04 Mar 2025 10:45:32 +0200 (EET)
Date: Tue, 4 Mar 2025 10:45:32 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, 
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, 
	fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com
Subject: Re: [PATCH v5 1/9] mm: Consolidate freeing of typed folios on final
 folio_put()
Message-ID: <re7ecgfu4x4arh47tjojse33qvc2dt2qrjznemphdwphe2rmzh@2vbm6zto3plc>
References: <20250303171013.3548775-1-tabba@google.com>
 <20250303171013.3548775-2-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303171013.3548775-2-tabba@google.com>

On Mon, Mar 03, 2025 at 05:10:05PM +0000, Fuad Tabba wrote:
> +static inline int page_get_type(const struct page *page)
> +{
> +	return page->page_type >> 24;

This magic number in page_type code asks for a #define.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

