Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39B96D2656
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjCaQ4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjCaQzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 12:55:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CD840EB;
        Fri, 31 Mar 2023 09:55:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBXEpgJ7hFETCsH3u5w3G79Oor/eYHI0blfcErjhVyqAP2GnUUUgZTVveagS0MrybYQrPJxYoDZSqiOhu6J4h7rDZ+se09qEwo5onxjFQ2to9Na5UJ92Z6A59ff1LBwPFV5C59PbZBOGPujpzHSiFM2/9HwURXRnEzdzAw2eeuqiCBLLHvHGtJ2wofvWCSc2nJisjSUH/YUkPflk2qiUdP0sz1tT5x96//MJWSx0IJmp++xCNK4eBH4uaVESTSks49FL5/JgwaStkrqhgiXr7Q8Dmbds1vsWV1dM7gHChK6WMmfGNODERabGQvxhuG/7Y2+R0AWFD0AKrmf4g9Kfrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKuSaQdcgvk84/VRuD++B0qXBXqqw2Yvf8rZtFObKPQ=;
 b=MYJh74wixfvJ7/NK8lOlmzzoI8tfyTFXeFvz6tbzJhe7AJEFHfkCP5ofKyQK5uVxuNBxi6nIMgCM2Lm5Bb71z2iN3Ay4vQQLtE0+L0qVzis2XHMK6UAwHXjFnfTKyXcqih6DfqvN5g4tB5StNQ/9HNT/SDh1zWyWFkhu2fStSlmpkKD1vfY6tHQfPDLCXmEYXup2vn5bc9/VdaZXFyvzXRvVjkxZpm+BGlLIMSRsdXfgl/khpyzmCb5LQ6DVQlEOJDuJMk8Cz23Zhdvkaz23BWOp7WEaQ8g7hjwxhiquBwWNxjmtWC+PlSLtCL/MmBT2tafIXDWGKhSA7DiERimb7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKuSaQdcgvk84/VRuD++B0qXBXqqw2Yvf8rZtFObKPQ=;
 b=UID9jHa2S9igV8xlNl7+TX9L2gebjCNov8OyFHFUo8Ne2m58Nv3EOaf4qf761WT2G1kfOxuo/zqTNilfbdz169p4I1sfyvbslib4XUJ4S9mpq+zUoTDPM+ffJ6pLBlt2PzJ/ty2YRCOtlf0D9MsBNxbnLJCcXrkJl0oh8dsIzToQvnbKc5a9QlvyI3Hyz352q/Y2C95PeByVY9ugWKfydwFtbwM6mvUIFVEeMbDBDOTTnwLPSWBa6PIS8sJy003zrnqjdmT4Ad2SXmBW+zeryVF9QnAg7wYxjtkh8Qu8bdcB4lof2rwdPl3mVPhAsg6pkwduMgvrX71z/Gdasq0Wgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7692.namprd12.prod.outlook.com (2603:10b6:610:145::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Fri, 31 Mar
 2023 16:55:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Fri, 31 Mar 2023
 16:55:39 +0000
Date:   Fri, 31 Mar 2023 13:55:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v3 2/6] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZCcQik6KVv5nl0/H@nvidia.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
 <20230327093351.44505-3-yi.l.liu@intel.com>
 <ZCSYqHIo/QrFL70C@nvidia.com>
 <BN9PR11MB5276BB3F0494E0CAC07AF4918C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BB3F0494E0CAC07AF4918C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0354.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7692:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd488c8-10fd-4c4b-bcd6-08db3208c1a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddzy8whTZYx/MS8a4F0uxKmvFqPExijjq7eW7gicuipjMcPBest6ge3nUFJczhjSmQI+hMDtKASgZjXR25uGXMeBhJjXTP7khbQjgLjPRkn54vStGpnypnNY3AHm2PiAlKU3KUM0HZ14BbHoUt3tSgvxNCW1YW+PQYGmZutGP5agK2Bc8Wcm+4vxSp2cQqn5e/f+ePYsnB1mmDQ8pD45EROgVdBhucrbFDfRu9vm4egqwAyKrgqZQMrY4h7R2zj92tfiwau9CU8dERfkhzI7OOx0+syuD52bsluuuY5gnAcRq8fJD6u1hndi9YC+9Pfdr+8Ak96/TNrce7hmqvNnxiRQvck2/nqLwP6rRf19rxExAkeJ+ksQ068klv6JaQsvGCMWk6XmT5HmigQONNxRlnMy0KpNzrhegEPrIcKtw5pIAB+ie7tEOfQv2FcufJDs5wQCFKqN2WGF7NgB72YZO6dUTy6/klbvr8wdS7SNb67TbcmqY/iGgI2Y5upfeu51SC6c1Omq9YcQWfv0FTzQ01MCoGjRpkRG7wcqFgoQTYNVZE5w3EA50M6NZGUCzvah
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(6486002)(86362001)(2616005)(36756003)(186003)(26005)(6512007)(6506007)(4326008)(316002)(8676002)(66946007)(66556008)(6916009)(478600001)(66476007)(2906002)(38100700002)(7416002)(5660300002)(8936002)(41300700001)(54906003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d0aKCYxwRQ+WUiW10espYpjj5QwP3LD87dFJK153MhPvG83zwb8bGd7niGcJ?=
 =?us-ascii?Q?zdnjO58h+ay/kdmryMZtTuvanvWZ7ld/QRdvABDJaxwCM2iUFbHgefwxCK79?=
 =?us-ascii?Q?yVHym6cuufBzGHDYvODXVOVTuJswMtqM62ykq301cKGhO8kY7H0BoO1XkI5/?=
 =?us-ascii?Q?afO8/9Y7hIs3aD+aru9Scr0PLKNYQ7ksN2nXUzeLSE42SadY8e68AsYqAm7c?=
 =?us-ascii?Q?FmQiP3Z4Hz21ZGWH7CG6gIriQJ5+87K6TCOfu3ZRoMZgAaSkL5dpkm4g7Yzd?=
 =?us-ascii?Q?ykb36d7ZJ8xX371+NWUu1BqVRZbyEIjf5GHahLXf/odjI7CIDL4Nsod98gUj?=
 =?us-ascii?Q?kZKgp5oB0zA4wvU3l1+3eTyvHpuU3y2AA6XE3tk8+1C+lLNbAdMnxDKlPVyO?=
 =?us-ascii?Q?11apNtNGtTbf2T8R7IZCUGGCKxO3UJ5KNdI1xVAtRXasQudCjgtWxqI8SUHA?=
 =?us-ascii?Q?WXG627GNIFXdLD8b66t1ifkxscBsrruavGuZqCbNDk9FZOZuAUgkYiKmo5m5?=
 =?us-ascii?Q?3Oy4FId5TarfTihFSFLg2LEUGQ75TnEnbhsj8vbEpg1hvyPiYtkDXBJkHws9?=
 =?us-ascii?Q?IgtA/O7Sm1Uv0zV2YNZrrrR4U+5FkB1I5UrzJ3Xiy+70/TQFkPKcDXv4gUkn?=
 =?us-ascii?Q?WsevavZkO0HjDe7bOZRxRPDvY5hyfcQQvQhVgMHQV8v0AdxxkcB+pTav1nSn?=
 =?us-ascii?Q?wZ+0th+q1/2SLEHIPXHhMWWiKKpzUdUToql28OYR/svp9vVntmo7ckemZg/h?=
 =?us-ascii?Q?9BPFATC3vl6PwBZWHNQP9HzNk9EksblSrsajzj/Gc7miTGTMw1AVKcLE3frY?=
 =?us-ascii?Q?/GQaj0T8Z89T7z6oqVx/sl5RlANZgEfEqZwgxuCzQp/OubAbzIZy6dTcnlkT?=
 =?us-ascii?Q?277jBQN6kIsZQVZVt4rGJHMo2xZ//zNk9GbLMleFf8lXBtmWMUI8bH0bsRe8?=
 =?us-ascii?Q?9vraiPTscPzCIy8xnkp7S+Sccr7wgF+j11IfNdK7TSgfK3maBy2c5iDEm0Xa?=
 =?us-ascii?Q?6Nl3nVyJA5gxA+t4zmLPBEIIDOpGeugFkG86NWzEXTNZNMBWH5/w7nk5NCVO?=
 =?us-ascii?Q?aGdQSluOVKbjb2ccwy2B9GA/1EO8qnQw2b+95lzMIBfraFAtSPDNWsiADV+1?=
 =?us-ascii?Q?pfsbNbwOtkO5WmZwmKBGnaR8SKF/jMJgimofl8unAzI6Yfh22ICbT5CJv3HE?=
 =?us-ascii?Q?yspiSufWGM//waSsA/ggdZU9+OanXvOtgn5TBfzoSRLNlTNz6Tfn6BchbM3O?=
 =?us-ascii?Q?AW8r3kWkGw2qpyi4ipTF+L8hjTK5K0Ff7bXfz5yoNjWOOY3mCkyMzes0VI11?=
 =?us-ascii?Q?I0pexYiT0PFOeMYF7j9SqGXZ+pdoF0OS3RTRm8SLe9IpQJJkLty9XR9CCwN8?=
 =?us-ascii?Q?p88A8lV/81PJBPLi3K1h7LQFwi25eTxgENEvg0Z1e3BSpHOV9rkh2C+cn7f4?=
 =?us-ascii?Q?h3IGIveBa4on3BLRDSnIHyN87hdI3Thhm6G9c7q93rnK9gW/uf37ahMnorFj?=
 =?us-ascii?Q?ahpCNY9yBHL4XeLPa2Wlbvi+H3co2ix6OBF7u5wXyt2KGohTvGUmevz/GmU7?=
 =?us-ascii?Q?h5p1ilqxyb4vYNszBFltizanScQQBlSb/BPFn6ZD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd488c8-10fd-4c4b-bcd6-08db3208c1a4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 16:55:39.5185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: st22l41kwzw/Ay2vL7mfN1/mKkhcH26795rt8+SezQefsSva8WW1FfPiIkBrY0Od
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7692
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 31, 2023 at 08:16:16AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, March 30, 2023 4:00 AM
> > 
> > On Mon, Mar 27, 2023 at 02:33:47AM -0700, Yi Liu wrote:
> > > @@ -494,6 +479,30 @@ void iommufd_access_destroy(struct
> > iommufd_access *access)
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
> > >
> > > +int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> > > +{
> > > +	struct iommufd_ioas *new_ioas;
> > > +	int rc = 0;
> > > +
> > > +	if (access->ioas != NULL && access->ioas->obj.id != ioas_id)
> > > +		return -EINVAL;
> > 
> > This should just be
> > 
> >    if (access->ioas)
> >         return -EINVAL;
> 
> the physical path has the same check:
> 
> 	if (idev->igroup->hwpt != NULL && idev->igroup->hwpt != hwpt) {
> 		rc = -EINVAL;
> 		goto err_unlock;
> 	}
> 
> If we change here then that one should be changed too.

No, that one is checking if the another device attached to the same
group is a compatible hwpt so we succeed to attach the new device

Jason
