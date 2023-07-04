Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE7746C89
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 10:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbjGDI7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 04:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjGDI7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 04:59:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9736F1AD;
        Tue,  4 Jul 2023 01:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688461148; x=1719997148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B0Liun5H47zI7VLtzpihzO5mn2vrOnoXsA76t7JLbhs=;
  b=SGOJT/5ER4ijIznpLsSoZKybwb8yulPcTZ1nN2xTeromvOEIpCcPM49w
   uoZjekZ52MJ7lkE4FwvSyB9zBwXyb4ZcEj6wD3HLtxJLffFr6S6cFT806
   KHhwxaorvI7uw4bvUS+mAbgQ/RrFM/Oc8pVu+VtXZa+3hvJpuSGmgVhia
   J6rdnoDqyPBhdMakFDNyiQU6C63lil16OEfR/pJ/XjkhdVN+x0b3BWxuM
   JWPQsXTxx/thkUnyaYNN+e5yoXGRc0IannsjpSxpW9D4TzOJ1cSafYVq2
   3C4pvWd9673//DdF++UNZPkPuOVLUw5Uv37NmDKg1I3fa9f4jhA+RCktn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="360555392"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="360555392"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2023 01:59:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10760"; a="965449714"
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="965449714"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 04 Jul 2023 01:59:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 01:59:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 4 Jul 2023 01:59:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 4 Jul 2023 01:59:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 4 Jul 2023 01:59:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My4BqV/wAkUY9CqOMzbBMEm+Vcs6HYWczLwLAetQrAD9g268tkevmOlwIucsN+3vhLimTKYsWqhYhqjGqbgl74Fatt5qIPF8z/zq6qdcV2j6CRM3EbeePgfIttXVkSvmWhvWD5euM5sTvn/0UoXVLxQnSzVIwFREVxGCU69AlfKwmyPxtQF0IT/WDsz0Gz/fJL+ti7xlLP1vKuE8xwgEmbe1c4bxQvO5s1iTmUsl8nudrUck7B8i6CERtsn0q64mJawL0jYmFJZwuWxkDuYsV7KSeaPpqSJrj2QgoZg2BYlmSKHCfwxlrcgD4czTMEZnWGJu4o7dCriiKkOqdHpS/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0Liun5H47zI7VLtzpihzO5mn2vrOnoXsA76t7JLbhs=;
 b=hSfiBu7Rn4t6uaKq2jR2nDLS5ilGE5gbQNbxdy4YJee8LA+O7ErfKp1UFkZAEBsjqgFdpBgZwCPKrP/mlTU1mW+z4NhJTuIyDva64Llk6sYf2RrdS45g00O8wvF2n51FjlzHA7LD18A1FOZG+I1M+LHnFYU5nf+S/kT/hRfrVwiXWfxfSBdRBrA/z+oLWGtqcNHlyv1npSNmUj7WVnuO6aseias+3lrgAVsvMtIU5RhJwPyL3BVXvJfGdtLtPQgW/VKXztLbbFz2XAxbIiot0pTFfuiT0FtlIDDz5/LFoLgYth7BA8FsIxmUyAjYlFbkM3G9xcZyf4HU136FIKWJsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6830.namprd11.prod.outlook.com (2603:10b6:510:22e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Tue, 4 Jul
 2023 08:59:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6565.016; Tue, 4 Jul 2023
 08:59:02 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHZqDW2SDcq1vhkU069JfN30XLipa+pRQ+AgAAWDwA=
Date:   Tue, 4 Jul 2023 08:59:01 +0000
Message-ID: <c366ea02dd1142e553cc816c748f6b5d2adecfbc.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
         <20230704074001.3xlsycy6c5vrc7d2@yy-desk-7060>
In-Reply-To: <20230704074001.3xlsycy6c5vrc7d2@yy-desk-7060>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6830:EE_
x-ms-office365-filtering-correlation-id: 9998fef9-0cd2-479d-feb7-08db7c6ce92a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iNovrJLfDzkWkj/O6hNgxsR2PN5Rql+EwddZTEn22UyB/VCeMhM6BsMmL3VWH8gZ+yaFpzdSTO4UjhGGVEmpDS8X7Uu3aIbRivdj6omxgpxgeL3kypf4FIf09DpN8vcMPpMROahFki+R7ypmfGAPX+DavXFhd5yVbcQiKILqkEUUFREp5HDnz/FYbnH54fD/u/s5dJ1DWqChkZfcM/BMK6WNJ4ZudyVfEpPBCTMdhnwrRycz5syDLRkiSl7Um0j4SLARXHrXeFlBYMRPHyyjgxpkrbliKiL0bTMnNXh+qR4vBRG+Dwgv20HJvQq3Hv07EqxvucFXZQJJF9KDixjtWVb7pOWIWM4a0AxL4T+xoFnAvWK7S0N+GjlnHDreODevAeEnXy2gyHsxshTeZJL3H26g3eousIh8qSJ9zGDe8J3D6NIZ+Oud1qx9pHsbzKG5tlIlssVpffLgxs+f8Z37Y9Qx11gtihJ5/fEJck7KapuutU7oWhekDixGYeu0CvEPrvzBVj/bjoTndb6tS3tJJ1uYirF271eLIxgaLz/e8O1KoWWcaMEg42Zp/75B/gllyO5nlviud09G3QGIyErEhrbWO1vhlD5bBBvGIuyUKfwyK/jOJ+n2aBT3IBhkUusm5o1/KrWMV3/D1jp/365OGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199021)(86362001)(71200400001)(54906003)(8676002)(8936002)(5660300002)(26005)(7416002)(6506007)(66476007)(558084003)(478600001)(66556008)(66946007)(6486002)(64756008)(66446008)(41300700001)(76116006)(4326008)(6916009)(91956017)(316002)(186003)(6512007)(2616005)(38070700005)(2906002)(36756003)(82960400001)(38100700002)(122000001)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2w3UHpCRFZIQmFua3J6azRIemN2QytZb1MwY3YyQUNMY29UREcxMk85WU9l?=
 =?utf-8?B?bUdEOEF4MTFpeGNyRGlybmNGWjdjVUV0ZHpSenlpd2pNQkNxSTcwWk9GSGIr?=
 =?utf-8?B?NFNmRDNDUkFUajNIaUZYdWRESVRoQys4R1ZKWWk3SWVhNzhOL0JyVmF0QnNS?=
 =?utf-8?B?QkhmbDdKdUxBQzFHT3pjY0cyckcyUnpWV0RRRXV4STZDYVZyVVV0ckhaUDZU?=
 =?utf-8?B?MGUycTJzK0M4QXlTN1ZHbVl0ME16M2xNOFVJWUtqbVVFUG1hUFd2b0RsenlY?=
 =?utf-8?B?eStNdVRIVUd6UHpod050U1VpL1BIcGUyTk10Ty9veGxBbW5oY2pmeHEzV0Mw?=
 =?utf-8?B?UGU2cnJWZzJueWZPOHRCK2tUaXRtdjQybzVTQjJKdGpvTmg1d2Z1eTBzWEEr?=
 =?utf-8?B?RlRSRTN0ZU5BeFRzR09hT2xGbVBzbXRIN0J2QWVJUXVyVzErY2k1aC9kZHdn?=
 =?utf-8?B?Q1hncXJPVDRndVJKOEcyMUx3czZSckNuQVhTbWt1TkRlR094SmVrUWFHa0VR?=
 =?utf-8?B?bzhyaU1rSDY0Nm52SHlYeU9PRnJ3ZklxcngzYTl1L3VmeWx1YVhSV1RqZUZH?=
 =?utf-8?B?TUdtRUwySGFmcVpzWkhTRUhNTlh4R1RaQitJbk9WU0dYak42V0lZNzBKTmRS?=
 =?utf-8?B?R0dha2lEaXVoSlZKK2RTeFk1bllVbWRMcHBZSHB6SFRHWVJWa1hwN1BSWDBB?=
 =?utf-8?B?TmtOa3RMKy9qdHBjQ2Y5Vko0MHp3SnprZnpQY0pURE4rWWNtbVV6QUp1WGIr?=
 =?utf-8?B?K2xVTSt5TjkzY0NCbGpHaHBzTjBzL1pZMlJIQnA4a3cxNXFOdno1VEdBQU5W?=
 =?utf-8?B?eVlJWVI2TlFJa0ZPVHpPdlRzVTRYOUlieldsSVdwdm5hMldjVExVb3ZieEQ1?=
 =?utf-8?B?Vld2VEcwdW1GSTIzUHdKQ0c4THE3ZGlJalM1Q0s2ci9nTjlCUjRGUnJUL2s0?=
 =?utf-8?B?cHJ4eS9jWVowYm9mN3VMSWlEa0x4Mm5rQnhJZURwTHdKU0wxVEI5TG1BMEhZ?=
 =?utf-8?B?ckZYTitpSzAxakVyRnNPVGZGM001TE5uNjIzRkRjenNOaWdXak5mb2JqTzht?=
 =?utf-8?B?L0Izc1VIbEhXeDJWZ0hyZUNycUl6NGVnNlhQcGZSMEcvemRuOUZLcDJNWVFh?=
 =?utf-8?B?RmxPbGhqSk9CTGJ4LzY2UzdEZ0lIeXhpNDdpQkt4ckFvLzJZSHI1VkpwZ1dM?=
 =?utf-8?B?SGgzQWprYUdtVzZ5VU1JNU15Smx1citTQWJHT2JKeEh3dmt4dzFzZXFwTkJL?=
 =?utf-8?B?aUFNY2RDQ29UMmJ4UGhDdzY0eCtYSXhQYVQyM0hMVm82dDZTNkdwWEltRkw5?=
 =?utf-8?B?Ylg3NFczYnBveWFKTjVzRGkxU0lwUFVjenl5QjJqNmtWd3NKNlJTby93clRV?=
 =?utf-8?B?L0J2WlVqMGNUcExhTlhUQ2c2K0s5aDRiTDUwTUZSK0JEQlEya0pEUmVrb2pM?=
 =?utf-8?B?dE1CVGVBdXcrdkVwUFNhSXlqZ2NGcGE2RlJhQjFuRWU1cXg5eSsvZnNVSldC?=
 =?utf-8?B?UWlxQ3N0S2dSbjJmTFpMTDNFSnF1TFZhbFM5ekpvUFRaV0lzREx1MlZyRVFv?=
 =?utf-8?B?alRWNzYweStQbk8wMDlSYitHRVpucklyb2RFYlgycVc4RllkRy9XUERJMGJi?=
 =?utf-8?B?a21Jb3R3aEdrZEU1SzVObjhhRzliS3U4ZXN2MFlSWSsyV2huTnVqcTdrWjUr?=
 =?utf-8?B?eUFsTVMwYjZ3MUZYU0U1QkVNUDg0NU9aaVBGUWpuU0c2NnpqNE9mQncxeWZB?=
 =?utf-8?B?SUFUYlptbmdGQ0prazdqVDlvSFJPZGlzaUVtWjdUS2tWMG1aNUhyYlJJOWRQ?=
 =?utf-8?B?dUl5NzkzSjNtMGorNkZnOWd6cGVJeXFIUm51dGtLN3Y1ZG8zUjhoZmxaanJP?=
 =?utf-8?B?R05xSGZ2c0h5d1d5REZ1emxjaGlvMnVoOFVpaE91eFpScXRDL0Zpclh1anFK?=
 =?utf-8?B?NC90NGlDblpTeDQ4RlB6OVhldWdudWhZanVmL0t4SEhkZ2NXbS9SU0t5WXp4?=
 =?utf-8?B?NVNlWVBnQ2RZM2VPZGUzSUFLVWZIK3RpYWVIVFhKbjMxM0h0dUhMbENtaG5r?=
 =?utf-8?B?NWVmVVU0UTlNNnJVRS9oL3FveHM2OFpDc0RiRU9Za2xLeUFIWjZvYnRtaFhL?=
 =?utf-8?Q?q/QeOqedeYcbHPWqtabJ+5sw0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A581F86B86C9A4A84E884C4FD45F4A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9998fef9-0cd2-479d-feb7-08db7c6ce92a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2023 08:59:01.2948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H7RGwuZm1tXXRfGk2BAg4IsBp7hjn/v8yl7pI5EcXnVYjo6qofXG0xEp+oR4J/lim3NmFepxm+r36tXoaJnLug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6830
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

T24gVHVlLCAyMDIzLTA3LTA0IGF0IDE1OjQwICswODAwLCBZdWFuIFlhbyB3cm90ZToKPiA+ICsJ
Zm9yIChwZ3N6ID0gVERYX1BTXzRLOyBwZ3N6IDwgVERYX1BTX05SIDsgcGdzeisrKSB7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF4KPiBQbGVhc2UgcmVtb3ZlIHRoZSBhZGRpdGlvbmFs
IHNwYWNlLgo+IAo+IFJldmlld2VkLWJ5OiBZdWFuIFlhbyA8eXVhbi55YW9AaW50ZWwuY29tPgoK
QXBwcmVjaWF0ZSEK
