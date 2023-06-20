Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1007377E1
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 01:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjFTXLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjFTXLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 19:11:48 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F5DE69;
        Tue, 20 Jun 2023 16:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687302705; x=1718838705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MSjLUX99XSBUJm7JJNSKfp21IcMO1MzKMwSNCfJTbmI=;
  b=XyLhdXWO0BxKEXjAfTnltEZJj897gX9hBNRUi2XiNqTxRh1+eqhrBsAs
   uIh0bBm/vfQhZ7WB68y8dmoYLrZp7ZYzba1/f/VN6dlmXTBXZWsF8Wmcs
   1zQpdCQ1+EcV2E9MSHp2AvfDSmrxed6KwjF9uGEzva5+X5zAPzChXNBNF
   1HFybbdVCNYgI8qHvn+8Z5iKogkxa7zMiL6DefAB0FC7k3WDwfHla0jEV
   q6Cv+kSL88Vj1fR48qs5Duz7VlhCiUIrsfNC2iffpgOS84RlvoR3iz4CO
   cuPODcGGrJUP3pauLGNsP2qswCa243Yi6WVeup35UTu2DIRPEM9X+HScc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="425963673"
X-IronPort-AV: E=Sophos;i="6.00,258,1681196400"; 
   d="scan'208";a="425963673"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 16:11:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="827199309"
X-IronPort-AV: E=Sophos;i="6.00,258,1681196400"; 
   d="scan'208";a="827199309"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jun 2023 16:11:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 16:11:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 16:11:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 16:11:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 16:11:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fmahb/uZclRnuPXBNUiZm880pyOWQu/BLZzExbiVB/C/bK8FFVTAQNmq9XW+4TORaUh3kE6X7b3gOWVKlBm1fY8owqfq+fF66V7PINe0TtdS1PpqfOM7BBK8aRVJmvepJVbzYgdCayVmghP1EPAlrJZd7BLDj8Vt8bvymNJ2md9Wru1I/bJOhasiKd51vgb6YZQKaD95yi/14DE6wBUe/8J/Xq9tDdtj66VhyV3RLL/GtOT9FcaXx3yAAcUK9bJmgvqjvgfF38LDjl1vGgYqSIor6KDD8SoRJUfltJXV10wZnbhar9CiDsBicj7kdb+sh4oKcF0ytqcT9pMQVaS3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSjLUX99XSBUJm7JJNSKfp21IcMO1MzKMwSNCfJTbmI=;
 b=dIRiZMfQuf/EiFdrO98Oc70hJZgJZXLrB+cP42QWAwCj0W6d0xw+NGBUK/6hJTj4s68hSMjadE2UN0x30T5L/9YIkrj43DLvLJjBOc04ygyZjV7NLwldx2TSJuoFmNsYAU1nXMTo3XuJ1Rg262GVfb9DZmty5O2VzwRglJOhF3f0C/aXYpd7rQvlxyQWyOMQEaeWEg1TeUFFFLfGSZASKLwzmICAdADfh4XsdPKk10jomVQx0XaX69dPlrmB8Sb3pA7gHKioVL/lGXgea3IFfjGCsab02JHf/AKmyTDi6J0D6Vh0KFyd4B6RU/lFvTnfjhcTBn7JtXiqTXOHAEAshQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 20 Jun
 2023 23:11:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.020; Tue, 20 Jun 2023
 23:11:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Thread-Topic: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Thread-Index: AQHZlu+rViPY+CkNoE2o6SSiJzjZxK9/Z0QAgACNrwCAEiH8gIAB13oAgAB81gA=
Date:   Tue, 20 Jun 2023 23:11:39 +0000
Message-ID: <77eaebf10657cebc2d32d1abdf7c5a5eea9b9f7d.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
         <bf797bc6-e264-02b0-12ee-c2ebf7c92d22@intel.com>
         <9cb242a0f5a6638770753b24ebd09e09ca047766.camel@intel.com>
         <15a06a50557335e0bbdb5edf228de6f8acb13513.camel@intel.com>
         <f4e0edf5-540b-6ebf-2cc4-3b0941fb901b@intel.com>
In-Reply-To: <f4e0edf5-540b-6ebf-2cc4-3b0941fb901b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7340:EE_
x-ms-office365-filtering-correlation-id: f72a80e1-ab8d-4325-22f3-08db71e3b3d6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a5iifbHfDN/Cr347oMGSLjMd0OMh0zZVpyIoAsYRrigBQF2EZ9zjOk0/Jy7+Asc9kSipiw4hZWjSBvxsmGCEbuPjARDDDPkF2cQCdes+qpkacMASUhYtEktsjopZZybBzSPx77WgXdCvh3sUBUdqg0TzeG1uFTqaXfy4aPXdAbjKPwLD5M3DI+1YTcuXN5oKOGGVszWJt1+wM0OtivfSdJzPcUme9YItK4EblA9d9PXb8jV5VVIN/Xbswf6qSvDAyiuwJZ75uLW2BC3uCkK2Qjpu+NJjcvr1uft3CZ63s2d7WnyIVqcxYQDvINM3CRINCuECS1j5Bz+sfGKpyolBWEExUfGBPFd4m+yM4Yh7rfzne2d6YywQIO0yvj2HlTyGpwb9ZNAiV/NrGcgjXMQLOyZaofR8oZxbz1/E+ztWhLxpJxFm6C0GAQ2Yr2GWS6EH1Ae+pU/r6RROxOqVU/YtALph4236QkwxIjRm5Y+2I4ufO0J83hgu9bO1R+CDGN9Gaa6P9EZFe5lX8e9p/S0QQVhEIv7jrd9dzRpTRjjmfbyN7Scl6m0rYdhw5jFmOvtlATvR6SCYl2O5tj7DL1fX/hBdQ4boZ8dARZnW7pg2QWkdPTp06wedefKrWcdGbSEE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(8676002)(8936002)(4744005)(2906002)(5660300002)(54906003)(110136005)(316002)(41300700001)(7416002)(4326008)(66476007)(66556008)(76116006)(66946007)(91956017)(64756008)(66446008)(71200400001)(6486002)(478600001)(36756003)(38100700002)(38070700005)(86362001)(186003)(2616005)(122000001)(26005)(53546011)(6512007)(6506007)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anRMdUJFblFvR05VNGlDa1M2UlIxNGs2d0lqVWJBUnJyMW91K1crRnJhQVNq?=
 =?utf-8?B?eDV4OFBoUTZQanR3NDZDeDhDUTBNSjdvajdtQmxBUTBBMnZ1Uk1zaG5nQ2cy?=
 =?utf-8?B?S0d5OURUMmxVTmljbWJxcGZGeFg4QVJsQTh4a1RpOWtFeUphNVR4K1ppVDYr?=
 =?utf-8?B?T1d2dHg4UlNYSk9vTnMwbFhaM2o1MksvTEZEL0R6Mms0bjRUT1Qxa21CL29J?=
 =?utf-8?B?VTA3QTY2WFF3cy8xbHgzSHdXbXJ2UGdQd0UwVE1Fazc2eUJpaVhNOUp1OFFW?=
 =?utf-8?B?WWp6YmRJMUYyZ2dkTWhtZjZGcGMybm84STRtbEhGU0dHVFgvSlNReVA5UWxh?=
 =?utf-8?B?T1M1YitFUUZZQVdlNWhYVm92Z1NpS2dhUGUxOTNTaEpYeG5STzU0b01PNVQr?=
 =?utf-8?B?bk15N2VBVVJ6MHVNQitOTUcxa05IVXpPVUxLdGtxd0JSY0R6ZjFFelBOMml2?=
 =?utf-8?B?dE5EbG9FNG56VEdmUlpXUVRXVHE1Q3RKVUV3NHJqNWF6MHBMQWlNVlRmUlor?=
 =?utf-8?B?WjZoRTk2OWFhVHRWM1FjQkp5Q3dXZjZsSGJuNDRDN0xqNVc4eDE0VU9sQm52?=
 =?utf-8?B?ci80cjM3UUQ3U2txZGdxaHF1WDJxMzMyTldDaUZuM0UzYlBYN2dEME5QRVYx?=
 =?utf-8?B?ZzVHSWdybTJnbDZZQ2ZzaWE5RGZ3UkJvVkVCcWwxaC9PZVgxYXhjRURnT3Nx?=
 =?utf-8?B?SURqMXZ0Zk1VV09jUmF3OUpJdWhKRE1hNXRER2lBZkdLMnl4T3hZSDhPMnVz?=
 =?utf-8?B?MnM4TUZSbm5SZmt6dWl0Vlh4cldlNTVxdEFCUlFUbUhMaTYwMm1TcCszb3U1?=
 =?utf-8?B?clVNOFIwMDNWTk55WERpTG9VWExhaHpMbEY4WFlSMWluTHBRQ2MxTzNVcytT?=
 =?utf-8?B?cVB5SkQ4K3hKM1JaRWx0eXlBWUlhL1NtRWhFOFlhZC8yTURxVWhHcTJuNzRh?=
 =?utf-8?B?U285d2lmdmcwRFF6WFdyMWg3cXQ2cm8wdlRxbnYvQ2pRaHVoU3p6OEF3d3pu?=
 =?utf-8?B?ZW1mbHB1Vnl0aDlFbTVjVjJrdWhvR0tZaG96RmhhT1Uya2pBY3hEb0ZsWDFH?=
 =?utf-8?B?ZjlCRncrbGdzQXA0WmlVN2JRazhiS1FKekZBMXRQczhtNVJHODlOaWlMNVRZ?=
 =?utf-8?B?cnRPSHlTay9wcDlGTzJGZ25qOWtWS0cwYm84YldIMldZNDM5Z0pvdmdsVEl3?=
 =?utf-8?B?YjNkd055UmxLTEZpSGgwTmlvMmVLRG9jREV2M2xCT1A2NDRxc1dacy9JcXF2?=
 =?utf-8?B?YTJkQlp5YkJ1M2dUUWJmanNOTk54cHJYRGFUc080QWh0V2NCUXNFMzRpUlE2?=
 =?utf-8?B?Uk5wLzVoTFRoTHhJRUhvMlEyd1pvYUprQjlpanduUERML0NBdlF3aTUyUjUz?=
 =?utf-8?B?N1VZYjNmUHNGM2VrdFZUQVlKQWdWMU02UnQvWWZVbXBNdkpaamF5OWhsOGFr?=
 =?utf-8?B?RnM3ZG5tcDZKNWRIdC9vTVd4VCtVekxHOVdSU3FMbVJhR3ZvTnNjRU1qMEp6?=
 =?utf-8?B?WVI3MTVUTnUwZzBHalByN25tY2dkejRqU0txYm5MelMrRjB6MllqQXVZNnRY?=
 =?utf-8?B?VVN0SXZZelpSRyswYjY4V2lUT1M5bEttTmpIMUhEbm0wc3R3MURzeElFbGRZ?=
 =?utf-8?B?RHU4VWIrckd4NW9ET1F0cGFsQnpZTkJ4NjZEZFpETzZBbml0V0tlWm1LZnpa?=
 =?utf-8?B?ZFdHM3N6ZVVJVTl5TlAxcXphWEIxSmJkN05JSVJLcXZIcTF2ampaMDZ4bHBs?=
 =?utf-8?B?RzR2Qm1KQmtPV1ZPK01mSk5iSmVXVHdoeWxCUzJIQmZBSkxWVm1odGNBMGEr?=
 =?utf-8?B?L09kM2JWZ3RSWkRLS09nYWF3THFUSHpEWmhWeDZ0aW9SMjBjWVhwK0xCTlpv?=
 =?utf-8?B?amRzQ0RITHY5MmhleTI3SU5rSVB2eEVJMVd2R1hZK2sxeWZON0plZ0RtRHpN?=
 =?utf-8?B?bDdveTVJNTJVK1NHc3lhOERTSVVqZVJGNFVuTGpmdWRsWTRRWFNXdS9uSGVw?=
 =?utf-8?B?MjBjTEtwMEl1d2FnZTNvdmkxTEI5dUxtdTFFTUZ0Z3BOU2tYUzhvZGtaQjFD?=
 =?utf-8?B?VlUzQVRxVU1xNkltbEl6dU5zQnN4ckN6OWNtTDAzT25oNm1nR3hGOU5SaGVI?=
 =?utf-8?Q?N5fHnAKWjHoJm2PMjcpljXGeA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50C29C32EAC2E94FB9874BEBC4E06FD0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72a80e1-ab8d-4325-22f3-08db71e3b3d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 23:11:39.1178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYS81GG8h2GjmiE1rO7JGJCGkm5Ivtz5n9RZPCSmQwdqHDU5kPdPLDcyZcMxwIJv9S4ygefau87I6keFftermA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
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

T24gVHVlLCAyMDIzLTA2LTIwIGF0IDA4OjQ0IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xOS8yMyAwNDozNywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBQbGVhc2UgbGV0IG1lIGtu
b3cgZm9yIGFueSBjb21tZW50cz8NCj4gDQo+IENhbiB5b3UgcGxlYXNlIGdvIGxvb2sgYXQgd2hl
cmUgbW9zdCBvZiB0aGUgWDg2X0JVR18qIGJpdHMgYXJlIHNldD8gIENhbg0KPiB5b3Ugc2V0IHlv
dXJzIG5lYXIgb25lIG9mIHRoZSBleGlzdGluZyBzaXRlcyBpbnN0ZWFkIG9mIHBsb3BwaW5nIGEg
bmV3DQo+IG9uZSBpbnRvIHRoZSBjb2RlPw0KPiANCg0KU3VyZSBJJ2xsIHRyeSBhZ2FpbiBhbmQg
c3luYyB3aXRoIEtpcmlsbCBmaXJzdC4gIFRoYW5rcyENCg==
