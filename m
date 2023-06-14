Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3513872F2EC
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 05:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbjFNDG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 23:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjFNDG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 23:06:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5312CA;
        Tue, 13 Jun 2023 20:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686711985; x=1718247985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=reLrfwwW5/tQ9J8ZXEwFU/Bxw5QV3ISZpvk7Y/nTbM4=;
  b=ZahKsrmDWjgTA6hG+4MqdtbpXhl5QB0o1aeMzGaERc5x0DS2ujSkme0g
   G27gy4l/GSksjsaINatMBZwM+Ve9s4y6rS2DVN5eS5lbQ9cZtu5LFl/Br
   cAtmjLJjV4iopIyLqlkkm2gH4X9baoXSlwI/9I20qjN9CkvygQxqdopXt
   HhpOOYiVtifOzpYab0PzM9lWoIohDu5pzTPjcPNXO6ySY0bhnIpqPg4N8
   1I1IYDrn+yMCumMwOwKtjY8DBsWPcfIlTjy7dQVdDJiFihY8xxhGqYZi2
   NFWRtTLcahd3ilnT4k3ZIRfIr8Nms1AVTtmcuBUpWuzFBqvTWyPtQbLiZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357385678"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="357385678"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 20:06:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="706044881"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="706044881"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2023 20:06:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 20:06:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 20:06:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 20:06:23 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 20:06:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lO4am8F7SLAnH956cFDR2ZYVedOoqU9CsgEzKzFX0Ns3H4htoAhETRr+sv/rdFOqanUJhNHP7+wJkwPSY7ODoEJkcj5I/VaGD4LOmm+JQZsvFx4pX6M5w0/6U2CppqkW279cFOWNqPHNTVMw2YdK88n8OMGtNt2YnuRQ3FP1yph8Ow0Gi6UbshbdmjFm8Xg0jGGf/bqcETMaF1XNw26Di4Cj8esMK2IgBso48/wV3agTXaxZV5p20zM12hjmJ1wxKmjWgk3pOvyEYumz7qUjI8Sqw49kGPmDW4Rz5ybWqwSXL3DmHXKY9D5uU/h9j5SERLZ7lpqYs5BS5kq5aL2biQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reLrfwwW5/tQ9J8ZXEwFU/Bxw5QV3ISZpvk7Y/nTbM4=;
 b=ZzooXs20P/VSGsaPke1N4Ul7r9SSZYr/H9cLVUOY6UbqyF3iONeW3kWCp9a9T1be0n4MXoj03KN2p2WpeNobflLbfqZ/gSmKaPEMLzZ0n9rRdQeMTKDVCYCrstpcFjguQMUCWfzFrehd0vwBpvgs8KODvtvpYUt3eSQn5qQc/YMF2Xe9l2g2UlyN/eMeLuJJYSRKMWcokRK4olRmz4/UUQHNZx1CuH9QlpMbcTBDQrlIn2dxoHmTVnBFVJclLh4uB+nQUMLrmPIQb8wNQRihCdZaELtKVH5HjityZqJ2x4pXfj3jhwRHxdZFMCxhwsEjjrIMOIvQuQpB8FvuVzxkPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17)
 by PH7PR11MB8009.namprd11.prod.outlook.com (2603:10b6:510:248::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 14 Jun
 2023 03:06:15 +0000
Received: from BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::24f7:be2d:5d10:11b7]) by BL1PR11MB5368.namprd11.prod.outlook.com
 ([fe80::24f7:be2d:5d10:11b7%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 03:06:15 +0000
From:   "Ma, Yongwei" <yongwei.ma@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>,
        "Ma, Yongwei" <yongwei.ma@intel.com>
Subject: RE: [PATCH v3 00/28] drm/i915/gvt: KVM: KVMGT fixes and page-track
 cleanups
Thread-Topic: [PATCH v3 00/28] drm/i915/gvt: KVM: KVMGT fixes and page-track
 cleanups
Thread-Index: AQHZhTL7wUoU2pq1pUWrl1NNW5lCWq+JzrhA
Date:   Wed, 14 Jun 2023 03:06:15 +0000
Message-ID: <BL1PR11MB53686A129ABEC1725EFD5FAE895AA@BL1PR11MB5368.namprd11.prod.outlook.com>
References: <20230513003600.818142-1-seanjc@google.com>
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5368:EE_|PH7PR11MB8009:EE_
x-ms-office365-filtering-correlation-id: 7f68a89b-f172-4aab-4d45-08db6c8450e2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6iH4v1rSW/ht0CeuXkBX7Lze9aJSt+pkla9wGROYYHvdg3BlMxVsNkVjlWiii66goDaMBqlwKEneF62rPsOlnCAJhGeOni6v8DKPBBDgiIw5XXhhZ1dPhXziheydN1WakNUk8LaH1aCKYXD+Hp4GGIx7PNoi1R81CX9/UcuRa8fHc/ThvmakLvY80CxbpfzJBqwy4Xikel81KBu8ONFm7OyUTVGvKxItQjOZ9mX3GGJQ+jagUVaHPmQNUlyk65jqyolCgm+UHFAxUKXsxsAXab9QOkSx4IB2TZoXhv/oRwoAPgxGIYO08qaNQ7rew2883Og/nNPHfUzXvREn6plykkoNgRHWzA4UAllgl0/ZpPWQM84dkUbBPsAFd7hZgc3IBWbla2JVj1LeD8erKXD1EmETEeH7tlkHkn7rEh5v2wsV9drpBu6V5xs5Au0xHRKd81H6ikdUKYnt99LaFJFGqKzQdztxApGz9b9HrwT3215T1EuUpmiRV/vrNSsX4QDa9znTM5eEiMQCxqdbFms3us7i3/IBQixQVyBEO3tgvVPjmCwqwMwqwL7BSuZa9eGqAVSNxrTufYTeFie8tdBa28cVBlFe9ZleCwxCR86dt2Aw3cW5jYZe6otT7+uoQeOXzwt3GnOGuf6fAI/ip9DCyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5368.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199021)(478600001)(52536014)(54906003)(38070700005)(110136005)(8676002)(71200400001)(5660300002)(8936002)(316002)(6636002)(66476007)(4326008)(66556008)(66446008)(122000001)(76116006)(66946007)(64756008)(41300700001)(38100700002)(2906002)(55016003)(33656002)(82960400001)(6506007)(9686003)(83380400001)(86362001)(26005)(186003)(966005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V09uZXVuVFR4aVFkbmIzVzkyNTFjNVl3RllpZTFTaDBkYS9seHBETHBrUFFi?=
 =?utf-8?B?eFJDdXlZTCsvdFc4UThYY2xQMEtVWDlkdU9FWE0yaGllMTdxamJ5WGRkczh5?=
 =?utf-8?B?V2grZ3phTldYeDdKdWdIajJNUTZiNWR0Zjk5eGRMcWlKdmZHeW1zdTZUSjNz?=
 =?utf-8?B?bWlnYi9VQ1BBd2ZJcnhjUU5xc0JvS1R2aXZQcmNIMkFzREN4VWVNSjZrU2p1?=
 =?utf-8?B?cEduU2pCemtRWWdDWXVxQTZoUmJ6djFiL1h6V1Q4T0pQRVRnRlMxVGJxVlpo?=
 =?utf-8?B?K3ZXaWtsdTdSQW9nU0Nvbkd0K0xUSEFVZ292SHFUeVIxVHFvZWVVRWdvcmJK?=
 =?utf-8?B?VE1yQkw2SUlqQW1hZVhzTmNTYkxzUFlZK3dyS2ZwVitjTkRmN1Y5NkJmWUw1?=
 =?utf-8?B?KzNSWU85Ly9lRE5YdmVJQzJzWVNXOE15dWM2SEQwKzk5VmdQRnJCOE5ibDd2?=
 =?utf-8?B?NzU2Z1lQaTdtZ01DTVNHYkgvMlg0b1ZwR0JWR1J0SDhRM3YzVWQvdnRyemRO?=
 =?utf-8?B?Rldib0xSYzRnbElRVGU0UWhncXFGV2lYdXVLeHlzMTQ4b1M2cXQyYUhHK3lU?=
 =?utf-8?B?VzBHMThEY0prZHFqRS9rSlFlV1lPSENlek04TG9UZ1FkaUZLbEpCR2poTHly?=
 =?utf-8?B?Q253T20yaG82ZjNzNTlpNlJQRU1OSnlSbDliUTRwQ0tPYmFoaGRBeXIxL2VY?=
 =?utf-8?B?ZlZ6UXRzU1E5TEFTOWVGd3o0WnVhTVR1bUE2eGNZQ2ZaRVpRekZCY0pVYkpp?=
 =?utf-8?B?c3E0Z0o4OEdabzBBVWdhSjBFMmUxRU1vN1JhdmZTejdlQ3RYL2kwV1cwNXpG?=
 =?utf-8?B?ZEIyYmVZVmN0YkIxMTFCRjNCMTZ2YWlENWcwck5YcmgzUy9aTVBBUG4wYU9B?=
 =?utf-8?B?SG9sV0U0dnZxSFl6eW9oNzl6TzJBL0p4NUI1dHdNT3ZtS2hUOWpZNWdSZEFy?=
 =?utf-8?B?TGRvVlhldGNBMnIydzdQWXNlUmUyQmVHMGYyRXl2SkFUTUc4NUZRZ1BaRkUx?=
 =?utf-8?B?Qk1KL0txWERuTUJ1K08xejQreDFJS2JNWG5BdnhOL3JaT1p0aGVzY3ZsamJu?=
 =?utf-8?B?SEFzaW9sU3BJNEFnUm5UMEhMdUVQcHZucXYrNG9qV0hDU0l6V2RYZzBTQlJS?=
 =?utf-8?B?bm1aWGV3aDJ5bEVSYnN3aDIxbGJPQkdBWGRYK3RWVUNaRjNaZ3VWaS80UmFG?=
 =?utf-8?B?RnNya2U2dXN3cjNMRHpXVG54RVZmRDdwcWd0Q1VjM1poN3dCT2UwQnhvc1lL?=
 =?utf-8?B?M0tpaEwxa1E0RVZISWxnWGdtRFNHZ1UrRGtJTDlpbnZGU3BCd1lKNXRaMmpW?=
 =?utf-8?B?RTExa1BLR21FTG5GMTBMbDE0cmVWc04vL2dWMG5yRnBjenJKR2Y2NnFySWFr?=
 =?utf-8?B?YkJRTGVtOU1RNzFMalBCcFVheWFmVmVXbGx3b3U3cGFzQWdVK2plM2xHdCsr?=
 =?utf-8?B?QndxTnFaMDhWdTgvaUNMY1o4WW5TTUY5YkVmVEl5NUFlN0FWTFpTSVhsSHB0?=
 =?utf-8?B?QWhBT2Z4elllTDB6VURSSVgyeDJLeG15QlFpU0FPVFl5TTVwcmx5NlVPckZs?=
 =?utf-8?B?ancyckxDOVZtbk9lNlpUSk01bXFFVG1OcVA5MUdsb3BTbFRIVWhWaDlDYjM1?=
 =?utf-8?B?bW5UK0tURjNiZFdsdnJ5Y3hhcGY4a0FxUnMrVVdralBwUm9scG9OOWVGL1V3?=
 =?utf-8?B?ZGZhR1F2K1JOSEttNWFyTXI4OUVNQWU1YnBkOURDbU8vekh5Y3hHdXV3TFB0?=
 =?utf-8?B?d08xcHBqQmZlRmRsdDVYR1lXV0E2Tk9sUnplSFMvVGZ4bWFLQUtnbnZLejRX?=
 =?utf-8?B?ajV1aFprUUJrSTJsS0dHQkUwTjhUcTFxby96clVaaldqbElyRUprMzE1d3ls?=
 =?utf-8?B?WHg5eXB3NFNRWWREcWVOckRpWTN0ZkZ4M0w4bzE0bXp1aGVkdVUzQ1ArWXZa?=
 =?utf-8?B?YXYvamFBc1RmSHI5QmF1UGdYMTE3Q253V21UUWM2eEJOTDR6Zyt1VkxjUXBo?=
 =?utf-8?B?NHU4T1BNNzBDRGUvR1JvYmxUOHdRQ0ErWDBOVEREMWl0ZEdCOU5YNkhBQ1I3?=
 =?utf-8?B?eXpyc0QvZEZJLzc1SG9EM25EcUdUY0tEdVZPQ0dCVzIvcGRvc0dqVXBSSWZz?=
 =?utf-8?Q?aCaE943SbUclOZWA5tLyIs+sP?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5368.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f68a89b-f172-4aab-4d45-08db6c8450e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 03:06:15.0928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Gr1BoJWcL09/lpYkSEh3p1NLhlNrPXNVXPan00q5sUxvsiFLVzPteh7jCoN8EeoQw4x59D61Bxc+BjgqBZytg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8009
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGaXggYSB2YXJpZXR5IG9mIGZvdW5kLWJ5LWluc3BlY3Rpb24gYnVncyBpbiBLVk1HVCwgYW5k
IG92ZXJoYXVsIEtWTSdzDQo+IHBhZ2UtdHJhY2sgQVBJcyB0byBwcm92aWRlIGEgbGVhbmVyIGFu
ZCBjbGVhbmVyIGludGVyZmFjZS4gIFRoZSBtb3RpdmF0aW9uIGZvcg0KPiB0aGlzIHNlcmllcyBp
cyB0byAoc2lnbmlmaWNhbnRseSkgcmVkdWNlIHRoZSBudW1iZXIgb2YgS1ZNIEFQSXMgdGhhdCBL
Vk1HVA0KPiB1c2VzLCB3aXRoIGEgbG9uZy10ZXJtIGdvYWwgb2YgbWFraW5nIGFsbCBrdm1faG9z
dC5oIGhlYWRlcnMgS1ZNLWludGVybmFsLg0KPiANCj4gQXMgYWx3YXlzIGZvciB0aGlzIHNlcmll
cywgdGhlIEtWTUdUIGNoYW5nZXMgYXJlIGNvbXBpbGUgdGVzdGVkIG9ubHkuDQo+IA0KPiBCYXNl
ZCBvbiAiZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9rdm0uZ2l0IHRhZ3Mv
a3ZtLTYuNC0xIi4NCj4gDQo+IHYzOg0KPiAgLSBDb2xsZWN0IHJldmlld2VkL3Rlc3RlZCB0YWdz
IChJIGFwb2xvZ2l6ZSBpZiBJIG1pc3NlZCBhbnksIEkgbWFudWFsbHkNCj4gICAgZ2F0aGVyZWQg
dGhlbSB0aGlzIHRpbWUgZHVlIHRvIGEgZ29vZiBpbiBteSB3b3JrZmxvdykuIFtZYW5dDQo+ICAt
IERyb3AgY2hlY2sgb24gbWF4IEtWTSBwYWdpbmcgc2l6ZSBmcm9tIEtWTUdULiBbWWFuXQ0KPiAg
LSBEcm9wIHRoZSBleHBsaWNpdCBjaGFuZ2Ugb24gVEhQIHBhZ2VzLCBhbmQgaW5zdGVhZCB2YWxp
ZGF0ZSB0aGF0IHRoZQ0KPiAgICBwZm5zIChub3Qgc3RydWN0IHBhZ2UgcG9pbnRlcnMpIGFyZSBj
b250aWd1b3VzLiBbWWFuXQ0KPiAgLSBGaXggYnVnZ3kgaW50ZWxfZ3Z0X2RtYV9tYXBfZ3Vlc3Rf
cGFnZSgpIHVzYWdlIGJ5IGVsaW1pbmF0aW5nIGEgaGVscGVyDQo+ICAgIGZvciBzaGFkb3dpbmcg
Mk1pQiBHVFQgZW50cmllcy4gW1lhbl0NCj4gIC0gTW92ZSBrdm1fYXJjaF9mbHVzaF9zaGFkb3df
e2FsbCxtZW1zbG90fSgpIHRvIG1tdS5jIGluc3RlYWQgb2YNCj4gZXhwb3NpbmcNCj4gICAga3Zt
X21tdV96YXBfYWxsX2Zhc3QoKSBvdXRzaWRlIG9mIG1tdS5jLiBbWWFuXQ0KPiAgLSBGaXggYW4g
YWxpZ25tZW50IGdvb2YgaW4gaGxpc3RfZm9yX2VhY2hfZW50cnlfc3JjdSgpIHVzYWdlLiBbWWFu
XQ0KPiAgLSBXcmFwIGZ1bGwgZGVmaW5pdGlvbiBvZiBleHRlcm5hbCBwYWdlIHRyYWNrIHN0cnVj
dHVyZXMgd2l0aA0KPiAgICBDT05GSUdfS1ZNX0VYVEVSTkFMX1dSSVRFX1RSQUNLSU5HLiBbWWFu
XQ0KPiANCj4gdjI6DQo+ICAtIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIzMDMxMTAw
MjI1OC44NTIzOTctMS1zZWFuamNAZ29vZ2xlLmNvbQ0KPiAgLSBSZXVzZSB2Z3B1X2xvY2sgdG8g
cHJvdGVjdCBnZm4gaGFzaCBpbnN0ZWFkIG9mIGludHJvZHVjaW5nIGEgbmV3IChhbmQNCj4gICAg
YnVnZ3kpIG11dGV4dC4gW1lhbl0NCj4gIC0gUmVtb3ZlIGEgc3B1cmlvdXMgcmV0dXJuIGZyb20g
a3ZtX3BhZ2VfdHJhY2tfaW5pdCgpLiBbWWFuXQ0KPiAgLSBUYWtlIEBrdm0gZGlyZWN0bHkgaW4g
dGhlIGlubmVyIF9fa3ZtX3BhZ2VfdHJhY2tfd3JpdGUoKS4gW1lhbl0NCj4gIC0gRGVsZXRlIHRo
ZSBnZm4gc2FuaXR5IGNoZWNrIHRoYXQgcmVsaWVzIG9uIGt2bV9pc192aXNpYmxlX2dmbigpIGlu
c3RlYWQNCj4gICAgb2YgcHJvdmlkaW5nIGEgZGVkaWNhdGVkIGludGVyZmFjZS4gW1lhbl0NCj4g
DQo+IHYxOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjIxMjIzMDA1NzM5LjEyOTU5
MjUtMS0NCj4gc2VhbmpjQGdvb2dsZS5jb20NCj4gDQo+IFNlYW4gQ2hyaXN0b3BoZXJzb24gKDI0
KToNCj4gICBkcm0vaTkxNS9ndnQ6IFZlcmlmeSBwZm4gaXMgInZhbGlkIiBiZWZvcmUgZGVyZWZl
cmVuY2luZyAic3RydWN0IHBhZ2UiDQo+ICAgZHJtL2k5MTUvZ3Z0OiBWZXJpZnkgaHVnZXBhZ2Vz
IGFyZSBjb250aWd1b3VzIGluIHBoeXNpY2FsIGFkZHJlc3MNCj4gICAgIHNwYWNlDQo+ICAgZHJt
L2k5MTUvZ3Z0OiBQdXQgdGhlIHBhZ2UgcmVmZXJlbmNlIG9idGFpbmVkIGJ5IEtWTSdzIGdmbl90
b19wZm4oKQ0KPiAgIGRybS9pOTE1L2d2dDogRXhwbGljaXRseSBjaGVjayB0aGF0IHZHUFUgaXMg
YXR0YWNoZWQgYmVmb3JlIHNoYWRvd2luZw0KPiAgIGRybS9pOTE1L2d2dDogRXJyb3Igb3V0IG9u
IGFuIGF0dGVtcHQgdG8gc2hhZG93aW5nIGFuIHVua25vd24gR1RUDQo+ICAgICBlbnRyeSB0eXBl
DQo+ICAgZHJtL2k5MTUvZ3Z0OiBEb24ndCByZWx5IG9uIEtWTSdzIGdmbl90b19wZm4oKSB0byBx
dWVyeSBwb3NzaWJsZSAyTQ0KPiAgICAgR1RUDQo+ICAgZHJtL2k5MTUvZ3Z0OiBVc2UgYW4gInVu
c2lnbmVkIGxvbmciIHRvIGl0ZXJhdGUgb3ZlciBtZW1zbG90IGdmbnMNCj4gICBkcm0vaTkxNS9n
dnQ6IERyb3AgdW51c2VkIGhlbHBlciBpbnRlbF92Z3B1X3Jlc2V0X2d0dCgpDQo+ICAgZHJtL2k5
MTUvZ3Z0OiBQcm90ZWN0IGdmbiBoYXNoIHRhYmxlIHdpdGggdmdwdV9sb2NrDQo+ICAgS1ZNOiB4
ODYvbW11OiBNb3ZlIGt2bV9hcmNoX2ZsdXNoX3NoYWRvd197YWxsLG1lbXNsb3R9KCkgdG8gbW11
LmMNCj4gICBLVk06IHg4Ni9tbXU6IERvbid0IHJlbHkgb24gcGFnZS10cmFjayBtZWNoYW5pc20g
dG8gZmx1c2ggb24gbWVtc2xvdA0KPiAgICAgY2hhbmdlDQo+ICAgS1ZNOiB4ODYvbW11OiBEb24n
dCBib3VuY2UgdGhyb3VnaCBwYWdlLXRyYWNrIG1lY2hhbmlzbSBmb3IgZ3Vlc3QNCj4gUFRFcw0K
PiAgIEtWTTogZHJtL2k5MTUvZ3Z0OiBEcm9wIEB2Y3B1IGZyb20gS1ZNJ3MgLT50cmFja193cml0
ZSgpIGhvb2sNCj4gICBLVk06IHg4NjogUmVqZWN0IG1lbXNsb3QgTU9WRSBvcGVyYXRpb25zIGlm
IEtWTUdUIGlzIGF0dGFjaGVkDQo+ICAgZHJtL2k5MTUvZ3Z0OiBEb24ndCBib3RoZXIgcmVtb3Zp
bmcgd3JpdGUtcHJvdGVjdGlvbiBvbiB0by1iZS1kZWxldGVkDQo+ICAgICBzbG90DQo+ICAgS1ZN
OiB4ODYvbW11OiBNb3ZlIEtWTS1vbmx5IHBhZ2UtdHJhY2sgZGVjbGFyYXRpb25zIHRvIGludGVy
bmFsIGhlYWRlcg0KPiAgIEtWTTogeDg2L21tdTogVXNlIHBhZ2UtdHJhY2sgbm90aWZpZXJzIGlm
ZiB0aGVyZSBhcmUgZXh0ZXJuYWwgdXNlcnMNCj4gICBLVk06IHg4Ni9tbXU6IERyb3AgaW5mcmFz
dHJ1Y3R1cmUgZm9yIG11bHRpcGxlIHBhZ2UtdHJhY2sgbW9kZXMNCj4gICBLVk06IHg4Ni9tbXU6
IFJlbmFtZSBwYWdlLXRyYWNrIEFQSXMgdG8gcmVmbGVjdCB0aGUgbmV3IHJlYWxpdHkNCj4gICBL
Vk06IHg4Ni9tbXU6IEFzc2VydCB0aGF0IGNvcnJlY3QgbG9ja3MgYXJlIGhlbGQgZm9yIHBhZ2UN
Cj4gICAgIHdyaXRlLXRyYWNraW5nDQo+ICAgS1ZNOiB4ODYvbW11OiBCdWcgdGhlIFZNIGlmIHdy
aXRlLXRyYWNraW5nIGlzIHVzZWQgYnV0IG5vdCBlbmFibGVkDQo+ICAgS1ZNOiB4ODYvbW11OiBE
cm9wIEBzbG90IHBhcmFtIGZyb20gZXhwb3J0ZWQvZXh0ZXJuYWwgcGFnZS10cmFjayBBUElzDQo+
ICAgS1ZNOiB4ODYvbW11OiBIYW5kbGUgS1ZNIGJvb2trZWVwaW5nIGluIHBhZ2UtdHJhY2sgQVBJ
cywgbm90IGNhbGxlcnMNCj4gICBkcm0vaTkxNS9ndnQ6IERyb3AgZmluYWwgZGVwZW5kZW5jaWVz
IG9uIEtWTSBpbnRlcm5hbCBkZXRhaWxzDQo+IA0KPiBZYW4gWmhhbyAoNCk6DQo+ICAgZHJtL2k5
MTUvZ3Z0OiByZW1vdmUgaW50ZXJmYWNlIGludGVsX2d2dF9pc192YWxpZF9nZm4NCj4gICBLVk06
IHg4NjogQWRkIGEgbmV3IHBhZ2UtdHJhY2sgaG9vayB0byBoYW5kbGUgbWVtc2xvdCBkZWxldGlv
bg0KPiAgIGRybS9pOTE1L2d2dDogc3dpdGNoIGZyb20gLT50cmFja19mbHVzaF9zbG90KCkgdG8N
Cj4gICAgIC0+dHJhY2tfcmVtb3ZlX3JlZ2lvbigpDQo+ICAgS1ZNOiB4ODY6IFJlbW92ZSB0aGUg
dW51c2VkIHBhZ2UtdHJhY2sgaG9vayB0cmFja19mbHVzaF9zbG90KCkNCj4gDQo+ICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oICAgICAgIHwgIDE2ICstDQo+ICBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9rdm1fcGFnZV90cmFjay5oIHwgIDczICsrKy0tLS0tDQo+ICBhcmNoL3g4Ni9rdm0v
bW11LmggICAgICAgICAgICAgICAgICAgIHwgICAyICsNCj4gIGFyY2gveDg2L2t2bS9tbXUvbW11
LmMgICAgICAgICAgICAgICAgfCAgNTEgKysrLS0NCj4gIGFyY2gveDg2L2t2bS9tbXUvcGFnZV90
cmFjay5jICAgICAgICAgfCAyNTYgKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0NCj4gIGFyY2gv
eDg2L2t2bS9tbXUvcGFnZV90cmFjay5oICAgICAgICAgfCAgNTggKysrKysrDQo+ICBhcmNoL3g4
Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgICAgIHwgIDIyICstLQ0KPiAgZHJpdmVycy9ncHUv
ZHJtL2k5MTUvZ3Z0L2d0dC5jICAgICAgICB8IDEwMiArKy0tLS0tLS0tDQo+ICBkcml2ZXJzL2dw
dS9kcm0vaTkxNS9ndnQvZ3R0LmggICAgICAgIHwgICAxIC0NCj4gIGRyaXZlcnMvZ3B1L2RybS9p
OTE1L2d2dC9ndnQuaCAgICAgICAgfCAgIDMgKy0NCj4gIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2d2
dC9rdm1ndC5jICAgICAgfCAxMTcgKysrKystLS0tLS0tDQo+ICBkcml2ZXJzL2dwdS9kcm0vaTkx
NS9ndnQvcGFnZV90cmFjay5jIHwgIDEwICstDQo+ICAxMiBmaWxlcyBjaGFuZ2VkLCAzMjAgaW5z
ZXJ0aW9ucygrKSwgMzkxIGRlbGV0aW9ucygtKSAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IGFyY2gv
eDg2L2t2bS9tbXUvcGFnZV90cmFjay5oDQo+IA0KPiANCj4gYmFzZS1jb21taXQ6IGIzYzk4MDUy
ZDQ2OTQ4YThkNjVkMjc3OGM3ZjMwNmZmMzgzNjZhYWMNCj4gLS0NCj4gMi40MC4xLjYwNi5nYTRi
MWIxMjhkNi1nb29nDQpWZXJpZmllZCBHVlQtZyBvbiBJbnRlbCBwbGF0Zm9ybSBob3N0IENvcmUo
VE0pIGk3LTg1NTlVIENQVSBAIDIuNzBHSHogDQogKyBVYnVudHUyMi4wNCBMVFMuDQoNCkJvdGgg
TGludXggVWJ1bnR1IDIyLjA0IFZNIGFuZCBXaW5kb3dzMTAgVk0gY291bGQgYm9vdCB1cCBzdWNj
ZXNzZnVsbHkuIA0KM0QgYmVuY2htYXJrIEdMbWFyazIgY2FuIHJ1biBpbiB0aGUgZ3Vlc3QgVk0u
DQoNClRlc3RlZC1ieTogWW9uZ3dlaSBNYSA8eW9uZ3dlaS5tYUBpbnRlbC5jb20+DQoNCkJlc3Qg
UmVnYXJkcywNCllvbmd3ZWkgTWENCg0K
