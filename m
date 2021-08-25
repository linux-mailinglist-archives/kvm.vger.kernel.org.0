Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4244D3F7562
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhHYMvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:51:36 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:43136
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229759AbhHYMvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:51:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUQxUFcRVF/oHWmNOyEvRo6IKHbjIOfml8wRWhB0IGdutc3HGQJJ6HW/LEkrNUtfnHJ3hewKgPG2QKVaKpbPlYKHU+RkBec7ehNx6G+ywwGAajUH0ZV16AHTmxoHjtspvOkMcAGAitlrepsgO5IvnaiH3OsagfFyg+Lm/RhRGMQj7JIOlEmtTxY9r5oB+2jAVEqiEs7SP9GUF1uEuIQKqGcwJMLNJO91KI+8rmbJn3RoWAgx3upS1oQENQ0WYOdZEenq2+AYa3AzzD+K2uyCV5xcgbyLEn1juVuoc2OC80UcS5xDadC188/f8i2LHFMfc0fWQ4x7J51r4rIRpRw3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krjqcMq1Lfh51fYNPcQJhSzsbztyIiMbdMdZ9L2TWe8=;
 b=JBM/DcZzine1opZuW2xpa5Min/J9Fxvj6NpyAMnKMJhYxuvh0F4NX4J2eLysoy+xjb8RchJLQZs7ctAkr0efRB6S/ICVBK5s6NxpVwXswVK26GQYbjZS9khPcspajO3iTzii4c4Fpcb1LOlPw2CaE01RkPcXwT5lBLM6UlNei6Sa5F5UPTOE+SNPLwm754pKRhC0MN3/DE1CMI0Jz1mQOuO7btZxWxTEUQimlDYZh3J5yz1wrfiiIQD2iFHvDp2raPfQ1zF1cyVLZAt44fVN9kPBAKW5Pi6d7s5Qd+Vgii+sDAhXDFBXpbm0J/Vm5pOEKJ53vgT9TQQ9X1WO4y4ZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krjqcMq1Lfh51fYNPcQJhSzsbztyIiMbdMdZ9L2TWe8=;
 b=QVS9qU2xdBPYmwkQMBAKbddtjYH2ryHhKiCTWdUmFF8rKvQRSIzEANgyfJmIKh2E9+l5QcrPEFpj5rwfEaHB9rMVlzIfHRjbWHljZU1nG0X1AIl0pqYhuoGu2fVqrCZKs2KGN/LkK6EAffgOq0vKrhbS1AgHBGEDXUn+XILnX8xKbKsl0S5oO1H8UFqgkmikilfolMZ+hjRfEhF3XZEGWAWRrvKXxTZ5F0WOa8vmpSj9UPoz8hJXNmP64KrDpuJfHZ6ykVNBGoO3QmU5HYs8ZUOhBredq+1nLEF7iCweLRvqTmdJqR/HV4ibqdVta9u2xOoa1nGLADzCVeqXxqUymw==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 12:50:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 12:50:47 +0000
Date:   Wed, 25 Aug 2021 09:50:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825125045.GE1721383@nvidia.com>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-8-hch@lst.de>
 <20210825001916.GN543798@ziepe.ca>
 <20210825053237.GB26806@lst.de>
 <20210825122144.GV543798@ziepe.ca>
 <20210825122400.GA16194@lst.de>
 <20210825123454.GW543798@ziepe.ca>
 <20210825123742.GA17251@lst.de>
 <20210825124538.GB1162709@nvidia.com>
 <20210825125022.GA18232@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825125022.GA18232@lst.de>
X-ClientProxiedBy: MN2PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:236::11) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0042.namprd05.prod.outlook.com (2603:10b6:208:236::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6 via Frontend Transport; Wed, 25 Aug 2021 12:50:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIsMf-004tEG-3S; Wed, 25 Aug 2021 09:50:45 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c96fcec0-2211-4212-dc01-08d967c6f4fc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5269F3D4D6F0E7B74A68C3C2C2C69@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: muWl/AbU6fQ6+RtcOJaoagTpxq8Rq6sy0hFquIOCOTj9my6A/YW70FUtq9JY/n+K7xYeuxovhjE738sCW9pzN6UJTaM1ibUAiqgo6soC3srCmsVci1ZogxiQ5phYmCCn/9kaw+6tsDC1b9wsIRAu93X21ypxReFw92/RRkTwoacrIP1PgYsEaa1nr1Beyu1Yd6InbrvnVwTrIniMWeP2a3i02/3qUaRM4b3ufueGCVCLUT/zNzZUDDcEqa5dPGTAlNAqh/00SGuabveukoqzWW2jDTPrzinyOXfKxrJHh0/CimVPRuji9aRq3QXprbhT8WoV/42iS4T4Xo+FGU+Z23SlE8u4zRPsUvK0nZo0eJxtLFlpJ36+8HoylzOAKNeX9oYIsKg62O46KxvlnmiKgiLzwSCPh1Qo3ZpgWTaXVrBU8WkMtoZzTzmKSD0CS+na2Et2UWq4GOupR38EVNr6C6RM9Aax3YLjOzAtaO5cqpcZSpHQjlfTyddP3bD9JCv1huIW3OEp1Cqo4ih6XvzaJYLQ91KNErRCDkc+A1N+pJFUHvL8w4GeI5WPNVkv3tA27GoIvTlN8AUM7lyJymWbv9PtnJQk7HghlTWDr/9vGZEqs/NoM8GUv9mUYXOBMllNcZ+jAEkCtEH+MI73Sa6M9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(9786002)(66946007)(26005)(66476007)(38100700002)(2906002)(66556008)(9746002)(36756003)(54906003)(6916009)(86362001)(1076003)(426003)(8676002)(33656002)(4326008)(186003)(316002)(478600001)(8936002)(4744005)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIhNJnjfe6jrsW2oSOuIiASV2CxP08bqtcVXPxMnA162EJQNdab/6SB4jcs7?=
 =?us-ascii?Q?8ly7+tPTqNujkDgb3f8RPqmncO0lKs6bTOMBzV9DT2gwNbc6qXcDrZO5M55I?=
 =?us-ascii?Q?+emp+DvyRMsQM6F3TKNS5QcKIy7HuTi4nydGaZ1LLiDrDV0VzpW2p5KnrOeh?=
 =?us-ascii?Q?xYnZU8aU5+zmPoK+qOkuht3ktxQyWep0xHD0PRxnyJO2fse25JRW1ddSyzQN?=
 =?us-ascii?Q?yGI8nI8a6UXU9cR2RJwIKzuoa/J8pkZ7UlprL8m8tSLtrhfimUVpMcFrV+zI?=
 =?us-ascii?Q?AnLaL85a2UAY4J1j7W00UrvI9m7f1yiH8NelfTCxjUDX1KQeAT9Bl8R6HKeJ?=
 =?us-ascii?Q?iBUjSeBcc5xEcClG2rud5tuOcE0uIM3JIddKaJZkmCQFWb9sphX7ey3A4ZGR?=
 =?us-ascii?Q?Impar428Gc325u4XWI29DWxZ0cB0fkcOhaIe1dnjqSNs2YHpRN9XBsGVuL2f?=
 =?us-ascii?Q?z8tViAinLajSN0nyoB91Toe/YNC+Oz+8PWuQXXt+TMSEIyw6a+yu0Scf0Wff?=
 =?us-ascii?Q?LgcEpSAmQLHfT7XDrx1lFJvDhMcMIYn8QILee4zlaJ/aJGoLWhGf780xib/R?=
 =?us-ascii?Q?15joh5PGSmMu9ID7dDzoHmV9pywQzAUBY2O4bFeUOyJmzmNPGDYgl88KdmwR?=
 =?us-ascii?Q?emz0Tj7jBB11EBcih/38NPByFZdjHISdE7nn3xJE1vYnj7ILYPzoW/QVJSq0?=
 =?us-ascii?Q?6xcEZOzwny7XZe7IKhGh+8AQvHhbF1nN/KRo3G1Lc8dST+Xzn3aDALnbNuB4?=
 =?us-ascii?Q?z0e7V1TnUumptDoxuuIsvLAQLVvrbjcVdsz/JMoZpU06kc4ohMBJK+FOMnNB?=
 =?us-ascii?Q?uYOD4B5zGkSCex2VDWkYruqG+pqqkVKQ2ZYUfwZ86zu0964b/XkI4WAjJpA0?=
 =?us-ascii?Q?bJ1VUZSIhZGeGOLVOy/dgFgWhBQttV11ptNh92vapzFVhDM//eOrhhuPFT0M?=
 =?us-ascii?Q?/M/dB2U4ZBBQZvF5ut6p8n83NHi+UZxLN0Z7ZMQeNmGOsz9lM+V7DfK9/PHA?=
 =?us-ascii?Q?MfHy6Sqzo2rs2K3PWGyYkXv0lxbE37Q6XNMR1dJYhPnnl6NiHrfGRMXpnzTA?=
 =?us-ascii?Q?Fdr8hnEzC8IJRvCk2FcDjPVrnt+ND8NxgF10cQyRiSLonbz9/GUf2OujVu63?=
 =?us-ascii?Q?B1giZx+HpJeG/0K8R0fSTQigeYrtJ3X70htqgZKSuQfnGlfYV6GTiinumLfL?=
 =?us-ascii?Q?TZdmpi8zM+ML2hRQkCCmrjUhX4ef54JkrdFj4Zhy2UxmmZ0Ocj0ft5mrp5W6?=
 =?us-ascii?Q?xu9RAe4EBbKtatkW1Vmk1YM7/eYeHcb6QTB5WtgabQwVqc0bLFWAiL0hw/ys?=
 =?us-ascii?Q?2931LIEm4J5iq8lyyr/V0y/A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96fcec0-2211-4212-dc01-08d967c6f4fc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 12:50:47.1029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NlP6QPDNqgrSlcR0zFOLSrgWBX1ZrTHNY9Itk8doN1sosf6y9QWfpiuo7zI1wInD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 02:50:22PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 25, 2021 at 09:45:38AM -0300, Jason Gunthorpe wrote:
> > I think so, in context of a group or iommu function it kind of makes
> > sense emulated would refer to the page table/dma process
> > 
> > The driver entry point can have the extra words
> >  vfio_register_emulated_dma_dev()
> 
> Not my preference, but I could live with it.  Or maybe emulated_iommu?

Sure

Jason
