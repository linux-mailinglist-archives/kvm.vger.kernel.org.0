Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDDE129450
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 11:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfLWKiC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 23 Dec 2019 05:38:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:59708 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbfLWKiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 05:38:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 02:38:01 -0800
X-IronPort-AV: E=Sophos;i="5.69,347,1571727600"; 
   d="scan'208";a="211517217"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 02:37:49 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Tom Murphy <murphyt7@tcd.ie>, iommu@lists.linux-foundation.org
Cc:     Tom Murphy <murphyt7@tcd.ie>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/8] Convert the intel iommu driver to the dma-iommu api
In-Reply-To: <20191221150402.13868-1-murphyt7@tcd.ie>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20191221150402.13868-1-murphyt7@tcd.ie>
Date:   Mon, 23 Dec 2019 12:37:47 +0200
Message-ID: <87blrzwcn8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 21 Dec 2019, Tom Murphy <murphyt7@tcd.ie> wrote:
> This patchset converts the intel iommu driver to the dma-iommu api.
>
> While converting the driver I exposed a bug in the intel i915 driver
> which causes a huge amount of artifacts on the screen of my
> laptop. You can see a picture of it here:
> https://github.com/pippy360/kernelPatches/blob/master/IMG_20191219_225922.jpg
>
> This issue is most likely in the i915 driver and is most likely caused
> by the driver not respecting the return value of the
> dma_map_ops::map_sg function. You can see the driver ignoring the
> return value here:
> https://github.com/torvalds/linux/blob/7e0165b2f1a912a06e381e91f0f4e495f4ac3736/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c#L51
>
> Previously this didn’t cause issues because the intel map_sg always
> returned the same number of elements as the input scatter gather list
> but with the change to this dma-iommu api this is no longer the
> case. I wasn’t able to track the bug down to a specific line of code
> unfortunately.
>
> Could someone from the intel team look at this?

Let me get this straight. There is current API that on success always
returns the same number of elements as the input scatter gather
list. You propose to change the API so that this is no longer the case?

A quick check of various dma_map_sg() calls in the kernel seems to
indicate checking for 0 for errors and then ignoring the non-zero return
is a common pattern. Are you sure it's okay to make the change you're
proposing?

Anyway, due to the time of year and all, I'd like to ask you to file a
bug against i915 at [1] so this is not forgotten, and please let's not
merge the changes before this is resolved.


Thanks,
Jani.


[1] https://gitlab.freedesktop.org/drm/intel/issues/new


-- 
Jani Nikula, Intel Open Source Graphics Center
