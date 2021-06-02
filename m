Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE16399656
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFBX2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:28:47 -0400
Received: from mail-dm6nam08on2052.outbound.protection.outlook.com ([40.107.102.52]:64801
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhFBX2q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 19:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKEgSYvXpOi61AsBJqkLSKaaFOLSdkvv01HfrR2b4N4t4H0bSuaoJn47pU5BZCezYoxoqMH5VydY9hFwhZNJeZBWhAEMboBoKtCvF1JFjsmMpg4u3Uyt0X2RstS7MibJjQJNsKgTosK5mpPFLYUyzaPXR4pknZuZYQmbbOp3jm6doyKPf2vVFhxMBVlpVCjy7hpF756wZqArQv8qe3KNbmg+N7FM5DPgzwy91sccsukiHpIUMbi1IrQSbhcqmOm2POM1kkUOUjobNONWH5QtuQyhxabKmW8VELLme+HqohHdC1Ec1KE5czHlin46BM7VYiGRjKJWzujRK/KpNqscog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZrdkgWbonFUe8/oj+jZZUaM12ytKCO0DBycev9Q0gc=;
 b=OE1fInDttkV6bOZ3tjbN+FFyCp22BPI6F0SKUhCIPAU18A2dBTzCAz6nD8nRghPRyp/KmgEUnQN3rfzO/ruLTWFBOkPl2MMNzuj95KIJB+TFJRZ/FG7Zy2VbBXZe6v3V3zU2IsFHvMqxbc4Bs9JBFwgf3yNr2CcFyJ3o8AL34y7lQMneMB422OcwQRedAUzWHBx1Dq4Mq1A4vZ6wRXqJoigvQjc330ahhjl+x1GlwyesB0QBe9rU9hz3km0yMyfRCXLhoHoYuVsYT4yHXW1BVbQKHcrx04920fezN4xCudgR3qsTce6bCd8a7KONwtzNWtQKFzkMAgUR9VAi6G/T6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZrdkgWbonFUe8/oj+jZZUaM12ytKCO0DBycev9Q0gc=;
 b=CR37NUVp0gaqpNCLOWYUZaUfW/9AojzRairE2G0Zh6oLCtn74+WOdn36C9tcpTc3Q9floWLsrQzJAkAoY4MoN2WmV9CkmkSEuiqeWJMtsmWLCDfyDnjCI6NJbX1DmUdn4PH0KeVibV2rUkvXApsXoUmmtdWJcWuH/hYmEp54dk3OmENVcgNqhr7hO6ir5fHPXJfN5Uacu8Mx5ChEfLejEZ2w9AT4TI2T+1kAMw1bOHbXEc8iJiARYtufUGCH8Wk4oTTAY8RVgHSFVU9mfXwbAo1xfneoCpwceNa8M72yEpCfImIsKUgfU/XuLTrV5r2quNvftoagkUipvr3gbhdY9g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 23:27:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 23:27:01 +0000
Date:   Wed, 2 Jun 2021 20:27:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602232700.GM1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601202834.GR1002214@nvidia.com>
 <MWHPR11MB1886172080807517E92A8EF68C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886172080807517E92A8EF68C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR02CA0095.namprd02.prod.outlook.com
 (2603:10b6:208:51::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR02CA0095.namprd02.prod.outlook.com (2603:10b6:208:51::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Wed, 2 Jun 2021 23:27:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loaGK-000nU2-Hc; Wed, 02 Jun 2021 20:27:00 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b5c0518-58d7-453e-5a8d-08d9261dec7e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53044CAB1A098B718433038BC23D9@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BU+zRYD9FkNGtHPmrbSKimdwhgH/MiQCyly4PIiEn3M6REBqA4Fw4lkl2k9R8Y+N/DPZuM29GtsdmXvFMWvJgjukFA1aG1i1g/IV2GnzMb/tj5OaJnrzp+EYtpEOO6AHhMJBmR8WQXoxxun1IomkwIDTvGADI7gtSfp4jI1T6kmvZCiFntHhd21I7A367dyrjUIjKi4QdDxbAOfXX6s7YxXJ8TNQE3PXQ5CeWsZcywCtWZKrd/zOkheM+nXTN202T7outfx/jHK4TgPVyMySAr8uT2oFvUIUycmhg5niwlL7oIs2Sett64+TNLgmlW6YB4xeCVqAYj6jpvdvLjjTNFNLgO5jHAygSJJklDJGqvMnLL4JEiuV10iXXI40mHYqTGtZrCd3ziXSR4p5BVIbBSXXo5t3nliEbcgSSU9MwfXSJ4/QF7N5k/8xc9WyjX30EjQgox30fsx/DI0olbVRrFLpB7w3LSn02rctTb6IhNhF8oyjue2nwUJIIWXN7/q1OJRtRIayFayHWpNWoinGNU9iz7epZoJJq5j5iO9t/G2fkR2TzvbUwxNRLpA05PBV5S0AIY1aDAYLRiCM8e0SEEYiihuMwBD4jqp1JQnLoB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(6916009)(9786002)(9746002)(8936002)(186003)(4326008)(1076003)(478600001)(2906002)(54906003)(66476007)(7416002)(66556008)(316002)(86362001)(66946007)(426003)(4744005)(26005)(5660300002)(36756003)(2616005)(8676002)(38100700002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/vtsiPMw8z7P9wAKGhALEjONbN/3Xl2uwCbIojOkXzpmml5sKGAxF2jonxmo?=
 =?us-ascii?Q?V8Cvk7ZhnWbuU3ehnSxFJ19xkTLqZsiIvG7VgMevrqct8v1/hItQKBsbjDfe?=
 =?us-ascii?Q?G5zCqZ3HOJ64CyIwZyjt8GB9qWhIXNjzpPkgAQNPVKk92bBEn9NiEWeJVjeF?=
 =?us-ascii?Q?uDqYVNxNg0cYTWjdVIdg3B/fLPyyvsBZXdZU+UdzrNr4ZnGWr+Bj2/rRb3Ko?=
 =?us-ascii?Q?gVZpdTI+U6/OutpbzK+uMBTCUNLwsbJRmIkqbP6i09uYxRPMik+P7GNcpOGi?=
 =?us-ascii?Q?Xb3h4qLYyY7Z2lWIzfd1GQBCq04WVQ1mR8Ds9xAZLieW00QkU0qo0cC3Oo61?=
 =?us-ascii?Q?pAjsofYylzM36kbtRekS582j+dGFIFEzGEAkQgIiD3nb4bRDcm3KHRNFQpi/?=
 =?us-ascii?Q?ept2HwN6jcwnXtdNJEDRN6+V4KYQt0+EyNcShdEKIhLrnOCKOuAHz8cVWOMr?=
 =?us-ascii?Q?lwvUwWpqwULDwT3V55/oO/D54u8uHKgW0dQ/hG7dbIiU6TeYFadx+hb/k61e?=
 =?us-ascii?Q?WSa/mpl0rD7RmJoan2WU4WyoqjGflvZzXU351NHxKd2qLH2Hwk5/pf/0KyQN?=
 =?us-ascii?Q?6ZwW4CzQF34H7rXFomLMhwELmzZbhsm8onn/2AzixCAtTo1JiiiBYrcRnrXI?=
 =?us-ascii?Q?ZV0OSJmY1EhLNugoZcHWuXi1LW2MJ5rcSlp8sfHK4tncDVXcDZL37l7FU9qb?=
 =?us-ascii?Q?xwgiylVybznwAUa8Re9gnO5TVvY4tqsTN6zEM72pkFeVFzq6x2nOjJ5XTaCP?=
 =?us-ascii?Q?aflboy2lpMNBZSutk7TW0loHG4eoi/WNVwK0i7FUWoKOxG3uGRIPjq+V8bSK?=
 =?us-ascii?Q?foDMy1W4fk7MYpsfk5H/Ij/L6lNzYfwDPhMw9u+fboRyt6mb53tYLS4jrYoI?=
 =?us-ascii?Q?aMkPZ8YGsSfb8kF3+lG+wF6MC+bldMhq1GthJF8wu7jWuvKv0Q815KzNzeh0?=
 =?us-ascii?Q?9dbDMHipQgE0HW5D3dSB5nQw5eClxl0Z5fr+XHxqGaQVbO8ylrg+IW99ZWak?=
 =?us-ascii?Q?p8WGeCB2ci7lxW8/N2gY2NbS24wj688MjGoXIloYHO6LOrS4hkS6G/hIX6WB?=
 =?us-ascii?Q?sDK5k05EZcsosxsIOoqn17P81ekoKLUhPVq5j7A0PgqpSFhkPcrrX0C+RzNT?=
 =?us-ascii?Q?62tBW2ShRM7v29warqWOAIFAk76pzOXFaGN6ZlijCpbuF8PeDKOw/4GrT+V0?=
 =?us-ascii?Q?v3/m3DGzj1nD2zlc+4WGy6e5gIeWQyYq/Y5jhRP6A4Max9RH1+0Jn3NuQt5+?=
 =?us-ascii?Q?1+/n619HuKFMhBz84xSUKdZv2bEOWB9xErllXB7fN+Y+hqIiZABz68wuDlwW?=
 =?us-ascii?Q?x2DAokWsgf3qttqNjK3BIc9E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5c0518-58d7-453e-5a8d-08d9261dec7e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 23:27:01.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P60kZnQMNKds2LGRYCQmsz8iS26mIQ+fZAPmGRDf12JIFxjNPTUBIhRDkJsojO6m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 01:25:00AM +0000, Tian, Kevin wrote:

> OK, this implies that if one user inadvertently creates intended parent/
> child via different fd's then the operation will simply fail.

Remember the number space to refer to the ioasid's inside the FD is
local to that instance of the FD. Each FD should have its own xarray

You can't actually accidently refer to an IOASID in FD A from FD B
because the xarray lookup in FD B will not return 'IOASID A'.

Jason
