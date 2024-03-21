Return-Path: <kvm+bounces-12429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3355F88618F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D5E1C2201A
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 20:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025CA134CD4;
	Thu, 21 Mar 2024 20:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PAOtddWz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5B71332B8;
	Thu, 21 Mar 2024 20:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052513; cv=none; b=KQhtEnmMj+rlfN8Y1KKeyGQVHcE4fp+2tbT7ZUXkqTodu/Y15DRFIeuOzqRKawvKoyJEWh1jfDBwnGl2Tk+U/PtAMg7wnJhdb17FUaOZNSGeZo+GmeQBRC0sp78nFrNCEkwoU3oQYIV7J5gyBaEr622eap+QG5bMPdOoUO0kC2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052513; c=relaxed/simple;
	bh=YNdCec0+EXbFaWJzFkVG+4FcFLin1OKD7Jn+VdAoNPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JL65fi8FuHz1PcpUj3oPgnTeCq2EiOnx1bicr4YBl5CVmXZGP+YRGhXcPNpsF2yxjhBpMqZ6NaL6lHZs7T0rf0d8PxnnIrMijdPNJ5a24YONHkXafZb9BY40F2kS0KbMKVi9IFEIXS0lfVFvgqbGW1CgR72r+QI/LBX3T+tO7Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PAOtddWz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711052511; x=1742588511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YNdCec0+EXbFaWJzFkVG+4FcFLin1OKD7Jn+VdAoNPw=;
  b=PAOtddWzEvRLH1NzoPRinogWbUv+RLBYfh47Ixk/DsMYocTMlnIl4JQF
   hjOfC9uC1arKAhf3vwF0MYtiQyyPW+qoUrSDiET7c+z0++NNo6b0wchuS
   vrj7aQKcXpv/D/BA/OkM/7S1rH1BzbfyLlOL9rBUia7L94n+ygaZ3WRrh
   GMcw2qRU5BoD6OWWy65TqbTYq84Uukg5uA9HwIPVlA5B7EopWPHNUWAT2
   VXWoHnHXQIVApg00Sp8dpZ0XP/BtNzzstz88DDsGTi4tUVeLedNmmGMxa
   9xGW49Q0FdpjwJoquokiHztvtLQyqHb33nGxOkSzq6jHuG+XZ/Ipmp7nr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6686108"
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="6686108"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 13:21:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,143,1708416000"; 
   d="scan'208";a="37768692"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 13:21:50 -0700
Date: Thu, 21 Mar 2024 13:21:50 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 043/130] KVM: TDX: create/free TDX vcpu structure
Message-ID: <20240321202150.GP1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <51c4203e844159451f5a78fb18cc5bebcc38a76e.1708933498.git.isaku.yamahata@intel.com>
 <ZfuNpI1fiUr4h27+@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZfuNpI1fiUr4h27+@chao-email>

On Thu, Mar 21, 2024 at 09:30:12AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> >+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >+{
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> >+
> >+	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
> >+	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
> >+
> >+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> 
> Cannot QEMU emulate x2APIC? In my understanding, the reason is TDX module always
> enables APICv for TDs. So, KVM cannot intercept every access to APIC and forward
> them to QEMU for emulation.

You're right. Let me update it as follows.

  /*
   * TDX module always enables APICv for TDs. So, KVM cannot intercept every
   * access to APIC and forward them to user space VMM.
   */



> >+	if (!vcpu->arch.apic)
> 
> will "if (!irqchip_in_kernel(vcpu->kvm))" work? looks this is the custome for such
> a check.


It should work because kvm_arch_vcpu_create().  Will update it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

