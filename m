Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34D836D925
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 16:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhD1OA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 10:00:58 -0400
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:31410
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240165AbhD1OAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 10:00:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuZKgwzbzQK8G6Yr2DPJEGmeRaONrC91wBpFtkPTyP1clpgmqBpNyB+Op8TJySfTyIOJQX70HdeD11n0eBpQA2jeRAGZU4jeuoQ7SDS7w1WLYohAGLo79/dzrVNJDPflh1a8N9+nMU3k8n9DLVQWzHnzeFG41JCDiFwUb7Cq21bjFrm6LrCfJ/4auTTypvBlZ8w4wJwE5QYIYLS/UKKp6ugA9+HJ2s1FxUjxGAmadVX8Nek8mztyIfKDRZDwVgGbMx0rC+h2XIq6MogMNIfX9UcGQGyJWFqOQcSpA/GPbi6ZPmA9rSmR3Mm6cvBNUK2+TB398b3giqbNxeN+9+F50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NpCuUMJMrHhZNyh+jW7NPNIkDZSQJiEtSnJuWOts7k=;
 b=DGN7pQTqBZIByqdIfH8YFE3WmqUPYMZ0o+HAnTs+2VgSMXvR3gWAQoHwjueVl8OSWII5Txc63Pj0zB+OC/FXMGpvDmc/Rf2MVW02hKaHlhTsoZKdlP7gAfBcmgw+Q/pMiL7mrqNo3jmsEd5WSlf3MUlMY7vsHm1BGpUVC0SaNZHljNmVLBDKmgR+yP9wod3JmlAfIW0wVaqCJelGF80DKhAxuA9hSDMM5ATA7qVAA6jgqXU95wIt3KKIhxIkm5iz2Qv/IOX7zzE4iA4RfATifeZpI0pP+deldvSjBKqlhteP6MyeJ2Bsill86PIxM2ROZS0nFALPespPQIMEWZpr9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NpCuUMJMrHhZNyh+jW7NPNIkDZSQJiEtSnJuWOts7k=;
 b=mdtgbOYyPIbVh80XEtUyw9+aXy0yCWKgwz/BbjNwikicBmhVXv16lBK974LsL/YgN5G5tlhndjukGmGzSuUpEND47qL3g0L+gfUfIyM0Qiw8lkjzuh+MPzjN9/V84/oQTIdW7TvbCyso5oiY4j1rFomNq9h3dKGrIEnCtg2589UpPNl9qnYjLPGLjSJoLz7xEM9xh6LY9jUQ6oS6b6HXUGCYdNV05Mf5Xh5nF0t09CbCZt1Sq7ZZd+eRHCM2xass3334N9JV+oGjphmPJgqx5CPj7wS5HOb91gk8gMwz4VMDWtdTUogVR0YeDOldf5I0QxotSk+U3pikg/YniyvAtA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2858.namprd12.prod.outlook.com (2603:10b6:5:182::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Wed, 28 Apr
 2021 14:00:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 14:00:07 +0000
Date:   Wed, 28 Apr 2021 11:00:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 02/13] vfio/mdev: Allow the mdev_parent_ops to specify
 the device driver to bind
Message-ID: <20210428140005.GS1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <2-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060300.GA4092@lst.de>
 <CAPcyv4g=MFtZMVZPn8AtTX6NyweF25nuFNVBu7pg_QSP+EGE+g@mail.gmail.com>
 <20210428124153.GA28566@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428124153.GA28566@lst.de>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:610:4e::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR02CA0026.namprd02.prod.outlook.com (2603:10b6:610:4e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 14:00:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbkjV-00E1V1-Fq; Wed, 28 Apr 2021 11:00:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5463dc-0390-4597-91a3-08d90a4dedc1
X-MS-TrafficTypeDiagnostic: DM6PR12MB2858:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2858BEF7A61DEBC5B5D1B223C2409@DM6PR12MB2858.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WvFW2MRzVzgyxGuhg0n9E/bGZUoGObgRDDDXU/9L9ahbzKT0nBAX5XVGkZ1+nIi7CfQR9LEYywgURGjHy0reXHncZrkfg5jLfDZx+F1QASr26VlJ/4cUoHCE3d9gTwbTA9FnRXtx/DABZLiarPGBgZa4yopDI+kmjE+p+mPz6dK3JdghhQiFD6T8pWBhtg/jnddAyDnl1tZztk92tTnP1yVrOwHPcncIiwYQ/PHHxTdV42X1jU62uMsME8N515fhYgaO0HUFK5LFB0j/PMuy8mIKT6XPsFdi35tjEVe5AM29pYCleIIS8zntBvvIZCFWbBsDITRTbSwM33Sj0/RYwbtYe7KHC1PRKiwyoNcgkkHginhbtf8QApb483A8O79/Lu6xHM/aR1/7EXKRcfu+9PsgOHojwx7imABBnx0nYCXn8S0Gfz3A3tib1Hyg/8M587sw/1GDE3AsZVdAk7JG84SRcWA5DfPCPdjVyP1nVerMZ0O+ezZ8AZEf/U17NIUtML6VqtTHwcW7/AFNcjXFim3kSd6Gq+375Yy6RqTRPkWtmtaU8XQeuZ/zFsVI9k6BlY/79i3tQqGk7QipBwhtRCEJlIjHCIrH6ObSUVHWNE8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(9746002)(26005)(1076003)(107886003)(86362001)(186003)(8936002)(36756003)(316002)(33656002)(8676002)(4326008)(2906002)(9786002)(38100700002)(6916009)(66476007)(478600001)(54906003)(66556008)(426003)(5660300002)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yH318VMUR6zpHf0rHtevFEUkb2A/NwNz9yjZccUebMC54Y7lJfchG3hszES/?=
 =?us-ascii?Q?Mm7g+/iz4wBIArE2t53u/CakQXQ2vE6pGYiDEebt9dbuIuMzZkTHhqFS820s?=
 =?us-ascii?Q?b4MhWd4zQGmZS0w4P+b1C5izC+v7Tu09UeLiB4MeEFlgW+6jD/37bFjKf825?=
 =?us-ascii?Q?CYtwi1JvjWsmq16akjyOHNjcgvz5hsIyBKNnKojjuf8OgaJ9GzgOByPrpuHg?=
 =?us-ascii?Q?WEmTEqBKoeZSVjr9GVa1dga5B160cvlxNUwsMxJZoFKXeTufj26reP7fwVzY?=
 =?us-ascii?Q?4eXMynwP4AAB5QKYy0JFwSfaI+UPeaK7sHhGZS2VFOGwY2vJmDnmt7nPXiwX?=
 =?us-ascii?Q?dwbxVbWps+hxo2oZqeqimHyspaKMidLWbHZ7/9w/qOmeijVsUPyHRqNHSiqJ?=
 =?us-ascii?Q?kjbQR4kMj0lX+30naZ/lxYej2ewvWvJNu7sebA2iMCJE87Pd/vuJB6rGWdX0?=
 =?us-ascii?Q?LlGis9T/FlFLdhYKkHR/tUEnQwEwtl7rh2Rgc/ugga2xJeU5yDZs3jZ38fZT?=
 =?us-ascii?Q?O3ivMD+x7nZU5HXcaxvO+C0PWQE9FMq39khMk10FdoIR78/a8QUTrf0Bftug?=
 =?us-ascii?Q?ZxRQXUwsB32HzJ+/QJuDMSGhzTuvXhA3sviNqtoVsqJu+c128l3Db+JIc1AL?=
 =?us-ascii?Q?1stdy24glqex1LjrU+ZVIbnoJDDK6fyFUhUj9LBsR7ZjwE+LHuY3bVeOb2/5?=
 =?us-ascii?Q?AhXI4hQuDf4pXM0VNqk+jKtSly/d4SehW7c24IUqCa3IVpGZ18Eez5TPxHoe?=
 =?us-ascii?Q?0exmVazzy8hSYm/Lnl7wDG1byDUts0LC/wIJsknDWpRUqR72xPJTCxMy3L9p?=
 =?us-ascii?Q?m877d8+iu9f71zGA4QYS07zsDL4A8d7VKSrFqziJSHEm1Z3VxPspVbks8trK?=
 =?us-ascii?Q?XXTi5kR+lQEZkYA+iLswECu3nUyVvBYlxuWRpueVEG2lVbSulJrRnvNYbHsV?=
 =?us-ascii?Q?OjdtO4iM/QA+yDtUmnLNcG30b5Nh07uBhxyybHVDehnPu6GAc1s7TCzasA6L?=
 =?us-ascii?Q?JAJuC/VtifosHVAMMEPrTNZ/lyNXIilFkSIrmfnC53YZsmeACdtIMJyruwdk?=
 =?us-ascii?Q?cjlbRFzln0aA0vO7sOdhr7VBxceIscD1+9QmZ2gT+IixKI0lAjxtgSt3bFjM?=
 =?us-ascii?Q?jZJ8zPVy8Bpv4n/dLAMWalpWYrZON44vxbUXWniDVDGKiAd3aIvKDbSwxzjo?=
 =?us-ascii?Q?VzrjKdy2DUxpK7WHtumECFMvmz6DLbB18zV9Yp7+LCVVkDlP2Zt16IgVGlZD?=
 =?us-ascii?Q?Lgmd5SJRyxSv3kyfJ5alTMQYF4Pa7b6AF7zGziBX/Ii9GrgtPfzcNXzn+en4?=
 =?us-ascii?Q?HCewZz7Em2DkAZJ2Dx6V0F4m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5463dc-0390-4597-91a3-08d90a4dedc1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 14:00:06.9260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GM+aM7tLRlJn4mzKO7+jw4JWSefLSE9n2xxD+OahAu95DXU+Iii25Yvo/qrnWXnz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2858
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 02:41:53PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 28, 2021 at 12:56:21AM -0700, Dan Williams wrote:
> > > I still think this going the wrong way.  Why can't we enhance the core
> > > driver code with a version of device_bind_driver() that does call into
> > > ->probe?  That probably seems like a better model for those existing
> > > direct users of device_bind_driver or device_attach with a pre-set
> > > ->drv anyway.
> > 
> > Wouldn't that just be "export device_driver_attach()" so that drivers
> > can implement their own custom bind implementation?
> 
> That looks like it might be all that is needed.

I thought about doing it like that, it is generally a good idea,
however, if I add new API surface to the driver core I really want to
get rid of device_bind_driver(), or at least most of its users.

I'm pretty sure Greg will ask for it too.

So, I need a way to sequence that which doesn't mean I have to shelf
the mdev stuff for ages while I try to get acks from lots of places.

Leave this alone and fix it after? Export device_driver_attach() and
say to try and fix the rest after?

I think this will still need the ugly errno capture though..

Jason
