Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B669F3A8A5D
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 22:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFOUo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 16:44:26 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:58464
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229965AbhFOUoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 16:44:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZtLWCGLJHdFHLNgEPeTzo0A4oYVT6hlGqXXiAt9yxcGFJ50CPJXcnFaaPd58H1R39uV6wIXRcsIi4TXrOUfYUio2FG+Gwlo3uom4VB5yxthS5YmE6O+3KXvJT3FpuEHf5rjs5YjOUzk5eqYl6jfCxoflegPBHNSztCuEku849xrjPGK/ypDcn/iewlgkcpR24jmK4tGLOiGoOBRg7RWzqkn1qiRWIMGvWyu8o+r0GiiRotGgypjsqGE+IoxXELxgJFQycrE/jDP75oMZZWIDnE6ixuicX5R4Wr9jy46aIXxSUbf4jxge/18M8tn0oRTyANYp/Ga2dWJ03KhhyzlmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZ7q8ovbkGW8vskFpaRtZ7jOqJbxUBOfOjCUN27rkTo=;
 b=NFg0Q3PoH6lnjwqZxIgTKwtXk0p2tD1l/rOaEYV+I25Kele0hmyJ3houFv4V/MdCeoDd3wxXVPKkuuD7lC37PWABhO4YUkDVx1+EXpOG1m8NMZSaY0dInEeeIJaSxwhQSNlx87RxYy0oV40z33dHIv/5VM23smIN3BF3KvtcqYDN41c/CWH70t+L92yA49THcWx2j+s3qDbOJfghpd87kEUJyj5kIy8JGaglmPABYdBaTa5h7zkumpcNefGxPuqijZkWu3UOIKSMfhiurCps9IpUG9oMUssR7zxP1vy4sa2TTg5kcQvwd9ygfFjpSX75TQWBlbQU0pU7B8Ac26de5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZ7q8ovbkGW8vskFpaRtZ7jOqJbxUBOfOjCUN27rkTo=;
 b=Gd573HoNlJn3w4klQbUAAbmwTlj0l3G1cZwUYPD3hEoymr4bKqNdRPM117BANsFldyCKwfTEDSctsNO93NKFGcxGQONz+Vquqg8t289guNBZ/eawB/dQIOTAFJijbeYhrxP12LoXMRa20pj4I9VaYT8fP5kK+zB8XnwQ03ToM2TcbInT4Y+zG4N1kwnhf1jFlfVG+hhqeeANb7Vg1LhGymT2WmzIZApJL4+y0WrzA82puiRa8KtWrQm7nPbjPhlDFuMCLwYOxnlgEXCLeUxM+LTk6d/+d4Wn3REy+OeeA92gLjIZ76lBl4Yok9fyfFEDiELoDnA5Hdk98DGYqZeZFw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5096.namprd12.prod.outlook.com (2603:10b6:208:316::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Tue, 15 Jun
 2021 20:42:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.016; Tue, 15 Jun 2021
 20:42:19 +0000
Date:   Tue, 15 Jun 2021 17:42:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615204216.GY1002214@nvidia.com>
References: <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <20210614124250.0d32537c.alex.williamson@redhat.com>
 <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
 <20210615090029.41849d7a.alex.williamson@redhat.com>
 <20210615150458.GR1002214@nvidia.com>
 <20210615102049.71a3c125.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615102049.71a3c125.alex.williamson@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT2PR01CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0022.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 20:42:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ltFt2-007EHS-R4; Tue, 15 Jun 2021 17:42:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d48221d-48ae-4aeb-3123-08d9303e1173
X-MS-TrafficTypeDiagnostic: BL1PR12MB5096:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5096257D6F51BC6DC3E40891C2309@BL1PR12MB5096.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANeBmg06aP7A5xYS2p77UWZ9S06sjg1muj1pYi/q9EW0ltS3N3pYvumPNCVMk3PLqGfPTrfahZ8XHeHOeKy6umjxTUbZ/9JmlNXtFa3y/gr1HAk2dGQldjr0AAMANWkBF4FqHVSzklg5wK3LHVQE/FDj6lFTY830uJ1FMYy3QzFXgTEX8dyJfkcpV1zXgSX0JF/cCVz83WYptxbmudr7k1NVxOH931gsEaHgrpwd73uLW6THI4OF7ek4uT5x6LGup6qGSvIXtyo/iRtdSXMVhRQDqnOnl/I08B4ONjI2KtaZVPwSpdprqb82C03g4ypyi60izFWDrc9CXYn5rn1B/sWzXjpF/eTlSj9gZwrtZQrcmkbXgpNKrXIfd7SBXG/d/J5bRvAOL1N+LAOfoQQfOIXq/zNRt5F/LkYCUvDahwP/Tiq5UnXEVRzi5Qs76EoKDBtzVbfEplBDutkNChANFhpFzDng16dpBzeZg/AZNcCh52TFArqftZ2Bx8vtQjZqe70LS/P3UIpcWVzqeS8TN3qkAl683vN4nxJy2GEf60CDiekay8pGRG91DIztTkuPRndrrKf99RBaLWV1OS3bjOanpHeY6inkqtuGq5QHzDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(1076003)(9746002)(5660300002)(316002)(26005)(66946007)(9786002)(36756003)(2616005)(8676002)(186003)(66476007)(66556008)(33656002)(86362001)(2906002)(6916009)(8936002)(426003)(38100700002)(478600001)(83380400001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nTvg+bFNVCXz20YYA9lFKSL2KCXHDmfki/dL0URHnLQ2njFPm+7oNBMFp281?=
 =?us-ascii?Q?N79e78ndjP9YRHpblgPNhQJlIhY66IY/4s/bjC8vsfrR4G+Sr8+ZYmQ9r85F?=
 =?us-ascii?Q?1n5LQJpEdjOMvnSi8gATxZ5if59mtZJ+qkdGs6gbG9Eu2+COFWTB3IJWxuW0?=
 =?us-ascii?Q?E7/v1e85NEP9bdgIwhJBlL3YjgNt6wZoo3lwGY1XV+kDB5itnlEcOR5zOvyY?=
 =?us-ascii?Q?Bl7G8+xmRDns9am0J0BwJdEoEhjrVA2PtGEHu4iGaFT/N3KChww4R0kDaG/w?=
 =?us-ascii?Q?LagfdFW1IRdYe/ZSwyGK/UutKJSjkArwyi1zsopTHC8zmwTfgxcrI4C0Nt7F?=
 =?us-ascii?Q?Ke3hmmqK6cylOboiP0qL3PcG1hdZV3YCOT+ShwwZOIp/biCKoOn9lu0RJGVV?=
 =?us-ascii?Q?X7dALts0GyoJIHwFcGmUAPKtwfas4/NVJM8ZCpgN2KKeP98Zbd7qRK46stUn?=
 =?us-ascii?Q?SYlzg8B/hkOsxHlJz/ydfepzBHyrg3Pc9hjjRvmx9ql27gsVee/BFvNybSO4?=
 =?us-ascii?Q?sLoQYiUNFhOiCsdMah19KPj+l/+81OCui/C438duXMeP+PnXUuVcykSWMQxU?=
 =?us-ascii?Q?odp6NPr8VJxAj90GJmdklUF2gx9CzuD5zHwJrfPjsm4hq6JurBAYRMvMC5vp?=
 =?us-ascii?Q?2+DOEDpiz5cvrMigvyRYYStfp1yP4CUmdnaEB0Gf6DJOECLqHFkpwohzdnOW?=
 =?us-ascii?Q?uoy36VwIGrx9B7H+tJ5QCOajnGtq40m8oIzD5cTn1KXhGNdFs0Z6Pwdc+BET?=
 =?us-ascii?Q?Z2hLE2gnKyXMV+w1SY2E7w2uzJg48MjCxgg3VWbLc/Qvtk0N8Y+aebiBf4wa?=
 =?us-ascii?Q?+CsA1AOAFJJMJUt7vdhqQei2UKfq8fSsZ2uCeI0kbWEImxkBoKpiKQ46LCa2?=
 =?us-ascii?Q?HeIl93IzjnEx4WZWWSjzsjQMdo727BOhfjbEiMkMJ2eY/fsyd3kpSsSVHUDa?=
 =?us-ascii?Q?8MjrYXP/GdRkS0V+l2bBZa0WLaoycPz2PJDRSd9l4IXxDhGl7sWLeyCaktRP?=
 =?us-ascii?Q?oY7C5i3ce25cEO3L+eyBLNbthVPjkvQg+fFJQjw+YFbBI7t6arhgwCWChAlM?=
 =?us-ascii?Q?e13pwLgvOCtzws+IP1hUeCRhLoiB41phh1AMMhH4rkrsLk28wb1PXD0Exrc0?=
 =?us-ascii?Q?A0NTCZ8q4/cBbssNMZj18pVp4x7O1K0x/DeMAQ9Go55InHblSy1pZoZmxHPU?=
 =?us-ascii?Q?htzmn6Wzri4TthfFThM8KEax/8Qd3AEacp14obd297MgM+LJ1g+GSdlcyqPH?=
 =?us-ascii?Q?2HJH9za2HhqWdo/0d69b5d5vic0LwILcZbjJ4FJLG13vUe1hG1chpg2ui1cG?=
 =?us-ascii?Q?mLPoQQH65Cy7FNW8Vp+6EEd/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d48221d-48ae-4aeb-3123-08d9303e1173
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 20:42:19.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szPbh2mKiVEnDDKHgVgXWSXU8bUnPyU4L7V3K5dUxOx73PRMWDRrfKlqlPAffnbM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 10:20:49AM -0600, Alex Williamson wrote:
> On Tue, 15 Jun 2021 12:04:58 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:
> > 
> > > "vfio" override in PCI-core plays out for other override types.  Also I
> > > don't think dynamic IDs should be handled uniquely, new_id_store()
> > > should gain support for flags and userspace should be able to add new
> > > dynamic ID with override-only matches to the table.  Thanks,  
> > 
> > Why? Once all the enforcement is stripped out the only purpose of the
> > new flag is to signal a different prepration of modules.alias - which
> > won't happen for the new_id path anyhow
> 
> Because new_id allows the admin to insert a new pci_device_id which has
> been extended to include a flags field and intentionally handling
> dynamic IDs differently from static IDs seems like generally a bad
> thing.  

I'd agree with you if there was a functional difference at runtime,
but since that was all removed, I don't think we should touch new_id.

This ends up effectively being only a kbuild related patch that
changes how modules.alias is built.

Jason
