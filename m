Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753BE3D69F6
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 01:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhGZW2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 18:28:47 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:8416
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233693AbhGZW2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 18:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzJy412bcFOvVVcQfzBW/kytc9+HBoJgtWkL8NFZxNxPA8brMYCztIeZsIp/l0JyIgacoSYNKLJUxmN8Z7g5EUnDLfPH8wKmFdXs2mTsvmDRJXoDYUGntJ6HhXfRXdU/vlj3R5ftyf+4/yJjaQVxzRs/+lKqkktuoEWyMLBSU95jACBEtWmqM+8/ehf3LyONNPGTO9FJzgl0MGWitMjitzw+vaEE/af6FBqhO0jehMrSmWZPpvmGameW2V3WKf4/4WuC9jYYfgIISUN7Z8yrzttqMeuvaTpMoys1FhmsuwXDc7/Vw7q1zgsccGWQPV+RT7RRVHE2ZkoYSFZB6Lj+VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEhpT5bttducPbwnf+WUCLYAEoPpXXsPHKraBkoD5Ic=;
 b=SzBjGUtOHJtdBaqtK6FoO4oFyLvYxSqfpx/L4guF4DgI3a8UiLBNvL1u/EyC1Gsh5sgW/lGMIWWM2kSmgnz78Dvu7i3xLxo+Q4yABf+lxyrG9mv72cz80EbCKPD3dE98gMh9GqS+lbjMqACFU2GUTJ+aiPgMUT7WTCcB3hYNDzSOIlLh/Ki+qef3L3ZioxpfR1/CBVLy3KWG6x0PYL/Yry8dBIfaXIk9gvBJjeeoYj+6d6tNOlMLASlJEwRap72Ctkz/lgr/g3ssAsqxpSf2JRKMtM089PEFUUq1VzGF2MFPy8pkEhrCAXXaKMjgrZm69MTh46ki5I/nBFVmkaRs8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LEhpT5bttducPbwnf+WUCLYAEoPpXXsPHKraBkoD5Ic=;
 b=Bn7Z1dHY4cxvPErGoZS6Y5Z6dXDcQPkwWBjKQnI1bWL3sn34b3Q9e6J49kr5FEC8cUGV1s4GW4twnLT5Wk473r/ZzuX8kF9aCEOHBRhrcxnioJbhqrT2vmth4sZVt5Y45Y+F5yCf8Eiawmx7U1UgIhKQx73choDdkzJv1rdANZDiKJXJHO6ay9aPVChK4mIJpFNlPo99NS3M7gZCEDsT51o4TBTnyo/o5xW5/TBMWT0n7tkU1k9AwQS1/q5WsKMXSzJHYTqR603c5JT5zsBp88PDTTgjB3hwc64oLpH8PoJB5Vs7H3TsirGr5JMZ15m10hwm4h/8YS2RqxJl6xNh3g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 23:09:07 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 23:09:07 +0000
Date:   Mon, 26 Jul 2021 20:09:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Message-ID: <20210726230906.GD1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de>
 <87zgu93sxz.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgu93sxz.fsf@redhat.com>
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0279.namprd13.prod.outlook.com (2603:10b6:208:2bc::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Mon, 26 Jul 2021 23:09:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m89ic-008qf9-BN; Mon, 26 Jul 2021 20:09:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b63a366-8e41-418b-fcee-08d9508a5e9c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5349368ED1A3BFA44A6C5BD1C2E89@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JjEdP1exn2QjnKBel2D4ADbGTyJcI/IC5lFOjBfrJ/4Ga434RttC9y1JefsNA2MtKKhBIh3DqHxedojWQ1tXlJH/axcHzuYuGtK3aeup6x63H9lP7AJsNVk2/i82d2tDSBbUDq63wOCKyopP1lNgUUxf/Gz21/d4QFVCIUYuOvvDVlJxzwYhL/CElPMsihO4Y3UB0a1/r7QJKBTw8XwLyj7ZWtdQNjq6Ll218mfbNPExzwM1VUlCdqFv5jXutB1/PJKdD+HG3hPkSFaV9YNXVjeSZWm62Un7IMx+fHUkDxugQhuq4KRho+hHm7JosJrA4A4ITTZ7nf0FXflq0ySFSQw/radZKvGhTSl6P+XUh5Fa85QaMrEB82jrvcYzOnc27TXF+E3hUeD+4vrv7EVeyzRXgJhPu7B3MHBncvy/fPXxDf+6hwKkYFFYglWLOA6ZfoUWoKvpZjSBYjGRI5CzRb2JVc3Hc/T6zhUdokMvfzq63RcFMwhQan6WrlBbHdH3DAj3f+xxu+aAYh4U408KmkPzBqUoMdN6lMGDFdherBCUCVKcD5aAQopu4BlNvQW3XuibUB3FdDhXZlH8GaTR1JwwhM5SbFKwFo1MTBXDhfz1Z/HpFJW+YB6YwRZxtq54GgQfMpFyOlIEJPCuYEaagA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(36756003)(86362001)(186003)(8676002)(33656002)(4326008)(38100700002)(8936002)(26005)(5660300002)(478600001)(2906002)(9746002)(66556008)(66476007)(66946007)(9786002)(6916009)(4744005)(2616005)(426003)(54906003)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4NGluKdc36yVLyODa/yF/cpf4tk3gI3LS04mle3OWQtNAFgxat42osyXZa+?=
 =?us-ascii?Q?SQ4GgxlompxxSFKqVNOLufriYlTJ/G4zdFnrweR7hw8aamrVkyTawkREyH++?=
 =?us-ascii?Q?elKSajOvrL47inwKLj9NBKWu/kraGOQazXbvdJnJnNFy/6dn1PliXAprq2It?=
 =?us-ascii?Q?CnVMpDXCKomlzKsRTgkmLZYQ4CQzi1n8Q+ageyo1cpopYtoUdG1KOLJRBBYn?=
 =?us-ascii?Q?cUB7Yc/s7AKGxypAxrq9OkfbhO94SQXtXYLheXBU6etAAvyyQxQsmhmukTOJ?=
 =?us-ascii?Q?jdLI82fHCZC4Td4KbgT+q+UALJyWc/O0fa+tQrnw0s0EkGdLQYTx0ON6akXb?=
 =?us-ascii?Q?3ZmgzBe6yYwJDGeqpOh/TCrTVd+qB39CstrEZEq03XwLb/e9RAgxuW0+RlzP?=
 =?us-ascii?Q?Qj8aN75ZO02Sep2IPcAOutu6PDLYRFPO9s8rVxvy7EjT8LWQfNanBMwDqXLU?=
 =?us-ascii?Q?/6I6znrjtYZgrq7jqcu50R4D8bfj/nQ1qK6KMMsEyHNiLgFBPbEnRiLRFAjg?=
 =?us-ascii?Q?KeS8TSPOXDOwyjM4vkx/oaYUL5JKymX2JUbgXciXkHTaSoYCK74I/kG/VzPa?=
 =?us-ascii?Q?pu7R/OAln40rHN9Bf1f8Zgx1xz3dxezzcYPpx92WMH9cvIKdtv32gX9RnKuW?=
 =?us-ascii?Q?ofZcKzr5WwGAiiVJi8gUKmh2OOxy6GpHbDTJgkFnd4c/NwyrAw8i2MxdTZBY?=
 =?us-ascii?Q?tBys/h2u/9Lz+f8xu6Vnz/Z3ZTZvZV6JodhPmpphk0zhiE/0/Cfwm+lkG9Yv?=
 =?us-ascii?Q?wFceERarNTE9oJKAUzlfMp54az2juWajQ8PWn38bJ3LeSrVyVcT+WV8tqYav?=
 =?us-ascii?Q?kIiauUmeIt6UMOgdpzwCDF9Avohcv+fJQlgEiVskPQbDwL2LbbmxNpLsWcug?=
 =?us-ascii?Q?MiG5+vbKP4iSip4IEwUibUeckyVmjVaMNlvtQSO9d4o/cv0f0TpjLw3tQHQ1?=
 =?us-ascii?Q?gQwCCi3ywOevOLXJI6KwBkQ2dD6j23QwL9MkCIKHZPPbTXYkB+hB86PJjmpH?=
 =?us-ascii?Q?UowvT/wqQZgkMJ+Z0fdDCErGrKEnj+PiYPSBkarmFxGGfLyP2zFMPb7Pn5fg?=
 =?us-ascii?Q?0uzgfzLGtogE7GZdqqHc/mqjCQ2OP1XJZKgrqG1sNS+AKVeR/F24bgpr2l1b?=
 =?us-ascii?Q?vdQmSWz3Xim/0gtNdI8GNalTyArbiTW7GUk66PjZ9OGifhdHDb0OsvwSnOsw?=
 =?us-ascii?Q?zHryk0Tanxtzz46SSgPfI6YmgEenc1qLz/gvAApTrNCxfUViOTkFS4g8XWht?=
 =?us-ascii?Q?iWDRz6v9XiOMc6lHpbtHjTUWDqEi2NYffLTCszsYIW+D6tdfg49OxVnaIAI6?=
 =?us-ascii?Q?eqOC0q+ciLOuek5v/gmxq1NO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b63a366-8e41-418b-fcee-08d9508a5e9c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 23:09:07.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRfF10E3+/VjNb9QL8aDU8gpxfkaWUnResPg5gJRPHLeMYZW8p7kf5q1WHfv+vS2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 07:07:04PM +0200, Cornelia Huck wrote:

> But I wonder why nobody else implements this? Lack of surprise removal?

The only implementation triggers an eventfd that seems to be the same
eventfd as the interrupt..

Do you know how this works in userspace? I'm surprised that the
interrupt eventfd can trigger an observation that the kernel driver
wants to be unplugged?

Jason 
