Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629E76F61B6
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 01:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjECXEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 19:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjECXEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 19:04:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900A5FD9;
        Wed,  3 May 2023 16:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683155063; x=1714691063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B3Z3SCq/HmY40JEpWH1Bzye8e2tJJCxXxAs6+Nfv0uk=;
  b=GmFDMa8wfAN5DoRKRX8Mfsc2g2HZzT2JdlkKNtoaplx4wJYLgWumiPoi
   HJ75qKYt2Jjf8QxQ6nxK88NogXHnMgVNR6ap/Tm7uf7nFCn4/4ffAZwPz
   LQfg7a61TA27zsTDtGZSN0mtj0y3hRTbyCHxLT1yG3u1QqfCccqB41IHm
   qo3jFMA5xJQTxuWEQwTzIPV4HV3YuD+xaDrlfR0CnGERUGl7gl249HN1e
   5kBe5pu4BIstPKzcrQSFp4c2beyQWONyf7qE05qNkN+pIKAEPbydx5sSE
   oUa+u6IE8CrRbQNz88dpE2iMs0LdzW2h+u3MtH1mkFtyjo7g2ttSVTYxj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="348830342"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="348830342"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 16:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="808454901"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="808454901"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 03 May 2023 16:04:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:04:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 16:04:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 16:04:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 16:04:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PiuQqqtQ/0ef2/KqWV4lRhdbnUDy2fMrZIjBw/p/b7Fy6bk0MAAAmM+75YKLNKDOFIdxQtjhaxqqEft3q2agHfOixHcMif1bHPdzkQCuFOUf3BR3OEEDhxA0/iG6fNKQy1SA+T1pHOjfs2axLGPQ3KOkNLq6TON2fwtvs6FoBTX8fCgl0TbMQU5MccwMzNNR/j2NCkNAKQBpY7IfCFHvZatTQNja7iSZdp7+x44hTeuhWB12iXakKJx8JADVRJaE2xRs7cEDU0AWqmIXeS7Py7R/PK/8p9Tsc1mtOXd3mUtSIExb/pcrpPgKHYJzakdPqoreVzdPqlRSFGkMmXU6/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3Z3SCq/HmY40JEpWH1Bzye8e2tJJCxXxAs6+Nfv0uk=;
 b=QPTbMnP0M2VYTMlbmjEWgD+3DXPwlmfUNZHmYCMnnlgDh0knOCy1LX2PZ2O8HXTme0stUl1qIOs6ewPRJv+PRZD2XIKjz4+6MOyA4Cmb1oZdpYio+9p0BmYqI4hVWKUfQ+WC7Vs4JMYTs4gX/aqG6dGdx/bFJivmOMLz6JEYzo1O86t/FMMTHQijjfDNzT3dGzGO5wPGs2CoAqZBatVXkilhkpZdGe+rMCvEpvor8Y/MgVjNOEexXt1AT/l8TThItBLTxXhGcYJZE8wjIexKLh1Ntv1SoXj9FqF7XbVzFQgUwsFjN7gbA7v/yo8MF8y627TqCYiNTek1vv+HbjiMpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB5534.namprd11.prod.outlook.com (2603:10b6:5:391::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Wed, 3 May
 2023 23:04:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 23:04:16 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of
 kvm_mtrr_valid()
Thread-Topic: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of
 kvm_mtrr_valid()
Thread-Index: AQHZfe1f0rO3GrjwtE6wZCgIpENwna9JK0yA
Date:   Wed, 3 May 2023 23:04:16 +0000
Message-ID: <06715227566b520d4a445466f091dc28a0b8cd95.camel@intel.com>
References: <20230503182852.3431281-1-seanjc@google.com>
         <20230503182852.3431281-3-seanjc@google.com>
In-Reply-To: <20230503182852.3431281-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB5534:EE_
x-ms-office365-filtering-correlation-id: 2d4c0050-06ae-4222-65ca-08db4c2ab807
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P61EtzOHKb6t3tSHrTlXuEWjQwmdG7b4jodc1wCJuelPg6Jm/GtNrEllpH2g+SUh7rZVcphnhHlyRpoI61iKHcqpIiA62cM/CT6cyLkXbI9PdPZe1juFBBr4nnl1/TZ3j26ruhl6FF8gFFxufpDONe8e2BW+XWSAOfy+2Sasy+8xwwRfGMaCZRBnhhiAkKOQ8SacngRNbsO1Y6a4LibBQsylvkFRHeaRAi+KNbhoqSdATKxSFsKGlOozvrthw6r5Y1lWwLuujecCQgBBG5ovYMBJ3ohz2KNDmu42q8P6X3w7Vxcmc3XVZYkgAWX1QDWptrbzemKWKAnAp2A7nQ0uZAST/GMBKSVpLhke12ncJzWn8GRe9tdM8kv7hPTMsjN67FSufOM6g6pvQnYgCaGtSeabKViRHHuNFaAGne0buMm4qC1j4uRz/O8X8gVzf5qXV1gAThQazfR8QG3X74OLsNIypMh4ZfwfwPHxfeUVRjHcaw869uzOf/BW3GIKF8nnupqn1NRKiLCIwFJbJBKEwsUl+qhdM4m9x7RnYqQQRLHbiO+x4Q9rFAjNTWWiySkzfYbqC6+j8S2zF8AatvhnKXKqOyt/6kG5P4CiORQNjx7TQWKHsV5zXHL59sPZ5Rxw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(8936002)(8676002)(54906003)(110136005)(2616005)(71200400001)(41300700001)(316002)(6486002)(5660300002)(4326008)(66476007)(66446008)(66556008)(76116006)(66946007)(64756008)(91956017)(478600001)(86362001)(6512007)(6506007)(26005)(4744005)(2906002)(38070700005)(38100700002)(186003)(82960400001)(83380400001)(36756003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE5UV0p1U3cwSFc5Y3J6NFhsSFY0M1IxcnB0QUNKSXlUM1drM015aTM2SGkz?=
 =?utf-8?B?aU85MkV3dExSK01HVmtyNWNGMGYybHR4cFM5U2E2cGJwWGd2UFRVcFZHRzRE?=
 =?utf-8?B?QlJUYldxZ0kwVVBhNSt2SzJSL2FYV0U1OWFIdzZvZ1VsS2JwMzJicWhPRlA5?=
 =?utf-8?B?Tk5xT0NQWG43ZmZTSUtxdmY5UnN3ZFRmbW43S2YwZTNRTG9DVENjNHV4ZEdJ?=
 =?utf-8?B?RWIzenBPWFZpTEhGWS82eGhBUG56S2RqZ3FhTUdZdUs5UnFKKzFDS0cxRGVB?=
 =?utf-8?B?ZkZMbkZxYmJ0ajNFZ1FIeG9EOUpDWWJMNWtodWhSNXpIaHlEK1FjaEdCWXV2?=
 =?utf-8?B?WGw2Q0V1UVhTaVZCOUtqTCsvVmJEL1RyQmYzYVY4NlV3Q3BXbEoyU3h2UHRu?=
 =?utf-8?B?L3dnNDhLQVhreGJxay9MeDEvYWNaZURsd1BKd3VkVGhtVXl6dTZuWkVpTjM2?=
 =?utf-8?B?c0pxWTF6VU11VGVzRk9rLy9EeG1nSU1SODZtY3hTNzJFeUhIa2s1WFpicEw3?=
 =?utf-8?B?YzM1OEFxUFBHTlA0UHJPbWVBODVWQ3NDM0NETjJ0Vng1ZkFra1d3c0dHY1c4?=
 =?utf-8?B?d3VpcWJabjFORkxOTzlKaTZkd0l6dlRFMlE2K0N5bnRualZ4ajluRTlOc0hk?=
 =?utf-8?B?bzdnQlI0dHBVWWc2K3M1Nm9DM056aGFGcHljODlnQk53Tko2YUNtV2hwc3Q5?=
 =?utf-8?B?cFV5RlhZT3Zjc1ZzTG42V0k5R1dyamhLQXd0V2paU3N5OEJGQVZiblVTWHMv?=
 =?utf-8?B?WSt4RWRNRSt4Y1Ewd3VxL0Rtak1WM3VYc2g4V2lmRXNoeUdUMmJReUZiYzVU?=
 =?utf-8?B?SkpVSk9CNDM0cUd0SlJla2MvbWVGVVVlT291ZkNESnpTTFVhbFBiZkh6akh6?=
 =?utf-8?B?UzdnMlF6cjFpNXg1MElER01NR0NoQzNVOGk4MmdXeTJsaDEzY3NteFQ0TE5t?=
 =?utf-8?B?OUlRcHl0SnBoczJRZmJwT01IcThWRGVoVDh5U3dTRy9WanZJbHh0ZWE3V1Jk?=
 =?utf-8?B?SGdhd2pnY3l5UVhQSGtFVnk3ek9QWEtzc3FyY3U3NlBTQ0VZb2g2cTZldnN1?=
 =?utf-8?B?NUg2MEo4WHVqZmRwQlBTWkpkWVhobXFDZ3gxaGROTDlVOTl0Y3pjWlphZVpp?=
 =?utf-8?B?UFJqZGFKejl3YVczV2VwcFduZStWbkczZXpxekVxYVU4OW9RWHlwOVlzZHJC?=
 =?utf-8?B?SkZxT2FBbndQMVJldHhSMUZ5RTVja2FBcFVtejExQkpHRFl1Sk5aWnp0azlk?=
 =?utf-8?B?R2JYbG1abjZUeTdFS3orRDBnS0FpaG02UExzc0JYSTJaUmN3bVRuUHBZZXB1?=
 =?utf-8?B?dFRiNWtveDBPT056ZGcxaUljQlQ1Q1BhT0VYZ0puaTRVbmJZNjhKQkhFeWVE?=
 =?utf-8?B?VUluNWJqOWFFdzRtTHBGM3pCZWNlSTB1QTQranpLbXAvLzRUenFraU15cDRo?=
 =?utf-8?B?K2RnTEUwS0w5K0VzaVpLdS80alkwOVI5RTBhSGVUSWdQWk15bzV2NkJBdWJp?=
 =?utf-8?B?R2l1cTVQY0ZnSVNFaFNDcEhDVXorMDlNNGM4U3RhOXVpazB3YnE4WmdTN0tK?=
 =?utf-8?B?dGZKR2VzaE1RVWcvQkRDMnNKY3NJN3BSd1JsMXJCK2ZvLzVBc1dNZ1FTOXhI?=
 =?utf-8?B?enNuNndFREIrcjEyWGJqbTdJQityak5BZUlrbXVLTU5RQTFxOHFWZ1phdUV3?=
 =?utf-8?B?Sm16ZUxuYUpSVmRDci9WcExhQlYyOW9XMDIxS3dSOUUvOTRabFNVSitCc0Zl?=
 =?utf-8?B?MVkxSlRiTXdRRVFPSGlwVUhhTUJRQ2p2TnY3M3ZjRTBaSEUvNm4vOTBEdzg5?=
 =?utf-8?B?Z3ZOMEhTR2l4MG11NnlBSTFPRHVwTGkwS1RtVFB3V25yU2lFT2JvQmFFUU9U?=
 =?utf-8?B?b0RRUzNucVUvRHVZMHRTZ1RiYmp5RTlBZlo0T1o4ZXBCVW1VSEcrdXRjMVpk?=
 =?utf-8?B?N0dOOExvODdZNytDeUtaV3BhQmJsblNBSkQ3N2EvaXpUaWxyVUVEako1djBT?=
 =?utf-8?B?T25XQ3BvckVrMXQ1bjBCU0t5OUszSThZQk1lbmd3eURrSVFoNktrUmVnL3FY?=
 =?utf-8?B?WGkyYyt1cjVyQ2xUdlZ2Mks1dVFYZDlRSitleTlwUDdUQWZoYThWUytkMVkr?=
 =?utf-8?Q?Z0nCMVfQ1OTTjY8dEm32PYE1M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C81FE968446E37448801F2E615E7CB30@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d4c0050-06ae-4222-65ca-08db4c2ab807
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 23:04:16.2507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oHPfBWH/WG9qxKal5TqzTDSG06xJPjYf1ps5U8ZWgsD2NjTOgYTjX+hCaZIM3ywHP91+nmWea6aMJU/Lqn8DUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5534
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCg0KDQo+IGZvciBiZXR0ZXIgb3Igd29yc2UsIEtWTSBkb2Vzbid0IGFwcGx5IHRoZSAiemFw
DQo+IFNQVEVzIiBsb2dpYyB0byBndWVzdCBQQVQgY2hhbmdlcyB3aGVuIHRoZSBWTSBoYXMgYSBw
YXNzdGhyb3VnaCBkZXZpY2UNCj4gd2l0aCBub24tY29oZXJlbnQgRE1BLg0KDQpJcyBpdCBhIGJ1
Zz8NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2UgR3VvIDxndW9rZUB1bmlvbnRlY2guY29tPg0K
PiBbc2VhbjogbWFzc2FnZSBjaGFuZ2Vsb2ddDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS9zdm0v
c3ZtLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRp
b24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94
ODYva3ZtL3N2bS9zdm0uYw0KPiBpbmRleCBlYjMwOGM5OTk0ZjkuLmRiMjM3Y2NkYzk1NyAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0v
c3ZtL3N2bS5jDQo+IEBAIC0yOTM1LDcgKzI5MzUsNyBAQCBzdGF0aWMgaW50IHN2bV9zZXRfbXNy
KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3IpDQo+ICANCj4gIAkJ
YnJlYWs7DQo+ICAJY2FzZSBNU1JfSUEzMl9DUl9QQVQ6DQo+IC0JCWlmICgha3ZtX210cnJfdmFs
aWQodmNwdSwgTVNSX0lBMzJfQ1JfUEFULCBkYXRhKSkNCj4gKwkJaWYgKCFrdm1fcGF0X3ZhbGlk
KGRhdGEpKQ0KPiAgCQkJcmV0dXJuIDE7DQo+ICAJCXZjcHUtPmFyY2gucGF0ID0gZGF0YTsNCj4g
IAkJc3ZtLT52bWNiMDEucHRyLT5zYXZlLmdfcGF0ID0gZGF0YTsNCg0KQW55d2F5IGZvciB0aGlz
IGNoYW5nZSwNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4N
Cg0K
