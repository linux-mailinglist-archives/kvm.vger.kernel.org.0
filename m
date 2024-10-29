Return-Path: <kvm+bounces-29955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1BC9B4D42
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EE7128762F
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741C6192D9E;
	Tue, 29 Oct 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gw2RPu+v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B991A4AEE0;
	Tue, 29 Oct 2024 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214833; cv=none; b=Q2e7wxKjFCEGrqlUG79p6Ynt1QCy5+5SrNedHslCgKrWyPGuowVely12GbvT8ahvm3XmTleIsfUwMFBaqhywTynRzfBPWQ6Qia6lNfi7e/VQQeWVi9W5FG+VKXP/tXtVEWzZQ+3r+1DoQDPS5LiUJsCcQWy5JenmqPY9X8TXIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214833; c=relaxed/simple;
	bh=C46h2hkYsxiCvxObmL4cr/5RX40/qGEf8l/UEib9DZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNfABoED61iKhpuT7jjGJA5sqTqjQBnasIIEQWC6pkJTstafHAauZdPo+5KgpWN7LlOxsBxj3Gye2TwQ3cjnRjHST14Wb/Jw8tt10KE5A5iEGhH8cRiqj3mZ+zqFU6cAG1rMEsLTaqywbl2utBJQH3DB0CYR1ocA9A5FpwwAiVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gw2RPu+v; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730214832; x=1761750832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C46h2hkYsxiCvxObmL4cr/5RX40/qGEf8l/UEib9DZQ=;
  b=gw2RPu+vcOhHregiKaYMxnZ+7H7jZtikiVzonGjWOIioK9LsEsNN+0RX
   9Co6WNArhWLwg5d/5UPsGDh+zOX9NtW6xlB9Bp++bRNOWUEGcLjeItu05
   mnGFIMi6jgxV1J5fwHkxjUueVSJjqskrc4utNj+H+Ga1Xx0ubkrndpoeS
   zqDBAl+1+Bpd+3p86OBUY+JzjN9wGAgkuElKFjlfeXcSL7uyoD8+UvMO2
   1RXO0/dWtXnupD0vgyxToi14evjQ1qBNJ3b9v+mzeDW0O3+ljFqUkzfxQ
   k709aZ+T6kO7m+U2wcTIdAX7FXdsMYXZV9zgnNEpv4pkJf4W7A5/Wb4Z8
   A==;
X-CSE-ConnectionGUID: oqO8J1v+TkO4Z5fKQzCjGA==
X-CSE-MsgGUID: N+LRM7SaQyyiHYPIAm5GFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="17495719"
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="17495719"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 08:13:34 -0700
X-CSE-ConnectionGUID: 970WKp7vROmWnggcYDfwjg==
X-CSE-MsgGUID: mXK/hnCeQFmd8+JztOQFJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,241,1725346800"; 
   d="scan'208";a="82803072"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa008.jf.intel.com with ESMTP; 29 Oct 2024 08:13:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id DDA7B26B; Tue, 29 Oct 2024 17:13:25 +0200 (EET)
Date: Tue, 29 Oct 2024 17:13:25 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Gaosheng Cui <cuigaosheng1@huawei.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Kai Huang <kai.huang@intel.com>, Andi Kleen <ak@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] x86/mtrr: Rename mtrr_overwrite_state() to
 guest_force_mtrr_state()
Message-ID: <l7l6ufyjbrfr4ms6quil5myf5bzmvu33sq3phfvpbwldhzn6m2@rzfdrvbe2glf>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <20241016105048.757081-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016105048.757081-1-kirill.shutemov@linux.intel.com>

On Wed, Oct 16, 2024 at 01:50:48PM +0300, Kirill A. Shutemov wrote:
> Rename the helper to better reflect its function.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>

KVM patch is Linus' tree.

Dave, can you take this one?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

