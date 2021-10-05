Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6961B422B6A
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 16:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235519AbhJEOru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 10:47:50 -0400
Received: from mail-co1nam11on2059.outbound.protection.outlook.com ([40.107.220.59]:39840
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234899AbhJEOrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 10:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/JXHFVTd1RWV9xKE6HnngT4U/gPpkEA/+x5RYuBUk1mwpW5nEdPje49ZLmgfQxEqv04qnOnD1d5ImCXytixAwXQ+S200sj/KebxyrPhOj/pSqNEm56JJvuMecaM2xx3P684SiYCPIhd6rTjTHyeYPbYNQjEuRGJnGtKVHxsDHL8W8KagqaoK4frYUmd/hA7iyiGwBFdmbX7hVRUOIJb0z1is6y/2EaUUd2Yl2/kPWDRoL9/rVveugyER1mDbDc2VDgzZ3xuFD1qvbxlrYMwXMkhGwtM7SFWTQkw6hgpsmkKCY8XEKcSXJwewPTU65+KU84hNpObb9Gh961mNhHjLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uApgwbzGkeGMipyOUf8ZGSIMsyzWGVZNk48wsx0lI5g=;
 b=COP0M1698kTV5wh4onklmgJV7vx9rrzZynT0lrBJp+OpVyKTBmgy1HakXZoxaJaVK0Ibc0Mu+BTlR6ZGJEqW2YnBQ4aX/fVeiTJGXUlppHpfZryK0Xz5b699Bg2HRhwl19mR25Zn7+SsflD8b1mO+wx1uc+8Tt4FOATyyXou1xE0YjdhZw+q2aOpIjppmgYwIkdrtLGWruXhg9rNkYHbD5t8qkQHYsBk6MNS8Gwu4Sm3+TlQE5LbAC/HsvRW9SdhFTzPMu/rSYhRRlxnnWBUb3trLU0he0iIdt8YwPzgHwFLga8S3VSKCQycBs46ovLcOY9W8tgABTxgyH088QGVHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uApgwbzGkeGMipyOUf8ZGSIMsyzWGVZNk48wsx0lI5g=;
 b=p1H84D+Wvv31Ea10PJeNpIKxpzQ/hx1b7KsACeJtamxRM6P+HbXYITx5pCkOOedWXkt/7WEKkDv9OJpztOSGALFZvhsJ+mp9XzzULl1nUM/gOFK0gyddH+nyojzPQaNFNdjzxgJ6rWRIUxVCb2LFTR9boVv3IPVjdLeEBWXdA2e4rySNZwFB7ePbOZ4MCEoZMi+ShAWQ2uJt1XFB7e0K0k9btQdNlyHl5CM+GbsmO1V3SyQ63fY0kWBpcelyEyXtuUCIsNhPE5pPJpBQNbAIT8qssMRj4yKpJghCEBh76/4CKHV2ahy9SJIqVZHKb8e95/z+iDmR/1G7WXXQDCJIGQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5378.namprd12.prod.outlook.com (2603:10b6:208:31d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 14:45:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%7]) with mapi id 15.20.4587.018; Tue, 5 Oct 2021
 14:45:58 +0000
Date:   Tue, 5 Oct 2021 11:45:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211005144557.GS964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <3-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <20211004162543.0fff3a96.alex.williamson@redhat.com>
 <20211004223641.GO964074@nvidia.com>
 <20211004220154.519181c6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004220154.519181c6.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:208:234::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0051.namprd16.prod.outlook.com (2603:10b6:208:234::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Tue, 5 Oct 2021 14:45:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXlhd-00B7MB-79; Tue, 05 Oct 2021 11:45:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fee90b02-ba7d-4f2e-6318-08d9880ed7ca
X-MS-TrafficTypeDiagnostic: BL1PR12MB5378:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53785215F6C6C9C08478AE14C2AF9@BL1PR12MB5378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxsiyiZsyrZp0NolL6p/blvCvvIhZdekJcIjlvBahaUA7Y62ADndNXsRsAxySOm5JYaZrdW9D/zfed2LHmLnvuf9hTqUZMQuDGFpNqAo5bium/ofcYrH7ji2kMAabK9ucopsyzr1Cn2LlcTJZpUycKZBEV+G7F4BzK43KuOLps5mbZhz5MEMV6oJhmwk/4MtsngcXoksJft5Z44pph4y7Q9qoGhO8ANLBUDty3bbBxNKAQNMdWUFEi9op5AoFHLwvdmNUYDdkt7Ndc298hmaC9RdsbcuWIAVdH4MgZYGaeln+oCghs8X9oEiwKvk27J/VEt6oUpO893vEo3IPtGjBoIvNB3fVxMSrklJe2KCGJ4EZNFw07IQw2R3keLFA37wSi9HfhirdOxzmQtVYaOORPrgC2WYIkRq+0FbVbVGegI+5HG5SibDJsTbyfW9GjoKM7Onbh46i68g+zMGi0A4XypqoL2Xj/gTGC2Ba7V2596lAlTuxn5Nk3JHEB0S+LkH7QDVbcIMRuZU4W/Y5+ogFrzeeTZhrselZV4aD1WbCTZs0uJnepCmav+aVC79O8GdonWBPcdnapO21Vuz9DeWQYvLh69XAg/sjy/h3yRf8lCq6CWBFZQo95mCCy0TX+d/C9Lx12BMCgRpVcndAG8AvpcmHHmliFpkrabzi+fnjeUZqJuq/wVq9Fvbwt/bb5aW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(9746002)(9786002)(38100700002)(4326008)(8936002)(4744005)(54906003)(5660300002)(316002)(1076003)(26005)(33656002)(66476007)(66556008)(2906002)(2616005)(86362001)(36756003)(186003)(508600001)(426003)(6916009)(66946007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yyGH+RxHidR3JiFtq0YfX/Gtzi0fI8ZrU8tLr0mJKtyR/zo9DCC88GP6z0e4?=
 =?us-ascii?Q?fMI0RvhdWllkHDD0lBt8rqXj2VfgtaRHcwM6URB9Bue3irrRSyH+i7n1eZHx?=
 =?us-ascii?Q?qYZVN+7Wr6yrZJj7OYhjaj5rUh+sO9pLry4NTZgJIK7b0I/3XpckgGqj4KHo?=
 =?us-ascii?Q?7RJ3DLnsthrYQsNFWmATsZEiqr/jevUiejQpVyYYtwd4KczRol9EFdYBT2j7?=
 =?us-ascii?Q?xfr9nSnI/luz5o4vhwEVXL/JTH71FIH+SutcXMLBdoF9i22FzL0GQszW+mtw?=
 =?us-ascii?Q?PfXnraKe43TLoJ9NHPcjopip5PSlXjkeCVMaiQNXBHskcFoRZtmoMO03A2wP?=
 =?us-ascii?Q?OYHs+7XhT+5kqG6FELroH3jJ2mHXBo9G2y3c+ZW9346j2f7TbxGT/Mln2DjY?=
 =?us-ascii?Q?uFBTpgPaWu5UC35dGz55X6nWCwdFcmFDVLO7YDVguXMIMKUHMm+UjL70iJpk?=
 =?us-ascii?Q?fNTfUBGSE20VdOu7l061gkTSECEP+NfKspBxxD+0U2Z6J2HxHcumS+H7XrxO?=
 =?us-ascii?Q?TLTyUmrg5UWnmviPjeA9iQVTcZCqNpDQTYbHHzCAaaN75r/RM2AfPa3E1Dsb?=
 =?us-ascii?Q?uCiNUtU4WOK21Bmi6C0dT5BX4B1SQaly+bm7n45iuPXJ6wiWrV9/s/PT+XN5?=
 =?us-ascii?Q?11xDHsHSl6CGbR5vGcg5kC/QSVvZ8beRHhoY58vg49ZjPZzINJUl1dtUTfHP?=
 =?us-ascii?Q?qOgZiFbWuy5q0ACrz3iHmDUKXli+jE8aAb2pFapO9XfQGdoTJfC+xUAxLQPn?=
 =?us-ascii?Q?Mhdx3VTKWLKnIFrVgj05Naf5w2kexphtSJf3jbcYhyhCJu5JxnTlS7YPRxsy?=
 =?us-ascii?Q?RNsrx0t4iPj026Z2X2iPCEpwpatmrg1OrEOsnVc3NMWj5Z3I+q/FjpCft6or?=
 =?us-ascii?Q?Z+mm+fIYg2QiquXGFpS7LX1dp8O8pylcZGVxQZLQ3sOt1PPQNAYlQTot5UrK?=
 =?us-ascii?Q?gkgn5R/admjTrb4USTd9zLFbnmZQsCCG/zMc4KYrqUuXUakixWJ5GFCzAhsP?=
 =?us-ascii?Q?KN8hQg8hzAgdPlUDXYYZKCZtvPTbxr1+JwBDARwTaQ8i090/KJXITyS7QH5u?=
 =?us-ascii?Q?dVqy6SyuMEhv9agIr/Ks2Twf4B2EUqqpit0nVg8n9DX3S/+IK7iLBc6cP5D6?=
 =?us-ascii?Q?U34+jz3D7mDhQR8QkKBd8sz4zkzKywOdUFBHj14d60OR1iOwVLpGaeloErYl?=
 =?us-ascii?Q?u+GydvZ7tH3G6fdUxH/Sq7vFj+ItT8EgYEmCQPeS2G7rOY5gZkzscvLNeX8W?=
 =?us-ascii?Q?WDl44SR8N6QmiqSIjO8j0EOFATpHrkr2AMxq7J+Z/W/8eBb86dXYoI+jxmDx?=
 =?us-ascii?Q?uh7fFpNzOVePGOQ9z7cialSS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee90b02-ba7d-4f2e-6318-08d9880ed7ca
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 14:45:58.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mVdkYb7fuzn8RCujv3ac6T1iug1fYyosIc1SMlkiRmqcFkm4b8ypGZsNFCCsPv+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5378
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 10:01:54PM -0600, Alex Williamson wrote:

> Note that this is the common exit path until the last patch in the
> series pulls returning the successfully created/found group above the
> error condition exit paths.  As it stands, this patch unconditionally
> releases the reference it claims to newly create.  Thanks,

Oh, I see, you are pointing at the missing return.. Yes I got that too
when I fixed the rest of it

Jason
