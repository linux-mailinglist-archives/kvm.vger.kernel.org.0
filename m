Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710BF565972
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiGDPJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 11:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiGDPI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 11:08:57 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10hn2242.outbound.protection.outlook.com [52.100.155.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2568E12D33;
        Mon,  4 Jul 2022 08:07:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EohccX8kkvESKHrJKa7nZzhRa4aKOtPbu3lqdFkLMUMVYhbNKPYHgbPfYkU6UKS1bhhoAaBLBrRDeF1+JIqviufflkLGa9whZAOLkPEtYcOZDhhRVYQ67HDBSixjhJRmaIDA/Be8NV5dsbONGz7cxasj8aPvQ7SZ1V178pZSwxO9kZA/9P37byNvkl7sNOrNqN0CnsvIr8pw4BFfGoz7IM7zQNZOkURLTpqCGSEePUEqCUM4ow+9Ik3PFIVGZo6p+VO6y25M1vamgXN2nydwTLvave7n65UesnbB+uGs4nKsGPP+DR6Fa9U04oAAqWjcR/sPeQBd8yBNvHuXr40s9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAOwMpqCWXN7IBR0Z6fOWwtbAxIvC0B3IPs/+wox04c=;
 b=YvixFL5tp/p25JzWVzpd5bhgCiIZhRB8d1UNEs1PzmsuHq4u6Q8yyz8iYfrbj04ET2yh5vCBOMbDbYBqTnZiM/sewfF8Oz6h/zSXBnWvWaZ9IVJuSgq3UQck84UPhDyXol2Z7cEDa1BW4wf2Me4lZs0BvvzemxbwRteqC3SGVh5tgxHyFxGuq+2l+7QQTagqzWGO1taXKX+X6WmAezgnV1WOvNK5wAuVClLC6tr8RHHHiqy4AY/n4njpUPOBYDqyOjOyOsYO7FvDumhB8AhcyBFIxjjoOKeFxfKHu0E1svyWWZLDjO8TWZpuFU/j4rpg4sPbhW+Giz44E4wZD9mVTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAOwMpqCWXN7IBR0Z6fOWwtbAxIvC0B3IPs/+wox04c=;
 b=URr66Rpn7DIp3sqIjSCZFtZM627KhPvf7JXkfdtDLhzvWgNUXncLN8KZvKG75R3JWRUPPOI7QK+wNO9rCaosAvAjm39rR3fzVtC00yDCfL1+K7IPwnoKrR2K4H+PR7hsm5gn9t1o7r3ecaCUDw4XhNFOn2lp6j3K+VM5faqyY+uSHLYtfTEDsN15EUQ4cqp9PmS10Rzhxjn7epqGD6kmIhMmiBe1umUUeUMppSATYb5345eHDQfDaUSu21NQI8OAMOTkd9Swp8U1RBJLBucnDst8W/Kaa7I3Ge8mCOlRMBuy+2IO5LVIvtnO42EGD4okHcjmzKOZBFjI6iXvhLXtBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3003.namprd12.prod.outlook.com (2603:10b6:5:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 15:07:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 15:07:37 +0000
Date:   Mon, 4 Jul 2022 12:07:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 14/14] vfio/mdev: add mdev available instance checking to
 the core
Message-ID: <20220704150736.GQ693670@nvidia.com>
References: <20220704125144.157288-1-hch@lst.de>
 <20220704125144.157288-15-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704125144.157288-15-hch@lst.de>
X-ClientProxiedBy: BL1PR13CA0262.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6514b18a-1ff4-40ed-4d70-08da5dceeeb2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3003:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s+oMDHtHHuC1+zulw8kctTOBwWYDbDC2evdWiEevcatVL/fhMaCQyv20wRRo?=
 =?us-ascii?Q?BwbBsoGgeVT6owBILCy3OUR/M7IHQ7ihWYtNSUvOHKm3ZyF9oNX3Pq3Y1KOg?=
 =?us-ascii?Q?OYGmRFmlJ449pcaAo25yGFzqON8lfmJPsQfsWMNtZ0+aC1bN67G/m2abksQr?=
 =?us-ascii?Q?l0VxhigcIdLUEJhcUuC1TJ5LXPypV96s1JkjDeeh7vawgQA6qLn1JWJ1Y+p0?=
 =?us-ascii?Q?qrxdAcxwaafLvlEHDIweqwOP2rbzQ2b6p/Xzpuq/oyW3Cd8YDatnwuz2W0I8?=
 =?us-ascii?Q?ptupG3DdDbQlAdcFcw2+77NsnwxDaWpbehEv67T4nU/5ISHi4bX1aEYanlgF?=
 =?us-ascii?Q?/ihnrvK31mAaAHlBnrs/eN3VPX9g6R1hGw305foKk+fsJ999cBhOHwuff3Qd?=
 =?us-ascii?Q?P1ALYHU4+1LS9uyePDVpHHagGpKw2Sdoikw06Mtrj/lKy9htwGS1RAU8Z+zb?=
 =?us-ascii?Q?NSWcD9nU3a2ms5X92Wl+rAe08IPQOEUZVZUQkkdwfLmRFfm4uhzHl/y+6ieV?=
 =?us-ascii?Q?Ur3ERR8mNUjIfv+QAiOHJvsw96ZY0dQOyPiV2pqwiphXKHSJuJdVo6xTQIiX?=
 =?us-ascii?Q?PmQj9NMHrt4SemDIxxEHC0Y5F9FYuAcmPmLpgVfXzJ5P1zI0pKhh27kLFwdu?=
 =?us-ascii?Q?ytAo97+XnlFNaXVrGb/xUG2p/ewEH9Bp1C39gbCn4eTle9lspEwQ54MAwMGl?=
 =?us-ascii?Q?cFu8boukYFOYuOowjX106dUmp2dPPbin6EqrzqJQO62MNjaItyWs/un+BAHP?=
 =?us-ascii?Q?axtFiTKx2K7gHPzRi4SBDg2uSV1Mgx8btkT7AKIthej/hwkkonqawlpALKuX?=
 =?us-ascii?Q?E/vcjHS+PguPcMXRM/y2lkCAxtRLNYa+CPQHbAiXK8z6OvFRPLos/Tg0poS5?=
 =?us-ascii?Q?eSPO5XBr/l6Pq3/472X/B51DBXcHJStmnTyQQUP5Ev/8WlPRvi1LhmVx2L7Q?=
 =?us-ascii?Q?L4PdTRfT06CDXuFAybK8Ei/6eCSI3JxV3NgspX1SUKPlfHnCdgeDGel7g6MU?=
 =?us-ascii?Q?O7A8hzDcr+GTNOi4E/CrohtFPO6zz3yryIpeEHH7ClrbvRVoQsmoiN9inJiw?=
 =?us-ascii?Q?Ekh19CkPGd1LxOf5ipz6jjdztu5oHsp5vqLos3hMF1h/9MI4UFIAcYKhhqGj?=
 =?us-ascii?Q?SIuFGAq75mrKqIHRN5Vp9BLil1qGbNxXPg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(83380400001)(6486002)(36756003)(478600001)(186003)(4744005)(7416002)(33656002)(2906002)(8676002)(316002)(4326008)(66556008)(66476007)(66946007)(86362001)(2616005)(8936002)(6916009)(54906003)(1076003)(5660300002)(38100700002)(26005)(6512007)(6506007)(41300700001)(27376004)(131093003);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mBtKTSApWrhcLM9hw9//QUneT6LKnw9w8BnlHUfli8xLZ7sKgw/axyhfJIX9?=
 =?us-ascii?Q?CdYpkGTMi2H5+ZzhAQ/hVwLI03GO9DwHssu9y8ityZ+Qa+LTBDG1gth+LU0q?=
 =?us-ascii?Q?lErE0bZUBHLwPFoGhhHWgmn7gUSXeAKEq7rvajOw5aZMdBdeQTAzr10rgDG6?=
 =?us-ascii?Q?/2trCS2cu8jviVRtiJE0A/OE9di1Hi4doO0udtCXvtZ5NOGaZ92frjGhL94A?=
 =?us-ascii?Q?jHiCksxDsDaoGTSSAGbF60dnvO5EiHUOG+Q/lhyMdAfhbES+7I7xmwUpm1QG?=
 =?us-ascii?Q?XlTAd1XJhzjC/sYumA02FQbtw3FxVC5G9hKNrNmcysgHo3htPAfvxSNcetiw?=
 =?us-ascii?Q?o66xM+JYYGWULk6wcGphJBCqAzSAiZM3OMgV73Ny2cQkMacQqYzTgji9toZK?=
 =?us-ascii?Q?/IYRZEqh7jegsBQNbj0ykdiSrfrc6g5qumh4HQXcmauxSUVMtX9iJq/jMDMw?=
 =?us-ascii?Q?wUswcWx5qDF1sqJg+7XK9zMRFPuwt1k4uhKmrvEbBv8pcYM+SjhNIBvs0a6K?=
 =?us-ascii?Q?5DNGMc5tAEdDX6va/d3t/Yb9ZgBsoIp8GEvFIcKonXRGWT7pk87CxKAsiXT1?=
 =?us-ascii?Q?G7Dr7z0qoLy2hPC0Tiw/SUaWcQZ3E7B//yntOcXHXWBrQWWDiYAY35wMLFGA?=
 =?us-ascii?Q?zQI4dm9yv6lAtArZ+BMrWClKEvSwXsWPx5/Cl004HCnMdSVh7s2p8ozEUYcw?=
 =?us-ascii?Q?7lkyhG66hLxZx9Izs5eLmX5x1xLeJzZEWofgJr65xTCs1G6ZDxqrM4wll3Ia?=
 =?us-ascii?Q?q/HwxCspnafCHLfLpLksFONRpGS541UGtLCGdRs1saYDDdHyIWot2mqQhuCd?=
 =?us-ascii?Q?jgC8jjbqF1GZIhMQVbPLzpm5UZvNtVvNmj2ImFonTr83grA8GXab7Z9iYCrw?=
 =?us-ascii?Q?FQx6E71KlvoFNvoja/osMIJVxkvQupH2VELGM+UVe3s4u4KqzXaFt/0lnUxp?=
 =?us-ascii?Q?OP+hYyzfbQ29KF2ke0m21noMLidO+qZy+RAmrNbk+s9A/kWsS1qGbtJxfz4X?=
 =?us-ascii?Q?qr4/rbLXA+yff3Q2C/Gr46vmgJOvzurjuoIopQ2PiAFBsafFpNqS2Db62uY8?=
 =?us-ascii?Q?FhSXGsn64lMYY3ZSIRSjhbR2R7ktlc9wDvaXqqRhFLvQ+D/gA4jjnvMlkIWT?=
 =?us-ascii?Q?9qx8IhKA1UdxBJqMWVzjS7/8EFzSXnNaLHM6iRpb/lBg3tRt5Az/dSAWEcxS?=
 =?us-ascii?Q?5MMqYxc7YljMLCeXxg/cS/aI+6LsgyxSI33SNzF2Do2OtJzSPS2lzGVFXaHa?=
 =?us-ascii?Q?Y4Qns2MMVEvyef+QPBuBv4EZ5blJuIU699uzOvIuvvwgrV782ObdmvfAbuRA?=
 =?us-ascii?Q?s/cZ5dlaiXhctSLhmEyCvyPor5xiqK7uduAbhNmt40EITKT/W6T3568ACLMv?=
 =?us-ascii?Q?v5SG2iY6sxhwkbHBSrCq9M7vftQvHVs3uFo8u3qHB7hFZg9AVvzgANwPW0cc?=
 =?us-ascii?Q?BROy/YkIVV6xiVGgdURfL6UtKE6vVWT8biK/jt+ZzCT8YR+iK6jeuRvb2MjO?=
 =?us-ascii?Q?eftrjGcylaMbI0fTE22jABQniumhefXe9Gw1Qr7SLx3rzqph4/VRVie7PFuZ?=
 =?us-ascii?Q?zyhYeD6/fUljjGNPIHHb4aM7nm1QzpfSK4n91kHE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6514b18a-1ff4-40ed-4d70-08da5dceeeb2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 15:07:37.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4g5XNZbKB2xzlnvAe9hOs+x34NkmND1WerD06C2x/TE9hL6nATCPbNIIAx1R2xdA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3003
X-Spam-Status: No, score=1.3 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 04, 2022 at 02:51:44PM +0200, Christoph Hellwig wrote:

> @@ -115,12 +116,15 @@ EXPORT_SYMBOL(mdev_unregister_parent);
>  static void mdev_device_release(struct device *dev)
>  {
>  	struct mdev_device *mdev = to_mdev_device(dev);
> +	struct mdev_parent *parent = mdev->type->parent;
>  
>  	/* Pairs with the get in mdev_device_create() */
>  	kobject_put(&mdev->type->kobj);
>  
>  	mutex_lock(&mdev_list_lock);
>  	list_del(&mdev->next);
> +	if (!parent->mdev_driver->get_available)
> +		parent->available_instances++;
>  	mutex_unlock(&mdev_list_lock);

I think the kobject_put() needs to be after this reference to parent
because mdev_type_release() will:

	put_device(type->parent->dev);

Which is potentially the last reference holding dev, and thus parent,
at this moment.

Jason
