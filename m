Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ABD72A080
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjFIQqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjFIQqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:46:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D70F5;
        Fri,  9 Jun 2023 09:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329207; x=1717865207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wFMJJs+TTbMfxr89eDhTjk6NgyRsBTe39RfG1WvlcIo=;
  b=kBD3VI5H/D8xO6/coywWFsytoOvM2/rJMelXN9WZcrUK6GQdnX2KH2DF
   4+UoYEvQMI7DTaFPtsVUgMRMkzvB7dABDAwMK3PXzWExw3jIETefGOoiL
   dMEfZlLnAFELf58lueODImvHwGB7MI4J54ulRlEovj3+/9qo1JRT1fVvW
   1fWy1XRsLINy3ZF7ezUlBKKy3dCyZgZ4JMlqXD5LUlDMh9lEVDKNxte2L
   T+4shD9xcARlzykulAMoHrv1mQaxi/a0v/444NmRT9LndmPKX9jI77QyN
   ElDeAgS0dchm82PcVD7qpCY7FNI0skk+JB5WAdvU7wqhVbWLziK+F9ZPa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356531077"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="356531077"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:46:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="780377410"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="780377410"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jun 2023 09:46:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:46:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:46:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 09:46:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 09:46:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnhI3eaJ3uHcJa6K5VLXwHVB2MLTygo/83E78cUhpM8Lw0TD/mplhWs329gVDdsVkZmz43r6goX5P6bGYiDgeUFO2CEYcKq6cTBZ+dd7ON/lvwT38VGemICJRSF6hqKRWghgAbJcl2JwXTe9JLmeB8VYf8v4UhL1EwaQb3IzpCicddsEaSAChnecFVK4YPQ5bCK25tOiA9axfZmI6+x8oaqt5Dy5LwcFcJptAP4yFdrYRb8aNaj5LRecpxUZ8jHN5Z74jBTjPAl4h3KnbyYxYgT6k7IMgGlNsm4/WCmf7JLVloO6QJ6hgieGzMTbHg/W6Wivx5W4AoPNrJFJc2CMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFMJJs+TTbMfxr89eDhTjk6NgyRsBTe39RfG1WvlcIo=;
 b=GPYQ9HSA2Szia2DQSl7SDayatbV8zmXlHE4IsnroJO8UVsBWfqHK3FQDnzMH/wh5XT9sV2sUyR4c3HZ5ty13bps1BojtcXBTf9+v02jRP2+RcqfFLZfNOFqLvu3trOCHeNseyKvbXasfOXs0yCecni2MWjPF2RiA6pbllTszC9ZPqhsQ4l1IAg3tzCSYp3o1frMqukdkLgnL7scS4IDhROiqHsvXf/fy/DyFNWUN/VRlDznIGxarbVuHfk/oKNU2AY8lmjMG3PrObb6hBlD9qoHQNLQGhl1uWBR+GnSKIVUtn1vRTLLs1TwxkesWP0MkHs363riGM1HZZeeCwvEs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 16:46:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 16:46:45 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "john.allen@amd.com" <john.allen@amd.com>
CC:     "Yang, Weijiang" <weijiang.yang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Thread-Topic: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Thread-Index: AQHZjlgZ1tFS5gCtHUqRoMcpmbTaTa9prHeAgBkGeACAABRQAA==
Date:   Fri, 9 Jun 2023 16:46:45 +0000
Message-ID: <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
References: <20230524155339.415820-1-john.allen@amd.com>
         <20230524155339.415820-7-john.allen@amd.com>
         <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
         <ZINGaJnNJ54+klsD@johallen-workstation.lan>
In-Reply-To: <ZINGaJnNJ54+klsD@johallen-workstation.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB6893:EE_
x-ms-office365-filtering-correlation-id: 5bfd2cf6-1717-4ca0-69a5-08db69091c55
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VIi0ZdtjX5pMSubR/LZY6N1HQ+P1Z/fb59QAPIzpq1UpHCJClZUISRiTrRIkPHrmJqPeoDkdjf4F07KpfYUTcPAwrj13BcL1NDj54Jrr8nZV/NPvX+jKtg/dLcUZc2nmjyLdDtqErHDmpb5yGzigqKgRELTfjlklxsdiFUbliQVA54zr1Lvao3u1sTduVb5N8h6WKW4z2s6+uu8CKYWJRE0I3H6thdNRwTx+tjyQ3bhW+tDJQOAzChKxrYH6nUZo3mhmkfT18YoudTUlA01SdLshuk9rXHygxUykMcK6Rq4ZPfInc74jrMnYvwcnN89c5UKRSs0/pMwA9GxzE5FF0gAUEBipfyfvIHvd0yUJz3sGiSjLegP1SAEKOObY08csjKy8e78pBog4+H3t3wPzJy32B9Vdig5uIkHJAbSZQTW1X90k6VM1c+7dyu7TUskv42sHYO7fMRIDNTz3xSayrXqc02kmKrm3yLz3TZL1G1FlEmSBuMFGUmC5ClEklkfrLlNrbxWo4erBG253wY7t15QEfPlFamoAW9zjRqSp5XnyTXY6idEdnWlTM0xarT+qLZ/ibZsssnu4i1Tq3r9Nv6qxgQEh4e/AjirHqoMe2ivH2cf2Od5+FL5VZYSHtwjw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(41300700001)(38070700005)(316002)(478600001)(83380400001)(76116006)(2906002)(66476007)(66446008)(86362001)(91956017)(8676002)(66946007)(8936002)(122000001)(5660300002)(64756008)(6916009)(38100700002)(82960400001)(66556008)(4326008)(36756003)(54906003)(71200400001)(6486002)(186003)(2616005)(6512007)(26005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODlTNHpRcXpSa0trRk1ISFE5ZU5xVnBaMEpPV0xMTlhhWk03dzUzdVM5c0la?=
 =?utf-8?B?THRaeHlqYjlHdmo2cWl6dCtjMlplbitoOU9HdFc4VDZSb0oxQnRWa2dzYnpK?=
 =?utf-8?B?Rmp5eGl0eWMvYVFuSUs4ME50UXVaL1dLK1YxQ1FLaSs0cXRKeFcvYW0vUlNa?=
 =?utf-8?B?RVg4WG12eHFDeElFUVVTV0daQ1AvLzZHdkg0cHJLMmVkVUxqNXV3S3krY2NI?=
 =?utf-8?B?WGd0cEdlK2tudWsyL3NPYlhtZk9tVHZJL1NaUFJiUTBOU1FwVk5NeXBzUkgr?=
 =?utf-8?B?aWs0eVZic3MxSUI1cFM0cCt4NC84eXpPMnNwcGVIYVp2NjRvWURxRTJudTd3?=
 =?utf-8?B?eDF6eWdTcUZYS09UbFdlZnNUaUwyYmNhb1owMjVubnoyTndlYUZFN2pMdkJC?=
 =?utf-8?B?RGh4UGhNNFpXaHVUeStENlJuUnpKdmRybGgzUHh4SDI0YTRiM3FpQWRVOEVi?=
 =?utf-8?B?bjRRR0F0MU5BSkM3c0JCT3hQd3NKZW5qOGFLektzcjVpdmpTclZsRTVOa3Jo?=
 =?utf-8?B?UFR6Q2hqbm1vNVVlUkJPVVNyM1ZiVWJlZE9lcFNNTmEvdjdGYVBIYUhVTGZR?=
 =?utf-8?B?K3FiVEFPTUZvcDNtNEttMkNYYzJSenN0VW41Y1o1MlZWdnkrY0xVWU5rYzll?=
 =?utf-8?B?UHFqTEFLV0l1V1BGVmRQY1VNSmpSR0ViR1ErT0o4TFVxNFY2TnVpRWlWbkFN?=
 =?utf-8?B?c3oxK0djUWcvVXRVQ1dlcnJQL3pqZUF1dUpoSEI5bmF2V1drUVBIcFZPK0d1?=
 =?utf-8?B?NFkwdHNtdW9XMHBPekYzcXNCclpFa0wxcHdkTzdqV2xrcDlhTis3NXRFbWlI?=
 =?utf-8?B?eHVCc0Y2RkFrQ0t5SEJBS3RGNUtKNkRvTXVvR3R3MzQ5SGoydDFBVnFlQ21t?=
 =?utf-8?B?a3c3akZzN1FXd3FUOXIwZmZlWGJiUklEaEp3R1NzSGZnMG54dTM5STNvdUI5?=
 =?utf-8?B?UlBuODdKTGxGZkU1VXc1ZjBoVHNIemlYV091eUQraTJsMWwwclVnZUhvcks0?=
 =?utf-8?B?Ry9Tb3h6cEhwbVN0d1ovdGR6LzBmRXpKMFZKQVBQQm1POUtNRHYwbFdmMXVy?=
 =?utf-8?B?TXNaQm5Rc1NubWQxRU4zMmNINFdMVFZqQitPVnB0UUlEWjdwcTVTbHVZUEhG?=
 =?utf-8?B?L1BxTW1aZzRKNkU5amZUSmhuZ3BxWGxFbWVSb0tIMUl2ajNoM0hVc09SSUhT?=
 =?utf-8?B?UkFUNVliYjdFbENlQ28zZXd5TmI0SmxpOHVDSWh5UmFEUElsZUxRc252elJW?=
 =?utf-8?B?OWVuV0xMMDB6cnZ3YU02ZzJpeEJqVlh3SFhBanQ3RUY5K0hlV0hub1hjak9p?=
 =?utf-8?B?ZktpU1hKZy94VnNmSEpNWXY3MDdJaHVZWkxxM0toV3R6Y2paamZKL2l2M1I1?=
 =?utf-8?B?QUpiQW51ZXkvZlMrQlRZak5aVHpNSVh5THpqYVd1N1dEbWJTNnY5QkRLc1Zj?=
 =?utf-8?B?SXdFak5VNkMrTjFON0NDUWJscVNGU0RudmVlL0tlMFh6TWF3QWc3TnpSWk44?=
 =?utf-8?B?Wm9hMkRaMmI3RFhHNzZoUjlBVnJlYjNycUJLbUY2ZlliQUZaRjJWUjIySzdy?=
 =?utf-8?B?KzhSV2tEZzVLV1R4VjdxZEdlZEZPR1F3Qm9FQjgrL2U2YWlrOTFPYVBPckVP?=
 =?utf-8?B?VnhXUEhoUjNYTTc2eGhFdnNBVjM5VWtPUHcwY2tXV0RHZG4xMDFlVnN3Q244?=
 =?utf-8?B?eVFNM3Q5SXJ4b0E5Wkw0Q21iOHNFQWd4cmRjU2pHcTg5WWxnRGtEeFk1U0pn?=
 =?utf-8?B?Q0t0OEVrdmZIZ3o5V21acEVvcVJZRTlTcG5NM21DdktrMVZQcUxJdUtKcG85?=
 =?utf-8?B?QWgvVTV1U1RaWXorNEl5RkJudGNaN2c2OEM0N1d0YXc5a01yVnVuekdnWEZH?=
 =?utf-8?B?V0d4OGd4L0NOR3ZpS1dUTitYakRMZ2t3WkhGS0NzaGFYemFlM2hka0FqMFJa?=
 =?utf-8?B?RlIyTUFPTG9ZYVBmTXBzNFZBbXRZTUxJTE9kYm05V0pDbmZiMFNRa3E3Ulhm?=
 =?utf-8?B?Zzg3RjhlQW5oR2hxRGt6YVJkYW9ad1F4N29sbDgxeVRJcEtTODRNbHk3TEtl?=
 =?utf-8?B?RW9QWUZ5aWFxQzBNdmlQT1Z1VG5KYWwyWWtaV3VHYStMYlpDaWc3SDB4Ylkw?=
 =?utf-8?B?NjJnbXNBKzF6bnNGSm81SUh3cko3MmpsTk80YjlGKzV0M2FyQVAvUlB5alg0?=
 =?utf-8?B?a2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9759B219E134F54E9670D7BFAF169E35@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bfd2cf6-1717-4ca0-69a5-08db69091c55
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 16:46:45.3969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGhug9ITqfRercF9lPAqbxkELN9i8tyKGvrFTBdLyX2hlwK8DPTEerMkUXhxtG5/acv3Qc7zpNNkjaeK0b79doqvGD4qXZzEnT6lu3FDjMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
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

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDEwOjM0IC0wNTAwLCBKb2huIEFsbGVuIHdyb3RlOg0KPiA+
IElzIHNldHRpbmcgWEZFQVRVUkVfTUFTS19DRVRfS0VSTkVMIGhlcmUgb2s/IFRoZSBob3N0IGtl
cm5lbCB3aWxsDQo+ID4gbm90DQo+ID4gc3VwcG9ydCBYRkVBVFVSRV9NQVNLX0NFVF9LRVJORUwu
IEkgZ3Vlc3MgYWZ0ZXIgdGhpcyB0aGVyZSBpcyBhDQo+ID4gc21hbGwNCj4gPiB3aW5kb3cgb2Yg
dGltZSB3aGVyZSBob3N0IElBMzJfWFNTIGNvdWxkIGhhdmUgbm9uLWhvc3Qgc3VwcG9ydGVkDQo+
ID4gc3VwZXJ2aXNvciBzdGF0ZS4NCj4gPiANCj4gPiBTb3J0IG9mIHNlcGFyYXRlbHksIGhvdyBk
b2VzIFNWTSB3b3JrIHdpdGggcmVzcGVjdCB0byBzYXZpbmcgYW5kDQo+ID4gcmVzdG9yaW5nIGd1
ZXN0IHN1cGVydmlzb3IgQ0VUIHN0YXRlIChJIG1lYW4gdGhlIENFVF9TIHN0dWZmKT8NCj4gDQo+
IEFwYXJ0IGZyb20gYSBtaW5vciBleGNlcHRpb24gaW52b2x2aW5nIFNFVi1FUywgd2UgYXJlIHBp
Z2d5YmFja2luZyBvbg0KPiB0aGUgc3RhdGUgc2F2aW5nL3Jlc3RvcmluZyBpbiBZYW5nIFdlaWpp
YW5nJ3MgeDg2L1ZNWCBzZXJpZXMuIFNvIGJ5DQo+IGluc3BlY3Rpb24sIGl0IGxvb2tzIGxpa2Ug
Z3Vlc3Qgc3VwZXJ2aXNvciBzdXBwb3J0IGlzIGJyb2tlbiBhcyB0aGUNCj4gc3VwZXJ2aXNvciBY
U0FWRVMgc3RhdGUgYW5kIE1TUnMgYXJlIG5vdCBpbmNsdWRlZCBpbiB0aGF0IHNlcmllcy4gSQ0K
PiBjdXJyZW50bHkgZG9uJ3QgaGF2ZSBhIHdheSB0byB0ZXN0IHRoaXMgY2FzZSwgYnV0IEkgdGhp
bmsgdGhlcmUgYXJlDQo+IG9wZXJhdGluZyBzeXN0ZW1zIHRoYXQgc3VwcG9ydCBpdC4gSSdsbCB3
b3JrIG9uIGdldHRpbmcgYSBndWVzdCBzZXQNCj4gdXANCj4gdGhhdCBjYW4gYWN0dWFsbHkgdGVz
dCB0aGlzIGFuZCBob3BlZnVsbHkgaGF2ZSB3b3JraW5nIGd1ZXN0DQo+IHN1cGVydmlzb3INCj4g
c3VwcG9ydCBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mIHRoZSBzZXJpZXMuDQoNCkhtbSwgaW50ZXJl
c3RpbmcuIFZNWCBoYXMgc29tZSBzZXBhcmF0ZSBub24teHNhdmVzIHRoaW5nIHRvIHNhdmUgYW5k
DQpyZXN0b3JlIHRoZSBndWVzdHMgc3VwZXJ2aXNvciBDRVQgc3RhdGUsIHNvIFdlaWppYW5nJ3Mg
c2VyaWVzIGRvZXNuJ3QNCnVzZSB0aGUgeHNhdmVzIHN1cGVydmlzb3IgQ0VUIHN1cHBvcnQuIEFs
c28sIHNpbmNlIHRoZSBob3N0IG1pZ2h0IGhhdmUNCkNSNC5DRVQgc2V0IGZvciBpdHMgb3duIHJl
YXNvbnMsIGlmIHRoZSBob3N0IGhhbmRsZWQgYW4gZXhpdCB3aXRoIHRoZQ0KdGhlIGd1ZXN0cyBN
U1JfSUEzMl9TX0NFVCBzZXQgaXQgY291bGQgc3VkZGVubHkgYmUgc3ViamVjdGVkIHRvIENFVA0K
ZW5mb3JjZW1lbnQgdGhhdCBpdCBkb2Vzbid0IGV4cGVjdC4gV2FpdGluZyB0byByZXN0b3JlIGl0
IHVudGlsDQpyZXR1cm5pbmcgdG8gdGhlIGd1ZXN0IGlzIHRvbyBsYXRlLg0KDQpBdCBsZWFzdCB0
aGF0J3MgdGhlIHJlYXNvbmluZyBvbiB0aGUgVk1YIHNpZGUgYXMgSSB1bmRlcnN0YW5kIGl0LiBJ
Zg0KeW91IG5lZWQgdG8gYWRkIFhGRUFUVVJFX0NFVF9LRVJORUwgZ2VuZXJhbGx5LCB3ZSdsbCBo
YXZlIHRvIHRoaW5rDQphYm91dCBob3cgaXQgd29ya3Mgd2l0aCBob3N0IElCVC4gUHJvYmFibHkg
ZWFzaWVzdCB0byBsZWF2ZSBpdCBkaXNhYmxlZA0Kb24gdGhlIEludGVsIHNpZGUuDQoNCg==
