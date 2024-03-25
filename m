Return-Path: <kvm+bounces-12617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4AB88B283
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D361C280E9
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB1B6D1A3;
	Mon, 25 Mar 2024 21:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D8gI9Afh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4226CDA8;
	Mon, 25 Mar 2024 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711401447; cv=none; b=XrrQ4s3QoD1QPNcTuf4JkBG/Bpb2T2qB9tkYUSrevUa+Mc6Baf1pxLO87uJvdrD3EuXu+0Cvn0tV5na2Dyz66gWMKilyB5rTy/lNNKsWALECNHMcxtz57FCoAJ/Yn9fFY9tR8E6htJ0ZawrWQ2D0ZFVEaPN6X64bshS2Os1MnEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711401447; c=relaxed/simple;
	bh=liQpZznPmxJSTYEPb0Eg7dXTRfDNwgyeGuWMxlxmPcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iwdftf8vc89cVnsG16GVY2xgx4p5PAOId++DpMcIQfAD1wPtFpYZ5onfTyuy1rDqImdqn+ARcXZcmbjNOq2YGM9ERktC4NZVhNSpe1e6MKJORMbik9pk86cBBTAhpR9LqVtUomqAGnice/XRvnbDrNpwCztAJuKwsipb8fQS+Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D8gI9Afh; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711401445; x=1742937445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=liQpZznPmxJSTYEPb0Eg7dXTRfDNwgyeGuWMxlxmPcI=;
  b=D8gI9AfhAvJTPQnUMYgW/FQXaFICf6MPbVnGfPt7W5+Eq3v+/x0Hh+9T
   6InSd0s1BX97Fyq16we5C6totFA+gR2x8p1Ftyx/iZb628f5hQMnMI53x
   Oomdi9bY55Cd15Cm5sXlfMaH3/0douN7E2ReS2ZnS15vYbEI7yQdn+oVD
   6yqYbEEhUWbyOKf/EUl8Qv14GM+42TvCSxRcBTzprwztmOZunQLHcNIqv
   swxm8ACDcLMnQhTCjziGSf4Q4c5KV0K0tebk7AzUSlAUF3Sdhc8hEyFJS
   NtnMYpBxByXofV6SbjDoIgnADKhMrJlBdVgfGvEnCIcgjpl3JnOeCDh0B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17161036"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="17161036"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="16129744"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 14:17:23 -0700
Date: Mon, 25 Mar 2024 14:17:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Message-ID: <20240325211723.GJ2357401@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
 <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
 <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>

On Mon, Mar 25, 2024 at 03:32:59PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-03-25 at 11:14 +0000, Huang, Kai wrote:
> > To confirm, I mean you want to simply make KVM_SET_CPUID2 return error for TDX
> > guest?
> > 
> > It is acceptable to me, and I don't see any conflict with Sean's comments.
> > 
> > But I don't know Sean's perference.  As he said, I think  the consistency
> > checking is quite straight-forward:
> > 
> > "
> > It's not complicated at all.  Walk through the leafs defined during
> > TDH.MNG.INIT, reject KVM_SET_CPUID if a leaf isn't present or doesn't match
> > exactly.
> > "
> > 
> Yea, I'm just thinking if we could take two patches down to one small one it might be a way to
> essentially break off this work to another series without affecting the ability to boot a TD. It
> *seems* to be the way things are going.
> 
> > So to me it's not a big deal. 
> > 
> > Either way, we need a patch to handle SET_CPUID2:
> > 
> > 1) if we go option 1) -- that is reject SET_CPUID2 completely -- we need to make
> > vcpu's CPUID point to KVM's saved CPUID during TDH.MNG.INIT.
> 
> Ah, I missed this part. Can you elaborate? By dropping these two patches it doesn't prevent a TD
> boot. If we then reject SET_CPUID, this will break things unless we make other changes? And they are
> not small?

If we go forthis, the extended topology enumeration (cpuid[0xb or 0x1f]) would
need special handling because it's per-vcpu. not TD wide.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

