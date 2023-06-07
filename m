Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5740725A07
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbjFGJVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 05:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbjFGJVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 05:21:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5731712;
        Wed,  7 Jun 2023 02:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686129670; x=1717665670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=r4QfkHNteOb2dAMatCWf0Gtn/i2Oiz1FHrCnoNlIwpU=;
  b=GOrf5o5ccZVmXyOpJkt7B9+IWjuD12ExgrPY2cO/OKrMFYRx1/8NUKuF
   +cjM8BhUz4xtWdtySftX5gqzsE8BfZA/0ACCM5kX0qrjene7HQIphds5L
   +splI1zVmRQrhdwq9zJTMvk8abyGPgYiLjHsqD00wRzSS8kFYOCGJek4T
   Kr05LLUB06YcGFBdvmVr9nQRRrVaccQrrcBrCJdWH8KkOQpkOznfIcrTw
   jDfksFGz4eWk0A6OaTwb5L7+SsEGrAoDAjmRiJwmxh++Y8dZ+pyPVJyxE
   /p/vos0VyhmRnipOtJMcYVup94s8XzwV3zbSTfbsgqop8xckhcugQEvWc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="336559109"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="336559109"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 02:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="659858303"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="659858303"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 07 Jun 2023 02:21:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 02:21:08 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 02:21:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 02:21:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 02:21:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1EL6abe14d9R2EZF4LyAzHT2Oc2O/omcUU1+PZtqSlr9q7Yy4Ths4QBrGNj711lk42g0v1ST43H4cQO1EIhoMt4uNJSkirXDdz8wrTyR0AejF0Yr7foloyTFBb+W92J7b+9z89doA5ywXAHC2XaWWLybWDG/qMYKxULzD6WkQUOIQL0PvefUhRcEsdvpRg0FBFBbZweVHstF/quYCxXLfjL28gbRoOdcSsDoj6ocESYHS/PAuNfFDfCeGhB2rI2qPAHiXqAthjyHMKCzJZ5IbWQhCQsi7YPonQsGor7M/e3HJBrBu7EDe3xAe4EdChsHDBPxfDpSalateaV/N0jtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4QfkHNteOb2dAMatCWf0Gtn/i2Oiz1FHrCnoNlIwpU=;
 b=FgAIxZQSkn9sqjqglqrc3gxC73BuHdueJWVSSkoy1xMDHk0dPYIa8XrKE18B2PE/D23eaqdx9T44mi8rBvnV8MJ4fmZLnPXTK+a7gxYJIocBpEc9qCDJcfeQfPdcVWMdS9BV1nkrSAg/eT1WOBl6s4iAPQutRtTGV4ycfurN6QkDDYaK4E7patvjrn4Jn+rzV9e4JllARM1Fn+MRW8K48Qhqe8TwDm8z7phphydDAdbNJYHHs7fFMaYGFe5q7PfpdQchOIoqi7sDQcw4rCr4syo0e2EoT9rAXV8XykejciPBT9tGcPxXlII+FTvEEEHoAzzJqTlve7QGq0kERy0dXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7162.namprd11.prod.outlook.com (2603:10b6:303:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 09:21:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 09:21:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Topic: [PATCH v9 2/6] KVM: x86: Virtualize CR4.LAM_SUP
Thread-Index: AQHZmFfuANh3ioR480+bw2zBFwe+E69+svKAgAAU64CAAEougA==
Date:   Wed, 7 Jun 2023 09:20:59 +0000
Message-ID: <b92e080b85c21edcea5d47caf2e8502b8be46bb1.camel@intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
         <20230606091842.13123-3-binbin.wu@linux.intel.com>
         <fbc522e315d261607869b1996adc05e3646e535e.camel@intel.com>
         <4c8c0d6e-8bb4-495f-3f41-6dee8c358124@linux.intel.com>
In-Reply-To: <4c8c0d6e-8bb4-495f-3f41-6dee8c358124@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7162:EE_
x-ms-office365-filtering-correlation-id: 17aa5572-9e83-4f95-ccff-08db673881db
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q1BDVJ1PB7XJAgujIHMaFApret6+Ad5Vf6MNJEGzxpOPjewCdS+/M/rUX1LBEdy12yGV22SFLgaygn6epH5mk/bOGNF50UI5kAKoZ0/X8PEdFfwwN+YeSZejIT7yrjKLw9drX44urAQz9DFrrGGxOBaDLCUP+TOVD3HEuLbZduzC4KBCBsKBbP9bPWkwBh+5FsmL316van9upGVViFBNqvYPyRRGeYeReCmBOsUz7u62YYDZslse2INlB2TuFzXxw/n9fBqKxBvWM58ab7AzXK5Ie35DAtRLFVhOwR9zGp+YhTxvqXC+mEieoDPAzq33FYlpTL9MY3CbhB8O6viqdp7CnD4dqD1pgwccEQk6WCz4R+yOYKRFwwprav8q1s8F/iJBOQymxSFCLO1008oLMcAVBY6uz95LY0YS4po7nM3GbWantbi72yWZeRPzreKu4qk2JLW88GWbf5dS5rF3Ko1ztiI1v8tRHQs7hItgFmhZ1M1zppL2YFKKWEHL7k8Zg/9QuaLKo9odVTAYI5sQGaNENwykgfcF+T/pvgUw5L8C/6HqzT4/JTrp4VgE38HeuTG09XmeYvUTTl4+10VPmaH5g1wVAvkd26ZEpZqfX2I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199021)(478600001)(66446008)(71200400001)(38100700002)(36756003)(82960400001)(76116006)(91956017)(66946007)(122000001)(4326008)(6916009)(66476007)(54906003)(86362001)(8676002)(8936002)(5660300002)(64756008)(2906002)(38070700005)(316002)(41300700001)(83380400001)(66556008)(2616005)(966005)(6506007)(26005)(6512007)(53546011)(186003)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L1NNS0JlNU1OWnJkRjZuL0czNUtiRDQyNzhZT25NS3IyZjFoTVBPamVaVGZq?=
 =?utf-8?B?OWJBSW5aOUpvWlc2WDUxeUNYQXFYbk4xdDh1UVRkSUhjKzBHOU0zRkhOZDAr?=
 =?utf-8?B?TlhTaFZtL0dUUUsvY0NJYTZzdlZNUURYb21xRFpJN1ZkL2xuYnBtTm80a0kx?=
 =?utf-8?B?TnB4c09jaFd4UkFwaGJqbXZLV0x4T1hRaHJzQmtEUEovTEFMQUxDVkZlbVdS?=
 =?utf-8?B?YmxZRkgzdHJja1BpRk9qQ28zUGc4WFdSbTlmYkM3V1NZb2RYUHc3OWErUkZX?=
 =?utf-8?B?V1BkVTByOHZFQ2M1RDNEMW9ZajA4UmhHVTVWYlB4VGFZdmxsZ05rdnpPSTNq?=
 =?utf-8?B?ZllORUdjZklMMWRaNHhOejlsa3BGaEhkTFBqYnZCczM4ZlU2YUZCRGg1VVhh?=
 =?utf-8?B?T1JCSnZjcTM0MmR6WVo0NVgwMHdXMGhaVmIvN2ZwRmg0UlI0WnhONmJsd0Ns?=
 =?utf-8?B?akRhYUdqT0RYMGFzT3NiVVUxUmxoaVF4WEhhdGhBVkE5dS81aWhiTUVhUEZR?=
 =?utf-8?B?dzdrUnB2NlRLN0VRM0d6VnpJU2xYNHJkaGxjKzM0M1d3L3ZObkFseHQ4TXhF?=
 =?utf-8?B?ZnoxclZyNm04WTRYTUR3UXlYb2kzelpmdUxxWGVnSTFJcUhPM2hKTHBPTHh2?=
 =?utf-8?B?Tzh5TUtQYkxCendBeUliRTNnUGdib3BnRTl1ZGU5ZXVRd1ErNnZXeURGMUQy?=
 =?utf-8?B?a2JrSk9aYmdsK3k3ZDJuR25HdWM3T0plS2pOM0xDU2g0ampGakI0MnU4ZVJn?=
 =?utf-8?B?TENreUZzZUptZFNWU2NqRkNNOS9EVXRBMGd0ZThJbTBieHoxWkpBbXYyWDll?=
 =?utf-8?B?RGJia1VrNys3aE5pNWFMOGxQdFVjVXgweDJvVFZNK1ZkT05QQ29wWVNiVjdN?=
 =?utf-8?B?YTJIeWxzNXZyWnhVWnc0eXR1alljSTZBRWxScXF0YnZ2dVVvWmJnR1l3QkJl?=
 =?utf-8?B?TFhlVjJSc1MxSmdoNzRLaEh6eUloU3E3Y0ZhaTRYeC84NjhuMnhDUjRmUWdS?=
 =?utf-8?B?cTBGMlFyV2syMVRZdkdPdHd0MVJ2dVNDWk5Uc3RlL3lGdkhpbVNYcS9BVG9C?=
 =?utf-8?B?Q3ZrUXNpNFIxSSt3d1UwVkRTMllpWWxUdFRGNEhPelhXOVpZcTJWaE1xMVEy?=
 =?utf-8?B?aWJVZUkxWk9ZZDhyR25XUDB3c2JyTEhIb1oyeXMrckUxOENpbG9uMEwralJu?=
 =?utf-8?B?QTJGTERLUXEzSDYybXJuQ3p4ZlBENEVtZXlSZ2VzbEZyRjBKMWdwZ3RjUk5p?=
 =?utf-8?B?SlJMMVVoeVVHaENVSFR3aE1Fd3pqYWF0TlplQVk2aC9wOW9rTy9hcEhRVStQ?=
 =?utf-8?B?Z1ZJTllkRmpoVU9jR21TRHhLSzdKTGovbkNVOTNMZ3dyOUFJaFNHa2pKVElF?=
 =?utf-8?B?b1M4REZaUGY4RWM4WUZjbC9jU3UvdUtsbFd2VkxwaVl0UDdSUXRjSituajNp?=
 =?utf-8?B?cG05V2dVdUJoaUZPWVZaQ3FONjVWdEZOdVREOG42dHNncFNram5CTFF1S0hN?=
 =?utf-8?B?d0xkRFVPYTZnODJPbHZLWkJRYlJWUnhITVk5dWduVkV0dHJFcnI5Zjl6RkN2?=
 =?utf-8?B?Zmh4RllSa3JjTjVQY2ltREtRRWU5S1hQeGZ0MExOa2RFdkJ0d1N6M1VIamRY?=
 =?utf-8?B?WTBWbUcwRWFCNEpjclVLLzJYT2VyNXp5bmV5dElrdjI3bCtKODJYVXRqaFQ1?=
 =?utf-8?B?UjJRSHBGeUNnSDhPWFJqQ1BaMi9mQW5hUUFDTkhNOWNGUGRLOExESXFhOUxK?=
 =?utf-8?B?ZXhBVjN2TGZRSk9scGdIR3BoeTdTNWVVbXk3UjNPcGRLZnRxVDdqMkYxcVNx?=
 =?utf-8?B?QUwxUTZkUEhJZDY1TE9aOWZWMXpGY0oyZmQ2QWNOQ2JZNnE2Ujd3VXJOVitG?=
 =?utf-8?B?OGhYWnlQRkc3OWthVnVETUl6QWFWM3BvdFBvanFrdXRxQlAybFBDaW9WbFlV?=
 =?utf-8?B?eUNCa1ZSYllUVmo5WUVoWWJMcEFaeGtoQWJaVGkrcUdDVHUwWDVZeVp2NE1X?=
 =?utf-8?B?UWRzaFljUjkyRVlIeCt2NGNBVXdUM2lqcHQ0TEo5ZVU3bm1CMWsvekxxdGV4?=
 =?utf-8?B?STNqblNKeGtoR0lneUl1K3pDVzhTTDcvcFduRWNiWmxoMGVEL0Y2c1c3K1VI?=
 =?utf-8?B?N1BvNUxnYWRaMlBXL015Mko4NGg4cktGbzI4cFVCUnVUZ1AxdzRBSTNJcVVl?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BAB07634CDDD348BB4EE89112BAFC1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17aa5572-9e83-4f95-ccff-08db673881db
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 09:20:59.7305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kEev/HlIYPwBrTr2uiFdU/z0vDFIbBpBuqgX2qZcscKS014DWkZ66mhxqhcmrK/kX1bLnd/sZdntfgdXMX85w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7162
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDEyOjU1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiA2LzcvMjAyMyAxMTo0MCBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBUdWUsIDIw
MjMtMDYtMDYgYXQgMTc6MTggKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToNCj4gPiA+IE1vdmUgQ1I0
LkxBTV9TVVAgb3V0IG9mIENSNF9SRVNFUlZFRF9CSVRTIGFuZCBpdHMgcmVzZXJ2YXRpb24gZGVw
ZW5kcyBvbiB2Y3B1DQo+ID4gPiBzdXBwb3J0aW5nIExBTSBmZWF0dXJlIG9yIG5vdC4gTGVhdmUg
dGhlIGJpdCBpbnRlcmNlcHRlZCB0byBhdm9pZCB2bXJlYWQgZXZlcnkNCj4gPiA+IHRpbWUgd2hl
biBLVk0gZmV0Y2hlcyBpdHMgdmFsdWUsIHdpdGggdGhlIGV4cGVjdGF0aW9uIHRoYXQgZ3Vlc3Qg
d29uJ3QgdG9nZ2xlDQo+ID4gPiB0aGUgYml0IGZyZXF1ZW50bHkuDQo+ID4gS1ZNIG9ubHkgbmVl
ZHMgdG8gZG8gdm1yZWFkIG9uY2UgdG8gY2FjaGUgZ3Vlc3QncyBDUjQsIGFuZCBwcmVzdW1hYmxl
IHZtcmVhZCBpcw0KPiA+IGEgbG90IGNoZWFwZXIgdGhhbiBhIFZNRVhJVC4gIFNvIEkgZG9uJ3Qg
c2VlIHRoZSB2YWx1ZSBvZiBpbnRlcmNlcHRpbmcgaXQgaWYNCj4gPiB0aGVyZSdzIG5vIG5lZWQg
dG8gZG8uDQo+IEhlcmUgaXMgdGhlIGRpc2N1c3Npb24gYWJvdXQgdGhlIGdlbmVyYWwgcnVsZSBv
ZiBpbnRlcmNlcHRpb24gb2YgQ1I0IGJpdC4NCj4gU2VhbiBtZW50aW9uZWQ6wqAgIkFzIGEgYmFz
ZQ0KPiBydWxlLCBLVk0gaW50ZXJjZXB0cyBDUjQgYml0cyB1bmxlc3MgdGhlcmUncyBhIHJlYXNv
biBub3QgdG8sIGUuZy4gaWYgDQo+IHRoZSBDUjQgYml0DQo+IGluIHF1ZXN0aW9uIGlzIHdyaXR0
ZW4gZnJlcXVlbnRseSBieSByZWFsIGd1ZXN0cyBhbmQvb3IgbmV2ZXIgY29uc3VtZWQgDQo+IGJ5
IEtWTS4iDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9ZN3hBNTNzTHhDd3pmdmdEQGdv
b2dsZS5jb20vDQo+IA0KPiBBbmQgQ1I0LkxBTV9TVVAgdmFsdWUgd2lsbCBiZSB1c2VkIHRvIGRl
dGVybWluIHRoZSBMQU0gbW9kZSB3aGVuIGFwcGx5IA0KPiBMQU0gbWFza2luZyBpbiBpbnN0cnVj
dGlvbiBlbXVsYXRpb25zIC8gVk1FeGl0IGhhbmRsZXJzLA0KPiBhbmQgaWYgdGhlIGJpdCBpcyBw
YXNzZWQtdGhyb3VnaCwgaXQgd2lsbCBiZSBhIHZtcmVhZCBpbiB0aGVzZSBwYXRoZXMuDQoNClll
YWggYWdyZWVkLg0KDQo+IA0KPiA+IA0KPiA+IEJ1dCBwcmVzdW1hYmx5IEkgdGhpbmsgd2UgY2Fu
bm90IGFsbG93IGd1ZXN0IHRvIG93biB0aGlzIGJpdCBiZWNhdXNlIEtWTSB3YW50cw0KPiA+IHRv
IHJldHVybiBhIHZhbGlkIENSNCBpZiBMQU0gaXNuJ3QgZXhwb3NlZCB0byBndWVzdD8gIE90aGVy
d2lzZSBndWVzdCBjYW4gc3RpbGwNCj4gPiBzZXQgdGhpcyBiaXQgZXZlbiBMQU0gaXNuJ3QgZXhw
b3NlZCB0byBndWVzdC4NCj4gPiANCj4gPiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KPiBSaWdo
dCwgdGhpcyBpcyBhbHNvIGEgcmVhc29uIHdoeSB0aGUgQ1I0LkxBTV9TVVAgYml0IHNob3VsZCBi
ZSBpbnRlcmNlcHRlZC4NCj4gV2lsbCB1cGRhdGUgdGhlIGp1c3RpZmljYXRpb24uDQo+IEkgc3Vw
cG9zZSB0aGlzIHJlYXNvbiBpcyBlbm91Z2ggZm9yIGp1c3RpZmljYXRpb24sIHdpbGwgcmVtb3Zl
IHRoZSANCj4gcGVyZm9ybWFuY2UgcGFydCBpbiBjaGFuZ2Vsb2cuDQoNCkFueXdheSwNCg0KUmV2
aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KDQo=
