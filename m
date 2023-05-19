Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FB670985D
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjESNcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbjESNci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:32:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC132186
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:32:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YiIVO3Vp8ff+o3cjXB3TWkbQknZt+JB3r3ixZMuJToA0KfGnWbEGJrqrIdLF5R1Q+2zqoXyiewcMJEdg5HkAnqPbSFb1W/F6pA7oKjDi/uIo6H3BrWXd1RKciotbfP8r1JOQMIZholNkLU2lOU5EG5AiM9MzbO9D19EZin8I+k2p1X+NzO0IOodRrnP4XZbm2Ft9CPbiP78NhSHDePVKDQZ9GWs0MRlFxAXiaVy7QrMsDISzD8lT0Xfo1hZCO6BgGk/OvRs+wx3botwyHlw+kipW21HCKm5KGOgUG7BoOHs3iPNM9WS0+iTE6rg0GoVZYbNJtjOLRBT00pk200VoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvgQOvfU4dAFRVf/zG+ZuV/eUsY66uEU8Trm3CxcqkA=;
 b=BIbhtotQ3Le/lpQkTsSsovxRvXx1062fi1UFAZxc4oDli8YITJ5o/StTkNLz56o1AjLJjKYhHXMWAmmkJVrO532xFaMuZevIEojApDS9XZGk5HiNOtDsI1kNqtDNxOL7nGwiZEXu3XxX+zzjHMroH33hvaY4V2OWoufZQD2MxVblOnk6HVYKpBBJElD9RBglv/pTy4gXxtWrzcDqAXHy5A/0GvKdkAWuPU8evLpPjik6bzPz/ePez6F3tFdJQRjHpZONfr3YNMet213ifX2+tPMwIC78cXwUpOHqI5uggOxo112r+tW7KRdPBI97nJqVBksg60aQ6ovZag4PRok5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvgQOvfU4dAFRVf/zG+ZuV/eUsY66uEU8Trm3CxcqkA=;
 b=UArtd9PTP+PlQIVTzsL6ckqaWkY9SUBzyb5sjNFHbf5Ang3QBgKp4BGSaVy5WyuTq2y68dnUhdMqo3djnqzBCr0JvC8rzxOthj+CgYzywJtOLJb8smftMmbWpbuPwFuBMm9/9l66tAkeCe5QvSH7ZUUw617y5SOxkcQztOfzCmIyeY7wdwT8Ar7l2W8xW3UDRWGD2aNtJnh01Z0D344uEE7DgpUO6nSYTYrDyyxKnPnDw8kxVRXc/VENXbnnzXSpZJWLkfb6Nud0ZWLO1m8fCcOkcJqxzWSi4Sbn+M4ecGVt95UVEgFTdLAp63bxfL6QX9663mesVfuA1t/I1Cwz0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7937.namprd12.prod.outlook.com (2603:10b6:510:270::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 13:32:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:32:32 +0000
Date:   Fri, 19 May 2023 10:32:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 01/24] iommu: Add RCU-protected page free support
Message-ID: <ZGd6bpwfz//c0Osq@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518204650.14541-2-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR07CA0017.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: 27077356-5f93-4543-9ec6-08db586d7fe8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgwngucQAW3O/53Seoa4ZHYKTtpB9M3mttW1RiRgOMw+MdmSXINIhGqSWjueGXPOktmXfiQzDcXCrGtaPjT+dIA+Ri/hgGVxj58fHJzLiP7BViEedKE+EZigtRxrhzChSNb4GMJ6izUPl8pYip0xx3FCDNmLsgWqe+p4UAuRviU9aL4TM73+eEYBqtEv4VBiqxeUDdcRRwKE2c6KROEFQxjMYRHbMhOvYqq1Yr8a2FESPai24hdcRcSlvi0RySNhRm857guUg3nrusG+NBeyKmqk6aTWr5YqGFSahPIsJt7eb7NkXszscMtd1UZVSRKLcbR1xoDCOudsi1c1hZSKI2b9Q/kNeD93cpB81BSIigjR80zEZPawenHsE5PD/3VfsSG+rvQkztCoEwXgqmuInMaQQWuaiaWpabpULAxzFfVatA+sr4BgI7UKU4FibtwUQrTOg4sF3HqNIDXh8QofOFpIITP3ezl/4fpUIv3NfBGZGm2+HFS5SrL4UUcGt+6JKheQDKxW748t4TcrZMJudxARlg0uRiuzyauMNUPCml0GbmHNrYo639PW0EJmwcF1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(2906002)(316002)(478600001)(41300700001)(8676002)(4326008)(6916009)(8936002)(6486002)(7416002)(54906003)(5660300002)(66946007)(66556008)(66476007)(6506007)(6512007)(26005)(38100700002)(186003)(83380400001)(36756003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PGZYBD+5L1WRR6VaC+vfSLj77hd/yYqYO4NSXlbnpSvaNdx9sgv2qe0mFtbP?=
 =?us-ascii?Q?jR/eSX6Xjg8vADTJIkWCe1BiFk1y4e6Lf/2bWjFbcT2I1VHhevy0lgqJsTCn?=
 =?us-ascii?Q?lpuQbXqQtLzO+sEAFsv9VMvSVXMsG1QyDmuEoPiFN2380gJ8uMxxZwUD0KWa?=
 =?us-ascii?Q?l8RzJsep2FtlF2vexd/PTCMJSWUoKOMIOSR2Or2bHRClawscwOpOPXa6AgZr?=
 =?us-ascii?Q?Aak3rg0DTkxKRchHJcUcs61bizZPs3wuWqE82f+dk/RluZVrb9Ej1dewDFqq?=
 =?us-ascii?Q?f/7ZyoG2KuGb2eD23LN8xpY4pqtYWGuUHClP9BPjZzGq0bRZ/xSd/d/v17Cu?=
 =?us-ascii?Q?1o6czpRZjCGDhaHZV8SPSE115yl/XbSlOmhiEdVqkKCBO6vTWtRVTm5484uK?=
 =?us-ascii?Q?HLVOUaC0Rrfut/WggvGdqyrQ3dTtHoVhRnGxxE3q4GgSJq9FZhqPorRCohft?=
 =?us-ascii?Q?2uftls2SAiSLF/aSsvgvdvwwlWeJJDoGKYMRXcg4hgbuVCzK9mxK2p6WkPL5?=
 =?us-ascii?Q?dKO8GsiLhcbjWg4WaenorGWGJw+FEUXgHJBTUC1wzIAkCxJE1aFrW+uXIAke?=
 =?us-ascii?Q?b0AtRgIn94y7HMbkuvx1Og9+gY4EcljWv6USu1d8UItNMesvMHKF8gAxE/3q?=
 =?us-ascii?Q?05AYIzqTlq5d9uJEGNZW8QJr8YKGg3omWsZMwGC60wtgRD9GLuVm8XilavF9?=
 =?us-ascii?Q?pe4F4AhZt7px0mYtCkNnVjG9v4ClpEcyYBaYwz/f/tNzH21TCLHeA/NLjXVI?=
 =?us-ascii?Q?YQAd2XW53CkSeacsY3MkpEMpae0iARN9UtJXsE0IoBzhRdez5HVUkDPA2ib9?=
 =?us-ascii?Q?Xf1X4TMLCaj2rs/iS46Yvp6uMrWpm9/o1aAh6amrhxbORVe+DW0yJ5wD1LGe?=
 =?us-ascii?Q?0llGmPceKawRxmGsG+f+RhJNDmPva5UXT7GOzOVUxUA/1VrJcns1SE7pebW9?=
 =?us-ascii?Q?wcQkwInKLz4f56Vz1+rkHtN8yZGLlc4ahaqxJ/y7yMYetP95iR+j5SY1H5IB?=
 =?us-ascii?Q?1wZPDTYhdnOM56aIxCxl2L/CRMtVqni2jpqes3Iq3ZDE9EmPF7ijrRn7qPO6?=
 =?us-ascii?Q?Lr1dVePKtAxb2AkPK4G84wHk0eNlG4+baopvs+C382WckXbiQQTYjZxa25mq?=
 =?us-ascii?Q?WP7PCciYDUwghQ3mGYa+Jzp6e11QZ7o09KYYxm+a3ffRnsLthHTq7t8eUBxA?=
 =?us-ascii?Q?bjcEIkJlBhlUCdB1t5on+EblL4CgfxpK1rht5w2v3s40OYi4rLepq0Mpm5VV?=
 =?us-ascii?Q?epUd/x5yl5gF++01WlitQS8UJw1fxEuJ/gGy7FXgzhSPP1dX4Y08RKo8Aptp?=
 =?us-ascii?Q?1A2mcCWjfFVHBeaoTkd3hiPtuXoGhCkMYF3O9RMDmfOenClTYc12+ID78te/?=
 =?us-ascii?Q?Xpn+sOMxc9S0f/C3bBF45VhSzzwScCF147OccFej4D0RvCsD4RTFxkd2tVi3?=
 =?us-ascii?Q?HhbO6cavoiohaQrcLKeBH4RcrRzt5kMroCKNjyVXgBFRyXnhyUIEAs0aSMmH?=
 =?us-ascii?Q?uJm+OWHvWJJxoBTKeuBsXfA4o4GudlgfGWCBIssVLFYzu6AJOg4eZkS47rzr?=
 =?us-ascii?Q?USfZp3CnHNk9kmb7WzP4/7ZsUngEOPulthyj0Yx2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27077356-5f93-4543-9ec6-08db586d7fe8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:32:32.5416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMMtdwLWo0ORewDCA/3Eqwhsun1ppsJsWaKjeKJvyYPx7tKozoaS7Vnb5uPGxjRB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7937
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

On Thu, May 18, 2023 at 09:46:27PM +0100, Joao Martins wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> The IOMMU page tables are updated using iommu_map/unmap() interfaces.
> Currently, there is no mandatory requirement for drivers to use locks
> to ensure concurrent updates to page tables, because it's assumed that
> overlapping IOVA ranges do not have concurrent updates. Therefore the
> IOMMU drivers only need to take care of concurrent updates to level
> page table entries.
> 
> But enabling new features challenges this assumption. For example, the
> hardware assisted dirty page tracking feature requires scanning page
> tables in interfaces other than mapping and unmapping. This might result
> in a use-after-free scenario in which a level page table has been freed
> by the unmap() interface, while another thread is scanning the next level
> page table.

I'm not convinced.. The basic model we have is that the caller has to
bring the range locking and the caller has to promise it doesn't do
overlapping things to ranges.

iommufd implements this with area based IOVA range locking.

So, I don't really see an obvious reason why we can't also require
that the dirty reporting hold the area lock and domain locks while it
is calling the iommu driver?

Then we don't have a locking or RCU problem here.

Jason
