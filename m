Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D776E031B
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDMAU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDMAUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:20:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E961B3;
        Wed, 12 Apr 2023 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681345252; x=1712881252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yY+e2wP8kZlBFZTktM2lDjfl1HC0Ch1RpGB7cTw4/BA=;
  b=mtVx8B/7vc05SmZ/VN4RXh1hwpSdG+XwWMrYIX8yCXY+/RO4YT9/w8+H
   Pw6BtuNS5Wvs0u5fAide5arM6ZOpXs9BgppdNaMBXfUKmrfUp6thQA4cO
   bqAkL/TZIG6eHf7H+LmpwGGUvw6fL8cs5jBTiyepRPVgs66kjm8cT1Zje
   OCVbWo9YBn9PPbyWlWGjoqTNdIVARKZkaTJlfSo99szujP6m/ZWmEpYNo
   qkNV8A9Ces3scSqdSOMdFQicbLTKAIxQYLiKuU36ocRpDZOhgkBJTSHo5
   1Zruin+dL8s/CoAO3fEnNz8AXr8RJfFQr+PWGxy/KqpUpNxRvOTRQx9fE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="324412160"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="324412160"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 17:20:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="689097351"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="689097351"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 12 Apr 2023 17:20:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:20:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:20:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 17:20:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 17:20:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiNRXKVD70O82l1kdI1C4je5rELjOGeDi8nNsK10zpetDI0izzcaW/yC4uEB+bkXXkpQcGv3Y9W93C6DKBhxlDf9oZ6bsXSSySHTPd2VX9R4cYzW+mJ/avHDGFrFQOVnNyPfL+5a8LS7OwgPCOjUlH8e1IpaFsR+YCsR9fPR4hTX11fW+pRstxTsJg7/5yeHv/gh1IXs2s26SVGkde9bgLSh9VnJs33co0J2DUV3w7+wsTYK1hbUkEYIqRYtlWVws+7Cbmvy3WKichI3Oz6ovqoioj5LF76VTHEHpdLAyf1DtVnjSo8NnxJnBHWF9IHyCoWZRke7YLFXsP7Dmn48YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY+e2wP8kZlBFZTktM2lDjfl1HC0Ch1RpGB7cTw4/BA=;
 b=SCQypAjG747YMYnH0kUyIk6UXjUO3/ZK53qE1Q118myOwp879eIYdAWS3ef/+crGq2V+dMWXGK35QPiV3c86LfQYMuRGmqSF/dhZJgihY9QQvexc5ZnF03AH3YnbijvBfy2/S/3cq5YJktsXIKcdsFw5xbNeeTUzcSQloQRn6xcyJw/lC/iu407FAbVP37B2YKsloTBzB7tfw+jpWq1doQ8i6RIbZ2+zfUtDwitrxuKccWS2NHWpbV2I7uZjXvxLU3Ev3eRVMqeIkgjE8AXoxCj7bFti1a+Frm4dJ6/mnBGr1f2QYxZx1UtDvetr8lKnmmHsFm5go4OnOGXZiHen+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7184.namprd11.prod.outlook.com (2603:10b6:8:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Thu, 13 Apr
 2023 00:20:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Thu, 13 Apr 2023
 00:20:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cd6WAgAETnwCAAIN/gIAJkScAgAA2l4CAAJZTgA==
Date:   Thu, 13 Apr 2023 00:20:39 +0000
Message-ID: <ae28ce9b0c78a926c38a8c8b9694aa34b140b467.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
         <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
         <ZC4qF90l77m3X1Ir@google.com>
         <20230406130119.000011fe.zhi.wang.linux@gmail.com>
         <e1e7a37a29c2c7ad22cd14181f24b06088eca451.camel@intel.com>
         <ZDbMuZKhAUbrkrc7@google.com>
In-Reply-To: <ZDbMuZKhAUbrkrc7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7184:EE_
x-ms-office365-filtering-correlation-id: e91ea06c-bbba-4103-3f23-08db3bb4e96c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: srDisIpejs83KGz0KfTOH6+QwJ4fe19+LCEeCN897EmF4Zx/CWubA8g3Neubn44G4MBfzF+ODBQMKFm6YbOo04rACsGi/FbYkmTLKD+OR2gkQMIhzvIzZeGTVSl7FmFWO9KA9hqNY4Q+Le2Fr1R6cy8hYh5fV769iy2dHz03QeRZrxRe3ozgDlh6RtV97ZgSlctFM6kS0VdPsiDaOdUYZqn/T5jnfrtnvl6JBtiy8qZUBLNycr17o5u++PYAmbDVqchS2o5/wGQ3nAWfOmJ1JPVsUo/kJrrJ5RAS2TkULBcDcELJS7hu4ZO3NjMsbB6k2ILHB80JBsjvab+FOR8ZCghR4a8yFAHgJcBTrXkFUzDWAlYsLE3AZjzmmshjh9Fv2pxGjoNWk0G9h0eHLJy4nOuyIyw2qSns3flc0i8w6pm4e5UFSqJhPbvgnhQe2ko7rJbloioc/PbW6YXwz+Pa1shsh/GLtDcyqPFrOYFT1ivb6x5uAb2Vq+1orjDso6P16l0twRLQeWm9IYXM3rC5vbZ4c5T93I+RzDVD9mxHyRSdR+whA0Pww5fH/GLOcZ/aSbff8TtUM0bcpPEwvOwJujSAH2HDlO8d1RWM5Vv/dr66jPKfLUnJQCPSnuCl10Yn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(38070700005)(36756003)(2906002)(5660300002)(8936002)(8676002)(86362001)(6512007)(6486002)(6506007)(71200400001)(26005)(83380400001)(38100700002)(54906003)(478600001)(122000001)(2616005)(186003)(66946007)(76116006)(91956017)(41300700001)(82960400001)(4326008)(66476007)(66446008)(6916009)(66556008)(64756008)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDZoU0ErVUdBZW91R2RpRHhvTnUxVHpPZnBrSGlFdTRmYWdiSUY4Y3ErSHN3?=
 =?utf-8?B?VTErWWJtaFlwSDlKd2xJajArVklyZ0xmd1RkazdzYWduMUwzaEJJVkJ0MGIr?=
 =?utf-8?B?WmlieGNqdVhWZUtHOXN3Nlg1Y3RQd1I5dkpNYThvYkdqWWRTeVdLUUtYb29O?=
 =?utf-8?B?T3hoZFVzRHpZNlYwSml0SUYzcE95VDlJdGtjbHZUVXFieGNDQzJzYi8rTUNT?=
 =?utf-8?B?RU1ndmhzaElvWGxLSnZibWREWkVQekYxdUdWRzNIOXA1U3ZxQTllS0pWUzhY?=
 =?utf-8?B?UjNsdWoybzg4cy9WRDAxRkZYVEVaU3pGckIydlVtckFhd3N2c3ZMaG1SN1pk?=
 =?utf-8?B?MiswYVBLNU5SeW1yRmlacXk1djF5MkNHeTdJVDJLVzk5SEtLTG50U28vUDJB?=
 =?utf-8?B?dlA5bXJYOTdPUVN5L2RmSmpQZzBEVzl2Tkl3M1o5NWw1RWlpR3k2M2cxV2tO?=
 =?utf-8?B?c0FoYUo5Z2daMTVMejR0VnpjSUpWYnk0OHVzWTkyWWN6RVM5YTc3ZndSa3c0?=
 =?utf-8?B?cVpCRGhqekVFVnRtUFI1N0NYaUpmM3lIOW1RcDJBNXNFdFJvN3U2ZXZuTlhq?=
 =?utf-8?B?TEtvSGVoSmd0ZGdaZFBsNVB0dk11Nzg0ZGVDTWZRdDlMblRyRW1XeG5EUTdX?=
 =?utf-8?B?VlBYMlRDQnpvbDBibDlWSFdhc0pGbUVMUlN3N2RoSnpCYUhKd3hzM3JSUEZN?=
 =?utf-8?B?SUlQNFNhc2h1ZXpmcWVxTkZFY2IrdE51UVBCMmNvcnpib2hsSWlpK1RuMWhs?=
 =?utf-8?B?alhVWjBqc3R4N2pMbWRhRlNmR0FodW5JcVlUYjNoWG5jeThnRkg4SUlPSW9h?=
 =?utf-8?B?QkhUUlJNQnF2Q2dtSGRKeTAxK0s3RitBb3hYMDFnSUhvWGRCZUhHMit1MDFV?=
 =?utf-8?B?OGxUUnJMWk9kaW1UNVc5dFlaRVI1eFhOd1ZUT0V3elB6cUtrR0JpMFdXK1BV?=
 =?utf-8?B?MmtHanorWWpGbnhibGg2OHA0MGRtRlNiMGdZdnhvMjRhcEhONVRkRWFmYW5P?=
 =?utf-8?B?UFRUS3lrK2tudFhUTUFaOXJKQ014ZHp0b3paeHdBTWZXTkFpa2MybzVrUG1m?=
 =?utf-8?B?TDREa0EvOFljSWFaZ0RrMU81bUNjSWRnMDJMVUdwbUZNMGY4UWNkeEpPSXYx?=
 =?utf-8?B?cWlNV1M5TGpxU2JFaDNBaWtXRm1FVFF4NWRCQXh0SFo4V0JVeXJUcEIzMy96?=
 =?utf-8?B?SW1PaFFiVFJ3SFJ3alM5ZWNmeW9tU3V5a0tjbktLeWM1OEN6WnFUM3IzbFRv?=
 =?utf-8?B?dWZRTmM3SlhkTXV5QmVVZDZQN0hwSmhaUyt3dkVEeFliQ01HaWlzWmNvc2ww?=
 =?utf-8?B?aG1WMTYwZUhtTW5FNENscHkwU2IrWUNxbnFiT2MxTEJkMUM0aTY1YkNWbFF0?=
 =?utf-8?B?TUNraU9PQ3h4V2Q4OGlPbmk2MWxVL0NuUmZtaVNyT0dXRmxKcjMvaHM3bExv?=
 =?utf-8?B?MmZaOVk1UGE3SkEyUHNWSS93em1pZnJvSExPYklxMVU4YXNLYVk4Z1p4Vy9H?=
 =?utf-8?B?aWt3TDFaY3ZTRjNVR2s2MHRGSDlZWUk3WFljbGY2c1VYa0EvWEt6bWhWY2Vu?=
 =?utf-8?B?eUVYcjZKNnlHdFNYelV1bWwrdFBITlJEL1JReU5ob3lObzBmTnM2bmpEeXpj?=
 =?utf-8?B?Qlp6MHZhQndOYlc3cjd0V3hDRm83SnJ2SmVqeCtBdjVXZ0ZFRnpCWXdwT29u?=
 =?utf-8?B?TjZzbHgvTGoreWpFMlNBY1VKTkE3dDVnZkIvQkc5RUhFYUUxM2JnMmU2WHQ3?=
 =?utf-8?B?cjhOL25zbWpJYjlSNnAySlRsKzN1MHVPME44WktqMWhlbEdLUjd3cG9uSEp6?=
 =?utf-8?B?dzFRQ2QxbjBJVzRxTURoY005Q3U4a0s3WWpJdUFCcmxLNUhSd2k1TkVWN1V6?=
 =?utf-8?B?TmkxSVVsOGkxcXhTTDBlOU81dHN4Rzc5UEhZOE9rWjN2S2tNeko0cjlTZGVR?=
 =?utf-8?B?Z0R3dE53bGVmSXdZaVBNcXBRQzRTYWpjYitSdWlJdXBTV080Z1VxN1AzU1ZS?=
 =?utf-8?B?WWNLK0hrYWdHQ2JINGFxVXVHTkgrRzUxMDhxamYyWFRGM3VBTTF1clRsVmZX?=
 =?utf-8?B?WjhmbHV3OTZyYTFYdGNpaVo1UTN6QmNOU2d6cElvUkdqV3lJeDQ1cUs5NE44?=
 =?utf-8?B?Q3I3dEZQaUNVanRzMGR2NXh2c1Zjbk9UTkRTdzh2b0wxK0kwcm1DMGlSUnhR?=
 =?utf-8?B?OVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52D6A358A9483E4F825F11401068458A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91ea06c-bbba-4103-3f23-08db3bb4e96c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 00:20:39.8902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lNWzUjOS7u4F9OF5NXFbS1igvvxq0cnbQyCtDd/baFhgDRUaf5BsV/Mz71tEO++hw5NUcL/rGRvMroYmLGLjLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7184
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

T24gV2VkLCAyMDIzLTA0LTEyIGF0IDA4OjIyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIEFwciAxMiwgMjAyMywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyMy0wNC0wNiBhdCAxMzowMSArMDMwMCwgWmhpIFdhbmcgd3JvdGU6DQo+ID4gPiBPbiBX
ZWQsIDUgQXByIDIwMjMgMTk6MTA6NDAgLTA3MDANCj4gPiA+IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gPiA+ID4gVEw7RFI6IHRyeWluZyB0byBlbmZv
cmNlICJzYW5lIiBDUFVJRC9mZWF0dXJlIGNvbmZpZ3VyYXRpb24gaXMgYSBnaWdhbnRpYyBjYW4g
b2Ygd29ybXMuDQo+ID4gPiANCj4gPiA+IEludGVyZXN0aW5nIHBvaW50LiBJIHdhcyBkaWdnaW5n
IHRoZSBDUFVJRCB2aXJ0dWFsaXphdGlvbiBPRiBURFgvU05QLg0KPiA+ID4gSXQgd291bGQgYmUg
bmljZSB0byBoYXZlIGEgY29uY2x1c2lvbiBvZiB3aGF0IGlzICJzYW5lIiBhbmQgd2hhdCBpcyB0
aGUNCj4gPiA+IHByb3BlciByb2xlIGZvciBLVk0sIGFzIGZpcm13YXJlL1REWCBtb2R1bGUgaXMg
Z29pbmcgdG8gdmFsaWRhdGUgdGhlICJzYW5lIg0KPiA+ID4gQ1BVSUQuDQo+ID4gPiANCj4gPiA+
IFREWC9TTlAgcmVxdWlyZXMgdGhlIENQVUlEIHRvIGJlIHByZS1jb25maWd1cmVkIGFuZCB2YWxp
ZGF0ZWQgYmVmb3JlIGNyZWF0aW5nDQo+ID4gPiBhIENDIGd1ZXN0LiAoSXQgaXMgZG9uZSB2aWEg
VERILk1ORy5JTklUIGluIFREWCBhbmQgaW5zZXJ0aW5nIGEgQ1BVSUQgcGFnZSBpbg0KPiA+ID4g
U05QX0xBVU5DSF9VUERBVEUgaW4gU05QKS4NCj4gPiA+IA0KPiA+ID4gSUlVQyBhY2NvcmRpbmcg
dG8gd2hhdCB5b3UgbWVudGlvbmVkLCBLVk0gc2hvdWxkIGJlIHRyZWF0ZWQgbGlrZSAiQ1BVSUQg
Ym94Ig0KPiA+ID4gZm9yIFFFTVUgYW5kIHRoZSBjaGVja3MgaW4gS1ZNIGlzIG9ubHkgdG8gZW5z
dXJlIHRoZSByZXF1aXJlbWVudHMgb2YgYSBjaG9zZW4NCj4gPiA+IG9uZSBpcyBsaXRlcmFsbHkg
cG9zc2libGUgYW5kIGNvcnJlY3QuIEtWTSBzaG91bGQgbm90IGNhcmUgaWYgdGhlDQo+ID4gPiBj
b21iaW5hdGlvbiwgdGhlIHVzYWdlIG9mIHRoZSBjaG9zZW4gb25lcyBpcyBpbnNhbmUgb3Igbm90
LCB3aGljaCBnaXZlcw0KPiA+ID4gUUVNVSBmbGV4aWJpbGl0eS4NCj4gPiA+IA0KPiA+ID4gQXMg
dGhlIHZhbGlkIENQVUlEcyBoYXZlIGJlZW4gZGVjaWRlZCB3aGVuIGNyZWF0aW5nIGEgQ0MgZ3Vl
c3QsIHdoYXQgc2hvdWxkIGJlDQo+ID4gPiB0aGUgcHJvcGVyIGJlaGF2aW9yIChiYXNpY2FsbHkg
YW55IG5ldyBjaGVja3M/KSBvZiBLVk0gZm9yIHRoZSBsYXRlcg0KPiA+ID4gU0VUX0NQVUlEMj8g
TXkgZ3V0IGZlZWxpbmcgaXMgS1ZNIHNob3VsZCBrbm93IHRoZSAiQ1BVSUQgYm94IiBpcyByZWR1
Y2VkDQo+ID4gPiBhdCBsZWFzdCwgYmVjYXVzZSBzb21lIEtWTSBjb2RlIHBhdGhzIHJlbHkgb24g
Z3Vlc3QgQ1BVSUQgY29uZmlndXJhdGlvbi4NCj4gPiANCj4gPiBGb3IgVERYIGd1ZXN0IG15IHBy
ZWZlcmVuY2UgaXMgS1ZNIHRvIHNhdmUgYWxsIENQVUlEIGVudHJpZXMgaW4gVERILk1ORy5JTklU
IGFuZA0KPiA+IG1hbnVhbGx5IG1ha2UgdmNwdSdzIENQVUlEIHBvaW50IHRvIHRoZSBzYXZlZCBD
UFVJRHMuICBBbmQgdGhlbiBLVk0ganVzdCBpZ25vcmUNCj4gPiB0aGUgU0VUX0NQVUlEMiBmb3Ig
VERYIGd1ZXN0Lg0KPiANCj4gSXQncyBiZWVuIGEgbG9uZyB3aGlsZSBzaW5jZSBJIGxvb2tlZCBh
dCBURFgncyBDUFVJRCBtYW5hZ2VtZW50LCBidXQgSUlSQyBpZ25vcmluZw0KPiBTRVRfQ1BVSUQy
IGlzIG5vdCBhbiBvcHRpb24gYmVjdWFzZSB0aGUgVERILk1ORy5JTklUIG9ubHkgYWxsb3dzIGxl
YWZzIHRoYXQgYXJlDQo+IGtub3duIHRvIHRoZSBURFggTW9kdWxlLCBlLmcuIEtWTSdzIHBhcmF2
aXJ0IENQVUlEIGxlYWZzIGNhbid0IGJlIGNvbW11bmljYXRlZCB2aWENCj4gVERILk1ORy5JTklU
LiDCoA0KPiANCg0KT2ggeWVzLiAgSSBmb3Jnb3QgdGhpcy4NCg0KPiBLVk0ncyB1QVBJIGZvciBp
bml0aWF0aW5nIFRESC5NTkcuSU5JVCBjb3VsZCBvYnZpb3VzbHkgZmlsdGVyIG91dA0KPiB1bnN1
cHBvcnRlZCBsZWFmcywgYnV0IGRvaW5nIHNvIHdvdWxkIGxlYWQgdG8gcG90ZW50aWFsIEFCSSBi
cmVha3MsIGUuZy4gaWYgYSBsZWFmDQo+IHRoYXQgS1ZNIGZpbHRlcnMgb3V0IGJlY29tZXMga25v
d24gdG8gdGhlIFREWCBNb2R1bGUsIHRoZW4gdXBncmFkaW5nIHRoZSBURFggTW9kdWxlDQo+IGNv
dWxkIHJlc3VsdCBpbiBwcmV2aW91c2x5IGFsbG93ZWQgaW5wdXQgYmVjb21pbmcgaW52YWxpZC4N
Cg0KSG93IGFib3V0IG9ubHkgZmlsdGVyaW5nIG91dCBQViByZWxhdGVkIENQVUlEcyB3aGVuIGFw
cGx5aW5nIENQVUlEcyB0bw0KVERILk1ORy5JTklUPyAgSSB0aGluayB3ZSBjYW4gYXNzdW1lIHRo
ZXkgYXJlIG5vdCBnb25uYSBiZSBrbm93biB0byBURFggbW9kdWxlDQphbnl3YXkuDQoNCj4gDQo+
IEV2ZW4gaWYgdGhhdCB3ZXJlbid0IHRoZSBjYXNlLCBpZ25vcmluZyBLVk1fU0VUX0NQVUlEezJ9
IHdvdWxkIGJlIGEgYmFkIG9wdGlvbg0KPiBiZWN1YXNlIGl0IGRvZXNuJ3QgYWxsb3cgS1ZNIHRv
IG9wZW4gYmVoYXZpb3IgaW4gdGhlIGZ1dHVyZSwgaS5lLiBpZ25vcmluZyB0aGUNCj4gbGVhZiB3
b3VsZCBlZmZlY3RpdmVseSBtYWtlIF9ldmVyeXRoaW5nXyB2YWxpZCBpbnB1dC4gIElmIEtWTSB3
ZXJlIHRvIHJlbHkgc29sZWx5DQo+IG9uIFRESC5NTkcuSU5JVCwgdGhlbiBLVk0gd291bGQgd2Fu
dCB0byBjb21wbGV0ZWx5IGRpc2FsbG93IEtWTV9TRVRfQ1BVSUR7Mn0uDQoNClJpZ2h0LiAgRGlz
YWxsb3dpbmcgU0VUX0NQVUlEezJ9IHByb2JhYmx5IGlzIGJldHRlciwgYXMgaXQgZ2l2ZXMgdXNl
cnNwYWNlIGENCm1vcmUgY29uY3JldGUgcmVzdWx0LiAgDQoNCj4gDQo+IEJhY2sgdG8gWmhpJ3Mg
cXVlc3Rpb24sIHRoZSBiZXN0IHRoaW5nIHRvIGRvIGZvciBURFggYW5kIFNOUCBpcyBsaWtlbHkg
dG8gcmVxdWlyZQ0KPiB0aGF0IG92ZXJsYXAgYmV0d2VlbiBLVk1fU0VUX0NQVUlEezJ9IGFuZCB0
aGUgInRydXN0ZWQiIENQVUlEIGJlIGNvbnNpc3RlbnQuICBUaGUNCj4ga2V5IGRpZmZlcmVuY2Ug
aXMgdGhhdCBLVk0gd291bGQgYmUgZW5mb3JjaW5nIGNvbnNpc3RlbmN5LCBub3Qgc2FuaXR5LiAg
SS5lLiBLVk0NCj4gaXNuJ3QgbWFraW5nIGFyYml0cmFyeSBkZWNpc2lvbnMgb24gd2hhdCBpcy9p
c24ndCBzYW5lLCBLVk0gaXMgc2ltcGx5IHJlcXVpcmluZw0KPiB0aGF0IHVzZXJzcGFjZSBwcm92
aWRlIGEgQ1BVSUQgbW9kZWwgdGhhdCdzIGNvbnNpc3RlbnQgd2l0aCB3aGF0IHVzZXJzcGFjZSBw
cm92aWRlZA0KPiBlYXJsaWVyLg0KDQpTbyBJSVVDLCB5b3UgcHJlZmVyIHRvIHZlcmlmeWluZyB0
aGUgQ1BVSURzIGluIFNFVF9DUFVJRHsyfSBhcmUgYSBzdXBlciBzZXQgb2YNCnRoZSBDUFVJRHMg
cHJvdmlkZWQgaW4gVERILk1ORy5JTklUPyAgQW5kIEtWTSBtYW51YWxseSB2ZXJpZmllcyBhbGwg
Q1BVSURzIGZvcg0KYWxsIHZjcHVzIGFyZSBjb25zaXN0ZW50ICh0aGUgc2FtZSkgaW4gU0VUX0NQ
VUlEezJ9Pw0KDQpMb29rcyB0aGlzIGlzIG92ZXItY29tcGxpY2F0ZWQsIF9pZl8gdGhlICJvbmx5
IGZpbHRlcmluZyBvdXQgUFYgcmVsYXRlZCBDUFVJRHMNCndoZW4gYXBwbHlpbmcgQ1BVSURzIHRv
IFRESC5NTkcuSU5JVCIgYXBwcm9hY2ggd29ya3MuIA0KDQo=
