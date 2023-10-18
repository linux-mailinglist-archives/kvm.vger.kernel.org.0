Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFFB7CDFC1
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345694AbjJRO3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345762AbjJRO24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:28:56 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0882F24F16
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 07:23:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKZ0lz5KPAUKMKnyoE98Adclq1pR7LHSFJKFQxRM8ObIvA6LSqDeZtEBLeRQwV7eaKIas0p/pC5swx0Cscm+eZQsF8UGbqVj4K0Z91qA6I6bhQeI/grfc7xjPl7Ki0nWDyEgDShywIz+zNyTopYCNcITp8BOYtWHxPxqb32miYgt2HBXYDTj/3SSEG4BfboPDgzXE4zAoqr8Ar1esDET/DyWjL29uP48tDyWOAITBtCeFwC71mu2/jzs0/A1gFCibuvo3gA/1G1O1HPe0m791zazJtZyFr9GpHfHJnCh8k+e1+6UTNDAIxQllRrGAbaRsoEpctBSFEB4WhaxskqC1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUfAWHIToetbkfeadtl/mIzSYB17vCIobRk08mqNSW4=;
 b=W3Qyu0vwBzNFPwQQymbnGB4667MhB+Z//6bwc27nhudpSbQRSp1urAX4dAajWezjuf9o1OBt+bb6MURg5UWx2nZTVFnXDaBlInji6Gwv7ILPBttzM5TRasyhGpPakhfQGfqmQkipW8INLnERC8AB0+NIXYbt3ZSCkYvNo8RnQehp1NGE3L9TK1154PXgRyDQgzi7I/gzkP4oJzKO8c9/mnpFoHxJ7ukRPZmnyy2tTR5H7RO8KSWmU7Aki5m8T7SpoI5ffLIF9AO42mKzx52JWtg5SPFOyUZhnSvl0oO7KG8q64CEglAduIT+kBveJVdQKl6qNkSJxYz96NGqC8Y2Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUfAWHIToetbkfeadtl/mIzSYB17vCIobRk08mqNSW4=;
 b=HbzeU/9SJHouPhyPyDMoszmHcIKrR0pMSFwv18jjViJv+xV/yeXiD8mlvhXxroMjyAobao/rB6ABKiIN4e0AkMY9Xmd9SbBwUO5iwYcoekMYCsNHC+VRjIIJXXWZtMXUNidRFN+Oq/VFRNQdmvOiz4bP8skMok6s5UCWQZNFRpQIsCQ2prBsyGt9X7sj6YaZNBtzpgizi7/5LVbwIEvbQ082gICMJ9srsqNCEHOo8Fsc79IAVAEG1dibribZRxI9QuCkTJcVvQnnzlYHn96xfu7ZFjq5gTLD0ej9LL37LqZD/FHjGGMIq5tIKZOnIpmS4oURHDwqfUCrxuORGgI8QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7134.namprd12.prod.outlook.com (2603:10b6:510:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.24; Wed, 18 Oct
 2023 14:23:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 14:23:11 +0000
Date:   Wed, 18 Oct 2023 11:23:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231018142309.GV3952@nvidia.com>
References: <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <5ecbeadb-2b95-4832-989d-fddef9718dbb@oracle.com>
 <20231018120339.GR3952@nvidia.com>
 <c8cde19b-60e0-4750-8bdb-8a97be26468e@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8cde19b-60e0-4750-8bdb-8a97be26468e@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0024.prod.exchangelabs.com
 (2603:10b6:207:18::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bcf6cf0-ab1f-46b1-a0fd-08dbcfe5c1ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQUQXmz9L7U+Ot1gpAMrBcEuDsu6u50D7y6qsNWi6chFI6cyPmx4cxscpPj/3wIUDdbrmtV7bYUQVU5uZbmcyFDkUqnwo4xJ4mgqJ5lCoc9/R/gMilsYGGHLs169iQxfrTGnVX7UNE0TtnwbPE4Uny5PgJUPL7xY0KIKKEdFCyX8XPJxaKfupiIcVNQ8NTeUINSTchOjHqgXXa9NxIUptyBibFIkwgkTlQrdYtRD6r+dgqO+qbu+rQ/2BG3ULZwwSA8nJyyUoARiEjCSBRPnq5SwOkKlKF3r0PR5yyuYCkziwaNFQoSnGSkrm6Ah3A2ZVraFPVDhAjVSVuhUZg4psyGb+idnfgG/BUPKy2A+x+G+H0lLBtWQs84TGHeHxb/kh/H+qgFc75nqoDIH/hEPlAdSdTbX5e42bpwYWmz3ERtyqSIK7VL8AhPwTUZxz0B+rrLB957dtZyHGUxTqTvWbRulkjcFVB+v1mTpuk3ST5y6NvdnkmnpeUIYgHZoLUpBQE0CJMIhFIHUoYMg3H4Bh3iGplCmFhN9meQCECqVXOzB3j/P2K7YWC6gDL/5IxAC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(39860400002)(136003)(366004)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(38100700002)(478600001)(6486002)(5660300002)(4326008)(8676002)(8936002)(86362001)(7416002)(2906002)(41300700001)(6506007)(53546011)(54906003)(66476007)(66556008)(316002)(6916009)(66946007)(6512007)(2616005)(26005)(1076003)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x7lRJTTnohGDFUwgN+xx1DvhQNh4xH+9kfoXmKGIsCo9OB9V4vQeNgNwWzfz?=
 =?us-ascii?Q?fJdc7Y7h5yTEjN5YCEJ5Fp42RrNZONmaQfyRUkGnr5hkUJd78U2cMUN+H6Op?=
 =?us-ascii?Q?2FdmPpJNmd3XZctbSRHALZDNXmVup+2XsRNMG4dYGQryQu4vdFxForLKRfWr?=
 =?us-ascii?Q?eLRANM9xy8u9LMIKHb/FaEao1mVJxF2qtqnKyHT2hUzcIfKZ7U6AYmV6xI4I?=
 =?us-ascii?Q?AlzzyQtpnBpcvCg+JJZzn/BROoQHZ/fqodKNgp5RObT+goAh1/WDQxkm7gGo?=
 =?us-ascii?Q?274nFimm43La+S5n39ODPcvPdGtoFqhZreIb7QHxQ8WkqfkffHNlbG22MPIC?=
 =?us-ascii?Q?tKe7GPyLTnRffAgQh1BpqhySuVgdpyyIE9uhvAx7RyW7rVjGjMl6O1VPmkYO?=
 =?us-ascii?Q?trVg08TI6TzytoBNorMTl9/JCHDTiOwXZS6boHRoe1dRKGGvD1VY7FhZ8G4K?=
 =?us-ascii?Q?gfwUNYw5GPQasNoRYVetuUcniXCezDLuDWTqslCwjlDKrUBVFWJrbcPAKoHH?=
 =?us-ascii?Q?VXuqtqSGuhJZrURBEzVJkN4b5R/xYfFJiI1Pn5ZEcjP70avvPJTFZ02SnNsv?=
 =?us-ascii?Q?ujr0hUenBHEsKtmuHFNj92kWG3JxZ28SgqeiT/GfYawPELwHPex6Vy6kNoLq?=
 =?us-ascii?Q?dfvlOg6qR58uzKzJxrb2ES8JekRBdgO15I3JhHpdn7rlMphBMJPG93HggjJ3?=
 =?us-ascii?Q?yYWoB+HIWhMmFBBQ4PQzcAC/ynPm1KUu4stk46bK+f49ss6qKwuoPgTy99o5?=
 =?us-ascii?Q?mSQptftPjWPM5CSG+K44mfNZiqSZ8Wa+tkn+BIdKe7y/eGlx+l8zCpMktIYZ?=
 =?us-ascii?Q?ThqY4Se1if5aNtyFGQaaMkshZG0PonXV+5NUVs5YYCvLx7ZOAK7Hzxp5w9u6?=
 =?us-ascii?Q?MOxL4Evm0ACRGAbz/GaC1ZEhA6KZ0qmmZKVVnG6Hz5QeycZscTGT9JyLa63k?=
 =?us-ascii?Q?bQG0lAn7T+oXMuJwkMJ3EoxO1BcJebG6kDATz5LzuIaF3USgXM8Wsj0Bo0Sn?=
 =?us-ascii?Q?tN+j6tCEs67Rwgy1ArNaD5Bqmiz63F/VDjYw0OfVqrJ4DjjJxYKcx9/L5DM4?=
 =?us-ascii?Q?fYoyt3tXqJ72ckKfPruYotyr/tjRtPSYPX4jispJTH6pZyJ5RW74kcsnW1c6?=
 =?us-ascii?Q?LA8Ihohmd60y1Sr5hH0cIMbWA7cwDXltltYelb+VmJHZ5TOX0kNfa3k7BFHE?=
 =?us-ascii?Q?x8TLpcVmNKYox9R1OJZS4qWWns3S8KExqev74WkLEzytKSmDKlr6+wl1R1EZ?=
 =?us-ascii?Q?H7H1YABrKYlxQ0yp8+4sgUCMxA/JxFUneNfAePZGGaL4hk5a8p6ADY0PZEa9?=
 =?us-ascii?Q?rxvSC1wPLX8ILfAStZ3U+uxyFlDhzb3gR65jpCk5v5LiaSAbDmhcVI6mrTqP?=
 =?us-ascii?Q?743XxoK/Q1QrX6Ri8/U7RX/qM+xaEvOuh0bLhoTwltBfr5JPBu2z5UTikWD0?=
 =?us-ascii?Q?5O3XIau4MYcxgjpeh+lVNyoZ6LgrldJk35DA8yd/JcVvwgBZ3Pa8gYVTOAPR?=
 =?us-ascii?Q?gpDog0TiOLi+G1NhXOg8i2KX93nKHsEzjxYGH1nkikefykZdi5aGNrYMTBIP?=
 =?us-ascii?Q?MDp10knq9+LzJ//hViby7Zfs82d+9ya3xIRgZooA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bcf6cf0-ab1f-46b1-a0fd-08dbcfe5c1ab
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 14:23:10.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FQqaRpho/5YlNgofnhedVZUDM1J7Symv2HlOwBj2swhIp+bZJiVIp3DBd74yo7zR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7134
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 01:48:04PM +0100, Joao Martins wrote:
> On 18/10/2023 13:03, Jason Gunthorpe wrote:
> > On Wed, Oct 18, 2023 at 11:19:07AM +0100, Joao Martins wrote:
> >> On 16/10/2023 19:05, Jason Gunthorpe wrote:
> >>> On Mon, Oct 16, 2023 at 06:52:50PM +0100, Joao Martins wrote:
> >>>> On 16/10/2023 17:34, Jason Gunthorpe wrote:
> >>>>> On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
> >>>>>> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> >>>>>> index 99d4b075df49..96ec013d1192 100644
> >>>>>> --- a/drivers/iommu/iommufd/Kconfig
> >>>>>> +++ b/drivers/iommu/iommufd/Kconfig
> >>>>>> @@ -11,6 +11,13 @@ config IOMMUFD
> >>>>>>
> >>>>>>           If you don't know what to do here, say N.
> >>>>>>
> >>>>>> +config IOMMUFD_DRIVER
> >>>>>> +       bool "IOMMUFD provides iommu drivers supporting functions"
> >>>>>> +       default IOMMU_API
> >>>>>> +       help
> >>>>>> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
> >>>>>> +         drivers.
> >>>>>
> >>>>> It is not a 'user selectable' kconfig, just make it
> >>>>>
> >>>>> config IOMMUFD_DRIVER
> >>>>>        tristate
> >>>>>        default n
> >>>>>
> >>>> tristate? More like a bool as IOMMU drivers aren't modloadable
> >>>
> >>> tristate, who knows what people will select. If the modular drivers
> >>> use it then it is forced to a Y not a M. It is the right way to use kconfig..
> >>>
> >> Making it tristate will break build bisection in this module with errors like this:
> >>
> >> [I say bisection, because aftewards when we put IOMMU drivers in the mix, these
> >> are always builtin, so it ends up selecting IOMMU_DRIVER=y.]
> >>
> >> ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/iommufd/iova_bitmap.o
> >>
> >> iova_bitmap is no module, and making it tristate allows to build it as a module
> >> as long as one of the selectors of is a module. 'bool' is actually more accurate
> >> to what it is builtin or not.
> > 
> > It is a module if you make it tristate, add the MODULE_LICENSE
> 
> It's not just that. It can't work as a module when CONFIG_VFIO=y and another
> user is CONFIG_MLX5_VFIO_PCI=m. CONFIG_VFIO uses the API so this is that case
> where IS_ENABLED(CONFIG_IOMMUFD_DRIVER) evaluates to true but it is only
> technically used by a module so it doesn't link it in. 

Ah! There is a well known kconfig technique for this too:
  depends on m || IOMMUFD_DRIVER != m
or 
  depends on IOMMUFD_DRIVER || IOMMUFD_DRIVER = n

On the VFIO module.

> I would like to reiterate that there's no actual module user, making a bool is a
> bit more clear on its usage on what it actually is (you would need IOMMU drivers
> to be modules, which I think is a big gamble that is happening anytime soon?)

This is all true too, but my thinking was to allow VFIO to use it
without having an IOMMU driver compiled in that supports dirty
tracking. eg for embedded cases.

Jason
