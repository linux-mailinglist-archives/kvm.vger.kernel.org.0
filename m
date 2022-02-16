Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379124B8AD8
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 14:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiBPNzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 08:55:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbiBPNzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 08:55:13 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C461EA710;
        Wed, 16 Feb 2022 05:55:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkZzc2s8TcIrO37RXMFo6XuK0nV4+3s7xqolmB8KG/S2BGkr97gyVVD3nAfNm3ceDywPsMGFxFgeC5ASk0nY/w1z2fnDXjlQQj5OPkZ4Z6lDhO9SdHPIbm+7o5AO12vderJRZ7ZnU322e2MSzphbX0HAwaF55SS7Xhe8KwnkZPP2s/hM8kP0eXu9H6RTWfuu4ZFZFASxwrYKySo4+ho28g0WpzGyTO/CebLYZ/CKSGq0672P7nkajtVAZF1+WFSgsTLb1mgvl0UJuLs/wQrTJ4tUN18UmMvjEawWhPKppduk5YJAWiRypS5XtUmHeU8VAzOKzO2Z85am1rc+ZOa7hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y45mihYmFTho5NIEGydamjQBTM5g939SS8D57Km7vhk=;
 b=GHmZqBc5Z6wgMDbYbQS263fldqmi3U58EG13ZfsxpwfyY5Ur3s15neoRoDG7jI2NWRYKzBWA01/BccX7wPoO9KMFhVzVQRvtpDlfn8tOqyk23ADlJqrQMckA2LYZYEOvN6U63UJDVW7wvH/nrHMQmJomTRoYf3+cZvHxH+Y+XHLpJKz5ISCR5I+bdJVJWOkCiWMofF3PLgqIywUmt2mG7DZJcoDd5YdQQ4EHfxAwJQiooIRUoNmKqQitRfwCC2VudnaM9jGXnjwxR3AIlSsLwTaaIh0mgsrAdwm2RDy1WAggopgMNCGewYOYMfc2Vr/T1labPWLS8TpgHbXA+QwigQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y45mihYmFTho5NIEGydamjQBTM5g939SS8D57Km7vhk=;
 b=Q+Y1Io8uJLm3hHo6uXNmsyqt0mvD/8SkhWB2LQWeUZOV/rDi3gapZzo0w5j0+j2HnucXoWmTV5ykec5C/EMd2y0zsbbjgBQK6XeS2UXbnR1r96+pb9XOsTWXDwmDemx0y0St8Ap+WO1ZaR/aDd/TCqUkao1YTkUDVGKiXonr2xONP2AcwLejMxHjCGDc+5i3DSvK+Lkmbyo4XrhYVJKQSAM3/ELfquOgdVZL0UyQDPe1IwWuvKgr8wmmQ+iN9Z+hlGsQ4StJclrwz7phFGKDQKGXM6MzzRdLHnn/HjSzD4ygTlRo6y19HOOsZAPSSznN+fmTAlg2i8H9TtzvEBjEKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 13:54:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 13:54:59 +0000
Date:   Wed, 16 Feb 2022 09:54:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Stuart Yoder <stuyoder@gmail.com>,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <20220216135458.GH4160@nvidia.com>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
 <Ygo/eCRFnraY01WA@8bytes.org>
 <20220214130313.GV4160@nvidia.com>
 <Ygppub+Wjq6mQEAX@8bytes.org>
 <08e90a61-8491-acf1-ab0f-f93f97366d24@arm.com>
 <20220214154626.GF4160@nvidia.com>
 <YgtrJVI9wGMFdPWk@8bytes.org>
 <20220215134744.GO4160@nvidia.com>
 <69f26767-66d6-12df-1754-45ee1932d513@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f26767-66d6-12df-1754-45ee1932d513@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86d0d7d8-eafd-4da4-1cef-08d9f153ec09
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26401A49DF31FC38EAA085B1C2359@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvv7lMGb9Z0KdAMN/A9OqxMtVKVIfkFUYTs7ZwHpFF8u7rPAQA/6TyEYe7JntFkEilqrw46o5cQgDjr9r85/LBytzjWkYLosmPeW3n1n3zGC2j9i/tzQd93ugNW49N2gnMZvs4v9Mw3dhfOSk26UQSAtqDSKg6jcN2SdrGwRl3SFLi4m9SqS/iyhPr6kpbNqlCKkiPP2NkVzfAV/UV6EkWhMhtScu6PT/eYA0Fs2L/JyaDOOYquOJhN7Gy8dx6rxlQIpHMOwtAOKI34ZSWf1GjpBGK+pXr6PkLtSFQ657vIC26d6nh/G4JrB6LJSfsO2K7uDcwliv8+jT9SWTwck7cKvvpkkhad7XK2HKkpW6Za6Elqn+YUfls7MCJ3U4w+ynJ4G5N+psrRt6KxkPrbS8Lpad1aU8W+l5yz3mSkoW4o2rD/SswNv21/LEFbD1Evw9EI7zlBrtGNFSs+y+qVeEZs1YxNOjiMJzftWDV4n4pFH2vaaxT+4DD7X4ey8dhk1tFJ1kUc4NkrmC2ulBgwANICDJce09jIAguWy6RhR2QPzzbB0g1CD3hl2XBvHS9sTo3ZYRnl71o/lMZAc1nlALLhEVDG7XRcIJlBD8Z+BfsWKQMg3bzvayZ19h57V962Z7qL9ey++++TgNzGkxtLtBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(8676002)(7416002)(66946007)(4326008)(66476007)(66556008)(186003)(26005)(2616005)(1076003)(2906002)(508600001)(6486002)(86362001)(33656002)(36756003)(6916009)(316002)(54906003)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NCk5UuiDLBjp2KBpSna1PT7QVZ/IMrDWVaOjFFG2LmTl5PfTnTLoe5FR5OBt?=
 =?us-ascii?Q?UFmL2eECPJa61zU2enqQqVHbbIQhX0zm74wxQxKw3WPk9M2DHyyBfvd62HiB?=
 =?us-ascii?Q?udvylJoGvS8oICoMCVffkY2ZA1+peimQeDnVyozmgi9kziLRfGnvhV9bz+X3?=
 =?us-ascii?Q?SAoIlslZK8IctTHzbNwefyPBZVuZbxsXpdWj9lCP8XphKieuEHALDwYYK6Fa?=
 =?us-ascii?Q?L7Spopd9ZssfQFtj4hEsnwT8wkvIeLISZNRqSsZSDkUKWsPpvhWFmCNBqx+9?=
 =?us-ascii?Q?BVyHiUCU5XXOaZmQB7H6L4tMrwqHXiNR32feCrB2l9QkJSsLxkxw0q0HnMTk?=
 =?us-ascii?Q?sM8VHpujcBA+7giUZ5jGxlEoPuDCnjTGvDRRbmbZBJ/ZRIcD5xClNHHR2pSD?=
 =?us-ascii?Q?Xdm/EP7lMJ2bONmodSU+Wk+9Mj2rYyi1QvUjBdshzR2zmDeB4Te2DBFMfh34?=
 =?us-ascii?Q?gjyRKDOMYSKhX6JQOBG8F9euyGKPzvNtSD1fskQsXEmG78oz3CdQitzDp1zy?=
 =?us-ascii?Q?2OzaAA2i+bVYUI2cFLNmmh/uNUdghbJ+BjbL0gFkpwfkAjcOGxgGR5NgfD1l?=
 =?us-ascii?Q?4CoXABe0G5coL3btE+C7wD3sNVVwNF2gNTxt2t+H5MM6eeMLDuUW8zBpecPT?=
 =?us-ascii?Q?pcUkKGkwo8f95HicPsp5JRW6hVbljBBlTKVxHibXNwra/HYYC1qB4Zy0MMUU?=
 =?us-ascii?Q?7qvJSHwFCRDOm3yE8YPoh3FvDGc6xEEotwOA/WF8GDvcuKkg2qokiHAPuD0d?=
 =?us-ascii?Q?rFwXsKEb70MqBmUVhCfj4WaKXtP/JGho+VTviFTQHAhTbbO7tr83D6REvwBd?=
 =?us-ascii?Q?jZY3Qar9Rb8ZoB5vaofFcwe6Df775kSKQMy9Pe0wmT5V/2sh0RtYIT9e7NYN?=
 =?us-ascii?Q?l4ZioosE9NU06wAvz4ep/BoSUW5LLztJmzjPnt8rtoTMtDh3JiIOTYjr5laq?=
 =?us-ascii?Q?0zqd+pLRetbKMeMFAJq7o7ySKXrot9EZKtv6Lr7ROq2tetvy1pw32Q/fwwrR?=
 =?us-ascii?Q?dSv5Ll4r019rrXBl3IESigZYt5CWrIPkOi22U5xL0+VQCmHRE/53hwo0xCBR?=
 =?us-ascii?Q?EAXsa2tKNd8JZpynNDFc9RJhhVbJuuRftiQdTw0lpkbVLXytqoADjYDH2F2T?=
 =?us-ascii?Q?J7cKGU5xvRWA97L1nTByR631BbWFgWXFo96Oi5YGV0WsueQ5PpmLf2gC6n66?=
 =?us-ascii?Q?v7AiPYbbsi7SXLMQxAgUk+vVo0SaIPMbKTxWbs8KrkuGBoCYEqxRgnLlSUfD?=
 =?us-ascii?Q?kYKQ8J/NkPH56T8ceiPZYltXV5TmHzrdUQBjdP1FUtCf6mbEzjw8KkMzWLHw?=
 =?us-ascii?Q?BdFDfF3Su+vBjVOVJy51NgCLmJjSu9bY2S5Go279WWXwH4iHeJs3nPRttaS7?=
 =?us-ascii?Q?cWgttau45SUB3NUg+tbZCzcS7ekTJ+iQitcD4aPweqmVjUP28awr4MMZFeKp?=
 =?us-ascii?Q?WpF7iGF7kVzvy2F0+Fmv6qQ5yUKiKRRlKsazidFF+B2hspOR9cXp4sHUPBKh?=
 =?us-ascii?Q?46OUneVl16OwgkQZ1zWvqls6C+MwuWv2PzgXybwjk+oGHsCpp10tv5se9zAd?=
 =?us-ascii?Q?xggIbO1s9nPat//2X3M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d0d7d8-eafd-4da4-1cef-08d9f153ec09
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 13:54:59.5797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iPCOqwOn8IEnRqKV2gqIQBGNBIfeNNnNlfIGWxzDU/9KiyrVnqCHZq7sHiHyDDx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 02:28:09PM +0800, Lu Baolu wrote:

> It seems everyone agrees that for device assignment (where the I/O
> address is owned by the user-space application), the iommu_group-based
> APIs should always be used. Otherwise, the isolation and protection are
> not guaranteed.

This group/device split is all just driven by VFIO. There is nothing
preventing a struct device * API from being used with user-space, and
Robin has been pushing that way. With enough fixing of VFIO we can do
it.

eg the device-centric VFIO patches should be able to eventually work
entirely on an iommu device API.

> Another proposal (as suggested by Joerg) is to introduce the concept of
> "sub-group". An iommu group could have one or multiple sub-groups with
> non-aliased devices sitting in different sub-groups and use different
> domains.

I still don't see how sub groups help or really change anything here.

The API already has the concept of 'ownership' seperated from the
concept of 'attach a domain to a device'.

Ownership works on the ACS group and attach works on the 'same RID'
group.

The API can take in the struct device and select which internal group
to use based on which action is being done.

Jason
