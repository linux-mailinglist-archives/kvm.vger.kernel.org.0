Return-Path: <kvm+bounces-12968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9898088F7E3
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 07:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3E1A1C22D46
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585A921101;
	Thu, 28 Mar 2024 06:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/W6kNgt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EFC3DABF2
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 06:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711607504; cv=none; b=AWG4KsE4f4IUH/vkuAtBjZnki+pryKAw5gmA9pnHLwmOT95JKj3VaeyNq0kWU2q6zvCyHS1CUJv9mSpJePHuuZocSWUETIPW4gIB9EjNMiXcAUqKO247/YDJcAJ36XKXgGVGVGfvzP+uDRDIVzvz4f19cRARct54gn2tqx44AMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711607504; c=relaxed/simple;
	bh=ya2nFRIyAOQJ0gCXxwKPx/um0va6AQwIyofwmLWNp/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVU/XVnhIpkbV/RQwbrdbhlysJp0qVRCRL8c84xcT4Iiw1vVV3zlnw3++5RPQ89WK1nXP8Q9Z+WOkujawNd+l5siefbmnLO3Px/4MHNxsBIgW4Ob08eP8xbNLmddeiBwXhGcAu7atCNMPBmYIER8Gkp+oTIyji/KPkGFvHzoVOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/W6kNgt; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711607503; x=1743143503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ya2nFRIyAOQJ0gCXxwKPx/um0va6AQwIyofwmLWNp/4=;
  b=b/W6kNgt5eP22lTCMFknZRnexhZUf4Hzwnjd2UXm3oG3Qg49xYBfPPNv
   zefOF6gKlpH5qZtxhnJavCC8lsxCvSEgTW7juH82kHGseDHZvVIEpArBW
   r6eJUa20hrzNXeNSLEtjGWcXN090/mCY7+27W2ej0F4ReFGLYFzp94Ndx
   mhbsG1wnm6HLR3k0FF2BxODVdl3PmPZQnrBZ2FLwouo8OclrpS+osTuNi
   1bl7cg2XNJJpcLDevkE5TK0uvyUrsu65pdGA0m01nu7hljtjZD6hYya3j
   RD2JKIBPV41PzK6mv7ckI5SZUm2LWCY1dkQI5Crs8yXuHNttRMlGwU2/1
   w==;
X-CSE-ConnectionGUID: nBNy17luQEuTlWkWz2jbhg==
X-CSE-MsgGUID: cH6e2nZHQcyGDHseL2Nb8A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6856716"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6856716"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 23:31:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16951517"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 27 Mar 2024 23:31:39 -0700
Date: Thu, 28 Mar 2024 14:45:35 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, devel@lists.libvirt.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH-for-9.1 v2 08/21] target/i386/kvm: Remove
 x86_cpu_change_kvm_default() and 'kvm-cpu.h'
Message-ID: <ZgUSD6Zw0Unp+1Te@intel.com>
References: <20240327095124.73639-1-philmd@linaro.org>
 <20240327095124.73639-9-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240327095124.73639-9-philmd@linaro.org>

On Wed, Mar 27, 2024 at 10:51:10AM +0100, Philippe Mathieu-Daudé wrote:
> Date: Wed, 27 Mar 2024 10:51:10 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH-for-9.1 v2 08/21] target/i386/kvm: Remove
>  x86_cpu_change_kvm_default() and 'kvm-cpu.h'
> X-Mailer: git-send-email 2.41.0
> 
> x86_cpu_change_kvm_default() was only used out of kvm-cpu.c by
> the pc-i440fx-2.1 machine, which got removed. Make it static,
> and remove its declaration. "kvm-cpu.h" is now empty, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Message-Id: <20240305134221.30924-8-philmd@linaro.org>
> ---
>  target/i386/kvm/kvm-cpu.h | 41 ---------------------------------------
>  target/i386/kvm/kvm-cpu.c |  3 +--
>  2 files changed, 1 insertion(+), 43 deletions(-)
>  delete mode 100644 target/i386/kvm/kvm-cpu.h
> 
> diff --git a/target/i386/kvm/kvm-cpu.h b/target/i386/kvm/kvm-cpu.h
> deleted file mode 100644
> index e858ca21e5..0000000000
> --- a/target/i386/kvm/kvm-cpu.h
> +++ /dev/null
> @@ -1,41 +0,0 @@
> -/*
> - * i386 KVM CPU type and functions
> - *
> - *  Copyright (c) 2003 Fabrice Bellard
> - *
> - * This library is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU Lesser General Public
> - * License as published by the Free Software Foundation; either
> - * version 2 of the License, or (at your option) any later version.
> - *
> - * This library is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * Lesser General Public License for more details.
> - *
> - * You should have received a copy of the GNU Lesser General Public
> - * License along with this library; if not, see <http://www.gnu.org/licenses/>.
> - */
> -
> -#ifndef KVM_CPU_H
> -#define KVM_CPU_H
> -
> -#ifdef CONFIG_KVM
> -/*
> - * Change the value of a KVM-specific default
> - *
> - * If value is NULL, no default will be set and the original
> - * value from the CPU model table will be kept.
> - *
> - * It is valid to call this function only for properties that
> - * are already present in the kvm_default_props table.
> - */
> -void x86_cpu_change_kvm_default(const char *prop, const char *value);

Features in kvm_default_props[] are supposed to be supported on the
oldest kernal version (v4.5, from docs/system/target-i386.rst).

So future PC machines will not use this interface to adjust
compatibility with the oldest v4.5 kernel. And it makes sense to stop
exposing this interface in the header. Thus,

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


