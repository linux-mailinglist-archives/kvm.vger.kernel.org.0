Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5726C6C1592
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCTOwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjCTOvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:51:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1AFE28863;
        Mon, 20 Mar 2023 07:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5X9yRxMeV4rSwWrs6u4HMip30qQTgK3EzM1s33useuoDVwHqR3EtF82QyMzVaSpK3LcUpvgW8CgGhV/Hf5AZxDd2AbfV5F1J9A67+A/7hlDEluvKw4BGlXJ6KDakohRdChiNVaflEuCAZhXmZosw8Zvxtki0GkFbIE/F1yspUZxEZNaGFC6UpA4Ubf4rmG9SzV4DRiHgSHIm4fqYesk5zXTEEjnrBg1En4v83nX1jCQY6ciCizkEOZAoGYQ/zsFIub6NCHuLobJUVQJgn67TNQcBnmOhJNQTaLQN2bURW4lIGJsuFTZrTE1YSTTi+qKDayT7Rmzs6dMlQNd+3XiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMrG54dYsfK8WUqmM8dG9clWwwRagbUyOPxnGKcqMrA=;
 b=WBNXQGjSqNlw1Kl9fAg8Uq9QBUDcpvz7Fv6hr7/FJM3m2LHer2wBE7OUGD19vqNE+OD3TtfAo4CTVjWq+jvnxWdE4GKJk3/zX/noJyqlK8f3qyv0rfXHiCFHVr/g1tK3HjphAGbtD4WZuQTE32S1CNPGgmhExQUve7ZUX8jmNlN2jxi/hsSEhg34YqTn1pKd2+Tv3m3RR328ys7uuDTJbUnGN207caehLOm4juA0UHZXCzOw99TRPOOdEHeALDU7npyTP4lbYkYbF3Couz7YgeS/JLLxabKxZfP9pP8Z3V6bf5INFUhL9CPSyiv3zg1oN8iAq8C5j8LGLEDrRpv1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMrG54dYsfK8WUqmM8dG9clWwwRagbUyOPxnGKcqMrA=;
 b=p9Y1+JHht3OCjnGWkh9S7sauguPORWFywGwCgWL8s8iPj8bVaeDUTowMosfUIj66fB6UQ9TFIghUubGc2Wim8C09nehuMFzG2XNDcNAYayB3q8f4p8qt5FZkT8vWavKlgsdK4uirDmgII+XlvlQuk90Xm2CzKY6M3hqAI8P7gcufMgqfueRiy3nBX3OC/WtS3NFC1OHuvlc9UpvgdthHreOfi+nstDb9DvUDk/RZvkAb8nBr44ypkTy2XZQp1F8pJs1oLXe60SAczl2J0a5RvzMB1IJ9AD9ZmnZH3CroN2Ps9zNmn0Y5S2+Uwqhxhi8Px0xAW+MOZ5e1S43F+M839A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 14:49:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 14:49:39 +0000
Date:   Mon, 20 Mar 2023 11:49:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Message-ID: <ZBhygasrWFAiaXIl@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
 <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia>
 <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
X-ClientProxiedBy: BLAPR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:208:329::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 77e65b2f-af28-4fbb-7371-08db29525495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DY1SplC96XomKEdc1PuCnGVU15jUKz1c0zWDlO0THqOVYyGF42aLC5GAz71HWcYaKgXGQc4hvLCZsUvRs+CxsTcaLnv8X/8Qsl3kvOBs2kRmDjm3JOjV0flFcD0HHcgnusfMFSdNV3fmcQ+EuE33/Yrs4Dtk9p0s9sFYSIOAtETQNi0liqmt2Wr6GYK8xanVZ5vgBYSKPunlpjk+bkiUzBNcPZ/txuBnQ46fgOmdmMAz1NguKUJXvjmrNgeyljkFUuySKq5Ejq7bmz4v1my7QmUjc7aKVhsuPi93/a09po58WvSGN2mtLQkPgOiYcUAcE0s58jVTMZZg3f46nin+ZTEJloW5X1PXdjC1fOPjk39Ohsy7wQifmvDsqqj7v0GNXOzMkv8DU2yuKbicW1iNguFUhHHnWtbCsKqCoejLNHgGZh9Sl/iNPuOCrKvssNCiKXvZaWSeg9MI1u/qfsu8Y+y5VNM+OhrOECt4RQ3GeSUphJtKkZP/18uWU/B98f83zcvkS01foyHrAzRH08h0m0XmQYxSqCqY/66s19kLnaXZWaqk5YeEenAeynqRPh+JE6iQ9d8nOEocR3KstcrXqHFvpB30HlU/thxljQ5amQgMyxDiJVUshZyEDx2NQoPzThOT65iKTIrOrrbaCRLNmS/h5YTb302/ZZbJ4i2se9MjhF5/WJ0BeZpui1DMaMbIGN+R3y7FcouDIsh/Bz14lUCV2vFK+3D2DgurUJU+W60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(2616005)(186003)(966005)(6486002)(83380400001)(478600001)(316002)(37006003)(66476007)(66556008)(66946007)(8676002)(6506007)(6512007)(26005)(54906003)(6636002)(4326008)(8936002)(5660300002)(41300700001)(7416002)(6862004)(38100700002)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4V841t1SDfELCy0ZGWJ9HZ9wztgFS7QikBcyvscUb61q2Df69EHivIEFXc3I?=
 =?us-ascii?Q?tEjxIIu9ZSeqgJl3uBenU6AZyFAk1bBFjRKscvCHh4dtT9OBYHTWQlHkLDWQ?=
 =?us-ascii?Q?02WTSFebWBmi1soFmplweJudKVgUepLq8lFgWZzmW4lI0cXZWLz59XB35xew?=
 =?us-ascii?Q?PJwSM8T6hnai+Wkfaq0V0yE9js6kaymW1b3IkSvCtA4FYvpxm7FhW7Yv0RFu?=
 =?us-ascii?Q?4piiiCFGIVtPeSeczqXNX1YSNL3Wy6qZPG1V0iQFyNJTo58ZwOBBoxY8qvy2?=
 =?us-ascii?Q?NrSKyoFZKLOgvWLIxmS0EfzMgf3TJ0lPUBgZyzlN9ki6w9vsBhC/mfrmrXKM?=
 =?us-ascii?Q?pBoPMhMbyxKy3sAYwPe8IWH3rcbL6OdHtTjQlg/xauxgzhg11NGp2O8kXiCS?=
 =?us-ascii?Q?CKe3cI2w2ZAib7csh7g0H3njUO7FxjSmN6lKKYSkzoMsHBrOWEnPT6GwTRnh?=
 =?us-ascii?Q?DqbE9gXoSAzYYJfhi25GtsJG7BR+cqW7NJRtoqSbtQZtydf++viZMqQMWRvl?=
 =?us-ascii?Q?1raE6ELoHVBC05sEUPDvkbMhQaIXc/XaxNvx0AUB8A49g7H819/GKJtmfR9R?=
 =?us-ascii?Q?1g3Tw8d28fhr0/4HoF0VWrmFoihs5c1TnZ7PJeKzmU41ilMuio2WfQhmR8Vx?=
 =?us-ascii?Q?NwuE8XwlWDyyR38Ynn8OoVZFWnMwp7sVRHjslH7gwUxV8B9DoFjg0m2sgG1j?=
 =?us-ascii?Q?JCotnvWesUSUYA6nPYwAKfBxxf9d7XAMh0Y+I71QD3lz1TXRjYuaALgnYufF?=
 =?us-ascii?Q?Jy6aA11cUV4QXwULaGgGeGfZnQs/IkIbzM2B70kGd1czbYF6BrnprIf+w2m5?=
 =?us-ascii?Q?jOEhWz7IFym7dxv26iwoDMma4TVjzDkXIijt8TFLN+iXy1PrDyIGah0Sh/bY?=
 =?us-ascii?Q?wZM/tNAjNJCCeGFo+tLfVfuAqnF53gqyxUqJ6BIE7sBP+sAxtP7IMBn4drfG?=
 =?us-ascii?Q?INi1yjuzy44URj7IWvHn1Zaj4GK6spA01PlVCJYUtxO2owHISwZTig0PL3dl?=
 =?us-ascii?Q?1Dq3ZStKicC93AnLm9QP6tSvcQFrG8CTZQKAlczZXX8Dz87joO4p3Fx9Evlg?=
 =?us-ascii?Q?5LPeQV4g/nrLE90gEDeVfT2IBqdFinJiX3zJ/fm7Czqiut6FNcVh+9SZ4GaE?=
 =?us-ascii?Q?UyOSuHtUWXx+WO4uLgRjzAeW/lB8K507TZ9MqH9ZgYEZLepiSaYjIU0Y+5VJ?=
 =?us-ascii?Q?jo4hiUVKTuwfqbkdSSbozNbGqa1YNsGASGtKDnpq3CRWiq2d1+GCHzaOwPU6?=
 =?us-ascii?Q?r0oo5GmazeXGFK9oDW6vFr8TYz47Xd827BeJEvRcgIxCWGSfNiWPSwUxJAEr?=
 =?us-ascii?Q?TIEl1RD6f2adbAPRAsaBfj++hkKCzP19AmUHffVR9ANU+oCS66qkbg1y+VKC?=
 =?us-ascii?Q?p8qfAc1fRq1gBUionOukP0nn7mxYqKlhg/cO27N1m8KOUKwvy3Jpgg2YJNRY?=
 =?us-ascii?Q?D+VIMOCbgUzermvY5dwhtxer/YmFDwa2IjunUaaqSufq5HR7GPnkNYUXkIBM?=
 =?us-ascii?Q?P/64Hhw3FGhu5tQBTChv/5Go53OCM1n6lHfzsUeGil/3ANb/nZWq6cnf3M3m?=
 =?us-ascii?Q?NMwef7oF//AVo+OAKmkv6ie7ttfBJwkhnzXVr70f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77e65b2f-af28-4fbb-7371-08db29525495
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 14:49:38.8850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rh+an1IC65+ldwxuuLBoZ7w1bCIZC8D5KSuiCkp9JMtkcrUQSv8Y7/WR9xJ/4Sib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 02:03:09AM -0700, Nicolin Chen wrote:
> Hi,
> 
> On Wed, Mar 15, 2023 at 06:50:53AM +0000, Tian, Kevin wrote:
> 
> > > So, this preparatory series will add a pair of simple attach()
> > > and detach() APIs. Then the cdev series will add the locking
> > > and the ioas_unpin stuff as a rework of the detach() API.
> 
> > > I think they can be something mingled... the sample code that
> > > I sent previously could take care of those conditions. But, I
> > > am also thinking a bit that maybe attach() does not need the
> > > locking? I can do a separate replace() function in this case.
> > >
> > 
> > w/o locking then you need smp_store_release() and its pair.
> > 
> > anyway it's not in perf critical path. Keeping lock for attach
> > is simpler and safe.
> 
> OK. Basically I followed what Jason suggested by having three
> APIs and combined Kevin's inputs about the difference between
> the attach/replace(). I also updated the replace changes, and
> rebased all nesting (infrastructure, VT-d and SMMU):
> https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-03142023
> 
> The major three changes for those APIs:
> [1] This adds iommufd_access_attach() in this series:
>     "iommufd: Create access in vfio_iommufd_emulated_bind()"
>     https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dcca5ceaeb40e22b5
> [2] This adds iommufd_access_detach() in the cdev series:
>     "iommufd/device: Add iommufd_access_detach() API"
>     https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a097e2c9d9e26af4
> [3] This adds iommufd_access_replace() in the replace series:
>     "iommufd: Add iommufd_access_replace() API"
>     https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9bc2bf319b7654a8
> 
> Please check if they look okay, so that Yi can integrate them
> accordingly to the emulated/cdev series.

I don't understand why this is being put in front of the cdev series?

Jason
