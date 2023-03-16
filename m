Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B606BDBD0
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCPWhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjCPWhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:37:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8E1DFB66;
        Thu, 16 Mar 2023 15:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679006271; x=1710542271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=483uOWxVYAnH9m8x+4AqgvFzNqH1MBAgifpJA5W/zZs=;
  b=PdeU4wMjcqTl/bH9Z6PZDm7n4RkOpStJrcRO5BKiDyV4XmgTpJtY/CYx
   l30tr2pUkWEknGPdDuhroxCvPVpTq2X6DtiEXyhksKXvs0f5xRE/Ksc4j
   E2X3W0j56IeqtHbQ7U6qUSUST7iaDIdAlYF5eoq/y7aUgz44+6u0ykMGN
   e+1fYXNI2xdRdkFLkL20eNKv+LHIbGvIlwGqMyRfQ53zGkxVAuhROEWNO
   Ik+KzzQ/5mQ9R+1PuWSgv+w1+pwM8gldCL2USyFAM2B8RSb2M/ll3d1/E
   qUCO5BsmACLGbtMbPeeKSQald/smrlr572LbGvPt6Gg5NUVs3KHP/2B0X
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="339670536"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="339670536"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 15:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="630070992"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="630070992"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2023 15:37:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:37:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 15:37:42 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 15:37:42 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 15:37:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I05mvTgyQHjaCDQY7dQ757hvjYEGrTkWSN19y4TaWbFIrWWsxfZrvYRnyM0kELGtfbWVNaKmJiFhd349GKDJgbGg7sdUlqNNk0ALOyvKLIbD/ZdrVJivXW+XNewf++fr4i0jLIC1yRXq1u2h6dP1bpc0GD6cY+W8QVzgjIOugawULQ8iFMBQNlFRUa6+kmTL0yTsrr3PVtpVvqg7l+FKugAvFzcKqH+G0RE6p5smrFVVB2+K3jpKMHiJ2uPGZOq51fg8+iU1ZntC+qLrMKG411y2yI/8plshYg8gTpE/7wNNWTjH0taYvMnkc8/rDFQBHSHDlIQdm+oQYAMBDPqDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=483uOWxVYAnH9m8x+4AqgvFzNqH1MBAgifpJA5W/zZs=;
 b=KUuPE0QzSH1ZV8selTpgntYyRbVib5HjvntA0PFsG6F3uihzUN/iHIEE0dbE+VYyzH8YDbiiBYi464m+HgHP9iUZmBwbjb4yOKWgqyTBiatAbzw0LV/29+d/PypJID/7EKdTPSsiNSy8YUYDjW6o3aV5BNv0Yp3g0tBjkS19kE9WfnxcVyUb0EMbwRC5wwRnwE1HUc0jaDnu8VTXFt5hNTCGrl95ofii+pUOBHoymKy0J5tI5nxjP54+LVWfF6xwovRfP0HXaOtIAilKOG4FKONKXSO1VGDfAHNXoIleyNMic6lyDV9kuQDpIalSy0CcYs42ng7LMHeAhHTbInlHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5540.namprd11.prod.outlook.com (2603:10b6:610:d7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 22:37:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 22:37:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
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
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Topic: [PATCH v10 02/16] x86/virt/tdx: Detect TDX during kernel boot
Thread-Index: AQHZUDU3AVff1Ip5tka5ejPHlOydGq79auoAgACkdgA=
Date:   Thu, 16 Mar 2023 22:37:36 +0000
Message-ID: <e8cc32a3f374e494bc6b93dad31367d8b093f9c8.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <35a2421ca97d9e8dd938dcd744674602f4faa617.1678111292.git.kai.huang@intel.com>
         <90f6a15c-0dec-4a19-7a21-b18b73932a21@redhat.com>
In-Reply-To: <90f6a15c-0dec-4a19-7a21-b18b73932a21@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5540:EE_
x-ms-office365-filtering-correlation-id: 4429b1d4-6719-4e37-cdb2-08db266f0ac5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AcZtS0fYOd5qE7yqyuuH6qmDmbdyVmRd8SZEuaWg1EYJn+ofG68EWvxHaLdfiHNLG9f1Nc6bRhK3Yafew5LfwMJNHb1KCb+/if3QVKaQr5Q4Bz10F5nybMjzKlxunZSHoBVCqVKmuCD+POLATHwUjIB6ZVUjAFlZSaYiiI1Vy6HALoj/Gfez0ExwrHlfNSGNF1+5mW5UyMIFcx7TrQ7N+qhfjhQzb6sSH9UUn0n30c6lCL2AWx2CCUnl2nEe/pW2YBZ79bJac0TveXl2qMK0Wf1iRiEwF10feqPstg+6wuklDSTYgk3m3T7b4GFS5YWQRNPF7L/RHDqyxNIDqqFJIeq0yYGclKsY073Vp1WfWYPxNu7AVsIGpsoPAgSmxWA39UWXKH1tYOy8T/IdLEIiAyatdAlDR1HstSPydxQ/Tjb57U2g/JCrXWWuv0T6Kdr2jv0EgL7Mi4kwfuwLHrgZLWblhXnSTXDvfLPaKnR6c1L/RnQ/+sD2Xo8gdxC0u2O6gkSUlQaN5pUU+x3y7bOX9g62ypobjSIvHhkC48x/AKBwbS0kZa6aAiL0ppXg3u/BZNNL66wzJtw0DcqKw2fMga3Nven9oTMOQ/zd8sSyn1stuUFR8F29oP8PG/PzTS1POdTywWbO8umVVph88BKeZxNZvlZQw1cmBklz9PhpTDNGbA/1mT/LfOuucFOGdBqrIlMunZKGHb7/Lwi4pDGPxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199018)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(36756003)(2906002)(41300700001)(8936002)(7416002)(5660300002)(6512007)(6506007)(26005)(54906003)(2616005)(186003)(53546011)(4326008)(83380400001)(110136005)(316002)(66446008)(8676002)(66556008)(76116006)(91956017)(6486002)(478600001)(66476007)(66946007)(71200400001)(64756008)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0Z5djNOYnk5QndXRGdnNCtuTW9xUEZIbGFWaE1aWk1DbnovQjVFR1VkNjJL?=
 =?utf-8?B?NDNkc3N2U1M3UzBkU1FPQ0RaN3ltdmQxVFlVUDA0dm5TdG41R2czdmNodW9N?=
 =?utf-8?B?ZW5DTmttT2xUNkM1YmR3cjFXd2RwQUF2SHJyN0JsR05LaEdKUkQ0RFljQXp0?=
 =?utf-8?B?Yk5adTZsUG1ac0ltT2pqWlp1SGhLOURENzBzS1pRZkF5RWZjZXlDbmZPdk5x?=
 =?utf-8?B?UDFRM1N6a3V2TEpYbDhpSng1RGN1bitUQzdXbDlKT0lEZkdZYzFtYTBVdWZV?=
 =?utf-8?B?eDdtS29vQ0hRWkNMQ0kzcjNzcGxhL2hXWHYwUjgrMnRuUHJLK1UxQ1NsQzZ5?=
 =?utf-8?B?bENEa3JGQzlYaWVhdXVTTTZBU1hBb21QOE4xL0pDL0dVYkxPZ3l6REhOdVdH?=
 =?utf-8?B?N1F4cjJ2ZGFCSGJ6dnNPUWI0SDQrQmpFZ1hiTjljamZGc2JURVpqODVESDd2?=
 =?utf-8?B?VGcyV0Uzd3UrUUFENGJwRzVjUTFHMURGZFREMVU3c2xUb0RzeGxtRktXT2ZX?=
 =?utf-8?B?eU1EUnZ0aGhhZmdZVzE3TW9vS2sxanU0ZCtrQWJybkZodWVUV3dWL0hvTHhO?=
 =?utf-8?B?TEZ4TnBaT3Mvcno5M1Y1L3dUdGlFazArQ28rWDd2NXVuVUdaNFE1eFg0cHRG?=
 =?utf-8?B?YVVnNWU3RE85VEZKZWNGTzIwZzhhODJOY0svcEVuTzFybWgyUTlDdVdWLy9y?=
 =?utf-8?B?Sjkrd0x4aWJuZTJPTlltZ1FIMFc5Z01jQmdJYnl5YWZHU0Z5bmFTb2EzeFVx?=
 =?utf-8?B?VVZyOEplbTBNTjJCSnVMbW8vRGVkWVFKajR6bUlTaG5RK3d5VVRVWUg0Nnhu?=
 =?utf-8?B?ZUl5TzRsM0lTM3g5RTZ0M3lLVG1RTExiUFlPbGdtT0F5QjY3anJLRTZXcmtH?=
 =?utf-8?B?emR3bVRFbnRLKzZ5OUc2TUVtL3p6bm1memdxd3RoYXpjRXlzRkpURC9oWGcz?=
 =?utf-8?B?ZXRjRWRXZXZURUEwVC9sWXQ5YWIzdmY4cnBZNlNCOWVWSjJQZEJhMng4YkRx?=
 =?utf-8?B?MnA5S2xHaW5wRVhCSDhRQjk4MjNOcTFLT3hzY0ZOVFpFUFpCaXJibjNOK2lq?=
 =?utf-8?B?YkxYTFZjbjhRVElWV3ZDeFZUelZhYjd2SXpZSFJsaHl2OVBOd1l1ZUg5Qm4x?=
 =?utf-8?B?blFOTjVGd0lWRlRSUkFJaCtnNC9RWmN4MWN4SzJROFp0bTVuUzVISVd1MVFI?=
 =?utf-8?B?cnBnVXVyTXFOUXNFZ2Y2QTlUS0cwYUtKMjliYm5ZaUV6NHZiR0doYlo2S0x1?=
 =?utf-8?B?d3BUdU9KaXI4dEVBWjdMQ3laSDZmblBZTmhzRmJnT1RTWDVRdFF4RFU4V0hU?=
 =?utf-8?B?WVpJM2tYdUtBVDNUOHV1V0p2Tkk1YlFEcVA3ZEFvcDNxd1V4QkdVOVcxZ3VS?=
 =?utf-8?B?UmZ4ZzVDaS84RGdhekppVzZoVk1ZQmtyZHV2WGtpU0pvWGc0UUVKU1JWSDg4?=
 =?utf-8?B?bGcvNHpLOWRyUzlFTGdIUVhHdXE2MmpGWkhGU0FHaFE3bzc1a2R2VEYxNzE0?=
 =?utf-8?B?bWduLzJ1b3ZWTFRTRkZBNDl2R2xPQ2l3Q3dRb2hsc2VYQkdFM2FnaC9RK1Ew?=
 =?utf-8?B?Sk5ZWnk4T2d2Rm5LNG9idTBrejJ1bTRYSkd1dlJXOFJGNlQ5Q3RUKzhNVnpu?=
 =?utf-8?B?SnBhWEpkSkJCMCtRQWhSWWZBTGlBMU8wZTlYMW5OTHVEL0EweXdXbWw2cFcy?=
 =?utf-8?B?WU5Mb3VnZis0dW1lUCs4Q044VDFGYU1taHVNQmN3RTNFc3ptL1VCcXJFRFJW?=
 =?utf-8?B?Qk1HREo5SEszQ1c2L2dmQ0dUV2g1Rm1EalFYbkp2UU54UHZraGdjVTk5b1E4?=
 =?utf-8?B?YXhkTFg2VGhKZjlDN2laeUpEV2MxQXdmdXlUS3VSTEl5OXRaV2pTN0RIcWZn?=
 =?utf-8?B?aEZxUS9nRWJSQW9aLzlWQ3YwanNsR0YwN3A3dXVxdkZUL1hFNTBJYU90RHAw?=
 =?utf-8?B?N210S2RXMUo5ZVB2ZTZOdy9LS1IvVktwQjhjeVF2M3VRYnlyU2NwSWd4OG5t?=
 =?utf-8?B?VlJNN1RnVkhCQmZhQXhlS1dxQnJmRTdQL0xta0p5Ujlua3J4Q2FkeTlaVENS?=
 =?utf-8?B?THJiUXdidTRzZVhvMjRiRGQwWTlBWEdVaGdNdytkVWJRZXBvRWEyYU92MndX?=
 =?utf-8?B?cTJqdWRreXV6dEI0WVhrTWdSQlBsa3NTeEV0Mjd2Um5LQjNucnVLcEJqVU84?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E80FCB1B235C5E41AF6B145D394755DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4429b1d4-6719-4e37-cdb2-08db266f0ac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 22:37:36.6861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xr9O5RNKFbI/C9YCS2LPvaG67h3r2Lt0tDAqqnbgg8iPdVSWmKgGVPtTnjm1VjbIKk5j0p3W/QcVnpUF+GuHXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5540
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

T24gVGh1LCAyMDIzLTAzLTE2IGF0IDEzOjQ4ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMDYuMDMuMjMgMTU6MTMsIEthaSBIdWFuZyB3cm90ZToNCj4gPiBJbnRlbCBUcnVz
dCBEb21haW4gRXh0ZW5zaW9ucyAoVERYKSBwcm90ZWN0cyBndWVzdCBWTXMgZnJvbSBtYWxpY2lv
dXMNCj4gPiBob3N0IGFuZCBjZXJ0YWluIHBoeXNpY2FsIGF0dGFja3MuICBBIENQVS1hdHRlc3Rl
ZCBzb2Z0d2FyZSBtb2R1bGUNCj4gPiBjYWxsZWQgJ3RoZSBURFggbW9kdWxlJyBydW5zIGluc2lk
ZSBhIG5ldyBpc29sYXRlZCBtZW1vcnkgcmFuZ2UgYXMgYQ0KPiA+IHRydXN0ZWQgaHlwZXJ2aXNv
ciB0byBtYW5hZ2UgYW5kIHJ1biBwcm90ZWN0ZWQgVk1zLg0KPiA+IA0KPiA+IFByZS1URFggSW50
ZWwgaGFyZHdhcmUgaGFzIHN1cHBvcnQgZm9yIGEgbWVtb3J5IGVuY3J5cHRpb24gYXJjaGl0ZWN0
dXJlDQo+ID4gY2FsbGVkIE1LVE1FLiAgVGhlIG1lbW9yeSBlbmNyeXB0aW9uIGhhcmR3YXJlIHVu
ZGVycGlubmluZyBNS1RNRSBpcyBhbHNvDQo+ID4gdXNlZCBmb3IgSW50ZWwgVERYLiAgVERYIGVu
ZHMgdXAgInN0ZWFsaW5nIiBzb21lIG9mIHRoZSBwaHlzaWNhbCBhZGRyZXNzDQo+ID4gc3BhY2Ug
ZnJvbSB0aGUgTUtUTUUgYXJjaGl0ZWN0dXJlIGZvciBjcnlwdG8tcHJvdGVjdGlvbiB0byBWTXMu
ICBUaGUNCj4gPiBCSU9TIGlzIHJlc3BvbnNpYmxlIGZvciBwYXJ0aXRpb25pbmcgdGhlICJLZXlJ
RCIgc3BhY2UgYmV0d2VlbiBsZWdhY3kNCj4gPiBNS1RNRSBhbmQgVERYLiAgVGhlIEtleUlEcyBy
ZXNlcnZlZCBmb3IgVERYIGFyZSBjYWxsZWQgJ1REWCBwcml2YXRlDQo+ID4gS2V5SURzJyBvciAn
VERYIEtleUlEcycgZm9yIHNob3J0Lg0KPiA+IA0KPiA+IFREWCBkb2Vzbid0IHRydXN0IHRoZSBC
SU9TLiAgRHVyaW5nIG1hY2hpbmUgYm9vdCwgVERYIHZlcmlmaWVzIHRoZSBURFgNCj4gPiBwcml2
YXRlIEtleUlEcyBhcmUgY29uc2lzdGVudGx5IGFuZCBjb3JyZWN0bHkgcHJvZ3JhbW1lZCBieSB0
aGUgQklPUw0KPiA+IGFjcm9zcyBhbGwgQ1BVIHBhY2thZ2VzIGJlZm9yZSBpdCBlbmFibGVzIFRE
WCBvbiBhbnkgQ1BVIGNvcmUuICBBIHZhbGlkDQo+ID4gVERYIHByaXZhdGUgS2V5SUQgcmFuZ2Ug
b24gQlNQIGluZGljYXRlcyBURFggaGFzIGJlZW4gZW5hYmxlZCBieSB0aGUNCj4gPiBCSU9TLCBv
dGhlcndpc2UgdGhlIEJJT1MgaXMgYnVnZ3kuDQo+IA0KPiBTbyB3ZSBkb24ndCB0cnVzdCB0aGUg
QklPUywgYnV0IHRydXN0IHRoZSBCSU9TIHRoYXQgaXQgd29uJ3QgaG90LXJlbW92ZSANCj4gcGh5
c2ljYWwgbWVtb3J5IG9yIGhvdHBsdWcgcGh5c2ljYWwgQ1BVUyAoaWYgSSB1bmRlcnN0b29kIHRo
ZSBjb3ZlciANCj4gbGV0dGVyIGNvcnJlY3RseSk/IDopDQoNClRoZSAidHJ1c3QiIGluIHRoaXMg
Y29udGV4dCBtZWFucyBzZWN1cml0eSwgYnV0IG5vdCBmdW5jdGlvbmFsaXR5LiAgQklPUyBuZWVk
cw0KdG8gZG8gdGhlIHJpZ2h0IHRoaW5nIGluIG9yZGVyIHRvIG1ha2UgdGhpbmdzIHdvcmsgY29y
cmVjdGx5IGluIHRlcm1zIG9mDQpmdW5jdGlvbmFsaXR5LiAgDQoNCkZvciBwaHlzaWNhbCBtZW1v
cnkgaG90cGx1ZyBvciBDUFUgaG90cGx1Zywgd2UgZG9uJ3QgaGF2ZSBwYXRjaCB0byBfZXhwbGlj
aXRseV8NCmRpc3Rpbmd1aXNoIHRoZW0gKGZyb20gbG9naWNhbCBtZW1vcnkgaG90cGx1ZyBhbmQg
bG9naWNhbCBjcHUgb25saW5lL29mZmxpbmUpLA0KYnV0IGFjdHVhbGx5IHRoZXkgYXJlIGtpbmRh
IGFsc28gaGFuZGxlZDogIEZvciBtZW1vcnkgaG90cGx1ZywgYW5kIGhvdC1hZGRlZA0KbWVtb3J5
IGlzIHJlamVjdGVkIHRvIGdvIG9ubGluZSAoYmVjYXVzZSB0aGV5IGNhbm5vdCBiZSBpbiBURFgn
cyBjb252ZXJ0aWJsZQ0KbWVtb3J5IHJhbmdlcykuICBGb3IgQ1BVIGhvdHBsdWcsIHdlIGhhdmUg
YSBmdW5jdGlvbiB0byBkbyBwZXItY3B1DQppbml0aWFsaXphdGlvbiAodGR4X2NwdV9lbmFibGUo
KSBpbiBwYXRjaCA1KSwgYW5kIGl0IHdpbGwgcmV0dXJuIGVycm9yIGZvciBob3QtDQphZGRlZCBw
aHlzaWNhbCBjcHUuDQoNCj4gDQo+ID4gDQo+ID4gVGhlIFREWCBtb2R1bGUgaXMgZXhwZWN0ZWQg
dG8gYmUgbG9hZGVkIGJ5IHRoZSBCSU9TIHdoZW4gaXQgZW5hYmxlcyBURFgsDQo+ID4gYnV0IHRo
ZSBrZXJuZWwgbmVlZHMgdG8gcHJvcGVybHkgaW5pdGlhbGl6ZSBpdCBiZWZvcmUgaXQgY2FuIGJl
IHVzZWQgdG8NCj4gPiBjcmVhdGUgYW5kIHJ1biBhbnkgVERYIGd1ZXN0cy4gIFRoZSBURFggbW9k
dWxlIHdpbGwgYmUgaW5pdGlhbGl6ZWQgYnkNCj4gPiB0aGUgS1ZNIHN1YnN5c3RlbSB3aGVuIEtW
TSB3YW50cyB0byB1c2UgVERYLg0KPiA+IA0KPiA+IEFkZCBhIG5ldyBlYXJseV9pbml0Y2FsbCh0
ZHhfaW5pdCkgdG8gZGV0ZWN0IHRoZSBURFggYnkgZGV0ZWN0aW5nIFREWA0KPiA+IHByaXZhdGUg
S2V5SURzLiAgQWxzbyBhZGQgYSBmdW5jdGlvbiB0byByZXBvcnQgd2hldGhlciBURFggaXMgZW5h
YmxlZCBieQ0KPiA+IHRoZSBCSU9TLiAgU2ltaWxhciB0byBBTUQgU01FLCBrZXhlYygpIHdpbGwg
dXNlIGl0IHRvIGRldGVybWluZSB3aGV0aGVyDQo+ID4gY2FjaGUgZmx1c2ggaXMgbmVlZGVkLg0K
PiA+IA0KPiA+IFRoZSBURFggbW9kdWxlIGl0c2VsZiByZXF1aXJlcyBvbmUgVERYIEtleUlEIGFz
IHRoZSAnVERYIGdsb2JhbCBLZXlJRCcNCj4gPiB0byBwcm90ZWN0IGl0cyBtZXRhZGF0YS4gIEVh
Y2ggVERYIGd1ZXN0IGFsc28gbmVlZHMgYSBURFggS2V5SUQgZm9yIGl0cw0KPiA+IG93biBwcm90
ZWN0aW9uLiAgSnVzdCB1c2UgdGhlIGZpcnN0IFREWCBLZXlJRCBhcyB0aGUgZ2xvYmFsIEtleUlE
IGFuZA0KPiA+IGxlYXZlIHRoZSByZXN0IGZvciBURFggZ3Vlc3RzLiAgSWYgbm8gVERYIEtleUlE
IGlzIGxlZnQgZm9yIFREWCBndWVzdHMsDQo+ID4gZGlzYWJsZSBURFggYXMgaW5pdGlhbGl6aW5n
IHRoZSBURFggbW9kdWxlIGFsb25lIGlzIHVzZWxlc3MuDQo+IA0KPiBEb2VzIHRoYXQgcmVhbGx5
IGhhcHBlbiBpbiBwcmFjdGljZSB0aGF0IHdlIGNhcmUgYWJvdXQgdGhhdCBhdCBhbGw/IA0KPiBT
ZWVtcyB3ZWlyZCBhbmQgcmF0aGVyIGxpa2UgYSBicm9rZW4gZmlybXdhcmUgb3Igc3RoIGxpa2Ug
dGhhdCAuLi4NCg0KTm8gaXQgZG9lc24ndCBoYXBwZW4gaW4gcHJhY3RpY2UsIGJlY2F1c2UgdGhl
IEJJT1MgaXMgc2FuZSBlbm91Z2guDQoNCkJ1dCBzaW5jZSB0aGUgcHVibGljIHNwZWMgZG9lc24n
dCBleHBsaWNpdGx5IHNheSBpdCBpcyBndWFyYW50ZWVkIHRoaXMgZG9lc24ndA0KaGFwcGVuIHdo
ZW4gVERYIGlzIGVuYWJsZWQsIEkganVzdCBhZGRlZCB0aGlzIHNhbml0eSBjaGVjay4NCg0KPiAN
Cj4gPiANCj4gPiBUbyBzdGFydCB0byBzdXBwb3J0IFREWCwgY3JlYXRlIGEgbmV3IGFyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHguYyBmb3INCj4gPiBURFggaG9zdCBrZXJuZWwgc3VwcG9ydC4gIEFk
ZCBhIG5ldyBLY29uZmlnIG9wdGlvbiBDT05GSUdfSU5URUxfVERYX0hPU1QNCj4gPiB0byBvcHQt
aW4gVERYIGhvc3Qga2VybmVsIHN1cHBvcnQgKHRvIGRpc3Rpbmd1aXNoIHdpdGggVERYIGd1ZXN0
IGtlcm5lbA0KPiA+IHN1cHBvcnQpLiAgU28gZmFyIG9ubHkgS1ZNIHVzZXMgVERYLiAgTWFrZSB0
aGUgbmV3IGNvbmZpZyBvcHRpb24gZGVwZW5kDQo+ID4gb24gS1ZNX0lOVEVMLg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBSZXZp
ZXdlZC1ieTogS2lyaWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwu
Y29tPg0KPiANCj4gDQo+IFsuLi5dDQo+IA0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYvS2NvbmZp
ZyAgICAgICAgICAgICAgICAgfCAgMTIgKysrKw0KPiA+ICAgYXJjaC94ODYvTWFrZWZpbGUgICAg
ICAgICAgICAgICAgfCAgIDIgKw0KPiA+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vbXNyLWluZGV4
LmggfCAgIDMgKw0KPiA+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggICAgICAgfCAgIDcg
KysrDQo+ID4gICBhcmNoL3g4Ni92aXJ0L01ha2VmaWxlICAgICAgICAgICB8ICAgMiArDQo+ID4g
ICBhcmNoL3g4Ni92aXJ0L3ZteC9NYWtlZmlsZSAgICAgICB8ICAgMiArDQo+ID4gICBhcmNoL3g4
Ni92aXJ0L3ZteC90ZHgvTWFrZWZpbGUgICB8ICAgMiArDQo+ID4gICBhcmNoL3g4Ni92aXJ0L3Zt
eC90ZHgvdGR4LmMgICAgICB8IDEwNSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ID4gICA4IGZpbGVzIGNoYW5nZWQsIDEzNSBpbnNlcnRpb25zKCspDQo+ID4gICBjcmVhdGUgbW9k
ZSAxMDA2NDQgYXJjaC94ODYvdmlydC9NYWtlZmlsZQ0KPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0
IGFyY2gveDg2L3ZpcnQvdm14L01ha2VmaWxlDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJj
aC94ODYvdmlydC92bXgvdGR4L01ha2VmaWxlDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJj
aC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L0tjb25maWcgYi9hcmNoL3g4Ni9LY29uZmlnDQo+ID4gaW5kZXggMzYwNDA3NGE4NzhiLi5mYzAx
MDk3M2E2ZmYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvS2NvbmZpZw0KPiA+ICsrKyBiL2Fy
Y2gveDg2L0tjb25maWcNCj4gPiBAQCAtMTk1Miw2ICsxOTUyLDE4IEBAIGNvbmZpZyBYODZfU0dY
DQo+ID4gICANCj4gPiAgIAkgIElmIHVuc3VyZSwgc2F5IE4uDQo+ID4gICANCj4gPiArY29uZmln
IElOVEVMX1REWF9IT1NUDQo+ID4gKwlib29sICJJbnRlbCBUcnVzdCBEb21haW4gRXh0ZW5zaW9u
cyAoVERYKSBob3N0IHN1cHBvcnQiDQo+ID4gKwlkZXBlbmRzIG9uIENQVV9TVVBfSU5URUwNCj4g
PiArCWRlcGVuZHMgb24gWDg2XzY0DQo+ID4gKwlkZXBlbmRzIG9uIEtWTV9JTlRFTA0KPiA+ICsJ
aGVscA0KPiA+ICsJICBJbnRlbCBUcnVzdCBEb21haW4gRXh0ZW5zaW9ucyAoVERYKSBwcm90ZWN0
cyBndWVzdCBWTXMgZnJvbSBtYWxpY2lvdXMNCj4gPiArCSAgaG9zdCBhbmQgY2VydGFpbiBwaHlz
aWNhbCBhdHRhY2tzLiAgVGhpcyBvcHRpb24gZW5hYmxlcyBuZWNlc3NhcnkgVERYDQo+ID4gKwkg
IHN1cHBvcnQgaW4gaG9zdCBrZXJuZWwgdG8gcnVuIHByb3RlY3RlZCBWTXMuDQo+IA0KPiBzL2lu
IGhvc3QvaW4gdGhlIGhvc3QvID8NCg0KU3VyZS4NCg0KPiANCj4gQWxzbywgaXMgInByb3RlY3Rl
ZCBWTXMiIHRoZSByaWdodCB0ZXJtIHRvIHVzZSBoZXJlPyAiRW5jcnlwdGVkIFZNcyIsIA0KPiAi
Q29uZmlkZW50aWFsIFZNcyIgLi4uID8NCg0KIkVuY3J5cHRlZCBWTSIgcGVyaGFwcyBpcyBub3Qg
YSBnb29kIGNob2ljZSwgYmVjYXVzZSB0aGVyZSBhcmUgbW9yZSB0aGluZ3MgdGhhbg0KZW5jcnlw
dGlvbi4gIEkgYW0gYWxzbyBPSyB3aXRoICJDb25maWRlbnRpYWwgVk1zIiwgYnV0ICJwcm90ZWN0
ZWQgVk1zIiBpcyBhbHNvDQp1c2VkIGluIHRoZSBLVk0gc2VyaWVzIChub3QgdXBzdHJlYW1lZCB5
ZXQpLCBhbmQgYWxzbyB1c2VkIGJ5IHMzOTAgYnkgbG9va2luZyBhdA0KdGhlIGdpdCBsb2cuDQoN
ClNvIGJvdGggInByb3RlY3RlZCBWTSIgYW5kICJjb25maWRlbnRpYWwgVk0iIHdvcmsgZm9yIG1l
Lg0KDQpOb3Qgc3VyZSBhbnlvbmUgZWxzZSB3YW50cyB0byBjb21tZW50Pw0KDQo+IA0KWy4uLl0N
Cg0KPiA+ICtzdGF0aWMgdTMyIHRkeF9nbG9iYWxfa2V5aWQgX19yb19hZnRlcl9pbml0Ow0KPiA+
ICtzdGF0aWMgdTMyIHRkeF9ndWVzdF9rZXlpZF9zdGFydCBfX3JvX2FmdGVyX2luaXQ7DQo+ID4g
K3N0YXRpYyB1MzIgdGR4X25yX2d1ZXN0X2tleWlkcyBfX3JvX2FmdGVyX2luaXQ7DQo+ID4gKw0K
PiA+ICsvKg0KPiA+ICsgKiBVc2UgdGR4X2dsb2JhbF9rZXlpZCB0byBpbmRpY2F0ZSB0aGF0IFRE
WCBpcyB1bmluaXRpYWxpemVkLg0KPiA+ICsgKiBUaGlzIGlzIHVzZWQgaW4gVERYIGluaXRpYWxp
emF0aW9uIGVycm9yIHBhdGhzIHRvIHRha2UgaXQgZnJvbQ0KPiA+ICsgKiBpbml0aWFsaXplZCAt
PiB1bmluaXRpYWxpemVkLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIHZvaWQgX19pbml0IGNsZWFy
X3RkeCh2b2lkKQ0KPiA+ICt7DQo+ID4gKwl0ZHhfZ2xvYmFsX2tleWlkID0gMDsNCj4gPiArfQ0K
PiANCj4gV2h5IG5vdCBzZXQgInRkeF9nbG9iYWxfa2V5aWQiIGxhc3QsIHN1Y2ggdGhhdCB5b3Ug
ZG9uJ3QgaGF2ZSB0byBjbGVhciANCj4gd2hlbiBhbnl0aGluZyBnb2VzIHdyb25nIGJlZm9yZSB0
aGF0PyBTZWVtcyBtb3JlIHN0cmFpZ2h0IGZvcndhcmQuDQoNCk15IHRoaW5raW5nIHdhcyBieSBy
ZXNlcnZpbmcgdGhlIGdsb2JhbCBrZXlpZCBhbmQgdGFraW5nIGl0IG91dCBmaXJzdCwgSSBjYW4N
CmNoZWNrIHRoZSByZW1haW5pbmcga2V5aWRzIGZvciBURFggZ3Vlc3RzIGVhc2lseToNCg0KDQor
CWlmICghbnJfdGR4X2tleWlkcykgew0KKwkJcHJfaW5mbygiaW5pdGlhbGl6YXRpb24gZmFpbGVk
OiB0b28gZmV3IHByaXZhdGUgS2V5SURzDQphdmFpbGFibGUuXG4iKTsNCisJCWdvdG8gbm9fdGR4
Ow0KKwl9DQoNCk90aGVyd2lzZSBuZWVkIHRvIGRvOg0KDQoJaWYgKG5yX3RkeF9rZXlpZHMgPCAy
KSB7DQoJCS4uLg0KCX0NCg0KQWxzbywgaW4gdGhlIGxhdGVyIHBhdGNoIHRvIGhhbmRsZSBtZW1v
cnkgaG90cGx1ZyB3ZSB3aWxsIGFkZCBhbiBhZGRpdGlvbmFsIHN0ZXANCnRvIHJlZ2lzdGVyX21l
bW9yeV9ub3RpZmllcigpIHdoaWNoIGNhbiBhbHNvIGZhaWwsIHNvIEkganVzdCBpbnRyb2R1Y2Vk
DQpjbGVhcl90ZHgoKSBoZXJlLsKgDQoNCkJ1dCBub3RoaW5nIGlzIGJpZyBkZWFsLCBhbmQgeWVz
IHdlIGNhbiBzZXQgdGhlIGdsb2JhbCBrZXlpZCBhdCBsYXN0IGFuZCByZW1vdmUNCmNsZWFyX3Rk
eCgpLg0KDQpJJ2xsIGRvIHdoYXQgeW91IHN1Z2dlc3RlZC4NCg0KVGhhbmtzLg0KDQo+IA0KPiA+
ICsNCj4gPiArc3RhdGljIGludCBfX2luaXQgcmVjb3JkX2tleWlkX3BhcnRpdGlvbmluZyh1MzIg
KnRkeF9rZXlpZF9zdGFydCwNCj4gPiArCQkJCQkgICAgdTMyICpucl90ZHhfa2V5aWRzKQ0KPiA+
ICt7DQo+ID4gKwl1MzIgX25yX21rdG1lX2tleWlkcywgX3RkeF9rZXlpZF9zdGFydCwgX25yX3Rk
eF9rZXlpZHM7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBJQTMy
X01LVE1FX0tFWUlEX1BBUlRJT05JTkc6DQo+ID4gKwkgKiAgIEJpdCBbMzE6MF06CU51bWJlciBv
ZiBNS1RNRSBLZXlJRHMuDQo+ID4gKwkgKiAgIEJpdCBbNjM6MzJdOglOdW1iZXIgb2YgVERYIHBy
aXZhdGUgS2V5SURzLg0KPiA+ICsJICovDQo+ID4gKwlyZXQgPSByZG1zcl9zYWZlKE1TUl9JQTMy
X01LVE1FX0tFWUlEX1BBUlRJVElPTklORywgJl9ucl9ta3RtZV9rZXlpZHMsDQo+ID4gKwkJCSZf
bnJfdGR4X2tleWlkcyk7DQo+ID4gKwlpZiAocmV0KQ0KPiA+ICsJCXJldHVybiAtRU5PREVWOw0K
PiA+ICsNCj4gPiArCWlmICghX25yX3RkeF9rZXlpZHMpDQo+ID4gKwkJcmV0dXJuIC1FTk9ERVY7
DQo+ID4gKw0KPiA+ICsJLyogVERYIEtleUlEcyBzdGFydCBhZnRlciB0aGUgbGFzdCBNS1RNRSBL
ZXlJRC4gKi8NCj4gPiArCV90ZHhfa2V5aWRfc3RhcnQgPSBfbnJfbWt0bWVfa2V5aWRzICsgMTsN
Cj4gPiArDQo+ID4gKwkqdGR4X2tleWlkX3N0YXJ0ID0gX3RkeF9rZXlpZF9zdGFydDsNCj4gPiAr
CSpucl90ZHhfa2V5aWRzID0gX25yX3RkeF9rZXlpZHM7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIDA7
DQo+ID4gK30NCj4gDQoNCg==
