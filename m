Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA11D3BC2B3
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhGESf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 14:35:29 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:9386
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229743AbhGESf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 14:35:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3dtKpdZ1Kt0kvC7HHyut+FNJZbAQpXToUD1POCFfB7bhHZxlZk3E52iLz7TMKOlMhS4W84HyObDvvdCFi2puYTuWs9u6HUeXGkrorKqcOF3/ssYAUBD71dvUmzNTP+HXgajqdZJvMeGqTPL+vNliznJ9Z2ymcfRDb3bflPeMs1V1vGwpsgpLN5o3wMR+JDc+h6wr5LB6BFIXML/NPbR3nCYDGM6mF04HnuhScnylqP6G/nyrR9LnRnqxZQ/hxBWU4TxlFywJWFR0g2vavBHmqNK0hUyDufiEAoZhIma9ey2/gOC6wVPT/aLDE2VE5NarLPqVEl3fReL873Ailp9+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uD3FEhulHgFrpWBm2IlCZPFPUWEg4ZFQFpw8GynJpqY=;
 b=a8wlblpt771bdC7wVrP8ElSPYodHaYD2Ag8ftRcYSdIwB3+u+DPZ0d9xBY5wanPdxX8wRqs/S4K14jS/FJ2KQM/TQywXamXHu3XeivutuKt/wWiovbLFxMkPOGJH5z8QcNv+S3xDg88nJAkbtpwonL9or1bGj9my/Z081TrBIZNKLNacyRK5/ZcaZ/szG7eQHwvJw58zaIwtyWRUJNsWMG9tr8Zb9eab0i2j8dS2V6ZDoIaLck+w4LyPv5SzOX9+Nq/wCYoxUHr6s4d9ogZ71jUk7j2rWGya3HdqQS2dsS0jjvLe5P1gl9ZQtSp/S/5ZUuAUXCHbHqsCMmeg4YlTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uD3FEhulHgFrpWBm2IlCZPFPUWEg4ZFQFpw8GynJpqY=;
 b=OWVscWuCJSUf9S5Q1txCoAb3TrYnKV0F4JLtdnC2ZUa8FZ748fLi4cnpxlaIiEiUWT3VWgXfTdDltJe6ZOvv+bkTQ0JZDzu4gXEyAX0eXxTfoDhIKVoFMWwwoLG9ursIe7xUgAgCCUPMmBZbFcfYyQrcTAA2urEciXdLD0VCOAKd66wXBTUwFqsstgRiiQFkbeq6PqH5Qo+AxapTKRkPZhyUSXYt2o0aBITs4aUxV+hzx3XSuIAnX9udNz75B5vyMeEucONNYPs6bQmFHmcbz8TL1sFfDrbGBdDAfeaMJfNXwwRge5T8RUtUoJ1IRQY1fkkgwiDQoRp1LHrA/EpIBA==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5126.namprd12.prod.outlook.com (2603:10b6:208:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Mon, 5 Jul
 2021 18:32:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 18:32:49 +0000
Date:   Mon, 5 Jul 2021 15:32:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 1/4] hisi-acc-vfio-pci: add new vfio_pci driver for
 HiSilicon ACC devices
Message-ID: <20210705183247.GU4459@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20210702095849.1610-2-shameerali.kolothum.thodi@huawei.com>
 <YOFdTnlkcDZzw4b/@unreal>
 <fc9d6b0b82254fbdb1cc96365b5bdef3@huawei.com>
 <d02dff3a-8035-ced1-7fc3-fcff791f9203@nvidia.com>
 <834a009bba0d4db1b7a1c32e8f20611d@huawei.com>
 <YONPGcwjGH+gImDj@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YONPGcwjGH+gImDj@unreal>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0115.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0115.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 18:32:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m0TOh-003uwF-Hz; Mon, 05 Jul 2021 15:32:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 061850bc-399b-41e9-6f8b-08d93fe34aa6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5126:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51266208F182A9C39F2B02B2C21C9@BL1PR12MB5126.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Baor3fNb1Z4Vqa9/gXJAMu4tb8wcAxcj4WeI/2uv+ZbKZMDRGfLd4hBfCjPUtPczwBFAVl6PjiQKUnLMbBy6WG3UoF8HGQu8tZY1jbDHUWKGb0IcJOT/cnu1o6+FZVWjKm8TWvVpnWrCr4dfadAOSC/HSQLUuVHcSYtjk9wckyk6g/0Db5Cg0cd5Y68NByhAgQ0kSZgWU1HspeY2YRAIUBI0vIEcSlIrrM6/tzeI1WI91I5dTk/VxwVNAy/Ew71i9MnRypmFqR8GLUdhgW0hfon00+AfHyGShnHsgNJOs10u54JofOLrghZUX1hBK5txJDHU8tptG7i7F5glXsnN6cNzRYSiZ2yWJTyOAZDHsjEIrCcMUjzxFL6WrC5jxnLblTfly1fmDgtBIFZDQZEUIEiutyWLuE4ly1fiGvCqhg5ewVwiCiPTkNB+8YS2JjzyblJ0EVIYeDKwNXsbIPDzrdRA6twUEb3O6B+kaZgqvqSbyjFX+snr3bWkD/KenPxSejwYkHQRS5PpVZwQ5ppwlD8swMnBM0+6xZOkOCNpQzSOuXFKdd7eRPig3aPzsjJVdW4Mw8LPpGmuY/oK6o2aeelxijYEvsQPJA29YLqZChNuIyLnOSXfxCAUUOYk2COb289l5xC9emkNRy7kpeos3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(4744005)(1076003)(5660300002)(33656002)(478600001)(4326008)(36756003)(86362001)(66476007)(7416002)(66946007)(2906002)(26005)(186003)(66556008)(54906003)(2616005)(426003)(8936002)(316002)(8676002)(38100700002)(6916009)(83380400001)(9746002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vw2RsYO9eXbJs5cQauIrnC7Z2942HV3rubRB09mzjD1GEaIXWdoP0sgPMWNm?=
 =?us-ascii?Q?PzJXlFnoIYY2WvOeFl4N3xnF0LNyffTBXnBp+q33nnmO17i2Q0hY3nxlfXYP?=
 =?us-ascii?Q?yCwZuA9Xuo/LVEE7AUeQR5VoCs8t08aSsbLhIpamN56VZt1QhJCqQGcHFeIu?=
 =?us-ascii?Q?5EigvsEyp0T9JDGLDfOoBQc6phjknYtD/e/T9RZ8S1MMTOWzhJZR4S55rgjc?=
 =?us-ascii?Q?Ljq+6L7n4P54tgN5Y1L4+uc1vPSCYCoA2BAEQ9giFjgrIpyv7YUuWJN7wYLI?=
 =?us-ascii?Q?rEhUvpXmXcwi0H3l65EvTd4k0/c1G/nWQnaUmGIdG1uTXTPnsRqWUzWR9JQL?=
 =?us-ascii?Q?Tjd82nKI5ycipRuVghnSvi4Ua+IjzdaWNKoqYjkP4oEU1gb3m7LHe94W5mIG?=
 =?us-ascii?Q?d+SxYx4wE0S5zy36v5FwzuNTbrVgu80EJsnniPThaYsMgtQUCuuYF39waFop?=
 =?us-ascii?Q?Bniw2GBF8cRKP1qSAhcWAAXwD/ztz/n6GjrKCa/haajvObCCHaOVyl85brIA?=
 =?us-ascii?Q?NUzVSg4GqPQ8OPebfT32ZcRx77BOCepN5Zq/OOHbi+3SNXjXXJPl4Uq/Pd2V?=
 =?us-ascii?Q?QD4Ac0arENVzfFsF3aRtx2TECTyDevmLxjkTKRA9+gt1uxMydX4ZXfDNv+R7?=
 =?us-ascii?Q?4qO+49Sja7FVMYRnyZu5bBNqyiLosgPhwftw+44rCHVlHuKYWsuDUYZbXWf7?=
 =?us-ascii?Q?iNTtBZjJOGjOkcGFDQ3lYUktAnA+/Zu20oz3/2eDjXkTb2lBl+2Ion7XfpId?=
 =?us-ascii?Q?w75mWZe0ZkKM68pwbjSmS9VG5OSSV1+SYoUhQiQZUUttkpzQN4OiDklYRy9E?=
 =?us-ascii?Q?Cuta5Jvum1Yl2Nald1x8CzXHPhxoUcpuFvQcZzwBRZ7Tawp2Nn8v0z0r6Rs6?=
 =?us-ascii?Q?kzSD0Un6OqjsqSAxQS8plLADf9biU1VRSheuOf7OmJrEsAi9wlnWiJ0c4UGv?=
 =?us-ascii?Q?uXKhRjNQJR8rZf2U05TDbMqLQc454iL0YdJrVqXNcoMgkQn2IQRt3+D+z743?=
 =?us-ascii?Q?LjscpozZ0/6W6s21aRMJmMIl9hiJT4lw3I92oCwOWgtmvYtXxyKlkXXqmtEq?=
 =?us-ascii?Q?skADOQ8C5Jj/yn9SL5FOBWEg/NdjtkfqDUWFqgkavA8+OtYcIUMuZIt39tQC?=
 =?us-ascii?Q?XdGFdOKVRDLP9waqstNZX++as1P3+frkYfJPRXurf6HeeDfHHTWO60okf2MB?=
 =?us-ascii?Q?z7QKYWtisWe6QQJ2QAAsrV/XX5BpZeNbXA9TIFOprHW5cQVpRsniQm1bnoNZ?=
 =?us-ascii?Q?s4J4G1D1EuylRR/KztsxeRmeqvtft6NmaVI2Ye8HpfLcq8r2sm3gIdyn35wo?=
 =?us-ascii?Q?F6LEy9PLD/1czQKUL0Ox3YTY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061850bc-399b-41e9-6f8b-08d93fe34aa6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 18:32:49.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijJtPgLp0zDYFUDj42ziRIjbhZuU/DbtsldJfeavsR3BfrIATv3nkAVlAc7hrgeL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 05, 2021 at 09:27:37PM +0300, Leon Romanovsky wrote:

> > I think, in any case, it would be good to update the Documentation based on
> > which way we end up doing this.
> 
> The request to update Documentation can be seen as an example of
> choosing not-good API decisions. Expectation to see all drivers to
> use same callbacks with same vfio-core function calls sounds strange
> to me.

It is not vfio-core, it is vfio-pci-core. It is similar to how some of
the fops stuff works, eg the generic_file whatever functions everyone
puts in.

It would be improved a bit by making the ops struct mutable and
populating it at runtime like we do in RDMA. Then the PCI ops and
driver ops could be merged together without the repetition.

Probably something that is more interesting if there are more drivers
as it is a fair amount of typing to make.

Jason
