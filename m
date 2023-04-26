Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E9F6EF3D5
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbjDZL5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240143AbjDZL5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 07:57:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF6D4C12
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 04:57:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gq0dzoIMypoWUnTQ1+xcGcyae5g2yoZFTe6RKTurUG6imMH/UrrAcqxDfjqlhK2Beqq5GkLfh7WeXl75l06PPY3T1d2t1VkrbyyJio2A9MdOcydzglxnNoD2BTpwndX9kM2/yckO+p28IndyfKj0vG5n8vH2a6jKnDxsI1iPUp6Bv4nSnWf3470iPWvA35xA0t7i07LB0f+h6UUiprE6QQ64Bce+DK+7yXDEMDK7C0GqpMIfEa1xTQUFrAfFt/9tWxSN6hnnELeW/H4vtRq3Ix6/IUgQOadBGsYQmFYB9bXJlamv7nBC5ZIYzEYZFIKZrFox1EwIZilcFKkJR/x92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bK9nv3dAOWMbeO1ZQGl2C557v6ODnrIVIm6qDMKQyh0=;
 b=CQAxlI0itW8MlIqE6O5Jg6TtnVp617/vh9Cf/LEkkrfX8p/2ZAphukA6xHTdJ09GxzokkBVAZ5YmAuBoiEt3Y/zr8pC6luP8j4WC+zJ/MeWoNik4T3k9DodvfvcwL3W5TZqlMcTs9G6W1CYjWmsWff7ILr92BQD+cu/6F0qDwf/wnZDbTCfUxdx5Jg3tYcOrlskdcIcUhP2IPmP1lnSgHbSgnm52o8sfiV01qncSjOKtGSabXkd5LnFSC0gNSarM/dNULEYaCUOy9urY2EVLZla7QOHoJoxDHNque2KarOfnOBqKxoGT9V83v047jyCWJn/H+jauN5B7eRVPg+ZBGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK9nv3dAOWMbeO1ZQGl2C557v6ODnrIVIm6qDMKQyh0=;
 b=W42AU7WlpB30O3Lf+1Mn5PmuQhw0GwoAvU7huPjlAAuFsFe+M/k476E+hCx8rkq8zpsw416XFSjp7nROsJQBnTRwRQS/5kMXoBVL4K54qr752z+p5hIDvKsOKBiWr2s6jZVzTSlFDuof+o3ZpvcubDrdLehgb2uTJA47Q8FPh/xEI6RGEapszuZMnGUm2Gk6e3FWrv7X+ePiUsyfXXpn4ik/8h6BZYMUO+VHg7LthUprrJCo0Qsb0CmLhm6BQ/RR8+wLOFNyWLAB3edY88KxT71V4wm/KbMM4qeAKOFqwKqjQAdbdo6/Sl+lkFBC8PdDtP8LEOdT1DjyutQVyZZOnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Wed, 26 Apr
 2023 11:57:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 11:57:19 +0000
Date:   Wed, 26 Apr 2023 08:57:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEkRnIPjeLNxbkj8@nvidia.com>
References: <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
 <ZEKFdJ6yXoyFiHY+@nvidia.com>
 <fe7e20e5-9729-248d-ee03-c8b444a1b7c0@arm.com>
 <ZELOqZliiwbG6l5K@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZELOqZliiwbG6l5K@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0293.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6920:EE_
X-MS-Office365-Filtering-Correlation-Id: bc01e943-9622-4ec0-df2d-08db464d6360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: coP/umzxnkGK3ProffeLGzXgMsZP+MkM5Rl4rKYopBS4QeMdHvIUPmAq32Xy429LGafkXzhX6a/jxZvn17+6mHiaRTlr65iGDQ1ErVXbKVDJTJ3rCYIuNb2O2D+5YABrIPR9AFcWTp0jjCnBLxHyRJejvXo+MR/Ou5jRO/sHZSMTHlbph0T1nrdOvTuohPnZWoigC8mxTPDnOBIajUdIRiPInRbHJhDkfCqgXDO17Znc2K0dA0qI8KaZUG/w7CITwox52jDTjbf3YlE+M9Olpcq6LTChI7tf9gD7HLkduEX2EL9lf0IrO5hbwoyYCU8gNYooPRPIyXgIsvC8gJVPY5aByj89Vo/HcgMNmuEpg3C+mo3pv1juYni0gSGafXbX+WSQBJoLwKnWchD6wmZFe85rmL0+UU0MkI9ZVFt3mQ8T3nY8Xu+KKCESDg1Qtjrsl5vq0nSb2ogzUWfE3AaYu8bevlKB8E3JHZylgApvjiigDsg+shBvKwfp7e0sFEOY0DQ9pCLwpHSUv818OpJSHja8MIe9+dgcHc3AX/Nncg6/EbW4T6TyKKJb6+BcOtZw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(6486002)(478600001)(2616005)(6666004)(110136005)(54906003)(26005)(6506007)(186003)(6512007)(5660300002)(36756003)(66946007)(38100700002)(2906002)(66556008)(66476007)(4326008)(41300700001)(6636002)(86362001)(8676002)(8936002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MUupoUVGhriJ3/JaSxRGgTiBYO8dHYXj6H4S5IAmDJBdkNK6wYNZQSbMOvw3?=
 =?us-ascii?Q?cd7IWV9ChESwZxHHWryTdYo0HbWoBeBSpcdcQmAOrZOcSP2iGoGTHwKWr+oe?=
 =?us-ascii?Q?roaWYLCM4Oyf2ARMJR6lpSirwruUnpZZtjULXf1wr0Wlai6D+TLbojl7X9fY?=
 =?us-ascii?Q?2gKSvps0aHIKG9wO7O9Uus0bBDr0K3n4X2XkFadIcUrwWBrKc1X53GckSFKh?=
 =?us-ascii?Q?SZ7NC/1pdLW3ga1Abz5Cxpm8VnQEyA0tJazR5oDTp6hJUjem6i7Ny1fAAs8D?=
 =?us-ascii?Q?wrG3oavtYquyGbb5cumn7m7vsiOWKUAmW5eO5zIl/kZoBiHjX0z6rKfp5NND?=
 =?us-ascii?Q?qSqJXTZgGgmg8ZSqkJHOh4TpeFuZR3aOysMiM5K0wPmoC0G8bVbdubyKq8xe?=
 =?us-ascii?Q?Kz6MVIDJElTQ9IzXUno3C7iAoe0jy9NXmdI5J2CpEBtdV/d8GhMgEKxysdoM?=
 =?us-ascii?Q?ARVzuijxMAFzIDMVd35qalpo+ysvqxcqFCNW5hgjUxKt54yiDpg48Fkzd/qf?=
 =?us-ascii?Q?o2B1DT0qW4re/fUhPBlfVTsiQ5azRxg/+VprpI5S0abIP3UFjSYrxGr0J+WV?=
 =?us-ascii?Q?ObNrAMkRzzjAjN4nxdM4QKijdq3LNxbQ8u9xiHurYE7J5GrgcFChyzcNmZ2A?=
 =?us-ascii?Q?0NcPqyNianmDGXjRXXUzD9Fvfkf71E5MrtW5pWFyxVBf5OIWf9ZLsfdmL95s?=
 =?us-ascii?Q?Ft5tOSMwtuwxgRViJL3EC8tfdLugao8u0wnhRSkFSR+gwCnRM7kmRc9fWVpJ?=
 =?us-ascii?Q?FCMCmLp2IVQhdRyLqTn5ekmuoLb6Ff4QAUH2Kdo3l+yvXpa0cJuBYvGON+D+?=
 =?us-ascii?Q?Vn22aO8k481rsNPKiKE14I8KUge52AbXPcu+FYU4rGWnRcIHFGUJP01WyB3C?=
 =?us-ascii?Q?rzjdv5SlRnID3bA/w4wXPiA60T4cG74uvnuV5dVRn1/M+iiECwsiV+V0CmQZ?=
 =?us-ascii?Q?gi2T2u8hb//xfB+/dvevzAH/7oD0eQNnd7zJpdSlHf6NB+zGOLS5egiX8zRb?=
 =?us-ascii?Q?OF4P66TH6G0hS4/5u1wuv01L6Jbwbd+l9ruNqo7NJ7w906fL5wtovbOyc3Cb?=
 =?us-ascii?Q?laz2AzskEvSduEbd402R1x66qTrMwK2p8xK5PAcDB2CqMktgavtC7KeDeuDT?=
 =?us-ascii?Q?d6wS/lJ/k9rys8RJDQ1BXqLjRjpP9FITPlMCRqcP2rAFFaG+MJ2zojM3SIYv?=
 =?us-ascii?Q?qYMa/X3ovkEsmCvVp6owTIMmB9SD3DmXL+aFVQrKq4u1G/Cdprnxf9MgCcVL?=
 =?us-ascii?Q?VsKsqv2+3rPwleNsS9o1x5r5vsSYP+ACvd1wn5IG8RkGuimweA+PP1mX/n63?=
 =?us-ascii?Q?PC+HKoRR64B0Oz+Ld2CDeqPM9acrwWotoZUbBv+cn8cJyH/yYmdNP5hyxOPJ?=
 =?us-ascii?Q?jbZRR9syAd5yUTKt4urhC+mfFV7+SeLIle0+Zl2MryOA2HVWh4l+Yl7ywKmm?=
 =?us-ascii?Q?3jf5Y1mZd8JhbeoZD7wrWuJs34p7/8L3GYP/z7ynGGlMI1UYZC856u2biMO3?=
 =?us-ascii?Q?optIB2UqlkzwP+mUKNGlCZTw/x255lh4oTCAYIpYxVLlH/s+N7ABdvKZaDm8?=
 =?us-ascii?Q?UivgRPsZzwoUPLpJW5Hdj1yBvKg2FHV9Zd3KfeUs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc01e943-9622-4ec0-df2d-08db464d6360
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 11:57:19.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELy9DkcR37Vzhl/XvXupIahlXXGPIPGBV5iFBf6AXyGxIMyIVN+5ckh3DA1H+aks
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 02:58:01PM -0300, Jason Gunthorpe wrote:

> > which for practical purposes in this context means an ITS. 
> 
> I haven't delved into it super detail, but.. my impression was..
> 
> The ITS page only becomes relavent to the IOMMU layer if the actual
> IRQ driver calls iommu_dma_prepare_msi()

Nicolin and I sat down and traced this through, this explanation is
almost right...

irq-gic-v4.c is some sub module of irq-gic-v3-its.c so it does end up
calling iommu_dma_prepare_msi() however..

qemu will setup the ACPI so that VM thinks the ITS page is at
0x08080000. I think it maps some dummy CPU memory to this address.

iommufd will map the real ITS page at MSI_IOVA_BASE = 0x8000000 (!!)
and only into the IOMMU

qemu will setup some RMRR thing to make 0x8000000 1:1 at the VM's
IOMMU

When DMA API is used iommu_dma_prepare_msi() is called which will
select a MSI page address that avoids the reserved region, so it is
some random value != 0x8000000 and maps the dummy CPU page to it.
The VM will then do a MSI-X programming cycle with the S1 IOVA of the
CPU page and the data. qemu traps this and throws away the address
from the VM. The kernel sets up the interrupt and assumes 0x8000000
is the right IOVA.

When VFIO is used iommufd in the VM will force the MSI window to
0x8000000 and instead of putting a 1:1 mapping we map the dummy CPU
page and then everything is broken. Adding the reserved check is an
improvement.

The only way to properly fix this is to have qemu stop throwing away
the address during the MSI-X programming. This needs to be programmed
into the device instead.

I have no idea how best to get there with the ARM GIC setup.. It feels
really hard.

Jason
