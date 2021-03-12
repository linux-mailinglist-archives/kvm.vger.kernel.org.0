Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DEF339196
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhCLPlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:41:52 -0500
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:15781
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231321AbhCLPlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 10:41:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhIOBLWyhGdlxrBgGXEaBIr027QWq9c0Ea+55xVXvLTYMec075Yhyv00jKqRRn47stlPGl8iPrPPIJgGPJdTIp22vRAf69WOFvAIaIqEjfP+zhrfg/hOV9kvhzNUgSIKkjBud/M9Q/FIBALFxrygphAWfOCX0afofo6EJhFbvqS47JZ92v02qkk6BwYi8hsUadftItj2Bo95f1f01V8fqFlI5q0Z5iIqHQ8DO5QoId307Dun0brPfjWM2yK+tYcZ1VCadFVQPHYBN+9h/ggRri/wti6cU+KNNKijmfVQqiZBiIDASjgQSHrOhQqDc9Y+Zpi0CEiOG0H3aUitiHfL8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvIb5YO8TrYwszZYSvWuobjLkYe429nFHWQadYYLURE=;
 b=FMBijejGaKfPWxrPhm4jfcAF0FMh5D5yF8CsMz/7hkxKPC+FuziXdRRwPlQCZmIlP1E5amHdwYoOlH5aQvuKBszI4dw2M2UuvdqSjdrs8WVKiQrrzz9V59BMpKsOQUar4gvBTszelmqGWceWeKWSq5idD14rnUu4ui77DSYenPZeLgBMpPETqjiNTooIr1Bx6OxA9Yh6o8cpsKKQiJ3l1BfQ0cpU7Gd078GJaaCwzeN3kjDwXQRCZdmQ7ljd+zs2gntldoILe7LMszjlDbIeT3W7dThBU6Z3GRndaQWtiQU7x6RMIOIM7CeMPw4Xs/0eXkaR9OijorC/GijPGoTs2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvIb5YO8TrYwszZYSvWuobjLkYe429nFHWQadYYLURE=;
 b=kxUBDcVCx9Lnt0evt14Rv6QzPMiIgyMltMlxh/asdIGE6OzHCs4QBeDlC8Eyf7WnfRZYc4zrbhGvcyWuJCSIqtdj4nBYZXUZvL2FigPkMJE8ZOZ5GQolBAmGfPh3MHnH1zwxovsJcfaG2fsDmH1AfVdfob4yTDG76BmYpUzMgPMpnHpHanO5IIs1c228AH9YZA0DGXd53ybAvVjN7Rxfo64QE8PlCpgoCm+6d/2jelGu9Rq6mxVRbE88AyBp5yc+z9gACFhqsYDANu5q+vSiVY01ARPLDy4Sl7nrDXGnBWV0GaYH2VXae//9570yDzU8ALTzCDa2KQUB++I5T+X3uA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Fri, 12 Mar
 2021 15:41:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 15:41:36 +0000
Date:   Fri, 12 Mar 2021 11:41:33 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 01/10] vfio: Simplify the lifetime logic for vfio_device
Message-ID: <20210312154133.GE2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <1-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <20210310072340.GA2659@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310072340.GA2659@lst.de>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:208:329::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0075.namprd03.prod.outlook.com (2603:10b6:208:329::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 15:41:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKjuv-00C3TF-Ph; Fri, 12 Mar 2021 11:41:33 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c10b0353-c1df-4e64-fad4-08d8e56d514c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4235A0526783D290DFBD10DFC26F9@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMyZUlyJGTeU8lgT9Enf+cV7c3fssLh/g1svL/H+swnlmQrbQYN4jJ43gZoPI87c2wqvjmtVJ3MCm0wkt/lPxdkZyQZ1189k94kz0W9Ktjk31BISXGFHo2i3CXWq3XZ6opLp+FmdxXy4+23D7YefoO4U9kMjbpiwIY0OOLv32YoeOBtjEFFJ2MfAzV9v2N3kvf3ehkUhF2dz2w0yjaBkmzHSbHgU9+Uyn1k9hTuG6Cgdu0zeTcMFtqXkxbvHKtiW2qxmAaJfrKjwh/R/H8+XeH28R3I3u+dlQEZZ9BfNEEOE3kvDsiLOJK26Jx7wNP9xwXY98De08CAyD54zfEM0yVuEdj0wRicurb87rMoBzZNKk6aAfJ2ZJmJUgsyAULyaLNAmaHco/1HTnJ3kADM2R9teAtlyx9E1o6V4m4xSq7I7vdWIp/1WZGAXIaGsyzGZSvSDWUFnqNqW3tVy7so25D7mrVwIlIRXNJAkxUE6hx94vK34sA5out2IO1iApf/08hILhPdiXLx800e/59gCaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(26005)(5660300002)(2906002)(33656002)(107886003)(66476007)(36756003)(186003)(66946007)(54906003)(8676002)(66556008)(478600001)(9786002)(426003)(9746002)(316002)(8936002)(86362001)(1076003)(2616005)(4326008)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1/L5La+MOHe0UCHJE6QEpGweAusmKWReMB0wAxAGCFQWea9n/fSpVhHcP+eZ?=
 =?us-ascii?Q?TTEvdZRPFNH1l+4zdPLi9PTXvx7N2dQeJROngz9p9gsivyxJLc4y9UCuXIsI?=
 =?us-ascii?Q?WS8EJM1lOMGE/DU8ANM9X9A1GjmS5kZgko6r/fAWE8RlX2I1VXSwW9U6HTXV?=
 =?us-ascii?Q?DHHm+KWJLEtYONztQNBzqXjanPGhPXSxk1K1iCAB+KlW95wW2reMAk0w4z9j?=
 =?us-ascii?Q?L6poqrLWgf5yX7DbbojnzzixFXB3PR+MVqdGGkA4GP6kuPWzGTqDfYZKrV7F?=
 =?us-ascii?Q?Pfau3bZxUv0po+3/jH0K2ulnz2VhgZ5Xb4XN4wcg1E+K5YeNc+MdCBCYDrWW?=
 =?us-ascii?Q?+rK0i/edIFnRZ0eyuK2Pgzu6eTs8PgzU+RryZDHc3cdgqWkw3DuH2YZkFOwO?=
 =?us-ascii?Q?1mO9cG6rLJw0JBW3e5Inr+tvA3+kwh6XrHKwuELLyJFx34hm+LPKw2Vpw7IX?=
 =?us-ascii?Q?rnE9OYJn64p+A/n5hEsWFutZjff1FQYu9X02AJpbSS4fTLhZ2D1X9vkxrs+J?=
 =?us-ascii?Q?I7jglMTmZMdI3Ofz1e1q+CEKAD720YZu/NTB8wccsM+i6JjBNf1t/rPXpEfg?=
 =?us-ascii?Q?kKqCMiBWqQo9Qgyxgnq2gdS8H1vcpxP70S3RdU250Bt3MhIU7PTM7ob2L1fL?=
 =?us-ascii?Q?yv/HgKax9Nfu7/dzk6UZYZf7AWNwXPi6Dq9KC/UCJDhTMFXnULiE7blMxBi3?=
 =?us-ascii?Q?IOn8CzsX2TIN1KogXaQP+i49dMAMwHISbh3Su4y4Z6GbM824n4zXqsN+2KL6?=
 =?us-ascii?Q?4gPRoQ0vyRDhITrsHEudmKesha19ymC9A1dksNr48aOTK4RUOykeF7o/ljxw?=
 =?us-ascii?Q?QAzs9Wtd7aHLSqZXxJmIRcnBWC0+Em5aLa079TcfyGfC6NF7YyNWFwLLAOLC?=
 =?us-ascii?Q?6i0kTuFwCJL9FPuYuYTvJYfFRESQCIZ29tneJYtwDWtXV8qN5kEzgsRWCYhz?=
 =?us-ascii?Q?U8MA1pQ78yIbcsRR1BUoF0vHS+3Jx3RHtYejWiJTnRqPV7hXEjD5AFx8quCS?=
 =?us-ascii?Q?O93Q60EZJmWbJRqdsYSPkblcrX5fGPMmBZvZpZNKCKT3LSXoTwEBvR7QijAK?=
 =?us-ascii?Q?wEpUMGIwQPToEHw+yoOsfFZ04RVGSROg9zNeSVQbk7gfMoEh1ztgjVkl3tPz?=
 =?us-ascii?Q?H2zLIFvZjht4k0qz/zxqc15rUilRGk+k/Znu/W3nftlPmoIBy9KnoB3tjsj+?=
 =?us-ascii?Q?Sb+rnlWKRpr4OCvM+DqeU9oa3daaXTbGI2YAyoUzz4zKiUAdcl29gaOQDc+V?=
 =?us-ascii?Q?Dx0iXaces779tcS9LQaaMYixznyNbZpH9dVm5iELdC1+xYKFLuZd/EwI6PLQ?=
 =?us-ascii?Q?FdtJSNJ6P1jiMYIqx/tQSLtIWPiyfe2/PSgEgkbag8mRmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c10b0353-c1df-4e64-fad4-08d8e56d514c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 15:41:35.9925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kwWu6sS0cAgu+Ta5lLrXz6JyferJiCwK7J9khrKQVypcX/2ldlvlEEqUFnjQ9EUB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:23:40AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 09, 2021 at 05:38:43PM -0400, Jason Gunthorpe wrote:
> > The vfio_device is using a 'sleep until all refs go to zero' pattern for
> > its lifetime, but it is indirectly coded by repeatedly scanning the group
> > list waiting for the device to be removed on its own.
> > 
> > Switch this around to be a direct representation, use a refcount to count
> > the number of places that are blocking destruction and sleep directly on a
> > completion until that counter goes to zero. kfree the device after other
> > accesses have been excluded in vfio_del_group_dev(). This is a fairly
> > common Linux idiom.
> > 
> > This simplifies a couple of things:
> > 
> > - kref_put_mutex() is very rarely used in the kernel. Here it is being
> >   used to prevent a zero ref device from being seen in the group
> >   list. Instead allow the zero ref device to continue to exist in the
> >   device_list and use refcount_inc_not_zero() to exclude it once refs go
> >   to zero.
> > 
> > - get/putting the group while get/putting the device. The device already
> >   holds a reference to the group, set during vfio_group_create_device(),
> >   there is no need for extra reference traffic. Cleanly have the balancing
> >   group put in vfio_del_group_dev() before the kfree().
> 
> Might it be worth to split this further up into separate patches for
> each of the changes?

I split the put/get and it looks nicer. The other stuff is more
tightly coupled, doesn't look like there is much win from splitting
further

Thanks,
Jason
