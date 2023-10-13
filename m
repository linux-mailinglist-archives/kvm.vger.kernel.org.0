Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F947C8B70
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjJMQbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjJMQb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:31:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8193210F3
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtmM8FnEh16ah+NMFgpRr1iFw8avCiD++D7yxIZA3bJFpZigpF+1WR7wNjXtD3R8loTnGafA9qRZcxfqfLMLtYsMyg39b6TW8Ju4Wue+UEfjKdrOh/45y7mqIUtegOl3P9vtwfbzuUA64Y5RnjmVphF58wZ94oce6/fSUiSZrXjlT+g2JiXgBMJ3j/Muuln6U+w6fip1cZkoNEfvUDE1mnsKMikfT0OIIrcd8rkz9yagycWu6EvtEN6FgXOBaUCHSU9oyO4PyiOPtTTGsz/e61TY6l3mzAp6VQ1Tkn+hq0zdwApJUCUUtj8kjZ4jZf+ASTqZ8+6JzFuIWIH/X9nyRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzrY32RkTfnqhAQnu8J5PFCv47gUx3mawZd4GLLfLQQ=;
 b=SLsgvItAtepBw97pwkZayCnEAPfU4QIl5FTN7V53zdyOYE46btIo7+7o9BIMAwbRvSOZqSURopjSLLzyuVSxB/V51XHQ+M7AswqSbDBYXhpC2gnQJyyGoQrSIp24pzfZ1K56WdNt+u09LchIW6Qr4zHComJW/l3wnYgQl3SlEKKnB54nECOMhqHMgah5KoeBPVbN1lLJu6LYF4H3gRCp0kGH9c8oQZlA/0XCBrTrQYqW+u7Eln0wGcwnXN956Iiq2j+SXX+hRT/5vZeX82a/+tvSVIWSdEKNasC+V2ZSMyorEvEF2SX+IuFVA9vJ3NlQl+yvkUnhYxQHGUg/2n3qzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzrY32RkTfnqhAQnu8J5PFCv47gUx3mawZd4GLLfLQQ=;
 b=orMM6nno7xvrU2pI3MFfAxV24WXlp32bi6fFgubitz26N/3iJSzW+cH5WoKOM8g4mLJfLG6iEBzXgMpbc0PyNNOTjfqSWSWx1A+ciLQWrGLsiml7e0YigsSZLX+fRujwgdiTHuoFc+WqkPP03J+ilYY5FBxTY9h0u06yNmnFgupc0Gv0uPbQPzs2ysc/C/ERvtD6Hml4Wr0rOJkSSRvzUaUBOeMuhGVDGy86YTZgE1eorf+nNFKL8SIYBuNlIPqU3yprg9gQ6Mq/2YR1Iv/ERi1VG7CeuFzfbp3y77qEyXPCu/MGf7lZa8z5Jh6fob0uxwjCsdYOlArgWvIFAtggPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 16:29:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:29:50 +0000
Date:   Fri, 13 Oct 2023 13:29:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>
Cc:     iommu@lists.linux.dev,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/19] IOMMUFD Dirty Tracking
Message-ID: <20231013162949.GG3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-1-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:208:d4::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: aef6599e-8d5f-4d7f-56dd-08dbcc099f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qruPf9KChOpuhQBgN/reTAKFP9b9NCNjgH+WMtSa5m683Wy1WjCRgY8b9V7F2f/n8WzcoMFvAc55wMr1iZu+SHpkiXg3c3bIki8vfgrDkaq2p6kE7Jo0C/666hU1glRbuZe5gYYt2K4az5xL8FU5fzG5dLN0bR8w6zkMjgBqmNlSjYPsu1iWeLU/BXlXPdSCit88b6ciV5zKLFlbe9yNaMG2pTa8Z6jHQl4aL3DFMPIHHA3/4eUi59d/UsOyqQRwWjBV1XcZfe/DhY6Io+1FI0iSazM6g1l5rGbfnL2fOtLw0UCwZnq4U1l6XTbD6yodGa0dg8OdD2KNlXp2T7utTwS4bAoG5HjHdPQTTbLv/Zn/tnn37TMdmk1THKVAaaeoV5xpy4aQJyswhyS2x+dJMQihvYMTEEyB3s5wvUyNpweSt1tbm9O9FZwssLu4OG4NoQO/2GruBgRECDk7wcv81qJozrVvMioEYzJytKsTIvh+Fa/8d2zTjcB0FocWNB+32i61swUdDtv1zJp/j6H/ADnecJvs7wFHe8JRW7eIYEVS/GHfKsGWftMxq2YEgSM3lZyAY2CIIlzIJzxQCq+dgA4ULuyIP8EvYe+wtim7JhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(366004)(39860400002)(376002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(26005)(33656002)(6506007)(316002)(36756003)(66946007)(83380400001)(66476007)(66556008)(54906003)(110136005)(2616005)(86362001)(38100700002)(1076003)(6512007)(2906002)(6486002)(478600001)(7416002)(5660300002)(8936002)(4326008)(8676002)(41300700001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E/LUhWI+M3iDGJ+udjeS/FS3V0ls2pGJgCsbq3CeQsCRIeqz5Y4JEoCBto1o?=
 =?us-ascii?Q?l4lg+DL//HMOxqqx1fm+RW/qVTuFygKMd+FIpMB9Lwb1NFOryLFLUIPkzAn2?=
 =?us-ascii?Q?qlWOhpKA2zMCU78ctHaFm30Q23YHKfmmPShkWAqpgXcRM2q9mSObOR3W+hmw?=
 =?us-ascii?Q?qi3uxYloX9f98058MRowU7Y4+UcmMmIkXKS5rT4UwOrS0XAgJUOQNeq0+DOP?=
 =?us-ascii?Q?nKDyau053Jm9rsHJ+qypssciG+TBrqIyqyyCD+ebICqVTL4ahKlxDKB52EDm?=
 =?us-ascii?Q?DU03Am0+sjwWKqH9MYKHbbfzZtuHmB3uVIf+E9wYNKNCXLiYJoA1pWHG/8s8?=
 =?us-ascii?Q?MAZkNLgl6cj53j0/nfgAEzqU826KorjBQXjKcCeDdK13Um1GyJwVAyjwbyqZ?=
 =?us-ascii?Q?XpaEZlkrRTNqYsovz5oznxrpsrO6eDedBbrWufvCY9V9e/1YFPwd9bIAU4o2?=
 =?us-ascii?Q?L++kP1LdeVn8s5bzZ/03VvutU7XZX0dfPW5ODBfitHVCQw9HWbMOQvG1IYpr?=
 =?us-ascii?Q?RFmgRmEFPo7eWMBzLtmzNrBSP2FulDfTSmTtk/VjgUkzRAlCQbporwzbP23P?=
 =?us-ascii?Q?htNheP5mqEbJn7GZzUK/PncHaNDJuQeVGwOBhMDcFTsShusvxxzvhr0bKPjo?=
 =?us-ascii?Q?/TJBhZKRB3xO1xXp6Ljdozmb4f/7Sz9SvCX8/uhhPkCEeLDTN2UugWyBsTQQ?=
 =?us-ascii?Q?6KtI6/zZ7XkW2fcijewHGP9eQKl6Y5yDUF77UhUBE1IO6b6Fut4jClzF4Xj3?=
 =?us-ascii?Q?gmpXEfIxLGWQ4O/QKbxcrIzoks/2WBeZFO26YsmUHJ0K/kN9vWzuialAzITI?=
 =?us-ascii?Q?mLGCAnzPl0HUu1SEv7IrhxJVfisi1HLjJvkUwRyFbIFDhxwOEXTAkhfZPAJw?=
 =?us-ascii?Q?8ZS4EA8XwDapZNHdlIJgXj4Vl6Q0xOSvgi1+PkUCBi/1O4yTBOkXr2C7eabQ?=
 =?us-ascii?Q?qVc6nv6fI63LReEpppJUes/iDXirRQn46SgBhBTlC1uofjD+jqUUM32EEbVi?=
 =?us-ascii?Q?v91cjGV6pxzVh949v33DxurSbmDUTWoLPh3uGffRkTNtdoAI1qafRK7mJi/a?=
 =?us-ascii?Q?HaA8FLOCRMN8ewsWVSpWpgtfKGozTl7PgwyP24BxScCJr/liz/tCZzheL/zx?=
 =?us-ascii?Q?wV21IBWFKzz64Cyl99kFD+9QwCC+Ef3tP9ytHcBGUCl3sGnKURKxhlaDBtYY?=
 =?us-ascii?Q?KmPNfBcItNov3KZqc2j3VraSRzc8z8yH3GzsFJzlF8dhMpfvQV8DWmOJ/+Ur?=
 =?us-ascii?Q?K1UvC+XcBmPeqHQdqSeY42K9mCAjBn3Ivori5bnJzP8KBjf+So/k9pqPL8Et?=
 =?us-ascii?Q?qhNtK2ptJ13Ai0WEuLRrxCE3DMpDQPD+NAbzNljkAzofbUAA2V2DqgB4LeT5?=
 =?us-ascii?Q?8UkKUe8zFSW+AWAsTxIIvqr6QqmKkc73gtkAOf8SZ9tzK0jbC38QAjahqLlS?=
 =?us-ascii?Q?sScgGYZE+X9Dv0Bpu1nbdzW0q32248LU71BdN55uO2oVq7oVMvUjTGh9YObe?=
 =?us-ascii?Q?LDmeNmDudJk2QHEDKuY9SVLQG+YYNYSAi5iOHBrYkzwsTe0PcCOwEibnaVUO?=
 =?us-ascii?Q?KMJB+0MqqB2mLrvNxdCAeGXUOTL27KUfOZY1rMBX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aef6599e-8d5f-4d7f-56dd-08dbcc099f58
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:29:50.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WTplSAE7zbWrfuQUmbpZjjpDMQS7d7v4TjBO05hisjbmQty96044RcbygRWttb0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:24:52AM +0100, Joao Martins wrote:

> Joao Martins (19):
>   vfio/iova_bitmap: Export more API symbols
>   vfio: Move iova_bitmap into iommu core
>   iommu: Add iommu_domain ops for dirty tracking
>   iommufd: Add a flag to enforce dirty tracking on attach
>   iommufd/selftest: Expand mock_domain with dev_flags
>   iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
>   iommufd: Dirty tracking data support
>   iommufd: Add IOMMU_HWPT_SET_DIRTY
>   iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
>   iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
>   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_IOVA
>   iommufd: Add capabilities to IOMMU_GET_HW_INFO
>   iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
>   iommufd: Add a flag to skip clearing of IOPTE dirty
>   iommufd/selftest: Test IOMMU_GET_DIRTY_IOVA_NO_CLEAR flag
>   iommu/amd: Add domain_alloc_user based domain allocation
>   iommu/amd: Access/Dirty bit support in IOPTEs
>   iommu/amd: Print access/dirty bits if supported
>   iommu/intel: Access/Dirty bit support for SL domains

I read through this and I'm happy with the design - small points aside

Suggest to fix those and resend ASAP.

Kevin, you should check it too

If either AMD or Intel ack the driver part next week I would take it
this cycle. Otherwise at -rc1.

Also I recommend you push all the selftest to a block of patches at
the end of the series so the core code reads as one chunk. It doesn't
seem as large that way :)

Thanks,
Jason
