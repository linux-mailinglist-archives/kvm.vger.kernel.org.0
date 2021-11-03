Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE9A44425B
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 14:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhKCN22 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 09:28:28 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:37149
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231393AbhKCN21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 09:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4BClG52b+Xw/RV2sODplW+qUnU6yuhIaR621EDG+ROgkUJc/tnTOcRRXuXt+DiMk81pWkK85W+B7TRoZptIFvBXfDuAC496qZJ79AnSifpY7w5jNExr/Cvs883WZbAG9uO3qIXw2YDYuKut1I6fIjcPkztOpo8AY2iwOl5Hp2bWa7Gg/nopIdCAdEsI2zfU6tkmA6n0d6/HQLhQJJiE7dA5QGI8zOi3jkLz7isQwvOUO/uO4ydqkIgqwzuqnjMerz2hV+zSOnOZQE5yw3ErzrutZoD/Raxn9kyc/45f5YAeq2q3LCxMroASloV+0b1VrlmVFG6pnZmvuHPvnmCpAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJRVR0d4XZ0yQ9p59L915agmAfe/xlb/Ax3al5lJGQw=;
 b=N1KHOAjGiJmp/TZFh2VKJCSymcpT6zwNstyxew9Qx0FbCCnWpCqDcQMRg6W4cbaTrOMBVxjRMoxViKXvznbsFQiMEpjC9RL5R0FELg00WTZMsu7xyAklVRHBsDcEt1DiQ2VmLliENjdlGlBtTDeKCv1CGW/GpG/UwyMvACe47wIxW01wT27y2Wk5IJFdI1jB3Brze/HqIQIMI4lJWGYXl4gO3EsJpuBZtKiATGFIxTaTeravI/D7e2kBoPfWKzss6A7b69LJCP7Eb3Sg0GQnfLWAdWGFIIm5JA6osvjWhShrglbTJIiDdPQ1yF4biPZMy5BCJV9jKNAqKQrqnqLSBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJRVR0d4XZ0yQ9p59L915agmAfe/xlb/Ax3al5lJGQw=;
 b=Sn8LG1bV/0Eb6fgiwEXbZIk1fQCY9MihzNyO9dNC2BFFYoBe2p/iZGr9JR2B3S2FfFMEtU8HgLc5fSGGTgG7HmZxS0SZJ9nczD4iYstfSo46n0rw23sUiIk1sfEQ98YaAReQhtTJcHQMwlJDuATjQRGz00hzN8B4gU6i4Uo2IbojRVlOEhMvzSy5dl8W8yQnzV0QubaRhu25wCTVvGtzVJelC5GhTCWVT+GK14QUMsgqYuCsLyrh4Ds+bXBrizQRbJSYXpjxZ5/Dc39S92fgc4J+hEBBWiqxJPD5WOqa7+23D+zU2QV7q+IqeLwsdZZUQUb3qIruxILlnJlFZtQegA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5198.namprd12.prod.outlook.com (2603:10b6:5:395::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Wed, 3 Nov 2021 13:25:49 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 13:25:49 +0000
Date:   Wed, 3 Nov 2021 10:25:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20211103132547.GM2744544@nvidia.com>
References: <PH0PR11MB56583D477B3977D92C2C1ADDC3839@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211025125309.GT2744544@nvidia.com>
 <PH0PR11MB56586D2EC89F282C915AF18DC3879@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211101125013.GL2744544@nvidia.com>
 <PH0PR11MB565808A9C9974A0D0D72B738C38B9@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB565808A9C9974A0D0D72B738C38B9@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0076.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::21) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0076.namprd13.prod.outlook.com (2603:10b6:208:2b8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.6 via Frontend Transport; Wed, 3 Nov 2021 13:25:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1miGGx-005dfI-FZ; Wed, 03 Nov 2021 10:25:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f67a8a9e-b58f-4938-db1b-08d99ecd7330
X-MS-TrafficTypeDiagnostic: DM4PR12MB5198:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5198B1562789D3244B59EF07C28C9@DM4PR12MB5198.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/U8/yLNpAOwDnCs+/tQLZxgF+QqLUoEp39ojjk/8+atW10s4aR7laSW9K/H52Um5p+hGE6kvy1DEVO6qViKH5/q4lFlvMwHA1qBwaL4hqgiAlodA6y21wDXmqr5xTpiDLk6rLEN1272moWAD44t/ZZ520eMcma/wnGshkDUNMZPVoNMIsHS9H7FtmHPr3tf67sMX1AIGQlNXAdoO4WyTNhrVO65+QuviscK3/1EOKvA63VciItHfaOCyRC0vT1FzbAvch9C85jDiwRAQwfJu8tXJzuSI6A018A+2/MNMTFZvesYY5kiamTQ0b9EXGakvbIEnbd5L4VQ7lVaZG9cYVUK3fGiQSte9BQugZVj/Io3b/cDc3WBU/6hau0SP9WbqFLTgSGDHkU4RMRiIoGCAWqnyiY7dz45c/JGbStYeIHi5qC3+vGXYqq+sql9gP6pGGYuPOlg7eC7L9VdQdqtCRQHyaVUv2uH2gIMudSmYVZKwUwGo+8EUDkYxjLYcgws/EFllsabaQom4Ep8+SplHkD+51vkLVkRivUS3RcsuzHM8D3Gup/Kl/x7eYfQu79jSZmeCUFFINDLauZlU59aN3SsW4M3X/0Uhm5j8q01wi8LDvBWPCYfjT8zYja7z4RHWpY8pJgViaeREiLDROft5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(4326008)(5660300002)(9746002)(508600001)(316002)(54906003)(66476007)(66556008)(66946007)(2906002)(426003)(1076003)(2616005)(33656002)(26005)(186003)(8936002)(8676002)(7416002)(83380400001)(107886003)(38100700002)(6916009)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k42aeq/H0HCnICeZYpDLQ1WdbhX3ulAy42JPq08wUbYJ51/EBX3/nQT7ZHOk?=
 =?us-ascii?Q?fKurEs+jr/fX75SHbiDvtMWYG475S6SyesvT+LSIfY+WYw6IX9B6rNTCUtCF?=
 =?us-ascii?Q?MSuO+hb+mbgdtPxty+bczXyyDda10ZRcr+YiC9Ruvj/Yy6BOJQGWUR70P+Nf?=
 =?us-ascii?Q?g2c6TzRdAJDJEQyFBNxn44rgBLM4H+er7Bi4KTPClW++jw4wIuhsfAEtHhrT?=
 =?us-ascii?Q?TG/OeD48oKzLBzBCsjKuF/p8JYOkv/6UBWwbRfuRRq8p8IKOdeKLsgO4JjYV?=
 =?us-ascii?Q?i8y5Ag1rby5i0edNg8TrkuKblHAEJybEIKNMIFOvOLRg/K3frvHETJVAhKPv?=
 =?us-ascii?Q?PyvswUWI1goFLuc/kBfeUbYXD/BUwcmOixgsVHbQ4QWKAJsRrDqnsvAZMaAa?=
 =?us-ascii?Q?vuVnzdMNF19dbcwo8UYzraegR0YIQNxleHJ816TWGD+PN/oApQNpYnMTebQH?=
 =?us-ascii?Q?QMFxQhn7wU6O1l0eoZdWhoA+6+zrcoGY3doSzOUITqpp8DGlvM4OqRzq0Z6b?=
 =?us-ascii?Q?Ykqu4ONiyH2xM4sLFM4kcoXYFcrmJZw+TPoEjMnX51FaBVkPNZKoAEXyi3b0?=
 =?us-ascii?Q?6/3ka511j+nLVd24uK5pxoLsJBZ1i7pimFALbfgf3Bk6Ok8CKzL/1/jastih?=
 =?us-ascii?Q?drb+0Dsr0CH32P3LFTNWza7qqJL/Ozq/qESHI8ZiWNSYaKYR2lrQN2IPt37+?=
 =?us-ascii?Q?l0T3edb9kOZlHkqwanqHm/oD6MxsP6/piN/FcyCOlwps1LwtgdoQqT2AWTL+?=
 =?us-ascii?Q?i9AxqyMl4rcUyVHjKCONowEpgAxDk7lGoW0XukCLNDuU4cSURUmQf8PqIVMi?=
 =?us-ascii?Q?EmRKN8t4crN8atkK8PMkNvrOhWnRkcecy5T4ytpN0eBrzZA56fE/OyfZN0ad?=
 =?us-ascii?Q?tk21rdd3342RJLLiRr98BAbUdEBHlUQjmOwTv8nM/j1Anr1y/RMrGOXlKX0j?=
 =?us-ascii?Q?KogLxDKTqv72mGgYe1RGNIMQ1D52tp36pXV0Wtf8jzwhc5Gxz9LnIFeYnbuk?=
 =?us-ascii?Q?jYcYH+hWHFd+rhh5iIBca+tNJkIbjfuMstE0plHFznPJVWccZDlVGmxTLE8g?=
 =?us-ascii?Q?QVxOK9ym0m1n1q20b2iuALiZZlXynef2FM5KZYZW8SE/I6XtK80T165unSsa?=
 =?us-ascii?Q?eYilyLzKET+2ZOII4qUWRIgrChdMtYO0l8zUNmxGZvtsiQuXbCzcfLy9Lb/V?=
 =?us-ascii?Q?neTguz6/oN7Cop1crRPrikocSw4/SxmeT5FvmoJcg5bKTyqq79GU1Enn/nLe?=
 =?us-ascii?Q?SHYgDyEuolsdh+bAPVpMoWEx/tqQJ2/ZJz78rpTCVaEu9B7iuDY3vuN6GL7B?=
 =?us-ascii?Q?dQTFwATZJX300DkkoMvAtLzL5nzGmCH+HMYFEWiC6AajRAq54nHJiE6fln9w?=
 =?us-ascii?Q?U5YBwHqVXPzYbYF4O76+lbkD2JfW5wP6KtB/knjzEXyBHvHL93HkCqxe3KMG?=
 =?us-ascii?Q?0q8OSLKHyTJaxFUB1t1vOBWuKE2kr7FqZ4mLkt/PFUezSCGEpORIH973cK4U?=
 =?us-ascii?Q?tLtMiXUaR3nf6x0DyuzztiOaU795+lF0xuwheFa9Rb55dVDV677QbUZP7P8g?=
 =?us-ascii?Q?LcECQOl9mtKrrhJaEn0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67a8a9e-b58f-4938-db1b-08d99ecd7330
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 13:25:49.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmoHTOIendl7eCU1V1s/USlrv3DHs+DFLn9znv2ZvIFaaGDdtcvcuqD3YV9JXbcc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5198
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 02, 2021 at 09:53:29AM +0000, Liu, Yi L wrote:

> > 	vfio_uninit_group_dev(&mdev_state->vdev);
> > 	kfree(mdev_state->pages);
> > 	kfree(mdev_state->vconfig);
> > 	kfree(mdev_state);
> > 
> > pages/vconfig would logically be in a release function
> 
> I see. So the criteria is: the pointer fields pointing to a memory buffer
> allocated by the device driver should be logically be free in a release
> function. right? 

Often yes, that is usually a good idea

>I can see there are such fields in struct vfio_pci_core_device
> and mdev_state (both mbochs and mdpy). So we may go with your option #2.
> Is it? otherwise, needs to add release callback for all the related drivers.

Yes, that is the approx trade off

> > On the other hand ccw needs to rcu free the vfio_device, so that would
> > have to be global overhead with this api design.
> 
> not quite get. why ccw is special here? could you elaborate?

I added a rcu usage to it in order to fix a race

+static inline struct vfio_ccw_private *vfio_ccw_get_priv(struct subchannel *sch)
+{
+       struct vfio_ccw_private *private;
+
+       rcu_read_lock();
+       private = dev_get_drvdata(&sch->dev);
+       if (private && !vfio_device_try_get(&private->vdev))
+               private = NULL;
+       rcu_read_unlock();
+       return private;
+}
 

Jason
