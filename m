Return-Path: <kvm+bounces-14998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0C48A8B3A
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 270931C23C65
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A6E11725;
	Wed, 17 Apr 2024 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lgl7eBnY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787EBE570;
	Wed, 17 Apr 2024 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379152; cv=none; b=jX31tOKstVx+alvR+VDK/9C+/YdfWEF3yXvKr11TnXpQ+y73Zuz0MAQtKeYLaUjT63FTbVhwWIpcMvkxrSThEFRcKHcwhN8WD9QrMRYa/GtAMGN7rr+RNbhx/eLtBaAt79rLnQ0uqnhQXeVvZb/SKPE9wLz82eCXr+7ihg/JLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379152; c=relaxed/simple;
	bh=sMNIB4tkcKWqS/aTQJ3ll+HLyA2/rEy8wqHL4XzD9QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLpgUlSPVmMgvLB5BsYt5Detwo18fSH0OP/dz+zRfSaMdj5Iwk/KRtclR1FvGCH67UbQX5XPPTGV7CvIzqcBip2ponSvb+Vp1/fKbStDsSRO1GN40jpYWyd7+DKtVKT9n2rk4dKAp4X8IXY//IvLjlllHmIKEHjEHeqvlnAaN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lgl7eBnY; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713379150; x=1744915150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sMNIB4tkcKWqS/aTQJ3ll+HLyA2/rEy8wqHL4XzD9QU=;
  b=lgl7eBnY2fqYaJna0G02SVpxcrXRiFqS9auIHmopYcTZW82AjUa8N6de
   DIBI7w+/bBAYVwRaQSxRttHYzruqVMycmOQJ3nAsVYuhop5vB6EyIxA14
   0EsXK8u+L/Sewh25tYsmpj7x92CRvLe2UWR6sU0ZCilVrAuMquWoQJqbq
   ++7Tg7zceV3be0ohuyjsT93nGtpcOYlsgbptD13FGBEQ/+gOpPKDAJbtv
   Og27pPJWcZbvv4Nyfi3cwKFBIUEzQBJ+vSAQjFfeDkn50jirtPJ2S1wsO
   qd954uQkfpNnppW4xH2tOpYXkloZhJvw4qEmbAtY0i42S02EEaDPk7eK6
   A==;
X-CSE-ConnectionGUID: Y59NaKY9SWiCv696iyAh7g==
X-CSE-MsgGUID: m0vWN33nTtKMolNREsHwwg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9439205"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9439205"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:39:09 -0700
X-CSE-ConnectionGUID: uFT/P/boQzq8hqlLXADjlQ==
X-CSE-MsgGUID: 28WSxGr9SIa3iWDlOHWcWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22727431"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:39:09 -0700
Date: Wed, 17 Apr 2024 11:39:08 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
Message-ID: <20240417183908.GG3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
 <8c4ee32de5016f7ebeaa76fcff7c70887024c34b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c4ee32de5016f7ebeaa76fcff7c70887024c34b.camel@intel.com>

On Tue, Apr 16, 2024 at 02:46:17PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-04-10 at 15:07 -0700, isaku.yamahata@intel.com wrote:
> >  
> > +int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > +                    u8 *level)
> > +{
> > +       int r;
> > +
> > +       /* Restrict to TDP page fault. */
> > +       if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> > +               return -EINVAL;
> > +
> > +       r = __kvm_mmu_do_page_fault(vcpu, gpa, error_code, false, NULL,
> > level);
> 
> Why not prefetch = true? Doesn't it fit? It looks like the behavior will be to
> not set the access bit.

Makes sense. Yes, the difference is to set A/D bit or not.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

