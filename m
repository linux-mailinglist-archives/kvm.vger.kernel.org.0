Return-Path: <kvm+bounces-14933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9901D8A7CAF
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFC441C20FF9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A50B6CDA8;
	Wed, 17 Apr 2024 07:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LmWoXw03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8DB6A8A6;
	Wed, 17 Apr 2024 07:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713337368; cv=none; b=dJRBN93gRUsZ3n9Nq/XcPiB4QxPq+/CC30ouEFoP4qEH6ZS3P0Qwaz72qI15TACnLMKjjbvg653/n+zp8ageTlxxip/pkMfSI52ni+qopte9hATELoHv+zEZ0pDkt000k2c7YssgSD8AEt/XwKFFgfJhee/AR6xdY5wcf8fOQrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713337368; c=relaxed/simple;
	bh=dLoPVcJwQ4v6YYynEYCpNfdJ0/RBBYsj8Trzjrt/SXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWTG+SdqX1wQUmkgi4B3c/5L38Nf7Ql+W65lb0sTwDY/o0WR1wmtikX5YNtaDE8Z8h9pbCOLniQ5pVKrPtn+jo/MAN143I99g3u8EPgGoSi0lPapn5C/6TacoybEFPbCtZCqmd7lhU/KF8MnSMWvqq9NbSQvGowxljXQ3gC3ClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LmWoXw03; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713337363; x=1744873363;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dLoPVcJwQ4v6YYynEYCpNfdJ0/RBBYsj8Trzjrt/SXI=;
  b=LmWoXw03FbF+/DzKWnkgrT5MKCM459lDuBTpyBWlmvXny73kzudpDosN
   2hUXf7Pk7cKy2qfWSGB33CtMxORsoxvXpHRkquntZ7gs4Y3f0frsNDYdi
   jvr7Xd0cfU9DoABNFeJNeNZo+ik0J+xQxArhho1paHoSEJDhPOjJU5zGt
   LBE2UP0rxlfGj12Ag1KOeg/I7y/I+LEnC+AuWuZMAtahsej1DH25n3h35
   /6oNtWugEOr926G9SU7IwWIgvV/iKL0TQTY+QfpcUFwILC9JYHEVyVqfo
   T1ITpMZjSgEsF/jU/zGa5iCG/zrTQW4DlFnD51WIHv7WJ7guZz5zn5Yh0
   g==;
X-CSE-ConnectionGUID: 4OqYt7/sSH6a5GVHyEGI3w==
X-CSE-MsgGUID: gd4udFgiTo+SemP/XYZsJw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="26275166"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="26275166"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:02:43 -0700
X-CSE-ConnectionGUID: z2WLZqFWQCayOm5eLJmklw==
X-CSE-MsgGUID: 54JhpEPFRHGD4Jx/Ncy42g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27181095"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 00:02:41 -0700
Date: Wed, 17 Apr 2024 00:02:40 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
Message-ID: <20240417070240.GF3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
 <ZgvHXk/jiWzTrcWM@chao-email>
 <20240404012726.GP2444378@ls.amr.corp.intel.com>
 <8d489a08-784b-410d-8714-3c0ffc8dfb39@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8d489a08-784b-410d-8714-3c0ffc8dfb39@linux.intel.com>

On Wed, Apr 17, 2024 at 02:16:57PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 4/4/2024 9:27 AM, Isaku Yamahata wrote:
> > On Tue, Apr 02, 2024 at 04:52:46PM +0800,
> > Chao Gao <chao.gao@intel.com> wrote:
> > 
> > > > +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	unsigned long nr, a0, a1, a2, a3, ret;
> > > > +
> > > do you need to emulate xen/hyper-v hypercalls here?
> > 
> > No. kvm_emulate_hypercall() handles xen/hyper-v hypercalls,
> > __kvm_emulate_hypercall() doesn't.
> So for TDX, kvm doesn't support xen/hyper-v, right?
> 
> Then, should KVM_CAP_XEN_HVM and KVM_CAP_HYPERV be filtered out for TDX?

That's right. We should update kvm_vm_ioctl_check_extension() and
kvm_vcpu_ioctl_enable_cap().  I didn't pay attention to them.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

