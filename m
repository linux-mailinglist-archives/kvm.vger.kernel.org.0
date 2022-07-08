Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E496256C2FF
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbiGHUay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 16:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiGHUaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 16:30:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06497904F4;
        Fri,  8 Jul 2022 13:30:52 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268JFGiv018258;
        Fri, 8 Jul 2022 20:30:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=pRR0bj/8woEKZPO3FbOxF92eAxrz91N49UHlfEtE2EY=;
 b=GENdpgJrwW61UWZizTNvNwHr0IoK+thqv5J+AvDdE1wbFfIvC49n1yuOzJSw3NIYvjzf
 aWkXM7I3UuGjC8W13L/iEANVpmBhelGamjzfHSF6we7u/+ZYKpHRLoQNJVzpCc5W4yIr
 USlCZcy4DJ3xvBi9gs0fNkfMzXOI6S79QiCy6U9rkJMNhbPvuv+N/c2/T/LRUtEeIBFn
 tFzHEKcn4M313tV34hS5oRcYvCn1ulxpkynwK/9m9a44lTdtiDpT7zi3/7nuGR9+eTbZ
 7C0htBFIGA/SNwrw0gf3JQG8QBL+ignDEY3iKfXF34TtjqAl6xQysqaGKC1lf0bzcq4q cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6tk09e5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 20:30:45 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 268JSsxc013860;
        Fri, 8 Jul 2022 20:30:44 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6tk09e4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 20:30:44 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 268KLt6Y010930;
        Fri, 8 Jul 2022 20:30:43 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3h4ud82mfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 20:30:43 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 268KUgm625493852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 20:30:42 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C346B205F;
        Fri,  8 Jul 2022 20:30:42 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D779FB2067;
        Fri,  8 Jul 2022 20:30:33 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.38.121])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jul 2022 20:30:33 +0000 (GMT)
Message-ID: <73ba16703b8b6f6b4bf37a55ab011324b5affa38.camel@linux.ibm.com>
Subject: Re: [RFT][PATCH v2 0/9] Update vfio_pin/unpin_pages API
From:   Eric Farman <farman@linux.ibm.com>
To:     Nicolin Chen <nicolinc@nvidia.com>, kwankhede@nvidia.com,
        corbet@lwn.net, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@linux.intel.com,
        airlied@linux.ie, daniel@ffwll.ch, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, vneethv@linux.ibm.com, oberpar@linux.ibm.com,
        freude@linux.ibm.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, kevin.tian@intel.com,
        hch@infradead.org
Cc:     jchrist@linux.ibm.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Date:   Fri, 08 Jul 2022 16:30:32 -0400
In-Reply-To: <20220706062759.24946-1-nicolinc@nvidia.com>
References: <20220706062759.24946-1-nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 56bjKPYcrWB6zzK-WiojMGACyXFFSAsI
X-Proofpoint-ORIG-GUID: BnA8Sj9ZVgB4eb97bBfAsmVyiACCKS5_
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_17,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207080079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-05 at 23:27 -0700, Nicolin Chen wrote:
> This is a preparatory series for IOMMUFD v2 patches. It prepares for
> replacing vfio_iommu_type1 implementations of vfio_pin/unpin_pages()
> with IOMMUFD version.
> 
> There's a gap between these two versions: the vfio_iommu_type1
> version
> inputs a non-contiguous PFN list and outputs another PFN list for the
> pinned physical page list, while the IOMMUFD version only supports a
> contiguous address input by accepting the starting IO virtual address
> of a set of pages to pin and by outputting to a physical page list.
> 
> The nature of existing callers mostly aligns with the IOMMUFD
> version,
> except s390's vfio_ccw_cp code where some additional change is needed
> along with this series. Overall, updating to "iova" and "phys_page"
> does improve the caller side to some extent.
> 
> Also fix a misuse of physical address and virtual address in the
> s390's
> crypto code. And update the input naming at the adjacent
> vfio_dma_rw().
> 
> This is on github:
> https://github.com/nicolinc/iommufd/commits/vfio_pin_pages
> 
> Request for testing: I only did build for s390 and i915 code, so it'd
> be nice to have people who have environment to run sanity
> accordingly.

Tested-by: Eric Farman <farman@linux.ibm.com>	# s390

> 
> Thanks!
> 
> Changelog
> v2:
>  * Added a patch to make vfio_unpin_pages return void
>  * Added two patches to remove PFN list from two s390 callers
>  * Renamed "phys_page" parameter to "pages" for vfio_pin_pages
>  * Updated commit log of kmap_local_page() patch
>  * Added Harald's "Reviewed-by" to pa_ind patch
>  * Rebased on top of Alex's extern removal path
> v1: 
> https://lore.kernel.org/kvm/20220616235212.15185-1-nicolinc@nvidia.com/
> 
> Nicolin Chen (9):
>   vfio: Make vfio_unpin_pages() return void
>   vfio/ap: Pass in physical address of ind to ap_aqic()
>   vfio/ccw: Only pass in contiguous pages
>   vfio: Pass in starting IOVA to vfio_pin/unpin_pages API
>   vfio/ap: Remove redundant pfn
>   vfio/ccw: Change pa_pfn list to pa_iova list
>   vfio: Rename user_iova of vfio_dma_rw()
>   vfio/ccw: Add kmap_local_page() for memcpy
>   vfio: Replace phys_pfn with pages for vfio_pin_pages()
> 
>  .../driver-api/vfio-mediated-device.rst       |   6 +-
>  arch/s390/include/asm/ap.h                    |   6 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  46 ++---
>  drivers/s390/cio/vfio_ccw_cp.c                | 195 +++++++++++-----
> --
>  drivers/s390/crypto/ap_queue.c                |   2 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  54 +++--
>  drivers/s390/crypto/vfio_ap_private.h         |   4 +-
>  drivers/vfio/vfio.c                           |  55 +++--
>  drivers/vfio/vfio.h                           |   8 +-
>  drivers/vfio/vfio_iommu_type1.c               |  46 +++--
>  include/linux/vfio.h                          |   9 +-
>  11 files changed, 218 insertions(+), 213 deletions(-)
> 

