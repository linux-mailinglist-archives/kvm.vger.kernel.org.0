Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232CE545BB2
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 07:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiFJFcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 01:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241539AbiFJFcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 01:32:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E034B1F8;
        Thu,  9 Jun 2022 22:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654839165; x=1686375165;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=23N2LviZrhmWdq/9QFNL+BxR0AGLkPnQeRIyXQG5LRA=;
  b=GBM11BHgmcU8XShTl4Sb2mcKIQBnZv0+9hCfAxSr1R3foMWXqa7tDuzl
   7tr1/8Q/pxRLtNuybtdlrUSoBvZO+UBrEsaAu38HYqNjkxsWT0QeQioqK
   N3n1Nezk1YJmfY8ZJcE9rwkHaOKRERmI15qZ7aMXcWatI93WD6hLNJB/b
   IPn24PzulBfNI4mHflK/U2P3n8G4OpXx0GzBFCXci0o7SY6+ip6LFoarN
   U1t+O/pLZRKsuHSQ5F2yISePW2/DkDagDmNtx3noc/tuOAk0YSLZAe/RR
   y9NXssK5GEJzvCi/0ugiexdH/svjdiMw9hPFWyBkTRczaMDeQb+U+ANta
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="275046987"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="275046987"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 22:32:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="649641019"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2022 22:32:42 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 22:32:42 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 22:32:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 9 Jun 2022 22:32:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 9 Jun 2022 22:32:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5MdYD2kEXvkOGJOHVIPdoXGKTdAJnP0X7o0UNKyMNpcj/C5LQl3A2nCASipgMBmad2+JF6Td0qUZxEXq0VW32DbDeBY7TWiaEB2XBuj5SC+zHzTR6ygxB0JUxR9G1WvFFUYvZGZmZxf/MWikiP1ivxywNNKVP+vnDwLOToOQDvZSAOcYTZGOnjjNySkFG9pqovSTKHiVVig86QhXrruPrMLbmcLZZ8kxMty/v6Buc8gTZqjny4YUucdQfVrSOkmFAZq5qd0UNcoxRKlMaqzkSSXgWxLPPiKAA033/xsZfVmOFtRsJv8HCqSkwRb9A7aV8O8cE3gjJga7+0P9/e72w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=23N2LviZrhmWdq/9QFNL+BxR0AGLkPnQeRIyXQG5LRA=;
 b=ArLEpJF382eTnKLylBjzi/w1xO5j8p5sa/3nVT8amsCrgYdOCaszSoP6/DC1rgA8EOo3MnCHQyvgk1201oXtndMgI6vp+EDFqR3H3cd6XdYupVE0dl63SSEFE2jckRfW0hslHt9PzaXObHBMVAQFt8CD74HPBBIAEt7W3IN1BkjV5pGbF2405J3elgrqOG7JWgo7i7wV6VkUcVKHcO2QdAPoN+QLGyascmJn6yo/C0xLwya5REFgVd89Px0lcyxvfZjlAkKMj4z+9PH8JIiqv95AmgJdHSBRW46gCMad5mPH1NWZTA5lK4oJGNfCMUBoukJILF/KY5ezSVV+nPG3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5610.namprd11.prod.outlook.com (2603:10b6:510:e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Fri, 10 Jun
 2022 05:32:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 05:32:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "diana.craciun@oss.nxp.com" <diana.craciun@oss.nxp.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "hch@lst.de" <hch@lst.de>
Subject: RE: [PATCH] vfio: de-extern-ify function prototypes
Thread-Topic: [PATCH] vfio: de-extern-ify function prototypes
Thread-Index: AQHYe2l9aM17ptBroU2FC9IoxGFwnK1IH/PQ
Date:   Fri, 10 Jun 2022 05:32:40 +0000
Message-ID: <BN9PR11MB52764A57D65FF2B0AC463C2C8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <165471414407.203056.474032786990662279.stgit@omen>
In-Reply-To: <165471414407.203056.474032786990662279.stgit@omen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6b2f1bb-ee88-4e51-20f1-08da4aa2a2b7
x-ms-traffictypediagnostic: PH0PR11MB5610:EE_
x-microsoft-antispam-prvs: <PH0PR11MB5610E04829AA9B82C8CD78648CA69@PH0PR11MB5610.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ViuAv5Oab844aLZ2N86+JNu6dJD79n0Tq+7Ak5y7MSDhj0U86MJh2f6lS/ndRFKxYGBLgd4phwOLH1OtUuXInvQGABSpiuCL/0ROvcqrZtCnGFhAoDW1jfRjtjYZ23Ib9deZzKH2wNTrYFuwDms34jm84ZavIu0aU5I/7HhPY0APW4lJTlwT1BvMPSQN85GavS1iv/MOn02A9d20n7rJkg9WpsAzD1JrX4Bar92MuQ2RC3btlX7qj4CQpNak4jvuWDanIxx/xU7Jh07tsRtYVZug7U021PQzD3K+dnCVBcKg3NA6QcEMjywcdQ6mlo3Dulc5/oRZkH6lM2Loqht4IwyBCNdg3duaEFGzAw4D7O6uIs1/RkHARGJB9pk6+IsBpS5+T0okpTQJS0EUI+oLXrUqbbOzEioqiSn83dgjRcEP4MU+UAgGGX6+55r2w0EhqhHbbB78PuTGFBUUnXMzjBK+aoyXsI4asWFKBEXHIfxWvYMK8aCduP0Yl+Kxf2sHniNylmOPlqqNs6VvL1bj0Vcemk9mZaDaH+X1mt3H+A1v35YjTFsfdgOFprb/moiZcdGEr4m6wwOMXCBytkVzli6u3M6i3E2Rq1GwEA4cUuJ6pGHlAwPnIUy6aiPiywyizIRZ4P/mPVETdebBxmyPN8098QVslFjfLKSrNDE/ARXSn7T8pnHp77xLfm0vFi2lR+hAfS81xa4HcWjOxk2MHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(71200400001)(4744005)(122000001)(82960400001)(8936002)(86362001)(508600001)(33656002)(66446008)(8676002)(64756008)(4326008)(66476007)(76116006)(52536014)(38070700005)(6916009)(316002)(7416002)(54906003)(5660300002)(55016003)(66556008)(66946007)(186003)(7696005)(6506007)(26005)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE81bW90cWkzTEdjYVNiM05OOVkvN09rNzNwV01GUFk3ak9GbS9oUi90dXZK?=
 =?utf-8?B?ZUFRWndBeFpvNDJGbkU0Tjl6amt1TVFRVFNvamlGUEpORWRuMnVrUWs2WjU1?=
 =?utf-8?B?TTJramFUR0FkVEZGSzBwN2Q0NjdkVDlseTQ4ck5laTQveGRFMk5mNm5ML2Rz?=
 =?utf-8?B?TVJWM241bmsrQ0xuU1R1cTJFVEUrS1JnYk1LMUlXbERkMmFVZ1QybEttM2ds?=
 =?utf-8?B?bmJ0bURpMFRWZ2pSTEpwZm5neTRZVVlsSXppTkRBUjgvTE82OEpLbmpKc1hx?=
 =?utf-8?B?RWxHVTlrSVg4NlU0L1ZvcW1BbytyampZeDJRNGhjanFlSU9hNjY0aldQSEN5?=
 =?utf-8?B?bGgzRXk4dWdDMUNGdjNQdGZUUHhsMHdVRVhrMEVZUVZpVXdienNWOUdrUmRx?=
 =?utf-8?B?bUI0MzZ6UUhxUlZvQVh6M0NTWS9vU2NKaEpKZlVNSEU2bWtYdmFGVElUNXpR?=
 =?utf-8?B?YnNUZFR4UHh6Q0hkVEUvMDkxWkRNWjdraGR0MnN6NnJXV21VK1ZuYjdyU29U?=
 =?utf-8?B?aXlIczA2V2U2UjNBeGZJQzRaWXJLcnN1NWU0L1VhS1hocUZIQVhyWUhvdXFm?=
 =?utf-8?B?Qk9tWkV2QjY2YzhCK3ptTmRtL1FaOENHbXRzcGZuOUhFeHZFWXErZFhJd1Nz?=
 =?utf-8?B?RXMrZm9XWWdNaDVoZzhtenJkdjI3TzFVS3Q2NDRINGtXY21SWXB2M2k2b29s?=
 =?utf-8?B?L0JWa3VEb3ZxY2lvSkhuakpMRzQ2S2pDZ3dsU25PQmgzNjI0clhjVTRmZjhr?=
 =?utf-8?B?RHYzWFBqdHFlMkc0MGtUZGFINmhxRUtBZCs3dkxTb3ZsajN4K1A5QjNaKzlB?=
 =?utf-8?B?d0ZjOGl6RnpQSzhqVU5Ca044a3ltWE1wZG9ZZ0k3WUJvbXphVjVXQW1CUHVR?=
 =?utf-8?B?ZHcweFRkUFZ1UVlHakErNXp5SWlNa1RCS2YvOEFraGpWbVNLVHlFWHE1YTc5?=
 =?utf-8?B?VFNIenVRSzdLMS9BMjh2ZGpHaklaMHZiT1J6dUdSV1hQMVJJNExWYVJqTkFL?=
 =?utf-8?B?S0tuQzNINXU5Z2J1RnFaMFM1K2NPRGxHSXpSMWVaQ3hNcnVsbXJQL0NYMTFx?=
 =?utf-8?B?M1pETTVzRXhRaHg5bjMvSmVkMUxnYU4wMzZZU3MzNStUZnZkcmVUUHNoTFpP?=
 =?utf-8?B?TnpSNlhVYXMwdThvR0llYXJPbGdhTG1qZWRBRDZtTk43b3psZklNWTEwVTV0?=
 =?utf-8?B?ZmNqVkJXMldjdHBpbnNEM1l5cTg5R3FJK0JBYjBpTXBNUTVwSGhRNkFJN24x?=
 =?utf-8?B?cU9nWDVZNUxUc1ZRV1p0RERFb0JJY1RHWEpTWjg2K29ZT0k2YkFwQ1FrZ2Y1?=
 =?utf-8?B?N2dXQnQ4WmUwM2J4ZFJWdElpb2hpTjFBdkpqYTFDT29BNDI2RWVLeisxQjRa?=
 =?utf-8?B?SExqdjAxOG1UR3FjVnZ3U2dyOVJJaEd1a1c1ZjVHUjVlWDJGc1VGMjVXWUlC?=
 =?utf-8?B?UWZTNFM0MTgwNUN6R3p3aytBcnY2cVJmejZiSWVPakZLM2FDUlp4VFVjY3Q1?=
 =?utf-8?B?Skk1TldPUlYvVnFLVEpuT2d2NUhkYXdGVEJiaWN3QUphWVpQSkZiZno0NGJs?=
 =?utf-8?B?bzFLSS9HaUYxbXFQaTBoUFBqZ09Nb0xjTkZlOE5DajlsUm0vdFlZZUlKekFz?=
 =?utf-8?B?ZTB4WDRCK1F2WkpvVHlCVXZVdTMyWmVoVnZKd3dSSkcvbUl6aUg1V242Z0k4?=
 =?utf-8?B?cGUwRkltOWxLcmNXT2psVTRLK3gvekNRaGl2cjNSSXgxNXpFUG9ld3hPV2xj?=
 =?utf-8?B?aHdkdHhSbXRuVzBMc0M5ODh3VVQxZkI3d1VtZmtjOWZrN25RRzVBMmxNdHpJ?=
 =?utf-8?B?U1REc0UyOUpxTEZxVEJlMDN2OWs1YlZKbWNuVk9BS0Z2NUNkbENRWnArYXlJ?=
 =?utf-8?B?RUhudm1HUjVPekkzd2ltQkxCcnM1bXRqZ2tRRUpqWjJSaVB5V1lyZ2I1Ty9o?=
 =?utf-8?B?VGNLZVFNTTZpaTV0RFpQZlB4M3Y4SHU3SkVSVEorRCs5WnVlb082eC91Tkl4?=
 =?utf-8?B?aWlFYnlnaWU5Z2tCSGJ1cmp6c1dlUm1Zc2N2Z2ZVMnYvTDE2R0xJTmQvTVVU?=
 =?utf-8?B?bUcrQlFVa0w5b1BlWENPWW1ZOG1mYzZpa0VlV0kybDNDRFp3TTFUL0VHbVJB?=
 =?utf-8?B?WlBmVllETXRGTFZyeFN3bXIzM3dQUS9JaGxwcElKb3NKMFdOWURGSDVTVGk3?=
 =?utf-8?B?RG9DQTBHZkU4Vk82NTBkMG95VjZwbnZPcVNiYk5ZR2pXYnlKNUQwaXFscmwx?=
 =?utf-8?B?K01OdkdmbGJ0aFRtK2tnL3V3M3BNaG9EMWtaQyt1QUdWNTg2VFpZMU9MWmo0?=
 =?utf-8?B?MjRFUmlBWWZUQ3BNZVVvZWt1WTVsZHdacUlQVzdMVENWVVY2Q1lNUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b2f1bb-ee88-4e51-20f1-08da4aa2a2b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 05:32:40.1258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m9W5hGdehQ34yHtmyVTiXM3Ugut1Go54+oGoCCqIS1niAMH1rMafU5q0fg5pMVbbl2PB+Q2IAgHVqeDpDDjyFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5610
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgSnVuZSA5LCAyMDIyIDI6NTUgQU0NCj4gDQo+IFRoZSB1c2Ugb2YgJ2V4
dGVybicgaW4gZnVuY3Rpb24gcHJvdG90eXBlcyBoYXMgYmVlbiBkaXNyZWNvbW1lbmRlZCBpbg0K
PiB0aGUga2VybmVsIGNvZGluZyBzdHlsZSBmb3Igc2V2ZXJhbCB5ZWFycyBub3csIHJlbW92ZSB0
aGVtIGZyb20gYWxsIHZmaW8NCj4gcmVsYXRlZCBmaWxlcyBzbyBjb250cmlidXRvcnMgbm8gbG9u
Z2VyIG5lZWQgdG8gZGVjaWRlIGJldHdlZW4gc3R5bGUgYW5kDQo+IGNvbnNpc3RlbmN5Lg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogQWxleCBXaWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0
LmNvbT4NCj4gLS0tDQo+IA0KPiBBIHBhdGNoIGluIHRoZSBzYW1lIHZlaW4gd2FzIHByb3Bvc2Vk
IGFib3V0IGEgeWVhciBhZ28sIGJ1dCB0aWVkIHRvIGFuIGlsbA0KPiBmYXRlZCBzZXJpZXMgYW5k
IGZvcmdvdHRlbi4gIE5vdyB0aGF0IHdlJ3JlIGF0IHRoZSBiZWdpbm5pbmcgb2YgYSBuZXcNCj4g
ZGV2ZWxvcG1lbnQgY3ljbGUsIEknZCBsaWtlIHRvIHByb3Bvc2Uga2lja2luZyBvZmYgdGhlIHY1
LjIwIHZmaW8gbmV4dA0KPiBicmFuY2ggd2l0aCB0aGlzIHBhdGNoIGFuZCB3b3VsZCBraW5kbHkg
YXNrIGFueW9uZSB3aXRoIHBlbmRpbmcgcmVzcGlucyBvcg0KPiBzaWduaWZpY2FudCBjb25mbGlj
dHMgdG8gcmViYXNlIG9uIHRvcCBvZiB0aGlzIHBhdGNoLiAgVGhhbmtzIQ0KPiANCg0KUmV2aWV3
ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0K
