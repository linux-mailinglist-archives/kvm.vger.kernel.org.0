Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00608493D60
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355513AbiASPke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 10:40:34 -0500
Received: from mail-dm6nam10on2080.outbound.protection.outlook.com ([40.107.93.80]:16224
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240248AbiASPkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 10:40:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUCWvCwJ8c6FBJApxpSSNer875qv1iMOIVrisDhBBtfEHKG+sYrXS8Qa3V6cwjEuC7ONa2tUvsYowWeRtY64AHMtQ/kbqf5f1h7MWhiK3a2LIsZJnCOmb5qsXcHt7cRBN1svUYnDJWAnxYVZ4JTbtei481qkv3PM7H+f7eXgZxJQMzdqT23UWfJ4FYpqAad0uInriAFgQct22lbTlXefeDAAKo/jUjVCRSFGz1PoceWfftEo9Gm94YQqc+/F/wbhmj9kR1KJS3RyfoKBtyCRYJ6zjZ1GFadFkpj09JABO62GpDjoqi/FebH6LFwapm8tETeQcAQrrQuKDpr/tf6/CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1Lw467qGK7oYSQU1tRyUapeCY0cSFQ0BzkhJ9tYaAE=;
 b=NFSKkxfhF6k17ml0Mw5I6sGcvDa5VNO/hhMIevea1lTuCg0nLWngbV536BBCw6Rm0gH+pfkMGqOfeEyp5b/6mbXdU3wyXxDPrPh472Ih23nQ/GWiier0vOk9dxFovXnSpzIUmI/egtSOUIA2ncgl/po8jBWcWyGbOotCrjzdN2ZgNILef1XxeY9hjVmE2H8YkqU/acBcKNylLKpDOsMlOdLzgPbFTf84rW7wJP4ufWxAhoKpertoUl1uey1/uyFQrSHctLcSqsvbts0cuSvOCKugQtsXYBRgBKSu4akhDnpNgYlogSaoMzUiSUNDlHGrO3t+qaqIdlEJVcajuCSneA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1Lw467qGK7oYSQU1tRyUapeCY0cSFQ0BzkhJ9tYaAE=;
 b=RIU2soYHhATWhNe7Rpri4Y63cih8uV4TaQ5WZryyQjspyFaTHwPyG0bBwIoTy9LJmdgCjECPyh+I3LksjAEfLDjsBFU5wiKX6evsE7/K6kcUM/RHSvLTRt9lpUtv6YbIMFwrtf/bzakLaQdKjGByvbSSQfB/56vgiUfeshBo4ysO8/pVOsCbSWRlM62B5d4yMMDcGNLO67Z6rO2MwX44XY4ebO8RHNu9LRa/GsY+ToidIXbXP7QSfZ+KkTNO0Irk9TtZH5H+prugDfPbnb6eRcaXtbtxxGVV6tnon4GYru7bUQjvnegYWTCjTQrWXCtDBq8nOk+M16qEC8hclZDGSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by CY4PR1201MB2549.namprd12.prod.outlook.com (2603:10b6:903:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 15:40:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 15:40:29 +0000
Date:   Wed, 19 Jan 2022 11:40:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Message-ID: <20220119154028.GO84788@nvidia.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
 <20220119083222.4dc529a4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119083222.4dc529a4.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:208:160::46) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3dc8d37-2151-4bf6-9e17-08d9db62054b
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2549:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2549DAC6C4465333FC7FE406C2599@CY4PR1201MB2549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRLqpB6bzUDlpbxUjyL+LZhjNxwIoajL4/gag5BZyJrGFNYRExsSJV3ck0SfkiHVGuklQtRrosVkyBYXzjyXhkkysWAs8OuTKDSEcmJkA4CQy0G3O8W4TSXSteR8wi621dlYc0SxnuqGVw1xAMUm0ah6iOy6gxuJB+ZWEnR10QaRvkYVRcWd5gOnyvJylF+Pl6Lrxr6BNHwbIHqFLxvtHXn/4jtF5o+j0/EkqL15KNK9oYT2PocXUVgekBSPJD+pYnOFaAHvhMGMspuwrf53qCib7x6xUPWr1k//sIPrBorORHtoI/pKs38RIxichgg5W6qCYzm2B5oX/+KAstyA+C172b++88F9Sxw97TgR0xKZ8CDrsNxgMOgNzxQV3ACJ/L2O6UunMIEFVohgB3L7u/nRhWUsZbBrgmWoTnXPClxfEQhEi5WRmbkyvSEMIO3yxUsSRkvIrPJF3MvjuHihSSXu6kjIsTHOjXialy0AmBShs20jiyGoZmNBx/VLUP1kR4e6hLhdQGjBsP310qUzyendRZxWGYtyfQs9C5lAlL81alK02PNrQF0sR61Dh8kX0kAXi1T/36oQK0E53PDmEaTVbkttvUWKyfB44Do86PCRmeCzd/pAhsMIoR+bWHLr4PT2p7fp/LfsvrXKzHp7Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(4326008)(6512007)(6506007)(6916009)(26005)(5660300002)(508600001)(38100700002)(83380400001)(86362001)(66556008)(36756003)(15650500001)(66476007)(107886003)(6486002)(33656002)(4744005)(54906003)(2616005)(186003)(2906002)(1076003)(66946007)(316002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JS36MBhwMA0LtnZmu5lHJ2GVVjirKBppbu5OuiLFFFrTf3YMC6X/eTkSwMJy?=
 =?us-ascii?Q?/zJM+ssmnnHrC1AlwW2AbnEqnJGqMdx/qdBmzTdpiSJkziqZXzzOZMsIHqr2?=
 =?us-ascii?Q?VX+kPNe3h2RmmBny2uX7jMBFL8xPMsUNyECPS1feQYmO02GB9Vobynh0xTmu?=
 =?us-ascii?Q?6wkBS+cMITUutXm/W+l+Bt7JQg0aQfx01B9ceHTbFp7VWoL1dr0R1BGuGAbk?=
 =?us-ascii?Q?0V8O3mHKxC9BOp8RFA61FPkL/9q5IZ4M7tTbGgB5Fwx/24+d1ZQQAliGoT+N?=
 =?us-ascii?Q?Sn7bQDN6aKYIqsOzNMO7uKACMXSIpcn5570vXFjbD5LBqbtgWoRnbtyZzNRI?=
 =?us-ascii?Q?jVKs+614hsoR2XWrY1OUPdJfYnTqCH7Iq7RCYD3d+Nfr8bWacoVMP/H/Xklv?=
 =?us-ascii?Q?CDqYF8u6MtO23S8jkmousMEV5eSPyktmcgy/3tmgxc0eWMUoefceSJtpsQ0V?=
 =?us-ascii?Q?W8//VTQhFd0TgB2HucdN95DGnNwlytjdvE3xjRXzjY4yMSW5qS6bLHhHRYBU?=
 =?us-ascii?Q?DM7zxZdDRrCcCDcSKSKJnmSHU90yJMee7kOANNFOorwrrt9ZI9WeY3gG+6qm?=
 =?us-ascii?Q?w6ZN4oMUxJU12E/+oCwx02gBkYdPGkIWN+sGvj+SfA4H/uj/FcLhcxIJcj5G?=
 =?us-ascii?Q?kh6o3BmyBd0aW9wvEAjWn7gOYSiTOaixcOLuqnCV6DFx33flj/ib17HlLsEV?=
 =?us-ascii?Q?hth/b/lWhVfnYNqoExIQCERpAzQWa4oECyzu275mwxMFV6KHMJ0J9GEd88+x?=
 =?us-ascii?Q?0GmASAmx38xtpFbA+oeerqyJevZQ0rE/xyHWxZj+a3GEOQ4Ka9mDmS+/2HkM?=
 =?us-ascii?Q?X7NhnpkR2D3On72lIshCImbw2/GmRNaQE6DIPLf4a6Rtf0st3PUK/BQj3YBf?=
 =?us-ascii?Q?utlJBoBZHpzEQOlNZ2MiozKbh952hn4yXMge1n/wHtVOxraNbyrZigMzX4Ez?=
 =?us-ascii?Q?+sR/K/T+BM5vc7PfTF1PoQBSLbYs04UqEJIkeOo1Ob8fVs4MuQElRQ+T3kA3?=
 =?us-ascii?Q?jdMsXREY2F6bNOqpaZ592QzmF4SzxtprFZKpRQYOT3p/c4/MBtgwvL1Zkeq7?=
 =?us-ascii?Q?I24csuGoCul433FQ8TFHvFQmNoxFSS/d0hrNBuet9s+ScsBCaUY+ib9us+Wn?=
 =?us-ascii?Q?Iywk7Th20bNODuGVDqjsmvI09qdyQt10CfD2UNCdCk0owI9iWUb1DdBjRhv5?=
 =?us-ascii?Q?vsKwMxrAP6/SonqlrFxjmLxam1yncGiTHyH7nyX3TdXYw4YPYV7NIu/CxwfT?=
 =?us-ascii?Q?9Ty3BQRSO+cABrf2XQy44o3gDwrb1fAvricYDjODu6gTdB18HnXb6nHfm5Q9?=
 =?us-ascii?Q?KCXvfsxAf9yAns2qtI5IrpJ5V5x6lKMPkBl7jYR8oCXKwffrp40YP1IvViCD?=
 =?us-ascii?Q?aJy6Gu1nBfMiv6lVb+emXMoFW2FbIfp+1edmcLXP9YHR5sat4tWxe2X09PXu?=
 =?us-ascii?Q?HPWnOMe/s1OK571D7XQgNPPavh1fLUDkXywkmLj/YtGIr4WObUMI2qlQq3PQ?=
 =?us-ascii?Q?CDEyuS9nAKNzXRmMjhMW9CawLVhy7aNlnfQQ6CEnOjMKhjp/OCLcSm/jL7Z4?=
 =?us-ascii?Q?ZZZTMg4h8KtcsYda4nk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3dc8d37-2151-4bf6-9e17-08d9db62054b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 15:40:29.5036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8s4yBIMk/fOLScWsTbgDDktbLcMqBd70AODdSSCj6Y1jiWFHAmGuhDnUYE1qX0e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 08:32:22AM -0700, Alex Williamson wrote:

> If the order was to propose a new FSM uAPI compatible to the existing
> bit definitions without the P2P states, then add a new ioctl and P2P
> states, and require userspace to use the ioctl to validate support for
> those new P2P states, I might be able to swallow that.

That is what this achieves!

Are you really asking that we have to redo all the docs/etc again just
to split them slightly differently into patches? What benefit is this
make work to anyone?

Jason
