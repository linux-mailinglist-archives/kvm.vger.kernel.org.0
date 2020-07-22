Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16B8229F1E
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 20:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbgGVSQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 14:16:45 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:35202
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbgGVSQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 14:16:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/PdJOZ3XZgau3SAm8kiNuUyQgdDJdQM5ad9X1T1J/guXHJCAMcSYaprRLwmoga07dUU0/bYo6oJov18PxOPzhhfLc4b6lQM3pIP2hCikmTtBqM1STLMQupE7ii2MmjjeRvd+E5h9D7uHK/2bkIWjOcswK+6eUF9taBH8D1IOEYK31+7T3WfFeyTngAi7lx5SDPyhQxG3jAf+iSxBHp7XKzK7pfLoJBFYHvJOuc27fpmJKnWY+p40KxB3QDphOI2CvsTnCfDbb8dJa8vCszXxwJK1EuF69gHDLSykYfNQBXssfYMXzuYpdcmAs0HrWvKbXLW+dPTHy4eOJXFq1hUug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7SHrnXVdr6Ck3wqQol1rleTH7vmMemyrDjgdqnDvMU=;
 b=F8tgll6rjvwbBddD/N+KokFYWU/bLC41cPYkdVJb9XIWW2Mx4jcFQfrvVE2jw2rbEjYqcygj47HYqTxqm10uUeW2elQlrtQS7L2gBNAM1hTOZ+DgKIgT3PD4d4ihTivbLn+eZWw5/mRW/kvYaGcfh5RKPacOW4y2YbSThWpbr6JSt1k2UP9VWz0wfaBOSMNrc6X+QTlPY092Zkkrs3fV4QHJ0hBvawiSggXM3Ap3G1cmG2FIU/6tC02255ZZW3k+xF7s8u6MWBJXR+cXziIEM57I8JMjQ3K7cX6aYPG5eSoqWswSCb0mCVgUYn3Szl1lLMop8LG888xVkSKmFGtxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7SHrnXVdr6Ck3wqQol1rleTH7vmMemyrDjgdqnDvMU=;
 b=hwfZCG1Xq0sB4+yJqMiF50ViYjIE3WhqSyAkIM7AHoL4UR4TzrL9eS5KaJTOqxxZ+RTaMvjTJiKe9Bis2Vt2w9LFLWh9occYqv+/lgVeTWJSOd2jAQU+DoLazgrx9pJkolSlqXjjsDMBiHcdzatF4EZ/E/8r7/qGKUVHgWF2SiM=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (2603:10a6:5:23::16) by
 DB6PR0501MB2213.eurprd05.prod.outlook.com (2603:10a6:4:50::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.21; Wed, 22 Jul 2020 18:16:40 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::4025:1579:1d10:fd4d%7]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 18:16:40 +0000
Date:   Wed, 22 Jul 2020 15:16:30 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200722181630.GM2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <d0ab496e-8eb1-3365-8b2c-533cf95d6556@intel.com>
 <8655dcee-58e2-73fe-a2fd-ca8d770103d9@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8655dcee-58e2-73fe-a2fd-ca8d770103d9@intel.com>
X-ClientProxiedBy: YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::9) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by YT1PR01CA0130.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Wed, 22 Jul 2020 18:16:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jyJI6-00E1Ix-W1; Wed, 22 Jul 2020 15:16:31 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 259bbe25-e332-413c-58ff-08d82e6b613a
X-MS-TrafficTypeDiagnostic: DB6PR0501MB2213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0501MB22138407E17EB0DEE5960138CF790@DB6PR0501MB2213.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/Ry3+Yur8J4a7bWzABieI/s0XFsgvO2xWe5Rh6wR7k37W47VFc4FqpL8wRcRlGNqyfXf5qkmTxjbvLZL85enTdrF5oIk8y+MqOHgNik2NYuJLSDDQXg2SCir+NMRj8SDkOUIZOEp1h5RwfAzCdHZ5n/HgqYRWcrS2d9FaWd3+QbXXeLhc6iACr2ydgC9bg7FNGI/tkhpyMJQ8BxoBXBYHtSv+HnxheiIhi+v2PgysQpQ6y/G+130yJyQdj8PSiUJvzUfSchR12PFGu+DOa8j3jrXvYigdN1bMRh6i6uUtsJoj1gs0PoEIF3XYnv7K4OBcxaYL8308tdj14nCQH8wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4138.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(426003)(5660300002)(26005)(4326008)(8676002)(2616005)(8936002)(316002)(6916009)(36756003)(66946007)(478600001)(66556008)(66476007)(186003)(9786002)(86362001)(33656002)(1076003)(7406005)(7416002)(9746002)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1YWNlCiGRg67NMAHIFPxMpP2YzUrKrPgWD+gNdk3ObI6AJeF21VtMVjBhbgeLdhO66dTFzwEJl6rINMtJq5strWlNLfefcrYLiEZPTH0Y08DdFpocqdMG2zeNA8BRX/eSAX5XteP9Nf3iXCseyGiTw+M8k8Rg3wWD5f45VjxaAATgLW4EMdjVccpiZffP1YCP3/BdYFOpjFhR9VuubO+xzfu4LOKz9mZREFCEy5eMAkKJmFLDRtReXDj67HJ/4xmFLBR/M36sGlz55Rt5AGel991OV053N5bVqsiBjtMshj78uUjfGOeSq2Ba2v2eo/qZGPWHkLRO2T/lHOYUt0kpbrUa0maOyEUU+Z3QLNWFODd1+48bcF+hfhITq8iffLLYJW9FbF5qFJR4rtkBdPjkDsDlfGkvj9fxYG0j5QPtLqVzLHcRRqr4GX9i+4AfnXVFfHfSi6uH3IKny/KrtdOHYkI0Bx87VV4ekMwnASJJJw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259bbe25-e332-413c-58ff-08d82e6b613a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4138.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 18:16:40.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qEzAlhD4JPZ23XtRmYA2VWfBtLMtb5dI86qq17ohBi3bxK0UKEMwrzUXpXhSTZJMvwLbLcFguufBjp2w+EPq6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2213
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 10:31:28AM -0700, Dey, Megha wrote:
> > > I didn't notice any of this in the patch series? What is the calling
> > > context for the platform_msi_ops ? I think I already mentioned that
> > > ideally we'd need blocking/sleeping. The big selling point is that IMS
> > > allows this data to move off-chip, which means accessing it is no
> > > longer just an atomic write to some on-chip memory.
> > > 
> > > These details should be documented in the comment on top of
> > > platform_msi_ops
> 
> so the platform_msi_ops care called from the same context as the existing
> msi_ops for instance, we are not adding anything new. I think the above
> comment is a little misleading I will remove it next time around.

If it is true that all calls are under driver control then I think it
would be good to document that. I actually don't know off hand if
mask/unmask are restricted like that

As this is a op a driver has to implement vs the arch it probably need
a bit more hand holding.

> Also, I thought even the current write to on-chip memory is not
> atomic..

The writel to the MSI-X table in MMIO memory is 'atomic'

Jason
