Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5797766F3
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 20:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjHISGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 14:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjHISGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 14:06:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B67E5F;
        Wed,  9 Aug 2023 11:06:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcTpUDHroCJcwBJ61w9zb5nHsrYAtvgxXcBn7o8UsPicZQVCF7BkKaHgkKILPgCEFXsJD5KeXaSe3aSSL/g9P1lNMoqUWKtnTvqCs7q0ovcvylFL7tHvM8tVE/pbzSs8m9VK3mu3/N6/JnFFoxRNwFFHMJ5hYRF7Vm7k7azCOlVUehskauGbAt7b+vTkngGJPEge8p+F1bwc27B1RjuHiKAQEaiwer5X4kGyojnTbkrVRLqSwumbmSIj2zHPzZwYiHS1Y4P+mqmx/VCffbIFw3W6+g6DHkD3CylVov3uXNk45PhWzhlHez6AUlbDhPIkLpF2pjOKA8InY9YUXVNVLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gsUSmuNdJRki77i0jm0+qDCkOqA2IV0mhcdhEhnH9c=;
 b=f0zj4XsqQZn0IWXPJVYluX30C9cZg030XibaCcYrfxbpT0OaKIafXHB2j0gIwL3rswaJ1BVzoQLhlJPUMEreec2HcTcUwQcYVKrOYrMgMXlZ/GhcnFWTOBKMtTNLIIygUjW2ehssKJx1oQLw1SuyIAxXt7VZZefOudcH1uh5gyC79EtxwkpaIkcV3O9xvKB5YrBzCtOodSwC/GSm2gA1GP3lB1DJrutXLnMLu+/Wtg8miU/DNB/BbzSuu39UnuxMgWAn9k1coQvC5vRUJgSeWaYlUvBtPs+cpYFpWsDgFZxi7tbn6kpBruX2HoWUMHSJD63/2DpqUSrupfwJKrreLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gsUSmuNdJRki77i0jm0+qDCkOqA2IV0mhcdhEhnH9c=;
 b=miU4saXyS/ZjeQni0CHwg8ORTh2F7X6IVkTSUgkqokGzN71fHR99bUtfbbNNz2x/1e/NFl8TuY6I7tPP9h/0dc/BLVIxfktPe++5m3ELC7IMAwAeQeD+axWhP9z2ntOT/YPt3dxGGful4N3mcdiruuaopFJFL3/kizDBRdJZIaezObUwZkMErvZ0vS+gt8jMD5e0uTaZmry0Mnd0O3SB4vJnXblh52NRiusvRuYKTWD9NrrvmhrZMYA+5ocg0yvA9axQ9XcUjOFDWF+yZkuUmzH6q/32FuJv0wFdT+Prfve8QChuzuiLggB4q4usw4WzxeQi6p/nl/Er4UeFA7cpMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8106.namprd12.prod.outlook.com (2603:10b6:510:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 18:06:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.028; Wed, 9 Aug 2023
 18:06:20 +0000
Date:   Wed, 9 Aug 2023 15:06:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Brett Creeley <bcreeley@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        horms@kernel.org, shannon.nelson@amd.com
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <ZNPVmaolrI0XJG7Q@nvidia.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
 <20230807205755.29579-7-brett.creeley@amd.com>
 <20230808162718.2151e175.alex.williamson@redhat.com>
 <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
 <20230809113300.2c4b0888.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809113300.2c4b0888.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0181.namprd05.prod.outlook.com
 (2603:10b6:a03:330::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8106:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e7656f8-c19d-4bc8-f20e-08db9903558d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0liz3Bb1z2B00gmVgiyPfk5tZMoHeft+fjof+UADNl3K6b2bNDxSBYOKhGlMMiEZSQBBZNYvY5P8mwOX27esEWRCiL5KgMY6kxVqfE5k1DgzsIDX9YaDz/wdszkJ1S217ILyrauJqUKZz6KLBMipn+WOfqSSTPOQFg6P0I8soDpK0xurkAJVedtwoRG8hbYypo/xeQbhvZsABoYDMLHjGea8o9EHyPpyqJatKE8dALGiTqzH4UbAJSSGs1qTu8DZYQt1QxXBI0U85r3HpCZEMyRigrwylGAd3Y5JHffA8ij7M85aIcFiipJinxBQjbu4MGRORAdlzT2cJgRg7YZvWEeqfLaJSwDpbOqBnhsSiF4ry/uSR2B/4zZor6nm0k4n6ZGMjMtfxaDdpchrU0f6h6Ik9yW5nFf+Q4n+L5T/inx7wxnN/+FrDD758opIRB+PMffOvoj/j3Ou9T/KkK3mRCrg1dHzABWwIvBHx38gPOGtkM3SrB59U0nrUVrPq4+JUth3uZskK/26FO+h04Gpx/MEyiH/fGf7VSYDR0yJQHaMf2ByBZWF6JV1Yb6OfQQshhwLWcX/ERAgpa77opsMx3pl0G2Y+RHEqClbGaZObU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(186006)(1800799006)(6666004)(6512007)(6506007)(26005)(6486002)(66556008)(316002)(66476007)(8676002)(8936002)(41300700001)(36756003)(38100700002)(54906003)(86362001)(558084003)(5660300002)(2906002)(4326008)(6916009)(66946007)(478600001)(2616005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1U3qfMaT5rJ4DQ0MfYGAsRdHtlzpziw4LoBPXuuOQTjp/sByeCBEwv8Zrr1V?=
 =?us-ascii?Q?49fxz3Vr/sLFepoqEdixruU+NK0EcRccg1yraJQ4Oi5ZrvP3puXcApdyKPZi?=
 =?us-ascii?Q?F59bfYgFsB9Tqd7jEKH5ShmKU4pkw8S3T//m04fp1P5vdAC5FnhJeIpLqbfg?=
 =?us-ascii?Q?EoJuJYL8V04p5F0IUEutnG+5PeRyFaQqvAIV20k81R/uCL4sEeB1LE/C8bdW?=
 =?us-ascii?Q?O9EvrQGRgGjUdZRU8HoYU0MRYln+PDnTA7Fxq4EfF+nUd1ssbVayFzzwDyaV?=
 =?us-ascii?Q?aEa3MFwAiPAH5rPSucbiicKY3n/xsfxmnT61Ny5tMNGMyCEPRkGznWieIMSa?=
 =?us-ascii?Q?7ZxVnJLN6a449berRaVzMs6bwRUBRuvYXvI5kTlg8ECtPZC4mHL9TOlrk49q?=
 =?us-ascii?Q?3+nE8RNrjC7bu95UvssQv7UuhkEWo98IWVhpPTjRNvvBIDNtvCxPwUKx5UbA?=
 =?us-ascii?Q?mjblypt050ns85fmz6ykcWQquC1XPwoeIBFSQol6sOOAXFhWOxxe4XsQ0tMa?=
 =?us-ascii?Q?zTXfGVZBsehcLHCLUWgE/51MGksDw6/BsbTemlrW1AcS2KUMVX7AP/5ysqSF?=
 =?us-ascii?Q?hwVjhVhdhtl9vf9dFskSjRjJMOiRZXhwrWwqqIpzOp9sJcLyn/USgRNlMjcm?=
 =?us-ascii?Q?NDOO9ISM++mKFcKp28ItlbZQ19YBUgQtnUZyywrkRVGrylx3Uk+j9a0i5sJt?=
 =?us-ascii?Q?sTHVMDHuRmbQWsvXtQSIlW40LI9HAETX7ui5r1t6DVQFzegN8XxSud/8KmIK?=
 =?us-ascii?Q?fnROe8x1ge2nHnI3upnTbT6Y9gMRA9aEqREtvxgKkC/MM67ovX9LOLpsgG+2?=
 =?us-ascii?Q?vH3Dt4wKcth3cEWaCOObZ2qos77+jEAde4AxGbO1ICrc559hG6ZrDL2AgwLG?=
 =?us-ascii?Q?jETn9qV1qg2q3Y8i8KfkgWvZkUncnuDaZFSGjNnOLKy5E060ggnEbBuD/FXp?=
 =?us-ascii?Q?0ngV1KeAkAFPKU1m5LPyh5OXp/dhutWerDLioHuxLCPWdi1LZ/AzM1TIUPFs?=
 =?us-ascii?Q?sWMezLHoszsWs1CPEV97JnV6J4GIbcGizGZaC8bLEyBt9GfnoyVIBO4OG8K+?=
 =?us-ascii?Q?LFQQN1NyTiYDAEzuSfqsgwo+nDzVSwX/wrNqSLuzgmhoUfMqZ13sgQHrY9dd?=
 =?us-ascii?Q?vnybLFExDoL4996IYpX0uVsmCfAaX0h6LO9uEmgTpNV+TE2UAIAjFGrjUgGV?=
 =?us-ascii?Q?d9MoZ0r72yTp3wZ21Asl7IaegI8cjScKIMjIv1Wo+VGOwTvvWOaRQdpUwpuq?=
 =?us-ascii?Q?XbvVMRW70Q8s/ETA3Ugnf1bexMYcMFi0CwwHyhkszIBlpPahOY/AdMg/mb6y?=
 =?us-ascii?Q?vfakgvfUoByC+/sulsLIVjiCSXTy8xw1yi4smLn3+Zua9a0/+QgUgMw7psy6?=
 =?us-ascii?Q?rc48XU6b7CfRclaNiuYPUyaesb8zX8SQU/uLh1WYoN0WKM2DgPvul8l+zqK/?=
 =?us-ascii?Q?CFbTsn5WIr7yzSAqoGWSLT+aPB77qP/WCvh7HIhv8SgEne9VM/ba0GG5EKaN?=
 =?us-ascii?Q?Di6ZVZnnxapMfRok7vcPzZufHixEEwxBD23ZAEYUmR++WFfec7HkglC7TZQw?=
 =?us-ascii?Q?xODcrJnakywQxbjL5XSCAsT1cHKry2Nm1VowhYvC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e7656f8-c19d-4bc8-f20e-08db9903558d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 18:06:20.4307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LlP9rsogg+ep3ocjBEIDQd8H9nFxnj8W3LfHqipaSYbZsRjx6kvO2+8BNgHr1Jv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8106
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 11:33:00AM -0600, Alex Williamson wrote:

> Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
> approve this series as well.  Thanks,

I've looked at it a few times now, I think it is OK, aside from the
nvme issue.

Jason
