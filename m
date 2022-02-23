Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AD64C066D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 01:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiBWAxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 19:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiBWAxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 19:53:20 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7F539B8C;
        Tue, 22 Feb 2022 16:52:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEmpafbQsQyG75f3YxO738k+3/JUu7Osk5x3ppjsiqBUjTcKKtQSFOsc9t4zhxXQPTqegYPrJMTMk7t3XRFY048k7VmWRBCBg9GIjgyfXi8VlQx+UudRU8pds5xiuu4R/y2/r8F5RD0aeBoKODlxRWAqrPDq6OBb64YGhFumZWKTi5Ngo7+GyzkgOs+z3l17QoAuDGVEH8K8xcLfuduHseo9ynvmm1yy+WkFXGz6C4ZhuqBNRsjBUrnEIa0PycTMhki53mVRtzxwtmZbeK5BP+ueW6XcM8vPYcrfK11TadSYXw66iwxa3/rfwjoZeEmz7g+F/bPeZdYe/s+EMvOYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEKJAjJh/wK179OyqWKlVHdQAFxlKN2obvmi4jv/304=;
 b=WcKRPOx9gxjEcbn12d98zPTGmjxnStvL7fvg8YAE3GrfrHCjoNFl0ST5y30jJDL8hPp6TRZcSWtNXYvxwkwemrQ+LIKK3zN7dt+zHlW5V7Hr8/bjvnNPYsGfenvVeKxKXWfG1cd/VvR7y5iwBhOF+aTBSr1U8TsZzRD099cHkoDTFvYFM9RR89ISL5TSgrA3RaEFMnaZ09AZpFfMYPKejQXtVU/gTFAytKcM//JPh4CZyaYF+IbEp/yf5SMd53JvsRIBIF8xXto4fifzS1LXWacnNx71cxvQvRbXaTWismBSlcL0EKIYOR94CHOAEQHkLo8sg2vMFl/ECejzSgT+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEKJAjJh/wK179OyqWKlVHdQAFxlKN2obvmi4jv/304=;
 b=rRgMGzMoiCppRa/6liwCxe/8zB44ySi+aXOCKfRJpgCERt696nL12wSvW9Vylw82V2XOpi7tnAvHz70jGIfjU/GJt2KsO4Jlhcv8YA+S4M4t7VlMw6ILyRbtU18o5/tCqpqIjgx3xUqY2QA9jUA++vRT1tL8Bkt8hqi4u6zbXUtuUC7rn6/NgoNxWxYWRl1Vtr6chVAntQ2q5w0qdde3H4OUoA+oFXEDumn8KbscFerVRIzckYNdRKjuRcv5c7cee6UmC8TSFaxq3WP0o85lCjXDUQ69snrr/tZAmYSz5ASNgL3OsesVUa7Rn5OEBs0Mto9sxWsFvD1ZRBqoMJ1EtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1127.namprd12.prod.outlook.com (2603:10b6:903:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 00:52:52 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 00:52:52 +0000
Date:   Tue, 22 Feb 2022 20:52:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com
Subject: Re: [PATCH v5 7/8] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220223005251.GJ10061@nvidia.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
 <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221114043.2030-8-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: BL0PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:91::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9aa95ec0-3186-44ee-d007-08d9f666d243
X-MS-TrafficTypeDiagnostic: CY4PR12MB1127:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1127B95E1BC354A1AF7CCF67C23C9@CY4PR12MB1127.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZMA3RmvD5MI7kEh04sge22OIisSegC51cVjjA3k3VvEZ8x6LIoss7sGQicvrK4sC/aLn6/fZyN3O5FoB0neAR54az+A6wz4MIBXGZPZB/A26tPCFpFZTitK7ylppZBqT94EhcuZa1n3yCNwKIWkTgINRfso8uXZksyacyLt0zU1FqMxwtWJUxKQLQVWT1IkzpstqJ23tojn2A/8BVTllSiue4Ks4L0LNwHEENPXAXc1Mn9vOrfbJviUgpPpdjme5NG7kwAxJDeXztBgWCr5W3+BTkhWYKpD7QX8hvStbG5iSDkOGDNicmvEaDGxTuVAkJNtkmLsoMM8pvKYi3VJ0UPnaV70moUGpzg6hJCp7a5x8MooJZX4bq7dkq2pvzxe4JSiHM4rVuu7ZsgeZ18ek8sjJw4rXi8/ZsUvNcBpBGCb10eraNjoChj1SLqNqgMn1dRDUwXyDdLTYuKR1i8u2ySAIboDV9d0vtBupT3Y9dE1uaaNE9KG8rU+e/JapdJWAqlFf9vvsr72aG0+SbOJnIvY4NCtfLE/Dz0k4KPMShVbWFg0lcKYIh+GzkRdAPkUSKHv1lVMj5w6dJLLAVzqUbdYXqTlHqPzR65B13zBG/4JS/UjHQ68qwQftUY1sO/s/jvPyP1mj4FXq2YXYiGq9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(83380400001)(2906002)(7416002)(6506007)(8936002)(5660300002)(4744005)(186003)(26005)(8676002)(6486002)(2616005)(316002)(4326008)(66946007)(66476007)(66556008)(1076003)(33656002)(38100700002)(6512007)(86362001)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SqOf4oaCYwfA4dFX9m3pmCy1R1G/OZEp/Fnx0fXWrLCIvajjnGdUEYqF5jRy?=
 =?us-ascii?Q?5hglWYM1h30e4jzR+wXepa8FQvVJKj4t77E6xLI11ML7a4fFo9N1RAZkbn3H?=
 =?us-ascii?Q?KcpnnCVEeEOpmrUxnaW6Rxi3dF//2o+7OgEnP9JUQP8qF2OljHEOa6Irq6Oi?=
 =?us-ascii?Q?DG3B6T0Eb59v6IerRKISpitf7Wrpa7jumt7aDrSd5nP2QlFqORS/GppwJhY0?=
 =?us-ascii?Q?a915TheP3y/OycyHzOFJX58hdSrj7sCWsTUNPyBGS5wMatWFYkK/jveTar1u?=
 =?us-ascii?Q?od1nsA9b9G1IA1To5l+OBP/HOTgFdS9jY8soRaRM7cvpUCkWyXmCCInBB7Y/?=
 =?us-ascii?Q?crEifzo9fidRU3iR7zJi8/cXsHm+xa3ytmq7GmjwZGDz5llYoQHvaMFPvsg/?=
 =?us-ascii?Q?uRxVvjhJ9pu/bU9Y+kcYBiP52AknaXTNZlS92d3lqpf6w/NfrgpN1G/I5XTa?=
 =?us-ascii?Q?L975b/mgez9Ya+KX/bfQ2OP5AGT7Uf/zgQTR/Zi0KBDKM6P5cnFO4Ez8sEDI?=
 =?us-ascii?Q?TAPdDrAR9YhqdvQcsuWmo9aPBErXHjtelz+exaq3adbHzCffI18hChSftEt7?=
 =?us-ascii?Q?FzdwVVukNoCiVgA4M7p21C/kQb3IzVDcBV/OiArYbzefU9JieakbRP2QD+b3?=
 =?us-ascii?Q?r+5CMMD6XJORoHKx/zBrl8Oh5YBvjSZquXGyFC/mTWuRW/nF/wO9ca40MVkm?=
 =?us-ascii?Q?d7EyBrjgj0bAU6KfeLHbCKCpN95V9h5FaXgLWcu3OAtafzwgLFu7CuZRrJuH?=
 =?us-ascii?Q?l6UvFLOYW9/Axv6g52M7AVnoZ7R48feDXETPjcJIyXCFWIpLRJYOfkf49PwR?=
 =?us-ascii?Q?urXKyBqSIRiF6idyQ2/j0psxaUw99R6/QYzhMxsASH2x3Orom8DJsrwq+hq7?=
 =?us-ascii?Q?oEqxn1hrY4CFE8kt+Yas9kMvst4zddWZc31X6UFmI0h49zV6lvKyjLg5q4PB?=
 =?us-ascii?Q?eS3JF4KWSHxmCfP10IOm7QhDpTiseIXL4Rq+MSrqAz3CU8b+TtZ/EGKq5rtz?=
 =?us-ascii?Q?CjuPaK3t7HQd6w97F+oLJJx3YGtj/DLpr1j9d+hGeSw0+FECPLCag8DzGSNd?=
 =?us-ascii?Q?i8WIgWbiW3O/lOS4f/v+Kir3UQiD9via3c3HWikl8Xq34pZ9LIb96FakCGSA?=
 =?us-ascii?Q?1xrWWA/Jocanm2oAyLldVwzvDfUeVdb9c4tFyjMD/+vKo/yjdvgOzcPIIwhQ?=
 =?us-ascii?Q?LWiHNl6kYtcmdRvzwH5qd+xVsh1mukaj849ExCE646fYP2snKA6PB7JRrO8U?=
 =?us-ascii?Q?0VG86zVVJVKIfbK0+jP7obCZp7tGPwhm3/VDP4xaZN/J8VGK/1Uk0w/XExmK?=
 =?us-ascii?Q?Poo7pcYlSJWPB+GsHlw+0me+vs8I70k7UUY2h8gnaA+mi1MoUSUR++yqe37q?=
 =?us-ascii?Q?tqwTzX/gQdtAimaOS7QWK4Er66yrw6MR8BdPiBmBBCK5ZTr1Z9cK4YAOajny?=
 =?us-ascii?Q?0SQJrJOEPyb9+Y2XoxCA0d4Af7vZEUvQ60NKyD5jXEtyeyOobrueA7rkrMMR?=
 =?us-ascii?Q?Zqmv2mmm0OXSXbuSvodTnR5gHawSlaSe0tlo690pkR5d2F1A7Sw4f6sY+N+f?=
 =?us-ascii?Q?G1RVC3/5T/z5VtS9Jtg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa95ec0-3186-44ee-d007-08d9f666d243
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 00:52:52.5954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qd1sIW2H29XgYbultJzM0ZwxmbwJ2IBTN7PBF7ba4fK5b06ApIoZiGqxKWgu9I8k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022 at 11:40:42AM +0000, Shameer Kolothum wrote:

> +	/*
> +	 * ACC VF dev BAR2 region consists of both functional register space
> +	 * and migration control register space. For migration to work, we
> +	 * need access to both. Hence, we map the entire BAR2 region here.
> +	 * But from a security point of view, we restrict access to the
> +	 * migration control space from Guest(Please see mmap/ioctl/read/write
> +	 * override functions).
> +	 *
> +	 * Also the HiSilicon ACC VF devices supported by this driver on
> +	 * HiSilicon hardware platforms are integrated end point devices
> +	 * and has no capability to perform PCIe P2P.

If that is the case why not implement the RUNNING_P2P as well as a
NOP?

Alex expressed concerned about proliferation of non-P2P devices as it
complicates qemu to support mixes

Jason
