Return-Path: <kvm+bounces-12517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA938871EE
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B77B31C22D29
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5275FDA1;
	Fri, 22 Mar 2024 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gQNFYkF5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3661CD25;
	Fri, 22 Mar 2024 17:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711129150; cv=none; b=r+frcscOmZtTi14bXBJuaSwHYKXxwEiaKb63DgFDheSwKuDgxmkdoZrMohRwafQN3AJN0SSIFOdPcG+oOJRZwRU0U9PGHiKYdDuFhkoIJk0sf40BY35rzgFj2++gL9CDn347e2178IIvgsSdet2wYoPjJUSfKoYCe1oRhxCCdR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711129150; c=relaxed/simple;
	bh=M10HBP0QHr0blsaz7VID9hCSGi9EAm/Vle9sr0Fgh0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDxry4AsDjijMgjXmzovKY2LEWfto1szHO8xd83jdBSprIsbamylKrCZEyWSWBWz97hBZMmGXnNmq33VLJFG032zV6Xs8+dVyOOmghW1Z+dzieu4iR9Qk76qRBiamSeOk568s6uuO85h3Xl7dXqgNt5dCG5ut+eUaRAtT3c/S0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gQNFYkF5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711129148; x=1742665148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=M10HBP0QHr0blsaz7VID9hCSGi9EAm/Vle9sr0Fgh0g=;
  b=gQNFYkF5NrpFsZfjyXsV25QLuNUqolNNbyAl4U5m8H1R5mca8lrEsn5f
   OWGBlPLBhXiGIOloeFY6oDoPMr357wjrioZQmk2kF/f/Qe9fph02DoJcZ
   q1K7z66Ne8o367/vbp46txGB79ms8Y2H05lNm+IUj3s7aaLp3jM5sJ0PI
   Ce0v1RTu0sfyEuyCjacZB+4qK0tGH3L1r34HNoHC33bjqRWB4s+zqm351
   AktkEV1ChoqhPJYza6QOwBCvnstS9l0D5V2fOLDV0KQjiXMcb56xCK/1j
   BzMy5vKOEta5ewflqkWqFH8HdHUSJxP2ssd0JuMp1uukgY1OuQfkoN0Oh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="17623621"
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="17623621"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 10:39:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,146,1708416000"; 
   d="scan'208";a="14986058"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 10:39:07 -0700
Date: Fri, 22 Mar 2024 10:39:06 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20240322173906.GY1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
 <0f466c5845e9d75b25392ecb5129c4e984052c1b.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f466c5845e9d75b25392ecb5129c4e984052c1b.camel@intel.com>

On Thu, Mar 21, 2024 at 11:27:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Currently, KVM VMX module initialization/exit functions are a single
> > function each.  Refactor KVM VMX module initialization functions into KVM
> > common part and VMX part so that TDX specific part can be added cleanly.
> > Opportunistically refactor module exit function as well.
> > 
> > The current module initialization flow is,
> 
> 					  ^ ',' -> ':'
> 
> And please add an empty line to make text more breathable.
> 
> > 0.) Check if VMX is supported,
> > 1.) hyper-v specific initialization,
> > 2.) system-wide x86 specific and vendor specific initialization,
> > 3.) Final VMX specific system-wide initialization,
> > 4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
> > 5.) report those sizes to the KVM common layer and KVM common
> >     initialization
> 
> Is there any difference between "KVM common layer" and "KVM common
> initialization"?  I think you can remove the former.

Ok.

> > Refactor the KVM VMX module initialization function into functions with a
> > wrapper function to separate VMX logic in vmx.c from a file, main.c, common
> > among VMX and TDX.  Introduce a wrapper function for vmx_init().
> 
> Sorry I don't quite follow what your are trying to say in the above paragraph.
> 
> You have adequately put what is the _current_ flow, and I am expecting to see
> the flow _after_ the refactor here.

Will add it.


> > The KVM architecture common layer allocates struct kvm with reported size
> > for architecture-specific code.  The KVM VMX module defines its structure
> > as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
> > struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
> 
> 	 ^vmx_kvm.
> 
> Please be more consistent on the words.
> 
> > TDX specific kvm and vcpu structures.
> 
> Is this paragraph related to the changes in this patch?
> 
> For instance, why do you need to point out we will have TDX-specific 'kvm and
> vcpu' structures?

The point of this refactoring is to make room for TDX-specific code.  The
consideration point is data size/alignment difference and VMX-dependency.
Let me re-order the sentences.


> > The current module exit function is also a single function, a combination
> > of VMX specific logic and common KVM logic.  Refactor it into VMX specific
> > logic and KVM common logic.  
> > 
> 
> [...]
> 
> > This is just refactoring to keep the VMX
> > specific logic in vmx.c from main.c.
> 
> It's better to make this as a separate paragraph, because it is a summary to
> this patch.
> 
> And in other words: No functional change intended?

Thanks for the feedback.  Here is the revised version.

KVM: x86/vmx: Refactor KVM VMX module init/exit functions

Split KVM VMX kernel module initialization into one specific to VMX in
vmx.c and one common for VMX and TDX in main.c to make room for
TDX-specific logic to fit in.  Opportunistically, refactor module exit
function as well.

The key points are data structure difference and TDX dependency on
VMX.  The data structures for TDX are different from VMX.  So are its
size and alignment.  Because TDX depends on VMX, TDX initialization
must be after VMX initialization.  TDX cleanup must be before VMX
cleanup.

The current module initialization flow is:

0.) Check if VMX is supported,
1.) Hyper-v specific initialization,
2.) System-wide x86 specific and vendor-specific initialization,
3.) Final VMX-specific system-wide initialization,
4.) Calculate the sizes of the kvm and vcpu structure for VMX,
5.) Report those sizes to the KVM-common initialization

After refactoring and TDX, the flow will be:

0.) Check if VMX is supported (main.c),
1.) Hyper-v specific initialization (main.c),
2.) System-wide x86 specific and vendor-specific initialization,
    2.1) VMX-specific initialization (vmx.c)
    2.2) TDX-specific initialization (tdx.c)
3.) Final VMX-specific system-wide initialization (vmx.c),
    TDX doesn't need this step.
4.) Calculate the sizes of the kvm and vcpu structure for both VMX and
    TDX, (main.c)
5.) Report those sizes to the KVM-common initialization (main.c)

No functional change intended.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

