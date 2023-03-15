Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D34D6BADC3
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 11:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjCOKfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 06:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjCOKf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 06:35:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B740F1A484;
        Wed, 15 Mar 2023 03:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678876525; x=1710412525;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oKxkbig7kmX/6gTvXdPi3BLNqIZ7FpwUmrTgGaQqDjQ=;
  b=YA4nmU1SnhDy2gXxUqWwKbcLpqDMgUFqkgcfKggK4+ZZ58XoDApGese+
   ljFS72Krb45M/02XEVc2BwUiIivi1Kgr5ibNsFggGMoinH7jwtXDmaJOb
   PVVzExQB/uHUZBsMk1qVLCdnFpRLac+e7QJtTWJMielOObTiMTi08GLy3
   hGcDEeOHPsDkXGIybmGTqIXaBOAF3l4Jhdjg+rTz7atm7+OMdH3J7bfvg
   MmKwehEwCJMVaKTTz+AXbDO3mT6kdDgy9H/FwsAWCrCD+tzEdKALSfRf0
   Z+m4q3/Kl09tSTQO3RYxipy/UQlUjzSj52zQAaXBWJ2R7kZILL6PDlOw4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="423938682"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="423938682"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="679462828"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="679462828"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 15 Mar 2023 03:35:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:35:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:35:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 03:35:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 03:35:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXMG3X/rTU6B601j71UaileT+RNtzqJlmijkXlVV/98y1jbJIo0iKvfDiJkrb1iULJkfbCkFpeypE0qqaU6alz+4u+pXGdvsir2gv/Aotqz5R8Oyo/bycAoahy2VEGtzTDWYaWsHKQffhz5jSNjra1EbH6tNB5GvqKdofn4cACDzEUg9xh24g6eutqgWsIOjEVmHJ0LZ1APi09NTGVh0TLjuosSN4lnaqoirsajW3nNRgO4Pu7f+tOSD+e7vU4hzoDML9FZoRFJ2y+x5/msBj1MnqnNyYXek+U7IFSZoicTRhi52/wyvywIckKcFjqSW26T0Pf6Yj9iURhDZ+z/N+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKxkbig7kmX/6gTvXdPi3BLNqIZ7FpwUmrTgGaQqDjQ=;
 b=HAavoRXE0/ijNcFCJbvmXZTMdQtwqjSaWdYykOBJJsOXhleO9ye1+92A7hVpxtArY1l9GlKpaV8JzxgsPQBcR2c9q/2Fd6YD2XJhwB38dkjMq1Yykf+sVvHm60lTuzTzWlpXHz70Qg2vUFWUMK1E+Ig/WHEEJYmRV1vn6DSWaBGCrGzCk6XFezSKwVhHezFmZKT1j4bpndAUp7ruX0oGMnT6885p9ScVdR7MGqJiAUvuOjq49kFpPXLeXrQGsiAKLjGTClgnZVfC2O0EOLOqu8oWasQHlumL1Beq854jFqHqUNYktNKhl7h8aequWmHqfQsyavraJ1MJURurgXEofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8048.namprd11.prod.outlook.com (2603:10b6:806:2fd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Wed, 15 Mar
 2023 10:35:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 10:35:21 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgIAADcoA
Date:   Wed, 15 Mar 2023 10:35:20 +0000
Message-ID: <9a70ba15eaa44fbaf39b7d392df978ebe7640574.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
         <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
         <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
In-Reply-To: <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB8048:EE_
x-ms-office365-filtering-correlation-id: 0c63619d-2227-44d2-420d-08db2540fa32
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bl4u7/xtfNAcaoBXq7YCpQE374FIYOVfjIYa2hSjtazPq8f6lK6G9dFQXJ16V82BhBJnkltLvzem6rp5vCtGrE477GfeR3MC8DAyoMCCdj9kLGbErJFCoPv9v1Dw0/PHXkA8SJbDepluu1plFkOqisPnxWREHq/LwzrxjoKdVm3MPdG7NfcTBCxhqmH7/vD9a/GghCgLJ0se7kLzytFP9XgGaZdXsiAK88Jj1cnegHvd9JQnU960iJnbSM9Mxt6IrIqrrjiNRpFjwOP5ZKaB8fKljBdxwfxkeIPhAKrQ1ZC/knoINgFLJ0h1UM1Y3Y7H47lNNuE40ixeXwo0W8PNBJ/g7Kk1nC4LVeQiV3suNHyu2IPnIp+VUlNlVZGohk95DymwRG446nxOOagZjIlIGABxQCtCPodhoYyYdsvvAaG3FfJbmkzHJkLNG6vd3bOsIQHjHeD4TaNC41Wor6SjA7+FY0wqHM/LvOa0BVLZAd11QFJu1UkJNnBCsa3OHxxS5yyHFJgVM4bXKC5RFaUnUGN6jVSnOmPvIMurzFdEN01Omji2/YXQ2mm7noN1OkKK7Epjm14/txE9dVMuv1atKNl3kWGm9GzWxjvFCDxP44bFL8X72wsxZEYeIvLlQhkubCNn7czq6f4TDtasU1ZVUV8iZkNVxz0OL7rmudcZOUnubkIwA8+Qfnvx2kd5MD3bIrbTn3UOh3eoQIu94qyCLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199018)(86362001)(36756003)(4326008)(26005)(186003)(41300700001)(2616005)(8936002)(5660300002)(6916009)(6506007)(6512007)(71200400001)(316002)(54906003)(66946007)(66476007)(91956017)(76116006)(6486002)(8676002)(82960400001)(66556008)(122000001)(107886003)(38100700002)(38070700005)(4744005)(83380400001)(66446008)(478600001)(64756008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak5ubC9jSDQwWHNld1VkZjNubm5RUmFCZ0RZaTBaQUo0RTVnbTVRTG4vOVFz?=
 =?utf-8?B?YWszTlhvYjJxT0IyajhIMEMyRmwrczZYaE4zWUhITVY2QUJvemVGd2xDOXMy?=
 =?utf-8?B?c01RejkrdzNhWHBmWTY5TDlMK1ZjaFZ4Vm1WeEdPUXFIWDYvTDdscXZ0WHFT?=
 =?utf-8?B?b3VqYUI2RVU0eTlZR3BlbU1DbGg2TTY2L3g2Ly8xcU96c3V3VjZXcXhLQTRH?=
 =?utf-8?B?cU5OMS8yNkRVN1V1ZlBGTkd5dE10OGRTV2xMS0syZzhCQmMvRmZQWWQrUzBV?=
 =?utf-8?B?KytLaXBtcEFCUmN4M0pkRkJIcVZGZ1hsSWNHYjE0U016WXdzUXI0ZkVjakJw?=
 =?utf-8?B?V3dpQzZXcDhUYXpwakJIS2VzcG1FaS9aZloyMnFGT2pxeXJvVmRlVjdNWTBI?=
 =?utf-8?B?UTFuRDQwb1BqdzRiTTFvSHA5YU4yQjIyNVJ3bVBsT2ZBNlZuczJjeUlRVnRy?=
 =?utf-8?B?Y1lHQkZqV2tHbk9kV3prY0hoVlNpbUtkam0zb0R1QTdtSjB0eUtHMGFUaVZR?=
 =?utf-8?B?YTF3T2tzTXYvSzI5RFJjMmxCTVJULzJLYkFkV0dOWGZqb25jVDM0Q0lXNVBE?=
 =?utf-8?B?M1Bpb1g4UFAwQWlnS1RSZENqbVFjMlpRbkRDYisvQ2NGa2xmSEErbldIclJm?=
 =?utf-8?B?VkRjdEordm56NGFYZVQ2T1BCRGdYVnUzK21IQzFjaW1KYk9EaUVYMTErbVRN?=
 =?utf-8?B?M0VlSnZLMFJmSEJPNXE5VjRiSm5hVTd1ZW5Ec2lwZFZlZEkwd0hGdHlpclV0?=
 =?utf-8?B?STRYTUVXcnJPYW0rLzFmSk5BdmgwbXg1N2hXMVg0Y0FKbUVzWWtpdUl3UU1j?=
 =?utf-8?B?aGxyUUZ1c1hCdnA4NGdRNCt1K0srUjRWeEMrK2c5Y2grWUwzbHg4cGdpQkpM?=
 =?utf-8?B?ZnRRN0tzT2ZmRlVBWU0zNG8wdXlEc3J3cGdGMXh4Nm9NYXFqN3ZqSW5rMyt6?=
 =?utf-8?B?ZFNVTjhkeEhSTVVaaEtBRWkwUzFpTE55NlpYOFZkSzhSQm1OV2JyZVRkSHND?=
 =?utf-8?B?bG56bVY1Q2dtRjk4K2ZxQ21WdzZ0OFIyMGduY1c0dkFTMXZlMkswM1lKNEtM?=
 =?utf-8?B?TXkxUks4aVR3aDQ0MFZlZDZZQW91SXQ1Tmp6ekx0WEtxeDdlSmFKbzYvV2lT?=
 =?utf-8?B?MmR2T2pSUHVydXNVRnNZVDd4Uld3b3JJdGZ0VzBiS3MyeEQvd1hCYlhwTHFq?=
 =?utf-8?B?Q0F3SCtqMzhQSUV4WDNQT25JR1RqZGVGbTMrVEQ3a1Q4eUF2Ylh0ZVQvY05l?=
 =?utf-8?B?anBPbm5BcUp5T0JXdit0Vnp5dTR1TmdrNWlESEpybWZSd2xJbFlWazdXVXhh?=
 =?utf-8?B?NVZKWEt0cW9qQ01neTVTQ0dTS2N2cTNFL1MwVjZ6NHJCMDZxSFNhTnl5QkN6?=
 =?utf-8?B?OWNaZ2ZKSERoUC9PRktzeFZkVEtzVC8za3h2aW83MVVHQVVjaGZaRU9hRThz?=
 =?utf-8?B?d2IxWkd1QnBDRWNKL2V0WW15TXVlWHFtNEJGOStIcjUxY1NodmZ2dzFjZWNE?=
 =?utf-8?B?M2poNng2bkcvYzZEQzhaMis2WGZKWUdRQkZTY1hxajdORzU2ekI5cWlQTGRk?=
 =?utf-8?B?NlFxRUJZUVhXU1k4L0doVTcrY3pRQk1ZVENwaTlSdkZ3enBOMGE2WXZad0Rl?=
 =?utf-8?B?VUQvb1N6NFFESDFudlRBaXJWUk04cjBSMDFFQVVCSURYY3dDaEtoTFRwWVVt?=
 =?utf-8?B?dHFWemxJVWpYbVcxNjMrYjg4MEQyS0xDSURRRnF3NXhJaGVmdmxuS3J5bW1S?=
 =?utf-8?B?Ujg1SmpRVTM1M3FCc0pNajVCWFdBeHJHZzlWV2lJU2VxR1Q5L0hWd0NFN05L?=
 =?utf-8?B?SGM3Z0hqTmFxZGozSnc5azd5dlpONklvc1Z0ekFMMHlMRis1bW5Zc2FndWN2?=
 =?utf-8?B?V2dKdTc0VHBySkwrTkRrek5IWW8rdnRzOVRLeEQvYWNyamlINlF0V2dSQmtB?=
 =?utf-8?B?bncwMFV4TmRlRW9QcWI3R0FVQTVraE1tTFJiRHRqekhVV3Q3MDdvWWJIKzB1?=
 =?utf-8?B?UUpycEZpTjRnNWFCcTFpNm1tY1lra0FPaEhETWRRVzJzRGwwQ2Y2RE45Skll?=
 =?utf-8?B?dGYxS0l2SVhKbTZPUmI0Vi9UdFp4V1Q3Z2ZMaGtBbnRPaHpkSkdJdE52VEpZ?=
 =?utf-8?B?d2FXUHgxWHh0QnhvV2RzSUZuU3VnVjNpdkE4YVJjam1iaXJTNURLSXBUUk1t?=
 =?utf-8?B?dGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <990CDA921B3E9D4294AEB3495236ACFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c63619d-2227-44d2-420d-08db2540fa32
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 10:35:20.8477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pHge9J6YECb+33DEuw3O6eWAwbLHUlx3+PmM5afm6ChysgDNJPE7lH+yf6j8z/+g/eMMg+QOtX22G/dAuN8E0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8048
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

PiANCj4gPiArc3RhdGljIGJvb2wgZW5hYmxlX3RkeCBfX3JvX2FmdGVyX2luaXQ7DQo+ID4gK21v
ZHVsZV9wYXJhbV9uYW1lZCh0ZHgsIGVuYWJsZV90ZHgsIGJvb2wsIDA0NDQpOw0KPiA+ICsNCj4g
PiArc3RhdGljIF9faW5pdCBpbnQgdnRfaGFyZHdhcmVfc2V0dXAodm9pZCkNCj4gPiArew0KPiA+
ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlyZXQgPSB2bXhfaGFyZHdhcmVfc2V0dXAoKTsNCj4g
PiArCWlmIChyZXQpDQo+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwllbmFibGVfdGR4
ID0gZW5hYmxlX3RkeCAmJiAhdGR4X2hhcmR3YXJlX3NldHVwKCZ2dF94ODZfb3BzKTsNCj4gDQo+
IFVuZm9ydHVuYXRlbHksIHRoZSBlbmFibGVfdGR4IHNob3VsZCBhbHNvIGJlIHByb3RlY3RlZCBi
eSB0aGUNCj4gY3B1c19yZWFkX2xvY2soKSwNCj4gYmVjYXVzZSBDUFUgaG90cGx1ZyBjb2RlIHBh
dGggY2hlY2tzIGl0IHRvbyAoYXMgc2VlbiBpbiB5b3VyIG5leHQgcGF0Y2gpLg0KDQpTb3JyeSBJ
IHdhcyB3cm9uZy4gIEkgZm9yZ290IHRoZSBDUFUgaG90cGx1ZyBjYWxsYmFja3MgYXJlIHJlZ2lz
dGVyZWQgaW4NCmt2bV9pbml0KCksIHdoaWNoIGhhcHBlbnMgYWZ0ZXIgaGFyZHdhcmVfc2V0dXAo
KSwgc28gdGhlIENQVSBob3RwbHVnIGNvZGUgY2Fubm90DQpyYWNlIHdpdGggdGhpcyBoYXJkd2Fy
ZV9zZXR1cCgpIGNvZGUgaGVyZS4NCg0KWy4uLl0NCg0KPiANCj4gSSB0aGluayB5b3UgY2FuIG1l
cmdlIG5leHQgcGF0Y2ggd2l0aCB0aGlzIG9uZSBiZWNhdXNlIHRoZXkgYXJlIGtpbmRhIHJlbGF0
ZWQuDQo+IMKgDQo+IA0KPiBQdXR0aW5nIHRoZW0gdG9nZXRoZXIgYWxsb3dzIHBlb3BsZSB0byBy
ZXZpZXcgbW9yZSBlYXNpbHkuDQoNCkFuZCBwZXJoYXBzIHRoaXMgaXNuJ3QgbmVjZXNzYXJ5IGVp
dGhlci4NCg0K
