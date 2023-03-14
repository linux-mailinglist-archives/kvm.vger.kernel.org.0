Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178606B8727
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 01:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCNAn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 20:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCNAnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 20:43:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6A1911F3;
        Mon, 13 Mar 2023 17:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678754589; x=1710290589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=d9uXMBBNiTeyRpsPOWMtC0oEoT5zw1xht8uc58DFrXk=;
  b=lDsyeu0sRTq6idAmiOzWm3s9De1n1Uv6NVNNjETfyAZtbSoGRzsWxOAs
   ydR41i6N8I91/8LhqzZcfTSEAtwNlb0m6qvJ0aB/OENkH75trdfsh3jmk
   lrJvXdj5YqGSKf1lZlKV20OMsBxmf+lvzL5yK4DBv3hAbsEy8Y9BRJxIe
   d74bMYX5h7juUCfisuOKUya7rKJQ94VHbri/FOE70EiSvQxlv3Wwe2jqL
   Cuk4M0N7MMpjM74jiKlwcmjv1LIxHErp1n9kQZssWBBfZxsWbhdGNPZyQ
   15HLEmmFRFujmNXsRLF+ynSa3LHM2rB98vrxtH9bkv/mbyle6T78fkMUL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="399885720"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="399885720"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 17:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="802651277"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="802651277"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 13 Mar 2023 17:42:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:42:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:42:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 17:42:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 17:42:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWLwb/Ag2SZ49gEjIbVTBxVVHcz/FvFTbKczqm1+yHBzy8KZ7fqFs+b6taxdgZ2y17ihO9blaewlGazhx1B6M9q8uGRngEgVUrKfZAU5Q+l1Yxmu7Da4EqBFUHQ439OVXAHU/8GNZsbwezA0YLPZgvNwXTAFv7FJsoptcGJshI7kj3O1uclaPAgkJIp2pesgyoIcT9c0LrJu/umhZX6aHisw+jVLWpw/ZUk/maEYqf7KvsQsOB29/4GBy4OQR2yj/i3tnfN8LyCYMtgEDiHgySDkEJvKB3gC5F/499UWHWWP0+oxtJgTfFjmShDHdLrApC285XrrK0djp3Uq1vpxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9uXMBBNiTeyRpsPOWMtC0oEoT5zw1xht8uc58DFrXk=;
 b=USELBoXTSaNzZ45e2ETtFOW4bjjjo7dvfezPm60KZ92JqCevM5Qvl6KtqZGLmE+TULkuW6QJq3tq8kUeRmO5RYyJb48FN7GwutlJgYCMBFIr+ugZFOAZddAITPiOxnajEbsameTooeXVNiZo2QmICo/MZ66mS99e0DgdI0BH/9cdJP2MbjZG4JVrNtAykuuGbL5uv6/kQcVCS1vFQ9w29BLNCjVhI6EyfZMdMjZh4IAeByRngGY5JMlbWSOy4XEoXzMzPqKvTbBw/dp0k4lc3SeHuM1w7TSwqwozEvEjwJ/UFYfpSsmWfTeCeRMQyhOpS93YwPD7GubhWLbQOiehXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7915.namprd11.prod.outlook.com (2603:10b6:610:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 00:42:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 00:42:39 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Topic: [PATCH v2 05/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Index: AQHZU5lNLkv1cCahbEC0lBpbSQHWdK735QYAgAETiACAAHv9AA==
Date:   Tue, 14 Mar 2023 00:42:39 +0000
Message-ID: <9f8c89bf44a8eb68407369d26956c24082562cd2.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-6-seanjc@google.com>
         <ce2330db94b05605a0649a3da0595211c5bd71dd.camel@intel.com>
         <ZA9avcHRPoIqZP/n@google.com>
In-Reply-To: <ZA9avcHRPoIqZP/n@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7915:EE_
x-ms-office365-filtering-correlation-id: 3237e75b-0609-4aa3-4ac3-08db24250361
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NhN98wSHCPU1ID9am7oeVRhBOkqo2vKeid+W/dkYlDedhTEne7d0RW9TC0G9uEesKi/f4AEc68PHbuIHc/uAM/lR1Dkl3a1lSwxoxH0RWkp33ZV6s7L15OmO1u1vv9lYKZw24UdhZ7tXsPCJBxirXPAX4DG6skB2+kbLYfJxLKjFeHQtNA5W6z2Ip7GkZOq2GNr3Oqamy0tcNFinHbQEKMtyg44w3szCJ0dqZapTOYwlqGhVhfXbYvzUZQR+qmW2TA12RJw5p8A3/AtrUz7l0ZZg3+Nb8MlLX5asLqVTwO1pQc2d0NTd1H2I/0XdGmiRx/JQPdbSfZvgQNl+FgxLB+UJjPQqFm7ggST8fhVGU7xvFboPPrwducSldMfAIMAPQMhuuUltl7yk9rLWF1rOyfkHlAslfpLIH9QKO6qIotvAsoRUm6Fp3FCESz1JavHn/1Xvcf+xiKVDfROfg73TikyYcfDj+Y9s79xMzYBYcrrYl4icE4jdsL91nHx53O3yNmXAlIy0bFy/unjzWFu2KKJZkl13hMV6G8D5sTvpFI6IKd2TjmlAraFUH0G//+d5PwkIa2gVFgV6C+xDHBbPR5CVcnmGFvxiH3ZRUfUrqI3NhzmtS1pNn4lG2sTn2X1NpV/YnZqlHxiKTh2WWCVQAXDi95LwuhhAeR0k871OkFrDyV19Kw3NLS5jpxcihEkQwtwNT/+oenGbwOIOXI/Fgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199018)(6916009)(7416002)(4326008)(5660300002)(8936002)(2616005)(41300700001)(26005)(6512007)(186003)(6506007)(36756003)(86362001)(2906002)(83380400001)(76116006)(66556008)(66476007)(64756008)(66446008)(91956017)(8676002)(6486002)(54906003)(71200400001)(316002)(478600001)(66946007)(38070700005)(38100700002)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGlZR3EyRnFQc0kvYWFPbDFoVjJmZ2ZEUTRKTmVuRFBvNnU4TU1aVEQ2LzQx?=
 =?utf-8?B?bjArUVJ3amVjZTR2UWRrWnY0ZWIvNmtyY3ZnaVRvNmc5blJ4Q2pCdzFBd3cv?=
 =?utf-8?B?bzkySWJUZmdPc0tvRnJtcjQrekhZaEI4R2YvSXdYMEc3dEUyRG4wUFdUMUZZ?=
 =?utf-8?B?ZTZ0YzJmaUFyR1cybHpTS2NrTWZ5QVZRc1p4bktnM3lkMGFqZWZSdHJCekJt?=
 =?utf-8?B?K3pKNDExZURCQXI4OERaMWVWLzZub3VybXNPREI2SzRBSnpVUEdMMHV0M2x2?=
 =?utf-8?B?eHhjQ1VSMjZDVGNQK1J0Y1lkdERqQzNxZ2xPTytKY1VlTnpPM2JsNEt6UDcx?=
 =?utf-8?B?Z3F0SG5kQWtSc200K1I2WVVtSksrazl1RWVHcEZ5QUhzaEp1SGNVSGgzMlE3?=
 =?utf-8?B?R2hncTZmT3R6YUVmeHo3c0Y2M3lwaytnNTFVZmhDMVNBZ0E0bXgxU3c4QWUw?=
 =?utf-8?B?S3pqbFpLaUE3R1VaSGxNQjJOeUoyaWpaRkVkdWI0MkhrclcrTGo3a0VRZXA2?=
 =?utf-8?B?Qk1LWlN1b0VTMCtwR1E5WjRHS3RFb2VGUlZkdnpLUk1tTWhEejdCUGp1eWda?=
 =?utf-8?B?bGtVaER4OC9ROVE4UE96UEphb3VBUHhoUmJXVktQY09tNVFFTjdZZU10bWNV?=
 =?utf-8?B?UHVTcnpzSTNtaURGQjM1Znh5Z1E1NkQ0V2pGZW1HOHFPdkF0RmxsRldXanlo?=
 =?utf-8?B?UitXdWJIMG82ZDJJdVA4NXNSeVltM2lNdzhaRlhLelNjT1AvQ21xbk81UWNS?=
 =?utf-8?B?U0FWeXNHbjdHRXRIL0JRNnk5SFE4cldHRVVGd0RkbjgzVnBrRDM4WnJwVkhT?=
 =?utf-8?B?dXBra25adEN5aitwL3lVM01DQmN3NlRmUks4L2pVV1JWb1JINFZDTEJlTVpC?=
 =?utf-8?B?RVEybVZHNkZ6M2VQSDNvMVkvdGtweDFsOXNtNk1VeFR6WTQ0WXRXdTVsK1ZB?=
 =?utf-8?B?ZWVhSVZ1TitnakZsWWNtZ1ZBc09MT0N5dFp2NHRxbnRpeVdrQTR1bmNMRERC?=
 =?utf-8?B?Wk02clpFdWwrbmJQK1JTZStXZ0VkdGN3aHJKVUhCVDMzNkJyU0pUOFVMeC9T?=
 =?utf-8?B?akZhWWkyM24rUjM2cDJOcXFZTVBQUUhXUmQzMHdtNmZ3bjgvMXNvay9QSG95?=
 =?utf-8?B?WkVLOFo1YklMakRkcUpwMTROSDlyN0VUWHFsdFUraWtpTzg4SHptdHA0NnBl?=
 =?utf-8?B?bm81QUw3TUVYbndVenlqMTZqb1ZmVzU5MlZVRG1UYXMrRVBENkcvRDBKd1RF?=
 =?utf-8?B?NGdTYlVrcm1WemNoLys1MXoxckphcUZvSVlvV3JLTlRsOExPWXFCek93VFdM?=
 =?utf-8?B?YVpoMVlPcnZSTjRoNHRWT2lDUE9Xc2hBRm52OWxXOHRRQ21LQ0RXRGhrRzRt?=
 =?utf-8?B?Y0cwR3VLSGhjU2VyTU1XamNQZFhSQmRGbTE2a3lsQmlvOXZhQ3RKVEdKUkdN?=
 =?utf-8?B?S2pWTS8yY0FCajVjeHhYZjhoZWVtalpJajBxY3hqd2VKNzdZTXM1Z2h0aHZ4?=
 =?utf-8?B?d3k0UEV1RytYb0VQNGJuZDd4MnN0SGhpMFlLS291V3ltNGdDTDZFMEk1US9F?=
 =?utf-8?B?RXFVLzZ0ZVVUMEd0ZUVwOXQxUlgwc3BrRHBuRlM4Yk1uVmpEOFVoekwzQVla?=
 =?utf-8?B?VVZXZjF4M2FzcGp1SEtRMy9MbE5JSFdvcFBJeHBGRE9zQjlOR2s0dFlha1Vr?=
 =?utf-8?B?N29FL25rU0RSbDQ5dXBwK3NWL0NPVkF2WTB2R0x4eHdmWDM5OExWZU9RamFQ?=
 =?utf-8?B?MXFJR21oNzBPcVF0MmkxV1VTYXM4TXRGeWVBY296aUVSMGN5QUI4SmhVZlNa?=
 =?utf-8?B?MTZUYkVoeEluWFRtTU41clhMSUZCVXlod0RUR2F6VTF6YlRQN1pkdzgyaDY1?=
 =?utf-8?B?UzA4MzRTRWRMcHJDUm1IbEY1U0hzTWZRWFZTVFNHaEQzTVl6OE9BRjU0MTlC?=
 =?utf-8?B?SUYySHRNdTVxa01OQ09Cc001OUdxK0VGZGNaam5tMHpiU3V1ZXJadlVoMTN6?=
 =?utf-8?B?ZExIQjNrZE5qaWpQZnNtVTAxYjFGMEJyZnRDcDRZS05ta3d0TVNTbmdTQnJP?=
 =?utf-8?B?MDJnOEVWeWtPZlRJV2RFamRrbmNFcGQ3cnhyeWFTVTc0YWZJVWw1RHF4by8w?=
 =?utf-8?B?bytFNTYrYTRhZzBueW5kd094Mm9iVnA0dmQrV3FZMTFqTC9idEo0UEpDZWs0?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47260E9AD3627D4B93F7AB0CFB08B5A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237e75b-0609-4aa3-4ac3-08db24250361
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 00:42:39.1529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6KVO9orJrvAP8JnvxISHbn8TZJ22pFZfq+zCS6Pe3pW9nsV5uk3NZq96uA3Kf60rUZS/Z43TE3Vr00NRDyZIFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7915
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTEzIGF0IDEwOjE4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1hciAxMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBG
cmksIDIwMjMtMDMtMTAgYXQgMTM6NDIgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBVc2UgdGhlIHZpcnQgY2FsbGJhY2sgdG8gZGlzYWJsZSBTVk0gKGFuZCBzZXQgR0lG
PTEpIGR1cmluZyBhbiBlbWVyZ2VuY3kNCj4gPiA+IGluc3RlYWQgb2YgYmxpbmRseSBhdHRlbXB0
aW5nIHRvIGRpc2FibGUgU1ZNLsOvwr/CvSBMaWtlIHRoZSBWTVggY2FzZSwgaWYgS1ZNDQo+ID4g
PiAob3IgYW4gb3V0LW9mLXRyZWUgaHlwZXJ2aXNvcikgaXNuJ3QgbG9hZGVkL2FjdGl2ZSwgU1ZN
IGNhbid0IGJlIGluIHVzZS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4g
PiA+IC0jaWYgSVNfRU5BQkxFRChDT05GSUdfS1ZNX0lOVEVMKQ0KPiA+ID4gKyNpZiBJU19FTkFC
TEVEKENPTkZJR19LVk1fSU5URUwpIHx8IElTX0VOQUJMRUQoQ09ORklHX0tWTV9BTUQpDQo+ID4g
PiDDr8K/wr0vKiBSQ1UtcHJvdGVjdGVkIGNhbGxiYWNrIHRvIGRpc2FibGUgdmlydHVhbGl6YXRp
b24gcHJpb3IgdG8gcmVib290LiAqLw0KPiA+ID4gw6/Cv8K9c3RhdGljIGNwdV9lbWVyZ2VuY3lf
dmlydF9jYiBfX3JjdSAqY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrOw0KPiA+ID4gw6/Cv8K9
DQo+ID4gPiBAQCAtODIxLDcgKzgyMSw3IEBAIGludCBjcmFzaGluZ19jcHUgPSAtMTsNCj4gPiA+
IMOvwr/CvSAqLw0KPiA+ID4gw6/Cv8K9dm9pZCBjcHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVh
bGl6YXRpb24odm9pZCkNCj4gPiA+IMOvwr/CvXsNCj4gPiA+IC0jaWYgSVNfRU5BQkxFRChDT05G
SUdfS1ZNX0lOVEVMKQ0KPiA+ID4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19LVk1fSU5URUwpIHx8
IElTX0VOQUJMRUQoQ09ORklHX0tWTV9BTUQpDQo+ID4gPiDDr8K/wr0JY3B1X2VtZXJnZW5jeV92
aXJ0X2NiICpjYWxsYmFjazsNCj4gPiA+IMOvwr/CvQ0KPiA+ID4gw6/Cv8K9CXJjdV9yZWFkX2xv
Y2soKTsNCj4gPiA+IEBAIC04MzAsOCArODMwLDYgQEAgdm9pZCBjcHVfZW1lcmdlbmN5X2Rpc2Fi
bGVfdmlydHVhbGl6YXRpb24odm9pZCkNCj4gPiA+IMOvwr/CvQkJY2FsbGJhY2soKTsNCj4gPiA+
IMOvwr/CvQlyY3VfcmVhZF91bmxvY2soKTsNCj4gPiA+IMOvwr/CvSNlbmRpZg0KPiA+ID4gLQkv
KiBLVk1fQU1EIGRvZXNuJ3QgeWV0IHV0aWxpemUgdGhlIGNvbW1vbiBjYWxsYmFjay4gKi8NCj4g
PiA+IC0JY3B1X2VtZXJnZW5jeV9zdm1fZGlzYWJsZSgpOw0KPiA+ID4gw6/Cv8K9fQ0KPiA+IA0K
PiA+IFNob3VsZG4ndCB0aGUgY2FsbGJhY2sgYmUgYWx3YXlzIHByZXNlbnQgc2luY2UgeW91IHdh
bnQgdG8gY29uc2lkZXIgJ291dC1vZi0NCj4gPiB0cmVlJyBoeXBlcnZpc29yIGNhc2U/DQo+IA0K
PiBObz8gIFRoZSBrZXJuZWwgZG9lc24ndCBwcm92aWRlIGFueSBndWFyYW50ZWVzIGZvciBvdXQt
b2YtdHJlZSBjb2RlLiAgSSBkb24ndCBoYXZlDQo+IGEgc3VwZXIgc3Ryb25nIHByZWZlcmVuY2Us
IHRob3VnaCBJIGRvIGxpa2UgdGhlIGVmZmVjdGl2ZSBkb2N1bWVudGF0aW9uIHRoZSBjaGVja3MN
Cj4gcHJvdmlkZS4gIEJ1eSBtb3JlIGltcG9ydGFudGx5LCBteSB1bmRlcnN0YW5kaW5nIGlzIHRo
YXQgdGhlIHg4NiBtYWludGFpbmVycyB3YW50DQo+IHRvIGxpbWl0IHRoZSBleHBvc3VyZSBmb3Ig
dGhlc2UgdHlwZXMgb2YgaW50ZXJmYWNlcywgZS5nLiBgZ2l0IGdyZXAgSVNfRU5BQkxFRFwoQ09O
RklHX0tWTWANCj4gZm9yIGEgdmFyaWV0eSBvZiBob29rcyB0aGF0IGFyZSBlbmFibGVkIGlmZiBL
Vk0gaXMgZW5hYmxlZCBpbiB0aGUga2VybmVsIGNvbmZpZy4NCg0KSG93IGFib3V0IGRvaW5nIHRo
ZSBlbWJyYWNpbmcgdGhlIGNvZGUgdG8gZG8gdGhlIGVtZXJnZW5jeSB2aXJ0IGNhbGxiYWNrIGFz
IHRoZQ0KbGFzdCBzdGVwPw0KDQpJIGxpa2UgdGhlICJjbGVhbnVwIiB3b3JrIGluIHRoaXMgc2Vy
aWVzIHJlZ2FyZGxlc3Mgd2hldGhlciB3ZSBzaG91bGQgZ3VhcmQgdGhlDQplbWVyZ2VuY3kgdmly
dCBjYWxsYmFjayB3aXRoIENPTkZJR19LVk1fSU5URUwgfHwgQ09ORklHX0tWTV9BTUQuICBJZiB3
ZSBkbyB0aGUNCmFjdHVhbCAiY2xlYW51cCIgd29yayBmaXJzdCwgYW5kIHB1dCB0aGUgQ09ORklH
X0tWTV9JTlRFTCB8fCBDT05GSUdfS1ZNX0FNRCBhcw0KdGhlIGxhc3Qgc3RlcCwgaXQgaXMgYWxz
byBlYXNpZXIgdG8gcmV2aWV3IEkgZ3Vlc3MsIGJlY2F1c2UgaXQncyBraW5kYSBhDQpzZXBhcmF0
ZSBsb2dpYyBpbmRlcGVuZGVudCB0byB0aGUgYWN0dWFsICJjbGVhbnVwIiB3b3JrLg0KDQpBbHNv
LCBwZXJzb25hbGx5IEkgZG9uJ3QgcGFydGljdWxhcmx5IGxpa2UgdGhlIG1pZGRsZSBzdGF0ZSBp
biBwYXRjaCAwNDoNCg0KIHZvaWQgY3B1X2VtZXJnZW5jeV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9u
KHZvaWQpDQogew0KICNpZiBJU19FTkFCTEVEKENPTkZJR19LVk1fSU5URUwpDQotCWNwdV9jcmFz
aF92bWNsZWFyX2xvYWRlZF92bWNzcygpOw0KLSNlbmRpZg0KKwljcHVfZW1lcmdlbmN5X3ZpcnRf
Y2IgKmNhbGxiYWNrOw0KIA0KLQljcHVfZW1lcmdlbmN5X3ZteG9mZigpOw0KKwlyY3VfcmVhZF9s
b2NrKCk7DQorCWNhbGxiYWNrID0gcmN1X2RlcmVmZXJlbmNlKGNwdV9lbWVyZ2VuY3lfdmlydF9j
YWxsYmFjayk7DQorCWlmIChjYWxsYmFjaykNCisJCWNhbGxiYWNrKCk7DQorCXJjdV9yZWFkX3Vu
bG9jaygpOw0KKyNlbmRpZg0KKwkvKiBLVk1fQU1EIGRvZXNuJ3QgeWV0IHV0aWxpemUgdGhlIGNv
bW1vbiBjYWxsYmFjay4gKi8NCiAJY3B1X2VtZXJnZW5jeV9zdm1fZGlzYWJsZSgpOw0KIH0NCg0K
V2hpY2ggZXZlbnR1YWxseSBnb3QgZml4ZWQgdXAgaW4gcGF0Y2ggMDU6DQoNCiB2b2lkIGNwdV9l
bWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKQ0KIHsNCi0jaWYgSVNfRU5BQkxF
RChDT05GSUdfS1ZNX0lOVEVMKQ0KKyNpZiBJU19FTkFCTEVEKENPTkZJR19LVk1fSU5URUwpIHx8
IElTX0VOQUJMRUQoQ09ORklHX0tWTV9BTUQpDQogCWNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2Fs
bGJhY2s7DQogDQogCXJjdV9yZWFkX2xvY2soKTsNCkBAIC04MzAsOCArODMwLDYgQEAgdm9pZCBj
cHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCkNCiAJCWNhbGxiYWNrKCk7
DQogCXJjdV9yZWFkX3VubG9jaygpOw0KICNlbmRpZg0KLQkvKiBLVk1fQU1EIGRvZXNuJ3QgeWV0
IHV0aWxpemUgdGhlIGNvbW1vbiBjYWxsYmFjay4gKi8NCi0JY3B1X2VtZXJnZW5jeV9zdm1fZGlz
YWJsZSgpOw0KIH0NCiANCkNvdWxkIHdlIGp1c3QgbWVyZ2UgdGhlIHR3byBwYXRjaGVzIHRvZ2V0
aGVyPyANCg0K
