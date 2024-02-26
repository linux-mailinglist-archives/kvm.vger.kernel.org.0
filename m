Return-Path: <kvm+bounces-9953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF74867F4B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C1A81F2FB86
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9048912E1FA;
	Mon, 26 Feb 2024 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E4Btn5JY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B3712D761;
	Mon, 26 Feb 2024 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969870; cv=none; b=H/m6mrTo6caVdhK//SSXfIuc6HJiaTvSs3LxOphve3XpZXeloalg72Xk7z0LlK2iB1yG36v2hMLZISgfYD2vIpTCXb3mKhy3k4sKoloEym831YHjxpgnsFDWys1ntqT8WSjgJyMaMUCn2DBhtESFKAaU6Z28c3i4H/x1Q4kpo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969870; c=relaxed/simple;
	bh=owWO0s5BBeKOkXbuxjeZxkyZEXYg+69HBcHtLINwK3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfR1dK+nEtrE1xjTFgldZtGonzU+56X9RQavLX3SHwUZqqIyNOZ8oA0sskno1irp6yaJ75s3OXewyHrDD6CpcWZRLY6bRtWre6aqC/Fc0Cl0dVKDEBlAc4H+u2+eP+jtBgXAk5iL45zduKk4Xe7d+hnyR3SwbX95fg3LOTgEBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E4Btn5JY; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708969869; x=1740505869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=owWO0s5BBeKOkXbuxjeZxkyZEXYg+69HBcHtLINwK3I=;
  b=E4Btn5JYOllVp5f1BlE2SG1zXBwXUSlqLHohKlaOsLtjVHNtQhCOWL3T
   M91QqTTnTMPmgHaHCje5X7LLj+WZVi0P40IZlk8HpEqEAu1NSBJPXh8oA
   aj9PSVHJQU8xm/ixB0QFzNt9gyd2doonDCY/c+RpJ/pBnRL0G8a+lqJuZ
   8MJK/HvzAg32aBdfd46IsGXi2Qd6QxiKxp+LCvDzV5PxJWSNFWuP3YLov
   OHxpYYG4r2pwLA4ES5YekWQHUiWv1eHGS3+a5vDoQrLD/hayWNoFN2xnN
   yk5ipv42uRuO/5u1FXPhip1aYsX3wM68GTaiXRh8gugq61h+nVdTwytq5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="28708540"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="28708540"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:51:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="11319420"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:51:07 -0800
Date: Mon, 26 Feb 2024 09:51:07 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 002/121] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <20240226175107.GB177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <88bcf53760c42dafb14cd9a92bf4f9243f597bbe.1705965634.git.isaku.yamahata@intel.com>
 <CABgObfYo0OaSXUYjQbn188y8JOAZGzD56TabdyENXAW6_Ca0Hw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYo0OaSXUYjQbn188y8JOAZGzD56TabdyENXAW6_Ca0Hw@mail.gmail.com>

On Thu, Feb 08, 2024 at 02:30:40PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Jan 23, 2024 at 12:54 AM <isaku.yamahata@intel.com> wrote:
> >
> > From: Kai Huang <kai.huang@intel.com>
> >
> > KVM will need to make SEAMCALLs to create and run TDX guests.  Export
> > SEAMCALL functions for KVM to use.
> >
> > Also add declaration of SEAMCALL functions to <asm/asm-prototypes.h> to
> > support CONFIG_MODVERSIONS=y.
> >
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> I thought you were going to introduce builtin functions for SEAMCALLs
> needed by KVM, instead?

After I talked with Kai, I concluded to use the common function.
Probably for TDH.VP.ENTER, we'd like to use customized version to avoid
shuffling registers between struct tdx_module_args and KVM regs.  We can do it
later as optimization.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

