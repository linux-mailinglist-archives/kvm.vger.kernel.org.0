Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92C36CE71
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbhD0WLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:11:19 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:52133
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235249AbhD0WLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:11:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVHCCt/5wm63JdmkNNRrbrFE0R0c8mmeU60PQOr6uacG34sG0Kq+hoja0e69z+YTeuWRMAxo4ugJj4UcII3DrBkW5C1Ez/Slm7LcCtWpRMOxIS0SPsuitSHz1w4E+IReaiGOZZJDjqy6m3FnSb5cSFYrbWStChm6ZGbbYyho50t2b5FX0WBon62foRD2CA61g5A/xDJPNuAQG4B2dVONQYr2lb1UCRR7UoqULXQoiWDUx1y0F3caNnZnJQHBAXAdBkZzyRR5I28C0SXK7oCMcy+b3RyPZT8pzNZynJ9ukTMhOInKx5IGT5UkBlbBg7qm9oYhDKUI4itXogFeSvLFqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcfGV7RPsxexf5/4kEyhTFvSRmn7kOkEtJb65a/24/4=;
 b=JfrX34GzkHae/E1lQkPK8pipMSnDEx6O5rjrCjMbSGPx07BBsAoW5mJ3DjUftjMqBXEl5dyxY58PHbKrvRZknrBL2IEe7FHS5YCNmtn84N60tsENrr3IebxF+eREq1SJfn8UNV+1mSN71E360cnmvi2dbSCrrWtSqyTAiwUHI5jhEbTMUmEZZvA8R/rg/fUQYYyiVodclpzqf4BmIpQD2ypvWA5Z5cP/d4QajMMASjcC92nc2UzB1nB6I6iCkpyfUEYBzSGoSGU9+dXXwt/jBkNNdU0fVpiSe1IK9dt7fzwUq9/A+9igjwKA4L1uFo1jdsUORWuXKOzrdDRnnuArAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcfGV7RPsxexf5/4kEyhTFvSRmn7kOkEtJb65a/24/4=;
 b=j8k59hFGaf7G4DlbjqarzlXtKr53v4YH7+ramYicZ4TvcxzeFWnJp13GfYKC+P3AxgrwHpPQ++Ch8xkhVq+Qo6F2UdcSTr5u8ldn4sQ/z+aDHOd0qddZCmTOKarj9qK6a+iZwroA7p2JOBv9hs8/EgYJJQtLUF0kmK4WXM89noHuJgTKE+0txn++uYDoSveTxqKEzPAPtKJzT30RgfGx+GVQEFJ7GVTbIW4Y7hXkwIyso0lPEhaafVCWbTTg9bk6UJ3hX+fORFk3fBoqTyIcPEz/xkT0zwHOLY9/32pQH+rnHpLK8SDLx2UWw9gq51PdTJqtI/U20gunJHUGPGnExA==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4780.namprd12.prod.outlook.com (2603:10b6:5:168::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 27 Apr
 2021 22:10:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 22:10:31 +0000
Date:   Tue, 27 Apr 2021 19:10:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210427221030.GK1370958@nvidia.com>
References: <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <5325cd47bf170b66591bc1e64bf9fa3aa9c365b5.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5325cd47bf170b66591bc1e64bf9fa3aa9c365b5.camel@linux.ibm.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR19CA0005.namprd19.prod.outlook.com
 (2603:10b6:610:4d::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR19CA0005.namprd19.prod.outlook.com (2603:10b6:610:4d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 22:10:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lbVuY-00DjK2-5X; Tue, 27 Apr 2021 19:10:30 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19ffee43-329d-4c23-4ad9-08d909c945e2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4780D70ADCDFED5762C72546C2419@DM6PR12MB4780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGWbZeyEYogTH3zS97Oa5O9lTkIskHAqUh0AJBiiwnGVeaOuXVxqOv41OrhEtQ7UqcykWIKQTBT3W7D+KkIQiDdTaBRgJV3UTtLTstq/v0emeQzDsvwroFaGskTbTaa2olknavmf+GUKeevViJJBizXf8c2m55N1SU5vtHht3Woc2t/KJGIRBuAQtLZr0XE45YRdxGIko0MOcLPDEWZXY2Sa2xYziBnf834K9NmYrDwEjSCOaPMA0rWrhtfU45Vlwn23oY/z2MBW0wU8K9KPn+GEGv8HhwxMUmbNUHcgEY3PKgfSgYy0zN8JdD4PN6YUL66DZvQSiSWKOQPeHwLWzS5ojMPh0TOryhdk9awoxCd9oXM2jiW+fOff3NNv0/5EFjPcO2rjPYLeXSnpeaGZv4o2arzl3pmLLiTMGSB/JSHHVEv2bhlVYRlnM8FrWK8PlaZupWaSNYgn5s6m+uuLh5VcnkeVt+qHnjlX0BWwURuRlOzVwwyoGnxn3imWRenq344w02sPeaUgJGlh6cZ7/+Ys+/QB/J8/OruEaPGMrXYXjNOtdScWFYXNT6ANlp6hAdW4t+PUfJEIHkUPPG1tAy4HVUC9iU8Y/vlrri4lueY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(2906002)(2616005)(478600001)(426003)(33656002)(1076003)(9746002)(86362001)(7416002)(4744005)(26005)(4326008)(38100700002)(316002)(186003)(8936002)(36756003)(5660300002)(6916009)(83380400001)(66946007)(66476007)(66556008)(8676002)(9786002)(107886003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ANrsCXrtqpb4jQUGZEVoz7VhS+ClLqXUq+AYSSDFa1+Eoe9rVAO34MyfC0qx?=
 =?us-ascii?Q?X0WwF/G4hUnKnvVW2TJ9nyCgr7ZLQUyhIVJ7Rro0U+H6sqQg4RD9PO4rOVjN?=
 =?us-ascii?Q?AuA04TKWgX/2xqqSdaM1e1vmkWB0fzu4Avsh4AbjJhv9iAw8UDDN2SQaO/A0?=
 =?us-ascii?Q?pxs/FvjxT6N6j6Uzj5hpdfFFLM8GJBCE6Z3IMgU7XQoFF4ZBqodGI2f6+OxH?=
 =?us-ascii?Q?Z+OS8Xdc3dUw9djvlkRaSK1ix3fPkcZ8QvQsLJ3ZSrOVTPFNene2EoeWVQ2v?=
 =?us-ascii?Q?2Xbkg7vL5JxMFI+dhuRBGP1T5eEU6FtHI3QnpANPCVnZ7nCx8/6vMUQ8YolH?=
 =?us-ascii?Q?Wa0qa1ftptVHwrHSuGTLscGiwR0+HWrmLAh7ZYsEw8uZ9FOeCOyUBKG6c1YI?=
 =?us-ascii?Q?f9D5mlvsNh88WkX8HXSethMg3StF61Q0o2k7391TbGAD50CbBTPpPNlisVcq?=
 =?us-ascii?Q?snNczPM2j1NFc8YjhB/yTSkmQUiw0fXTYjOtdmL+Jyy5SAssiZcQPcv+SO/0?=
 =?us-ascii?Q?iS/etX8vDZLmtM83LjtXoMxU6fWsorCI5l0TRCZp4esB87IwVtYkZ8Uz3UiB?=
 =?us-ascii?Q?8tQFLboQzBt6ulbNwjs4Lpb8gGo1O4hqx41SpoRj/a6Y+5ZM3NVryIoHuM9w?=
 =?us-ascii?Q?GoxbjLiCfJsa09T3gfm65EBTxxdhIHV9lkBFzwmq6upWMkWJXsIQai93IG5X?=
 =?us-ascii?Q?8ID4VEqA2iZIcibOPfxazsHCZ2w3Gt2vgaUL8jb6LEVKsq+VhlGRMKraB3r1?=
 =?us-ascii?Q?0fALCF5E7Yq+y7JEPb5gl4yb/zMy7HdhG1IQG8isAL+FE4VmlYCdCIf9vCNs?=
 =?us-ascii?Q?/EvcZv4HqT9Q3mStpm7ev65Gj06Xztc/Z3bjWMH9bYfTzFUrlKJ4xzbaekoZ?=
 =?us-ascii?Q?xDNqUnXw7VeIbtIBNfIkQcggL9ytiY7bt1AnvL4/cz4d1itvkf6XDXHJ8ZwY?=
 =?us-ascii?Q?GS9LZh3UZ+evOCRBNGJZMiR+g8WxTqxxdSBgGOcCrcprbNgeMubeabpdzs5P?=
 =?us-ascii?Q?Xz3sdFqLeYNdBlQ69Ny98t1P1vuyKcjAbPNC1Mxxd0Si1U9i7hr5aCg10Wos?=
 =?us-ascii?Q?mMED172Sqb6lrc/xhBcKm1jXYjcVuuunxBh0BwFGnIJwptYM2HgAa+saKXK3?=
 =?us-ascii?Q?wxHB+WGom4e2eoOeK0RkwpnRkhFAr/DRm5ZYF/jCaQpfxZuoHdLA3X+hK2lU?=
 =?us-ascii?Q?VN+NfEhpPkoliQ0HhZ85MIpfM6RjP4RPYVprkciB/b6RUedB0WxqC5sZdODo?=
 =?us-ascii?Q?z4lQ+tZxhCajd5kMlhY1Q0W+hgK7HmyVjdagz2NOB/GEr6yf7H9VdbpgHcuQ?=
 =?us-ascii?Q?owJrAGK608sDf2RItV1IS2sL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ffee43-329d-4c23-4ad9-08d909c945e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 22:10:31.6899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rankcc4EopqVIUfiVBs7zMy+igvJsPBs0HiVrq2mhGnHhivEB204SOikr+itBQk1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4780
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 04:06:04PM -0400, Eric Farman wrote:
> > @@ -132,19 +137,28 @@ static int vfio_ccw_mdev_create(struct
> > mdev_device *mdev)
> >  			   private->sch->schid.ssid,
> >  			   private->sch->schid.sch_no);
> >  
> > +	ret = vfio_register_group_dev(&private->vdev);
> > +	if (ret)
> > +		goto err_atomic;
> > +	dev_set_drvdata(&mdev->dev, private);
> >  	return 0;
> > +
> > +err_atomic:
> > +	atomic_inc(&private->avail);
> 
> Since we're unwinding, should also do
> 
> private->mdev = NULL
> private->state = VFIO_CCW_STATE_STANDBY

I can change this, but it looks quite weird to do stuff like this with
no locking.

eg the only reads are here:

drivers/s390/cio/vfio_ccw_drv.c:        if (private->mdev && is_final)
drivers/s390/cio/vfio_ccw_drv.c:                private->state = private->mdev ? VFIO_CCW_STATE_IDLE :

Which is from a WQ, if someone thinks setting mdev to NULL should
effect those WQs then there are problems...

The non-atomic state is equally confusing

Jason
