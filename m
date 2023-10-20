Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30B7D10A4
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 15:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377424AbjJTNki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 09:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377421AbjJTNkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 09:40:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB7FD6B
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 06:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ahR5WPYvFKKFki9ZHDuVEkcWC4v0a1N2QtB1VtXMKf6m2P6DfT/XIi0osLZqojMeo/Oovp0nJ7bbOkCgKpLnfHHNsHgnIjIP6Ul9jMr8Y68050hXK1PfYIO8kfe+LiatIje3c47aWE84/kRl0XPHRhuzfXZpr8YFyH1YGLfH/yJn9tQsrLpxabwM/g8Vkbu4LvnJqD2cERKopeKqOU7gv8EtyFvRb97pd1CDHlkHMz3q39qEHkHSwnDyt6ZWAzKG/v+/YukrTDdQ3lsYa3nhLcA8NgbBUCYTQqcA0NWitP0GUd5pwtKisnwjX0203XJg9bfeXCd7V7hvl5FkEuzxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRgontKNpjEUGD1cskBPBoMY4tluTvQ1MdXuil1REIs=;
 b=Q8lNrlVcyNYBXkMG1AiN0EEMtu/GhhCZvgdH6LJE8X0sUj/MNMcMXLwsOY4pbXfEZ/kwHL9vH3Hn865pTT/h2N7jJLAQcxAwTDluF1zI69hfQOeaNoVE7aho1ybxGcIcjaXdpT4AXtys+JzL0uQs6SjYXM0iEdHlJYKh+6avMe3RBO1bBeamJUL7GChcUVVMHIGJsjkEljqEKVaFdBPUlLNqF0ez635L/PW1xxvQm5b8qBVdrfZsdi4ucIt/m6G54faugzIbXZlzSG7iGR99klbd0cpvMxQ7AKWg/mvdH2XdEJyhGgpikFsv1lBtaXvbxXonnIN/FbC2jTzBL+Py7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRgontKNpjEUGD1cskBPBoMY4tluTvQ1MdXuil1REIs=;
 b=PYO9hQv7bFIy0f3vmuMjzUtsaaQzk7KETb+P5cEafezuXvpL6WHzL42UY8gR7knyjKOggOi4W4ZLX72jUf+uljoyL47KYbWih5EHorBLVm/xiAn046BgVasmSSNZWPWhctsql4uz3fTifmMrKHhFuFn5UstRQtoFB9Zf2Jji2Zetdnowhyfg43Etv9RB5n9QlRTcSIj8BLt6m6dXXaoE1CUAmiE4GNVpXk4tzec+IkCjHUXDQETEMYQzn81R5JoLWwtsx8p3fLO/k8wE/FXNj+7gvfaVyumD83LOWG6IbTMPU7KJxP7qQuy2ziKPhgKrH/ID9UzWBcnKdxVzL4aZGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Fri, 20 Oct
 2023 13:40:28 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Fri, 20 Oct 2023
 13:40:28 +0000
Date:   Fri, 20 Oct 2023 10:40:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 07/18] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Message-ID: <20231020134026.GF3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-8-joao.m.martins@oracle.com>
 <BN9PR11MB5276E0546391A87457258D368CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cec5aba3-6e25-43e4-9aee-1342a369ece4@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cec5aba3-6e25-43e4-9aee-1342a369ece4@oracle.com>
X-ClientProxiedBy: BL1PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4367:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af8cc4c-1496-47cc-eac8-08dbd1721f29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OOZxLNnpavNw0+UIa6rHfnasuHQrSIR0Mwn9sRATIoGpIqeLW6irhnPq6s07oYU2FsYXTRzlSwg6gM6pQTKga0DVBp43fuz0zQrj3bkcGJWCot+krAavp76LaTn+P8yQuUczKIFF8Whjx8YVhlmw/bnB5doTEOYzx2gRRu9Dcs9PJ6WU6kzffc/VD5fhEAC9XJZkcbNx6TcR1D/qXYtyn8OdVm10K6aGKYg6gWactYFeG8kvp6UeUJYOMlu+eNt8j4dwayprCyE3HQm8PMSWmzfJzxpSDZ4gGihChimFS96O/0dNFaQ9ApgXT/Q/b0unmJdw40pMQxuqlMP/tJOto/5bQ4psNPE43gWSS2zx3sbu77Z/ZVl4DzRHsRqqIqnqnCT1H6X4zqw6rgc3sBPqPLoBIfhQlEdCbz4vL82zHLjYvT0wDQi8Ir4OqwvoEMKmRVPUgsAqldHhpTSNLwfAtgVp0FHdP4kBYw4eow3AaD+xLlOHMJulH7adAfUQFiIh7pAC8VYtgE0iT88fSsQKbNtCt2d75GK9g4VRbNMHnSlGzRcdkye09lbBcBCSw/H+GCG1lakmPF50GcISjo3AlTLamHrBzc3/Awpmr+JeZtU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(39860400002)(376002)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(2616005)(1076003)(6506007)(26005)(8936002)(4744005)(6512007)(6916009)(4326008)(41300700001)(7416002)(6486002)(5660300002)(2906002)(8676002)(478600001)(54906003)(66556008)(316002)(66946007)(38100700002)(66476007)(86362001)(33656002)(36756003)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qtfuWXUiXxnHqGHY1ZfWxpXYrr/vN+8+WeR7KpyGTNx64PNOR74vBNE6JKq8?=
 =?us-ascii?Q?QH55do4nK8fj7psi0TayLtRKMQeY4ZlwaGCiZ1NxiHzeqNSA7rRsqLX0m7gf?=
 =?us-ascii?Q?O7LaCpA7MWc2dvn/l/W83pUpjThZgtW1+wYuQulcOc3VVQIxgNEaRhoShcBc?=
 =?us-ascii?Q?UvuiCLrzygNHoB3bxkylt1lTkZnTK+Cy1rlGzWRxO1hWHGHMeC28JmcmUHHs?=
 =?us-ascii?Q?cmAsWoB4s4/SDTk/Q8LXVX1uRhZQoDU8aDNWjQyvEbEr907Rkj/heNQRHZjj?=
 =?us-ascii?Q?BA/8uno0zd6ceTL53p0bsaPNzoOqWAAg2SDcmej5x1C14XNxjJbA5JIuJ64O?=
 =?us-ascii?Q?ZNRnwSAGgEb7Ngh3VZ4tb7JKMeIl31L4mR0mFON7m4GnR9JTG0d1lnZ6boB6?=
 =?us-ascii?Q?cNrSDz+xqPCagoircah6NZwRxvMZ6Y1ggMVPh3DtpxOZyb9aymYs77ebBQXj?=
 =?us-ascii?Q?YC/XceviKCexlQtMPc7XzOgFvrpObLPSjR5JrhGmoNU1aTZJZLGJYBm9BWGS?=
 =?us-ascii?Q?/JCVF0CkQeoBwVrP6YP9x+FtyHtu0vQIeJ+ilqMBduQey4ETSsIHZFCGT3fU?=
 =?us-ascii?Q?XMd6jWv8kk8zLBRHHLChMiRqr2fPsURibkEZaK/uVVvNeinc0l5nMlSNG0XO?=
 =?us-ascii?Q?r9222IfkEPCNLqH0F3ixEQgV0SEy/opSfQqbqQ1aa5+l4GUeD29yP1IsV+2T?=
 =?us-ascii?Q?Gif8PGVeA8ZC8brkG7lWgBL3jbZmI+QERBFSIdy3JBp4AE4wImezeT+ppjom?=
 =?us-ascii?Q?19+FQk6nMSvVSEDHnivndX1czWUwOaczozpQpNmycibPwuIO0QJXdGhAmKMW?=
 =?us-ascii?Q?pzEEBt6pc+cRDwbj99gmBbdfiIV9yrHtkgYmdId8HyG0ztEFGzMN+qFQVTpy?=
 =?us-ascii?Q?V+TfpJ1dOy6UUYkh2vZyfr8iyYYc98XZE12GiAli349OhizwV7Zsk1opOC/S?=
 =?us-ascii?Q?IFsDb1gQ7GorCxAkmJyOeefmCIBl+jfJaJdac5VlI9MDBknZx02ji0m8cx2c?=
 =?us-ascii?Q?gV12h50IJ2+t7H7Gh9utDT45nKB6ePv5Q0Ivg1lyFtzI0kVZerOKH6a4vVns?=
 =?us-ascii?Q?AL6U3FGf+XKTl463risE5igDmkrnOrxVyV+KHcrTairV6AqlI+oBjDdU+/Dh?=
 =?us-ascii?Q?ML549pR4oHGet7qxc33O0TbkMF2BDwMrTgY/bwlMuJVdwnqFvdmkWMtMavYE?=
 =?us-ascii?Q?zZRLF+ForRewRP4fgit2ylPGJz8BoQapCgs36X9/kBhe8QBjSyTXJnaY+ae7?=
 =?us-ascii?Q?YMroCHYqHIfpGXa8DBxGq9MarmZDUXhvWkAPEWrRHjEbCowztSG34VTvNi3h?=
 =?us-ascii?Q?Mtu0UcykREjE3o8SX2D7jhc49cYeOQLl9jmrZ6xJImqjHt5yIBd5d7DAu2Ou?=
 =?us-ascii?Q?jSrM2kSsspQ5tKq4GIC7+AOBfeEKBHhvnVIIgWL3zwFv4QTN2iZKsdFzac6x?=
 =?us-ascii?Q?kDSgUP9/WyPJTkegPDJbxfZY8jvyLPk1GwAoUs9gi9EQtJ6nMfzcvXdjy4Nq?=
 =?us-ascii?Q?R8AKg20uNc702JFReihMKzxVAKHI5w4wlxbdTQbTa108/Yc7skUc6hQwaccB?=
 =?us-ascii?Q?xDMfcKSMXO8DDCKWLXM2XRaFOXZ6Ahet4cJnHSHL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af8cc4c-1496-47cc-eac8-08dbd1721f29
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 13:40:28.3356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hZeUdMR/BSxj9V62kOj2WoDk/+8FLi/GdhlBy5a+sHGmt+L0SOni+/3DIzGU6ZO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4367
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 12:53:36PM +0100, Joao Martins wrote:

> >> + * struct iommu_hwpt_get_dirty_iova -
> >> ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
> > 
> > IOMMU_HWPT_GET_DIRTY_BITMAP? IOVA usually means one address
> > but here we talk about a bitmap of which one bit represents a page.
> > 
> My reading of 'IOVA' was actually in the plural form -- Probably my bad english.
> 
> HWPT_GET_DIRTY_BITMAP is OK too (maybe better); I guess more explicit
> on how it's structured the reporting/returning data.

I tend to agree

Jason
