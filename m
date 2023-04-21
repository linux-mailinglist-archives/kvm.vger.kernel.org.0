Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C596EB149
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbjDUR74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjDUR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:59:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345AB19B7;
        Fri, 21 Apr 2023 10:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO6jWAUrORuLfdCCltLUR49i+jMSrvpR638pPEPUi35d04DO2Fc/x9HCruYB2PJxlyUMs26yBab9Avcb1H8cJgK4es/GXTkDK1LHUFi8e5UaGpG5hzOh6STYY0LJtNJpGXT9FeDEn01+32KOzVug79HyvFLdTHnzqAH/bXfzHz9mpaKqWGymaoAgM/RMLeu4H6wZbKTGjaqFs4S1+ZZs3XConZ+FShS0oFAe/cBzmjbH8djRG3I9T4hxBum018uO1ghC/gs2n3O197C2b2h2b6qSNeIMchR+6oQDJNiZmufEi8LgYJgSbJ1pZAqkf+Kn65Xj/JUmp9Hk4oau4z3zNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrF2sQhExta0LK2UsECr2eVyfC8lu+pRa6A1ZAzpThU=;
 b=f2FE/iVekfG9ErDTd5PvOrq0fTZ1Qbasd4xVPFxpsL7GwxoSjWMR47L1T+wKk+vvhJmj5Hm2pFdam6Ukffxax8kc5feNQTbdtX8BHZj+fl+NMdMbSHg6YjwQ5IFv0vsHJs2/1TGah5Qty0/E1Z0QGTd7Q+LiZ7/OFQBYPXCdqCZtdoaSJLjKzytMvEdjRKed5Znhx/qsRYsC9JuhrYRbAe8r70Rz2gErdyk3stoo1CfCFMaX3hCJFSfQ9u1m91BBmLAp1Be86OBlOevTf8Okw3uHrIhqdgCLdo+xdXsatVi7qdg777t9rktgJu4cndtgYNAXK0yZf1inUVFcRU/NrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrF2sQhExta0LK2UsECr2eVyfC8lu+pRa6A1ZAzpThU=;
 b=ST9lb6Zae+BAG2k2KeGCymcPuRKCSbbgyMuS+Y52uI9M73E44Wm89Aa5GbBCcTeExK0Kf9Wb+Ip7De0ZXa3WMRhEHKVSxko2OzfVr+G7ezFE/8fSMIDMyO9+wrXNtY9xeoyeWF03aFsPFMpxUWDOm+hEIy5aixteFMlrvjk73dzcCiFsj+5vAGRHihF3K/TnDGlcfxqvpESW5tl7HzUnb8jbg0LvE3+/paoMiuLz/J/CX6YGq2T+oHdg6z6XDg+2dR/G6Mk02rgcYjLrTgVRHQj2/mD40FbYW/ztYwljcyheDi0jTJlQsoKrOqNWLg56PICoV5KRa1j8NtZy7t7cNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6936.namprd12.prod.outlook.com (2603:10b6:510:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 17:59:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 17:59:38 +0000
Date:   Fri, 21 Apr 2023 14:59:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZELPCTOEgU8XlhFh@nvidia.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
 <ZEKLDzU8C2niNyOw@nvidia.com>
 <ZELJ0uv4gGCPrDfX@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZELJ0uv4gGCPrDfX@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:208:23c::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6936:EE_
X-MS-Office365-Filtering-Correlation-Id: 35056ff2-9d5f-4b98-73e2-08db42922c89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y5oSOTQckIfa5QeqfAxoSeVXKqgiDeOuHBbl9xX6QUsEnH1A5SE/1+RdZgC20drk5zWM4PTZckNv4z3wrQyVldPUgPRnp5rh7rkkYQxAmw5fn7qtjwULUg4sr7YpGHKNAI2lOdBVTGXcv72e4XkHyKz/mTpeb9UId9aKCHT96OBgMdFP55lCCzm2355Bsu9AIaISvebIQUueGXfUNIf/63f3pOkFZikVBjw+Lo7xYzx7saydH+JFIK2pMzqJufvOpn2P5QK3NVxmL04p08X1w1J2dxJvsuaXQ0kvb+LXGDPG2kBed0pu5ymhGpGNzoUNfoXYALicjnGiLFzojjs0BPXQ+sNFXLr/BACRnY0PXK4chDl3s1Fp+CWNdUHlZFBrDh7XuRZgP89P2wDMVwhZEZqPe56ZEmCwCLqIw+iDmQHbLuPzKM3ZgLZVnih+Beb8Tr/qigYdbJMpqH2+h5xmijXhsBH7YrGEiPHkKB1C5kPiM0AZXf8th7hnqYkzGZgJkgE22Kur8YiHudKZ3pnFSNc22INGe9ReOph+1cJiTaB2b+4KMTvrPp0WCx1jB5RM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(186003)(6506007)(26005)(6512007)(4744005)(6486002)(38100700002)(6862004)(5660300002)(41300700001)(4326008)(2616005)(66476007)(6636002)(66946007)(8676002)(66556008)(7416002)(8936002)(54906003)(478600001)(37006003)(2906002)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?39VkWHZqd0M+Jex9jSD3e+z5YHhZvBsRJcbfZ0pDCaokOEviR4CrOoUWGCLt?=
 =?us-ascii?Q?Jrv7HlYOD05UYw/QnbbnmykqJcLMEaZf82UMoKGArr22UnSmczXHKaM3YMzM?=
 =?us-ascii?Q?iPV/bNsoAhYUH9/6UxFhsVNtwB1zjIi9OSWZduqUunPyVviUCsB6dmi9S4Gf?=
 =?us-ascii?Q?4ayfwseKTvOlq00AtXtmhGRo30uAfy+doVHNgqu2UCN7DTvxo9EepFpZkg//?=
 =?us-ascii?Q?BCGVvz45695ExCjbfn41UpOnu2uG3q06llPfHYTdTn9evovVISZclXpOQUfC?=
 =?us-ascii?Q?azMja4p8ViOBXr4DENslmmvq+bNZaHbAoCtmD3ji3I/v9GPLpmB6XhGwOJh8?=
 =?us-ascii?Q?gxjaye+N/2eN/XcNbIHYWQetBT/v67OLfo8QmiX1QG/RXdxJ/Lad4Pjqhy8W?=
 =?us-ascii?Q?atItWmArcofhaolZVkR/MWHg5azHJ2LlPsX+yPvDraC5x0Y+mWdu7MYJK7kG?=
 =?us-ascii?Q?3ZF2ShyQG1ke3G9lx1KdLJETPUJ/ahH/M3Ta0U41BVW6jzxCtORDKtNLRLq3?=
 =?us-ascii?Q?ZTzbBOmk+keDij6Csvy4PxG1SBMnTMQtRQXpdu3zZR1yr+dG9R9LduslWxLU?=
 =?us-ascii?Q?ocpKt/DmBoCMX/WliuoabfVWXH7vvfBeYsntJECp2+rGggc4hYA3VM9tHWnT?=
 =?us-ascii?Q?bwAeF552HmR8+i3N//zd2Q45rkXg0yFoLCThHpg+COSCOSzUl9uOOjq6jMaS?=
 =?us-ascii?Q?7XcSMyTzvb/ASQUO35R5sx7X8RQoEr5Y5++MdVH0NyONiyCOz4t6fVvl9TXy?=
 =?us-ascii?Q?OhGGylfRHxPD11Lw59csQ4JIIDcYTrFKCtrb1ZKe6cTpTjhHxZUUiSBauJ4A?=
 =?us-ascii?Q?hrHEMXfqcTmqeSStVbledGbzJiE2eBiNUkNyTai0vaor6MFyeGZ5ZM96Ki2X?=
 =?us-ascii?Q?orcNyB01I7pqmmELUAorF/3eAwbipPeQIN+cAhIWVADmI6olB55yT9gpkaWE?=
 =?us-ascii?Q?1h9HE/3qyLbpvW6882isMZAQn2TDvUNVuX3I+McSYoBYG5UAr3BNLbRWFtfo?=
 =?us-ascii?Q?2CLaJHoy837yY9l40me4YhetbCof12bXIyImEjJtjq/ZUeYTRrnMoHuvt/Sv?=
 =?us-ascii?Q?SuezugthfFogMQrpSveXLoUrz50enbaanSKyBjcPhWYiVK6n0ea40/ZljQj0?=
 =?us-ascii?Q?9NVg88ZCWda3BneZ1xzlzHSZPha/BcSM8eAyoAOmlAfh9RQ+B2SSY94drVqa?=
 =?us-ascii?Q?g/aRxX8OGAhnrL284BLKR9OFjwU+HaCo3JNtRk4VhZIHrkO5e0fmfhgr8yoL?=
 =?us-ascii?Q?NK0vCE/7v5F4yLQX5osGZil4XBA9nQRSjPWY7+zukHyu5IQ/6lCjGQikHWKR?=
 =?us-ascii?Q?zBrnNdU+K8Tf2oFoYpHr9KinTZjvbSNhe35Vvo9ZutOt23bAdogyUkjhX1Kk?=
 =?us-ascii?Q?hT6u/+qAg+sULxT3EnWZJCnrdvnETCxMm/t2v4sFX8txEk8qLysS5JSkG/Zu?=
 =?us-ascii?Q?/YrtQg8tzAe8dzU8pTJ3adcwGstyHFJgrcPEE+TnAylodaHSxXRwTWGPbfj0?=
 =?us-ascii?Q?m/MQ7Q2sMH1UjkRGht2LjtdzRKZ1qcPF5uq2+nXioxZndF0SXIvDSBV7XGU1?=
 =?us-ascii?Q?1bf3dM6nAOUdk6jJF/cB1mUqlMtXu4x6mE2G4pTj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35056ff2-9d5f-4b98-73e2-08db42922c89
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:59:38.4328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mebB7w/4yW5VWNr/TjLOhn9jOI9r74taliLvRtQeoQCnHnJdWaSPcNL4g3N44x9j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6936
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

On Fri, Apr 21, 2023 at 10:37:22AM -0700, Nicolin Chen wrote:

> How about the following piece? Needs a test with QEMU though..
> 
> static const size_t iommufd_device_data_size[] = {
> 	[IOMMU_HW_INFO_TYPE_NONE] = 0,
> 	[IOMMU_HW_INFO_TYPE_INTEL_VTD] = 0,
> 	[IOMMU_HW_INFO_TYPE_ARM_SMMUV3] =
> 		sizeof(struct iommu_device_data_arm_smmuv3),
> };

If we need more than one of these things we'll need a better
solution..

> 	rc = ops->set_dev_data_user(idev->dev, data);

Where will the iommu driver store the vsid to sid xarray from these
arguments?

Jason
