Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC097D05A4
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346738AbjJSX7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbjJSX7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:59:39 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C09114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEGhPcNsTrSFJEhFQ1zS2a29f71YHaJfJwGBN23m96My/c6xmzDiVPCe2IBlsQZvS91ByvcU7QZzGjmZS1988eLSfezm8skmtgU5Xjvg547mZXzOrLOeVCTxCvgOek0dBEfBba96sf3D/b2GAAD9ZGb2vVdqb3r/WJr7Nzp7m/nrBv40CL9iCoQ1YmrwesXDwg+hbl4P55UKfhUQDvan/iEjnO5yz6vbXMIPmR6fjujoOzWfEQVClN3M5tsIQLkiLRJtNBR9nWATb4PNZg7rcfjdrEBSLSrvcFU4EIEGFH9Cdd6s9csd6HFuXga1uLeP5CM7UPxPMHR1Ry3XM+687A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aByiIG7Oxcpdc9Xkl6JwFk49+DqV4Q+IyOiAn2DdSg=;
 b=n7vvNGgh9Dsj3OcB3zzFnHmvsC154qRc3LTpS8YXStqFN0zoHCeQN412wS4INv+hjKYb9eOnJOrJYoMOygZH3S/6pfLa/9sWW2Y0LbGtq8fy0qQ7UT4tEZ+lhVUriy6jRwcdDPRCqMoVzGAJwUr0wH0F9Nusiya02eqTPBRhc3yXAcsAlsWxmY5i/5bnrd8qf9fu9wQUP+5mvLrCRBI9gmboacf8dI0dqyXoNe+KxSMGlV13p7hdER3rn8oR14gtUQw2Mns7mFZKBt0YtllieENvIWRb3zaBvu9b3K+S19zbm5z2eopnAI9qsr1RBV33HW+KOvsntKMGLENI8Iil/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aByiIG7Oxcpdc9Xkl6JwFk49+DqV4Q+IyOiAn2DdSg=;
 b=jLnSotPz86RXqMyaGQpiPLZ9MJvBCuuRiCJfiMW7uf9ZXMt7ON9ao0/g5C05ZLl96lz+24AkBMfEBBjsgt31zk0D+MYzXIogwBtFd1UexbN72oc9yOodhiVhQMhusXORU3vKipvbEK9sgqcPtBvTWC+D/ExHXBIUxgK0eKsNKmsS185qU1dVSJmdDW3uwPDb90JOJ+k1AchgKo1mF6C4voyoU0y3hcYiCBpIaMkCZ/E2LfT8v8mNBEme78UeIfyt/4bE4GmxR5qKQvVbTFHwOyA/xvLb1Gprd7RTj8GS63G6u3dDo+lVr36l5wP4tHd40T+CBzrs7sggcZNuQKp+OQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.25; Thu, 19 Oct
 2023 23:59:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Thu, 19 Oct 2023
 23:59:35 +0000
Date:   Thu, 19 Oct 2023 20:59:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Message-ID: <20231019235933.GB3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
X-ClientProxiedBy: BN9P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: 7916fcd9-fcf3-416a-530c-08dbd0ff71f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcvKQCYz+Y1hoH42Vda7z9hbYMt0cxv4GpqqwD7a3+sLeRXD4wAYnPRjFxjmb4cIoonvJi0ewmJw2i4sHaBCcO9U6/Na+074zyEmFIlOy6j4DbOBu73E/d9v7+OvTGMq8pkGPEy4nYOMmVgjaMpqOHneWIyNglbezyCARES6qF6YcsC2EJ4gjYS44Q28gL2FqydYOSvk4rT9nZASeqDCkMzgILfJthp1SO8x7IEFY6m9O3bWp4nGDYncrDWIE7CfgzxDnChQzeVEkWeRMTylnvqtA8VZQcA8PSRPvPFqpa67Xcr0QtVilYY1/0xMrvyqcynObWxU0WcCXDgwIGkuAkIwm2c/2zglQmqHLoA3+ZvL+YonwH1Moy241ckg6W25C6wcqQkCGKrmptUjaPCZ8gKSn9IfppI3z6aQWfQamwucKn4VuxG5hhi3pccK1BEmtCVXroF7hiGHPEdkQG+uCvCc+p02ycM8TPj8VQlz1xI5Pieu7xY1c2yVBwriOCYwz9HeuU/0XNMrjAIY+Gwz0audjCaFB4HVgfSY75JsF+gMxjJoxtifL7Oipvxt3sHzBsvlMCH0x5K1zTdg+LVgKETpuzfvLpEEqWg72j6g+pY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(5660300002)(41300700001)(8676002)(4326008)(8936002)(2906002)(7416002)(6506007)(6512007)(36756003)(38100700002)(26005)(2616005)(1076003)(83380400001)(6916009)(316002)(66556008)(66946007)(54906003)(478600001)(86362001)(66476007)(33656002)(6486002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yyfNbhoHuM3sXYeD8gSre54OF9sh5stSCBnBDFLfK1p8jFVOKBA0c8hRyPdc?=
 =?us-ascii?Q?FrJAMm9Dl5305IyATBvbOOGIVqDPXnM6IwCd0EYVZatD21USpg8MRuN6Jkz9?=
 =?us-ascii?Q?9yF0Q5Tgdl+AGTw+EYF2j9k9fgvX09e4R1t8ibZkTw/66hwU0qP3dqvc+oEk?=
 =?us-ascii?Q?O7MR7l1nFQTogx9uu78qvAYEnRaX3BHUwm1XzFRiTw0f/jgmkCIv/gHwEvsn?=
 =?us-ascii?Q?mP6o0TKKTQzGlfAJrLro3M8VcFizzmnQv+iGPY1F9njZPE9SZqjJj78e5PT+?=
 =?us-ascii?Q?Kit/L11ACyR7qcFF7lG3/5uM+LjP6HUBU1sutE1CyoptOXOlD71FBD3LLDba?=
 =?us-ascii?Q?M0tGjNqK/TBq/g1/7MKKB/f84bZO6tKnV726kYQG47JHicIyA2RzRFQmdeTp?=
 =?us-ascii?Q?+/Uc6NcKOOvi9rJNIpeIyIIQLS0vG9lzAu5DYRsTg3pUGrG3gktF/m9g5v2J?=
 =?us-ascii?Q?61x6N6WS50zMm+xnJBDEgZEEeGFwxHk+cg2QwDDUWJk8G1ShfjsovM4Y9+vL?=
 =?us-ascii?Q?Stx1dvzKKTNAdDHA17Sw1e/tceJ5AuFvZvhSRR24Cug1kEFQk57nNiOI0+1c?=
 =?us-ascii?Q?kCDVs4NwGpECaI99DEQsbM8M8xvtOB4MiR+civ0/60cgpqjOlHeRWPmWRZFl?=
 =?us-ascii?Q?XLQvMszlirpRSraPYg3SyfDOtL2jwvmmOoHurlR43tD1uiE+oBK2wRBGW21X?=
 =?us-ascii?Q?Q0dQNjnkdiFjI2mpLubiwnd1tHc07i7mV+szTLhuQaVWp51Cb+Wy7rYvZuJk?=
 =?us-ascii?Q?t+JVqnVXygLiTOAK5ad73xF+mlw8IiBaeMQIq97iODVXd4rPCSiIxbNJuOIX?=
 =?us-ascii?Q?U4LA1kCYPTgY4tFso7mwf8rwizIPbslSgE7x1tIumQso0rhE+6efr0Tkf76s?=
 =?us-ascii?Q?5QwCwk5/fCNXOHz7Mi6Ga95xe6Mtwu5dHrR+KMJVxoGpslSsgiK8zLG2S4FJ?=
 =?us-ascii?Q?VgvLVLUYjMct+Cv4sxKkJiTmr9rkcsIf+1aUOlKGK8UXwAxK6au46EptFuhb?=
 =?us-ascii?Q?kAI1odrGZ6vJcpl6jhoiZXeQH+qa+LNYNa5qiZQnEsqk1no3mke4FPDPv6nR?=
 =?us-ascii?Q?YodFC25AcBeOXjHOykjbCxY2ob+sly1hvkjTYViyGzd2LvfxDl0bfncZCPXw?=
 =?us-ascii?Q?nvGWdedpjxawPvgsjaPxeKUFflPEjTg4yYJFbsYeI3CXD7v4+1aWfuoZEbAi?=
 =?us-ascii?Q?/9YFiH8Xg49JStuu96pnRIWu8R1dCE8nbWX864CMljoyOd+ByQQqEU4VXCrP?=
 =?us-ascii?Q?eBgk9I8npT4CXMz/jd87woxT1UfivFPhFdAb4oj7HMFt7b5MOERT0YAJU0bv?=
 =?us-ascii?Q?RS8dbc8IN7JyZOFsIBEhpQnJA2P+XJ7TtiPwWYknelf+eGXi/TehW99eYlw1?=
 =?us-ascii?Q?S+Rc1GHEVb+EWJwV6rsrB4Momqwo67+u9bRI1bcrUregm6b30x9iWG1MnPNl?=
 =?us-ascii?Q?TEE3rbMwR70mdHYYBnMUQ03penmFKXEZYU1w9ma0Z1FOzR759lk+t3cr+JFD?=
 =?us-ascii?Q?I+Ba4Bppusc3tLskHsjynVIFOAX0aDJ7NqrSAXleYpFdt8L8/F9XV06QCDsO?=
 =?us-ascii?Q?brkljjqnKR7DAwVSy5puYct9IYDXtWVxbB/tYY5D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7916fcd9-fcf3-416a-530c-08dbd0ff71f9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:59:35.1521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viNhMYhQHioEOJ0wGiee13UufO/9hx9OTxWbjbEvMsWs9dO9GXGlwsIZ3GKTAgi0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 12:58:29PM +0100, Joao Martins wrote:

> Sigh, I realized that Intel's pfn_to_dma_pte() (main lookup function for
> map/unmap/iova_to_phys) does something a little off when it finds a non-present
> PTE. It allocates a page table to it; which is not OK in this specific case (I
> would argue it's neither for iova_to_phys but well maybe I misunderstand the
> expectation of that API).

Oh :(
 
> AMD has no such behaviour, though that driver per your earlier suggestion might
> need to wait until -rc1 for some of the refactorings get merged. Hopefully we
> don't need to wait for the last 3 series of AMD Driver refactoring (?) to be
> done as that looks to be more SVA related; Unless there's something more
> specific you are looking for prior to introducing AMD's domain_alloc_user().

I don't think we need to wait, it just needs to go on the cleaning list.
 
> Anyhow, let me fix this, and post an update. Perhaps it's best I target this for
> -rc1 and have improved page-table walkers all at once [the iommufd_log_perf
> thingie below unlikely to be part of this set right away]. I have been playing
> with the AMD driver a lot more on baremetal, so I am getting confident on the
> snippet below (even with big IOVA ranges). I'm also retrying to see in-house if
> there's now a rev3.0 Intel machine that I can post results for -rc1 (last time
> in v2 I didn't; but things could have changed).

I'd rather you keep it simple and send the walkers as followups to the
driver maintainers directly.

> > for themselves; so more and more I need to work on something like
> > iommufd_log_perf tool under tools/testing that is similar to the gup_perf to make all
> > performance work obvious and 'standardized'

We have a mlx5 vfio driver in rdma-core and I have been thinking it
would be a nice basis for building an iommufd tester/benchmarker as it
has a wide set of "easilly" triggered functionality.

Jason
