Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C877A9CFC
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjIUT1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjIUT11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:27:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB0BA150D;
        Thu, 21 Sep 2023 10:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695319042; x=1726855042;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lZI9EHcbdOxip7edtlh2mYkLMLJrHlYZxeQh2OLaPQc=;
  b=SgQ+hlFHP2uU2B3OS1zo9GUhbZ7HwlMvwozJIyUQtBhy7PKs5DFUrS6Q
   tdaxDkEsqawFGo3nmw34/1i+GQHIeV45yyC6Q1eSdw2oLk9rMDRUMtYBz
   UFIfVEUjLqv4TvVHDSgtiESLtEoYWE674fnJ7c+QDe+CzDHrnwfWuRjia
   QXZhFUKP4TueY/HPjVf2I0fTRX6iWsxOn0L/6TvtcJ1U01zetaDKZYJQG
   UIXJVR0bLvIylaH4UXj/QJaEPq2pO+Y3xqHhRyL1vGi5q2pMeQCT5J+MW
   BaWW5Dn0l/gruSTGI+6nc3ctYWGrTwlSUW3v0iTaXcuwTVtWgs53FPOyB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="379488317"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="379488317"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 10:54:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="776534413"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="776534413"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Sep 2023 10:54:59 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 10:54:59 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 10:54:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 21 Sep 2023 10:54:58 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 21 Sep 2023 10:54:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klSKAOkH4VvXZ4+Yx+0pEt9Z77ayspbMF5JWe/2mau3xhJW+4KwLGWwPwbG0+TjXLNXIZ4jDPYA1lxzlzKwk787rnKQxo1r0b1PDm2p8TzyBgcyfBpWlrZRdmIZTZXLPEYgST1blxPznmkHkQeqZ3L/rnaN/Y4gZoNAoLWlgcE4MlbkNtt8Tkh5m97n8/s6BMWemwgB62GkFrpdEyt/gxRI+OkTwjsv1qIWvLsgxmfBHecmWE7IYG7ExfYFdZOtSDAg8z6auPxx8OCHonLcCrmO116pO4+TnxPPkwmt1mCax0ebMqchp/id3KD3mrlJglihtJgm/D5bI6XXV4kEhOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZI9EHcbdOxip7edtlh2mYkLMLJrHlYZxeQh2OLaPQc=;
 b=apro2Vgs5t5N3Iyz5A5u0R34ojv8+KCqEVwN02oi3GbUGZdX7CjH1tu2d3EjY6r+0ArpS4ONnCG6PjqPNv/d6b6k/nM6En3mValhUP0ubvtojCEiwoyxFE2RhkPWriianAMBA4KcGxaCuFIov5U/Iod7VPuLcXGth+qCyESIATowdkSOxCZrmVYxzU8J+ZQ/8BPACsji9WD2QV7mxGo8PGxivt4XvxoekKbvmGd8bbyChsVybDf38dIqEWxpDcgZCQyLKrEdZNobq6AZl3Qib1ZwlVos/WvuIT0kOShmJnxLbX5tiA2+/4hi59hVp3Dle0WIOm+cWVmnqqcRIDc2Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB8465.namprd11.prod.outlook.com (2603:10b6:610:1bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.31; Thu, 21 Sep
 2023 17:54:56 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%5]) with mapi id 15.20.6792.026; Thu, 21 Sep 2023
 17:54:56 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 28/38] x86/fred: FRED entry/exit and dispatch code
Thread-Topic: [PATCH v10 28/38] x86/fred: FRED entry/exit and dispatch code
Thread-Index: AQHZ5stMrcSPSIs00UmJ9LfsWvvEWbAlE+eAgAAFnoCAAIIg0A==
Date:   Thu, 21 Sep 2023 17:54:55 +0000
Message-ID: <SA1PR11MB6734856675798D0C4E359619A8F8A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-29-xin3.li@intel.com>
 <22921663-0e5e-58c0-c6c8-c45f991790ea@suse.com> <871qerj0tk.ffs@tglx>
In-Reply-To: <871qerj0tk.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB8465:EE_
x-ms-office365-filtering-correlation-id: 21fa82ea-9490-4bfb-077b-08dbbacbddab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: usafrOlCoF4lwI98vzlPgF3cjsv1wxdDDZKT3gFS/W1VHSixGotx0vQCZtp4kU9Yt/xoQR3b3gxUqfu4fhaLsiyx8Js1gZY9BIUWIV25w1/uUIOQcDnrsXm3AAMFfG6hmRSumlZ42a+wezG1wJsjL9h4OP1arndkpivtj8JZBIQfutnZbRmmXLSq2Nawjt00wv4V0Qu3RkDjYzcXK19WwgtqTA0c1cNDsQPOLQDrqb8Pxr4onxWI6/upGneVIKYNjf2Lo3ta1K6RZEW5J+lv9t2GJWLha8+2axwYJ44AZtT49bYoBYmedZi5IwoYBBO4qmENMDgQYAVdgEk70QDyB/fsZAcU4oFXcALnWTdbPNx9Zkyozab30i4Tnt3twBnwAw9/fPttTT6JHUrF0LZmYPzvtz9/aEwjYN0Za2QdX0EFWQfA0lf/f1yrhX0iLavQMrOWEttXEGEFlYYeJhRLY7EUEUp8/3e35ogqMl2Z9vZIRC4G21UsEok9VTb0w6pJsUkjFPAkeX1hRjLUBB3kMwO24iX5MZVdYyM0h/BES3uvDNRqjOgh9Mdgq92/z92g54+xjU9Jn+YrYd7hvDBhkSIkb3V+VwbxtorFtJjZrgA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199024)(186009)(1800799009)(86362001)(2906002)(7416002)(4744005)(9686003)(26005)(33656002)(55016003)(64756008)(54906003)(66476007)(66446008)(316002)(41300700001)(66946007)(66556008)(110136005)(76116006)(122000001)(71200400001)(4326008)(8676002)(8936002)(966005)(478600001)(38100700002)(38070700005)(5660300002)(7696005)(6506007)(82960400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTg3N0JSbHplSEFmaUFTd2dzZU56TVpRamN1QTA3T1VqaHhJQnFtNnRZM3JI?=
 =?utf-8?B?b3NxRzE0N2p5ZUFab0pyemkwOHluUm5URVYzSFg1d2dTR3JzQzUrL1d0ekdL?=
 =?utf-8?B?c2dnOXpaVTdkUDZxTkc1b0lGVzRWY0VQbVBOZ2RzTEZQQzRiRFk3YmNUa3E1?=
 =?utf-8?B?aXdoNjlFTS9yQm5Sa3NGZjJ0YzU2UWMwb0FRY1BiT3h1SzEwUlMyeHpVMWY5?=
 =?utf-8?B?c2dzVG1hS0lRWThEN2hqRFFEQktmeHR4UEZiclBJdkwxeUhNRS9VUkdlTS9r?=
 =?utf-8?B?dEJLT0hEWWc1NWFtV1NwYWxtUkxoWlF4bEl6RVVKRkdMdlVnZDBIa1p3dlhn?=
 =?utf-8?B?T296Q1hjYnNTcjB2SGpXNU5IYTRmWE83TGV1NXBzbSt1dVZ3ekp2K2FleXhW?=
 =?utf-8?B?UDB0WllQZm9YZ295QXlQdkVDNXdJby9pZmFxUHBOTW1jWnU2VU54T1E1eEdt?=
 =?utf-8?B?VmtOcHF1amJZS2E3bW9RTzVDSGp1MTh2RXU0QmI2V2ZnOTcrYUNZWlM5VDN0?=
 =?utf-8?B?aFZoZkFCUVdEaFRISzAwVm5Ia0R3Ym5lbWZ6bU5wNVo0WVRFTFhWVGRBUmFk?=
 =?utf-8?B?aGFnWUhxNWc1OHU5TGlXZUR6T0pZYmd6UXcwWkdKV29QWDdDQWcrT2k2blJk?=
 =?utf-8?B?RUFvTGJBRXE5VmU4YStNNmd1ZEhwUXpJMkljTE94cnlRMWY2WUx1N0RnZytq?=
 =?utf-8?B?Tk1VaklaT0ZpNjQ3a3JWTVFNT3JlWWdOTzRUUUF3eG4wZy9tdkxCcTdSSXdY?=
 =?utf-8?B?K2RBVTBSdkcrNHB5SFozN1FndWdKOUlwbjlUTVZrUEVCMDhkZVAwUFk3QnMx?=
 =?utf-8?B?ZllEdlNGYldLVnd2TkNGc3E4TnVmdDc1bThJbDNDU1d1MkRJMEFTcnU2ZUQ4?=
 =?utf-8?B?UG1QYlVXTFcyUUVPdjU4SnpMZGd5S3pTUlVKTUVnTVBCU2V5ZVBnMU1XbGNK?=
 =?utf-8?B?cGlnaUxwR2xvcmhCNnVpTkpBSUlKb1dxVDF4N2ptaHpZSllTS0IxV0dGSGkr?=
 =?utf-8?B?Slgwa0FEVEFRQUhrSVdDME41bnluSU1oOG4weTBhaHBueFYxb3F4c1VwUVFj?=
 =?utf-8?B?aXpKZEJrN3ZHK3N4QWdISTc4b251STJjL3R1elU5eGo5bkJVQ04wSStwblJJ?=
 =?utf-8?B?SEsxaUliNXBvVFR1UUxWbGRnNVlnK1p2WWdZbzJUc0dMR2RlYUZWbnExRTcr?=
 =?utf-8?B?SEMxNllBT3J2TTVTMHcxWW9uV2ZMUkNCalNEWmVLbHc4b3JUQmdCeUNaQTRQ?=
 =?utf-8?B?eTQvTEY3K0ZUaWtIa1VkTlgrUE9xb2ozbVVVTlhIZGRvbWpLK0JjOVlhL3A0?=
 =?utf-8?B?emNuTHFiOTNUMXRuS1dTU1F0VExGa0xUN2dNY0VwbnQrdUpIYVRrcG9lYlVN?=
 =?utf-8?B?YWtHWW1ZZURNNWJKc3J1cTlaaU44bzVPQk9yaStDQWxPTFZwcTYvRllkbE5y?=
 =?utf-8?B?TkdOcUZWaldXRVRjZ0xuTVoxdVdtbUM2ZnJUS1RtaXZIWEk3bC9abk92aW00?=
 =?utf-8?B?ZWZ3SUZHK2RoYUt1dGg5U05BYi9rZnZkOFBDWGg5cWZJUzVNK09nbGtld0xV?=
 =?utf-8?B?OFhRWjFXeE1XMzlyOG9BeUVVYlJVTGd4d1p3bWZaNGEwd0hNb2FjNjNJVSsx?=
 =?utf-8?B?U1Z5ZlV3VVRiaE1OSUMrQ3h5cldXWXk1SkJPUlRQdXM5b0lDaWRkQXZhSUkr?=
 =?utf-8?B?dVdTTEIvdlpCM0JtZVZwYnFWbWZZb20vdUpweWQ2WWFCZFNxc0RvYktJWHNE?=
 =?utf-8?B?c1JFMkZsbFp5enRtbXNuajFOSzQ5eGltM3g1d1VpdTNpTk5GNitnMmVjMmlw?=
 =?utf-8?B?Wm10Wkd4aEtQZTduSElEOXY4UVlCczNPSi9MQi9UNjFOYTFMdk8yak5tZ3k2?=
 =?utf-8?B?OXRiY081Uk12cDNIRWxBeFN5RWlxMlI1MnhBc0RjalB1Y1ZubnRpb29Mb0t3?=
 =?utf-8?B?QVkwTmltb0xGQUxlS0ZrNGRvNVhGZ2xaUStyK1NPeE9UVXFoZWhjbFUzSmtl?=
 =?utf-8?B?Qll5YzlRTTFHeGl0WDYzemJWRHZYdDU1bnNaRUZoRkRqbWx2SjVnd1pjaXY5?=
 =?utf-8?B?cTRTbUcrckJmaG5aUVlHSU5TU1BjZDdoSDJaRzlCZWRLeG9SL0QrNkxVa2VB?=
 =?utf-8?Q?Mv0c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fa82ea-9490-4bfb-077b-08dbbacbddab
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2023 17:54:56.3153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqzbTCljUXnHwVQ/yt8Cf1wPIlgPk43ACMha53miHsR3vWs+P/y0luOHyuJ0fHpyvdZPCwwelJDVsQzJDa3ugg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8465
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IFNpbmNlIGZ1dHVyZSBrZXJuZWxzIHdpbGwgc3VwcG9ydCBib290dGltZSB0b2dnbGluZyBv
ZiB3aGV0aGVyIDMyYml0DQo+ID4gc3lzY2FsbCBpbnRlcmZhY2Ugc2hvdWxkIGJlIGVuYWJsZWQg
b3Igbm90IGFzIHBlcjoNCj4gPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC90aXAvdGlwLmdpdC9jb21taXQvP2g9DQo+ID4geDg2L2VudHJ5JmlkPTFkYTVj
OWJjMTE5ZDNhNzQ5YjUxOTU5NmI5M2Y5YjI2NjdlOTNjNGENCj4gPg0KPiA+IEl0IHdpbGwgbWFr
ZSBtb3JlIHNlbnNlIHRvIHJlcGxhY2UgdGhpcyB3aXRoIGlhMzJfZW5hYmxlZCgpIGludm9jYXRp
b24uDQo+ID4gSSBndWVzcyB0aGlzIGNvdWxkIGJlIGRvbmUgYXMgYSBmb2xsb3ctdXAgcGF0Y2gg
YmFzZWQgb24gd2hlbiB0aGlzIGlzDQo+ID4gbWVyZ2VkIGFzIHRoZSBpYTMyX2VuYmFsZWQgY2hh
bmdlcyBhcmUgZ29pbmcgdG8gYmUgbWVyZ2VkIGluIDYuNy4NCj4gDQo+IFRoZSBzaW1wbGVzdCBz
b2x1dGlvbiBpcyB0byByZWJhc2UgdGhlIHNlcmllcyB0byB0aXAgeDg2L2VudHJ5IGFuZCBqdXN0
IGRvIGl0IHJpZ2h0DQo+IGF3YXkgOikNCg0KSnVzdCBkaWQgaXQgZm9yIHRoZSBuZXh0IGl0ZXJh
dGlvbi4NCg==
