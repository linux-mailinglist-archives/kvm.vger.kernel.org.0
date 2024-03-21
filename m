Return-Path: <kvm+bounces-12459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 21674886421
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 00:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5E271F21AB4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5333BB29;
	Thu, 21 Mar 2024 23:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRVnwmHb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E3C1DFCF;
	Thu, 21 Mar 2024 23:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711065137; cv=none; b=nUDX1eSZexFlkIW1Lvfj95IaKoBTGvFxhTfLA+HjzyzADtLGbfNPqdRtjr6WBdBQ9n82xnBzDqu6PjxLiT7Kje1Hja6lCYeHcuPKWyb+Fbi0vT46/Z13HPGg6hdni7DMQuwWW/ZpEjszWTIWC7w2vR0fAwIGjDSSofg4OnbrMqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711065137; c=relaxed/simple;
	bh=A6ppOylSGg1w6xWuXb/YW2+KGjwJm/zoyUI49PmjYEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8iTdKzr+Rtnk80TI7SKu3Rd1sh7okG0bDWon0T7H9uNVi525bK8MuSEfwj1GvUuuwaBGgk+x6H4imPdynTi8Pm1niqTXbaRyjuXkBlFcMZ4lwN05Kr+KE0MxfOkefzhKn+v82Gh/eHruuekO1isY+ZOLzPWVsOhXZc7GBGJ5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRVnwmHb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711065135; x=1742601135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A6ppOylSGg1w6xWuXb/YW2+KGjwJm/zoyUI49PmjYEM=;
  b=XRVnwmHbmH/9o3C+Shqkj4vqgabRzVQPifQrldV0fZbAliig8E0g6vso
   tDLF0NDWwfo+S8nM3W8bYFm4qrwHFFABljVtFY9fE5V8fL4FJwcx5SJvT
   mmG9MeIBo9l6KuyFgroQwTL4b3ALLSfpWgIk6BNPC1bzfWRiHwiCeeSxG
   H1KM7uXKP8eILBEr2mf0vxfHHZPZoGizIQd3SlfjXA6BHA3fLjcsd+GDv
   IA5nPKbvLJf0sXQxedoP3Xro9uMfNevF4L4cv4/4NDqdJYS2aTpCqjOV+
   p2RdN4kYz4lfNjDkweCtCWqRd4BdAEWHKPSwhGBXlVIjPHLfxk59IcfVn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="17490815"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="17490815"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 16:52:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="19345136"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 16:52:14 -0700
Date: Thu, 21 Mar 2024 16:52:14 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <20240321235214.GV1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
 <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>
 <20240320215013.GJ1994522@ls.amr.corp.intel.com>
 <76e918cf-44ef-4e9b-9e56-84256b637398@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <76e918cf-44ef-4e9b-9e56-84256b637398@intel.com>

On Thu, Mar 21, 2024 at 12:09:57PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > Does it make sense?
> > 
> > void pr_tdx_error(u64 op, u64 error_code)
> > {
> >          pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
> >                             op, error_code);
> > }
> 
> Should we also have a _ret version?
> 
> void pr_seamcall_err(u64 op, u64 err)
> {
> 	/* A comment to explain why using the _ratelimited() version? */

Because KVM can hit successive seamcall erorrs e.g. during desutructing TD,
(it's unintentional sometimes), ratelimited version is preferred as safe guard.
For example, SEAMCALL on all or some LPs (TDH_MNG_KEY_FREEID) can fail at the
same time.  And the number of LPs can be hundreds.


> 	pr_err_ratelimited(...);
> }
> 
> void pr_seamcall_err_ret(u64 op, u64 err, struct tdx_module_args *arg)
> {
> 	pr_err_seamcall(op, err);
> 	
> 	pr_err_ratelimited(...);
> }
> 
> (Hmm... if you look at the tdx.c in TDX host, there's similar code there,
> and again, it was a little bit annoying when I did that..)
> 
> Again, if we just use seamcall_ret() for ALL SEAMCALLs except VP.ENTER, we
> can simply have one..

What about this?

void pr_seamcall_err_ret(u64 op, u64 err, struct tdx_module_args *arg)
{
        pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
                           op, error_code);
        if (arg)	
        	pr_err_ratelimited(...);
}



> > void pr_tdx_sept_error(u64 op, u64 error_code, const union tdx_sept_entry *entry,
> > 		       const union tdx_sept_level_state *level_state)
> > {
> > #define MSG \
> >          "SEAMCALL (0x%016llx) failed: 0x%016llx entry 0x%016llx level_state 0x%016llx\n"
> >          pr_err_ratelimited(MSG, op, error_code, entry->raw, level_state->raw);
> > }
> 
> A higher-level wrapper to print SEPT error is fine to me, but do it in a
> separate patch.

Ok, Let's postpone custom version.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

