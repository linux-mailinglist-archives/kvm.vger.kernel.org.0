Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419A36EA6C5
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDUJSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDUJSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:18:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378C583D1;
        Fri, 21 Apr 2023 02:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682068721; x=1713604721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OETLn0tM0/BHcq/RFX8yM5pj+JenjHCEFDVB5Qn7wKg=;
  b=IWuPBIgjo2XxJRTTO1kjFC+9rSUPgA7lrZMwq3oCq54O8OW98y86wW7z
   f90cOETdlqUrX3XRfODZVteN++YeCpwslCf/4TDIzJTnmijKWzAWx7KFt
   Ui7MnqURX5SaHCNRwD5CkUlWojFfzl+8MkugxgGhRv6o+tlU0DX8qAI/B
   p8okQICZG0eqYDd9U6xh8nLH1s+jC7xH3QjVTIKwWPb4T5eXYtJHYhgTD
   0oZcv6oem7SkrvSFKhutOuVqUGx9GHQ8GzioNaY2uwuFc5xD2RsYL8iWM
   7IIrmmFG3+8sJXoXCMUqM95wrtwSdpBw0SDFmkPDuVj5kqbLAwoRtt0D6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326280024"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326280024"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:18:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="803666936"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="803666936"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2023 02:18:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:18:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:18:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 02:18:40 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 02:18:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7ylXIuM2lFQvEYy5gbJ2Gp4/rDBIIw/7FQYibDIg7wmLe/MxARWZnwtB9quxDEE1ylfg6UtKfFs+2e3uWxFNEivbBRSsFhG4aNEMt6UnhyIQcFMjRSgefsH1XFYMJQMynXGhzbY9WhGsjksSx1/l4FAg5w//xi8/rkxMqkt4HV7T8oBR6IjgolGfaNwXX2jmwjObTtfimLsdGO9WOSfO73Kvd4SxPNMDxsLk1cAKkHlYTkpW90nNRELPYKdjQL5Xro13VIFUMlfN7TiT/eQy+xB7KSt9MMDwhJj3EaLXwVV/Lhj+0cwjVYUQsEJ40tbsZB3YMfyWUQ0BjicIjl4kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OETLn0tM0/BHcq/RFX8yM5pj+JenjHCEFDVB5Qn7wKg=;
 b=dkZU4GlqSbCwR+7UQy2pbqQTqOqoAfIWxQhHFKUjz9Y1J4hVb93l7EDYlfG6+ztr1/jCUns+gAag13N1ayiI2fFNQjPbcuEy8l+D6qt+s6AP+955gfT5rajGAH/VxqGYqRsHmA1mnL5sLNsvjcDTJtTqUEQsJp8G2LjnY2EAwm2KLfEYf/xfRWI7URciZxUcLte2wXL3TEnFV9T847qpoHlCKH3cOsBz/nrvBlNe3Qi6BWUQ5b2MeV+cL+6/n1Uw+yb5w0b1y+Kox/PN1nHAxd/dAz6AJF2wt6rIA83s7F9LNF9wan+Z1nFqa0p8njIs59I8C+VEjV2XwfWex/3G5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 09:18:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6298.030; Fri, 21 Apr 2023
 09:18:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Inject #GP on ENCLS if vCPU has paging
 disabled (CR0.PG==0)
Thread-Topic: [PATCH 1/2] KVM: VMX: Inject #GP on ENCLS if vCPU has paging
 disabled (CR0.PG==0)
Thread-Index: AQHZaBjTnv3Xw4rSL0WDrKfMqYpF1K8d+rGAgBeZmQA=
Date:   Fri, 21 Apr 2023 09:18:36 +0000
Message-ID: <0f4ce335514602dce385a162548aa465865ebbae.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-2-seanjc@google.com>
         <082ff217ecb7633ef4c1363bfd27a20f8afcbe0c.camel@intel.com>
In-Reply-To: <082ff217ecb7633ef4c1363bfd27a20f8afcbe0c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7708:EE_
x-ms-office365-filtering-correlation-id: 402e40d6-6a30-458b-2542-08db42496354
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9/pU5CbD2GdBDhR+1x+gowtKaFifQf1uSEEXcxy0j7+4uFc42cnL4xss/c9s26b5JhJWyIERu2UlpW2/4elpwP9CraqFsXPhvsUbyqXwoTYrRtswAKjjVtVkj8Qqo+aIp7pLyn3/CF+RITZZE1iM7WiLA2GB/VsVh6ELttXseH0+pmFeZkr7gUh1rQrxNdnssDQR+f7Jh8FYHfEZdM+QKrNbwXPPsgR/7tGDNT7m8eTeNcw9z+fmtiDecNPZxaA2J4TvILrlohyx0O4mshn2siaTJcAeAhAui0P9r3xONuhTAj9BzMaursbdgHbHJkQueoTM73C1XR70mm7YC8n/I2Z4+9vMDL23ANgNEZXHCTX5q42En6Dqt0mEVztqlMGt8mqXlsTnP9GrFZKVD0A5PJmHtA8YNSHNaZ9FCiNIdk3buLYTcFCDC/LnN4qJErQtFScit3pEoqe0brf/F0ZUNYZVirlPytlxJUbrQ8b2LnuhPY4jEqTJNQd/ow4YVLbZaZVfob1jN5I8G1cxn7OJhwMRBxJ4yDVTq6rowZhXXaq9PnYprC/yP6yzCvlia5/dcZxG7HChKueVxCfYVdJck8Du+GUVQFw09oSPSRQNoa1EhCUUDT0e+5+z2biNnMNs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199021)(2906002)(4744005)(38070700005)(8936002)(8676002)(122000001)(41300700001)(82960400001)(5660300002)(38100700002)(36756003)(86362001)(478600001)(54906003)(110136005)(2616005)(26005)(6506007)(6512007)(71200400001)(6486002)(76116006)(91956017)(186003)(66946007)(4326008)(316002)(66446008)(66556008)(83380400001)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUNDZUpkTTEwT3pZMnNZdmRRZG9aMjVnYkNGeHZ5OHRjd01FSVJjQUdubEFm?=
 =?utf-8?B?RUE4WEIzVFlRYXozNkZjbWY1UEFZUXhDaXpLWmJ5dWMwb2Z2b245MzBNdURm?=
 =?utf-8?B?aXZtK21nNUlOQ2VGQmp3cEhKQlhsSTFHZW1yY2ttSXorQi8yUlRvQktsMEEz?=
 =?utf-8?B?QkxLdGdaRWJaSDFIbHJtNVhXeW81NVJUeCsveW9uVGVoVXNYZlE2VmhibHBN?=
 =?utf-8?B?ekw5UXlPUUVVdlV3dFBWQUNzZm44aUpmdVkrdEpma2I1cHdrWkVjbFl1S1Js?=
 =?utf-8?B?WUtkMm4rNHpnUWMwQnJTMkhmd2JjQ2RDL0UwWE1CRG9GVHI1QVhCT1RIZ0Rw?=
 =?utf-8?B?UjRSU2xFVXA4NzZ2aHdlTmxnY1ZkNHNSZ0ZWMUxhcU5RYzRpZUFHVVlvdFhI?=
 =?utf-8?B?cmRXeE5ocFlmdEpEcHU3dFRYeUhuVkg5dTFsMWlVVEMva2pEVTdlR2R5QS9n?=
 =?utf-8?B?V3RuSC9XOHdwMzAvWW10NlM5eVhGOVlxMndrNzBnZmR0cVFUZWtkTFdCWTYx?=
 =?utf-8?B?bDM2VkVSZ1B3WitYMmJsTzRzQjN1MnF6UHEvV2pUYk9kWEFlYW8yQjdyeHdj?=
 =?utf-8?B?M1NGVk85RXhLSkVpd3E5NGY4ckJ5NHp3anBMN1JyRWtac2UzSTEwK0xibllG?=
 =?utf-8?B?ZHRkNVBCa0xGdzM1aHd1RDdpcmpPTEw0UVZoaFF2UE8weUh1TldCYURxVWxw?=
 =?utf-8?B?eEZVbTZOdk9xSG5LTkc0ZkF3dk1ZbUU4eXpHT2JoQnhPMjZjKzhVTDl6cGg0?=
 =?utf-8?B?RzFWTkhHQTdwT1EvcXdCeTJoRVh6TnhtWHpnQ3ZIN2t5aXNXUGVuZFM5TElz?=
 =?utf-8?B?bFd6aStXSm04MXN3aWNFbjhaNVBRUXhTVzBqWnMzMWp5VCs2LzltTlZLLy9a?=
 =?utf-8?B?L2V4b3pyVGFyY3Q5NUVlSGx6NldZeUIrSUFCTWxpeWR1YURsTmd0VFdaNFk3?=
 =?utf-8?B?Rk1zYUZqSVpCcFVhMGRIOTdZYWR2S0pRRkNrUEdNZldab3FzKzZVMlpSQmo5?=
 =?utf-8?B?U3FFTnJpZWdOMzNCOUZ6ZzNvWi9ZSURXdXNZUWl0N0t3dmZ5YTE1YVNzNEZX?=
 =?utf-8?B?NTdZZ1RoK0Y1OHBMRnpac0RrZXNjdWpjekcvM2tSRHVuUmpXTkZSU21WT1h2?=
 =?utf-8?B?ckxPd1MrbGw3NzVZTjczQ3AyQ1pITUcrUHFWc1hwUnVraC9sWVU1V1RnRFh1?=
 =?utf-8?B?cnphbjRQejQwZ3kwN3AxcVNGci9aKzAzUitDUVc2am9DeHdXemgvY3o4TjlH?=
 =?utf-8?B?L0lTajFWd0pFV3FHbmtQaXJYUUlNakVoR2NadFJLTFJXalVqeHF3WWsxeEov?=
 =?utf-8?B?cDN0Yk9UM09qVTBQMXRncm9mdDJUTXNDT3NLZXNQU3luQjF5RjFta1Avc3hQ?=
 =?utf-8?B?T1BZNHlwZHU5UGhtMGZKWGtidmkxWnNKcnpUNlc1ZDVhSm16NlJCMmpiTnBM?=
 =?utf-8?B?Vjg5bW9ZUi9aQmRUeitFNnFJOVA5VE9zV3M5dFNudHdaVWRLa0VNbGpFNnhm?=
 =?utf-8?B?ZTltNUsvaEE5UllNRFZNLzBXOERNSUFpZWN4Ujl4aS9NbytmM1VPSDhmeXJZ?=
 =?utf-8?B?d1J5K0RybEtSK2Z4Q0VTZjhlZkE2c2NqR2ZoYjYvajMyK1hFU1lDTXFFZko3?=
 =?utf-8?B?bWxUOWRMdzdFRDF3NzA4TFBJdnhuMEM0NWMyV3JpeU0vTTlSeEJiSis0c2No?=
 =?utf-8?B?YzhCdEZxRGQ0NGNIRS9zakxjRnNVZGgwYTF1dnJYMzlFbjViZXNvOEh0RFRy?=
 =?utf-8?B?bWlzbmhSbTh4L1MxS3NwZ0lNVEZsSU0vV2tvWkVsVkpCYTVORFhNYmZ3K2J6?=
 =?utf-8?B?UjBabjlVbW0xUkhQVm1UdDBWaUd5UWVEbXlHT3B5K0NrR2szMExMTmNqZEtp?=
 =?utf-8?B?eUFRdWdTTngrTWpaNXZwby91VkdLekhSemlhcUZDelVtTFFwSVNneit0bm9k?=
 =?utf-8?B?RHNkNmhJem9QTzdDN2xvR01IMHBLMzhxbVJmOUxDcDRGOHRFZmRJMzRzU1Fq?=
 =?utf-8?B?TWJyWUpBRlJVWi9LRUw5QnJIRG84Y0lqdWRrNHFlQ2tUWnJzeWxpekZxVmdG?=
 =?utf-8?B?czFFUlZEcDBkeDF3T2htdDhvR3ByWUhmYXprWlFiYzNmNXdUQVl5U3J3SlFy?=
 =?utf-8?Q?eUEy++LqI7+ioFK5ULB2FKnjE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBDAB7415C7E134FA9C584372323E2F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 402e40d6-6a30-458b-2542-08db42496354
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 09:18:36.8962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CYgqwPLcFEybxt5ZVAWJnslCVj8vp8YcNjDbQydPm2lNNbw3Okn2KRNIvg2QmRBhYioF0iz+CmfOdZUiboaB+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
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

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDA4OjU0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjMtMDQtMDUgYXQgMTY6NDUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gSW5qZWN0IGEgI0dQIHdoZW4gZW11bGF0aW5nL2ZvcndhcmRpbmcgYSB2YWxpZCBF
TkNMUyBsZWFmIGlmIHRoZSB2Q1BVIGhhcw0KPiA+IHBhZ2luZyBkaXNhYmxlZCwgZS5nLiBpZiBL
Vk0gaXMgaW50ZXJjZXB0aW5nIEVDUkVBVEUgdG8gZW5mb3JjZSBhZGRpdGlvbmFsDQo+ID4gcmVz
dHJpY3Rpb25zLiAgVGhlIHBzZXVkb2NvZGUgaW4gdGhlIFNETSBsaXN0cyBhbGwgI0dQIHRyaWdn
ZXJzLCBpbmNsdWRpbmcNCj4gPiBDUjAuUEc9MCwgYXMgYmVpbmcgY2hlY2tlZCBhZnRlciB0aGUg
RU5MQ1MtZXhpdGluZyBjaGVja3MsIGkuZS4gdGhlDQo+ID4gVk0tRXhpdCB3aWxsIG9jY3VyIGJl
Zm9yZSB0aGUgQ1BVIHBlcmZvcm1zIHRoZSBDUjAuUEcgY2hlY2suDQo+ID4gDQo+ID4gRml4ZXM6
IDcwMjEwYzA0NGI0ZSAoIktWTTogVk1YOiBBZGQgU0dYIEVOQ0xTW0VDUkVBVEVdIGhhbmRsZXIg
dG8gZW5mb3JjZSBDUFVJRCByZXN0cmljdGlvbnMiKQ0KPiA+IENjOiBCaW5iaW4gV3UgPGJpbmJp
bi53dUBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVs
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+IA0KPiA+IA0KDQpUZXN0ZWQgYnkgcnVubmluZyBFTkNMUyBpbiBwcm90ZWN0ZWQgbW9k
ZSBiZWZvcmUgZW5hYmxpbmcgcGFnaW5nLCBhbmQgaW4gbXkgdGVzdA0KdGhlICNHUCB3YXMgaW5q
ZWN0ZWQgdG8gdGhlIGd1ZXN0Lg0KDQpUZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCg==
