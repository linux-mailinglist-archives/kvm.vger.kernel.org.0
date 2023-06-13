Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A272EA50
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjFMR4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjFMR4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:56:20 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F2D13E;
        Tue, 13 Jun 2023 10:56:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euH/WSZsyAhiuFXyimVMAqaHhDQFHTdaoi2ZoOBVXucqnBKPNve3LipL1HQm9tOEW8EtjOr+ztRu06/mL17FwUY+JjLMMGakhZS6ix4Ac51QQ0QGwHdP1P8iZPmK/aPzJPFnMT4ydNCEorA/x4BrN8S5To8hm8AkXDZLM5EiiYVSellz7Rz2jF+UIqCdiOjywj6zNrxHJWDJhfFXpRuT9PZ266DrtPcftbopsET9jJQTznya5JlvEjV+k6JBsM6E40TCXjcv0kh82TX5/uC8RU0fAQdC/NdtAiWla9wuyQbP1Qh6EUuhcWrJGOlBa5F2xUd1FXnTZ8T0yW4nfics4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGdtVcFA4p/T/erKyK7a69EfX54SH3VGC1GBuruAqQ0=;
 b=KB9L1yk4EdXs7WbPGU0J6jpF8YafGB42j+HDcKP1B3Ivcga4lRVh52bYFd/ISMO/9ND3x1502AqaaHLyuq1+XJnvBWQmesPS8TW3XygyNKw6RDroPj6odrZkkN55Ur8u8qjy63Gt2uQ1SNpKk529fogseaF/wS/Jfk2wg0LCv/TAHCAsMc7+3ExioSbUkvCaV5CVL8ZzMiOO6+H20ikNtyO+bNwZsY3Mi7hiMRugsnVrd3WKi5J2a1/Ib7KINpliroY1xUbiYv+ps5/mQ86qyiGQbjGjYy4K9dBGX+3K4WPAopqAMp9z/9zR+FyH0XuGgSXC7xLqPbXsDZSBgCPkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGdtVcFA4p/T/erKyK7a69EfX54SH3VGC1GBuruAqQ0=;
 b=hsLVh+s8rLjVYFYU4izT18xI4PWUn7V4REyxOmc2erAdNqp+N6WkPFogmmqkHS2/Py4cA7D+5+FrJw/STuBGOlXI8fOm+NRovUZ4PVYT66bN5veKWakwHltFSSlitLmjSk0aaMWuaiXzVmV1bdM+vFF/jpHdlz2L5FeRR8MkEQUl6AIKC2dEzwCYbeauZxrebQ6XUEbzmQseMHWiiowvV5TYfi/4GjTnQH7kxV+IvuOvOlwBGcmIQ3raCsv+VZKhiSFw6axnUY51CMTtN7SBmDQoBTWjxO2z1j34K1XWseuZLFTO47mQ3CBpPxdOYs2HNon4KQD0/7wp70H9c8ktcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6261.namprd12.prod.outlook.com (2603:10b6:8:97::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Tue, 13 Jun
 2023 17:56:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 17:56:17 +0000
Date:   Tue, 13 Jun 2023 14:56:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v7 6/9] vfio: Mark cdev usage in vfio_device
Message-ID: <ZIitv1rz3wg48dOW@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-7-yi.l.liu@intel.com>
X-ClientProxiedBy: BYAPR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6261:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f76c58-a333-4cf1-1125-08db6c377cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qnSJMDt0z1VzuPc+pMgV02yt4cMCfA3eRAUUvdJ99eDDH0oONPJY8C4C99XwltcVv6atCp0FFGgNN8e9msxqUuHpjkl2qxP6AaKmvOA/8KnEuVKZy6deV84/nlyohBXfaEFlfLXxjpAayx+UDw6t8gokAViMMolWMRUSauUCBzqUtg6bjFttAfbm/S0IFN/vK3r4HHG8OgAM5VrfjwvO8IaAjFI63fOKuTVHEEQGmxGbWYYGGvpFb49GZqbuzckqaCnLP/Sh7LjUaRBee1EGKxIUu4xiuGEyrM6lVYsxAVy+/DcFm31ZyTOnnSKmr878FW2uUg9bQh8Tnib/HxcgPEllzRzKKwo5jHdiKClRFo7cFB12XicjDTpy6ontIlcjDQ6FvSX4eHUvmp1D3jCgXejbH3DO8xJwe8gf532nLvW5Q09/iaDDD+MHObWhkXTNoRMD5/jQwDM54bdRM6e8voEMhmSMF3xY7Jdhst/yTjBPqrgQjTDQliu9UEbPfJ1FDmq/QWS+UWBXfA4JPTMtkLCiQfTiJpPkLEgLNpiEm8kHk065qNzMPqlxbaKGSjym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(6916009)(66476007)(4326008)(316002)(41300700001)(7416002)(186003)(478600001)(66556008)(2906002)(66946007)(8676002)(8936002)(5660300002)(6486002)(6512007)(6506007)(26005)(36756003)(86362001)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G04q7jkPXfVGyd6IR2dBpJLXDUEqGQdy+QU/n+AkB/fPGBko8ye6npdPRCui?=
 =?us-ascii?Q?Sq+ic5xTD4jclVR4oolGSq74/o6ai0tdSYL3uGqPNGuQysAi0hkl+3aSzdU1?=
 =?us-ascii?Q?rWnTnDLFIvvRgx2+PGdCVhO82uihQgfpBQjA4D07HjNCErT/Bj8SeVg+2yOO?=
 =?us-ascii?Q?kxxJfkUYmy+xzZ3e7+sP/ZuA/tiUSLGRmLoiyfkfiQBlXFvSANk6zYG6Zf7P?=
 =?us-ascii?Q?ujj/dWWrkh6/tE7Gp8Om0pQXT3qbS+scfL7G4VJgEPAxh2X1ba7a+AnXtJi1?=
 =?us-ascii?Q?0ehcakhedWbQ/R+iuntexi6NaZiUfboNIret69uDZkvg6XXEEXsVbw32rhXK?=
 =?us-ascii?Q?6aQIHOx9OENnyci1nknY9d7dEljdEqlX8LJ3oSTZ5yJL+Uj4uL9drkdnBfpO?=
 =?us-ascii?Q?Jh5soiBfOQKQt8sqUR3T3VSJIXWckFZ5mxKaQoiJEadv95kG7740UMPv1DiH?=
 =?us-ascii?Q?NqsLpaBHpUl+M4R0WNvab2Rxk7YnbeZ1D79TuvIe6bMw+0lhH11WfKp+HHlr?=
 =?us-ascii?Q?3ck67FHDMJFkoZPNp0/KsFtlyDt0deaepytrGCx+D/yoFxdhJM6IODRRcSGs?=
 =?us-ascii?Q?5RanR+UgXg+CB6nY7CwMasRqa4ANDVGvB3Dakx0QgTKSYYI1LulWY6VuXrpd?=
 =?us-ascii?Q?TLwc+1evLMa9LZi9nUIAGs4LSpDCvj0KceyndamjfhYAAc767S5hIxwMmDkF?=
 =?us-ascii?Q?/TEPRby+dzg0dJ8ZuOyWIfRN0FHfkaWyXqtIJxbjDZV6e1Lmzl3dwh5ZGRpj?=
 =?us-ascii?Q?hW/s+zliT597nZTxBN8P4LX+z9dad5D7FNOBmmL2ib4r0C1PkdkUBx9eIpMQ?=
 =?us-ascii?Q?04oyAKw+IC7MFFrBbvqor8HFWjirehoTunS0xZ3cClevIf0/rM0keMEBWbXN?=
 =?us-ascii?Q?ZpNLD7Wkt6bcsWo2uIXSdgKk47JZHuO07hVnoD9LPFnQ1VKSJ2YGRwO24tbm?=
 =?us-ascii?Q?a6kwNU6qDE9Y6zsslCx9hpFd1My9eL16Vo2Jw52DwztsqxzUbttpA24JmKlz?=
 =?us-ascii?Q?idLxrbEpdRy/clGqQwHVglc0CSo+L14P9UoKU8dqNItez0nHkA69pecOtgiQ?=
 =?us-ascii?Q?SSz7S3LIthMPswHJGQfTuMBLqUXAIvw4RVMEyrk77pU+ps53CWLZqRMMlYyV?=
 =?us-ascii?Q?R4B9OanO+bNj9hMI45ywZG6kwWylJFs6afTsCzjWLVFZ4/N9V6IxR2OciATc?=
 =?us-ascii?Q?AzMTX72drWxUMXIDjRTlrM3PeHYWZ7vAi+uLTxyqjZKSENWb8jE615gqslpZ?=
 =?us-ascii?Q?yPsE53kRlj4xjFIWNwnuTsjkfpKo5Lkk4HjFBHPw4YixKDhYnVe98/5tiZso?=
 =?us-ascii?Q?S9vOPcG9eGuWynVZxX8Q1+fyBKVK7IkfHst4reclSk40OjRbEuEuO1MnlgG8?=
 =?us-ascii?Q?lYASZdJ/PNyYEGDjMkN7CL/xmlBdh9RF6Ayo2FAU0Q520yLLeNWc0zXKGGDV?=
 =?us-ascii?Q?MkukpLZQbLzUwMEBEGRPxIOjIYza2jr7QwlKLrhfDS2VyqP7log9PCupRcwr?=
 =?us-ascii?Q?rq6w/jmAtTHnSNB1flpgGXWsUOhUUISprdlgIvBmAbkFomes5mf2Q3pZ4/uX?=
 =?us-ascii?Q?hifnbH0MQKTDr9wlgRBoDfw81p4fQzzUMQA+RVOy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f76c58-a333-4cf1-1125-08db6c377cb9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:56:17.6424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3r5tMHf3pIlBh9qduYIRThB5S2z9+ZFmS9hdtCMu7Wjo+oGRBHJtKTSKOGL2i63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6261
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:15:12AM -0700, Yi Liu wrote:
> This can be used to differentiate whether to report group_id or devid in
> the revised VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. At this moment, no
> cdev path yet, so the vfio_device_cdev_opened() helper always returns false.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  include/linux/vfio.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 2c137ea94a3e..2a45853773a6 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -139,6 +139,11 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
>  #endif
>  
> +static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> +{
> +	return false;
> +}

This and the two hunks in the other two patches that use this function
should be folded into the cdev series, probably just flattened to one
patch

Jason
