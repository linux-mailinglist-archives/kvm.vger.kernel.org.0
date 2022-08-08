Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9720058D078
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 01:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244545AbiHHX0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 19:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244528AbiHHX0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 19:26:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EA46258;
        Mon,  8 Aug 2022 16:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660001212; x=1691537212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jeQ6gbebGY5Vz3fqLKLipvhtG0FbfPdUjZ5GmeJVubs=;
  b=GyTRXeK4RDNN0unVxM05UHRREQdIC+xvv+5Z+uqUWfDbjU50+6sGWDcZ
   ngKCl1ClSbdEQ1dv8sPpI4lB3JRpEZDDZAD8ikSPtXaW7AYiBhyKKQfRr
   oI6U1/uO2dOWWtSkH+CPIQKbnaVZ/MJq0BYZDkXX2kZ+FEF8Ql9VLPkfP
   fL/sbtAoWoKfYijjQTZJfvFZko4GZOOJ/nvXx9yVVdgOCVZFoa6nLOphP
   +Zx7Srpd0J5bqAATsiDEVuk/HXrdRoUI6iGGpgzqFRaD0cKchl2tSOfRX
   c1t/bkERd6mU727LnWJ4kUdUb6nWyKf8y4azReS/zVQrTWfViG0R1P7lM
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="270488083"
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="270488083"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 16:26:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,222,1654585200"; 
   d="scan'208";a="633102555"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2022 16:26:51 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 16:26:50 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 16:26:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 16:26:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 16:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DowRmJADrP+dwIc4lDxzy6vUiZS+Ic1A8fB49fw2OSrbHkgG3Vsx6JX+JtLzmQhOl2qaXqzJwNu6Ws6dBNkwoSZG3iUYQ7f9k/jXhWKEfQilPRGntMYKVHmQ7RL2kHdANUgScKNEEtfe9fvf0d7c9xsCvyFsj9tYH4jWsbLsAn2PGBRB37ebWQEwWws2XRes694o6eKbnwQzY3YHsu+BaIcGQs/Wtw82iV92/NvmSbKIJXQojCstPlwdMS3X8ayYiO9f5VjhhdHc54AwDtcvDeHBjVoPF9LuzNWTIfEjo33GCPrBAwU6FKZQ0UDMnfRqbeht6aVdWqJz3und7uBU+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeQ6gbebGY5Vz3fqLKLipvhtG0FbfPdUjZ5GmeJVubs=;
 b=RnhP3i/SCKlQ2DU3JoQgZA+m3/Y4qSuFph2ty2g7CxF6JdxgKz+FmoPsuNVzAuLgoDQzvYxdPUvhKq9c5lglMtywvwTN27iT3AvccnTuZBA5Sprx+9zDXUd4OItkrtvdn1Zg7Odgpsp5KMD98p5xCGqCpxXM5tfG8rGbkE9h7ZQAUNSU8/BxaFtaVqinz1t1P+EqsfIlC3JVHnMLCB4qCjy9yNryYgw6F0K6hssgUyH9j0wxNSAXJZZgXQnr17s3NND22Bg9MeqVsKdcX4Qw9HheLTm6ZM+WNZiB5vTkOZcamSGZu2zczImxZFA0mF91UFplRceXu+VjimaD3gKQ+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by BYAPR11MB3319.namprd11.prod.outlook.com (2603:10b6:a03:77::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 23:26:45 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::e849:56d0:f131:8efe%7]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 23:26:45 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Dmytro Maluka <dmy@semihalf.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Rong L" <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Tomasz Nowicki" <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
Subject: RE: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Topic: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Thread-Index: AQHYqQNV5DxKJST9sEC1NUps5Q8SMK2lqmdA
Date:   Mon, 8 Aug 2022 23:26:45 +0000
Message-ID: <BL0PR11MB30429034B6D59253AF22BCE08A639@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220805193919.1470653-1-dmy@semihalf.com>
In-Reply-To: <20220805193919.1470653-1-dmy@semihalf.com>
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
x-ms-office365-filtering-correlation-id: 55de2a9d-777f-491c-5cd3-08da79957560
x-ms-traffictypediagnostic: BYAPR11MB3319:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: REwVx41Z9yBt7kG+dW3OIdtgRiunzPEHIsDiLAdmacZQHE1NTzvNXuXh9a66I6KMjfYDcIiFgeKKwyEurASgEdj8F2FxxzbVFvkvNh4pCAPBOdbgGmwVig95XPJNnHKqFurbgK655Llmmh0KZD0xJcZv1bDCCJSW8aa7f8z8lB0PDhxnmX82trqizWlxWEpXmbG671X5s33xezmJbfp2OigOz4WQaDX2MU/dIAzE+olspiV/Llqk/WzN2fJERJST/+q5PEphCvonejgken4cVV/6ukUstvegt0ttueBjpqdDz3b5pGCb2oUbrb4PRpp9J6NozmBbzGXTfTtF0MG9lTaqEnXzTlHPj76vTBAa0hoyhsGVk8nA1w6kqhRii2hG8a5yJRdE4Bcd8enEaV4mMOWketX73wE3BerDhFWNwN9IffKsh0iFk5IjUT7A7ERcjfgHkEVkbqCAvacUNfyjyAWj4XVnBlCsZNA4ulK/5S+eFqTqUP3DI5V3Ju2UIBCdI4NKu6BF+xD5UzIMG4IzW+z7LimUUetVo91j9elswUZnzcGJSxsX98lsnsu0Pl5X47CkdMTIK5lIpcdak4IAKKJEpWIKYxeMBgUazyaVwaCpbTUCt+WpluzEEKWER4YewjYCPDJM7wax6qCwoTxyDEqVzfef+GfQUX7w/c08RIVwNFRXl4OinGrPeG3DbTnAA4vmA95nM9B5MgOcWYVVwHvC6SRtYCBvY8YqhR1UXAktHzsnfvSVdJGbrxliDo8iWtRy8ZnyRJo7iWnI9PXJvsRWpag8185xY7D3A9sCmsO9OvIsNFyY+FNsrSxGv2bl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(136003)(376002)(346002)(396003)(316002)(82960400001)(478600001)(110136005)(54906003)(38070700005)(122000001)(186003)(83380400001)(41300700001)(55016003)(71200400001)(9686003)(26005)(86362001)(6506007)(7696005)(8936002)(33656002)(7416002)(66946007)(52536014)(76116006)(66446008)(66556008)(66476007)(64756008)(4326008)(5660300002)(38100700002)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWVUTUJPYWFIS0ZKNklycGp6QjVTaVdVRTBzU2w3OUV1aHhqZE0vdzhWb1RS?=
 =?utf-8?B?alk3MWZQem9WUytEZXNKU3dNQ09PQjBPeXpZY00yNUxFRFdUUnBBM0NpaVRz?=
 =?utf-8?B?aExoV2RpblFJUldVUGdKTVhYWWVEdEZ0ZmNDY091a3dlVnZPSm5abC9CZ242?=
 =?utf-8?B?SExMNm45QzZmbVRxRWp1L1d4WWhlVFAvazdmRXhtTUwzR3FDTkhKc3lOblNG?=
 =?utf-8?B?a2tyZ2RZeFBGL1ZaMnVSK2xFd2hncVlhNnZZK0VSMGpnSFUrc1FmaW4wdm1E?=
 =?utf-8?B?amlhRzM1OUlJOVhYajZySGpWK042M0xKUHZtWWZKUng3d3Q2akxoa1VtMzVE?=
 =?utf-8?B?amZvcGFpd2x6SHB2bFBZaDBpY3RWTlJ3NHpFWXlKNVR4RXdSMVpNa3c3WGd1?=
 =?utf-8?B?Q2tmRVVGOVREYXdNQ3ZNMmxzUG9LZkloZkNGUFppdjVLNmxsZXhQV0hFTWNM?=
 =?utf-8?B?Z2tjUTFQejRmVEpJRmdpUThrZU01TnB1d0s3dFo3bGIxUmQyZk9tdUtjdis0?=
 =?utf-8?B?Nm1VengvcmYxV0did21SRzAva2JSb1RpbzliYXVNWlNCUGozUC9CcVk1ZXVw?=
 =?utf-8?B?MjhnMWpraU1CcUNiNEhpaDlqczJsRTRFSnV6TTg3dXZCQWhyVzFYMWp6cEFB?=
 =?utf-8?B?NzdJcUhCL0VlNFQ2ZGFwZmRMV0ZnSUFVNFhYcnUzek1PZFhZUThLS0NUTlpy?=
 =?utf-8?B?WFdWekFZc3NlRHFsUUVnRjdSYUVSeUdNTUNwSkV0SjAxd2NWZ0Q0RmZOUE16?=
 =?utf-8?B?dDhsV2liYlpjV3IxcjFtajJhZkVLWHhrS2hMVG5nU3ZJYmFBNCtTLzF6YU1l?=
 =?utf-8?B?ZUhHOUFIZ0p5TlFPT1VYaFc2S0NUbm9XejVZeVlyd2F5U3B3ZzVFbTdSZlNJ?=
 =?utf-8?B?ZzRkK09CT3puWlNWVVNQd08za1d3VWJIdExtSytoQ3I5SldNVFBoT2M4bDJ3?=
 =?utf-8?B?dGJyWUVxZ3FsZlk2VkRCU0V5UWgyNFM1NGxsY25tZXNSamUzWVJITURJbDg1?=
 =?utf-8?B?Y0FDZkN4Qkx2M1l4MGlpKzNWaHlkUVhBb1l3end5bWdpYjIxeGUzTDBUWjVD?=
 =?utf-8?B?cXhmWE95bzFGNzROM1U5UmJWVi9Bbm8zK3hmR1ZMUGJxRXIxTmZUVTY2Y0hL?=
 =?utf-8?B?eEU0M1UrSGhVTnMzRCtqcjFQYVZTdkNEazBLb2xTZ3dIZWFJcVh3amhJVTI4?=
 =?utf-8?B?Ulp4YmNCMmRwbGo3L2ZEbVV6TVBzOXVwMnk2MmtITUVDbzJpczhFT2F3SG9T?=
 =?utf-8?B?OFJ3blBSVkZLUkcrOXpzNkk3WmtrcHl1bHBXN2NCQ1d0Q25rMEdxN2EzK1hq?=
 =?utf-8?B?ejdZTmNiQWpUSmQwcUdkZ00zamJ2RTArcnlvMWUycmQ1Y091dnk4b1JDOUs4?=
 =?utf-8?B?NlZ1UUgzT0V2S2RXb2dCWDFqN2xtSFVQZDRIb3JwZmQraThIN1BhdEg3R2Np?=
 =?utf-8?B?WXdEa3Zjb0EzVHNaajJjNmcwYWFHS25nNW1CM2NoWnFnVkpWeEc5THc5QlJR?=
 =?utf-8?B?clYxL0phc2paKzVVaVNzaklQcExyZzFxd0tqWEt5STBmYkxGS1ZtaUVnOFBW?=
 =?utf-8?B?UEwzWVp2RWNKMk44SGdnT0w1dFd3UlVOdGF3YmJzazJWZEVUbGJrbndKNEhy?=
 =?utf-8?B?VFAwSEFjbmtpWTNkRzV0aXFLSi9COUFmalh3NmFPS3hOazV0Zm13R0VPOFcy?=
 =?utf-8?B?dVVjM0dFcjNyZmVhMkxTSEZDbHlRek5iZFlDeFo4YXpZS0V1NmRJdk5oT2d2?=
 =?utf-8?B?cGZVMGhUeXI4eWdTZ3FmKy9uQ3E1MGErR0RFV3ZQSjVDRUQ5MFl3cUE0T2M4?=
 =?utf-8?B?bThhNENlMDNubWRkSUIxWUNaM21uM2hQeEh5d1VkMjFCR1VESEppYmhmWlp2?=
 =?utf-8?B?dktEYjZSeGRKZWJhTVN2RkV0UzRQUWFLUmxKam14MDZNajRxRHRZMSt3S2V5?=
 =?utf-8?B?TEthUWdvekwyZ0ZDVFNMMW94OXNad2dOTGRud3hxTEtpeGVScDFUSWNNTEJH?=
 =?utf-8?B?eXJxdk1ZQi96VEt1R2RQcTJGeldYVWU2dDdRSHd5c1VPakxLS0RVVWRMbnRo?=
 =?utf-8?B?dUIydnYzbVFsbElDdmMySDlEUHh6aitlT0hZcWNQekcwWndmdXMvanhHN0RG?=
 =?utf-8?Q?FGfeQ78l+zNk6VF2KOlXZ99x4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55de2a9d-777f-491c-5cd3-08da79957560
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 23:26:45.2059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: To/csqpeUVwaWgux3clyYa4IVkuy8k12pj4K0LwFzHIe+1QOBfI464YOYnI75ttmOSPF8XwiWcqe9KxhRYsU/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gVGhlIGV4aXN0aW5nIEtWTSBtZWNoYW5pc20gZm9yIGZvcndhcmRpbmcgb2YgbGV2ZWwt
dHJpZ2dlcmVkIGludGVycnVwdHMgdXNpbmcNCj4gcmVzYW1wbGUgZXZlbnRmZCBkb2Vzbid0IHdv
cmsgcXVpdGUgY29ycmVjdGx5IGluIHRoZSBjYXNlIG9mIGludGVycnVwdHMgdGhhdCBhcmUNCj4g
aGFuZGxlZCBpbiBhIExpbnV4IGd1ZXN0IGFzIG9uZXNob3QgaW50ZXJydXB0cyAoSVJRRl9PTkVT
SE9UKS4gU3VjaCBhbg0KPiBpbnRlcnJ1cHQgaXMgYWNrZWQgdG8gdGhlIGRldmljZSBpbiBpdHMg
dGhyZWFkZWQgaXJxIGhhbmRsZXIsIGkuZS4gbGF0ZXIgdGhhbiBpdCBpcw0KPiBhY2tlZCB0byB0
aGUgaW50ZXJydXB0IGNvbnRyb2xsZXIgKEVPSSBhdCB0aGUgZW5kIG9mIGhhcmRpcnEpLCBub3Qg
ZWFybGllci4gVGhlDQo+IGV4aXN0aW5nIEtWTSBjb2RlIGRvZXNuJ3QgdGFrZSB0aGF0IGludG8g
YWNjb3VudCwgd2hpY2ggcmVzdWx0cyBpbiBlcnJvbmVvdXMNCj4gZXh0cmEgaW50ZXJydXB0cyBp
biB0aGUgZ3Vlc3QgY2F1c2VkIGJ5IHByZW1hdHVyZSByZS1hc3NlcnQgb2YgYW4NCj4gdW5hY2tu
b3dsZWRnZWQgSVJRIGJ5IHRoZSBob3N0Lg0KDQpJbnRlcmVzdGluZy4uLiAgSG93IGl0IGJlaGF2
aW9ycyBpbiBuYXRpdmUgc2lkZT8gDQoNCj4gDQo+IFRoaXMgcGF0Y2ggc2VyaWVzIGZpeGVzIHRo
aXMgaXNzdWUgKGZvciBub3cgb24geDg2IG9ubHkpIGJ5IGNoZWNraW5nIGlmIHRoZQ0KPiBpbnRl
cnJ1cHQgaXMgdW5tYXNrZWQgd2hlbiB3ZSByZWNlaXZlIGlycSBhY2sgKEVPSSkgYW5kLCBpbiBj
YXNlIGlmIGl0J3MgbWFza2VkLA0KPiBwb3N0cG9uaW5nIHJlc2FtcGxlZmQgbm90aWZ5IHVudGls
IHRoZSBndWVzdCB1bm1hc2tzIGl0Lg0KPiANCj4gUGF0Y2hlcyAxIGFuZCAyIGV4dGVuZCB0aGUg
ZXhpc3Rpbmcgc3VwcG9ydCBmb3IgaXJxIG1hc2sgbm90aWZpZXJzIGluIEtWTSwNCj4gd2hpY2gg
aXMgYSBwcmVyZXF1aXNpdGUgbmVlZGVkIGZvciBLVk0gaXJxZmQgdG8gdXNlIG1hc2sgbm90aWZp
ZXJzIHRvIGtub3cNCj4gd2hlbiBhbiBpbnRlcnJ1cHQgaXMgbWFza2VkIG9yIHVubWFza2VkLg0K
PiANCj4gUGF0Y2ggMyBpbXBsZW1lbnRzIHRoZSBhY3R1YWwgZml4OiBwb3N0cG9uaW5nIHJlc2Ft
cGxlZmQgbm90aWZ5IGluIGlycWZkIHVudGlsDQo+IHRoZSBpcnEgaXMgdW5tYXNrZWQuDQo+IA0K
PiBQYXRjaGVzIDQgYW5kIDUganVzdCBkbyBzb21lIG9wdGlvbmFsIHJlbmFtaW5nIGZvciBjb25z
aXN0ZW5jeSwgYXMgd2UgYXJlIG5vdw0KPiB1c2luZyBpcnEgbWFzayBub3RpZmllcnMgaW4gaXJx
ZmQgYWxvbmcgd2l0aCBpcnEgYWNrIG5vdGlmaWVycy4NCj4gDQo+IFBsZWFzZSBzZWUgaW5kaXZp
ZHVhbCBwYXRjaGVzIGZvciBtb3JlIGRldGFpbHMuDQo+IA0KPiB2MjoNCj4gICAtIEZpeGVkIGNv
bXBpbGF0aW9uIGZhaWx1cmUgb24gbm9uLXg4NjogbWFza19ub3RpZmllcl9saXN0IG1vdmVkIGZy
b20NCj4gICAgIHg4NiAic3RydWN0IGt2bV9hcmNoIiB0byBnZW5lcmljICJzdHJ1Y3Qga3ZtIi4N
Cj4gICAtIGt2bV9maXJlX21hc2tfbm90aWZpZXJzKCkgYWxzbyBtb3ZlZCBmcm9tIHg4NiB0byBn
ZW5lcmljIGNvZGUsIGV2ZW4NCj4gICAgIHRob3VnaCBpdCBpcyBub3QgY2FsbGVkIG9uIG90aGVy
IGFyY2hpdGVjdHVyZXMgZm9yIG5vdy4NCj4gICAtIEluc3RlYWQgb2Yga3ZtX2lycV9pc19tYXNr
ZWQoKSBpbXBsZW1lbnRlZA0KPiAgICAga3ZtX3JlZ2lzdGVyX2FuZF9maXJlX2lycV9tYXNrX25v
dGlmaWVyKCkgdG8gZml4IHBvdGVudGlhbCByYWNlDQo+ICAgICB3aGVuIHJlYWRpbmcgdGhlIGlu
aXRpYWwgSVJRIG1hc2sgc3RhdGUuDQo+ICAgLSBSZW5hbWVkIGZvciBjbGFyaXR5Og0KPiAgICAg
ICAtIGlycWZkX3Jlc2FtcGxlcl9tYXNrKCkgLT4gaXJxZmRfcmVzYW1wbGVyX21hc2tfbm90aWZ5
KCkNCj4gICAgICAgLSBrdm1faXJxX2hhc19ub3RpZmllcigpIC0+IGt2bV9pcnFfaGFzX2Fja19u
b3RpZmllcigpDQo+ICAgICAgIC0gcmVzYW1wbGVyLT5ub3RpZmllciAtPiByZXNhbXBsZXItPmFj
a19ub3RpZmllcg0KPiAgIC0gUmVvcmdhbml6ZWQgY29kZSBpbiBpcnFmZF9yZXNhbXBsZXJfYWNr
KCkgYW5kDQo+ICAgICBpcnFmZF9yZXNhbXBsZXJfbWFza19ub3RpZnkoKSB0byBtYWtlIGl0IGVh
c2llciB0byBmb2xsb3cuDQo+ICAgLSBEb24ndCBmb2xsb3cgdW53YW50ZWQgInJldHVybiB0eXBl
IG9uIHNlcGFyYXRlIGxpbmUiIHN0eWxlIGZvcg0KPiAgICAgaXJxZmRfcmVzYW1wbGVyX21hc2tf
bm90aWZ5KCkuDQo+IA0KPiBEbXl0cm8gTWFsdWthICg1KToNCj4gICBLVk06IHg4NjogTW92ZSBp
cnEgbWFzayBub3RpZmllcnMgZnJvbSB4ODYgdG8gZ2VuZXJpYyBLVk0NCj4gICBLVk06IHg4Njog
QWRkIGt2bV9yZWdpc3Rlcl9hbmRfZmlyZV9pcnFfbWFza19ub3RpZmllcigpDQo+ICAgS1ZNOiBp
cnFmZDogUG9zdHBvbmUgcmVzYW1wbGVmZCBub3RpZnkgZm9yIG9uZXNob3QgaW50ZXJydXB0cw0K
PiAgIEtWTTogaXJxZmQ6IFJlbmFtZSByZXNhbXBsZXItPm5vdGlmaWVyDQo+ICAgS1ZNOiBSZW5h
bWUga3ZtX2lycV9oYXNfbm90aWZpZXIoKQ0KPiANCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmggfCAgMTcgKy0tLQ0KPiAgYXJjaC94ODYva3ZtL2k4MjU5LmMgICAgICAgICAgICB8
ICAgNiArKw0KPiAgYXJjaC94ODYva3ZtL2lvYXBpYy5jICAgICAgICAgICB8ICAgOCArLQ0KPiAg
YXJjaC94ODYva3ZtL2lvYXBpYy5oICAgICAgICAgICB8ICAgMSArDQo+ICBhcmNoL3g4Ni9rdm0v
aXJxX2NvbW0uYyAgICAgICAgIHwgIDc0ICsrKysrKysrKysrLS0tLS0tDQo+ICBhcmNoL3g4Ni9r
dm0veDg2LmMgICAgICAgICAgICAgIHwgICAxIC0NCj4gIGluY2x1ZGUvbGludXgva3ZtX2hvc3Qu
aCAgICAgICAgfCAgMjEgKysrKy0NCj4gIGluY2x1ZGUvbGludXgva3ZtX2lycWZkLmggICAgICAg
fCAgMTYgKysrLQ0KPiAgdmlydC9rdm0vZXZlbnRmZC5jICAgICAgICAgICAgICB8IDEzNiArKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLQ0KPiAgdmlydC9rdm0va3ZtX21haW4uYyAgICAg
ICAgICAgICB8ICAgMSArDQo+ICAxMCBmaWxlcyBjaGFuZ2VkLCAyMjEgaW5zZXJ0aW9ucygrKSwg
NjAgZGVsZXRpb25zKC0pDQo+IA0KPiAtLQ0KPiAyLjM3LjEuNTU5Lmc3ODczMWYwZmRiLWdvb2cN
Cg0K
