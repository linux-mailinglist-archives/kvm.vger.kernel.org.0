Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DE073FA4C
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 12:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjF0KhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 06:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjF0KhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 06:37:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B4DE44;
        Tue, 27 Jun 2023 03:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687862232; x=1719398232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bia4Qm5loxzuk/27xP1NRuLwgRU9rvHzDhbPOFCU5h4=;
  b=m26IuTXsWCSHVb2OYqExGywFXpHAEOicatadHa5cjT5QLX07XzCXes9u
   eYwctCUMHZVYnFnvljtzzQH4nDIihVHav7VDXTVSgYy68aQU47V78V27j
   oQQhCNb9l62mA4Vdi3ESBBRU7k04RBVtYSEnP3n909TIpjZD0d0e5+XBh
   LYz4JcqEWwtGfUhOft3Nde92t1Lv8B3vlWmVXshzMjCLimjhpVFbsqeRt
   aiL5Nvf5kTP+zOySN9mjuJY04B7fJKlfYGVueamLVaQylcBI2OXQoHFK9
   /WISQz5gV60WVMShYQ8AYbfaiCLs2cRcCJsv8Kgn/7k1ZtD+NXbQ7riw5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="364987575"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="364987575"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 03:37:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="719728631"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="719728631"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 27 Jun 2023 03:37:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:37:10 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 03:37:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 03:37:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 27 Jun 2023 03:37:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAG6A1IPuKikU77qclAeAGPpoQ9nj1q+0Fo+TLQWgoY9A4Mrt4BjJ7/oK2tJu2hR+XVfL4wBcB2tEduCAk/BSMFQy+m99mPvjdlz9EakepswEEbaL19TfnQlrV1n4A12tBdz3t+eRpuKkwNhGEmNL0UpC6kVEXJh5rw9NH1fVnhjt1XtDBTohSlB8tjaKv5PzwZ99mh04CDOFt6DwvhfLY0pYsuWd6R7arHyZy8cnGKZdyEu4D05hf1AbK3/x0IdFV1EP6TNNDdiNHJxkDkx1DKsHtlMJW8ySOD+3kxAdiGTFeJlizuv34coZs9TO4oTNs6n+74yTsZqsTT8weDQKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bia4Qm5loxzuk/27xP1NRuLwgRU9rvHzDhbPOFCU5h4=;
 b=WCe9Fle7nSI/MUl0EKh76FZNefr2aHmCiihkIuAvru+Ii8ilVxmRAzwqIUMir5Z+PuzGtxaKEoylq94iileVCa1+a1Pb6oH4f9ztFYMjWKUNqn+USQj4iRsH279CZEwekXxRUBmHLrOtDikcEL/FJ5t9OVhXGPlHDErwphDPyjFseaIRGpdAbORGLwaNQNy343V8ykgNE4bUj7sxEQzjxIfKW9qXavFRJK5eFR/+1xeobk58P26RwQH2MnO+0hFTa0GnCwZ623cV1951UGWLOHrEdr7qeBOOaoMa1nYMYqxqWY0W+bTx7zc19HJajmU/flltJC9iiwb4TqOhhETMtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6332.namprd11.prod.outlook.com (2603:10b6:510:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Tue, 27 Jun
 2023 10:37:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 10:37:02 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+dmA4AgADeIYA=
Date:   Tue, 27 Jun 2023 10:37:02 +0000
Message-ID: <e7878046807833c718b54eae3e3066a28cca406b.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <fcaf00b3-3da3-af72-65e0-ddacb870f96f@linux.intel.com>
In-Reply-To: <fcaf00b3-3da3-af72-65e0-ddacb870f96f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6332:EE_
x-ms-office365-filtering-correlation-id: 1abbde1e-b175-4a17-e834-08db76fa71b5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hQeF1N/qcCkcLvjPMk+zDdknpHXFrjQAhC/V9H2LQWACvBclP2KnQQd7rFCyUzEcPnd2nY1mEhQqsWecEk86bBa6R0OJznbYXaLjk56KaHxnKWgvY0kFVLGkYV2ZVJD/EGfQ093BYo27LUSmipx/4+VBXBG2baqy2ukUx80BX9b0EtcC91/aRKpnmn1jNSTqU0m0EcVfJFVb7WfLecsOQjqbPRgefEiQprgKp7etTdMm87usbbT1Bz+UHFgB2N/+sVUoB+sda70lTtl4bQZOZKWc8PtNZjisjlocQZ9kGbDzZQKZXdy6Qm+uLEmy496TA9y2q6XfROtrIXGcbaoKxS6JfxfrKZfyyme43IeHvifN3bZ5SiDw3DCeoZUn135aoPqZ2xBH3Gf8T+ewTDdEcu3UxirhYWugQtzZOtWKeRGKjJZEZj2EdGA9fztFeKHILDMtSR1XXqGkzjdiDue6LDMswtKyjKlo33B3luYE8o/iwABfCtavp+uDALcYgZwAgIoJKx9ECc8/wtE2JdAJvru0cNmVr9eMve5kfiD6H6ITNWMcUf2L8NRuOpmW/d6N1e3kIffSJfwqvCaDZH+WdsFGLif0GonLbHvejc4gxYDXofz62x8CYWl8LQ9qR3kV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199021)(6506007)(7416002)(5660300002)(4326008)(91956017)(66476007)(64756008)(66446008)(316002)(66946007)(36756003)(478600001)(66556008)(76116006)(8676002)(8936002)(86362001)(4744005)(2906002)(110136005)(54906003)(41300700001)(6486002)(186003)(38070700005)(6512007)(26005)(122000001)(38100700002)(71200400001)(2616005)(82960400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QW9rWG8zVVBRdU9kQlFPZnJKMFhSUWtoeVRIMzI4MnEzQ0EwRmozYWFkaGNa?=
 =?utf-8?B?amxZUzVnRWdJNVE0M1VLZ2EvWnhMRUxYeG84MDNGOGNYMHFmZXAxRzVvR2dx?=
 =?utf-8?B?SXhSZEZkaXNXSnZvQXdpRnVuZktHMXFESVNjRjlMeENueE1CUWdZK09HUk1Q?=
 =?utf-8?B?MkhVaWp5alNBd0x4aG1MQ3BmWDZhSWRjV3pUb1NseWpPM0hrVVY2Um5VUEh3?=
 =?utf-8?B?eHNNU21UZDNPWkgxWENCZ011L2NxOWxMQ1NZUnZmY21sMW56UUplaGxtc2tO?=
 =?utf-8?B?eFduVkRrcGhkWUpDU1FZN0ZHWklrY0hmMFdVNytEWmdIc3MwalYwa2Vsdngw?=
 =?utf-8?B?VEVzY283L2lDVUYxYWZtL1FvbmdVTjRQSWxYTmhqU1dQbmplOUJGM2ZXNWhI?=
 =?utf-8?B?OTl3WmRWaThPUE5GNm1mZ2FVQlh2Q1JZRmlnaXAzQVN4dzRJNzd6NldkdlBu?=
 =?utf-8?B?dEpKbXVUTjZ0enBhMmdyRmxZSDc0UEEwOG12c2FJTm1UejBlc0RIY2lyaGpV?=
 =?utf-8?B?QThtSklpQjlTNlJVb25lWG9WcUF1TC95N3FzekFHZmFnVUpoQUZkNVMyUXpO?=
 =?utf-8?B?K3FDT1BKQThVNkJMK3RsOHBMWXY2VUp0Ym1tcTZtRGRQTDhsM3dzb29WcWVR?=
 =?utf-8?B?UExHLzRTcmNjMmNRM01TQitGTDdDcUdKU3FBUDIraUQ4WDVwMG9raVJrOTVt?=
 =?utf-8?B?RDlpVjVDRWhzajZVWXljcXE4WHV2SmFpeDNqNmhhc2NmYVlualFQdGpSK2pt?=
 =?utf-8?B?RnRJV0RWUTJ4WTVTekJ3YXU3SEl2REhHUjk4dkxFTzdmYjlNSFJrWDNTTzNv?=
 =?utf-8?B?SFVzUVBOUXVJVTZySUtQTjdWbEhRdkhuU2p4eTU2alkwSHdVbWNSbnQ2cU13?=
 =?utf-8?B?dHE5N3VscXZBcEN6VzBiR2RydTQ1SnpPYUJiNTdiMjNscGdFbTg2RFp0ZW45?=
 =?utf-8?B?bVBBbjBxcW01aXJ5WndqeXVaZ3BjRUVVMytpRm9PL2dBYmdFeExtQ1ZqRzNT?=
 =?utf-8?B?N3c3bnc4UWExWWJzSDZJL3RBUWtCeVBuSmF1cGNhbkJOWTdoZllPR215RCtt?=
 =?utf-8?B?MDlSaWptSlMrMU1sYWdJTkF6dzd4cjNWUnAxUlY1aWJ6VlY2cDVzbm5kOWl6?=
 =?utf-8?B?TUI3R0pkSnlnOWpBbWUwZzhDN3JwMEJWdFpHY09OcjRRVi9ibmdvanZxMzhE?=
 =?utf-8?B?TjMxLzFaa05PYmhEUEVldTlZT1RoOEUrR0ZhVHZqOWNCb3ZFK0ZiNlB3TkY1?=
 =?utf-8?B?Vit0QjJqVkZYN0drTW9rNlhRWktkaEsvV3l0NjFyK0U1MElwcnM1U25jS0hz?=
 =?utf-8?B?eENTUlVQQ0FuOWtTSUtFbnBLSXRxZ1BKdFZMMnBuNU9GL3lVY0toNVhuQWc2?=
 =?utf-8?B?OHFVcFNiZGhoZmJCQ2F0aWZFQU5FRXRnVWRQNWRqaDBXNlVCNzNGcUcvcFlQ?=
 =?utf-8?B?OU1PeWpIb3l6WEUxN2FDQysvcDVTcmVndHh4VDZpaUY4YmZYL0ZobzJVa3Vq?=
 =?utf-8?B?WmpLYnpGemN4UUJiNFp1b3lPb2x2UFQwbmlkaEhLbFhsbzFwUVFiQTl1dEZP?=
 =?utf-8?B?VXBxSEc2V012SERHdFBGS1ZXZ3FrNFA0K213SW5KcjNhYVpra3ZZQWdnK1hF?=
 =?utf-8?B?MncwRWhTamtTR1U1NWJtSWlyYTZqNmVKT2p5U2RydzJzemdZMHJaRzZlZUl4?=
 =?utf-8?B?dDNTNVdHdWdXWng4UWR2VHdpWE9NaEZ2U3N3OENqMmhDYVp2akVxa2JUOVZy?=
 =?utf-8?B?RVRBcTFyZGlZZDdJSzc0OU1tcDlTWXlWM3hrYkpBRHphd3l2WFZMQlNmbEVr?=
 =?utf-8?B?WGRLZmNjcHlnb25WVUcrSUQybE5FZ0lhVWdtYTNISHltVDJVZHZONGZLZDds?=
 =?utf-8?B?dXJBREdJbmFBRUdQeGlWaU53UzRyeTFNYll5ZGNvNkt1Mk5jZUZLYkZJWWUz?=
 =?utf-8?B?R084bTNJTnBWVXY0Qk5uWGhUWlNWSC92U3AxeHhoM0tabVZzMXpJWGxqL25t?=
 =?utf-8?B?ZHFpSHFneVZqOVBWUE9BbmVSMEZYZi9qOU1CL3dmT1c5d0NwU0d2dTgzNDNH?=
 =?utf-8?B?Y0RuQTRNVCt5TnpNUU9hTkdDNGRUYUFRUEphREIzdnAyUHFJNll0azFhcWZH?=
 =?utf-8?Q?tSiVqHYSMSSXfoKRSdc79rryk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F5FD59C84C3244390B72E9514E6F495@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1abbde1e-b175-4a17-e834-08db76fa71b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 10:37:02.4620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /j9hD+pQRaQrgGgFFB6RO6TBbKgcELycXwFC31pyPA0+eqZCb8t84mCYOQtKrzPvlEvw6kNgF9NOcbIWTm8NIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6332
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTA2LTI2IGF0IDE0OjIxIC0wNzAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gPiArCS8qIEFsbCAnMCdzIGFyZSBqdXN0IHVudXNlZCBwYXJhbWV0ZXJz
LiAqLw0KPiANCj4gSSBoYXZlIG5vdGljZWQgdGhhdCB5b3UgYWRkIHRoZSBhYm92ZSBjb21tZW50
IHdoZW5ldmVyIHlvdSBjYWxsIHNlYW1jYWxsKCkNCj4gd2l0aA0KPiAwIGFzIHBhcmFtZXRlcnMu
IElzIHRoaXMgYSBhc2sgZnJvbSB0aGUgbWFpbnRhaW5lcj8gSWYgbm90LCBJIHRoaW5rIHlvdSBj
YW4NCj4gc2tpcA0KPiBpdC4gSnVzdCBleHBsYWluaW5nIHRoZSBwYXJhbWV0ZXJzIGluIHNlYW1j
YWxsIGZ1bmN0aW9uIGRlZmluaXRpb24gaXMgZ29vZA0KPiBlbm91Z2guDQoNClllcyBJIGZvbGxv
d2VkIG1haW50YWluZXIgKEkgZGlkbid0IGJvdGhlciB0byBmaW5kIHRoZSBleGFjdCBsaW5rIHRo
aXMgdGltZSwNCnRob3VnaCkuICBJIHRoaW5rIGluIHRoaXMgd2F5IHdlIGRvbid0IG5lZWQgdG8g
Z28gdG8gVERYIG1vZHVsZSBzcGVjIHRvIGNoZWNrDQp3aGV0aGVyIDAgaGFzIG1lYW5pbmcgaW4g
ZWFjaCBTRUFNQ0FMTCwgZXNwZWNpYWxseSBpbiBjb2RlIHJldmlldy4gIEkga2luZGENCmFncmVl
IGhhdmluZyB0aGVtIGluIG11bHRpcGxlIHBsYWNlcyBpcyBhIGxpdHRsZSBiaXQgbm9pc3ksIGJ1
dCBJIGRvbid0IGhhdmUgYQ0KYmV0dGVyIHdheS4NCg==
