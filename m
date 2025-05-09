Return-Path: <kvm+bounces-46042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4D7AB0EBC
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBE0A1C260A0
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18C328136B;
	Fri,  9 May 2025 09:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ngP+yMnL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A8F2749CA
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782255; cv=none; b=Sd3rWa2P2j2k8rtVDcbKs4mPQH9GlYTTEbBJ4+iJ7JI8Dik0vnMi0RSxfsz55D/+ooreO+hqq7Ab8wrNa4bYrpuPfL/F9vGAbRJlR282Z7y/9wraquXRzuaxVyTLWHOt8RZO/qRyKdOIYCYZwqAbAw+sYBxHCSV/b3JGNRiEwS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782255; c=relaxed/simple;
	bh=5mIvtmlMDAOHavZAXRHaTj/kdL7gzjc2wDPxrUkRr+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ol3wgetEpkVQCUS5yS+SGBX02/il7pwN+xRZVc955XZ71tPWwirdB7s6eh4E/PhOr5ZpuOLAW6lT5GpZlDF0pnv0nqiXoCDlbGB6yXPSZKtD0k2lGV8IIA9U8Ng8ULxtA5kZtsP9MwhPP1be1Urb5zfdTpkWmP/raHQOG5lL4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ngP+yMnL; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782253; x=1778318253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=5mIvtmlMDAOHavZAXRHaTj/kdL7gzjc2wDPxrUkRr+0=;
  b=ngP+yMnLM7z3JrYaDnfHOhL+bHo7/it9qGZzkyY73nYzH9F5Q73kvr2c
   wyJE+MLwYCXAyg2lDy5PT9d+TBu6Epz92hI//xGEP2Hkr3C0T4kyDG7pu
   YkUUl5l4wuKgBTHKD3DmUYmsSJMN4EUrn33f+IZ4SzavGo1nOAVJHzGdG
   1V1fWME0QXlSlWtf/On3sqy2e7aUJT1RqJM4nN+fqcKh5j2H9mS9jzaOi
   QpWc0RckESaXPhkobuds4mI8WM0UWXqGP1knpR8jPvlIM1ylnTLR51Rdi
   NbpWPINEBIrseeyp4NQDt4XO7UMAXm35yCxHLSS2tfCFwGFTnPFUX9hEM
   A==;
X-CSE-ConnectionGUID: c/GxtFRlQ/OEkzxipXdTCA==
X-CSE-MsgGUID: /gA+6b0oRUKNnnrJDi/keQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52410797"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="52410797"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:17:31 -0700
X-CSE-ConnectionGUID: xkxzZMCtSeagvkGP+nrt9g==
X-CSE-MsgGUID: kLRaW1O5TW+pOnGVjsMXEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="137562238"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa009.fm.intel.com with ESMTP; 09 May 2025 02:17:25 -0700
Date: Fri, 9 May 2025 17:38:26 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org, Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
	Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?iso-8859-1?Q?Cl=E9ment?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v4 21/27] hw/audio/pcspk: Remove PCSpkState::migrate field
Message-ID: <aB3NEtdeP7mysAgJ@intel.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-22-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250508133550.81391-22-philmd@linaro.org>

On Thu, May 08, 2025 at 03:35:44PM +0200, Philippe Mathieu-Daudé wrote:
> Date: Thu,  8 May 2025 15:35:44 +0200
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v4 21/27] hw/audio/pcspk: Remove PCSpkState::migrate field
> X-Mailer: git-send-email 2.47.1
> 
> The PCSpkState::migrate boolean was only set in the
> pc_compat_2_7[] array, via the 'migrate=off' property.
> We removed all machines using that array, lets remove
> that property, simplifying vmstate_spk[].
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  hw/audio/pcspk.c | 10 ----------
>  1 file changed, 10 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


