Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082E75EEA51
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiI1Xyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiI1Xyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:54:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA8BBE26
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664409277; x=1695945277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ViAk1cm+GNeLzqUUof6jzES5LAL5MQx6az9A1K4CmoQ=;
  b=UaegoyACJj3dIML9GYFTCpqyeZoGOrwAY46TR4hLIUDEllQguFtoKPY0
   cUMomKnFaTtLNE8A8c4pc5YX0Fw/3GORrzEWfDAJ3BCUz86iGj9dDsP6Z
   woTrsS4EEoiMLvbBOZeriMFi72/UJ0SYwNujGLR4p8881xygyXi1jX09g
   VP90C4NVIYybKMJZsHEkA4Je2xW7rCybEhhtz5Q43AvT71IITNCa9EndB
   vGMXYVutY09r1DPYM+fdrCak1RDi9h6ZTIwhcyoMbkWwDhyygW6no1nEv
   4mrIZimmtlGb14B9C54xx9NuViCdbLwym1GRFPQN4UQWuTghOfRZRNrZ2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="281461582"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="281461582"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 16:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="797343309"
X-IronPort-AV: E=Sophos;i="5.93,353,1654585200"; 
   d="scan'208";a="797343309"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 28 Sep 2022 16:54:36 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 16:54:36 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 16:54:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 16:54:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 16:54:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dn0D0HuE6az0VxVuXjfq20Wl4eTZxdwtltpijdKTOh6W8/sBywycaphGmPBjsFydQDzjHUMXO2JCI517cttr73SBcgBMGyKMDelCcN2M4a8I9hbMW7MiOW13EAJlxE4xiI9oSQxNAK0Bf8P3moZ+SmmtDLVG8kevchN4V5sWAPunfWCVxsSc4w2XDxOg3DD+9goHGA4572F6r/lccSLoGQdD3Km6ekNZULY6pNjJWUOPxPW58bkgizuv+6yvYCpJPQPM449kBsEzvvdU1bBx7Pld4P+mOJqfWE6wdk5VwHVmO9FNB1jDlpZtEk3B5zITYzC8jahvgBHmzmDK91nbOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViAk1cm+GNeLzqUUof6jzES5LAL5MQx6az9A1K4CmoQ=;
 b=G7bz0mOWbE12MsTlx0nCteplAUKgDGZQ1cxWZvoFbMKBFBBywOFfSqtnlAOHqfzUnCXaQHd8Ou1/zTl72V1Xo9k/jA1dohyEqH/eyWO/eF46Z8Y+L2fWjKmOG5IwkRgYiLKOrSCOpX7G9urRd5oIN432fp6vdaBpwQIYF+/6Y6A+W+xJ3OTU+1FKW0Y7nPuB+IAoK6TS32V8/Yex5aYB6wBtnz9pei3KCZtM5DYp24l9mGIHJ/uTxa6dRqJtAsDo+PBmDPWRkvwK7gFqt32JNxF+mwQF37QAGmdm/+UnXk2Lw5vldbnx7uAUn5ElKYuHMG4gmkG36nI32ELyGAzeug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6564.namprd11.prod.outlook.com (2603:10b6:510:1c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 23:54:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ff76:db8b:f7e9:ac80%5]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 23:54:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Qian Cai <cai@lca.pw>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Thread-Topic: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Thread-Index: AQHYzuBaWYUDg6E9Sk+I6S3tW6vjE630OQTAgADGhQCAAIym0A==
Date:   Wed, 28 Sep 2022 23:54:27 +0000
Message-ID: <BN9PR11MB5276FF5CB2A2F12554D26CA08C549@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <BN9PR11MB5276ED36A2F498D37A18DCF38C549@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YzRnlqw/U7xDhL7P@nvidia.com>
In-Reply-To: <YzRnlqw/U7xDhL7P@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6564:EE_
x-ms-office365-filtering-correlation-id: f72dfd55-0894-436f-0b77-08daa1acc748
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w25LPkoM8b7b45yD0ccQpwncHqbNAoFz1S59ZoZQTosKxMBJol2OjBMLJrT9+6G/wk0MdUA2bfskLn7EBeW//ccqoLMtS3JYIMh7nOZrqSt+Mz55gTkZwPGrOib31jtkuv6qNKBvA3IQWDpZjquZpTDB7Gyb2I2gA5XK7cTpj9dZHAhkcZ/zbF9aYxQrNWyfr8kTncYKcDh7CCceNkytP32sS/Qg2qePP4bObMVnGEglK0YwZoZT5BCE26qQ1InSKOJHn8Y4jMnUPZrG3HteboQu+dDD7jBs3Doab3Onyk1dAKmP/sofxUTGzHVFVsrwX79T29gLuIsVmJL6fthxLy7e+GthLCZ4PebifJ3aykt0I13OwrOCGa3QQj+0yAdAiGfH5reSOpsUadVLGh9FZWKtVJtadPV/kfdepB4Ux8g5We33pNy1q9LZnwI/12AEVfKzKRLBwfBfZd7bq03/ufeGW/uQI0NpxtqIQUwrw/fZtTaEnKUByBWTe64c0Ur8gpfY6VS9T5rBRGdqY3osIPXpPCQqeJfdq4g8doyoXoDNFFiaF2aVL3LYq9OtECoJu7kf5Dx9nl2rmb37egQJ5uySTmokzRwHI5bqwPuEP3IUfEb+ZeD+ovJjU+btFNGcG4LuthR167DOPq6sYjc3M2nDfC5PU6OHuL2oZwgyCk8On65MTECN/PwXvIp+ktNquYotcgStpTEOwm/YvBrXRHbFsokzVtwnAc7kOhlIwy7uhlNfyij0ecSpWpP5y4MimKFn4YCBBC5uA1sxKQwCyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(8936002)(478600001)(5660300002)(52536014)(83380400001)(64756008)(54906003)(6506007)(122000001)(66556008)(186003)(71200400001)(8676002)(66946007)(41300700001)(76116006)(82960400001)(4326008)(66476007)(66446008)(38070700005)(38100700002)(7696005)(6916009)(316002)(26005)(9686003)(55016003)(2906002)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkVWSE5LRUh5OXJNdE9GbUNZQTlKZThiekFLWTJ5Z3JVM1B0Z2tTL3pkZFBF?=
 =?utf-8?B?UVdxSE1RWU5BSVB1VUo2S3JuNGFFRzNqNFVKc3h5Q3VCY1JaZ0o1TUF3SGhC?=
 =?utf-8?B?VXNTajJJTmZmejlSOHpYZTcwbzJnNFhBZkRVRXU2cXBxVUx6dE0zTm9CRWpG?=
 =?utf-8?B?RWR2K0xoZVk1VGJkNWUxQ20zQWJuWlhaNkNrU2tyaC8xM1c3L0RkODE1V0Jm?=
 =?utf-8?B?eGtBUDYvNUswTVRjQjhtVm10TmNZWURBZC9JWmhMZ0N1K2JkcUtyb0hNb0dj?=
 =?utf-8?B?T0JHMTVTYlZPSlZFbFRNRmVPM09WazdmUlRkTDdaaytIZXRwTHBjcWtwaUVH?=
 =?utf-8?B?ZDRTbmlRNUdBUW1Nd1JtM1BMcHRPbHVHTTlvMkRhTVp0bXYzemNaM2lzWXh4?=
 =?utf-8?B?SzRvNHZvamxXYzVmdjZ3QVhPaU91eXNVR2dnSWN5UkNsRUpsS0xRa1NiR21p?=
 =?utf-8?B?bnlGMWlKU2hFNnRmSEFzK0hPZm1GNFRnTkM5NER0UWJVMEoxRkM0SWJjaE14?=
 =?utf-8?B?bzgzeU9rb3JoaUZzR1I0YjA3ektPVitTcWVZM0Y4aVhTeHoxTE1YLzNaN1Z0?=
 =?utf-8?B?ams3RXdqWGxLKzdaZkdyc2U0RmN4c29iYzN4RndaQlBCZFhpMkhHakZiajBr?=
 =?utf-8?B?MDUyRU5IMnJpNitrM1FjanozUzdiNkRCM240djlidEszaE9USTFIbVhpL3c2?=
 =?utf-8?B?S3NXM0xBT2FUbGVGNHZ3Y1pXbWF3OUVCWlNja0VMdUNuc1RENFZVZ1pxTDdY?=
 =?utf-8?B?RDc2ZlJDMzZuOG5YRC9xVjFEUmh0REtGOTQxS1kxYmkxUmtSc1lHdy9Qamtm?=
 =?utf-8?B?RTRnMVVFVkJ4eVNmT0lPbTJLRTdSa1RiOWtPdFRQeDYvWjhBTUs0Ry9ycWNh?=
 =?utf-8?B?cVJoay9FQ2lkc2RtcEZOYk9QaWdLc2RoZW5Ldk9JQ1EyQzg4VDJWNGIzdERV?=
 =?utf-8?B?dFpRSlRGbzA2L3lrVGR1ZUU0N1JSOFV5YTF6c2taOVZTMmJteE9jejFLT28z?=
 =?utf-8?B?RkVOMEJlY1l6QlhxSlg3NmsrcllhRjhPMzV0UFVOS09zRHdYQVF3Yk9PNVRI?=
 =?utf-8?B?ZldBN3JtSTh6L1hwbGJZdU0waEZTeHRhY2pGREVKamNNc044VlRvTWpqb0Vy?=
 =?utf-8?B?RnF4TlRsM1ZoNWtTVytuV1ZSNWxFTUdCNnFHbC83WG1rMHo3K0g0bGJoZ2xw?=
 =?utf-8?B?Q0dVMkJwMEhJTlpwQUhxVkpRRFplRjNmYzhaREcrU0U4V1BzTzk3aHNnSmlI?=
 =?utf-8?B?RlM4RXl1amxLdnFyMmxZQmMxZW1ucHlVQXJkdk9ZZ0Z6U3VXOGFsS0ZKZ1JQ?=
 =?utf-8?B?dFNyNnpMNEdaRTdEdlR4ZlRUSWlJMHVqV2g0allHd2NvMVV4ckxJNmhGamFQ?=
 =?utf-8?B?RXMwUkZhZGxzRXU1WlV5VUxmNEM0dkVMZVVGSU5TM2RCNmVmcWplK3gyY2di?=
 =?utf-8?B?dDNkTmNxNDcrMEl6Q0lzckJyTXNsaElrZE1DRmhLZUYxdjdMaFprR3JrSFZE?=
 =?utf-8?B?aDNsMEFxSnFSRVdrMU9tTjVXbUNnbzVhdUtzTjZzQjAydjMwM1NmNVBQbzBT?=
 =?utf-8?B?N3BXOVRLTDEzeUV5TVpzY2VHVzJSZ3hIc2ExZ2pDWDlyYzlIWFdMOGViQ29O?=
 =?utf-8?B?UU5GK1l1KzR4K3A1ejl5RjJDV3BhdklJdENseVBFYkpSM0h0MUZNS25QUmFC?=
 =?utf-8?B?b0FDWm5nM1BKVkRBZjk1T0xGNDg0WWpjWjE5WnYxak1LbHQvSEVUVVMwa1lH?=
 =?utf-8?B?SFJYbFp3M1N5cmhocWFzL2RGYjltamxrV2liR25HN2VMTkZEenhXS0JqWFc5?=
 =?utf-8?B?RDQ3WG01bUNxbkJsTWsrcFpBMWlEcVF5M1VWWWhYbjFsYkNNeWJROGJpcS96?=
 =?utf-8?B?WGJxUHY3Zzh1Yk5FRHVJN0tsTmRDTTBaOFNweWhVMmZOVk5lenlhaXdnU01T?=
 =?utf-8?B?M3hOOXBNd29HVW5OSnJjTjV1VFVrcVdTV01WKzRDQkN0dnhybStsQk5KS0pQ?=
 =?utf-8?B?ZUxYSnh4Z2JSVWxoMjUrNUdrMzBqZzdxQ1R4bi8zRDVzK2hYRGZmeThkT2Mw?=
 =?utf-8?B?NENGZXl6UWE1K0ZZSjVYMGVQMktEVXZ5SWwxcWM4ckFiZnhDeXZ3bWVHdkZ0?=
 =?utf-8?Q?z0nWaMlHt787S1PIakP2/1DF0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72dfd55-0894-436f-0b77-08daa1acc748
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 23:54:27.5868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6/uU/C63/ws/5a2FXpIOpavcs/2eMk8wIZiZNYmw+UWl1FWOvSIDMW2lDAiafM3kriznTI/zcAmlcVsGynnaxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIFNlcHRlbWJlciAyOCwgMjAyMiAxMToyNiBQTQ0KPiANCj4gT24gV2VkLCBTZXAgMjgsIDIw
MjIgYXQgMDM6NTE6MDFBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBK
YXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gU2VudDogRnJpZGF5LCBTZXB0
ZW1iZXIgMjMsIDIwMjIgODowNiBBTQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3ZmaW8vdmZpby5oIGIvZHJpdmVycy92ZmlvL3ZmaW8uaA0KPiA+ID4gaW5kZXggNTZmYWIzMWY4
ZTBmZjguLjAzOWUzMjA4ZDI4NmZhIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy92ZmlvL3Zm
aW8uaA0KPiA+ID4gKysrIGIvZHJpdmVycy92ZmlvL3ZmaW8uaA0KPiA+ID4gQEAgLTQxLDcgKzQx
LDE1IEBAIGVudW0gdmZpb19ncm91cF90eXBlIHsNCj4gPiA+ICBzdHJ1Y3QgdmZpb19ncm91cCB7
DQo+ID4gPiAgCXN0cnVjdCBkZXZpY2UgCQkJZGV2Ow0KPiA+ID4gIAlzdHJ1Y3QgY2RldgkJCWNk
ZXY7DQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIFdoZW4gZHJpdmVycyBpcyBub24temVybyBhIGRy
aXZlciBpcyBhdHRhY2hlZCB0byB0aGUgc3RydWN0IGRldmljZQ0KPiA+ID4gKwkgKiB0aGF0IHBy
b3ZpZGVkIHRoZSBpb21tdV9ncm91cCBhbmQgdGh1cyB0aGUgaW9tbXVfZ3JvdXAgaXMgYQ0KPiA+
ID4gdmFsaWQNCj4gPiA+ICsJICogcG9pbnRlci4gV2hlbiBkcml2ZXJzIGlzIDAgdGhlIGRyaXZl
ciBpcyBiZWluZyBkZXRhY2hlZC4gT25jZSB1c2Vycw0KPiA+ID4gKwkgKiByZWFjaGVzIDAgdGhl
biB0aGUgaW9tbXVfZ3JvdXAgaXMgaW52YWxpZC4NCj4gPiA+ICsJICovDQo+ID4gPiArCXJlZmNv
dW50X3QJCQlkcml2ZXJzOw0KPiA+DQo+ID4gV2hpbGUgSSBhZ3JlZSBhbGwgdGhpcyBwYXRjaCBp
cyBkb2luZywgdGhlIG5vdGF0aW9uIG9mICdkcml2ZXJzJyBoZXJlIHNvdW5kcw0KPiA+IGEgYml0
IGNvbmZ1c2luZyBJTUhPLg0KPiANCj4gTWF5YmUsIEkgcGlja2VkIGl0IGJlY2F1c2Ugd2UgcmVj
ZW50bHkgaGFkIGEgbnVtX2RldmljZXMgaGVyZSB0aGF0IHdhcw0KPiBhIGRpZmZlcmVudCB0aGlu
Zy4gImRyaXZlcnMiIGNvbWVzIGZyb20gdGhlIGlkZWEgdGhhdCBpdCBpcyB0aGUgbnVtYmVyDQoN
Cm51bV9kZXZpY2VzIGhhcyBiZWVuIHJlbW92ZWQgYnkgb25lIG9mIHlvdXIgcGF0Y2hlcy4NCg0K
PiBvZiBkcml2ZXJzIHRoYXQgaGF2ZSBjYWxsZWQgJ3JlZ2lzdGVyJyBvbiB0aGUgZ3JvdXAuIFRo
aXMgYWxzbyBoYXBwZW5zDQo+IHRvIGJlIHRoZSBudW1iZXIgb2YgdmZpb19kZXZpY2VzIG9mIGNv
dXJzZS4NCg0KdGhlcmUgY291bGQgYmUgb25lIGRyaXZlciBjYWxsaW5nICdyZWdpc3Rlcicgb24g
bXVsdGlwbGUgZ3JvdXBzLiBUaGF0IGlzDQp0aGUgcGFydCB3aGljaCBnZXRzIGNvbmZ1c2luZy4g
SWYgdGFsa2luZyBhYm91dCBkcml2ZXIgaXQgaXMgbW9yZSBhY2N1cmF0ZWx5DQp0byBiZSAnZHJp
dmVyX3JlZ2lzdHJhdGlvbnMnIHRoZW4gdGhlIGltcGxpY2F0aW9uIGlzIHN0aWxsIGFib3V0IGRl
dmljZS4g8J+Yig0KDQo+IA0KPiA+ID4gIAlyZWZjb3VudF90CQkJdXNlcnM7DQo+ID4gPiArCXN0
cnVjdCBjb21wbGV0aW9uCQl1c2Vyc19jb21wOw0KPiA+DQo+ID4gTm93IHRoZSBvbmx5IHBsYWNl
IHBva2luZyAndXNlcnMnIGlzIHdoZW4gYSBncm91cCBpcyBvcGVuZWQvY2xvc2VkLA0KPiA+IHdo
aWxlIGdyb3VwLT5vcGVuZWRfZmlsZSBhbHJlYWR5IHBsYXlzIHRoZSBndWFyZCByb2xlLiBGcm9t
IHRoaXMNCj4gPiBhbmdsZSAndXNlcnMnIHNvdW5kcyByZWR1bmRhbnQgbm93Pw0KPiANCj4gT2gg
aW50ZXJlc3RpbmcuIEkgZGlkIHRyeSB0byBnZXQgcmlkIG9mIHRoYXQgdGhpbmcsIGJ1dCBJIHdh
cyB0aGlua2luZw0KPiB0byBtYWtlIGl0ICJkaXNhc3NvY2lhdGUiIHNvIHdlIGRpZG4ndCBoYXZl
IHRvIHNsZWVwIGF0IGFsbCwgYnV0IFNQQVBSDQo+IG1lc3NlZCB0aGF0IHVwLi4gSXQgaXMgYSBn
b29kIGZvbGxvd3VwIHBhdGNoDQoNCmEgZm9sbG93dXAgcGF0Y2ggbGlrZSBiZWxvdyBzb3VuZHMg
Z29vZA0KDQo+IA0KPiBTbyBsaWtlIHRoaXM6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92
ZmlvL3ZmaW8uaCBiL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gaW5kZXggMDM5ZTMyMDhkMjg2ZmEu
Ljc4YjM2MmE5MjUwMTEzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3ZmaW8vdmZpby5oDQo+ICsr
KyBiL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gQEAgLTQ4LDggKzQ4LDYgQEAgc3RydWN0IHZmaW9f
Z3JvdXAgew0KPiAgCSAqIHJlYWNoZXMgMCB0aGVuIHRoZSBpb21tdV9ncm91cCBpcyBpbnZhbGlk
Lg0KPiAgCSAqLw0KPiAgCXJlZmNvdW50X3QJCQlkcml2ZXJzOw0KPiAtCXJlZmNvdW50X3QJCQl1
c2VyczsNCj4gLQlzdHJ1Y3QgY29tcGxldGlvbgkJdXNlcnNfY29tcDsNCj4gIAl1bnNpZ25lZCBp
bnQJCQljb250YWluZXJfdXNlcnM7DQo+ICAJc3RydWN0IGlvbW11X2dyb3VwCQkqaW9tbXVfZ3Jv
dXA7DQo+ICAJc3RydWN0IHZmaW9fY29udGFpbmVyCQkqY29udGFpbmVyOw0KPiBAQCAtNjEsNiAr
NTksNyBAQCBzdHJ1Y3QgdmZpb19ncm91cCB7DQo+ICAJc3RydWN0IHJ3X3NlbWFwaG9yZQkJZ3Jv
dXBfcndzZW07DQo+ICAJc3RydWN0IGt2bQkJCSprdm07DQo+ICAJc3RydWN0IGZpbGUJCQkqb3Bl
bmVkX2ZpbGU7DQo+ICsJc3RydWN0IHN3YWl0X3F1ZXVlX2hlYWQJCW9wZW5lZF9maWxlX3dhaXQ7
DQo+ICAJc3RydWN0IGJsb2NraW5nX25vdGlmaWVyX2hlYWQJbm90aWZpZXI7DQo+ICB9Ow0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYyBiL2RyaXZlcnMvdmZpby92
ZmlvX21haW4uYw0KPiBpbmRleCBmMTkxNzFjYWQ5YTI1Zi4uNTdhNzU3NmE5NmE2MWIgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0KPiArKysgYi9kcml2ZXJzL3ZmaW8v
dmZpb19tYWluLmMNCj4gQEAgLTE4NiwxMCArMTg2LDkgQEAgc3RhdGljIHN0cnVjdCB2ZmlvX2dy
b3VwICp2ZmlvX2dyb3VwX2FsbG9jKHN0cnVjdA0KPiBpb21tdV9ncm91cCAqaW9tbXVfZ3JvdXAs
DQo+ICAJY2Rldl9pbml0KCZncm91cC0+Y2RldiwgJnZmaW9fZ3JvdXBfZm9wcyk7DQo+ICAJZ3Jv
dXAtPmNkZXYub3duZXIgPSBUSElTX01PRFVMRTsNCj4gDQo+IC0JcmVmY291bnRfc2V0KCZncm91
cC0+dXNlcnMsIDEpOw0KPiAgCXJlZmNvdW50X3NldCgmZ3JvdXAtPmRyaXZlcnMsIDEpOw0KPiAt
CWluaXRfY29tcGxldGlvbigmZ3JvdXAtPnVzZXJzX2NvbXApOw0KPiAgCWluaXRfcndzZW0oJmdy
b3VwLT5ncm91cF9yd3NlbSk7DQo+ICsJaW5pdF9zd2FpdF9xdWV1ZV9oZWFkKCZncm91cC0+b3Bl
bmVkX2ZpbGVfd2FpdCk7DQo+ICAJSU5JVF9MSVNUX0hFQUQoJmdyb3VwLT5kZXZpY2VfbGlzdCk7
DQo+ICAJbXV0ZXhfaW5pdCgmZ3JvdXAtPmRldmljZV9sb2NrKTsNCj4gIAlncm91cC0+aW9tbXVf
Z3JvdXAgPSBpb21tdV9ncm91cDsNCj4gQEAgLTI0NSwxMiArMjQ0LDYgQEAgc3RhdGljIHN0cnVj
dCB2ZmlvX2dyb3VwICp2ZmlvX2NyZWF0ZV9ncm91cChzdHJ1Y3QNCj4gaW9tbXVfZ3JvdXAgKmlv
bW11X2dyb3VwLA0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+IA0KPiAtc3RhdGljIHZvaWQgdmZp
b19ncm91cF9wdXQoc3RydWN0IHZmaW9fZ3JvdXAgKmdyb3VwKQ0KPiAtew0KPiAtCWlmIChyZWZj
b3VudF9kZWNfYW5kX3Rlc3QoJmdyb3VwLT51c2VycykpDQo+IC0JCWNvbXBsZXRlKCZncm91cC0+
dXNlcnNfY29tcCk7DQo+IC19DQo+IC0NCj4gIHN0YXRpYyB2b2lkIHZmaW9fZGV2aWNlX3JlbW92
ZV9ncm91cChzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSkNCj4gIHsNCj4gIAlzdHJ1Y3QgdmZp
b19ncm91cCAqZ3JvdXAgPSBkZXZpY2UtPmdyb3VwOw0KPiBAQCAtMjcwLDEwICsyNjMsNiBAQCBz
dGF0aWMgdm9pZCB2ZmlvX2RldmljZV9yZW1vdmVfZ3JvdXAoc3RydWN0DQo+IHZmaW9fZGV2aWNl
ICpkZXZpY2UpDQo+ICAJICogY2Rldl9kZXZpY2VfYWRkKCkgd2lsbCBmYWlsIGR1ZSB0byB0aGUg
bmFtZSBhcmVhZHkgZXhpc3RpbmcuDQo+ICAJICovDQo+ICAJY2Rldl9kZXZpY2VfZGVsKCZncm91
cC0+Y2RldiwgJmdyb3VwLT5kZXYpOw0KPiAtCW11dGV4X3VubG9jaygmdmZpby5ncm91cF9sb2Nr
KTsNCj4gLQ0KPiAtCS8qIE1hdGNoZXMgdGhlIGdldCBmcm9tIHZmaW9fZ3JvdXBfYWxsb2MoKSAq
Lw0KPiAtCXZmaW9fZ3JvdXBfcHV0KGdyb3VwKTsNCj4gDQo+ICAJLyoNCj4gIAkgKiBCZWZvcmUg
d2UgYWxsb3cgdGhlIGxhc3QgZHJpdmVyIGluIHRoZSBncm91cCB0byBiZSB1bnBsdWdnZWQgdGhl
DQo+IEBAIC0yODEsNyArMjcwLDEzIEBAIHN0YXRpYyB2b2lkIHZmaW9fZGV2aWNlX3JlbW92ZV9n
cm91cChzdHJ1Y3QNCj4gdmZpb19kZXZpY2UgKmRldmljZSkNCj4gIAkgKiBpcyBiZWNhdXNlIHRo
ZSBncm91cC0+aW9tbXVfZ3JvdXAgcG9pbnRlciBzaG91bGQgb25seSBiZSB1c2VkDQo+IHNvIGxv
bmcNCj4gIAkgKiBhcyBhIGRldmljZSBkcml2ZXIgaXMgYXR0YWNoZWQgdG8gYSBkZXZpY2UgaW4g
dGhlIGdyb3VwLg0KPiAgCSAqLw0KPiAtCXdhaXRfZm9yX2NvbXBsZXRpb24oJmdyb3VwLT51c2Vy
c19jb21wKTsNCj4gKwl3aGlsZSAoZ3JvdXAtPm9wZW5lZF9maWxlKSB7DQo+ICsJCW11dGV4X3Vu
bG9jaygmdmZpby5ncm91cF9sb2NrKTsNCj4gKwkJc3dhaXRfZXZlbnRfaWRsZV9leGNsdXNpdmUo
Z3JvdXAtPm9wZW5lZF9maWxlX3dhaXQsDQo+ICsJCQkJCSAgICFncm91cC0+b3BlbmVkX2ZpbGUp
Ow0KPiArCQltdXRleF9sb2NrKCZ2ZmlvLmdyb3VwX2xvY2spOw0KPiArCX0NCj4gKwltdXRleF91
bmxvY2soJnZmaW8uZ3JvdXBfbG9jayk7DQo+IA0KPiAgCS8qDQo+ICAJICogVGhlc2UgZGF0YSBz
dHJ1Y3R1cmVzIGFsbCBoYXZlIHBhaXJlZCBvcGVyYXRpb25zIHRoYXQgY2FuIG9ubHkgYmUNCj4g
QEAgLTkwNiwxNSArOTAxLDE4IEBAIHN0YXRpYyBpbnQgdmZpb19ncm91cF9mb3BzX29wZW4oc3Ry
dWN0IGlub2RlDQo+ICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGVwKQ0KPiANCj4gIAlkb3duX3dy
aXRlKCZncm91cC0+Z3JvdXBfcndzZW0pOw0KPiANCj4gLQkvKiB1c2VycyBjYW4gYmUgemVybyBp
ZiB0aGlzIHJhY2VzIHdpdGggdmZpb19kZXZpY2VfcmVtb3ZlX2dyb3VwKCkgKi8NCj4gLQlpZiAo
IXJlZmNvdW50X2luY19ub3RfemVybygmZ3JvdXAtPnVzZXJzKSkgew0KPiArCS8qDQo+ICsJICog
ZHJpdmVycyBjYW4gYmUgemVybyBpZiB0aGlzIHJhY2VzIHdpdGggdmZpb19kZXZpY2VfcmVtb3Zl
X2dyb3VwKCksDQo+IGl0DQo+ICsJICogd2lsbCBiZSBzdGFibGUgYXQgMCB1bmRlciB0aGUgZ3Jv
dXAgcndzZW0NCj4gKwkgKi8NCj4gKwlpZiAocmVmY291bnRfcmVhZCgmZ3JvdXAtPmRyaXZlcnMp
ID09IDApIHsNCj4gIAkJcmV0ID0gLUVOT0RFVjsNCj4gLQkJZ290byBlcnJfdW5sb2NrOw0KPiAr
CQlnb3RvIG91dF91bmxvY2s7DQo+ICAJfQ0KPiANCj4gIAlpZiAoZ3JvdXAtPnR5cGUgPT0gVkZJ
T19OT19JT01NVSAmJiAhY2FwYWJsZShDQVBfU1lTX1JBV0lPKSkNCj4gew0KPiAgCQlyZXQgPSAt
RVBFUk07DQo+IC0JCWdvdG8gZXJyX3B1dDsNCj4gKwkJZ290byBvdXRfdW5sb2NrOw0KPiAgCX0N
Cj4gDQo+ICAJLyoNCj4gQEAgLTkyMiwxNiArOTIwLDEyIEBAIHN0YXRpYyBpbnQgdmZpb19ncm91
cF9mb3BzX29wZW4oc3RydWN0IGlub2RlDQo+ICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGVwKQ0K
PiAgCSAqLw0KPiAgCWlmIChncm91cC0+b3BlbmVkX2ZpbGUpIHsNCj4gIAkJcmV0ID0gLUVCVVNZ
Ow0KPiAtCQlnb3RvIGVycl9wdXQ7DQo+ICsJCWdvdG8gb3V0X3VubG9jazsNCj4gIAl9DQo+ICAJ
Z3JvdXAtPm9wZW5lZF9maWxlID0gZmlsZXA7DQo+ICAJZmlsZXAtPnByaXZhdGVfZGF0YSA9IGdy
b3VwOw0KPiAtDQo+IC0JdXBfd3JpdGUoJmdyb3VwLT5ncm91cF9yd3NlbSk7DQo+IC0JcmV0dXJu
IDA7DQo+IC1lcnJfcHV0Og0KPiAtCXZmaW9fZ3JvdXBfcHV0KGdyb3VwKTsNCj4gLWVycl91bmxv
Y2s6DQo+ICsJcmV0ID0gMDsNCj4gK291dF91bmxvY2s6DQo+ICAJdXBfd3JpdGUoJmdyb3VwLT5n
cm91cF9yd3NlbSk7DQo+ICAJcmV0dXJuIHJldDsNCj4gIH0NCj4gQEAgLTk1Miw4ICs5NDYsNyBA
QCBzdGF0aWMgaW50IHZmaW9fZ3JvdXBfZm9wc19yZWxlYXNlKHN0cnVjdCBpbm9kZQ0KPiAqaW5v
ZGUsIHN0cnVjdCBmaWxlICpmaWxlcCkNCj4gIAkJdmZpb19ncm91cF9kZXRhY2hfY29udGFpbmVy
KGdyb3VwKTsNCj4gIAlncm91cC0+b3BlbmVkX2ZpbGUgPSBOVUxMOw0KPiAgCXVwX3dyaXRlKCZn
cm91cC0+Z3JvdXBfcndzZW0pOw0KPiAtDQo+IC0JdmZpb19ncm91cF9wdXQoZ3JvdXApOw0KPiAr
CXN3YWtlX3VwX29uZSgmZ3JvdXAtPm9wZW5lZF9maWxlX3dhaXQpOw0KPiANCj4gIAlyZXR1cm4g
MDsNCj4gIH0NCg==
