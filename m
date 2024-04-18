Return-Path: <kvm+bounces-15099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E1C68A9C8C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FBD01C22267
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A82D16D4D0;
	Thu, 18 Apr 2024 14:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="guxryueD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E3E16C455;
	Thu, 18 Apr 2024 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713449777; cv=none; b=hfP3YsgY7MnnoHDPEYxudd1jxOvLrhQPqBCBgY7j1l3VoatAtqDHcE9YqoUm9J+u231SJMkAsPL987/z9M+JBsaCUaWxlWnfOo7cjU2gTdYippGDnXBlnZ/pb33sxMIi3qtBMKsDqGhUj3Sk38RXqkJF4xSj+cuNbkxVkjamqmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713449777; c=relaxed/simple;
	bh=Nu3Gt3C5H8x5Gv/JDaM5n0VDFv+I2kYAKmcFhoJ6i1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOoAHA3IE6jpwV+sgaOBZxcphkz3rYmHgYyY1ZJFkZYMNbVusdPVP4M7mvhm/oZD7+S75x3kqa6wIcvE0DXhauOVcgP2r7tj6uc2j5riTc2iSnrE2BzPJ3Z+zBPuMOfySxNyRhfrqhuqa6Qs8+iAEfM9o5zqocovoFC/4z4RphQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=guxryueD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713449776; x=1744985776;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Nu3Gt3C5H8x5Gv/JDaM5n0VDFv+I2kYAKmcFhoJ6i1Q=;
  b=guxryueD1gc01u1br2mS1GRTXKe74tfvvX/9EOaue7xfheRJJCJQbQrJ
   wR43aKMxmMRGS48aLf+qAcEiGZKjc27BC1kZjcbev16UH7fJsW+AEa1Vi
   cUnyZFP5ohfATCRJV5+cdwINc/7y/tmhi25AuiuF7P03grNwth/tgKzb0
   9OI+PT2e24GCf5lBJMnbTQ0kSNp2+Wx8uB6w68bRgsmxmbNKVHKnMr+tv
   WPpt2eNxIrPkdnjEk+ock6drZQ4JEMpJwLbkJiQGrE4TWfCN4wUTWcW/8
   R/Hn/G9ZW8gYypueNkE/cKZNdvWkbGTrbzBIcTso2iAOSdu8/rMNr0WpQ
   g==;
X-CSE-ConnectionGUID: /G6sdc+fTcKQCyl/ama1fg==
X-CSE-MsgGUID: G7hZevIPTdmy71GJpgMBUg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19557858"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="19557858"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 07:16:16 -0700
X-CSE-ConnectionGUID: jkMwj2BORI6r4ujwIYiWqw==
X-CSE-MsgGUID: qJTtvzNOQRa3Z0Aoj3dSnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="53933646"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa002.jf.intel.com with ESMTP; 18 Apr 2024 07:16:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id EF6642F0; Thu, 18 Apr 2024 17:16:10 +0300 (EEST)
Date: Thu, 18 Apr 2024 17:16:10 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, 
	"Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"Yuan, Hang" <hang.yuan@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>

On Tue, Apr 16, 2024 at 07:45:18PM +0000, Edgecombe, Rick P wrote:
> On Wed, 2024-04-10 at 15:49 +0300, Kirill A. Shutemov wrote:
> > On Fri, Mar 15, 2024 at 09:33:20AM -0700, Sean Christopherson wrote:
> > > So my feedback is to not worry about the exports, and instead focus on
> > > figuring
> > > out a way to make the generated code less bloated and easier to read/debug.
> > 
> > I think it was mistake trying to centralize TDCALL/SEAMCALL calls into
> > few megawrappers. I think we can get better results by shifting leaf
> > function wrappers into assembly.
> > 
> > We are going to have more assembly, but it should produce better result.
> > Adding macros can help to write such wrapper and minimizer boilerplate.
> > 
> > Below is an example of how it can look like. It's not complete. I only
> > converted TDCALLs, but TDVMCALLs or SEAMCALLs. TDVMCALLs are going to be
> > more complex.
> > 
> > Any opinions? Is it something worth investing more time?
> 
> We discussed offline how implementing these for each TDVM/SEAMCALL increases the
> chances of a bug in just one TDVM/SEAMCALL. Which could making debugging
> problems more challenging. Kirill raised the possibility of some code generating
> solution like cpufeatures.h, that could take a spec and generate correct calls.
> 
> So far no big wins have presented themselves. Kirill, do we think the path to
> move the messy part out-of-line will not work?

I converted all TDCALL and TDVMCALL leafs to direct assembly wrappers.
Here's WIP branch: https://github.com/intel/tdx/commits/guest-tdx-asm/

I still need to clean it up and write commit messages and comments for all
wrappers.

Now I think it worth the shot.

Any feedback?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

