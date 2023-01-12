Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0F6666854
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 02:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbjALBTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 20:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235746AbjALBTO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 20:19:14 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCC3C0FA;
        Wed, 11 Jan 2023 17:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673486353; x=1705022353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2dGp7TSfQnWhEFXnrMzSrsHl2nTks+5ZTgRkLAAkFtY=;
  b=nslT3h2gbj64Cru3/koCm2YFD3Z3tU1j2/qBcDMatlYqsWeAONL7KfCj
   Jt2WwYdW70WTKzXjT7MwU7NksFP0cghfmt1VNfrM0/WY/+rwI3pIexLdZ
   rttbKCzf+BESsZaUE+sSwwvzlwKU1dII9cWTiPOd57rxErkXcrdjibJYu
   6H+jERFFH8HkPxO4c77gVV5OXEG2OGpU+6veNqoLgxnkpvUF+Wi7//k9x
   LxhZSX2ENACQa742O8MnbEjhMdZqAVNJ2A5087RqMNxXtfXAYIEM0QAHl
   OdEEbLNXbJYadmMBE2I38OZ3QFtpRF25+ZZ/4k/RhtvjX0vMG5NHTh034
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="325600796"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="325600796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 17:19:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="831512105"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="831512105"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 11 Jan 2023 17:19:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 17:19:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 17:19:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 17:19:04 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 17:19:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hyz0weyRAKAAMI0Sa5t1huvjYPHErgup6eC/UtCiizHsIZSr3QUmZL+Pc9eDHh+tWuly7Q5IOR3zEtQMjykuNA7vpDecXW9LF1NnrLhTUvC89sIZzMYbSLV5fFb+bomdPqUhiiz9kMELO8zxi7wfWFXjfez58XDuvMx+e61KfQjW8v/KwFO4dYDbYEObc41+hsctDcQejxLIP9RBZ3sqvt6cG5x87RsrUngNUY4Gv0bTtluzJGEIXqmfxvbc1haHFSHIfoMW/opqr4LFJQZQLVmjoFvhCUcXbiVPrlBlW/7dtRr4kHs2sBlCyqJ315yJgk6n4sVWRT+HZSKPPcmlyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dGp7TSfQnWhEFXnrMzSrsHl2nTks+5ZTgRkLAAkFtY=;
 b=TF6JkjmlVgW67FgmGa70jtXu/BWOriiEI6tr3L7P+O+Aj6d26AYp1gTy0o3X8y5ejCjfUq2C8w5ETEqbZ52/yg/Pb3HauP+1a4a0T88NPjpAXx8xFdbORbjB6NHosHuDn+WY91rFex971BM14ssceQru72MazocxEB1UlNANHZPWlgpSKr+WgTU+Q0bIHKmX/h20f0LURtkUousKUGmTbo8CqF8rvw552ef88NKrTFRL5ppzwhtlk5mTGVcsoCTKBzdAkoNMxAlwMU/lb352Z5YwxmsS3wSgIE5etAPYvgfsx54fGAl8NMWvi/pCDAyynlGuA5HDgSXZ7m59SxP6HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB7334.namprd11.prod.outlook.com (2603:10b6:8:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 01:18:58 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 01:18:58 +0000
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66R31QAgARKC4CAAFSjAIABQ4mAgABFsgCAASiJAIAA+shEgAAF8YA=
Date:   Thu, 12 Jan 2023 01:18:58 +0000
Message-ID: <ea87e343f7f6b75a98e65d573a0182377994d1e6.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
         <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
         <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
         <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
         <16f23950-2a27-29de-c0b4-e5f2d927c8b4@intel.com>
         <13096e4e39801806270c3a6a641102a8151aa5fc.camel@intel.com>
         <871qo0y3i3.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <871qo0y3i3.fsf@yhuang6-desk2.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB7334:EE_
x-ms-office365-filtering-correlation-id: 3bca3bbe-132c-4b47-dc0b-08daf43afb5b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LmZNrseaaWMANEQvWQIEAuVEuZmTrLmEaHmWmGKRazggDMgMLGVdxYen1JxvTbhgeXET5LlS0z/hCR08Mjf1BgSbJDBgeik4cpUQCKqQF0qtsIwpjWCXaJ9Bx8tOBjSFCcj6lR/UngbKIYWNUs5oKSOOy3Aui7/6Jpo+VuIxaVldciv7/6PyfTpLksf3pKGhKMKeO9te16akaYI7CnVhvxPHDtyfqa5arkoQu6f9lyMoPkh8SixrjQvKfKBxkyHzY4OXnlWiC6vO6bKR239i1+fvDPaMvJrD4D51mlFPbxNOkxNcQdYukhSgqtyKu9fN/SBtZf4yVhN2bmyH9IfP/O5d2Wjh5U6wKPY9YMXn+CDz1g+/I00JHQFBALnl6S4efAzRaJkU+xMfU6E3iRSIZ7eDw6MIXyHnuo3pxVHrZ2wVpSAX2TIcn72Hy9QGQ0ORxFFq0l4IUgGAMRdUhsKCsUr3rekiswy2gP4CaJJumVNmeo2ueG+/4lZj1rRwj/xVwFWl+XbJ1d8YLtadBLkh5j5x4hJDX7M0g01WaejQ3IdIhlOkxNqgHkrLSLLIZgDRZCnKW8KjbCRmhcxAxEox6TXbLRRu6CPwT/g8mgD5PXLVaAbg2FSerUIlEeAnkmRAomc+H87BRct74C/oDs4c8UVqk/2KFHQJc75I12jSp/O5Gbj/pR1nKzx45Ps/wqsESpD1cvP/8Zu7X2qPk4jU/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199015)(66899015)(36756003)(91956017)(6636002)(66946007)(66556008)(86362001)(54906003)(38070700005)(8676002)(41300700001)(76116006)(66446008)(66476007)(64756008)(4326008)(82960400001)(38100700002)(122000001)(71200400001)(186003)(6486002)(53546011)(6862004)(478600001)(26005)(6506007)(2906002)(7416002)(5660300002)(316002)(37006003)(8936002)(83380400001)(6512007)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tm53L0xxd040Unpjc0VLTy91SEFmYnFudStCYndTRXEya0xtVERvWWo1Ynhy?=
 =?utf-8?B?WGN5bVozR3pBblBzRGtsS0dqR25CNUJGY2Izc3paZmV6a3JkaXcxYjZWeWVQ?=
 =?utf-8?B?Y2RYNDFzVlYza21ZVnVSVHlSYjVNVzFVZnJVVmViOUIyaklFczhSeU1rSnFm?=
 =?utf-8?B?MU1pczJLcXNtaFNEN2JrSVpzYUVSZE5IK3ZOeVVXbHpzb3J4dHV1blZKU2NU?=
 =?utf-8?B?aEV0K0xQZE56Mkh4MUZ2VS9XenZQdXB5Z3ZWK2lIRTE4VHkvcFYvaUE5S1M1?=
 =?utf-8?B?WHk4ZjFNVTZJV250bVhPd0E2a2cyT2VvNFdTQzdKZWY4bytxd2NWMXNEdXd6?=
 =?utf-8?B?VmpvYitLK3ZoMldiSm1nelZqamwwL1F1VW8zN0dyNzhNWUdhZHlyTEhETGdZ?=
 =?utf-8?B?bi9qQjZkdWFRSy9oK3VLRVpZQk9QNkFtNElURXBKZnRDanZzamRjNFBBZlZV?=
 =?utf-8?B?K3UxUXpSVXNLdS9mbjFEUzZ3bUhNNjZ3a1o1YzN1MnlYdmdaODljWnc2MG5i?=
 =?utf-8?B?SjdzTExpbkdCaWMvaVVnV1h4elNEanBRS0N3aUVrY2VZZ3J4Z2pVbFJYb0Fh?=
 =?utf-8?B?b2lpT3BzUzJVeE9ONmh2YjZZY2w4bklsRFAwWllTK3crQ2xBTUkxUGl5N2dC?=
 =?utf-8?B?aEFFUTJycTVmeTJuR3FFYkhoOGFmSHBoWW9hemZDaTErQUJ2dWVUL3V0c1A5?=
 =?utf-8?B?UTBreDNmcmxDb0lOQ0ptR0l2WTQ2a2MvQmpGQXIvem9lVTkvQVRnMWRmZklp?=
 =?utf-8?B?YWpxNXJUSUpaeE16am5KNlNhK2owV1NHYTF2UkVyLzArVk9oOHFXZ0p5N2No?=
 =?utf-8?B?V1pTV3NDNFBTU2ZMOWxOaE5wSXJlc3EwOUk1STNRUGZlWnZ1TDIwYUh1Z1E4?=
 =?utf-8?B?U2x1aWJIMWpRTDlsc2N6OHAvbGNvMHdzdmJ0RHkrN1RyZ1ZsaXEwOFEzY05a?=
 =?utf-8?B?ZDl0L3V3ODhNNzkyTTdFN205WFVuajlDeFNLRjNTZmF2dmg1RzF5U3lyMEh6?=
 =?utf-8?B?UGRVSEpSYjVxZDU0bS85RW1kTXdER2V0eDRrM3I5dVB3b0lnTnVtaGczV3g5?=
 =?utf-8?B?c056dmlIT3l2UGFRNXNYYTZyYjROUWdqTmkvMUo5MHhsQVpqczJvVEtISWhY?=
 =?utf-8?B?NlZFS0pPdjhiSmo0V05oWTdaalFtUkpvM0h4K0JwUmpuS0VXRjhOTCtuMUJD?=
 =?utf-8?B?eDZBRkpWUnJCeUplYVBOZG45bHFiSkZaVnlyKzlKYTlwUmRjWXRlNVcrRGNn?=
 =?utf-8?B?RWswdEh4YURWK2F3c1pBVTdNbnRMMlBpUjFsR3JhamFRQmtCdFhrMjRwV1pQ?=
 =?utf-8?B?amgwNUI3cFcwc0hwOFR0d20xS0kvT1RranVLU2hPclFkZTNZSngwTFZNVTRN?=
 =?utf-8?B?VnVJZlgxZlI0WFdIU1Z3U0J2dFZyc24wc1lwYjlmZjVvTm5ZaFdjc2I4dWN0?=
 =?utf-8?B?NlZoSk1kOFNPVWJjR0NsdFZpbDI0T3pCWWE0bHRzSWpoWWlqR3Zlak9hQXAw?=
 =?utf-8?B?T3JRcVo0MkFtR3RHQXhWUW92MEtENkpTN1lvR3pXOUUxRUNCMUNuSzUrcEY2?=
 =?utf-8?B?QThoampsYUE3U1dhaDF4WlFtZm1wTWJVakVtOURIczUxZmFEQmVtSTM1bmEv?=
 =?utf-8?B?TFRkV2Zwb3JreGgyUVFySU51OHQ1SS8vbGM5QUx5cVZWRzJndFhNYWF0VEZH?=
 =?utf-8?B?MXBOaXhObFIwampZU09TT08vSXpvclBHSlU4ekZCTWVFTlpNNzFIWnJtVEQ1?=
 =?utf-8?B?YXgzOFpORGQ4N29RTjVacjBMQlRQODNIdWxkakpBT3JXTkxUbHR0M1gvT1dw?=
 =?utf-8?B?bGtFRHlKdVhlSXA4RThXamhwelBvZm5PcTZNMzlHcjZzdVVWM2lwOWdZczQy?=
 =?utf-8?B?bGNlNlFoamU4NHJsd1ArVnpEd0lrV1BUODBHN3AwRy9Da2lLTUNxSUg2Rzlx?=
 =?utf-8?B?ZGwybVduVmYyb1JEVm9ZNldKNkxpVUxFVk44ZGMvNG9wb2xqNGQwQno3b1ZH?=
 =?utf-8?B?b0g0aXdzM3owaERDTjBBQUUva3E2eWVoOXlVdXM2K3pKTEkxNVdWanluUmVO?=
 =?utf-8?B?b1pIcVkrQlFOcml1dFhDb2dsbUFuMXlOdUVTdHR3OEhRUnM5MXZQekRVZWtR?=
 =?utf-8?B?ZXdCODA0Q3Exd1dNUGZnMVlDS1p4TlAxTG9HUzhTbDcxUmx5YmJjSUQzYVJi?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDCFDA11C563CE42B2267BA1CACC9A15@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bca3bbe-132c-4b47-dc0b-08daf43afb5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2023 01:18:58.8104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alFlseldPU9sDPRtnXQcPudlyl6l8rEZUvte3ZFxP+kQAYulZW3+ktiBKPlNSr5Pp2XPtpyBEZMwM7yumD1vhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7334
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjU2ICswODAwLCBIdWFuZywgWWluZyB3cm90ZToNCj4g
Ikh1YW5nLCBLYWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cml0ZXM6DQo+IA0KPiA+IE9uIFR1
ZSwgMjAyMy0wMS0xMCBhdCAwODoxOCAtMDgwMCwgSGFuc2VuLCBEYXZlIHdyb3RlOg0KPiA+ID4g
T24gMS8xMC8yMyAwNDowOSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCAyMDIz
LTAxLTA5IGF0IDA4OjUxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+ID4gPiBPbiAx
LzkvMjMgMDM6NDgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gPiA+IFRoaXMg
Y2FuIGFsc28gYmUgZW5oYW5jZWQgaW4gdGhlIGZ1dHVyZSwgaS5lLiBieSBhbGxvd2luZyBhZGRp
bmcgbm9uLVREWA0KPiA+ID4gPiA+ID4gPiA+ID4gPiBtZW1vcnkgdG8gYSBzZXBhcmF0ZSBOVU1B
IG5vZGUuICBJbiB0aGlzIGNhc2UsIHRoZSAiVERYLWNhcGFibGUiIG5vZGVzDQo+ID4gPiA+ID4g
PiA+ID4gPiA+IGFuZCB0aGUgIm5vbi1URFgtY2FwYWJsZSIgbm9kZXMgY2FuIGNvLWV4aXN0LCBi
dXQgdGhlIGtlcm5lbC91c2Vyc3BhY2UNCj4gPiA+ID4gPiA+ID4gPiA+ID4gbmVlZHMgdG8gZ3Vh
cmFudGVlIG1lbW9yeSBwYWdlcyBmb3IgVERYIGd1ZXN0cyBhcmUgYWx3YXlzIGFsbG9jYXRlZCBm
cm9tDQo+ID4gPiA+ID4gPiA+ID4gPiA+IHRoZSAiVERYLWNhcGFibGUiIG5vZGVzLg0KPiA+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IFdoeSBkb2VzIGl0IG5lZWQgdG8gYmUgZW5oYW5j
ZWQ/ICBXaGF0J3MgdGhlIHByb2JsZW0/DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoZSBw
cm9ibGVtIGlzIGFmdGVyIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24sIG5vIG1vcmUgbWVtb3J5
IGNhbiBiZSBob3QtYWRkZWQNCj4gPiA+ID4gPiA+IHRvIHRoZSBwYWdlIGFsbG9jYXRvci4NCj4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gS2lyaWxsIHN1Z2dlc3RlZCB0aGlzIG1heSBub3QgYmUg
aWRlYWwuIFdpdGggdGhlIGV4aXN0aW5nIE5VTUEgQUJJcyB3ZSBjYW4NCj4gPiA+ID4gPiA+IGFj
dHVhbGx5IGhhdmUgYm90aCBURFgtY2FwYWJsZSBhbmQgbm9uLVREWC1jYXBhYmxlIE5VTUEgbm9k
ZXMgb25saW5lLiBXZSBjYW4NCj4gPiA+ID4gPiA+IGJpbmQgVERYIHdvcmtsb2FkcyB0byBURFgt
Y2FwYWJsZSBub2RlcyB3aGlsZSBvdGhlciBub24tVERYIHdvcmtsb2FkcyBjYW4NCj4gPiA+ID4g
PiA+IHV0aWxpemUgYWxsIG1lbW9yeS4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gQnV0IHBy
b2JhYmx5IGl0IGlzIG5vdCBuZWNlc3NhcmlseSB0byBjYWxsIG91dCBpbiB0aGUgY2hhbmdlbG9n
Pw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IExldCdzIHNheSB0aGF0IHdlIGFkZCB0aGlzIFREWC1j
b21wYXRpYmxlLW5vZGUgQUJJIGluIHRoZSBmdXR1cmUuICBXaGF0DQo+ID4gPiA+ID4gd2lsbCBv
bGQgY29kZSBkbyB0aGF0IGRvZXNuJ3Qga25vdyBhYm91dCB0aGlzIEFCST8NCj4gPiA+ID4gDQo+
ID4gPiA+IFJpZ2h0LiAgVGhlIG9sZCBhcHAgd2lsbCBicmVhayB3L28ga25vd2luZyB0aGUgbmV3
IEFCSS4gIE9uZSByZXNvbHV0aW9uLCBJDQo+ID4gPiA+IHRoaW5rLCBpcyB3ZSBkb24ndCBpbnRy
b2R1Y2UgbmV3IHVzZXJzcGFjZSBBQkksIGJ1dCBoaWRlICJURFgtY2FwYWJsZSIgYW5kICJub24t
DQo+ID4gPiA+IFREWC1jYXBhYmxlIiBub2RlcyBpbiB0aGUga2VybmVsLCBhbmQgbGV0IGtlcm5l
bCB0byBlbmZvcmNlIGFsd2F5cyBhbGxvY2F0aW5nDQo+ID4gPiA+IFREWCBndWVzdCBtZW1vcnkg
ZnJvbSB0aG9zZSAiVERYLWNhcGFibGUiIG5vZGVzLg0KPiA+ID4gDQo+ID4gPiBUaGF0IGRvZXNu
J3QgYWN0dWFsbHkgaGlkZSBhbGwgb2YgdGhlIGJlaGF2aW9yIGZyb20gdXNlcnMuICBMZXQncyBz
YXkNCj4gPiA+IHRoZXkgZG86DQo+ID4gPiANCj4gPiA+ICAgICAgIG51bWFjdGwgLS1tZW1iaW5k
PTYgcWVtdS1rdm0gLi4uDQo+ID4gPiANCj4gPiA+IEluIG90aGVyIHdvcmRzLCB0YWtlIGFsbCBv
ZiB0aGlzIGd1ZXN0J3MgbWVtb3J5IGFuZCBwdXQgaXQgb24gbm9kZSA2Lg0KPiA+ID4gVGhlcmUg
bG90cyBvZiBmcmVlIG1lbW9yeSBvbiBub2RlIDYgd2hpY2ggaXMgVERYLSpJTipjb21wYXRpYmxl
LiAgVGhlbiwNCj4gPiA+IHRoZXkgbWFrZSBpdCBhIFREWCBndWVzdDoNCj4gPiA+IA0KPiA+ID4g
ICAgICAgbnVtYWN0bCAtLW1lbWJpbmQ9NiBxZW11LWt2bSAtdGR4IC4uLg0KPiA+ID4gDQo+ID4g
PiBXaGF0IGhhcHBlbnM/ICBEb2VzIHRoZSBrZXJuZWwgc2lsZW50bHkgaWdub3JlIHRoZSAtLW1l
bWJpbmQ9Nj8gIE9yIGRvZXMNCj4gPiA+IGl0IHJldHVybiAtRU5PTUVNIHNvbWV3aGVyZSBhbmQg
Y29uZnVzZSB0aGUgdXNlciB3aG8gaGFzICpMT1RTKiBvZiBmcmVlDQo+ID4gPiBtZW1vcnkgb24g
bm9kZSA2Lg0KPiA+ID4gDQo+ID4gPiBJbiBvdGhlciB3b3JkcywgSSBkb24ndCB0aGluayB0aGUg
a2VybmVsIGNhbiBqdXN0IGVuZm9yY2UgdGhpcw0KPiA+ID4gaW50ZXJuYWxseSBhbmQgaGlkZSBp
dCBmcm9tIHVzZXJzcGFjZS4NCj4gPiANCj4gPiBJSVVDLCB0aGUga2VybmVsLCBmb3IgaW5zdGFu
Y2UgS1ZNIHdobyBoYXMga25vd2xlZGdlIHRoZSAndGFza19zdHJ1Y3QnIGlzIGEgVERYDQo+ID4g
Z3Vlc3QsIGNhbiBtYW51YWxseSBBTkQgIlREWC1jYXBhYmxlIiBub2RlIG1hc2tzIHRvIHRhc2sn
cyBtZW1wb2xpY3ksIHNvIHRoYXQNCj4gPiB0aGUgbWVtb3J5IHdpbGwgYWx3YXlzIGJlIGFsbG9j
YXRlZCBmcm9tIHRob3NlICJURFgtY2FwYWJsZSIgbm9kZXMuICBLVk0gY2FuDQo+ID4gcmVmdXNl
IHRvIGNyZWF0ZSB0aGUgVERYIGd1ZXN0IGlmIGl0IGZvdW5kIHRhc2sncyBtZW1wb2xpY3kgZG9l
c24ndCBoYXZlIGFueQ0KPiA+ICJURFgtY2FwYWJsZSIgbm9kZSwgYW5kIHByaW50IG91dCBhIGNs
ZWFyIG1lc3NhZ2UgdG8gdGhlIHVzZXJzcGFjZS4NCj4gPiANCj4gPiBCdXQgSSBhbSBuZXcgdG8g
dGhlIGNvcmUtbW0sIHNvIEkgbWlnaHQgaGF2ZSBzb21lIG1pc3VuZGVyc3RhbmRpbmcuDQo+IA0K
PiBLVk0gaGVyZSBtZWFucyBpbi1rZXJuZWwgS1ZNIG1vZHVsZT8gIElmIHNvLCBLVk0gY2FuIG9u
bHkgb3V0cHV0IHNvbWUNCj4gbWVzc2FnZSBpbiBkbWVzZy4gIFdoaWNoIGlzbid0IHZlcnkgZ29v
ZCBmb3IgdXNlcnMgdG8gZGlnZXN0LiAgSXQncw0KPiBiZXR0ZXIgZm9yIHRoZSB1c2VyIHNwYWNl
IFFFTVUgdG8gZGV0ZWN0IHdoZXRoZXIgY3VycmVudCBjb25maWd1cmF0aW9uDQo+IGlzIHVzYWJs
ZSBhbmQgcmVzcG9uZCB0byB1c2VycywgdmlhIEdVSSwgb3Igc3lzbG9nLCBldGMuDQoNCkkgYW0g
bm90IGFnYWluc3QgdGhpcy4gRm9yIGluc3RhbmNlLCBtYXliZSB3ZSBjYW4gYWRkIHNvbWUgZGVk
aWNhdGVkIGVycm9yIGNvZGUNCmFuZCBsZXQgS1ZNIHJldHVybiBpdCB0byBRZW11LCBidXQgSSBk
b24ndCB3YW50IHRvIHNwZWFrIGZvciBLVk0gZ3V5cy4gIFdlIGNhbg0KZGlzY3VzcyB0aGlzIG1v
cmUgd2hlbiB3ZSBoYXZlIHBhdGNoZXMgYWN0dWFsbHkgc2VudCBvdXQgdG8gdGhlIGNvbW11bml0
eS4NCg0K
