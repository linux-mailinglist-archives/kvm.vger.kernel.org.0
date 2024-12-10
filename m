Return-Path: <kvm+bounces-33399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B8B9EAC89
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F991161519
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D884234974;
	Tue, 10 Dec 2024 09:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RLpT+ktl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334C9231C91;
	Tue, 10 Dec 2024 09:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823350; cv=none; b=CjYg9wsn4uVHPxGpg/Vi4mNbRx5R3/KTiXa7iNuhcfbhukdHkbKC/InT2GqOGuZ+5qeN8v18cSl61OHwHaY14gVrK5zpxxT/jpnaAIcgWobjO2CIEUaabSrLqf16bHi/ZpnzTnjxRxh93ZxQBzFdfeMRIGlh9WG7Y9Gq9478Bhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823350; c=relaxed/simple;
	bh=LF9TgfquWKkXnQZNiQYQ2vV2OAzMoAmA1UwMuJJ+mxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKLcbHxiwbwtN6CrBr+CwvyMFGNr+xGcPOyMfiPLA36x7QN9oALwD5x7AU+5XHKVJCtrglD13trvMf85vJj5d1Sip6lL7AYiMK9RK4bjkfYAGVaOKxwt6cPCsab8C5WilMlENvPvqzyTBrJgJHQNDFGg5j8hlleC2nwXU0I7NmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RLpT+ktl; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733823349; x=1765359349;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LF9TgfquWKkXnQZNiQYQ2vV2OAzMoAmA1UwMuJJ+mxE=;
  b=RLpT+ktlWFM8VJcBIkMByZkKfpYK+TKFdKvh4q91tRhGa8SQmehBGzRs
   4gyKKpLhvOh7LipXnQTjCWc9Tpx34Xy4k6T3JC4yZy/a4dE0YmILekuEy
   cAXtPT3ysvwKVZc4hrEGjTfzEorhElDd3koN+aJ995JRWV9Kb2dyR8wsy
   air13OA8Jr6izRFaS9AhrDeH7E9MZXPKStYJbRdDpztXJvTc59xFuCTVc
   7lpfN1squX61yZPJFtlX3AYkNkm8ZTf7MAjseXCNoOwC6PMD4ftZroH96
   vnI7jRva66VgWtOSbsSb56tJ8g9iS5qFZk1z3mbfiX4gmPIl+RVysK7Tb
   w==;
X-CSE-ConnectionGUID: /nKABmc4QzOIU7CoLS9B/g==
X-CSE-MsgGUID: MOmd0xjGQpiOCkK1q/CdMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="33493248"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="33493248"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:35:48 -0800
X-CSE-ConnectionGUID: rFYplmSnT42oQoa9xbjZRA==
X-CSE-MsgGUID: aEg00VOSQViG1MlxFqcpLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="100395743"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.224])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:35:44 -0800
Date: Tue, 10 Dec 2024 11:35:39 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Message-ID: <Z1gLa2oWBtk2bjvF@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <2463ba67-aa8c-4f41-8f13-f1936a4f457a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2463ba67-aa8c-4f41-8f13-f1936a4f457a@intel.com>

On Fri, Dec 06, 2024 at 04:45:01PM +0800, Xiaoyao Li wrote:
> On 10/31/2024 3:00 AM, Rick Edgecombe wrote:
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -928,6 +928,8 @@ struct kvm_hyperv_eventfd {
> >   /* Trust Domain eXtension sub-ioctl() commands. */
> >   enum kvm_tdx_cmd_id {
> > +	KVM_TDX_CAPABILITIES = 0,
> > +
> >   	KVM_TDX_CMD_NR_MAX,
> >   };
> > @@ -950,4 +952,11 @@ struct kvm_tdx_cmd {
> >   	__u64 hw_error;
> >   };
> > +struct kvm_tdx_capabilities {
> > +	__u64 supported_attrs;
> > +	__u64 supported_xfam;
> > +	__u64 reserved[254];
> > +	struct kvm_cpuid2 cpuid;
> 
> Could we rename it to "configurable_cpuid" to call out that it only reports
> the bits that are allowable for userspace to configure at 0 or 1 at will.

Well it's already in the capabilities struct.. So to me it seems like just
adding a comment should do the trick.

Regards,

Tony

