Return-Path: <kvm+bounces-25476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA89965A67
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE1882848DC
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC80216D4E5;
	Fri, 30 Aug 2024 08:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8DrxBCD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453FC1531F4;
	Fri, 30 Aug 2024 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725006864; cv=none; b=nCQJuzyz7szq0Q2vZrYL/bMcfMC7BJg877IF38C9QMQwC0BwFP4ndu0Od4GVeSY64kpObnGH6nDs32I8Ik3FZH0TNHZLVurFzw55sufGAmrcuQ1OP/LUPLkt3PH99TsnDLooyoie7PAJQGz+Pc7eG2Z1SAq/exUcnwC2HAso0A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725006864; c=relaxed/simple;
	bh=qwsMEMHeerdWI1UTdx6FPqQoa8iGsLfB+Adm8JCDW7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBEXHdxkAei6HTzoNMOmoguti1dvUT36l9aL96LPRUJMQGpcTOyNeZbq8XwmWW8li6xeHoUVRPoG2sqNyIt7LJgpfFa6jfkmOaUzW6bjMA38kFY5I3imqK9HhscuoPYAiPS0z2plWfxYnpGYIRRJItER/ZweOGev6UzxGdrVK4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8DrxBCD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725006863; x=1756542863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qwsMEMHeerdWI1UTdx6FPqQoa8iGsLfB+Adm8JCDW7s=;
  b=d8DrxBCDtKUoDPeW9CtAtlXnYj72+JqrG9DlrSDCjlSor+Z7xBYjUTFd
   nikFTwvM+xyuD1VEzYiBwxRgCEPuu25L5e65qcffN72NoFwd38EEtMqi9
   zvvb/44vhOIfMU+xjzIdfPnT8KDfOBjYj+WmAv5NHQ7CGv2agA2+aQkqP
   JIFhOBAHs4iy2OJ2jeCojPXF2YLh8lH7IMZQqjTSAYoxUN0kVOclqtF2P
   agZVmpNG0zXjMwPsDoyNH5nQEQcVODYXfasIiUl90iwta0W4wj1z2Xx2s
   XueGIhthLfRrQ2ATWsrSwABnI1pUqd+oUIkcGqNubGdvCYeyXE8Vrw5nq
   g==;
X-CSE-ConnectionGUID: PKfm/2wnQu22gk09u3Bxsg==
X-CSE-MsgGUID: ystzEsF3ReGQcC+U9Lj5Ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23777263"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23777263"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:34:23 -0700
X-CSE-ConnectionGUID: gyNQ+s63Q0K8UIXDemuNfQ==
X-CSE-MsgGUID: kvsX+b0SRM6yeoK6hGACnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="64183943"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:34:19 -0700
Date: Fri, 30 Aug 2024 11:34:14 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZtGEBiAS7-NzBIoE@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <ZrrSMaAxyqMBcp8a@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrrSMaAxyqMBcp8a@chao-email>

On Tue, Aug 13, 2024 at 11:25:37AM +0800, Chao Gao wrote:
> On Mon, Aug 12, 2024 at 03:48:05PM -0700, Rick Edgecombe wrote:
> >From: Xiaoyao Li <xiaoyao.li@intel.com>
> >+static int __init setup_kvm_tdx_caps(void)
> >+{
> >+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> >+	u64 kvm_supported;
> >+	int i;
> >+
> >+	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
> >+			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,
> 
> struct_size()
> 
> >+			       GFP_KERNEL);
> >+	if (!kvm_tdx_caps)
> >+		return -ENOMEM;

This will go away with the dropping of struct kvm_tdx_caps. Should be checked
for other places though.

Regards,

Tony

