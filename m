Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8677D56F9
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 17:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343785AbjJXPzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 11:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343525AbjJXPzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:55:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F401A83
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:55:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZfHWv9xbiRLv5zsYe7NCtcxEEF1YweayVuhBnUFfWVvj675hjzVeGaYklRCj6icF/VGb4Vq3KtdfZDlQnNf2g8Or8LObo1iwNC7iuIUivsMsIKQxu2jdqJdF9bg8Px/0ZE+lZ25zmTl1JcN9qkIJeRKkHPfmYn2mMjXjF2eLxwYKv/L47bUmppWSwtndl4gQeDumeIbG9mI+tnKJreW3vUKk5sjNyTqRZdwS5iQKP8OTLe/jbhSKaBzw/44uX8surBq6No8NonVrZJwr9zShMMz/FouccTrsj6KkUDY8sVihjUNDTab1/wAQ/VnMCsZZkxBlCzw/NeadtTEeJxxWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I6GYO0XtvzuhEJEUNczfAv8lR101IYssd6wZfOz+o5k=;
 b=TU3cEKsAQ8/HTFYgqXt2LSgyo+LQ4WK7CJf5AFdXWXJysM+WD9Ux+9MhtkveDGRRho5wfqFXoBCLsRbT/VlTSQTcM/NN498/lItudb1CnmURkY/qTlyzUIOe7TtrgF1PJBwMameAEqCUJoE7x3W58C68fGAZuD5ZzF2kl/e+k/mf0m4z4sXU6nRoVYtV9T12UV7aaxv6GhEjXYw75y0DQlGRQGh9KafxpdI/lCa0XV+mIO3OtR29NkGOHOD6DeeVmm8YSsEM9obTA8ZzXU6Qu7XcskGAY/38l/WXXXhIYygjJj9tduX9eJRprBpzTbcgnJzAvsRVNQrWkoWLHoZoig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I6GYO0XtvzuhEJEUNczfAv8lR101IYssd6wZfOz+o5k=;
 b=hQEnP5GXfOUxLZD64KnDozoc1Sq1/RsYE7QKBoxX1+2DSe5kuvmyBSKyL2tpSeIQ1tYz6SFewQW1xuGLPmZv+GplfFroeIi4suq28rLbnH5HNl6XwZxpp/hypkH/tXpq4jbhqNJWoPV+sT6IBQ/irEnCrVRhPQQy9y9LWWJlhJs37691nudx6ZtXp99906/3D5bQKKZPL85YhyoVieepWh6C22mqwRDO/eIADPHjA0yG1xoSppG1nDrcUU9yC+r0kamYYhujp2RbTlQ5hhsmdPdcUZ4kC3ORyYphuoYvoMeiqlJ0refdjhGm5eXhR+OQMWkPym/CDZLwbDRX43lMEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6530.namprd12.prod.outlook.com (2603:10b6:208:3a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 15:55:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 24 Oct 2023
 15:55:13 +0000
Date:   Tue, 24 Oct 2023 12:55:12 -0300
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
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Message-ID: <20231024155512.GK3952@nvidia.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024135109.73787-1-joao.m.martins@oracle.com>
X-ClientProxiedBy: SA1P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: 45775ae3-080e-4f61-513a-08dbd4a99bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/JkgJC6/YJcrQ07btzHVQF8N9mQkqG4z04L0e3eMovBhqHVaUYMHOj3DZby6DLLxon2MxPUnNZ3KCC3IlV0gf2KLhPcIrUXTrUEmno235E+rfAEnlO4X82WGLcXjR6GQvMc9vMhJxb63nHnkLOhbFtiSlxDGrpsNX3tIeGT8PV2KcqC/yWropXkW/H+RmkqbSS/t5ggASgI/5+JChlnydujvRlfJ9IC45jTfPzobndX6P/Kva8wDWDXwQgts9akkzTzFvKeSCX3BmVLl58ZfMY9Xdb8vVc3wKcFRT51zj8r7b3/g1k0abeVSUd04LbyX8aRhUUoTH+cego78OdWokkSdYDuhBG2r0ebAqfm/6zi36DzgU8Kly06UiM2ERK99K6S/Ji1QcEfj6RtG52aus/dynKRMtwybmKvQJinziXsD4IXZNgn8kvYLQGUu7luuTkcmJimfpnfmx52T+BaUkgciVP1JkTK+azgtwh/ru7qgTGjaard4QsayjZYV0Ul6uWiPOAQwxkDE0ErQKJby8L4MGl5p0TqR+RV7eRBtRnPW8DTCl+Q9Y0vbqGQTAI1FPzH2nHUjX7PLd27xK++BfEnnhFe20wTPaiOeKJ067qgzZPRtjxIumOt8V2rMmzzcbpvijcHBOkE9Q42XC00Eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(346002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(6916009)(33656002)(2906002)(5660300002)(36756003)(8936002)(8676002)(4326008)(7416002)(66946007)(41300700001)(66476007)(966005)(54906003)(6486002)(6512007)(478600001)(6506007)(86362001)(2616005)(26005)(1076003)(66556008)(38100700002)(316002)(83380400001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hhST/FtiiPKvgIdPVVKAWyN2O9EebEhESA63cVUDfFm9gnShP0IH266c8TVv?=
 =?us-ascii?Q?spwItQAm2dFW6oinoA+JUmXrXKqcaXO53F77etCaHYJfBPHhWqnShc6IO/Bx?=
 =?us-ascii?Q?FU2UMy/3DUBIgYLBE4jck2XKvDHO8twcSZ3n9gSJpP/EIBzo0ksd9AQ5qN1p?=
 =?us-ascii?Q?MT4ANs/eQpT7Aqma2S5Ol2N1tgkuf7FIW6QTJyXRyqQlZOFaI49iS7u+iEjd?=
 =?us-ascii?Q?vKpGTzh81PG0AZEZ/oUawDESq3ZcBGd6a4FAplqhkZtwNGkhkBFUJ2ghUyp3?=
 =?us-ascii?Q?EKuTDCSqcfcuxxAxd34VCTlBcfjCbfPHXyDJnFTAkf6AAbpBF8XiDJggRdHq?=
 =?us-ascii?Q?W8YXkUB9evSfNwKsFOI1Ox8UcBwr+AHloZmV7DhlcAbOemZ3MAvSOPk+qBVr?=
 =?us-ascii?Q?BYC6EDDTV1gM+k0MAhRJVfOryU98PIDCF/xOT7gi9UFsU63r52qvRbS21Pjq?=
 =?us-ascii?Q?lwkG/BvvJfzknXNa19Wc1K32tAZ5pCyKLMQ3u8W59TotzLSatkdejm48Hfp5?=
 =?us-ascii?Q?0BlTTbDZy1wQfeybklacPCm6zpWQWZrN1+X6yxMJb5W20AxhQaW601TuX2KD?=
 =?us-ascii?Q?GewAh+Yf1yFLu1wpR8uqXBJ23JC793MNoaI+xBQEmIU6mjEtDf7Knu7cAVKd?=
 =?us-ascii?Q?Z1rLn2L1MXZwFhKqQ/QaFP77FQdGUNtwA8GHYjhVgGzQUYVpHO54dpBSbwfG?=
 =?us-ascii?Q?CHdplSU06cLDLXnIrZPll355Dr2M3BsTXYho7FT39WoE3qdg4sXVZRDOoCsU?=
 =?us-ascii?Q?qlXcwyCNrb/PsWMg9FdRa3iNGBnaWuMEHgAUJrWkvNl/bwGtir4Z8o+dMd9M?=
 =?us-ascii?Q?fUZpBHiR8fULy+AZz5KApOurysAg7NPI770mnebpkkWAXYZzwR6knOuw+Xnm?=
 =?us-ascii?Q?FgZyxAykfBPP6q6sgz0g5GnuqWNFkyY8LHdYIe8zVtClpE8k1nJ37EHDwVuT?=
 =?us-ascii?Q?7YGnltaBNQliNmt8ghBwzX696aGwimxZdML+gHpmkZt9t3yumDzNo/XHAKB8?=
 =?us-ascii?Q?onztS170HShqHHTaM8ffArKyNfHzEVxpQwjjOd+GmYaDYuSZt2T428sy5/jU?=
 =?us-ascii?Q?R0wLtGGt4DWZa8uf70k2iN7ut/KIBeoffZmGJM80Zi1IXqKZM9T01OAiqxWl?=
 =?us-ascii?Q?qEhqxzfluNqBPdxEeNdidwr0d1k9Q9xO/XnDvx0Fx2fzL1PXW0nor7c/gILz?=
 =?us-ascii?Q?UjTXJvrw1VWQdQSV2pzlMYZqvOd4iND1eTSOuG7+TQTAMLrVCXGC42q9i8OD?=
 =?us-ascii?Q?7FkwImGPGxC5we6DtrWqGODoZD3v1PAfdO5VFRtA5vJ0X3Pcwvt0PsVSoB6X?=
 =?us-ascii?Q?83JT87oTaOywdnwBH1irjuSyBdB+S7UI538AxyDHepCXqEXLhypsR1uyGrM7?=
 =?us-ascii?Q?exDZrwthxUyx0XDhWxqN+42QMyIAhKhjgn7yZSYj3eZd5RA3CowGqVkCJKCN?=
 =?us-ascii?Q?BTPI3syZAMJCgy5OPF2TxpLwyTdfn4fv23Vsr6lShLCkVdd7A1EYxx0chmt6?=
 =?us-ascii?Q?OLOD3x96cbvRs37SXcg/8CkCFKvJiRwpxYTB0RP9ZQvwG3cbUc3GPqfViDVc?=
 =?us-ascii?Q?heubcosBJ9waM3bfQ7rSYdjZWun7xFuB8ncGDaDS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45775ae3-080e-4f61-513a-08dbd4a99bf0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 15:55:13.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPHGcvL+/zHLpeq1KSTXxgeUmHv/zCZrLc4uH2WVdEFtx+WTVqVeD2Okn6WxqpPd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 02:50:51PM +0100, Joao Martins wrote:
> v6 is a replacement of what's in iommufd next:
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
> 
> Joao Martins (18):
>   vfio/iova_bitmap: Export more API symbols
>   vfio: Move iova_bitmap into iommufd
>   iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
>   iommu: Add iommu_domain ops for dirty tracking
>   iommufd: Add a flag to enforce dirty tracking on attach
>   iommufd: Add IOMMU_HWPT_SET_DIRTY_TRACKING
>   iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
>   iommufd: Add capabilities to IOMMU_GET_HW_INFO
>   iommufd: Add a flag to skip clearing of IOPTE dirty
>   iommu/amd: Add domain_alloc_user based domain allocation
>   iommu/amd: Access/Dirty bit support in IOPTEs
>   iommu/vt-d: Access/Dirty bit support for SS domains
>   iommufd/selftest: Expand mock_domain with dev_flags
>   iommufd/selftest: Test IOMMU_HWPT_ALLOC_DIRTY_TRACKING
>   iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
>   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP
>   iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
>   iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR flag

Ok, I refreshed the series, thanks!

Jason
