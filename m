Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252944E5D73
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 04:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbiCXDRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 23:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241880AbiCXDQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 23:16:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2C062F4
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 20:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648091725; x=1679627725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r/ZMXwqtblazos1zv7EqwAeBmqYZuHgjSsmfoeAkZjY=;
  b=FgDCVmxXG2CHY7mgsv+vJJ4geOIRltlqu/gDOU3vuPInNVSOOKTlCBU0
   vvuFPvzAiiLSZAuQfXR/qAZb4WYsrePLW0cbNxndrr8AbjvDXRqEQlyig
   fS8/y3EkFstj9FCe3SqpoJPYA5tn24/UCYhsR2t8KqBT8oucODaS+rjLo
   fYPVXZz4ADTmIpmx22Hlx934chm6BEYjfAQa3kNyTAGsflphaUS7bxkRT
   mxShioDWdt+bdx2YwOEJdbY/WCqX/I5W0JeN0K6VI1ST+ZnVFu7c6sQtB
   JnG0IuHPYLNxphh6sRGFo/y+eZSx4Znh336sQIwBBOwMOgU34oAcE8mEs
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="257104494"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="257104494"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 20:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="583927417"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 23 Mar 2022 20:15:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 20:15:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 20:15:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 23 Mar 2022 20:15:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 20:15:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loSn3JkTFKcm8v5KOBLU1FD+j1/hJM8WI82qd9m/oHj9dutaS+YyjnhqLRDUYKP4LV77zseUibEoVbPBQIYzqO5ASGMOLXbRhyj2QnRL0sIyC4ULCZJL7PfifU15TrS61ASYjh1pQ/cNGEnCYRjGf2qsk7XX1QX9u95sPSA9jtbI84EBRe5xXFdLADDb9cXIzRFi82bhOsb2JKggtLOU5d0uzVfMPDrr3cfcXTmCM/GSC8rBf1n/8DQ55yU4BVBBl4yNz8ZA9dq1X/ohaJr8VM1dKFWHv/pTsWde/GO00NDDZ1TKOJYYephyV9QqZS0iQrf2Kzb8jnCkehkOSPVwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/ZMXwqtblazos1zv7EqwAeBmqYZuHgjSsmfoeAkZjY=;
 b=CQn54nfcMnIoJF5nfjBUAGHLAviVWS9nE5bILLUMVWuwXhpj9sDoiX2INK5znw8u6/PuEKv3r823TgOyYwt0TOV0s7qxUD2fjacTQb91RIXEmKHPj19uZPVdh4czyp76oFb2bfVhF8AuPTs3lr8lVpCm1jcOJgGG/G4qw8rvJRnjBcXkxqRxTSWC84Ol4jnW24NmZAcEmE3p1TaYtfwPjJfSQhjUtmqh6sFTL2Nmw4XZIghTMashE4bZCCzaERVhBLbc8z9UPWUPB9ioJH62bkdHL1twyUkaBbJwY4HqwrBij32d0fhI4SH8waU+aEAHdt72KfW3Ya17qImt59Qr0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN8PR11MB3667.namprd11.prod.outlook.com (2603:10b6:408:88::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:15:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:15:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Thread-Topic: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Thread-Index: AQHYOu2DSsSjQi9eMEu6J1ns8GLP6azLfE8AgAAIMYCAAAjbgIAADNiAgAI1J0CAAAhSgIAAAkLwgAAF7YCAAAOIEA==
Date:   Thu, 24 Mar 2022 03:15:20 +0000
Message-ID: <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
In-Reply-To: <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc550e21-a0c1-4560-97a3-08da0d448785
x-ms-traffictypediagnostic: BN8PR11MB3667:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN8PR11MB3667BA517B11BF84EDDB3FA78C199@BN8PR11MB3667.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2mdXykGL1HzckNbPPgN/lz6tuFtNCzlWjQogVHt7db/3R0MJlmBg8WCtR9R3AevjuQptLJtdl3pPzeIoEqGX8l+biR9yu9hf0XDceqmFcb59YIb4epz3ytPk6S/Reu1MGnNZhczHmERkJJ5KT0rFt8GVt+GZbQXni6Z/jt7zlyDM3MFd32VV+pelvTPN7XKu9X1o0LrZqNsB01ikb9SXrTft/yPgR1/8MdZeeW9L7LzEnyxg8FuLLVaDfSa/lFa8MAXFQMy9bW3w4rUOyaptF/wdXp3fEy6P57XagfMQj9coKQgnZci20+0ZkcbRDRnCGMIAtj4uBiicV0Lkqv9c9UnDxM91Esyf+3xlPMMeng4Z9XX5sD4N3/ko2CBxiC3ZVKwgLXc7+JoKGA7GK1nKGqPO2XPHglYRQVBWeN+GbE12Glh5IYznbZ4ckbubs4qC5QaG1Hm9hplHaC4uEOJ5mqoMIctkuG2AwGZZLNBe+uBEQ+t82vi43wJnjjBF0EUPnwc6kEOmnF00lljaI/fL2mlpEirI2Z8AHw4PmZNKu8lGbV2Ao71Whi/ZLgDhbWy9Lpbn0rX20O0QAo5hbBhQv4CBwetri7WLflQGvL9TYPNS7TYfT8gwZAPiv42Zntrw8df+VEIR5LXnuZvPuwG3X9omq0ejnZR7KJzsgklEg7SCafrD7dl2t+ixgfNL/GJFtMJUbdUEkHAxxWDGwi5L+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(186003)(26005)(316002)(55016003)(33656002)(53546011)(6506007)(9686003)(7696005)(122000001)(2906002)(86362001)(66946007)(52536014)(71200400001)(508600001)(38100700002)(54906003)(82960400001)(76116006)(6916009)(5660300002)(38070700005)(7416002)(8936002)(4326008)(8676002)(66556008)(66476007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzUwQmtsY0dQc0FhQUJwMGI0eTNubFZLYzF2L1pUOFVzaHdXYjdLK21NVDdM?=
 =?utf-8?B?bnM3RU1haVpqZVc3K29GZlQ2SjRpa21pZlN6dTJ2K0dEQXZkcjJLMFdUeUJC?=
 =?utf-8?B?bG94Rm56YkNSbTJkaGtZQjJOeWp0VlBNSjcyc2pvNkErK0J5OVhpQmZUbldR?=
 =?utf-8?B?WTU2R1hZMDBCSWU1cVFwa25yS2xVQ05Ob1NtdUp4L3RZZFI4SGRwcGRWRjFB?=
 =?utf-8?B?a2Q1cDBORFNHTXR0eXNQckV2cFRNNDZSZDgvVG1qUXNiRmdhdVhNREdoWWlr?=
 =?utf-8?B?b1cxUXpkOW1hd1FzclRyRnRoYnlERDA5OEZjSlRIdWl6N0NzbHdNck9wWVNC?=
 =?utf-8?B?Nk9Oa2tEaWlhN3pVem5oM3N2YzdYcnZtckk3c0lSUHlKK1NsbzlnejBVbG5z?=
 =?utf-8?B?TFVQTnNxWHgwZE04VmNidVM3N3FOejRHRnU5MS82Z2NSbzByUzNIUnNDY1Rr?=
 =?utf-8?B?QmhGVlY5bGdvMTVKdy9YU0duZFFUc2J0a05tTHhNam00UjBCd1hSNzkzUlhB?=
 =?utf-8?B?QmRBaHZWM2QwRUVwbVJkQ3ZMNVZTYzlzTjVBbXNVWE9rRkM1RGZNSXl0bm8y?=
 =?utf-8?B?bGJvZEF3U0YvanUweUFtQmpRLy9lVm15WnNmU0hXb2E5aW9GeFRWUE1wdEZu?=
 =?utf-8?B?dm9rT3JjM1JNaUljV0NtaUFBK0Z1cno0Z1k3Z1VxdWJmejc3TE0zY1NwamZI?=
 =?utf-8?B?UkIxeXc0VHhaUWdRR3pGSWorSWZFa0haMmxobXorUjZXZVpDc1RreGlWdnd5?=
 =?utf-8?B?L3AyaGpNQThuQkRjTGdFb0h2SHF3WHhoWFlsM3N1UWp3NXhuQjZBU1VwZ0N2?=
 =?utf-8?B?VzNiTlBHTU9HU3VLUHVMMkRCYVJUdDZ0TWpnTWswK0Ircjl1eWNEdGt6TjUz?=
 =?utf-8?B?Y0dML1NTSWhZOUVJOHF3Ni9ZZXdkc0RvYXpDZ3JwOVVETVJtWXNZME9qNkg1?=
 =?utf-8?B?cy9SZ1NGbDIrTUlIcGdpelBVbGZmRTEweXZZL1IxY2hJNWNKL0FJdWdzZkg4?=
 =?utf-8?B?cThHOFBaT012UElFcGNEMkRJa3Y5NkVyU1hmZGNFUk5ZL1lLZjFYZWZ5MHNj?=
 =?utf-8?B?ZXhyeXl0SDgrUk9sdCtsS01XYTdIZWxBMEtHcjA4VHNxQ0JiTjROc01TeGJR?=
 =?utf-8?B?eXNQY0tTV3NNdTI0Znh3dHYveUZMYlZqUzMyQ3l6bGpBRlVHMDROaWpyK1li?=
 =?utf-8?B?QVZnbGk0d3dpWVVISEF3dHpmR3BGQTJrK2JVTy9RTm5QNWhXY1FMS1hLaG0x?=
 =?utf-8?B?b21Tb2JpczRJS0pibW43ZXY5NW5jN1djT1dOd29JUGZJays1TEhHSGNIaXRh?=
 =?utf-8?B?dWxTeEIyUGRqQ1pQSTdyYktJMzlId0VzcGRCVHdxWHdQdVpabVpKUDdnbzE0?=
 =?utf-8?B?a2hHdnl1TXJ2R0lQam44WUxlVWsrK3MvTjFNVjV0dVVpU3E0Mzc0bk1wL0t5?=
 =?utf-8?B?TGd1NlRCZ280c0gySzZVd1VWTTl2eXJLaC9JQlQ5MExGTFRHTzdYOXg3cm1V?=
 =?utf-8?B?ZDVUNVI2cUdjTFF4V0cwTWUvMkw1bGhXZDJjN0JidzZ6RldvT2l5NTNpS3BS?=
 =?utf-8?B?cHZrT1ZWT3JZL2pMRWIyaHV6NVYweGtxTkNoY0lyYmZUMXJLWEh0MkdIUE16?=
 =?utf-8?B?Q1MrV3VGUURzSXBQTG5ZaVZ6cFZvOFhvdHVZcWRFV2V5MEc1UVJUMnJRNmtW?=
 =?utf-8?B?NW92ekltZW5JMURHZ0lTdmNhQzZPdWpPYlZYVEl1YU9LR2ptOGE2TGl0R2pr?=
 =?utf-8?B?SEcxaTdEZjVwcEhUZy9YdE95cFpFckFxNWNqRVNHU2Y0M0QzZkJzNENHVk81?=
 =?utf-8?B?c0lsUVpuQ3RrT1pFL2VwaDZORVgyUnlKSWo4b1M5a05OVXlKdUttZlY0eFlB?=
 =?utf-8?B?azBkSkEydG03YmNsYlhkNWV6dm9hbG54ZCtyYk4yMkF1WDhDTE1JRWpaTW4z?=
 =?utf-8?B?K21XUUtzQ2o3cmpZMWRTeUR0YTdidVV1ZUovM0UxT0tMQzBEV3VZNkpNWmRN?=
 =?utf-8?B?Slg5Rk04UHREWVQ1MklTai9ocE93V2d6OGdDMERiSHJWZjJVQnB6dWJ4VWx0?=
 =?utf-8?B?ZUN1V1VxOG4vbnd1VGpxSU5TSkwvQkhYUnV3NzgyZmNQZ0FYMWFZZklSS3NJ?=
 =?utf-8?B?bDVNbkU5ekpSZnMwTVVvQmxmQWwwUmxseXd1RXBnTE9aa1RvcGk2RCtwRDdm?=
 =?utf-8?B?ZkFPTmd6NnhlVlpJN3cwdVRlVzczMU5uc2p5S0Q2dGd0VHRzWGk4Si9KcFFY?=
 =?utf-8?B?MVNVS1BIWEFPTUFvNnZGck9WUlRqb3VrQjhiVzVtWU5XWENOKzhQemJwb01B?=
 =?utf-8?B?bit2YTZOMGJlM05QK1VIMEttYVBqMXYzM2FYRjZIWGtqWUtlaXhBQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc550e21-a0c1-4560-97a3-08da0d448785
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 03:15:20.7869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeCAD44ApRV5aZfW0jwgjSKSc99AIxbHSpVstPn9yMVnowa9D1Etn19VqzX2vgKpDw2ycEF1hktTKA9Q7Jkvxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3667
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgTWFyY2ggMjQsIDIwMjIgMTA6NTcgQU0NCj4gDQo+IE9uIFRodSwgTWFyIDI0LCAyMDIyIGF0
IDEwOjQyIEFNIFRpYW4sIEtldmluIDxrZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4N
Cj4gPiA+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+ID4gPiBTZW50
OiBUaHVyc2RheSwgTWFyY2ggMjQsIDIwMjIgMTA6MjggQU0NCj4gPiA+DQo+ID4gPiBPbiBUaHUs
IE1hciAyNCwgMjAyMiBhdCAxMDoxMiBBTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5j
b20+DQo+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiA+IEZyb206IEphc29uIEd1bnRob3JwZSA8
amdnQG52aWRpYS5jb20+DQo+ID4gPiA+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAyMywgMjAy
MiAxMjoxNSBBTQ0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24gVHVlLCBNYXIgMjIsIDIwMjIgYXQg
MDk6Mjk6MjNBTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiBJJ20gc3RpbGwgcGlja2luZyBteSB3YXkgdGhyb3VnaCB0aGUgc2VyaWVzLCBidXQg
dGhlIGxhdGVyIGNvbXBhdA0KPiA+ID4gPiA+ID4gaW50ZXJmYWNlIGRvZXNuJ3QgbWVudGlvbiB0
aGlzIGRpZmZlcmVuY2UgYXMgYW4gb3V0c3RhbmRpbmcgaXNzdWUuDQo+ID4gPiA+ID4gPiBEb2Vz
bid0IHRoaXMgZGlmZmVyZW5jZSBuZWVkIHRvIGJlIGFjY291bnRlZCBpbiBob3cgbGlidmlydCBt
YW5hZ2VzDQo+IFZNDQo+ID4gPiA+ID4gPiByZXNvdXJjZSBsaW1pdHM/DQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBBRkFDSVQsIG5vLCBidXQgaXQgc2hvdWxkIGJlIGNoZWNrZWQuDQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+IEFJVUkgbGlidmlydCB1c2VzIHNvbWUgZm9ybSBvZiBwcmxpbWl0KDIpIHRv
IHNldCBwcm9jZXNzIGxvY2tlZA0KPiA+ID4gPiA+ID4gbWVtb3J5IGxpbWl0cy4NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+IFllcywgYW5kIHVsaW1pdCBkb2VzIHdvcmsgZnVsbHkuIHBybGltaXQgYWRq
dXN0cyB0aGUgdmFsdWU6DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBpbnQgZG9fcHJsaW1pdChzdHJ1
Y3QgdGFza19zdHJ1Y3QgKnRzaywgdW5zaWduZWQgaW50IHJlc291cmNlLA0KPiA+ID4gPiA+ICAg
ICAgICAgICAgICAgc3RydWN0IHJsaW1pdCAqbmV3X3JsaW0sIHN0cnVjdCBybGltaXQgKm9sZF9y
bGltKQ0KPiA+ID4gPiA+IHsNCj4gPiA+ID4gPiAgICAgICBybGltID0gdHNrLT5zaWduYWwtPnJs
aW0gKyByZXNvdXJjZTsNCj4gPiA+ID4gPiBbLi5dDQo+ID4gPiA+ID4gICAgICAgICAgICAgICBp
ZiAobmV3X3JsaW0pDQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICpybGltID0gKm5l
d19ybGltOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gV2hpY2ggdmZpbyByZWFkcyBiYWNrIGhlcmU6
DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBkcml2ZXJzL3ZmaW8vdmZpb19pb21tdV90eXBlMS5jOiAg
ICAgICAgdW5zaWduZWQgbG9uZyBwZm4sIGxpbWl0ID0NCj4gPiA+ID4gPiBybGltaXQoUkxJTUlU
X01FTUxPQ0spID4+IFBBR0VfU0hJRlQ7DQo+ID4gPiA+ID4gZHJpdmVycy92ZmlvL3ZmaW9faW9t
bXVfdHlwZTEuYzogICAgICAgIHVuc2lnbmVkIGxvbmcgbGltaXQgPQ0KPiA+ID4gPiA+IHJsaW1p
dChSTElNSVRfTUVNTE9DSykgPj4gUEFHRV9TSElGVDsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEFu
ZCBpb21tdWZkIGRvZXMgdGhlIHNhbWUgcmVhZCBiYWNrOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g
ICAgICAgbG9ja19saW1pdCA9DQo+ID4gPiA+ID4gICAgICAgICAgICAgICB0YXNrX3JsaW1pdChw
YWdlcy0+c291cmNlX3Rhc2ssIFJMSU1JVF9NRU1MT0NLKSA+Pg0KPiA+ID4gPiA+IFBBR0VfU0hJ
RlQ7DQo+ID4gPiA+ID4gICAgICAgbnBhZ2VzID0gcGFnZXMtPm5waW5uZWQgLSBwYWdlcy0+bGFz
dF9ucGlubmVkOw0KPiA+ID4gPiA+ICAgICAgIGRvIHsNCj4gPiA+ID4gPiAgICAgICAgICAgICAg
IGN1cl9wYWdlcyA9IGF0b21pY19sb25nX3JlYWQoJnBhZ2VzLT5zb3VyY2VfdXNlci0NCj4gPiA+
ID4gPiA+bG9ja2VkX3ZtKTsNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIG5ld19wYWdlcyA9IGN1
cl9wYWdlcyArIG5wYWdlczsNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIGlmIChuZXdfcGFnZXMg
PiBsb2NrX2xpbWl0KQ0KPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVO
T01FTTsNCj4gPiA+ID4gPiAgICAgICB9IHdoaWxlIChhdG9taWNfbG9uZ19jbXB4Y2hnKCZwYWdl
cy0+c291cmNlX3VzZXItPmxvY2tlZF92bSwNCj4gPiA+ID4gPiBjdXJfcGFnZXMsDQo+ID4gPiA+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBuZXdfcGFnZXMpICE9IGN1cl9w
YWdlcyk7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBTbyBpdCBkb2VzIHdvcmsgZXNzZW50aWFsbHkg
dGhlIHNhbWUuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUaGUgZGlmZmVyZW5jZSBpcyBtb3JlIHN1
YnRsZSwgaW91cmluZy9ldGMgcHV0cyB0aGUgY2hhcmdlIGluIHRoZSB1c2VyDQo+ID4gPiA+ID4g
c28gaXQgaXMgYWRkaXRpdmUgd2l0aCB0aGluZ3MgbGlrZSBpb3VyaW5nIGFuZCBhZGRpdGl2ZWx5
IHNwYW5zIGFsbA0KPiA+ID4gPiA+IHRoZSB1c2VycyBwcm9jZXNzZXMuDQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBIb3dldmVyIHZmaW8gaXMgYWNjb3VudGluZyBvbmx5IHBlci1wcm9jZXNzIGFuZCBv
bmx5IGZvciBpdHNlbGYgLSBubw0KPiA+ID4gPiA+IG90aGVyIHN1YnN5c3RlbSB1c2VzIGxvY2tl
ZCBhcyB0aGUgY2hhcmdlIHZhcmlhYmxlIGZvciBETUEgcGlucy4NCj4gPiA+ID4gPg0KPiA+ID4g
PiA+IFRoZSB1c2VyIHZpc2libGUgZGlmZmVyZW5jZSB3aWxsIGJlIHRoYXQgYSBsaW1pdCBYIHRo
YXQgd29ya2VkIHdpdGgNCj4gPiA+ID4gPiBWRklPIG1heSBzdGFydCB0byBmYWlsIGFmdGVyIGEg
a2VybmVsIHVwZ3JhZGUgYXMgdGhlIGNoYXJnZSBhY2NvdW50aW5nDQo+ID4gPiA+ID4gaXMgbm93
IGNyb3NzIHVzZXIgYW5kIGFkZGl0aXZlIHdpdGggdGhpbmdzIGxpa2UgaW9tbXVmZC4NCj4gPiA+
ID4gPg0KPiA+ID4gPiA+IFRoaXMgd2hvbGUgYXJlYSBpcyBhIGJpdCBwZWN1bGlhciAoZWcgbWxv
Y2sgaXRzZWxmIHdvcmtzIGRpZmZlcmVudGx5KSwNCj4gPiA+ID4gPiBJTUhPLCBidXQgd2l0aCBt
b3N0IG9mIHRoZSBwbGFjZXMgZG9pbmcgcGlucyB2b3RpbmcgdG8gdXNlDQo+ID4gPiA+ID4gdXNl
ci0+bG9ja2VkX3ZtIGFzIHRoZSBjaGFyZ2UgaXQgc2VlbXMgdGhlIHJpZ2h0IHBhdGggaW4gdG9k
YXkncw0KPiA+ID4gPiA+IGtlcm5lbC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IENlcmF0aW5seSBo
YXZpbmcgcWVtdSBjb25jdXJyZW50bHkgdXNpbmcgdGhyZWUgZGlmZmVyZW50IHN1YnN5c3RlbXMN
Cj4gPiA+ID4gPiAodmZpbywgcmRtYSwgaW91cmluZykgaXNzdWluZyBGT0xMX0xPTkdURVJNIGFu
ZCBhbGwgYWNjb3VudGluZyBmb3INCj4gPiA+ID4gPiBSTElNSVRfTUVNTE9DSyBkaWZmZXJlbnRs
eSBjYW5ub3QgYmUgc2FuZSBvciBjb3JyZWN0Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSSBwbGFu
IHRvIGZpeCBSRE1BIGxpa2UgdGhpcyBhcyB3ZWxsIHNvIGF0IGxlYXN0IHdlIGNhbiBoYXZlDQo+
ID4gPiA+ID4gY29uc2lzdGVuY3kgd2l0aGluIHFlbXUuDQo+ID4gPiA+ID4NCj4gPiA+ID4NCj4g
PiA+ID4gSSBoYXZlIGFuIGltcHJlc3Npb24gdGhhdCBpb21tdWZkIGFuZCB2ZmlvIHR5cGUxIG11
c3QgdXNlDQo+ID4gPiA+IHRoZSBzYW1lIGFjY291bnRpbmcgc2NoZW1lIGdpdmVuIHRoZSBtYW5h
Z2VtZW50IHN0YWNrDQo+ID4gPiA+IGhhcyBubyBpbnNpZ2h0IGludG8gcWVtdSBvbiB3aGljaCBv
bmUgaXMgYWN0dWFsbHkgdXNlZCB0aHVzDQo+ID4gPiA+IGNhbm5vdCBhZGFwdCB0byB0aGUgc3Vi
dGxlIGRpZmZlcmVuY2UgaW4gYmV0d2Vlbi4gaW4gdGhpcw0KPiA+ID4gPiByZWdhcmQgZWl0aGVy
IHdlIHN0YXJ0IGZpeGluZyB2ZmlvIHR5cGUxIHRvIHVzZSB1c2VyLT5sb2NrZWRfdm0NCj4gPiA+
ID4gbm93IG9yIGhhdmUgaW9tbXVmZCBmb2xsb3cgdmZpbyB0eXBlMSBmb3IgdXB3YXJkIGNvbXBh
dGliaWxpdHkNCj4gPiA+ID4gYW5kIHRoZW4gY2hhbmdlIHRoZW0gdG9nZXRoZXIgYXQgYSBsYXRl
ciBwb2ludC4NCj4gPiA+ID4NCj4gPiA+ID4gSSBwcmVmZXIgdG8gdGhlIGZvcm1lciBhcyBJTUhP
IEkgZG9uJ3Qga25vdyB3aGVuIHdpbGwgYmUgYSBsYXRlcg0KPiA+ID4gPiBwb2ludCB3L28gY2Vy
dGFpbiBrZXJuZWwgY2hhbmdlcyB0byBhY3R1YWxseSBicmVhayB0aGUgdXNlcnNwYWNlDQo+ID4g
PiA+IHBvbGljeSBidWlsdCBvbiBhIHdyb25nIGFjY291bnRpbmcgc2NoZW1lLi4uDQo+ID4gPg0K
PiA+ID4gSSB3b25kZXIgaWYgdGhlIGtlcm5lbCBpcyB0aGUgcmlnaHQgcGxhY2UgdG8gZG8gdGhp
cy4gV2UgaGF2ZSBuZXcgdUFQSQ0KPiA+DQo+ID4gSSBkaWRuJ3QgZ2V0IHRoaXMuIFRoaXMgdGhy
ZWFkIGlzIGFib3V0IHRoYXQgVkZJTyB1c2VzIGEgd3JvbmcgYWNjb3VudGluZw0KPiA+IHNjaGVt
ZSBhbmQgdGhlbiB0aGUgZGlzY3Vzc2lvbiBpcyBhYm91dCB0aGUgaW1wYWN0IG9mIGZpeGluZyBp
dCB0byB0aGUNCj4gPiB1c2Vyc3BhY2UuDQo+IA0KPiBJdCdzIHByb2JhYmx5IHRvbyBsYXRlIHRv
IGZpeCB0aGUga2VybmVsIGNvbnNpZGVyaW5nIGl0IG1heSBicmVhayB0aGUgdXNlcnNwYWNlLg0K
PiANCj4gPiBJIGRpZG4ndCBzZWUgdGhlIHF1ZXN0aW9uIG9uIHRoZSByaWdodCBwbGFjZSBwYXJ0
Lg0KPiANCj4gSSBtZWFudCBpdCB3b3VsZCBiZSBlYXNpZXIgdG8gbGV0IHVzZXJzcGFjZSBrbm93
IHRoZSBkaWZmZXJlbmNlIHRoYW4NCj4gdHJ5aW5nIHRvIGZpeCBvciB3b3JrYXJvdW5kIGluIHRo
ZSBrZXJuZWwuDQoNCkphc29uIGFscmVhZHkgcGxhbnMgdG8gZml4IFJETUEgd2hpY2ggd2lsbCBh
bHNvIGxlYWRzIHRvIHVzZXItYXdhcmUNCmltcGFjdCB3aGVuIFFlbXUgdXNlcyBib3RoIFZGSU8g
YW5kIFJETUEuIFdoeSBpcyBWRklPIHNvIHNwZWNpYWwNCmFuZCBsZWZ0IGJlaGluZCB0byBjYXJy
eSB0aGUgbGVnYWN5IG1pc2Rlc2lnbj8NCg0KPiANCj4gPg0KPiA+ID4gc28gbWFuYWdlbWVudCBs
YXllciBjYW4ga25vdyB0aGUgZGlmZmVyZW5jZSBvZiB0aGUgYWNjb3VudGluZyBpbg0KPiA+ID4g
YWR2YW5jZSBieQ0KPiA+ID4NCj4gPiA+IC1kZXZpY2UgdmZpby1wY2ksaW9tbXVmZD1vbg0KPiA+
ID4NCj4gPg0KPiA+IEkgc3VwcG9zZSBpb21tdWZkIHdpbGwgYmUgdXNlZCBvbmNlIFFlbXUgc3Vw
cG9ydHMgaXQsIGFzIGxvbmcgYXMNCj4gPiB0aGUgY29tcGF0aWJpbGl0eSBvcGVucyB0aGF0IEph
c29uL0FsZXggZGlzY3Vzc2VkIGluIGFub3RoZXIgdGhyZWFkDQo+ID4gYXJlIHdlbGwgYWRkcmVz
c2VkLiBJdCBpcyBub3QgbmVjZXNzYXJpbHkgdG8gYmUgYSBjb250cm9sIGtub2IgZXhwb3NlZA0K
PiA+IHRvIHRoZSBjYWxsZXIuDQo+IA0KPiBJdCBoYXMgYSBsb3Qgb2YgaW1wbGljYXRpb25zIGlm
IHdlIGRvIHRoaXMsIGl0IG1lYW5zIGlvbW11ZmQgbmVlZHMgdG8NCj4gaW5oZXJpdCBhbGwgdGhl
IHVzZXJzcGFjZSBub3RpY2VhYmxlIGJlaGF2aW91ciBhcyB3ZWxsIGFzIHRoZSAiYnVncyINCj4g
b2YgVkZJTy4NCj4gDQo+IFdlIGtub3cgaXQncyBlYXNpZXIgdG8gZmluZCB0aGUgZGlmZmVyZW5j
ZSB0aGFuIHNheWluZyBubyBkaWZmZXJlbmNlLg0KPiANCg0KSW4gdGhlIGVuZCB2ZmlvIHR5cGUx
IHdpbGwgYmUgcmVwbGFjZWQgYnkgaW9tbXVmZCBjb21wYXQgbGF5ZXIuIFdpdGgNCnRoYXQgZ29h
bCBpbiBtaW5kIGlvbW11ZmQgaGFzIHRvIGluaGVyaXQgdHlwZTEgYmVoYXZpb3JzLg0KDQpUaGFu
a3MNCktldmluDQo=
