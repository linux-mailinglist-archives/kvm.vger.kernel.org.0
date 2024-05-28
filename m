Return-Path: <kvm+bounces-18199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 959548D1620
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 10:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01A161F25155
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 08:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21E913C3ED;
	Tue, 28 May 2024 08:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eofvSYDU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6D6F079;
	Tue, 28 May 2024 08:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716884372; cv=none; b=lbVRV5zQ8Gegmv2kUbphfOSN46dy5/nh4TZGDx6rG6l42uT58owvCWNrpxhk2z7lf/BSjAN0zpApfHe/iXQyw7Z+gw9O02dIhn5Cgv4Rjn3CZsJT2foUzy0t8TOXy5q0u0FW7iQjkEyj1L35WxTHaAMk45SlMNUsXvCRuX9Yu1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716884372; c=relaxed/simple;
	bh=Oc8QGTkURsUqafymwekWRoZjg0nWpLr6CloEAujioeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3XRWB1jQh7Rr1LijYNt3raJZdI76yffu/bhmGmJdkXK6alGFZKpnWeLhVgQoiVW/2kiDU+WrgSj2kpbKX9+lt9CCBeYzH11ifCmrpDfvKmHIypxFW5rtR4dLcEbffYnDgOlHh/Lz6l9bB/wXoZSg4igukMuSO8sKKeE/jwzyDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eofvSYDU; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716884370; x=1748420370;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Oc8QGTkURsUqafymwekWRoZjg0nWpLr6CloEAujioeo=;
  b=eofvSYDUCqV0gy9K7Ts8XC56NPW2jgklP5h2qW8GWL2IRzl4z7r6HQCU
   9BCi+AilaDIT1T5O2HMGle5HtBA3OW4U9wvt+Zl0KMhiDuo2cHFKqqh2D
   i/z75ky+ARBd/OqAV7M8Lwc4rSB0wRmyuFaFCLS6Me+cj5xrF5zM7IgTo
   AscibwGak8WuNYDBIOffcDkN+OMicnptXiV5zZGeieN+TQl2RUIOKw/Wu
   Gx+Zdrz1jYXfn6GizZrnEb5+7ViNiuTG3T7HC8Rk59dQ8QZQuKGfKEIIE
   6Kgp1Hng4QJiyng9XXPE28lg+ctbmmaR57wokdtsArxDi8OvOx45m8l5d
   g==;
X-CSE-ConnectionGUID: 00mZGMnuTvadWRGpV41Uag==
X-CSE-MsgGUID: taHGjtM5QhekTMkO36HPvQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="11723371"
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="11723371"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 01:19:29 -0700
X-CSE-ConnectionGUID: EW6srXeGSdGt2Mn9vIXugg==
X-CSE-MsgGUID: mC0outMrRpiGofdXme4ReA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="35071106"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa009.fm.intel.com with ESMTP; 28 May 2024 01:19:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id B751B184; Tue, 28 May 2024 11:19:25 +0300 (EEST)
Date: Tue, 28 May 2024 11:19:25 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	Sean Christopherson <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>, 
	"Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>, 
	"Li, Xiaoyao" <Xiaoyao.Li@intel.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <fagj35jsiktyxegcyb6jujq2tkwzgnvqjfebka2eybdmzhpxej@m4ycvcqow5kt>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <46mh5hinsv5mup2x7jv4iu2floxmajo2igrxb3haru3cgjukbg@v44nspjozm4h>
 <de344d2c-6790-49c5-85be-180bc4d92ea4@suse.com>
 <etso5bvvs2gq3parvzukujgbatwqfb6lhzoxhenrapav6obbgl@o6lowhrcbucp>
 <e8b36230-d59f-44f1-ba48-5a0533238d8e@suse.com>
 <pfbphwefaefxw2l2u26qr6ptq7rtdmnihjmxvk34zv4srlnsum@qyjumzzdnfxo>
 <46713df6-d73e-4816-bbda-a3b2dc723438@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46713df6-d73e-4816-bbda-a3b2dc723438@intel.com>

On Fri, May 24, 2024 at 11:37:15AM +1200, Huang, Kai wrote:
> 
> 
> On 18/05/2024 4:25 am, Kirill A. Shutemov wrote:
> > On Fri, May 17, 2024 at 05:00:19PM +0200, Jürgen Groß wrote:
> > > On 17.05.24 16:53, Kirill A. Shutemov wrote:
> > > > On Fri, May 17, 2024 at 04:37:16PM +0200, Juergen Gross wrote:
> > > > > On 17.05.24 16:32, Kirill A. Shutemov wrote:
> > > > > > On Mon, Feb 26, 2024 at 12:25:41AM -0800, isaku.yamahata@intel.com wrote:
> > > > > > > @@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
> > > > > > >     	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
> > > > > > > +	/*
> > > > > > > +	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
> > > > > > > +	 * always work around it.  Query the feature.
> > > > > > > +	 */
> > > > > > > +	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
> > > > > > > +	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
> > > > > > 
> > > > > > I think it supposed to be IS_ENABLED(CONFIG_FRAME_POINTER). "!" shouldn't
> > > > > > be here.
> > > > > 
> > > > > No, I don't think so.
> > > > > 
> > > > > With CONFIG_FRAME_POINTER %rbp is being saved and restored, so there is no
> > > > > problem in case the seamcall is clobbering it.
> > > > 
> > > > Could you check setup_tdparams() in your tree?
> > > > 
> > > > Commit
> > > > 
> > > > [SEAM-WORKAROUND] KVM: TDX: Don't use NO_RBP_MOD for backward compatibility
> > > > 
> > > > in my tree comments out the setting TDX_CONTROL_FLAG_NO_RBP_MOD.
> > > > 
> > > > I now remember there was problem in EDK2 using RBP. So the patch is
> > > > temporary until EDK2 is fixed.
> > > > 
> > > 
> > > I have the following line in setup_tdparams() (not commented out):
> > > 
> > > 	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
> > 
> > Could you check if it is visible from the guest side?
> > 
> > It is zero for me.
> > 
> > diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
> > index c1cb90369915..f65993a6066d 100644
> > --- a/arch/x86/coco/tdx/tdx.c
> > +++ b/arch/x86/coco/tdx/tdx.c
> > @@ -822,13 +822,33 @@ static bool tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
> >   	return true;
> >   }
> > +#define TDG_VM_RD			7
> > +
> > +#define TDCS_CONFIG_FLAGS		0x1110000300000016
> > +
> 
> Hi Kirill,
> 
> Where did you get this metadata field ID value from?  I assume you meant
> below one, from which the ID is 0x9110000300000016?

The ID has changed in recent JSON ABI definitions. Looks fishy. I will
find out what is going on.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

