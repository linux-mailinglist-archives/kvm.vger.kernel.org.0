Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95939337A4F
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 18:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhCKRCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 12:02:08 -0500
Received: from mail-dm6nam12on2084.outbound.protection.outlook.com ([40.107.243.84]:50976
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229796AbhCKRBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 12:01:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/dPG7SIIgdYg1QDFpjLei5OBlKsR4/I5raZuNWpA0Khc+fFqUnJ1F8Ocr9bA99xWlbTlUiDPgkDQ38uLbU/C+bvw40owitn3g13QA5XpJ5tX8jtyPgG39FnDUnWDIn3/MahQvg7DN6FwkB3bTPsy4uI9p6e1ZbZ2wH/B38z4FACkExxLLD1UaUStYNLVAysCm6kartaK0aPxBFW2QwEvLjIdmMRsV7AD5HG8KFA4OTmTof8IDo2RKN2shFQHsBH6zjVZ0BxyE4N6JWc4YwNJZsmzWD9DulikiB4pmfLYG28xIWboQWDQuLtdosUGrnhxzUaC3CQ44lRxEJFmfgcsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P68ki63yygGwBVLLKhdhPWW68gDOzl4FkHE4R1/wrxY=;
 b=WUMrbkWHBfsipzyZUB5ZC7pOdHJ9W5ikQAMttDBmEGQWWfOgCa0gAE96FOpBGwhUDJNC64Z2qoOeivDCXICUdonSPi9DiWh+8cCSJYcjE+MBPuW3iegCByPb09szHzvKZgPBI2Xzh8Vti61HVv+j77M8JtRN2iMTykoTAz+poVG/+wj6JHgC8XOp9c+317bQiVEjbbIiggESBIT3npIWPfc4mAnltJV0qTzbGE0xQH+2Jx1I0LRAXcs71NqN5uBzvy/M5S1hWeNzvTJVHMbK7jC27MWz1Zxuudo+ALo0rxUeSqu8KGE6Ei6LdkMKfkVaBSYQKMti4Pt8VJzISEFvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P68ki63yygGwBVLLKhdhPWW68gDOzl4FkHE4R1/wrxY=;
 b=LECOH41l3f88Lj1lFxv4oPZDV4WZQvdk5Z4Vbyx2QuRQaW4Jz099tQnv+mI8NrtcrjehEtRH6m2iM20uUzMPV3UA/lPHYIP1/RTWTgaTEf2ha8RZF2bUSlr0Dohj/32cx9ds2RwoP8iw5AvETgg3/zcRB8azFfRRs423x2MGb+n/xElwLDAZ8rtstfLCjwqN/eFIzDvJZ0FZprw1OOU+n2Wh/MKFQERY18xouQ+3GvsWQGxJzn4gsd3VEjEvS2lvfnsNNOwWPe7oFZMz9E+tUx+nVKkh8owwuwfdz72BiM2FAjkxk5dHQTX4m5/yD5tsXUMcivjFDIGmsEfDuFaybQ==
Authentication-Results: ozlabs.ru; dkim=none (message not signed)
 header.d=none;ozlabs.ru; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 17:01:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 17:01:46 +0000
Date:   Thu, 11 Mar 2021 13:01:44 -0400
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
Message-ID: <20210311170144.GM2356281@nvidia.com>
References: <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
 <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
 <20210310130246.GW2356281@nvidia.com>
 <3b772357-7448-5fa7-9ecc-c13c08df95c3@ozlabs.ru>
 <20210310194002.GD2356281@nvidia.com>
 <7f0310db-a8e3-4045-c83a-11111767a22f@ozlabs.ru>
 <20210311013443.GH2356281@nvidia.com>
 <d862adf9-6fe7-a99e-6c14-8413aae70cd4@ozlabs.ru>
 <20210311020056.GI2356281@nvidia.com>
 <73c99da0-6624-7aa2-2857-ef68092c0d07@ozlabs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c99da0-6624-7aa2-2857-ef68092c0d07@ozlabs.ru>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0030.prod.exchangelabs.com (2603:10b6:208:71::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend Transport; Thu, 11 Mar 2021 17:01:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKOgy-00BLjZ-Q8; Thu, 11 Mar 2021 13:01:44 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7d2ed6f-7c5e-4a31-fb55-08d8e4af5a75
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01062B0ECE1B24AC8F5776B8C2909@DM5PR1201MB0106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVB5/BV8DixHprtAAq62XlEhrBccqVHeEGA0BELruoVXrcNPnv8fBGrTDwckxjjMeBnVVfnjQJuiRoBNAK+sKsODc7fUFwCiLNzfTTiwJ2tJ5QfLoZNLhQ/19KI4IfmL1io0aK5FPtco3or8pVgjlDLif+WzSg2I7L8SL7C1opojknGLQeHTIveWX4gHai/lu+JzsBoy5Qqqmpicesq8WQS6mVyQssNxLAySrzwNhmutjkIvZu2xTgNrNZ9cmNN3gSt9Fop0BAjLvZDVEznWcFd3foy+y7TkkwHwKB3pkGfN6o1KHqFDW+a4z4D7a5SHVN2s4udV6/vtTJbyWtnBPyYEu4ercteGBDR9xRBhJWH7iLYxMdAC3k4GOaifbRHgHPl/eCLCJaaeH+vPr3/CfAoTQlYoJeOTaZUBiY0O4Rt1T6dJwTd+tZFx3yNUs7DzzCl2semyvtEPvurAPiOqkaQ73LdPinEPk0l58e3o3tBWCypqs5vqYYK/A0d/Vd7/5QryQotgWn34DdRrNaaotUTkfSNkdjXoc+nL5bb6/YV0T4EuGbvNGAV5aO6OkmJZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(186003)(4326008)(26005)(478600001)(2616005)(5660300002)(36756003)(426003)(6916009)(1076003)(2906002)(66476007)(86362001)(316002)(9786002)(66556008)(8676002)(66946007)(9746002)(33656002)(8936002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hc2uuc6cSIuuOdliUlZdQCrVqzdiQ9KSSebeu6IOJUuZP58pLLQp+X35kNEj?=
 =?us-ascii?Q?jpLqSY5fZ3grUvBFEzjZRhqYPxiX8qQBVl/tHnyzrPxxKbG8uhwlja2eruJ4?=
 =?us-ascii?Q?wW22H+vFB2gNZIRNHR7dpOPDKrlbqeprBEb1DkU4EjxGyabT+OeL5bzFnAWg?=
 =?us-ascii?Q?stbtSfrMnmxkuV8qkeOrEBH1JE0IEnbxLtJrqooja3zRVR3J4ao7LTyDqcRq?=
 =?us-ascii?Q?VOBDReaFXE2LyxX4V/2TK9+rweVQ14zeuV6pHccD68ooJ6O6iF2a1vur/vbk?=
 =?us-ascii?Q?Dqf84TB+0ZYmLnM39hGHG573CzwbKjsT/l6wskcWr7hIUwB/XmJ2T4ggDnLR?=
 =?us-ascii?Q?YlfzSQSSTda4UYO1nfa1oqQnUoC8Dl2EHhsrJnZudxOq5FCGb+iFn2wzt+ks?=
 =?us-ascii?Q?1Mz+OcTBJNhOUUXxnxGtg85RT8y6lQ5OpNlA0EDZl4Rq09/quTFEL0UvDtcR?=
 =?us-ascii?Q?AOhsoJsV6oEGEs85UMCrlORytboHfpPZYtTw3tWQJ4xAu83dr0H1J7Uj/XL3?=
 =?us-ascii?Q?E0biaRRDRPtfS+znAfTQsk9xg9py4Qeg5wpjEHbaSAEBtcvh3oboM6uqsZda?=
 =?us-ascii?Q?tgPZg6xgyrAu9Zcjl0QpTzM/ZJ3QPWUZT7/6yPJlt6tKjoUCBfNKAy0MEOLe?=
 =?us-ascii?Q?u/NF2I0/Yx8JWltJYaG9hvmL0a/hS3D9iHWe86bmAueGa83736ZWWk/ZJOEt?=
 =?us-ascii?Q?dUPcN3VqX7I/pn7/YgYnkMkITetZ8rFXZrxCeY3PZ3DMQXU4dOZsyVNDK27u?=
 =?us-ascii?Q?Zbk3z2BOcHlGHt1v8HEHVL0+9H08R5rYM+fM4ZwPIT3oNq8yD4kxPK/TXnnh?=
 =?us-ascii?Q?kxIrpRU17CM1iTXMFiXZDkuc3ykwrw5iEyB8M/L7tvKJdgm/dW2wKZheYAjD?=
 =?us-ascii?Q?JVhzOW85//u1KAwWUwiBTyZcP6yGG1xDP5nsKSvVunaC+wnLCqrbfQxdwlYV?=
 =?us-ascii?Q?XQ1C3jqDPbpXxFzXOF4CA6MXtnyfwaqeBrWJt043kGYPX+FN3cFz790tTHl2?=
 =?us-ascii?Q?QOVf2OdUiX4IYzS/6DajfTgwzHhdANAu9vY0lK74H0TcBy89rVHiNlZ7zMJJ?=
 =?us-ascii?Q?/am/wM2l+FCnNpQ40Du4yxfKmMNeZ1Y8K9JeZQBWLBQQYWlx7wNRAyawluQo?=
 =?us-ascii?Q?9oA//9BUcWqtrBHrNBJhbjjq78+iONWN7o/wCUeUgalR1QaIZ9oJhJSKOjQL?=
 =?us-ascii?Q?kVxb42V/Qr2Yl6EDiMC5TmA54o+V7vhk+/Lp16l6kBvegMVE1PhvBDhVIfTE?=
 =?us-ascii?Q?BvnJOoBR/hioYi8EO6543OMxkbRgyY9p8BbTZCjZi/BQlLrahjQ36nsG582E?=
 =?us-ascii?Q?m/gbIMIXyTrKZnUbCdCi2KQyjc8GyLpWGgLZ7F4+9L1PAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d2ed6f-7c5e-4a31-fb55-08d8e4af5a75
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 17:01:46.5823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4tm1kjAZK7DUedCA3Xg7UuA+gQgZDwXGKxghXefiPjoQaC9+Ax6BQav7aBQZXoo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021 at 06:54:09PM +1100, Alexey Kardashevskiy wrote:

> Is there an idea how it is going to work? For example, the Intel IGD driver
> and vfio-pci-igd - how should the system pick one? If there is no
> MODULE_DEVICE_TABLE in vfio-pci-xxx, is the user supposed to try binding all
> vfio-pci-xxx drivers until some binds?

We must expose some MODULE_DEVICE_TABLE like thing to userspace.

Compiling everything into one driver and using if statements was only
managable with these tiny drivers - the stuff that is coming are big
things that are infeasible to link directly to vfio_pci.ko

I'm feeling some general consensus around this approach (vs trying to
make a subdriver) so we will start looking at exactly what form that
could take soon.

The general idea would be to have a selection of extended VFIO drivers
for PCI devices that can be loaded as an alternative to vfio-pci and
they provide additional uapi and behaviors that only work on specific
hardware. nvlink is a good example because it does provide new API and
additional HW specific behavior.

A way for userspace to learn about the drivers automatically and sort
out how to load and bind them.

I was thinking about your earlier question about FDT - do you think we
could switch this to a platform_device and provide an of_match_table
that would select correctly? Did IBM enforce a useful compatible
string in the DT for these things?

Jason
