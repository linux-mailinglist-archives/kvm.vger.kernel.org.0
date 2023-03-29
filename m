Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26F96CCFEE
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjC2CYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 22:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC2CYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 22:24:39 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491D92728;
        Tue, 28 Mar 2023 19:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680056675; x=1711592675;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sn6jGR43XbY3SC+2mgbVg5c+VreVRx1DS9LA0OkPJ9A=;
  b=En21gHVjQTWB28MDILeJPliqAf1C733yaQj/juULtfEZWGETKNVM5S4y
   cASbcad3CD12s9HmPAzrYVOO6opDNnwJa8rr0QLXHKeOB/s39G5bmDzah
   KawVdMfgPZAuOZGKnQVz/EWM2ZptkiWYCGX/AM5Ybf+cKrtukU/Ho/Ka1
   IfmfDc7RtR9KDHr3RJ8IRbBoYnnz47kjS5d8x8tsn5sabru5JmkyEMkQZ
   B4wtU+WDPQCLXAX/1dNK9LgjXyYi0z1JahpUSggIjnXao5IrkKFh/eoJw
   +YhEIAMiDwjfAIxFMbuk0ffU5ZLcn/FglIP4et+6beiuZz+Ufz0ZInhuO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="405693946"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="405693946"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 19:24:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="661432465"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="661432465"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 28 Mar 2023 19:24:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:24:35 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 19:24:34 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 19:24:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 19:24:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nz83FrQdYwgOAiqR/nIeoBQRWS7yxY7U49xXvVYZIntFULN75cq+PpQAWutfi3c3iGBJBDkmG7ah0tD47rUiIa5k+qcOaD7fCkfQrW7TL+kbNIDHfSO8i1+MHFItF9Kh+yxPfS+gstMjHRzVO4gy7tCUj0PgE0AYvpNhggcnBtwCkUM4TdlOBTpAyyrR3bO3oLWudh7cnHXGZSdzaYgaOh/nnLCkekbTL1/joYNrPTBacJMxjyoySaaX3twnus1EKtlN3j+lulPy8NV0Irv8bjC+Jc+k2A3RyLCIhwZyyVKRUJYpiyH3gccw92dlQ7SLy9OoXPU/K18Qo8M19TunDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sn6jGR43XbY3SC+2mgbVg5c+VreVRx1DS9LA0OkPJ9A=;
 b=MTW7ELNvSFHVgqlq0gjTkdD5qYzWDJlnUr6R9SAzY8deLeiyXct30KYYorQb1chvfGEAPj8SNlXJDlw7ZU7Ve2xdZ6voMlAc9BZtsgKFiW72v8CJ2XZQkclX9U3nOJWz0p1fDpc3qG4M0rumBtKhc7FmHMt9tHI4hLUqzcnseqtPa7Ki2XSQMcrXF/n+XRNs03DnqO2SlNqodKmRdrbxCM5C4e7SJ47SU9JAlRQ/BwJZaLoRtMK6X9tVkH8n0QkeBQ1+xXC0MqaQBTm21WzFtfLNg4LZJgnTeqMsIM0R7G7hP7QQI6WaqwiTwKBNaHm6+ctDhwY5Yw5hxMXTPdV+sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB7834.namprd11.prod.outlook.com (2603:10b6:8:ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Wed, 29 Mar
 2023 02:24:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.041; Wed, 29 Mar 2023
 02:24:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>, Jon Pan-Doh <pandoh@google.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v8 16/24] iommufd/device: Add iommufd_access_detach() API
Thread-Topic: [PATCH v8 16/24] iommufd/device: Add iommufd_access_detach() API
Thread-Index: AQHZYJBEHdpEizO+5UWisN8HThOh0q8Pd5KAgADikQCAAK/Q4A==
Date:   Wed, 29 Mar 2023 02:24:28 +0000
Message-ID: <DS0PR11MB7529F70B9C0E17D02890C91CC3899@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327094047.47215-17-yi.l.liu@intel.com>
 <20230328022357.2268961-1-pandoh@google.com>
 <ZCMNzMV0DTOQEdgH@Asurada-Nvidia>
In-Reply-To: <ZCMNzMV0DTOQEdgH@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS7PR11MB7834:EE_
x-ms-office365-filtering-correlation-id: 5d690f01-a245-4f4f-6462-08db2ffcb8de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jKwyARU16uejpPVAkx+YcH4AHn2tQNSdN2RS0jQkV6JxfxELbNMMyKcEujb6gxjsi2yR1pwPe981tC8ciQ+6bmOOc2rbk79+b0y6cP2leJSZC7Va2+SfdEimBkEn235y4BgzzUlnWXQGY4VHP87R8Fo0IReTOQIqmN3DAoqmXKT9kixPdG3xTA00JDB25F3yLHGgWGAE7PR4TvnNb1nURcAdrd6D7UvxtsjPb78sjjB3Gsuevf+ORmRE9IsBR8t/A1pqNqITo+w0YeptjOm4/5CG+sj6p8YWwxuao+7gpxuJVLclqMk79kVwqPY/Jayk1+pk5sonzyF1Q0IJYRoBOl3f1y2+hXNaJXz/AN5R/riINU0E/r/KqYhQ+d5MJD6jqi7shRi990K2gF4HKtCZNbwCen4ip3It6N5jFmC1HsepjygEVk92JB/r4IZf1mBkIOJ2N6PYr7/4UUq6X2Ko6A4l6G/3wx3izru9PNcTsFYdUT8N4/jloVWaL2w/iv2nETNynONG0Iblt78SD5Lk30cYqDiqlMvz/fvEho+7NH7HvZFjlzowjglB3wv02xNKlkFq2wJ73r83GFyYzDCpscV7tSP/1v3ZRRxe4rq6ddvh4f/d3XLPDP1WSBSgqLPU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(84040400005)(451199021)(33656002)(38070700005)(86362001)(2906002)(38100700002)(55016003)(83380400001)(71200400001)(7696005)(9686003)(53546011)(76116006)(316002)(4326008)(478600001)(5660300002)(66556008)(66476007)(64756008)(66446008)(66946007)(54906003)(110136005)(122000001)(52536014)(8676002)(186003)(26005)(8936002)(6506007)(41300700001)(7416002)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUVLbWhrVy84cGsxRFQ1VGYxWVJwQ09HSzdMZnk2Yi9rQkd4SG5vaGYyM3JR?=
 =?utf-8?B?b1lJajFnSUl3RWoybVp3YTdualJhNllDYjhkV3hCakhHa2htTWpwbURRaG1i?=
 =?utf-8?B?YTV6Q0xwK0pZNktSYmlabzlIT0JjUUVWOG5JY3N1cFFHVmJNckk0UisrL3BD?=
 =?utf-8?B?UDlmZjY2bTh0dGZiUnJZZC9wZks3Qjd1VlVUbjlZTEpSejg3bVhoOXEvRjVs?=
 =?utf-8?B?QzNTcWt0QkRzek1kTE9EOVhEdlhNdGRQcUp6WkNuYWdrYzM1THFWL3JYV1Rl?=
 =?utf-8?B?Ris5VHpmSGtUNFhvMWViaXJmWXNDZzZSVlJTU05URUV3WHhLMDgvKzNqQVA5?=
 =?utf-8?B?M1ZtWmhlSUZ2L3c4OHZ6VUR6SThtYzczczNiOU5JVFg2K0RjWlJmUzFtZzZy?=
 =?utf-8?B?VVdsM0hLRW1QNTNzZ3Z5eHlGNW53anoycUQvdG5lVkd6NTBsbHEyVERqQy9t?=
 =?utf-8?B?OWRYQ3BxWXJneGNMcXpQSzc1VHA0MmlsVi9QTWNNMmFHaFl2YUQ5b3hMYmxC?=
 =?utf-8?B?VGsyQlM4b1cza1hLVHdSZXluLzhmZEJyUFUzRnRjMXU1REUwVHJLTzQ3T0ls?=
 =?utf-8?B?YUpTS2kraUE1bVVUMFlTTllUdmQrY3kzdkI5MkhJZCt2VnBhS1NMdzZNVnd5?=
 =?utf-8?B?OGdWUjFkOUNEaWNaS1ZNYmFzcjl3VG85MlVSYytZd2RlbWIyZWRaQXRWVXg1?=
 =?utf-8?B?TnZpNWNBdElkQU1FM1J5a2dwYTZTank2T0JPN3NKNld0UFFOT2k4QmJXOTla?=
 =?utf-8?B?RXZUN0lsNFp2ZjdwZ2tFNmp3RXY0ZXVJcHlOdmtURzNxMGFIMDBoNmw4RlBU?=
 =?utf-8?B?elVTU2h1Q2NBbW5lc21ocmZ4bElubDNjaHQwMUxqdDVLM1NsMHFrSEdIUnlO?=
 =?utf-8?B?QTNiUllJbVVlcEYySE10Und3U2pVM1BQSy9MNkwzSFRjWldVWWVpY09idmlJ?=
 =?utf-8?B?M1BpdVpYK2Q2bTZiR1RwUXIrc0QwNndsWHY0UDY0a1VVR1N4dFJxRHR5cS96?=
 =?utf-8?B?cDEvK3JwcUcvZ0lWNUxHUlA1bWVod3RBODY2ckh6M0t0aGx1WmVjdW1weDdC?=
 =?utf-8?B?RG83R2lSd3M2NkhxUDB2RHRsV096VnhnamdYdUVXajNaRTZSeTdQdXkveWRy?=
 =?utf-8?B?UUJsaUkvVWowWTY3T0NiU1pxWS9KR0FaNHJiK1lqLzMxZG50dDd5bFZlR0NU?=
 =?utf-8?B?ZkorQVdPZFRJY2x4c3VrSjE2c3dLNlhRelRZK1dBdmxONlp6NWZYNnFIZnRi?=
 =?utf-8?B?Q0VYV1J0Q2VmWGlnYm1USVZyaXd3RUR0dXZXeDZTbG1hMWNpQ1Z4VXY4RUo1?=
 =?utf-8?B?Q3ZPMUxDT2ZMZVphODJzeVliOElXTy9ZWE9pWVZaeXExYnJwWGtrSWZ2WnV0?=
 =?utf-8?B?Wjk2YU55T2dDS3dibHlYNmlqSWxFZk0vcUpDaVRHY0JKZ2RhYTZEYkNSVlA4?=
 =?utf-8?B?d2pRUlZ6RGVTcU5ROHNHYzRsZEUrNWZsYUhLM3IyaGtIRC9WOUc2b3lRSzUr?=
 =?utf-8?B?eWFDVU9XeitDaW9Gd1Q0RlJuUms5MjdqUGgxWVhkdFJSTUZCcCthTHA0VzUr?=
 =?utf-8?B?ZkloTGYvM2JEOEM2TlhiSWwyaDk1VXloWFlCV2tENXRGRUVEZHhwZ3YzRGhX?=
 =?utf-8?B?clNhNnZ1bmducGJHSzhZckV6R0FtNEJtb2RFdllXcGxCNDUxRUdXM3dqcU9s?=
 =?utf-8?B?V1MwcjNuNGVFRGI5TTh1TFQ1eU90NzJYNk8rQ3JUREUxbnpCNlJYSnRpSkRn?=
 =?utf-8?B?cnJKRVRyRXpsdWNIb1dkendva0Z0MGVCbGx0aTJQT2JDUG54Qm1xZzExSzZa?=
 =?utf-8?B?Q2NiVnp3dHMxa00vZDhIanFjUzVvYUR0WVBFWFQxOFVnYkRBaXpOaGN6ZzUz?=
 =?utf-8?B?czNySFJaTVZwaGl6dE1JSk9LQ3hHNmh4Y2ljSjVtd3BNWUZVWXM1N0k2emVK?=
 =?utf-8?B?cDJtVUZBL2ZKQ20zZ0h5SE1qRE9sQ2dHWlBrcWpuOXh2WlV6Nmc2SVp4VjBV?=
 =?utf-8?B?R1AwOVlnak4yVTh6WUJPUmRoYmYrL01iUDBFREtqaldyeEd0c3A0aWRtc0xX?=
 =?utf-8?B?dDBkT0l1ZkNRMHBnNzhSa3FTdUZweTZGK2dnbjBocW1BWUNDV1BnWTNwazht?=
 =?utf-8?Q?A1Jc0doq7Y8YNJ7RxgCT3VzGH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d690f01-a245-4f4f-6462-08db2ffcb8de
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 02:24:28.2590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k1vBJwZMMPoSclO6LMHhM69XlIX8ljIG8LAvlzThAeTiA0UaAtidd8RPiV0/SFrXAx0Plw8iy91ni1XCODogRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7834
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBOaWNvbGluIENoZW4gPG5pY29saW5jQG52aWRpYS5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIE1hcmNoIDI4LCAyMDIzIDExOjU1IFBNDQo+IA0KPiBPbiBNb24sIE1hciAyNywgMjAyMyBh
dCAwNzoyMzo1N1BNIC0wNzAwLCBKb24gUGFuLURvaCB3cm90ZToNCj4gPiBFeHRlcm5hbCBlbWFp
bDogVXNlIGNhdXRpb24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiA+DQo+ID4NCj4g
PiBPbiAyMDIzLzMvMjcgMDI6NDAsIFlpIExpdSB3cm90ZToNCj4gPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2lvbW11L2lvbW11ZmQvaW9tbXVmZF9wcml2YXRlLmgNCj4gYi9kcml2ZXJzL2lvbW11
L2lvbW11ZmQvaW9tbXVmZF9wcml2YXRlLmgNCj4gPiA+IGluZGV4IDJlNmU4ZTIxN2NjZS4uZWMy
Y2UzZWYxODdkIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pb21tdWZkL2lvbW11
ZmRfcHJpdmF0ZS5oDQo+ID4gPiArKysgYi9kcml2ZXJzL2lvbW11L2lvbW11ZmQvaW9tbXVmZF9w
cml2YXRlLmgNCj4gPiA+IEBAIC0yNjMsNiArMjYzLDggQEAgc3RydWN0IGlvbW11ZmRfYWNjZXNz
IHsNCj4gPiA+ICAgICAgIHN0cnVjdCBpb21tdWZkX29iamVjdCBvYmo7DQo+ID4gPiAgICAgICBz
dHJ1Y3QgaW9tbXVmZF9jdHggKmljdHg7DQo+ID4gPiAgICAgICBzdHJ1Y3QgaW9tbXVmZF9pb2Fz
ICppb2FzOw0KPiA+ID4gKyAgICAgc3RydWN0IGlvbW11ZmRfaW9hcyAqaW9hc191bnBpbjsNCj4g
PiA+ICsgICAgIHN0cnVjdCBtdXRleCBpb2FzX2xvY2s7DQo+ID4gPiAgICAgICBjb25zdCBzdHJ1
Y3QgaW9tbXVmZF9hY2Nlc3Nfb3BzICpvcHM7DQo+ID4gPiAgICAgICB2b2lkICpkYXRhOw0KPiA+
ID4gICAgICAgdW5zaWduZWQgbG9uZyBpb3ZhX2FsaWdubWVudDsNCj4gPg0KPiA+IEkgdGhpbmsg
eW91IG1heSBuZWVkIHRvIGluaXRpYWxpemUgaW9hc19sb2NrLiBJIGdvdCBsb2NrZGVwIHdhcm5p
bmdzIHJ1bm5pbmcNCj4gPiBpb21tdWZkIHNlbGZ0ZXN0cyBhZ2FpbnN0IHRoaXMgcGF0Y2guIFRo
b3NlIHdlbnQgYXdheSB3aGVuIEkgYWRkZWQNCj4gbXV0ZXhfaW5pdCgpLg0KPiA+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvaW9tbXUvaW9tbXVmZC9kZXZpY2UuYyB8IDEgKw0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lv
bW11L2lvbW11ZmQvZGV2aWNlLmMNCj4gYi9kcml2ZXJzL2lvbW11L2lvbW11ZmQvZGV2aWNlLmMN
Cj4gPiBpbmRleCBmMDUyMmQ4MDkxOWQuLjBlYWFlNjBmMzUzNyAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL2lvbW11L2lvbW11ZmQvZGV2aWNlLmMNCj4gPiArKysgYi9kcml2ZXJzL2lvbW11L2lv
bW11ZmQvZGV2aWNlLmMNCj4gPiBAQCAtNDc0LDYgKzQ3NCw3IEBAIGlvbW11ZmRfYWNjZXNzX2Ny
ZWF0ZShzdHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgsDQo+ID4gICAgICAgICBpb21tdWZkX2N0eF9n
ZXQoaWN0eCk7DQo+ID4gICAgICAgICBpb21tdWZkX29iamVjdF9maW5hbGl6ZShpY3R4LCAmYWNj
ZXNzLT5vYmopOw0KPiA+ICAgICAgICAgKmlkID0gYWNjZXNzLT5vYmouaWQ7DQo+ID4gKyAgICAg
ICBtdXRleF9pbml0KCZhY2Nlc3MtPmlvYXNfbG9jayk7DQo+ID4gICAgICAgICByZXR1cm4gYWNj
ZXNzOw0KPiA+ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0xfTlNfR1BMKGlvbW11ZmRfYWNjZXNzX2Ny
ZWF0ZSwgSU9NTVVGRCk7DQo+ID4gLS0NCj4gPiAyLjQwLjAuMzQ4LmdmOTM4YjA5MzY2LWdvb2cN
Cj4gDQo+IFllcy4uLiBJIHRoaW5rIEkgbG9zdCB0aGF0IHdoZW4gc3BsaXR0aW5nIHRoZSBjaGFu
Z2VzLg0KPiANCj4gWWksIGNhbiB5b3UgaGVscCBhZGQgdGhpcyBpbiB0aGUgbmV4dCB2ZXJzaW9u
Pw0KDQpTdXJlLiDwn5iKDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
