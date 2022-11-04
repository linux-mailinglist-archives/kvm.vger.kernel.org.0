Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1F619750
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 14:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiKDNQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 09:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiKDNQV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 09:16:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF64F12AF1;
        Fri,  4 Nov 2022 06:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoxvuHDZKJ4FPRHQOE8DcayzbKmY34h2w6x7+Dlz0jqh6ldlTzjmunZmf9MkHOCVDorXSs8U7E3VbhWJWJ20eAYN0TcAB7J4EIKtySPWbazRfvxvgABhd95Lb4MfVFx3KJjD7//qzLJPb8GGW4SiPmA3Dv/INs815GdP8MDwVr+7RogEV1AfTFTYdv6fVIi6iju2w3yuqvGsMDAFJEqSaAFKAI80VazbgzCXyYjao3f8orgYqng+aM/cQzDzLc0mb4SQsRNzmiZZE1RTpkJwuajLctiChRz9tQ6kxZnj5j0x2D3at/zqz60ujXXxXRmm7UeSpAHkMfrPGtmrsFlsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhqiwN9iG4xOX+MwWS8RByX1DI9RFcX4tKfvqxfeKsA=;
 b=Qgx756Lx+Zcb3pRGUicSqlbB9baXZlhBjciT389ausTk44MT1IRm9UDLhspWeMqHmshUYNHrgLo1483JjKybBco3ZfE/iO6dx/CkjkSWceBAwkoJxMjDf9r5lNmcx5/gNBzYq0j+nOju8VpM2sQF+DlFLUdVahlwvk+/8ACXtGTqYcp44BoSWMR6GFScJd+/eznBKGb5KOHva5OUVXtIkUygUABCSHBoNu0/axMdTeOzNfzTJK37zSFexAwDOQgeL0cDHX0N4m2IxibxXEFp1D6uHgdbxNQvYrMGhyeV1L0VGdJLRjgFl0NcGRJuom9OmD8GusyKhw985urcb+SXFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhqiwN9iG4xOX+MwWS8RByX1DI9RFcX4tKfvqxfeKsA=;
 b=gc1cAAukmda97gcOJCjrseZ1sLbTawNpf15cO2yd0yjUZbG+2Sli+xNX6J6NN3kWntXvASQqgjzoM3laUQvLr2ZN1JTJdnJG6g5lLK8LD7McMIlSY2XCYdkK2tDhIPQKds925FcgWf48cSYp7+7buck/Qx+du6NSUB6sPSsOnx+yVbT54B7sRAwxr/IFN1pJH/NqvMNnXIMb7uWlGzE03iSx6wsyQrqjcB+PtzIktwrcmTc2nEj/EiDz6l9oeNvCxyA4bhz3Xgsw/C0GhcXEyjfFWFhkOBjL3jal1VLfMWpv12bQBkvop8+xLmOA9NJB36LOI5wMAnWMmigRzMXc0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Fri, 4 Nov
 2022 13:16:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5769.015; Fri, 4 Nov 2022
 13:16:15 +0000
Date:   Fri, 4 Nov 2022 10:16:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     liulongfang <liulongfang@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        shameerali.kolothum.thodi@huawei.com, john.garry@huawei.com,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] hisi_acc_vfio_pci: Add debugfs to migration driver
Message-ID: <Y2UQnQjKFrHZ6PT4@nvidia.com>
References: <20221019081033.3169-1-liulongfang@huawei.com>
 <20221019081033.3169-2-liulongfang@huawei.com>
 <20221103142113.73ceddc9.alex.williamson@redhat.com>
 <def63749-6005-8a67-8858-c5b0ff4f633d@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def63749-6005-8a67-8858-c5b0ff4f633d@huawei.com>
X-ClientProxiedBy: MN2PR12CA0004.namprd12.prod.outlook.com
 (2603:10b6:208:a8::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 53fa377d-9ea1-4be4-ec38-08dabe66c066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mLEWYinTKib6WBNLhRSX/rF9q98V73y+8CsuKIQ8vtJeEymib7B8CrSlqZYR0yOiBidOaKXV5u9GctZ8jeBWn/CyANr18zgYBUhely05JwPR4SbdJkGVpxQY+GUqd0ejim5M55A2Cer4HnEiCdOhhVi8qdlrioXgK8VJkc49CMDk5t1xXGDAFOlCZe9ELByEVch7IDfChO//JEPCou10c6PqsB1j8bBVo0g+aLMls+VB4unQ9xNRsdP0xHOMGAfPjfjYdpynl8lmz0YQq6Hz6sIZcQMWN/vulG3q3nkJPpejTb1yf8q0GqZ1hOb08Q7ZlXVfZOp2wkdgOfQsxJcdySKjXB4Fb5yhI4Bd42bFkTJTTKUwAU1e7nfxRYmJNHPWLsqLm0ljipvrg8j/5nhwO+leoFND4+9QEKFTPLafIEIJ5Au+c1vYqQZQWMAavHzbpOsyFLQ2hcLVRd6qmabB9NY/Y0oGTA8HofggTNQlBZ0/+2O8jSEw7XqS+ywGzY1qEW+9OPjFAjHiYloe8xqkoEF1jxLvn8JQA8vj1LA0wU6KvshkARatX2ZnwVoMXw3jnXBVYLisBG/k+aTUE1JtMzAdwRnFluIIOO1L+9BjgkcfKZkpW3VfHM48X0TFoz8G87Vj5rRDYBFS782EIUKCVB/9Yyw9n2/kDXvmjX3t+H1R4ev0PXkDkojN40gSV3FLtvRc+ElhAbOGvSMgBfXYsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(26005)(6916009)(66946007)(8936002)(41300700001)(4326008)(66476007)(5660300002)(8676002)(6506007)(54906003)(6486002)(2616005)(316002)(6512007)(478600001)(36756003)(2906002)(38100700002)(53546011)(186003)(83380400001)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5c4MD5kCYqQQ9Q83AIZQ50psEFOveIysWBNF8VWw6AhtffRRxPqGWSY6T85o?=
 =?us-ascii?Q?sztuRQiSD4//EAPjGS/lRXUS0NQpx0acQsDzzn2jUrno8jRKKU47NBk9p7TC?=
 =?us-ascii?Q?wtbXnhQDPE1OJZ8gOX2qPq2WOc00VY/sYJXN3UaG+FFcy9tBtCMQ2PqKIltH?=
 =?us-ascii?Q?Zom528/P1uoJSxPb6bQd7n37NXfdhDUyJMkvoi29Xwgwg+5UX5tAeMoo+BaS?=
 =?us-ascii?Q?mzJygawmGaQia7nqXeiGx6l55ZuqpYOPeL96P91rrjOHgcYHwKUZcecvktmN?=
 =?us-ascii?Q?+CEEEf23R2w5AdQU+tKYUQbbVHqPD1h863xhEN34i27/LuplS2UYDLVtEsl7?=
 =?us-ascii?Q?/E4COa8WO/To1dP4ZS1T853HYDKBYgV4WYmOa9AwqHpxXQuRNAwpPusMmpJr?=
 =?us-ascii?Q?7rhu/QSWLq/cp968TxeN6rk8hsAKZ3UWgHT8PG/2gTjIClj7z0fYti1Ek1ax?=
 =?us-ascii?Q?p3xnybAKMFIjXGP6rxPOFYbih7Bc3JlNzccG9/7QcrdsJcNUto5FwCICYz9T?=
 =?us-ascii?Q?SLtrGQF+Sj9+gllT7HEF59SWfXXquLJW+zGPcHURFGgeS4HjBUMKAoxwxtnb?=
 =?us-ascii?Q?r9LoZp6XO7kax2UR9gEo1pulnsCJ1TVo7k50+yGCLzTQgSm+U7YoGLls+arc?=
 =?us-ascii?Q?dOO1xcAs1rEp4ypX4Q6coQS6HarcuRFVnT2+TUjSCLFbSD2lKh1OwtEtJAtg?=
 =?us-ascii?Q?lqQAF2NVjUU7mc9FgTlIAKVOipmh7RokL4/Inj0mEn5cMahODDU+VG9FBCfx?=
 =?us-ascii?Q?MLqv1eXObLZvw3g0CcFWEkCBn63NI8KAWmcp6OEun8mJMPBpqGqEe2Nn524F?=
 =?us-ascii?Q?gtD+TbA3R0eNTQCWLFiNGwEHNiUweVyLq1BM0IFamcan9muRq19qHcHS7l0s?=
 =?us-ascii?Q?ofIdGJyWY1u2vtAUkziuiUck7LPaB5ylnnv8+W7V0OosxenGuW6zf7SfHw0+?=
 =?us-ascii?Q?bTtgpYkqxwkBgqn5MswgxS57dwmgz83AOphBpNo4ufkY13/j0RaJO3MArmpb?=
 =?us-ascii?Q?2hEGi3jlYoXsdhFz4K6NkHFUbIOKctqL6IKt85LWK2hkcLxsxZnapDKs2rL4?=
 =?us-ascii?Q?rezqUkyLis0OoigTMQ8xVlDBPBpVSWtcuqykALcykEN9DcPFd0Ore7stkEaY?=
 =?us-ascii?Q?a9UC30HgjzS8uDjLLjZuGbpk0amTEcNmzyVShyB5+Fx5Mz4p6RXkjTQEohc4?=
 =?us-ascii?Q?ZPb1/ptsDjd0NWxQp7R2owcBo61EFgmiC1YCJk1Cb6/0pi4O7GcIyPEmvnit?=
 =?us-ascii?Q?0a1CX3UIo551+HToUjbnXFes+LS+ZDZN6yExSH7NLkuQxuyAQX/4BxrqyKS3?=
 =?us-ascii?Q?+BRGG7+QP/ddKDZYLDcZIGU87osk2Jdd0zdOGAauLiwswimBxCM9KeROsJtx?=
 =?us-ascii?Q?ECbZmk2zPxLFauWbTgPoKr9LQJ1a4bJW8lIsaFT1H9bmdN4miQxIV09/3mxv?=
 =?us-ascii?Q?h3pOav1uRjunP0aEiAhP1fsQQ76g3GiasxrxQlr1Q6kcg/lLdYrXEipvsLQC?=
 =?us-ascii?Q?+LDUIU5bbnUioU9t94yMFFEvGkyL6nWTsEky5cgtcSFolNnGUtO09/Wdj1St?=
 =?us-ascii?Q?LfslSsPZvJ26gtsqvHw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fa377d-9ea1-4be4-ec38-08dabe66c066
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 13:16:15.1508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wK6oYOrnByYHyP1O7ssAFvsNEDlCC7U1RxAutGccpxIaWwz855V5/J95g2Xazj7R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 11:22:51AM +0800, liulongfang wrote:
> On 2022/11/4 4:21, Alex Williamson wrote:
> > [Cc +kvm list]
> > 
> > On Wed, 19 Oct 2022 16:10:32 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> > 
> >> There are multiple devices, software and operational steps involved
> >> in the process of live migration. An error occurred on any node may
> >> cause the live migration operation to fail.
> >> This complex process makes it very difficult to locate and analyze
> >> the cause when the function fails.
> >>
> >> In order to quickly locate the cause of the problem when the
> >> live migration fails, I added a set of debugfs to the accelerator
> >> live migration driver.
> >>
> >>  +-----------------------------------+
> >>  |                                   |
> >>  |                QEMU               |
> >>  |                                   |
> >>  +---+--^--------------------+--^----+
> >>      |  |                    |  |
> >>      |  |                    |  |
> >>  +---v--+----+           +---v--+----+
> >>  |           |           |           |
> >>  |   src VF  |           |  dest VF  |
> >>  |           |           |           |
> >>  +---+--^----+           +---+--^----+
> >>      |  |                    |  |
> >>      |  |                    |  |
> >>  +---v--+----+           +---v--+----+
> >>  |  Debugfs  |           |  Debugfs  |
> >>  +-----+-----+           +-----+-----+
> >>  |state|debug|           |state|debug|
> >>  +-----+-----+           +-----+-----+
> >>
> >> This set of debugfs will create two files for each VF device:
> >> a state file and a debug file.
> >>
> >> The migration status of the current VF device can be obtained by
> >> reading the status file.
> >>
> >> The live migration function of the current device can be tested by
> >> operating the debug file, and the functional status of the equipment
> >> and software at each stage can be tested step by step without
> >> performing the complete live migration function. And after the live
> >> migration is performed, the migration device data of the live migration
> >> can be obtained through the debug file.
> > 
> > This is proposed as an hisi_vfio_acc specific debugfs interface, but
> > common code could certainly implement much of this as well.  Should we
> > have generic support for debugfs?
> > 
> 
> OK, I'd love to extend this part of the debugfs functionality into the
> vfio framework and make it a common debugfs functionality for all
> device drivers that use live migration.

Yeah, it is an interesting idea for sure

Jason
