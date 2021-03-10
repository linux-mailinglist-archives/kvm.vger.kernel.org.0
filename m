Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730CA33683B
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 00:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhCJX5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 18:57:54 -0500
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:20544
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229643AbhCJX5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 18:57:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCfMkXLgh7DPWpM2/UaADgH0lETlTWI4kVPVCR3eDwCr7GSgVpQKoST9uQv+nyhTN5QupaQj/Am2u9kUQtcQZNFsz9Urd3DOnd4gVCk3H9G063dVQ3UlwcsoK9TcewY25Bh+tEvwryhLEfKYBq0IL7KiyE56HgkuQwjgzrKc2PD8m1cSFxGiFdjYCUQyAa8dlScvSks9hIhC0VPtXU069dlt68mkS9KHtWhr00CFhKYyikE06I90Rq0NLLl21KJur5loGlEwpKmqFNunbBaDZkHnmZzT98AlJwDT0wPEVRToB05ZqTHKPnx1yX5ul6f5IIsJyfDXDUx+fYJuZny/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=op9B5d3APoAI8EC4Q+aIiam1yU2r8S67mBamMqOPzxQ=;
 b=JqG3qFHM+Y5Le9NgbQFy8Yj3cHWR09Gasme3IhpuB7K9/RPDcSBBV3QVzYSie38OE9t9ubTq16OQfiTVzAsL7FfecnRQLcg8RR1zfr3KSQyeax+5TxlAxBewujXe7MWwdhCIHyHzg4TMYeaik1lFRYTYm5DENxMIT8aPjY2QAVo+K8SWD95Rj24OQbsjDW8P5D35Px9QG3xR9l3AH4YgykulRJZe8P/3cTkg4sn0jIUo/b0v+2VO1jbVBS2ebyNtFnm7R6ZMn1CjttFmzE/1qBpRl6GaxDosJZsM7H/Y0E3JQtdSSc91R1tKKxOEv+E3gbNC/2phjbP3UB32cOlP1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=op9B5d3APoAI8EC4Q+aIiam1yU2r8S67mBamMqOPzxQ=;
 b=J/OrOcYlx+X8hAMXxfxogzDTC9p4kz0U2vNSBAG++OpJL8wY8M591ZLovr2Jr4Fp+BVcUksbA321yPi/IjVMW08P9Jhx2Vk01JmxEVnKwJFtLo3x3IwhHgNB4QgIrABonJGzTzcyiKebiZenWNGdv4RZtSlwqpQWxr9uAbvsRmsizvfarPcIuxoBA/NXKLOn5pur7saf2G061O7+3H3luR7XrLzFD2tvSNj9nmEBP+0In17Ktg+gMk7vfVIuOjXT7mWOZQgJ4ktKN8NdGQ54c/0wSxb+TW5tbxSWT8JztBVM8ms7OsFcTB9RCmDSPbyBRszIl4vNBNZOZbyYfhzH5w==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 23:57:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.031; Wed, 10 Mar 2021
 23:57:31 +0000
Date:   Wed, 10 Mar 2021 19:57:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 00/10] Embed struct vfio_device in all sub-structures
Message-ID: <20210310235728.GF2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <20210310165247.0f04b237@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310165247.0f04b237@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR0102CA0070.prod.exchangelabs.com
 (2603:10b6:208:25::47) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR0102CA0070.prod.exchangelabs.com (2603:10b6:208:25::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 23:57:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lK8hk-00AyTp-8v; Wed, 10 Mar 2021 19:57:28 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e98302e4-eb4f-417f-5bde-08d8e4204401
X-MS-TrafficTypeDiagnostic: DM5PR12MB2440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24401DB104E304823B5AC0CDC2919@DM5PR12MB2440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmLXP/BXWGkn43V4gzsaVHrzc+LOsmopduZyT/CiVMgi1KqE8G6ldJcoKtDaL+N0E2Ne0sedvOT+wVqI2MxQ3SmT59NUwW6UQSC2rtv6N2kHneiMMSECSqbDeKYUDP3GhirXkao9r6d+5uAnvP3Jny/0pZrhbOoGgbQxKEmm8B14b1bCLFZnbCxMBOLmZe1TxQOhKcrXmcecubGh4TSjMIjWbRQkwLrntcvEpSyu1pnDKeXTK6urL2Z9w4+efOxX2K6SRpe9WOL1U3ar647rMAd6+Iv8GuBT8OFpnZn9RxGWvdKn9HN66WAXCUT7K2Fzw9Td5uD+J/nQ4Y4wne7kA+PfqHGu3M8m4BuwcK/e20BaG3LShN+LDJFKYt+kJM+U3dG8PDmriNyQZuZj75/BoNQI4Nx4twhTXY4JhxCTzagvmuG76Gxi0IRI31bUuvUjXYS8YYFwEGTN9PvhgUfGP1X5m2kzW6cLwZRyJ1xlocyF1gShhWSJCTWZ+KxsuN8jdg42WT99SmHaisQPW3ynnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(316002)(107886003)(36756003)(8936002)(478600001)(2906002)(2616005)(1076003)(86362001)(186003)(54906003)(9786002)(33656002)(9746002)(8676002)(426003)(26005)(6916009)(4744005)(5660300002)(7416002)(66556008)(4326008)(66946007)(66476007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QZY6YfmBHYkSo62g8VAf9JDnIyR1ve+lyAspf98EDM1vr/a6n/s0u4DNB/8d?=
 =?us-ascii?Q?lwgfhZeLT7+g+oqay/D2sKWotnfxv7c+YrYaV/FxCaHkXQlssd1qM+/SIlsi?=
 =?us-ascii?Q?Kk7NgLQmPYzG8dP2Tzrng60GoemoPGhrN8k3KWBMZkfewqpLvPI6ugy8DWdz?=
 =?us-ascii?Q?jNQPiFetGmsJOgnXFiHRmC+j8sNaGf3Nmso7XWu7Ix4Hg6hLIaowCOKL9Cby?=
 =?us-ascii?Q?9v9XD+hkgP9/2ZOvEzpyDNPfN5KLUvQjIK9lcfHhyAntoJA7+GdHCmTPTCKA?=
 =?us-ascii?Q?UHxh3VPD40zBxcJkGtmZ0j38OKFihoy8j+0DrLIdp7JUnjlwrEH6x4xjx0pV?=
 =?us-ascii?Q?/D0hqxhj4wpgJQ+baxjbQf5nHDHvYefFYz1Qd1jnIiqneMmikFRUWY4a2NXb?=
 =?us-ascii?Q?gIVAKcB6P3weoEQbBQaJQ1w0fRm262OQCwoBiy3bSXkuiaRHpcK0p3ByXVmT?=
 =?us-ascii?Q?0XimEkOcmKWvSDMZi3WzSjI9yC/N4V/b73QZA8ubJJBhoxab2YUhUpx3Kgt7?=
 =?us-ascii?Q?7mHvyodfYqkskBcDcj3Ne9CbCUz0j+FFw4335a39rvEXZsL2rRElw0F17Hzm?=
 =?us-ascii?Q?nnEMgHRdlYen6C7FM5VXVH7GCdwW2fJgeTCbUZZXgUdF+qq6BASI37Wf4Hr6?=
 =?us-ascii?Q?EwKUtgss/LIuITjtya3fJA7rm2EKb5bO/x2yQCfD+tRCUuwNuRIvBWOEqvBn?=
 =?us-ascii?Q?6PIJygYJWjo5Zz/KAT15s84fIYkW+zMzCqh0+pLWHz9KDzfzYZf0q4kR7rht?=
 =?us-ascii?Q?qpXfBFjViu4xp0axCLiQx3h2EaYtjC7+S+M5UixqYaMWSBCOJ+XnzOwe+ykD?=
 =?us-ascii?Q?NQPBfMdNXmjED9AzkGhjrkTi0go7STeNs6m7Ef150BDBCQxD1RNYbbJK6Q6M?=
 =?us-ascii?Q?yksfZqy1yhFtkESVynPi3cuFQIePQMTjAddbXg1+vYqfy4VprAeDdjJX/Jiv?=
 =?us-ascii?Q?VfQVsHz7r6EdkBwjV8gXaUHlpZ2UiegbdXCX4ivedvkhM26+4b746fXFmRX4?=
 =?us-ascii?Q?Oswpi5i+ADPtLRirY8BmAijQMZql8nIUiZgC2Yui3oT7Ch0BfrJq5qjPgHQL?=
 =?us-ascii?Q?/13kf1x2aNUuUGHfNc47v4HEDn8dlbj1+iR5r+SJppsuBriHpvGQo6flTX5R?=
 =?us-ascii?Q?3q5drzab5o60wJg8tYKY4mU5wBsNG3piG1tXdjaqHNeLAiHxz5hPd2Pizy1+?=
 =?us-ascii?Q?Mo1wcy0k/srm5OpLrn6nUcVmW8lKwEbjThZuc2l6VNlX+HwyoQJAb/ONEHdY?=
 =?us-ascii?Q?DGT7nfJbLkA5hLN0BR1aa2JvscIIajG1RS3IBXFLmR5QlfnoZESVw3hOXufm?=
 =?us-ascii?Q?f93Ysskkk5wGAPMedIkEMyxcVgDOam0RjJmWE9EvI7tN9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e98302e4-eb4f-417f-5bde-08d8e4204401
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 23:57:30.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKnYPNo5kq+g/lpUaSC1How9UYEHfqQqKuuViMc8v4HvZluDYLTWOw7h1L/VaX6x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2440
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 04:52:47PM -0700, Alex Williamson wrote:

> This looks great.  As Christoph noted, addressing those init vs
> register races in the bus drivers don't seem too difficult or out of
> scope for this series.  Thanks,

Sure, I'm happy to add it. I need to check vfio-pci closely that there
is no hidden dependency, but fsl looked fine

I'll look at splitting patch 1 as well and send a v2.

Thanks
Jason
