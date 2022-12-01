Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0C63E652
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiLAARW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiLAAQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:16:59 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2075.outbound.protection.outlook.com [40.107.102.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C289077B
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 16:13:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ycm6/39+BTTBnfdVzwF7Pc00wXiZvwDTXcCzW1/kSbgTUBGbc9IsDTwqpLfHf3zHrs5cO4ySM//nIhLqJcY0ncHy5CbGDlMvQ1wR+R7kpNXjKkiK42N1IiSBWzFyzKjnKqOyLg07bwgLKcu3qBmiqTVFB0MVgDRn1cwtPnw+bnMZT5db0YgFv4xLTxzNnUpbxMdG2OWSMD0Yz1POXwEpJVfpOaDfnLEHNqheTHi6foYKDz1ujkeRvLlJhczQwAZ+lYWjShxlgwAGL6y4S/2ujGN8I5QKTR1Vw0J+n8HuhHh2xPkDZYDyBGrANYtsympFDeoqw+uKlfx+2H/StJzuPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9/nU835VsAK1d8gMuyVEaHjBoO6A8Epqv/2xGYZaHg=;
 b=kAN/kFB6XkX7TgTwM6VxRfPZIXjfr6EG64zdPSWuGy2njQj2poRaun+AFoHbTUhkx5zJb/Yj/cYedSjgAl62UrJp9I3qbDfOSlX6C2d5wQCBVQtZ0TLGFE/vPAU/45g5qdV00GFkwGYuJ/D+LP/CuLB4xbhum7ke1V7KEErLDXjNAkiRB4/yz995qZNOGOhHy3OV+LP+Y/XD41kFEc7Eg8waQUgeKtfEpGbIVgJ2N82N/c5GMbnp9x/1hPXltllWvjQNLRBZZNLTB0/aH6IT20xJF1s9AZ4ThD9+VX7tCCvEpCFtK/6v7iDqMrHz9YYcBcP/3lXyzjKPm1/MeLr9sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9/nU835VsAK1d8gMuyVEaHjBoO6A8Epqv/2xGYZaHg=;
 b=mzmG64HvWJSftWmL9dfNttF604V49l+jm6uPFEAO4vMRIqWblLFp3W86hImoRxezp5QvP8wHbOIS/JY/XHpaCSyNZtX+Di1PMWfZHP150gglYuqUZWWbGjCneCux1+xfyS+nxCebV6zvMRq1C9Dz7Q1zyQu8ySwO/k5eo6DkA7unYsIx4AUk7ipXt/v9aGWvmUlTabf8d1FJjCZQskc4Ihd5ouobNrErxRNPm9c6HrvtaGpQnWL9G1dUR03RrvNU4vZUxms7nJqT6lG7/4h4RPRo3/30CCg9UAvL+oO/ZX/t9FaP2PH7vQsJe7jw2It1KkWadMB5t0feQaiJQ9p+hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6913.namprd12.prod.outlook.com (2603:10b6:510:1ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 00:13:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 00:13:48 +0000
Date:   Wed, 30 Nov 2022 20:13:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 19/19] iommufd: Add a selftest
Message-ID: <Y4fxu7qUQR2YgHZR@nvidia.com>
References: <19-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <48c89797-600b-48db-8df4-fc6674561417@intel.com>
 <Y4dfxp19/OVreNoU@nvidia.com>
 <00d43a82-3262-5248-a066-e71c608be0a9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00d43a82-3262-5248-a066-e71c608be0a9@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0013.prod.exchangelabs.com
 (2603:10b6:207:18::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a7b2480-3668-487d-17ec-08dad330eb2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXd8rwgUJLyWDZb6WG/mpgdpW42RdfgEXdf7MRdudEyAIx+pF7ExC/QzYeFpOr+DWC0XLrlNiQW8ArnXa+RSOc8HHpfvrTF596ZxFnr1/SbpBjZH34ZT9wJH0UnUmD5e9KrhR33sQl1ZU/kqQ/2qzp6X+8poCtRUd11N2bSpJ1wOaIvfFO9UjuhhOGbVcUDAf+C4i375euiwAHpDEg4n0uWLkTg0nHSrTULe881A4w4cvOFeGs7HrPUkYxUcnmtU/oUyjmLoPhfvIwv+vqh8Knye1VqMIOkzCzYa9nAy1FVGNWwHKp5D1sB5HvzpZZqXhisjtEXU/IBut6FefUL//AxLIZ7HFXooxjeuNU0JiOj3v5UZJl0rNqsxwd6q1Uj23Z5Kzikdfzx60sllaZBH0dTQxtmgMpPovFWLWxL/z5LHqht9rYpSKLguKy7osEGozHU2sYZMm8YxIglvv5+uY9tbSHnttJaJKCCm65caMUz8tWI+FnDOHIiEe8k/u20W3zoZ/2LjOkGHU+ut0Jo4fhb9U4JpIWzUH7CW+zme5htLTaYNHT5VAo5cK46vOoIL87BiCS72RukzTvQqbRj3Vt2KCXD3HiCw89+7EhJy7/+Ok1xq4s46WI2XDlsmuDjlg75b4os4quHBhWgypinQjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199015)(6486002)(53546011)(478600001)(186003)(2616005)(36756003)(83380400001)(38100700002)(6512007)(6506007)(8936002)(5660300002)(26005)(7416002)(2906002)(316002)(6916009)(66556008)(66946007)(41300700001)(8676002)(54906003)(86362001)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QL0XszvOt5bu+1cBBvL8YeHk9+yoQ2L990QX/rPbzbSjKi3WU0o/gKY19Vuj?=
 =?us-ascii?Q?OY9E3eM6t/g7wKko5v27aGdaARYYPGypR6RQHRupPYqNO3b7XVkA4EIsegN3?=
 =?us-ascii?Q?3+jgVloHzFrcLbroPEKQHkoWTh3XEqklDXpC+jI19r+y9u9NCeCmzHJXwoP+?=
 =?us-ascii?Q?L/ogBrreJv+QVLzxxCnon7Ucp6aY1wpkmOTrS0mWadpPr5cF0ZZmD6DLYtfa?=
 =?us-ascii?Q?yNhGr+3vA3WnAb3V7JaLmB6t8aMMphB0aG5nx947JVN+Go/gY/vzoKTdwlqf?=
 =?us-ascii?Q?mUM0lMraPgZ3345OxZmkkuR55+5WVeEXB/XfrQG1kaY8hPLsM+RALX/r5ii/?=
 =?us-ascii?Q?rsw5cqwo+m0kvm8QxgAXKYaC9yRpOsgniZSPDwwpze+PxVSCr+DiVu/2h2mQ?=
 =?us-ascii?Q?2m9ojM8ciE/bSgYxWO3uc92jv5BPXRMWDXxEQpmfbg0/5asHUfLiLW/OuWaU?=
 =?us-ascii?Q?H08QLI2BqJbdwhwvRapYb4q3Gf5PTRfxyOGzsT9klsByBsgoen26DWh+axG1?=
 =?us-ascii?Q?Lb5gNmRBQrrTrvPCAEHl+jyZDcoFZADMhW5A9aVvIra4pHx4L9q7Uvnam1zr?=
 =?us-ascii?Q?YBwAcPUNwRXo+19EHcNRycXTdCYq7t+aCjhzBUmiL6Y+18gADGBN2F9vIles?=
 =?us-ascii?Q?OB4UyCm+0AYoH/dqPkx1+dLlLDv26GjJ1bIz8uujdMq1ZOkbEzhvWloEmUZi?=
 =?us-ascii?Q?1Ak8rkglm5PzQJgrqfSDxW9PjezjDdAu941ftpfNi0DhmeBAftZXeZ07Kgk5?=
 =?us-ascii?Q?wcpqDNTveLODWUNdzzdbozGSA0bNeFOxtWiaNko5LE94c9RqS4TMS8vW6eky?=
 =?us-ascii?Q?zy4IKfS4IDBvNp35abWtUBKTQPtYjbPenGZ0ZUqr4ZCMb60H0ULH103p8oJg?=
 =?us-ascii?Q?yXDv2DTsi42tVm1GIKIqQ9CDPH8SpYVlsPEKZHqIRCDFiMguUysrGbhy3yW3?=
 =?us-ascii?Q?/mueJidSy+oQlcxLckErbQvJ8g9aVdI3DcVqVF/lPHR0prUqB7xaRCJdEcxS?=
 =?us-ascii?Q?LeNGcxr18ouZCpvS+jSGAX5ayclOC5Eb07OOUkb/7U5CfOl/0Vg23KlsatGn?=
 =?us-ascii?Q?yDSd3fEjCsiNFLtf2hOSC5q5lLLYOE7P8qJHj6TRL/6g2ZCquRwRYET7c3OT?=
 =?us-ascii?Q?T0YN+iW1cv4hO/g1CVrgf8tZhI0HsvAMN8TW5NjYHYFaUj9RpZp5mY+YiLL+?=
 =?us-ascii?Q?6lK5BYPK1vadYTU7CMsdSQD3gtm6r0pquW/VU6PMMgkW4xBxOhevKSosZvlS?=
 =?us-ascii?Q?qGcvCz2UaAJMBgxEThjqFiT+ZBPqxXSU5YQm0HM58pMQQAJBQO2QIs5PyihG?=
 =?us-ascii?Q?ZcasKMciEJlkCi0ky3i0V2erjGmLzJGCNFBOwongCVu37vsxmUUHDf1yrpL8?=
 =?us-ascii?Q?wH+Mj1vM0plUPk4dtTs/KdieVhoF5ApMHRfCLI6ytPcrXmg8XjNE4OpOgwvo?=
 =?us-ascii?Q?mK/qLh+eSe6tHSZLV2nE4IgsK4VFijocSWrUwz0ns/4HtYhywCkOAxzqh5kK?=
 =?us-ascii?Q?11l0BNtPaBizsV9saI8rOM2lfG5cKc94pLJToJxMecQczYSxLwPBR/og+FVE?=
 =?us-ascii?Q?5eZjdUDNGktbMqmdLbo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7b2480-3668-487d-17ec-08dad330eb2b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 00:13:48.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJqHLiMU+nlahKTBPNhz5SxLsfTHAEA3KqDdFBTQ+MEbL11I6ktQVyuU9bPTqghw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6913
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 30, 2022 at 06:18:34PM +0100, Eric Auger wrote:
> Hi Jason,
> 
> On 11/30/22 14:51, Jason Gunthorpe wrote:
> > On Wed, Nov 30, 2022 at 03:14:32PM +0800, Yi Liu wrote:
> >> On 2022/11/30 04:29, Jason Gunthorpe wrote:
> >>> Cover the essential functionality of the iommufd with a directed test from
> >>> userspace. This aims to achieve reasonable functional coverage using the
> >>> in-kernel self test framework.
> >>>
> >>> A second test does a failure injection sweep of the success paths to study
> >>> error unwind behaviors.
> >>>
> >>> This allows achieving high coverage of the corner cases in pages.c.
> >>>
> >>> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> >>> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com> # s390
> >>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> >>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> >> with sudo echo 4 > /proc/sys/vm/nr_hugepages
> >>
> >> Both "sudo ./iommufd" and "sudo ./iommufd_fail_nth" works on my
> >> side.
> > It is interesting that you need that, my VM doesn't, I wonder what the
> > difference is
> 
> That's the same on my end, I need at least 2 hugepages to get all tests
> passing.
> Otherwise
> # FAILED: 113 / 121 tests passed.
> # Totals: pass:113 fail:8 xfail:0 xpass:0 skip:0 error:0
> 
> I think you should add this in the commit msg + also the fact that
> CONFIG_IOMMUFD_TEST is required

Done, thanks

Jason
