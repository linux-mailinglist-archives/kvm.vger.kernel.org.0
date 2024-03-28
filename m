Return-Path: <kvm+bounces-12954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAA988F60C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BED41C23AE6
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A5332C9C;
	Thu, 28 Mar 2024 03:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ImyjkFsG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58128DD1
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711597679; cv=none; b=dp3kHAsKpg870n9RQl5mvgXG/s/BfbqMUGbgHmfyLvy22yKMDBvIQfSGuo3357MkLAnUoGPXlbywHkzow26tvLONPbPZnEHWHhLDvE94IcF2pNBUlsI0OQSlWBwGlIETGYPl7cm3CJ1+UG1X2yJl2NEoKI4EXg4n2u4Y/Kyh6pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711597679; c=relaxed/simple;
	bh=CZmyMDYmLGJt1aVeM7GMIos7pinDxlgS7ivSaGO4u00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGNGje3b3o1H2ccnyHbnn+V4Scrihu98oX02BHs+vFz0fSrU3SwAnTfg/DgSHcWR4UlB/PO0Tvu2fmRa4TbFNuMThwsCsRHSvGxVDVlHHpoevisvpofkQUl1JlTaMEaWVfGNKDAwmh3sIH8C5f7E2TUiytij0TLkck4Q+14Utls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ImyjkFsG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711597677; x=1743133677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CZmyMDYmLGJt1aVeM7GMIos7pinDxlgS7ivSaGO4u00=;
  b=ImyjkFsGoJnduxMpgo6tMAR8ftDSAMwmm8pwUE3n144++QiTqNYEVJq+
   33BR7GS+Es/3zY+um8oecBUXts2GwDK6irr2unqkjjVxhtrPmSNtgN68U
   0lNAJNJ9Mw4t4b+PyjUH9qbmwMTKbboYd8FZfx8+XVmV4xUVFLinR+CYI
   I6X/mRoS8ov693fTMKbyu7km/u61DbVMvCqBU1GgNvRbd9wyysa7um1LL
   7E6NPldTuk5Emg8TyETzC+2CZBS5WCT0j4JAt013pvUUKMsECJRdUi4K0
   EmoUhkWAcvqEYmus/B8Id9OjPyB2s3wUdJMGKLAGZJf8z5IMYqx/VISTI
   Q==;
X-CSE-ConnectionGUID: mVmscYw1TPuA4isp8yF5yA==
X-CSE-MsgGUID: Lcjsim5jR8KecKAUhl7E2Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6597090"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6597090"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:47:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16538537"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 27 Mar 2024 20:47:54 -0700
Date: Thu, 28 Mar 2024 12:01:49 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, devel@lists.libvirt.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH-for-9.1 v2 20/21] target/i386: Remove
 X86CPU::kvm_no_smi_migration field
Message-ID: <ZgTrrZVam/hEdcU0@intel.com>
References: <20240327095124.73639-1-philmd@linaro.org>
 <20240327095124.73639-21-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240327095124.73639-21-philmd@linaro.org>

On Wed, Mar 27, 2024 at 10:51:22AM +0100, Philippe Mathieu-Daudé wrote:
> Date: Wed, 27 Mar 2024 10:51:22 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH-for-9.1 v2 20/21] target/i386: Remove
>  X86CPU::kvm_no_smi_migration field
> X-Mailer: git-send-email 2.41.0
> 
> X86CPU::kvm_no_smi_migration was only used by the
> pc-i440fx-2.3 machine, which got removed. Remove it
> and simplify kvm_put_vcpu_events().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/cpu.h     | 3 ---
>  target/i386/cpu.c     | 2 --
>  target/i386/kvm/kvm.c | 7 +------
>  3 files changed, 1 insertion(+), 11 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


