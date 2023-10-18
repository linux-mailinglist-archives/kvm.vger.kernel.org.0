Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703FA7CEB68
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjJRWii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjJRWih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:38:37 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B297111C
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:38:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijcXBcOAXBkbvTbCsTvhUR3a1nRc0VZjXw70ZGFbwjmyNrevLyJe6ic7NwvGE74MhZDu4onK2ueQtzOVwTASJTBRzpTs/zKJTeAQyZTEGj9PJJxWA8idngX6HJ3P09wuLjWrIL3Mqi57bmpceCAoCnoMKCqHte+lHMaZP8WBJIHeZyDuzIaSDfyHlZ0vFXv/soTpgllxLL+XrYPcceKFnf6IdMyCcVGYFvNIs+2YHj2bYnFSbSBusmKmRw+v74gX4xO02b8ycYezfigPho2GJGis66pseRgZ/N9FdGUTOzjBaPQPIruxTSZLViD3KlUxTP0UEMSCGOd7ggcQBQaRnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34Apla85arxspa2d0S6TZUK2bhctGVclayy7pqc7BqA=;
 b=hgVCi2Of3VPNY9t7buiye847W2jbNwWabB/bn0pPrNQcNEOo55LiajnElfk0yrSqrv6AbCNREn0Zn60Un791nFGwiNoj68nUaGY4vK8hYtUusWChXZdMlf9Dr86eMvnBigEosdHvp6Uw+QXwEa5gM/ZxtrlpCQdcFAagX40oAEcBpsvmFgjgrLQyJCp2h7H202O6B1zLDYmLGlm+NGi8atZsPd3Fwg+xoWswngHzgVfJPxtpjHpl4uRgI2V+3BbPVk6s0OWDZQ9jhQrOnUKlnclaSzZ2dRng5otZ6vnmUhyohlV2pM4j827N3rN4g8k1QAggaY9Ujuas8K1bOZiAqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=34Apla85arxspa2d0S6TZUK2bhctGVclayy7pqc7BqA=;
 b=RODW2mq7CoIRjr0yu97C9Iy2xeXDZwFP3hMOJN4wRyeFjTIXM9HjQZtrc3jwQ3GbrYL8o3G/NN5zNipTduGGpLlywQX7QCN+NLJObMGV0CCiiVnUVvO/kngDHRAubd1BjcMBsu4dtfaEkH1ui4I7wsoUyCdpH1bLqvlvdXYCaju55Q1ocAsKxpmdOm/q21UZ87YMZR6/Y+gdyXEUmZuKEGAO4Fbt7ng+YAEjb405+6O/uMn1GG9XYqeDLhm8Ynpldf2w3Az9lwASdXtoEm+l0xeTcLp5BqGqqHMqA9Rixt5L2/ol0LGjWFlFpXKVIpFpuc8zUKnQPnCvzgftHzmVuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.23; Wed, 18 Oct
 2023 22:38:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:38:33 +0000
Date:   Wed, 18 Oct 2023 19:38:31 -0300
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
Subject: Re: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking
 on attach
Message-ID: <20231018223831.GA747062@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-6-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-6-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6460:EE_
X-MS-Office365-Filtering-Correlation-Id: 54165e3c-4cc7-4a3f-ada8-08dbd02af59d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L5BIY56k9jfiI45IVVn5J/Qgl1TMbsjRBAuceSjvY6uMEOcTEqbb2uEm8KN9fhaNeC3vqqywwFtyIIDGSq7T6B9KpAIZfpBbdtW3lgv+MayIvGAQj2Tov45WQZ6L2RmeG4CDxagQEi3RXJ1XY9oWGDmpUid6XugCsXy1OO3IvBn3ST1lYxjLSYv5CRZWJ9XQJtFEn0wuycxV+HnE2oAyWua/W9ipv7c2i9lOScTQQDeK2JvuZqZGafV3zm633W3NhzurDG+xtPZOY1mMrBhs/faFxfxrWoHeNFFIrQ43LFGHVq07Ncx12CWMCCRpn/uWCIMs/L1HGlJJ4NX0Iwa+zRgKP0TU67QSjHXAHJc5sIlu5krMpeRarUJWRY+cjfePwD2zAusQnHKoDwQWH6R0TXo3XlUkv9c3IgNmWTq8/OpUctpeqWskq3NWJZ3Ld3mA0ccYMbsRbTF37mNT490kjfnkHEhT28B+ubOgBB9RN0DpSS+oXxNEQOEpibJuVdreoOGZRVBNJptiaW6jGfF4ZBYZD3RpXrw+uY0hi8jsfl3IlkKTorl6oggfBZGTYFqScCbtabvLc1+8GnudIczE3hP9wYHsAZk/8TsxpYpaV0gNkFSyXB9s3p5DDxTqegbKL57BZlmvgX54zXU/+90TiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(38100700002)(5660300002)(1076003)(2616005)(36756003)(6512007)(2906002)(86362001)(4744005)(6916009)(66556008)(66476007)(41300700001)(316002)(66946007)(7416002)(4326008)(8676002)(8936002)(54906003)(478600001)(6506007)(6486002)(33656002)(26005)(27376004)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSX/DJBvsGBPmvmhPDXKJRjxiVIAcEQ4m6d+SrjpHoty2M3TZvzNVb42oHmL?=
 =?us-ascii?Q?6Nkb03avxzh53CCf+WQlBiuMTOlIeM0S2khp735pPSTpLj9HHPI8NqW8ER5/?=
 =?us-ascii?Q?nCmSDJl9eFRfXkIrXRbJe0u+8BYVsyqSWzbmWUT/16MLAqKkuRUG1+kjYnJB?=
 =?us-ascii?Q?d5BNZHreathywr1lLmyVQxpKVnKcJQ47wFyAnSSs0hxomZkxD78n+We5D1IQ?=
 =?us-ascii?Q?ef6bNNbw8DPXJT7yl31GK1n+hV9oA8zNea+O8aYvAwrS/gssqp75jtH10aXN?=
 =?us-ascii?Q?zSey5qSvfyXL9OzXVB4qS3G01+4e7ma+9dG81I8/lLzwu1fOAhIGiG49ezzl?=
 =?us-ascii?Q?tFTGWsiD0lp2BFFkOOSZ0OGkTp3H1NLbBxX0Nzio0J4GDsCa1uuAevts4MrQ?=
 =?us-ascii?Q?oRizQWerV2hvf2yubyBXH3ZAmm0LxtIThFpVXuCyFW3u7RCWlVMf/17ZXARp?=
 =?us-ascii?Q?UttXLY72cUH4HYaWPG2tcsxX+bZhPISRnle7MZQSiSPuKKwW471YAutdSPQ0?=
 =?us-ascii?Q?UHQEdTieTiVHSfPFWDVX1AnWhGhE+NdWSOmrdpiS9kUbBu7aCOuLxNOeeLWv?=
 =?us-ascii?Q?4kjuxWbZUQF6Y3rSzkQmllknUbZY7KR0wz4uifdaiPn/XnePBJudJvQhwGux?=
 =?us-ascii?Q?lsa0j7+fdBryLqaU5asABwUO2E3RTc4YZg0wiWDaLbKPY/7tTc+yMXja8889?=
 =?us-ascii?Q?79aUVakMsUIjjm1LIQqFDFL4Aycq6ESa+0nFDuHPIPoJN8VOysg6shlu59R7?=
 =?us-ascii?Q?w40bvsgXhBjEYk8pXRP5sQCfmh9PIvabdZGzYoWTzy22v5ImCclZTkH218hn?=
 =?us-ascii?Q?omNmuMTVReKGZjoI12sCMcoCtJ0v3r2LpHryMOW0eLltWojYxB+RRFwaRbJq?=
 =?us-ascii?Q?BRgxAKuEKu6LEOcG0LUX+rw84Ugu5WpQMkOZmiXFymiCECKkoAA0Er0hl+1y?=
 =?us-ascii?Q?KRDifh+3h1FuOFOv5I7yjdsw2MigrYRLoFy+zXNbHa5l/YKPat0jpnje8mb1?=
 =?us-ascii?Q?nX/rGisFN0meyH2ZFwmrJOBtWk7XxJZ0z/FPbcYoF7OztCziz5au0JMjLCKm?=
 =?us-ascii?Q?JbEiCPLE3WYvQKdZLmxbvbKpt82gnfqyyiuLVBjUdqMnM8srl9GkUyBWEAoo?=
 =?us-ascii?Q?L0H5sxzQoh0UMuTYo6y5i0K9oTJYH/d0d/mBLIkLGrsWO0MOPZiiS1tbYZkm?=
 =?us-ascii?Q?kK7Z6lY6GD9KmJ6YrPU3fv6he0X4/pFGC14p6Wod5iTd113WIi9y8nX+qZxE?=
 =?us-ascii?Q?153BMQeu/gPbsCXYVLTFTgSibm3bbZuJVaAAySNbKJHMbsFUDcddENWRHgUK?=
 =?us-ascii?Q?G0dAH3BhoWjNXtWbt3r5wCAkF2i6biOBfZWvcvQUq8iQHXjXr41bKyhsuadN?=
 =?us-ascii?Q?+JTNp/hmRvaNPYafzJDLrIUxYPZWzYJcGKxoUaaRk5MZL3Sp9uuLZP8J5rGF?=
 =?us-ascii?Q?50oSALS0G28Mew0LPBOX7xCXy+75uyqaD6LaYZ8Lsc/6dIh7ZzNzBcJnkV0x?=
 =?us-ascii?Q?zqdiQSeScqT6VQa4VJ7nTvSS//vzzF/z+76zAVPbYxvy7v/57yrQazoBPK8F?=
 =?us-ascii?Q?2+oE8HL1LJbu7PdaT3DJhmGGnNzooy3JskZdbDCn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54165e3c-4cc7-4a3f-ada8-08dbd02af59d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:38:33.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2onfUI13KznH9T3FY30FmZrTPIG3BpyUswxQT13Afpoc0cWXZcVM2aUFBzB3HlbQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6460
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        TRACKER_ID autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:02PM +0100, Joao Martins wrote:
> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
> guarantees are needed such that any device attached to the iommu_domain
> supports dirty tracking.
> 
> The idea is to handle a case where IOMMU in the system are assymetric
> feature-wise and thus the capability may not be supported for all devices.
> The enforcement is done by adding a flag into HWPT_ALLOC namely:
> 
> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY

Actually, can we change this name?

IOMMUFD_HWPT_ALLOC_DIRTY_TRACKING

?

There isnt' really anything 'enforce' here, it just creates a domain
that will always allow the eventual IOMMU_DIRTY_TRACKING_ENABLE no
matter what it is attached to.

That is the same as the other domain flags like NEST_PARENT

Jason
