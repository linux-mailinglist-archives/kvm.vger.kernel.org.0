Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B127D08BB
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376363AbjJTGrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376331AbjJTGrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:47:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409EDB8
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697784425; x=1729320425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UdrKLc3TwAEOH66fTq1xqOViJuUoObAuUld1hhOmkxA=;
  b=SJuFPki44dr4+3qmfvm+9MKV+0O4XAHuD5h/XN0guJVUYZmS9LZ86VtG
   JYAljTiHzESHf4KRbhUJA/eXcZJYHxIZsfKE6Q6ScX3skNx4eYH3tUwq4
   327DQ6l8859JfYioF85QelPFFktYc2d3R1bFhxB5RDUjsovynmFI4ucDb
   NgOSfYWsMGKTvx7cPAVMwD1eKz6fRvlhq/NDB4JYW4q9bNyvg5CsqVFxZ
   mHWR2mjb8xqOUmbyQ0IIFTtZoIJLNhT1FMtYKmKS5cenaRn6HCj0YolST
   7e1Etcjph0u+Xo6Ei8R/wBjZ17U/PxUIYeIodrO1/NFwOn0nmTrpGyLy2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="371514699"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="371514699"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 23:47:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792297903"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792297903"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Oct 2023 23:47:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:47:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 19 Oct 2023 23:47:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 19 Oct 2023 23:47:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 19 Oct 2023 23:47:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c40mN4eVzdtV66Fw4BjxMYjTkTNCYCFX7J7fHplOwpnURIbLCu2e2xqzVSehP+rpkAV5/nl4GnF2V1XHQfs8ksslsfPYdolUNL80dXO7UgbJjne0mWS8TXY7gnwqFn04nnUnMSvCYqh9B7Af5gRbvPOZcdGNFft8/9FmL/hBsXdtWt0eYY/6kuEKkBuozlrN5l9u/3U4Dr/Wn/br4jEJcDREHIBZaptwhvwfEa3hGMp4bxZ78edez6TljcAj65o8i1eASIvrrGz6MgyVVi/zXLf3xxorEvJqu5Q2Imd4LJAehlz4Mrq4JTlrbHNEPFyKNrq8e9wA6L0xilClA2wwsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl6VZkE/NcN5RZRrKRB9AJspsbuIdQvhwd0YBN+NWY4=;
 b=a4lxV+xpVF1+FWYs6dz/K5bQKOd0kQvMNJ7sE5SGxIXFQFiIq6FD7oxZv0F4nXGAKyUWCW02zmL/cGOmzKSFyMkOupAO1qz6N3rVyivnwgyE3p4Yp2UEZULMKlIDF3H+0sIiVkzqnn63YoxHTazECs2vdg5aQ29TiKH7ZEtiGrqJKg6J8wxX3uGafdI7Qf0PXgx/UKj7uZxZLpX0Ncw/+LWwqQpU6JO8HbLWBVSkSoYQOcdEf2Fqqg9zO5wRIStw7EGWhWbqry9UqglT35oSLSeZ/xzhzNegHWhzPdfNAwn74uFFOVwU9y7kQUfLcgXF4/ki20rIlmktC69SiztAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 06:46:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 06:46:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Thread-Topic: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
Thread-Index: AQHaAgGsImNm+EkgNk2QrmauQ09hOLBSOqrw
Date:   Fri, 20 Oct 2023 06:46:50 +0000
Message-ID: <BN9PR11MB52769FC84C9241EF41D064C38CDBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-9-joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-9-joao.m.martins@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5134:EE_
x-ms-office365-filtering-correlation-id: 5b766268-a786-403b-4317-08dbd13856d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WPzgDra/7zgW/K8fC9bXV9vX0wzAKw/AEdrNTku+bGx5chlgySPIS1XJ9n/8+DiTLOVd78Cx9VMb7Fdv7eFMoUjoRX0Jze5fh6yiPNr+StvmqIU7TBWT/57ToBrhD/z8IaQxZNHpCUEBftRS7KCt5e0DdMVf9tuJYjpOD/l49U7SEzwOSTFLI5cuJdoPbFYYoRHHjR6JPxUGGxMb1IJrUPJRAjPOQh12aVzXzHWbt/wwgomt7SxjKaMbOwwwEuf5UEHKAKvgsBU5PVYKoMey7eeqiKha5UG7bKYgcvZpR17zalC650oS0uXJj1bt0LIV8lw8Nnom2CwYr36vLk+cvOiLnswOrYubGCmyjqFpP2gL+OWDTM2pF0GF9nRE0DNYBAOKfbESMs/nK6w06FZjoYlCzOT0XMrXJTfLRHYfu8zogj2C1IlwKFTyrxPZ5wAEZLZKCLVLsNeWmIIhm5fBazQCJogLgepIRL7fIQN0qCORrOfV+IhjN2u3AbHgvi5RuhOTaqWHh7Tfd5dpOALnBBsDkeKWlTMutb/hH8fHoH8fFciPGFiLR9hxocDddlzA8StE+pRejf0ax9KGfOdJQCn50UQo2L8BpBuI2q5AZvgEtWNqdzQOEOLW/y/kN+S3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(366004)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(52536014)(8936002)(8676002)(4326008)(4744005)(2906002)(7416002)(41300700001)(5660300002)(9686003)(6506007)(7696005)(26005)(71200400001)(38070700009)(38100700002)(33656002)(86362001)(122000001)(82960400001)(55016003)(110136005)(66476007)(316002)(478600001)(66446008)(54906003)(64756008)(76116006)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5nC1fsOeacmWUToRurFvPglaynrMinKglmqO3o0iu2XkNM/thV/NaogOzI5a?=
 =?us-ascii?Q?t1FdmkF41/eyRHo2aLB/A+xqC6zYWbxVIk8JwV7qv6hOAck9ZVEZOR/LJOH/?=
 =?us-ascii?Q?ttl+NDgK5h+revyLSIjshd6P0GBCuXdI+fNGVsoU2YIK11FmV4XVDvfY/7wT?=
 =?us-ascii?Q?N6tNTEXX8FKv2kWJNvqwKEi3lBMzroPjbGBBS65VkBe18+DZJ/HRu7lB7XRh?=
 =?us-ascii?Q?8osxheSF5iJmD9LkkDmDU5OkWx8YGkOdGGg80EKRaOFQNzJis6JUpDeQQC+o?=
 =?us-ascii?Q?WA2ciMzsuQsyBwEePuIkTwydmQy8APSoHIs0dWnW3vU7Xh7v8YC+fMZBktbC?=
 =?us-ascii?Q?UWwSoGm7rvO8QiHovpjhh0RYOO9nlsf6mY9+f40R6UrMq43v2HumyHSQsivn?=
 =?us-ascii?Q?RTv4lz0Pr6HktHThJ4UBytjzJS/kmLb5zzYsOG+tayZq3BImpSbWQnbIyQpe?=
 =?us-ascii?Q?iayvYg2D+EAcGLVkCqzi+NzgUhdo048wQcesvauWZrBqTUnJJ9O7HW+lUK1n?=
 =?us-ascii?Q?LLUp7vgwuP+iVnkiEA4uZzhVivpUFnRiUccsQr0oHl+PHEiBNfIPmSjiy70h?=
 =?us-ascii?Q?j2D1c9UJFqLI2VozujR+HEr3QYTJfcwo3y6F0u8TvBWehB7nO+T1liDjIYLq?=
 =?us-ascii?Q?NnkA5h553OBLOFt/WUyK/r1QLHznnjTmf7TB2ounDoMnUi8XJNpqDxBGqj6z?=
 =?us-ascii?Q?ixsAn284pADcHMPGP0slYJfwxvzknduk+oSmLxdpJQpXmh49z77ZkxoqzKdg?=
 =?us-ascii?Q?1+iGgrfK/vSYvz4IdvlQRTafDgAqe4EOnthoPEsFgKP+iEgUBQ22mpZlWFp5?=
 =?us-ascii?Q?9+mnuySBfqvXR4CRAJCYb9iux78PUgfFe+pq6NtDZhWxBNpRG6ac8odR1ENG?=
 =?us-ascii?Q?o59sTNAq+/hg/eWDitznIUzYo4ZlB4K3OwXffOZXGXSSZUCAG4AliOkCOmnA?=
 =?us-ascii?Q?Nn+j8Jw7yZTxwLzolpgEYxNjFQvZHCfBxnig9nKvLea3eJ0oa6s+jnLzfZ2T?=
 =?us-ascii?Q?4JgTvTSMls0Sj22vVZO57bj74gpIn/YmnYUhag600OhwKxe5r8Mq4oolnaBP?=
 =?us-ascii?Q?iNR5pPN/65oTHYfR3sbQFbkpLbFZauTLdMrWnWiDQuyUC+TnOawQzHbztwOs?=
 =?us-ascii?Q?PUHtKMGlOyhiBw587Xn+/X6+lqd3RvTYGlkITf9JqqaIyYl9uVlPNbzY+rRA?=
 =?us-ascii?Q?kyhlk1bWhrtaLG/v9ga5JOxa1XrMNsD8vJ3y1x9dsmh9XQCufGe4EfogSzd2?=
 =?us-ascii?Q?tyn0jZ07SOls37UOKZLggmaYnQ5IdgHgnPxQtKTFOGAC935MXweYCeT9LQ3x?=
 =?us-ascii?Q?4UlKfXt+uvYqDWIJfsVPcoyyn9qCNTkVkHS4glLS3WgfToIxW0A06iOSNYWP?=
 =?us-ascii?Q?slGIeZUvCnHXDPIR6wZnfkYEEl+d2mZ0AMhnmdrg90OJeaL+Se0v044EYh87?=
 =?us-ascii?Q?xq1yAIrj5eKvXU87YSh6E3gwo7DwAiiDfb+d0UQ9La3Zfb1QSJSdf2B8Aw1f?=
 =?us-ascii?Q?55/Gr6QnzZZkoo/unkWpPPPdw5lECI7tHcuPtq6UN0W6rhhB0X0ZoRBt0IPA?=
 =?us-ascii?Q?O2o5tclsjjeTxuVvsXXX3gV80zRbRxqMso5pXyaa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b766268-a786-403b-4317-08dbd13856d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2023 06:46:50.7994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/IIFaxxxMWaZjtxN9bG7G5PPh2OdVi9+1dQgjON9fefN3p5yJbpjHrpsILTGp8zHyQSraLPnvuQGNc1csFRcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Joao Martins <joao.m.martins@oracle.com>
> Sent: Thursday, October 19, 2023 4:27 AM
>=20
> +/**
> + * enum iommufd_hw_info_capabilities
> + * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty
> tracking

@IOMMU_HW_CAP_DIRTY_TRACKING: ...

>  /**
>   * struct iommu_hw_info - ioctl(IOMMU_GET_HW_INFO)
>   * @size: sizeof(struct iommu_hw_info)
> @@ -430,6 +438,8 @@ enum iommu_hw_info_type {
>   *             the iommu type specific hardware information data
>   * @out_data_type: Output the iommu hardware info type as defined in the
> enum
>   *                 iommu_hw_info_type.
> + * @out_capabilities: Output the iommu capability info type as defined i=
n
> the
> + *                    enum iommu_hw_capabilities.

"Output the 'generic' iommu capability info ..."

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
