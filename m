Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C366429CC
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 14:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiLENou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 08:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLENoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 08:44:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2226ACE27
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 05:43:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXIt1BbaNXcCoqNmJsae2juSxsdltu2eTDsWlJIxyNIgjOmDEWLp5ij1adOlOu5vmwLOloaAAuAyapqdhZWAEyJP9qaCfeJUtyMncqBTjtOAwjIz2fTppXdK2xDR3+pQ4rx6JPOwvoIiHzEVPfZw4dhp50fX8R2WwIt3waF5IF6PeSdj610BraSah1izZa1pabNaZnCnsKov+bk8N84Q6NeEVgCexRs/AzEkLGlDhXCk6LAx5GQBGAkk/Qk/wqfKio6sEGb8PTHC495HLZgd/l+GdR/ambgvltpIIk2RWTh3ruaH8uXd4k7azxj01SGPewUkwYwTmfbu4LUCCZlnUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12aU/QG/JfzyGvKNIXzvLUcODiGtMsPLsq/1O/Un+cY=;
 b=TmGHo9SESCH+tD3cLH9bmvWFWyFAAYjyyNE1yA6CLJqj+QOTF9vWmiu6OqVhiC3u0OMGNiriHG5naNxjrGNoLv9yX+XpD91FXdsrKxGIEjrsn1QZGyFcZyxcSZr1aUf9BNd8euBE+9SmqdcA9DnKo52bPwECGbljWpmpFdLGUjNIWSlZGTiCmcD/NuIdH/Hw6OxKDZSqVzvWYZMbyanD04LSpXtyzQfgwKt5GT03pHdiPtTN8U+kp3dD/VghTjkdkBHkU63eHPEG91PliBp4S+DZqeyc27V+KwM1nWaoGyME/WMZt6XFuFVS2EAc035B62h6mRjpsK4pdPXfbc5BPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12aU/QG/JfzyGvKNIXzvLUcODiGtMsPLsq/1O/Un+cY=;
 b=MizAvao0QCaP74jnsjN/fTnLI2WkyiuLocHas6Bj7F9vanotUEiew7VocXKcIIBcoM6OyqOsoBdZ+waT2Csf0Xub02hqYE/JmDL9pD5QVTJngCKS+St2tii+6txix0gTuDUkawxyZd8++x3F9loorR6OjdaufMc6NiHMiscHA4ad2nKwkzrc6ZdW3hA4580BrduQpcl+pteMSS+tFqpmyf7MibDprC3RTaM3FdyUmQwCUWjZxtx2CJWs4cKVT0j2oroOh97qAW+/N//kJiileCi9JQvUR3NttoE3ilGkguGTreefjAmnAgZ9O2iBTBcA6G+as4OznrNEecyktGPAWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 13:43:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 13:43:45 +0000
Date:   Mon, 5 Dec 2022 09:43:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        yi.y.sun@linux.intel.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Message-ID: <Y431j8HBvuCsvP+U@nvidia.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
 <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
 <Y4oPTjCTlQ/ozjoZ@nvidia.com>
 <20221202161225.3144305f.alex.williamson@redhat.com>
 <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
X-ClientProxiedBy: YT3PR01CA0078.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5732:EE_
X-MS-Office365-Filtering-Correlation-Id: ca150500-2ed0-4694-b465-08dad6c6bab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QV/JJB1aIu14LRRC4UL+dZv0M6baCu/UdVLmImLytwr3TINXJrZc9UzULpELsoKgY5qFmgLfMveU/nTxKl6ITSqfvJMqEnBOqPlWGIIv0d05VQ+nM399TNRHdeySVqNwW3NzVeV6d9XpW2G0tG4DtJVNCbBKxRtjM63Q2+hhI9q68fRfHmiUcXH11K9MUKYP8xiU02JLh2caUScAtcD6dVGpDRUOxFSlqBF0tPwKEMfvRoZxn5+cFxdCB4UaIiApIVfx03mjM0+7ILjcUZRIf6DZRagHuXDFkTX6V4Do/Hd8w+YGNcilPdtlbVshevcu1mPcU+rVowTmmT1h5ChYEPtwUapWzTQQaTtfgUX4GZCv1pflBRf90kyzk4uYYwUR2CGKCXcilqhCZ9sv9GCwym05ddzwsTZH6OUOH58Z73RGOBv5/VkY12kXGNpjdAHxpFsM5p7Maw+TPI1MfjKE6B+S70jR81A3YvYJ2SAePolxHc+7LDrNWsRsYDCgpIjRa26YbZecFQGneBp1LrA7rvA5MDTnz1ZrzHxPy2vtOqDhNGMILz6Te59/6+xcrC4VsRTuuaeJavQE5clZCD6Gy+9qvOYLedvYssKcvQnD6BE9zzJekgLN96xSfGW8/1TlABt91nP6uOszs2fx6yaPc2EhG0Ctc1ljRrXrnNWrp+Z9OYwV8D5EJJn7E7dLuSRKi72f9458pOH1BAyGdNrW2m8SPK09lF1XB5JDSYMWu20eJAElUV49ZkR+SdLH7lAWkM/CTogolBgjvtlbdbiXFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(86362001)(38100700002)(4744005)(5660300002)(41300700001)(8936002)(2906002)(4326008)(8676002)(186003)(26005)(6506007)(6512007)(316002)(2616005)(6916009)(66946007)(966005)(66476007)(66556008)(478600001)(6486002)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wjIBWK0w3BnhExC92PZvbboixwkpjCV24wboWVj4MvPQQ08s5kBidH7giW2E?=
 =?us-ascii?Q?BcmfBdLonrQZC3ZamtfIGebiQ24xC+irEsoy/MzuTW1iollIqsM1SZhOgcMH?=
 =?us-ascii?Q?ZcNsJzegGc2ii8y6UL+LoRDU/vbDZ/oNgEW9ZHgp5BRfgTPv40ShJYhof1Js?=
 =?us-ascii?Q?N4/OF6OW4Vrtb4DlUA/5l3gkAcVqcCkw3zLfvzdHoT16cI83RN80RzIibrE7?=
 =?us-ascii?Q?mu5tl9REZM7qcKNhz4EPM6KEoqmYaZD85h1Nvs8LX8Mo+FgrglWb2IU6IPZL?=
 =?us-ascii?Q?HukexuruOPhxbknfXJZFlvWPz+oPZ0RPYbD8GHHJcd8vLURUulXbdDUzhH/C?=
 =?us-ascii?Q?axM/amEp58MPgF7jpyP7VCrDA1p1/gIpxDnKvDeSGVHthYTuKIQekcYsYC+C?=
 =?us-ascii?Q?OqO0yO9fUuQ0+Uu1BILWe7kaHi7fWIIyrzeZGi67L9kYgKJS0nsSgDKLPfij?=
 =?us-ascii?Q?0/5vH/5zNlvZx4fBJ4++ejuczBJc7Xoxi/sdvvzfzdayK6gXMDkRTT8UQnr4?=
 =?us-ascii?Q?mTB/Jtz+olXWghrSoRaTV8pyJsFtwVZy5YNBsawgsRSEvRvu6Adfa80vdk3y?=
 =?us-ascii?Q?Q/EVFXI2R5hx8SZ+5M4b41Lu1zsUzDf2m3mRm2qh3JXyM6gdR1d+r733MbQM?=
 =?us-ascii?Q?+tUEsNtJ3RMmx5DXOY9JD6ufMNNEE1vUjmwOTxTi4tj11iLdhp0IKk63JHaO?=
 =?us-ascii?Q?jFguPhx+DMhS751Wm0H1tWSi4kjlQshfTx4l3iG4vNxoLHDk8GDnjsAgBebM?=
 =?us-ascii?Q?/YS9Ion8h0Dp2T0tgbD16zct5nPP/l4vJlOsnA1G44PjlkTqV+d+DxGj2JF+?=
 =?us-ascii?Q?o3k6xgK1O4QLL0jGIYNyKSLZiKaZHZM2TVYMeWFBslt1cmOkH2+/9LvKFAsF?=
 =?us-ascii?Q?q25MVaRfm4U5SDdLPM7i/qg7kkMNfh8CeD3OcCbqfKKZ39gabwKaJHcWQNmj?=
 =?us-ascii?Q?NxeZNHrrBfHBBpO0rYhcikV/o5SQCKMvBRxzVo50EPqYCRHwR8/J1B4ErG1q?=
 =?us-ascii?Q?5Wu++ozqUzVMUiuLDBvSWAxhcOxYaO3yHi5V5WmY1w4kTLWW+SXOXtuBpgRC?=
 =?us-ascii?Q?hVVRGsftfzVwn/dpfA/8aPgsekTY6WpjL31WjkZEVHvLLWDk6ke9g6l5cU93?=
 =?us-ascii?Q?GQXIKbbWa4umDx+RT6iC77xQlI8K0276ENIydKhBqI+FqrbOTmxcPAX1TvK9?=
 =?us-ascii?Q?SHEmco38lUDN5eP5ozIdW1UiYewlwZLbNq9tjHdzKRgtGjDVTXtCSTA17Yw8?=
 =?us-ascii?Q?7TnOmsO6fermMl5Ms12ALZbZrS2ie5Wkyrz3kf3IEpa6mKvjeW9mDgc34gAT?=
 =?us-ascii?Q?9ftmyI2zIXPcqZ9SEsxVHgr7k3hMOeQDoUtNdmVwm0ZLDx1YkjilElHV48ze?=
 =?us-ascii?Q?5wK4aa2JygynLeYVvYHCEHKKCJfXpeNjjHhQOAgoT657E1qEwnhP7WWjZT8p?=
 =?us-ascii?Q?gpG9ordrVTpz2g+jmwhf3fGw09dQdygWVyYN0JdH2efSm4uTvEZNx+IxBADo?=
 =?us-ascii?Q?lFaBrHUZKHZ9cXHmo6NOA1357zKh21ePkiVN4xi6aIiZFS0qFelCgygFX+6G?=
 =?us-ascii?Q?AYB75IGqI86N1KencPv96cP900m5wLDcXXoXXf/1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca150500-2ed0-4694-b465-08dad6c6bab2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 13:43:45.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dnfbqzl8QWikZ6xRtttB0j29tLlMgsUJ+hcgzzg0YR+QvNSP7GrBAULAzserc/ju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5732
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 03, 2022 at 09:53:18PM +0800, Yi Liu wrote:

> > > Please rebase it on the above branch also
> 
> To Jason: done. Please fetch from below branch.
> 
> https://github.com/yiliu1765/iommufd/commits/for-jason/vfio_group_split

Okay, it is merged in to the iommufd tree

> > It looks fine to me aside from the previous review comments and my own
> > spelling nit.  I also don't see that this adds any additional conflicts
> > vs the existing iommufd integration for any outstanding vfio patches on
> > the list, therefore, where there's not already a sign-off from me:
> > 
> > Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> 
> To Alex: thanks. above branch is based on Jason's for-next. So may have
> one minor conflict with below commit in your next branch.
> 
> vfio: Remove vfio_free_device

It seems OK, I did a test merge

Thanks,
Jason
