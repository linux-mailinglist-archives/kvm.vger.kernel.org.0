Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163D366BC9F
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 12:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjAPLQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 06:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAPLQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 06:16:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CAB6596;
        Mon, 16 Jan 2023 03:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673867771; x=1705403771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tzdIWpJVokWu0uFO/jYjcHo+cMo60ZY+sDQAJjwi0CU=;
  b=LnohqRWNaJXOBCSaWhrjjQPIrzG9UBWASaXAUEI6WBcw3ZZ95tHxi5EP
   feHoc6sCCJFxQ5qRbCWpkj9HUHMeyb1wYn+PwvTZ4if+bUHi7FTgJ89OS
   fTDvcTj9Dw3Njt78N7LDKm/DkuSy+GbAzBFEBeSqWXw+HMDKmI6mFtg3U
   irWlO/QMx5euUomuCxUj6n4EFKrabRUj+p1NR3ObSfcUjNXIypsetb7Iu
   Gh7y+I2azMsOKD6+rdt+L9/FrpSRunpZP7KWsk2hnVPm5JkDqriKvlMyO
   PE826G5WIiduk082WApUU4awScoPW2MIsJQiaQl8CtCaCHRs/BBMrO6lx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="324501020"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="324501020"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 03:16:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10591"; a="832807154"
X-IronPort-AV: E=Sophos;i="5.97,220,1669104000"; 
   d="scan'208";a="832807154"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2023 03:16:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 03:16:10 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 03:16:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 03:16:10 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 03:16:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OU10dY95Ym20ibRJxS8b0oxhpkNlkXwzeRGNfywGaZ5eESXgwZL7KETIgHWW6yr5OmhsJbhKuA6hX2Yq3i0RzpPZYMyWum0KEYFHmMbRHo2Nw7YtFebkLNyiucn63d0kJmi8OaQOdxz75VFMCjhNo6ziKFWY6Fcuo6hHMy5SuXLdU/SMX4nwipOf+2bka17Ioe88c2ijRxgVRGawKDlbywBDK/pznc4qtKdlhUHI1qgLJs2O9BdaWIpV4Z1oYtDEo9PqwVmP3AhZ0ef4CzMfVk6nUZAfZH0woyHU4WiFU20F075D95WqOPAZV5VKLBIAU8L3dK3wYnOeYwtAG0mxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzdIWpJVokWu0uFO/jYjcHo+cMo60ZY+sDQAJjwi0CU=;
 b=TKVSADBIrhthzeJ4o45YNNxdB+e9bcKKBfG3UX3jtlrXJEnrHYq1cqYi+4aAdJqSYq0SHgG0hLLCmnNE85c+dt2PlksFR+SkA7VkIaBA0bYT4YkB+3f7uazAd57tClpc4epQTkA1zbvuEoHF86huQxvY5dJztTISO0gVzv0Gew28Hb56DJo1MlYyyi+Au87J9Dk5rBE+w+bByOc8kjOsR/lmmOuOHAYVYEC6M8HiaQ/OZGtKQwuPsm8of7iXGM4lu730ad5zcMPtnblTfwIoOd+vI1eUamRqgWqKI3UZJ3IjflefdaumHBoN+trgxKKCr9aajRKRha+q0PSHSTjkCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5118.namprd11.prod.outlook.com (2603:10b6:a03:2dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 11:16:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Mon, 16 Jan 2023
 11:16:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 033/113] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v11 033/113] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHZJqV40pjbxGRgKkW1kzlK9FHzcK6g6oeA
Date:   Mon, 16 Jan 2023 11:16:04 +0000
Message-ID: <886ee34123be83bbe565c5d02e5b0d4c000ef5a6.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <e3a95546186bc010c11da4152b8980a86702b6a9.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <e3a95546186bc010c11da4152b8980a86702b6a9.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5118:EE_
x-ms-office365-filtering-correlation-id: 94c4aca8-773d-4404-428d-08daf7b30e87
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zIRb8VD+T+bNAECSKyCNLG+kIeSKOHV9cjX50GL9DV9x81in8jFYU4ud5KOSlfGDN4nrpM96VF+JS1Bxz2MDBzuwRbZD4fQwl8ATDPRUU2B6wAE1d3tb89hq7Z7gJPWNhYpx54Hc6qFQ5TN9tfGq+ZA8d5PAKPlcdIoNif0wikNUEcQQcZaJ0z+ffE0z+DoxhbgzupcRrST1JpU9RhB2260/9qWGEp0uyanSSUwFSjPv4OblRRfv0H5X4PcB3RYl628Jx4r/kgarYMoLRR/UHLjn1hojcJ0mX8AVqVQmrH1ik3sNOaniwTPyyLvihhIYDjUbEy4UtR5IoTkxqvkXiLDXvX1ceKVK7uCsLYwJE5Dt/oblB4co/qxppLTdAx6lrQc4I9CqcUf0r+4XGy/evgb84gryliSqNYRrLfVrUQFQuibTwdfmlADYhlVZ1ohJlPHDHemR5SpqycCjy7zWl0yTcUBT6Yr62YKBBhJIdCqmI3BPVEuCcLfXq8vrAJ8X1mJp1Q+qq07VcBwg1bRLPTboBsaJcnhliep43amLKkx1IX8ZU0lOLY8+R/tQkRfv2MEJ82rXhrPR5oZCJGcQ4rXrdxyr8pgw2LHypqefi4SWkNjMdBqe8bwYKtS8jv83MUcDAPqZhGbPQ9ipANCTR2ANlCkajevGzft7koaBv+L51pUxexW3epDzVXqTybZ9FlNbXnJwoa6k9OtqHWnx2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199015)(36756003)(66946007)(66556008)(76116006)(41300700001)(2616005)(66476007)(66446008)(26005)(186003)(6512007)(91956017)(8676002)(64756008)(4326008)(86362001)(83380400001)(5660300002)(82960400001)(8936002)(6636002)(110136005)(54906003)(478600001)(71200400001)(6506007)(316002)(38100700002)(38070700005)(2906002)(122000001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REFMUWpteW50eVhrS0pQanNqYXhMaHp4L1ZROWU5S0NpVXBnb3BQbDNrVE5o?=
 =?utf-8?B?UnJnKzZXNEE4NlphQ05DeExUeUxqRXlodzJqWVozUzBRa1lESUJiRjQ1ZC9w?=
 =?utf-8?B?RVVCSnBRd2VxRzR2ajkvTlNPVlpDd29BN00wSFhRdloycGQ4dlQ3amIzMkVs?=
 =?utf-8?B?eW5oNXpqODZBcFJZMW54NEFISEV6dE81MHkwbjF1SFFYL3JvMVJkb0Y3WjFv?=
 =?utf-8?B?U0IrOTJmRE9iYUpqYUR4d01MdThZcENWUWZRM3gzZW94ckxRYUJTU1J3UzJP?=
 =?utf-8?B?NWNXYWNKZlhaeFNMM01HNzJWaUxzaDVYSWI1RHI2SkhEOHlzQUowclZlNkRI?=
 =?utf-8?B?NkV6emx2QVk5MnVIUWFMMjJQTWU4clRSL0dhWFNKbGhTd0VxNUFzRit4QUgw?=
 =?utf-8?B?QVNkZFRjNW5PNHUzY0tuV1liRTJVMTI5UHlmL2NGZ0lxZE9FT2RaYTF1SGsx?=
 =?utf-8?B?SkRHbGZVRzQzdUg0R1lWSWx3NFk5UE11RFIrUnBPZFBmTEc3WWUvOUFjeEY2?=
 =?utf-8?B?UGhWTHV2NGVhUTR5eHBnYjNJMkQ0NVNOaUs0UEN2eXhEY1F4N0xWRGp4dWNC?=
 =?utf-8?B?ZkwzNDl6UFhaNzF5NHBEbGlHdkpSeHh3SWdheG1vYnVXNE5zZzI2cUxnWFc0?=
 =?utf-8?B?U2VuZUJrKzBGVU9tWTRLSXpGSmdzSkpZR2JlcXNlWEdBeDhGcmYralZhajFz?=
 =?utf-8?B?UGNLRGUvZmkwRkFHbDFDQVBBK0ZIS2tBbytPK2FicFRXQW11T05mMGRDUStR?=
 =?utf-8?B?UHhjLzM5dTZqMHNOTjRNK0tVM05yYUhhNFFtYjZHT3Y5SnFRNy9IQnFYUHNq?=
 =?utf-8?B?cG5hT1FZejY5VFVJM2g5MzZFUEhBTU84WlZlRUEzK3NkZU1XdnBUR0pQcHUz?=
 =?utf-8?B?d25KdzNYSDAwd0lRa3R0Tkx6K0ZuTTU1YWY4Q2c5TlJwa2xXdHdhT09veGRl?=
 =?utf-8?B?aFhYTUV2WkhWMis5WG5PdnY5a29SS09rUldNQlNxTmVvb2xrUE0xZHBKQk0x?=
 =?utf-8?B?dmRDMnU2VlRMUHROSUd3dFBpL0FNbCtMTkFQTG5jQ2FWUW5FODZkZnBYZ1dr?=
 =?utf-8?B?dlpZcjh2eDZQSFdGRVRmdElPTElQd29YVjlJeEJGUzRCdU40ejhHejFNWVpo?=
 =?utf-8?B?dm1COTlKR3dUS3BZbml5T2FBeFJUOS9KMDRESFJ6R2U0YTZ2SkczT3ZmSHZ0?=
 =?utf-8?B?L01Pd3ZDUzQxRTd2emQvTmx6RzhHVXdTcTlMVkplV1VGUHZ5dFF3NzhPSVd2?=
 =?utf-8?B?TG5sTlZCYWlVZTh1ZitmRmVFM3JkcDMyVWpBYTFYaFlaTTNqeUpCWGtvR0t4?=
 =?utf-8?B?RFV5U2RjWWpYS21VL25ZRXMrZ3VoQ09wcWVQWjlsbFh5OUlGU0pxWCsreGVh?=
 =?utf-8?B?OW5lbzdpbFZKbDAzUjZJZy9wMkovRGxqVG1OZmtpYk55VU1aaWZGM0c1WTk1?=
 =?utf-8?B?NHdWVTZhUzJpVzFsSGg0YUZ1SDE1aStSS2RmNENwSFVSOTlCT3hVVVBtSm5l?=
 =?utf-8?B?bzhrOTFYU2NUK1Z6TFNwN2JGd3E1Y1dZY3VNYlhHNHFoZVlBcEhYZEx3U3hi?=
 =?utf-8?B?UllPdUhmWnd0amd2YjJsRmIrTG5obHA0a1BoTlpSdzRCRkQ3cXRHUXB2NFg5?=
 =?utf-8?B?OXhqS3lXeWhNK3pJUDJrS3hYaFVWTXVqMCtlV1lGRzM3emtCby9NRzIxN1d3?=
 =?utf-8?B?RWhmeUJlSWhXRnF2NitVVm13K3VwbXJ2ZnA2RUNNZkdFeE5QaEJ1UTFWZ2Np?=
 =?utf-8?B?QUNJdG5RTVV0ems0OWZQTkZDWTBBRDFVaExJN2oxTjZSRTBDciszZkNzekF6?=
 =?utf-8?B?VXlIQWxPMlYzQlphSUx2RUNvZ2wwWWpDTHRvRStWSnlsQ3padkRYbnFKRktq?=
 =?utf-8?B?R3dSOWt3d3EwR3orSFVYdmhLUUxhK0pZQytZbjBLTVFnUXgxRkFrcVJZdmk1?=
 =?utf-8?B?bkNyeE1ETjEvbmlFbFgxN3AwWlQxVEx3dlRsTGMwZUdUbWdObGdHUURqSitZ?=
 =?utf-8?B?NUZJY2FpY3RFclVnREFmNCtCYXY5dHd6VWpFbHNDdlJNbGVKS0d3K2ZFbEpw?=
 =?utf-8?B?VEl3M1BlK2NKQVl4QjljWUpTcWN0Y2FQeGg2aW1WVnlPU0NGVUF2dmYzckVj?=
 =?utf-8?B?YkZhdDRWaElYbmMwTEluOUxxQURLOHN5cUtTa2h0Zm1xNFFCRXVjYnNmcHlJ?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF5EC0162B7DCA47B91963FA3C7182D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c4aca8-773d-4404-428d-08daf7b30e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 11:16:04.0986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPReGoy80z7ez9xU4na+zy64gf0Wif5wj13/8bhEUdSi70ZYZQDauxILl6p+AQ7TW/N55GqghAswbKG0iKhAvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5118
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggd2lsbCB1c2UgYSBkaWZmZXJlbnQgc2hhZG93IFBURSBlbnRyeSB2YWx1
ZSBmb3IgTU1JTyBmcm9tIFZNWC4gIEFkZA0KPiBtZW1iZXJzIHRvIGt2bV9hcmNoIGFuZCB0cmFj
ayB2YWx1ZSBmb3IgTU1JTyBwZXItVk0gaW5zdGVhZCBvZiBnbG9iYWwNCj4gdmFyaWFibGVzLiAg
QnkgdXNpbmcgdGhlIHBlci1WTSBFUFQgZW50cnkgdmFsdWUgZm9yIE1NSU8sIHRoZSBleGlzdGlu
ZyBWTVgNCj4gbG9naWMgaXMga2VwdCB3b3JraW5nLiAgSW50cm9kdWNlIGEgc2VwYXJhdGUgc2V0
dGVyIGZ1bmN0aW9uIHNvIHRoYXQgZ3Vlc3QNCj4gVEQgY2FuIG92ZXJyaWRlIGxhdGVyLg0KDQpU
aGUgZ3Vlc3QgVEQgaXRzZWxmIGNhbm5vdCBvdmVycmlkZS4gIEl0IGlzIEtWTSB3aG8gb3ZlcnJp
ZGVzIGl0IGZvciBhIFREWA0KZ3Vlc3QuDQogDQo+IA0KPiBBbHNvIHJlcXVpcmUgbW1pbyBzcHRl
IGNhY2hjaW5nIGZvciBURFguICBBY3R1YWxseSB0aGlzIGlzIHRydWUgY2FzZQ0KCQkJIF4NCgkJ
CSBzcGVsbCBjaGVjay4NCg0KPiBiZWNhdXNlIFREWCByZXF1aXJlIEVQVCBhbmQgS1ZNIEVQVCBh
bGxvd3MgbW1pbyBzcHRlIGNhY2hpbmcuDQoNClRoZSBzZWNvbmQgc2VudGVuY2UgZG9lc24ndCBt
YWtlIHNlbnNlLiAgSUlVQyAiVERYIHJlcXVpcmVzIEVQVCArIEVQVCBfYWxsb3dzXw0KTU1JTyBj
YWNoaW5nID0gVERYIF9hbGxvd3NfIE1NSU8gY2FjaGluZyIsIHdoaWNoIGlzIGRpZmZlcmVudCBm
cm9tICJURFgNCl9yZXF1aXJlc18gTU1JTyBjYWNoaW5nKS4NCg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgIDIgKysNCj4g
IGFyY2gveDg2L2t2bS9tbXUuaCAgICAgICAgICAgICAgfCAgMSArDQo+ICBhcmNoL3g4Ni9rdm0v
bW11L21tdS5jICAgICAgICAgIHwgIDcgKysrKy0tLQ0KPiAgYXJjaC94ODYva3ZtL21tdS9zcHRl
LmMgICAgICAgICB8IDEwICsrKysrKysrLS0NCj4gIGFyY2gveDg2L2t2bS9tbXUvc3B0ZS5oICAg
ICAgICAgfCAgNCArKy0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyAgICAgIHwgMTQg
KysrKysrKysrKystLS0NCj4gIDYgZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMTAg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3Zt
X2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gaW5kZXggNzNjOTg3
YjNkMmI2Li44MDdkYTRiOTVhYmEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiBA
QCAtMTI0Myw2ICsxMjQzLDggQEAgc3RydWN0IGt2bV9hcmNoIHsNCj4gIAkgKi8NCj4gIAlzcGlu
bG9ja190IG1tdV91bnN5bmNfcGFnZXNfbG9jazsNCj4gIA0KPiArCXU2NCBzaGFkb3dfbW1pb192
YWx1ZTsNCj4gKw0KPiAgCXN0cnVjdCBsaXN0X2hlYWQgYXNzaWduZWRfZGV2X2hlYWQ7DQo+ICAJ
c3RydWN0IGlvbW11X2RvbWFpbiAqaW9tbXVfZG9tYWluOw0KPiAgCWJvb2wgaW9tbXVfbm9uY29o
ZXJlbnQ7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11LmggYi9hcmNoL3g4Ni9rdm0v
bW11LmgNCj4gaW5kZXggYTQ1ZjdhOTZiODIxLi41MGQyNDBkNTI2OTcgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS9tbXUuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11LmgNCj4gQEAgLTEw
MSw2ICsxMDEsNyBAQCBzdGF0aWMgaW5saW5lIHU4IGt2bV9nZXRfc2hhZG93X3BoeXNfYml0cyh2
b2lkKQ0KPiAgfQ0KPiAgDQo+ICB2b2lkIGt2bV9tbXVfc2V0X21taW9fc3B0ZV9tYXNrKHU2NCBt
bWlvX3ZhbHVlLCB1NjQgbW1pb19tYXNrLCB1NjQgYWNjZXNzX21hc2spOw0KPiArdm9pZCBrdm1f
bW11X3NldF9tbWlvX3NwdGVfdmFsdWUoc3RydWN0IGt2bSAqa3ZtLCB1NjQgbW1pb192YWx1ZSk7
DQo+ICB2b2lkIGt2bV9tbXVfc2V0X21lX3NwdGVfbWFzayh1NjQgbWVfdmFsdWUsIHU2NCBtZV9t
YXNrKTsNCj4gIHZvaWQga3ZtX21tdV9zZXRfZXB0X21hc2tzKGJvb2wgaGFzX2FkX2JpdHMsIGJv
b2wgaGFzX2V4ZWNfb25seSk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUv
bW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+IGluZGV4IDU5YmVmZGZlZWMyMy4uOGQz
ZDdkZWViZGQwIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gQEAgLTI0NTAsNyArMjQ1MCw3IEBAIHN0YXRpYyBp
bnQgbW11X3BhZ2VfemFwX3B0ZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fbW11X3BhZ2Ug
KnNwLA0KPiAgCQkJCXJldHVybiBrdm1fbW11X3ByZXBhcmVfemFwX3BhZ2Uoa3ZtLCBjaGlsZCwN
Cj4gIAkJCQkJCQkJaW52YWxpZF9saXN0KTsNCj4gIAkJfQ0KPiAtCX0gZWxzZSBpZiAoaXNfbW1p
b19zcHRlKHB0ZSkpIHsNCj4gKwl9IGVsc2UgaWYgKGlzX21taW9fc3B0ZShrdm0sIHB0ZSkpIHsN
Cj4gIAkJbW11X3NwdGVfY2xlYXJfbm9fdHJhY2soc3B0ZSk7DQo+ICAJfQ0KPiAgCXJldHVybiAw
Ow0KPiBAQCAtNDExOSw3ICs0MTE5LDcgQEAgc3RhdGljIGludCBoYW5kbGVfbW1pb19wYWdlX2Zh
dWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGFkZHIsIGJvb2wgZGlyZWN0KQ0KPiAgCWlm
IChXQVJOX09OKHJlc2VydmVkKSkNCj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+ICANCj4gLQlpZiAo
aXNfbW1pb19zcHRlKHNwdGUpKSB7DQo+ICsJaWYgKGlzX21taW9fc3B0ZSh2Y3B1LT5rdm0sIHNw
dGUpKSB7DQo+ICAJCWdmbl90IGdmbiA9IGdldF9tbWlvX3NwdGVfZ2ZuKHNwdGUpOw0KPiAgCQl1
bnNpZ25lZCBpbnQgYWNjZXNzID0gZ2V0X21taW9fc3B0ZV9hY2Nlc3Moc3B0ZSk7DQo+ICANCj4g
QEAgLTQ2MjgsNyArNDYyOCw3IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nIGdldF9jcjMoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgc3RhdGljIGJvb2wgc3luY19tbWlvX3NwdGUoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCB1NjQgKnNwdGVwLCBnZm5fdCBnZm4sDQo+ICAJCQkgICB1bnNpZ25lZCBp
bnQgYWNjZXNzKQ0KPiAgew0KPiAtCWlmICh1bmxpa2VseShpc19tbWlvX3NwdGUoKnNwdGVwKSkp
IHsNCj4gKwlpZiAodW5saWtlbHkoaXNfbW1pb19zcHRlKHZjcHUtPmt2bSwgKnNwdGVwKSkpIHsN
Cj4gIAkJaWYgKGdmbiAhPSBnZXRfbW1pb19zcHRlX2dmbigqc3B0ZXApKSB7DQo+ICAJCQltbXVf
c3B0ZV9jbGVhcl9ub190cmFjayhzcHRlcCk7DQo+ICAJCQlyZXR1cm4gdHJ1ZTsNCj4gQEAgLTYx
MTEsNiArNjExMSw3IEBAIGludCBrdm1fbW11X2luaXRfdm0oc3RydWN0IGt2bSAqa3ZtKQ0KPiAg
CXN0cnVjdCBrdm1fcGFnZV90cmFja19ub3RpZmllcl9ub2RlICpub2RlID0gJmt2bS0+YXJjaC5t
bXVfc3BfdHJhY2tlcjsNCj4gIAlpbnQgcjsNCj4gIA0KPiArCWt2bS0+YXJjaC5zaGFkb3dfbW1p
b192YWx1ZSA9IHNoYWRvd19tbWlvX3ZhbHVlOw0KPiAgCUlOSVRfTElTVF9IRUFEKCZrdm0tPmFy
Y2guYWN0aXZlX21tdV9wYWdlcyk7DQo+ICAJSU5JVF9MSVNUX0hFQUQoJmt2bS0+YXJjaC56YXBw
ZWRfb2Jzb2xldGVfcGFnZXMpOw0KPiAgCUlOSVRfTElTVF9IRUFEKCZrdm0tPmFyY2gucG9zc2li
bGVfbnhfaHVnZV9wYWdlcyk7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUu
YyBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5jDQo+IGluZGV4IGNjMGJjMDU4ZmIyNS4uYTIzZTky
MDVmYzQyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuYw0KPiArKysgYi9h
cmNoL3g4Ni9rdm0vbW11L3NwdGUuYw0KPiBAQCAtNzQsMTAgKzc0LDEwIEBAIHU2NCBtYWtlX21t
aW9fc3B0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBnZm4sIHVuc2lnbmVkIGludCBhY2Nl
c3MpDQo+ICAJdTY0IHNwdGUgPSBnZW5lcmF0aW9uX21taW9fc3B0ZV9tYXNrKGdlbik7DQo+ICAJ
dTY0IGdwYSA9IGdmbiA8PCBQQUdFX1NISUZUOw0KPiAgDQo+IC0JV0FSTl9PTl9PTkNFKCFzaGFk
b3dfbW1pb192YWx1ZSk7DQo+ICsJV0FSTl9PTl9PTkNFKCF2Y3B1LT5rdm0tPmFyY2guc2hhZG93
X21taW9fdmFsdWUpOw0KPiAgDQo+ICAJYWNjZXNzICY9IHNoYWRvd19tbWlvX2FjY2Vzc19tYXNr
Ow0KPiAtCXNwdGUgfD0gc2hhZG93X21taW9fdmFsdWUgfCBhY2Nlc3M7DQo+ICsJc3B0ZSB8PSB2
Y3B1LT5rdm0tPmFyY2guc2hhZG93X21taW9fdmFsdWUgfCBhY2Nlc3M7DQo+ICAJc3B0ZSB8PSBn
cGEgfCBzaGFkb3dfbm9ucHJlc2VudF9vcl9yc3ZkX21hc2s7DQo+ICAJc3B0ZSB8PSAoZ3BhICYg
c2hhZG93X25vbnByZXNlbnRfb3JfcnN2ZF9tYXNrKQ0KPiAgCQk8PCBTSEFET1dfTk9OUFJFU0VO
VF9PUl9SU1ZEX01BU0tfTEVOOw0KPiBAQCAtNDEzLDYgKzQxMywxMiBAQCB2b2lkIGt2bV9tbXVf
c2V0X21taW9fc3B0ZV9tYXNrKHU2NCBtbWlvX3ZhbHVlLCB1NjQgbW1pb19tYXNrLCB1NjQgYWNj
ZXNzX21hc2spDQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9MX0dQTChrdm1fbW11X3NldF9tbWlvX3Nw
dGVfbWFzayk7DQo+ICANCj4gK3ZvaWQga3ZtX21tdV9zZXRfbW1pb19zcHRlX3ZhbHVlKHN0cnVj
dCBrdm0gKmt2bSwgdTY0IG1taW9fdmFsdWUpDQo+ICt7DQo+ICsJa3ZtLT5hcmNoLnNoYWRvd19t
bWlvX3ZhbHVlID0gbW1pb192YWx1ZTsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKGt2bV9t
bXVfc2V0X21taW9fc3B0ZV92YWx1ZSk7DQo+ICsNCj4gIHZvaWQga3ZtX21tdV9zZXRfbWVfc3B0
ZV9tYXNrKHU2NCBtZV92YWx1ZSwgdTY0IG1lX21hc2spDQo+ICB7DQo+ICAJLyogc2hhZG93X21l
X3ZhbHVlIG11c3QgYmUgYSBzdWJzZXQgb2Ygc2hhZG93X21lX21hc2sgKi8NCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oIGIvYXJjaC94ODYva3ZtL21tdS9zcHRlLmgNCj4g
aW5kZXggNDcxMzc4ZWU5MDcxLi4yNTYzOTVlYjU5M2YgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2
L2t2bS9tbXUvc3B0ZS5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+IEBAIC0y
NTEsOSArMjUxLDkgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcHRlcF90
b19zcCh1NjQgKnNwdGVwKQ0KPiAgCXJldHVybiB0b19zaGFkb3dfcGFnZShfX3BhKHNwdGVwKSk7
DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBpbmxpbmUgYm9vbCBpc19tbWlvX3NwdGUodTY0IHNwdGUp
DQo+ICtzdGF0aWMgaW5saW5lIGJvb2wgaXNfbW1pb19zcHRlKHN0cnVjdCBrdm0gKmt2bSwgdTY0
IHNwdGUpDQo+ICB7DQo+IC0JcmV0dXJuIChzcHRlICYgc2hhZG93X21taW9fbWFzaykgPT0gc2hh
ZG93X21taW9fdmFsdWUgJiYNCj4gKwlyZXR1cm4gKHNwdGUgJiBzaGFkb3dfbW1pb19tYXNrKSA9
PSBrdm0tPmFyY2guc2hhZG93X21taW9fdmFsdWUgJiYNCj4gIAkgICAgICAgbGlrZWx5KGVuYWJs
ZV9tbWlvX2NhY2hpbmcpOw0KPiAgfQ0KPiAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
bW11L3RkcF9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+IGluZGV4IDYxMTFl
M2U5MjY2ZC4uZGZmYWNiN2ViMTVhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3Rk
cF9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBAQCAtMTksNiAr
MTksMTQgQEAgaW50IGt2bV9tbXVfaW5pdF90ZHBfbW11KHN0cnVjdCBrdm0gKmt2bSkNCj4gIHsN
Cj4gIAlzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAqd3E7DQo+ICANCj4gKwkvKg0KPiArCSAqIFRE
cyByZXF1aXJlIG1taW9fY2FjaGluZyB0byBjbGVhciBzdXBwcmVzc192ZSBiaXQgb2YgU1BURSBm
b3IgR1BBDQo+ICsJICogb2YgTU1JTyBzbyB0aGF0IFREIGNhbiBjb252ZXJ0ICNWRSB0cmlnZ2Vy
ZWQgYnkgTU1JTyBpbnRvDQo+ICsJICogVERHLlZQLlZNQ0FMTDxNTUlPPi4NCj4gKwkgKi8NCj4g
KwlpZiAoa3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9URFhfVk0gJiYgIWVuYWJsZV9tbWlv
X2NhY2hpbmcpDQo+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCg0KU0VWLUVTIGRvZXMgdGhlIGNo
ZWNrIGluIGhhcmR3YXJlX3NldHVwOg0KDQp2b2lkIF9faW5pdCBzZXZfaGFyZHdhcmVfc2V0dXAo
dm9pZCkNCnsNCgkuLi4NCgkvKg0KICAgICAgICAgKiBTRVYtRVMgcmVxdWlyZXMgTU1JTyBjYWNo
aW5nIGFzIEtWTSBkb2Vzbid0IGhhdmUgYWNjZXNzIHRvIHRoZSBndWVzdA0KICAgICAgICAgKiBp
bnN0cnVjdGlvbiBzdHJlYW0sIGkuZS4gY2FuJ3QgZW11bGF0ZSBpbiByZXNwb25zZSB0byBhICNO
UEYgYW5kDQogICAgICAgICAqIGluc3RlYWQgcmVsaWVzIG9uICNOUEYoUlNWRCkgYmVpbmcgcmVm
bGVjdGVkIGludG8gdGhlIGd1ZXN0IGFzICNWQw0KICAgICAgICAgKiAodGhlIGd1ZXN0IGNhbiB0
aGVuIGRvIGEgI1ZNR0VYSVQgdG8gcmVxdWVzdCBNTUlPIGVtdWxhdGlvbikuDQogICAgICAgICAq
Lw0KICAgICAgICBpZiAoIWVuYWJsZV9tbWlvX2NhY2hpbmcpDQogICAgICAgICAgICAgICAgZ290
byBvdXQ7DQoNCgkuLi4NCn0NCg0KVERYIHNob3VsZCBiZSBkb25lIGluIHRoZSBzYW1lIHdheS4N
Cg0KQW5kIElNTyB0aGlzIGNodW5rIHJlYWxseSBkb2Vzbid0IGJlbG9uZyB0byB0aGlzIHBhdGNo
IC0tIEkgaW50ZXJwcmV0IHRoaXMgcGF0Y2gNCmFzIGEgImluZnJhc3RydWN0dXJlIHBhdGNoIHRv
IHRyYWNrIHNoYWRvdyBNTUlPIHZhbHVlIG9uIHBlci1WTSBiYXNpcyIgKHdoaWNoDQpldmVuIHNo
b3VsZCBoYXZlIG5vIGZ1bmN0aW9uYWwgY2hhbmdlIElNSE8pLCBidXQgdGhpcyBjaHVuayBpcyBj
bGVhcmx5IGRvaW5nDQptb3JlIHRoYW4gdGhhdC4NCg0KPiArDQo+ICAJaWYgKCF0ZHBfZW5hYmxl
ZCB8fCAhUkVBRF9PTkNFKHRkcF9tbXVfZW5hYmxlZCkpDQo+ICAJCXJldHVybiAwOw0KPiAgDQo+
IEBAIC01ODcsOCArNTk1LDggQEAgc3RhdGljIHZvaWQgX19oYW5kbGVfY2hhbmdlZF9zcHRlKHN0
cnVjdCBrdm0gKmt2bSwgaW50IGFzX2lkLCBnZm5fdCBnZm4sDQo+ICAJCSAqIGltcGFjdCB0aGUg
Z3Vlc3Qgc2luY2UgYm90aCB0aGUgZm9ybWVyIGFuZCBjdXJyZW50IFNQVEVzDQo+ICAJCSAqIGFy
ZSBub25wcmVzZW50Lg0KPiAgCQkgKi8NCj4gLQkJaWYgKFdBUk5fT04oIWlzX21taW9fc3B0ZShv
bGRfc3B0ZSkgJiYNCj4gLQkJCSAgICAhaXNfbW1pb19zcHRlKG5ld19zcHRlKSAmJg0KPiArCQlp
ZiAoV0FSTl9PTighaXNfbW1pb19zcHRlKGt2bSwgb2xkX3NwdGUpICYmDQo+ICsJCQkgICAgIWlz
X21taW9fc3B0ZShrdm0sIG5ld19zcHRlKSAmJg0KPiAgCQkJICAgICFpc19yZW1vdmVkX3NwdGUo
bmV3X3NwdGUpKSkNCj4gIAkJCXByX2VycigiVW5leHBlY3RlZCBTUFRFIGNoYW5nZSEgTm9ucHJl
c2VudCBTUFRFc1xuIg0KPiAgCQkJICAgICAgICJzaG91bGQgbm90IGJlIHJlcGxhY2VkIHdpdGgg
YW5vdGhlcixcbiINCj4gQEAgLTExMTQsNyArMTEyMiw3IEBAIHN0YXRpYyBpbnQgdGRwX21tdV9t
YXBfaGFuZGxlX3RhcmdldF9sZXZlbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQo+ICAJfQ0KPiAg
DQo+ICAJLyogSWYgYSBNTUlPIFNQVEUgaXMgaW5zdGFsbGVkLCB0aGUgTU1JTyB3aWxsIG5lZWQg
dG8gYmUgZW11bGF0ZWQuICovDQo+IC0JaWYgKHVubGlrZWx5KGlzX21taW9fc3B0ZShuZXdfc3B0
ZSkpKSB7DQo+ICsJaWYgKHVubGlrZWx5KGlzX21taW9fc3B0ZSh2Y3B1LT5rdm0sIG5ld19zcHRl
KSkpIHsNCj4gIAkJdmNwdS0+c3RhdC5wZl9tbWlvX3NwdGVfY3JlYXRlZCsrOw0KPiAgCQl0cmFj
ZV9tYXJrX21taW9fc3B0ZShyY3VfZGVyZWZlcmVuY2UoaXRlci0+c3B0ZXApLCBpdGVyLT5nZm4s
DQo+ICAJCQkJICAgICBuZXdfc3B0ZSk7DQoNCg==
