Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEDB7250FA
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbjFFX56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbjFFX5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:57:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC99173E;
        Tue,  6 Jun 2023 16:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686095874; x=1717631874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rhsbm9OEtHGftjdp8npdGzUt4g+0SWZzZo1htXLzl4I=;
  b=gbwq+xdANL2t13K6aTgsOLR7GsjmU8+kxpxmea188YPdVaPImQ+AEVf6
   iF05nqHzjeFu2kpXRHsCsLmJzUKVfD21kY2VGmc/ZQ08gZQQcoJO+Hw1M
   ZNTi11KBldxXcEYBvJQ0w2rDfssCjEOgechWB2jjIp046KqStAzQyWSJD
   mpKlyoxdj/Fi3Evf3RMimCvdZODLFl3OJm48HeyOZiMgGNnvZrMe13nUm
   GHThh7+UPgfstEbMjvzDGYKoM2spo/BfuEPUKA+tTH+cE1cfJqjiw+xv8
   fykw/Fe9ko8eFThE0JKnDFdtN1XzHuDWhpgurDqO5JFJm1tyKOCLkHv4Q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="336456008"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="336456008"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 16:57:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="883526912"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="883526912"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2023 16:57:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 16:57:39 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 16:57:39 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 16:57:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 16:57:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqL76qkLnUcpUXdvB9UscGXZiFqjfUMYB6mNWizBP57cVvzxNjJE4ab9Gzu/OXa83Og+h1RAMSHOCT1TubG9HgQqwIn/7+6gku+t/MLiwJo+aIYajZDqblG66m1LfyXgdeAkT3tqvW23zrtMP5PRcOlANVwpHrKB3+Ejz37ckFTFC7ZokyWdBSucSUMwYfkYLyVaCuk3791HnNnNvCgpF1JkCjgcmSNi5bI6tibLjieAtjmNWhs6P1nUdLDLXqcXhq9Z8DNNREP5k+HY16oW2E+S99s4iHp9BVxHs4vvz2Y2mT0JygSsnlLXef3p98J+Qsj0nSvKqpSDMEDK4RFnAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhsbm9OEtHGftjdp8npdGzUt4g+0SWZzZo1htXLzl4I=;
 b=IQP/ngQVlCPP+HtJ/XIveU4KCMyL5vmsPs/VkWq7tuQOYM52SAgeplhQQz5HDBAi9oyQQ4T5OYdBFhg4YxxtgJoAzAe9wsE9pkB3/5S2BNYRL5cTnoQF7Czr0rPzpugA+ld7U08xllGTPooNGz397JskD8lhI27Tbd5uyKFWvlSNavOhZV0AcmzMs9BLknZHtf3bYVShebj1JRhxUM4gV/NEOBqKRXUpnBCfAZlAQPa/ME8JKVgn1ytJ5KhtGK/usgTkFXBexMpNh1vWrfo0l9TqMQjmEobR7OX3TrSPZewkOklw03CUrbWbkA378Di8ziXUGmKEoRhUjCbR2Rvttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6882.namprd11.prod.outlook.com (2603:10b6:510:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 23:57:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 23:57:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Thread-Topic: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Thread-Index: AQHZkeUiOK4roLgjWkKd/CN/ohKP6a9+gXUA
Date:   Tue, 6 Jun 2023 23:57:35 +0000
Message-ID: <05da9ce1eacab59e81801acca146b5f4949b98ac.camel@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
         <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
In-Reply-To: <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6882:EE_
x-ms-office365-filtering-correlation-id: d7070fbe-c1f1-4d4b-8595-08db66e9cd30
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xtxZpgHj44nhkKBc2BPQD8ipRIawdrnYsI7gJ8aTsMGSBKoTw68i9nNc1Tf/nAjaT0FcEQtzBw1hRqTGLEed0Ur/Lnn/ybLX6G3qrpP2Hr3MYVsAzyGDaBqgX3BmF0hIVHoX0OTCL3f88oaXTmwT5/LLmGTqDEb4MRedlS5SmLZplq6iR9gjBJqYbOV1hcuMAVCODdvH7NDSW9bG7LrFGFPtiX7DeVbYktNGNeBgMuFZDUqp5lqZiSYwPPRZLcMwrjtsmEF0+a/BkzmEQT1IdQYlS35iQQWKyLszL7DqEeLDhF/ag9j6Zu/EcSLDuZG5usercQPd640+un7uHTL26VHjGGPz62a31h5lALtBCMIFYAiNT1X+0DhGbRzw7uxqTMJ11jUe7iaMXR8Frq9nm8tYWBl3hCYm+r2BVqWN0I2utcwuJ1erLHva9i5/9J4P+8AO56Emm7IHbsYyCC4rYut0dpT1WtQm7T/TCX1aYZvxtoks/m36HN08SYH0ars+XC+xMx0zlD/S8iXCNy1OWuF3SlIGbUnO/RC/DXdtd4s4I+LhX+okBA80aUTlezMlvBROCBzWYs+zkR9YrhG/4wCsEHQ+2Y5xKug58Rbv/T6ok9e7y+a4whqePb8QxP0w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199021)(6512007)(6506007)(26005)(36756003)(122000001)(86362001)(38070700005)(82960400001)(38100700002)(186003)(2616005)(8676002)(6636002)(41300700001)(110136005)(54906003)(66446008)(4326008)(478600001)(66946007)(66476007)(76116006)(91956017)(2906002)(316002)(64756008)(8936002)(5660300002)(6486002)(71200400001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0dtdnVlY2YwUnFoNHV1MURUYjhCMzBpNS9PS0dxSS9TWkhXUWMwc0lRcFNi?=
 =?utf-8?B?M2lkNGtyUlVUb2dxK2trOXRObUlQT0VXcytvRG5TNzFpWkdHZ1J1SytzRHNR?=
 =?utf-8?B?RTJvR0RpRjM1ZTJ1SzYrM0VQeXBJN25iVmF4cnhYclkrTXdZRVRxc1pDcC8r?=
 =?utf-8?B?QVI5V0MremFyNElWQ0xFZDNvVEhzdnI4K0ZvditaTEt4UGhKNEdzUE9yOWZB?=
 =?utf-8?B?WHgzYTNGYndnWkkyKzNTWVJOQ2xNNXFsTVRuOTVMY3RUYkptWXFyTDNUVWxl?=
 =?utf-8?B?UGZDOVduMzVkbUF5eFFCSGs2QSs2RXpMeGdWTW02VjNXUk9pck9tcWNsRW9Y?=
 =?utf-8?B?RWdjQUNXelN2eS94T1FRaTN5SWNVU0xzdlhVVVNDZW5aS2NzcVNhTjB0cmxB?=
 =?utf-8?B?cjRON1BmYVIyWmRGN1kwS0k3c1F6d2c3Yzhlc1VHRWE3cUVTMTVGbmMyMFZa?=
 =?utf-8?B?a1JZZUtzdkRRT2xjamVGak90Smc0cjV1em90L1hIMHM0aXJHTmpseHllWWFB?=
 =?utf-8?B?L1ptYVhIOS8zd2FUV1U5NklCTUliYzRVSHdHZDBUNXdYYlNEcUU3bnZNa3I1?=
 =?utf-8?B?anFiQkZyczVtWk9Bdmx2MHQ3MTBVY0k5b05mSG9QV2U2WXRqZFlOQWgwbnVo?=
 =?utf-8?B?aTFIUVgwYVoyV042dzM3eDhuQWVRQVZ0M25ZVTJnajRkM0Jjc3hJSmpncGd5?=
 =?utf-8?B?SjNoU1lXOWFwdDJDcWFmT2tZRlpKY2VsakMwczlNYzU5aDFWcCtQMnVZYjVi?=
 =?utf-8?B?ZUJ5U09zWVNHS2tSSGorZ1c0KzA4c01OS0o3QzFRQ2VFSmc5OWtqYm1MU1dO?=
 =?utf-8?B?Y0RFWkFUVnBIbkphcXMzenUvaEFPTWMvaklPRWRxb05IOHJOSWxwVlVtRWdm?=
 =?utf-8?B?RDJCcXQvT2VxaDlGWmt4QVAxYjZHYkdnNm1uWGlsWEovUmhvSWR0MldkYTVS?=
 =?utf-8?B?Ty9XcXMwWEZFY0MwS3ZOSVVRRnBYSjFDNFMyQ0svSWV2KzFrQUY1MlVFaHZL?=
 =?utf-8?B?eEswdkFySzhoWHRTb1JvN3BrN3dvTCtybzNFZ0JPanMxakZRMzRBbnh2T1Y2?=
 =?utf-8?B?ZzlraDZhS1M2aHYvSXpJZGF2cnZwYmw0MVNreXAvUTRlVmNQSWZlczN2NjdJ?=
 =?utf-8?B?VzNiRDR2NE8vT0tla1VFZjNlckUxb3hXcDQ4SnB5ZTlWaTZXanNtNFpTdDJN?=
 =?utf-8?B?alk2Q3JQZFJnT01EVUZxMTVEREpsN0pUNVFyck40WlNON0ZYaE1oemdlamNQ?=
 =?utf-8?B?S1d4NHgydVNCdFJQUkJIb0p0aWkreGNEQSt5cHk2dm00U1g2OXFRRUtMY2lr?=
 =?utf-8?B?TjVMQWhBQkNyZ3FSUG5zMnozRHpPZER2bzIzWnJ3eWhuUWlFbktwTkkrU0p3?=
 =?utf-8?B?RVlzeUhGa1g2Ym8xTWxwRjMzNU5PcTBFeWFQUDRpWFc2U0QyVVplM0FaV1li?=
 =?utf-8?B?N0Z0N3N4Y0c5ZEw4S2t5blA2K2JnZWFiSStUdXdtK0JycEFKd0V2cUc3YkFL?=
 =?utf-8?B?N2ppalFhdjI1bk5mMkJGOENwOGRHeUNtanRycWU3T1VmaC9haVVtQzJycWJT?=
 =?utf-8?B?eHFtNlY4SElHeGtLSlBPbk80R0FsR0phWXMyekdzaE5sZ0gzMXRxU1JwbEIz?=
 =?utf-8?B?ajk5MEs2ZG5VMFArSnF6ZWMvVm14QnJYQ09PemhQcndhOFl2cXRIc0RzcWho?=
 =?utf-8?B?VTIwcFJSbGUrYXBMSHNLZExVS1pGUG91d0hsaGJvQVFXWThVZW9vRFk5eURK?=
 =?utf-8?B?SGlvTm1aVU1PV3UrVTFXaERSeWdFRXRJYzlHVGxJZEVHdUtwQnVkMmIxaUF3?=
 =?utf-8?B?cVkxaDM2U2RzV2Y2bEQ5WGFNV3cyNWR0ZmlxN2doZ3NNT1NDSU14V3BZMmQx?=
 =?utf-8?B?L3BseGNDTUVIMnNtYmZ6WWE1NVFuM3ZDWEpsdUxnbzRxaGl4QngzR0gvU21O?=
 =?utf-8?B?UFkwb2RKQlV6SmNlRmRvMkRzSWpvWHZkaXU0ZEptTnVYazJENHBTSVlObnJ4?=
 =?utf-8?B?Q3dycDBGWDJGdUF2ekhweVBCQlJQUVorUmp0VG51ZXJsQ1JmeE1NSkpvL09s?=
 =?utf-8?B?TU8yR1JJQ1VuWTIzTjJmaXB1a2RrbkZkQ2tsVnNpTDNRcXlkejB2OU1sQnV6?=
 =?utf-8?B?ZWY3VGVDQ091KzRWZFFvY3diRXB6dTFXcisrNDFROS93YU53Qmk0OG44Nkgw?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0751C0EC997CF44A392720FFEF46BD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7070fbe-c1f1-4d4b-8595-08db66e9cd30
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 23:57:35.8939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GvdpWvANOFi11X1F00nSkCdTbd5DOKcGNcDxnNv7erRS66TqHbs9lNlLEAQ42X8b3Btol/885/05PCgur73jYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6882
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

T24gU3VuLCAyMDIzLTA1LTI4IGF0IDIxOjIwIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBZGQgYSBob29rIHRvIHNldHRpbmcgQ1BVSUQgZm9yIGFkZGl0aW9uYWwgY29u
c2lzdGVuY3kgY2hlY2sgb2YNCj4gS1ZNX1NFVF9DUFVJRDIuDQo+IA0KPiBCZWNhdXNlIGludGVs
IFREWCBvciBBTUQgU05QIGhhcyByZXN0cmljdGlvbiBvbiB0aGUgdmFsdWUgb2YgY3B1aWQuICBT
b21lDQo+IHZhbHVlIGNhbid0IGJlIGNoYW5nZWQgYWZ0ZXIgYm9vdC4gIFNvbWUgY2FuIGJlIG9u
bHkgc2V0IGF0IHRoZSBWTQ0KPiBjcmVhdGlvbiB0aW1lIGFuZCBjYW4ndCBiZSBjaGFuZ2VkIGxh
dGVyLiAgQ2hlY2sgaWYgdGhlIG5ldyB2YWx1ZXMgYXJlDQo+IGNvbnNpc3RlbnQgd2l0aCB0aGUg
b2xkIHZhbHVlcy4NCg0KWW91IG1pZ2h0IHdhbnQgdG8gdXNlIHNvbWUgZ3JhbW1hciB0b29sIHRv
IGNoZWNrIGFnYWluc3QgdGhlIGNoYW5nZWxvZy4NCg0KQWxzbywgcGVyc29uYWxseSBJIHRoaW5r
IGl0J3MgYmV0dGVyIHRvIGJyaWVmbHkgbWVudGlvbiB3aHkgd2UgY2hvb3NlIHRoaXMNCmRlc2ln
biBidXQgbm90IGFub3RoZXIgKGUuZy4sIHdoeSB3ZSBqdXN0IGRvbid0IG1ha2UgS1ZNIHJlbWVt
YmVyIGFsbCBDUFVJRHMgaW4NClRESC5NTkcuSU5JVCBhbmQgc2ltcGx5IGlnbm9yZXMvcmVqZWN0
cyBmdXJ0aGVyIEtWTV9TRVRfQ1BVSUQyKS4gIEl0IHdvdWxkIGJlDQpoZWxwZnVsIGZvciB0aGUg
cmV2aWV3ZXIsIG9yIHNvbWUgZ2l0IGJsYW1lciBpbiB0aGUgZnV0dXJlLg0KDQpBbmQgd2h5IHRo
aXMgcGF0Y2ggaXMgcGxhY2VkIGF0IHRoZSB2ZXJ5IGJvdHRvbSBvZiB0aGlzIHNlcmllcz8gVGhp
cyBsb2dpYw0Kc2hvdWxkIGJlbG9uZyB0byBURCBjcmVhdGlvbiBwYXJ0IHdoaWNoIHNob3VsZCBi
ZSBhdCBhIHJlbGF0aXZlIGVhcmxpZXIgcG9zaXRpb24NCmluIHRoaXMgc2VyaWVzLg0KDQpbLi4u
XQ0KDQoNCj4gQEAgLTMyLDYgKzMyLDEzIEBAIHN0cnVjdCBrdm1fdGR4IHsNCj4gIAlhdG9taWNf
dCB0ZGhfbWVtX3RyYWNrOw0KPiAgDQo+ICAJdTY0IHRzY19vZmZzZXQ7DQo+ICsNCj4gKwkvKg0K
PiArCSAqIEZvciBLVk1fU0VUX0NQVUlEIHRvIGNoZWNrIGNvbnNpc3RlbmN5LiBSZW1lbWJlciB0
aGUgb25lIHBhc3NlZCB0bw0KPiArCSAqIFRESC5NTkdfSU5JVA0KPiArCSAqLw0KPiArCWludCBj
cHVpZF9uZW50Ow0KPiArCXN0cnVjdCBrdm1fY3B1aWRfZW50cnkyICpjcHVpZDsNCg0KU2luY2Ug
dGhlc2UgQ1BVSURzIG1heSBvbmx5IGJlIHBhcnQgb2YgdGhlIHZjcHUncyBDUFVJRHMsIHlvdSBt
YXkgd2FudCBhIG1vcmUNCnNwZWNpZmljIG5hbWUsIGZvciBpbnN0YW5jZSwgY29uc2lzdGVudF9j
cHVpZD8NCg0KQWxzbyBpZiB5b3Ugd2FudCB0aGlzIGJlIGNvbW1vbiB0byBBTUQsIHRoZW4gcGVy
aGFwcyB0aGUgY29tbWVudCBzaG91bGQgYmUNCmltcHJvdmVkIHRvbyB0byBiZSBtb3JlIGdlbmVy
aWMuDQoNCg0KDQo=
