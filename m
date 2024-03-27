Return-Path: <kvm+bounces-12912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEEA088F360
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:58:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFAD228F4D2
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 23:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1EC1552FC;
	Wed, 27 Mar 2024 23:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SjHD06Re"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A06922094;
	Wed, 27 Mar 2024 23:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711583917; cv=none; b=Lv44fFfMQ88fIZYv9hlrn/2Jr3WBUhiQRzhHgRf1GC4iiX0b6wJG5rE6yNADQJNGrL3d3YzPQISvgtd5qJJa21H3OgOQG58dbw1suuUVmOYnLlKFLgCehYAwHEHrB5MzDHweFBcH02cLZdqTkxfHbgFFMPkm1hFcjL+Itdxlfzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711583917; c=relaxed/simple;
	bh=d6jZWl/4ns4obMB2o0aKFjPdoKDJa/8I2PNQXfn+TVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hsh7xEzahCRSXKTkqGyO4TmxhcxjkfpuN+IMyMNE1T/ufH60VE+kz/FvVG+YCc6s6aEAimqecWdypqzc1DQX8sSKgJCDC8tInsRZGkL5b4CPSjuegsG8N5KbGZ0+kf90UzQN0doHfgIO6tjU3IVgU2b3A6WiN8fnmG2vEs6a1sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SjHD06Re; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711583916; x=1743119916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=d6jZWl/4ns4obMB2o0aKFjPdoKDJa/8I2PNQXfn+TVE=;
  b=SjHD06ReJJ3wb7Kx4cldNVo4YJBq8MtlZ6e1gEAYcVCBIwYCmkEuv/AD
   KPrCMwiQeBPEuG3gtttc/1tM2i7i4niAE63MQMl9kpLVb3d4u30mmZCJ0
   jB8fc+z3TXFpKxm6yuvwQZlpsCKCdkU2w1Az/E8MSbQI8XFin6g2TqJC9
   hCFPey6Na3xRZC7mxAfwoAXJvBP8fVKjw5bAGoUQqKFRhPf4g/NDDeMom
   cKGlVYhzfu0iNOp61CnafnbfwLeY5J299nHGHIuvOMCEnQgveBUr/YRKK
   2oeZaL5YOQ0uEAYcxNHAHsVBd/+6dM9leWEFEAAOjN5tv+BNRRTzTljJ9
   w==;
X-CSE-ConnectionGUID: FzRCR88NQJuN8/Qh2Hhtuw==
X-CSE-MsgGUID: 5Ya01s2tTSOKa25STcJIgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="9677418"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="9677418"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 16:58:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16486554"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 16:58:35 -0700
Date: Wed, 27 Mar 2024 16:58:35 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 052/130] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Message-ID: <20240327235835.GI2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <34d7a0c8724f4fce4da50fe3028373c31213aa8a.1708933498.git.isaku.yamahata@intel.com>
 <ccca711ccd0cb52739041580a26d4ea240760b10.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccca711ccd0cb52739041580a26d4ea240760b10.camel@intel.com>

On Tue, Mar 26, 2024 at 03:31:05AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> > members to kvm_arch and track value for MMIO per-VM instead of global
> > variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> > logic is kept working.  Introduce a separate setter function so that guest
> > TD can override later.
> > 
> > Also require mmio spte caching for TDX.
> 
> 
> > Actually this is true case
> > because TDX requires EPT and KVM EPT allows mmio spte caching.
> > 
> 
> I can't understand what this is trying to say.

I'll drop this sentence as the logic moved to
"069/130 KVM: TDX: Require TDP MMU and mmio caching for TDX".


> >  {
> > +
> > +       kvm->arch.shadow_mmio_value = shadow_mmio_value;
> 
> It could use kvm_mmu_set_mmio_spte_value()?

Yes.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

