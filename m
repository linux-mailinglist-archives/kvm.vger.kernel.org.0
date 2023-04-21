Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1154A6EA6C0
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDUJR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 05:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDUJR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 05:17:26 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6218E;
        Fri, 21 Apr 2023 02:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682068645; x=1713604645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TrkSTK40Mps7wIRrjHiWC3+KOr9aT5Jn6yaLtRVa5QI=;
  b=W41JReHCuYP7TyToePh6UPWYEE5R6Jnwv51NBY+4NaP831rRq1NkAukq
   tnH4UaoZvMT1BqDJpDy5DKGFCXT9HRj3sQE2c41bhom7P4xjD/SwqHvS9
   WodVa6I+vVXAX8EPJDB9ZKZT7Gu8G4iX7ECJtud4NRps3/3s+4nuVukL6
   YCeZpd7FZT1+U+IE9RPUzaHA2C5kbXUNyPcilXgPoU3Q+wuLC7m/8Itlm
   0pzl7B/UDvU+7Df1izmYcsP12U3sL/LsMHw8Nh1eANJ5Yeids6M8R/Umz
   512rMiHczGWM5JphqrLWYq1v6EN2ZK2G64s+IVEclfIsxkFpnWNbvx02I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="408891572"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="408891572"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 02:17:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="724752030"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="724752030"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2023 02:17:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:17:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 02:17:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 02:17:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 02:17:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gn/hTaqOL7HVK9bMbGIFwJ0zRTvU1cHDQAPjTDWfBs2x3ZYRP8ez/krff0bITg45iAOQCXB3uUriSO+/Inihle78fSE/5qEyEi02iWtTHlzXPBL90+Emt5g4zLQOssgPJCMDsVxnsGcPU/Aem5mpl5zyeblCQhwYcbkXSRc8d7VIDc4cBqKGuwaGfgNxrW+JLjoVn96HfFQdtdWv/Rx22NviDFEVmtL/xIcmV43NfHdNRNb9NzJjK+dWIc4DCIqTObbctRA80GxYMvsKuI6iVG9+O8L6g196IfnBbin9b39ufK/sLSsHG/KdZE+imscoXAh92CIP44JztlyEtsSCUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrkSTK40Mps7wIRrjHiWC3+KOr9aT5Jn6yaLtRVa5QI=;
 b=DwQ/1w4BSuOwEX0iW+CT8aMiq6TitfbiSokMLzzwKk3rFZ/GYGqaNOqlrYrajf2QUvjXz1WshNDTceMz6ed98/3Tm8vnBSqW5CbYxcuQ6v/6lFRb1lmbt7xPY1wvSzzAaqxVAgpl4V4gtLoDZR7gSAZJMljGtSNv23RyCzStdoGfH/lDhVoguFTR4/5Fh93fRKTOMiXipef5rs0aHB6qwAQzWXZNGNWfK+xq8ocWIJhns0h9RY3zuX8J1vhcfxDnF++iKuNHI11epU3hr5UjraHxSUcE4dMUSV/DO5ezUk0IjqCvWJyIK6IAqTcmC2wiQ5fPhYwmOwzGenNIvupnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 09:17:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6298.030; Fri, 21 Apr 2023
 09:17:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Topic: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Index: AQHZaBjVaqwUToI390GQi+QIa02Ixq8eASCAgACSBQCACPzaAIAOA/GA
Date:   Fri, 21 Apr 2023 09:17:20 +0000
Message-ID: <c7c93661bca6fb464bc3adbac39c841cbf6225e0.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-3-seanjc@google.com>
         <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
         <ZC8IsP5ehaJXQOnu@google.com>
         <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
In-Reply-To: <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7708:EE_
x-ms-office365-filtering-correlation-id: bba98714-1374-4eb0-1b8f-08db424935e1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x7YXt1ARNrSsFBsypPzzQgZ4OFMigeInqJuJHSf1C4qJjU97UfcVuJPopzTHynTs2WNvNpsxOz22hnkpl2Q1h0Akri16mWXNdZa93cmaWGoQVgptBDALylE9fz9VkAm0Ul0Zl03vYGNrfZMcC/SsJ8KGXhPZamxuQFu5NRRDECQCFH7ZaSRLydeYsMRpqybR3XHJFpG9H3LyBwW3An7PROdYKrNcEos3OJVYINDtwXvzRHCIVuuQwdkeJFpp9BOsm/TqoBsrHqcp/GHLhoBMPrpnLUnPt3o0te+fht3gdhSG1aKW0kPYnfiNAWuLHSwB99NgvgvzT/a3y22JIkYt2iLkIBX+bQ5k+GxBlA+CQpkQ7/cpyOnRlhj5GJ9ZG4cMh5JLO0XGN6p3RFz13ukbyvhaMFgHLGCBjnVMPUpzHA2pEYry9Fj7r05aCavi1CQd/UxdHcZb6mv24f+y9GRb10ER5tag6+yRiyYVCmQKooSaYH3AKXcSeGT99+//vhLe3omfdlqDFfoNCQLfFI9qK2xjYeHgZEyUsQTTiZ6rq8+oJeYdK509fpN6TSRq+uoLT3bqJPZQhSPYMB+4nYw+5yN1LiATVC/bnwZY7RlfcHrB/E/A6ka/VHn2F4s2OgEv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199021)(2906002)(4744005)(38070700005)(8936002)(8676002)(122000001)(41300700001)(82960400001)(5660300002)(38100700002)(36756003)(86362001)(478600001)(54906003)(2616005)(26005)(6506007)(6512007)(71200400001)(6486002)(76116006)(91956017)(186003)(6916009)(66946007)(4326008)(316002)(66446008)(66556008)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVp6U0dpUHRLTmNNeWhuM2M1UEVKOHVlMmVMRjFZdW5hUE5INTU0V3Q3ekpS?=
 =?utf-8?B?Y0tnY2J6Y254T3NTNXQvR1lpWmdtVEJENUVBVVptRGx1dkpYRVl4Nm8ydGdP?=
 =?utf-8?B?ZjBDbEhTbmd3dWo0N3NBK2dIQkNRYlJzb1FWMzFQWm9rTXRrRDROWXcrZVN2?=
 =?utf-8?B?T3NsM0V5M2NOdlh2ZG5wMnFKQjFHS0ZUR0dlcVg4Nnp0anZSeGovdG9IOHA4?=
 =?utf-8?B?Y2xpVE9neE5vdFpXTUYxWEdPWlc4RGxMSDl6UTkvbVZONTNwaEhWTmJWRUR1?=
 =?utf-8?B?MUpZNEhQY0VkeEI5Ui9vWjhka0RwT2tGVmpWTDhtbTBpSEpFNnVXQjkycEFv?=
 =?utf-8?B?VVJib2NXS2FLNjNtbUQzUCs5ZjgvdldhaG1vaWEyUzBzVEpTNjJ5VSsvSjVL?=
 =?utf-8?B?alJwdGloTXhsbGh2c1JiZmNlNFFBckUrV0RSME9ERVkvRHlFSk5rQ0NDd2R4?=
 =?utf-8?B?WnhPYzJRb3phM3VKWHRCTlQ4SzdzUmVIaCtZQW44aUlaT29kTGNHdlFzc0pS?=
 =?utf-8?B?VERGSFVaczlVUVhvRjdSMjNDRWFmRE91VTUxcFpMTWhpZkhRejBLdEhURlhz?=
 =?utf-8?B?eFhUUFVhMG9PWDdqQ0lMZFVQaW1DVlo2ZTRETUFlKytoNll4blErR2FBK3NG?=
 =?utf-8?B?TGRQTG1iK2c5Y3UrRTJnS3NybHBveTRJR1lLTzFhajVnbnkwNU03VlVhTmxQ?=
 =?utf-8?B?cmx2cnMrTzNIRkxaQWIrcWFidVVzVEg5N1FHT1JRS1hJMEQybDlRZWM0NS83?=
 =?utf-8?B?Ri82L2VaTXRGTVI2QVo3VFg4NEtLK3NXaFdSbGlIRjJQTjRIVE1uaDRtdTlF?=
 =?utf-8?B?OXh0MVJScVphOFcrZk9POCtmUFJwY0JXZ2RoT3JOejlPZWc5bXQvUzM0cGtz?=
 =?utf-8?B?elQvTjEvUnhobVV2ZDYrYk5nTUZ1aXRDSHJIUG9oTnlDZXoyUGM2Z1hmOU9o?=
 =?utf-8?B?cnhSNGliTlVjU3FMZkw5MzhPeW0rdmxncUp5OUp0NThHN3BTYVNuNUhjL0R5?=
 =?utf-8?B?TEMxUDl6MU1Yc2Ircm1INldpbUYydVdJcmtXblFBZGsxZHJnMjUyci9LcmxY?=
 =?utf-8?B?MTZYdzM1Tm4xMXEwbElET2dUbHF1MURGR2NZTkRWbmZ1T0o1OGNLbHZhcnJl?=
 =?utf-8?B?WTIzcnlTZGxHMXRwb2FtdC9yUTNIUnBTL1ozTU5aSzRVblEvbzhMaXNCVCtW?=
 =?utf-8?B?VkxHczRYa3FKVnlZNDNDL3FvbkJHbURzQzFvd0wwSElLYW9PN1N3ci9GMUFG?=
 =?utf-8?B?SUhuTXp5OWpxdlhHbk1uWC9DMDc5TkxkYUJHRklSR2E0M3V0ZG9CK1ZEQXVS?=
 =?utf-8?B?VEpLc3RWVmZoNVl1M2RWdHUyTlQzZE9ZRWdETW1kM2hqeEdUN2dYYjNBRmUy?=
 =?utf-8?B?WUc1TldJTkUzRnFNVUhFckw0VUVoOUdGSXNpb1JHenluc3AxZFdkUndxSHJa?=
 =?utf-8?B?N3ljU0NNQytlT1loYVdWTFE3NldFZ0hPLytlRG1GUGFjMDZ2bis4dU5rUmZ3?=
 =?utf-8?B?Z2ZTaE82ZUMwV2hvaDNaVlNacTFmV1huWnFUaGhYQXpYOW1CQ2ZkOXFWdDdV?=
 =?utf-8?B?V0d5K2IvUXdCU2N0Wm1STjZKUzY4MlNJWXdlbithc2JwcjRHVXdRci9hajhQ?=
 =?utf-8?B?RlVQZDFHYWZSVHZrRk4wMU5xSElTVTl0aHJ4UXB6eVV4ZDRIOHh1dGc1WDNC?=
 =?utf-8?B?YlVtN1lwQmdobllDWWc5TEhsd1ZQcEgxaDlPTlVGNHFpZURRc3VyVWJPNWdu?=
 =?utf-8?B?UkdGWjNNQWgwNVRUd1BtcS9RL250VThGZ0YzS3pKSy9hRHhESDRFdE54dVRR?=
 =?utf-8?B?RGVOb3BqTHB2M3JHbFczWTBkMVEwcWVjYmNNbkJJQlZ4WFFwZkE0ODdPajU1?=
 =?utf-8?B?UWxZSjhScDc4K0MzQ3gvVXI5T2VGR0lpcTBWQzRmL09zMElvbmh6QUVoMUtR?=
 =?utf-8?B?eFdVZE8xYTJ0RDZ5dWY5WnpkcHFWM1IxRHVHWjZBZWJxc0RwK0d1WmtOZXk2?=
 =?utf-8?B?S1JacndUajk4a1hUTFBIQTEvdlJFRkdRQVFDVHlqSlo1aHA3VCtQa2NlYmYz?=
 =?utf-8?B?SGVqTmRTN1BmYk1SOXJSNjU2eWpSbHhCNHcyU1pFYXRsangwUFVJREJONm9G?=
 =?utf-8?Q?oOK7YJxGeJG7iXpiu/ivfAgnu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2D7F3620C17A7478829C56AAB2EACD2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba98714-1374-4eb0-1b8f-08db424935e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 09:17:20.6916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oxd6S1clH9SbGQcRGX0zJ89ZjKoW8lkiLfj48gULMAlbczNftIFGIcC0PIzXjWvPR1GB24vYHObfjImgiflXQA==
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

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDExOjE1ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjMtMDQtMDYgYXQgMTE6MDAgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gVGh1LCBBcHIgMDYsIDIwMjMsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiBP
biBXZWQsIDIwMjMtMDQtMDUgYXQgMTY6NDUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gPiA+IFBlciBJbnRlbCdzIFNETSwgdW5zdXBwb3J0ZWQgRU5DTFMgbGVhZnMgcmVz
dWx0IGluIGEgI0dQLCBub3QgYSAjVUQuDQo+ID4gPiA+IFNHWDEgaXMgYSBzcGVjaWFsIHNub3dm
bGFrZSBhcyB0aGUgU0dYMSBmbGFnIGlzIHVzZWQgYnkgdGhlIENQVSBhcyBhDQo+ID4gPiA+ICJz
b2Z0IiBkaXNhYmxlLCBlLmcuIGlmIHNvZnR3YXJlIGRpc2FibGVzIG1hY2hpbmUgY2hlY2sgcmVw
b3J0aW5nLCBpLmUuDQo+ID4gPiA+IGhhdmluZyBTR1ggYnV0IG5vdCBTR1gxIGlzIGVmZmVjdGl2
ZWx5ICJTR1ggY29tcGxldGVseSB1bnN1cHBvcnRlZCIgYW5kDQo+ID4gPiA+IGFuZCB0aHVzICNV
RHMuDQo+ID4gPiANCg0KWy4uLl0NCg0KPiANCj4gUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2Fp
Lmh1YW5nQGludGVsLmNvbT4NCj4gDQo+IA0KDQpUZXN0ZWQgYnkgZGlzYWJsaW5nIFNHWDIgaW4g
dGhlIGd1ZXN0IGFuZCBydW5uaW5nIFNHWDIgbGVhZiBpbnNpZGUsIGFuZCBpbiBteQ0KdGVzdGlu
ZyB0aGUgI0dQIGlzIGluamVjdGVkIHRvIHRoZSBndWVzdCBkdWUgdG8gbGVhZiBub3QgZW5hYmxl
ZC4NCg0KVGVzdGVkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0K
