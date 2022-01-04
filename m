Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F53E4841B4
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 13:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiADMjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 07:39:17 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:55841
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229502AbiADMjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 07:39:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKKZdmbK+exe6RbZ/mRl+LAUI5l/OxTRFz3ML+945KZQjY0Bfud35HpeuEAtk0jWJy+XjitEMu5LqDBHZcr8cCeJYkCHb5RzXfNAMx7Wwnpe1sn9sAC46ScamUwENPDmsP1F5bZaw6e25+y+nkcLTxFVMaoflI6wHa/OmAfqLvT4HXA9cuEChwFND8ckwAzrmgDK301GYOZ7naoxA2gt09y6XtVPT6yjYJJ9yC3OTbAKTU3+h5g/mQte0LJvnlRr7PsL9ItZ3bDmSflwiaEveI29SpfLpY+7GWUnDB4tf52UNs6Q/3wV67guOcIwmNJ/vAVMF/Q8dU2Nqv68FUSQYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HJoWuWmia5cwocb8WJte9PMwuNiR98g4XeXe1ikfKyQ=;
 b=FEKpDCmqJhXDDyXlqaEZXE/KuK0ld9ikmIPbHeoO8xmDSYSZK9BSZHN0z0i5Uxr5rI/K7A+T5XxXETyrn2vqJEHbUSkhAs4/y7ZGiLUdq19Ub+65z1SnweaF5Go8yxjIjFVDk2zp1lo7nKkns52etH6Kb2/NIu+NLWSpBxWdRPEEg2Vk3nOw8sCXqDU9mxHk3goBA8LNY9wpQyXImLYlfbx9NDr1nHPz6UiJfdMUhc+2NqyrNd9PzJhPMAhqakOSaRA6hMEoqI0wub3tgoqCM0monhww9sWY0SG4GfRLuADyWky/Q93ppzZ/KvPTdi3eO2WMStlD7LtmpD0u6hzLdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJoWuWmia5cwocb8WJte9PMwuNiR98g4XeXe1ikfKyQ=;
 b=ZHnpKMzvuZl0Cpadjgth8zy6FzT1eC1rvVT6yLpah2klr+ALRpqQDUv2KNXBZPNYOfM8vqRhH5nXYbeLxGeLe0Zp0vmGRselhWZJnCWCbP6os8d3pn5tnvSjefLtotPhAz5dDCjcovMyckcrDFb/K0lFjRo4uEtos0/sfebF7Shii9lK6UfCEa0hU4UjYce+lsPtLs0PlhKWfWqNNiqzOyy+5062LxjWZawMJ57ih8//yetJ7gq4y7e0JlByV9wAwPOiPc9RCSf1wOraSy6yFT1zov2+SLpdV0AewzM4eMOuWZPtkwkxrWXyoATW9VDJWo/xeD2P6E+eGzAP66TAZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5038.namprd12.prod.outlook.com (2603:10b6:5:389::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.16; Tue, 4 Jan 2022 12:39:15 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 12:39:15 +0000
Date:   Tue, 4 Jan 2022 08:39:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/14] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <20220104123911.GE2328285@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-3-baolu.lu@linux.intel.com>
 <YdQcpHrV7NwUv+qc@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdQcpHrV7NwUv+qc@infradead.org>
X-ClientProxiedBy: YTOPR0101CA0071.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::48) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab73438e-7e93-441f-58f0-08d9cf7f3775
X-MS-TrafficTypeDiagnostic: DM4PR12MB5038:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5038D96B93F75479AAA4B60FC24A9@DM4PR12MB5038.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2wWY2vwnSFxHpSF/txSOQil0w3duqr7N7tcX0wO3a1hRV1HFnGRKxcp4cHZj/i1uE9KYM3piZ/3g1hX1s3r+MKs57iAton2qtPYHRuvtcGNPHeLLvlhL97HSsU/dwqe5uQt9ddx/KbXqOS5Muv47BeyBpUTtXDJIYKbeTx/QK6UFXb7Eqbmjx0ad+04uTsAgOdQ6VhWcpo6JyS/GpgXqOHX+HW4Osp/v/0brZ2RAqdjcxjh3L6OWWgM94BYS/piaXRDJlWBEGNRc6uwq5P241SYwJGb5H+avvNgB0VlbczDPgj8y5E7Jh5nbFbEHAWzXNmoU0rRaqHEsHJJBYY+9FR78xqXcuSltRHMlwQ7jJ/PHC8/3yKp8v/YuM3+Dp0KAEaeI4GAl2WvcBCYm5W8QgJXFmzdUfje5x/m5bzC4p1+GuK/w75ZT3IznwIOZaJpfedf+TQkUYMw0vIvyMv5iz9Vrzp5+LsWdWSgT1Yba6uemR6ZYpERfs3NQXIVkTUTWtDcr5LBgKTUgwYUSB2eC/Znzjj5t1LttTMX0wXi4rCCYGRVwiB1EU6EzAcJ8nGD8/4sE/z53TrS2t8iB6efaR2fTGWfzndW/gYsCzaWQGJgXyFEh5rlUgtyamkP81RvLr5Er1hZTm2u3P5Dk/YfrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(558084003)(36756003)(5660300002)(86362001)(6666004)(7416002)(33656002)(186003)(8676002)(6506007)(8936002)(38100700002)(6486002)(54906003)(66946007)(66556008)(6512007)(508600001)(66476007)(4326008)(316002)(26005)(2616005)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kgjc6AjNriXUS7o+gXaifZbKl0equoPluL4O/syxdOQne1d0UjKiONdGrBpQ?=
 =?us-ascii?Q?XxddIKYWC1Ac/rAwfMDIJVlDv0qnZRfSO0ZeaoCmG8O4z5ho74qOUTIym+j4?=
 =?us-ascii?Q?9JWsQCiSvC/RsJPJ1imGE87P52wGvaGPDnph0WGQTfJL/PG+an8e5DI7/2I/?=
 =?us-ascii?Q?KiNPwkMcPRmtqosIMKNLSqmOSM5akXypHtSLaA9QhAL84/EgxZzlspooLfBP?=
 =?us-ascii?Q?h6mxFBzOOWiYv0FHpfhXFKNRv19+VKH6rlpQ1wMy6qnxRLgmt/XSrgeBWPTa?=
 =?us-ascii?Q?86+0TqIh40NrOTR39f6hNYWSXJjdSiBatlDmPxgYyRbqVpNB1sdKRf4c2NlA?=
 =?us-ascii?Q?Z6QY3CFBtR673f9XiTbTODl1OH88Bt86lxXUxaQsOEGuebGtEsEZG/v2ypH7?=
 =?us-ascii?Q?yAjuUCCdzrh1j0UuMXgiBVQf3u27U7HoaVJ2BYCiU9r4zJ7jme9upiDXMRRC?=
 =?us-ascii?Q?aJ2a8gV0nOoXY4BpObCFJvBZhJSjn8QpuqFsbWMJLvhMxJYfxYERzYLRRuTG?=
 =?us-ascii?Q?KZIGN1mtvHKLUm4kte23+2w9BLcR/LZ0oXxCAgtym0cxQYgpFh2YdGr1MoKg?=
 =?us-ascii?Q?JnP/N4nZmGjGsIZJmC8e0JwN7ZWZ6s/5xwbH1AbTwE44oJeOQyckxn4+6wIi?=
 =?us-ascii?Q?orBfYEAoVIM8iSdMbF8iewDGJLtYhaRYB39LywuTmu8mYp8WAjRq9ZBepKCd?=
 =?us-ascii?Q?xDUWC+42wtFmKSee9zgXHx94doPp615NLZkg+Aly9O3QESEWhLt/M3dT5van?=
 =?us-ascii?Q?FPL2qCikenAgXHgjo1OdNI2E0hpqiY++QeKmAjvrsLyDq3EYu8RkAdK4hh+l?=
 =?us-ascii?Q?MANtPV6Z+I4G51cLS5cPxM27DIYpfth+G5eA3bvjHIuF/uKMKpuAkqKoQM/w?=
 =?us-ascii?Q?7HXuNwMBeAkEbDQk2HNubU9oHujzbCLDeYv8TOBd4RumT9Xi35c14k1dQNFA?=
 =?us-ascii?Q?Zl+TGW+OQLaE9oM0gvqkWv0F7KX+LwZagdGviQKrmvuJqehjYQd4AYWsr7wG?=
 =?us-ascii?Q?uU92JPuuhgIWZXx/+Yxc6VySdx+kTaOihXzs5n3huL+3uHyzXls84jCg4YA3?=
 =?us-ascii?Q?wrzgtXplNobpqQlE1Rwym56IapykghhWDTCIxwe3mhgGI7nf7HtonjhXP29b?=
 =?us-ascii?Q?dlce9LD6tDGqJeKO3B9eRERGMqXeYEddLqsO2gj3mBVDh1NyVXDAUcEpuur7?=
 =?us-ascii?Q?7YeVT6FdL8BbkzYObN4RiDTVutWHBIpxqlQ64cWvR+KKoOGUehMT9LahxlXJ?=
 =?us-ascii?Q?xTPDY/a7tJG3qqmqExg3cVme1m8gWK14XUmLn2TDp3b7/2FTKN3Ty4+0dNDR?=
 =?us-ascii?Q?BkCLtaNvN8PEE1jl/xu/8CYskVjvtz2nJ34N5Cfi95AhUb/TZ8oydCV3cyuM?=
 =?us-ascii?Q?YEM97knCCuv/E2FnF9GRDoFC7jz/bvqdGW9Bn8ATpVgbJYlN0KQNPCaRrt2Q?=
 =?us-ascii?Q?NIoJmB6Q0X2ao+dEPpz5QXJH2E1lNGJLdzSLCqnHfTbhbLxFHquxKHalWwqE?=
 =?us-ascii?Q?bqSDfh6scWIEEn5M2cz1QJIqCCmvTGnTpUNoHn+FDCGLFtC1q1U3DgXmvFLk?=
 =?us-ascii?Q?fmtI7dHtMRb4SroFcnQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab73438e-7e93-441f-58f0-08d9cf7f3775
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 12:39:15.1931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVkq8usVuq/i1BFyOYoXZ2enZZZPCR7WEVo7m1xzQPVDa+SKTmqx7mZcn4wbLPyP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5038
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 02:08:36AM -0800, Christoph Hellwig wrote:
> All these bus callouts still looks horrible and just create tons of
> boilerplate code.

Yes, Lu - Greg asked questions then didn't respond to their answers
meaning he accepts them, you should stick with the v4 version.

Jason
