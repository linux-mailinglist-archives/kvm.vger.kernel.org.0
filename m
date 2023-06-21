Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC17738E78
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 20:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjFUSUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 14:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbjFUSUL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 14:20:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E441FC9;
        Wed, 21 Jun 2023 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687371605; x=1718907605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Nw5tgxx6EmPzVc2lb8Oe33Wmy4TYmQaI7uIB1C9cFuc=;
  b=WQGGzC47dgIsdz2bbb4/P2XU+qesgBzBJM4USFTQDhKnO6GoTcl8WhTA
   d7a0mpV458vzpIs7usccJ1dFjokOqkafWgFLAzUR8bmNfI5T+Tf4Ws78A
   TcgVuSdH6y846svI2k6FIZSWo2S7P1cX1jop+Q6NK8W+AmHLFoz05e/UW
   gI/aJvroRYVjrLV75oi1hI7arxoGtP1d7ErFJtYiefloj+DTTK+rqgTj4
   O+25KtzwtLDShpXvz2XYE1OzR6HDbdx5kPPYBTCAR3wY9KvRNfSEvYCvO
   +c38Q6gZyrs817YIVMvBullHoF9WpHaf+wdnC0NkUBrb6QTqTBune39vZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="362800138"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="362800138"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 11:20:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="691943721"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="691943721"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 21 Jun 2023 11:20:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 21 Jun 2023 11:20:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 21 Jun 2023 11:20:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 21 Jun 2023 11:20:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 21 Jun 2023 11:20:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqdqRMIQZePGtiYY3ZHXDyYRUEu/yg6uvSxks3GiD63pGUxJYInoRG+xcjKpO1SEfIC0o15V+oDeVrj/5yQtpiTFy7HD5/ag8EleSjosJFGlHzXvLc4YQMmSFvxuubjROeJQlCT6upEyd0uwqB5O8wsttQAyy5MQOu1A87ugmshHVd0O6rbqSTgNMt58boR1NcSFyZWbAqR3BzqDniTsBziaQVCScvzGI8i9Isci8E8jBy8Gti2dmvvdplAdNMy9erVROxvW7blEjEA3qzTDRXuTkTRJrMB8sMVR0zKaiuUFyUXM8xMYvrXpjzU1GdYn1YiMWla8B3oF1429d8Tx9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nw5tgxx6EmPzVc2lb8Oe33Wmy4TYmQaI7uIB1C9cFuc=;
 b=UROCvUo+d2Snsxh2d4vWddDYe79p+S9erzfbtTOSAPR+FKsPo4h+lnqvVSQey+rvslpmvzLTVeZG8oC5VmiY69jSlTEWpvYwnaH6ik9EMLfqybCcd+clT6dVqfn2V+kXLteLwDr4SwobjPGBOEofjjRMucbHG7Y+l9NNsSP6O1xU6xqHne7yKBkyirSf4YN+uKP6mF0WjYnW/ojz8XA7WoU5ZJvx33JlQUdLfD/vqWPBB821lnC8aJhdLVSjhrVVmqbYHtPSGbZj/msfZP8RDWa4p4PHyYbpjJcfQaJpvlVcVa/goDq+tj/T8FyQ9x+FM8Z16IkbnVpctq46HoYECw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by PH7PR11MB6905.namprd11.prod.outlook.com (2603:10b6:510:201::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Wed, 21 Jun
 2023 18:19:58 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::59ba:4a19:43ed:b66b]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::59ba:4a19:43ed:b66b%5]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 18:19:58 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     "Annapurve, Vishal" <vannapurve@google.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        "Michael Roth" <michael.roth@amd.com>
Subject: RE: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
Thread-Topic: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
Thread-Index: AQHZouH2DpEq+EqxQUmyb3JFxZS8na+SjsIAgAAc6ICAAuc+4A==
Date:   Wed, 21 Jun 2023 18:19:57 +0000
Message-ID: <BL0PR11MB3042820B6CD6E4926E7BA50E8A5DA@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <CAGtprH8O6dsjjNrMzLPmRio0ZDLe6M3U06HD0oNX3NN9FeWQfg@mail.gmail.com>
 <20230619231142.0000134a.zhi.wang.linux@gmail.com>
 <CAGtprH8jreK52wTcNhoAcBoHKZfkQ_1AYArgb2v6M_YVRYAw+w@mail.gmail.com>
In-Reply-To: <CAGtprH8jreK52wTcNhoAcBoHKZfkQ_1AYArgb2v6M_YVRYAw+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|PH7PR11MB6905:EE_
x-ms-office365-filtering-correlation-id: c77ef60f-9b9f-48a2-56b2-08db72841e98
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ls73yZaAX7QX1WMyaCFUSMmEjkfQAK52UBqNva6Tf25Xya7k/JnRhTQZxEc9Uh2Z0I7eEVNByjZz5de8HSV2813qEECx1y/pp0bb/dYflCBPyk3B3Q5sjf2CN7MMt8A8Dxy4/XP/LuEAJnT6cH9QHR0gaTL/FdLqugf83AOamimO2EA+omFZyQVs/TJuY3gWeNgG9oG3z1fl5jPWksU3g08ewblJ+h8mWKlOUn+E1ZkVxK/GiObDJO7xANeO3drk4yZIJnNxlFw8z7fzhdjZjhSlMD1k75QL6I9QUQ1uEo73aY2AiKxe+CCuk/9rT0wgGRGrpZdznTsus/V7iTo4iPQpMdaYJoJs4ev1O18enURXIUgsJvwFVuaYbk00aa7TfekxSg8M0zNr0Q+PSADdAZh1apBZB88sMYDPVZpte1aexZCa7zxYhflQCaEqajsgpM9OWjsu0XNZKKjjclLK4QxqLpVg7feJ9mEBqgYEVgC+07KQHypnfPoF3LK4dwKQbfVLO9mwfC5Vhuo7glyEdgH+7WZ1LzMi6AUQ2NAd2TfTpaGVbT/bwuARw5syGxR1bNah2VynMXTCfCeRjgITLVjZ8G1klCHfjufWqipuYXk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199021)(26005)(6506007)(2906002)(966005)(7696005)(9686003)(38070700005)(55016003)(86362001)(8936002)(66556008)(66446008)(33656002)(76116006)(41300700001)(66946007)(64756008)(316002)(4326008)(53546011)(186003)(38100700002)(122000001)(8676002)(66476007)(82960400001)(478600001)(83380400001)(54906003)(7416002)(110136005)(71200400001)(52536014)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE1DcEFtTFhaWWs4ZzZOTmE5QmVBNXFnWU1kckk2MDk2QU93Zi9EUERPZDFC?=
 =?utf-8?B?RTNzL0hSMnR1RWlZTU14S2dUdkxCNWNINi9JTzBId0Rncm12cjZTLzRPNzZW?=
 =?utf-8?B?d3B0UVg0TmpDdWZsSlJVdHNSK09FMXQyRi9XeUhPaFR4UVVBNy9JOGduNkRz?=
 =?utf-8?B?dWJiTkZ4ak1DMFp5bnZzdXdpM0MvSWxFR1cxUE1aVVo2SU1lL1BwbEN6SEpz?=
 =?utf-8?B?WnJodnAyQTMxSFFuY0lNaWZYcnZWN0xadzVGYjJYdmgzQmFsb2Fjb2J5cnBv?=
 =?utf-8?B?VU1oazRsMjNSeXowY1M0d3h1ZWs1U3hCQzQyWkJFYmdQR2MyNStDN094V01O?=
 =?utf-8?B?K2lMTlZhdWhna2s0a1lCM09vTFdqUDNWMG5ib1Q4TThuakpVcWxycmNWUzg2?=
 =?utf-8?B?SGNMTkRDWDJIMlBSMjQ1Vjl2czlFbzR2VzBiYk9URW9vNUpBS2pwc0Ntd01Y?=
 =?utf-8?B?OWpjeUs3dlZ1YkJiRGRqSEtOWnNkYUZrNlhkWEZEbCs3OGZKUFVyU3dhVVZN?=
 =?utf-8?B?R2QwajlIOWVxZWsvTUNUOTVQckc0bW42eUNwT05MbzhsSjZpN0l1S2pLdERp?=
 =?utf-8?B?QmZRM04vWVNOclJvK202R0xkT3RObHk0cUxEbHJaRDYvVStSQ2E5aU05WXQ3?=
 =?utf-8?B?OExrNmpLS2k2TVlHRmlkQkwyczlmTGhCcFJZYkMyeHMzR2NNVWg1MHdVYkM2?=
 =?utf-8?B?U0FCNmZoeDNuTytWRG1OYXY1WkdzVUFMWkpWTy81Wm9TS3FXTCtNMHpZRU8r?=
 =?utf-8?B?YzJZQ1pIN3hpTzArcGxRMlRYb0FQdGtCa2NSRUlyMldmaXdSQUx1RUV6aVp5?=
 =?utf-8?B?TXNwNTZCRGdRUjZrd1pib2V3ZGdtYzMyT0VaaDlMTjk2NTZTU2szSnJvSHo3?=
 =?utf-8?B?V2VWc3BKdnFTRVFvRzV0SUdNc2x3Y2RlZHNvYnBMdi9UbkZrUEtwZWxLVEdU?=
 =?utf-8?B?NkF6dzNmS3N4WVVDN1ZUVzRFYjEySmt2R2pxMVFNMkphVVg1T2FPV1M2dlJR?=
 =?utf-8?B?QmtteDRmWkc0MDNrd2ZYQ0p4Zmtpb1Qrb294YTJNVjNDZkliNk9jazYrMlVJ?=
 =?utf-8?B?NU80VWxmRzNhMlZWUEQweWhKaWdKNHdISUpGTG1jM3d4SGgrVVAzbDFGejZM?=
 =?utf-8?B?ZDZrMWZOeVIxVktUZzNqWDYrODQwL1NlZkgvRWVqeDhwZVROaHVld2xENFBo?=
 =?utf-8?B?a3psUzYvbGZSZnlRN3E4a3kzNlVITmJKME5VeUNJVDFkblBHOXZlSGszanJ4?=
 =?utf-8?B?ZCtYd3AwcWFmcUxvRjFsaTdNYmJjeERqc1VDc0Y3aXVGODZvNGdRSXVDcUVG?=
 =?utf-8?B?RVp6dG8xNGpJNVB2aFJhYzlrV3JzRzYrWlZTV2Z6b2d3MEJ3WU9OUzJ4NUJo?=
 =?utf-8?B?d1IyREc5aTVlQ0tKNXM2ZjkyTElTL2Mrd1NJL3hwMjQrN0hLUm8vV1hTY3Zp?=
 =?utf-8?B?MFQ1K0t2YmpoV2VML2JTQ2hYbnNLWDNZVzIwc3AxOVAvWTNsU2RoVExRakE3?=
 =?utf-8?B?VkRCNStzVkxmMWpUZW00Z2tOdEt0RU5KWUNhcW0xdUo1VXh2Um8vTngyTmp5?=
 =?utf-8?B?allsMUpvRldIa1RtWGRnL2F4RGkyZEFUUkVFaTJUZnV2UGxELzVWa0F4eW5n?=
 =?utf-8?B?aDFJVnViTXdFMXVwaDBYc2h4dzQrbFh2NDBFcFhzM2ZoZ1FkaVFVYzZKdzhI?=
 =?utf-8?B?L2xrZHVVckZlWW0raGxRYWZBWVdqcno2blRLN254QmY0MEkzblVnZTBTODhu?=
 =?utf-8?B?ZzN2SzJ0UUp0dW1rcDlaZkdkR1pIOURLMlkvdnJLaGpCSk9pQVdQTEpwS3ov?=
 =?utf-8?B?TXA5aDlZd1RnVVR5UGV2L0d1NWYxL0w1ZHRkendvZmhxbXl4VU1TbVNKeVNN?=
 =?utf-8?B?Zmd2UHFvSUJ4MitzYTRreHd0VnRMWTZTNEZjQmRnUmJVeU1VVGlMcGM1T3JY?=
 =?utf-8?B?cHRmd0tYdE1SSlkzOVFoN3dnbFJTM1dRSlc4WDVoaUFqKzQwT21Jdkg3UWJo?=
 =?utf-8?B?ams1VjJ0dmY1YXJOeFREdm5OaFdBeEQ5djVLOUZEakdTL01EZWJYaUdHQy9F?=
 =?utf-8?B?OHZCZ1RnelMzd05RMmtGWmtsRUFrTlZpOHdSOWRkeUJZMXNBdWVyUWJacVQ2?=
 =?utf-8?Q?/N6ELNfCC1OI0jR4dJI4Ez2bf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77ef60f-9b9f-48a2-56b2-08db72841e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2023 18:19:57.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bayM1giVfCCMQyjF56+y5e1N3MR+wOu2iti+MragjNqhTHll08y8/v6I/afXKdhuzZ8sOA8Y1uXwfCJmPEyuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmlzaGFsIEFubmFwdXJ2
ZSA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPg0KPiBTZW50OiBNb25kYXksIEp1bmUgMTksIDIwMjMg
Mjo1NSBQTQ0KPiBUbzogWmhpIFdhbmcgPHpoaS53YW5nLmxpbnV4QGdtYWlsLmNvbT4NCj4gQ2M6
IFlhbWFoYXRhLCBJc2FrdSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPjsga3ZtQHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgaXNha3UueWFtYWhhdGFA
Z21haWwuY29tOyBQYW9sbyBCb256aW5pDQo+IDxwYm9uemluaUByZWRoYXQuY29tPjsgQWt0YXMs
IEVyZGVtIDxlcmRlbWFrdGFzQGdvb2dsZS5jb20+Ow0KPiBDaHJpc3RvcGhlcnNvbiwsIFNlYW4g
PHNlYW5qY0Bnb29nbGUuY29tPjsgU2hhaGFyLCBTYWdpDQo+IDxzYWdpc0Bnb29nbGUuY29tPjsg
RGF2aWQgTWF0bGFjayA8ZG1hdGxhY2tAZ29vZ2xlLmNvbT47IEh1YW5nLCBLYWkNCj4gPGthaS5o
dWFuZ0BpbnRlbC5jb20+OyBDaGVuLCBCbzIgPGNoZW4uYm9AaW50ZWwuY29tPjsgbGludXgtDQo+
IGNvY29AbGlzdHMubGludXguZGV2OyBDaGFvIFBlbmcgPGNoYW8ucC5wZW5nQGxpbnV4LmludGVs
LmNvbT47IEFja2VybGV5DQo+IFRuZyA8YWNrZXJsZXl0bmdAZ29vZ2xlLmNvbT47IE1pY2hhZWwg
Um90aCA8bWljaGFlbC5yb3RoQGFtZC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIDAv
Nl0gS1ZNOiBndWVzdCBtZW1vcnk6IE1pc2MgZW5oYWNuZW1lbnQNCj4gDQo+IE9uIE1vbiwgSnVu
IDE5LCAyMDIzIGF0IDE6MTHigK9QTSBaaGkgV2FuZyA8emhpLndhbmcubGludXhAZ21haWwuY29t
Pg0KPiB3cm90ZToNCj4gPg0KPiA+IE9uIE1vbiwgMTkgSnVuIDIwMjMgMTI6MTE6NTAgLTA3MDAN
Cj4gPiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+IHdyb3RlOg0KPiA+
DQo+ID4gPiBPbiBUaHUsIEp1biAxNSwgMjAyMyBhdCAxOjEyX19fUE0gPGlzYWt1LnlhbWFoYXRh
QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+IC4uLg0KPiA+ID4gPg0KPiA+ID4gPiAqIFZNIHR5
cGU6IE5vdyB3ZSBoYXZlIEtWTV9YODZfUFJPVEVDVEVEX1ZNLiBIb3cgZG8gd2UNCj4gcHJvY2Vl
ZD8NCj4gPiA+ID4gICAtIEtlZXAgS1ZNX1g4Nl9QUk9URUNURURfVk0gZm9yIGl0cyB1c2UuIElu
dHJvZHVjZQ0KPiBLVk1fWDg2X1REWF9WTQ0KPiA+ID4gPiAgIC0gVXNlIEtWTV9YODZfUFJPVEVD
VEVEX1ZNIGZvciBURFguIChJZiBuZWNlc3NhcnksIGludHJvZHVjZQ0KPiBhbm90aGVyIHR5cGUg
aW4NCj4gPiA+ID4gICAgIHRoZSBmdXR1cmUpDQo+ID4gPiA+ICAgLSBhbnkgb3RoZXIgd2F5Pw0K
PiA+ID4NCj4gPiA+IFRoZXJlIGFyZSBzZWxmdGVzdHMgcG9zdGVkWzFdIGluIGNvbnRleHQgb2Yg
dGhpcyB3b3JrLCB3aGljaCByZWx5IG9uDQo+ID4gPiBLVk1fWDg2X1BST1RFQ1RFRF9WTSBiZWlu
ZyBqdXN0IHRoZSBzb2Z0d2FyZS1vbmx5DQo+ID4gPiBwc3VlZG8tY29uZmlkZW50aWFsIFZNcy4g
SW4gZnV0dXJlIHRoZXJlIG1pZ2h0IGJlIG1vcmUgd29yayB0bw0KPiA+ID4gZXhwYW5kIHRoaXMg
dXNlY2FzZSB0byBmdWxsLXNjYWxlIFZNcy4gU28gaXQgd291bGQgYmUgYmV0dGVyIHRvDQo+ID4g
PiB0cmVhdCBwcm90ZWN0ZWQgVk1zIGFzIGEgc2VwYXJhdGUgdHlwZSB3aGljaCBjYW4gYmUgdXNl
ZCBvbiBhbnkNCj4gPiA+IHBsYXRmb3JtIHdpdGhvdXQgdGhlIG5lZWQgb2YgZW5hYmxpbmcgVERY
L1NFViBmdW5jdGlvbmFsaXR5Lg0KPiA+ID4NCj4gPg0KPiA+IE91dCBvZiBjdXJpb3NpdHksIGlz
IHRoaXMgcmVhbGx5IGEgdmFsaWQgY2FzZSBpbiBwcmFjdGljZSBleGNlcHQgc2VsZnRlc3Q/DQo+
ID4gSXQgc291bmRzIHRvIG1lIHdoZW5ldmVyIEtWTV9YODZfUFJPVEVDVEVEX1ZNIGlzIHVzZWQs
IGl0IGhhcyB0byBiZQ0KPiA+IHRpZWQgd2l0aCBhIHBsYXRmb3JtLXNwZWNpZmljIENDIHR5cGUu
DQo+IA0KPiBQcm90ZWN0ZWQgVk0gZWZmb3J0IGlzIGFib3V0IGJlaW5nIGFibGUgdG8gaGF2ZSBn
dWVzdCBtZW1vcnkgcmFuZ2VzIG5vdA0KPiBtYXBwZWQgaW50byBVc2Vyc3BhY2UgVk1NIGFuZCBz
byBhcmUgdW5yZWFjaGFibGUgZm9yIG1vc3Qgb2YgdGhlIGNhc2VzDQo+IGZyb20gS1ZNIGFzIHdl
bGwuIE5vbi1DQyBWTXMgY2FuIHVzZSB0aGlzIHN1cHBvcnQgdG8gbWl0aWdhdGUgYW55DQo+IHVu
aW50ZW5kZWQgYWNjZXNzZXMgZnJvbSB1c2Vyc3BhY2UgVk1NL0tWTSBwb3NzaWJseSB1c2luZyBl
bmxpZ2h0ZW5lZA0KPiBrZXJuZWxzLg0KDQoiUFJPVEVDVEVEIiBzZWVtcyB0byBiZSBub3QgdmVy
eSBjbG9zZSB0byB3aGF0IHlvdSBtZWFuIGhlcmUuICJQUk9URUNURURfTUVNIiA/DQpXaGF0IGNh
c2Ugb2Ygbm9uLUNDIFZNcyBtYXkgdXNlIHRoaXMgZmVhdHVyZSBpbiByZWFsaXR5PyAgT3IgZG8g
eW91IGhhdmUgYW55IGV4cGVjdGVkIGNhc2VzPw0KDQo+IA0KPiBFeGFjdCBpbXBsZW1lbnRhdGlv
biBvZiBzdWNoIGEgc3VwcG9ydCB3YXJyYW50cyBtb3JlIGRpc2N1c3Npb24gYnV0IGl0DQo+IHNo
b3VsZCBiZSBpbiB0aGUgbGluZSBvZiBzaWdodCBoZXJlIGFzIGEgZnV0dXJlIHdvcmsgaXRlbS4N
Cj4gDQo+IA0KPiANCj4gDQo+ID4NCj4gPiA+IFREWCBWTSB0eXBlIGNhbiBwb3NzaWJseSBzZXJ2
ZSBhcyBhIHNwZWNpYWxpemVkIHR5cGUgb2YgcHJvdGVjdGVkIFZNDQo+ID4gPiB3aXRoIGFkZGl0
aW9uYWwgYXJjaCBzcGVjaWZpYyBjYXBhYmlsaXRpZXMgZW5hYmxlZC4NCj4gPiA+DQo+ID4gPiBb
MV0gLSBodHRwczovL2dpdGh1Yi5jb20vc2Vhbi1qYy9saW51eC9jb21taXRzL3g4Ni9rdm1fZ21l
bV9zb2xvDQo+ID4NCg0K
