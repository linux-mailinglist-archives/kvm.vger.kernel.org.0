Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42958D22C
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 04:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiHIC4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 22:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiHIC4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 22:56:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8075615D;
        Mon,  8 Aug 2022 19:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660013773; x=1691549773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SUhJi84bxHrsT1gyhOGpMJwKlz2VKx68CD+CAJtRKqg=;
  b=bDlKYdpfMOA5H8JDLqKJ0RMW/AtMWn6Ru3htOkK4yvU6BVc1fUCeOHe0
   lj1xzewk9OUH0VoGjavzFEExKXtIPm6plJm9Ghsk92cqgcudWWmOrr3L4
   utZsz7P8r3RotXw7sOh2FZOlvgMfUvzkMDpQ7TcKqFhfBv66a1XWeYsdh
   5CkNhvyHOfdp2oYXQLENHa3mJPuiRKIXvazH8RyRyulJAmhJwVRZRgva9
   RYDTC7hSpHkzCVUt1YdumLKMYo08mvMLvm5itSKjktxBVL9JEGoaFuWNG
   Ea681NOv3FohcU+2jHf41pWEp/WVQiO/zBg2YIS2TMZfTxN9FYly0V8Rc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="288304774"
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="288304774"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 19:56:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="746882538"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2022 19:56:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 19:56:12 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 19:56:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 8 Aug 2022 19:56:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 8 Aug 2022 19:56:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQ1oZbR1hpa19FTa9n6CgS3U70Klo59A5gDXS9iUp2abvKgwp8Ld69CSfO0/rKaxLQEyckRFu2ILli6m5787+gvuVwEIv0M2RLjZWEw/PFLHtFLKzV9p3Hm2grjOWzZ60j0PFVkbchRr+0YeKVg2kAeNqz27Gxynp1SbfI/hwvQI8ylrH1mZKSYkdYmgWhgjmOLUNVqDFAyguUABrjvXF6CYXu0bQZwloxmmazLlffo7ajoNzTgeldfW8iw75q0XEt2rrShmniZyGUt342zACRvsQhEFrWIahiHzV/hNqGZRcECo6eu++DYozO4tpygwTnqIik0ET2+aHJI/mHkKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUhJi84bxHrsT1gyhOGpMJwKlz2VKx68CD+CAJtRKqg=;
 b=SQtDTrGLCFSMTHuL9OrVQSee0tGN1ekF8wIVcVWnp/AYS9u04Eyf+iqnXRDJUlpm7FdxEoAFpVVGsr7tqWwp+GbHA8ut+X8WMse0jbBiTS6iEGCgE9+x+IT9LokNCyZZTWV0Lj/cOcgTrlqcp0YCyHsl73LBaJkyslVS2rrB5FKBDNpW28TJo7V0tSdiA0isjm0stJ7mqbMoxsuFC5tfvRwifg/sg4yzskw9XdXLt+9zHgk80Z6SQxUOjW3FEbzdWVAI70FpzkghKfiV1yvNaFoWlymlkraPTcxN8kzz39BpdpOvPzDBxQMqGtHpJVIdcoExDs02j3EhD8x93+qupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by BN0PR11MB5759.namprd11.prod.outlook.com (2603:10b6:408:164::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 02:56:05 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::acc9:20b2:7a15:2dcb]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::acc9:20b2:7a15:2dcb%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 02:56:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v8 032/103] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Thread-Topic: [PATCH v8 032/103] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Thread-Index: AQHYqqnOPP6KFHJi0UuqZzWYxJ89Eq2l4cyA
Date:   Tue, 9 Aug 2022 02:56:04 +0000
Message-ID: <417351cfbe23fe56dadebbd167738a851f2191d2.camel@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
         <8aa5fe0bd8b2e79634440087c32a5d32b4dbe1af.1659854790.git.isaku.yamahata@intel.com>
In-Reply-To: <8aa5fe0bd8b2e79634440087c32a5d32b4dbe1af.1659854790.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74cb2214-878f-412f-36a9-08da79b2b36c
x-ms-traffictypediagnostic: BN0PR11MB5759:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0YXk/M7CJt0g5ZYg+U3PhLSlZmusX/tx2QaAyJWfA3Gzg68Mx8YJ9JCoj9Xk5DJ/D6LhbVEJvxo9/Vg6gyGMO44aEzxMDYhUsB6n8tZLletWvqgSomdAK2rLflWpo6MxUixP/THXa+slB/6UYqQ7fQkqHoab7p8R3d3W+D43mBKYyvLZpjeaBKi2ns9Th1IjF5Le1xrN/YIj4WJ0ViEMJRFaJJzREwbGvvGE4wMMCgHPu/VgF07PkCI/syxuk9ErlhXmwNToOxTh4xpNME1j3p4jhS1HWe9jVbk88r7iif0EHBcgmDR3Pxpld3KeuHvJODuaNGkFR2+vMOYJ3vNdk+6QMtMFptjLDQstaz5+L9cdmR5VUEOTFuROfaF4T4Ua29WP2pC9SsrGISIcoRzOljfOda5Zneu4/2P+VgevetIG2WpVDoPn1vLECXcsY/miFi3yL9r/4g0Jeof6wa8KMOZb/gw9FJ49rKGmw+3Mu5mBxzW2VFHTn10Z17ekcsTOB6VOwyeu4MAUyp2j54t0ZhiO95DN3vzFfHfDlXAi29ZXtYhhyRT274JZDR7uvWt8jrsRMj4pdd3a7vwyFa5x1V2oA+l+wqPIybnonoDa1mLE44tHj+xkUBNj7MjLU3zIZS60QUzKOYHIq91D/Pn/739lpbDPX99D0XK3zLQvBSdmBMbe9DkHL+Lk7pCvDqLQGh/LBParzm7EjYv7vMYt+BhoBO630FeZ1RJwUe1Acn9GzTFg8Moyyi6mCJY2JgT/sXqF1w0P3XKsimhgKxlPuYbhmVx++svb+/fO/SpCjKkxxVrbJ97SMduM9nIBkOihILjhwivnFGK9oDuzq6yDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(376002)(136003)(366004)(6506007)(2906002)(41300700001)(38100700002)(122000001)(2616005)(38070700005)(186003)(6512007)(26005)(83380400001)(82960400001)(966005)(71200400001)(66476007)(64756008)(8676002)(4326008)(91956017)(66946007)(76116006)(66556008)(6636002)(110136005)(54906003)(36756003)(66446008)(8936002)(478600001)(86362001)(6486002)(316002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnRCYWZqandyclFGR0psQ054c3phZ2hGb2FITzEzR1FjUlpQdGVzbDFiY1JR?=
 =?utf-8?B?STN3ODdTWExMbEp4QnpJRDJRWUNuMGVWdk5NeE1tYVBTQWQxWFBQWUlWS0hO?=
 =?utf-8?B?emtWSEI4RTROSE9UUHdPbDBsZmMxaU5FekZ1WjVva2tFMW0rTTkvaE9rWGcx?=
 =?utf-8?B?WFVScGdwZEZPSmpPN1pCc2s2RVkzZHdKOHc3Zk5nK3hoSHozZU1sTksySE5j?=
 =?utf-8?B?RVNtMGhKb00zY2FPQVdrWUJ1TXcwL29DemlHVFFBQUxJOXgzNG5WVmtuY1l6?=
 =?utf-8?B?aXBRVzZQaDduTDVFZFA0SmVaZWZoL2dnRFBFeEV3S0FsNUQ5cUVPcjRsMG52?=
 =?utf-8?B?Tlg5RTJXSHhUZ1BzUVdkQmNvVnBEYjBSTFZtRTdwYVh2UkNTK0VON0N5V1RR?=
 =?utf-8?B?eTNudEFWeW5TcW15SVBIbnhvSmppcDcrZEhWZWU1ZUMrOWVuZUpwSVhNUkxu?=
 =?utf-8?B?NVQ1MEt0RWtacE9GQXRtL1VsbjdrdUZOWVc1bU9COUJkRHlhcTlaN2lnRWgv?=
 =?utf-8?B?VncrZ2JHSGVXekxrVE8vbFN6MktFbjBQNUt3YTVIbyt4UWNTZXBxU3RaZG1L?=
 =?utf-8?B?Nm5GUmY3ZUZzR1BUWXVtZmNrdnR5YTJPOGZPOEc2Q2pydXNwbC9aS0pNSG4y?=
 =?utf-8?B?WDBSMG1COFZYTlo4ZnIrTnZsUmdha3pGMDlKSmdjWHkwZldDNmNNZHNkR2Q1?=
 =?utf-8?B?VDc0V25KeXhGZ0dONGlhc3ljeEwzNkNVS250VDJVZWpPaGs1cjBmaVVHMXU0?=
 =?utf-8?B?UWRScTNQU25vdkgzWEtYbVVzTTNFT3dpK3J3cklPWnljNENHRzdyc3hWbktt?=
 =?utf-8?B?VGQ2MzhWM0krR3RCb1JkN0FSZllYMGx0azBtbEkxS1ptLzNCSDlmc3Jwd0RB?=
 =?utf-8?B?V3B3MHgzYm5MaG1xR3N4UTZ2K3BHNGFSYjlIajhhOVVkZXpKYUZINTQ4RVRF?=
 =?utf-8?B?SU1oL2owb1l6ZmNCQ0F0MmJLYkx6V1NYdkM1NTNFdFZkOC9SS1RPZFM4L1VX?=
 =?utf-8?B?RXhSRXpHSVprUXM4eEVLY2Z4UjY2MHpJVmNWQ09DQkczSjBzWXoyREhLZFJk?=
 =?utf-8?B?SkU3bkhQeHd2ekdOVFR2UzdKblRZRHJTc3NaL1Z1WjcrSjVUQnFuUlE2MC9B?=
 =?utf-8?B?K2dhUitZY3RmcFJOWVNZQzFuc2NCWi8zTVVJUm0vYWFyanlSNXRjMzltelIw?=
 =?utf-8?B?aDZOK0FITEl4MFpodFphTURCa0NnaXN5MW9UNHBWc2Q3RTFtYTlneXlCS2p4?=
 =?utf-8?B?bHhUbFlxVVVoTW05TlNPd2JnVUdFUzRqYmhBTEJGS1lQem0yMkpuNnVEdGdZ?=
 =?utf-8?B?eFhINjhxUUh0Ym9heGdJOGVBcWNBZnkxdXRwUVk0MkwzSHlzTmFEYi9FY08y?=
 =?utf-8?B?a2dNUFVZWHhRT1FiVEg0ZFhnZGMzWWJZbE9YdXVpMERSa0RrYWorNEJpQ3FY?=
 =?utf-8?B?V0k5SVBBNzdJSlNwNDV4ZkRqWlJtWGhwME9BNHZRSEswRGs2d3NCcC9JbFB0?=
 =?utf-8?B?eVZnSDhSYzNkR0RqR2Y2VzRTVXJvOS9CTGhsc0JsZEtuYmdRWWtDbTRIL0dQ?=
 =?utf-8?B?Yjl4WTRYZXgwYWkzMjdoL1FPMkV1bWpvakRZQllkK3Y3Q25xWHFXeFArMzJS?=
 =?utf-8?B?UmtPSFgzK3RJUllBUklKWU5QWW9yUGI5bC9QSVFUSlczQk1CaXI3RmhCRDV2?=
 =?utf-8?B?ZTZ5LzZNMEVBNEJjaGVBNnNLbG5VTGFhalFKaEU0T1VHT1R6YXhOazQwTXVm?=
 =?utf-8?B?WUpuN3VONDVVdk5TcmpXV2todHQyUElkSlI2dHJUcC82WGRzNDN0SGN0RlZm?=
 =?utf-8?B?Qjl3NlZUU3VXeEZ4MTVndWlxRERyRXYzWXI4Zi84czlJOXpiRnBUQlNVOHky?=
 =?utf-8?B?UTROaEVHT21vbGVJenhRZ2xDbVFtT1Z1WEEwSHpNeVFWSlY5bThQc3ZBdTAv?=
 =?utf-8?B?ZGdrNVpUUmtvV1E3THBxOG9GbDJseFRFOHJHa21TSXUwYTlIWGNrci8xbFI0?=
 =?utf-8?B?SDdCRDdXckJpUHFBdHpTbWU0YkhWa3BuTHIyYjdMZUpBOTY5K0pNOHY3b0FH?=
 =?utf-8?B?N3pzS0ZuV2JFd20rK0hGUURGczdLc1JyRzhzTDhHYzBncHQ2MW52WUM3SXJv?=
 =?utf-8?B?ZTJROVU3MDVHUGc5V2xyUXY2SFVhaHkrNG5PTHdMN3E2cU1qUWQvY3d3TDhp?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DA79F9D02D8C14097E29153E0278CFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cb2214-878f-412f-36a9-08da79b2b36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2022 02:56:04.7230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JWhr7U7geED2KEsrncyAiU72LO4qCNhLq9CnwvpifYf+nNt38HEqz7tLx2llX8isWequJA583aOh3baXQhabNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5759
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIyLTA4LTA3IGF0IDE1OjAxIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBGb3IgVEQgZ3Vlc3QsIHRoZSBjdXJyZW50IHdheSB0byBl
bXVsYXRlIE1NSU8gZG9lc24ndCB3b3JrIGFueSBtb3JlLCBhcyBLVk0NCj4gaXMgbm90IGFibGUg
dG8gYWNjZXNzIHRoZSBwcml2YXRlIG1lbW9yeSBvZiBURCBndWVzdCBhbmQgZG8gdGhlIGVtdWxh
dGlvbi4NCj4gSW5zdGVhZCwgVEQgZ3Vlc3QgZXhwZWN0cyB0byByZWNlaXZlICNWRSB3aGVuIGl0
IGFjY2Vzc2VzIHRoZSBNTUlPIGFuZCB0aGVuDQo+IGl0IGNhbiBleHBsaWNpdGx5IG1ha2VzIGh5
cGVyY2FsbCB0byBLVk0gdG8gZ2V0IHRoZSBleHBlY3RlZCBpbmZvcm1hdGlvbi4NCj4gDQo+IFRv
IGFjaGlldmUgdGhpcywgdGhlIFREWCBtb2R1bGUgYWx3YXlzIGVuYWJsZXMgIkVQVC12aW9sYXRp
b24gI1ZFIiBpbiB0aGUNCj4gVk1DUyBjb250cm9sLiAgQW5kIGFjY29yZGluZ2x5LCBLVk0gbmVl
ZHMgdG8gY29uZmlndXJlIHRoZSBNTUlPIHNwdGUgdG8NCj4gdHJpZ2dlciBFUFQgdmlvbGF0aW9u
IChpbnN0ZWFkIG9mIG1pc2NvbmZpZ3VyYXRpb24pIGFuZCBhdCB0aGUgc2FtZSB0aW1lLA0KPiBh
bHNvIGNsZWFyIHRoZSAic3VwcHJlc3MgI1ZFIiBiaXQgc28gdGhlIFREIGd1ZXN0IGNhbiBnZXQg
dGhlICNWRSBpbnN0ZWFkDQo+IG9mIGNhdXNpbmcgYWN0dWFsIEVQVCB2aW9sYXRpb24gdG8gS1ZN
Lg0KPiANCj4gSW4gb3JkZXIgZm9yIEtWTSB0byBiZSBhYmxlIHRvIGhhdmUgY2hhbmNlIHRvIHNl
dCB1cCB0aGUgY29ycmVjdCBTUFRFIGZvcg0KPiBNTUlPIGZvciBURCBndWVzdCwgdGhlIGRlZmF1
bHQgbm9uLXByZXNlbnQgU1BURSBtdXN0IGhhdmUgdGhlICJzdXBwcmVzcw0KPiBndWVzdCBhY2Nl
c3NlcyB0aGUgTU1JTy4NCj4gDQo+IEFsc28sIHdoZW4gVEQgZ3Vlc3QgYWNjZXNzZXMgdGhlIGFj
dHVhbCBzaGFyZWQgbWVtb3J5LCBpdCBzaG91bGQgY29udGludWUNCj4gdG8gdHJpZ2dlciBFUFQg
dmlvbGF0aW9uIHRvIHRoZSBLVk0gaW5zdGVhZCBvZiByZWNlaXZpbmcgdGhlICNWRSAodGhlIFRE
WA0KPiBtb2R1bGUgZ3VhcmFudGVlcyBLVk0gd2lsbCByZWNlaXZlIEVQVCB2aW9sYXRpb24gZm9y
IHByaXZhdGUgbWVtb3J5DQo+IGFjY2VzcykuICBUaGlzIG1lYW5zIGZvciB0aGUgc2hhcmVkIG1l
bW9yeSwgdGhlIFNQVEUgYWxzbyBtdXN0IGhhdmUgdGhlDQo+ICJzdXBwcmVzcyAjVkUiIGJpdCBz
ZXQgZm9yIHRoZSBub24tcHJlc2VudCBTUFRFLg0KPiANCj4gQWRkIHN1cHBvcnQgdG8gYWxsb3cg
YSBub24temVybyB2YWx1ZSBmb3IgdGhlIG5vbi1wcmVzZW50IFNQVEUgKGkuZS4gd2hlbg0KPiB0
aGUgcGFnZSB0YWJsZSBpcyBmaXJzdGx5IGFsbG9jYXRlZCwgYW5kIHdoZW4gdGhlIFNQVEUgaXMg
emFwcGVkKSB0byBhbGxvdw0KPiBzZXR0aW5nICJzdXBwcmVzcyAjVkUiIGJpdCBmb3IgdGhlIG5v
bi1wcmVzZW50IFNQVEUuDQo+IA0KPiBJbnRyb2R1Y2UgYSBuZXcgbWFjcm8gU0hBRE9XX05PTlBS
RVNFTlRfVkFMVUUgdG8gYmUgdGhlICJzdXBwcmVzcyAjVkUiIGJpdC4NCj4gVW5jb25kaXRpb25h
bGx5IHNldCB0aGUgInN1cHByZXNzICNWRSIgYml0ICh3aGljaCBpcyBiaXQgNjMpIGZvciBib3Ro
IEFNRA0KPiBhbmQgSW50ZWwgYXM6IDEpIEFNRCBoYXJkd2FyZSBkb2Vzbid0IHVzZSB0aGlzIGJp
dDsgMikgZm9yIG5vcm1hbCBWTVgNCj4gZ3Vlc3QsIEtWTSBuZXZlciBlbmFibGVzIHRoZSAiRVBU
LXZpb2xhdGlvbiAjVkUiIGluIFZNQ1MgY29udHJvbCBhbmQNCj4gInN1cHByZXNzICNWRSIgYml0
IGlzIGlnbm9yZWQgYnkgaGFyZHdhcmUuDQo+IA0KDQpTb3JyeSBJIG1hZGUgYSBtaXN0YWtlIG9u
IHdoeSBhbHdheXMgc2V0dGluZyBiaXQgNjMgb24gQU1EIGlzIE9LLiAgSXQgdHVybnMgb3V0DQp0
aGUgYml0IDYzIG9uIEFNRCBpcyBOWCBiaXQsIHNvICJBTUQgaGFyZHdhcmUgZG9lc24ndCB1c2Ug
dGhpcyBiaXQiIGlzDQphYnNvbHV0ZWx5IHdyb25nLiAgTW9yZSBpbmZvcm1hdGlvbiBwbGVhc2Ug
c2VlOg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL1lsOFRsTVRRR3E1UjY5RTZAZ29v
Z2xlLmNvbS8NCg0KLS0gDQpUaGFua3MsDQotS2FpDQoNCg0K
