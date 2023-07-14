Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42502753BE4
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 15:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbjGNNhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 09:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbjGNNhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 09:37:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEB4AA;
        Fri, 14 Jul 2023 06:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THf2kyFg4x4YSSrWUSPUkEhpDZ3l+8wo4nhSStJ34CTqGYG0ywqKVdyMXHQP/GdArm/p2h0oYiv1lSdlWvSL5DGCKhP4FpXZbist/k5ZId+tGbhQzO+ZeP64yHnh7Zo0mwGJeCZBamQLQk/6FYc5aaFs5/qdysj1XmNtnrd66QuxLfQbx1hHdFDqd/2V2npMoTCvzAmRkJkIUjk2EFeSWMAcu/2UhvqqrDfbkpzRHtfynkcfDFOti+dPKnFDX8pa67a7t/siecYesOtWMMBEpawgoM5K7+EeYuLPw40IntSmNi/4P5XHle+s+t8GI+sxUPmsF4XCAg/cY5179zgWfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTHIkmghNJUKzgjF6AnV911ZQ4AzK2cm4/OvyQXK6d4=;
 b=QHMMElYfWnN8xU4NGvZcbmIKLqRfGU2/I5U8gp1+5SbfCp8AUmwi8UGEQ76i6p+OTcfLy9SNEejK6JDZebSbMOxRoRpeABoy+Y2qKgOs0U/7OvkKGqCt262kl49dodbOMlNJ3uUmrVSNUH0DO+2Q5WwMnkAF8nsyGcT2DG9PV8qc2jFy6TUn/2oVRAoWTcko0HQY+gkKNYetkgcgmKi0j0UxpHQMDHfetV3GKczf2xDrbWfLtuC7ILMEc6pdaS+/LRKEZSw9d2oZIKFiYHpXMf99wb2AQhMVEdGRQn9+lG5wtjMelXj8K31AXHmoDiMGsIAcY+T8P1Fo+PscW6WPKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTHIkmghNJUKzgjF6AnV911ZQ4AzK2cm4/OvyQXK6d4=;
 b=Qqjset5OrM8IwEi03ZK8eofZvPeLre7v0qr0+GVUgRDi2w9Uuq8qDDvoH9HCw4ZnxIVhreyBc6Y5LSJiCKrcZ5r8ZDz0k9HFdH0qBVySNC6z6VoOn0TiXoq8EExjo8GojW9jxGDXYEcewBzjsty3ZJ5nTHM43QCC0ZDY7iq711LwBkFSITSGQJOl61+eGu2bSDA79q2lIMqOi+sCSoV4ecXJ3+OFFJqp8t6CUFIVjNWtgFIKF/vH8jxQdRnWfHbN1XaKXMSLCVBe66UQSB/a1Ll+QsSDkiCO/xK8H11CC1vvoNmXvLJkyu/vPF1ymnww+hDHY1qk2cwaTm4tYk5z2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6450.namprd12.prod.outlook.com (2603:10b6:208:3b9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 13:36:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 13:36:58 +0000
Date:   Fri, 14 Jul 2023 10:36:55 -0300
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
Subject: Re: [PATCH v9 09/10] vfio/pci: Copy hot-reset device info to
 userspace in the devices loop
Message-ID: <ZLFPd2coVKPcI05G@nvidia.com>
References: <20230711023126.5531-1-yi.l.liu@intel.com>
 <20230711023126.5531-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711023126.5531-10-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 00c9ee18-a60a-4a33-f74e-08db846f657b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ViqBFCxueFEf/YOj3S3U8w+wRRxHcsZ/2N78ATNjvS8n8WSS6wmI5zIpMkIVAGFJeAPZcMBe0UI7JmoN8ekuAsL2EHrLUnh5pxoBlOO9DYTYdfsJ6ph2e6HejokOWIJdspc6WNEKut2xBm2NJ0Q58Dh7Cgbw3O/yytFO/ad66GV5DYx9o3tQLDR+vl/d5YJBdA/twcWIh2rK3tJiTjNaNWP82tnvRuAlyfj8lulrYTEhTf65j6PKgM5IDjvyYxqxXZqWBqy3VOz/dlxqZIaE/vS1lVHtmU9rMBYi6fwLqgYDQLroAZrXf0RrDkzOHMOEsDPE0AVL9gaCfLzctDlp1nBB3JHErbJzbdqu521QdhOq10U0x4NFac29245UWG8cR2OnH8pOsOHoHIfWeKpvmzynsPVguG8+BKV5jo9MlyOcvs6FDW5Se1VeI4S8Q6VrEU6SwaeUDGOng7NmB8At1vHYLTL1sXwUgbq3WNitt17xcZnLDdjB10BhSJ1MZcvZpUrY+lbAjdNAJGv3t4rGHsa6rxwPFbNDOhXQgFy3oHtBAVrkmD4X6smkbAS0ASDP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199021)(478600001)(6486002)(6666004)(186003)(6506007)(26005)(6512007)(2906002)(316002)(41300700001)(66946007)(66556008)(66476007)(4326008)(6916009)(5660300002)(7416002)(8936002)(8676002)(38100700002)(86362001)(36756003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PSQJIavSu/SaUTctSNjFv2xAflYpkyOhw2T7qxm5wLzMAGsiK0oss58Yw+b9?=
 =?us-ascii?Q?OTY9nyy8xHGsYlp7iBbyADd4jL3Al2jfjSARqHbyaawr+e5siMfFv5X03G+c?=
 =?us-ascii?Q?bzgB8RoVLFv4OrsaMY1eOVIIWX6yD9louMD75DFsB4TMPWGvY//nsk/UTlII?=
 =?us-ascii?Q?yyzA4nfqiU9x9thBfNbthQH9jjiVEtwU4cnHrCn76Gc+jBDO2AW0R04Glv7N?=
 =?us-ascii?Q?1YUWKtQ/Hifh3sVkkr9SAuUtlOsG4pY5MfNZZjzvn6BojUtVXKFBMZgwTxvb?=
 =?us-ascii?Q?FsWv85sJ0//r2qYQONcDTElaGM1Jy3a3xPjKJJe3HtW0P0Nc8UphkErRtqif?=
 =?us-ascii?Q?MaPZ/HcJy9hkCDl6OPy+DAZlXP68d/9gTvkg2IRsJamFEGuqtJW/vNo5iB0h?=
 =?us-ascii?Q?lOC9Ehj8DsfOyr5UZUx6zSmpio9jiFrFjrEm3a6vIuysBELlJ0pcKNN3WK1b?=
 =?us-ascii?Q?kDZZyiuOW/Gl1Olsp7onQGqpB7lLfNUxSkOmARHNz13F4Xho/uTJzwH0zsrg?=
 =?us-ascii?Q?luuoLnVBuThGn74uXWwQ2QSLDENMHTw9E9NIN1830Ka6UDkRXvTf8Zq7duBN?=
 =?us-ascii?Q?0a4fQRS6hn9xEtMIhDH2IbC6wA8WM3JKTqi6qY97ACYAnADpMbH+qIVCyql6?=
 =?us-ascii?Q?YfLLOfM08QwRJF6XYblOl48PEO5QGYNd0Q0T8BWa8/3+hBrsBmNdd1iuRIrW?=
 =?us-ascii?Q?wbOdUlNvkbOep+Hk4MZH4T5/ySt22g93faqzonf0to62G/rI68sDgPJkGL0K?=
 =?us-ascii?Q?L61ivSmOZ7W4ubM6XH6TbOGKvgoghEgqLCJAt+GvPsYy3WbeHWqHaeW0bgVI?=
 =?us-ascii?Q?QlzpU8PEhGv4g1SwNjzdItFYVi+Xv6LaVtPuahNDaR+7WDxem3HV5HBjyt0r?=
 =?us-ascii?Q?NnMw3uCxfo3Pr9K257J/ht0Z6p4p5A3lh9D43MRWe1qfPRfbMuuZ0ZCk+2ZJ?=
 =?us-ascii?Q?x1w90umTH7zVysSH7RkZexrVBi4gV4x8saqe/2YVTGywAkhnVAHE5Ga3d5xc?=
 =?us-ascii?Q?x/8PUylXYi/i8vrN8AhD+tK6lSGG5ai6Q7KrMko6u3UOn7tLKKOqK6ITN2D/?=
 =?us-ascii?Q?TCi1nA/BqXR/2DbCekN014WlfSh9isRLejkE2B7A8rnfbGo7NhvKmFK/tB9Y?=
 =?us-ascii?Q?GIE5so6TsU1fxxISy188CCfALnZnx6CbzCteB0e4VS7txGrjavLSPkxEmf0l?=
 =?us-ascii?Q?+GDLDAQk49lombnKmKDx9r/pasKSrP48Y1NDpDUeM2zk0soB4gD8J/02I+cp?=
 =?us-ascii?Q?9kI8cXkmiB0WaG9Ga6aeTT4jxKZMfm8ABOa9DWHNt+PpUyTPCOq9VpaOvwBi?=
 =?us-ascii?Q?Nci8lmZ6t4AveqtUvUXNvIzAkZOy/rCrzT40Ny2MpkhNUxStwG1U3u4N4wuO?=
 =?us-ascii?Q?FnoWJ0z4ihmwabljJ8SRPahDjwhQMRE8zXRIrHjjHJM6+1PST7xfvFZWw9rF?=
 =?us-ascii?Q?ujxDlUM/T0Wdsm96YnP5iXPfB/h0Y6wtAW3BKn2ppbAQjtca1AK3Vw7CdC98?=
 =?us-ascii?Q?qHJn6AS1LWdii/fMNTxJBZKRuxBrZe8IGMpri2tGZUyeAM/23byTxKHWrfrJ?=
 =?us-ascii?Q?jCG646GDnqVUqwLblwi0FsezAXLF5BP78ln6cM3E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00c9ee18-a60a-4a33-f74e-08db846f657b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 13:36:58.4678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 76MTx2tGB5CxP9OrueEu85iRUzsxwZGEHxa3yB46hGFjyYh3vKq3YGoQhX9GvEFa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6450
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:31:25PM -0700, Yi Liu wrote:

> @@ -1311,29 +1296,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
>  					    &fill, slot);
>  	mutex_unlock(&vdev->vdev.dev_set->lock);
> +	if (ret)
> +		return ret;
>  
> -	/*
> -	 * If a device was removed between counting and filling, we may come up
> -	 * short of fill.max.  If a device was added, we'll have a return of
> -	 * -EAGAIN above.
> -	 */
> -	if (!ret) {
> -		hdr.count = fill.cur;
> -		hdr.flags = fill.flags;
> -	}
> -
> -reset_info_exit:
> +	hdr.count = fill.count;
> +	hdr.flags = fill.flags;
>  	if (copy_to_user(arg, &hdr, minsz))
> -		ret = -EFAULT;
> -
> -	if (!ret) {
> -		if (copy_to_user(&arg->devices, devices,
> -				 hdr.count * sizeof(*devices)))
> -			ret = -EFAULT;
> -	}
> +		return -EFAULT;
>  
> -	kfree(devices);
> -	return ret;
> +	if (fill.count != fill.devices - arg->devices)
> +		return -ENOSPC;

This should be > right? The previous code returned ENOSPC only if
their were more devices than requested, not less.

Jason
