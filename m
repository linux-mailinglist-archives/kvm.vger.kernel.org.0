Return-Path: <kvm+bounces-12006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0555287EE87
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 18:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 356B71C20E88
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D0055769;
	Mon, 18 Mar 2024 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUpnbys9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F22954BDD;
	Mon, 18 Mar 2024 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710781942; cv=none; b=kDaR7Q/cPRNkodKSDythZ8vJaaYFeSz1xAR8Not/Lec0TGreqCwEHAX62ceml+dMsgj3j5WjLYanv9iPMxIAQKjJFXZGk65vvEbwUg19NlyTuPXehOLNqgkadPfkLD+sH82CN6Nd0WjIQbznJztmPY4kdECZ3DlRb9CmiOjzdKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710781942; c=relaxed/simple;
	bh=v+TlVPrVdlVGwoJdEhxp1LrYuRsBEUrWr7CIMuNk5RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbyzgvmLZi4u3YLddMcq9XFx0E6p5ajVVlmCnW124I/EkPK9Vn3rUmSvYQKnfiZMKXsQiMgCVDlDAwbmZywgsJb26x8jieoexWE6RUpJn/OTzF0pl+Gc3rQvZ7ULF0NSw/Jn/vx3MKpr9VBe9/JLbYue2JsBNIqCF1QuQ5pAr2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUpnbys9; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710781941; x=1742317941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=v+TlVPrVdlVGwoJdEhxp1LrYuRsBEUrWr7CIMuNk5RY=;
  b=hUpnbys9iy89tuNREgUTV2C/VEHRsPafeB5p/dvfICx6Y2Z18XN+nQ2t
   SzZfXYhzDI1GVmxh2UNXwsiqcusYifRiAFGCgRqxN+rcxr60cwSBCcJQ3
   CsWJZwxQ7twlcwnv698NCwWJ4HpS6PgHwv9IRS2jQmuvyHh9ymjvX6Zyu
   5QZ6BFL9uZmtQkUL99qhN1N2hdgdd+oHUbFlbbY9TPcNLVDvHmbjd188J
   1imW/klVmzFMnt5vRJWAvp9x1GZgMGcgTPnWtxJyYUUx0YfIwDOseFIxJ
   g1sxjwLkzoKxTODtxhfTyt082uW5BHz2xQZgd7nix7o3Tb5F5KDrcq44u
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="16335335"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="16335335"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:12:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="13568609"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:12:18 -0700
Date: Mon, 18 Mar 2024 10:12:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Message-ID: <20240318171218.GA1645738@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
 <20240315013511.GF1258280@ls.amr.corp.intel.com>
 <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc6278a55deeccf8c67fba818647829a1dddcf0a.camel@intel.com>

On Fri, Mar 15, 2024 at 02:01:43PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-03-14 at 18:35 -0700, Isaku Yamahata wrote:
> > > On the subject of warnings and KVM_BUG_ON(), my feeling so far is
> > > that
> > > this series is quite aggressive about these. Is it due the
> > > complexity
> > > of the series? I think maybe we can remove some of the simple ones,
> > > but
> > > not sure if there was already some discussion on what level is
> > > appropriate.
> > 
> > KVM_BUG_ON() was helpful at the early stage.  Because we don't hit
> > them
> > recently, it's okay to remove them.  Will remove them.
> 
> Hmm. We probably need to do it case by case.

I categorize as follows. Unless otherwise, I'll update this series.

- dirty log check
  As we will drop this ptach, we'll have no call site.

- KVM_BUG_ON() in main.c
  We should drop them because their logic isn't complex.
  
- KVM_BUG_ON() in tdx.c
  - The error check of the return value from SEAMCALL
    We should keep it as it's unexpected error from TDX module. When we hit
    this, we should mark the guest bugged and prevent further operation.  It's
    hard to deduce the reason.  TDX mdoule might be broken.

  - Other check
    We should drop them.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

