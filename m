Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DBD73DFE0
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjFZM4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 08:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjFZM4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 08:56:13 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC490;
        Mon, 26 Jun 2023 05:56:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYv01JTCM+Ybm/G5Hlu2buU2AFzoTkqYf2yLrM2DL1J4glUvqmeu5Qq4zt7KrwCtHnkuUMtPwQPRxycqA2Zr3smcLsmuxiuNdRj0NsBxC1gAXU4kU7TSohNKzv1jYMzX2iCSvkOpHTrSeE3dwxqGNMaWSODKPUeB1nG6hBZIxlS6WKeQy6yEG8Ko0uNvlW6lQKutJqnuUuQr7wc2VnViEanQ641qz1ltT2jYGmq5+FkPeHRAWR/KLFSpVhHrPrDAg7s9QW1mHqy24s05GNTbalh0Di+gfwlKg65ghAg/RXH94krfQOgNNHacYqQr+WP8YeC4eI+tNom5rU32VY8A8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xlp/gDo9wsyZD3jo1Le3r3k3THIrGwevCIEzjYxyACo=;
 b=OHbUukMRkL1GqEYmJv4cNcYzlan2ssmyNilGg5/rg2Net3S+ZuM9QNBekx7BYN8Z6oUt0lhGMqM6LNS3b0l3s6MTOFx0H2NxJdbGVyu9pninaWnazO2OkBn87LNQvLM/mqJeiN0tTm0wbvymXktpu8sAipVNgctZW4f836bXwGj5qKfu4sBgHYq+mS2d2Vuy4aGsDpbKtDzFbQq322+ZkZ+nhE9Mxgj/iRWa2v/1pCIMMIu+VYo292gX6bWXWYXDgd5W5BGve+QTuCPr9oFCzNziNIWJobplt+rKI9dDX6zHKfr14wVMJQjFgcFojyusvaXCstQqrbVBa9p3kgmNgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlp/gDo9wsyZD3jo1Le3r3k3THIrGwevCIEzjYxyACo=;
 b=PpT2Rkn1pcaAKtORHYeA7SoT4kS2IdWIyMFa2ABytrUQcNwbwjOwVShfDZ+l4mmKLJKKWAY0jpKpDRjTfshWBbG4aVYXnDCo2eik+N/CoIqn6SiPiptG/mwL2O8TGmSR0munGjVXqpFLrxL5N3cDVIbmgpxUDVAs/ddZvQf1CTZsh9gGmu28on4/b6TTSBSCO1JQtEndI9dpOaIgMo9wZDbAWClL1MESGxM1wA+znAv5MssLUmqOIEq/+Uybar9rdpyvJvIjVae9EWDcBQ640k6x7pRcAl/qrqVulzKNCTOKevi2A83JJWEeSZxNXB9xRc/kDb62PNiZWhwTZT7Pyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6916.namprd12.prod.outlook.com (2603:10b6:510:1bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 26 Jun
 2023 12:56:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Mon, 26 Jun 2023
 12:56:10 +0000
Date:   Mon, 26 Jun 2023 09:56:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZJmK6ensADJS/kms@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com>
 <ZJXFEbmY7BOW6QIe@nvidia.com>
 <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:208:237::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6916:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ed4766-8248-475f-78be-08db7644b6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CD16pyDBPDs970gs1VeANrA0HA/IaWyIukUpsTUrSUPi2C4B/nDNiUW1FkjFIacf2PL6TrqeMTDvEnGgf9fwn0zcIux/JbBCH/DDOgzDaQAQWEitSacrFTkW3qyf6dlALqK/h6TgqIv9jdk3MWcy/5Cr+Tdc4ubhe36l9Dukmj2G4UZnzqQv91wLPddhdUh9alW94Ft/D2ybe/LzVc4lvzxS+2WKDMV9m4UdqCLraLXAmFEZ79NYCMLOB8zZYuAACtSIJquw2OivDFxndAlyvh6dVnrcEqZosQWKUDzqiqkwCiaV2rvrWup3SY5AAfL2mXXatbRA26O48Tf5OfiSd5xJXXakyp/KxW1N5ebM/y+maP1dJydHyJcY+nx1lpqRaPN0JoCQ8SHUsp5LFya67ll5wcLSEFwWCJZN8cyjkynIQdM3YkkwGolZ/lY9ruvzEhWBvhaeEltBL5kXqEROtYye1OLshfIktwCSzzV9Idd14CheQETmIhtm1hXkkCpBIbkPEwSzD0APZRQwR7aMui8jevMWS/4snD91vTJVkcTvzLrSwkRq8FJ/x5ivWqnr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(2906002)(6486002)(38100700002)(2616005)(83380400001)(6512007)(6506007)(26005)(4744005)(186003)(41300700001)(54906003)(86362001)(478600001)(316002)(36756003)(66556008)(4326008)(66946007)(6916009)(66476007)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hcIl/bIfreBR8MmmR50tT7cJdRYsCwXhY6kOk08/87mpC74JfwFXCM37OHos?=
 =?us-ascii?Q?MZG0FFfl1k+lyZG98YFBKZFHcU4XEMyOiM6Rkx3XHlLKX3/4PbBcMOCJ9HW0?=
 =?us-ascii?Q?fuT/iZ6Ttq4TwKG6JNYfX8PTCZZ9bjVHr5u6spm2WsSH7dGtjKwc0IgK7GtO?=
 =?us-ascii?Q?CCJncdkWFKq/FKR7SHjuj/x99tNlIuTLNb3+ANHs3ZgoOKZm7ADCJqTcJmy/?=
 =?us-ascii?Q?CB0xkaGa8bXIVBJdxAIbnX+/x7DvnQ9pBc9C0Wvio1Z/8UpAKc7gBGrkZiUs?=
 =?us-ascii?Q?5KTzac0C9u/niBwmo0Vw1J4WJ8DP4SrfHa2ntkCGVDMqajDUZ9FK5TnAU0PZ?=
 =?us-ascii?Q?GaZKW3p/YqQIbixukTO253at396Pm8uXQDmiwbNYH9Wt6o9IFsPoBD54grqW?=
 =?us-ascii?Q?0K5D1NankXpcEL3JGBbWWcImMFwrmiAZPXXewzouJM6+iO6ToA5N/doGTRA4?=
 =?us-ascii?Q?asXmhOFv4rqzG0wtmhO4hZLvJ8zAXSUbg/H7+hN6UIzNplXTr6/MAdAog2hY?=
 =?us-ascii?Q?nWaKH5VKnSOcERw4sIbSJWbPZb979/I1PZjATXgVtv2C6epbnOUvUGH/s4/n?=
 =?us-ascii?Q?pNlX3UJcAAez35SFR9UEn8hF2g4YG6tFcw1DOaIKvnQuWRkTABWQSmieh3KH?=
 =?us-ascii?Q?QxTw/Z0fSZatzoxX21VY3P6obROQuwP/901dMBeQW9EXZkhdPXl4ZgHkgPXs?=
 =?us-ascii?Q?RQtH61j9FrA4HxuXSu8MP6+M1nLl8mlfcrOd6P2FlNXwg/ftGGDMladoDyFP?=
 =?us-ascii?Q?NfRON1hxf2HrpKARykGbx5vEGtNJaoh7y2kEAQSN8UWkQfXD4gHUnA1WAkeV?=
 =?us-ascii?Q?dpw8yYojKOcQon2MEaa6utQ9kSSJlOkZZVHkVq3hkfbiq4+m7xT5N8R+1NX8?=
 =?us-ascii?Q?He3NIFaCANcj5v64IGWYe9ydlMBYW3h7Nxop0ax+Z/DWh2rC8aqLxKEpaEqY?=
 =?us-ascii?Q?DgJ+115sz+1AxUP9DMO4pPYb9MvY70KUVqKrPi1qGY9p6gs9VWsGeuR0BevV?=
 =?us-ascii?Q?fgPkBKW+/mlcK2oqjYEozdI877VJmdaXXtDhCC2AAj+mLhxLQgzP3AqF8w1L?=
 =?us-ascii?Q?Ky91DDY1xzMfmqOjSgY/jgxdz6JUL2M+NMZpPoMD2ac3FLu2RnToop40/IcE?=
 =?us-ascii?Q?4ndxLXQa1iTxOMPYtsl+AaB4KCAKKaZBqri6HSI+xbXazOe06tBmJVKBKafC?=
 =?us-ascii?Q?Iv2XQGXDo5eH9lqlzUYZUIAE9FJgBfiEHUfU/DwKfPbwMgDPyeXI+s5InlO7?=
 =?us-ascii?Q?X2tfKNGR2WDyyh6P4GIzny0Eo1aVYlRabAW733c3795zgU9vqqxyq8UUWj3t?=
 =?us-ascii?Q?I4h6ilMTbFjU+e2NFFhI+eOVD67lrCaOqV0w92a0pWCbtAL//MGrLSFfKIMy?=
 =?us-ascii?Q?8KqvCPxgGavd81WwfrbA8pbj+/PquxvSFoaQALw6Pxv/IE6TeZuyNnoXuv1z?=
 =?us-ascii?Q?cCDHY80HK7qzNsdwyoeRJ87odcWXZgZSr+/kqRkUhtWf+1EKiys8vNRzv7IX?=
 =?us-ascii?Q?9jrTKM7Fi4BhI3Wnz+CW6Pkr//sXKPYp9zC8dgfdghtdEan7hdYWVrT3gL8o?=
 =?us-ascii?Q?90XDwo8r6npmjKFfXwJs8tnp0LyuHgWXuYpUsuND?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ed4766-8248-475f-78be-08db7644b6f1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 12:56:10.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLY0M8TM4TjjQt/bcTWXlgDG/q+sCezHMaEJi94YSXynsx9n/BFn2DfonvZj0pxu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6916
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 08:34:26AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, June 24, 2023 12:15 AM
> 
> > >  }
> > >
> > > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > > +{
> > > +	spin_lock(&df->kvm_ref_lock);
> > > +	if (df->kvm)
> > > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > > +	spin_unlock(&df->kvm_ref_lock);
> > > +}
> > 
> > I'm surprised symbol_get() can be called from a spinlock, but it sure
> > looks like it can..
> > 
> > Also moving the if kvm is null test into _vfio_device_get_kvm_safe()
> > will save a few lines.
> > 
> > Also shouldn't be called _vfio_device...
> 
> Ah, any suggestion on the naming? How about vfio_device_get_kvm_safe_locked()?

I thought you were using _df_ now for these functions?

Jason
