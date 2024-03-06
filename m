Return-Path: <kvm+bounces-11132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBC3873789
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D64F1C220FC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 13:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D6E13172E;
	Wed,  6 Mar 2024 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OP8I6US4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2468C130AED
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 13:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709730854; cv=none; b=VQ4M5aiqCZZgueVxpxhTm7FWxSa+7vQYugl0C2YENhSNUY+nlEe3lYQRHTG01+Iy0tZApEd+Mo9GnLQKvIayYFoYrn28GLYAMw7RvewiNLSBlTkYP4gCSpoXlmPIWtooDEYdkOaNROL9evwy3gDwpt3WzAWEh7wtAJJDIb4DUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709730854; c=relaxed/simple;
	bh=p8ErNJLqEVurtuygwgHqoaWZ6GjvF3Rx52YwT8d3QIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3XL5ZcxwpcscOd+R4p8VQGBw3PDc889QEu6oIi7lE3iNPaqk9TiimfAII2fEKD83xyNxBzaJgHGNMPDL1oFX5JuKojVeZ2AzcT+MF/mxGWlP1u2MRZJr41r5DtdsS1zMX8toXG6zW1FQJX53gCtr+rkxT+YGmbbUj8cMK2yJ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OP8I6US4; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709730852; x=1741266852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=p8ErNJLqEVurtuygwgHqoaWZ6GjvF3Rx52YwT8d3QIc=;
  b=OP8I6US4PP78qJPlwGt3ZF++dGVhuwYAD52Msq+0TEvNDkz8KxyFGSTD
   OkS8us5dxrQIxFg1wnm16fpOCOWKAUmd8BGhSjKRbX8iMBtKGJA39gywu
   Qsht2O2sJueWldtrWQJ58a/QwycnfWoEvw63VaOGZAVkeAzVnyLCLewnS
   TAwMbJv5NdgHj75jh34Cg3lGQhuMEp/4z87aI3KLHJc0pxh3gcbvrU9wY
   1mvUeGm7Gs9KrlmrKOPyXfiNbcGgY+usQASeGOQllhFymc6GJn+06Go6q
   0PHHDazsjNbmPqYRh1/I1VQhxvsqCVb/T77eBLiOxeEzkhn3cj0HLFuru
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4493319"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="4493319"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 05:14:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="10174137"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 06 Mar 2024 05:14:07 -0800
Date: Wed, 6 Mar 2024 21:27:54 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org, David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH-for-9.1 02/18] hw/usb/hcd-xhci: Enumerate xhci_flags
 setting values
Message-ID: <ZehvWi8UhQOl3v8j@intel.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-3-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240305134221.30924-3-philmd@linaro.org>

Hi Philippe,

On Tue, Mar 05, 2024 at 02:42:04PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Tue,  5 Mar 2024 14:42:04 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH-for-9.1 02/18] hw/usb/hcd-xhci: Enumerate xhci_flags
>  setting values
> X-Mailer: git-send-email 2.41.0
> 
> xhci_flags are used as bits for QOM properties,
> expected to be somehow stable (external interface).
> 
> Explicit their values so removing any enum doesn't
> modify the other ones.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  hw/usb/hcd-xhci.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
> index 98f598382a..37f0d2e43b 100644
> --- a/hw/usb/hcd-xhci.h
> +++ b/hw/usb/hcd-xhci.h
> @@ -37,8 +37,8 @@ typedef struct XHCIEPContext XHCIEPContext;
>  
>  enum xhci_flags {
>      XHCI_FLAG_SS_FIRST = 1,
> -    XHCI_FLAG_FORCE_PCIE_ENDCAP,
> -    XHCI_FLAG_ENABLE_STREAMS,
> +    XHCI_FLAG_FORCE_PCIE_ENDCAP = 2,
> +    XHCI_FLAG_ENABLE_STREAMS = 3,
>  };
>

From the commit 290fd20db6e0 ("usb xhci: change msi/msix property
type"), the enum values were modified directly.

So it seems not necessary to bind enum type with specific value,
right?

Thanks,
Zhao



