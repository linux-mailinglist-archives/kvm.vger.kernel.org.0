Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37AF7A2ADF
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 01:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbjIOXK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbjIOXKv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 19:10:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45AD186;
        Fri, 15 Sep 2023 16:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694819446; x=1726355446;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eI2qERF9VjreKd+9JuEhV+yRtUn1voKxcjwiNDy8H6U=;
  b=Ds4z1HBVDgpH983lGFa6Cd2HgwWWOr3NQjb8v55BKLhBc2RCoUjY8+dx
   QaT9/oDuCtTkE+22G7TWZiAfAdi+z8+g1n0hV62TVuKKTb8wS9R+VLNh6
   eldMIL6aUg4+WWjJwDIjXPs+rwWU4aJr7iIZNPWVvc88TMfFCfV4+xddJ
   EPPJruRp95IOW7j5rs9+lRZbtdsGjCPG7Me14Nq75GZEi6JttO3+xpJKF
   jAniqnQ8stBxKnRiSFozamFKvL8werJ0SFx200F5vJ31p6LMX9hg0arjR
   xNdwZhz7nWm3GPBoreQjms3R/w3113YjIaK58OBxkncVc64QBnL3S3QgM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="383194849"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; 
   d="scan'208";a="383194849"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2023 16:10:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10834"; a="992031088"
X-IronPort-AV: E=Sophos;i="6.02,150,1688454000"; 
   d="scan'208";a="992031088"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Sep 2023 16:10:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 16:10:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Fri, 15 Sep 2023 16:10:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Fri, 15 Sep 2023 16:10:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Fri, 15 Sep 2023 16:10:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=namjCF52g0AOSx108KGCjQRekysEsTFsVvphBdASwlIWsIXwOCHuBIXkAeHF9qmFVaZywn2o/TzqSVT+5DaQGv74kBhQ92+b8EuMkTd7CvvPvLSujtgenmju7XrW8AFtdpb7gEfqxNW5CNpcTwZ+zm1BCVBEjTzp9WfiysQP7PryOyWXfvGmuACw+jAMzVBExAv6yj3mBT25/6pQ5c+2NleDs4ZvkcPqps6uwiV+i99xws+rJBljXaLiLEFoT8EgeKIBCZIyHvV/gTxmD7sQrAUdSP65ldU138XGfyw9ZcWw9zg4EG4/G2qXkAOYmpjK4km8OIqAC1m+D6OpXpzikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eI2qERF9VjreKd+9JuEhV+yRtUn1voKxcjwiNDy8H6U=;
 b=JPBx11uFUkZRWAk26qpG6tg10WO620wIHbfblEEIzGw4T5kHTbVTRNf/zz5t+R6UtB/1hBJ/R+AVPsNKmhiXtzcIaosGOUaLsvwZ7ym7NnqN3MRzQvymTmToeQQQG4GJsYUZRi+xmylry38uakQRf+cb+6tW4c6Gr3XhkRGnm+0gWjfcGXpPwglwoaXqGb2cHO3lv12TOQNx3SuAPPcMJnzkRrDzZc9G0ThOIF86w8loI6EVpdc4/afaZFbM6Vkkq8MZG2L6d1Co4xflPn58B6P0UetQYkHLOO0Sd1kINtRp+q5hK5fQdpbT3Zo08lywY2/TLt1u48i/kNbT3mthGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Fri, 15 Sep
 2023 23:10:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::56f1:507b:133e:57cf%4]) with mapi id 15.20.6768.029; Fri, 15 Sep 2023
 23:10:42 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
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
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
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
Subject: Re: [PATCH v13 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Topic: [PATCH v13 18/22] x86/virt/tdx: Keep TDMRs when module
 initialization is successful
Thread-Index: AQHZ6CnZ4DP0QbX7P0iURHxqvostqg==
Date:   Fri, 15 Sep 2023 23:10:42 +0000
Message-ID: <88a72d16cee7fe7331439a0be85e2cf8d4381ecb.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <ee8019b33d57f2a4398a55cc5ebfdf21d918f811.1692962263.git.kai.huang@intel.com>
In-Reply-To: <ee8019b33d57f2a4398a55cc5ebfdf21d918f811.1692962263.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6763:EE_
x-ms-office365-filtering-correlation-id: d7064de8-7871-49a5-0aa0-08dbb640fbf7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PPFMnTiA0K5QBA/2Caf5od51OELBqkUaOM30E6fYtIpfvr4yCGS9SxmhChMNedrHOm8vRqcjAHSjj5LC4KfWSXJKDv6PPu5rAwOXefxM7A6xZ5uT5IED37hO+fFIRIH9Wm2w52eK9rAZTQ7ty5NAx0x+mTwK+rstRYtLR1ETNjhIZbj+Fj6IytroVMNPk4q8CrmzOF54FeCyom2XYmOT4MdJ28jIFhMSvB8nckpqiKDW/rEsEmWMUUCzyzScoxR56BZPgrUXuia7uc8TcmeYri4OJ4M9nW6uK+Gxg4wOTBq3t5XiixSz5br7+uPtyDhGpbtP9mm1qXmnChtbaWF4ha8+qxlfYD11E50UMR0DHrsu3p8HefOibHUJIshPQVuSjG0J7FYfrkRWDR5bjrrgc8vnv2F3/4U5JckXZqoNOYsjz7WAkt6mbYF9lhJQf/gqo50B6IU0aTO2jGJah5AXEnApbzfmzL3MDCD0z6LWPqS0zipw2CUSpBVPPJeYpdHu5iqorJFdd+IR0cZUnP5iz8qoEGkA4VgQOcnkQoIjJGOgzirFevV2ZldLm8H3r3FITOFixYHsR3Lx9Rwk3Y85xu4GiOkX3rnBOEAYgMcCKoSfrnMmqmHJuTFMuy+7Dv1Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199024)(1800799009)(186009)(66946007)(110136005)(66476007)(54906003)(316002)(66446008)(82960400001)(2906002)(66556008)(5660300002)(76116006)(4744005)(41300700001)(7416002)(36756003)(64756008)(8676002)(6636002)(38100700002)(86362001)(4326008)(122000001)(91956017)(8936002)(38070700005)(6512007)(71200400001)(6506007)(6486002)(2616005)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WElBamZmNEM0Ulc1UUhxRmVERlhsbHlyTkZIM2RCaXN3cnp0Z09QTTZHak1J?=
 =?utf-8?B?WEhWUHZCREt6cFpITy9BYnJLQm54bUNtMHI3amlvTEE1Zi9YVHBJRU1hbE80?=
 =?utf-8?B?ZEx6SGpacFY1ditYOE5MUzNxS2lGZ3M5OE5qcjB2b3BaSjFpTHpENnF2MlFV?=
 =?utf-8?B?UnVFbHVSeWNTN09aOWFza2c2L3M0RXlNeFozZzBJR3NBdW1ZOUN4YUNmWVZh?=
 =?utf-8?B?RGQ5dlQ3UWFoVnVTazVTelJjbDJiVVNKaFNiQzg2NVk3enNwZ0c4NGd1WWRE?=
 =?utf-8?B?TFZtaFhWeEgzKzJOUWdkOEdYQ2sxNW9UT1pGOTJGUnNWOVpTanRaMmxUMFdD?=
 =?utf-8?B?STBGeG0vODNlSmxjWERJbktVUDF0ZGI5VTdjR2JpM1Q2TWY0NWpxNFB5ZHVh?=
 =?utf-8?B?alFucVdGN1dRQnpKbkloa1pZMnJKMDB5bnU0S2xKYW1CcUJmVXBzYlFpUEtV?=
 =?utf-8?B?cDVoT3RlNVN4K3VmSXBnWEJKb0tIOU1BUXJXOWlVVlZXbUdaSmZmTWdTRkhV?=
 =?utf-8?B?N0NOOERCTDJqc0Z1eFJXa1NMaVVlU0ZSMjdKbW9wbFo5V3kvNS8vTDJlWTMy?=
 =?utf-8?B?TnRsMmxRUmJKNmc1anB4cTN5TW9nblBuYzRCQWNpdTNpem9XMHhRR1FQVFlF?=
 =?utf-8?B?V1ZvMWk2ZWdWNUlPaUlYcGQ4ZVM0TTJyS3hmUTgxS2p3STl2OG5kWURldDRQ?=
 =?utf-8?B?M01vMC8xK2dBOVRrVzdFU3Z3VXNFZTAxQkpldFowakJyd25qb05aK2tvYmM4?=
 =?utf-8?B?K1RIZHgvUDRmdGtraTBDOHdqZmVLajV0aEkvODNvbnBsL0F1Q2RQeVMvRTgz?=
 =?utf-8?B?RHhXcytVODNyOFdqUW5XeDVnVzd5ZU5LZ1VUYVNmSmxlSm1EamFuNHVOZlRs?=
 =?utf-8?B?bzFuMUpxVGdTZmtNUHJHb1FPaUF0d0Q5dTMyWEtTN256OHVoNWhWa1Rub2pn?=
 =?utf-8?B?ZzVzdkg4S3dnRUJEL05wanR2ckNVOGZRTFBnOFpabzBlR05rU1Y3bXMvOFhQ?=
 =?utf-8?B?YTFDakJRd3AzVWV2V2FwbFNwaTNVaTlVQnd6dTUrVGludVZKa0VIZGIyK3dJ?=
 =?utf-8?B?S2ZPVHZPN2tvRmhEY2d1RSsydXJKTUx0NnJUZGNxeFBjbGNxK04rTllneGJV?=
 =?utf-8?B?d0lJN3R6UU5uNUpnd0ZPS1NsTi9hNFpmQ0lXTVFhTDlWbzN0d05GRGpHdng3?=
 =?utf-8?B?YmZvN0ZNZlRwcUJxNC9KTW10ZXRtcFBMVUpKby84OCszT1ZiNWwrTkhHYzd1?=
 =?utf-8?B?WmFic054RW91K3Q1YTRKYkRSYXp5YnhITGJ4dlFYS0JyZUllVjkvcXZhblpP?=
 =?utf-8?B?UHN2emNBQzZkUEtlazlydUpYNXlSdWFhUEd3QkFaejNDWkU1cUtkQjNaZnJr?=
 =?utf-8?B?MlMrR1MwNkNUY1FXbWY5ZU8ybVBtY2RlRGNwamtBTUlmK0J4WkpHK3hGMjc1?=
 =?utf-8?B?TTJOdllVeFo5bFR6RmhPUFRBZWRFbWQ1Mzdod2M3VEcwaEtoK0hMR3FLMnBY?=
 =?utf-8?B?ZDNaOXhxOFQvd05BdlhDMHBJMzNic3NGeTh5STR3bVN4ODF5L3hjbURJR2JS?=
 =?utf-8?B?M2cxS291QXozUnFiNkhWWnV3VzQrNzhGQS93dUZDU2ZPZ3JEOTAycnFPYU9H?=
 =?utf-8?B?VWpKVzQwYTgza3JraTUvZUcyakVTekpvczZVRjFHUmRDd014SkVtQ0ZKR2oy?=
 =?utf-8?B?ZkpLSzFVREpUUmVHc2xKejVsNU5DRFcxdmxOOG9qSWx4cEVyN09ZbGRHK29N?=
 =?utf-8?B?RklScE1jczNPeC95cFM0TmhwR0Fyb1JKQ3RTV0dLMDBFUG8zODgzRlR5ZzI3?=
 =?utf-8?B?cm9tMTh2Q1VlSU5ZZXVjSGFjWXdnVzI4L1YvcWJ4TExEOHRtbngxWGdiWW5q?=
 =?utf-8?B?SnBkODZaTkZEbkpqSTFpWHFhbjVyWnUxb1VSSFVSMkczZVFkSzM3WGhPRXVo?=
 =?utf-8?B?WW1TQ3BtTXBFZGFOUmJGaHdKWFhGK0I0cXRkWmRNcE52MTlFVmRYNk9zRGxE?=
 =?utf-8?B?KzM2QnlaZkRqelB1eTlWdkRkWUVhSTdseE1CWkpSdHJwWVA5WTQxK1ovTHB0?=
 =?utf-8?B?YnQ1L28rSTdlZUR5bDNOZE8reHlqSkpIcFZJS0twb0U4dGUzY29KTmdwOEtI?=
 =?utf-8?B?ekJPeUhuUlQ2aDg3a1RiOGVST2t3U2F3MDlqTVliT2ltTEV4QklNY05jem1i?=
 =?utf-8?B?Ymc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C71A27C82808A8499EF3FD6855AFC8D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7064de8-7871-49a5-0aa0-08dbb640fbf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 23:10:42.4124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUnuXbCwyJBlG4UdOVVzCBabTTsSTiRuckU/d8xg5/1qz4lNGNpyz/fDBs6IhuAJQN0XmRRxGAewZqkhQgXJwgEJFiRln+NDypRpV88Gw6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIzLTA4LTI2IGF0IDAwOjE0ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IE9u
IHRoZSBwbGF0Zm9ybXMgd2l0aCB0aGUgInBhcnRpYWwgd3JpdGUgbWFjaGluZSBjaGVjayIgZXJy
YXR1bSwgdGhlDQo+IGtleGVjKCkgbmVlZHMgdG8gY29udmVydCBhbGwgVERYIHByaXZhdGUgcGFn
ZXMgYmFjayB0byBub3JtYWwgYmVmb3JlDQo+IGJvb3RpbmcgdG8gdGhlIG5ldyBrZXJuZWwuwqAg
T3RoZXJ3aXNlLCB0aGUgbmV3IGtlcm5lbCBtYXkgZ2V0DQo+IHVuZXhwZWN0ZWQNCj4gbWFjaGlu
ZSBjaGVjay4NCj4gDQo+IFRoZXJlJ3Mgbm8gZXhpc3RpbmcgaW5mcmFzdHJ1Y3R1cmUgdG8gdHJh
Y2sgVERYIHByaXZhdGUgcGFnZXMuwqANCj4gQ2hhbmdlDQo+IHRvIGtlZXAgVERNUnMgd2hlbiBt
b2R1bGUgaW5pdGlhbGl6YXRpb24gaXMgc3VjY2Vzc2Z1bCBzbyB0aGF0IHRoZXkNCj4gY2FuDQo+
IGJlIHVzZWQgdG8gZmluZCBQQU1Ucy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8
a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==
