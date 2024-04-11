Return-Path: <kvm+bounces-14323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A45EF8A1F7C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31E481F2BA5B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB5F17BD4;
	Thu, 11 Apr 2024 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bbbJcrwU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D25B17BCC;
	Thu, 11 Apr 2024 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863609; cv=none; b=VTrjiahHpBfB/rU/EMg3Y6w+6XCPtViw7VauzcKvKBDWfTsJOx7kX/VbRbexyIJQdgJ0DsUgv38g2xvPZmUwZEgahh3yb/4nqG168cs5AndOUTNdFJTm4L22+sbexnBHH7okBjRXnQto9V3G7vkxxUSiWrD8pUXbpA0JO2GNGTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863609; c=relaxed/simple;
	bh=lYzenBhRaOAOZhYmtVWGKE77H2vuw/BevvWB1GfkDsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uR4H74SBpENwpF42Tn0SzUkRQTR+dMptGPwYx9FAYJuUTo8DXzu0x5i89t7CRqXFrnE0GhnVJ8ohNBERSJ3jWLF7m8t9IpgOic12n+VXkdhGqyrfgAn+K9sDESZdi1eM5tyt/ZJErUiOznEQHBXOyGQRNEwCDiypgXonbP0VhmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bbbJcrwU; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712863607; x=1744399607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=lYzenBhRaOAOZhYmtVWGKE77H2vuw/BevvWB1GfkDsQ=;
  b=bbbJcrwURsGh3T+luM+XKG5z/6FvnmrTXaJJTKt61vUWqGM2Q/MzUPNO
   OUFd/X49v5rMcVobHzAgrQPOSk5jzHgEmtjY1QKi81zuDTLQOdK76GZRD
   hPNurEQqfkXg+4TSQ6c9ymZdOeB3SXDjZ4oUnLD4KlWb5xhDpv4Z1N5xD
   ObelFYKukWNN8eMd8zmLNaefPcZlnnZ4a0pOL3zNqywdtbJD4yF0zKggU
   JF4bXImYMeRFXuzmY+PHzW1M+6OtjilslRZ9eF8dGqXYK1pvrY0Ehd5sB
   0Y7z5tXWNTHyDxeKmY0J8GfRFlS1yKx3189DWTSI0451O0wYJrcoM9PT/
   w==;
X-CSE-ConnectionGUID: L8ruqASbRPOmKIs3tnV2bQ==
X-CSE-MsgGUID: jp3f7SbxSXaMTV8qCTSu2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8406918"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="8406918"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:26:45 -0700
X-CSE-ConnectionGUID: o1xWlzYiQ8ml+zPSHeQh5Q==
X-CSE-MsgGUID: vNhKdrAqRKy39cf5wapP3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="51958107"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:26:45 -0700
Date: Thu, 11 Apr 2024 12:26:45 -0700
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
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20240411192645.GE3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
 <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>

On Mon, Apr 08, 2024 at 06:38:56PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > +static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
> > +{
> > +       const struct kvm_cpuid_entry2 *entry;
> > +       u64 guest_supported_xcr0;
> > +       u64 guest_supported_xss;
> > +
> > +       /* Setup td_params.xfam */
> > +       entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
> > +       if (entry)
> > +               guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
> > +       else
> > +               guest_supported_xcr0 = 0;
> > +       guest_supported_xcr0 &= kvm_caps.supported_xcr0;
> > +
> > +       entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
> > +       if (entry)
> > +               guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
> > +       else
> > +               guest_supported_xss = 0;
> > +
> > +       /*
> > +        * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
> > +        * and, CET support.
> > +        */
> > +       guest_supported_xss &=
> > +               (kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
> 
> So this enables features based on xss support in the passed CPUID, but these features are not
> dependent xsave. You could have CET without xsave support. And in fact Kernel IBT doesn't use it. To
> utilize CPUID leafs to configure features, but diverge from the HW meaning seems like asking for
> trouble.

TDX module checks the consistency.  KVM can rely on it not to re-implement it.
The TDX Base Architecture specification describes what check is done.
Table 11.4: Extended Features Enumeration and Execution Control

> > +
> > +       td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
> > +       if (td_params->xfam & XFEATURE_MASK_LBR) {
> > +               /*
> > +                * TODO: once KVM supports LBR(save/restore LBR related
> > +                * registers around TDENTER), remove this guard.
> > +                */
> > +#define MSG_LBR        "TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH
> > properly.\n"
> > +               pr_warn(MSG_LBR);
> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
> > +                       struct kvm_tdx_init_vm *init_vm)
> > +{
> > +       struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
> > +       int ret;
> > +
> > +       if (kvm->created_vcpus)
> > +               return -EBUSY;
> > +
> > +       if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > +               /*
> > +                * TODO: save/restore PMU related registers around TDENTER.
> > +                * Once it's done, remove this guard.
> > +                */
> > +#define MSG_PERFMON    "TD doesn't support perfmon yet. KVM needs to save/restore host perf
> > registers properly.\n"
> > +               pr_warn(MSG_PERFMON);
> 
> We need to remove the TODOs and a warn doesn't seem appropriate.

Sure, let me drop them.


> > +               return -EOPNOTSUPP;
> > +       }
> > +
> > +       td_params->max_vcpus = kvm->max_vcpus;
> > +       td_params->attributes = init_vm->attributes;
> 
> Don't we need to sanitize this for a selection of features known to KVM. For example what if
> something else like TDX_TD_ATTRIBUTE_PERFMON is added to a future TDX module and then suddenly
> userspace can configure it.
> 
> So xfam is how to control features that are tied to save (CET, etc). And ATTRIBUTES are tied to
> features without xsave support (PKS, etc).
> 
> If we are going to use CPUID for specifying which features should get enabled in the TDX module, we
> should match the arch definitions of the leafs. For things like CET whether xfam controls the value
> of multiple CPUID leafs, then we need should check that they are all set to some consistent values
> and otherwise reject them. So for CET we would need to check the SHSTK and IBT bits, as well as two
> XCR0 bits.
> 
> If we are going to do that for XFAM based features, then why not do the same for ATTRIBUTE based
> features?
> 
> We would need something like GET_SUPPORTED_CPUID for TDX, but also since some features can be forced
> on we would need to expose something like GET_SUPPORTED_CPUID_REQUIRED as well. 

I agree to reject attributes unknown to KVM.  Let's add the check.

The TDX module checks consistency between attributes, xfam, and cpuids as
described in the spec, KVM can rely on it.  When TDX module finds inconsistency
(or anything bad), it returns error as SEAMCALL error status code.  It includes
which cpuid is bad.  KVM returns it to the userspace VMM in struct
kvm_tdx_cmd.error.  We don't have to re-implement similar checks.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

