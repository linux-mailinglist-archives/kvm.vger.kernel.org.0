Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C5332C87
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 17:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCIQsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 11:48:04 -0500
Received: from mail-dm6nam11on2070.outbound.protection.outlook.com ([40.107.223.70]:19776
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229689AbhCIQrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 11:47:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqcFZp+R0dDv2gyzInb1igXzwpMg5McfkHQEmv23QadX9qFCOVAd/djBs91j0RE3EX5EMMOZ+qlPi+Zz4asJAGueUjEd2n8BNQ1dts7gkKrAEENO8c0WSWt1wwiUzjzIpDVxy+ESadzi31l9IA9cy13YwhAE8IblRuDZL5n47K64AMaD27OKRQxQpYFn2h6nce+UA5x4+UBHNMh9OpWDQ6tjXHDblM2NbZ7ZDNt3uN1ljJw5BRyL+Ns6F0shyex+yPq6q9otFgBSdsbbSY212R8q9jjno9cNdj/o8rN3r//NJBOIGJKf83ZA/6FcoYy6knbnXrDxRWZdpSnreKkJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeFMMmPkIw9p19EpgaP5dNeegEDJBIhlVCf3ZaH45+I=;
 b=dvJamc3ygs4FjgG+mR/XY8z1B50lZTphelfgFvI3u6SUXb62xevOqRloeSACIpfJ1vgs7YReRODyZ53EUM+w7MlErrgeg1JkEbTlQg3V+9ylhm/rn5YCvtTErHCs9HGvcTcp/sVBYX5vh8H0MlQMlEUsQeb/roCR9pGMrlCQ9p42CDmcVacv8b1rLJc/IdsWiWV/odNLkKzguaTi4PyPwZOdDpEJFmNfdcaYKc3/wtQlacH/FmGSlgAK37UmUOMFFkPjMbBZxcHWT3yQSCxzAKPcwje292Ivgp1+1bCe5jX/9sP6E+ncatUX+wH+4yZ5NTO3ZVSY0ZVAgxXdaZcXjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeFMMmPkIw9p19EpgaP5dNeegEDJBIhlVCf3ZaH45+I=;
 b=QBaS5LIjKLvlE8QQ0qgeezygtP4jusTdmUUkZoA22GZKBLpOGz0ApnBk2ByNX35KQV0ekQwEO2wDhRSCS3AtmX5gv1bprtJXJpgU4sqw7LUMlKEA6c/Pd0JGDvd3eYMSt4JaTCYk6VF+Vh+z2tSvRcDBBjQvwWDDaZaru4iBRet94mqjSYYTIptN4hATNnvqju8b1qS7Kc5qu9ZLdQjr2nxXuItI25zl+Fc1fSFHU+bkXAe72g7XW1PxGjaMbvvLmQPCccE+0IefyzjX2yLzJ9te/z8RwYE4Ski5LVDXDNzoPworvvqz0Wjf04XaoFFUVB6wM3z5azkWYLYEDEWJGA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3404.namprd12.prod.outlook.com (2603:10b6:5:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 9 Mar
 2021 16:47:45 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 16:47:45 +0000
Date:   Tue, 9 Mar 2021 12:47:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210309164743.GK2356281@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524010999.3480.14282676267275402685.stgit@gimli.home>
 <20210309004627.GD4247@nvidia.com>
 <20210309084513.51fd2a97@x1.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309084513.51fd2a97@x1.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:208:23d::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0014.namprd06.prod.outlook.com (2603:10b6:208:23d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 16:47:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJfWJ-00A8hu-Vv; Tue, 09 Mar 2021 12:47:43 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4753762b-bf91-461f-07dc-08d8e31b1051
X-MS-TrafficTypeDiagnostic: DM6PR12MB3404:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3404F73A8686F23CBD00F2FAC2929@DM6PR12MB3404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dxyw43HFk+INTaeFfkFEl2rQCvuXE1VlGJ7pBR5B4Tg558aIolqtXK+2Oza4dwDPkgqVWMEHliHGj6S8ir4A15kUbHtpKcGJvks9TEWEWCX7o+4w25duwNW9JOCWq5TDNAzPU6euDSJGRRPsnAHuoqwalbRUTY+HO1pOEOsu4Pd9ZX5NTBu3okJCFFMwlI9CAAH/BkNP/m0rpdh/Y1D5RjPav87uXDr2g/lZ5BtPUUW36b72rhH8+mufvBla2byQ9Ub0uuDfJb+xgIzD3SKrY0rtL4Cge0ZzFaaHhas9BbgnpvUWoYnVEOTJ3bcBnbA2koYjfUjhKgcuBAANbL4+R7PWGcSHXVr4Ho67UlrgQ54eW4eiwMjpPbcwnf/iiWP9Y1KwgEuCaNpudRpS/TsTx1NoBWRr7lhUPFr5G+eURXlXshq8OvNHRMkRA/vPspCDlmCOXYQv0VZ3YtHxVK6yo57JoGZq0YyJ4vjtDGNg3VjNMq0SJehBtFxmisp4m2nmRYwQg/7l8BxPrE8JqsxQXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(426003)(66946007)(186003)(2616005)(66476007)(8676002)(86362001)(26005)(66556008)(8936002)(4326008)(1076003)(316002)(4744005)(83380400001)(9746002)(9786002)(5660300002)(6916009)(2906002)(33656002)(36756003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Nuzaqq1Y/RYSt/ULb23nBfZjlw895LMWHMhK5kOfysruEt6wOmYR2vLtRwqu?=
 =?us-ascii?Q?tdu4R51vVjSZ62LuIzT58+EuLr9di5kmeRH1BL6PJSMogO7tAmuJvEbCWtuS?=
 =?us-ascii?Q?oPVOmd5xsKJnn9PbI/Q8BzSO+16m9+wzv4wANYPhwIscY/TCnoun5JNvNhMh?=
 =?us-ascii?Q?uJqdYI69X7B7qeDiaik1e6ver/pzk9dBbx/PI/oAc2nKeN6gS7g73bzzYzlo?=
 =?us-ascii?Q?/8Kf0tLN2OMebCgQJWbV1mn3d6bJxgnPX6lhdJNpV/BqSQnpSBWQCUovi70j?=
 =?us-ascii?Q?dyO8Yxwuep8piDYtvMpqq/D3OpNP7oQgYIUZIaBecBPa+9wlMiKHqlJtMpIL?=
 =?us-ascii?Q?w3bcm5YewFjgLbFKVSYXhwjk/qpo2103b+BtEE0WjMSulH1rl1Lq/mWnekTm?=
 =?us-ascii?Q?urWHjlpLN1hYxkUtRln4O6Itmcc4UyDySYXVJn4Z5KyS4jLZBDvybxliow8f?=
 =?us-ascii?Q?biX0Fed33vStFEZf3mCm8l6KIDeiolpxW1lM0kf2ylKQNR2y877xCtCbnF7Y?=
 =?us-ascii?Q?ulCxb6zp8Xxj69paP9nHFK5y+5SYWhXasMqOzCdq99aEF5j2kukxjsmqYNbj?=
 =?us-ascii?Q?GX2DYvKTG5YkLj+pLsQD7F4GazbC8JWZvS3d3qxy3zJb57UOmFILQfnVX6cd?=
 =?us-ascii?Q?BvcINyoqq/+PY8lKuB7empCVLci9DmtfRutZtxv0zDkmYe339DCMb6m5t/FX?=
 =?us-ascii?Q?k9HUp14rjukL6Q7KaCCCkD1oViDAri+D0H3QX4vgvwYzGOf+u4EsFCrKDtvr?=
 =?us-ascii?Q?QgeF+/aI426+VOGr/bU8KRGwtwWZf+MBW4LfZD/Xl+xLyRhRoGI0FV50+pGQ?=
 =?us-ascii?Q?8iDF18/qqC7gwjAOBFtNFT4S5yzcU/fIIa4e6kbnUygyXPW+6vIeCt/hQtXk?=
 =?us-ascii?Q?3b88jMXhHNrVpj4dQEdl+QwPp5WRwv4bkkKDcZproT38yWoaBdbbpxkz5Wau?=
 =?us-ascii?Q?IIQp82kRQ7XSqnt6mhgivjNmqBSRT3KOENcubu/hXUGjn6kg4N2+hoO+9Vc6?=
 =?us-ascii?Q?RcqvSP6ZVlpMqRhWBIydsN3ebZRYvegrHeJ3Jplzhqcox1VX3/+T9EL0tQ+I?=
 =?us-ascii?Q?hGW6HrelBkOQehIwJ/vhmwnD5P5vXx9B59pIMT4QLI98LaKy0asNokPyqqnS?=
 =?us-ascii?Q?iNBsQuPk/1hBu7Ps6aqA5sU1u3UfXWlfFxlbDH0TuknjcUD03q7+xkrvQuuI?=
 =?us-ascii?Q?+QXXcuHTy+LM0JMKxSL7Tuvlv+svZ3RWHheMeFj/kCAcMtCwKLQPm+avi1Mo?=
 =?us-ascii?Q?J7mvbhNv+LoFXns5EPf2uzOPh45/KenW1d83/FV9fccqBJ9PbBG7sctmeXc7?=
 =?us-ascii?Q?gu3Pi/64iHSuLUcbl9IDonvWORoB3J1cEkrqO6Sh2tsg6g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4753762b-bf91-461f-07dc-08d8e31b1051
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 16:47:45.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8huGYQTJkRQbhRIDWuiKmnXGHRKGFe//7hePLMBtp4DUPRngKRO2bYWywLaTkieU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3404
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 08:45:13AM -0700, Alex Williamson wrote:

> > I'm having trouble guessing why we need to refcount the group to add a
> > notifier to the device's notifier chain? 
> > 
> > I suppose it actually has to do with the MMIO mapping? But I don't
> > know what the relation is between MMIO mappings in the IOMMU and the
> > container? This could deserve a comment?
> 
> Sure, I can add a comment.  We want to make sure the device remains
> within an IOMMU context so long as we have a DMA mapping to the device
> MMIO, which could potentially manipulate the device.  IOMMU context is
> managed a the group level.

I find refcounting is easier to understand if the refcount inc/dec is
near the thing that is actually using the object - so I'd suggest to
move this to the iommu code.

A comment sounds like a good idea since this is security sensitive

Jason
