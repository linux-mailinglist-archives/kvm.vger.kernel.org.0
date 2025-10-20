Return-Path: <kvm+bounces-60570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D144BBF39AC
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 23:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4DEC18C4478
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 21:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DDE3328FC;
	Mon, 20 Oct 2025 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VKvJOWLk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE27931280D;
	Mon, 20 Oct 2025 20:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760993775; cv=none; b=iGb95qJytgKZrex00boOVpaKgFs0QJJy0DklMGihZW8s4oFTgQMoXOuI2DECNR51qN/eyhfiFGfLUtXZZh14LtiUf+vJsu5KHoTUsoX2mAwbdtK/0Dh5rWiEhcs2CU1bIrwtI2abBtqnTKPHwyCIqRHDk5KTkzZjexW49oWBgv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760993775; c=relaxed/simple;
	bh=ZfW7ZPj2/urpyrJRR27Pd1uc6Sw7mUpby74QqoU0mBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uOc8HcMYbDKME3PyJKOl1vUaf893DgWe3nfDrjRuCdV3T8UA17Vie2ckUEdP3lQT0TxgGIQ3FvnIN8CkdTw/LR4wy/q6ylwg9hw3LXAQzUPrsRDNLnyPLvVJxr+7gEaRx2UVg2fl0fNFV4BMMiZjiHn9AnLdXW15l8il/3mxaFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VKvJOWLk; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760993773; x=1792529773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZfW7ZPj2/urpyrJRR27Pd1uc6Sw7mUpby74QqoU0mBE=;
  b=VKvJOWLkPZc9Z4bCeXh7UJe3Wh/RFqo3rEl4tvJ4CgPzjhHEbCMqE+lE
   YVKoWjuFXH16QfjVhPSbY5cdOgtnqHrADfSoYLpM0hB/tYnzYl1f0rH8i
   EVAHoogv3NC3skOPbZ+jVDzOt6/hi6JRhEXtu/teiGup473dSp6/BzEW9
   EnauZvcOnvUWnqmN6p3M/hh/joQIpgHjluDV7v09gyHJKbrawz15YYk/G
   3dX9VKoirH1mDDr+Ft3Tl6fJaplNaTC9wHaIct5xyj9mJc74ITo3SQHOl
   f14sy6ip8BVuBFgDY/HDyB3xlhSgm5HJY8f/hpjox0ryccTkbN48TEr9q
   g==;
X-CSE-ConnectionGUID: POLOhZlPSEuLr2jXXDdnPg==
X-CSE-MsgGUID: yKnlc22uR7+gG5ujg4nvEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63014551"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="63014551"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 13:56:11 -0700
X-CSE-ConnectionGUID: IsRe3ERCQDKuYGZ3NPuDjA==
X-CSE-MsgGUID: AK8qCjQmRGinzW/5a1cUWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="183267182"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO desk) ([10.124.220.167])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 13:56:10 -0700
Date: Mon, 20 Oct 2025 13:56:02 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v2 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
Message-ID: <20251020205602.xrgypiwk5dwejdqf@desk>
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
 <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com>
 <aPZe6Xc2H2P-iNQe@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPZe6Xc2H2P-iNQe@google.com>

On Mon, Oct 20, 2025 at 09:10:17AM -0700, Sean Christopherson wrote:
> On Wed, Oct 15, 2025, Pawan Gupta wrote:
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 49707e563bdf71bdd05d3827f10dd2b8ac6bca2c..00730cc22c2e7115f6dbb38a1ed8d10383ada5c0 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -534,7 +534,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
> >  		: "memory");
> >  }
> >  
> > -DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
> > +DECLARE_PER_CPU(bool, x86_pred_flush_pending);
> 
> Rather than "flush pending", what about using "need" in the name to indicate that
> a flush is necessary?  That makes it more obvious that e.g. KVM is marking the
> CPU as needing a flush by some other code, as opposed to implying that KVM itself
> has a pending flush.
> 
> And maybe spell out "prediction"?  Without the context of features being checked,
> I don't know that I would be able to guess "prediction".
> 
> E.g. x86_need_prediction_flush?
> 
> Or x86_prediction_flush_exit_to_user if we would prefer to clarify when the flush
> needs to occur?

Ok, ya this is more clear. I would want to make a small change, instead of
"prediction_flush", "predictor_flush" reads better to me. Changing it to:
x86_predictor_flush_exit_to_user.

