Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C6D6D040A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 13:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjC3Lxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 07:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjC3Lxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 07:53:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C10D9753;
        Thu, 30 Mar 2023 04:53:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Of/J4Nmoc5ORK4uTlxDhyB0q0HsJsew/qFOmevO2YlKKHtqgTgtzAZq/70wVXDjnM9dA1n7j4s8E5XiwJoJBMt4bMkXUoaFUfKhOTVAzP+HncB0tzLfj52Plw4nLn3JANj4Zaoji8bwQGJoYJdOWlIhkU2wR6n2Q5TlVRoek1cK+f2He8PyYpiOQPgm06rdfN7lKlaBj3sDIHzq8azYB++ewhxjmKeJhqN0Rb/mc9FjP+dpuLJbJgxSJRSXUgk7EBbaROB/99Dpq/02yMi6l4RL7IWBvSl+dpXcdj0jo06DpHt/F1F+i0ETjE4hR45QJIVQICW0mDN/iAS+RAQVAbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDiWNIhyeYLrYny55TvdPFac9v3rMAXRtk3dNuw1Eik=;
 b=DVHzSwwUJfo38/rwU8vJ8O7AE4Lie9V0fN25tcUnVNEnce+Upmwn+4l1IMwV9QGMZjc8JfxLxnB0bW+y36MkTKsSk6Ftau1ypGs2H4tdgJQn/nVukFonnMpvtOJH3ZIz7ozI8m4RqX2yG27vcT3L0yeqTY5qbbDGNvwcyVn2FlVuoYhP/vU1S6kUpGZFSUdL7SmYJKc2tpzvNEy1RqeUBQWR+FsNRmFtrmdNB3tsBRf//DYerOXtjB3EAku1vWza6QYNs+FcQi/tpA/NaKHR0460D5zrsyVcn5ZT6OCLL9Mr5wqCxNwQSMTd/kiOAa2kdpVmGhHzFJq6vALgqWwD6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDiWNIhyeYLrYny55TvdPFac9v3rMAXRtk3dNuw1Eik=;
 b=bBjYtaT3TS+JfuPlMy9noC2WcH8PLBMZ5Pwli3drlclE9JXA75Mf1Da3S2kQqIFEH+ETis2/8aOsGs+u0psEukctB8uEWNkrOOn0E9EI2k+spwN7JZBDKqmTKTM+pVFQ8BfUDGVWNfuH4Er7W3X6zuwLSGlucjITgX4NLY2p2vR1LxhjO7MWlRU+u4bxlGKxXYMa3ixmmbZeCJOqlfNKufrtLEEBM/j1CZGUHVJLvSbL7dTmgoWTEIzx6Zf9ySVesQWVT10GzZEdMhFh7PE7AZML91g5KGNskZriIierqdt3U7Kh+W0BucGC3GmktP3War/0Z+1BLhdLLJxw/Bzgsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW6PR12MB8664.namprd12.prod.outlook.com (2603:10b6:303:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Thu, 30 Mar
 2023 11:52:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 11:52:20 +0000
Date:   Thu, 30 Mar 2023 08:52:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZCV38yPbzSRQcsRl@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-22-yi.l.liu@intel.com>
 <20230329150055.3dee2476.alex.williamson@redhat.com>
 <DS0PR11MB7529A19B0368DA4769444B84C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529A19B0368DA4769444B84C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:208:120::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW6PR12MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: e52ca783-b02d-467b-7f1d-08db311537fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDYUJeBJrsCloAIP9VgElZ2REQvc2SYFlj0AVoiBFp4OwN7sC20RaTJmhalGvfmA/N1LpsPg2XChFB6yjEtnUBTHOY3xDQrdHLSTTPtReGBbTg0oBXi1tiwDhOCjlZvXF2wh1Zj9QyInZstjri8h+Hn51/XU18gnIUYfMoLyJVVBCNcNcvV8uMzQthJALqBGK6JyxT6A+xNJyEEhCLhzA/CXVz+vhHVgs47HPy/3jrYmnxjsIjEjX+ZfX44N3i0sdpAqMzlYcdOxPbmzhHWBkhxqkXTackBe+vemZM8+ZSm77g0vvg8m28HSc/t6IU/dZc7e6uN0U3HJSV/kvz9Pzx1T0M1rwCjl47Ma795YTzizZE2ySI+1QOYw/Qv3KeeqhIRXVAAwZV7ySEOUpXjE88LDucTfX/NdWRMDZ3QyLtyltxhzml9Em1k7S0mbMh/6JXVVojimr82xXD3YHnyF7BsgwZ316/RLgeYNDZIuN9AaBC6PYktKj4VHcRyxVGsPhFTJZzQGRmTHPtojTIfBFazT0wjo1iwEFr34Z/PNQ6egB50eAqMTm+k+rt47wkEx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199021)(36756003)(6916009)(38100700002)(66556008)(8936002)(5660300002)(7416002)(4326008)(66946007)(86362001)(4744005)(8676002)(66476007)(41300700001)(6506007)(6486002)(2616005)(26005)(6512007)(54906003)(2906002)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I7gonf0cbXvTnt7T3euxzyyHO5wMgSES6+EFJhCuO/cA67aASB6sJx6FXjd6?=
 =?us-ascii?Q?nv3LntPYKJN6oNb5NBkZXQLh+q6zG8IZPjiRjubk+471lUack9k0LpIw+idW?=
 =?us-ascii?Q?qpfqMnfiOPtxKc7ZXxGF5sAkKZ4P1Vb+40qgkDRlGChUB9sNXBwmVeeyinMc?=
 =?us-ascii?Q?LtUdXecMtKpEqS5bEyQ3eg1zMrbPJgE7Kyi8LtjSnU8G97Y3saKmRNZJr7Xl?=
 =?us-ascii?Q?kOppzcI1RrZ3XJDMkS32hZabl/VMR1hMG38XehW6fMJhDGrgFCTAJ/3BJo3l?=
 =?us-ascii?Q?DOyf74ZTObu1ybcK+jfcUbTLDWIu7WCwihBAgUUBwHgk740+eEhH/cM7XbHj?=
 =?us-ascii?Q?2gcxZO0nV9U5aVccCT+Y495LJQOj219VRwClE5gmI/AcbCYKmXAjK6H1y8zA?=
 =?us-ascii?Q?TpijGBCn1A88zXQBJt5Tqzg8GJVX+tWbrGrp09W7OjJC/JxiQUEZEattYc1j?=
 =?us-ascii?Q?3F4c51YwkeMFF7PS7b3vI54gPGxk5l93ottnRaOfoqmEiuW3lNMvl/nFUbz2?=
 =?us-ascii?Q?d+9CHTXdxqpDnjJ/FmuVMFc9/UuYMdS63OJzNbCr1rzfJsZhlh+N7+UPR/iy?=
 =?us-ascii?Q?m9AlotcIndkr+2V/hcrWDPtbpvOMv4Ded5G4dvUXNouQJMfYd51v4ypmdVle?=
 =?us-ascii?Q?xLWYRuHFBJ3Tit/hMhyPnf/NAkeoYMWw5FqWqcUdM3oS8UJs/QKuKAPGPVQK?=
 =?us-ascii?Q?iETC80qibvNilWJUzh+gdFb7SPKndcx8popsjX0pwbba4PKhUtLxFE5oqxVN?=
 =?us-ascii?Q?oH6nbb1/osRW5/Z1vaWUrdKPEnRjr2qG9QIZIG4e6DKyhIYHk6ze6Tz1LlRj?=
 =?us-ascii?Q?WHqH6j/YgL+xO3MflceCe1nICcUwJCs4I7a7p+lpwgaXWM2UPeTNr7Ki8CXF?=
 =?us-ascii?Q?bZiOIVpldBtCclhzKSscLqftEqYEZGoFKies5tyi9ZmPE30TyLHXTRcxJCKf?=
 =?us-ascii?Q?0fUQRML17BKys8fYkrwJe+V6xmL7NirkNSWnJ4ReVm8UJ9cONB27Qj+veOVC?=
 =?us-ascii?Q?Kpb9dwNam1W/LVmva5MZNh1w+eQ+wotl8m8gZk6SXkKLX4C4flQcftJ6GWt5?=
 =?us-ascii?Q?yNWXHWEQce4mfJy3FN1BZ8emeM1YyldBO6SHQaojGV8KjOakguq1vtMHUCW/?=
 =?us-ascii?Q?I1ZGXyTrR64HP2nilsGtzNqIGWBuhz4fUjRW7MPxjS+FdTVJHR0UIq3/+Cuz?=
 =?us-ascii?Q?MT5rn1X+vgFhhvgT8IQEc3rrtepqs1Ez95QAPljPT8je06zbLX9vw4gh6Ef1?=
 =?us-ascii?Q?I7P3+3QIX7x69xomf3yPWcVV0GF72CGOaVFpJ4c9o6LyN1CmSyyRPwG5vanz?=
 =?us-ascii?Q?apK06t61l3Ml2zXN1bPqdl5XYUbt/oistEzeq7IklSQ/tRnIMhnefrgf+qoy?=
 =?us-ascii?Q?4VqzlTFpFtLARhZseTIFhCqdwsL2UxK9Ljxlzd+XBGcPQ9CdfgrQMjP6IHKu?=
 =?us-ascii?Q?l5EB4rWWbaPYRlToFcXz7QCioeoGUJL1csl+4FswoU3dCrlJt8ulOrdqohuT?=
 =?us-ascii?Q?8gqILmIjmesv/5ROlZ3bYwQyAEWsRxrI94MDnwVrlz80PbXuIU5qQOjC9+0F?=
 =?us-ascii?Q?wW3MV3kw9yNW+2/qtfBfRUiMLTiPjGSvYuqMU9cz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e52ca783-b02d-467b-7f1d-08db311537fd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 11:52:20.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YtrdKO2x/kPdZDoCEghDzwCGtaNNOzZSiZgD6tqk3OqcAGKd7/S68hftGEvxgCR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8664
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 07:09:31AM +0000, Liu, Yi L wrote:

> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    struct vfio_device_bind_iommufd __user *arg)
> > > +{
> > > +	struct vfio_device *device = df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	struct iommufd_ctx *iommufd = NULL;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	static_assert(__same_type(arg->out_devid, bind.out_devid));
> > 
> > They're the same field in the same structure, how could they be
> > otherwise?
> 
> @Jason, should I remove this check?

Yes, it was from something that looked very different from this

Jason
