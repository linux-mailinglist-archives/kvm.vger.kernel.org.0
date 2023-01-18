Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96D670EED
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjARAnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjARAmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:42:07 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F4A59549;
        Tue, 17 Jan 2023 16:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674001325; x=1705537325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c3bYoOOAPYmxPTd2uk9P9jmaJ0PPsIByXW7j1nCplg4=;
  b=Qq6MiEtYVTSfH98V93EdTII4d8dZAO2ykU34R2VvXS/0fjRd+dx35DgS
   qwW3kdZsuSR0D6dsDosuavNDSeFkySmF/qOjfA9y1nCDoDfoSTXSP9oAX
   KRc09G+J0mK/yeFPW8TDRP4X+O/TTLm9i7/IbAR5JHzXe/FdDm8bcqbu9
   sclY7inWWCDN39FZFCOgaxqpqYwtiYlEO+ff+Y40H4DMdqwT4MyVs1JKc
   OpvdO+osrLLPD3O2i0dBThkwqmh2OB151Vjy2kRIe1Jz20nMk8mupPusv
   hjOS0vHhQVCtIR7eXKcGEHNYXGdP2BVj0QrUyAAPCkgaUImMMe9KpxBCt
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="411094327"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="411094327"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:21:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="748224263"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="748224263"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Jan 2023 16:21:46 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:21:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:21:43 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 16:21:43 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 16:21:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xol9lIVOlGlMp0jk5FNrTjVV6R0FnHCChUDVvoht5+dK41bhzttaE3SZgA/GYh67ncnOwpO5IP/e2iR+SvoO2Sj07PyK74KsstFdmBfebgEKrp9oSPS4bZXGO57hlCGIEDiDOf9M0CBP0TaNIZ/7VpeFIO/hcDZav9YJvXXTx5F1hfd00XExycjUS/CbyGfflM2LAts5Foduf4XcX4BX++bJ8ce/uJpwQYFMSXtiUt7LtanVrJMfgnqAy23fe2tLMnq/PhCwHXyUM+7LcEwGxPZ3zzmKiND3Db5TUFYKAjOpuHwhm7PKuNq/OzuwuwsvwIBzTeVieTewfMM3T18gCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3bYoOOAPYmxPTd2uk9P9jmaJ0PPsIByXW7j1nCplg4=;
 b=Bi2Z7/uJbLUhImr3LZ7GQt6Cyub/Yf2s4s6EG//aAoqPuvX43ghsy4n/ZyOkS3A6d4VuL2cNMfY1thi1k6lop5PJH4OL0WYqJj2L/OWGMLCzC4rVt/Je0Nra7CI0BVKSFV8trSBReH6B+Zy/jXZFFfOk6op2I0ww50G23PDDFjyLXlVxEvd58Tm9Fyst6E81tpkuI/u76xWLj+pphK82scxEoTnWrd/NHzWq84XCxxkhebExEGGV4XKAhymgaEBhJtEgI/XiNUre/kcKn5AfTMJgUyJfX5vyBMhYnofyBIosmL95ISwfPEgYg4Um1xDdiNjKpHei28JBwC0fkokNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6473.namprd11.prod.outlook.com (2603:10b6:510:1f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 00:20:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%6]) with mapi id 15.20.5986.019; Wed, 18 Jan 2023
 00:20:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "michael.roth@amd.com" <michael.roth@amd.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "harald@profian.com" <harald@profian.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "nikunj@amd.com" <nikunj@amd.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Thread-Topic: [PATCH RFC v7 03/64] KVM: SVM: Advertise private memory support
 to KVM
Thread-Index: AQHZD/aMOfef/QZK1Ey2so50GAbxHa6jhYOA
Date:   Wed, 18 Jan 2023 00:20:59 +0000
Message-ID: <4e75a1a0b67e7b3ccaf6b140b08a5f2080aedbdb.camel@intel.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
         <20221214194056.161492-4-michael.roth@amd.com>
In-Reply-To: <20221214194056.161492-4-michael.roth@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6473:EE_
x-ms-office365-filtering-correlation-id: 8d562410-2081-4611-3977-08daf8e9e017
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KPeCcQzpodMxhBULkkkxiA/9J6vYTHONCGxSwA/SDX5Y0weaAz8lLUSaB7aspHGy2JO5gToVTj7a0pQgZNT5j1X3ZWVT2wrxk/mE8wE0L0zim0T5qBaXDlClaU1HAfbFsew6vae5dpcNgjS6bLWkwyoBi2CqZ7MGjBvLdyaian/7b7+1KRIa+efGEhV3U9ifRIi39XVnGAqdZgQOi2+E5XLY8tq0BDFv8mgxA3+/CmPjpm7qWvbY1RdEkFe+fR3TYKHPDEaiR/POJPcDPYq7o8npMNUWNymSzQiSjRQVzjwglImVcar6LipVqt7Ey3cCDJpd3bZY7S6EEaZt2Cp1H/LwfKaXjdHD6mFf7HqidiAPkg1HjuvY5D0seHbYko7Gxlz62Y6cbdECq8S4XAJjix6A9r41TUexwkDBKdUXWk4bA5uQS2fsHQ4cn/PeslJFAW4cHFUOPLAOMy4KOZRc0lO38hw2kU2hKeeQHPKuQ0P0LoNHoCQMkiFZPfddCAYHRFnBSnxuFkMDcCL+2e6WvKWcUTRyqVUev0QEPepGDkyrSfzdEooBdzoaOO5vg4PcS9Ms0Tu91ShXNrdKcRYXnxSdt9FBY/SjsgbFvKwb0N0AJXp099GKQoXMqHbOfMgSvbFs5H8Hg36GFwLLwtYIk8EEQKO0xdY/etvsmC3eaAW3Tc7qhp/4WlqfJG1eQV+jdJPZR0NhKQoQEPfy6oZhJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199015)(83380400001)(122000001)(82960400001)(86362001)(5660300002)(41300700001)(4001150100001)(38100700002)(2906002)(7416002)(7406005)(8936002)(91956017)(6506007)(478600001)(4326008)(64756008)(2616005)(186003)(8676002)(76116006)(26005)(71200400001)(66446008)(316002)(66476007)(66556008)(6486002)(66946007)(6512007)(54906003)(110136005)(38070700005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ektEOFIySVJpYllJaUMyQ0xSRXZ4aDJIeXpidFNmTTF5MWR0Y0hCVDd6SitH?=
 =?utf-8?B?UWxzN2hMaXU0Vi84RWNxNktNZzBxeURib1dzR0lDVmFBSjYyK0VLYlYvelBr?=
 =?utf-8?B?dHBndk1GQ2YwV0pTRklEN2YyQStCdVlRbVNtRVYzdE9LeUs0aVd6OGJVRVp2?=
 =?utf-8?B?K0ZRalV6QzZiekprcFRUcmJwOVo0Qnd1VFVRcTF0SzNrbkliWktueFJNYzNO?=
 =?utf-8?B?bTkzSHVhYzBZbVBlQVQ3ZGRzbFhuclN3dHF1aStzQnI0bi9USW81NEZicWR5?=
 =?utf-8?B?U2xKRjRGNGNlL2IzOFp0Unhpd0VxaVJLdDlwT0VBN0JNTmRnTHUxdmN6WG5I?=
 =?utf-8?B?c09vM0VFZHN4a3dMdGlYaTBnSGVFeE5YbEc1VHlTbHU2bFhLV05aOGExYzVR?=
 =?utf-8?B?RHQ5bkM3R0V2cWE1aVZKWlc1LzFwTEtWeWRqTmZGUWxkVmZ1aHI4YkNzQXlR?=
 =?utf-8?B?S1NkY09CYzF5Y1JHLzl6RktMSVJZRXd5UjJtRGx2RlYvVmtJSGZDcWR6TEgy?=
 =?utf-8?B?ZUtESFJsbU83M1QrcHZHL3hOSk42NFptNkw3aXJ6dWdCTWlGdzFXTTEzVmFG?=
 =?utf-8?B?cXNSVHVrbmh2MkExVm1rL3lGY1VJTFVBdDNaOWV6U0lMNGpjZCtiZXJrL0tr?=
 =?utf-8?B?b2ZuS0JNNVpDVFh5RElCeVRPUTM0cm8yYnhSVENsNHp5TW5VNUNkS01yS29I?=
 =?utf-8?B?MStMQ2U1cFdjQ0l0TFdkbG8yeDFRdHZ0WDUveitPSzhmNVpHSUJiQngrcExi?=
 =?utf-8?B?RFpKUVk4YUtmU0MwRVg2bkE5d2QwREowNER0KzJ5QUFrdXQvOXp4RU1XbEdZ?=
 =?utf-8?B?TEpVT2RKaHFGVUZCcENQWCtCNjZHZUIzUUluaDR2VHNGc3lPRk90LzZHRjJs?=
 =?utf-8?B?U2hLb2VseEV6Y2M5ckh3NEk5bFNYaXlsUEVON3cvK1lkRmduQ2ZkN0FOSDIr?=
 =?utf-8?B?NGFuUytpNlFPTGN0UnVGSXRoVE5XeXpwVjBTSE0zdEZVRjhZUTJvK01wZVpE?=
 =?utf-8?B?NFgwNGNqbjlnb3RKNjFuaGN6U0R5UFpoQ1RidmYrUTF6NjdrdHNHdEttL0J0?=
 =?utf-8?B?NDJOZjRaSEZCUC9qR0M3NXVXM1U4MzNxNXFEdFB3dkV3NXpxU1VwNWdyeVlV?=
 =?utf-8?B?cTVtWGdpVlJTaXFTSkpMTEI1VkFSZG9QZkZyOGNyY3k2M0RodFRWV1I5aFB6?=
 =?utf-8?B?aVNESGxIdnBUOVZrVjJIRHp1WlRUZkd6T0hDWS9FUTQ1SkhDSW0razEzVk5u?=
 =?utf-8?B?L1VPZ1hWYnlmSWZRaG9VRmNnT2xXYncxYmpyV3c0Y1Q1NTBxRVMzeU5MUlRm?=
 =?utf-8?B?ZXNSeFhtOGptb3N0Z1ovM2hDV3JjQ0xib0JBS3A5TFN6UzNVczR4THdJK1Vl?=
 =?utf-8?B?QTlNL0N1MGxsbFB2amk1ZCtiRWxxdUsvTDdJdWtHbWF4UkRsUjVJdGtMcS9M?=
 =?utf-8?B?WW9vWUhpdXNGQTd1Nk5Wd3o0VmJ6blpOd0gvMXFzSTFZM3hUV3RNUVBHVm9n?=
 =?utf-8?B?RHFIb0xCV3ZaeHRlMTJ5L2loS3Z5WFBjby9zVnhudU12RTRVTU1uSVFlU0pj?=
 =?utf-8?B?M3RmL2tET2tlVi9IWkt0a29kWkpmTksyeHA0RlJuNGlZOGdPeUszNnhiRGtv?=
 =?utf-8?B?bnZnWGw4dmk2TktmWmIzd20xNXl6Zm9yTzJJbitsM2RmbS9RNE1QeU1LNTVt?=
 =?utf-8?B?NHdxSngvQmllYTB0L2thYWdFcjVlcmt2bkN2cXZVT0pHaHpPYVdkNDRCQ3Z5?=
 =?utf-8?B?dWtxQWFwazhZdGxIbXJVUk9VdjdVRDJ4NDVZQm5pY29HYnJTcFFxYXZtV0hP?=
 =?utf-8?B?dEF2TWNiSld3VzlhbXNCaDRBbW16dlN3bE5oR3hSZ21QeVZwU1NibG9GNGZR?=
 =?utf-8?B?a3RVWFVKUDA3elVUNldMOTNzMVR3R2x6c1BjMHRZU1ZDZmxjUTM5ajQwb0d3?=
 =?utf-8?B?TG9mR3FiRUt2NU9hYXpESkZtTXpuZGhLZFI2M0NKakRPYTB2L3NVc0xJdmNE?=
 =?utf-8?B?cEROLzZ1N1o3NEdFUjNVT1lPZHJ6ZUliRTg0cVZYeDhUYWNDRmxYbktBc1pJ?=
 =?utf-8?B?dTRtYUFJRmJtcE5Ob2FlN1lNblo2b2F4ZXl1eFhSM3dQT2RwNEZ1ZWFpV2o0?=
 =?utf-8?B?NCs2STBDaEpqYjFURE5ZYSsxU1dJMmhLaVRqV0pNZkZKakFEZHd5aC9tS0Jh?=
 =?utf-8?B?Wnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8ABE8917D36152438658C7A6775E6613@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d562410-2081-4611-3977-08daf8e9e017
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 00:20:59.6564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uTNhtXYmHKDQYV2UGCduKLgBJm1XF8O8PwVxCPE7dAcSzo6cQaB5vbKMo+bu+1FBk3onjf0p9sAWDx99LWzQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6473
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTE0IGF0IDEzOjM5IC0wNjAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IEZyb206IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1kLmNvbT4NCj4gDQo+IEtWTSBzaG91
bGQgdXNlIHByaXZhdGUgbWVtb3J5IGZvciBndWVzdHMgdGhhdCBoYXZlIHVwbV9tb2RlIGZsYWcg
c2V0Lg0KPiANCj4gQWRkIGEga3ZtX3g4Nl9vcHMgaG9vayBmb3IgZGV0ZXJtaW5pbmcgVVBNIHN1
cHBvcnQgdGhhdCBhY2NvdW50cyBmb3INCj4gdGhpcyBzaXR1YXRpb24gYnkgb25seSBlbmFibGlu
ZyBVUE0gdGVzdCBtb2RlIGluIHRoZSBjYXNlIG9mIG5vbi1TRVYNCj4gZ3Vlc3RzLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogTmlrdW5qIEEgRGFkaGFuaWEgPG5pa3VuakBhbWQuY29tPg0KPiBbbWRy
OiBhZGQgeDg2IGhvb2sgZm9yIGRldGVybWluaW5nIHJlc3RyaWN0ZWQvcHJpdmF0ZSBtZW1vcnkg
c3VwcG9ydF0NCj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1k
LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oIHwgIDEg
Kw0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCAgICB8ICAxICsNCj4gIGFyY2gv
eDg2L2t2bS9zdm0vc3ZtLmMgICAgICAgICAgICAgfCAxMCArKysrKysrKysrDQo+ICBhcmNoL3g4
Ni9rdm0veDg2LmMgICAgICAgICAgICAgICAgIHwgIDggKysrKysrKysNCj4gIDQgZmlsZXMgY2hh
bmdlZCwgMjAgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bS14ODYtb3BzLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5o
DQo+IGluZGV4IGFiY2NkNTFkY2ZjYS4uZjUzMGE1NTBjMDkyIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9rdm0teDg2LW9wcy5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2t2bS14ODYtb3BzLmgNCj4gQEAgLTEzMSw2ICsxMzEsNyBAQCBLVk1fWDg2X09QKG1zcl9m
aWx0ZXJfY2hhbmdlZCkNCj4gIEtWTV9YODZfT1AoY29tcGxldGVfZW11bGF0ZWRfbXNyKQ0KPiAg
S1ZNX1g4Nl9PUCh2Y3B1X2RlbGl2ZXJfc2lwaV92ZWN0b3IpDQo+ICBLVk1fWDg2X09QX09QVElP
TkFMX1JFVDAodmNwdV9nZXRfYXBpY3ZfaW5oaWJpdF9yZWFzb25zKTsNCj4gK0tWTV9YODZfT1Bf
T1BUSU9OQUxfUkVUMChwcml2YXRlX21lbV9lbmFibGVkKTsNCj4gIA0KPiAgI3VuZGVmIEtWTV9Y
ODZfT1ANCj4gICN1bmRlZiBLVk1fWDg2X09QX09QVElPTkFMDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaA0KPiBpbmRleCAyYjYyNDQ1MjUxMDcuLjkzMTdhYmZmYmY2OCAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oDQo+IEBAIC0xNjM1LDYgKzE2MzUsNyBAQCBzdHJ1Y3Qga3ZtX3g4Nl9v
cHMgew0KPiAgDQo+ICAJdm9pZCAoKmxvYWRfbW11X3BnZCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBocGFfdCByb290X2hwYSwNCj4gIAkJCSAgICAgaW50IHJvb3RfbGV2ZWwpOw0KPiArCWludCAo
KnByaXZhdGVfbWVtX2VuYWJsZWQpKHN0cnVjdCBrdm0gKmt2bSk7DQo+ICANCj4gIAlib29sICgq
aGFzX3diaW52ZF9leGl0KSh2b2lkKTsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3N2bS9zdm0uYyBiL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4gaW5kZXggOTEzNTJkNjkyODQ1
Li43ZjNlNGQ5MWMwYzYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9zdm0vc3ZtLmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBAQCAtNDY5NCw2ICs0Njk0LDE0IEBAIHN0
YXRpYyBpbnQgc3ZtX3ZtX2luaXQoc3RydWN0IGt2bSAqa3ZtKQ0KPiAgCXJldHVybiAwOw0KPiAg
fQ0KPiAgDQo+ICtzdGF0aWMgaW50IHN2bV9wcml2YXRlX21lbV9lbmFibGVkKHN0cnVjdCBrdm0g
Kmt2bSkNCj4gK3sNCj4gKwlpZiAoc2V2X2d1ZXN0KGt2bSkpDQo+ICsJCXJldHVybiBrdm0tPmFy
Y2gudXBtX21vZGUgPyAxIDogMDsNCj4gKw0KPiArCXJldHVybiBJU19FTkFCTEVEKENPTkZJR19I
QVZFX0tWTV9QUklWQVRFX01FTV9URVNUSU5HKSA/IDEgOiAwOw0KPiArfQ0KPiArDQoNCklzIHRo
aXMgbmV3IGNhbGxiYWNrIHJlYWxseSBuZWVkZWQ/ICBTaG91bGRuJ3Qga3ZtLT5hcmNoLnVwbV9t
b2RlIGJlIHN1ZmZpY2llbnQNCmVub3VnaCB0byBpbmRpY2F0ZSB3aGV0aGVyIHRoZSBwcml2YXRl
IG1lbW9yeSB3aWxsIGJlIHVzZWQgb3Igbm90Pw0KDQpQcm9iYWJseSB0aGUgQ09ORklHX0hBVkVf
S1ZNX1BSSVZBVEVfTUVNX1RFU1RJTkcgaXMgdGhlIGNvbmNlcm4gaGVyZS4gIEJ1dCB0aGlzDQpL
Y29uZmlnIG9wdGlvbiBpcyBub3QgZXZlbiB4ODYtc3BlY2lmaWMsIHNvIHNob3VsZG4ndCB0aGUg
aGFuZGxpbmcgb2YgaXQgYmUgZG9uZQ0KaW4gY29tbW9uIGNvZGUgdG9vPw0KDQpGb3IgaW5zdGFu
Y2UsIGNhbiB3ZSBleHBsaWNpdGx5IHNldCAna3ZtLT5hcmNoLnVwbV9tb2RlJyB0byAndHJ1ZScg
YXQgc29tZSBwb2ludA0Kb2YgY3JlYXRpbmcgdGhlIFZNIGlmIHdlIHNlZSBDT05GSUdfSEFWRV9L
Vk1fUFJJVkFURV9NRU1fVEVTVElORyBpcyB0cnVlPw0KDQpbc25pcF0NCg0K
