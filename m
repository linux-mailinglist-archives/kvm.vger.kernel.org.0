Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AFF633214
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 02:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiKVBS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 20:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKVBSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 20:18:53 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220B49B383;
        Mon, 21 Nov 2022 17:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669079932; x=1700615932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X5/Oky70qNR5nNt+0jfc4GhFsXkTGaXChMNraZKSIoE=;
  b=Kr0JgPjh1fI3Cwz2AIPpnf1u4QF/INMKdAzbNf4JmuZSGLAtaaban4ma
   cu9W4csSGh40MpeABcRVfk3Hnx6B34boQSkXLkRvmMqhlktIF1L2lcsOu
   s3GrbYj/3MAWTtPetzHLxiaYZ+0WtHhj0szDh0eJS54Yu689UDiQhH5zR
   eh/RIXmEmv0SUXQQJZqc4vZvraIA0dBJLM1FEOvYaBn7Z+pmEESkBb5Cg
   dPbFm4qIX3j2W8+BKReHrh+nHkge3aJIUMyd5XHe6+XTkgkNRJV8SurNm
   OxpXoF2Cauq+pxbgz/15Qo926wjIxfX6Qk4J4Q0MyyFkmgrQyEAKRbwEp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313730979"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="313730979"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 17:18:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="815915993"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="815915993"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 21 Nov 2022 17:18:51 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 17:18:51 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 17:18:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 17:18:50 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 17:18:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsbmA3nZdly/lf0+AIZexXQezLBjFIs2Xmw+rXt7aUW9yVDl+JBUXAZhhe/Y44vH4fyauXX+1ij+gER0mlFaOrLtVI2YkkR3adbgsWWV+uHi2m9m4q87L8mUW1yzec1/y3v+4xjXV7TnY+pgHCMLOJOi3Z1qr4ZBpTLvhvQA8EXCLoBULCPa8FiyYj3lPChnpjC6rYwV016ADNUmuLo5RiLbQ0KloBWUjDJeiGzhWit7tTxhZfbd0ugrBEig07lXSqm3aUkaFQTkridgjkVPOHuqYHvH5tZ4E5Bggla0WKC/gz0l6Vl+nUlT3Nl0Zp1lz3hSx5rsJn5I57zAm+QC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5/Oky70qNR5nNt+0jfc4GhFsXkTGaXChMNraZKSIoE=;
 b=Mg+O1opILw2pAoNc2fgcMiabMdB7iGvXxU1RHzMqLwZ1ti4hcHkBvCxSPNSwoNEXOfyLjUW/xUyBV+asVt1HpdRHuR6p+i5/O+w7i4T1foO/tJOyq19x88lTad57hfWSebo5D2dhBpQhnynty1gd8lvwzHekRJ2aRxrAI7Tx1SJR7hKDtfBKrUU4fru27PEu9eCLtnmyCx4C6uqNMe3tWusCkhUVQlM2u4E/XXkXID3MZby1IgcOWFv61QNJa8wUzHM9q50BpsbwlE6ZBAwxBZheyNCzWBf+k87c3C3pBpCdhKPNnL2HeWKkw9EqK8HtLaPPEKypBQERArh22m5Y0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6477.namprd11.prod.outlook.com (2603:10b6:8:88::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 01:18:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 01:18:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Topic: [PATCH v10 105/108] KVM: TDX: Add methods to ignore accesses to
 CPU state
Thread-Index: AQHY7Ckvrt4ExdXw0UaZ9PPNheleja5KSGaA
Date:   Tue, 22 Nov 2022 01:18:48 +0000
Message-ID: <75c655620a6ab8e5cfdbb89148cfc27480a8cd56.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
In-Reply-To: <282dd5a8edbee0aa87cdf035088ecd8558b0b999.1667110240.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6477:EE_
x-ms-office365-filtering-correlation-id: 2d6bcf54-5a9c-4f89-995b-08dacc2781f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIfq59aJaHqzeGuXieq7VceKu0nw/8ukf1l0Rz+Zl4IZmaWvIAdCVUt03l+GH7fkjcgTqo0Yaku89vUVay90/Ehox9C0/HHhS6P2EfuduwvM7AtJ0Ct4tmQUG1AMQNnrK1fAojzNVuYNJwZoYstZc1wgXDCiz2B/Yvl43CwTfAdc3MluVLJ1UNkcBfNfxS0+Her/+chtPvv8hAlBm9Cy/Kow4gSeQK/KhQcwxKx0KMmTNUxcCiiKb1cAhlWkAxlqJk6zOzq2CEJvWR15sXoomkkaNcyCKlQ2ooLUwODWRujbYw6vAJ7TDKV8YIOfURij8bgJTHsShOi6XqOiAHaBy+XnUHHlJ41LOrCKgp2ty7tQ81hybTl1xYjvjxoWh56F1aJjB8VAF1yPG/zrUazLqyabdXl2NC8uOO44+gjxPSbJ/J9moQESXei3N3IDUKw/7CeJjQugDp48x74U0Pzv+7dLdPunnOKzSV39g6rTkNn1T/aqg3nUyfS3kQE367YgeOb7PO22t7tXnEMhqTcl9xnJRdhpjgTXTYED/E/04RXBTozDr0UXlVuIg7+Dp03zgOGv0154txWyEjExwIl4vggqHLHHLxzi/JlmKlD9YMGfJeF+SyMyx8vc99FKA+lx0UYDq/MUg2bhaEhlh4OPZlhFVdfz/Cexy+1gvFsnmFg3MinbVn3VVj5jCO10y5/khgM3nrHfSQrJBVjKgWsLhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(2906002)(6486002)(41300700001)(4326008)(478600001)(5660300002)(36756003)(6512007)(6506007)(26005)(4001150100001)(8936002)(76116006)(66946007)(8676002)(64756008)(66446008)(66476007)(66556008)(6636002)(316002)(91956017)(71200400001)(4744005)(54906003)(110136005)(86362001)(122000001)(38100700002)(2616005)(82960400001)(83380400001)(38070700005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzd5UDVrU0xpL0NYalBBaVljVnJVTFg1RmNiSDJsNHhRazlFM3VJMFcxSFFW?=
 =?utf-8?B?bWs1MnZsK1FmOG1jYlplc3AycG1qK0hXYUhsekRXLzhzajhOUzUzYUg0ZnBK?=
 =?utf-8?B?bDdlZGZmc3Y3MS9FaXBxVTdmUFNVTEdwUWNjZDZadEkzSDJOMEd5R1Nndks4?=
 =?utf-8?B?MmpwSFJjQmg3cEE4Vk00SCsxQlpiZjNxTUFXaGRML2hrSG9UcmsvdGFQMjZu?=
 =?utf-8?B?emwyamVubW1JOHJzcVVlQ0RFZm91bnlDT0xoQnIyMTBJc2M4MlFySDJiWnd1?=
 =?utf-8?B?TDk0RVF1RXZoNUNzeWRPZVRZNlozaFdYelNiMXJOZ1lpYXlJM0xkSFllOFpQ?=
 =?utf-8?B?SWdZYnBYWmlGMnNoMXd5dTRCU3NiNnRxYW56T3pRN0o1NGFVYnBLOWdOa1Y5?=
 =?utf-8?B?ZENEa2VTSmNQT0xlL2EvOXhvcDBVRVAyUDlGL3hwZ01CUENNdjRWUlV1Qk41?=
 =?utf-8?B?QVBJOUdGWFV5QzloUTNuQVJmYm5mSUxUbU1sRWlGeDFVUVhkbnh6dXI0bjBi?=
 =?utf-8?B?VjNrcDNRSWJBd1psYkJuWjMvUlJQN2NqMG15bFlScGZUZ3REL0VjL3lqZEov?=
 =?utf-8?B?bWc4dHNpaHMxcmVwN1MyNVdYbDM2cGwra203T041cU9HZ2E3U3VFajE5bi9q?=
 =?utf-8?B?ZzM2MTJ2dFFXZStVU2NjWHRBUVNkWERUS2ppemQyUmZWVERGYVk5ZjBTejVs?=
 =?utf-8?B?Q1lnY3A3cFRYaG1HRjRLc0Y5NGJtcVdTU1VuRGtrSm02WEcza09Ma1gwSThS?=
 =?utf-8?B?b1pHeVJoaS9mdFZFSXhkSlVOQklOVDdYc1pyRjhzaHFTZGorVVNDMUxTSHU1?=
 =?utf-8?B?eGl6cTVLcjdLSis1VWJ5ZDM4dmM2bVFoeGgrcWxFUnFGRWp1ZkI3OHVVVWRl?=
 =?utf-8?B?Myt3eldlRTVQZkpTRWRnSEpwaWgzQ1ZxSkRsYWhTa1VHWTZNaTdEY3ZHZmVy?=
 =?utf-8?B?cXkvaXhXUExodTZHKzRxcjcwZUxmeXJJaHVuSlVnQ3J3Wld3d1k3NEFZL1JP?=
 =?utf-8?B?NHEyR1Q4QWdvcDN5c1lKOFNENTJySis4eFk3djFVK2I0R3NTVTlwb3N4WlNV?=
 =?utf-8?B?d0pHZTAxaHJhNGxZM1hQWThqYytMdC9RM0pPN2tlL1JtbjlFVllwcWJRcnN5?=
 =?utf-8?B?R2RTQjJMKzdpVmJTc1hOckR6R2NWVFNUcXAwVUlmV2pRemxxRDU2TUExYU9l?=
 =?utf-8?B?dHpQSGFCdjFkMTRXKzlXa3FiT2JlRXJLV04zb3R1OXN1U2JYU3NBVElkVkZ2?=
 =?utf-8?B?dTJVUzROUVB5TmJXV042b0NXSnZjeFFJd1RaeklvS1h2ZzhzQ0ZDa1J4cU1K?=
 =?utf-8?B?ME80YVo5Zkx1ZUFMWE9sMHhrTUxDb1kyZmsxV21PMHhGcXpKRmdLSDM5N0Np?=
 =?utf-8?B?M2JSd0FjdzVDR2ZjTkhiaWxHTmVHa1Z5U0Z5ZVZKNkdkS0JyVXV1RUg2ellx?=
 =?utf-8?B?aUN3NHArSXhpZmJuSnVoWGNKYjEwSlR4M05WKzFiZ0s1bWVhc2VwbUFqRTJh?=
 =?utf-8?B?WDhtVU9KUEs4OU05Si91YkhRQXRLNWVWOFJYYmRNVWhrclc2ODBKenJZMzJH?=
 =?utf-8?B?N1dWTThmc1hsRHdkZ0pjbGp0VWd3UWhDckV0bXRZUnhRTHJLWVNDTEtYV1h0?=
 =?utf-8?B?ODI5bnBub1NUcVBsQ1haTGl1Q3VRU1VpSXpuTXNqSHVqbDI0UU9qMXY5Zncz?=
 =?utf-8?B?bnVBcmZ2Mk9TM1k3RncvSS81Sy8rUklIdnpBaFFNZWdRbFB6bllkdGVJMnFp?=
 =?utf-8?B?SUtva0JoN1ppR0t1UG52UGxRVlIyYXV1V3k3Vkkwc0Q0akJ6RXU2NkYxdzhv?=
 =?utf-8?B?RTdYUkszUXZXNllBcWRRWFhUdjZYZnhWbHM0SGN1WS9Vbm9QbUxvSlpyUHpn?=
 =?utf-8?B?S3hJNGRlbFhkeHdFUXA0dEw4UTE2cEdaZXJVbzUwN1BvQldCanA2dDZERUg4?=
 =?utf-8?B?Ny9HaXZqTFdsT3pEU3JadDhSN0srdjNLb1ltRWJxQ3R0KzJJd3JaNk1VMW85?=
 =?utf-8?B?akR1NjEvY1RKbS9zM1lmSHFlcEFENmV1eCtGbVFwaFhYNmI3RHlDMnV4eUE3?=
 =?utf-8?B?QjMvOUQ0TlhwUW1MZXhYdCtWMmxVRE1NSFhnVXFwSEFid1R5MkdvRXVLSnV6?=
 =?utf-8?B?WFB0S2ExMlRod3VyMWFIbnJnSjRXSzc0QlVLNm56enFhT0pKZy8vSUpTZVdH?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C0B60270EEB5F498406F03D6B4CB6B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6bcf54-5a9c-4f89-995b-08dacc2781f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 01:18:48.2075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2CeQv+QfSNNXMOWa2HXE3c79nEQG/3cDv5OWwWb5hKtfD+yFPlOuHbCy2HXPLGJC3BhRQtfpWRw9ndH7/49VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6477
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDIzOjIzIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBURFggcHJvdGVjdHMgVERYIGd1ZXN0IHN0YXRlIGZyb20g
Vk1NLiAgSW1wbGVtZW50cyB0byBhY2Nlc3MgbWV0aG9kcyBmb3INCj4gVERYIGd1ZXN0IHN0YXRl
IHRvIGlnbm9yZSB0aGVtIG9yIHJldHVybiB6ZXJvLg0KDQpJTUhPIHRoaXMgcGF0Y2ggaXNuJ3Qg
cmV2aWV3YWJsZSAtLSB0b28gbWFueSB0aGluZ3MgbWl4ZWQgdG9nZXRoZXIuICBBbmQgdGhlDQps
b2dpYyBvZiB3aGV0aGVyIHRvIHVzZSBXQVJOKCkvS1ZNX0JVR19PTigpIGFnYWluc3QgVEQgaXMg
aGFyZCB0byB0ZWxsIGFzIHRoZXkNCmRlcGVuZHMgb24gY29tbW9uIHg4NiBjb2RlIGxvZ2ljLiAg
VGhlIHJlbGF0aXZlIHBhcnRzIChpLmUuIGludGVycnVwdCByZWxhdGVkDQpwYXJ0cykgc2hvdWxk
IGJlIHB1dCB0b2dldGhlciBhcyBzZXBhcmF0ZSBwYXRjaGVzIHRvIG1ha2UgdGhlIHdob2xlIHRo
aW5nDQpyZXZpZXdhYmxlLg0KDQpIaSBTZWFuLCBkbyB5b3UgaGF2ZSBhbnkgY29tbWVudHM/DQoN
Cg==
