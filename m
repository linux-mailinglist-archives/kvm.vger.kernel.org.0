Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628CD74067F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 00:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjF0WiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 18:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjF0WiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 18:38:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568BC212A;
        Tue, 27 Jun 2023 15:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687905484; x=1719441484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JwDMJDEEAPWAzBRulFyci4hDczn9trbyUnN7j60RLlo=;
  b=PkrNTnIoFAlmkpbW+YiZTjEVfLedUgoB5/jAvBPvy8nD+4LSqEKh/7io
   j9g42jr/y8cK7/EsBt2jL6CJ+1WyLWWLuIWiV4xe4Mmi/aR4Xm6xWehwt
   AnZu2xD97nRXuvZtPEADY0NBwfaPduncy9UtwUH27To58o2fi7SRnUV9b
   CRYo4BnwoUfUayHdeBeFHbtZWPmj3jAxweKLGANbDmUlCL434wLWHykF4
   htwGJIzQuY37d8qsiRjuXdvny3h+UnksLQqSgLRPqhyKAWRFP5DQvUzov
   5CqHLBXJUTJNKr0/rYcsvEtnxyMi/KmDwRfry35M362+U90OgJTNErFIJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="448081953"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="448081953"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 15:38:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="840847247"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="840847247"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 27 Jun 2023 15:38:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 15:38:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 15:38:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 15:38:02 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 15:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRcG/PYNonP/Mdz4U3zPzYJwGwvIisi+uXfkLFCrF1rKpovay5Bklb2f327ryuXnMyCR9jb3QBtRqk5ghnEIxHs7uuqHGO/EpwOLKDJNBcZF4eFP416y0m8eEc7vQstfwboH24IsiXjxOu9oy6a7eIjXCpc2AH7a1wSnFNKg7LBOFfxsjI4UbGXSVrx8tajokaIvqut9O4QlPVY3AJ3VZrBac1Cs25CBUz3gBRGJq8hXkXuetcRdV33OuHHLWrKkz19QPE1dD4CU/st4G4jieli8sRuVSA/DdOOzl4M1Peh1Ot6vP7GDHkV9sM8X1Zde/mUaE8aavxJ9BsinuvcvWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwDMJDEEAPWAzBRulFyci4hDczn9trbyUnN7j60RLlo=;
 b=NPIniv9W4fWO2DpnAHAQXua0ILJ0/u3JMlYuQ2DrTVAON+sxCa68HVVqGc/MTWTcjnnLDvkruwRxMvCtUH/jKVnYuB5dmCrUf//n5l1puKg2nCpKzCgqpzYMvHnxnvouqFoU81eadzLRh1RWyJET0cs2tUnaXH92s1oBExRubdhBBsKXrv6i0ApllC44LgA0HnEt7B4dXf+Uu03258chqadZmBnkxOAa8I4TavQnuLriCjcVRMS7zeOabm2lLoopYTtpDk7vjJoxh5WdAjHPDVu29V10tjchc0lciqXhwCwlNt8feHSw0tnMgLQ7MGvNTn3Th1F5WqmoUNXD9HPN4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5275.namprd11.prod.outlook.com (2603:10b6:408:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Tue, 27 Jun
 2023 22:37:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Tue, 27 Jun 2023
 22:37:58 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
        "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+eaRwAgAAMPoCAAB1NgIAArPYA
Date:   Tue, 27 Jun 2023 22:37:58 +0000
Message-ID: <9361abfa9bf22c2a1a4b25e5495bcccc5b8dcd43.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230627095012.ln47s62pqzdrnb7x@box.shutemov.name>
         <d6a0fb32ebcdeb6c38ebe8e2b03f034f42360c0f.camel@intel.com>
         <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
In-Reply-To: <20230627121853.ek5zr7sfiezfkfyj@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5275:EE_
x-ms-office365-filtering-correlation-id: 16ce655e-8c76-45d6-a580-08db775f2874
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dqDggh8lrboFxTwkAnbbx/z+IBlyVJgSm1EoAzz7yAab2CkwT+lDpRymak5IjLDLRm6uMC499RMBusRKdizeEC2oJASeaBd/Pc/+Zu62Hi8qtQXJboU/yuStb1JY6QGLWqVpeFupAFMAUHUzp5NMV6Vj7HE2gOTm22DSYMeH7ZOFk2cmYhUDQhAN2uN1zEDksFQnfFvhuwROx+CC2tuGrEVFw/cu/2DYvr2zduRGNIHOuftiSEpkpFLQMWUBVy+FgSxdpJZqoaOSd9iB2YNQmxtqSAB0GdPi11UO40R3UFUSP06wVvKxi4H6KndgNufLt39ppidGAyXbQrCsw+pPrJNg181wPgshWhNoVkhR8yeTJ957spSfbi22SWZjcfiagdrVPeikxQ23c83osoqpqg1weFoNf5JaOu0YI+zgpou59RBRmVB/7X9UsH/w4DPyZl8qVcoSx9x4cxu5+ePp+3Hqec3T7z7BjSodNw47vMhpIXlPe2YL8fM16VCicGa5gUDXyfXe3QjRqeV1SmMC22yenI+nCge/tHfx4kBGnhWa04TwUD6XOsamUvKN9i/liYHGE0WoUngECSJAuQqYSL2v4NxvT4aFg/gOMoyofJzDK4akhWdKR5FzlHdkTaNp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(39860400002)(396003)(346002)(451199021)(6506007)(36756003)(66446008)(6486002)(478600001)(71200400001)(26005)(2616005)(54906003)(83380400001)(2906002)(4744005)(6512007)(186003)(5660300002)(7416002)(316002)(86362001)(66476007)(76116006)(122000001)(82960400001)(66946007)(8676002)(91956017)(41300700001)(38070700005)(8936002)(4326008)(64756008)(6916009)(66556008)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEduZTg0d21RSC9VcjlwK3N4b0YzMG5Cb3BrTUhYQWNpRUZzUWthL2tNN3Jy?=
 =?utf-8?B?dFVlTFVDWEQ4a20vdWl3QUk0TEpJc1BzcU1EM2cwRU5PNGY3cXZNdjFPUmE2?=
 =?utf-8?B?UUxzeUxBOGZiMGh1NkxYL3lxSXkvd2hVWVVvcWtFMFhiUEpFV2xzc29UNVZW?=
 =?utf-8?B?bVNLcmp6U2taeXlLbzJTZXhqWmhBODZ4dVBncExsYURwaUQxeEwvdGRGODgv?=
 =?utf-8?B?RzNLV1A0Qy9ueFF1YnZPZUxTdTZzdVdDaks1aHBJdHRUNEU3K2JjRkJqc1Rv?=
 =?utf-8?B?bTAxS28vUUN5Ly83Q3Y0c0pNM08zKzRhNFlRNFpTYjFxR1BITVdaNkQyTlo5?=
 =?utf-8?B?WmZJOVJOc0NxOHNLNWhNNTlGdXByOHMzUTJYU0xIcG5jbmpqc1llckFVQ2Q2?=
 =?utf-8?B?NU9UNjdYZ1RBRSticVB2dU1zQ1I4R2Zsd051UlVOSS9mRlB6YzNMOWIySDYx?=
 =?utf-8?B?aUN5K3RMZzRmenBsYUIvTVpaOXpKLzlQeFp2eGxUalpxTjdSS0YvbUp5Mmtj?=
 =?utf-8?B?eGwybGVrK00zOUdlRVB6ODJ6b0VZOW0ra2E3ZE1XTEtkd3V5cDA4M3ZqSGxF?=
 =?utf-8?B?UG5WYU96QkhrWGNMMnF0YkJCR2M4eWRpSXA2NXdKWldYdjdBQXNRSkwzL2JC?=
 =?utf-8?B?TERNRklUMzYrS01aWjQ5THJhbVdHVUU3VktLZWlXdGNyTWozM2g0a3p1VGk3?=
 =?utf-8?B?UVBpZHlmWHFoQTNHdERWSXJCR0prMUtqUUNZRkJQdTREbTBuT0hocTVFampr?=
 =?utf-8?B?dWtzVG1BWTBwWGdQRDdrY0RZR3JYcC9SUUFSMFdZdkNlZHJSWjRxQUNnM3Q2?=
 =?utf-8?B?L0lvK0xwNXQ2dmJBS1VWVFNmc0JNcCtsbWNXNTFNRDBYcnN1dkZHVTU4UC9a?=
 =?utf-8?B?VHhhYnZqT0Nvam1Demc5aGdKRlVUa3lrNXhIL01BOGVpanpoZk96RzVxZHRw?=
 =?utf-8?B?Q0NlSXgzT2JtNS9iTEpMb25jQlhGUWo5aGVsaG9TZjFKVjRDNTNheiszdE5w?=
 =?utf-8?B?S1pyMFNsdTY0VGRDZWRKY3RucDVDWWpralJsNVVJRHZ5SkY0STlaLzlOL0dI?=
 =?utf-8?B?MUZpYmFxZkFaWFUvOFFweTF0T0hMa25IZ1Rnb1gwejNMT3dSQ2wwUExqQWFH?=
 =?utf-8?B?MHZDMTdZZWhvcVRzMDBrYVhoRnR4OFMvNW5hdlFWRE1xSU1aM1FBK2ZLNDhu?=
 =?utf-8?B?TTVtVUVjZGY1dWl2YWNtY2RWYlZiZS9nbW01UjdKNU85UlJRR3IwSENCRy9w?=
 =?utf-8?B?MU1ua20xWE5tdCtGdDRXMHd2SXNXU3hhZDRJUkxTby9Xa1ZtUFA5aFNuMzdB?=
 =?utf-8?B?bjQ5TEpBRlViMTl2dlk5eE1TTThaQVQ1TzdDL2ZrSkt2YTYrOHlzSHhxSHVs?=
 =?utf-8?B?T2VuTTJhNEYwNlorUnJaQmNWVVpUQmcrZjlGUUJpdG94OTF4ZzUvYldlYWZj?=
 =?utf-8?B?bU5IVmNjTHJZeWhISGpTbFlUekJLRGNFV245WGE2OS8wRzVkVzh1MHBVWU5H?=
 =?utf-8?B?RTFWRXhsdWFuK0w4dUV0THlFbmpKTEZBaWRUUmV5SWhUcEZjRXQ5RUJkOFJs?=
 =?utf-8?B?bWM5Mm4yYkt2c05obkdIQm9LelRDTzlhQ2Uya21odjNyNkN2dHRNQ2FaNmJt?=
 =?utf-8?B?R0lLVXpsdHBMdmVkYytlTXpRZ2hyRDgzUnl1aGNGaXNCeHRqOUoxckI4U2FH?=
 =?utf-8?B?ZTJjcU96NnpWVFVFbnRYQm1yM3BOaS9Kb01OSUhBSUlZWldUWWgwdkFpYVpM?=
 =?utf-8?B?S1JWMWZIWm41bGpMU0l1ZWhwM200QWkyNUhJdEU1alZJMXMxb3h2ZjJjdThv?=
 =?utf-8?B?NUJ5VVVqOGtTS1FQeHYrWjlvVGVXTXdaRnlCcGQ3SXRkR0diS0tldzN3R0wy?=
 =?utf-8?B?RUsxQlpkeitzQ0lEckhrTGl3YUU3RmdKa2dJTXdNdVBQVkt3blc3YmUrVXhn?=
 =?utf-8?B?WXgxZ3RuQUhjcmpBWVczVTFZbWNMRE50Sm5MT3NCWVBHV2RRdzRWeTRuNFp6?=
 =?utf-8?B?RDJDT0llSDgrRzBCb2pKUm42SUhNVHk3eEVGUnNJU0JkRG1PZFBIWngwY3hN?=
 =?utf-8?B?cGxPeGgwT2MyR2wzR3U0N2tNNFplU3JYSHJaWXhrYkxwM0pkdW9RT0NWK1FX?=
 =?utf-8?Q?jtWBfF/FeFeimjQl/PtPs2+Zc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFFE992E2751C140B057B16DBF785234@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ce655e-8c76-45d6-a580-08db775f2874
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 22:37:58.7060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qvam88bF3lLLWi9kH89RCVsgGNXSFaZE+emHveV46iVkIwy6WWrlTyShDgYVGatfrQh13Yi/t+DO/iAgo+WypQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5275
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

PiA+IA0KPiA+ICsvKg0KPiA+ICsgKiBEbyB0aGUgbW9kdWxlIGdsb2JhbCBpbml0aWFsaXphdGlv
biBpZiBub3QgZG9uZSB5ZXQuDQo+ID4gKyAqIEl0J3MgYWx3YXlzIGNhbGxlZCB3aXRoIGludGVy
cnVwdHMgYW5kIHByZWVtcHRpb24gZGlzYWJsZWQuDQo+ID4gKyAqLw0KPiANCj4gSWYgaW50ZXJy
dXB0cyBhcmUgYWx3YXlzIGRpc2FibGVkIHdoeSBkbyB5b3UgbmVlZCBfaXJxc2F2ZSgpPw0KPiAN
Cg0KSSdsbCByZW1vdmUgdGhlIF9pcnFzYXZlKCkuDQoNCkFGQUlDVCBJc2FrdSBwcmVmZXJyZWQg
dGhpcyBmb3IgYWRkaXRpb25hbCBzZWN1cml0eSwgYnV0IHRoaXMgaXMgbm90IG5lY2Vzc2FyeS4N
Cg0KDQo=
