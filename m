Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E333B8B81
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 09:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395012AbfITH1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 03:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390633AbfITH1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 03:27:54 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D66C2A09B2;
        Fri, 20 Sep 2019 07:27:54 +0000 (UTC)
Received: from [10.36.117.220] (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E12DE60606;
        Fri, 20 Sep 2019 07:27:45 +0000 (UTC)
To:     Will Deacon <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Zhangfei Gao <zhangfei.gao@gmail.com>,
        Andrew Jones <drjones@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Subject: Plumber VFIO/IOMMU/PCI "Dual Stage SMMUv3 Status" Follow-up
Message-ID: <51ed9586-9973-4811-2cda-a2356fb3a1b4@redhat.com>
Date:   Fri, 20 Sep 2019 09:27:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 20 Sep 2019 07:27:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

As a follow-up of the VFIO/IOMMU/PCI "Dual Stage SMMUv3 Status"
session, please find some further justifications about the
SMMUv3 nested stage enablement series.

In the text below, I only talk about use cases featuring
VFIO assigned devices where the physical IOMMU is actually
involved.

The virtio-iommu solution, as currently specified, is expected
to work efficiently as long as guest IOMMU mappings are static.
This hopefully actually corresponds to the DPDK use case.
The overhead of trapping on each MAP/UNMAP is then close to 0.

I see 2 main use cases where guest uses dynamic mappings:
  1) native drivers using DMA ops are used on the guest
  2) shared virtual address on guest.

1) can be addressed with current virtio-iommu spec. However
the performance will be very poor: it behaves as Intel IOMMU
with the driver operating with caching mode and strict mode
set (80% perf downgrade is observed versus no iommu). This use
case can be tested very easily. Dual stage implementation
should bring much better results here.

2) natural implementation for that is nested. Jean planned
to introduce extensions to the current virtio-iommu spec to
setup stage 1 config. As far as I understand this will require
the exact same SMMUv3 driver modifications I introduced in
my series. If this happens, after the specification process,
the virtio-iommu driver upgrade, the virtio-iommu QEMU device
upgrade, we will face the same problematics as the ones
encountered in my series. This use case cannot be tested
easily. There are in-flight series to support substream IDs
in the SMMU driver and SVA/ARM but none of that code is
upstream. Also I don't know if there is any PASID capable
device easily available at the moment. So during the uC you
said you would prefer this use case to be addressed first
but according to me, this brings a lot of extra complexity
and dependencies and the above series are also stalled due to
that exact same issue.

HW nested paging should satisfy all use cases including
guest static mappings. At the moment it is difficult to
run comparative benchmarks. First you may know virtio-iommu
also suffer some FW integration delays, its QEMU VFIO
integration needs to be rebased. Also I have access to
some systems that feature a dual stage SMMUv3 but I am
not sure their cache/TLB structures are dimensionned for
exercising the 2 stages (that's a chicken and egg issue:
no SW integration, no HW).

If you consider those use cases are not sufficient to
invest time now, I have no problem pausing this development.
We can re-open the topic later when actual users show up,
are interested to review and test with production HW and
workloads.

Of course if there are any people/company interested in
getting this upstream in a decent timeframe, that's the right
moment to let us know!

Thanks

Eric

References:
[1] [PATCH v9 00/11] SMMUv3 Nested Stage Setup (IOMMU part)
https://patchwork.kernel.org/cover/11039871/
[2] [PATCH v9 00/14] SMMUv3 Nested Stage Setup (VFIO part)
https://patchwork.kernel.org/cover/11039995/

