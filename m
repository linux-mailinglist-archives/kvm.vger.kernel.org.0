Return-Path: <kvm+bounces-29956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 467739B4D50
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:14:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B28F28503C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D603F193438;
	Tue, 29 Oct 2024 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ImL+57Xp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA01192D87;
	Tue, 29 Oct 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214881; cv=none; b=crDJ8SKJCQ7C05wOPPIm2Rmov0cMtsJffHFHOD61RQziobU/OLz+AI3DygUj2mfAzmwLoG/JxHx8kAo3z7WQzyMuGhT4BrusouiKyqOt++MDtrVAQjy3/EvIriR9L/Y67hs9+InaMRcfFyvhW7lC6dmEc97v3InZ2l9eQvIVbvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214881; c=relaxed/simple;
	bh=VxfkBUVqN7pKQ3j0D5LM4Ff75dFoq9324/ciN2UvlR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sR1tVYQ0ig9hYRnLX7SP9iVnuxVUcGWc+5IfzIOR11Oz8V3/JWxi2dh8xJcedsoXwxPeZBHiJGszy/2c0ktp/6lN6++UdYD/iyR5YegKyL8OaA3jaJZ78fEf7+x7kkHvfDUyNIz9kQOR3jElpBTBaGs0D2PdVSxpcSqt2DPKAJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ImL+57Xp; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730214878; x=1761750878;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VxfkBUVqN7pKQ3j0D5LM4Ff75dFoq9324/ciN2UvlR0=;
  b=ImL+57XpiBXYq0UTIWmZhYD6FN6oHCNKcfYwwRMdxUEY0T9Z0wE3wQaQ
   birNEKOs1P8zRvJW1y4uDUkusVYgW83WHOUkDntulNFBzCtvqT+oM3xUP
   D5Sque4ZOI6LIA6DGOuxOimUCc+PmfyHsdZQHSvzHcF+yOAe7P5w4fByH
   SMFL+qdxgv12BTAiUm1yi0eTpKkpm0BuByufZqyNJuwhgZkl+c2SMZ1lT
   BO8+6gDj4JRjt4G4JcQgd+XiZvCzgy69xBeSlXxyLk11IK7iRrRSmOwY6
   MWTneenWUpksDRSeCvgG6jkfumlq7/pWJr+WbwB0miGK6sxvlrDxjrflV
   A==;
X-CSE-ConnectionGUID: JQskI5qiS+uSEgXku+EyJQ==
X-CSE-MsgGUID: AkR/m6dYQEKRmO0vSqJrrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30001108"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30001108"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 08:14:36 -0700
X-CSE-ConnectionGUID: +OwAoqocSxeGSVfZuetzQg==
X-CSE-MsgGUID: HhUJTg4KTUeTGuJ+MbgFpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="82060423"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 08:14:32 -0700
Message-ID: <59084476-e210-4392-b73b-1038a2956e31@intel.com>
Date: Tue, 29 Oct 2024 23:14:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
 <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>
 <20241029150327.GKZyD5P1_tetoNaU_y@fat_crate.local>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241029150327.GKZyD5P1_tetoNaU_y@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/2024 11:03 PM, Borislav Petkov wrote:
> On Tue, Oct 29, 2024 at 10:50:18PM +0800, Xiaoyao Li wrote:
>> I meant the starter to add SNP guest specific feature initialization code in
>> somewhat in proper place.
> 
> https://lore.kernel.org/r/20241029144948.GIZyD2DBjyg6FBLdo4@fat_crate.local
> 
> IOW, I don't think we really have a "proper" place yet. 

Then why can't we create one for it?

> There are vendor
> checks all over the memory encryption code for different reasons.

But they are at least related to memory encryption, I think.

However, how secure TSC related to memory encryption?


