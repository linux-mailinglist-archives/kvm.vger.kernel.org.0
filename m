Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A321F5FF0F4
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 17:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJNPQL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 11:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJNPQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 11:16:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B571C6BE5;
        Fri, 14 Oct 2022 08:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665760568; x=1697296568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+of2+ebDtKtkCv8x6DTdwXKoF91l1capGQ9Uodkqfqc=;
  b=lBQoWY3IlHert7y4kZ2se3UTs+eGhRKR/7JmjmAubEWLQ8KBkHy2iDfk
   5uk+LxqfTYRy6dnxnvfu7pv8nLp5pDMtRUl76rwULbxSjFmZu/0+bmb87
   KK8jlbmvFGhGruOeBNc32nvWae1mp1LbkZOaBpYIVtIaiVKReT8HzLZjT
   t1F3oeZ264/lfLMD1dopim+rWoO+vvEOmDNQFCLRKK12SIFWVM/VjutRC
   V/GIp9QSz4WuppAeSPP7pJO5K1v14SS1WI2NcqdzuRwKcYomZe/2tRBP8
   FpvDHdQJ8q1UpqXltxhDh36KMtGLqc76x01Pl3hW7oSXmfXJdpp0XlrYP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="285788627"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="285788627"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 08:16:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="956615782"
X-IronPort-AV: E=Sophos;i="5.95,184,1661842800"; 
   d="scan'208";a="956615782"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2022 08:16:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 08:16:07 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 08:16:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 14 Oct 2022 08:16:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 14 Oct 2022 08:16:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP8g6ahdVSzKJlwPoxpSnxyJnb7vRKIrcvL8ha4CIDtEZdBT/R7JPuwsQ/qRVT+gci2Iu4JzuL5DOgSMLN/FfpT3GnDc4QBD9+t6i1wQdK0UXIm5JoqPWs8olwlJrgRLmK61FomklcJRzWs7pRHEAkFDwT5abqQpSrrtW5DVZggsOsQBJWsVuY9u2XjYubi9GzjDZ87OqpLxCWUu+sUSLnYTPd3OKkv6dUoXoIlLuZ5iu0icma8HcxE76RqYr1/d9CvE+blNj1irzTaem9V7EarKuFmhJUr7cWel4whI7oAeGatEsB/+/bBhZo1dY+fKdBNnYPdhI66f8U6pvWakCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+of2+ebDtKtkCv8x6DTdwXKoF91l1capGQ9Uodkqfqc=;
 b=XIonxUvowna+PjUr8MFnTs2LWzy1+4rFZGH22N20cxc0MCpBIwdnKCmL7gzpkQYzURBQvCaOtznmRcGLZJpsWuE0xAjcv8sAiG2KhTvuVM/F83Uk9Oj+YrcwwS7UA4w3vkIqYakk26WJpmx2uOTbWCIxoEfyJBBAig0je3FML9XuWcDZLUzhyI1YCQ9JF7iK85rAtObGrk40popMHmuG01rH8kwdg6n98sKMHV3uGlPBdnu6Mwb3pfxD8EOc/jfZJiC1z2Eb+16m+1A4bnQHVd4Ahc5vw1kPWSKVMLod2q6MQsbY9Uh1fQ3WZRCcK/g+KwR1SpSSts3ONAhNhBVGRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW5PR11MB5859.namprd11.prod.outlook.com (2603:10b6:303:19e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Fri, 14 Oct 2022 15:16:01 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%5]) with mapi id 15.20.5676.041; Fri, 14 Oct 2022
 15:16:01 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Topic: [PATCH v5 0/5] dirty_log_perf_test vCPU pinning
Thread-Index: AQHY3PSo5mk7BJgdskG84RjiFjmwJa4N+zRAgAAJ2hA=
Date:   Fri, 14 Oct 2022 15:16:01 +0000
Message-ID: <DS0PR11MB63732F6E4B35CE11C9963521DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221010220538.1154054-1-vipinsh@google.com>
 <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB63735576A8FBF80738FF9B76DC249@DS0PR11MB6373.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW5PR11MB5859:EE_
x-ms-office365-filtering-correlation-id: 71e34efb-14b3-4ae6-e35b-08daadf70137
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lsc4D1sifHYBKQVJnwhaa6ONOiCZB8+w/FXg3WXaP2yLvi6sNaxZpIr46INlf36UvMzkHzvIXiQ57JninW8tzXT8G634y0RjTXjH8VNN2N9Ai1GEIobFvG7orYrlQIUQ2iKq4l4MdWxN9FhVZuZESIF/+eq6D07n4gxR2cd0NJyVhEmEKt2S1BzGd7v9GThG6g5qX6kb2brp8Fu5HUDWFbSx3233i0T9Tpq3wy99po6XquMzR/KAUCMo1Ydj8o5X8zoA0iR5s+S2Vd+LWkt70NFKdAA/WBiwNzUfSQ3xhQ3tmTeLG7cqAuSmE8w531ZlN5fCAFLjHh5sbWa3cDRknKmrImKcjx/h8x/FLmPQE06XwdW9SyHXrcsdM2PWD6wiVgxyrOEzFEVJncpN4Bqe3+EouYI1yaAK2sVsKptUa+9yhTEtAMYo0Po/CFdTF6XJnMS7Z0kBnVH9VXL8JBDOSaMfOL1N8F52gILv7Q2vJahu46uWW66NsavGlJtTtw7qz7GRPSgvhJFq9/MnBlgha+XXHAeBFm95o1wKrxtYHu92ud1Q0rqLk+Q4tJPCFliHHmqth8ct2lHOEq4vDAT8MFxheKOZRCpxZ7Zf4+Iq5xH9QW881I0OEt3fbQblQhXjJd7TQz1RZeJ4gKd0lNLrS0SFEUheAQkmVh7a7YwYGlArmXxwoiojvhlkoc/0mevKSggf6CNrGwDFhC5+O45ffXxnbLE0RaoQWYmSMxDaJ7mCmjfz9TLCjz1pnRcNsSwWiTcFZSJL70M5gsqPwR4t8aH+LcISWRxKh0iSYYytdgk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(9686003)(26005)(7696005)(6506007)(2940100002)(53546011)(186003)(52536014)(2906002)(5660300002)(55016003)(110136005)(54906003)(316002)(71200400001)(478600001)(8936002)(64756008)(66476007)(66556008)(4326008)(8676002)(41300700001)(76116006)(66446008)(66946007)(86362001)(33656002)(122000001)(38100700002)(38070700005)(82960400001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXFlVXdNTVIyV1BDQU45dkFNY3lCbXZWSW9yL0pWbXFnd09HS1RlRFBmcGNa?=
 =?utf-8?B?aVN4TXB3YjFmNUdxSEptcm1zKzhCSWg1UGx1WjROVXF1TlF0UzZQUjJOZG5L?=
 =?utf-8?B?Q3M0K2FBclJUTTN4R29OS0kxdXlJK2JKRjBhc2hXN0UyaFEwemJSc3ZTYWxQ?=
 =?utf-8?B?WUgvYWJ4WUswMW5FTWNHeDduU2RwRFlGZEd3RDg4MnhpWkhGZ3EzTGhUcTJM?=
 =?utf-8?B?b3YrcnpjcUxuR2VleGIwUmVxd2VzblJWMWo5STkzRVRTTDBhSjVXVUk0TklO?=
 =?utf-8?B?V0lMQXdPZjF2ZU03T29TOUlheTlpb0dac1RhdUE2S1Z1eXZlbjl4eW9tU2dp?=
 =?utf-8?B?cTB0RUVMdDErREVYc0Y5VzFhMElEeEZjaVhPR1MzOGpEeGw4b25DSVRQdmg3?=
 =?utf-8?B?ek9lVFl2QkUxcmlHZ2M0ck1ZT3d2QzJTeEZKS0NzVTRIM2h6Rkx2dXhxYXBw?=
 =?utf-8?B?TVdTR2E5UGQ5SWZtcFk3U3BIR2pMcDFtZU96NmFYV3p3NGIrUEJUWHZwUkgv?=
 =?utf-8?B?RXVWbGRCQ2oxOTFzYnVWN25jTjh5L0poT0VQTGgzQkNFVHNtd0lqajZkVTFN?=
 =?utf-8?B?R29Fd3FrSnJGMUdiNTMxSEgzQXhLQkRyY2pyU2dGSm5SNUwyUnB5UzQySDVh?=
 =?utf-8?B?TW03Y0oyc053NE0vWHo1ZThXakUyZ0NzZDlmakx1MnpnM2kxUkZEMFdhM1pm?=
 =?utf-8?B?WkVQbXhOekdORFJoYURPNHpWaklUbm5la1JYQVBUMjFjcHluSEFneS9BcG52?=
 =?utf-8?B?ZndKalJDTGdDdHpibXg0RlRIcElsWkpvQm0rb2JIenFHdS83enVaRm5wb0lh?=
 =?utf-8?B?ZTVyaUJLcEhhYnVpUUZncnRURkZMbVZOcW1FZmVyVTUxTEhUcDhxaWU5WWtD?=
 =?utf-8?B?SmFHdGRueHphSUZ6c0dFbkhXaDNFZ2lpWFZHZmFVRklxS2I1S0NVcGNNbDBN?=
 =?utf-8?B?aGczOUNRN2IwR09UbmNXYXRzZ3hPN3RieXV3d3VzZElXVFpZMzZKRklING9S?=
 =?utf-8?B?cUMreUY1amwrM0lxRVZGMC9tWGUvMjRwUTFyOENmRitEbTE3bHplbmFDZWw3?=
 =?utf-8?B?eHVPNm1kZkVJN2VqRnNkRWJWVi9TNUhyMmJCRVNCL0RUS0krTWtOOU9XTmR1?=
 =?utf-8?B?YWNrSnZUS3VncmI3NURFbHhwUXI1SVpOVGE2ZHhDaFI2UnZwUlgyYVVESExP?=
 =?utf-8?B?ZHVKc0IyNnJheGVyQURaRXNSVFk1OHdXSXJTVTk4Wk5HZFdEdzhSUDduaG5r?=
 =?utf-8?B?V01uNnRNRlpUYmd4K1NyTUIzRmtybENEQUYxUzRvVVJjb3l1NVlhL3VUVDNp?=
 =?utf-8?B?YktBQUpJTHM1ZEZ2bDhjd2RnaFVVSmxUMFVlcG4xY24xazBJd2pnbk0xYXJK?=
 =?utf-8?B?VkFIV1c0NzZiQjNZTmRySThGbVcwelFseGpQeFhvTjNmNU5BV1RuVkRwMzRM?=
 =?utf-8?B?SDZibEdiVm02ZDM2SWF4TmtsVmMwZ3pTUUErNW1YQUtOZ1FENHl1UGNZYll5?=
 =?utf-8?B?YUt5Qm11a2tWb1dSQ2svR1ovbHRSZDBVMHlkcVJMUkMwai9vRWRqTzJPdFB3?=
 =?utf-8?B?L2FTUzg1RDBVWmpvWXI2UWo2OFo4a1dSUXFSNFB6VzFNa1ZwYjgrRnpSTnhY?=
 =?utf-8?B?dHA3eFZTUGxoRFRsMXVLWVlEZnR6dWh6RTlFdDVOT0c1UUNPcjR3amRQM2FB?=
 =?utf-8?B?YVYyZmQrN1VTaitDUUdKRkZOQkhBbnlNWXlPYjdLemVEamRzMXR1NXJQYTEx?=
 =?utf-8?B?WWhJN3ArMmNWK3dLTVBYWit2WVhicWtLKy9DSTFTeWcvSG45MVhHK1dMQTdL?=
 =?utf-8?B?UkpTTjI4YXVwdEhlS2s2Z3NpNC9SUEV0MEZJOFF3MU1aZlo2RndqM3pvZENa?=
 =?utf-8?B?TGNZNmphM2pta2wxVXV3VG5VczhCZElQZHlUZk5lS1prRGlnUWFTeVA5bGdp?=
 =?utf-8?B?WEoyV1FVcTRKWGttTWRzUFNIbm1sNjYrb3g4U0Q0RDhPUE15UlBWdTg2eC8z?=
 =?utf-8?B?aGpoTDduZmZqdVRNOGxCQnhteEpUS0wvN1dIbC9tOVFpV285dWtuQ0ZSN1FQ?=
 =?utf-8?B?emowWGMxM2NOMW9ld3QreXl6T0dHNlRVOFAxalgyeGFVNXJOMnpaMXhWWklN?=
 =?utf-8?Q?YbHMugfmovwwNiftDq3qUrTT0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e34efb-14b3-4ae6-e35b-08daadf70137
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2022 15:16:01.5157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyVwXObH1IIXOBYcvDPjG5tCBXS3lkB5s4e+Bc3r45S5qgZ7mXNfSCF0KQ05CzGWkh2W55ctlKH5wTnzvzG7jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5859
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBPY3RvYmVyIDE0LCAyMDIyIDExOjEyIFBNLCBXYW5nLCBXZWkgVyB3cm90ZToN
Cj4gT24gVHVlc2RheSwgT2N0b2JlciAxMSwgMjAyMiA2OjA2IEFNLCBWaXBpbiBTaGFybWEgd3Jv
dGU6DQo+ID4gUGluIHZDUFVzIHRvIGEgaG9zdCBwaHlzaWNhbCBDUFVzIChwQ1BVcykgaW4gZGly
dHlfbG9nX3BlcmZfdGVzdCBhbmQNCj4gPiBvcHRpb25hbGx5IHBpbiB0aGUgbWFpbiBhcHBsaWNh
dGlvbiB0aHJlYWQgdG8gYSBwaHlzaWNhbCBjcHUgaWYNCj4gPiBwcm92aWRlZC4gQWxsIHRlc3Rz
IGJhc2VkIG9uIHBlcmZfdGVzdF91dGlsIGZyYW1ld29yayBjYW4gdGFrZSBhZHZhbnRhZ2Ugb2YN
Cj4gaXQgaWYgbmVlZGVkLg0KPiA+DQo+ID4gV2hpbGUgYXQgaXQsIEkgY2hhbmdlZCBhdG9pKCkg
dG8gYXRvaV9wYXJhbm9pZCgpLCBhdG9pX3Bvc2l0aXZlLA0KPiA+IGF0b2lfbm9uX25lZ2F0aXZl
KCkgaW4gb3RoZXIgdGVzdHMsIHNvcnRlZCBjb21tYW5kIGxpbmUgb3B0aW9ucw0KPiA+IGFscGhh
YmV0aWNhbGx5IGluIGRpcnR5X2xvZ19wZXJmX3Rlc3QsIGFuZCBhZGRlZCBicmVhayBiZXR3ZWVu
IC1lIGFuZA0KPiA+IC1nIHdoaWNoIHdhcyBtaXNzZWQgaW4gb3JpZ2luYWwgY29tbWl0IHdoZW4g
LWUgd2FzIGludHJvZHVjZWQuDQo+IA0KPiBKdXN0IGN1cmlvdXMgd2h5IG5vdCByZS11c2luZyB0
aGUgZXhpc3RpbmcgdG9vbHMgKGUuZy4gdGFza3NldCkgdG8gZG8gdGhlIHBpbm5pbmc/DQo+IA0K
PiBGb3IgZXhhbXBsZSwgd2l0aCBiZWxvdyBjaGFuZ2VzOg0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYi9wZXJmX3Rlc3RfdXRpbC5jIGIvdG9vbHMvdGVzdGlu
Zy9zZQ0KPiBsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPiBpbmRleCA5NjE4YjM3
YzY2ZjcuLmFhYzU4ZDFhY2IzYyAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMva3ZtL2xpYi9wZXJmX3Rlc3RfdXRpbC5jDQo+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPiBAQCAtMjY0LDYgKzI2NCw3IEBAIHZvaWQg
cGVyZl90ZXN0X3N0YXJ0X3ZjcHVfdGhyZWFkcyhpbnQgbnJfdmNwdXMsDQo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB2b2lkICgqdmNwdV9mbikoc3RydWN0DQo+IHBlcmZfdGVz
dF92Y3B1X2FyZ3MgKikpICB7DQo+ICAgICAgICAgaW50IGk7DQo+ICsgICAgICAgY2hhciB2Y3B1
X25hbWVbNV07DQpUeXBvLCBzaG91bGQgYmUgInZjcHVfbmFtZVs2XSIgaGVyZS4NCg==
