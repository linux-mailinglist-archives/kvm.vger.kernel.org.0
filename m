Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99AE7CC3D6
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343728AbjJQM6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343496AbjJQM6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:58:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6229FA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:58:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaQTuWOgSIcqN58B6TDV4QFYI67BR+B4I2q0vBhNox5S246eIWlC5xUfxg6977g8emVdHtyhYaKoWX8T9BV+a5J+yQmKWND23OxizRwriE1jIrHryPmF93uiQtYQQScLk9jJo6b7ci3dPGzhrNIAYimtzSIQs5vjUXnQcB4p+AhkcxjhNoAIJOEOvkVqOL8RL3Z4BollvWlINCBVU4NIA5zn+pVxHpyOq245dU3XaqXiOo8SFmuAHG4PzxNL5xyR21lR8xZsYOgruhrwI97UvL5MX1G7QsFOW0wDdv0K4xx2TAum+J8+CFy1/UumZu/h4qmxycBrfyEwJ51mQBFoFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E47Bxlpym1Ghc7DJEgrbIOkINaFe+ItM9fHrJ21uAYo=;
 b=NrhNlVNiM/+deBggsX8SRy3+59T1RBIqVKdAjCS+ktPgWJiB2y7vRtZ6UPGLRnkdunF+pOS4iiGRSDC2mgNEmtn/kkYPKk+zi0B8sjTA+KGTw3q+OJkxkDZmTWEUHa+vgYv5yicPZ5wtX2Wtt5jux1UlwAwslQLUdwzBaaOvp/nLNDSpLtREHdR512sS1NEtCv2HupLR4CHmEUjSg5uKBHMDt3rkV+hIbVFxjl3iCTmkYB02hMPjQSPaHSg9fiIBSQEmZS36uJ5yjGk5kiM205Dh/3GqvE0741BfReC9UUXOV579BAHcQka3CuZuod/FdDYQgZm8pN/RYikVthNJ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E47Bxlpym1Ghc7DJEgrbIOkINaFe+ItM9fHrJ21uAYo=;
 b=ZUExKiM5X63SLtDamqMozFCu5GgaSFRvRTNfNSuUV/28o2eCsmieK54tDJNWCEjd6HVyUN8i5+Tzi/laewK8hBGyKVzzBqLNdeDSGziwQ8w3ymvVsYkLHQoekcADZumsRo5mD3ujQxgkP46S08RxN00ZCAvcw6UdAbpoyUDwlvAMvBaLdI7h6a4YrStZSwPL0lcyE+Oxf795/M9vbCuvGuRiA3zFX0UzeqWtoCPb3Erydyfn07cIJfvL89z+py2NjtvhlneK4062TkrnytQMT3qWopdqvdRF+YaHrjC9Qa+TkN0NWXW2CUkbK7l4zSn/0UAz7YOBvi4KIJ7Va7CytA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8886.namprd12.prod.outlook.com (2603:10b6:806:375::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 12:58:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 12:58:42 +0000
Date:   Tue, 17 Oct 2023 09:58:41 -0300
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
Message-ID: <20231017125841.GY3952@nvidia.com>
References: <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
 <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
 <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
X-ClientProxiedBy: BL1PR13CA0314.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8886:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c9c23a4-a3ba-4d0e-8849-08dbcf10ca51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDvdSZqDpaSFHzCUp6drQC2xiesjhmxDANwbkmyi6RHas5ndgOB4inksJoXPy2n7TFs/LQoz1Rj+UAwpzV3zeAyvwnQEfB2RckpL3JYXFQOaR1mhaNS5ZB40Dc++nmDZZFsbitxQ+2ZdMmdhv3euEw7JPKbrXgDoKS+6Fj+cd11XkRcDKrPT9M8AKb0Nsy4odLF+yUOO5gZ4qARgAhiDOlXMuzFOESHnVM8j8zw/RFwXfRfIC72DY1uYSl3iy1QjR0/KqKD6a3o2EKxov+46Gti7qUBxmZ+u5MVoZx6oiws4RNCc8F6B1zL1fLn6B6yk05v4Zw4hm+DIoz6cbEp32qhLBQjH7KJ0IEIy+3fjyDnYV5AOgxf3E9O0uVdfh6USKEd7Vg8vT/CINuVlZE0iJ0/YEXyIixo0m1RE4+ekgIJmTMvulXEf0f08ZNx3d94CoSCZHQIiq+DInXA80AQN+MstFi0Q3U2JgAVGSqhH8zXkjknilOD/MAerG9WTv4UZArltRzhijpNiDYcF+i2d8TIkg+g7tWnO6EIm63xYYo3/L7XzNQ7ifTCP46/PJLBF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(39860400002)(376002)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(6506007)(5660300002)(53546011)(83380400001)(2906002)(36756003)(26005)(2616005)(33656002)(38100700002)(86362001)(6512007)(7416002)(66476007)(6486002)(478600001)(1076003)(41300700001)(6916009)(316002)(66556008)(66946007)(54906003)(4326008)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FewQ/N84NgbldH9OR3lUa6bwUDxRHdxgkhNraLCM5lNS7bCeoY+FA5j/IUdB?=
 =?us-ascii?Q?m8ydj4mO+za6msI1KUvdl1C/mHgH7x9CmaqSql+eBs+M7Fv+uRR2cUGYljrT?=
 =?us-ascii?Q?az0oy/D70EignQ3UuX5aWvDm7Wi62TaJyMVwREm5tC0pRWCYC+gBMeMl1fN+?=
 =?us-ascii?Q?SnUYo4aaRhOkAGGkaVALpELyoLvCGZJqz/C8IQhTKHN1zBnxP6KxcmFnbn7S?=
 =?us-ascii?Q?pzFZTX9FDrmRVSMIXB++GYRaCeLbp6+0r4Et3r/Pp1kDL27aCeze0lQYUw4Z?=
 =?us-ascii?Q?1wgXRli0pPCecPVg34Xehr7K3fVx3boLb8spMBIdioUNwR2WePAWbxpx23ll?=
 =?us-ascii?Q?YqVTbOUNiQNRIwFEL250v7nDTwr5b7ukw1wnQwoWp/nkgsQsVMpLdNSbFfU5?=
 =?us-ascii?Q?ZO67nxa2SmP8jsw7RjeCvx+ZZLp0ANEyCmtvHehMOFV352AcC04TbfHlvsuG?=
 =?us-ascii?Q?FvWdJaxecaZUL9yLLhNrYAcKEpCwYRWuAzf2nWGpNKyazvZNLqhk+tpc0M3V?=
 =?us-ascii?Q?8EJK4YCty9PeyvEDwymavCMJvQoDj1OWWCovqvEsNDD99jRn6zoABcKaPHV5?=
 =?us-ascii?Q?OkDZ1TH+qiBoZIoiH4E7dASs0PNETwFcyIjqK+KUXQVpioxz+AikyR8IoudE?=
 =?us-ascii?Q?FdpKyQ3X6mchoe2epzIwccvD6reACZi0+PwBt/FCYY6vFEMA+0nCelamH1Ml?=
 =?us-ascii?Q?bwOM+Ekb6HwUgeJ0T9eRWdlPCAGMIQDI7Ymk8eGA8yWpRORGssSny8G982Af?=
 =?us-ascii?Q?9TDjfEqDvGL0xJeLdtqNZqUmj6s2vW2Wwqryc0bNAeLvGg3UNOJTZ4eZwz8N?=
 =?us-ascii?Q?QJGZ6nj3ZQiCJuLDpmQysYWidN9rSTi6WUfxd9AkQjpRE2CiapcBbj42pNjs?=
 =?us-ascii?Q?DZYanx1pyKorXEeENB338IGrIzFXGs2vJkbIUgYiPPTk4T1fls5kUALKSWBI?=
 =?us-ascii?Q?gP4fHWdaQFetXq1J3w/88bH9UTT4+ivqGP3wXS9jHLFPrv/vbcxnZUFPtiym?=
 =?us-ascii?Q?i/dBpRhdaNOyZkAIcL0fa2hzAMvhD4c7i6AZrBAOjHEHOKHE5+86/OP57rV2?=
 =?us-ascii?Q?OiUNlEbAMF59q8L6njyO0gXX2MisVAoEjP6qygG8VAVEF7M6TIPoQQLMcbio?=
 =?us-ascii?Q?oOHQyyZR005acTmkwrZ0enSIZWuxlKuFzoB0ezaHtWBj4TDdDglRISfUh8FI?=
 =?us-ascii?Q?6V7yfz71fAbrKvNCc4NdGe6xe3pUcPMBf05rGom1L1F7g51eFRwfmNKGb2Pg?=
 =?us-ascii?Q?cwQ/ZXvzk/pKg7QsW3tpBLzpaMr+45/b81dgLxy69DHaN11M6DcvtIGxPgok?=
 =?us-ascii?Q?r41mntP1GKVwCtzyiF+5QOLns8bBf1J4DzzH1jwYjIm3ZhkbHUeixun5umBX?=
 =?us-ascii?Q?kpeNWUon/V7DpWDOwULK/UVbdit4XXuBeLysdn2lA3fbFZdvfu/HCUh0EBD9?=
 =?us-ascii?Q?YHHyI1TggTsTiRRrPIK9bdrzCQHEh1CmpIKro9ohQSlCe7wZdOcic9kIoUGA?=
 =?us-ascii?Q?R1GawzL/kjkANvaOuH63/O20doOTaTauYW+xLT8mA73WiHrQ7DTUHHsE83GI?=
 =?us-ascii?Q?gqwpKiduXWRgDKr8KSkobTcBOF3W23/fZUBGwRnI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9c23a4-a3ba-4d0e-8849-08dbcf10ca51
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 12:58:42.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOvzFJRbyTLKz7H7PS0xirfK0GczQgqEzMkVIa3OmP3JkZR7nkRjpBL/xbV5Gd9v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8886
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 07:50:25PM +0100, Joao Martins wrote:
> On 16/10/2023 19:37, Joao Martins wrote:
> > On 16/10/2023 19:20, Jason Gunthorpe wrote:
> >> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
> >>
> >>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
> >>> well later in the series
> >>
> >> It looks OK, the IS_ENABLES are probably overkill once you have
> >> changed the .h file, just saves a few code bytes, not sure we care?
> > 
> > I can remove them
> 
> Additionally, I don't think I can use the symbol namespace for IOMMUFD, as
> iova-bitmap can be build builtin with a module iommufd, otherwise we get into
> errors like this:
> 
> ERROR: modpost: module iommufd uses symbol iova_bitmap_for_each from namespace
> IOMMUFD, but does not import it.
> ERROR: modpost: module iommufd uses symbol iova_bitmap_free from namespace
> IOMMUFD, but does not import it.
> ERROR: modpost: module iommufd uses symbol iova_bitmap_alloc from namespace
> IOMMUFD, but does not import it.

You cannot self-import the namespace? I'm not that familiar with this stuff

Jason
