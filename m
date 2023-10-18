Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214557CEB71
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJRWpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJRWpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:45:04 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44B9114
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQFYm4WFK7MX1vKxNksgo1SF+q7OFzw0W6FNdNfs6Mhzn7FKELl2wTKJMtfZmupbsrxYtDio786uFZ1mk2VoSPz3uYTgpFIyIBgZwhkcpwxGzBuiX7YVplVFe6Kui7/7s0wdqEJGDAGpX7viGobChJ7QT87cv2cVCBB2fYj5hrbRaXCOGzv8g4v1YWxIykOxHfzYEpITgi0oA/UhDe6nosjIZZtbzlamgJCh4vePo8kqpx4XGMkjnb7u8iCWMZFDxfUZAQZgygoQmzXtoZ1KnUFeWS4hvPzvA3qXgrCXi0oSe/RPWj2P4ngku6knh0JvCVGQonB3LAlPHAuoOditMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSkplnTN6yCFqEWwyx1gv5Oe3lkUdaPABwjr/shQ3Mw=;
 b=HoM4mho6vCu8UzvhLv513tHYX5g2R9W02llxv/GcHBkQyKJP19zjhpAvF25ASC7hz4mNV/bbrukGBa39tnVyOzleM09dmlw0EOJllLj556ZDxmsSpuXI9d0yFsTTLWw2ipaBr/6O0oZmZ93m3mapYcCd8Nle9QrZec9FHnCcf7Lw0S5Fm6/6V9eZmBkS7Qnuy1EP6Bb8HoxBQ7ycR77nt+VbIKaSAhiXepIMAQCXO/grbLOV9gt1D0Wq5okSytd1Afcmr6p3OMQtC12xqH6A3WBc/676sCQ1wblFgraeBI7B6QTNb2pXI7CzcrAVpZn6c90RIXSdy+E0Ixyw958uUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSkplnTN6yCFqEWwyx1gv5Oe3lkUdaPABwjr/shQ3Mw=;
 b=fF7BU6S0a2d7vfjcoAix1OvCvxHiY6I9H4j/X7Hd7vE7wyhii+R1Hw7wlcikQV6+cwvvr+nxGAqmrnzPCyi8teObk80zhL7P2znAaRUGGd7A2t0WH+pdJtjh1vAVe+QQ9Dreanx96diK5tiIIKF2JgaSfkozdG5ykdQxMpFw8HGOTmXe6XugvDLvohE7WRlXwSHw1qXwHt928w0apJeRQaROyuXr9DPEdEx4c6qK0nxuU2rSwGIvOT/zM+wjKv1173QZDkoaGAO9girakQo0WqsBCekBperz3jJQpTqFjKm9eWqNjTd27cyeBCsaj5xmVqM3/IDPjEYDtXleD/iiCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 22:45:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:45:00 +0000
Date:   Wed, 18 Oct 2023 19:44:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Message-ID: <20231018224458.GM3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-9-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-9-joao.m.martins@oracle.com>
X-ClientProxiedBy: BN1PR12CA0008.namprd12.prod.outlook.com
 (2603:10b6:408:e1::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 69d4bc65-e7ee-4b02-47cd-08dbd02bdc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBG1DtpFMvCEtA1LR0OcrmtniDBFqkLNl6VBi1RITkhnXDoVzeJbi99wYonVoXf0uelgF8piO5qmRA+NjAVvJIRSLNM7uAB0nNN37O6tSCk27oyJlo1bDAsEGHe1cZWVp1FUT5UQNCnW1kQT0J7LSzY4zxqg6ci1tOsOhgU1miYpBaOzznpBKG9Fc/zfsWI0XBgvaofMbYOE1KLyjoEAL+DOiCpWe03vbqNQq/hriirIjq5rzGKxRL49sTGWjAnXBDvDrEqgeU+YiTrRyfcoqgVlJdaTCtBu7q5x0nsqQwKDGQAZYxqcBHOIw1Xrz8iW3oLv5VPzQf+ODlNwmtNILWTtE9oYcWhENT3jx+PIkUzUni8Cop0XQemogAIRO/6vw/TzGv6IoJtkl9OCqqQAQQ5C+N61BMoA+5NyyEmRTxVpok/uCJqWbo/NjIDbs0RvmBwPumO52o8MuCNzvEx22XNL/Oh8E0fcQr6y2eQ7y90GHXRYJYn2CGwxDiiY78CIpm2T+2b/5b/51H/k3HlzbvkULGs7dMmff0K3lwZVykX68kIWGy4YEIZBImZoDRJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6486002)(66476007)(1076003)(86362001)(66556008)(478600001)(54906003)(26005)(6506007)(66946007)(6916009)(2616005)(33656002)(5660300002)(8936002)(4326008)(8676002)(2906002)(41300700001)(6512007)(7416002)(36756003)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JM5WgbugGQTtPWr5SFbf6ipgME3NeKF16eHllpFVDPvgHerl7hqlvbzworzd?=
 =?us-ascii?Q?4uDx/bI/51FPR1IPr87aHbZPfDuQbtdOBgDVhiFhQz6Gwt3YaqeEkShWQPm7?=
 =?us-ascii?Q?O61Wy8PrtAqUgcKzs03FkN1BOHaXbpd9u0u5q+Srf/wpjD9b/JM2Aei01o59?=
 =?us-ascii?Q?WzjXsHMHNsNxUDIAqwrAR9tnTApFlN0Obgu9fkkUCYgz7stfS8fh0aSPezoP?=
 =?us-ascii?Q?dqPiNvtIilsnxqKgcKLRajLtfZn0fzPXYiq3HIFb8vPkOFHuixFGfq9f0pz5?=
 =?us-ascii?Q?9IK90u1cPy/Yc0VootKGPb28l9Bb8Bv7MDkCBfDywQoAeR6rAf786SwDT4VH?=
 =?us-ascii?Q?XEFUYHfvJI7W8r1gyLHNiraHsYxpnXGCntYcku25ClO0vj+HPC4Ntntr9SnE?=
 =?us-ascii?Q?+4gKGnyakkOf7PxM33dOtMx/Rz9nBICy0KmnfILftS6IiIPk/71yRbWg+8oj?=
 =?us-ascii?Q?pOIeTrD5hXau+Yo7EOevzWVimao3pp1ghb//FiN3EwjH/iMG1NHu9gbtLzFk?=
 =?us-ascii?Q?2VnSLZ9hTnOCp9AcancP6srWubQBua3d6e6ZNXmbiyYfFUgJhZ/g3i3icTJd?=
 =?us-ascii?Q?dvx7/bK9cFN2lBxcZlTcIJBObywPQj/dVM4/Y96wa07cqknw6fnhVgSHvkqr?=
 =?us-ascii?Q?z4LTTgphps0RSnn5/K4u+17oP7MqMUq0GTiK/WWtnH4207A12WiHDipvVpes?=
 =?us-ascii?Q?NYbq0Vj8BWZdYCz0uGqvVOZI8U1e8PGbXyIHM3BdnYdKcGm2UzdD5JNiMyY3?=
 =?us-ascii?Q?VG5B+zAGwuinaDFeQEVR5Nq82LjIp6n4VkZqPetUnEvn35+QCiLstMDKu4Sv?=
 =?us-ascii?Q?479I2tFspD61+YRSikuIXgo1pMWrIXgFqmTEMHkp1dlAfi4jV3FOFYe/pk2b?=
 =?us-ascii?Q?ZKii8QiGxb+U0HHlZr/u81uGcDT853j0OknvaSgPIBXbPgP77xAnPhJ58/5L?=
 =?us-ascii?Q?zGM5Sye+BnMAo0H1DCel98HPe+BVm9T9i528Ez6grlQeBDqW+J9ddhMYky1U?=
 =?us-ascii?Q?uX0JBSHZA6OOZyVkleH67GQbKFs4GEhagg8lbIweRrIclOnA77tsMSJ7bSRL?=
 =?us-ascii?Q?LoW5iuyiNOoPwbeQy8rzQs5GBeHiQbPNiPd8m+ZaA/XiTuh51KNAqr2a0Uar?=
 =?us-ascii?Q?XapMb7iFJZjzHH5fWaFmtQFsJnUACxqknDZ1A+QTkMQW8HAQXmUfaxOIvhJh?=
 =?us-ascii?Q?pZjRX8RH4wKe/hrrsP8hF9oI8N3tePtOSUTooHJEjD3fUJta3V5nfSo19ay0?=
 =?us-ascii?Q?dP2wec2/SbGp+JSh3wB6cGrRBYhO9tjelhfJiTleeKWOyNsM4ILcdLjDKgKO?=
 =?us-ascii?Q?zfrfDf0U6ZQ/42az5D38MroXxC+70kG3XFtJhyxGtxOfx3pqfw0dnh631F51?=
 =?us-ascii?Q?OqW5sBhfyV8qJ2DDdN24OoCNeedBqD4gGCDtcVOnqY8fiUyFLkED9vWHOczM?=
 =?us-ascii?Q?2CI818lzMg7SkFPDEM8E4XHhAHQNc4T5cp98mDmeEeLhax8cjA8Srzx0XBcw?=
 =?us-ascii?Q?vcoXAoIWJUciByuvOtvlAw5A7UqOrM5Y210TsmhCm4J29AHGCioSn59CH+e2?=
 =?us-ascii?Q?xNhCf3dudE71RcEHmCX734PjjLMblRdyxOIcXQNi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d4bc65-e7ee-4b02-47cd-08dbd02bdc61
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:45:00.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NCY08dmCjOND+vV2+3An7a9BwyY5+NRfHAg7J3ZBSRTHIuodG9Ddyh+wT1gVOlkg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:05PM +0100, Joao Martins wrote:
> Extend IOMMUFD_CMD_GET_HW_INFO op to query generic iommu capabilities for a
> given device.
> 
> Capabilities are IOMMU agnostic and use device_iommu_capable() API passing
> one of the IOMMU_CAP_*. Enumerate IOMMU_CAP_DIRTY for now in the
> out_capabilities field returned back to userspace.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/device.c |  4 ++++
>  include/uapi/linux/iommufd.h   | 11 +++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index e88fa73a45e6..71ee22dc1a85 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -1185,6 +1185,10 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>  	 */
>  	cmd->data_len = data_len;
>  
> +	cmd->out_capabilities = 0;
> +	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY))
> +		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
> +
>  	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
>  out_free:
>  	kfree(data);
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index efeb12c1aaeb..91de0043e73f 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -419,6 +419,14 @@ enum iommu_hw_info_type {
>  	IOMMU_HW_INFO_TYPE_INTEL_VTD,
>  };
>  
> +/**
> + * enum iommufd_hw_info_capabilities
> + * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
> + */

Lets write more details here, which iommufd APIs does this flag mean
work.

But otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
