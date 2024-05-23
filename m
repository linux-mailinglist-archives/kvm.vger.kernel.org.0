Return-Path: <kvm+bounces-18026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EDC8CD06A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 12:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5103FB2239F
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 10:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35095144307;
	Thu, 23 May 2024 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSbr3YC6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30E51411CC;
	Thu, 23 May 2024 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716460524; cv=none; b=XOlhZ6himxW6SHpOtcZRhvW/2iMmmjXHQk5GGDPKEXuDZJrcZpqb50jYI7yjjhBgQ9D3GxOK94QKzTXTBwOHZ77pvjN5ShsJk46rW3uYqkdQekrQ+/1ZZxq7DP2Vhr/yzCmmEhRlZ3jQwg9ekhHivT8dq1HneBVgKUN1pn48Fuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716460524; c=relaxed/simple;
	bh=Fgf6odqCeSEJhq7ShJB0xxt6qYihivnoTkpdEB7BfMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kv8gblbUSgIq03H4fkXL/8sF4WFLZV4SomZwF3DwI5H6G+UvpWY5qxxPKXf7hiCWw/mpqO6hkyRNTB2gU1bCAqOTfq3PE4LxDRujtzSETKg/WMZ3coiuHiy6D0HS8RijvZDSN/MwpLo5EMK0QeWJtbektgq/8zxNcysVgDHq0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSbr3YC6; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716460523; x=1747996523;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Fgf6odqCeSEJhq7ShJB0xxt6qYihivnoTkpdEB7BfMs=;
  b=hSbr3YC6FpiVkkKj68AM5XWHYC2TLUA9a1LOIjMmTeVKSxt0jm2sFo/n
   DA7/l8weSeAv0g9fS0W97jLWGo5aeMWgPAR37IcjKglWmSFmDIuyrKyya
   J33/qIuzIWQZPhm4XdOJDZn0uQdqsX+Nafr6CPnP4o+GuFSgci/qapdiU
   zJdVrwroxdh3CXEVdpA/NLCyN/38Rgy6jqaBHxXJSlo89bjGBh2vjWXZZ
   Hw2ki8QcGBrMd53BwKXCg0u3REZ7O2JrT81FQCWQ9VmVn6QjQemHXwu75
   7d+LdbnpdenYovN8owXqLgzVIFJdNH2HduFgx5oXsy7fApbhBFQztjmuY
   g==;
X-CSE-ConnectionGUID: dj8HDqARQ+CvEsXJlKvQQA==
X-CSE-MsgGUID: fuAuZUbNREym/plHNdg+dg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="16594454"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="16594454"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 03:35:22 -0700
X-CSE-ConnectionGUID: E5BnD6BMQ7CvWr+qLZ/DNw==
X-CSE-MsgGUID: 8mqndPSkQ/ur6uWkSrvZwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="38458164"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa005.jf.intel.com with ESMTP; 23 May 2024 03:35:19 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 29CAE3D1; Thu, 23 May 2024 13:35:17 +0300 (EEST)
Date: Thu, 23 May 2024 13:35:17 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <icnsupynjfh6p7ld7yungwzbplvelfue73ii6m7szezg6ryd46@5owux6sevg2w>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
 <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
 <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>
 <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>

On Fri, May 17, 2024 at 07:25:01PM +0300, Kirill A. Shutemov wrote:
> On Fri, May 17, 2024 at 05:00:19PM +0200, Jürgen Groß wrote:
> > On 17.05.24 16:53, Kirill A. Shutemov wrote:
> > > On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
> > > > On 17.05.24 16:32, Kirill A. Shutemov wrote:
> > > > > On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
> > > > > > @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
> > > > > >    	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> > > > > > +	/*
> > > > > > +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
> > > > > > +	 * always work around it.  Query the feature.
> > > > > > +	 */
> > > > > > +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
> > > > > > +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
> > > > > 
> > > > > I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
> > > > > be here.
> > > > 
> > > > No, I don't think so.
> > > > 
> > > > With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
> > > > problem in case the seamcall is clobbering it.
> > > 
> > > Could you check setup_tdparams() in your tree?
> > > 
> > > Commit
> > > 
> > > [SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility
> > > 
> > > in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.
> > > 
> > > I now remember there was problem in EDK2 using RBP. So the patch is
> > > temporary until EDK2 is fixed.
> > > 
> > 
> > I have the following line in setup_tdparams() (not commented out):
> > 
> > 	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
> 
> Could you check if it is visible from the guest side?

Jürgen, have you tried it?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

