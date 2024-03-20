Return-Path: <kvm+bounces-12327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C0E8818D6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA84F1C21258
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:55:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D1085C5D;
	Wed, 20 Mar 2024 20:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mRRMad03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994CC85936
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 20:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710968092; cv=none; b=TGL1/qAPkqEVcxaRfbAdHqB6/VU8hRhJ8wwTKxhue+TsLnPPK+WUCsz67sRD6HNmqCUWCSL/iFjO7z/9yR3PUDXYuF8Qe7sbznd5FjQu1dNQ4h5u69C3nECZ2f+AaAndmuVz8nuzzmsQySt9BAdfcE9wSFvWGThBcnLEhUPp/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710968092; c=relaxed/simple;
	bh=z+uhnrXGcV33J9cLFUCMuRjcEsixfuEkrkh6l1QzBWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L56+sNWH/+TIW2sIH6F0IN+EGokEvPdBVPzTrJaVBpr3bRph6tS6gVkMJZd/hbeq+9sJiJlwnNZcAdV7LGhJaqUnPiTKWHpa03fqDHQxn2RG37BasZqD2Vly1bx7h0TYsFKN4KNIQkJGquEK3gvwzzBOVcqgM+j3ayWAQWPkb+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mRRMad03; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710968090; x=1742504090;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z+uhnrXGcV33J9cLFUCMuRjcEsixfuEkrkh6l1QzBWA=;
  b=mRRMad03JUlBfMXoUtVJ2g40E4PvdZT+rgN6rFtB60qWa+Iy/aQET3Mg
   iW+rWV7rtqj3xPbMeg9tc8BAS2BAV20KWKWmsXI1k4rrg8GadkNTIA0g5
   aox2Z3M1EIpyNWKTTDciXnMYICoQPBveY4sV/JRpAn1JRVHdbtYuGM/Zy
   aMhkgXWsVlQu44ttX/eeUg2oMnDZJ1f08EnD/p9rmAL9b0VejwOIUXRVG
   F/ebEYKnj5oQoKS0dDfMhXrc8wAW1t78x3xKFGD/7/c0Bcecyd/XBPNY8
   nX95MbA66tZ0MOMjwtGCqnIBSAlq05pUZCjWEtcO/d0xY1ZvR5Ub0dSl2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6052206"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6052206"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:54:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14929346"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:54:48 -0700
Message-ID: <5c9ee0e8-efbb-48bb-ad8b-804cf80e3bf8@intel.com>
Date: Thu, 21 Mar 2024 04:54:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 00/49] Add AMD Secure Nested Paging (SEV-SNP)
 support
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <eea690c2-7d2f-4a35-b5c3-078c12ef228b@redhat.com>
 <CABgObfYzNksaaHgZ5kozXohwWWyDgfw3ue2juEbZmVteb5Trqw@mail.gmail.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfYzNksaaHgZ5kozXohwWWyDgfw3ue2juEbZmVteb5Trqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/2024 1:08 AM, Paolo Bonzini wrote:
> On Wed, Mar 20, 2024 at 10:59 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> I will now focus on reviewing patches 6-20.  This way we can prepare a
>> common tree for SEV_INIT2/SNP/TDX, for both vendors to build upon.
> 
> Ok, the attachment is the delta that I have. The only major change is
> requiring discard (thus effectively blocking VFIO support for
> SEV-SNP/TDX, at least for now).
> 
> I will push it shortly to the same sevinit2 branch, and will post the
> patches sometime soon.
> 
> Xiaoyao, you can use that branch too (it's on
> https://gitlab.com/bonzini/qemu) as the basis for your TDX work.

Sure, it's really a good news for us.

BTW, there are some minor comments on guest_memfd patches of my v5 
post[*]. Could you please resolve them it your branch?

[*] 
https://lore.kernel.org/qemu-devel/20240229063726.610065-1-xiaoyao.li@intel.com/

> Paolo


