Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A856B55D8
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 00:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCJXnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 18:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjCJXnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 18:43:06 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AB319C53;
        Fri, 10 Mar 2023 15:43:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzGwS5SPfIZWB6/apPo9v3QRVUBUMNr/6COSEdIsvPMAeCMVLtGVGdrHG/Dkv0yxoDaHVySa7eKBW3XZd4QTsBLtK/vb/1NAdzi91GgScLYUKYMy8xAozSaSWFFz9NWf3v3bdBFf7WqoGRypdp2raBweb4jAbf52MXHjKhbu4IarScx95hFganrRKGtMkOrUu3VdlczEVUj3xVMd1Q5AABTc1fE9k12jaURPvqYeiqvv4fpcyfTEwUvUJlOrHVt2LW3UE9PzsTAQgvDPrcLioxNRu7xt8uW7NBaTLvDqvKM21j/bEHg+1yhpM6ZkqmQjcovVy8NE/ROUSTys9YFvKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itwey4G+2+kox5P7w8UJfl/DS1gfirKBZVYDB2CzBvM=;
 b=S7PlI0QdhLArPDu/+el7p8a4TkSiWaI1n+1edF7loIwBdtJ4mwHFvHGn7ztu0gSKk61NnVWUKUl5AqqBNub8W7fO60sE1wg1t+FAMnUuP0Sko41OlbhZ5+RVKfLIv2RLj/Ns1FC66/zQmyhllQEz58HHCdQW/xTFvPETr/jq6M9b7uVOuD21hOQDiBmaD+u0yVzClljoUmci/w3u6hIT3Lq6kpFnHYq10sztcKwsfJxvEf5mzuYpOWUljV9ogx5FLFH64LGp7R4Uo3z7FwmQjM/wc95Q5pDVsE4nYt7W4ESqVcOu7qzXl3ZY8CmI/JNWPaDqZgxQhVbP86a7CoSo/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itwey4G+2+kox5P7w8UJfl/DS1gfirKBZVYDB2CzBvM=;
 b=C7Kk8cN3Gzb272ox0GZ5KqaahlVF4jcZkVsKSnQ+LOxy/j/cnW6ZFL5y4jLUvk6F6zAjWnkbf612W2tBzUnfi1/vKTd8ISKG/thKzCX5L2V10+NQJQeOPQRqo/719qzZSkb/tETI90c3EhHZa83h97AqdErLPL170TOpRQb3gHL1HbmQ1262UwePjVD8TFELnIZHmRLA3QahRT47m/+o/1YLlPFTmzOIkYea4Q1BZrGxCVd/Y+FMpYKiewdp3BdNWJa2QXG+5Qa3BKq9e4d0GD0V6kXekuhlVqLYCRh8X+x9IJs39/AekO//031ynDKCoahvyWexfZKqkt/dFbyt2g==
Received: from DM6PR01CA0029.prod.exchangelabs.com (2603:10b6:5:296::34) by
 MW4PR12MB5644.namprd12.prod.outlook.com (2603:10b6:303:189::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 23:42:58 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::92) by DM6PR01CA0029.outlook.office365.com
 (2603:10b6:5:296::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 23:42:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.20 via Frontend Transport; Fri, 10 Mar 2023 23:42:57 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 10 Mar 2023
 15:42:52 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 10 Mar 2023 15:42:52 -0800
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5 via Frontend
 Transport; Fri, 10 Mar 2023 15:42:51 -0800
Date:   Fri, 10 Mar 2023 15:42:49 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <robin.murphy@arm.com>,
        <cohuck@redhat.com>, <eric.auger@redhat.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <yan.y.zhao@intel.com>,
        <terrence.xu@intel.com>
Subject: Re: [PATCH v6 19/24] vfio-iommufd: Add detach_ioas support for
 emulated VFIO devices
Message-ID: <ZAvAefwLEj8i13+s@Asurada-Nvidia>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-20-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230308132903.465159-20-yi.l.liu@intel.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|MW4PR12MB5644:EE_
X-MS-Office365-Filtering-Correlation-Id: 993113bb-b0e5-4b90-14b3-08db21c12d92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmIuQzXHC0rMviEsGEZtDnbV4DVkNbXRwaYkNCYZnwVqX4uTFe6g1bgGoyzXpKwOlv3CJJKlxo+okN1TiQbGcHs9egY4ibiUx4FUECOYr5UJeWMcJ8s0Mngew/KZxrmwKKpAARpge0UwfzzG+7cvb/FxmmiDsZJCZQBeyt2uj0mfYqDbsqk3wwibuxYQq+5OJ0Y6u64IMLWJODuqlUuIwvmldHtNQhy4fjm/i7cQeYYqDJb3yCRF4a/eJQEQs9iaC+ZeyF+EX5EHhQPYvdSS1BW/d3c7LpUbKPAwEF5hduICYz1Z7hcGtIfxiI88e1M+1XbSzkpw7wGEVWF6phEzE7ty7nbUA6+mhgq43OeKw3rBgbRbEFdf4a5119vxWzQqXkp160iXwzm8rFYdyWHxrDPf/nWjaI+xNEucJQX78Lxwhz3MvOTge7EHvsekyrYaSMS9AgEjQhEFsVjYRVK0XA9aX7+jp9BOAHt+ssZwynCUcyWlyOd5SFvHyinVdcpKPYsE/NiZotwvEw/mdehsWKEL4jDgIHVMQRVhJvn0a9TaVIoXK0Ft6DzsUAMIaXbSPMKEHtjHvMMrG0Q0idfxkM03u2p0J8+2jtcaYoGjAuSofJjg+jSG80IRsMjwygOn13mOTckf0yjv1OIPZ0mkYDnALNLXR8q2Bty44h6SyOspRw00eg04icofixNuXvBLRW6lJCYMdww6SIk5G2BZrA+lQ5TpMTTmpgw9UntSIBMEVjjj1svIBzIBtf2MbrMt1IzxE7LkclfaYnE5GO0RwQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(70586007)(4326008)(426003)(8676002)(6916009)(70206006)(47076005)(2906002)(82310400005)(83380400001)(82740400003)(41300700001)(33716001)(9686003)(186003)(316002)(356005)(54906003)(40480700001)(336012)(5660300002)(478600001)(26005)(36860700001)(8936002)(55016003)(7636003)(86362001)(7416002)(40460700003)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 23:42:57.8291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 993113bb-b0e5-4b90-14b3-08db21c12d92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5644
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:28:58AM -0800, Yi Liu wrote:
> External email: Use caution opening links or attachments
> 
> 
> this prepares for adding DETACH ioctl for emulated VFIO devices.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c  |  1 +
>  drivers/s390/cio/vfio_ccw_ops.c   |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c |  1 +
>  drivers/vfio/iommufd.c            | 14 +++++++++++++-
>  include/linux/vfio.h              |  3 +++
>  5 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index de675d799c7d..9cd9e9da60dd 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1474,6 +1474,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
>         .bind_iommufd   = vfio_iommufd_emulated_bind,
>         .unbind_iommufd = vfio_iommufd_emulated_unbind,
>         .attach_ioas    = vfio_iommufd_emulated_attach_ioas,
> +       .detach_ioas    = vfio_iommufd_emulated_detach_ioas,
>  };
> 
>  static int intel_vgpu_probe(struct mdev_device *mdev)
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 5b53b94f13c7..cba4971618ff 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -632,6 +632,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
>         .bind_iommufd = vfio_iommufd_emulated_bind,
>         .unbind_iommufd = vfio_iommufd_emulated_unbind,
>         .attach_ioas = vfio_iommufd_emulated_attach_ioas,
> +       .detach_ioas = vfio_iommufd_emulated_detach_ioas,
>  };
> 
>  struct mdev_driver vfio_ccw_mdev_driver = {
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 72e10abb103a..9902e62e7a17 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1844,6 +1844,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>         .bind_iommufd = vfio_iommufd_emulated_bind,
>         .unbind_iommufd = vfio_iommufd_emulated_unbind,
>         .attach_ioas = vfio_iommufd_emulated_attach_ioas,
> +       .detach_ioas = vfio_iommufd_emulated_detach_ioas,
>  };
> 
>  static struct mdev_driver vfio_ap_matrix_driver = {
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index c06494e322f9..8a9457d0a33c 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -218,8 +218,20 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  {
>         lockdep_assert_held(&vdev->dev_set->lock);
> 
> -       if (!vdev->iommufd_access)
> +       if (WARN_ON(!vdev->iommufd_access))
>                 return -ENOENT;
>         return iommufd_access_set_ioas(vdev->iommufd_access, *pt_id);
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
> +
> +void vfio_iommufd_emulated_detach_ioas(struct vfio_device *vdev)
> +{
> +       lockdep_assert_held(&vdev->dev_set->lock);
> +
> +       if (WARN_ON(!vdev->iommufd_access))
> +               return;
> +
[...]
> +       iommufd_access_destroy(vdev->iommufd_access);
> +       vdev->iommufd_access = NULL;

After moving access allocation/destroy to bind/unbind, here it
should be:
	iommufd_access_set_ioas(vdev->iommufd_access, 0);

Thanks
Nic
