Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8BD7005E4
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbjELKq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbjELKqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:46:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503697A84;
        Fri, 12 May 2023 03:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683888383; x=1715424383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BCO4IKCMx5mABQw+ZJ5/FWQl70i7wXJO1U3Q/vywzyY=;
  b=ZFHi9e1uCgpTewkfbaVERj7fnwPpZibKnmkFcru8Gnnh4MKSIHc4sJ4W
   eWdd3KqHAK4QAik0FAj0mreFmqanxgUyhdBAvT8pc85buVWH91nK6L2Qm
   NTRRon+XaNO+1qnr9wpNDpZKvwnxfBUh4PtPh+9VXSFMnn5fNgTp6fInH
   x2ARg/PwkbzUnJ10srPIlLsSC32rjg9M+HaAMSS5MjtFhc81xGg6m3RyP
   qp66vlTmQF7WCsvSF/7yvS2ajX27DzKdW4seK8J+2GNd/qBys67uClUQ7
   8ZRS4WWdx+XeuZC2vG9b1R0V8Mni+eIBI9Z/nDwNt5Ipl5QDaIMj2v0k8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="378894889"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="378894889"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="874354660"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="874354660"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 12 May 2023 03:46:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:46:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:46:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:46:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:46:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fzR6OsTOrse26JxnqWnkDFdgjQkt1Lk48nP5eoZoRDNWrg5nXX4G/iLc3WBV1EAiVHPbAu0rSfdGV2vO2vraj+/kmvnbwE/sNn+0jKGmyTdbf/Ec4qt1eLqDZ9pB6me/TbmOIhTs68qg1PxyY5OxunQK1DDh/Nfo1yGfxqtLmlUxpsBxT/WxPyz2LStWclfKekIBiPjCGIRSlvEXy3M3XItZdvvSiecY7JmDBNlz2znzFifvgjz+qr++k6WsxPudPcTBKHObv6UfPDTXb0XQ0BuI4uHYeUfGVN/tlilGCSeljFyUWdjMZXGOkHv2mNa+XD2Hsfl5SmfpXsdyrDPLEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCO4IKCMx5mABQw+ZJ5/FWQl70i7wXJO1U3Q/vywzyY=;
 b=Jwf2dfCMbCb7viHs8HkQ1jGWtgZ2MKLX9Z1Tm5+2u65WomvrZRkFQGPHBoWkw9rOyfpnqZtdKCp3jjY9tFelrTQ8rHo8DV+DuxCsQGJ2cWNi67Dg+77K77syEYPQ+c3zyXU3Hh58JTlZNXVf3jEaT2vGOt9mrOW1hugQfXqd98dIK6VBa6KbhxeGBYfQhakiIDNuq6rcM929h1ldgWcaR6c8F/sYV5Zu9/awFaBpeC8TxWICq5UxgmjbKFDTgYFwzI8eCKk2WcTkDZy4UCPEAps0qaxszWVsQe1lIG5RG2YS0s/6kV0MMlt4G4tsjElhtw/jme6zNrBYqSx/68kDfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Fri, 12 May
 2023 10:46:13 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:46:13 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 7/8] KVM: x86: Make kvm_mtrr_valid() static now that
 there are no external users
Thread-Topic: [PATCH v2 7/8] KVM: x86: Make kvm_mtrr_valid() static now that
 there are no external users
Thread-Index: AQHZhGEdlGGNQtdNSkezDCzVUT9rw69WdSoA
Date:   Fri, 12 May 2023 10:46:13 +0000
Message-ID: <918864112f3b92ee751ef8860e536103d42dcfef.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-8-seanjc@google.com>
In-Reply-To: <20230511233351.635053-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6805:EE_
x-ms-office365-filtering-correlation-id: fef7318d-5c11-4c20-101f-08db52d61b1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /kCzKpuTXJBMPjx8Q/O5lsr3OSiv53Wa8Iq0ZJyzwLi4EqT2loehUNkTvNAMoEVq7KuKG+9eTfT7CA5OQOFyEkbtcmNSVMNsKIolOuDTAGWmKpSDmgbqNZIX1WDPj8qkiVBQVfPfPgn8wdPe0T/bUylu4SPYEF5uy7Ypuc/8zC5pt/tdBA4Oz65eEK/yBdUJMsuYqluO3QHK9zT5WGTmJv1oe8oEonlwG5VJEtYcjq81i/G+I0SAMRpzEiKNA7Xh9FQheUfVY5SXMnfywKukCF4xvkWyMRENj7JFCrHYCQ6QKPz3vQPfRhHEX1S5Ys3jL8DWka9J1yWKIbb2/BvDXUhS7pvF8pgTkPtY+6On/SepLg69mpf8HBDmIrK8HgFJLe5UUb2HdrLaRE45EOwsUIHrz68UuG3nBHLQwbH5qnDeRs3VuTVcruIs1SFNL+K+l3tvR6v2GCoJYbWh3fTbu1eWxtEnxjkuyPNj8msj1CJ/n0LqihyzkJ/ODTOMylXpWH35WtEh8nbsN561hRdU2MVz/h6vjohrxB6QEaOBa8krup8/Eus+JeXFFuLRfC2UI9FDhf2p0fqbhSQsEWkh/MxovHT1hj4dYQ5zGAIcO/jE57OAqDqdw3yWQboRePQto0Ku0nQivaytei1BpecrY5B3eC563eT97YN+oLMeQyb/nlvP8piosQnG8ErhxPzf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199021)(76116006)(66446008)(66946007)(66556008)(4326008)(64756008)(316002)(66476007)(91956017)(478600001)(83380400001)(122000001)(41300700001)(82960400001)(110136005)(54906003)(2616005)(38100700002)(8676002)(8936002)(6506007)(86362001)(6512007)(186003)(26005)(38070700005)(2906002)(5660300002)(71200400001)(6486002)(36756003)(26730200005)(19860200003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzlNMm5HdzZrdFZyRFBnVUpXNlV0Vlp2TEVSQ1FrVW5KUFFxV1ZyNVlrUzh4?=
 =?utf-8?B?Z3JRVTdZTEZ5cUViS05JZUtvcDB3dllpZVJTVzNKTC9SNW9vSjNtTExtT3ZY?=
 =?utf-8?B?L0JkNE5SWFk0UnMzUVNLNkpXMWtPTnhZTithbFJHWTlRVFExeUVaYUJpL2VL?=
 =?utf-8?B?cVJ4MXJwMlZjYnN2RDRkcUlnRzlodncreW5yZFFSWk45SG9peFhaTEt2WDFv?=
 =?utf-8?B?cVZiczF4bFJxVTIrU2gxbFBPaXUvT3VLOCt6YTREWkdUUnNSNW43a25GSHZn?=
 =?utf-8?B?Sko1cjFSUFF5dVFGRDNiRUtJdlp4ZXQ5UStLWm1KcmVNQ3YwQkQzZFBkWFhZ?=
 =?utf-8?B?eGw1SE1BajhZOXphWlhGcmhLUjNhOS96RjVqL0FqQ1VHVUlvdGdaSmJMbk9P?=
 =?utf-8?B?MEdPQlY4NUkwMFVYS0FhK01Uc3RKVm5GY2J4eGJLRGlmTlpPNlN3MGVVYklw?=
 =?utf-8?B?YXpOelBXUTUwSWxwcFlwRVkzdzFEdHdXMW9VL3UzbURscTZLUUxtMllXWDA5?=
 =?utf-8?B?aURLZUNCQUV6TFdsWjVaUkMydm1hSWJIZ0dvOW9XRWd6NElZTGI2NjV4MUdK?=
 =?utf-8?B?UDZuYTIveTRiWXA1SzdlQys1QWh4SXZobGdSbmo2S0U4b1FmdHVSbGNtTTdq?=
 =?utf-8?B?RUFQYlh0ZWpNUWc0UGk2OXNuOWNkelVUYVluKzd6eEhERFJ3NUdsU2xYLy9L?=
 =?utf-8?B?cW5meVI4SmJ3ZnRZaWJUZ01jUXFuMDNmRmRaN21DVjI1V1piYXd3UmVrL3dD?=
 =?utf-8?B?V29vNUR5UmZ0ajI2VXJXYmY3emRHbmZXTGx0dWZ2aEVudTdLaVI4K0xKNlRt?=
 =?utf-8?B?Q2svNlUyeGFJRC9zZnVuOVRNMnRRRllVUXhvL01oM2ZHeWxQY3pFY0lVbXBV?=
 =?utf-8?B?Nko2dDJBbURFT0RURHVDc1FsQ2ZBRzQwL0E1ZVVtVHJCQjJpdVhQZStoQzdC?=
 =?utf-8?B?SzFrbzdscVloZUVoRmJsODhDaVA2Q3VqSjlBRytVRUZ2NUpGMGFqUU90eW9t?=
 =?utf-8?B?MWpGekE4L0lpbzVTcjZjNnNtakZvVUZBNzN3STR3Y2w4dGxtUWN6M2Z1Wm40?=
 =?utf-8?B?bkVxQnN4ajd2MXNXbkNIb2VHeEhFS1dUUGVnbXI2WnhHRThPbG44SlhrS3JP?=
 =?utf-8?B?YmVRWFpVUXg0Y1VrM2lXRWl2NFhsYkcwaitKUFg3YUN3U013REVrTC9jOFNS?=
 =?utf-8?B?R0QzenlWZmdEWFZEaU5aaHQvUnIyWTFRd3NOSVpZYmRXYTRROW54WjBQWENF?=
 =?utf-8?B?eDBBWmVUMG9KRHdQakFOMzIzbk5ncVhtUk1OR01sTStSY29GK0RUK0pwZ3JM?=
 =?utf-8?B?RUZnbVJIeVBYempxMm9PR0dFM1JYdGNCRXBIVTdCSnJUbW9aVHBrRDlDaUh5?=
 =?utf-8?B?eno0UzdNYnBmZk41azEwUitBaEpTaFg1RFdVY1lyVkZlMkFDcVVDa1JzV0FQ?=
 =?utf-8?B?aGlyVGErQnc3QTRFQnRDRVVNSkw5eXI4THZhS2JqT3l0d2FpdWpsR2lkZk9a?=
 =?utf-8?B?VXgvZVNZNWpjdUhvcHdYTmU5UGVZaDJhN20yMGMzSm5GVHY1WDUvdTlBVHNq?=
 =?utf-8?B?NXFGaS9DeGJnNXNRdTczd0puNzRrR2dsaXNuaURDeWlBeHhaZDlQUEh2NWN6?=
 =?utf-8?B?QkQ5Nk8xMmtjclBnVXBpQVJ5cmI0MjczQVlWOGZXb1JNMmxCeDZtU0RhazRy?=
 =?utf-8?B?dU1UNk52emVyRG9TUFdiUWprekZ5dHA5SWdnbGs5UWJSTXpBcFRNQWdzWmNP?=
 =?utf-8?B?MXFJbmJqVlV3VWtsdFBCMUEzNEtGQkxaSnFua3lkTUovNW5ObUhGVS9aSmVu?=
 =?utf-8?B?T0VQS0ZQNG5OQjVMTUx0NWxmYndMY2FmZ3k0Mjg2Uk4xK2Q4MG1CZVppWlhQ?=
 =?utf-8?B?S2JRYVh1ZXZyTmJlRktXY0pvZFhQZVhscFNwQmh2TWtMN0p3ODNkUnhoSFp4?=
 =?utf-8?B?SHJ5Z09jbnBsazVnVlFwQUFhM3VkckpZYWpGczJWWDNCVlU0VVlTeGJXNlNB?=
 =?utf-8?B?R3ppeG4wS0V0Z2JrQVlRM2V5REhzd1dIMHN4NktQR09SM25zTWJxVnJJOFlU?=
 =?utf-8?B?S1dVa25iSUFQOWxVdFVVZ3Z0SXNpbU01em56czZqZWRzcm4yNTBwd3FoMSt5?=
 =?utf-8?B?Qk0rL2hsRGhzSG5naUI3S3ZDa3lYNmdSNEU5MW4zZzNYQVpNV2c1SmdGak84?=
 =?utf-8?B?U1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91517F63F8EF6C40A7A6861FC33F6E68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fef7318d-5c11-4c20-101f-08db52d61b1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:46:13.4272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r3SnLLm34zED2C8FWvnRN5PdPrviazPM3X/P9hgVRgdXOzQrGHo66qSa5fD0Fag6mdYsVcXGpFYOjXHp4cTJNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNYWtlIGt2bV9tdHJyX3ZhbGlkKCkgbG9jYWwgdG8gbXRyci5jIG5vdyB0aGF0IGl0
J3Mgbm90IHVzZWQgdG8gY2hlY2sgdGhlDQo+IHZhbGlkaXR5IG9mIGEgUEFUIE1TUiB2YWx1ZS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUu
Y29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQpO
aXQ6IGxvb2tzIHRoaXMgcGF0Y2ggY2FuIGJlIG1vdmVkIHRvIHJpZ2h0IGFmdGVyIHBhdGNoIDIg
KEtWTTogU1ZNOiBVc2UNCmt2bV9wYXRfdmFsaWQoKSBkaXJlY3RseSBpbnN0ZWFkIG9mIGt2bV9t
dHJyX3ZhbGlkKCkpLCBhcyBhZnRlciB0aGF0IG9uZSBpdA0Kc2VlbXMgdGhlcmUgaXMgbm8gb3Ro
ZXIgY2FsbGVyIG91dHNpZGUgb2YgbXRyci5jLg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL210
cnIuYyB8IDMgKy0tDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmggIHwgMSAtDQo+ICAyIGZpbGVzIGNo
YW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS9tdHJyLmMgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+IGluZGV4IGNkYmJi
NTExZjk0MC4uM2ViNmU3ZjQ3ZTk2IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbXRyci5j
DQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tdHJyLmMNCj4gQEAgLTY1LDcgKzY1LDcgQEAgc3RhdGlj
IGJvb2wgdmFsaWRfbXRycl90eXBlKHVuc2lnbmVkIHQpDQo+ICAJcmV0dXJuIHQgPCA4ICYmICgx
IDw8IHQpICYgMHg3MzsgLyogMCwgMSwgNCwgNSwgNiAqLw0KPiAgfQ0KPiAgDQo+IC1ib29sIGt2
bV9tdHJyX3ZhbGlkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEpDQo+
ICtzdGF0aWMgYm9vbCBrdm1fbXRycl92YWxpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBt
c3IsIHU2NCBkYXRhKQ0KPiAgew0KPiAgCWludCBpOw0KPiAgCXU2NCBtYXNrOw0KPiBAQCAtMTAw
LDcgKzEwMCw2IEBAIGJvb2wga3ZtX210cnJfdmFsaWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1
MzIgbXNyLCB1NjQgZGF0YSkNCj4gIA0KPiAgCXJldHVybiAoZGF0YSAmIG1hc2spID09IDA7DQo+
ICB9DQo+IC1FWFBPUlRfU1lNQk9MX0dQTChrdm1fbXRycl92YWxpZCk7DQo+ICANCj4gIHN0YXRp
YyBib29sIG10cnJfaXNfZW5hYmxlZChzdHJ1Y3Qga3ZtX210cnIgKm10cnJfc3RhdGUpDQo+ICB7
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmggYi9hcmNoL3g4Ni9rdm0veDg2LmgN
Cj4gaW5kZXggYzU0NDYwMmQwN2EzLi44MmUzZGFmYzU0NTMgMTAwNjQ0DQo+IC0tLSBhL2FyY2gv
eDg2L2t2bS94ODYuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmgNCj4gQEAgLTMwOSw3ICsz
MDksNiBAQCB2b2lkIGt2bV9kZWxpdmVyX2V4Y2VwdGlvbl9wYXlsb2FkKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwNCj4gIA0KPiAgdm9pZCBrdm1fdmNwdV9tdHJyX2luaXQoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KTsNCj4gIHU4IGt2bV9tdHJyX2dldF9ndWVzdF9tZW1vcnlfdHlwZShzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIGdmbl90IGdmbik7DQo+IC1ib29sIGt2bV9tdHJyX3ZhbGlkKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTMyIG1zciwgdTY0IGRhdGEpOw0KPiAgaW50IGt2bV9tdHJyX3NldF9t
c3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbXNyLCB1NjQgZGF0YSk7DQo+ICBpbnQga3Zt
X210cnJfZ2V0X21zcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiBtc3IsIHU2NCAqcGRhdGEp
Ow0KPiAgYm9vbCBrdm1fbXRycl9jaGVja19nZm5fcmFuZ2VfY29uc2lzdGVuY3koc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBnZm5fdCBnZm4sDQo+IC0tIA0KPiAyLjQwLjEuNjA2LmdhNGIxYjEyOGQ2
LWdvb2cNCj4gDQoNCg==
