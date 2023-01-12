Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6906668E5
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 03:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbjALC0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 21:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbjALC0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 21:26:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79127B7DA;
        Wed, 11 Jan 2023 18:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673490368; x=1705026368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hRU/UJqEr/oWhkYlhSAs253+ykgL1pqlg8MhxeVfblw=;
  b=ff4FyIBIhWsKugkL26vzqCUyGlyfDMS7q89ZmsFDHCZAdGoDrFCfdZq5
   WIW48JwoxUDcZRJ+3shc8ENIWMCkmhVawZumVpPNnNVQ0O5EVH1vYlHr6
   e9XVj/2g69/8BG6sHQphU97/BgipCfa/XQ+1l4PMaC99mJcDc3sfOoDFx
   FpTysKC6kmOWJyEFZ/VFjcEg7verOzfTfUMnAlQcJHM3cW3zQKTRo0arF
   UBlGwSZPuFcNW6zIbpTT8DcftL7cqOZAgVGCi90zhiDx6gD8EveYgMNoC
   GQCeIFNT6+jjmM0azKszG3pedW5pBvy0bOy7FuILj8eNifmXvuMySgdXI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="409830693"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="409830693"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 18:22:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="688165704"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="688165704"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2023 18:22:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 18:22:10 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 18:22:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 18:22:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 18:22:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ5qZziqxATNhGmsdVuKyS201PiAQ2lmYsW6h0MWWnsws2/tiUYjkQZoILZXZh/qU/y9lLWZG0n/FMUHc05zXVyuCakK+HLCnS6qaibYVh5g5SAKDbJ60gR+foI4Nf/sTc73ChcWe1kGOH+ecY1D9vmJTMJ1aeBkRpezbTtYAwQGVlFE2tybHD6D0TMkyuRz/8qfN83hgQDH4F0TmbL8qrAe9rF6KjAeD97nnGyoUlbqjgI2G+raYML8dqcDAymrOp3XCjg/iiy3XyBB+TpoDRY3vAgZ1bObD34WOqH/LkmnJpep/e2k340o/ZPmuSTRv+t5eRYBjH6vhQA0gdZ9Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRU/UJqEr/oWhkYlhSAs253+ykgL1pqlg8MhxeVfblw=;
 b=YPJkqsYFPfk899dxyWKNDV+LXdclE9NnypWZIxfc+tUCFwbcHLYYYObCd+8eWdSBnstal00ogox1flnyivYlRgwh7+3dDt3UgJSqMO8KhVvFNiwH2ciMVuS6mVnl16GV+x/XIUIQ8fN35nQ5eSIIzm9t0dBLQXGW0p5McBX6ab2krgx9yCnP4XjrXW4Ls2F9PpD/O49dVzoUuBIWphhtTAOXUs21nt0Q2U3TRijObNz5x4TYGK2L5+FZmYT+f1tSEusmMr6qi6VYaMDWzBBbnc7M9tci3PidJQ9AjGMIxxkDFlLE3RNyx18t29AZ2c3sX4lcjM1zlVbRxoawsghucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by MN6PR11MB8170.namprd11.prod.outlook.com (2603:10b6:208:47c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 02:22:06 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 02:22:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66R31QAgARKC4CAAFSjAIABQ4mAgABFsgCAASiJAIAA+shEgAAF8YCAAAuZpYAABguA
Date:   Thu, 12 Jan 2023 02:22:06 +0000
Message-ID: <125f22b741f780ef46089ac6a8f70c4d148d4ba5.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
         <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
         <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
                <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
         <16f23950-2a27-29de-c0b4-e5f2d927c8b4@intel.com>
         <13096e4e39801806270c3a6a641102a8151aa5fc.camel@intel.com>
         <871qo0y3i3.fsf@yhuang6-desk2.ccr.corp.intel.com>
         <ea87e343f7f6b75a98e65d573a0182377994d1e6.camel@intel.com>
         <87wn5swm19.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87wn5swm19.fsf@yhuang6-desk2.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|MN6PR11MB8170:EE_
x-ms-office365-filtering-correlation-id: c55b4872-c190-4f9d-8524-08daf443cd0c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V+S6nYxKsT5jErESjLePh7XPTTLzTaZYsMyr+pvZ6b1XI8v7Fh4xPno43n724xBZySr8DLqxtCrO8+oxjglZXMz1W114yTjcFzLCcOc+rHU67jUa+1xCDuOjANM2o4hIard3xu+FsUvy/w2TeRgGSORMvGWUu855JmwZ1aVD98bw96F2zx/xix/N2GuzLtF72AAZ/KG7tNooFfI04PT5Laif6n+3T8Kncnmk8fqTBem3mW4+ztmeK08RE9+E1cjjG3AUAQD4exijU9FWb1Eq1Hg7yb4+46cQljJ4W9vq6d78Mz4aGkqUw3yADoiyACYgmtB+1eVAcS0l6vJ+W1RWWz0y0+nhlLA0YYrEBhsKanLk9N03Qvy52zfyu6hawKtkGkgKtqgaOV/FD4LiD81ybtuJzjM+7hrcCFUOkTTZozypZw2VIyP3/e9YwGDiKAKz9QB5Juye+99+F/KKGECi1XeH4cLw9Ao2lGeXjJy5yQdKEiuwI2TxkLfl2743yTNfpbutcvBSqId3bOAHTRWG1mCHWKtFFfOQlyKwyrzphwmQwshOP1g102V6QyL+5h0ojl/oguwkK/WtjUq2x3CBMN5QvzueRcMD3OU3G/p69tXkyPSCo6z7DhDY9JWbuSwl+SFw2QF9SWSkvahVqDJWisT9X+34kGcbFwmUSiJxunBsIkhTZYT/FdOPc/noQh8nTpwfuYfj7A36NRbKgEyn7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199015)(54906003)(66899015)(2906002)(6636002)(66946007)(5660300002)(6486002)(6862004)(7416002)(36756003)(86362001)(8936002)(4326008)(316002)(38070700005)(66556008)(76116006)(66446008)(64756008)(8676002)(66476007)(82960400001)(122000001)(37006003)(38100700002)(6506007)(53546011)(83380400001)(41300700001)(71200400001)(2616005)(6512007)(186003)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emF0VW9MWkdCbElLNU9SZTEzUTFxdHQxYkFwZjZwZDhHTHY1KzY4allUclAv?=
 =?utf-8?B?TCtiblNNYmRHaGd2bUQzcG9DZmQwT3RtZkVVcFE1a0hnM283Uk5IRUFPcmVu?=
 =?utf-8?B?VkMrR1pJVlZKMGc4ZGhtb0V4czhEQms1ZHJ1Q2VyVnhVVi9mMXdQT1FuRUpZ?=
 =?utf-8?B?cGlxZHNiSkZkYlU1WkpYQW5ORVhTNUlKc1FBdTdhS0ZFeWRRK25nMWlBMTBW?=
 =?utf-8?B?ZmRFU3VhSmZ4V0tkNm9WT1hjUnFOaXZ0eUN6TjZLdlRUU2lMODFWcjAwUjk2?=
 =?utf-8?B?YmJDVnhMbE9aUy9RclkyRURGek0wM2owK1VmRnE0cHZYVGY4WEsza2txUjk2?=
 =?utf-8?B?R2V1ZUgyaU9Vczc2S3RSUGl0ZTNkYXVUMzR5VjRyT0l5TTU3Y2xpaWtPYnMy?=
 =?utf-8?B?eDVoTVpJeEVDaHlJVllWNFF0RUhlNGhzeWdYUEsydDNqd2ZwTGhFdEJNOWdo?=
 =?utf-8?B?NWlpektUUjZUSTN1Qno3Z1JnZFMrUFFjY1lGcEczczhrRUQrRU9jSzBacVV5?=
 =?utf-8?B?bXFuUWpQODBYTFY4OHBwQURTTUFrcFNwQWRGdk5HZE8xc0lteTZ4V0VJbk1a?=
 =?utf-8?B?dGhoakttQ3pYYmw3SGtLcW1Lc1dUUVBPaE1yZVJnWEgxR0ZYVDFjM215cHZw?=
 =?utf-8?B?TmIvSlk2S25adEswbW9UbnRpRVZjYXhhOWkxTjN5RXorUEdNdElwVWlVT1Y2?=
 =?utf-8?B?L3FTdDdSQitXMzZ4YlJGUjBGcXpFRlFRQllNZ2YwVEtrYzFTd3o0WHJ4MWJq?=
 =?utf-8?B?M2JQR1Y0M2l3V0ZYS1JIejlENDd5OWhWTFdBYWJ3dlVqTWdmRXJGZVBuL0RY?=
 =?utf-8?B?RFliaEQ1ZWNNRUlDN05CWjdkUzdMT2FyWXlvNVI4bFBZZExJdVFsZUo3MXdW?=
 =?utf-8?B?cmdETmxHUG9TR3Bob0FLSmNOeGRiVGVSaWFhQVVXTmYrc1BEbjhYekZLT2Z0?=
 =?utf-8?B?MnR6RE9zM3U0SXhiZU9MUEd5UDRYYW0vbnIyRGtRdHpySld0MXV0OUZWdEMv?=
 =?utf-8?B?WWo1clpyY05hZHlKRjk0UmZybnRDYVVDL3F1by9GdDBFaU5WRXVqcFBtTDNJ?=
 =?utf-8?B?VWxZTUdJZHFnY1J6RXkvcDBYdFR6WXZvakpRemlGcWIzWmNrblZNNWQyVXZB?=
 =?utf-8?B?U1RybFZtZUxsMUpoOUFnQlhVWnZMcFlJZVBnMllaWGgyQVJ0Z1dRNlN4UXdT?=
 =?utf-8?B?VmZjZFFkeXM3TklXTEsrNGNXcjhsSXQvWEJiUDF1NzhLUnpmV2U4Z1RkRnhV?=
 =?utf-8?B?dDVYYnlGWWpYOHVvbmtTVWY4ZSsxaG9paXJFQUlNNWpORVdVb2dSVkVHM3FT?=
 =?utf-8?B?UEh4aGJodXZoWDRINWRiOHZydStjZWdiQlBRL0txSGxOa3Bvcm52T1NKTW9H?=
 =?utf-8?B?UVM3MW9KUmsxTVV3VzJyYWNvdGh6YUtlQUVtV3g3YWVnaWVVbDhuMFdYRmRy?=
 =?utf-8?B?Z1dEZXRjc3N0NkZnNU9hTUxYaFA4Q2NnbG5Na1Y1Wnp4VFRKdEMzUm5OVnQ3?=
 =?utf-8?B?YVdySm5HTDA0RVovRzhxSXVBZEJjcWl4RDBOZVVUa1o0QkpnSzlGODB1dGhX?=
 =?utf-8?B?Z0ZGWWgwaUs4N054YUVOVHNFMUR3TFRaRUc2akFRcHkzQmhDNUdRSFJ3RzFJ?=
 =?utf-8?B?L2Q5U013R0M3Ny9xZjV2WlFTdk83Q1BnN3daUzVoNzdVcFNKelEvOHBNM1cr?=
 =?utf-8?B?TGEyY1kzcG9ta0w0SDRQbWN4NU5pT0ZybFh1Y2p2ejBrMmJhejJyWDEzTStG?=
 =?utf-8?B?Z3o3L3lTNHVqcHBOT3FSa1ZBY0Z1U3hEVkhkbmtlTklDemJiS3gvcGg3Zk5q?=
 =?utf-8?B?NUZCYnMxQ2p1K0dxSGZKcVd6ZFZscnFYUW1qU2ozZmx6S1pNdlVmUFZsdlZu?=
 =?utf-8?B?bGpjdklYUkR0SWlpYjlibDVBMnM1Q0hCMnVVU2V3eUFMUkxIc3M3QXUwaXN2?=
 =?utf-8?B?U2hoM215OVVSYm01N2toR2VGbVJkZEFKRG1SdnBQN0NETk1HRlhVQWRpSktp?=
 =?utf-8?B?MEhiUFI3QXRQbGJ2Z3IzRXViK2dCRklqRGczTEQ2VWZVWTg0MXI4ME1qZUZj?=
 =?utf-8?B?bGppa3B5RWd5bUVRQ1N6MFNMelpDakw5UnF4TUJlRW8reC9Vc0w4SHFnUTNq?=
 =?utf-8?B?ZDZzeGlqVnJXZHVxWGluME43a3dSek1iWVVUdkdzSXRsS2F6T0JjYXluRHFh?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4A98C4EA818F64FACEC1C3D7E74D274@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c55b4872-c190-4f9d-8524-08daf443cd0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 02:22:06.6326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbGPtPZ73H5GH8Xy6cMc0cHyKHrzowWNQMpIQCbTwrgZjywJai7IuWJ2VYDt7J0M4egkIcXtIU4SKuGV9dNu3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8170
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA5OjU5ICswODAwLCBIdWFuZywgWWluZyB3cm90ZToNCj4g
Ikh1YW5nLCBLYWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cml0ZXM6DQo+IA0KPiA+IE9uIFRo
dSwgMjAyMy0wMS0xMiBhdCAwODo1NiArMDgwMCwgSHVhbmcsIFlpbmcgd3JvdGU6DQo+ID4gPiAi
SHVhbmcsIEthaSIgPGthaS5odWFuZ0BpbnRlbC5jb20+IHdyaXRlczoNCj4gPiA+IA0KPiA+ID4g
PiBPbiBUdWUsIDIwMjMtMDEtMTAgYXQgMDg6MTggLTA4MDAsIEhhbnNlbiwgRGF2ZSB3cm90ZToN
Cj4gPiA+ID4gPiBPbiAxLzEwLzIzIDA0OjA5LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiA+
ID4gT24gTW9uLCAyMDIzLTAxLTA5IGF0IDA4OjUxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToN
Cj4gPiA+ID4gPiA+ID4gT24gMS85LzIzIDAzOjQ4LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4g
PiA+ID4gPiA+ID4gPiA+ID4gVGhpcyBjYW4gYWxzbyBiZSBlbmhhbmNlZCBpbiB0aGUgZnV0dXJl
LCBpLmUuIGJ5IGFsbG93aW5nIGFkZGluZyBub24tVERYDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4g
PiBtZW1vcnkgdG8gYSBzZXBhcmF0ZSBOVU1BIG5vZGUuICBJbiB0aGlzIGNhc2UsIHRoZSAiVERY
LWNhcGFibGUiIG5vZGVzDQo+ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBhbmQgdGhlICJub24tVERY
LWNhcGFibGUiIG5vZGVzIGNhbiBjby1leGlzdCwgYnV0IHRoZSBrZXJuZWwvdXNlcnNwYWNlDQo+
ID4gPiA+ID4gPiA+ID4gPiA+ID4gPiBuZWVkcyB0byBndWFyYW50ZWUgbWVtb3J5IHBhZ2VzIGZv
ciBURFggZ3Vlc3RzIGFyZSBhbHdheXMgYWxsb2NhdGVkIGZyb20NCj4gPiA+ID4gPiA+ID4gPiA+
ID4gPiA+IHRoZSAiVERYLWNhcGFibGUiIG5vZGVzLg0KPiA+ID4gPiA+ID4gPiA+ID4gPiANCj4g
PiA+ID4gPiA+ID4gPiA+ID4gV2h5IGRvZXMgaXQgbmVlZCB0byBiZSBlbmhhbmNlZD8gIFdoYXQn
cyB0aGUgcHJvYmxlbT8NCj4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiBUaGUgcHJv
YmxlbSBpcyBhZnRlciBURFggbW9kdWxlIGluaXRpYWxpemF0aW9uLCBubyBtb3JlIG1lbW9yeSBj
YW4gYmUgaG90LWFkZGVkDQo+ID4gPiA+ID4gPiA+ID4gdG8gdGhlIHBhZ2UgYWxsb2NhdG9yLg0K
PiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IEtpcmlsbCBzdWdnZXN0ZWQgdGhpcyBt
YXkgbm90IGJlIGlkZWFsLiBXaXRoIHRoZSBleGlzdGluZyBOVU1BIEFCSXMgd2UgY2FuDQo+ID4g
PiA+ID4gPiA+ID4gYWN0dWFsbHkgaGF2ZSBib3RoIFREWC1jYXBhYmxlIGFuZCBub24tVERYLWNh
cGFibGUgTlVNQSBub2RlcyBvbmxpbmUuIFdlIGNhbg0KPiA+ID4gPiA+ID4gPiA+IGJpbmQgVERY
IHdvcmtsb2FkcyB0byBURFgtY2FwYWJsZSBub2RlcyB3aGlsZSBvdGhlciBub24tVERYIHdvcmts
b2FkcyBjYW4NCj4gPiA+ID4gPiA+ID4gPiB1dGlsaXplIGFsbCBtZW1vcnkuDQo+ID4gPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gQnV0IHByb2JhYmx5IGl0IGlzIG5vdCBuZWNlc3Nhcmls
eSB0byBjYWxsIG91dCBpbiB0aGUgY2hhbmdlbG9nPw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+ID4gTGV0J3Mgc2F5IHRoYXQgd2UgYWRkIHRoaXMgVERYLWNvbXBhdGlibGUtbm9kZSBBQkkg
aW4gdGhlIGZ1dHVyZS4gIFdoYXQNCj4gPiA+ID4gPiA+ID4gd2lsbCBvbGQgY29kZSBkbyB0aGF0
IGRvZXNuJ3Qga25vdyBhYm91dCB0aGlzIEFCST8NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
UmlnaHQuICBUaGUgb2xkIGFwcCB3aWxsIGJyZWFrIHcvbyBrbm93aW5nIHRoZSBuZXcgQUJJLiAg
T25lIHJlc29sdXRpb24sIEkNCj4gPiA+ID4gPiA+IHRoaW5rLCBpcyB3ZSBkb24ndCBpbnRyb2R1
Y2UgbmV3IHVzZXJzcGFjZSBBQkksIGJ1dCBoaWRlICJURFgtY2FwYWJsZSIgYW5kICJub24tDQo+
ID4gPiA+ID4gPiBURFgtY2FwYWJsZSIgbm9kZXMgaW4gdGhlIGtlcm5lbCwgYW5kIGxldCBrZXJu
ZWwgdG8gZW5mb3JjZSBhbHdheXMgYWxsb2NhdGluZw0KPiA+ID4gPiA+ID4gVERYIGd1ZXN0IG1l
bW9yeSBmcm9tIHRob3NlICJURFgtY2FwYWJsZSIgbm9kZXMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gVGhhdCBkb2Vzbid0IGFjdHVhbGx5IGhpZGUgYWxsIG9mIHRoZSBiZWhhdmlvciBmcm9tIHVz
ZXJzLiAgTGV0J3Mgc2F5DQo+ID4gPiA+ID4gdGhleSBkbzoNCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiAgICAgICBudW1hY3RsIC0tbWVtYmluZD02IHFlbXUta3ZtIC4uLg0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IEluIG90aGVyIHdvcmRzLCB0YWtlIGFsbCBvZiB0aGlzIGd1ZXN0J3MgbWVtb3J5IGFu
ZCBwdXQgaXQgb24gbm9kZSA2Lg0KPiA+ID4gPiA+IFRoZXJlIGxvdHMgb2YgZnJlZSBtZW1vcnkg
b24gbm9kZSA2IHdoaWNoIGlzIFREWC0qSU4qY29tcGF0aWJsZS4gIFRoZW4sDQo+ID4gPiA+ID4g
dGhleSBtYWtlIGl0IGEgVERYIGd1ZXN0Og0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICAgICAgIG51
bWFjdGwgLS1tZW1iaW5kPTYgcWVtdS1rdm0gLXRkeCAuLi4NCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiBXaGF0IGhhcHBlbnM/ICBEb2VzIHRoZSBrZXJuZWwgc2lsZW50bHkgaWdub3JlIHRoZSAtLW1l
bWJpbmQ9Nj8gIE9yIGRvZXMNCj4gPiA+ID4gPiBpdCByZXR1cm4gLUVOT01FTSBzb21ld2hlcmUg
YW5kIGNvbmZ1c2UgdGhlIHVzZXIgd2hvIGhhcyAqTE9UUyogb2YgZnJlZQ0KPiA+ID4gPiA+IG1l
bW9yeSBvbiBub2RlIDYuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSW4gb3RoZXIgd29yZHMsIEkg
ZG9uJ3QgdGhpbmsgdGhlIGtlcm5lbCBjYW4ganVzdCBlbmZvcmNlIHRoaXMNCj4gPiA+ID4gPiBp
bnRlcm5hbGx5IGFuZCBoaWRlIGl0IGZyb20gdXNlcnNwYWNlLg0KPiA+ID4gPiANCj4gPiA+ID4g
SUlVQywgdGhlIGtlcm5lbCwgZm9yIGluc3RhbmNlIEtWTSB3aG8gaGFzIGtub3dsZWRnZSB0aGUg
J3Rhc2tfc3RydWN0JyBpcyBhIFREWA0KPiA+ID4gPiBndWVzdCwgY2FuIG1hbnVhbGx5IEFORCAi
VERYLWNhcGFibGUiIG5vZGUgbWFza3MgdG8gdGFzaydzIG1lbXBvbGljeSwgc28gdGhhdA0KPiA+
ID4gPiB0aGUgbWVtb3J5IHdpbGwgYWx3YXlzIGJlIGFsbG9jYXRlZCBmcm9tIHRob3NlICJURFgt
Y2FwYWJsZSIgbm9kZXMuICBLVk0gY2FuDQo+ID4gPiA+IHJlZnVzZSB0byBjcmVhdGUgdGhlIFRE
WCBndWVzdCBpZiBpdCBmb3VuZCB0YXNrJ3MgbWVtcG9saWN5IGRvZXNuJ3QgaGF2ZSBhbnkNCj4g
PiA+ID4gIlREWC1jYXBhYmxlIiBub2RlLCBhbmQgcHJpbnQgb3V0IGEgY2xlYXIgbWVzc2FnZSB0
byB0aGUgdXNlcnNwYWNlLg0KPiA+ID4gPiANCj4gPiA+ID4gQnV0IEkgYW0gbmV3IHRvIHRoZSBj
b3JlLW1tLCBzbyBJIG1pZ2h0IGhhdmUgc29tZSBtaXN1bmRlcnN0YW5kaW5nLg0KPiA+ID4gDQo+
ID4gPiBLVk0gaGVyZSBtZWFucyBpbi1rZXJuZWwgS1ZNIG1vZHVsZT8gIElmIHNvLCBLVk0gY2Fu
IG9ubHkgb3V0cHV0IHNvbWUNCj4gPiA+IG1lc3NhZ2UgaW4gZG1lc2cuICBXaGljaCBpc24ndCB2
ZXJ5IGdvb2QgZm9yIHVzZXJzIHRvIGRpZ2VzdC4gIEl0J3MNCj4gPiA+IGJldHRlciBmb3IgdGhl
IHVzZXIgc3BhY2UgUUVNVSB0byBkZXRlY3Qgd2hldGhlciBjdXJyZW50IGNvbmZpZ3VyYXRpb24N
Cj4gPiA+IGlzIHVzYWJsZSBhbmQgcmVzcG9uZCB0byB1c2VycywgdmlhIEdVSSwgb3Igc3lzbG9n
LCBldGMuDQo+ID4gDQo+ID4gSSBhbSBub3QgYWdhaW5zdCB0aGlzLiBGb3IgaW5zdGFuY2UsIG1h
eWJlIHdlIGNhbiBhZGQgc29tZSBkZWRpY2F0ZWQgZXJyb3IgY29kZQ0KPiA+IGFuZCBsZXQgS1ZN
IHJldHVybiBpdCB0byBRZW11LCBidXQgSSBkb24ndCB3YW50IHRvIHNwZWFrIGZvciBLVk0gZ3V5
cy4gIFdlIGNhbg0KPiA+IGRpc2N1c3MgdGhpcyBtb3JlIHdoZW4gd2UgaGF2ZSBwYXRjaGVzIGFj
dHVhbGx5IHNlbnQgb3V0IHRvIHRoZSBjb21tdW5pdHkuDQo+IA0KPiBFcnJvciBjb2RlIGlzIGEg
a2luZCBvZiBBQkkgdG9vLiA6LSkNCj4gDQoNClJpZ2h0LiAgSSBjYW4gYnJpbmcgdGhpcyB1cCBp
biB0aGUgS1ZNIFREWCBzdXBwb3J0IHNlcmllcyAod2hlbiB0aW1lIGlzIHJpZ2h0KQ0KdG8gc2Vl
IHdoZXRoZXIgS1ZNIGd1eXMgd2FudCBzdWNoIGVycm9yIGNvZGUgYXQgdGhlIGluaXRpYWwgc3Vw
cG9ydCwgb3IganVzdA0Kd2FudCB0byBleHRlbmQgaW4gdGhlIGZ1dHVyZS4gIFRoZSB3b3JzdCBj
YXNlIGlzIHRoZSBvbGQgUWVtdSBtYXkgbm90IHJlY29nbml6ZQ0KdGhlIG5ldyBlcnJvciBjb2Rl
ICh3aGlsZSB0aGUgZXJyb3IgaXMgc3RpbGwgYXZhaWxhYmxlIGluIGRtZXNnKSBidXQgc3RpbGwg
Y2FuDQpkbyB0aGUgcmlnaHQgYmVoYXZpb3VyIChzdG9wIHRvIHJ1biwgZXRjKS4NCg==
