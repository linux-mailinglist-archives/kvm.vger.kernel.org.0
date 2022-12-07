Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1FD645937
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiLGLsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 06:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiLGLrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 06:47:53 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C45B859;
        Wed,  7 Dec 2022 03:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670413664; x=1701949664;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=azEKOvVZpVTY7JQoPuQixcDUAMCCEgexcwGnUTj5Z14=;
  b=SCXtDD93zOEUgo+iZm5alZ+0ZyGO2tq9HKemdfsSRffo/9/G1YNjgco/
   /qIeUUTPXv30MZaq5gZ/3Y6QjTGIHxqhxj9qNZtl6ZPYrjpOV8WY3Z+St
   Az81DNkTMHx2lgR9Ab5kOl4SvmfRv5DuXAnTzFHzD51HyJU9Z2UujPjj8
   +GJr8/4JD5vHFQkagf+QpnyGE0jSNHETIxXddS5Z81l3euN7HVifd8Prb
   CjdmXm4S1ZoTLP5FPAqXIIqHePO27ETBZSXsZ0zrH2XgmMT+oge5e2QmS
   O+5T6DMEvfxThcEZJGxyQroNRJ39uAZqgYc4Llgw4dbvcJu9hc1ECUelh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="379038795"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="379038795"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 03:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="710038369"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="710038369"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2022 03:47:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 03:47:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 03:47:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 03:47:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 03:47:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsYw+J7gs5VoFMu7qpWjxfXmhta+5PYGf1a6a+tPkqC7t196yGXPAwNdbx+jTma3IHjZbkoeKmkutXGhwgydB/dG6FCPbihcrPECRi3wHCyRnSh1P/UIn7pTCwxbmGFJG3RZQ7BBXk078h54sYbMJG0iwrN33L8mAjXLva0lndKBuPnQb3zKBhY6VwKJ1ECFubsUep2er8JLDt/632a2tHuGBCHUnR3yVsK3RwMUu/+z4hdAIzBDRKicyZ0xd6fTlMnymk/oeki/z1FL4kkcakRKXc7VpQJJZqK2g88xq4yyCSBX/q019uuX0W5GHmuwvAEdnMZhk/cpUyuXGsXP4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azEKOvVZpVTY7JQoPuQixcDUAMCCEgexcwGnUTj5Z14=;
 b=hSZP60bVB6pICkd/S139+yfhWynY6EoOC/Ko4QcXqKaCh8uktTbgDJRPEg+2VLqBm/gnfOrf7cnO19Be12zyAMkK9pkK6wj6ykTZlNc35EL47qvLJ76m182QXZ7y3G8hHBu+QdPim2+GqtAGgrr3P486Q+hdZxhesu/tyrqHcp5pjwyYCydTYOl4ZnIPn5dV+KC8eHF0R2JiJoJQReuU5PAXV2CpRxP8CB3FD6Guim4cTvKBt6Y9MIEnc5NbNOSyj9kSAjdfAnG4pWxIlSCeYUMVJ71KJM4I/Hi4JHEbx54lJOYuVaunDhDB0a8YQOU3KlJVSjJBM3PiYFXarJe0EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6897.namprd11.prod.outlook.com (2603:10b6:806:2a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 11:47:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 11:47:35 +0000
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
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYCABotngIAAaI+AgAAB1QCAAAiegIANa7YA
Date:   Wed, 7 Dec 2022 11:47:35 +0000
Message-ID: <98935273b05feb55fc52c69a48d31018e0124e58.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
         <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
         <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
         <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
         <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
         <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
In-Reply-To: <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6897:EE_
x-ms-office365-filtering-correlation-id: e7ebb3f2-2a42-405b-6d97-08dad848d549
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H9C/5o2pJgXnOasUFyKGuYY1CxFPJuEQDWd3CqU/uVMtxqZdOu3PTbR0Mipv1vuMVoyW6agZxo/E1GxCQzw8/ozMCvUm533z9Ksd6jDX40dzYzaOfBgrCTgk7tEfIgO4wwh7pQNjR9jo5GiPlgMrFpNxTLqtOfbQZlyDmRWakQm+rzmG5zsSrR5ReVplqa/HnlVXNm67ZEwtCfDqubNUTU422UzpUZQuwCIauCLJwY2Tq3f0Ww1+r5O9FOG55SvrVvMgFy/kuxOhB5aICi6VzFfO8256YLO7FGcKi78JTG9xOEJRuvscb6GO16TMYp0OeSAo+1pBr55GIet2kMpx66XoO/TOp2C4kwfdAu97+XsIfZzSz1j3K1IViF6dN+nC4Mbni3wYNgchSQ+YEAbRjH0o9/j/lQqvZZw6U2Uc+vzmrkRVTfEy9X6ZJAFHxKBkQt5HzG+7snw3J85EWj62XK9GjQ7yjCWYt7a0QamL+rqPXnv1fPgLVAPxs7vpy0YJ9bYmvDmpV5I2fUiRfv7f8uWm+YOnRXyl+Nbf/5npSYsgdcv5WjkNRO68jSEAdnBCN6veOCRN1v8yJyyJocJN5p3cfyTH740Kl4co+L8zi8Eos//aaDsCTdZR9YEH5tk1QzIRt4TwNtJ9Jo/g2Dlsrw8G3DdauwKs0XO3IAi/MXGHjM9t5IZy5mEiOVMUUafOFciUiVgiCNzeB3C01oZXIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(41300700001)(2616005)(66946007)(64756008)(66476007)(66556008)(66446008)(122000001)(82960400001)(2906002)(38100700002)(36756003)(7416002)(38070700005)(8936002)(5660300002)(4001150100001)(83380400001)(6486002)(71200400001)(478600001)(110136005)(186003)(86362001)(54906003)(316002)(91956017)(4326008)(76116006)(6512007)(8676002)(6506007)(26005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEJqYmZLcHlSb2tncDNmZzAzUXcxbGhybzR0S3BWcEN5Ui9wVVpKWlEvWHBL?=
 =?utf-8?B?anVlWE10SzgvdnpFdG0zUTRjUTVXeElpMkQxVVlBUytCcmdwV0J3SEpENjA3?=
 =?utf-8?B?THR0bm4rRmtFL2ZqNW9wcGtXS3hSUEVHTnExcnJUek9mMzh1Mjc0NzlPSlp3?=
 =?utf-8?B?WHZ6Y3NNS045M2ZQRkErR0F2Mmk1Q1JnbkRNOW1TZnFPVW1aYVRIZUpVMVlk?=
 =?utf-8?B?R2g0RFNDVnNqWlZsV2JVei9NMzR4djJTRkZKRGk3UFdTcU9LWVEwMGJ5Nkdy?=
 =?utf-8?B?dU1Zai9ydE4wbWU3dzQrSmp1N0c0SERGTGdRRTlFZVU5M2RpZzJOSXVCQThj?=
 =?utf-8?B?bVZSUkUyZ0dxZ09QczZMdUp5UnZUUTlCM295RkFuenlBM2tvT1B3cWp3YlB0?=
 =?utf-8?B?ckd4RThiZUM2RlRqR1plQnNoSDFmU2JPRkJYTnV5U0E1OVNiVitNS3VGNjdT?=
 =?utf-8?B?dWEvMkw3Mzljbk1YQXlsT2Z3eVpJU0tmYUczTkVIUFdubWpqNWZEcFpuaHRx?=
 =?utf-8?B?cFpNYndDdEpST0MrWG05N3dUZWplM2NJQWRLSGhvbnFzYlpNeWk1b3pGUHhD?=
 =?utf-8?B?SEtEdzJYMEZZRnFRMU9QVytUQmxZZ0w5T3JrSm44YWZSMmRqOHVwYnZ5MlB5?=
 =?utf-8?B?UU1JSmtYd1AyLy9KUlBSSG5razdzempLa0VLbFZVRWYweS82Q3IwVmRkbGRw?=
 =?utf-8?B?QUNvYnFwSmtGNFlpaU1zL1JoY2tPNUpyeDRDY1BaVTF5RFBwOFJoekh0aDdk?=
 =?utf-8?B?ajlhWVhlbVhocCtSWFFWcEd4a2NGa3U3b2xhbFRwMnIyL2JNZmJDNUlZaGUx?=
 =?utf-8?B?YTlQY25QWmVMWUwvd3laRDR6dER6UUovZHJpeTJENzdYa05DVVNtQTRKS3RN?=
 =?utf-8?B?N1ZqcmV1Rlo1bzE1OWZudDdONUZqeENqeGNvU1hMaDdhczVhTWhqdHZmN2gr?=
 =?utf-8?B?Q1NoM3p4TGM4REJQRWg3am0zQVJWdnQyUmsxQlQ5bnF4STArcjhLUnUzUm5B?=
 =?utf-8?B?bWpvQ3RDVUlUT3MxWHNoQjBablRVRVNCQm43cUVrVGI0eXViM1NGWGR5c2x1?=
 =?utf-8?B?NCtwU05YRzB6SDhtKzRibjZJU0cwTU9jOFl2bE1uZHdYYlhYMTk3STRQZFBs?=
 =?utf-8?B?UExaWGdaQ3ZDZFFLMitBUUtMaTIvMVM3Y2NSV2w3dzNzMG9lb3FuWTNEblh2?=
 =?utf-8?B?RjhFZWk1UkNFdStnakxzbkxWWXFweUYxcGYxN0lGVitUdXlrTlREVytEUG1L?=
 =?utf-8?B?MXNaRVhkT01OM3BXV3RFRG1IWlluK3BtZThqUWZ4QkxmcUg4NVJGMDZCK2gz?=
 =?utf-8?B?aEkyQlNHYk04ejZZL2xKdVVrOENYUzZxK1JhMUNxajR1UXhhNUw5WFN5RmNG?=
 =?utf-8?B?WFVaemdwQjhQMXpBOGNuNmUzdFhvVDRPL25BalhPa3dWSFZnQ3gycWFFYmlC?=
 =?utf-8?B?MVgrZ2hzWVVpbWIzcWZxbytGdUVGbUhLeVh2MzlqeWpDaFkwZzRHdFRYTWZk?=
 =?utf-8?B?QXZwVU80VlZmUWF3TDJmeW5PQnpjRjJCNjdJbFpqQlE2TVJTT1dvdVZseFg3?=
 =?utf-8?B?R01JNXRUZUh5ZHhBNEs0R1MyQVhPb3RwK1NxZUFxUzRrT080SVc1cGxHM2tC?=
 =?utf-8?B?ZDErejRLeHZGZmlzcURhT0E4Q3Jja29PdXdEUXJlVGVqcnkvNWxiQTZuSkZn?=
 =?utf-8?B?QWgyVG9UNTh3Z25ocEJ6MHVlVlc5TkxaUUtsb0FuYldzRVBSeGtJK252M0lx?=
 =?utf-8?B?UXlGOVFSeXRqVURidzJEa0JQZTh2OWNncFAyUkd0cFN1enYzL1dQY0o0L1E0?=
 =?utf-8?B?d29nMk43WmxxVjVnK2JLV2ZPZk4wdm9INGZPZ3dhNjJmUWM1Yy9yZk4vSzNh?=
 =?utf-8?B?bEhZZm5TMDdnUlRyWGRhVEdyeXlOalFtMGtsYWdmTWF6a2lYTGNWR0lJKy9w?=
 =?utf-8?B?T2w1cGpWQytRNVFmc0I5elVyZkt1dGpGYk45dkpvdFJxam5Vd0FPWndKYXdQ?=
 =?utf-8?B?K0NNN1lpdVoyLzhXNmo1RDAva2NqK2VBRERtSmtXSnZBaVJLbWhxa1RrUlZX?=
 =?utf-8?B?Ull6dk1BNzNncE5qeEhuYUY4NW50TDBhOG5RZWd5czhkU2kya096dXZsSmRj?=
 =?utf-8?B?eU9leFNuSEdpN1JNS2ZJQzdEeUhsNHlDbjYvUCt3b3psTENFY051WEJkU2Yx?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <147697AD3AED0E438E81DEF1F1E35428@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ebb3f2-2a42-405b-6d97-08dad848d549
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 11:47:35.3638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vG+VAn8DbXnhgv+xkaVHqhaofmE/T9RaM+w9p43mfYKjgp14Sb9EZg6fCtx615in5XUZSnRgNA9FhKumFL+lLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6897
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTI4IGF0IDIyOjUwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjItMTEtMjggYXQgMTQ6MTkgLTA4MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiA+
IE9uIDExLzI4LzIyIDE0OjEzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gQXBvbG9naXplIEkg
YW0gbm90IGVudGlyZWx5IHN1cmUgd2hldGhlciBJIGZ1bGx5IGdvdCB5b3VyIHBvaW50LiAgRG8g
eW91IG1lYW4NCj4gPiA+IHNvbWV0aGluZyBsaWtlIGJlbG93Pw0KPiA+IC4uLg0KPiA+IA0KPiA+
IE5vLCBzb21ldGhpbmcgbGlrZSB0aGlzOg0KPiA+IA0KPiA+IHN0YXRpYyBpbnQgaW5pdF90ZHhf
bW9kdWxlKHZvaWQpDQo+ID4gew0KPiA+IAlzdGF0aWMgc3RydWN0IHRkc3lzaW5mb19zdHJ1Y3Qg
dGR4X3N5c2luZm87IC8qIHRvbyByb3R1bmQgZm9yIHRoZSBzdGFjayAqLw0KPiA+ICAgICAgICAg
Li4uDQo+ID4gICAgICAgICB0ZHhfZ2V0X3N5c2luZm8oJnRkeF9zeXNpbmZvLCAuLi4pOw0KPiA+
ICAgICAgICAgLi4uDQo+ID4gDQo+ID4gQnV0LCBhbHNvLCBzZXJpb3VzbHksIDNrIG9uIHRoZSBz
dGFjayBpcyAqZmluZSogaWYgeW91IGNhbiBzaHV0IHVwIHRoZQ0KPiA+IHdhcm5pbmdzLiAgVGhp
cyBpc24ndCBnb2luZyB0byBiZSBhIGRlZXAgY2FsbCBzdGFjayB0byBiZWdpbiB3aXRoLg0KPiA+
IA0KPiANCj4gTGV0IG1lIHRyeSB0byBmaW5kIG91dCB3aGV0aGVyIGl0IGlzIHBvc3NpYmxlIHRv
IHNpbGVudCB0aGUgd2FybmluZy4gIElmIEkNCj4gY2Fubm90LCB0aGVuIEknbGwgdXNlIHlvdXIg
YWJvdmUgd2F5LiAgVGhhbmtzIQ0KDQpIaSBEYXZlLA0KDQpTb3JyeSB0byBkb3VibGUgYXNraW5n
Lg0KDQpBZGRpbmcgYmVsb3cgYnVpbGQgZmxhZyB0byBNYWtlZmlsZSBjYW4gc2lsZW50IHRoZSB3
YXJuaW5nOg0KDQppbmRleCAzOGQ1MzRmMmMxMTMuLmY4YTQwZDE1ZmRmYyAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC9NYWtlZmlsZQ0KKysrIGIvYXJjaC94ODYvdmlydC92bXgv
dGR4L01ha2VmaWxlDQpAQCAtMSwyICsxLDMgQEANCiAjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wLW9ubHkNCitDRkxBR1NfdGR4Lm8gKz0gLVdmcmFtZS1sYXJnZXItdGhhbj00MDk2
DQoNClNvIHRvIGNvbmZpcm0geW91IHdhbnQgdG8gYWRkIHRoaXMgZmxhZyB0byBNYWtlZmlsZSBh
bmQganVzdCBtYWtlIHRkeF9zeXNpbmZvDQphbmQgdGR4X2Ntcl9hcnJheSBhcyBsb2NhbCB2YXJp
YWJsZXM/DQoNCkFub3RoZXIgcmVhc29uIEkgYW0gZG91YmxlIGFza2luZyBpcywgJ3RkeF9nbG9i
YWxfa2V5aWQnIGluIHRoaXMgc2VyaWVzIGNhbiBhbHNvDQpiZSBhIGxvY2FsIHZhcmlhYmxlIGlu
IGluaXRfdGR4X21vZHVsZSgpIGJ1dCBjdXJyZW50bHkgaXQgaXMgYSBzdGF0aWMgKGFzIEtWTQ0K
d2lsbCBuZWVkIGl0IHRvbykuICBJZiBJIGNoYW5nZSB0byB1c2UgbG9jYWwgdmFyaWFibGUgaW4g
dGhlIHBhdGNoDQoieDg2L3ZpcnQvdGR4OiBSZXNlcnZlIFREWCBtb2R1bGUgZ2xvYmFsIEtleUlE
IiBsaWtlIGJlbG93Og0KDQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisrKyBi
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KQEAgLTUwLDkgKzUwLDYgQEAgc3RhdGljIERF
RklORV9NVVRFWCh0ZHhfbW9kdWxlX2xvY2spOw0KIC8qIEFsbCBURFgtdXNhYmxlIG1lbW9yeSBy
ZWdpb25zICovDQogc3RhdGljIExJU1RfSEVBRCh0ZHhfbWVtbGlzdCk7DQogDQotLyogVERYIG1v
ZHVsZSBnbG9iYWwgS2V5SUQuICBVc2VkIGluIFRESC5TWVMuQ09ORklHIEFCSS4gKi8NCi1zdGF0
aWMgdTMyIHRkeF9nbG9iYWxfa2V5aWQ7DQotDQogLyoNCiAgKiB0ZHhfa2V5aWRfc3RhcnQgYW5k
IG5yX3RkeF9rZXlpZHMgaW5kaWNhdGUgdGhhdCBURFggaXMgdW5pbml0aWFsaXplZC4NCiAgKiBU
aGlzIGlzIHVzZWQgaW4gVERYIGluaXRpYWxpemF0aW9uIGVycm9yIHBhdGhzIHRvIHRha2UgaXQg
ZnJvbQ0KQEAgLTkyOCw2ICs5MjUsNyBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lk
KQ0KICAgICAgICAgICAgICAgIF9fYWxpZ25lZChDTVJfSU5GT19BUlJBWV9BTElHTk1FTlQpOw0K
ICAgICAgICBzdHJ1Y3QgdGRzeXNpbmZvX3N0cnVjdCAqc3lzaW5mbyA9ICZQQURERURfU1RSVUNU
KHRkc3lzaW5mbyk7DQogICAgICAgIHN0cnVjdCB0ZG1yX2luZm9fbGlzdCB0ZG1yX2xpc3Q7DQor
ICAgICAgIHUzMiBnbG9iYWxfa2V5aWQ7DQogICAgICAgIGludCByZXQ7DQogDQogICAgICAgIHJl
dCA9IHRkeF9nZXRfc3lzaW5mbyhzeXNpbmZvLCBjbXJfYXJyYXkpOw0KQEAgLTk2NCw3ICs5NjIs
NyBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KICAgICAgICAgKiBQaWNrIHRo
ZSBmaXJzdCBURFggS2V5SUQgYXMgZ2xvYmFsIEtleUlEIHRvIHByb3RlY3QNCiAgICAgICAgICog
VERYIG1vZHVsZSBtZXRhZGF0YS4NCiAgICAgICAgICovDQotICAgICAgIHRkeF9nbG9iYWxfa2V5
aWQgPSB0ZHhfa2V5aWRfc3RhcnQ7DQorICAgICAgIGdsb2JhbF9rZXlpZCA9IHRkeF9rZXlpZF9z
dGFydDsNCg0KSSBnb3QgYSB3YXJuaW5nIGZvciB0aGlzIHBhcnRpY3VsYXIgcGF0Y2g6DQoNCmFy
Y2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYzogSW4gZnVuY3Rpb24g4oCYaW5pdF90ZHhfbW9kdWxl
4oCZOg0KYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jOjkyODoxMzogd2FybmluZzogdmFyaWFi
bGUg4oCYZ2xvYmFsX2tleWlk4oCZIHNldCBidXQgbm90DQp1c2VkIFstV3VudXNlZC1idXQtc2V0
LXZhcmlhYmxlXQ0KICA5MjggfCAgICAgICAgIHUzMiBnbG9iYWxfa2V5aWQ7DQogICAgICB8ICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+fg0KDQpUbyBnZXQgcmlkIG9mIHRoaXMgd2FybmluZywgd2Ug
bmVlZCB0byBtZXJnZSB0aGlzIHBhdGNoIHRvIHRoZSBsYXRlciBwYXRjaA0KKHdoaWNoIGNvbmZp
Z3VyZXMgdGhlIFRETVJzIGFuZCBnbG9iYWwga2V5aWQgdG8gdGhlIFREWCBtb2R1bGUpLg0KDQpT
aG91bGQgSSBtYWtlIHRoZSB0ZHhfZ2xvYmFsX2tleWlkIGFzIGxvY2FsIHZhcmlhYmxlIHRvbyBh
bmQgbWVyZ2UgcGF0Y2gNCiJ4ODYvdmlydC90ZHg6IFJlc2VydmUgVERYIG1vZHVsZSBnbG9iYWwg
S2V5SUQiIHRvIHRoZSBsYXRlciBwYXRjaD8NCg==
