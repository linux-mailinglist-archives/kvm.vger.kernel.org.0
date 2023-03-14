Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142576B86B9
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 01:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCNARn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 20:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCNARm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 20:17:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B1A9008D;
        Mon, 13 Mar 2023 17:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678753061; x=1710289061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Fgm2n6prmr4Q3dLSwYLo/YFobR6/+8/s90k9DSjf8Uc=;
  b=Gf0YBhmAEaJAJ5W9H+EJadi3gnTTP5YM4PoPSXR5hdeag5qTa9w8/oXX
   W6AkK2O1AOYjWBRqUCY+hk3oDVAr9wei3tPw7BQ/fjlk9IMedTJY16Q7w
   ahdAyWWSMBotA4uRJ6v/vCGJC07eIJpmSdP6xXu2QYg7Spygl3fLB+x3P
   RgbF2/8sthIenLFk2oSW1f03SYIi7rKSgus5GXghBSlB/ZckNzZvXEu5V
   GDDVlFvleiOFWUum6IN5HhroKn9VobcHSZU5NT4xz/tgFM63sVayGVG79
   9oMKrCow05OnxOWmsUxj/Fc+QPz1iAFyR3aMz6XI4jN6/hGC8wjlPWE25
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="316936418"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="316936418"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 17:17:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="924701877"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="924701877"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 13 Mar 2023 17:17:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:17:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:17:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 17:17:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 17:17:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efD8PrBWHudHCE1+ChLs7TgKAXIhVcoTDN/SoOvx2HhmfHlgvqM4CYFIWAJUaLjXyAS+9+mUFw3F9kJF99tm8X5YvpZ4SlaC2yS+UQDyhUKrraCf53faS9JKWyKmjKhntzeYuPTNE6c5HjpZr9qLmMHbeqMGBN4IPe5AQ6oOFBrxAhlhpJKkxSYsS+rmrPLRyeU6YIC1OFOFEbZIIOWds7gYBBVfdxuWKJpu7NO5kOPh30XXX9CVEuTzcuc47xbwRYNSqdHSUKwmSwqq+1Mei3NjpY39Igl3a0SJVL1kj8DA0kvzhqkWHG3b82TY1RaEu94ggShNt0OVb5faj8xM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fgm2n6prmr4Q3dLSwYLo/YFobR6/+8/s90k9DSjf8Uc=;
 b=cEgJHyhDcinmZs8J4n2IhCaFnaYOI8E5nOtCJ4F1zXqIN6Ajqcpoev33U9/uaQ9Tr/hRLO2WeosyiGVsJ1DI8ZcSw9CyXKmMeI6ackbzmSOjxQBDOwXIhKAhWioIdHhOxMHjqVguQdq/j8SvO5hqhozXTqEUsj62P5mAoboMqeruF6z3mssE63vll8cczLaf1WmIiFHLw5mmeH3yIq3EytXKlXmCmbxIv4bAx5iNznhrrKfQ+FaI2h7bAnPCabZo5jbiztOVBYHwVTpSdYyP4srXZCGr/2kzf2pOcyxK2B65ENSqoDuQB7at+RJCj707hRwnJ6laiDOnx08So3qPzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4719.namprd11.prod.outlook.com (2603:10b6:806:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 00:17:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 00:17:02 +0000
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
Subject: Re: [PATCH v2 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Topic: [PATCH v2 14/18] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Thread-Index: AQHZU5lXMnpUqycUmkKZ0SzG1hqX/q74BPSAgAD2tgCAAHG5gA==
Date:   Tue, 14 Mar 2023 00:17:02 +0000
Message-ID: <77284a4e8cd1bedda5ddd9b730a988233e45a419.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-15-seanjc@google.com>
         <eb7ccc4f362ce833600f0096710003188571e4b2.camel@intel.com>
         <ZA9dbo2ZufqLdHNg@google.com>
In-Reply-To: <ZA9dbo2ZufqLdHNg@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4719:EE_
x-ms-office365-filtering-correlation-id: c9c77d27-2a0c-421c-02b2-08db24216f3e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0F5RRNz4+1VY7bdopBBN5bDiMzelqfd5lVgo2XxlRFEFvhPnaZ9cVvE+5nh5sFAR9GykDzCRFc6BjtgUMLGmsOsDkx42HfuzhAZ6oQzrGaWCizd4MHU7NUVYuk5f6YcT4L4dOvsyQXzJNQwtro1rnhRn5OarrR2aQQpLhbwZePRexiP9DuHBbIM3TzRBWzPKcoeENrTRdot6L/6YAX+HAXsAUxwDh3Vpl/BXs4c+M7K4xSlob7qfotUh7AJK1P/5CeUuLY9IHwkvR5JoWe68gxKAwy/FUjJIqJqR1cmFSwjeSWJs4yzSYA40tjW9pbEhGrlX38+EixrdNu1M9dtOa2thDCEq1cuEw0OLd3zSdfrvS9LBDi78/XsnOp+AYACF+8leVuou6+Zi5IUgHcJNpVtINN9P2Qdsuv+yQ9v+DQMBbFRlLrRYkt1q5xw5Dabs8EyjUKEIObTwRd7Zs9HMhfS+D2sOP2KW0STBEfJoJZJ2AWzyRDHv8MT3UStj0DSRsP4fPrpAgxPjQJ4aSC/hiUnfnHm0x0vLNJiDlcQH8hBWjRm3Fc9R/8RxcB0uo47jBxPwBx4fIR31oogygOBtM+nyLQsYUzDex2Dsubv2zp76REGgvfGdvFjQi2lQXHWWixqu1/DQYBUUg38F3UxBwITFZ80X5219kYlJ/ptjs1hjrFH4pejwizodwGe117H0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199018)(54906003)(41300700001)(91956017)(478600001)(66446008)(66476007)(8676002)(66556008)(64756008)(4326008)(66946007)(8936002)(6916009)(76116006)(38070700005)(86362001)(122000001)(38100700002)(36756003)(82960400001)(26005)(966005)(6512007)(71200400001)(186003)(6486002)(5660300002)(7416002)(2906002)(316002)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkRaRGc3VGtsNUVFRlY1bHBLSWZCQUVHMnE4R241YVZBZEJodGZlelFUWVBE?=
 =?utf-8?B?c3I3WDhWOXBnN2Zrdm1JOVRPajNvUTYvc3JPN3dFb0ZHbG1qMjFRUWc2cW9x?=
 =?utf-8?B?UTlBZTJwTklzdjQwQmN1SHNYQys0RjhoRVU3QVZtallDUHFkUGtjZnVxSHUz?=
 =?utf-8?B?bjRlbFlNck1kNmhhRGVYVlVIKy9UcGIrMGEyUDY3S0I4Y2c4aDVwMVUvaVhx?=
 =?utf-8?B?QzFtRkVSbnF6ZGhZd21FR2l3TERLOURlUktjR2pBSHlnVmhJaWVnUTBWWW9D?=
 =?utf-8?B?cGM1WTV1T1FkS1FCTFlvalg1YU9KUDFjdDA1UzNUUUgzL2JndUFPY1YxZE9H?=
 =?utf-8?B?T0l6WlZuQjRSYU9ueklxV2xZRU1tZW1DSUpTY2VSaXZ3WEhSeUtvWjlRLzhv?=
 =?utf-8?B?ZkpJdXkveVlEcjAvNDNDM3d4WVpXWEc5ZXpTY2U1dVczY3J3K1U3WTlvR3d4?=
 =?utf-8?B?TVpPeGJzbnBlWWdCTjNHVktzNGFoL3lhd3MwcWNTVWpKZ2JsaUpwam0zWDg5?=
 =?utf-8?B?cVYwRWlEdTM2dHJBMENVVktvZldmU05EcTZJSXB2bEduL3BieXRhcXA4eWFC?=
 =?utf-8?B?VW5QcEJRMHlEUCs4SnBhSExkMzRVdWdHSWlvRnBpMGV3OGNZQkdyc0o4Rk9k?=
 =?utf-8?B?SG91YmhCTm9PVHRzMnBXZXV4YklVNmxVK0NURStlcWhLMEhSdm9haTBnejhl?=
 =?utf-8?B?TWZNVWFVcE1UT29wZjcwdlZYT3pIWFNZSHU0OTZGeUY1dktzdDJNMFJ6d2Jj?=
 =?utf-8?B?ejVQd1QyQmM1ZU1lMHRkK2czQWJ2WTdxTFhiUUg0N0V4SGZIemI1bXBTV2Zn?=
 =?utf-8?B?ZnpzNkd5TURDS3c5NUdVNTZqZjRjSEpacjIxR2w5cy9DaGN2STVONHdwQjAy?=
 =?utf-8?B?bTNkUms3M3pHRitEeVl1b09yUGtSV0JDS2pBVTliVWpZZUZYT1FlbDNVMGxl?=
 =?utf-8?B?RzluREFZQ3A5ajdSUGJqUGxoOHByOTI4UEJiT1QyUWFyWEt0emVhSnBIMDI1?=
 =?utf-8?B?YnZyU3hmU25GVUxwOEFsaDhkY0t3Umw2OWZXVlVNcVN4bklzMWxReXZpK0RI?=
 =?utf-8?B?NlR1Umx4Y1QzdWtqZDdiay9CK2F0dXBNTkhMUmJDUmk0T0ZJWjl5eTFockkx?=
 =?utf-8?B?Y0h5ZENXc3VEdnJtbHEwSVN4YTRiRmFvTXpkVjdTcEhDUXp4c3ZVNzNnVC81?=
 =?utf-8?B?S0tlN1NFTjJ0My9hYWxkSkp4aVNFN0EvTmU4aW5FNUdMQ3R0b0dRUEpDbGRP?=
 =?utf-8?B?TjgrbDhDL1BaN3M5aEZjTFhkRG91TlVPRTFNQTBZQTBhTHg0cEJoVUhYMEJa?=
 =?utf-8?B?RVl4SlBORkJxOXBiNXp1YkUvdXVEd1VmZEZKNDNiSGp5WUlxRmVkWTY4bU90?=
 =?utf-8?B?MTNVcEpGZHVRNkNXNGkzc2NtQmNwVGRYaHRSczlHa1VFbE5GbEI5RllHejBD?=
 =?utf-8?B?TGQ2NkdmU290Z2NVaGlKRlpkcGdqMElDUlFEOVF2VGZzSkhZV3Bpd3crdmRP?=
 =?utf-8?B?cXhRRUdVNXZiQW9iZS90VjQ4aWZtOExFdzkvQWFEYms0dUFrWVRaSkFkREdL?=
 =?utf-8?B?ODlwOGVjOUlKN2VjSSs5aTlmRzFXK2lkcEp4R1VLVlhXbC9KS0ZJRUMzb0pw?=
 =?utf-8?B?Rm8zWEdDTWIrUWloUGt1WDVMVFFZZjd0R2tsK3d1QWZMb29ydnQ0OWdnZ2ty?=
 =?utf-8?B?Zy9sNHZReEpYYWppMG1hN2tOY3R1Sk9KRmVLaVFoRmlqRmlCa2ljN3FKQnAy?=
 =?utf-8?B?bmdCS1gwVHBSWTRzMDZvbkpLckphQWVVc3huYzJvZnlFcmpLN09zcmNTWWxa?=
 =?utf-8?B?VjBTblloQ3R1SnB1elBsUkliQzNOOUlNcHBDTGNSWlpBUHB2REt4aTdjOXlh?=
 =?utf-8?B?MmdINEJ1WkNhRGxtalRhamFTMFJDSEhzZXAxa3NUQzFlbXdwWG1Nb1ZuN1hQ?=
 =?utf-8?B?b1NmMTc4ZHcza0FFU0RITjVWL3JPa25YSytIT2JQV0pENjA0eWtMWERmWElz?=
 =?utf-8?B?S0xUcW1BTjhVRGVYZzZRZGJQR3p1STZKK2tnNm5ucklBY0l0UVBySVlWSTlQ?=
 =?utf-8?B?UG9sN09icktHUUZzZVFBY3VPK1NFM2ZNOTVEYnJBeE1iNkwrR1NFeGxVSG54?=
 =?utf-8?B?SjVBbUd2ZkRielU4Nzd1NTNWWkYzTDJCSWZRd01TaVlLNWx5WkRGanVjTTZj?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <522B0CAC1EB582429CC975C95BE5EB92@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c77d27-2a0c-421c-02b2-08db24216f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 00:17:02.1600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gMhelracHsiOt6y7zL5KGoWYw2+QHIbbZrC68ixx5PTMWpRqlZFUy0Z1+PrEnjoq6CeVcLVLfJXMna8YacytQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4719
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTEzIGF0IDEwOjI5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1hciAxMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBG
cmksIDIwMjMtMDMtMTAgYXQgMTM6NDIgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBDaGVjayAidGhpcyIgQ1BVIGluc3RlYWQgb2YgdGhlIGJvb3QgQ1BVIHdoZW4gcXVl
cnlpbmcgU1ZNIHN1cHBvcnQgc28gdGhhdA0KPiA+ID4gdGhlIHBlci1DUFUgY2hlY2tzIGRvbmUg
ZHVyaW5nIGhhcmR3YXJlIGVuYWJsaW5nIGFjdHVhbGx5IGZ1bmN0aW9uIGFzDQo+ID4gPiBpbnRl
bmRlZCwgaS5lLiB3aWxsIGRldGVjdCBpc3N1ZXMgd2hlcmUgU1ZNIGlzbid0IHN1cHBvcnQgb24g
YWxsIENQVXMuDQo+ID4gPiANCj4gPiA+IERpc2FibGUgbWlncmF0aW9uIGZvciB0aGUgdXNlIGZy
b20gc3ZtX2luaXQoKSBtb3N0bHkgc28gdGhhdCB0aGUgc3RhbmRhcmQNCj4gPiA+IGFjY2Vzc29y
cyBmb3IgdGhlIHBlci1DUFUgZGF0YSBjYW4gYmUgdXNlZCB3aXRob3V0IGdldHRpbmcgeWVsbGVk
IGF0IGJ5DQo+ID4gPiBDT05GSUdfREVCVUdfUFJFRU1QVD15IHNhbml0eSBjaGVja3MuICBQcmV2
ZW50aW5nIHRoZSAiZGlzYWJsZWQgYnkgQklPUyINCj4gPiA+IGVycm9yIG1lc3NhZ2UgZnJvbSBy
ZXBvcnRpbmcgdGhlIHdyb25nIENQVSBpcyBsYXJnZWx5IGEgYm9udXMsIGFzIGVuc3VyaW5nDQo+
ID4gPiBhIHN0YWJsZSBDUFUgZHVyaW5nIG1vZHVsZSBsb2FkIGlzIGEgbm9uLWdvYWwgZm9yIEtW
TS4NCj4gPiA+IA0KPiA+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pBZHhO
Z3YwTTZQNjNvZEVAZ29vZ2xlLmNvbQ0KPiA+ID4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCj4gPiA+IENjOiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiA+ID4g
U2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+
ID4gDQo+ID4gU2hvdWxkIHdlIGFkZDoNCj4gPiANCj4gPiBGaXhlczogYzgyYTVjNWM1M2M1ICgi
S1ZNOiB4ODY6IERvIGNvbXBhdGliaWxpdHkgY2hlY2tzIHdoZW4gb25saW5pbmcgQ1BVIikNCj4g
PiANCj4gPiBBcyB0aGF0IGNvbW1pdCBpbnRyb2R1Y2VkIHVzaW5nIHJhd19zbXBfcHJvY2Vzc29y
X2lkKCkgdG8gZ2V0IENQVSBpZCBpbg0KPiA+IGt2bV9pc19zdm1fc3VwcG9ydGVkKCkgYW5kIHBy
aW50IHRoZSBDUFUgaWQgb3V0IGluIGVycm9yIG1lc3NhZ2U/DQo+IA0KPiBNeSB2b3RlIGlzIHRv
IG5vdCB0byBhZGQgYSBGaXhlcyBiZWNhdXNlIHVzaW5nIHJhd19zbXBfcHJvY2Vzc29yX2lkKCkg
YW5kIG5vdCBkaXNhYmxpbmcNCj4gbWlncmF0aW9uIGZvciBtb2R1bGUgcHJvYmUgY2FzZSB3YXMg
ZGVsaWJlcmF0ZSBhbmQgaXMgc2FmZS4gIEkgZG9uJ3Qgd2FudCB0byBnaXZlIHRoZQ0KPiBpbXBy
ZXNzaW9uIHRoYXQgdGhlIGV4aXN0aW5nIGNvZGUgaXMgZnVuY3Rpb25hbGx5IGJyb2tlbi4gIFRo
ZSBvbmx5IHF1aXJrIGlzIHRoYXQNCj4gdGhlIHJlcG9ydGluZyBjb3VsZCBiZSBtaXNsZWFkaW5n
Lg0KPiANCj4gVGhhdCBzYWlkLCBJJ20gbm90IGFnYWluc3QgYWRkaW5nIGEgRml4ZXMgdGFnLCBi
ZWNhdXNlIEkgY2VydGFpbmx5IGNhbid0IGFyZ3VlDQo+IGFnYWluc3QgdGhlIHJlcG9ydGluZyBi
ZWluZyBmbGF3ZWQuDQoNClllYWggdGhlIG9ubHkgaXNzdWUgaXMgdGhlIHJlcG9ydGluZy4NCg0K
QW5kIEkgd2lsbCBsZWF2ZSB0aGlzIHRvIG90aGVycy4NCg0KPiANCj4gPiA+IC0tLQ0KPiA+ID4g
IGFyY2gveDg2L2t2bS9zdm0vc3ZtLmMgfCAyNSArKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+
ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+
ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94
ODYva3ZtL3N2bS9zdm0uYw0KPiA+ID4gaW5kZXggMjkzNGYxODU5NjBkLi5mMDRiNjFjM2Q5ZDgg
MTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ID4gPiArKysgYi9h
cmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+ID4gPiBAQCAtNTIwLDE4ICs1MjAsMjAgQEAgc3RhdGlj
IHZvaWQgc3ZtX2luaXRfb3N2dyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gPiAgCQl2Y3B1
LT5hcmNoLm9zdncuc3RhdHVzIHw9IDE7DQo+ID4gPiAgfQ0KPiA+ID4gIA0KPiA+ID4gLXN0YXRp
YyBib29sIGt2bV9pc19zdm1fc3VwcG9ydGVkKHZvaWQpDQo+ID4gPiArc3RhdGljIGJvb2wgX19r
dm1faXNfc3ZtX3N1cHBvcnRlZCh2b2lkKQ0KPiA+ID4gIHsNCj4gPiA+IC0JaW50IGNwdSA9IHJh
d19zbXBfcHJvY2Vzc29yX2lkKCk7DQo+ID4gPiArCWludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lk
KCk7DQo+ID4gDQo+ID4gU2luY2Ugd2UgaGF2ZSBtYWRlIHN1cmUgX19rdm1faXNfc3ZtX3N1cHBv
cnRlZCgpIGlzIGFsd2F5cyBwZXJmb3JtZWQgb24gYSBzdGFibGUNCj4gPiBjcHUsIHNob3VsZCB3
ZSBrZWVwIHVzaW5nIHJhd19zbXBfcHJvY2Vzc29yX2lkKCk/IMOvwr/CvQ0KPiA+IA0KPiA+IEl0
IGlzIGZhc3RlciB0aGFuIHNtcF9wcm9jZXNzb3JfaWQoKSB3aGVuIENPTkZJR19ERUJVR19QUkVF
TVBUPXksIGJ1dCB5ZXMgdGhlDQo+ID4gbGF0dGVyIGNhbiBoZWxwIHRvIGNhdGNoIGJ1Zy4NCj4g
DQo+IE1vc3Qga2VybmVscyB3aXRoIGFueSBhbW91bnQgb2YgQ09ORklHX0RFQlVHXyogb3B0aW9u
cyBlbmFibGVkIGFyZSBjb21pY2FsbHkgc2xvdw0KPiBhbnl3YXlzLCBJIG11Y2ggcHJlZmVyIGhh
dmluZyB0aGUgc2FuaXR5IGNoZWNrcyB0aGFuIHRoZSBwZXJmb3JtYW5jZS4NCg0KWWVhaCBmaW5l
IHRvIG1lLg0KDQo=
