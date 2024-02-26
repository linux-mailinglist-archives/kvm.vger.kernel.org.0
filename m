Return-Path: <kvm+bounces-9966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D7AAF868037
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8899D1F2544B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69CA12F597;
	Mon, 26 Feb 2024 18:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PzAEqCYP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5BA12E1F0;
	Mon, 26 Feb 2024 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708973896; cv=none; b=qZ0Krel7g4PJY8z3Z/wUrUWPTxBpDAO9xDQw+Hrtn401YtP8ZpmaAp8f33bB14Tl3R8/ytrtEkWRt8Kjtyy07TL/p5bcK2iuAVz0f3wbP16vR7GopAMPYZZ1++A6Cihwr+K+F9XULyNqrgJh/GtlxbBCghmH+8beKY7X/02JGpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708973896; c=relaxed/simple;
	bh=98GfyHFMzpKrK23mnt5GV5fD+sLh8aFquLTB/LhXPe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQSeZlvLhf2wJ7wFSXJ88tAMF0GmDqhyTRFqQivebtxwutDBQ/Uv/LZaCi5qac94Mhl+kfBIFX58MB11HZFPbxeWmB6GQAwF83/ZY3jMiCqg44w9TErNExl+FmCMicV0GHRMeO1avQ5GeqMMeW+Y0gCngSSZ/xeRW4wn22lzMGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PzAEqCYP; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708973894; x=1740509894;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=98GfyHFMzpKrK23mnt5GV5fD+sLh8aFquLTB/LhXPe8=;
  b=PzAEqCYPRLRVCcmqASVH01a7NHu80Pn2bYG4atkMmmoYX01MHaId4vAP
   GeReg6h/2zuqh1BRtKsTxrUNkIrzpFAMwHy+BQX351botYmqzg2y3KcFq
   bJweg/g4KTakZLe24if26JIwUn1Q/JpdF9dPzYbBXxz5bVUlANOP7T99F
   cfBMm/+sv7fbvoFpghEYX6fp8VWTSNUL8HSo3NG6DizNjuuw3zaU++MgJ
   7n6S93HNXDiuGwpvuqSvxZFumYlDpQNCddAt39oXtjv82Cn5XMSHWOsKV
   2U55rgwMvlnfpG3X28bNP36aU4DWkpb8svHJDxC6QzJ2qJT0BPdpG0KbD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3409124"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3409124"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:58:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="7302804"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 10:58:14 -0800
Date: Mon, 26 Feb 2024 10:58:13 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 029/121] KVM: TDX: create/free TDX vcpu structure
Message-ID: <20240226185813.GL177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <f857ba01c0b2ffbcc310727fd7a61599221c4f21.1705965635.git.isaku.yamahata@intel.com>
 <49f044a1-e5ab-4a3d-8d73-67fa913e2948@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <49f044a1-e5ab-4a3d-8d73-67fa913e2948@linux.intel.com>

On Thu, Jan 25, 2024 at 11:06:22AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 1c6541789c39..8330f448ab8e 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -411,6 +411,55 @@ int tdx_vm_init(struct kvm *kvm)
> >   	return 0;
> >   }
> > +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +
> > +	/*
> > +	 * On cpu creation, cpuid entry is blank.  Forcibly enable
> > +	 * X2APIC feature to allow X2APIC.
> 
> This comment is a bit confusing.
> Do you mean force x2apic here or elsewhere?
> So far, in this patch, x2apic is not forced yet.
> 
> > +	 * Because vcpu_reset() can't return error, allocation is done here.
> 
> What do you mean "allocation" here?

Now this comment is stale, I removed it as Yuan pointed out.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

