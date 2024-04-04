Return-Path: <kvm+bounces-13514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4672897D63
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 03:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64982B221D5
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 01:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE62312B82;
	Thu,  4 Apr 2024 01:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IGQ4Zx1K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A37DDA3;
	Thu,  4 Apr 2024 01:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712194049; cv=none; b=Jngrj11dZx4ziX2Z+QP+s2VVJfk6tzKQp/WLW0Vk3EQ4qAScdKsCfU39fuFDuYV9i/KzZN1QITCS6YL/uJZ8/F7ucRtjS2VJo96uVkl3jJ0jfgaWXJ1ZrX7ZM6r5h/OxQXKxToCi/9GBjM9s8MAJvAHmUaq06kISYKzmGgLzoVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712194049; c=relaxed/simple;
	bh=zQZjF7w3cEt0YI/Qk6JRvDqqTu9qoiRVS2jKtLljvxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSztgCoRhxPeoRp98XxaZn6ze2SLA/2uU81njpvHFaN8jhplN4ONVA6A2HOxidf+BbOhJePtbZwokcR4aETK8yg1TnYCp2upBoJXER7iMl8gLsC1Dj2Th7jLTOl/e8XHbMRq6L5qeXZBKvwWfK/rURZgJTKkECKF117xlfdW1qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IGQ4Zx1K; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712194047; x=1743730047;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zQZjF7w3cEt0YI/Qk6JRvDqqTu9qoiRVS2jKtLljvxs=;
  b=IGQ4Zx1KANRew4D3j/+shAdf2wKH1mubrpjIKuVWx1Fu63ohowSZmrXS
   5Zz+ONfO5As/igM5uMlQv7NmyGXmwJOpdhlEoy/naYgq4IQyTRz28yU7m
   7knwxxz6Lk776aqfjGHfouznROaDFJmHAgTteaJwHG2BmiomA3gl2MBOV
   qRw7OVHUHkcjsUUiB8X1okyX0zhbquyGDS9bmJTdtpV+hWqmRkw/qlhuJ
   JR7xMAixF/0bWx2974FaG3pl2W40LDfViKeF7ilvUKSJHvAQNN0LshFFK
   ZOokZCInHnF31y9o34fqaxiblQqF42IToFOKHo9PJXsvVN8kEdH0oEySF
   A==;
X-CSE-ConnectionGUID: Xq+9TEclQlqODQcvgoY5Ig==
X-CSE-MsgGUID: BoAadz6oRcubYl7VtPZUCQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="18617553"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18617553"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:27:27 -0700
X-CSE-ConnectionGUID: +Ef9LtV/RDO3JPODnsDAZg==
X-CSE-MsgGUID: OCx6VRZBQjiMhvy88lLLnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="19077990"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:27:26 -0700
Date: Wed, 3 Apr 2024 18:27:26 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
Message-ID: <20240404012726.GP2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
 <ZgvHXk/jiWzTrcWM@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgvHXk/jiWzTrcWM@chao-email>

On Tue, Apr 02, 2024 at 04:52:46PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> >+{
> >+	unsigned long nr, a0, a1, a2, a3, ret;
> >+
> 
> do you need to emulate xen/hyper-v hypercalls here?


No. kvm_emulate_hypercall() handles xen/hyper-v hypercalls,
__kvm_emulate_hypercall() doesn't.

> Nothing tells userspace that xen/hyper-v hypercalls are not supported and
> so userspace may expose related CPUID leafs to TD guests.
> 
> >+	/*
> >+	 * ABI for KVM tdvmcall argument:
> >+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
> >+	 * Non-zero leaf number (R10 != 0) is defined to indicate
> >+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
> >+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
> >+	 * number.
> >+	 *
> >+	 * R10: KVM hypercall number
> >+	 * arguments: R11, R12, R13, R14.
> >+	 */
> >+	nr = kvm_r10_read(vcpu);
> >+	a0 = kvm_r11_read(vcpu);
> >+	a1 = kvm_r12_read(vcpu);
> >+	a2 = kvm_r13_read(vcpu);
> >+	a3 = kvm_r14_read(vcpu);
> >+
> >+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true, 0);
> >+
> >+	tdvmcall_set_return_code(vcpu, ret);
> >+
> >+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> >+		return 0;
> 
> Can you add a comment to call out that KVM_HC_MAP_GPA_RANGE is redirected to
> the userspace?

Yes, this is confusing.  We should refactor kvm_emulate_hypercall() more so that
the caller shouldn't care about the return value like this.  Will refactor it
and update this patch.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

