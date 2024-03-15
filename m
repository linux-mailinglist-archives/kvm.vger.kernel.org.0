Return-Path: <kvm+bounces-11876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 498C587C743
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 02:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03564283251
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908D16127;
	Fri, 15 Mar 2024 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BdbsAzMd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE4C17E9;
	Fri, 15 Mar 2024 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710466515; cv=none; b=toJtBmFnzMF9A911yHIih5VbsIORHJul6w51W4830VLjV7iDdMme/3faNPPSUjGYj4pDOTccNAc1uUvD9Gqa2mdu0Ly6skqfVWkZ8bWdoj40UBKq8/udHZFbZdrLTJKOsbprWlfGQ0vfYp4lzoqbDkrTyqSAiwU5iGaV0pMICk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710466515; c=relaxed/simple;
	bh=Th7S+DhYrtzjGeSKsD9TjobPaMkl17CMIDV/Ixl5vvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s237Ang+9s+Na+MdwrA83otVRXz9VGTixenN+q8HWfN1tv5k2JrealChSDgTOCy5qd8kDVemeXGRBSouwhHTrp8B65oD7Ealo1YmTC9TavgGwqSSGwddyUpQRM7PL+ucHFjWVq8McgdFnsjzcuqJDhwN1XPGFPitCjjbUKEgHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BdbsAzMd; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710466514; x=1742002514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Th7S+DhYrtzjGeSKsD9TjobPaMkl17CMIDV/Ixl5vvw=;
  b=BdbsAzMdlaYXXpYJJK9JzDsACVYIJgTFsOYqYdHcsCNsiFCvCYMDF2yr
   TqjTJBqz/rvp7RqCUzuUeTi4dGArnCyVo9UktpkGHNTwgNm9X4i7TPeqD
   c7BqDm/pAGzWIG7f2TY/QK90YhkbPbyvQUP1/K7OeNWkrP4SWUVTQeLg9
   vg9XtV1Can6PO/JfyEMhOlD+TtxEYoBWNscCR7sMMIf7E0h19djiQBwnJ
   Yi5p8gnIyJSolQPsHfGHExDvgBUxKcRwMfrlo2IbYsdeUUTEly1eJvupm
   Xc7oy+jyTRN6SB2zWah29axIYV9EeLdsDaTNkr3aSk2ntEonB5gZR5EiF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="15963108"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="15963108"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 18:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="43397230"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 18:35:12 -0700
Date: Thu, 14 Mar 2024 18:35:11 -0700
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
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 120/130] KVM: TDX: Add a method to ignore dirty
 logging
Message-ID: <20240315013511.GF1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1491dd247829bf1a29df1904aeed5ed6b464d29c.1708933498.git.isaku.yamahata@intel.com>
 <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4cde44a884f2f048987826d59e2054cd1fa532b.camel@intel.com>

On Fri, Mar 15, 2024 at 12:06:31AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:27 -0800, isaku.yamahata@intel.com wrote:
> >  
> > +static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
> > +{
> > +       if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
> > +               return;
> > +
> > +       vmx_update_cpu_dirty_logging(vcpu);
> > +}
> 
> Discussed this first part offline, but logging it here. Since
> guest_memfd cannot have dirty logging, this is essentially bugging the
> VM if somehow they manage anyway. But it should be blocked via the code
> in check_memory_region_flags().

Will drop this patch.


> On the subject of warnings and KVM_BUG_ON(), my feeling so far is that
> this series is quite aggressive about these. Is it due the complexity
> of the series? I think maybe we can remove some of the simple ones, but
> not sure if there was already some discussion on what level is
> appropriate.

KVM_BUG_ON() was helpful at the early stage.  Because we don't hit them
recently, it's okay to remove them.  Will remove them.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

