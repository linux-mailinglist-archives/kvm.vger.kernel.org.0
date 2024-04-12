Return-Path: <kvm+bounces-14564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D422A8A3561
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D3221F22764
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5638C14EC48;
	Fri, 12 Apr 2024 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eN5ZO6yp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5DF146D7B;
	Fri, 12 Apr 2024 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712945400; cv=none; b=XLLcFbs2Nz8KtO8UWMN2C5cf4TrJd+Dj7av8UK+v6pvNS5tSP4VTmHaA3diRs+qf+tScsR+p+eLmE16Obx9W+rn3JGSrl42fSfzbnwGFR4bqZESybQKBrDjCKEh3uCKaDAso12ILt4ZnoHXHhHrQeLOphZER1B0RY4FclYsdd6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712945400; c=relaxed/simple;
	bh=0J4SlgDGf+5ax9loRJCtM8+Hj8SjQZHESyQGU7tmxW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jr93Ei+HOssBUO8ytyh1y1ohaLAtd+zO+AJ2jcu2jnHP8zKIKRwcBt06ZsP+jR+q/Y5Utz9XatjnQk7FUsBzKhwK1B1F6G2WAKuCLJN17u9HuJZ1yJyEG7dtDt0KEkV8B3GHo+32LzZsRWJiPlxh4ja8pPHRLjBNbwivTCSKV4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eN5ZO6yp; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712945399; x=1744481399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0J4SlgDGf+5ax9loRJCtM8+Hj8SjQZHESyQGU7tmxW4=;
  b=eN5ZO6ypRnrWN8psJZ0kj2nAI5zDa0PziW84KwNfttSwo4pKOFuhAWjH
   YdU1C3FBGhbR1zbf8L5cYTW7vd7Az3pf/ZTaeKsqMtMVYXWBlKn0vRGvv
   /OeT3j1P72HzJdFokT3PSzahs6I9UnJP464044Oj0mvNScdFEVCI2gJ2g
   y65gpG7yyoR0cbfE8tsFMof4pepA0EsACMWPlf7tSjs1N8yqI9TJpKYw1
   QFvoFeqjGBSbRwHXadqvCcEE96gFcAo2VEpixphbGZK0INC0pavYaoEda
   0NLeKQb5JNGmmGhRNmcAG2vUn4N3pJbSXfroNK7xxxXZhyqkW5SEtBszg
   A==;
X-CSE-ConnectionGUID: hl63ZS0dTQeh8NO64IYkYA==
X-CSE-MsgGUID: L1Ixrb6gQJuF8Z1zjWflKQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8583247"
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="8583247"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 11:09:58 -0700
X-CSE-ConnectionGUID: kYEP+10GTD69RVfRQuSdHA==
X-CSE-MsgGUID: mx5ldHYRSBqXgJI8J5lA0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,196,1708416000"; 
   d="scan'208";a="52262517"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 11:09:57 -0700
Date: Fri, 12 Apr 2024 11:09:57 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 076/130] KVM: TDX: Finalize VM initialization
Message-ID: <20240412180957.GI3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e3c862ae9c78bda2988768c1038fec100bb372cf.1708933498.git.isaku.yamahata@intel.com>
 <f3381541-822b-4e94-93f7-699afc6aa6a3@intel.com>
 <20240412010848.GG3039520@ls.amr.corp.intel.com>
 <a876accc-a7bf-4317-9612-d6d5a1fbaf9c@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a876accc-a7bf-4317-9612-d6d5a1fbaf9c@intel.com>

On Fri, Apr 12, 2024 at 03:22:00PM +0300,
Adrian Hunter <adrian.hunter@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 0d3b79b5c42a..c7ff819ccaf1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -2757,6 +2757,12 @@ static int tdx_td_finalizemr(struct kvm *kvm)
> >  		return -EINVAL;
> >  
> >  	err = tdh_mr_finalize(kvm_tdx);
> > +	kvm_tdx->hw_error = err;
> > +
> > +	if (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX))
> 
> There seem to be also implicit operand codes.  How sure are
> we that TDX_OPERAND_ID_RCX is the only valid busy operand?

According to the description of TDH.MR.FINALIZE, it locks exclusively,
RCX in TDR, TDCS as implicit, OP_STATE as implicit.  And the basic TDX feature
to run guest TD, TDX module locks in order of TDR => OP_STATE. We won't see
OP_STATE lock failure after gaining TDR lock.

If you worry for future, we can code it as
(err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_BUSY.  We should do it
consistently, though.

> > +		return -EAGAIN;
> > +	if (err == TDX_NO_VCPUS)
> 
> TDX_NO_VCPUS is not one of the completion status codes for
> TDH.MR.FINALIZE

It depends on the document version.  Need to check TDX_OP_STATE_INCORRECT
to be defensive.


> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 98f5d7c5891a..dc150b8bdd5f 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -18,6 +18,9 @@ struct kvm_tdx {
> >  	u64 xfam;
> >  	int hkid;
> >  
> > +	/* For KVM_TDX ioctl to return SEAMCALL status code. */
> > +	u64 hw_error;
> 
> For this case, it seems weird to have a struct member
> to pass back a return status code,  why not make it a parameter
> of tdx_td_finalizemr() or pass &tdx_cmd?

I created the patch too quick. Given KVM_TDX_CAPABILITIES and KVM_TDX_INIT_VM
take tdx_cmd already, it's consistent to make tdx_td_finalize() take it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

