Return-Path: <kvm+bounces-29977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D09249B52C7
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 20:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95F7B28385A
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 19:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278C6207219;
	Tue, 29 Oct 2024 19:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S5gVQ+ra"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3273BD53F;
	Tue, 29 Oct 2024 19:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730230384; cv=none; b=C+mTFiUmKq6VgvDRlTmz1PKhZgaLifjTzk7hhBp78sdnNu10SeTktYlPkVOTcoICeVdiXsN2u7MTQDTiWChz3Vk1UVf46fiK3DaY4HsYDcqdhCguUpUc4Hz67P6M8/wxzRBqMn0DMj/UyY51gRnPNsSd4/nXb8Rpbq4mY9GCncY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730230384; c=relaxed/simple;
	bh=rKuHVvH42ui6GSwdR20x9vXuuUKOs7LyPxbi1NASNnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUPdnYaOwvHTTRAV6OU3wECwb32e/tbYBdn5jHotMhGjbA8RP8r49krgmAM2REC7UmUL3d4Mr3qFkEKUyXvIDJOEQEnhiwjh/ChXgNlMWSz1Sb8ftMVwyf8wvJ1kTT3rIkClGnrrF4aS8zNvau3kvXD1t6Mz/r088+5u8mE0S8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S5gVQ+ra; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730230382; x=1761766382;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rKuHVvH42ui6GSwdR20x9vXuuUKOs7LyPxbi1NASNnI=;
  b=S5gVQ+rafRQIrmUoPgWZurMSmOnMG3Vw4l604B5jiAY62C07Nz/e2kb3
   s9RcYBQjZgsJYHxDeJO6bxR8QaSCl3jwtGFAWMupVQc1/wRAAFpb5PG4B
   I48sWXv3y3VM73S5BhkRhlAQXUWdy+abb/jDPRqWyMqK9rNnUaWJXSoXt
   1bU3zJw7m9kSKzRJqfwdfLA4VzVLn+v/AWh8yILVgaZsPv6Ke1OjUx4Ph
   vJbwW8MBWcneDARwvJWkfxbciLDtNG4YXtuJrZ1JQzRmL95k1x8kHeeS8
   l9xCFjVaeV2SIoH+XXc0e/8o7lzxxUAHGlq2VfVxigYcdYxIb7zlHejqB
   Q==;
X-CSE-ConnectionGUID: VjLDeNyHSFajvAMYQ/JyUw==
X-CSE-MsgGUID: yX10SUxIRlCB0tf9UhYWJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="47378529"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="47378529"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 12:33:01 -0700
X-CSE-ConnectionGUID: +eIVlvmHQ3K/+bFW1SyJVw==
X-CSE-MsgGUID: OaEP30QHQQi0PlK6I9o+OA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="82399102"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 29 Oct 2024 12:32:55 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 02E3426B; Tue, 29 Oct 2024 21:32:53 +0200 (EET)
Date: Tue, 29 Oct 2024 21:32:53 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Kai Huang <kai.huang@intel.com>, Andi Kleen <ak@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Message-ID: <elods3c5ocia6645vhce7khtzdvzwf7m3wicxmwzvw27hyyvxv@mdixnwonfzgh>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <20241016105048.757081-1-kirill.shutemov@linux.intel.com>
 <l7l6ufyjbrfr4ms6quil5myf5bzmvu33sq3phfvpbwldhzn6m2@rzfdrvbe2glf>
 <4d39b188-0642-495c-8638-67ae08c070b7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d39b188-0642-495c-8638-67ae08c070b7@intel.com>

On Tue, Oct 29, 2024 at 10:37:07AM -0700, Dave Hansen wrote:
> On 10/29/24 08:13, Kirill A. Shutemov wrote:
> > On Wed, Oct 16, 2024 at 01:50:48PM +0300, Kirill A. Shutemov wrote:
> >> Rename the helper to better reflect its function.
> >>
> >> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > 
> > KVM patch is Linus' tree.
> > 
> > Dave, can you take this one?
> 
> Not easily without a merge of Paolo's KVM bits.  The confusion that
> might cause isn't quite worth it for a rename.  I can either stash this
> somewhere or I'm also fine if Paolo takes it on top of your other patch:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>

I don't follow what is the problem.

As I said KVM patch is already in Linus' tree -- v6.12-rc5 -- and tip tree
already uses the tag as basis for x86/urgent.

Hm?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

