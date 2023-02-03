Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BFC68917A
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjBCIBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbjBCIAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:00:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1551B326
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 23:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675411198; x=1706947198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVljHCO+pUSvuiB/eCeVtHsFRejOhmaiJNivjqOsOFA=;
  b=LBW50bzGzakNkcZ7xsgtvAJSY5VlKDnjqvwe0n00TC2/+PRbMqfAYw0U
   mEwocZC2XJDLpCKFQCP/vMApmUJ6u78V4PtM3L2Ld4hVMnkgCc2dpLQLR
   buJztgV6qESTqEO5KwTDS3zMf+Q7CWLTRVJRiFaUqIfEx4jjZveBCrV46
   uAui2oH0ZNp1DjYYV5gxkxqbO69BENfNVg2lsI0rF+d4TBV/kNVTyvV2k
   DteuE4uMt6KBdABl/qaro1W1KEdQEhHBEC4J9qgguSh86dmc1Eh8T2GwA
   +GQfMNwNePVYWhytIRIcb/9clHXgiaSfkAz//MCE97xRWegbpWFD4ruYG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="328703162"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="328703162"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 23:59:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="643177664"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="643177664"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 02 Feb 2023 23:59:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 23:59:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 23:59:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 23:59:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 23:59:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnRQVicSVXaNM8Rd8WukvoXVcJY+qf5WZq6BjRdHboLEL2eaRHY9Kpj+/0kIQCVLx3IqWkRG4wgE0Hb39wfixFStOc4/EuQftMLpoNcRwHwrCbEsalrI/5Cjx2SXHHoGVQT3YgXIqz6bhKffJoy1rOzbjbVyeNNfzlbil6zAKkBnTAG/f57QTMM2JyNZlNrFDqN6Ss0rU13XY+fzSYlHKIYx7nme/+4O6La8KU70mx8NAA6N23moL8UpPhUrJn8mjBxsxOPOCx/nxMgChMx4rYaqJpQTGo+9Kbs91sMxBAzjH+5SzspJDHZKU730lBa+yU5uCPF5STRzYdZmxOip6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVljHCO+pUSvuiB/eCeVtHsFRejOhmaiJNivjqOsOFA=;
 b=as/QvaWvPbCae85MyfX8WBb1pyq2vncqi7JoEGXogFhpzD/+Rx793l4E+yH1rW3ZmWQuOb1t1fsCjpQEZm4Cxm84ygmw6yvzKRnG2tU8mwRNXurGpmi0mAAivM+XfRaEmiiDQiVRveZB5QGxKV94wtUJ1ynHYXfaaiQSnIxW4Ib3CiEEYJOk5KvHyPCJlakbbEw86JJKHjqZDpzXrQLzcuWoaVDhGWaD9lWsguQflsm4+qrUmSyv122rTRuvduziQte+RcV0RSNAIulJvRGiLTkd4EYMLWeu8jkN9zVOuqQgcj8YAcgAKk/uSx6sEYB4CRTmCnrmhWB/2Eo4F4z4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 07:59:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 07:59:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZNtymfc/0mKQcj0e603kVKITxmK68nHIAgABAjcA=
Date:   Fri, 3 Feb 2023 07:59:49 +0000
Message-ID: <DS0PR11MB7529960B42D0DFCCB712C1B2C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
 <20230202080201.338571-3-yi.l.liu@intel.com>
 <BN9PR11MB52767455B0FAA0CCEABB05238CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52767455B0FAA0CCEABB05238CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB8018:EE_
x-ms-office365-filtering-correlation-id: 88dc85af-c763-443f-6d5b-08db05bc9f88
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4G5M26vIs6e8gnp5dyuJXuN6LqyZzX7l6SQ39horV0IxrgeOP+bhlqX/47ydIgywKVcCPeDwdZY7pjdNUDC8Pumiap91jtj9z/Y9LUuF/S9ko9injacPXaAKl7zNCqF2JNr62czvMcyXhkEfL7eVrz+fJSewHEN2ZhatZXUMtzBlTfuqsrh9CoPdSRUC2Mvgp7CV3a2Bfhqri8/hrCQmQwXRlssDk+X8oWcIZ+p4Jp2/IfmQyGJCdmYrQ28NenVRP3UKlFH5IZMh+3HFco+RFFjsjRHHANjGLoxmfzl/23qsORNdD6pV9FCiRE2GS7uLIBHv9XHpaUifQ4pD7TcKWlKbccOHbl503VOCW7Yf1eHNfeJyLeBgrd9geKF+nMHaQto6zfaqYEo4bQcrIIDyPDgGYDmdXLpDjZmiCL90NopAlU/DcTXqS+/L4wamLIfZtr1PRmqTrUGs4bEYmMjur78yfQnpSsaX5bYDy2cu2Se3RjNACYcGnwXmUu1fCZ+DulFAu93ku3OAAJCElaR9apn2tNqMjDdjmMh+wBqMCZad8RZupoAzZ1BF5ZCLR29WT5N051WMtMAXsxGjhnvvGp7HVAHYerYjUFcAtxVmjRVAYfWYeE5JG11h9Sv0nj1OmZOI6sVjL6lydVGj5E3oFQ/uKLK3z5O11lOgAdYN1fH37Lo5KHIexbZssggIxK0S3te9Tq8oYzEaNOco8zZ0bko9BPr12rfRZdqG2ssP+/s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199018)(2906002)(66946007)(76116006)(4326008)(52536014)(478600001)(7696005)(38100700002)(33656002)(5660300002)(66446008)(6506007)(9686003)(26005)(186003)(55016003)(71200400001)(83380400001)(86362001)(8936002)(41300700001)(66556008)(64756008)(38070700005)(8676002)(66476007)(82960400001)(122000001)(316002)(110136005)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTBHSFVMb0xJWDREYUtvUFNkd3VXbCtnOGZ1Nit5TkpsbkoyczN2Mnh4emJU?=
 =?utf-8?B?cG40OFZtV3pRNzVwVGxqeHZDVGZzWW45dDRZWTVMOWc5RHhYcy9RdGkycG5S?=
 =?utf-8?B?aDRBZTIwR0ptM0tZQ2Q5Zzd3ZjNYbExabGRyNlNHdzlNUXJyYVAweDNTeFFF?=
 =?utf-8?B?dzhVczZCSUQwblAvTndCU2tBWitIMVJJL3krb3FRQWZzR2RLd0llUXhEc2l5?=
 =?utf-8?B?RW90Q29DZ3N3K3lBcFdkdjA2UHpUTXBJczB0UmZvUFZ4dFBnWU9OV1YxK0Vh?=
 =?utf-8?B?VTJ0M256ZG96WFppYXpmalErK2Ztd1c4WnB6bExjQktOU2NydW5vSmpFM3dY?=
 =?utf-8?B?YlVCMkRhMFBxRW44QUpPU3JmSFRSd2hWS3RIYXBWNENHbTNKaGQyNmVZK3Jr?=
 =?utf-8?B?RTNxb2pWMG1NeFQxajIrdGhMQ1VhcUJ4bW9qL2dUWk9nUGlhaEVBbGo5ZUVK?=
 =?utf-8?B?VlRvblNGaVF3THlOUkZFNkc3SmJOUU0vOXQvWmticlJaZFJXVStUTzdkeHRm?=
 =?utf-8?B?dEQ1dmNiOGl4dlVuT1djVzJjVkdkTWNKZTdGOEFYc3QzckhGbW8vSHAydERC?=
 =?utf-8?B?YjhuTHNwR2pvZCtSNlo4UzZRQktBQW84cFlaNk14K3ZBQUdWM0JDQXE2TlNU?=
 =?utf-8?B?ZmRWM1dIcXU2S3hoZGxTRWJBQlZEYXJTd3hqUHU0N21FZHRxRk9NTEVpNFpF?=
 =?utf-8?B?YkEyWFVVL21LM3lBVE92V0ljeW5aOXBUelN6KzRtN2p4bzFFWUNnWUNqRlJQ?=
 =?utf-8?B?SysxSzlNVkQyM0V1OHlUUnpGMFlZY3ZxK1pYSTRvU0plTFI4UlVqdnkrTUNS?=
 =?utf-8?B?aGc0UlRXSnlJNFY4RzY0Z1FzWi9WNHhybEVaQ2U0OVp0L2dVeUZreE9MMHpt?=
 =?utf-8?B?RTdvK2VOQ1dRdmRJVlJKcE80Q3pTMkhKWklmNm0yS01JcWVQcjhOak44dEJD?=
 =?utf-8?B?Y3dLUnpJbTQwZFJMeit0WTdGRjR4azRXelRQZm54cytaNHB4THJxT08zdmdP?=
 =?utf-8?B?dWNiQTlvWEVpRW1MOGtSWkxIYTExMFh0ZVVrcFN1R01vd1BpVUd5Z0ttM1U1?=
 =?utf-8?B?RTV1dFpUbDE4UGI3NlhwUklSRE9Hd3UvWERJb2tBV1kwU0owU0NKY1BDYmZT?=
 =?utf-8?B?UTJIejZlU2pRSTJoVGlhcXZMVXBCZG8yK2c0aXBWSzFDNHBHcGNTTzZvVWpp?=
 =?utf-8?B?U08ySEcwaHJ1ajVWOGtOOEEyQzg2Qng1UmQyNm9TbG12OExPcFdzS2RwU1Zn?=
 =?utf-8?B?eStoaTNWWlhiTUZrMFBveUM2L1VkRmNOb293engxZXgvd0xYM1BMdDBCNnh1?=
 =?utf-8?B?bldhZURtc2ZkaVNSdUdsWWxoR3dOdGNwbkp6ZTh4N1VWOEpyYlhhWHgvWk5R?=
 =?utf-8?B?bDZmTzZwYVp5eWtGWnNES0xzaG10S3F2Z0U5UHgwRUh4TWRYT3lrdUNFUWlN?=
 =?utf-8?B?SUticVpVRlExYXJ3YzFjN0dtYzh5dUVNTFFsSTlrTzIwTVZVQkQ2Zk1RbnUw?=
 =?utf-8?B?enQrV1dHRU00ekFrY244SkoyTDVRT203aTE4Tml3VUZ0dUdqdnlSNThDYTdB?=
 =?utf-8?B?VnJjSDdlcWlPV09qMEdNWktmekcwekdreml4TGRDZld4U0FyeFcrNlV4c3pG?=
 =?utf-8?B?TlhXdDQzZTNDMXFIYXIvUk9YSklMbDQrU3JFWUtZRHFySUxtWWxGcWpabWJv?=
 =?utf-8?B?cjc2V2VPS29YUy9SUUZOSy82TmlJWGpBT2RPMWRyUVZDemRUMmU2UVN5S0xO?=
 =?utf-8?B?Ynh4aGdqemVvVHFVQ0FQZ1B0bzRhc0srQnNFWFJvUEZGV2UrWVpCSy8rSkdm?=
 =?utf-8?B?S2JlSjFMTmF5ZXUxcFFtbkcrL3IwT2p1U2dhWS9xcGlzRVYzOVBlTUFhTTdB?=
 =?utf-8?B?SEl6UG0xYjVCcndXeXRhVXdPaHYva2tIRGZYazVHRk9JR0xEUHhwRWxOUCts?=
 =?utf-8?B?K3g2VE1JZGN0Z1IwTnhCYndQU1M2UDNPUUJyOFFBTlBMTzlhTUVMbUl5WHl4?=
 =?utf-8?B?b2JxYnJ4T3p6MFB4c0RjTFh0ZHRxaVBDbi9LVUZidnB0K3FKWUtBclBRNEtt?=
 =?utf-8?B?MW05ZzBhcW9ZSVR3VldHVHlvTFQzUlFhQzVFc2R6UndxUE5ta3oyejhzKzdT?=
 =?utf-8?Q?2yqpxCZT/jJ8jfZCgBNSSkdMH?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88dc85af-c763-443f-6d5b-08db05bc9f88
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 07:59:49.1409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdggDFifpR+4T5dDx4y1lgwVckUm+Hxu+omludSuAiMDbzyU9O1WosH8m+SjfIW/SP4wgpw3qKXTtiblmpqkOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8018
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRh
eSwgRmVicnVhcnkgMywgMjAyMyAxMjowOCBQTQ0KPiANCj4gPiBGcm9tOiBMaXUsIFlpIEwgPHlp
LmwubGl1QGludGVsLmNvbT4NCj4gPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMiwgMjAyMyA0
OjAyIFBNDQo+ID4NCj4gPg0KPiA+ICBWRklPIGJ1cyBkcml2ZXJzLCBzdWNoIGFzIHZmaW8tcGNp
IG1ha2UgdXNlIG9mIG9ubHkgYSBmZXcgaW50ZXJmYWNlcw0KPiA+ICBpbnRvIFZGSU8gY29yZS4g
IFdoZW4gZGV2aWNlcyBhcmUgYm91bmQgYW5kIHVuYm91bmQgdG8gdGhlIGRyaXZlciwNCj4gPiAt
dGhlIGRyaXZlciBzaG91bGQgY2FsbCB2ZmlvX3JlZ2lzdGVyX2dyb3VwX2RldigpIGFuZA0KPiA+
IC12ZmlvX3VucmVnaXN0ZXJfZ3JvdXBfZGV2KCkgcmVzcGVjdGl2ZWx5OjoNCj4gPiArdGhlIGRy
aXZlciBzaG91bGQgY2FsbCB2ZmlvX3JlZ2lzdGVyX2dyb3VwX2RldigpIG9yDQo+ID4gK3ZmaW9f
cmVnaXN0ZXJfZW11bGF0ZWRfaW9tbXVfZGV2KCkgYW5kIHZmaW9fdW5yZWdpc3Rlcl9ncm91cF9k
ZXYoKQ0KPiA+ICtyZXNwZWN0aXZlbHk6Og0KPiANCj4gTm8gbmVlZCB0byBkdXBsaWNhdGUgZXZl
cnkgZnVuY3Rpb24gbmFtZSB3aXRoIHRoZSBiZWxvdyBsaXN0LiBQcm9iYWJseQ0KPiBqdXN0IHNh
eSB0aGF0ICJGb2xsb3dpbmcgaW50ZXJmYWNlcyBhcmUgY2FsbGVkIHdoZW4gZGV2aWNlcyBhcmUg
Ym91bmQNCj4gdG8gYW5kIHVuYm91bmQgZnJvbSB0aGUgZHJpdmVyOiINCg0KR290IGl0Lg0KDQo+
IA0KPiA+ICtpbiB0aGUgdmZpb19yZWdpc3Rlcl9ncm91cF9kZXYoKSBvcg0KPiB2ZmlvX3JlZ2lz
dGVyX2VtdWxhdGVkX2lvbW11X2RldigpDQo+ID4gK2NhbGwgYWJvdmUuICBUaGlzIGFsbG93cyB0
aGUgYnVzIGRyaXZlciB0byBvYnRhaW4gaXRzIHByaXZhdGUgZGF0YSB1c2luZw0KPiA+ICtjb250
YWluZXJfb2YoKS4NCj4gPiArLSBUaGUgaW5pdC9yZWxlYXNlIGNhbGxiYWNrcyBhcmUgaXNzdWVk
IGluIHRoZSBkcml2ZXJzJ3Mgc3RydWN0dXJlIGFsbG9jYXRpb24NCj4gPiArICBhbmQgcHV0Lg0K
PiANCj4gImlzc3VlZCB3aGVuIHZmaW9fZGV2aWNlIGlzIGluaXRpYWxpemVkIGFuZCByZWxlYXNl
ZCINCg0KR290IGl0Lg0KDQo+ID4gKy0gVGhlIG9wZW4vY2xvc2VfZGV2aWNlIGNhbGxiYWNrcyBh
cmUgaXNzdWVkIHdoZW4gYSBuZXcgZmlsZSBkZXNjcmlwdG9yDQo+IGlzDQo+ID4gKyAgY3JlYXRl
ZCBmb3IgYSBkZXZpY2UgKHZpYSBWRklPX0dST1VQX0dFVF9ERVZJQ0VfRkQpLg0KPiA+ICstIFRo
ZSBpb2N0bCBpbnRlcmZhY2UgcHJvdmlkZXMgYSBkaXJlY3QgcGFzcyB0aHJvdWdoIGZvciBWRklP
X0RFVklDRV8qDQo+IGlvY3Rscy4NCj4gPiArLSBUaGUgW3VuXWJpbmRfaW9tbXVmZCBjYWxsYmFj
a3MgYXJlIGlzc3VlZCB3aGVuIHRoZSBkZXZpY2UgaXMgYm91bmQgdG8NCj4gPiBpb21tdWZkLg0K
PiA+ICsgICd1bmJvdW5kJyBpcyBpbXBsaWVkIGlmIGlvbW11ZmQgaXMgYmVpbmcgdXNlZC4NCj4g
DQo+IEkgZGlkbid0IGdldCB3aGF0IHRoZSBsYXN0IHNlbnRlbmNlIHRyaWVzIHRvIHNheQ0KDQpP
b3BzLCBpdCBpcyBhIHJlYmFzZSBlcnJvci4g4pi5IHJlbW92ZWQuDQoNClJlZ2FyZHMsDQpZaSBM
aXUNCg==
