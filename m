Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF873C79ED
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhGMXFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:05:52 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:17761
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235536AbhGMXFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:05:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RezNrOQ6XSnmn3IKA/bAAkhGGFIRwFjZ3oXUzR8OP1gUM+3fG9Wu6hYMSQUeaBlq+voANTGTIKtRzg/lijWicCJILg5qgkUFQcld/44NV0he/gFLpS1N38xQTLBqzjpZTC6v1TNCDqz9IC0ONvzHP7aMKZgvxNtsm2Z+6pOugQxW7EX+c59d0b70jvRJ2Xs5LUuHboswbjlG67QT0QALzZJKrK3+wLPvQUqWlVIEFYoyZWC8P2j9bAAuwe2msogJGi2MLaJwqTi6CRD44SVuBLe3E4sAocHYNr6yQN7eXhNJX21+bH0w2YtZUmZLnLCG7mP3Hy3UrYuQUTMW56+DYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPiba1nk3Wjbp3b3j8Fk4cAhlMpAilpMFgE3GUtQUA4=;
 b=VmoYjzYeMI0H/icSrYXJx6rsFSAGUeSxcCwAZjdBZiqkmJ3VCDPrp3RsQjQrSdn6G32HtkK1sOJWCVu44Jg9tFyLeBLIwWiK658pGNTwjKSFfPRZroJz/NeqLmsQm2Y4KsTMuCIHDoo5seiyVcQzmkx/RoG8ciHjf/uHemBV+RSh673EfBNZg+N65gkeTbCHmqsmbJwzjD0dCCcgATBlMdRlIjRZbpRPGZA/AKe8rQlBcCOjMNp05n0v0zID1J+BsolAN+R80IM0KGG4WLXaeMi5qj66by3AUZz4WvjVYQGX3UW+Asu3Ej1SHxdIxzV3hIJMhUX+u28JKSxLa8nA3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPiba1nk3Wjbp3b3j8Fk4cAhlMpAilpMFgE3GUtQUA4=;
 b=ODxGqs96ZZ3PvHmfFdHxVFXhSiwbpWXT2NzlI1NgjarXkOyqt035pN4bhu3jQxVzOxHniBs9UYPx1P6WOj6MfaosXlRWTJRV6lHO7QgrlFd4M3bhTuCkMPeT6Z5qwVFdPfiSAYD/cbtZQQ/CA7va4I1AGNPV5/sJvNR0+d+enShRRgwOtonn+CU/HC2DnVxpIBnsdKrSdKVeTPmiSBytAyDIihux3oYA7YTGDDwOeAVLeHnhczGcYVaaVJgrPnonYZ+VHvCzov4bB0BCPJCeAbYBN/zFz8ClkpFqWGGxWmezZDu42XmXHJdB0EJ98WKpx8sYUwO8Dihj3s0JG1yrGw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 23:02:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 23:02:59 +0000
Date:   Tue, 13 Jul 2021 20:02:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210713230258.GH136586@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
 <20210713163249.GE136586@nvidia.com>
 <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: CH0PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:610:74::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR04CA0075.namprd04.prod.outlook.com (2603:10b6:610:74::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 23:02:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m3RQY-0023Nw-0x; Tue, 13 Jul 2021 20:02:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e27d1cfd-bf85-42b1-a125-08d946525c10
X-MS-TrafficTypeDiagnostic: BL1PR12MB5191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5191A0BC2D2F45B3FAA80C77C2149@BL1PR12MB5191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C83Ql2uGfBTkxyIbQdbp/txr0/zbg6Zj6w4H8H7e9jhi7IvaZ/qBlRndUc9aqNzigp0weuxK9AvSMfpLNBcBGVCEP7dJoQdRDtBRs7enrXdW0bcAdthenC7Z2CyRPPBFdmIpXVQyJ7uLAOijR3aBH6OPPRPOkbyhskSVmr9rxXLbeY9G7n8LT+7XLVj3u55/zIhrLhVpqGDVcaXuzS/1upeqUEsCcgkAAcr13pkDmdvnmAqFTlkkS5wGQiYxJyzLz3zXfOrl6YORZiq2GvREUKZ/3CSH+oczv37UD7KBk6KYqnxQET9zdZjOR8JXRlxb4VF47wyOOGOZVXCIONYEuT4OT6/21NavOu5OgZVpL8Ys/VDs1zUOwxvOEq5PDiNqV9XG6qVAS4WXZ7VMXvp3SxQRXxHV7rvGKvbjyR5KWAeXAZBq0D/GX6IE8DTTM4FKlwnaqTzf+lcit6FTTPTvluzPniNt6bWfFaqE4Qdh92zUmxdz13k0B+nWe+GFJo1JlnsU03o/OSKtrdx7cpyyCTvYvvMJqCd7OeO/KKb8pZ9SdHlev7mwdouTgHce7seHI7443x0l5qhcPiS2mr1nLNzm5hJf5OirLJveUr3nceXEE2xrKGFnhlrheKAUyA7IEtpaAdLy/MeKpKg8Tw8IiYlBLkcoZEQOPQy83YUAY9btyv/Fx2twlQYOuSYFFlNq4DczvZSF+SPhp3Nau0Q4YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(4326008)(86362001)(26005)(8676002)(36756003)(4744005)(478600001)(316002)(38100700002)(426003)(66946007)(66476007)(2616005)(66556008)(5660300002)(54906003)(8936002)(1076003)(6916009)(2906002)(9786002)(9746002)(7416002)(33656002)(186003)(83380400001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p2e6F9ymXkxbiMGKwJ6nhfO7dEkLOOTJNl1qICCU5QEJcQ/dTDHtHKa8Ow0n?=
 =?us-ascii?Q?4Iya/NIhqyhNhzmhahI2qiFXqSNY1WvH24dXEkJsb+SXY0i7wQie5OUAi7d4?=
 =?us-ascii?Q?HFpSiNLYJuueHRX7dY/2zcPP2pUs/IZJ9zx+e/DpiF0YpXGRXv4qTcvzDR3h?=
 =?us-ascii?Q?o6XUhk06NdGKtvXbS0vONDt/J7Mthh09g2gCQLSsnYouTQnYe6Toif47BKZN?=
 =?us-ascii?Q?lGHVdzIv/f3qXIXmLSmWV1QtsGDUYRcQS0O0XwBgYxeXU9EwSuGSjzJOYOzS?=
 =?us-ascii?Q?Jgcn9P4U36wz0vJ7I7Wn+gienc4bXeJkACT1sohidx4OLwEplDd/dqY8VXj3?=
 =?us-ascii?Q?/34ffux/oYcZpBiYOhoo1RqNBWDHSq56a7MwMXAcQVyQCBkL44E0+br1THeB?=
 =?us-ascii?Q?Avl3rCMPyr0dqK9XY8gpK50jiMa2Y++uEECnU2F6nDDPAWicg1O6zgZMU+Qc?=
 =?us-ascii?Q?ojHq9js547sk8mlKyRCtxmEtQue2yAu1Jj/gXRlu9TmXt0ftp/tsf2vdzY4S?=
 =?us-ascii?Q?LhDurfdjJivcXf3elOnd/33b20oW9XPFZowV5lM0fbg4Ade3DVlq5mChPFwk?=
 =?us-ascii?Q?+ILqeKDmI+Zg8KJ+/xU7xsnTGyg/sCcgarFd44DUQU82P/9LME/zCi8XyuC2?=
 =?us-ascii?Q?WLb/31F65csCQi2m33dmutCdQQLK+GdhpxQjG7eD3qfKz1AjxRoXdafZEoKM?=
 =?us-ascii?Q?f9+mH40kCFMbqTR29UliY+EQi4fCqLu3+7QhMZ/ajEsBAQKO+5WLpOPb+6vS?=
 =?us-ascii?Q?Ky8125tkfStay1IOc5KrkByvOaojVST+8h7OeJY0CA5OC62P23psZAUvIWFG?=
 =?us-ascii?Q?6tmEeCulc7Y6ueL7eeyk/C4cBtzh35V8lYjQWgcUYHK/8rIqMn7/V+CX139Y?=
 =?us-ascii?Q?sutQR5z+6NRJsu80VJc+uvdwFHLk6nAtQMn/yS+xUVMhexBuZclbH7tWCaJI?=
 =?us-ascii?Q?ula1+R/uN5OduomTOymBIsbH6CL7m5zIYMMSDO4PoWuViagvDzV9+GeNZMER?=
 =?us-ascii?Q?yUqDrTx/uzU7g+0KN6hlNvbHZcqazIgqFW8YUSSU881kHsnmRdS8nOjMTjZT?=
 =?us-ascii?Q?EMrsJCk3AHI5YaOB2LnJlcN1m8UPy2oJzyxQmm9zVtgPbhjDdh2qOXP6z9xD?=
 =?us-ascii?Q?5jJuKaDdyJbdymgGpc5nDCvMeOm+78masrepMOwXxvemvgr4XSKJZ+n7vPsS?=
 =?us-ascii?Q?GcO694RCn0R7qAoRJ6hDdnClBqUk6jN61wBPHtTR17YxG2naXqtzWH6iKhp0?=
 =?us-ascii?Q?vlNgWso+6CCQrKGtGKLw4aA4m8SpG6ae7YScrDs6np2NfP/KDL8WUue9W985?=
 =?us-ascii?Q?7tMs/FwZ90Qar7hn85Ebtco+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27d1cfd-bf85-42b1-a125-08d946525c10
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 23:02:59.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+8TQmPK/CdiE4spGhMh2hp6k+t+oakQfA5yKZkmv6OUDgqNDDthAJI+ZpL+WkC/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 10:48:38PM +0000, Tian, Kevin wrote:

> We can still bind to the parent with cookie, but with
> iommu_register_ sw_device() IOMMU fd knows that this binding doesn't
> need to establish any security context via IOMMU API.

AFAIK there is no reason to involve the parent PCI or other device in
SW mode. The iommufd doesn't need to be aware of anything there.

Jason
