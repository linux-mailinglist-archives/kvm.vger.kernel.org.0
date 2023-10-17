Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D897CCB1A
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 20:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbjJQSth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234963AbjJQStf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 14:49:35 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2069.outbound.protection.outlook.com [40.107.96.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C336C92
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 11:49:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jga116DaliC+5fjijIu3CicUFISOv1tSn+Mbco0rIOozRfBGWfJU70HTlWP6jlwSYw5Fz83HVqRcETa7sOMeKRKir1mboMY3dcnrXriIT8EhsZCIY7DjUm8zqiY9WpB/1Z3OAc3NBztFmdByZ7zv1RjOs6QuZb1ZxeRCLLwZtX+49kaG9F20oyGY8FfMkhmSokhpw6T3GkvlCoN1/GQnlpzuQaC9nv/qSmi5ZhWytwbnGQRbkRvRalubvsL9P61vID+/un1KZHFeViNPtDJyEugQ9r1xoM+HDHuDZVRXh3n1ZvV/1ULGDbF2jAEaiW3nBV2+IsIs+WOSylc1Si1uzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfItZog1CJYZNagcTzJ8LqMVsGO1YZJMD5xR/0N15f4=;
 b=gmVGG6Fl1qbSvZ7SiBEZag6COeEONmE76rcY3WteilzAVgHFFrIYdamZAuhrdmuzo+CJ+AZrlZC62J+MNQuaXZgt+6B0NXn6eH+YoWgku1H5BQ5nY/344FCChbu55GwKP8QICng2axFvHfp3GcPDM7PRffwnE7nk/FITR9hMfvImVNfaJkQpWvb7+8UwAjV3voA3TUPUVrstiICFhGXfUnL1z6kdgYQF4Xz1wz+Xm5uBGNjtq8jzWrGKpuWE6eACjewKm7FWVI8zVeWMSGtP4OY29MSzl95g6qWvsOGNmI9CFPWv+vzJH0qr7npG5KzNjesHyLtln3sYKruBPsBwQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfItZog1CJYZNagcTzJ8LqMVsGO1YZJMD5xR/0N15f4=;
 b=AsO8JbF+AthCGAz7AZbPzBa+deBkdjNng7pYnGTX4KRian6IhwfOcpqAbi9sABdypxDR/iQgPYAmXsGH9NsVhILxNNZ/XMrr0f2THKlf18LfURZ+fLViWOAITBL0urmHgF2vNpf9I3kRMWUuV7VkFZNnnCEtXhtR/rfudA9im/xyH1nIB71GtHB5ap95JjVQCITToO37XOMpR59N6HurYRYyTbMiFjvSQkyeJIIJupdxB9RhnK0UphYcOR/7Pyaiu4fCFfn7HpRLeX590TFZ8wtAQiljbfWndFyWMvRQWHNXoY/RNG1ZsAXQ/jKLyJx1sS1RQZ19h+DP86oMjnNvdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7094.namprd12.prod.outlook.com (2603:10b6:510:21d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 18:49:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 18:49:30 +0000
Date:   Tue, 17 Oct 2023 15:49:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Message-ID: <20231017184928.GO3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f359ffac-5f8e-4b8c-a624-6aeca4a20b8f@oracle.com>
X-ClientProxiedBy: BN0PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:408:e4::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7094:EE_
X-MS-Office365-Filtering-Correlation-Id: 9611756c-0a64-41e9-690f-08dbcf41cbc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0MnnD7N4EiYgsVFWua3f1slDisqcz5h22y+cen3rQub1wo82WhQd0hP9C4TRHZQX79NzTHYo2Ls5dcDqC0LGr+tTeA6qOyMukm/aGMtbvyrQbIUmacndVIngEGDs76jvTaq+o/BZHGYlOiL1bziNfVdSenZ5FnO/7G+bHKy4a1cjO//Ou675O0Qt5lLl5Arsv4mmoqG5stplIF/fV3sePTRnZP7LwRSDQVuWL1S3a5zltgzfL4SBLDj1p0bal/nbj/IhLhmUOoH3sWIHnHnhJzvdZMsav9lM43F8jD1bLcFcKNVxWNKtxJJnq97FP5/V425/Jtf6IM6voX8+tzqtyc3N/KhZhY3GwdYqHs0oEGJxaeGoUKc0xkazgNiU8/qhX7/ZfnHvkz9OVbsEbZ6dKj6oeuzmb9zF+2pteU7Ge+MKbRjHxBk+IJYGR5gVt5ORbTUuSEkpi/cSAxp/lY2gSwCfYL4zM3beCHbapPFbvIvlABuuWtA9TE4OknPjxJQ8yxOWZSXTElUmFIjUffpljUEUOzEICebROmQkXd2I8iB4wk/ijhmbSBDFRPacDo7PrIk72wnlkWrF0Q2USOt98+jH5O7LwP1cyCub7dNCSjs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(6512007)(36756003)(33656002)(66476007)(66556008)(66946007)(54906003)(6916009)(38100700002)(86362001)(316002)(8936002)(26005)(2616005)(1076003)(6506007)(4744005)(2906002)(8676002)(6486002)(478600001)(4326008)(5660300002)(41300700001)(7416002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1AQAEd6phJtMMMQNmNcw5yYo6NE9XAgKH6OMMxsKwLMv6uPscjlP17/2eq+q?=
 =?us-ascii?Q?wgiqAVNUDSb0+lV02OyIBtcO2qBplbovhdJAIr5tGmNVg9/21bv+9AmoWIgo?=
 =?us-ascii?Q?9AyrT6aHECCbCh9slx1dYh7pgNsMoYPAqa4beaVp3SRFizT/n4bBNG0nXUM+?=
 =?us-ascii?Q?rqCwdChVbxqnl8/htoYgIE3bGItwvDk3s5jq8HFjVJ6fW3fMb/x/JjKy3ULl?=
 =?us-ascii?Q?x2wHidC1AO3WlUHyOpkXdA0lg4O1xUhuAfTx7kzpuyj5SsVuaq1z2lnyfD0o?=
 =?us-ascii?Q?MF1BnZjuPyZnlmwWmT1BGmtlSqT8lKKOiOS1+sBRsL1pmMtg8c+8jCiN3ahU?=
 =?us-ascii?Q?KsPX5CVjprGS/yDib2uEqrqIJCYWvzdQmzw57dg9tX7vRUycgmJzt3TcOc//?=
 =?us-ascii?Q?y8GkZQkTx9kb97ORENhWz/PQicItxAlxoCgimOdGnz/Cqefr7btL9Lawv+en?=
 =?us-ascii?Q?XFxapZNgEpL/ktJw67BzmWf+MSKrSzvRfstkTF8jMMzs1/bluA/v5NlBIoVP?=
 =?us-ascii?Q?3MXjojv7l2f3YwTklfiXtWGNeSQaAgreRrcgv/BtuJ0GE9Aqg0q+iwoVBD4E?=
 =?us-ascii?Q?V99EoJNI2f1ojU4P9MsmnIRBZRwJSV551yJMSWBAwnsrR1ieSb8k5AzdkC9i?=
 =?us-ascii?Q?RIIcGJUm/sgQUdYGfuLZHvHj4j4eVx+csM4K+lc1DtxFpclc1Vfo+87QFEu5?=
 =?us-ascii?Q?zfIUuqZmcsTBJP2NHRtQS3Mw47tCjX4CtvfbtCUbRAMvqw5RvQdvXBTI4g2a?=
 =?us-ascii?Q?pnhoN2waIR6oJWHjqjYuy3TRnWbeaWmvXFgk14luzHnKchhmtdT5ferKsfoN?=
 =?us-ascii?Q?niN+oLBR/7q0J2ol3LUA89puZ7gjqrA/t3qlp/ewzb95N+iJpbHli5iuAfL0?=
 =?us-ascii?Q?b6ex0rPmms/zru1uugCNHwR70Yuw8t8Y0jSaqFoDCmb8CpEW+ZAS545Eymse?=
 =?us-ascii?Q?iF9TLumRsS10AFWrkGFz//St/20ZetA95A8Z9NrnWYflMrTZfAzwrk78DwX3?=
 =?us-ascii?Q?QzFKTidMrzMM8DtiFGxdta+lgjvqYYxHnfNESMelf0n4F+doNF1dLQ204WSs?=
 =?us-ascii?Q?knYRCXJun6+qMWSxHa1phXH26gizbP+AMdBHXYD3o1930vRGK5CnYMfBj/o2?=
 =?us-ascii?Q?IXCbqM5qrEaeuPMRiMt5V4/SbsCRAiAA30Ng8CmiTGsHtcEdtPUvBS0lw0ct?=
 =?us-ascii?Q?ziF7wT+OLdtN6k/Bm+BIo5SornzBJ72Bm+nLX4uWfrM3rCRoG6iJM1spIHLz?=
 =?us-ascii?Q?eXXQoGT899rcCZY4jlzKJY7C33xx12N2IGVoxAFp3Ryg2vOq58XkYgJ9GrEJ?=
 =?us-ascii?Q?WdGD+hu5W1FKNSKsk0FSBIyktg4pzFFwuIdi5jGxkquT9CZWnhlCur87LIDu?=
 =?us-ascii?Q?5SHH30ybZwnl57XfLbGo9br1TKkcUx/97cJx+1G0PtjVOq/LLEmuJlEHu8RI?=
 =?us-ascii?Q?KjBk8U2qn0AfyWkWLip/iYAVMR23tjyM63LXG7qWYg8IlIU4WuKOux+v7UPy?=
 =?us-ascii?Q?+WqrpOg1jZa3+qaRcBkfZiMfKVXTKoWqOeAoqjKqTZ15dBFnml76keLzsBM2?=
 =?us-ascii?Q?/3ZA2UnccOWmKTyZ1306CWi6cBkXdhref5R2Cvy7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9611756c-0a64-41e9-690f-08dbcf41cbc4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 18:49:30.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wnmE7UPx7R0HaEkI0lpp3FeNPcJk6ZbR7KfNdJ7l3r7Txx0QBCg+/fa22dF/4hSd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7094
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 07:32:31PM +0100, Joao Martins wrote:

> Jason, how do we usually handle this cross trees? check_feature() doesn't exist
> in your tree, but it does in Joerg's tree; meanwhile
> check_feature_on_all_iommus() gets renamed to check_feature(). Should I need to
> go with it, do I rebase against linux-next? I have been assuming that your tree
> must compile; or worst-case different maintainer pull each other's trees.

We didn't make any special preparation to speed this, so I would wait
till next cycle to take the AMD patches

Thus we should look at the vt-d patches if this is to go in this
cycle.

> Alternatively: I can check the counter directly to replicate the amd_iommu_efr
> check under the current helper I made (amd_iommu_hd_support) and then change it
> after the fact... That should lead to less dependencies?

Or this

We are fast running out of time though :)

Jason
