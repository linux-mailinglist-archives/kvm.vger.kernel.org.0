Return-Path: <kvm+bounces-13914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63EF489CC11
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 062401F23759
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A305145356;
	Mon,  8 Apr 2024 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kG//dSCO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF44144D3F;
	Mon,  8 Apr 2024 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712602576; cv=none; b=MewELXMLK6bNRaogTCX2XXG4tOPNU8uIjEekgko7aAXPTmq/0eTc/lnZUieE1plDkLkn1sTfjx1ysXDnQTIZE54DBUL+p4l4Hd1aiE0FQSyZK/eHd88aOHxYSxQDqnIuMscZ3qNBN8C5Ll7vNcoiwMtK9z9eIOhxX3SetdGeFpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712602576; c=relaxed/simple;
	bh=GT8DmlYW4wP87a6DyCfEapNSv2ZZRQv8FnHKuwMlPMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itzTZ3HLtG8rIYlylsrePBXn3EJRH4xEToQEWAWmTFPcW7FNq93IcarX8Dka4EgO23jcDthc7uoU8y+Oix25ZR1rCmyrJku1YOlXs0kIro3mSaAaLuI6lMZqLLFZGkUqPLcpYxplzk0gZljyXjqzRYvTuwTCbCJwKbQ7aI+/DZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kG//dSCO; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712602574; x=1744138574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GT8DmlYW4wP87a6DyCfEapNSv2ZZRQv8FnHKuwMlPMk=;
  b=kG//dSCOlaC0bbY7USlueejZDVlPJ/d5rASSkTTu6UEpiBo9548pQ14l
   ai/ojCFJgtsp72BIq0H/wr8KNy5XoHSMFzATlFCHhDWQs+D+mtH8RGmi1
   JJnam49mkl7/vBYOk2fT07uk1DmQkH+8RN6PNQrGKGY5weBKXEkPgBFT/
   t1BxeZ4LqmmI/vWP1178RkEPJ8sF4WBKNLQidRIMkeUAJ4xxlkL4B5DeK
   yRkIMl1avvWYDkMwgunCg8U+iHFiNbVLacq+aeRjuVyGwRD4ThbHl3UMf
   63to/DWvO7VZGJM/mWAX32O/5r7fFVinZnJtVkyz5vO/LQ3X5tyDOvwQy
   g==;
X-CSE-ConnectionGUID: qmUW/ol0R8Svv5fxMj8mWg==
X-CSE-MsgGUID: aiGmqWLSTsmLd/t0xnb2kA==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="25342975"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="25342975"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 11:56:14 -0700
X-CSE-ConnectionGUID: 4s75vRUOSFy5s5xzZjEywQ==
X-CSE-MsgGUID: iKPoeOtZTQ+Ussm+qhsdgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="19928342"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 11:56:13 -0700
Date: Mon, 8 Apr 2024 11:56:13 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
Message-ID: <20240408185613.GX2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
 <ZgzMH3944ZaBx8B3@chao-email>
 <Zg1seIaTmM94IyR8@google.com>
 <20240404232537.GV2444378@ls.amr.corp.intel.com>
 <ZhIX7K0WK+gYtcan@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZhIX7K0WK+gYtcan@chao-email>

On Sun, Apr 07, 2024 at 11:50:04AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >> > >+	union tdx_vcpu_state_details details;
> >> > >+	struct vcpu_tdx *tdx = to_tdx(vcpu);
> >> > >+
> >> > >+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
> >> > >+		return true;
> >> > 
> >> > Question: why mp_state matters here?
> >> > >+
> >> > >+	if (tdx->interrupt_disabled_hlt)
> >> > >+		return false;
> >> > 
> >> > Shouldn't we move this into vt_interrupt_allowed()? VMX calls the function to
> >> > check if interrupt is disabled.
> >
> >Chao, are you suggesting to implement tdx_interrupt_allowed() as
> >"EXIT_REASON_HLT && a0" instead of "return true"?
> >I don't think it makes sense because it's rare case and we can't avoid spurious
> >wakeup for TDX case.
> 
> Yes. KVM differeniates "interrupt allowed" from "has interrupt", e.g.,
> 
> static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> ...
> 
> 	if (kvm_arch_interrupt_allowed(vcpu) &&
> 	    (kvm_cpu_has_interrupt(vcpu) ||
> 	    kvm_guest_apic_has_interrupt(vcpu)))
> 		return true;
> 
> 
> I think tdx_protected_apic_has_interrupt() mixes them together, which isn't
> good.

Your point is code clarity.  Ok, we can code in that way. I don't expect any
performance difference.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

