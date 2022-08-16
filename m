Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9845965D8
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 01:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiHPXEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 19:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiHPXEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 19:04:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ACB67CB4;
        Tue, 16 Aug 2022 16:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660691078; x=1692227078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8UwestwsapijOqjzbC/kIiMh63aU/iUDa+NPCeWNuwM=;
  b=OiNMDkO29rkuPJEudBKEJlOyd96qkSjTO+M3Pbv5UOZJvJeMrSRiZK6u
   H/d+JxflCAnK3eAN6K2cIj/9+9RNLAiL4WkVBLLPer7AIqXNlL5fA+sF9
   m1FP5pG4Zf6UL4HuQcxkNobYtJt8DU2DgHOXxjuWDF1JL6nDPlHsT0oor
   KwJQ7XGtvAE9JmmPa10uzlJ1B/kKHI6KdGigAqeiz+YycjsT8PVDzBPZ5
   EM8ebrpb9aZHK21LWvzw5EgflPHNM2ysR5SK7AmNMD1yTqza96ONRfX0K
   qEXGdNdOtA+ZRuyybF5Nc2fJ6LF7dgk/W3MLF+VS/gsNQxLp1TVwvsTVS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="272741522"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="272741522"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 16:04:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="783196981"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Aug 2022 16:04:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 16:04:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 16 Aug 2022 16:04:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 16 Aug 2022 16:04:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 16 Aug 2022 16:04:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkJvRzFQk3Mt5F2VAa3cLcvonNycjo9p8obHuOfdOfJnS7uGKy9llNx0Ad5our3RKQpiUpoW34clHQKQtnLfUwqC7qv/rn7aTku38+SWDQ11PeQ6LPnMXADgjPLZf264/mZyoVoGROCXl04KYk/vVfWSBxge4Ski75JewhTjYK80ajMlspFRzESfSaFmXlLBZOzZmInkDZR4Y9XpTUjNLF0PS9v8wAu+AV+hBx91wSYvnjinqqrOzKkBagLPirhx9wSWhgBn2vc5/O2phIB8a3BqinsJkCCUGk+3tFAH8oM4mwzMhTju9ISPVPPRPb+7duphLw+lSPVnSMTBfRoVTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8UwestwsapijOqjzbC/kIiMh63aU/iUDa+NPCeWNuwM=;
 b=QofN24NUrB2+NHE4LavKo9rd9ca8QEObN8AP8yad1Pl8zuQEM280FUCZLh0vAvSjf0SrDcnuvmda9Cf2aGtiICVAVz9BV0GFP7YvoJ4Igw557QUR30M1jsB2lEUI7D7QRGOHd1/teyoJD5pmaZYt6QzyVERGLowmqxRdVCix0Nv0MMZ9TCcK8JWZS+NjonuMeiBp4Gn38d2kBifM6Bpzdd0dbX/c6jOaFftp2UftHFKr6/lATkBfWusI53LaG7uj8HR+j0zyIoYzX0QBqKaE0wT/Z5H2DUU2UA7lzlliBzRZSwpzoaP5Oiqz2QaSgBORWIVrDCWgx72BJDIOfTNhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Tue, 16 Aug
 2022 23:04:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 23:04:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH v8 053/103] KVM: TDX: TDP MMU TDX support
Thread-Topic: [PATCH v8 053/103] KVM: TDX: TDP MMU TDX support
Thread-Index: AQHYqqnIoYPojObMgE2/eC8JUZeOL62xtkkAgAB9e4A=
Date:   Tue, 16 Aug 2022 23:04:34 +0000
Message-ID: <31fec1b4438a6d9bb7ff719f96caa8b23ed764d6.camel@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
         <2b51971467ab7c8e60ea1e17ba09f607db444935.1659854790.git.isaku.yamahata@intel.com>
         <Yvu5PsAndEbWKTHc@google.com>
In-Reply-To: <Yvu5PsAndEbWKTHc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adaa926c-355b-4f42-1205-08da7fdbaf53
x-ms-traffictypediagnostic: IA1PR11MB6291:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YZ3PmqUwWgbfQpi1DMhQn7X5IWpvPfhY34jmfW6MBLmuXhUsqNTd1pkqEQJSmSpUTbIRnjF9dJ9qYEZWkTDpYgA0tVQWUednhtzflyTGorQPqrFIAu0m1hbdJOOo7v/HeNWZAmr5zEiE/xn0RkaicgXiT49//huzZ09FgltawDFBT6qzTg5w1YT1zx3aGKA0msHi7yORYC3noG25d54dXhjj0gvsX7qv4+1lGy0a6DeTD0afgBYbJXZbsOt8NQ5g2o4zeIpfNqHBraBaj7syrnlrAnftgcP6voRdpyJitCfIrK+xn09m10NoiZO9wD0dEhazYml82H7tE2XrRCNM61ISWN58+77pjFvKgh8/sUgzWsdnQ3Il3jgLSxJfPIiYBFq4Tp/UqXE0gT0Mk4iQf6aMIWCFhjIyPIDlXDW76Co8Pqadm6pMZEBkqnUd6YaW4QeNBgnAW+wb0Bc4J7aMRobBf4FLHmVZup39eSQGugRJc1IZp1uDfVBMBTqV71lD+KRupHAO+WrIKCqSvtDYWsePV0ueKOIlR5hZznBAOCmKg4nQCU/m/Iq51iTsqFplz+gm/a005Ty+t5Xo4eJ2hbksddi8UqUY1bH4nSjD+uXT14HRzxgjAV9M+mRyh9kQPuhFzGsFDWkEzU54b9VMfheqDuc2yyxq0o+CbYl3qfAcjyLkH1af40IwRbVzVs2fDrBz7qhssabpP+927XMVqie24Co0/sV04zCilp5CluKXVoFS4N87q8ouvzD2TuRldipN5UtuPqRggfEtg8fFeKUNT2c3qkzN+8FKscZN4DAa4gPv28OSctpR9TpeMLqHNoxmrDowkwiKEOpCPetuPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(136003)(39860400002)(396003)(478600001)(41300700001)(6512007)(2906002)(66446008)(26005)(6506007)(6486002)(66476007)(71200400001)(966005)(82960400001)(4744005)(8676002)(4326008)(64756008)(66556008)(86362001)(36756003)(110136005)(6636002)(54906003)(316002)(2616005)(38070700005)(186003)(66946007)(76116006)(5660300002)(91956017)(8936002)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0JQd0dnRW01UG42WnpPUFlScGNEOHIvV1FYejRZcU1FeHFTY3V3SStzV1VY?=
 =?utf-8?B?OTd4ZUdoMmp0eFpzTTc4MVhDYWFSUmJ2SkdtU2kyOFZEWDB6MDBva0NJSWdm?=
 =?utf-8?B?ZThoeUVERjZwb1ZUazRmU1VMandmbGxsLzEvTUppUzk1WVBSZ1JCZDZMRXNm?=
 =?utf-8?B?TnNFVkFjYUIxY01tMzBkUWJHU1RvbGYxVnBRdko2Zm9wNVhBbnVPY1dKWFdp?=
 =?utf-8?B?c2paNHhKMTZOOTkyK0g2NG5sNHNSbC9uS0ZzMU1NalNaZHcva3EvQjE3cFVp?=
 =?utf-8?B?Rk9DU0Z1L096ZTQ2OGFaa21haTh6UzhYMHBhdHBpbXNkK0hNcncyY2Y1MkJv?=
 =?utf-8?B?ckRyd1lSeXgwSHh1TFRzNE1wR0FpdHluL0VPUVAvUDRHUHZMUStXNnJpN3JS?=
 =?utf-8?B?NUk5UTdvb2xOVGVFbjQxbDJxcnI5eVRsdzFZK0hiTjQ4Z1l2KzZTM1NJaW9k?=
 =?utf-8?B?OG5INGlONzRBbkVVSmNnNGk0a040Wmh0WGs2ZExBSWR2b0tXV2lidjl1Unlt?=
 =?utf-8?B?aXFMcmpIZERib3crRytkTklKdlYxeGxWYW00VUhqYmFNanlZaCs2QWg5L2FK?=
 =?utf-8?B?M3IwOGl3ZGNsUUNrSlhrYTk4RkpDUXpRNjZYVENJQWp4eWNla0lwTzhuSmhz?=
 =?utf-8?B?eE00MUtWS2V5T2hkbmhiUEhsK2tCWXd0KzNtY1FOR1Y5dUFSa0pXdjR3VVpU?=
 =?utf-8?B?QVUwQjJETUpjYm4zK1ZzQTdzdVRma1hTNVM1dENpaVE4K1I1YzV6Y3M2N2pR?=
 =?utf-8?B?K0xVNWR2Umxsam1lbEw1bi9PUTJtLys2S292UHdxaTIzbXM5WGQ1YXh1NXZI?=
 =?utf-8?B?SXBaZVFtdENFSXVRK2g1NUJiQWpTOEVYZ0RtZTRmcVo2K3VGN0JucTNUQjlQ?=
 =?utf-8?B?clpjcDZCWTQ5ZDFmU3lEMDh2SGM4Z0IxNEVIeUNLSWN2UW9GbUt4VlFkS004?=
 =?utf-8?B?Vzg1Ujh3eEcwaFhHK2orWmxScStwaGZuWGppMG81MndjcndKNCtubE1kTytN?=
 =?utf-8?B?bTdXamRsT3dpYlhjZFNlajExejFwenFlaEEvdHNOcmc5KzZmOCtNTnBTK29m?=
 =?utf-8?B?b3BjMGg1aEorK29DMTJIaktla1pPQ21MUDV1NFNPSitiMUlnaGlJbytnb2ta?=
 =?utf-8?B?akRobzFhVlFiR2YwSXdqTkVLOXBVR2hFYU5DbGFpaUdWeS9MOWRzdTdyNHBt?=
 =?utf-8?B?Y3F1WTVvZHEwUmRwNzhkc3g5MVVFWWVERDZTY3BncUhvc09VZXpFSnVuVklI?=
 =?utf-8?B?WlRIUnJBMmVtSllDQlNqNDNhYzhZZEhJR2RqUlBkWXFhR29qT1dHZGp3dHJl?=
 =?utf-8?B?bVd0RTVudkE0cXlOaEhqdmZGZXZ3VzJUbW9mZ0J0RkJhbzVGVzVINzF6Y2di?=
 =?utf-8?B?ZkdUUmNrMjJLVko4SldyOXFxT3AzNmZIdkw0UjJNWjVheStJMERCTXJIblZT?=
 =?utf-8?B?WDh3dmJQMmR3UlJHa05zMndCNDhWdXhJOWE3OU1INE9EUFk0a3YvNmNMejhC?=
 =?utf-8?B?a1NYeUJyaFUyT0Y0N1FPQks1UFBjcEdzV0tycTluQzh4RVd1b2d3ZnQrcGNR?=
 =?utf-8?B?OGNBdlRkNWVjVWYvUmtFOXhiZGNIeU5PRnkvcXp0azhxWXRNRkl5SVZJM3dL?=
 =?utf-8?B?d29ob3Z4NDcwRzhxeDVaRmdab3ZWVFdZaHpRaXhHOE1nL001UTR2aFJxczRD?=
 =?utf-8?B?ZXV4Y0g0MGJHRkwyV0RpcWtoZHB0YVoySmxlTGlGekNWU2s4aHFEcjZweGNs?=
 =?utf-8?B?UFZiQU10UCtOUXdCdnplcnBzVWpNZ3RNTlRBSnRyTlAwcTZYUTU4Ui9LKzRO?=
 =?utf-8?B?Y0phUTJlc2NKNDc5SzUrem41M3pwRmJWUURHWUgzc2hqUnhCOHlUaStWR1NY?=
 =?utf-8?B?endhUjlkc1dFcjZEeC83VWRQMEZSUndISXRsS1hOTTNiazRIbWl0c2Q1Vzdq?=
 =?utf-8?B?Tk9GMzFqTFlobXFYVWtndFNXUEpJM0ExUWdPVENTMDBMQzFxL3YySXhPUm1N?=
 =?utf-8?B?bzcxbEE3MXdjRnF4ZEZKUlFReWluOHkyL2pqZHVTemdHNEhuV1pvOWFTcWVr?=
 =?utf-8?B?ZW1ndy9oRlVFek16dFBVcElaQjhlYndrZ3ZNeG1lQzRXSTlDOWZaK2xLVkNF?=
 =?utf-8?B?U0lPaVZCc24xa0VUTUk2L1AwNHVLekluSUMwUmplWm1ESU5xUkYvdXVMZENs?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E52097586FB0945BE759A1CAE30AD7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adaa926c-355b-4f42-1205-08da7fdbaf53
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 23:04:34.1900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DR5XwCRYm1vWSQSC2he6d/b0WubKPqFlfFeM+tyYXd683q4tyhuf88aZoxDI07jHlUTkJlvldFP8cWSchMV/Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTE2IGF0IDE1OjM1ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTdW4sIEF1ZyAwNywgMjAyMiwgaXNha3UueWFtYWhhdGFAaW50ZWwuY29twqB3
cm90ZToNCj4gPiArc3RhdGljIHZvaWQgdGR4X3VucGluX3BmbihzdHJ1Y3Qga3ZtICprdm0sIGt2
bV9wZm5fdCBwZm4pDQo+IA0KPiBXaHkgZG9lcyB0aGlzIGhlbHBlciBleGlzdD/CoCBLVk0gc2hv
dWxkIG5vdCBiZSBwaW5uaW5nIHByaXZhdGUgcGFnZXMsIHRoYXQgc2hvdWxkDQo+IGJlIHRoZSBw
dXJ2aWV3IG9mIHRoZSBwcml2YXRlIGJhY2tpbmcgZmQuDQoNCkFncmVlZC4gIFNpbWlsYXIgY29t
bWVudCBtYWRlIHRvIHY3IGFzIHdlbGw6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8y
MDIyMDgxMTE4Mjk0Mi5HRDUwNDc0M0Bscy5hbXIuY29ycC5pbnRlbC5jb20vdC8jbTk5NWI0MjU1
ZTBiNWEwNzU5YzMxZTRmNGNmN2JlNDBjZGY1ZWUxYTQNCg0KLS0gDQpUaGFua3MsDQotS2FpDQoN
Cg0K
