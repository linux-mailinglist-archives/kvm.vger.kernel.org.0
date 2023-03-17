Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC46BDE75
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 03:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCQCKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 22:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQCKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 22:10:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0736BC655;
        Thu, 16 Mar 2023 19:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679019042; x=1710555042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x19ovFcG+ZH8b4MqV7OnAqHYz+rqPuzqCEHfhZe1CHs=;
  b=UicRVF1Z4neIOP0g+vEwVYpPIh0EnDCY399kmX1A8D+cPA3RPcbel1tj
   EwTfKamEYkAtEqyBvSdy9wxd7fjQTjjeVqumD3aioEKeGdWnWLCPyYIR2
   rgmWYOeX1v6NibqZlFWq91Whxzlq1U2afr4AENuLp9+LVWt1vIduHc1ym
   CBx2akTzsVFjkMy2tGDPq10vnAl/obE/cMyLVHsIPAbNK3bjdK7rCr8PF
   cjh2f7GTboPbZdAxP1087gpVO/NoWHtVm02tnOpBRISoj0oFPWVKYoeNq
   NPXo919zgkSDMnaGkRriqAeet0KoMVGSGlJDWWgvOwmfNDVDMXsSkjX/k
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="424431471"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="424431471"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 19:10:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="657400747"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="657400747"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2023 19:10:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:10:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 19:10:39 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 19:10:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 19:10:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J635D1uviHEiFj4rc/yXEkfRWZeDHUox2wtgbRpSA9vrdx9cNTqqOYpAAirJ8wWRmDFDJs6BndPk8m/dKT4TPHKJYV/mFtqJNqUaooKJVzG1pGsOZom4Ul0ODGZ2y0pery/CMdZtcQdjANxxrVG5gFKCyWWLF4O3xqe5xJr8ke3STznIX/wCn3ghPE4tQ+UbNYWSEM1/amtniRglXktOpKAvgZ7feNxNe9IGqlHNpei63jAUxDa3gK0ET2ZhzT6fH7LIfKAkNb1+iLgkRzP6PpMQVHgDGX1E1EKcCUjvWRj7Pja+WFwzoucIpmmyN5WH2RsUTlBjpdi9skvdomRGbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x19ovFcG+ZH8b4MqV7OnAqHYz+rqPuzqCEHfhZe1CHs=;
 b=BzMdKK2Ph9Rgb58WH/JGgZtPTMOouaF7LBkMgIE4KaSKdvWuL21MgjYrv3Qkd9qucy/lSZmK8qbfBw7qAXRyAswXuKCdvK3Qmephxwbhr2xVkcO0wKZMX7hc1+P/3VWeI0qPHPiJSPnGbItk/EGxm/WFH9tndN8L4G2esLdTQ6W02OqjdRVOwUptpk+QBehO79GsVTG6h3JjlppN1CAmo6xotqDJDj+eEkRbr2V0lZyQJnqom1tKhhAMrssKfVH1LQ/4L++TDE9kycH/P/qye2heamunPtxDqrTn6wSDB3DbIzrvtpaDkGn2QYaGyzWtv+lXs3ubfTlbCMjhYALGIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6658.namprd11.prod.outlook.com (2603:10b6:510:1c1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 02:10:38 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 02:10:38 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v7 16/22] iommufd/device: Add iommufd_access_detach() API
Thread-Topic: [PATCH v7 16/22] iommufd/device: Add iommufd_access_detach() API
Thread-Index: AQHZWAatdqU/XzNWZEaZnnGlfToIZq7+OzBA
Date:   Fri, 17 Mar 2023 02:10:37 +0000
Message-ID: <BN9PR11MB5276900BB28DF8A2B956A3E48CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-17-yi.l.liu@intel.com>
In-Reply-To: <20230316125534.17216-17-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6658:EE_
x-ms-office365-filtering-correlation-id: 4ab690a4-99b3-4bcb-56b1-08db268cccec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odxNDLRmRw7Lxjk/dwjTAa4bTKHcpbI+UYxfJywcw3nD3mh2xpgYmKMghhWWINV4TzR7FYzRSoCtF13WvwYDIbEkHgNfyHO/tLmgns0Rjb99EtFQCRN7gJvnTl5lNIfNAazLF0ZRJQay8yOshHngsCcR1RNGMA4pC7MXNQcPrUCiSutlMDgn4T8GrNSIj2Ryi3W17ZNztPDIN6+fgzDWxtv8NXtUalCo+8p+YScfqrSurjBeAr/gf9MTekhKYLyy0ka5MG668QDipDnYT9ob/19/P4YgeE5nXHoSPQa0DesmLk1GmUreUBrgeTxFY0A9yw91gLnADorjYl+/P2E7r2VOAj3S9bbXhcdNz9s6GEqo0QMPsZJrkSUo+WekD1zeoH5/Y8u5mw2ToVvx24fZHbGC9s70v47UNQV6GO5U2GmvjY/vFXtUOdv+hwS+sEpooRVCzZ0UCsuaVPoN1zLX7uhc2o1+R1dMhNVsh11EwfrC0hAqCXLlcyzXD8j0zukd4lRxBC6eCsMZQfxLiH0oCufDWiE0FDTiU30Tf1qlJkKjQT5LlkH2AdorweoGtz1QMIPU0aD9E16TtYBaA6WLINFMrtaKlgQnSbIat00A0MGWSzQtHAyEOvEpJA2OdzwR88HXOzOMC67Uqc/gJHDzmgYpAgKE2y8ZIdB8toSEuan2+Bl0vNFwAU1Rmf02pPY9IH83whjggcbZtGNmeJ3kBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(83380400001)(186003)(7696005)(7416002)(66946007)(76116006)(5660300002)(66556008)(66446008)(71200400001)(66476007)(64756008)(8676002)(122000001)(41300700001)(52536014)(2906002)(6506007)(9686003)(26005)(38100700002)(33656002)(82960400001)(478600001)(4326008)(54906003)(38070700005)(8936002)(316002)(55016003)(86362001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sur9F2xkDjST2sAYYQI9GI9cRwj9trlYkuG/HgM2XZOSMYf2xI3SCnEmArHH?=
 =?us-ascii?Q?F5V01/pwQJDZwLg2aE/Zd0Sw7kuURBi7Q8UydlIT3UFzX3/iFoW+p/jv2KZp?=
 =?us-ascii?Q?oBNmP6xDwGnFVpZwhFO4YUm3W4X/9k/zWCnz8Gagb/x9rMXtEJoxBJtYy8Ge?=
 =?us-ascii?Q?tP7TKG3eqYqk02KUtPdX6tsAFE2H8la9iKJ5aw/7iHcsaODVNs/3j3O3BOzJ?=
 =?us-ascii?Q?HTM4D9SakTYs347pMh/caxUczxsBHcoRR37CIZLGWveVutVb2Hi0PM01MAuw?=
 =?us-ascii?Q?ttQSFn/0skC0IBcUiEeDV6iA0ZhroLkqwaWZfiDjGTh+eNwfEqbW8PNe2ter?=
 =?us-ascii?Q?NrbroFF0tgr4/TInjV+R9wYSZDoniFK8anAXPm2rcdQFn0Bt5i3OC/f1f7ed?=
 =?us-ascii?Q?bdRy5Xrp+MQdeDMVs04d+/LZajIvQjHq8MiXxC6bxygW3vgvQMWJNUG6J95/?=
 =?us-ascii?Q?0LuRnn8AZ9rQzDIypjqmMbMoIOusHskkc4YF6Y7SLq+6u3Td4ssZvU1/+jon?=
 =?us-ascii?Q?dE2T4uxCiQ3u6SI1o6fEE9JbaVFCdQYyUZtHgXWUNHOwvNDhjAwCMx2TFQiR?=
 =?us-ascii?Q?jtmaO9mNKEyVDUQcyDeaFUDH0Zbq9G9BS+SDyxLqz+tUBQA/4BpR6L5uw15r?=
 =?us-ascii?Q?zvnQPEOr1amNn3F3oqgFs1mTZkcpm0G1dnILc6QHvvL84hPH3NyvDafzclfx?=
 =?us-ascii?Q?Ql9C4bYgJJlYXPumjHbhZbtZNnoNVJXmLHnqjiMVDq68aKoW+YpqblRe6OBa?=
 =?us-ascii?Q?7yxNz7c4v4gri0WQi8Kubwufk/MaewYMHtAVZ2frvNPitqVycGV28wgWw3DJ?=
 =?us-ascii?Q?EA5GHIwQKXgga4QcBMNE4LXvNUA/aQiFZQTIorslllnsa63vZD5FHsbrekJQ?=
 =?us-ascii?Q?t3TDmtZ7ZYkeoBkY2IhogoLBMXLMeWTIST+Tg9RmiKEBpW1W2hSRAqOY+RDb?=
 =?us-ascii?Q?Vr1vkeKDYjiH3m+Y+D5zmInSHlua+VG4foEUPIPjDNZ6PGPYBzbVxogP+nAu?=
 =?us-ascii?Q?/VbLc+ubqcerzqaVUDnyUwJI9eSFgsEgrwfqd102OoYuwBVixNtswsr1CwgB?=
 =?us-ascii?Q?/eF5c+tMafKedseJrGUCNczYaY3XTK+rkPTXCCk9BmoVKjZN03rKTU0+dhE1?=
 =?us-ascii?Q?5FvRaPdJTBNk/FJK2xBTlFThhOL8yeJ7zlDQ6XzGPH19zlgZdOxXrYp0Z2Vq?=
 =?us-ascii?Q?Ah/cjxtSge+qhhMMXRD6ZrGmp9PngpkHMloGxeMKHGFrgZhpFepZVaiebHNf?=
 =?us-ascii?Q?ZluwBS/YYtGdY5f7o1R1keu/kc/E8/Rcxo7fYGvWE4J7kun7Q61K2fxkyVrH?=
 =?us-ascii?Q?TqZWnDZf4+jLXoeXSekE/z86yxixZ7/GbI9hS6YN8FXbR++DE6zm/I8M6FwU?=
 =?us-ascii?Q?GN4Kp2PozkP8Nv3TtfAeLWPVbd/FQciuXl9s7XUwvEP67/oF/ac7m8V4FLni?=
 =?us-ascii?Q?PfOBax3ZDBwGfWubEPyJnSselpwjYL2ze5zutm2dg3JixYSQz2g4EugfCnPq?=
 =?us-ascii?Q?XGLMLLV3W75cgG5B2sF0zQjWyrfIK09XZyvX/bQKsZjbG9r1puaMcka4aGoz?=
 =?us-ascii?Q?h5h+n7uRO9TnFWCtve7JaniTYak2VbVD3j+E9mI4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab690a4-99b3-4bcb-56b1-08db268cccec
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 02:10:37.7906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iy+CYEOCq7AwreWVKOifnElYV3yWDnPrB4b0+5P7Bc5LQXXR62AiQ7pxSfU8Byks9hMkWdpwV4SzsUwfQY7YAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6658
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:55 PM
>=20
> From: Nicolin Chen <nicolinc@nvidia.com>
>=20
> Previously, the detach routine is only done by the destroy(). And it was
> called by vfio_iommufd_emulated_unbind() when the device runs close(), so
> all the mappings in iopt were cleaned in that setup, when the call trace
> reaches this detach() routine.
>=20
> Now, there's a need of a detach uAPI, meaning that it does not only need
> a new iommufd_access_detach() API, but also requires access->ops->unmap()
> call as a cleanup. So add one.
>=20
> However, leaving that unprotected can introduce some potential of a race
> condition during the pin_/unpin_pages() call, where access->ioas->iopt is
> getting referenced. So, add an ioas_lock to protect the context of iopt
> referencings.
>=20
> Also, to allow the iommufd_access_unpin_pages() callback to happen via
> this unmap() call, add an ioas_unpin pointer, so the unpin routine won't
> be affected by the "access->ioas =3D NULL" trick.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
