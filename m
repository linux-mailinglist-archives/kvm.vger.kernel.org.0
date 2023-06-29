Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48E7741CC5
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 02:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjF2AKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 20:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbjF2AKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 20:10:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6484A10CF;
        Wed, 28 Jun 2023 17:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687997411; x=1719533411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fePX9SlnFnudb9pXKCtvP4hisXp4nIY7htnBXCwcyi0=;
  b=RhBZA6z/RjAPfLDGTSgKtEnW+YXkMkSWcs5OLHTu6AND3hC0bMOdyaeX
   nSbsA7aAmIsc9dYe8JEu2+Yp0LHxy4NmN4Akphrnle7yAO6QgAeTOqtBf
   C3q8jyA8c5PktEAd7POzCAvpVls/LBaSusaWz3RCdZpdHt6n/X1ulM8bc
   DC6fC6oTCyxSv5cZQX4A91TESpXO5Q7Usa6i4JK7ukw5wOfmJYHCSTCWZ
   09Qc/aD6LKY/owpvkA2Xmhcg77h9JkBj6mI6r4qTc4NUVLIULnA5pcfby
   9B4EsoB6w8glI//ZWYKxAirI6gkd3/tX0fj/PD+202N2x0ZyFIz9vc9Vt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="428006695"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="428006695"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 17:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="667312837"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="667312837"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 28 Jun 2023 17:10:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:10:09 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 17:10:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 17:10:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 17:10:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7h30OwZo6xHK1BedXjXu+RY2fRrz2Ok9XyexGrAFJQSbpmC0AV8+RAKbk2zlVP1I0pl+KXjnzkiprLaEV2gxQQm2+szAJSMoZ3UM8weWhjGRb/6LoeJMOz62RbD0i3b21jtaSd4fdFuIj7nN52KnIWTxnhsxISwKKZvAFY6q2j/YHA7SMtuinarg5egjmC0JQq88Vj3uYsT/VLPpA+5NNKBUkn2XbmRkT0+Ubk3RoNmxQf6/GCkgq8O9SAt/S2SfE3eTZgdJoGDHsO3pv4vYY8tQgz5RarjbuJDJP2KxuZr+WDXeT/9W6FWTmymUflbneS2gI0rrX75vuTUH9/i6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fePX9SlnFnudb9pXKCtvP4hisXp4nIY7htnBXCwcyi0=;
 b=leHrWlQ0vINGZsn7zC6G6p0qdzOl6eQp84VKd0lK3hnWIQp/kAoIhaKCl63dyFF7VcPlujvnCUI8DFanjC6w//JNt9gAE0CF53vSaLcRjYEHunMrF2XQuABMummreTPuHGGND+DxsBmcnUR2nIaj4llnH+8dCJ3QP5jvjY2sN6Uwfcd1yf7hHhSfhgPFwQAUkgNtsPxoCWIq8W/tSaZAPbj3uJVdRO2mweBCl2s07S9m57f/Wkbru1gRkx6LXo5Td6KEX9t3DCJMBoMsX/djdSKnIFAPxfUZ+MieIJYOBR627lLCMPAd8Dhnmy7AqPl5Rv/jSrCxX1J2gOgHIyBDgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8250.namprd11.prod.outlook.com (2603:10b6:510:1a8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 00:10:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 00:10:00 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
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
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gNU2AgAC2WwA=
Date:   Thu, 29 Jun 2023 00:10:00 +0000
Message-ID: <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
In-Reply-To: <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8250:EE_
x-ms-office365-filtering-correlation-id: fd621991-b449-472a-de27-08db78352e59
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThYpUS1hO+efbh/PFmodqo4tbRXXlXNEUoQRtEXewby9fXEJGLg2f+APBcDTTrqv3n8K7WOxiUefbJ5rSOGZ3TTMV2+7VTHtnFKFASeWFRYsdf0YMCSdYBspsY1e2ZwiLJ3QkJqjIoz4T67nZ2T3vAowwX3cZzdAmaaPSzXQGMaTMwdp3RSBjc5q9KmIU1JAiFAIKfAZTd2pHGFbZM1+EfgsK6YBvIjmr/N9DyvWZ4+SMrIpqCaQ6aCHx7LbraIqWif8HgSn0GhPeKfOKew+s2L1N9YHT7+2MYhHot4K5ARv8y6O4D64W2CMIhTlfvyj4+cFrf1y78Jx+oXIti1ozozorcDnvtIoLjjlKedtnzOjDheb83pDhuDSev8y9952qSsywdWwTmtLZGJW4emSK1cn2PkTK4G3weklRIYMzMmQmBZz5uFTa3WC4pL5LQHY7wqlkVcHF/pLsfv/f5HDqmyr0qwLl9G9ud0mR6pJ+KGy07lCqMkKo/WL13DOtQQeFO6kvQj+Sbx80sCLQNJymdZzHzjy3kF5uqKzC+Wy8/+ZEmJ2YIZqf5qDEMrnNpdpquNbQF2zvPTI31nJYs1mrK6/3BOKCyLllmrFgWeIgmGSl2TQylKVYpHyqo7WtNQr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(376002)(396003)(346002)(366004)(451199021)(8936002)(6486002)(316002)(71200400001)(8676002)(54906003)(4326008)(41300700001)(36756003)(122000001)(86362001)(82960400001)(38100700002)(64756008)(2616005)(7416002)(6512007)(5660300002)(66556008)(66446008)(66946007)(66476007)(478600001)(6916009)(2906002)(91956017)(186003)(4744005)(26005)(76116006)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlMzYTRqT29RdGFxYzJMWkNSbm5yeGk4NTNkZVFCWVE4cmgrcTB3S0RBYTdX?=
 =?utf-8?B?VUhzTW9KTUJJSlQrbGhhZHNHdms1UksyY1ZhN0pTVDczM3d4YUVmczBab0lk?=
 =?utf-8?B?NnBYemQyamhrWFhZdlFXOGZ1Y1gySUdhdERGVjRNRndkRVZxckJ0MEl4RkVO?=
 =?utf-8?B?Mjc1T2RQMCsxcXNjK0M1N3lUV05XaFAxRmk0N2llSHBLdWRjRWhUUG0vOWFE?=
 =?utf-8?B?emNQUk8zR0xvSzdhQUxHdFVIU0NxWURtSUxOV3FNcWpzWFhjUVA3bCtYc2Iw?=
 =?utf-8?B?aEJoOENDZWR1SGxuSlR2QWJsdUF6SDJpOEpDMzJjRkVlSjUzdE9pdTNCc2pX?=
 =?utf-8?B?eHk5OHJCVU1ZTk0yOEJaQXpNdy9VaVIzVGtFQ05xSmpjZDdUbDgvMWllZStQ?=
 =?utf-8?B?bndLVGdjdDhEYUNGZnFobmUrTGIvVUc2T0VmaGRZZWFvTThmQTdwWUNoMHIw?=
 =?utf-8?B?QUwzbE9iczZ1ZGFMdXludWw4R29GbTE2bitweTB3U0UwZGpISGtvc1IxbUkr?=
 =?utf-8?B?cDVUelBIWUlFRG1FNXhrdnlyVm5wSytvUzBRenMxYUZsN05pTzNSZ0prRXhm?=
 =?utf-8?B?RXBIY1hVSUhwa1Zudkk0ZldFMm15WkNlZUZpcnl6YUt2RWd4Zk5VZ0tvU3Vq?=
 =?utf-8?B?Y29yc1ozYjdEWWp3U3phOFJPbk41QmUrN3pZVkJsb2JxMTV0UnZRc2pVV1Rq?=
 =?utf-8?B?aU1NUGg5VG9OM0Y3aXc3bXJnUjJKY2s1SlRFZnZzcmFMNnVoYk12MWpWNlZ5?=
 =?utf-8?B?MVVtOHJzUHZvdHF2NFgwSHNZeUs0T041cDlhUnAwK3g1ODhUY1Uwd0Q2NllV?=
 =?utf-8?B?a0doUkxZMGdCZElFaHlxalVuYWZFZklPdEN6LzFOZ2c2cThxYmdCREc1M0VE?=
 =?utf-8?B?SnAzZjAzSTlpYmZOL2l6elF5Sit4akxzWXBsR29yMnJHcXhrbnQzZkwrUWd4?=
 =?utf-8?B?bnhuZWhoVXBKMHI0ejBEUHRoMXlBK0h2bTlnT1luQmVYL2pETEM2OHFreTRU?=
 =?utf-8?B?WHR2UU9iWWorbVpJZ29pY1B5TWo3VjhyWUExZ09KeFB6cHlGMDVTWDhXVGFJ?=
 =?utf-8?B?ZjdjNUNJK0xXbmRXeVlZMzV0T2tQTXVhTmQ5L3dFeTArMHMyQTlLVWY2VG5G?=
 =?utf-8?B?R3pPcnB0dHlPK3ZUanFaR1lkb3pacTFXMHpadEJqY0NNei92TGdvbXJlNjky?=
 =?utf-8?B?bVd6MzN4dVAxcmlkejdodlJrWENmQ3hPcU5DMjZqeFpzSENUS3BmNnFMZEhm?=
 =?utf-8?B?SUtFUWQ2L2J2WGV3WE5jcVJnVWVFMklvNnhjQm5uNUg4aGtNemVoOVA1anZK?=
 =?utf-8?B?dVFUMERRWWZ2NDROV1FVd0Q5TFp5VS9YWEdIVWlwSGVwRWxNZWRZWFlEaUJM?=
 =?utf-8?B?MkVQYzVGWlpzRWhvTklOVW1uUWJQLzVDVzBQdDIvY2J2MEJYNlRPTWcrclZ5?=
 =?utf-8?B?aVZqc0NBazVTWDVYUkRxbmxmM2xlRS8zLzRQbkRPVlpFVzZKajhvV2NVcEpm?=
 =?utf-8?B?NGdxRjBQMnRUZlRGVUkwRm54Rzg5ZmliTGZJR1kyeGJSd3dnNXdMdlpOajh2?=
 =?utf-8?B?Z1MwMnJWM3FMUmhtWWd2MTA1c010S2tyZGRsL2xyOFFGR05JckdLVTU1cVpJ?=
 =?utf-8?B?NnBqcFkwcUxrd25UNzNybTRsdzhOT1lleGRnWURlOUhOME5nOXBWVHBTc0FV?=
 =?utf-8?B?RjA4ZDZUdWFhUE40QlJHbDlHZVRkUzJKRW0yamE4YUlVbHYrYk5oUjFHMWhm?=
 =?utf-8?B?eVo0aGpzRzZULzhaa29WZUZlZ093V0l5MkloYzZYeTJrdjdQNHd0bFFra3Bj?=
 =?utf-8?B?VDc1Mng5TmpnaUJvZTNDejE4ZzBTbWI4TUZDVlNtL3MvVlFhZmNnTWZ2anRy?=
 =?utf-8?B?ei8vTXEyaUI3eUhWNXpOL2JLcG1kM2hqdTlkdnp1VEozN1lQZk0wVDAyVkFm?=
 =?utf-8?B?OHBoREk1MkYvVmhYUWs4ZXNYMnkvMTltTWZiMGptbUovWnRWcTE4VFl2T0Ev?=
 =?utf-8?B?aENZNGdYQ3pTempuUGJvd1pOSXR2M0tLeVpLTnh1OTJjSnl4Z0p6K1k3N29O?=
 =?utf-8?B?T2RxN0RRWTBuY1Bxd0Q1UnoxUGZ2VXN4N2ZxVTBFcHYrVHlVb29mb2dVV2Vp?=
 =?utf-8?B?Ky9yOElaamlLVEpCZjB0VHd3dHdMT1RiVU5SUWlCRDVHYkdQcnp5YWJUelBv?=
 =?utf-8?B?cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06CA1749A269984182C3467720FB9133@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd621991-b449-472a-de27-08db78352e59
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 00:10:00.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 868tW8Pa+uWgAXunf7CrcTI81DPVi7UjCsyIONTpYQIEvRrnTjmbFHy3blKJoxDvYtQazuGmSZUU1iNZuKqZjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8250
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDE1OjE3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzdBTSArMTIwMCwgS2FpIEh1YW5nIHdy
b3RlOg0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfY3B1X2VuYWJsZSk7DQo+IA0KPiBJIGNh
bid0IGZpbmQgYSBzaW5nbGUgY2FsbGVyIG9mIHRoaXMuLiB3aHkgaXMgdGhpcyBleHBvcnRlZD8N
Cg0KSXQncyBmb3IgS1ZNIFREWCBwYXRjaCB0byB1c2UsIHdoaWNoIGlzbid0IGluIHRoaXMgc2Vy
aWVzLg0KDQpJJ2xsIHJlbW92ZSB0aGUgZXhwb3J0LiAgS1ZNIFREWCBzZXJpZXMgY2FuIGV4cG9y
dCBpdC4NCg==
