Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6EA3369B3
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhCKBfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:35:06 -0500
Received: from mail-eopbgr690069.outbound.protection.outlook.com ([40.107.69.69]:10430
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229608AbhCKBeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:34:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z47ZRhb1mjx6S4XIQrgNHVYF6HZ3OzK1hYCzsxzhKgwF0IWZgL71A2IyUDGlwVuzExoNcKiMf2hcs4c/AUAWt8eimbAPUSqmoOw56wyEP4+qZ8hASzuz3r80tG92cBmN49x3H8AJScN8rMw0ewMtFDCsZawtFwPYoJwe9I3SaoeJX6ENSpz7hrxNlruzqHImIYKbEo1qYV78fdquA59N+MlYD7tb6kgccFQvQV2BLnRfE1COheYJ2znNVFMshn90z6hlISZGKdBPZ36Vq40TY6+1ASMymDBgmdtfe2eNiYDpySLQ2oCASer/PBIaTzOPlzWtDx2X9Npjkmw3w0m8vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Tso6aIVKsaKDczeP0/TpUkt5xqzq/yW00tdPe/hrKw=;
 b=mBNEDFhmVRfq2MYT++a4F9anCEOnbItMEHqyGaWiaWwLUHdY1oGfmCYEF9t3jyhNUSW3JfKpoiAS2zb8xhD0j+vkKpsH8sodaSkImzjMV9AgKNqrnaiJo1RsANVrf/KPWSgsqukYhSuvF35hxla0k4cni7+1x0WWqe0oBiUODTgpaGTqI4PgRsP0ee5t0QyhpenxohcqZJiUseRk/K2JTvnIgdfa8sb7uOs9e/vCvKDlEkFL+SKJcCBY2zslMhLZAEse818oNWEvuOxHk833juRUBtH3n8VFJRALGc2bXpu4tpRaRQx8ftl0+vXqBzIFfyN4LRh4qxkbH01ZXT8V6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Tso6aIVKsaKDczeP0/TpUkt5xqzq/yW00tdPe/hrKw=;
 b=os3lVumeg+6pj+hn6NGnd+l+uLGlGR7jW7Ce34N65do9GA0BFlnHCeALb6qPUFs/h9+oP2G12aUrM6BVR6x46e9b8nqsxE33/aqBbIUWAMCDRGHUa66SFJHXbN++91ZHHRH7LOveQEqe2jXpTSiZP4Efe4X1nwwqjE2a0Vzzb/INh5ezPoCFiEM7jhfq3DJP/vbr/s+QLIfhihyDXmHFyNWN/1WwwBXzDSKReaol/Vyq2dPSwN0wFnFXKymPHKFVrAVB8gVOXTC//vyg8hmpp/SWYoyHDWZfri6twFLggFyIjIBdOENYkPG1YTCkyAGrTij5NaWN6cLHX6Pu1V7zBw==
Authentication-Results: ozlabs.ru; dkim=none (message not signed)
 header.d=none;ozlabs.ru; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4578.namprd12.prod.outlook.com (2603:10b6:5:2a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 01:34:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 01:34:44 +0000
Date:   Wed, 10 Mar 2021 21:34:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210311013443.GH2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
 <20210309083357.65467-9-mgurtovoy@nvidia.com>
 <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0015.namprd02.prod.outlook.com
 (2603:10b6:207:3c::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0015.namprd02.prod.outlook.com (2603:10b6:207:3c::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 01:34:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKADr-00B00A-1h; Wed, 10 Mar 2021 21:34:43 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91209ed4-ac2e-49d8-b85d-08d8e42dd95e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4578AD523CDB733E550B0B9DC2909@DM6PR12MB4578.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpDBXZ+rz5/xmzPerYm4rceRIsjZx3br0Xf/TrCE50FRCb4XeNXR3hfba8zjhL+X59HROsYPN7pgIbysNVUSxrPp/jfzVrLb3AfqpR4rXY9bdDgGPEMK4URm8wv6EyP8Y6QUc+kFytdN811jeTOD1NT7tEzanfdqdTa7lPly4t2ltDX5huboALsOC/uiRQ1a/EIOKPqOGWDVKq1uSRqp9XVv8qfiUTZ8PjK9BWgaWhuF9+dhkHcuTwi4ILdhExJ07oehiu/yHNwCqWtOxNVeipz2Zyhz8GD6VZPOka+lt322nO+/FWSZsDbDdE4lq7VyvnM4AJIysi8gQxkok2RlgYemnQMZ/UcEo08i6FiKZGuFg94K2N3l4t+SpTw4859ZwljDOphR1SXV3a4oxoYNWqZDFq7hzGTz/b7RgKEacEvB+YqIqyR9E+ybfaEJ8flU69ba1f8B2TPKqLu4D3ZxzJvARLEwj2C6mZ3p2i4dHwvtWNe6YBtig7lS20rgdqzH0Op6OGg+n/j+xOqgEAywbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(4326008)(478600001)(86362001)(5660300002)(66476007)(316002)(66556008)(6916009)(66946007)(36756003)(2906002)(83380400001)(2616005)(8936002)(426003)(8676002)(33656002)(9786002)(1076003)(9746002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ONhJxytIL7rdrBFLJ6ZsewIDMbG1fysfJeUBkSUm8C2XpuARb/UAI/OdZRUE?=
 =?us-ascii?Q?wSUw+/O7cW5W7MbuklJrHwEO1LOKDm9Zoby24ZrcbFqaZPHK4tkO23sxtOwh?=
 =?us-ascii?Q?s3eCM3bZlzXe5I8AQtpWpFJ7IWv4oPwLeSmL/MJUfOjaf27nFim0pWjje6Dq?=
 =?us-ascii?Q?VGKRBdv04dBpTNpjrVByXDfNJV5t5z6n0OrEad4ahvbGiINN0d2yrx7ebRpN?=
 =?us-ascii?Q?V8EwbARK5+aEZrUziAuetn/eub5w4+9Qj3fY2yFDtbJSbyiuXtWYLdstE1/D?=
 =?us-ascii?Q?YukwH3msps3MIeu8eLdyMOn3Q5mu1QbW4Lf07dS7xrYvUIF7d/Ika7wYmGXO?=
 =?us-ascii?Q?C/nJ7eTy0t85X2cX8/zUy1fzKHhzZMAxjitj7qJHQ4mS1l6C/+phhtmyoAE0?=
 =?us-ascii?Q?DB6E5e7nz8A4NusGM4cTSA0xfnR2sNGdB6//BkYo4FeKM7LWxQ/Sv1gjuqHu?=
 =?us-ascii?Q?0poEHeRSX09qURYuMUbICQvPE8mO9UZwgr+52dGYWh0fG4RFDtPk89aYlRjt?=
 =?us-ascii?Q?RCCQrxXrvdnTPmuuV4sFFPchkH7Np0q4ySx/YPoSRSSKj0Q8xgHWBJ/WtccO?=
 =?us-ascii?Q?Rm83WaZ+9lgdb8dyCnLUcKpPGzWdB25noScsrqYiB+D4h7Ztb7hnx5XcLJGt?=
 =?us-ascii?Q?AM16m6L3W+CXDtL4Sig7q7fWlM4eYFDQQjNcaZ8X3naYYocew8Y4cMG8fCzT?=
 =?us-ascii?Q?Fitt9ApxCngPzMY/O1BI5tnpzIuDrBa8pCIIVw+ySUKrWM3fjVS1UQ1JWHdF?=
 =?us-ascii?Q?U0KaHRzIIc8I+V3nAzJc3Wk+SreQV3/f4FzcEaLEU2gp+R/38Sg3rxweesIU?=
 =?us-ascii?Q?de+wThMr6QFCPlR3FGkoFMasJ6QQoCKjO7H0zYkZ9VrAx27l6BKM2hu5K6u+?=
 =?us-ascii?Q?2fl0JGiTPSlUbUHvu4LnRoJlvTZnFBVd3hQpV4z6FAd19dvLrBQEtB3zbwn2?=
 =?us-ascii?Q?Ecc0PUzat0PYbQv/wRcjim+ep5EfF69Hn7dHJvDiKU3/zO4Rn8+go62Xvu6Q?=
 =?us-ascii?Q?jBQ4u1isHWr9lJUKt3a5gwEJ7+P1AfzpiUPn1HDPVIhU2eZ1ZVCMCrOYoIG7?=
 =?us-ascii?Q?gRrwd/epLV1XXX+WyeM9i2HLpHRoyl7RlePCxpN05fAO8CigyMuWQpckJMW2?=
 =?us-ascii?Q?j4ozKZ9jsfdkv2DSCG70qzG7s1adHY18YSRprhI1a8Ny/A5uTRA8+7i73oYy?=
 =?us-ascii?Q?82rU3ODK/ciCa7NheYMQ3jvMmnksvaC1bU3VxhBdrd9PkoW4XmGXPReM8dOH?=
 =?us-ascii?Q?nq0vY7afvux7vCJbqWkdkdtTVMMkpjwV4Nx5A8fLLKhqZaWnS4lV51xdjNuj?=
 =?us-ascii?Q?zeRB73e6RuOTOQ6dO3HljEDYwAjDz8N/H81VnMwkjJX3WQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91209ed4-ac2e-49d8-b85d-08d8e42dd95e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 01:34:44.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hhsftH/KjNuspO9iehjYkpMMFk9cjONizOiyFJUFZu2E7G6bznGePSPIHZmRcC5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4578
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 12:20:33PM +1100, Alexey Kardashevskiy wrote:

> > It is supposed to match exactly the same match table as the pci_driver
> > above. We *don't* want different behavior from what the standrd PCI
> > driver matcher will do.
> 
> This is not a standard PCI driver though 

It is now, that is what this patch makes it into. This is why it now
has a struct pci_driver.

> and the main vfio-pci won't have a
> list to match ever.

?? vfio-pci uses driver_override or new_id to manage its match list

> IBM NPU PCI id is unlikely to change ever but NVIDIA keeps making
> new devices which work in those P9 boxes, are you going to keep
> adding those ids to nvlink2gpu_vfio_pci_table?

Certainly, as needed. PCI list updates is normal for the kernel.

> btw can the id list have only vendor ids and not have device ids?

The PCI matcher is quite flexable, see the other patch from Max for
the igd

But best practice is to be as narrow as possible as I hope this will
eventually impact module autoloading and other details.

Jason
