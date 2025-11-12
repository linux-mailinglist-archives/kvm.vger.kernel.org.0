Return-Path: <kvm+bounces-62919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D218C53E27
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 087EB3450D5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B4B348866;
	Wed, 12 Nov 2025 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kor5iehC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A42D97AF;
	Wed, 12 Nov 2025 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971552; cv=none; b=j9uJi2J0ur5rZqdtgarR55zvgTde2/ZUBsssmghaAQOFbQHBNV4IDqJmi1lUk0dn0g/I9ZAtbwl2LbojmqdqhKlxsBII3ov7TNiS6ZeqKw9I/VogvvRc4uF3e3+C1uBuOb2wywajarL7TaoSxIw+Srl7Zg9uSuxTsopCyp+3aFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971552; c=relaxed/simple;
	bh=pvFB1yXBR3JiIIWoaQ0Ii4iHpiJNJJBG5p0BNDR+YRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKx/ON0kafZRBuCbpcSsVNE5GDwOJGAGQvUkT6loS+wgOLwM4QYroyPlqZ62fx7IiaYPdnwtJE4WTeMFSY5axDc/4wZwV0dowc+GRm25X0aFc2lFHXA7pwG8kzzPtM+lHQY+9Wb3YHV2+3B/s56U5kKKoWLPBxXJZSdzALkjaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kor5iehC; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762971551; x=1794507551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pvFB1yXBR3JiIIWoaQ0Ii4iHpiJNJJBG5p0BNDR+YRI=;
  b=kor5iehCnZjOiu7BL6tdc8arAPbub3cinPmC1/45HLZVqTmW+mYXoL5k
   a88SCIS9S50fheL828S+k13RYj5rTyUqiOGBMUqBjwmOZFhAPvDadXaep
   AIjZuG/7Np7tjUtqLi3N8kfVi0CQpPNuySh+uNMlVXC5NDxEBg0fVYbIt
   4SCA3437uuf/vnL4aVLE/JTZU2v2+kTTUU7fGG4T1rqgi5FZ6egUtl9/k
   K0boYpD1lvDY0NDM5NHGD2XZdaZEKrea45ZHQWsCHUI8he8xjm4iRko8y
   +j2xbObvtzf3W2u6OMXPnOI4iZlUL5rKwEGROMeVmmKmjkUN8OkR9oyKT
   w==;
X-CSE-ConnectionGUID: UBE0vzcvQViwcwh1GOIcFw==
X-CSE-MsgGUID: 1jQxY5IDSLelLJ2Mvw1TiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64249885"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="64249885"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:19:10 -0800
X-CSE-ConnectionGUID: oQHVh8B8RfO4NEA1G42ZuQ==
X-CSE-MsgGUID: F6jmC2UPTHSEQqTZ8HV65g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188934873"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:19:10 -0800
Date: Wed, 12 Nov 2025 10:19:05 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251112181905.nvdurg5zsogixp4z@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <20251103181840.kx3egw5fwgzpksu4@desk>
 <20251107190534.GTaQ5C_l_UsZmQR1ph@fat_crate.local>
 <aROyvB0kZSQYmCh0@google.com>
 <20251112102336.GAaRRgKJ6lHCKQgxdd@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112102336.GAaRRgKJ6lHCKQgxdd@fat_crate.local>

On Wed, Nov 12, 2025 at 11:23:36AM +0100, Borislav Petkov wrote:
> On Tue, Nov 11, 2025 at 02:03:40PM -0800, Sean Christopherson wrote:
> > How about:
> > 
> > /* If necessary, emit VERW on exit-to-userspace to clear CPU buffers. */
> > #define CLEAR_CPU_BUFFERS \
> > 	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
> 
> By the "If necessary" you mean whether X86_FEATURE_CLEAR_CPU_BUF is set or
> not, I presume...
> 
> I was just wondering whether this macro is going to be used somewhere else
> *except* on the kernel->user vector.

I believe the intent is to use it only at kernel->user transition.

