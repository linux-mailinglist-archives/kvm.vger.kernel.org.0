Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0B0637850
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiKXMCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKXMCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:02:43 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2D413DF4;
        Thu, 24 Nov 2022 04:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669291361; x=1700827361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ByzyqHT0pWydKIz/KfDxD+ECkFTq6Ws31EHvLEzI37U=;
  b=Hc/mN8HJcCm7MvtKVQwGpzPbJVJld8o229vvaQuEGFxP+zymVnmxmm6D
   ecZtH+sXCDFpxITNk6FhmqwIyUQ4Bg8IAfSjPYRvcaINlIDvpha3yJAoX
   /uUzsS/mB+tWz76VHGGDGAPwFL5lTLlfzUKYCM9KkSBnQCaf5PspYl6Kt
   2AFCC3S4XwcJKNRgIaj6yui9mfbebuOj4lmfBnrmbhrd4eJu+wrFrXRXU
   +k0oLNCjjYwl9qSD9lGdonDirOMiRRnlFxnl8w7J+rghAEeCPXx6AfBsU
   n+U4xZTavcB8GbvjV+heUUZKpZQ2PjsVXeQ4/P0sdij6lB/vmNFJ1OIWf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315437366"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="315437366"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:02:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="784610437"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="784610437"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 24 Nov 2022 04:02:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 24 Nov 2022 04:02:40 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 04:02:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 04:02:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 04:02:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaC11gu43Uv+55j+HIIqDhtBLKJOAVbrmHxpMCnA/NqLAUZ+yVBCXrdpm49o69QcWHowrMlfcSLHIkm0+c+O+U91nGFlSyc2amj2JGq+9ELbqXTn+PAmNYMgLVz55POKa80npVqVJPfJMCRVP5/UMzGECtKpPidjPbGu6TVMLfHqSplSUssettUHui5f9rVCOX6E35aJ6tSffQiNgkgWZ/zfs+4Bryp3o2uTI1uDklMnxSkCDM5un0Ac3gHT3nLK8SAFzzl5/8olajZQUGghw0Ji909RaD5gGr+XaJGXtYeBTgdCOCRaiLfUrD76pszc5XGUmOkdDrSVnXxQEzfBYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByzyqHT0pWydKIz/KfDxD+ECkFTq6Ws31EHvLEzI37U=;
 b=k+4T8vjUnkEqAXNnTLpXpKjhMgw1sf4XbKS+eUV+6t5a1sYApB+Jtk9fTy7GQeKwxfgl2OshSBPCzT/UOBXfFFqviD7IWY97jBS9OLTrmPFpTT9nyDXd8dcAE7k6FtXiHlSm2tyYqAdhg78YHu3dsxAu+S/lguJAxWbFlTknE1CKcdWqrIcumcb4uyAGPEc6jI2i7KiU/8GbsuyOY6dOri7TDlxjrwC/2oNG7gp+vgg0qzBjmRcQAfASXTC6V2KC7zrHzDCtMvs8ndQFOayy073fuixWph6qkJqZ8eqVl4+NW0Q4tlRbNdlTqq5ZF16CHnUuYy9vuxcqtjL4Y07rwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6294.namprd11.prod.outlook.com (2603:10b6:8:96::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 12:02:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 12:02:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYA=
Date:   Thu, 24 Nov 2022 12:02:36 +0000
Message-ID: <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
In-Reply-To: <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6294:EE_
x-ms-office365-filtering-correlation-id: cf5d9485-ab73-42d0-2c8a-08dace13c738
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1gVJkCi1eXK2j1j0Caz0PoNUYrDML7BeSO/cyDChS+7W6ljrlZZw+6rx0bEk6aMTcdjuMLyFv6bvKv2xr45DmLVlhF+9aqwp3qXUB+VlpmYjHIoxE7fQAhgGAS3pMrOhy9EhanVsRp66mPYdBfRLgaizJsRVyHuvVjFWmRTbA7nj2S/TaGLTJvvJMv8OBi9Tsnqo2hP4YEkkw2B91Y03rb4DXZ4lYjyT5dB1A4GolJTcBjAoiG/offCut5CWPxcWliuMBz2l/gxWoh7hR849LIYDqKkqwYZRhkWRt7fSe4zG5cohFY2kuMxX0MfJ4YEnioWKqlasHX5CK/dMYBbYi1DIXHyuIXbe6cke/XmVsZsDqOZUgYwA6iVvT4FAKK+rmVAFA0T8GvolT3uGeYO5lKEpIIkYoHbYP1EMoyLgvsoAeYmEGBOry0uLjjufwwGlji2x2z2e+xvggqdcNSIaKPvTfwcpJZANsvUdcV0x8ey99O+ZZQbzEKRegeKCNPVTyJqMd2uqjp8Yz5QSoxrH5jQppgfWtWfKHVuk/Gcf7XfkCInWgVdu9nfVmmsLQI+uxBdOLD7nt3ieVvQ6w+jeSuUQIzjSMfaBoQkWQzXmemdSt3mIRcZVjLxa5gq3Oxk5IHb6Lbvpfj68B+BhVMvUyFdXXG8dpCV7jw1YRt1wWmwmleD2Ys8s4GvdM6VVUlf4nc5SPBuOV5S32WC1Cy+vVNnBY+2Siz1bGJ/M1Vqats=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199015)(82960400001)(122000001)(38100700002)(38070700005)(86362001)(26005)(8676002)(91956017)(4326008)(66446008)(66476007)(66556008)(71200400001)(66946007)(64756008)(76116006)(316002)(54906003)(7416002)(4744005)(110136005)(5660300002)(2906002)(4001150100001)(41300700001)(8936002)(6486002)(966005)(186003)(6506007)(2616005)(83380400001)(478600001)(6512007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlZUQ0dRWWRacGZySW9xT3hueTUrZWFkVTJWM3pkOVNhbjc4UzhnSjArcytu?=
 =?utf-8?B?T0V2V0VpWGp3SGJNak93WnBqZTRIUGtlRE9NZ0RJWkZZVWhyQzZQTjl3ZXNT?=
 =?utf-8?B?VjN0ZHNTWEFRRW5sb2lSdU1JSUpIQnlSSFo4TlFST09JK3Zzd0lRR0E5K21Y?=
 =?utf-8?B?QzIzRzJDLzZ6bEpWL1dCM2VjUW1vblpFcGlmK3FFZ3pZK0JRVjJESVBhOEZY?=
 =?utf-8?B?WmNIeFdvSCtvL000dktyOFNtUWt5QWZZRFA2ZmJ0cmdjVjJqbVF1bnBxb3dE?=
 =?utf-8?B?eUkzRGU4VkVSVENZWFZRYTFQK1h6QW92UENGQlVraWVJUHJDb2xpUnVUY1c3?=
 =?utf-8?B?RkdRMFg2aU9yK0EvVmE3NXpHellRRWxCdkoreHc0eWtyM3Z4WWRIaXcvZEx5?=
 =?utf-8?B?dFVGYlExMCsvWUhxcS8vOS9iQm82Q1pvMjlCMEpWM2E0UWl3NkdxYXJLdXBz?=
 =?utf-8?B?Q3YvUDJWcHdjbllralBzaXltbUxzQ1lwd05IRTNMV3ZXVFdFS3pxSkFIYk1k?=
 =?utf-8?B?VlNLUzB1TFROTEhZalhSSWRycGZGdlZic0tKMS9qak56Z05ZTkRseURYdTdM?=
 =?utf-8?B?a2VFMWdLUmhOMjRWSXpjVFhYUUplYlRWRHcrdFM0MVp2TUNidHBveGNtcURs?=
 =?utf-8?B?c0ZvaFNZb0REWjV4djJPclVERjlycTE3T1pXVzk2bURsU0ZpbVpQaG9FeUY3?=
 =?utf-8?B?N0JzY2N4MU9VUEZhWENSckdFMHhNRU83TWcvRkMzRm00dnRUNDJ0c1hnMUsz?=
 =?utf-8?B?M2lsSCtzK2N4ZytqUWJEc0U4amZEaTIyaUM4MmZNZHkzWGZUZ0pEaXFsV25J?=
 =?utf-8?B?ZnlKOUlJYjV4azg1S0FoTDdaNHIwMjcveGRaOWdtazVnYlFINlEralN6WUZE?=
 =?utf-8?B?NWZNYWlJOGpLR1NLU2xqRnF2d2tZZWNSY3JvY2FHcUNTUE9waXMwd2Y2V0NG?=
 =?utf-8?B?MkxNMmV4bUFOVUtJUnpmRS9YMzZ3c1hESkY4M3EzdHlXTjcvRFhtR1lzaVhV?=
 =?utf-8?B?TW5ERGdrTElhbDBVOWRISmlhSHBXR3E2ckRhNEJ6dWM1WVpwUWx5bXhhZ2Rw?=
 =?utf-8?B?MlM4c0k4aGgzYm5XRjdJNzhaaU1rRlIzczBkOTZRTGNGNkVlaVRBa2Z3akhl?=
 =?utf-8?B?Z0NMOHk0NkRGbHJiQWMxbTd5cXlGTFNVaEJtQXppMmIybUhOcDVXdWtRVWVT?=
 =?utf-8?B?RmgxTTVqNW1lRGNFQW9BS2t4ZnlaaVpWZ0lFVXlLSXBROHJ4eWxmOEFYREx3?=
 =?utf-8?B?WGU0YTR2VG05VkFSUER3ZWMrNHh5SUg5TTBqYXZtbE12d2p4TEZkNmhFZmRZ?=
 =?utf-8?B?eUJtNUV0NXZoQjdVS3dHb290TGNpaGVmMHcwOFRXSXBwSkRNTkIyR0ZkMUNv?=
 =?utf-8?B?WnRqNVBnRkc5eHN2QjJ0NEdnR2tEVk1hMVlQK2dydGdvL1JsdE1tNnk4ZEFw?=
 =?utf-8?B?ZncvbFR3bmlzc3BQTmxHQ2pJMkZKUnRzNzQzM0dpeUxVSkY0MGNnaHBSL1hN?=
 =?utf-8?B?eWl3bFRDWElTMFlEZmhzdjNGYnhjam9wbVZzb0liV3BaL3JaMDg5NFhObjZv?=
 =?utf-8?B?eldKYmhQQXNkaWVYQ0svK2MvdW5rbllyUlMrRm1ZSFlXeHdTVGsrakJ2d2Iz?=
 =?utf-8?B?TXRGMnBrdEFNdThKOGNCRnB5WEozcW14SFJBWTNpTDliRTNwOXR0S1VtK0tw?=
 =?utf-8?B?d3c2K3dJcnVyTlhkYjF3UUIvMXh3aW5VNndDRUY0cXFrck9FMmxaYnhjR1dO?=
 =?utf-8?B?MmlzZFFnYVJXTEhySFpXVXlMWjhpelVkeVJnNWltL1JZUWthZEtHSC9zeGlE?=
 =?utf-8?B?Ry9UK3NsTGp0TnlqYS9EQmo1VTh0YVNpRkRKY3BlUFUxbXN3QTVtazcwQ0R1?=
 =?utf-8?B?c3hRclNadEdpTmlLZ0FGV0ZTUUZnNTZyZFNNeHk1TFA5TEN5TEFqRmNUNTNr?=
 =?utf-8?B?OGRrMGhMU3RRckV0VStwN1RsNC9FZ3d6czdvWElhZHE2dkFUT24rQ1Q1cEZ2?=
 =?utf-8?B?eTUzUEhDSEhnU2t4QUJoT1NCdTl6NjBWU0kzdkRqK0pGaHRXT3hKUkQ4SEQr?=
 =?utf-8?B?OWRxam01OHdYL0RmbEZCN25ocEIvZXJUTVIyQVUvTXJXcFRFSjZFZS9iWURh?=
 =?utf-8?B?VEc4VkkwVk1LRC9GdWtUeUdJc0R4amhybjlwSzV6bmNrdTNqMktEazgrUkNY?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFF0A2D5429D514BA166FA859BA77B79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5d9485-ab73-42d0-2c8a-08dace13c738
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 12:02:36.7925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBnDloKa2rfuaJMffNZ7XtLglEE1kxQN8xItrPj02QXVfh2xaEvDzC97zUJDECWLe2oxsocfMkcO7Et0dUBQag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDE0OjE3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
Rmlyc3QsIEkgdGhpbmsgJ3RkeF9zeXNpbmZvJyBzaG91bGQgcHJvYmFibHkgYmUgYSBsb2NhbCB2
YXJpYWJsZSBpbg0KPiBpbml0X3RkeF9tb2R1bGUoKSBhbmQgaGF2ZSBpdHMgYWRkcmVzcyBwYXNz
ZWQgaW4gaGVyZS7CoCBIYXZpbmcgZ2xvYmFsDQo+IHZhcmlhYmxlcyBhbHdheXMgbWFrZXMgaXQg
bW9yZSBvcGFxdWUgYWJvdXQgd2hvIGlzIGluaXRpYWxpemluZyBpdC4NCg0KU29ycnkgSSBtaXNz
ZWQgdG8gcmVzcG9uZCB0aGlzLg0KDQpVc2luZyBsb2NhbCB2YXJpYWJsZSBmb3IgJ3RkeF9zeXNp
bmZvJyB3aWxsIGNhdXNlIGEgYnVpbGQgd2FybmluZzoNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGttbC9hNjY5NGM4MWI0ZTk2YTIyNTU3ZmQwYWY3MGE4MWJkMmMyZTRlM2U3LmNhbWVsQGlu
dGVsLmNvbS8NCg0KU28gaW5zdGVhZCB3ZSBjYW4gaGF2ZSBhIGxvY2FsIHZhcmlhYmxlIGZvciB0
aGUgcG9pbnRlciBvZiAndGR4X3N5c2luZm8nLCBhbmQNCmR5bmFtaWNhbGx5IGFsbG9jYXRlIG1l
bW9yeSBmb3IgaXQuDQoNCktWTSB3aWxsIG5lZWQgdG8gdXNlIGl0LCB0aG91Z2guICBTbyBJIHRo
aW5rIGV2ZW50dWFsbHkgd2Ugd2lsbCBuZWVkIHRvIGhhdmUgYQ0KZ2xvYmFsIHZhcmlhYmxlIChl
aXRoZXIgdGR4X3N5c2luZm8gaXRzZWxmLCBvciB0aGUgcG9pbnRlciBvZiBpdCkuICBCdXQgdGhp
cyBjYW4NCmJlIGRvbmUgaW4gYSBzZXBhcmF0ZSBwYXRjaC4NCg0KQ01ScyBjYW4gYmUgZG9uZSBp
biB0aGUgc2FtZSB3YXkgKEtWTSBkb2Vzbid0IG5lZWQgdG8gdXNlIENNUnMsIGJ1dCBwZXJoYXBz
IHNvbWUNCmRheSB3ZSBtYXkgd2FudCB0byBleHBvc2UgdGhlbSB0byAvc3lzZnMsIGV0YykuDQoN
CldoYXQncyB5b3VyIHByZWZlcmVuY2U/DQo=
