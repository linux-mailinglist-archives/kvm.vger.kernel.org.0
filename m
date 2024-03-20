Return-Path: <kvm+bounces-12330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE2B88194A
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:52:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BF1B1C21090
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8455885C68;
	Wed, 20 Mar 2024 21:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZCnSeSl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D533062;
	Wed, 20 Mar 2024 21:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971558; cv=none; b=FgSsv+PjDIFQUrALvOmXfni2ig7F6EXWe3Kkjb9UsjSUQcYsE/UjbUJzZK6Dltuoo3Val57Emm9jVzHdjNI1hrIJjfNd8yl2roj/oJ79c+0O+5ZOfVdUj0xIITF5IUk+3Wwq87vGn/czAoawZoZEfliN3K4eSNhhCup20OIX7ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971558; c=relaxed/simple;
	bh=8zhUcMHgW8RImpLOFFWUdVjfodb9oNMgadrLsX11UVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyKCOzz0HGoyTQ9h8OhuVGsb7VNtiVsFY9Js2/VOYXy8nZikY4dTunDflmAGRPhVvl0Pxg8ZPdrOEt6AHIolmNLLJTjTreQiei+Y8CtHOoV/13r9LDPbFzCCOZLn26hYPMq2yiM7HIj/33VbB4Lx3Vwfe3Z0mhRlWf6zo4uxFbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lZCnSeSl; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710971551; x=1742507551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8zhUcMHgW8RImpLOFFWUdVjfodb9oNMgadrLsX11UVo=;
  b=lZCnSeSlA4DcmdZl80bV6j7Po5zE27RDGkI+NkNdnsJs0t/8lQ0Pq9cd
   wy+YzGLG3e8BFuYREcDyGYNoddQVZawy+PXHM0Xf9Ai8jlVuLB9EJ62NL
   cDPCdLawavS/6PmMEnitDjUvqCMOHUndnmYgRoCALKBGIPvhOXUzmKyHT
   3rPjPoW6jqeRk+/Cb9ZTorUCRUHqwAEl8Ei3Qt6mueomGg/QnGY3gND2+
   J9dMXguZF8SQkkBpFnSTLXthzQMqKv0QDTb4LDTxOddrL5EiJflPCAg6b
   xPhGqnYtjrj4t0X1XXUAexlRFI7a3shS09qsLXvfNgBTEh7v+V5E5oz14
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5816216"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="5816216"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 14:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="45386606"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 14:50:19 -0700
Date: Wed, 20 Mar 2024 14:50:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Message-ID: <20240320215013.GJ1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
 <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>

On Wed, Mar 20, 2024 at 01:29:07PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 26/02/2024 9:25 pm, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add helper functions to print out errors from the TDX module in a uniform
> > manner.
> 
> Likely we need more information here.  See below.
> 
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> > Reviewed-by: Yuan Yao <yuan.yao@intel.com>
> > ---
> > v19:
> > - dropped unnecessary include <asm/tdx.h>
> > 
> > v18:
> > - Added Reviewed-by Binbin.
> 
> The tag doesn't show in the SoB chain.
> 
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> 
> [...]
> 
> > +void pr_tdx_error(u64 op, u64 error_code, const struct tdx_module_args *out)
> > +{
> > +	if (!out) {
> > +		pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
> > +				   op, error_code);
> > +		return;
> > +	}
> 
> I think this is the reason you still want the @out in tdx_seamcall()?
> 
> But I am not sure either -- even if you want to have @out *here* -- why
> cannot you pass a NULL explicitly when you *know* the concerned SEAMCALL
> doesn't have a valid output?
> 
> > +
> > +#define MSG	\
> > +	"SEAMCALL (0x%016llx) failed: 0x%016llx RCX 0x%016llx RDX 0x%016llx R8 0x%016llx R9 0x%016llx R10 0x%016llx R11 0x%016llx\n"
> > +	pr_err_ratelimited(MSG, op, error_code, out->rcx, out->rdx, out->r8,
> > +			   out->r9, out->r10, out->r11);
> > +}
> 
> Besides the regs that you are printing, there are more regs (R12-R15, RDI,
> RSI) in the structure.
> 
> It's not clear why you only print some, but not all.
> 
> AFAICT the VP.ENTER SEAMCALL can have all regs as valid output?

Only those are used for SEAMCALLs except TDH.VP.ENTER. TDH.VP.ENTER is an
exception.

As discussed at [1], out can be eliminated. We will have only limited output.
If we go for that route, we'll have the two following functions.
Does it make sense?

void pr_tdx_error(u64 op, u64 error_code)
{
        pr_err_ratelimited("SEAMCALL (0x%016llx) failed: 0x%016llx\n",
                           op, error_code);
}

void pr_tdx_sept_error(u64 op, u64 error_code, const union tdx_sept_entry *entry,
		       const union tdx_sept_level_state *level_state)
{
#define MSG \
        "SEAMCALL (0x%016llx) failed: 0x%016llx entry 0x%016llx level_state 0x%016llx\n"
        pr_err_ratelimited(MSG, op, error_code, entry->raw, level_state->raw);
}


[1] https://lore.kernel.org/kvm/20240320213600.GI1994522@ls.amr.corp.intel.com/

> 
> Anyway, that being said, you might need to put more text in
> changelog/comment to make this patch (at least more) reviewable.
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

