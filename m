Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9B22853E
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgGUQZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:25:09 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:14978
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726919AbgGUQZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFH0aWIQiXCqS8QMn4vZqrtavYjzm2UzMcgeZhpp6/QVzSHh+mQn+yu/YSl8VX+NstRP+Ojn+TMxq+kUC6t548mB8BjyYIr2OBUtWFYhRRMIphEGZNAYsLxW5H9KtcoddRwiUYwRNPWtzuzzw1W3rOOoC9JV72BCZFtoZuE8kvx86rTW7Z3XClXMcO06XwQQt2k5PtT/AvcHreXZLIIuXw5gS92KekLueA/5aLVlT3S/UF2vY01/58gamoY6VirxU2ePcheSzqDI5rp+fIsjV5qLf4muTfZ39uWtv60zm9BHpzvVzgvz8AN0Wj6u7v1b3zV89485N1x7C7rRaK0/PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxIUqmVcJjeucPujZ3oAX3sWhQPvniTvHgdFbarLwdY=;
 b=TEyiwujcblNEemy5oegVVtOe7W7UZYu4owL+NVuhgYMW3zjgMsX9RJYjTwBmucjTFldjS4jze6tRUc9I6yCmoEcF/wZlkK3fp4eUP94m4y52Xm+i4mLp28xOK6SuNb4R4GYiQK8tkduqLloZ3eugk3OGvGLqIVdiVSi1rVUo72HavabUyZ+d1fNk6ufCla0pPavc+nNYGg7VlP7HPTajEMPVbhQuh/Q88dL60HWgs1MgL/pSB4TnV/drSOEUeEZqwce2qdL/CnVsf8rCxvhTGr+rjsJOfCuUkiGWi+GVtzYFe7wpwdnh22AyThN7Ky4E5zxC1/e8HZ+iMQr7L/Odyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxIUqmVcJjeucPujZ3oAX3sWhQPvniTvHgdFbarLwdY=;
 b=FdaHrvVgvZgWejETQzRG+5SsRx9886kN969sjeeagfrLLasLt5kq6x7cx4qItamiNBpy3FctAZsEc0HPI+pyomv4hXl+s3+UqDCP3zgrqIfBycSSCG0qBRgIsn4c8mfCQ7NCuJoOMMFp34erAX6sdp4Z0l033mxqIMNtXh5ehrY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0502MB3952.eurprd05.prod.outlook.com (2603:10a6:803:23::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 16:25:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:25:05 +0000
Date:   Tue, 21 Jul 2020 13:25:01 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to
 allocate/free dev-msi interrupts
Message-ID: <20200721162501.GC2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:208:160::42) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR13CA0029.namprd13.prod.outlook.com (2603:10b6:208:160::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.15 via Frontend Transport; Tue, 21 Jul 2020 16:25:04 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jxv4f-00DGaQ-GT; Tue, 21 Jul 2020 13:25:01 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15196007-01a4-4df4-f3d3-08d82d92a02c
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3952:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3952B7996A24D99A1BEB8891CF780@VI1PR0502MB3952.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tvd7/H5c/IytsPIVME8EwHSiMLoAbjf2suVvYSgsrIgnMidYYTJoqcBAB/4EgORSUjtscraVTWy2EDkVTukggcFehxc828p1JsbGAsid+hf6I0dVMEOxSyQmjbWY4/WouiOR3EYkBhIgOZIhLh7vjMRLz1UzgYMGgTUcYzgoxy8cr8tM/JY0cnxHK0KtlFLzSHaWp5bsCLQbH35i9PtUZaQ7ZczSXyCC9EpUtqhRUKmspK3kyNuSlFmIG9CmOvVa8DIAhPpPkQHZeBq8sASfmI0o6D2+WEM4Tan/pcF3R4reTsVAcyc7aaisxZAIXcOY4NcV2Z9RBSHK4iiAPlr4mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39830400003)(36756003)(86362001)(5660300002)(2906002)(316002)(478600001)(66556008)(66476007)(26005)(426003)(33656002)(6916009)(186003)(8676002)(4326008)(7406005)(83380400001)(7416002)(2616005)(4744005)(9746002)(9786002)(8936002)(66946007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: enjRqkU2/KEOmfS0ROVqzO0KNOcuClQIMccQKnBdV4ptmnV6E7illlW2Pu43JGQezIiJ5do/MwxxIKA05D6tYov5qm1MskkjR09pFJi3U+iO2MGCKytzI5IQPDaa4vnTFACO8dWBO4vk+b3JmG86sUHG9UDGxqMqT7CG+YwXwv1cWVlGQzjCAai+0xkAjW0/dsLlW/TTQWD9K221H8qjrMDasY44VHiM9Ibva3y/Bog6BP1FSmSUDRBeJOZdZfn156aaLFY/KZ6foEUGdMmlb70gi3w/TBWCaogbiI+w0ydGZ+3Rfm5hYlGqE0gljaEED6D+o2ZsRW7j/RUgBjlmn+layVgIbHrYrv9KuM7XjcBgL6Cj/oU+EeBAW73snjol4fidbN8R14vbAgu0kQn70iNo+MM1dPyXZdL+7+NWvBcuTKEhPAw7qj8yinG7oikYOHaFP92T2p0iybw7Xls1U8xlVfHnnOMv/TxImazZy/g=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15196007-01a4-4df4-f3d3-08d82d92a02c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:25:05.0859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwFLbMYHvWy1dfO8Lt39VNdX8PiVBAlxyfsca9pDMeY7oklJQU2zKDi124nWKHWpyw7YeUXwVur4r9BaLTkh6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3952
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 09:02:41AM -0700, Dave Jiang wrote:
> From: Megha Dey <megha.dey@intel.com>
> 
> The dev-msi interrupts are to be allocated/freed only for custom devices,
> not standard PCI-MSIX devices.
> 
> These interrupts are device-defined and they are distinct from the already
> existing msi interrupts:
> pci-msi: Standard PCI MSI/MSI-X setup format
> platform-msi: Platform custom, but device-driver opaque MSI setup/control
> arch-msi: fallback for devices not assigned to the generic PCI domain
> dev-msi: device defined IRQ domain for ancillary devices. For e.g. DSA
> portal devices use device specific IMS(Interrupt message store) interrupts.
> 
> dev-msi interrupts are represented by their own device-type. That means
> dev->msi_list is never contended for different interrupt types. It
> will either be all PCI-MSI or all device-defined.

Not sure I follow this, where is the enforcement that only dev-msi or
normal MSI is being used at one time on a single struct device?

Jason
