Return-Path: <kvm+bounces-12536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7648875C7
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 00:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFBE21C22EDA
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 23:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A6582D6B;
	Fri, 22 Mar 2024 23:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKrEU1F2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D878289E;
	Fri, 22 Mar 2024 23:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711150622; cv=none; b=s/xXAQP/wr/UfF8QGPxwmHz7VNPLCA8iGIxZ4k8sQMUjYKvT9YOX3eShdpgSU2SSwsq29Q0BFAadYbvHZpRM4QMjUjuMFmfNnEkmuA29BWrcM1fac9Vc8OprP9X52GOy54+s1Ki/bJ8qOlEXGRPCT3fRt3pzqVu/LK+VboMwaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711150622; c=relaxed/simple;
	bh=oW8x+AJ+C5MlfKPaF9F6y9Z8696R8v38jscn5m7LBqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8LC+8s7lDRiHh/RdUhqKnjBLDRSdnW9VEUjJBxnV7kidjOUp6O1V10D3nFH/A3AynOxsJzKLyYQ85rLzmpCszPPuI39e/Oonx8tUhkeSkg04anhyaBY2D+KcuVa9zHMaMdZJF0FBTpFaKoNpDX6W5nXz6jZKTR2mgLR82rgN7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKrEU1F2; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711150620; x=1742686620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oW8x+AJ+C5MlfKPaF9F6y9Z8696R8v38jscn5m7LBqk=;
  b=IKrEU1F2cS4HZHru3NqiJ7ZsQFc8D8/TgduqnkEWXmJqAM5lhHfXfYMi
   3d3OSASF5d1U2/GFN+SGMnXCZXqWkHTLGdOu/x7FvOGrIFw3W9VrS7dIm
   F8tq73CiENcltP/y0CZ7DmdkzWCtIRs7E+rwlWi2BMrFUQf+QUdZs+8yM
   yYtZu8W5M4evBEAegrdSzRINI4dyoAPfdDfXSywTtzKjjxpkj9gMAtjLA
   CkIhZXOP1Cd+Ui9hDm0fZTws4SZ40cCw3Wju22GHqgVSdprEQ71pMz5MV
   KQbw1VudGbDLVXo5wTAYa0G+iOX6Se3wMt3VoLybrRD9fEgkkPtNZvkF1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6051048"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6051048"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:36:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15094329"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 16:36:59 -0700
Date: Fri, 22 Mar 2024 16:36:58 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20240322233658.GG1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
 <9c35ecd7-e737-441a-99ff-27bda2a9b25d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c35ecd7-e737-441a-99ff-27bda2a9b25d@intel.com>

On Fri, Mar 22, 2024 at 11:10:48AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 45b2c2304491..9ea46d143bef 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -567,6 +567,32 @@ struct kvm_pmu_event_filter {
> >   #define KVM_X86_TDX_VM		2
> >   #define KVM_X86_SNP_VM		3
> > +/* Trust Domain eXtension sub-ioctl() commands. */
> > +enum kvm_tdx_cmd_id {
> > +	KVM_TDX_CAPABILITIES = 0,
> > +
> > +	KVM_TDX_CMD_NR_MAX,
> > +};
> > +
> > +struct kvm_tdx_cmd {
> > +	/* enum kvm_tdx_cmd_id */
> > +	__u32 id;
> > +	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
> > +	__u32 flags;
> > +	/*
> > +	 * data for each sub-command. An immediate or a pointer to the actual
> > +	 * data in process virtual address.  If sub-command doesn't use it,
> > +	 * set zero.
> > +	 */
> > +	__u64 data;
> > +	/*
> > +	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
> > +	 * status code in addition to -Exxx.
> > +	 * Defined for consistency with struct kvm_sev_cmd.
> > +	 */
> > +	__u64 error;
> 
> If the 'error' is for SEAMCALL error, should we rename it to 'hw_error' or
> 'fw_error' or something similar? I think 'error' is too generic.

Ok, will rename it to hw_error.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 5edfb99abb89..07a3f0f75f87 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -55,6 +55,32 @@ struct tdx_info {
> >   /* Info about the TDX module. */
> >   static struct tdx_info *tdx_info;
> > +int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
> > +{
> > +	struct kvm_tdx_cmd tdx_cmd;
> > +	int r;
> > +
> > +	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
> > +		return -EFAULT;
> 
> Add an empty line.
> 
> > +	if (tdx_cmd.error)
> > +		return -EINVAL;
> 
> Add a comment?
> 
> 	/*
> 	 * Userspace should never set @error, which is used to fill
> 	 * hardware-defined error by the kernel.
> 	 */

Sure.


> > +
> > +	mutex_lock(&kvm->lock);
> > +
> > +	switch (tdx_cmd.id) {
> > +	default:
> > +		r = -EINVAL;
> 
> I am not sure whether you should return -ENOTTY to be consistent with the
> previous vt_mem_enc_ioctl() where a TDX-specific IOCTL is issued for non-TDX
> guest.
>
> Here I think the invalid @id means the sub-command isn't valid.

vt_vcpu_mem_enc_ioctl() checks non-TDX case and returns -ENOTTY.  We know that
the guest is TD.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

