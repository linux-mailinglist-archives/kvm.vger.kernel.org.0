Return-Path: <kvm+bounces-13478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9648E89753F
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A55A1F2B3B2
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 16:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D529C15099B;
	Wed,  3 Apr 2024 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dHbiiKvv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB103152182;
	Wed,  3 Apr 2024 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712161815; cv=none; b=ThumbPQzsZYs3TMdpDH9s8PQAxQzMPoC0sBGS0Pupc7h+qxnXhdD2y7WSFwMS4bpu6c8/C240Gt5EaqTybD9mDbHt8oVGhcfEcU/ljGAk38aVVSAsJvooc3RG0+yAeZ8jZDVTWiwd0cTxBMaWAf65eCk16CJ41BPBP5BtsZuVBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712161815; c=relaxed/simple;
	bh=vbDpGSoI9EPAI1uhODCTMNPVWnAKTin6hpwpvwV3kck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sNau3/CKMvSn/nf3FqYL0tzhEagJ0UiO03cca5G/wDqAkcMi65YXAAdlMlEQMp5BdzsOkSS+46aEKy/3Z4KJX1Hyx1Qg4MIPVUkxwhakv39+aC5hq0iDdt/6Wc7OkvABowDKffRv4gJ6Vic2FAphacQQwc3W50bHPv5wEvPZdzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dHbiiKvv; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712161813; x=1743697813;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vbDpGSoI9EPAI1uhODCTMNPVWnAKTin6hpwpvwV3kck=;
  b=dHbiiKvv8+nlK376RzEgLmsBq9FCRjtu6qokn4CTmtVYzLdGZJwunaw4
   Ta/V4chrM62TRKUVkdpzkx3tDKlTKNkzgfhm5QLA5TXJw81cvCElpRyXL
   GsSO21730V1uIkhXa8ibDQi5uFmSwdxDYVV9PX9EXUYcw3/ZYsf3R2xRN
   hhn0MnLyhxDivz9Ja3Jt1z51Abd3uhaWdoDPcrkf9JBrzLE1GFNoPAGuZ
   yliGB0R+XDuQH3JV537t+DCMAUHG32Mkn9MGi9Xzn1vr6iNneBSMbWZsy
   oAu2m0OakG2nH4LgiRqA1l/fazik1LkA8i7g+FxcvDoobAxDYPrMcFD8V
   g==;
X-CSE-ConnectionGUID: KrkKMjRhQmmi13895Pwjyg==
X-CSE-MsgGUID: S1qXJ0W1Rh2K6Xe1RxhG9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7640303"
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="7640303"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 09:30:12 -0700
X-CSE-ConnectionGUID: aEmPxBAXSnCVVM0ZIFzQHg==
X-CSE-MsgGUID: +uZpr5OLSNWg4mGpW3HMRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,177,1708416000"; 
   d="scan'208";a="22959547"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 09:30:12 -0700
Date: Wed, 3 Apr 2024 09:30:11 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
Message-ID: <20240403163011.GD2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <Zg1v4wSgPWiY1Tok@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg1v4wSgPWiY1Tok@google.com>

On Wed, Apr 03, 2024 at 08:04:03AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > +union tdx_vcpu_state_details {
> > +	struct {
> > +		u64 vmxip	: 1;
> > +		u64 reserved	: 63;
> > +	};
> > +	u64 full;
> > +};
> 
> No unions please.  KVM uses unions in a few places where they are the lesser of
> all evils, but in general, unions are frowned upon.  Bitfields in particular are
> strongly discourage, as they are a nightmare to read/review and tend to generate
> bad code.
> 
> E.g. for this one, something like (names aren't great)
> 
> static inline bool tdx_has_pending_virtual_interrupt(struct kvm_vcpu *vcpu)
> {
> 	return <get "non arch field"> & TDX_VCPU_STATE_VMXIP;
> }


Sure, let me replace them with mask and shift.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

