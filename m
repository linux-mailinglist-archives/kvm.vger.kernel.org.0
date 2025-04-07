Return-Path: <kvm+bounces-42789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB385A7D160
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 03:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CBA11685EA
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 01:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146081805A;
	Mon,  7 Apr 2025 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MbuGEUiB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EED191;
	Mon,  7 Apr 2025 01:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987643; cv=none; b=Y3TUKzxffjVCppN8RXMPXbJCsM2QgxlsnIIo+VPSqVnWEHB8VySI5m80ZS5nHzVRRhFPJysHwEmbke+UmIBySdeM6rYk1ttw6qCZZeyzQ/IPyQvnU+idkJpk++SUvc64rxdWDwTawF5DkXwMxUB9x1F3/UJq9T/OZOV0xrdwyCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987643; c=relaxed/simple;
	bh=cr6IxjTU0dcg6yUzRHjmcq+R1dBR+HO/jS4n7WU70P4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNa5bbY6h6YRj/kZzDHWXJistIfEwMfGHJGnTnudbzrOAOFZbvc7Ikk5nc1DOT5hri9+EJ9VY/vRGWEuxMs8RLRSTuZbPaLOXDOShkwwDPJ7ow/8aFSaRFhSoibK5Juk+90X76G5PSYrweLiXXkddUXnuuo1Y1bZHjsBXFFrXgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MbuGEUiB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743987642; x=1775523642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cr6IxjTU0dcg6yUzRHjmcq+R1dBR+HO/jS4n7WU70P4=;
  b=MbuGEUiB0y6iw9JQYNt4nH+9jnZXlP8kCtbagEVBxKifm3ChsY5o7/7r
   75x03/LkAIIeBIRvgOwQgWqexLxnvtVMFBZDZ3hTQXGERxD+63wlik5po
   yCqy1Uvr6HInXnU6x4oip95dKhfpcCC3aRUwjIzmOpTT8kewDtoEU/Uob
   GU+lXaXanpDfWHmtsfidodZnhjkDTmcgaccT9dEhmJmaY5wqau9UxK+s2
   bJE1mE4xTir8djbZapmFd/LBzBgP1biRqgCGi24CSP8RK1MEXsZWsCBHI
   afoLcfqJImNc4r55FZ1KNDJVi3tShKlWTV4y7Xi2M9/gl8e2RGL9uKnl7
   A==;
X-CSE-ConnectionGUID: X5y4t9NJSKyIAHB7wcgCxw==
X-CSE-MsgGUID: KQZprNPBSGWWj8j6chu4XQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="49009267"
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="49009267"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 18:00:41 -0700
X-CSE-ConnectionGUID: vW8hNn6VQjii1q+eq/ctTQ==
X-CSE-MsgGUID: /ym4VWfJS/yIKIX45rghaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,193,1739865600"; 
   d="scan'208";a="128655367"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.247.168.206]) ([10.247.168.206])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2025 18:00:34 -0700
Message-ID: <84d44db2-6327-43db-93c9-61823f4d90aa@linux.intel.com>
Date: Mon, 7 Apr 2025 09:00:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Gao, Chao" <chao.gao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Hunter, Adrian" <adrian.hunter@intel.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
 <20250402001557.173586-2-binbin.wu@linux.intel.com>
 <2047f2964fa713f70823b9293bf1ffd65ac44fa8.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <2047f2964fa713f70823b9293bf1ffd65ac44fa8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/3/2025 6:19 AM, Huang, Kai wrote:
> On Wed, 2025-04-02 at 08:15 +0800, Binbin Wu wrote:
>> +::
>> +
>> +		/* KVM_EXIT_TDX_GET_QUOTE */
>> +		struct tdx_get_quote {
>> +			__u64 ret;
>> +			__u64 gpa;
>> +			__u64 size;
>> +		};
>> +
> The shared buffer pointed by the @gpa also has a format defined in the GHCI
> spec.  E.g., it has a 'status code' field.  Does userspace VMM need to setup
> this 'status code' as well?

Yes.
>
> I recall that we used to set the GET_QUOTE_IN_FLIGHT flag in Qemu but not sure
> whether it is still true?
It's still true.

>
> I am thinking if Qemu needs to set it, then we need to expose the structure of
> the shared buffer to userspace too.

For the structure of the shared buffer, since KVM doesn't care about it.
IMHO, it's not necessary to define the structure in KVM and userspace can
define the structure according to GHCI directly.

