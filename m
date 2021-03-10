Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514DE333C7F
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 13:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhCJMTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 07:19:50 -0500
Received: from mail-dm6nam12on2057.outbound.protection.outlook.com ([40.107.243.57]:61281
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231265AbhCJMTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 07:19:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGDljgPNOYqCQojevtbVa7NpRus+LrCs6VntetmaM4IgqEXr0eW+exr2Lgi5jpt6TX24N7K8VQNfOUQJRE73t2gQTYaCSDnprzdmHuwon9H1Mqi7K4wG87MuV83eS0DOZLDFW0Vb+YkXkUDJfL04PRz7oRhA0VBX9MK8D+drGuRsFTRUzr9gfhtmr1ELRIRZktwbEw7Gdm4NcHhKy7wcv6e8gxYc0jDMjUxm74b+vXQGRxvff5rx+WAkP+nGQfZy92TpfvEi/j37o7mdSHAslF+GrC+HaqAbqxcaJR/eq/84rzkWzXJD447K6nIT6ZrDeeTgyEMxSTHNee9/hOAjRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLUTvPNydimapKYY7La1OXkhRMYdFDMPCK4TQ0HM8Q0=;
 b=amYkiMDSfKIFgawQ49ibLB2UjX4nkjUS8unKFDHTH8Ro51+UU4/Y14qkDvGQXsMgHaeADHF9ovUWWkCK2D6Jg9QkOBR+7FdqyjBCGKYqb8ujr0kcqwPg1YeD2aUcO8tcQXDo6XD8FYqCCUn2VW9YPSkA84GAR57+s3rRryP37btsHyamJ/XDYhb+gRihTwW21svLnA62uMwQvoco8g00ZL4Qssrl/32ro0WTcF04j+p1WE5b9MW7F5VKvwRli2zkGFT4QDg5XGjpkuQCLjd4bb7ddulMCF+6LorkOmlTr2eS/b/mXcmn3yQXeM06EjF/IklP01/dxZoQ9PUMGO65IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLUTvPNydimapKYY7La1OXkhRMYdFDMPCK4TQ0HM8Q0=;
 b=UurqhG96VJa1yFGn0SVf3JqdiXt6itXbiXn36C13YvYb9x4QKFnq+P4V2G0dV6Eab0RAMrrrBC02yD4m+kZK5heijPBV9HfEhRsQgSf8d+4B6aQHTn9xhHYI7yxCZ+Vd2k3tY46NWkF2qfLDCOjIzRUUo9UeW3R5PAwMc0O6WOGpXjtPJ/z57adGmmAclRDv/+HOkwOrIPdwo2ZoNdFLvJN2FsMPbEXfsmW6NvxSVl0nLia/mhLNHiSAsylkRp3rxlgyMNv/sIFfj3xL8QJQd3ObOVJL35aX4fSDCbM5lwGoVPofRjjhywai/JHLNGgOE+ctgm5qoA2rw2hZ6jiNng==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2859.namprd12.prod.outlook.com (2603:10b6:5:15d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 10 Mar
 2021 12:19:15 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 12:19:15 +0000
Date:   Wed, 10 Mar 2021 08:19:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH v1 02/14] vfio: Update vfio_add_group_dev() API
Message-ID: <20210310121913.GR2356281@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524006056.3480.3931750068527641030.stgit@gimli.home>
 <20210310074838.GA662265@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310074838.GA662265@infradead.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR18CA0011.namprd18.prod.outlook.com
 (2603:10b6:208:23c::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0011.namprd18.prod.outlook.com (2603:10b6:208:23c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 12:19:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJxo1-00AhYH-OT; Wed, 10 Mar 2021 08:19:13 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6811b3e8-097d-4453-133b-08d8e3beb84b
X-MS-TrafficTypeDiagnostic: DM6PR12MB2859:
X-Microsoft-Antispam-PRVS: <DM6PR12MB285965AA4B64597BBC853C6AC2919@DM6PR12MB2859.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxeMjhSJzZJWgX70yWqcH7gAtB9WSKMZN0EilNgI9V7tGqbRaxYsjed7h7jJJERQbomNnqylYX3N31WL7avVs7/gqpn7SKl26c3zBP1EIZyOQlJCRKufllDT5x2j9X/n8e7hIg039awUrH3eXZfAxxou/HQ2MCCab8xvxTgIrpaq4gyRqoojaqunj8ScSJh1ZDLRUKiZuxuwrJOXUBnOnnBAXOCH0IPHriOyl3sFzepqTZtICjzffzjtuIUz4St5Gw8O99LJieva35dh+gzYQfdwxOePuBbtOEqpbL7Z8VNmsrgAS8ftr3NcnqEzco4qQ/s5CxV+EnAGoqGLz/vZrP74Q6IPlKgjQUpDzMdPKrz6DiTdOkL3S5XCRiqJb/MO+qgCd86m5Szyp6B/bB+0kW7+stpz8uAFMIj3T0RcLghwKRqTpHrmUWFAxD7AWbMtA1DzgaugfbijkEK5vOZzB/gUyFkiig3r0Nu14S3adAZO91B+PFliGMr50hkzzJraazd5yF1bw3AKjKdO+gp97Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(6916009)(426003)(478600001)(66476007)(36756003)(66946007)(9786002)(316002)(66556008)(2906002)(8676002)(26005)(8936002)(33656002)(4326008)(5660300002)(4744005)(9746002)(86362001)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SSmlRfcnyWiI4n2Ol3PzFdjeMSrN0uhn8FsLv+Gk+7hrTghFVaY8LPFHB7E+?=
 =?us-ascii?Q?RT2EN4HSlBy2H2hveltl/lHur3RXwORuECKeDvcKuA0G3QmfFAAHL8wmCgR/?=
 =?us-ascii?Q?uWRBv29gQJX2J6FlEU9UDAp5kW3ONL7UZUwGFJckvq6UPdwa61qyAnhsoWha?=
 =?us-ascii?Q?Iny6yVEG4Tg5FqRVw+5Km1oPrUnoEQtDZB1sb0WtfwFo++njKIiL5JE3W78+?=
 =?us-ascii?Q?4JXcHk3EQr8nU5n856DcqrabyKfWTCcccdPuVbk0ceiWRQnfzXIGDG6tMyvS?=
 =?us-ascii?Q?irVbiljoNWxQ3GBi27i/QfqKfiQ7iHWTWkYus8P0ReIV7woD/EH9QrmtcQ05?=
 =?us-ascii?Q?Jc0EQPmWlv1+oYwAk5raLOjqFYz/6QBGMjbSUgsYY1UX3t1szFimLezI3wZ6?=
 =?us-ascii?Q?rii+/Wx/J/LqAFABwMo+2z0EJkJHN5RQrsrhpnsVE93acEeHZXmF3jyb4/90?=
 =?us-ascii?Q?ysrUFUMZv/tvDfC3eRHD9Y3ZJL9AuD9fPz911ydHAf4JE20D6TN6z3dTkuqu?=
 =?us-ascii?Q?I6VOgfdA+C99dgOcb6EQ7I2+gIwYzW8v6FqfAEeGexhvwg8OZuLBIhzkh/jO?=
 =?us-ascii?Q?EXAcKTfrG7YreZ6WZnTGWtiCNdA3jWpsy5tOoxFIOOdlVQmSJMSjhDYy+rYs?=
 =?us-ascii?Q?jXW/Pn6GDKScAqNTALbb6LnaYRI1xCa4mxhmohZ+bup5i77Pld+IdI5mprPp?=
 =?us-ascii?Q?E6ENOeStQR6D1INQD2Kcc/PVulFudFz5Mk8aag5EKfdP4foFo0BazNuLnnjs?=
 =?us-ascii?Q?ywPdPJgKTTiwYmWq+gAb3hSmYVMIMURNiXcCAHxd7hbtSQHNUq5nPPqLMCnt?=
 =?us-ascii?Q?dc+tqBM3euwIyWrnx4jik6Tbi7OBJXhMQYFuTWPQXEpUimhWzoxFNQ/BcWTG?=
 =?us-ascii?Q?5gpTLmMK0S7z7+tG7SjfqqAA6x9C19B++O0KwaoHea5Dm88gl2JzKpeRI6wz?=
 =?us-ascii?Q?GWYHaHozAFe1zaOPApT10jQqV6Qa8bVn6dHCURctMDpCIXrYlMhtSEFs4pac?=
 =?us-ascii?Q?jScn6KOQSchv7PalmmHuf91f604d3bkoZFSXZqCv5vDW1M5QpJ8yLIDmX08C?=
 =?us-ascii?Q?GW06tuEJulMFdM36BbY0zE0MK1fh27GTyQaEMVFiE+7qdomQdrpSH7UyBzzH?=
 =?us-ascii?Q?LIxRoc54aT/eQo68rozqv3VR8WTTpZ0U2P90gpppBbTAa7C6JGd3aDb65Esw?=
 =?us-ascii?Q?A4ZxuAly3azI+XP0bhJ5Bh7tSb3m3hfrPdNWnngm5NdBKN6GBKz5MQaN+i2o?=
 =?us-ascii?Q?p65TfcefZfhL3XAB794ThD/pWrBrvqcTzZYcxQvqcXEBqf5/Bjq19xrqnrpW?=
 =?us-ascii?Q?SKtBVVbeBH7D9LdbBFm7C42r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6811b3e8-097d-4453-133b-08d8e3beb84b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 12:19:15.2911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YZpgE1r0WQvl33yE6PVwMIE/6MVbT4xCz/rGh1eY0pau+2zz7LyDAGMCoIEz37U8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2859
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 07:48:38AM +0000, Christoph Hellwig wrote:
> On Mon, Mar 08, 2021 at 02:47:40PM -0700, Alex Williamson wrote:
> > Rather than an errno, return a pointer to the opaque vfio_device
> > to allow the bus driver to call into vfio-core without additional
> > lookups and references.  Note that bus drivers are still required
> > to use vfio_del_group_dev() to teardown the vfio_device.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> This looks like it is superseded by the
> 
>   vfio: Split creation of a vfio_device into init and register ops

Yes, that series puts vfio_device everywhere so APIs like Alex needs
to build here become trivial.

The fact we both converged on this same requirement is good

Jason
