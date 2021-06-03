Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE539399FB9
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 13:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhFCLZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 07:25:35 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:63457
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhFCLZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 07:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDl4BySQlp57TX/KcIBLcml5Fe3AUAcrGBJxYF2pGWpnFigw0w4gC9woCIqWDK2NVND0nWBTb5H1bjCPqCPa7rZyE6dsc7n8RQpFkPfLvxlOmEenTKuNqfymPEA/1v7TAMHtJC/1qRdMDEBk67+drt+Qx8eFGkvWHyV/Qd32YYdnmlvZuUfcGOO459JWVeN2n9y4xXxJwBJusfYE7ws7TwM4XBPE/XnlV3EIcqejobKaDWcE3sIZiPP4BzhAuaX0tjfrxOCR3sMaFNJhC+RIVkDqY+lMnGZYQ702t0g3FiqiNYpIe7685QPpT1lggLr37N8YeTGsjYDYxQtFXHPQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R14Ky4yTI2rDE9TXH8iXM89SEfc+vS5j1q158/vVTT8=;
 b=fxrXkSr87ODcvmK1MR1uznFcrWjFRDEUTodD/9jx+YQxKvqxexX11gGBdLq1DCz3witXIGg4pj5Ab86Keid6/p+JX4XUBD/XkICXMbrLQYgT+pATc6AKLSk1OKX8StXrgb1fUsDiIY8ofq60qIsajMPPrGx89uaafSd2DpMafMyuKAzRKHg2gF2hcr0SgCiWibPpqJluJe1udsNHBAanRoIPNNSDfg1NZOtiwASYzO4JMnaTyAP9sAkdZ51kk1LzL7XfrXxWN84s1+o03vmvaMIXoGsqtZH9G/vbjtWCTVzyOtvoMZM6aDdiCQMgWaRJhw9u0lzFIu1yjFjmKFvcDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R14Ky4yTI2rDE9TXH8iXM89SEfc+vS5j1q158/vVTT8=;
 b=RWHkQJKZB9zbSYkJL3NRJb0LqpsY+VXBdAfjwuIKA9lfa2XeddfpeTehC9R493VOEbQutFAb+cT0LfEio22DChxdN83S/5x+rT9SlHAdEx+gQOk4vwbVZjp7C0vCNT7ZGWXH0RtChs0SOgQKZeF+uqj/Gk/I5WjaBHxcrjkUpjjVwFl6/kEgZWpJKArn3gByZwivVqqlKmrB3TmHa6pIe6Yp+MDVYnbS3LAsgAPEX1Y2H8vPSWy22CBokPtlacQ7g1OrTGXMz39ok2SabclKwwt59oCIl2uqAimV8LNx2jnl3BwTT+s79F2BMqJ6B0uA3+lMT4HsSObEZ4SBe8vLNA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 11:23:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 11:23:48 +0000
Date:   Thu, 3 Jun 2021 08:23:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210603112347.GO1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603014932.GN1002214@nvidia.com>
 <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:207:3c::34) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0021.namprd02.prod.outlook.com (2603:10b6:207:3c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Thu, 3 Jun 2021 11:23:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lolRz-0013KO-1o; Thu, 03 Jun 2021 08:23:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 901146f4-752d-4511-de4d-08d926820e83
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5521BEC3420349428C8D4DC6C23C9@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvck4F93WK6xlP0McqWMiCWiY2uBm4gSzOV62VjBDluYbcTGN6p8z41COAkES+1n2AWJeBwlLKeozNpaEtNpW0/GKXf/WqlitnmO+9dLx0EP8jqHz/oyq7U9HDm2VXOQnPrqlDMqDXptMebgkOX48FSON21mO8zsPHs2j7gvcWyoqt2o0XJvCjzOZ9+r759Lk84bi7RWaDJqaQkcupEokRwlUcSRF7raqZn7TJwOqK5Ljq061W/8aDW2vimhfUftpds8EMYqU6IXy283g03bM4GxQWShcdBA8PIKqxWksHvb+Jp6zTcBlkhaf5LEuwFzGdY6bwFUAZ2VvebcWv79KtpNvDxBkYrBe5L9+qWhq1sQ0us80mD39Iff74/3hkiIC76KkJeZD4Rzm04VaKBA+s05edcMFR79Q0WAQVYXpdj7MO1iWkit33P/+prdB6CpM5AYt9evhhtknHeanuq6PnSouDwzu0Soqmlj70ESoJDGVD/waJ+HUeZ9sC+lX0To+Q490nOQ5hAmbSnv652+6WA09F1bQTlNucbSFZdFjnc8doV1Zbl/orjrsz+QhdENghSg+riZUW6UvanvFXC+hPm3jtiT5zVPCXfegDgox80=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(2616005)(426003)(26005)(5660300002)(478600001)(4326008)(66556008)(186003)(38100700002)(33656002)(66946007)(66476007)(7416002)(9746002)(9786002)(316002)(54906003)(1076003)(8676002)(8936002)(2906002)(86362001)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NTIb/0QrMVs+lw6PBBRrq7LJsrfKyojK1+RLXvnCNmy1EXW1U0rwbtR5Ml7D?=
 =?us-ascii?Q?2nO4i9ekkFG04pAKAxrqOZTncjeFMrek0OwizWojqSI9OQGu1jXfTb1/RXQA?=
 =?us-ascii?Q?2bXbEedrPEzTPMViTgzcYjW7LrgATORMGLJPeizgjZNPpuzSgmABsIxKSW0D?=
 =?us-ascii?Q?arB/IIWTYFrrad10WCGBv3gCTqX30bX+RF0gdVw71s5xwTrKB7YwucikF0es?=
 =?us-ascii?Q?aY/wpwIV1/xLlLF5ys6dRDjmmZkkFhyCw6oN7mPMD+kLr39qzr7WKLAkMHsC?=
 =?us-ascii?Q?n5Lym/u4rcjnrj5w4f/4kKkI9Lew0MuUlvYBZOw0iJkqcj1lxYnAtIBqw1TZ?=
 =?us-ascii?Q?C/9fhxRQnmRO58gkSIdWU+0TqyBiiGFB9NB2HkWyDjkEnOuIPjMAsMDOJXi3?=
 =?us-ascii?Q?c+B86EgM2vaCvrlzdtz/47C9IDQ0g/YaC4PLEkHAwK3MjeL59GxHjzYQSyor?=
 =?us-ascii?Q?9MGhlws+BHXgzauRUD9OV/0ZoZKgNlrtqsdz12xSKaf+m3wwHb2wVnumLoa0?=
 =?us-ascii?Q?0SVZREj1UG6O5Se65p7PUZWdTm1YvpEMpsH+0YsznDq6sNu/XJfrAER9BHXw?=
 =?us-ascii?Q?t8EWVrf+BZdA69BOOAePn9GCBLyQCA2fF0YHBbKMlLsd75WdpMbntAEK5JqX?=
 =?us-ascii?Q?CPviWGp8LI7xXhx4mn8mYIZZhvipA0ZgYXFyQWj/KExOxjnbLfBBrHuGyure?=
 =?us-ascii?Q?cOoudlQvuhHzaNkW0a9rk4NCEbku2qGKkYTMv6qKWy1mh7Z9kSrpbN/x4t0x?=
 =?us-ascii?Q?oeLuAt8D4gLZHFVsQd9ATadyLe5yxcN5+5uG09TjZGY0BeLca8DB2flDs5oE?=
 =?us-ascii?Q?+rMlmKUCsNtE2VKIl4wfCUeNBHNPFMu/smS8dlHF7Ty2OtpXQ4bsDw4lO1W9?=
 =?us-ascii?Q?bbRhtFviwv3PTiAhphoBVRQJ8k3bR/0XweVP7i4OZ2nB03YOgZZiSn+yqYi4?=
 =?us-ascii?Q?wxQ9a6U3Xu0IjpB2sy8G/tVhpk3E/0mwpyIcl80OgrCpX7OEb8CaBNgKAZIA?=
 =?us-ascii?Q?SrOP6dRu+340xQrl/b72p9s/xYxOT8ANBDqeAa5W241rKHRg/M6Br6+kDioF?=
 =?us-ascii?Q?1uzWnQzzZIqDrIU83XyWyf8w9FR7ksXhS32fOJq185JqVqM/+Wocs11p/LnP?=
 =?us-ascii?Q?5oLZgul55HNB33F107ucNW2NON93fqOy7ikPXYe2+qhtirRX0x3bYeJatXgf?=
 =?us-ascii?Q?ogAZ1Hzlpke4Gunv+FhjDOs2AZyfFsdku50m0kC1AzX7KMF4uN3loDXSCoP/?=
 =?us-ascii?Q?L28Tg5GCY0BOf//f9mLujI4PMxr3/tQWdV0qi0O+kR+FGRMY3QIa9NpU2zAw?=
 =?us-ascii?Q?2yVZMFJprhZYDldG2bykxaiK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 901146f4-752d-4511-de4d-08d926820e83
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 11:23:48.2873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVdcMoJipNBdN8gLZ5Efo0xO64dFrqPCS5H1iUG8tgyIdRgVx1zJcIhMwzp5lj6L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 05:52:58AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, June 3, 2021 9:50 AM
> > 
> > On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:
> > 
> > > Jason, can you clarify your attitude on mdev guid stuff? Are you
> > > completely against it or case-by-case? If the former, this is a big
> > > decision thus it's better to have consensus with Alex/Kirti. If the
> > > latter, would like to hear your criteria for when it can be used
> > > and when not...
> > 
> > I dislike it generally, but it exists so <shrug>. I know others feel
> > more strongly about it being un-kernely and the wrong way to use sysfs.
> > 
> > Here I was remarking how the example in the cover letter made the mdev
> > part seem totally pointless. If it is pointless then don't do it.
> 
> Is your point about that as long as a mdev requires pre-config
> through driver specific sysfs then it doesn't make sense to use
> mdev guid interface anymore?

Yes

> The value of mdev guid interface is providing a vendor-agnostic
> interface for mdev life-cycle management which allows one-
> enable-fit-all in upper management stack. Requiring vendor
> specific pre-config does blur the boundary here.

It isn't even vendor-agnostic - understanding the mdev_type
configuration stuff is still vendor specific.

Jason
