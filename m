Return-Path: <kvm+bounces-30446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E9929BACFB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FB711C20E40
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88C5192588;
	Mon,  4 Nov 2024 07:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PqITj/bX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1B918BC1C
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 07:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730704190; cv=none; b=o3pZXr/xWLr2f1T3HwtwP+pxHJMe6Vw6tv6ALJ3pjxv0ASY/FxYjdCnfXNM66xrGcqkpqeMYHJ9Y/h7X5E8oQhNAJLqIaIV4EDC6qMfsNn8vY7xpUsxgmf7EpfbyyX1S9MmsvMIoTBX+pvsN940YwPP3k8jdD5KMgzGVul25G+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730704190; c=relaxed/simple;
	bh=7cxi2Id8YWrPfwRXnu9GLfPlyvIGsyEtkFXYgr014kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+7bNt3duLim8FSefnkOa190S4n/XKc7xYaM8LG827DnY2fn3b3pI4g8L2tEgeRlF1L9oap/RoR/IzSdwITKHSPW44FbM5FSW3DUZA+P8DIyOhTIPqZV6RpYVmmj9eTnBox60aa7CiN4BZHF95qfSTBxlTswGgUBQ2staxtbyiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PqITj/bX; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730704189; x=1762240189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7cxi2Id8YWrPfwRXnu9GLfPlyvIGsyEtkFXYgr014kk=;
  b=PqITj/bX4lMRLL6Ks2z/VKC9g6+4c7dxzEPzlWKuaG6gYl8P9HfVHMSi
   rVXgRjBVrLwW2/VrUypJQpOynLPuv/Qy6lfLGADlmLsQ4gQw4hSkPDHau
   /eDxEFcS8AmTfQKkuWWQqVYeICDE6Qq1HehajPtqyR0WqrSQQexzMuzCB
   Eqk6wnnQHGGjLJBJhsjgOSa29Cu/XECq8qdzTxC6FpjhEy+2HwOS9RVVk
   fDuoxRePIP7mtnwS+jb/7IZRxGMBQo/7hMzp7H5EpsfLG1zvuzufj9g1V
   tXxF9vhBnPNuMHMy7ATEtrfgySP1XpVmhFR54LGvg3Z+0U7FVdmHQpIW/
   A==;
X-CSE-ConnectionGUID: LeZ8F0+IQTusHZ35jcyQmw==
X-CSE-MsgGUID: iBCpsUewTv6YCllvJ9nRkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="55786346"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="55786346"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 23:09:49 -0800
X-CSE-ConnectionGUID: IXLSJlGhQQSbdybblCQuag==
X-CSE-MsgGUID: swbEfGpFSQS6x9e7vxaJNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="88381857"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 23:09:46 -0800
Date: Mon, 4 Nov 2024 15:04:41 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, jiaan.lu@intel.com,
	xuelian.guo@intel.com
Subject: Re: [PATCH 0/4] Advertise CPUID for new instructions in Clearwater
 Forest
Message-ID: <ZyhyCU16iZysIFSc@linux.bj.intel.com>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
 <20241104065147.GAZyhvAyYCD0GdSMD5@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104065147.GAZyhvAyYCD0GdSMD5@fat_crate.local>

On Mon, Nov 04, 2024 at 07:51:47AM +0100, Borislav Petkov wrote:
> On Mon, Nov 04, 2024 at 02:35:55PM +0800, Tao Su wrote:
> > Latest Intel platform Clearwater Forest has introduced new instructions
> > for SHA512, SM3, SM4 and AVX-VNNI-INT16.
> > 
> > This patch set is for advertising these CPUIDs to userspace so that guests
> > can query them directly. Since these new instructions can't be intercepted
> > and only use xmm, ymm registers, host doesn't require to do additional
> > enabling for guest.
> > 
> > These new instructions are already updated into SDM [1].
> > 
> > ---
> > [1] https://cdrdv2.intel.com/v1/dl/getContent/671200
> 
> I'm willing to bet some money that this URL will become invalid in a while.
> 

Thanks for such a quick review. Yes, the link may be invalid.

Would it be better if I attach rev, chapter and section?

> > Tao Su (4):
> >   x86: KVM: Advertise SHA512 CPUID to userspace
> >   x86: KVM: Advertise SM3 CPUID to userspace
> >   x86: KVM: Advertise SM4 CPUID to userspace
> >   KVM: x86: Advertise AVX-VNNI-INT16 CPUID to userspace
> 
> Why aren't those a single patch instead of 4 very similar ones?
> 

I mainly referred to the previous patch set [*] which is very similar to
this one. If you think a patch is better, I can send a v2 with only one
patch.

[*] https://lore.kernel.org/all/20221125125845.1182922-1-jiaxi.chen@linux.intel.com/

