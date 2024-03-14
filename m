Return-Path: <kvm+bounces-11810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A95287C211
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3ACAAB218C1
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818AF74BF6;
	Thu, 14 Mar 2024 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0nMFClX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF474411;
	Thu, 14 Mar 2024 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710436910; cv=none; b=N+4wNp4PLwufFkNAWdjl0Cxesn6yHiXSDmK3b5iT4D9PKn5fpHoVMg1Mjxg++ZS3J9SAbGb+8mPSVtRdzi3n6YqFdKu87zKk7kvM/fQaDgdchSrip3lCIsSeL8XNQQMgoKL3XZN+dOdK52ofIKv5/NYzcOhzf40Zyf+GO3hj8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710436910; c=relaxed/simple;
	bh=KdwO8TeQ8OJGIhOmmmsHC3CWBJKrdEUiu7MAlHhdeM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgB+DifScppIgYBrsZv9Madf3W3tPGaqjpL8v2Gw5gZqEeK8eEQR928yj5JuEEGC4kjD/Ey7CRDzZ/+unfqJxSIliMRd9rV3GViTIwsJptN6QLDj+EHxDzm9pbvHihOqoo4U8ZAoqF4ZzCBtO9waBW9DYeQhgfWO0KbZ6sLjrzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0nMFClX; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710436909; x=1741972909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KdwO8TeQ8OJGIhOmmmsHC3CWBJKrdEUiu7MAlHhdeM0=;
  b=Y0nMFClXcOkPwB/TNz1hCLHHx4AQhg+j2TiHdb/ie2q9ZkyAsMv5ag0X
   71iDljn8b5T74TOQtxQnDb8Ss7F4SV5EENP1JdYDGa52ihfP/200X6HAT
   Hy9vX8ZfOf35zql9S29xuGDAKLjgsS21/Z1/EFp+iRsAjwbvoTBqT2ipN
   0ASs7t8xgVcKtdXG/c0l3odR5UuMParbtdfjNzJJgZPiSCfguuI4K67N3
   I0bTlL0uHxlJuCrvqF5MFiNJ6hfmlDBztrl7qNyRmKMbLVbxvS4QQhwNv
   fa9ZXQ9xGt54o4XgHrymGQ8Q2hGJtJnJJOU5trktKB6NFtv5XbxChxer6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5459266"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="5459266"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 10:21:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="35489615"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 10:21:42 -0700
Date: Thu, 14 Mar 2024 10:21:42 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yuan Yao <yuan.yao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 028/130] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <20240314172142.GB1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ae0b961d80ab90e43c6eff4a675e00ff80ab3b9f.1708933498.git.isaku.yamahata@intel.com>
 <20240226192757.GS177224@ls.amr.corp.intel.com>
 <ce00c848-16eb-4276-8f8c-03a97fcb4d86@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ce00c848-16eb-4276-8f8c-03a97fcb4d86@linux.intel.com>

On Thu, Mar 14, 2024 at 03:45:49PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/27/2024 3:27 AM, Isaku Yamahata wrote:
> > On Mon, Feb 26, 2024 at 12:25:30AM -0800,
> > isaku.yamahata@intel.com wrote:
> > 
> > > diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
> > > index fdfd41511b02..28c4a62b7dba 100644
> > > --- a/arch/x86/include/asm/shared/tdx.h
> > > +++ b/arch/x86/include/asm/shared/tdx.h
> > > @@ -26,7 +26,13 @@
> > >   #define TDVMCALL_GET_QUOTE		0x10002
> > >   #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
> > > -#define TDVMCALL_STATUS_RETRY		1
> > Oops, I accidentally removed this constant to break tdx guest build.
> 
> Is this the same as "TDVMCALL_RETRY" added in the patch? Since both tdx
> guest code and VMM share the same header file, maybe it needs another patch
> to change the code in guest or you just follow the naming style of the exist
> code?

The style in other TDX place is without STATUS.  I don't want to play bike
shedding.  For now I'd like to leave TDVMCALL_STATUS_RETRY, not add
TDVMCALL_RETRY, and keep other TDVMCALL_*.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

