Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64FA634CAA
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbiKWBOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiKWBNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:13:54 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BE5C76B5;
        Tue, 22 Nov 2022 17:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669165976; x=1700701976;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1Mg2VcJ+hHaX8PO8cjmnaNt7MRn7Dcy4dUdtOUKZsDw=;
  b=YXY8Qj63OzV/Xs8/Y+RyjOfojbrgesxmZWFKV4J0dxI0ObhnN/UG0Qc5
   DRmTq5TVjevCiA7lcfiuPlhjE3sr1bszprB5whgOwfpoeMZVPRM7DViOL
   cOqu1ORs4sZieD9QyovNG1XanXu1A2G1JTcatoBjE7AmYSiDpZ7FUtj9F
   qvoTCjNZAZubdTEj59cMyiIqo8LE7jJlT5hxR7ERxu+G73IITxQK0To3q
   O6NQ1OCkOgmTWbfq+Pvwnd+82MHWgR7Tvnop8w6pOor94w5gdDJWO0AVs
   0vNo37IhQ68Zr6hp0u/U23UprDJu9nooPcriG603/NEYGrW25Uh8i2YdN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315106168"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="315106168"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:12:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="643925756"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="643925756"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Nov 2022 17:12:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:12:51 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:12:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 17:12:50 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 17:12:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhGHP79mKFD4yYmc6+68xKWYpl4tpsOTWbBiuwFSj0Y3DJV/GI+e4/azLXsCum+zQaOLkP6WDAm1uLSvBMPFuBoTAb1OL/VzUNq9gdVDqbh8e7totliXr7IZ8dj78l6B8Oksgd+spWsRHEBgyX+xZYHBTK6sJGIlJ28y3QUy5YEzU2ioKlAhS1kK7q7TSy/zHhqNaNJw72VlY1p6eNQOsZKjUT3ey3IGxRK0oLNRZeb36WVayDkEWLct27+jDHEAMRLqecv2ecx+pDhyk/NfGUHfDpN2SRpLeyJ8pMT3xAaWQiYaW6n8zis0M/t0bfEjfd9KwvDMqKe9YP4NHpFeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Mg2VcJ+hHaX8PO8cjmnaNt7MRn7Dcy4dUdtOUKZsDw=;
 b=MeKwWcg9EDReEnWbYynbA+1JN8TwnW+ohPs+pr9ktxPlMmD5bu6BVlcbogtPBBiVskR9l1Oud3DA8blPUFzqB7WOnL6kXI9NPNwCNBBjJLnD9eVLT8UsHRFywRXTO03rKp4mHy15U3/IJWnLwuHzSdtuh6sJ+YcmCRjuMNVzKhYVGSWg/x7FRLOcTYA5EJfERjzYF9YHyZpzntQ3eNalo5QKrkLcEMsIMqjipDtZsbf0ssWsLGjvURGgdWq8aanrzt8PjiGY+67imEK6XKGQ9PoIRV3W0NLJzPem+r5+LBlYxvdn9HPjzyTXxuZzGexSm7dgFPqwfHw9bn2F6oaCbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6399.namprd11.prod.outlook.com (2603:10b6:8:c8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Wed, 23 Nov 2022 01:12:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:12:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHY/T29USV2IuUHCEyPQthCEbaZH65Kp9QAgAAYugCAAFUUgIAASuaAgABKsYCAAAuugA==
Date:   Wed, 23 Nov 2022 01:12:46 +0000
Message-ID: <57be851ef63335a6f3bed84609e4081d37bb8dfd.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
         <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
         <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com> <87mt8ig3ja.ffs@tglx>
         <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
In-Reply-To: <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6399:EE_
x-ms-office365-filtering-correlation-id: 8649d940-852e-46a9-2042-08daccefd502
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SoD/WHNZS8bWQWbag4n35kEqLknA5nGV4v4vnrJ40U7UmBvcCbX3KiryPf+0+221qfAzQTPPiDUVF81v+i1HJX3bPg90gPBiLf55p6pdao/HwiOFMNM3QUEm6hxUS/uvKZXfgB6sQssRTtxBvBlHJzclHs7FkuUusBGE4vTxwAyKVYv7YYO+CxZOCkknZ0rzRu0uH2MARi3KhgMINYBcpyX5cNWwwcUiOy7YOGDrbbukWOrbCNV+mE0jTDfj3EEtCMVRFpQTWSWRm9dxs7uLPEhj4CpqkplAEi39UOXvtl5im+5FNRhfFAd7L66fZ/WeM/OwcJRTlVDFbOvpbnyrcQsBrpc15t9GTh+SPezrktV+eY4YYdTKwPggmDWOWO6sg6Fhxljk1GLEkZmAE6tCGT3Wuez9UTOF6W5fKEet8RHnoTlP4DilU4QAArHMYFwInCQPthq3F7AjgrdLjoh2Bnev14Ioj+mY9o3OqHfuVeeF38TNPsv4RgydFYtbTr1C6L0F8IWSaorcefRHHKzkDz1VJAlPYr1II70+hYOj5Q0GqYEckUX3BC3Ht9jLuqee6Ehf1cE5vGUDHlF9BMG8Y7Kr9GvV/flkLcO0asv5n4D/HD2CPs0vuoGS0x2RtX+WeDU/W8eAo2XD/qABF7wYOMQxzO1OIhv4T2XvzbYpVacKvFbpk6POa6Lwk43akFYicvGHLqxvNDgP+5Py4IfEdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(2616005)(2906002)(38070700005)(186003)(4326008)(478600001)(76116006)(66556008)(26005)(66946007)(6506007)(6512007)(6636002)(66476007)(316002)(5660300002)(38100700002)(64756008)(8676002)(66446008)(36756003)(91956017)(8936002)(7416002)(6486002)(122000001)(41300700001)(86362001)(82960400001)(4744005)(110136005)(54906003)(4001150100001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek1GN0U0bklnL05UbGc2VHMwRVgxdHpqaDk3YWpvdlhnOFJXOWEzQmdIMFU3?=
 =?utf-8?B?bVppLy94emw1b21qNlRvVDNzSnhUR0tmUTE0MGFkMlZ4dThtMlIybTVicFVj?=
 =?utf-8?B?Y21nMXc5SWJCaFl6ZG80OWh6RUNGWWNmZkI5NitodmxmYmI2TmlPZmdldGZh?=
 =?utf-8?B?NTNvU25JVFkxN1dOdXJMZzI0L0czZndsSEZOQjlHckVHQnB5ekdjTmcrUUpk?=
 =?utf-8?B?RURCNHdDdmJCL3l1MkdsWXRST3U3VTd0OUN3YjkwcWFxUWlJV1d4ZUo3Nit4?=
 =?utf-8?B?RHpEdVFaelpqR3o4dEVXRlZWOEplYW1Eb2xkVWwwT2o0ZThJRFFsS29KczRy?=
 =?utf-8?B?WGduNU1jcmxnMlJNakhJQSt1YURtZWpveFdVZzdOMExab1RVbk1zaG5aMW5Z?=
 =?utf-8?B?dzV6QWp1c3k5aTVtcDRWWUpXYXNtdGs3dTlDK3I2c3RYVnVHQ0RxekN4RS9z?=
 =?utf-8?B?LzJvQ2N2dTZ2YlpGRXpHSHp3MGx0eWNBdmJzZkZzaDNOOG5QUWEzZnR5d2x6?=
 =?utf-8?B?UkFHc3c1eHRXYWtlT0crYTdBdmo2d204bHN5Z3pQN3U1OGNZQXdiTkp6c0FC?=
 =?utf-8?B?TGQzRjEzNDJjd05kMTRqNG9hQ0hXaVRLaWxubTVWZ1l3OU9HaFJCRDUrVDJv?=
 =?utf-8?B?Z0NPSnBlNDI2azZiSUR2MDNya1pIWWhsRzNhZWZoVFlKZ1hLaUMzcXpNVUhu?=
 =?utf-8?B?SWp2YnRsYjB2WjJST1Myb1ZWR2tPWHRlQlAyMzFpWDM0dE83eitGRHR0TGps?=
 =?utf-8?B?ZEFJcDBWeDNndXB0dnE5SkRqRTVrOFc4OE5FUXZjbGZ5aVRQV1doaXV0eGRC?=
 =?utf-8?B?R0dlMytSTkd0UCtldGMwcUVpMjNiZ0NCM09TWDBmMUVLU0tBV25QZWgzYi9z?=
 =?utf-8?B?Qy9qNGF3ZjVCUGs5bmM2VEdMUUtVLytMdVZpWXN4bWVJV1dmTEw2UTBQemN1?=
 =?utf-8?B?dDVLV0FyTElMdnJmOXFwY0Z3STVMR25hdytyWGtma2RWMU52eUhqeXhWV2ZJ?=
 =?utf-8?B?akRoenlnc1UzTDB4QXlpeVFoZHFQdkwzdnh0dGtFa3hTWU1haHFZYk5KNC9S?=
 =?utf-8?B?U3RZS1E2S0I4N0pVaDJwZEZDRlpxNjUwSThGYUN6L2x1b013NjZuaEdGVmlo?=
 =?utf-8?B?MkFIVEpORkJCbzNVcFF6R3IzR0UrbGxsWDNzVnMwTWs3OEVKaERlZmZ1T1hr?=
 =?utf-8?B?QzRzTmM3WEpTOUUvVFIwQXB2bWVRNHJsLy94ZUJqN1RzZXhsbXFKRlZKdzM5?=
 =?utf-8?B?RElxbVRqelgyeFVMbHpTbnN5UFF4YnMwZHRkeDZYVnpKYVNpOFNmS3FvcWN3?=
 =?utf-8?B?cjFKeGN4dkY5NmJselg2MDdmcGV1b1NWUXI1TmhncG4rN1BDN09reEkydmdw?=
 =?utf-8?B?OCsyMlFITkVLOU9hd1o4R2tlSVk0UUNvQTJjRmM5NEZRN01NbWwrWklUVXJU?=
 =?utf-8?B?T2NGdC9kVUh6Um54cEhrbm4zYUs1cEd0THkvTmF6RmJNVk4rQkF1NGNkb1Va?=
 =?utf-8?B?NVgwMjNTV2xlalpQR2NRMUlnSlRLcDRYeENaN1UzdzlzTTNMQkp2ak5NSVRt?=
 =?utf-8?B?KzFURzlXU2loWWQ5d3Z1cys0c09mSE11TGJwUjRzZmFaa01mOWhxOURocGQ5?=
 =?utf-8?B?ajhBZjJ4bm9Ec01pclJuWFBCeHlJeU5rM2wxWU84eTJVQkZFWjg1Q0habnkw?=
 =?utf-8?B?ZUJSWVhLeDMwaG5SS0lBMmozeEZPVjdhOUJpN0tiWjlIbjlIek5ncGJ6MFpz?=
 =?utf-8?B?RXJEZmNCb2pmenFNSGUzSFJUQmZ6dWlQVHdrNmQ3cCtSOW9pbG5nU0xHRllP?=
 =?utf-8?B?V2EyNDV3UGRZM3VWSzhxQ2dDb1ZuaHJNdFJTSmIyQkQ5aHFxQWRyNERvS055?=
 =?utf-8?B?ZnpZV0U0RlhzcmRyVUp3VVp3YWxuYmZzempLQjU3ZlNlZTd5N21XdVF4MGI0?=
 =?utf-8?B?bDc2a2Zhc0x6cWFsWUNsVnBsYS9oeGxEcEZ4MWxGYmRUWkN6TDhhdDltTW8r?=
 =?utf-8?B?bkJDaysxU3BySTZYVFo4Smd6Wloxb0xsUDArVjZhTUxhV044b2I2bUN2dXZk?=
 =?utf-8?B?KzlHQ2tPUlN3VTRLSlc3L0YzRU5WUUlHSUEvMDNmeGFHc2JTM21vNk8wRGpj?=
 =?utf-8?B?ZkJLNWx0U2VndnpiT2NpZHFiT1BZWCtWODFhY200L3FNREFpSE1xZDJrbGV6?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67D2B90A04A85A4A9FA1C437D8DCD296@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8649d940-852e-46a9-2042-08daccefd502
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 01:12:46.8814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ju+la6bhKc0LJskhuyyacRXJrHSM8C3trTj2bV3ln4TE3sTzC9AZrAgiwtJvoDTaxy9I1bp6QtwJjiUsX68nzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6399
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

T24gV2VkLCAyMDIyLTExLTIzIGF0IDAwOjMwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IA0KPiA+IENsZWFybHkgdGhhdCdzIG5vd2hlcmUgc3BlbGxlZCBvdXQgaW4gdGhlIGRvY3VtZW50
YXRpb24sIGJ1dCBJIGRvbid0DQo+ID4gYnV5IHRoZSAnYXJjaGl0ZWN0dXJhbHkgcmVxdWlyZWQn
IGFyZ3VtZW50IG5vdCBhdCBhbGwuIEl0J3MgYW4NCj4gPiBpbXBsZW1lbnRhdGlvbiBkZXRhaWwg
b2YgdGhlIFREWCBtb2R1bGUuDQo+IA0KPiBIaSBUaG9tYXMsDQo+IA0KPiBUaGFua3MgZm9yIHJl
dmlldyENCj4gDQo+IEkgYWdyZWUgb24gaGFyZHdhcmUgbGV2ZWwgdGhlcmUgc2hvdWxkbid0IGJl
IHN1Y2ggcmVxdWlyZW1lbnQgKG5vdCAxMDAlIHN1cmUNCj4gdGhvdWdoKSwgYnV0IEkgZ3Vlc3Mg
ZnJvbSBrZXJuZWwncyBwZXJzcGVjdGl2ZSwgInRoZSBpbXBsZW1lbnRhdGlvbiBkZXRhaWwgb2YN
Cj4gdGhlIFREWCBtb2R1bGUiIGlzIHNvcnQgb2YgImFyY2hpdGVjdHVyYWwgcmVxdWlyZW1lbnQi
IC0tIGF0IGxlYXN0IEludGVsIGFyY2gNCj4gZ3V5cyB0aGluayBzbyBJIGd1ZXNzLg0KDQpMZXQg
bWUgZG91YmxlIGNoZWNrIHdpdGggdGhlIFREWCBtb2R1bGUgZm9sa3MgYW5kIGZpZ3VyZSBvdXQg
dGhlIHJvb3Qgb2YgdGhlDQpyZXF1aXJlbWVudC4NCg0KVGhhbmtzLg0K
