Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18126B3B8E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCJKAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCJKAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:00:05 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D5A305C4;
        Fri, 10 Mar 2023 02:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678442402; x=1709978402;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oleQtMNdryoaA+QY03aVTpbG+T/j3Bn9ElaHk/HGdQc=;
  b=AFmWnWb01B0U3zhTkRX17wiIbj0+QOzy56vT/k16CDizz7WffNuUt6Ek
   wdUpw5Y+P7QU/a4KjuxDgpF9sSCJIaEJoqLuLkoS/Xp6K5kfkX6HSyPp7
   G7zTA4kFLG35D7QRRnDzzlSth8hg5uicgBS9AoR14qTRGDbfcccTmEx14
   YOFntdY07qXyt0RdIccJm9ttzlHartkxgc/cuJ8EPL09Ctpp9vqWWKNQ+
   h3UCODbYMhvC4ZHjG0EnIuXiJr04JcKhcIZ7wG1ba4VyhPo4iIgLRr5dP
   iHZ/7z/NkN8yzorUdbjta/q1kOAfK8kl5VLmnMaHaclJgvfOQpYKDLhTl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422962126"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="422962126"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 01:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="655128848"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="655128848"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 10 Mar 2023 01:59:21 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:59:21 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 01:59:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 01:59:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 01:59:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMBH+HYt5gNkvvhPOAqxPJB7bbE7u7vEYaID0GqeSqYpw5lxIK2CIoYTKmn+oEpD1XZ5p9OvbBC7NczdL+Z5L0ABR20pSplT/BfuuLTZ0IceMF8XSngtIkLGtwzG4vLCEeaZbyfHJXpmlk3LDc/mrUHd1dAfHJtnVaLBMN+ip9DoOx+qIjbQQjrwzVve/5sOh9IppoZw+0wg2T9chGCKWtHlZvILXNIHJuRGLc+Ako+TzhJR2ulSeRKtYcnxSJO6kEolB9Yp8WdQo+TGRgwtTkTLtQeNLbc/SCbjCfdysrE6+SgsTV1YOWY2PwcecU8hW6NXVkgBSF6znUiIPNQ6pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJCmpCuV7X9OOJarnpZngFNIj4aGvieArtjaw5JqQk4=;
 b=OPou7rER7CXRDNlB7rs85vGE94qImvk7eTu9Q1PeYv3TCW0knveG7hSJABA4EEW+X77vcGNzo1gq4WBpXarotEu+vgcbSaI4fuwzce25sHBemmVEFclYUZqRkJ7BM67inGxz+svzr2M+pP/IQOy5dtGRiXvqMQRGL71LY5dBFnohKnCP0mZ2CEGAu9BbykuL5KTMRQym0OfcHrWIexdiqSMikI/12alm27rNk0aAjJ5f9qmCrsvnQ6HwbrONL3w3zXcdr3AFQczkj92+Feqci8vxIHq3G7PxtKS+mswtCEQsl+R7qeSiKgBWAhPijJP6WYHxM+4oCqQMDN+/SuiqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 09:59:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 09:59:19 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v6 20/24] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v6 20/24] vfio: Add cdev for vfio_device
Thread-Index: AQHZUcIMU6XTKF1u+kuuM49ndl1Bma7ztrQAgAAAazA=
Date:   Fri, 10 Mar 2023 09:59:18 +0000
Message-ID: <DS0PR11MB7529DAF5C24F91D0345E48B7C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-21-yi.l.liu@intel.com>
 <BN9PR11MB5276168FC09BFEF06E8683CE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276168FC09BFEF06E8683CE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW3PR11MB4634:EE_
x-ms-office365-filtering-correlation-id: 7eb0af27-3f1e-47a6-b8b2-08db214e1d77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vfV14Ycso2XrnJrwi39YRA1zOAE4lxrhy2Blp9qSqXzyVgSJyzuI44g0d1e4h3zvAzFC4/c0WML6/xdvt2HPdAOsA2WsovyYZXUDM2SuzBx8ZPOw7Z9Pw0IG0QqPqx+l+5lV2vqrKMk4BBTXinQEjgeX0hIX9RKYG7HMV/zL3lUy4ZmIdqoIlv+RWxz7D415qVqjqHEfEbEGX42E1kyJtU4tzgwuwtkDrg+FnWtHF1edGXvdxx/QF333y9HO9ZU7NjjC5H1A7GXPLhPX5ln2+XO7VdFGqRZ0cgYBnDbuBpJ4GhznsNAZF930HGXYEXpKIe+MjcDnD8n8cN+9zs7PmP3c6QQtvdw0IZkirL8scu8BHNs91pLMFLlHNXrO0utyk0zQ2Vube05EfcZ+idzTfejVnAQGa8khEk040ZchEdkdq3AJpwWzHbOh9bGMj6yRehkvXFCNA2638yXO0QdoLInk7q2hkHa08F10OKvsoCVhLuoZsWkIPLlVLthuiPdkQrOfbtNp9GTzL1tllhWeoPAafsDNQ2COhGU/qCAxrftTykzHiQB3vjlonxoEpLS1YAZI6BKGUyh1H8jwpJ2PoXSNLdolsqh7t/thEd/dfxg0N8+zm5fYhObjJwYsXqAZLHu2rArN9Z+P8tHY3h+/pd3gXFiQ5HVURuYZuBQdG3/gtCNmroMYquVZrOJUq0eUCY/dRzMduIqhmkJ8yAIopN4S+Babi2noirrhXckUGCw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199018)(38070700005)(33656002)(55016003)(86362001)(122000001)(82960400001)(38100700002)(8936002)(52536014)(478600001)(110136005)(7696005)(71200400001)(5660300002)(2906002)(7416002)(4326008)(66476007)(8676002)(66446008)(64756008)(66556008)(76116006)(66946007)(316002)(54906003)(41300700001)(9686003)(186003)(26005)(6506007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YEAYrjt6z/gbyacHT6oaq6TMKG/KXRCnqq8x6T1vmU+ebYC75OhgXMJotn3N?=
 =?us-ascii?Q?730udMnMupilN1oMu4DEdWI7PALjElBy5UEVdUMsvV1IkM00aO1KlX5jxmbx?=
 =?us-ascii?Q?H57blXAzjgjy2IxBxennr66BpK3+z0yGqnQDrcyHqzqq5stwOLXt6VsmOW/v?=
 =?us-ascii?Q?pJECS6qqkzvxr1ddh058luuBXwb3sivRaZ7Pxn69Dp73gTk6k4tf5fh2Rxj8?=
 =?us-ascii?Q?MwV+Kk7bzg1QzIhXieuI7vl3DIbhrilgTe/D9irzLmdNxylG5vmqZxmm8YHm?=
 =?us-ascii?Q?uXHdf9rD+AsKsUU391D3k9/NxgszjwSnlDEeTo/VDZIAOA+Q/yh/BAjGIgPK?=
 =?us-ascii?Q?3WlpWNtfTCdyUlFRbAcvJNT4VdyR2LEku+B20LOByPltByn6ktDPx0qjU5MN?=
 =?us-ascii?Q?KgSybIMc2PRzxRr+ZSUAyxQw6VLiHz2SeOZYrcI1RiwTlGzd07LVzP/i0gRm?=
 =?us-ascii?Q?MwV5hbTY4Ss589PJjgOpoTMliUKea7oMB+qmxiPVzk6CigdUfZXq+sNAvIg3?=
 =?us-ascii?Q?R/ZlZpqLwGXSh9JkKR+sNcVIH8mfSkkZgTvt8cLYNkClTced0KZQaYXC98Jw?=
 =?us-ascii?Q?xEKIyKNL2qUtptHO/qsPo5FRsG8I1qWd0e8AaOHvhkSNShaD66JHFcdprnF2?=
 =?us-ascii?Q?c6NZl1u6HxVbh1JUBKFhKQgcm4PWI4dcCxxSemtRXXdJfEr7/5AhlzoZQKD9?=
 =?us-ascii?Q?CXeKcncz0n0UJdofE4L7bsy0w0CBPGXnLHArTjJl41H3Y5wKPPJpFLMGcDzY?=
 =?us-ascii?Q?YVY+Rx1H1MPuBrCMAGV1unBRr+k+nIVXspyr3/1WB+SUtGQzNACsq0I4Ov0w?=
 =?us-ascii?Q?jdfogYQY1qBfESKyXL+B1JjP4vzHFMq4RCKPEnrnX99paGi1j8FwpvuAdE+v?=
 =?us-ascii?Q?v210Q8IHQ+hfpaXpsskUAalKo6lxATAipfnwe8JWOoIxVFviuLQmc47fuYFX?=
 =?us-ascii?Q?0QhBO3v1xdF7GPml5KaxylJHcGxwAQtkfQs2Lz4BGwsdextwGQYVdlW/Holk?=
 =?us-ascii?Q?ZwMtO3Z3XqpuBxsQ2OC5aszLTM9f2NbL8Tg+VU0VJWmNiZCTDrOw8uo/xW0P?=
 =?us-ascii?Q?8G58VGUvhSlrRYq5T5rg4e5E8PxDk2dnjzGD3Ip7OLt0wx7qTQPV4x730T7c?=
 =?us-ascii?Q?ao9SXjSDZbbJ1tdx5kiyxaEYVZtrdJKlrc95piYSuQB5eHG/s/j9jd1j7N8K?=
 =?us-ascii?Q?qSlLx5jo1zFVKYte/gi+n7BCgqmzWekgNpc8KY0t+bHHC4orns8ZOzwDlqd9?=
 =?us-ascii?Q?zcY2IlZMf7WpDgGh6qoDPta4eMXbLngc2w+4iGIKrR6hSdwCT+z/wPhaQTHN?=
 =?us-ascii?Q?oMY2uD1BBSPzOrTeBaxxukN7yBZI4a4DGo1KHRtmJbqCmTFCpE23pO4SaEc3?=
 =?us-ascii?Q?nhB2FIMEyfy1E9RFSYsiB/9j35fr5yt6C4Bjpt5KmqFFE88wpadfv2ML6rjE?=
 =?us-ascii?Q?IbDDx8+mRL/ls79BRc7C28ihCDYjr19cEZF5jVBWXMyLWrCJ9y5MQneIOhFv?=
 =?us-ascii?Q?d8diHMb3TK605nsE2XC4rGzADZ9sKUCH55TJBvOqc4ZPKn2LkU+xq4i1rOGx?=
 =?us-ascii?Q?f0OvjJlGOr2EhqdQn3wJliwYFieMA29YNxeUDDZ3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb0af27-3f1e-47a6-b8b2-08db214e1d77
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 09:59:18.8451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bGLpscO9Af8uNW0p82Mt+ISsDO8Q44+MFeViBgQWzUFnMoetk1v2q3hWLAPC3NYhxsHHLhywAUDpsPL9IVht9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
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

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, March 10, 2023 4:49 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, March 8, 2023 9:29 PM
> >
> > +	/*
> > +	 * Placing it before vfio_device_put_registration() to prevent
> > +	 * new registration refcount increment by
> > VFIO_GROUP_GET_DEVICE_FD
> > +	 * during the unregister time.
> > +	 */
> > +	vfio_device_group_unregister(device);
> > +
> > +	/*
> > +	 * Balances vfio_device_add() in the register path. Placing it before
> > +	 * vfio_device_put_registration() to prevent new registration
> refcount
> > +	 * increment by the device cdev open during the unregister time.
> > +	 */
> > +	vfio_device_del(device);
> > +
>=20
> What about below?
>=20
> 	/*
> 	 * Cleanup to pair with the register path. Must be done
> 	 * before vfio_device_put_registration () to avoid racing with
> 	 * a new registration.
> 	 */
> 	vfio_device_group_unregister(device);
> 	vfio_device_del(device);

new registration is bit confusing. Maybe "new registration refcount
increment by userspace".

Regards,
Yi Liu=20
