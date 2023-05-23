Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C066470D0C6
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 04:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjEWCCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 22:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjEWCCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 22:02:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E62DCA;
        Mon, 22 May 2023 19:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684807361; x=1716343361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fVUpdBNvef/+ndzQrCjqsDDLsGo3WbGkSaM54EXfh9E=;
  b=V0axrJLqXtCSu4iEMkBiu1VlCpwmxj7ckwY+GBUm247uO8JTiRv/8/m5
   chi+BrXYwDqjedwN5YLug5fNDx7VrWyTR0fte0rsuUWGn+X2d2fQ3p1nP
   MQI9p5i45BkGjtOAg75CeMTYqzlrtD2RYgco8f6ChWzk5BQYgULP/tnVo
   zR82T2NTbQRo0Lc5mLlR6h55cPwz5yoY9t1CvgSyole27APszbkFnb1Pe
   H71JCwVCeusgUpWtcxmTV6y77SneEfeAg8ISDuoMzxuwymvfjflZrZcVD
   kh+Woawbq9RmuBa+LGdBrMzobp1d6IkBBRO3atpE/G9Aq1b1MhgOqa+aZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439452837"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="439452837"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 19:02:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="848074899"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="848074899"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2023 19:02:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 19:02:40 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 19:02:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 19:02:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 19:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGScPQn9ws2w5z6+1Ge694mxKKrQ92TTAxrbi+YAm+mGwVgTC1dfqTMih5Jsh9k0DMPF2lCDW8TR0n0vFx9IOiYTdUqDizzrh7I1F/g6Z09k9tqm8050xb2tb5A22puo/on26G79lgaQ19V/hnZAQ8LUcYfmktPBm8ThlcSTmtAcY6UrqOMWKa/jb298bQUW6SeDx/GUuD8NYeFbVByv5IOWwXfwKZ+zkIvvy6SC4jNreaoVVovDZPR8UH0dmnocz/b9zTwoyXm0Zk9FHXh7ot1IP4GHKSByuQc/KniKtEWyoHsj2F+LOW3VM/OV39eP3MdOX5LUvLm2XzupM/vGGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVUpdBNvef/+ndzQrCjqsDDLsGo3WbGkSaM54EXfh9E=;
 b=KXzwC9HA1Adrp9svFtlT/u6wXc9f5mqvjEKn1yDsx5pT7BivWFVgUr0yOblMEpphyS4bfULVQza2IeJ4T1LvskVTHem6+Xzpr8kNQSgo6rYfLexluQkm8YOQ4qmdQBDwMrB2K9OnnmwrnCyCquUEjWEd3oce0/ti2CfVEwu1VcjuciImnnuhrM4l2vuFCDi1LjBjz8jqaB+TxzvxWEx+h2ByIqPDBPd8aZjSFz8wrjFmNn2WVDSTCuMq580d7Mg+1HF350OoFtLybOKFC2k3DcsygE7x0iKNO+YY3ufSW5lAzJCTFgVlbYOBnT3tVI2NVgNfwldfEk4whOnnn+Nf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6043.namprd11.prod.outlook.com (2603:10b6:8:62::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Tue, 23 May 2023 02:02:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 02:02:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 17/18] KVM: x86: Force kvm_rebooting=true during
 emergency reboot/crash
Thread-Topic: [PATCH v3 17/18] KVM: x86: Force kvm_rebooting=true during
 emergency reboot/crash
Thread-Index: AQHZhSyjOuJ4Qyzib0KQbsMiOzm3ya9m/v0AgAAr8IA=
Date:   Tue, 23 May 2023 02:02:37 +0000
Message-ID: <73ea9a6075898081871b0a164a5779900f2e54b5.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-18-seanjc@google.com>
         <bc6a458d20c2b1743196b672a201d1d9e004b518.camel@intel.com>
In-Reply-To: <bc6a458d20c2b1743196b672a201d1d9e004b518.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6043:EE_
x-ms-office365-filtering-correlation-id: 05ca5737-2405-4479-4c5e-08db5b31c833
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6k5gHfB+ReJFZgiBhD4i5Yv2rgY8rKHSMiMVqASNzo9EjyPeWz0RoJNitN5pp1S004BJO4d/Q5zhG5S4aymqofmg7aCtatRwUYZm7Vx7ZpjiPBz3YQK+6LT9PVPGAkLOj247MU+rd45ZYfLTPiym6VGjn9EtQFlc6VFfFEQVKTercSkl9QXYP0EzfrgT0HH3OrxpvqVa7BRWuYo0LU3Z+PHCyRbuEZOq5r4vXshd3EY9KuPV8fjDfdVKrhuirOdKh3GI9mAebCqEo0Vttf7qDoYm55Pn1vIW5qSJrWKovzQ7rn1eDeyS0FDSEQ/C8MODvrAznMYjB11xKwlXtbb07MZQChK/TwaCy0vnAIK+diahZavc5KGGL53t/Gjmu3DOccr/+QcQHqYUT+diCaSWaah7lzt/Qnf+ltNYJD1QdoHotDWKBaF+jMYCihvt7mB1DMo3r2G7rfoJle3gijLqI3focTE/inCRv9zayGWyVAAPs4KlCpiygLjuyMYHaZxDjjJd6V36aXmhk+maz19AOIVchLm9jv4MMbPgsSxgWDPmgxRiKJ0mZnJ4Wz2j9FdrpJZlsOeMMn7VeojyWKbltUxNUq7W6Y65oYNYS4wdVuXgBpOXVl0tFdhFrfSZwXLZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199021)(54906003)(41300700001)(6486002)(478600001)(110136005)(316002)(71200400001)(91956017)(4326008)(76116006)(64756008)(66446008)(66946007)(66556008)(66476007)(86362001)(5660300002)(38070700005)(8936002)(8676002)(38100700002)(26005)(122000001)(82960400001)(6506007)(6512007)(186003)(2906002)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGg0dnZrVWZCZnV6aGdkeTFaT1U2TTQzV015b3JyWVRjYTZIbmRZZ2lLTE5H?=
 =?utf-8?B?QXpSc0VlZGFpaTBuTDNVcVRmRmZ5L2VUZ0ZsNSt0TXFyRnhZMzdDYmdZV2VH?=
 =?utf-8?B?LzB3bWJtVWlwTlZYZWRTTUJwa2NPdDVWZkRycXlBNStrZ0I3Wkd4dHlrN1dm?=
 =?utf-8?B?djJjNitFNTdZanJBaXoxeVZNL0Zqbi9GRkYwM3Z1dk1ZMDhTTk1peG1XeHcr?=
 =?utf-8?B?YjdUOUF2SFk3ZFJkQmorbXRFOWlRVHQxQXNnQWF0TlZSS3hyd1BVa1pBY25W?=
 =?utf-8?B?MzV6Q3dxMVlIRWZ0SUgrNWZEaEtFV2liK3Y5bUVmM3FUTVhJSTNCQS8vNUpY?=
 =?utf-8?B?R1EzNXZkc09GbzhLQ0V6dU1idTk0VDF4OS8wRC9oaS9XekNPK1NxUVNxdlFR?=
 =?utf-8?B?VEFaOHRzSTFpYzB2ckw4Nm1heFg2cVhZSG1RSVdMeFpMRTRuR3g1Z0IzcVQ4?=
 =?utf-8?B?WE5oNVFxZmhZc0RKaGhXYVpmaXhoa3ROUFhoSVNPT080SUlsaWlaYmV1bmNt?=
 =?utf-8?B?MlZ4TzlTVEw2NHJsSThyUlRYcFU4dElDY1dTSHpoemVFVThKNTgwUWN5SlVM?=
 =?utf-8?B?b000Qm41ZDhiQnUyY0VMSnYwYmJXWjZzU1dmZUNuWUdoUElKczBFMmFQRnZF?=
 =?utf-8?B?YkpkOC91NE56UWFOOVdBUk01VndkaVBRVkd2RjJRRk9pU1pBY0Y1OW5mRUdM?=
 =?utf-8?B?aExCNUZBbnRveWRtTDBwQ0Q5ZnhZTzFZU3JMeFVrbmdwcDMrY2NkVG5CL3o5?=
 =?utf-8?B?cTRXdVlpWjNEdmxLNFA2VDlDK3IydUlTVG1rV3lzSURRS3MxUHVFSVVHa3pG?=
 =?utf-8?B?allTcHJQdnNnUGZNY1h5YmJxcjFJbnRLcFlPL0pDdmVSTUNFeGNzK3VucFkv?=
 =?utf-8?B?YTFhM0RZZXlRckxKY1VBUVZzMStDNm9CbnFBcDMwQWs2ZHlucXJxUzZoRWt1?=
 =?utf-8?B?dTViQlFObWJpTnFvM292YnVZVGREemxkaVhiOUU1VGtLQUs2N2ttRmZmN2kr?=
 =?utf-8?B?ZXl2ZGNnNjlORUdOeXQ0ZkFWNmxCcm1FbFlNSlRPMEhGMUhwQSt3cG9pV3Rq?=
 =?utf-8?B?aVdHNkRPTDdxTytHczMrOGR5U0x0WWQrZks2YW1LcHd4L1NoRHEwU25hdUJK?=
 =?utf-8?B?K0UvT2hMQXVGVlhBU0liWkJVblRMRXFaZXRkTjdXeHJBZG5RNk1iNnFUVndJ?=
 =?utf-8?B?M1pUM1pjQWtRcGVMSUxUL0RjN0g1aWozTVpVVWFKdzFmclJ0YVFkMFJDOGJG?=
 =?utf-8?B?NG9tSGwyTG5OaVVEelZuSmxvVnRJTStYOEpnRTNiaEg0YmpGN2xSb29iUHFi?=
 =?utf-8?B?LytwcGUrL2d1Rmt4aEtBYldSbzJTdmxYVGJ4QmFIZmlvRHNmT0FKdkhyWWNR?=
 =?utf-8?B?QitOZi9wYTZ5L1JaVXk2eC9JeHZHY0hnTzArOWkvTm1rRWZQblVKTThTaExM?=
 =?utf-8?B?R2JRTVRrczVZdFV6MEZzMGc1enQ4cEl2UWNuNmRoZ1FBcGVUQW81QUFwWlBo?=
 =?utf-8?B?M1JQK1pjckN4Y05FQTZIeEpjdmh4WHYzZURFdStLNTFxVEZ6NGZNS1d0QWJy?=
 =?utf-8?B?WmxSV0tFWW42UzFuNUR6bXNDakp5SG4yMlFhb21XSlVGbjR5VVAxUUs2L1Qr?=
 =?utf-8?B?N3NweDVIUDR4cU1XbGx3UHdkemlhQXF0ejAzVndabEk5MlArNjhLSVZ6NjNQ?=
 =?utf-8?B?ZnhsSWVXa1FmZGkzcVArQmxKa25xMW9QWGQzVWJ1MWppN3dNS0NzaDRCTHpK?=
 =?utf-8?B?WTMxSW5qbCtMcGNnT2IwK25YLzNZN1lPM2dpWldURjQ4RTRROW9CSDluT3FF?=
 =?utf-8?B?LzUwbFg3blZ1Zm5TanNyZFIvak9QRHFoYVJYRzVtTytKNFREVENxcEswRi9n?=
 =?utf-8?B?Sm9zZkdkV1NvK3JnQjhrSkxtWEQ0OVk0eTVYZTg2Zmg5blBubUd0YWJsRjcx?=
 =?utf-8?B?dmV1R0N5RzIvT2FsYjlZNHpBSW5CQncrY09sYUFQTFEzc0E3dEROYzNnVXlQ?=
 =?utf-8?B?QkVOTmkxRllYbWVuK1liVlVoZldFaENwY2lzZjVmbzRsNXp1d01jd2xMK0lu?=
 =?utf-8?B?dEtUY2lHQnNWcVBYRFV2TWNwUS9vRDA2SFl2WlhhSi9MdC9oY0h0bzkySGtl?=
 =?utf-8?B?YkhSTVZYYVdUbHhQNjR3YUlwU0N3amRYbzgrbXVUQzN3YTVCZVd5a29yRU1I?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6696E61DE6EF8A428C4D8E3484AEC669@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ca5737-2405-4479-4c5e-08db5b31c833
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 02:02:37.3272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDIjnXeEAQV5qUjyM/GE0vToe0PfB8bHKkLYL5jHryURlz2JdeR2vAeHpsy8vKjkUdC5csIXkAZzub1v2hQvVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6043
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA1LTIzIGF0IDExOjI1ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IEZyaSwgMjAyMy0wNS0xMiBhdCAxNjo1MCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90
ZToNCj4gPiBTZXQga3ZtX3JlYm9vdGluZyB3aGVuIHZpcnR1YWxpemF0aW9uIGlzIGRpc2FibGVk
IGluIGFuIGVtZXJnZW5jeSBzbyB0aGF0DQo+ID4gS1ZNIGVhdHMgZmF1bHRzIG9uIHZpcnR1YWxp
emF0aW9uIGluc3RydWN0aW9ucyBldmVuIGlmIGt2bV9yZWJvb3QoKSBpc24ndA0KPiA+IHJlYWNo
ZWQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2t2bS9zdm0vc3ZtLmMgfCAyICsr
DQo+ID4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAyICsrDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9z
dm0vc3ZtLmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ID4gaW5kZXggMmNjMTk1ZDk1ZDMy
Li5kMDBkYTEzM2IxNGYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0K
PiA+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gPiBAQCAtNjExLDYgKzYxMSw4IEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCBrdm1fY3B1X3N2bV9kaXNhYmxlKHZvaWQpDQo+ID4gIA0KPiA+
ICBzdGF0aWMgdm9pZCBzdm1fZW1lcmdlbmN5X2Rpc2FibGUodm9pZCkNCj4gPiAgew0KPiA+ICsJ
a3ZtX3JlYm9vdGluZyA9IHRydWU7DQo+ID4gKw0KPiA+ICAJa3ZtX2NwdV9zdm1fZGlzYWJsZSgp
Ow0KPiA+ICB9DQo+ID4gIA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5j
IGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+IGluZGV4IDAwODkxNDM5NjE4MC4uMWRlYzkz
MmFmZjIxIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiArKysg
Yi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gQEAgLTc3MSw2ICs3NzEsOCBAQCBzdGF0aWMg
dm9pZCB2bXhfZW1lcmdlbmN5X2Rpc2FibGUodm9pZCkNCj4gPiAgCWludCBjcHUgPSByYXdfc21w
X3Byb2Nlc3Nvcl9pZCgpOw0KPiA+ICAJc3RydWN0IGxvYWRlZF92bWNzICp2Ow0KPiA+ICANCj4g
PiArCWt2bV9yZWJvb3RpbmcgPSB0cnVlOw0KPiANCj4gRG8gd2UgbmVlZCBhIG1lbW9yeSBiYXJy
aWVyIGhlcmU/DQo+IA0KDQpIbW0uLiBQbGVhc2UgaWdub3JlIHRoaXMuICBJIHdhcyBjb25mdXNl
ZCBiZXR3ZWVuIGNhY2hlIGNvaGVyZW5jeSB2cyBtZW1vcnkNCm9yZGVyaW5nLiAgTm90IGVub3Vn
aCBjb2ZmZWUuDQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+
DQoNCg==
