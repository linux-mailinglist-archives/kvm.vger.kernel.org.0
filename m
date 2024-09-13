Return-Path: <kvm+bounces-26779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A72977798
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 05:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76FC81F2498E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 03:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23BB1C3F1D;
	Fri, 13 Sep 2024 03:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DpB5Svfp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAF21AED49;
	Fri, 13 Sep 2024 03:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726199702; cv=none; b=XgbN6Ei5ptuGtN6/tJWCPwe2rdAN8nCw18wRgpU9wJzKqxYem6nXrCFU9+YJnAYiJunW+I8DnbZP6YrlLuUFxbQ5t/MBUyj/54cq0k43m64rE2Q/0YtA0QZ07+zGmHgLxpw43tl1Iyad6wTvQzinAgQmx4HZhSBq91Wpk7toFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726199702; c=relaxed/simple;
	bh=x+iVIu+R8bVjJ0KOFX55GeWTxdccM9M3Q2qzG1lmGpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOG2gadAK0ZZv7+upeH+zh0yblzHFMNqm3i8Ut7yRpWzH3aEsLJYsyjfjLd/bcp11SsGNj4Idgu73Vggpr6RzHrhWCVRhgVh/hDJ3zxKLY+p1XJFDgdv/BDGIA1S6iRQo/OmpKTx10FjYjvoXee9oUS9n5hMITeZ/H7GfzLEUx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DpB5Svfp; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726199701; x=1757735701;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x+iVIu+R8bVjJ0KOFX55GeWTxdccM9M3Q2qzG1lmGpM=;
  b=DpB5SvfpeVwLoohWIc7HyC9cSHzEnq4P78FrimfLnimy5yq8Hvau8UEN
   xpNUfk3A73JRsiJljTOFuODogXyRBJ954cCY/lPSh3+7R6ldTeiZPNb+q
   u37AkRVuPlAZl3Q3VX7PT9Mdv5wAcq9qYfBbLNmtCZKZBsG0tp2jk2ChR
   L6AtgCt7T56rHW8b7y0VOz4O2cNSsBV7dc+9yuTAOnig4UjAOV5bdE49M
   0ZSvn9CqK1aeyXobPeY2BQ0xQT43NbIcc/mtlN+US+Pz0gYBj++9XPT9m
   vp+GpZazLeSsQUadE4Y3OcVgXpym3c9VGpjsf+4XH3J5ge82pE+n/wVhQ
   w==;
X-CSE-ConnectionGUID: kSLe/KxATPGRE9FOl98g8Q==
X-CSE-MsgGUID: Ayihkq+YS32EVP+ZoBoPUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="36466598"
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="36466598"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 20:55:00 -0700
X-CSE-ConnectionGUID: CkpM+50KTxuronlFsPj+Iw==
X-CSE-MsgGUID: CS2zJcFbTvaAXCLEXysEZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,224,1719903600"; 
   d="scan'208";a="68698681"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.38]) ([10.124.224.38])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 20:54:59 -0700
Message-ID: <36289f8c-85e1-4bb9-aff3-648ead059cd0@intel.com>
Date: Fri, 13 Sep 2024 11:54:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com>
 <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <df05e4fe-a50b-49a8-9ea0-2077cb061c44@intel.com>
 <CABgObfZ5ssWK=Beu7t+7RqyZGMiY2zbmAKPy_Sk0URDZ9zbhJA@mail.gmail.com>
 <ZuMZ2u937xQzeA-v@google.com>
 <CABgObfZV3-xRSALfS6syL3pzdMoep82OjWT4m7=4fLRaiWp=XQ@mail.gmail.com>
 <ZuM12EFbOXmpHHVQ@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZuM12EFbOXmpHHVQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/2024 2:41 AM, Sean Christopherson wrote:
>>> CET might be a bad example because it looks like it's controlled by TDCS.XFAM, but
>>> presumably there are other CPUID-based features that would actively enable some
>>> feature for a TDX VM.
>> XFAM is controlled by userspace though, not KVM, so we've got no
>> control on that either.
> I assume it's plain text though?  I.e. whatever ioctl() sets TDCS.XFAM can be
> rejected by KVM if it attempts to enable unsupported features?

yes. XFAM is validated by KVM actually in this series.

KVM reports supported_xfam via KVM_TDX_CAPABILITIES and userspace sets 
XFAM via ioctl(KVM_TDX_VM_INIT). If userspace sets any bits beyond the 
supported_xfam, KVM returns -EINVAL.

The same for attributes.

> I don't expect that we'll want KVM to gatekeep many, if any features, but I do
> think we should require explicit enabling in KVM whenever possible, even if the
> enabling is boring and largely ceremonial.
+1

