Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE813997BD
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 03:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFCBvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 21:51:19 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:14817
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhFCBvT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 21:51:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYPsUt9a5gP+RffdQ3B+bEHu+tI4WNQYc/G5N/B4Lj9QPgpQTX5EJehwFfNm1Po2hAnGRYHJtMeX8HJegK1noryndNskzpecn9wQKOLjihmSXkBAQET0hDCGXvElO/iF6KI5ZmUwa0cIG9N9XQHsRN4+bDPeFo57M2+KhuGCQ+ZT6CaN5WgGhPS26PXIf7Lo6924XMtvfB/ZRgvCLnAUExaHfY+U9TMxsaYp1bTdLWQt6uLXbWNqfVTsjNpEDmo5XWpydtvGAG6dNyOTKp+pMct7yh6thk2ZxDJ+k8Q59jAirbWuTNXbbWyMKyecB2R1Sy/KNikIpn4o8Z8xMi+pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdYNczfiCqKW4mR04Sn7xTSgDBDIHwiRETn6dGpBW4s=;
 b=advUu4k+PCYJjtDxfwUsVgP9KljYr3MPMfgXxj5gt5q8gXmz3mJzI7hbQxpxAvNB9cwhD+K2zAZbAjwzF7+38Ny7WexdbP1314KsHdYpf8O6t2XgbH8nyltzmSec+yMD85kwxnm2MbP0qlet6eyWOxnQ93xZYEQQdSxmGg4vbMPYuWKOHK9NlhJDRHXEhTAXIrGux+1IZqlbPw0V8XNswaCY5VLi6e+m+83LlKrOzRg/p6GYCwmTJ92cispE/fjIt2EVMdTsbbs0kNQHMWIPxS7TTQMLS4Q2y7HE63Lkbs26SWpYQWn7OaLVVNi9wFNNMu2qwJq6pOxPqYVlYqpCAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdYNczfiCqKW4mR04Sn7xTSgDBDIHwiRETn6dGpBW4s=;
 b=I+S/4SdxXmk9q29q/5shwLG/6FJHLuU6MNbej4BYkFwIfc5ER4Ziwc7V7UVma/fDfmLTSxvUVSDVrFH09vWhgENDA6EGW99kRugWxujAtJotDOB1JZ9tklYMOkscg//At+siFdLILfnTBoemPS3oT/FXkfvMi0YRjk0dVILNmEOSQ1tUlQOrp4SG7yLkzTIOQArcokifFvYAii1/o4MZZrujOtXJnDusLEtuHCct9QuzX75XpdB7WMkF62aC7v0powly49TfNWifh9LqLtDZ8vsIt2dCcofBnZcbFAJC7rGSmxdOmvbAW96rlGlca7bAM/aivCfXHYehOYNUSFWzuQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 01:49:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Thu, 3 Jun 2021
 01:49:33 +0000
Date:   Wed, 2 Jun 2021 22:49:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Jiang, Dave" <dave.jiang@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
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
Message-ID: <20210603014932.GN1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
 <20210602231747.GK1002214@nvidia.com>
 <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:208:32b::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:32b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Thu, 3 Jun 2021 01:49:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1locUG-000uIh-NK; Wed, 02 Jun 2021 22:49:32 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dfb9cb9-343c-46be-01c5-08d92631d605
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51894650FFAAAF2CBC0C86ADC23C9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Unu0UJZOzbPmNK/Jbqj/GtD7rnTtdFYKygyhZZCZq6haz7YDN2VcJGQ9CYxZSO8e7H2nwPIRQ+e4a6JidNTVlgHqvlXrs5lErBy4Ilefx7Uw2KwmwXw7BATIKaVGyGA/z+kOASR2AdBch9b2Ks9ro9abbXSFBJUxuWXOqlRw3Ljf3FDuVtDX4Fa25yZVAv6of9a3Wglqo2oi5VfTwrLXneVqAhoQT2Kk+X0q7d9xLWQ+okYqO/ppOlatRVKR1vExO8S4ru23qneZlIFv+t12yC9WMyj8JIctfdn9SbzuJPIhWWboaS9mQ7CTgmiLeLM34kSXThDiMd71lmZ0l/Bwdb9MZwiy++gxTExUnF58tWa45y8IdyTgHyzp9ga7JsuuwZBpQNzJABiIxpJoLcz1OB+KTl5ns0dNyhiSpf6zP+Se4hwzxfHvSlznLsp8A/ErndNknlI9Il2xoZ62TSnL21K4uvED0SsOrLL2YQsyD0fuxEJn9oqWN4ux4DcY4yU38wnPnuj3U1MH4xYd1rj1yNEZM8GIhLRTzygMbn2crwUYzy37BNdILv6XNEbbtDC8QePpmEH7/sDV12A8pMhThHNIE6jupzvbXaMTba0vxaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(2906002)(4744005)(1076003)(8676002)(8936002)(9786002)(38100700002)(4326008)(2616005)(426003)(9746002)(478600001)(7416002)(66946007)(66476007)(316002)(36756003)(54906003)(6916009)(66556008)(26005)(33656002)(186003)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Ln26i+gRLDWxVE3V9DAp5nCS7YJPoRAOXcXr8cIGT6pjFmjI+KqwJVbi6ku?=
 =?us-ascii?Q?9azk/Zypa3B+26rqy0vUd1Ojxwss7zqrvI9pelrFvE+m+jEcpuPsbba4z3eQ?=
 =?us-ascii?Q?fNnSoO3tmscq52s9KfhR6NQQ7ldL9Rv/wOU4hRy/TcqRUdk7mOOyxBpJOXyW?=
 =?us-ascii?Q?YUVARsApK6rd24XaAlpDKf+D2AIYDo8uX0jWuX7/XdhautSCx9scPZX+m/P4?=
 =?us-ascii?Q?qB2puQX0r8yJ7+jsuBMkA7WaRDqrVK0BTbb3q/14sodVuNdG0zJM/QjEj6tG?=
 =?us-ascii?Q?MrHI6uWLe5XbOQjmBTCuaYseQMkYV9KdktqsRMpyS8wKCkll7b4vgBh+iTx7?=
 =?us-ascii?Q?nBKN53avsfig5jmD6WLccDTBIcm62kSz6z36PnzEIZVeb3K7Hu+v0+2gJuJ9?=
 =?us-ascii?Q?/ewvoVcY63/mmM7pCAikzyo9rqjQyIHi6pqbBmQ+gFKbW8WpoDJ+BNwYkIPJ?=
 =?us-ascii?Q?Dq9jZoWq++AD/eRsqir5Gz08h/cs1PpReuETx54qJD3AiKIlDm5mo1pCc2fg?=
 =?us-ascii?Q?Q2ON6X+FiYoi9jgE1zVhJ+MK5UHyBZ0DSybdIdFI5FmpZ8381a8DBeaBPflc?=
 =?us-ascii?Q?PZwVFFB+M/LWxGrREn+ObMoOAwVXgPhyr2ZllY13NOH8f6I58BqejX0dr5jj?=
 =?us-ascii?Q?Pn9xdtioqdTc7FDPJs+CpYPIh86CKVwEFwzKMfIoTwLrpDHDOwRsJb+w5/5q?=
 =?us-ascii?Q?mS3IwIrUIz23yssDYUwC5CIILRI9/Q8Lj35lOcSFyXNcfsai+7/E1F9gfK6p?=
 =?us-ascii?Q?PHoJgNYQqe5HkiGJx8hCLujjzXTtGmXD2a5jvqxXQeZ7Jyzfm5Mi4XJf6Nxv?=
 =?us-ascii?Q?IaJeOagLlGvVc1GuvVi7VyFnrLDh8B4/Kbi5KFw0DfDC+1iZgBRtQBeTu4WE?=
 =?us-ascii?Q?lBK1PIEE+wCIF+I1cryV8Rzis4Uu1jtcXhsCmwwIgvGOctw8p1CemQ0rLyo2?=
 =?us-ascii?Q?HfHKjEYDV4c66fdai2Itbu3f3MB6WkokhDVoenhDqNCrDAPyUI4Ndio5LqaZ?=
 =?us-ascii?Q?WD3Cszgh0bOvZz8vFkajbghKer8BQAmAWIDGJjzaZsrfan3UK9NrjfTaeKyi?=
 =?us-ascii?Q?SOVMaWLtzMwVCrOQ9KyXpHCQmX4Hf6//J38XSSZ5PZjF+TVxbpv4yHvjmkv6?=
 =?us-ascii?Q?4j19FkFduV3Z+r4GbZJdipGhKqbIWbzwa4+LJwQZDB90s45BC0ZV8YnOu4Fl?=
 =?us-ascii?Q?DDRp1yikn9qmyGRc0bK0i1Rqm4JrgDX9//y/ugrLwHQ8Yn340xEARnhzs3mw?=
 =?us-ascii?Q?eS1Bb490P8i9YcXcsmVCig0mcS99zM0w05OLiRHRjy4WDxs/ahLfdR1+Brqs?=
 =?us-ascii?Q?NSzY8aw4sRmi1awMH7cLqKgy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dfb9cb9-343c-46be-01c5-08d92631d605
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 01:49:33.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X65cPoI7z5MBRDpTTlLnrf+7pSkRHsDRtoo3D2B/nSQnYzkbm457GCZEeR7e1Thb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:

> Jason, can you clarify your attitude on mdev guid stuff? Are you 
> completely against it or case-by-case? If the former, this is a big
> decision thus it's better to have consensus with Alex/Kirti. If the
> latter, would like to hear your criteria for when it can be used
> and when not...

I dislike it generally, but it exists so <shrug>. I know others feel
more strongly about it being un-kernely and the wrong way to use sysfs.

Here I was remarking how the example in the cover letter made the mdev
part seem totally pointless. If it is pointless then don't do it.

Remember we have stripped away the actual special need to use
mdev. You don't *have* to use mdev anymore to use vfio. That is a
significant ideology change even from a few months ago.

Jason
