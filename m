Return-Path: <kvm+bounces-29952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B9F9B4C9A
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15BB1B22F8E
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C53E192D91;
	Tue, 29 Oct 2024 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3Fqdbh1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78727192B71;
	Tue, 29 Oct 2024 14:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730213429; cv=none; b=MCqQamhOV8hYLgII/GowNUjpBBzR0adx8qFSBskQymWvs9Ze3Z48EOqqq/aipd0BYIdSrePcCMYZNU87J5uDd0ul3fJFRhCOq86M3oOMsEmWSXQqHj77QJfsWdO1DKJR5L106lIJ9ep14KgPuBDVN1vxZatKEA4owNTzpjJJvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730213429; c=relaxed/simple;
	bh=5Hrolq8N5sZTeWQoD2aC0Cg4KDDqlkAqRNZWSnMnsJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qawkUMIuTd64sDTsH2DXeMMwlDpyGH1c1TB+/P7R38JlIaVi0ugUdeI8vcrTTVPbKq6J6h0sumrd1VXqmSfhK6jL83QbLRWpjAS8fi8F1+tqUt9hwnFWTu22W7qVmSQPPE6U3/kVjH1zwWVubhnAz4wH/jf+CMVkD1ZnbKQCCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3Fqdbh1; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730213428; x=1761749428;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5Hrolq8N5sZTeWQoD2aC0Cg4KDDqlkAqRNZWSnMnsJ4=;
  b=c3Fqdbh1Cr9h8sGeznXuGA4ATFKgRxmY/inWeBzDc8hGU7oGqbNnYhIu
   sMz4seD69VGUxVQIntZ7udjOnj/3cCo5de+PISHP38BVPIVGeiN54v0jn
   5dPMcUrNsMf9FkPpZxVWqXiEVdkUzSQh/kjsto5zRNlTe1x4ODwLD+Qpt
   OWOAgKy7jrwwYVSgz/PYeT7fHYhktMJfavhEKnFWjdWwieiXfyQB3VN0P
   Y/XHe+v5pJZtYBMWRiHGUfv2nEY24F0ZziV3imJcBpq4RvHlVkvqVXj6/
   wxRNhlywyRzFhqvfYzv3os3c4gIwvU0G0GFMJtXu35zAEHnwtDBs6EwXe
   A==;
X-CSE-ConnectionGUID: 5qoO8TgCS3CMvRHG+gF3cQ==
X-CSE-MsgGUID: o8tex0H+Rp6DBZNg6K1Thg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40955694"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40955694"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 07:50:27 -0700
X-CSE-ConnectionGUID: PJshU8bwTTa97s1W6SWriw==
X-CSE-MsgGUID: zags2y1cSBONHzwPKCQ1qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="86537518"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.172]) ([10.124.227.172])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 07:50:22 -0700
Message-ID: <ef4f1d7a-cd5c-44db-9da0-1309b6aeaf6c@intel.com>
Date: Tue, 29 Oct 2024 22:50:18 +0800
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/2024 10:27 PM, Borislav Petkov wrote:
> On Tue, Oct 29, 2024 at 05:19:29PM +0800, Xiaoyao Li wrote:
>> IMHO, it's a bad starter.
> 
> What does a "bad starter" mean exactly?

I meant the starter to add SNP guest specific feature initialization 
code in somewhat in proper place.

