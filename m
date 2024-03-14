Return-Path: <kvm+bounces-11806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24EC887C180
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 813672835F1
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AA174417;
	Thu, 14 Mar 2024 16:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n6yryM4S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4FD6F524;
	Thu, 14 Mar 2024 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710434884; cv=none; b=B6LYnRj8hFdWGpN5oftoqEqXRLZLf4zvOm1OMAWdQFN9Rn8285h5qzvXyFAIOF/NcAxURCAWMGdxASq1B9Et3JCOd5jnqL/fwh6DCZqW2l4/HrOhANl96F+47Q3XBGYzYkuoDP6tzwd9UvA+O002agWmTKIixgI8SA0DohFlF7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710434884; c=relaxed/simple;
	bh=FsEKtAhsZGo5h1PjChAm7sCz44W0i1u7H/cs7wNigB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AqOnaU3bFk0pDtISLdHCbdLOnSzUb9zWZGT/YOrqiUXX7CfYN32Lpm2YVB11EBEPyCoQl2mbQnCUq7IouN04NRGBQV1vg9dbZq0+LyCcTvHfqMYYSBqOA+sC7V8f/UQLlhTyiItOgxyqxGmjvqQHaT6RAV+15D6RYURhgMncrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n6yryM4S; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710434883; x=1741970883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FsEKtAhsZGo5h1PjChAm7sCz44W0i1u7H/cs7wNigB4=;
  b=n6yryM4SdcQVhFextOuoFhAt4FxN4yn+v1ObKiSHJaqluwNVzTJcnT5h
   4MvKjZ+rFHue4p3jWNubHaiqGSf/5tO72yoawkEPqEkGByZeuypZiK895
   jjOvN+yhJqWJ04WYHh4X5im/HzwshAFeRHkSGimOLCGdRYZmCTuxj7C4w
   49KQGT4wg5ksm9fdm+vhuo3aWZGg2s0S/jqNtaqfPmxkNmPUiOrqTT7qa
   WMgzmncv4XI3TyojKIVLaI7c6ApUMZytpEBY6TG/imdE9FGje72WLesoy
   LuS0m+ugFTaMkMpTbCDJMUefkfS4svxhRrs0xDPvbul5iWdxPCsTzA7TD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5137319"
X-IronPort-AV: E=Sophos;i="6.07,125,1708416000"; 
   d="scan'208";a="5137319"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:48:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="43269551"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 09:48:02 -0700
Date: Thu, 14 Mar 2024 09:48:01 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240314164801.GQ935089@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <f8d50f45-eb7e-46bf-b3a8-35f02efd4e4c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f8d50f45-eb7e-46bf-b3a8-35f02efd4e4c@linux.intel.com>

On Thu, Mar 14, 2024 at 03:30:43PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
> > +#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
> It's better to align the style of the naming.
> 
> Either use TDX_TD_ATTR_* or TDX_TD_ATTRIBUTE_*?

Good point. I'll adopt TDX_TD_ATTR_* because TDX_TD_ATTR_SEPT_VE_DISABLE is
already long.

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

