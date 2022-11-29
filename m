Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8BC63B7A7
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 03:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiK2CEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 21:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiK2CEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 21:04:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ACD4732D
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 18:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669687445; x=1701223445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3ciObR7+OWEaCFK9bNajmK686LHVhRtmHuJRHUMSTnk=;
  b=nBuJP97Dlf7y9BXCoa9mq8u9XTBWdPF9kz2KK2KoTJLOlusBEbUxJK8m
   aTUgdFusPREqnKZafwgAtrEvFQ/nBEvqyA/MwfrQaqmKtAuSzJ6A0dPrw
   INQMGuA6qNg4jyVnL3ikgoD43usjGg2NFNAex12XlOe/Ps2iA984UlUwi
   kjnqKjm+u3tdR5Br4TDSBhzP6c8+w+g4LlNvBP6QfoAEdS1xaz3RFTTYC
   evQnpqAuFjTsRCjYmbeY7RcEdeMJOc4tiX1XRsgW2JfRi7Hix2/2HhQUG
   Dx2pbisX+yXex8YjT0p+EzVpd99BbSEHl6662suzxiWo2ZypvL6WV16XL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="401286080"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="401286080"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 18:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="621274699"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="621274699"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 28 Nov 2022 18:04:04 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 18:04:03 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 18:04:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 18:04:03 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 18:04:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFancA17uEJFGalE8vplYjcEVUSDkiNvUXJpCpy7r9oQ3J/Z3MtHU9IVKNKYGaJ6UpVEEzDfm8IMgVhgiFXNghrcroHut6JDTl/+RE5iRoDMJjekUU2FYJG4cL5MHwZEYh6QB5Drp4SLeUUhOMrBoBlSN6UwAYgYCvXsNmiPiFBo2tJFFr7TKuNFXPQ/tkYbLV9LPQ952o6v7E0wzlhKTQXRFs9FVjcuxITLMC/IYS0yYjX18YM0Qr+HxEmLSVl5i764WZA/DnUa1BISwLvApawfwTzzBCkiJ9gbgrMcznYSPRcM4E9a3Lv27Tw5sd/vsyIBSY+UaL0812+gI2vWbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ciObR7+OWEaCFK9bNajmK686LHVhRtmHuJRHUMSTnk=;
 b=URKVMvLQKIDWfXMaLKcwaHbOv0y2vCTcLQ8QRBHndnfjGV4ypWqoHIVXvKVkRJCJqkNYWmwS8TnbARnJO7Cewm47xMciMpaCi7lnI9ZjHpFLmwn7ho4F89cKiu2B2Fb+NYlq+82myphXENYJWnxZnrnShwHsZ8ZLbaJGCjdhl0mvH7Ny8mlYudQ28Vku0c13adT9MspMw9/zaWd0K+YuDCxz4PN1hnDCJixvcIRvr4nvgLmj48gSlD7r9fBCBBaFCmDmaxM1wVPWabiO76oKQqo1lmVbSxIH8oszph79vJD47tc7/iVfyJf50FAZkdIhhmMP70OqzvxryK/pIcZy5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DS0PR11MB7880.namprd11.prod.outlook.com (2603:10b6:8:f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 02:04:02 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::7a7f:9d68:b0ec:1d04]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::7a7f:9d68:b0ec:1d04%9]) with mapi id 15.20.5857.021; Tue, 29 Nov 2022
 02:04:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 03/11] vfio: Set device->group in helper function
Thread-Topic: [RFC v2 03/11] vfio: Set device->group in helper function
Thread-Index: AQHZAAAdAKOnfng01kKzW8cL4bGI265T/ilQgAAWOQCAARiPUA==
Date:   Tue, 29 Nov 2022 02:04:01 +0000
Message-ID: <BL1PR11MB5271B4790C8C90FDFF813DF08C129@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-4-yi.l.liu@intel.com>
 <BN9PR11MB52768F967E34C3BE70AA0FCD8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4e180f29-206d-8f7c-cc20-e3572d949811@intel.com>
In-Reply-To: <4e180f29-206d-8f7c-cc20-e3572d949811@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DS0PR11MB7880:EE_
x-ms-office365-filtering-correlation-id: be86d9f3-2bb9-49a6-9c97-08dad1adfc49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Rv6UO3AtP5EddaMf9uKG7uNavzHn06z5vs07CcDiLt+s9f/9QbBHqEdjJGhQewxWpewSBP5G4Kx68s4WI/gHFSReW3RHrBRSy6fwbWwkyA4JDmPEmJ5k6MrtDL34+Ors25lBmNkCWY9ulANuKeRcq87AWK3vRLkfemAfoGgxAR0E2WmVqsaJcinfye7JUKY9+c13SJ2/JKSrgvALNUl1lsbp4i1D4y6eavPn4yZmLgvYyU+AsDELHc35CmmWe9Sjk4VrHQmAGvJ0eDorxoGeCgjCpXoCT7Y4elRMoBuW5jHlDFw5R1YbNQpm2qsQGJ3Nn/n3VD/Q/50aqXqWOYs48ihy5hA0y2X4quy+wqBS3nQ+MkNey00Fo3EPkJyPn9alDWRNzsPbziKQXYkFUrs3eZ0NRQyP+QIzsUHUw6TzneM+MA2ZS//YCKd+mIYggbZ36LGMG87VZ4/hW5ncK9fedMOfOYnpl+B3GiHKKZe6s4ZmqWZvG24nEK+hEs91qPK6d9N1/d4zHsLp8ks25vdgHO8rgG1MGkDmW1YQHzLMmn9zCKQEayXgpS04jYsF/gJrTuM2HPmG6NreYgN66KLMqCB8QozyKMWVyAbRPlxzqujhjLHwwkdHFTcS1HYcLn/I3kcXfIrHybbPMW/qiZMZjLbb6/2QjQRmNhZmnO9eKTkDyTJcqzmEt+jVJ8FYTThF30JiHvD0GnASyZrK053bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(186003)(38070700005)(33656002)(2906002)(110136005)(6506007)(55016003)(9686003)(71200400001)(26005)(7696005)(478600001)(5660300002)(52536014)(4744005)(41300700001)(8936002)(316002)(54906003)(66556008)(86362001)(64756008)(8676002)(4326008)(66476007)(66446008)(76116006)(66946007)(122000001)(82960400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yy94d1c0WWlKOURWRTY5a2J0U1IyUElRaTVEN1NYYUxPM3A1UkFOS2x1S0E3?=
 =?utf-8?B?RnJRUFBCSmZaaElJNWExdWZuVXhCVTNpNXdVUmpkRXFQZHFRR2xnL05UcDk3?=
 =?utf-8?B?V2pDRkV3NEZhcVEwTlp1WlJnd0NPOUlvQkhBQXc2WFMzcnFxdjhvRmVaRlJJ?=
 =?utf-8?B?VWovV20vVDkrMWFFUEtsa1k0bXBGenlIV3plcU5VTVFsQTlvblR3MTBIaXBl?=
 =?utf-8?B?STBHdG0xQ2lTMTFSVTRCR0xoZjhJZ21GYSt0NEFyeWMvUzkyTlViaS9jNWZy?=
 =?utf-8?B?VVhTYzhyMStBL1hWWlFxTW40b2VSWjUvY2s2aDY4QkUzMXduaW9DVW9rdVpa?=
 =?utf-8?B?TjJ6dEU2VithVHNsUVRuTzJwNy9Gcm9YeklOVndFVUNEd3NIaGlIMjUyNmJq?=
 =?utf-8?B?cUI5VXFZeDJGRUlJKzNPUmMzNjVyb0Y4cUlqc1lNMEE1eWNlRjlVSXdGVnRt?=
 =?utf-8?B?VDM3TkxITTlvUmk4S3JiVDhQa1JqcXg1cTY0VlVwSkdDK3JqS01zanovRm9V?=
 =?utf-8?B?dEVEK1BncXIrTXJSMkFLVXVkYTY5c3htZFo0ZDJMWnY2SzU2aTBLb2IxaUJa?=
 =?utf-8?B?VVRVU3QxeDdzYTZudG5rb3Jxblcyb1BHc1JWcHhaWEMwa0ZXZWJ4d2VObi9T?=
 =?utf-8?B?Wm41bWRreVl5QmxsK2VNa01UY2dNOE5hQnNQNlVTdzlyZ0YxVkJRYmFzc2dy?=
 =?utf-8?B?Mms0NGE4QkwzTUFPTGZTUy9WMyszM05Xc29vVTFZZUl3MXo1OHptVEpxOFA1?=
 =?utf-8?B?a3ZaVC9mcU0vZHNqaXUwR1FRK1ovaHljcVFIbXBmcVNJZlY5MXVCUE53emVw?=
 =?utf-8?B?MlNRNzlrUjhleU9US1BNL0ZhWWdZTG5QQjc2RnN2aVh5b3d0N1ozYktMak13?=
 =?utf-8?B?aFlpc0x3LzBaaFRsK2grZTI2ekI4WWtXZ1U2WkxxY2JwbjBmNkVDN2tKeFps?=
 =?utf-8?B?SVpNdUFFQVV3SnhURDhZQm1jTUxicEhQdXNJVERBUGN3a1d0VXVzVGtwaFZE?=
 =?utf-8?B?dkIxa3FQajQ3akFRN2NYUk0zcE5mdVA2d0VwS29VbS93Y1ZQa2o5V3p0YkIv?=
 =?utf-8?B?Vmw3YnhNVlBqZmVEZmV2T2hTZm9zclJldnA1WmRuQUlkSU9YaTE5dWlRYXU4?=
 =?utf-8?B?R0kwRy9IVUowdk11cWRyS0hJa1VQUllGSldpeWtES1VKdHBoZzhlWjFNTFUv?=
 =?utf-8?B?aTF4VmE0dWZrK09iY3J0RUJvcWpNQ3NUNXRQTWNlTmJPOTd1MEtWTjlnRW5r?=
 =?utf-8?B?eUlmMmErZjNtUWI1UHhHYXVTRFpVNThOYW0yYXNnVnZ1aGNwRzNnbTVqR2tK?=
 =?utf-8?B?SVg0c0lDZ1VMYmRIM3h5VUNOb1ozS0xwSmNRczJCOFUrWTdQMEIrU2ord2J0?=
 =?utf-8?B?aHFvV2FscDQ5K1hFWkRXTEJBVHREMk9ndGFGcjJkYXV0SVdUeTgrditMZU5T?=
 =?utf-8?B?bTloQ0E5aldVTTdaZVpkQktabWZ5MmhkV2Y0c3VUZjVhKzZzZWZQMHdlUG9v?=
 =?utf-8?B?NHN1Y00zZ05XQUFkSVBmNE00ZjFIMTlyT2dMZzI2QWJvUUV2VnRDeTYrT2J6?=
 =?utf-8?B?MTIrU056Z2kyYTBCR2tQMThHT0h0cU8vV3VXM3EwMW5ucWY3ZlhWL0FlS2Fv?=
 =?utf-8?B?WGJlUEthNjNROTdNYkx3ZUFIbVRWSkRDbWxTK293WUZxMWgzcmtteVIxU2kv?=
 =?utf-8?B?aTdaNzJtRTRNK1VlTXhHK0Rya0N4M29BYzZxV3RnYlJBZzNveXFaWElvamRK?=
 =?utf-8?B?bG5aYzZhWkdLMDFXWkZiSVYwdnNxa3h5OGdNUnZjSlZyUUtyckVlcDVDMlRm?=
 =?utf-8?B?YUNrcmRGNnlHYURGVkhjZThVSXhYbzRBY3Z3dnRpaGd0aWtPS0k3Yy9CSGNK?=
 =?utf-8?B?UlBtaE5MMFY5ZXprMnBVdTY4bUY4czNTZGVpbnhFM1AyUzVNdEd1SnAwY0E2?=
 =?utf-8?B?RlVzdnAweUgzWko1YmlFLy9mVFJqdzhySmNrTXhvWm5MSlJhZE1JdGRmU1A2?=
 =?utf-8?B?aldEbitPQmhrTlVFRzlWcVdCbEg0MjB6eU52TFVSbDM2UGwrNzErNllETDY0?=
 =?utf-8?B?ZkVRVVlSTDNUQjhaZTQreGJtNDlQRHBkenpSN2FVdFVBVnpITW84V215SVUz?=
 =?utf-8?Q?Au5c8sptZxsF+GmnPv3Xneoso?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be86d9f3-2bb9-49a6-9c97-08dad1adfc49
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 02:04:01.8264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u05jWzHqjCnSaGLeLF82BBmaJpzEpfRpsBbJd/SJk+ZQyXUbLozEQiAdPIHVJClPeD+uldiIYoQK40Nf4C4/Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBO
b3ZlbWJlciAyOCwgMjAyMiA1OjE3IFBNDQo+IA0KPiANCj4gPj4gK3N0YXRpYyBpbnQgdmZpb19k
ZXZpY2Vfc2V0X2dyb3VwKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlLA0KPiA+PiArCQkJCSBl
bnVtIHZmaW9fZ3JvdXBfdHlwZSB0eXBlKQ0KPiA+PiAgIHsNCj4gPj4gLQlpbnQgcmV0Ow0KPiA+
PiArCXN0cnVjdCB2ZmlvX2dyb3VwICpncm91cDsNCj4gPj4gKw0KPiA+PiArCWlmICh0eXBlID09
IFZGSU9fSU9NTVUpDQo+ID4+ICsJCWdyb3VwID0gdmZpb19ncm91cF9maW5kX29yX2FsbG9jKGRl
dmljZS0+ZGV2KTsNCj4gPj4gKwllbHNlDQo+ID4+ICsJCWdyb3VwID0gdmZpb19ub2lvbW11X2dy
b3VwX2FsbG9jKGRldmljZS0+ZGV2LCB0eXBlKTsNCj4gPg0KPiA+IERvIHdlIG5lZWQgYSBXQVJO
X09OKHR5cGUgPT0gVkZJT19OT19JT01NVSk/DQo+IA0KPiBkbyB5b3UgbWVhbiBhIGhlYWRzLXVw
IHRvIHVzZXI/IGlmIHNvLCB0aGVyZSBpcyBhbHJlYWR5IGEgd2FybiBpbg0KPiB2ZmlvX2dyb3Vw
X2ZpbmRfb3JfYWxsb2MoKSBhbmQgdmZpb19ncm91cF9pb2N0bF9nZXRfZGV2aWNlX2ZkKCkNCj4g
DQoNCkkgbWVhbnQgdGhhdCBWRklPX05PX0lPTU1VIGlzIG5vdCBleHBlY3RlZCBhcyBhIHBhc3Nl
ZCBpbiB0eXBlLg0KSXQncyBpbXBsaWNpdGx5IGhhbmRsZWQgYnkgdmZpb19ncm91cF9maW5kX29y
X2FsbG9jKCkgd2hpY2ggY2FsbHMNCnZmaW9fbm9pb21tdV9ncm91cF9hbGxvYygpIHBsdXMga2Vy
bmVsIHRhaW50Lg0KDQo=
