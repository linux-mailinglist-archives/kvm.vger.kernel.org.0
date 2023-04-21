Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D772D6EA449
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDUHHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDUHHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:07:22 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997501FE7;
        Fri, 21 Apr 2023 00:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682060841; x=1713596841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8M74LpyCZwdYk+cdQj4VekYieJuIs4qXGYYfryjAXN0=;
  b=mhoy+7+68mmr5AZnfly6WB7071mKID6vO5zxanIecAnMysFRc/o68QLJ
   aaGSYS7t+bVxz7HoFZdeb+oPBDqOPVTyHPRK+xEzUboqnniGnYuaGOw3h
   kgBl1nbmp1q07Ecvg5b8Hp9Q8zZAthxbE37iLlOcKigNeGQgFV1Sdc9N/
   AY6bsrkhKM+n/J2rFNJLL2lHS3QaZfA05JwsL3kmWVLZedBtSfAzwd1VX
   3H4ck91UnQt+7DnYOHmBeGj4sdbp3nLccWCi7Ywr7IKRmWB9cnbyXQXW+
   aLzy79gZ/dCYBerhaz02/L6F2qfpFVVdlAerz7vAyOstpf08lwGBjQnAf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326258878"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326258878"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:07:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="722667631"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722667631"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 21 Apr 2023 00:06:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:06:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 00:06:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 00:06:53 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 00:06:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heBooL+F1DXk5e141XURlSdOF/8kUOX4oONYRBPdtdMAhN1CxIZ8osCswZl4M5q9XaOoS6RR93ExvGMltM7AxmmsBBN/jRSuFRXp6q4rddendxW0spa9zQ9Zv/mHiINS5SR1JOpcnBz7Kk9p6tCWs94SpdfNisRgtMBP79sKLGr0QOJMPiw5BJ01RDRfdMsCjIo9j7yqEsHCeMXqew8BuLGc5tdaUnWrjyA1pKb/hWVVRscumvNC3gvHPVF49+MsgtWiW6CTxoeUP602EEK1jnlYCo8AcU14p0beKKh22bZ3SHxg3JXaG7jOqRIVSMVnlbIXG6BcQPeGdqjwkH1i9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8M74LpyCZwdYk+cdQj4VekYieJuIs4qXGYYfryjAXN0=;
 b=A5IBKkIzycKZN+cCCSnEUNiZOAYr8aQca8sc+vH5bhWI0eNblrnn53qigFazyxGsHdDun7L8HVQx0uYVT0YJLq8jnJj2+9l+vo53WI7o86yk5Ba05U0GLm5sk9rbBdmMOgN4uaQR0P9UFogV2ctic1tY9/Axk04ts+xBLX/NVW/YxAvUc/1YKw3IK8M7DmBjJ+FAWpfRqAaqgm0HB7Nj2oUCwEzEbqD3yXh8NB3yXL3lQfEYUHM97UDtPXRYEc5ViACEOuS947TH01LdBWWL9oBeMfNpX+gs0MbKBwTifz8MgdNDR63SVEUEOJrfQCfQJtgrUzi6WFb8LjlhvEtLkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7897.namprd11.prod.outlook.com (2603:10b6:930:7d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 07:06:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 07:06:51 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3 10/12] vfio: Mark cdev usage in vfio_device
Thread-Topic: [PATCH v3 10/12] vfio: Mark cdev usage in vfio_device
Thread-Index: AQHZZKiANPOEA39TS0ydq4s977mVdK8cn6kAgBjVqcA=
Date:   Fri, 21 Apr 2023 07:06:50 +0000
Message-ID: <DS0PR11MB752914607E1DC9CFBFC2EF7AC3609@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-11-yi.l.liu@intel.com>
 <42a1dd97-a95e-d5a6-ad6e-d87373111bd2@redhat.com>
In-Reply-To: <42a1dd97-a95e-d5a6-ad6e-d87373111bd2@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB7897:EE_
x-ms-office365-filtering-correlation-id: ab0de612-81dc-4ed6-c402-08db4236fb0b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /rwCShvF9/jAd3PgXHF2nkAdRPo3uG2MXVaJO/2k5Cwn6aOUyFdqT72NqASaueKkIXD/12Lmo2Of8Bi5lD4MCsH+P207wwn3MkDgtHEtT3d0hqYgFG9iM8P9al7O8Z+h6ZZ21ZDVegQiX2E5F0Qg9wAUe4ss6oPvH91yKmrT+Kuo4BR90xq12+D8+7hLRl4Q6VqvadyeFq7RonlxNcxpqDKR2VW168l7NfFC5A2RNBBrWDKTUTLip5VeqpvdfKS7vkXIH3qLc+LuMW7t3g09K6WKNZCNa234U9PJPN3PR2XWwNlQG5woZqQhM/rOLLzkSz7oMPB/7BCzaVrjdb39N9Sr5nku9+ypx0zxPnLwgcbst28Dh710x05IjCj6HO5kbw+FZlBMKiG+9GAJNPFGWNeXV3+bUbKxslcwNDvLUrmdFwhLcBBIG8M+AOj4IQ/nFshsJrIe9mM9N+mENMWnRRG5LmE40yAd2+iswDeJzlbfFWflhHte2zdSFRMDovP4MYtbp5zwH+8O/WQCPZVQfQUCIU3WCtEBNL+MyeZoy7kY2oocIKoS17PyWX8RM9Hs99uznVtv7ZAYN1/5irlTR9ytp5gCIboAhBSmqmi02v64y00XdWHGsYwMVwj0CVgO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199021)(66476007)(38070700005)(38100700002)(122000001)(2906002)(8936002)(8676002)(7416002)(86362001)(52536014)(5660300002)(33656002)(41300700001)(7696005)(55016003)(71200400001)(9686003)(53546011)(26005)(6506007)(966005)(6636002)(54906003)(478600001)(83380400001)(186003)(316002)(82960400001)(66946007)(110136005)(76116006)(66556008)(4326008)(66446008)(64756008)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHFqa0hTbFIxVWtUcXZZNWhndHphSWtJekxLbDQvYk53TFNMNWF4dEM1ZlRn?=
 =?utf-8?B?a0FKcngrM0tobXA3UWVQajNYWFpmY0tVTlBHS3MxbWVNUDVwd2o3MUk2dXEw?=
 =?utf-8?B?YWdwV1o4UmI0azZUVUszNmRhbXZkWmhBelJYQ2tIQWw4VjhnMjlLeFY2Y3lk?=
 =?utf-8?B?TkJzeUk1aFlZdkRoRGZ1RUJGeWdKMm0rZmZ5Y2RjaXRnSmRLTDdEYnFYL0Y2?=
 =?utf-8?B?aHJ5Z24xWWtVN1hYaDdDZSs5K2RnZFc1SytxbFBUOWd6b0FsSEI2c0EzSlNH?=
 =?utf-8?B?M3VkeW1IdlNYL2RaZnN5VE5JWmJSTTZ0Y2VsOTNBQlJrU29TRjFFd2lkd0dm?=
 =?utf-8?B?MTVmdW85cDlKNTB1YXdsdFVmUEM4UjU4TFlLZkhYNzF5T0NxbEpIM1J2Qldo?=
 =?utf-8?B?aWEybWF3N3VBTlNHOHh5aW43RUhweUMxdm5Bak0yd1Zac3ExVDR0U3BPNFBL?=
 =?utf-8?B?cVR3bXoycEZ4OUltWkFzMkNpbHg4UzNFQW91ZEc3NjVEY2s0clVSTXlWWUxI?=
 =?utf-8?B?Qllzc0lzMU96dStFalVQdzhNSFFGc01RcGRrblJKakxrZHU3WG5rcE9oZ3E2?=
 =?utf-8?B?ZXRzMW9ScWhHVGZoUExWR0JFbkdjUXJKWWx3bmc1OFNtUkdYL0RUQnh3Z0J2?=
 =?utf-8?B?bFJpVkM4TmpNcjZPZDhqUDdnbGZwaCtrRHJVMjJidFhETnZlL1lEK2ZabVU1?=
 =?utf-8?B?aFFGVS9tWTdSSW43bDJNVWtJa0I3RTEzYmlJNnY4ZzM0d0duZ2UvZDFMaGkv?=
 =?utf-8?B?MDIwRHgvbFVJMU5zblZnL2xmdys3SWRaRmZjN3BoUU1ON0JPaUgveGRjem43?=
 =?utf-8?B?L3dvTVBiNnhONThpTXhYMjBhcEw2eUMyQlkxNlFZVnFaQzlPaGFYdkRxYUN6?=
 =?utf-8?B?bk1nNXZhdldSejRLVmI4SkVsRi9WT04rTHczZGFGUTRsTFM0enZJS3JvNGZI?=
 =?utf-8?B?QzJZZGxEM2ZZY1MyNXp6cnk2MFEyUklGMDdQcXg3Qm9iV2Z4SmF0ck5ud1R6?=
 =?utf-8?B?ejh6YUNqV0xhWGVDWjdqT2pUVWFDQWQ3THBpM05ROXk3cFVHWkM4M1JqQmFI?=
 =?utf-8?B?VHd3SnZ3MWs2SDMwZkJFcVorQkdpQm1CVEFUcmZ0RWw1TDgxd3BlZXJLTEQ4?=
 =?utf-8?B?aGR2bFhvUjh3VkdPbmRKWGZ5Ti80aUZpQTBVRXQxRlBleEswZ1NXWmlxZks1?=
 =?utf-8?B?dis4eTlNQmMvOTVjOEV2c083dUx6U3doQ2VvZHE5OFJUSDlSSFJaOUlsd2NB?=
 =?utf-8?B?YTZhbzVlWmdPUkJudVNVeTJqU3VzWTI1MmZYcTFiYWN0aTNDL2REemxwYXM5?=
 =?utf-8?B?djNYdFM1bE9IdGd2ZHg4dUdyQXdoVlR5TEZSUlloMDFCMkhjVjBPWWhoeFRH?=
 =?utf-8?B?MDRyK1B3OWxTTzZtb1JBRG91VDFtUG1LOFFYeEJnVmxFS2tiTFlJd0JCRk1U?=
 =?utf-8?B?SU1veXBacDlDRDBYWmluK2VIUkpSUkFiRzc1MS9oRHdBQ1hoelRQcStLcG96?=
 =?utf-8?B?M0FubllEM21KcHB6T3cyTlc0eG9lV2U1WEx0eWRacnc3a3dqc3h5SjZKdGw0?=
 =?utf-8?B?amNzWU9mNnRMVWo3NGQ1WWM4VUZQR2ZoZDRsZ1FjNm9KYnB3V3QrUHdpOXFy?=
 =?utf-8?B?UUxFbGYxRTE1WHBmL0dIUFkrQ2JGR2NCMWw0K3FhamxGZm5YdU5zazlmNXZu?=
 =?utf-8?B?K3IxbjlBcUN3dVNMdW92R1R2NWkxRmgvbkdtNWVYYzVSVys0UGdETWl0UnNp?=
 =?utf-8?B?M3RSSUpGZnZoK1I0MjVPRjJuTmN5aCttUUg0UkF6dEZQUlVPVlh6S0xuWjhy?=
 =?utf-8?B?Q2M0Vlgxd052cXNwanBRSHA2ZDJncTdtRDdHbmhRZHRxOURMNjFWcE9LaFFO?=
 =?utf-8?B?emdzTmJOYkFmSDh3Y3lIekRpTHk3dVVCY1ByWUZHZWkwMUZtMUpSTWZqQVVE?=
 =?utf-8?B?aTFVL2FuL1RpNUhiczVpSXNNbUV0MUZ4S1dKbzh4L1JtR1FmTGw3RVZPMThB?=
 =?utf-8?B?bEVZSFRRYkljcjcyMk5YR001Tk5XK0tIaHFwK01LWUNkNitpd2liRm9RRy9s?=
 =?utf-8?B?OGtlZUdFU1ljVHo5MitrYi9LS0Z2QllJMnFPalQyY2Vjd3BSU3RTaWNKSnhW?=
 =?utf-8?Q?pa+M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0de612-81dc-4ed6-c402-08db4236fb0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 07:06:51.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 29DhBeOVSknPPSWf1qWkdaIlA6GitysDhyQEX8w6zrTwvUkoHvgvjNNOi2MBe7xakbVoqS2M+BwwUGnVCHMbxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7897
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgNSwgMjAyMyA3OjQ4IFBNDQo+IA0KPiBPbiA0LzEvMjMgMTY6NDQsIFlpIExp
dSB3cm90ZToNCj4gPiBUaGVyZSBhcmUgdXNlcnMgdGhhdCBuZWVkIHRvIGNoZWNrIGlmIHZmaW9f
ZGV2aWNlIGlzIG9wZW5lZCBhcyBjZGV2Lg0KPiA+IGUuZy4gdmZpby1wY2kuIFRoaXMgYWRkcyBh
IGZsYWcgaW4gdmZpb19kZXZpY2UsIGl0IHdpbGwgYmUgc2V0IGluIHRoZQ0KPiA+IGNkZXYgcGF0
aCB3aGVuIGRldmljZSBpcyBvcGVuZWQuIFRoaXMgaXMgbm90IHVzZWQgYXQgdGhpcyBtb21lbnQs
IGJ1dA0KPiA+IGEgcHJlcGFyYXRpb24gZm9yIHZmaW8gZGV2aWNlIGNkZXYgc3VwcG9ydC4NCj4g
DQo+IGJldHRlciB0byBzcXVhc2ggdGhpcyBwYXRjaCB3aXRoIHRoZSBwYXRjaCBzZXR0aW5nIGNk
ZXZfb3BlbmVkIHRoZW4/DQoNCkJ1dCB0aGF0IHdvdWxkIGJlIGluIHRoZSBjZGV2IHNlcmllcy4g
TWF5YmUgb25seSBhZGQgdGhpcyBoZWxwZXIgdG8NCnJldHVybiBmYWxzZSBhbmQgYWRkIHRoZSBj
ZGV2X29wZW5lZCBpbiBiZWxvdyBwYXRjaC4gV2lsbCB0aGlzIGJlDQpiZXR0ZXI/DQoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDIzMDQwMTE1MTgzMy4xMjQ3NDktMjMteWkubC5saXVA
aW50ZWwuY29tLw0KDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbGlu
dXgvdmZpby5oIHwgNyArKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMo
KykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3ZmaW8uaCBiL2luY2x1ZGUv
bGludXgvdmZpby5oDQo+ID4gaW5kZXggZjhmYjlhYjI1MTg4Li5kOWEwNzcwZTVmYzEgMTAwNjQ0
DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC92ZmlvLmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4
L3ZmaW8uaA0KPiA+IEBAIC02Miw2ICs2Miw3IEBAIHN0cnVjdCB2ZmlvX2RldmljZSB7DQo+ID4g
IAlzdHJ1Y3QgaW9tbXVmZF9kZXZpY2UgKmlvbW11ZmRfZGV2aWNlOw0KPiA+ICAJYm9vbCBpb21t
dWZkX2F0dGFjaGVkOw0KPiA+ICAjZW5kaWYNCj4gPiArCWJvb2wgY2Rldl9vcGVuZWQ7DQo+ID4g
IH07DQo+ID4NCj4gPiAgLyoqDQo+ID4gQEAgLTE1MSw2ICsxNTIsMTIgQEAgdmZpb19pb21tdWZk
X3BoeXNpY2FsX2RldmlkKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwNCj4gdTMyICppZCkNCj4g
PiAgCSgoaW50ICgqKShzdHJ1Y3QgdmZpb19kZXZpY2UgKnZkZXYsIHUzMiAqcHRfaWQpKSBOVUxM
KQ0KPiA+ICAjZW5kaWYNCj4gPg0KPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wgdmZpb19kZXZpY2Vf
Y2Rldl9vcGVuZWQoc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpDQo+ID4gK3sNCj4gPiArCWxv
Y2tkZXBfYXNzZXJ0X2hlbGQoJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4gKwlyZXR1cm4g
ZGV2aWNlLT5jZGV2X29wZW5lZDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAqIEBt
aWdyYXRpb25fc2V0X3N0YXRlOiBPcHRpb25hbCBjYWxsYmFjayB0byBjaGFuZ2UgdGhlIG1pZ3Jh
dGlvbiBzdGF0ZSBmb3INCj4gPiAgICogICAgICAgICBkZXZpY2VzIHRoYXQgc3VwcG9ydCBtaWdy
YXRpb24uIEl0J3MgbWFuZGF0b3J5IGZvcg0KDQo=
