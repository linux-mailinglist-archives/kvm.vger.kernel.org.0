Return-Path: <kvm+bounces-9956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96EAA867F87
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C68381C2BA94
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAB412EBF3;
	Mon, 26 Feb 2024 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KiDWBdZX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2709612DD87;
	Mon, 26 Feb 2024 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708970791; cv=none; b=Q/gCo3ADTUv1GSJiYbztCcQ/s+Dy7Lwti2xoErni0YNIIQicqVhVlkdPb2opfl5OwJpkTQ9NCpJuZr07PyhpSx9Wn178JjqCFNpV6clzUFWYBq8/p+gyfVdVQg4Nky34DQ9UZHbsBTmUtgtY4/MMFT1FLr6DvfrBbrwsGfnaoPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708970791; c=relaxed/simple;
	bh=+qKKWlBc2Z+IVbGPagJK6EFTeqoeC1JGKYkeOHNof0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4oyINpTQ4sjIELdypNVuF38yBF8n5vlGMaLQJGam7i50dTw0/0SdtDkAqyXAEE1oYPn1wWvjbJoJBXt64mipGtXgJacRpG5tVTQQaC48NpC8ovVSu/QDSJNqrKHI9mFIvJvviSunwWRDvZ+LCfFdar7DMJLK8mPlBdfHLQUFDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KiDWBdZX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708970789; x=1740506789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+qKKWlBc2Z+IVbGPagJK6EFTeqoeC1JGKYkeOHNof0w=;
  b=KiDWBdZXPqTE/Y4lmu3/uJ6B1hf1y4N9S5tdBbpuKOHLjicnIIe10K95
   RO3QsMtGkMxsiL1TLTEanGer52LlP4WObOCAoZxWVVHcLKtcTanUtVle/
   XWB/HHBXHl6nP7wqYlW35KHat0c2J+h7X2T8GKEakYiAgVv00C8XSJeRU
   cmCmQJ8JTs2HR87lh5Q7b4o4UQ1sJXxEUbB/asXxC+AbkQH/G71gFW4LG
   mI1csxQa9d4cJj4H5XRYvZFDrEgD2i03BC/OZ7svj9WfzPUBcVCl0WaPx
   UrwqPqKYeStAH6gxx2geGciIp9w1U5pCjYo6ypDWy1DRTtJt7GAV47mC1
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="13981897"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="13981897"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:06:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11532248"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:06:27 -0800
Date: Mon, 26 Feb 2024 10:06:26 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Chao Gao <chao.gao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 044/121] KVM: x86/mmu: Assume guest MMIOs are shared
Message-ID: <20240226180626.GE177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <cce34006a4db0e1995ce007c917f834b117b12af.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfbZRO3yiXoHAoHSsBp4sKQY9r4GTLt-SRqevz2c8wOqbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbZRO3yiXoHAoHSsBp4sKQY9r4GTLt-SRqevz2c8wOqbQ@mail.gmail.com>

On Mon, Feb 12, 2024 at 11:29:51AM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Jan 23, 2024 at 12:55 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Chao Gao <chao.gao@intel.com>
> >
> > Guest TD doesn't necessarily invoke MAP_GPA to convert the virtual MMIO
> > range to shared before accessing it.  When TD tries to access the virtual
> > device's MMIO as shared, an EPT violation is raised first.
> > kvm_mem_is_private() checks whether the GFN is shared or private.  If
> > MAP_GPA is not called for the GPA, KVM thinks the GPA is private and
> > refuses shared access, and doesn't set up shared EPT entry.  The guest
> > can't make progress.
> >
> > Instead of requiring the guest to invoke MAP_GPA for regions of virtual
> > MMIOs assume regions of virtual MMIOs are shared in KVM as well (i.e., GPAs
> > either have no kvm_memory_slot or are backed by host MMIOs). So that guests
> > can access those MMIO regions.
> 
> I'm not sure how the patch below deals with host MMIOs?

It falls back to shared case to hit KVM_PFN_NOSLOT. It will be handled as
MMIO.

Anyway I found it breaks SW_PROTECTED case.  So I came up with the following.
I think we'd like to handle as
  - SW_PROTECTED => KVM_EXIT_MEMORY_FAULT
  - SNP, TDX => MMIO.
  


-       if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+       /*
+        * !fault->slot means MMIO for SNP and TDX.  Don't require explicit GPA
+        * conversion for MMIO because MMIO is assigned at the boot time.  Fall
+        * to !is_private case to get pfn = KVM_PFN_NOSLOT.
+        */
+       force_mmio = !slot &&
+               vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM &&
+               vcpu->kvm->arch.vm_type != KVM_X86_SW_PROTECTED_VM;
+       if (!force_mmio &&
+           fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
                kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
                return -EFAULT;
        }
 
-       if (fault->is_private)
+       if (!force_mmio && fault->is_private)
                return kvm_faultin_pfn_private(vcpu, fault);

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

