Return-Path: <kvm+bounces-11936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C73E787D471
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:24:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62444B215D1
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 19:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A376524CE;
	Fri, 15 Mar 2024 19:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YlG5MGOO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31E61DA26;
	Fri, 15 Mar 2024 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710530632; cv=none; b=qwvGbh3Fgis1YtNNSgFvAO5sdefczAwVwHBBYwpGynhh+MREWU9VqpCy9dWL1DYTNTEB7Dhs+zxavBqDwo/vHB91qDn9iLiGoCDm9KEK6lrjNWnk11N25fBB+ZT5SnKVoXALWMgpR7N2WYPrSs8wSAuQ0zVidLgls8YMPaz1JSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710530632; c=relaxed/simple;
	bh=WhqqqLSJmcb/1xXuOSj7PUdueHYKSnEzIPiYeLM9uhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xajjem4Sn5SDXeK/M6Ij4z+CbQnKfk+mHimm0a4PjOP9yD3xLrBi44+sPNPSGVMkJVFX9g5Ma2Nh5cIyAOkcmz6FhLXop0ASTV3UQsXju5uox1D1eZKVkJAfRC/K9UUhszAdVMJBOT2e/mrZJXcONYVdmxEAHwnOvawhc0CRN7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YlG5MGOO; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710530628; x=1742066628;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WhqqqLSJmcb/1xXuOSj7PUdueHYKSnEzIPiYeLM9uhA=;
  b=YlG5MGOO+t3V5rPC06om480XehNCBeqI5eRh9SMPXaYRACo2ALLPXxEX
   n0bXYP+cBoLwrw3vK29aPV08mr43EgzA2Ys3EmLnHP9o7gxxHXYt8kCX+
   8NolmtQ0U2GP4SJ607hY1NRYDj89WRN+7FNiA3naoUs+7h316pMvWBNrF
   Vvx6M/IfTE3q8uNiX6E3lbFeeM8daN4A8//TcfOx4de0rNEDan00XTKQM
   7O1mzixlb2io4pVRIlC3WWKQUUjyUUa2VczdLnRj/iK1x8yn8DrCUmtGA
   V95nuy4MrMFx76wLhWcZr4pHsZzTpGRsc6zcCyrLX7mvgyVw/pd5Xd/QL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5626995"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="5626995"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 12:23:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="13171747"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 12:23:48 -0700
Date: Fri, 15 Mar 2024 12:23:46 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240315192346.GH1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <ZfSISAC0sIYXewqG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfSISAC0sIYXewqG@google.com>

On Fri, Mar 15, 2024 at 10:41:28AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> > +			       struct tdx_module_args *out)
> > +{
> > +	u64 ret;
> > +
> > +	if (out) {
> > +		*out = *in;
> > +		ret = seamcall_ret(op, out);
> > +	} else
> > +		ret = seamcall(op, in);
> > +
> > +	if (unlikely(ret == TDX_SEAMCALL_UD)) {
> > +		/*
> > +		 * SEAMCALLs fail with TDX_SEAMCALL_UD returned when VMX is off.
> > +		 * This can happen when the host gets rebooted or live
> > +		 * updated. In this case, the instruction execution is ignored
> > +		 * as KVM is shut down, so the error code is suppressed. Other
> > +		 * than this, the error is unexpected and the execution can't
> > +		 * continue as the TDX features reply on VMX to be on.
> > +		 */
> > +		kvm_spurious_fault();
> > +		return 0;
> 
> This is nonsensical.  The reason KVM liberally uses BUG_ON(!kvm_rebooting) is
> because it *greatly* simpifies the overall code by obviating the need for KVM to
> check for errors that should never happen in practice.  On, and 
> 
> But KVM quite obviously needs to check the return code for all SEAMCALLs, and
> the SEAMCALLs are (a) wrapped in functions and (b) preserve host state, i.e. we
> don't need to worry about KVM consuming garbage or running with unknown hardware
> state because something like INVVPID or INVEPT faulted.
> 
> Oh, and the other critical aspect of all of this is that unlike VMREAD, VMWRITE,
> etc., SEAMCALLs almost always require a TDR or TDVPR, i.e. need a VM or vCPU.
> Now that we've abandoned the macro shenanigans that allowed things like
> tdh_mem_page_add() to be pure translators to their respective SEAMCALL, I don't
> see any reason to take the physical addresses of the TDR/TDVPR in the helpers.
> 
> I.e.  if we do:
> 
> 	u64 tdh_mng_addcx(struct kvm *kvm, hpa_t addr)
> 
> then the intermediate wrapper to the SEAMCALL assembly has the vCPU or VM and
> thus can precisely terminate the one problematic VM.
> 
> So unless I'm missing something, I think that kvm_spurious_fault() should be
> persona non grata for TDX, and that KVM should instead use KVM_BUG_ON().

Thank you for the feedback.  As I don't see any issues to do so, I'll convert
those wrappers to take struct kvm_tdx or struct vcpu_tdx, and eliminate
kvm_spurious_fault() in favor of KVM_BUG_ON().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

