Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A3F636DA7
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 23:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiKWWyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 17:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiKWWyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 17:54:03 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E845A9E08A;
        Wed, 23 Nov 2022 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244041; x=1700780041;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=y7SKgn0X5SWbHeC9lBZi34HbNqY+wS/JQnle8P3Tqlo=;
  b=i9L3dOoXS5FPTCwfW2JmIF1BUR+uue86V6MGOq3rLkS/NdG5exTYyGh9
   WShLBMLmx7aMkYvj0rumSZ1ri3X96EX9g7FM0dMvsX9hysFI2zVnllylC
   AJPVj9fxqqJzeB2ipirvBTE/Cz7wq4kR1WR/lQt1C5qaEP9UUJ2ghash6
   n2xq21C7p60A+vxZbDlNB06I6YBpyUiK+c7X8yk8aYyFTq+DvzXiJgN29
   XDWE738VHaXRvRtbpQYIKUimGhX3gvxVZJKVUANvYkOQJkvraFNGAtF77
   pJ1utVz04iQYa0uF0kFJKHw5Wj3q9TsvqMLAtXX/K82AAfWAQIw+z032J
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="311809387"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311809387"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 14:54:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="710748976"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="710748976"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2022 14:54:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 14:54:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 14:53:59 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 14:53:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 14:53:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aofXNeACOoRLJjlRWdbb9bZJPeAV8w6ZN3k8MHmU5LU1CEtIX0XC+YeDidbyo7ypCfLU7qPi9H6ZuxA2Umn5CDSzRTe0FgxSUHsJNImcv5QuLO2AJb12p30Ju7+l02nr0ZwcrUctSMMZkcujgEbur9QJj20nXCzQ/X+gv2HwEuuzWAspAHp/8/jSAkj02XuaE8h+5z7oeiWzBZrlJ0SV0EKFNVaR2ax9aTTIf4AmFGso1EaqN77NodVDXOF3URMaINDtxc5A4nuSOPUccI18Hi0Im8RDWRoRfB3DSs9vW5TklXWSZm/RpH3FWgXdIsq57wMyZ6Xb4wsFYlQh8yxgYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7SKgn0X5SWbHeC9lBZi34HbNqY+wS/JQnle8P3Tqlo=;
 b=S2+RDP7ZZ7ApURqpb4JHTVsSf/xmXsW7TJZw1er41s41TJAohYXxnwbiEt+MOrGSbtJpP9N8y+dk1JYZsGclTEatnjm5bjL2TPsdzOLswvulzcwhO4uSm6piAK4dAVE9i8dY3hX5ripTCFrQZjIyWwdatvHKWWDloNXx4UzkoOK3IEU8OrV2NyEe8fsFkQcxSQZnbBM2IqEgw/ZGAisCoGwxkeE4IDB7MtZ0GTmNNfu2niOI17s006C1qtl6fUDaHxROLAWVwqOSquq0F+9DyudBx8QH1kciTG9iSyZalCSYgiVlaUzpgVmTntZ3NUtJ6NJy/gTUu4xlrNU/tUWoxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 22:53:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 22:53:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Topic: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Thread-Index: AQHY/T3BkERrb6yHxUStNPJD5vkcxK5LnNIAgADJbQCAAFT+AIAAZzMA
Date:   Wed, 23 Nov 2022 22:53:56 +0000
Message-ID: <a5e0f218e911a4ad207da55e21fdeb6d8035fed0.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
         <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
         <57af0b96f8a827828b1d64031774962972bfb060.camel@intel.com>
         <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
In-Reply-To: <1c6580f7-3abb-03ba-dd98-367ddb9bf23b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4947:EE_
x-ms-office365-filtering-correlation-id: ee13106a-d3c2-4bc1-f901-08dacda59a3a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9H2e1HXsP51CJL0rBUGUJzWnjvD8wQSNC1hsz8CQsOvkwZBBcuA03mfETEB+akfzvEQEJOsAeJMJuKLQkBq2LI9pCwT+rvpXr/QyCx6GtWe4uivFeNfxdlKYOBneyku1br+slqrbQKmK4JXpeWl0ToVlHGsOfvx70TKam88+K6aiVYd+65SoIkoGozvl4fFpMc32AJWZkzf/y5GhQUQ9UD8sjMz2r6z5cOfW5qC0iYp/xvu0Z0AWKaR3F1wU64pv4rAk/BrMhbTKwzHH5CSs+vaRoQDEBN+2WFilsc7VZTabj7XCic3UpEuGfFLexSuBfQmTAmtrEhxJVuZJR1lYIIlHkXEmIdoZQ6Sf5dj/LMdFkpIPIA1zLgc/l9YMj23BajNoy9QqBnzY4mPU5ugoyosplD7BVaWJ1VdKA7HRyhS1g8Nw9eUbbux0NmjXLiutfT3HiveRrTFNh2YU2UvfGjQZ4UbbljB/LUzRIRgi9s+aLsdL+P3u8nf7HrzyaaP1hUe1MMiQx9fKj0ABlNLMSeAquQ1JMBPuzliqyLTFdvMEpR0Pf6ZjQIxn1Da3XNChnHvxkO3yRhlxvBnf76aeKhai9/pEAmTZyXlMIUP3t+0gQVPamvfQOkzyulCH2URTDCaSGQEUD3O8IIBO43WuxHEGCoiYVt5iM8lSdpNzKSKLzF9f6k3XCN6cIT8nWb19WlvOduVznuWNOAMs8hwE0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(5660300002)(7416002)(2616005)(8936002)(36756003)(186003)(26005)(316002)(4326008)(8676002)(38070700005)(41300700001)(6512007)(66946007)(64756008)(76116006)(66446008)(66556008)(91956017)(66476007)(54906003)(82960400001)(38100700002)(86362001)(122000001)(2906002)(4001150100001)(83380400001)(30864003)(6506007)(478600001)(6486002)(66899015)(71200400001)(110136005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnJXaVRIaEU2VXhlbEdWUVVoOGdwdVhmcFZJdE9aNTRpU3hLd3pibFBIUE5v?=
 =?utf-8?B?eWNwNWZJb3k3RjZqU0gzREhRM3l5eGRqN3NMZWF2bWxnMm1FWms4RHJReUQ2?=
 =?utf-8?B?Mm5rU3VTdkxMVG5tcjl6SG5qRGhmSWNuZVl3WW9CZTJhNkJLOStSSEpZTUxB?=
 =?utf-8?B?VnAyMUIxMnhyTDlBZ3FLNldZMmp2QnJBQ2I3eWtwLzFHa3c1RzNyU3N0bTZ5?=
 =?utf-8?B?dXhxdEYyc0pXUVVGU3FiNVYxS2RmNC9JWGVBVlczT2VaWXUwY1kzbE5YTVFa?=
 =?utf-8?B?L3lLU3hBOXkrNGh4L2RsMU5ZT2pqbTJwYmxXOFE3Y3F3SzJyb2lmc3VreEhu?=
 =?utf-8?B?a3h4RGRVazcrMVo0YVp5bjlQQ3BVa1dKT2NzTTJXSkxqODdPdDUremJycURC?=
 =?utf-8?B?RlNIZ2hHbFRJL20rMEtoM3l3WHJtbW9JUEMvOUZrUVpMelgwWkFIcEl5Yjdp?=
 =?utf-8?B?c1gyVUtBYXc0L0RIRFhLci8zWE9wM1ZoUFpyQlpIS1NDRTRGSnZwOU85ZThO?=
 =?utf-8?B?TDdMUTVZMU5kRi8xWWpmWCt2VnI1UW5iOWxrV2VuaDZ6dWkzWEJtdXJzNWNl?=
 =?utf-8?B?S2pHY3BiMUliYnR4bCt5bXR4aXc5d1J0M285b3FzS0l1aVYyUWl6V1dlZVNt?=
 =?utf-8?B?dGVqY1krU0hEdjJBRnJmSDR2OU1vTzZoUnBnVDA5UTNIb0lSQkpCMDhrNnFM?=
 =?utf-8?B?NU92My9OOS80bFhUUkoycHVGVlZCcUxjWDJNaW1EU2MycmgzeEp4M0pHeXN0?=
 =?utf-8?B?Z3Z0ekhhOWVWSExYSzMzN09PMFp4aHVzOG1HZlRTZTg3d2hxVytRTFpJcUg2?=
 =?utf-8?B?NTA5THY5UjU0aGhxM3N0QnRpL3pPaU1sQ05BTjIyQnlnQVByTVRjYnlSZ2R3?=
 =?utf-8?B?WnVXUW4yZEpiUFRic1p6amV6eHl4WG9VOW1GRjM4Yzl6Q1hpQ1VGb1YzbU9x?=
 =?utf-8?B?WEgzY0NheXdtb2N0RmU2d0h2b3ZPbUVUeXF0M1dIZ011V2dPY1pVU3RNaU5N?=
 =?utf-8?B?cnduYmtSelFqc1NhS29meVM1UnBmemFiVVJUckdEcEgxNzZhd3JHcTNBRjAz?=
 =?utf-8?B?R3NJTXFmb0JvM3BVTDZOSHk2cHJNUnRocnlsWlhabW14cGQ5Vmlpa0JTWmIy?=
 =?utf-8?B?Qk96YVNFSEt1L1NhMkt3WVE5Z2Uzc2Y3aUl4Qi9RRjRaeWZ2Q0d2S1RONE1O?=
 =?utf-8?B?WFBneHZWd2xLRzZoWFhZZlA1RTEwZXh2T0crTEU2eW1ZL1VpRHpKQ2NMaUZt?=
 =?utf-8?B?ZEsrVE5pNXFuMU8zcEpTbmZEbGVGNEZTNVo3OXdtOFF2YTB3Sm1ldGdWZ3R6?=
 =?utf-8?B?TFpSbHoxVmxIaG1KdUNRcEptTHFsd2xNdUFNQjZTUGhKak90MlZERkUyemwv?=
 =?utf-8?B?VmJTR2hhTG55VnVhUlBhUmM4Z3EvSFNQVVV3ZjliQXZFaXJvYUlaUmR4NkRH?=
 =?utf-8?B?T214cnB0NTdLbHgvNlV0eHM1V29NdUxaeWVGb0hwaDY3UVlRVXFWemQ0Y0Nj?=
 =?utf-8?B?WEFIS0lLdGNhOU1RWk1aZmV6c1FSNEs1N1VVWlg2Z3VDcnlqTmg3NmdlYWxV?=
 =?utf-8?B?RUwyd0pTNFpkMWRDUkwrVjgrekF5T1NvTTNqTHZERENmejlJY0VBWUoxWnFo?=
 =?utf-8?B?TGtSWUVYbWtqTGZrb1RoRWZVODRHMUtWWTgzUVJ5NldxS01VNmgveGJVcWpV?=
 =?utf-8?B?UDU4U3V4cy8wbHNtazRZaGNnaFd6dVA3WnBoK20xZVhoeDRmUjNnenJPR1Nu?=
 =?utf-8?B?cFVQT2Q0R0tSS0NUbitnT2Y0RXBIRENhOVU3QkhtMXEvSEdMdTVUMlFKNzdy?=
 =?utf-8?B?ZFU1NTdFd2pZSVNuUHp4RGJmRCs2YkFXQXV3ZUxmY0krYUsweXBDVG04OXlM?=
 =?utf-8?B?M0hWS2NNRDJtNkRRUGhvbkpqSE56UzdXZ2NBMGU2TEk2eTc5cHF0TFJ3ZjRB?=
 =?utf-8?B?RW9sQ0lIVUhrQ0FueXBPUHV2RTZybDFCbW5YRnRpcndpY2t6WkZESVRmR1V1?=
 =?utf-8?B?b215TU0rQzdtdGlnWk1CSC9CSWpDemRTQjJOalpzVlpjcHhRV3JNaVY4UWZo?=
 =?utf-8?B?QkMwOEVUU3NQamlXVjVMcy9mNmNSTDJyNWxpSnpTa1lxUGRQY2haN1Y1Q0xu?=
 =?utf-8?B?VStTUG5xNlM1YndzUjJGVFBnY3cwQXpNWndlc0tiWnlQZHFZUGlnSFc1N0RK?=
 =?utf-8?B?MXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A549443DF6D33C41A4028F2A66E02080@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee13106a-d3c2-4bc1-f901-08dacda59a3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 22:53:56.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZrHUIy0eZ3eSPUbMnUCUnNZ9IP6AVGinnl0SgjXjH0l7TTcguIXK8eZlAA/Y1CX87pB81cOnWLj/0Q2NcwZ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTIzIGF0IDA4OjQ0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiBPbiAxMS8yMy8yMiAwMzo0MCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gT24gVHVlLCAy
MDIyLTExLTIyIGF0IDE1OjM5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+ID4gPiA+
IFRoYXQgbGFzdCBzZW50ZWNlIGlzIGtpbmRhIGdvb2Z5LiAgSSB0aGluayB0aGVyZSdzIGEgd2F5
IHRvIGRpc3RpbGwgdGhpcw0KPiA+ID4gPiA+ID4gd2hvbGUgdGhpbmcgZG93biBtb3JlIGVmZmVj
aXZlbHkuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ICAgICAgIENNUnMgdGVsbCB0aGUga2Vy
bmVsIHdoaWNoIG1lbW9yeSBpcyBURFggY29tcGF0aWJsZS4gIFRoZSBrZXJuZWwNCj4gPiA+ID4g
PiA+ICAgICAgIHRha2VzIENNUnMgYW5kIGNvbnN0cnVjdHMgICJURCBNZW1vcnkgUmVnaW9ucyIg
KFRETVJzKS4gIFRETVJzDQo+ID4gPiA+ID4gPiAgICAgICBsZXQgdGhlIGtlcm5lbCBncmFudCBU
RFggcHJvdGVjdGlvbnMgdG8gc29tZSBvciBhbGwgb2YgdGhlIENNUg0KPiA+ID4gPiA+ID4gICAg
ICAgYXJlYXMuDQo+ID4gPiA+IA0KPiA+ID4gPiBXaWxsIGRvLg0KPiA+ID4gPiANCj4gPiA+ID4g
QnV0IGl0IHNlZW1zIHdlIHNob3VsZCBzdGlsbCBtZW50aW9uICJDb25zdHJ1Y3RpbmcgVERNUnMg
cmVxdWlyZXMgaW5mb3JtYXRpb24gb2YNCj4gPiA+ID4gYm90aCB0aGUgVERYIG1vZHVsZSAoVERT
WVNJTkZPX1NUUlVDVCkgYW5kIHRoZSBDTVJzIj8gIFRoZSByZWFzb24gaXMgdG8ganVzdGlmeQ0K
PiA+ID4gPiAidXNlIHN0YXRpYyB0byBhdm9pZCBoYXZpbmcgdG8gcGFzcyB0aGVtIGFzIGZ1bmN0
aW9uIGFyZ3VtZW50cyB3aGVuIGNvbnN0cnVjdGluZw0KPiA+ID4gPiBURE1ScyIgYmVsb3cuDQo+
ID4gDQo+ID4gSW4gYSBjaGFuZ2Vsb2csIG5vLiAgWW91IGRvICpOT1QqIHVzZSBzdXBlciB0ZWNo
bmljYWwgbGFuZ3VhZ2UgaW4NCj4gPiBjaGFuZ2Vsb2dzIGlmIG5vdCBzdXBlciBuZWNlc3Nhcnku
ICBNZW50aW9uaW5nICJURFNZU0lORk9fU1RSVUNUIiBoZXJlDQo+ID4gaXMgdXNlbGVzcy4gIFRo
ZSAqTU9TVCogeW91IHdvdWxkIGRvIGZvciBhIGdvb2QgY2hhbmdlbG9nIGlzOg0KPiA+IA0KPiA+
IAlUaGUga2VybmVsIHRha2VzIENNUnMgKHBsdXMgYSBsaXR0bGUgbW9yZSBtZXRhZGF0YSkgYW5k
DQo+ID4gCWNvbnN0cnVjdHMgIlREIE1lbW9yeSBSZWdpb25zIiAoVERNUnMpLg0KPiA+IA0KPiA+
IFlvdSBqdXN0IG5lZWQgdG8gdGFsayBhYm91dCB0aGluZ3MgYXQgYSBoaWdoIGxldmVsIGluIG1v
c3RseQ0KPiA+IG5vbi10ZWNobmljYWwgbGFuZ3VhZ2Ugc28gdGhhdCBmb2xrcyBrbm93IHRoZSBz
dHJ1Y3R1cmUgb2YgdGhlIGNvZGUNCj4gPiBiZWxvdy4gIEl0J3Mgbm90IGEgcmVwbGFjZW1lbnQg
Zm9yIHRoZSBjb2RlLCB0aGUgY29tbWVudHMsICpPUiogdGhlIFREWA0KPiA+IG1vZHVsZSBzcGVj
aWZpY2F0aW9uLg0KPiA+IA0KPiA+IEknbSBhbHNvIG5vdCBxdWl0ZSBzdXJlIHRoYXQgdGhpcyBq
dXN0aWZpZXMgdGhlIHN0YXRpYyB2YXJpYWJsZXMgYW55d2F5Lg0KPiA+ICBUaGV5IGNvdWxkIGJl
IGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBhbmQgcGFzc2VkIGFyb3VuZCwgZm9yIGluc3RhbmNlLg0K
DQpJIHNlZS4gVGhhbmtzIGZvciBleHBsYWluaW5nLg0KDQo+ID4gDQo+ID4gPiA+ID4gPiA+ID4g
VXNlIHN0YXRpYyB2YXJpYWJsZXMgZm9yIGJvdGggVERTWVNJTkZPX1NUUlVDVCBhbmQgQ01SIGFy
cmF5IHRvIGF2b2lkDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEkgZmluZCBpdCB2ZXJ5IHVz
ZWZ1bCB0byBiZSBwcmVjaXNlIHdoZW4gcmVmZXJyaW5nIHRvIGNvZGUuICBZb3VyIGNvZGUNCj4g
PiA+ID4gPiA+IHNheXMgJ3Rkc3lzaW5mb19zdHJ1Y3QnLCB5ZXQgdGhpcyBzYXlzICdURFNZU0lO
Rk9fU1RSVUNUJy4gIFdoeSB0aGUNCj4gPiA+ID4gPiA+IGRpZmZlcmVuY2U/DQo+ID4gPiA+IA0K
PiA+ID4gPiBIZXJlIEkgYWN0dWFsbHkgZGlkbid0IGludGVuZCB0byByZWZlciB0byBhbnkgY29k
ZS4gIEluIHRoZSBhYm92ZSBwYXJhZ3JhcGgNCj4gPiA+ID4gKHRoYXQgaXMgZ29pbmcgdG8gYmUg
cmVwbGFjZWQgd2l0aCB5b3VycyksIEkgbWVudGlvbmVkICJURFNZU0lORk9fU1RSVUNUIiB0bw0K
PiA+ID4gPiBleHBsYWluIHdoYXQgZG9lcyAiaW5mb3JtYXRpb24gb2YgdGhlIFREWCBtb2R1bGUi
IGFjdHVhbGx5IHJlZmVyIHRvLCBzaW5jZQ0KPiA+ID4gPiBURFNZU0lORk9fU1RSVUNUIGlzIHVz
ZWQgaW4gdGhlIHNwZWMuDQo+ID4gPiA+IA0KPiA+ID4gPiBXaGF0J3MgeW91ciBwcmVmZXJlbmNl
Pw0KPiA+IA0KPiA+IEtpbGwgYWxsIG1lbnRpb25zIHRvIFREU1lTSU5GT19TVFJVQ1Qgd2hhdHNv
ZXZlciBpbiB0aGUgY2hhbmdlbG9nLg0KPiA+IFdyaXRlIGNvbXByZWhlbnNpYmxlIEVuZ2xpc2gu
DQoNCk9LLg0KDQo+ID4gDQo+ID4gPiA+ID4gPiA+ID4gaGF2aW5nIHRvIHBhc3MgdGhlbSBhcyBm
dW5jdGlvbiBhcmd1bWVudHMgd2hlbiBjb25zdHJ1Y3RpbmcgdGhlIFRETVINCj4gPiA+ID4gPiA+
ID4gPiBhcnJheS4gIEFuZCB0aGV5IGFyZSB0b28gYmlnIHRvIGJlIHB1dCB0byB0aGUgc3RhY2sg
YW55d2F5LiAgQWxzbywgS1ZNDQo+ID4gPiA+ID4gPiA+ID4gbmVlZHMgdG8gdXNlIHRoZSBURFNZ
U0lORk9fU1RSVUNUIHRvIGNyZWF0ZSBURFggZ3Vlc3RzLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+
ID4gPiBUaGlzIGlzIGFsc28gYSBncmVhdCBwbGFjZSB0byBtZW50aW9uIHRoYXQgdGhlIHRkc3lz
aW5mb19zdHJ1Y3QgY29udGFpbnMNCj4gPiA+ID4gPiA+IGEgKmxvdCogb2YgZ3VuayB3aGljaCB3
aWxsIG5vdCBiZSB1c2VkIGZvciBhIGJpdCBvciB0aGF0IG1heSBuZXZlciBnZXQNCj4gPiA+ID4g
PiA+IHVzZWQuDQo+ID4gPiA+IA0KPiA+ID4gPiBQZXJoYXBzIGJlbG93Pw0KPiA+ID4gPiANCj4g
PiA+ID4gIk5vdGUgbWFueSBtZW1iZXJzIGluIHRkc3lzaW5mb19zdHJ1Y3QnIGFyZSBub3QgdXNl
ZCBieSB0aGUga2VybmVsIi4NCj4gPiA+ID4gDQo+ID4gPiA+IEJ0dywgbWF5IEkgYXNrIHdoeSBk
b2VzIGl0IG1hdHRlcj8NCj4gPiANCj4gPiBCZWNhdXNlIHlvdSdyZSBhZGRpbmcgYSBtYXNzaXZl
IHN0cnVjdHVyZSB3aXRoIGFsbCBraW5kcyBvZiBmaWVsZHMuDQo+ID4gVGhvc2UgZmllbGRzIG1v
c3RseSBhcmVuJ3QgdXNlZC4gIFRoYXQgY291bGQgYmUgZnJvbSBhbiBlcnJvciBpbiB0aGlzDQo+
ID4gc2VyaWVzLCBvciBiZWNhdXNlIHRoZXkgd2lsbCBiZSB1c2VkIGxhdGVyIG9yIGJlY2F1c2Ug
dGhleSB3aWxsICpuZXZlcioNCj4gPiBiZSB1c2VkLg0KDQpPSy4NCg0KPiA+IA0KPiA+ID4gPiA+
ID4gPiA+ICsgICBjbXIgPSAmY21yX2FycmF5WzBdOw0KPiA+ID4gPiA+ID4gPiA+ICsgICAvKiBU
aGVyZSBtdXN0IGJlIGF0IGxlYXN0IG9uZSB2YWxpZCBDTVIgKi8NCj4gPiA+ID4gPiA+ID4gPiAr
ICAgaWYgKFdBUk5fT05fT05DRShpc19jbXJfZW1wdHkoY21yKSB8fCAhaXNfY21yX29rKGNtcikp
KQ0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgIGdvdG8gZXJyOw0KPiA+ID4gPiA+ID4gPiA+
ICsNCj4gPiA+ID4gPiA+ID4gPiArICAgY21yX251bSA9ICphY3R1YWxfY21yX251bTsNCj4gPiA+
ID4gPiA+ID4gPiArICAgZm9yIChpID0gMTsgaSA8IGNtcl9udW07IGkrKykgew0KPiA+ID4gPiA+
ID4gPiA+ICsgICAgICAgICAgIHN0cnVjdCBjbXJfaW5mbyAqY21yID0gJmNtcl9hcnJheVtpXTsN
Cj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICBzdHJ1Y3QgY21yX2luZm8gKnByZXZfY21yID0g
TlVMTDsNCj4gPiA+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgLyog
U2tpcCBmdXJ0aGVyIGVtcHR5IENNUnMgKi8NCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICBp
ZiAoaXNfY21yX2VtcHR5KGNtcikpDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICBicmVhazsNCj4gPiA+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAg
LyoNCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICAgKiBEbyBzYW5pdHkgY2hlY2sgYW55d2F5
IHRvIG1ha2Ugc3VyZSBDTVJzOg0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgICAqICAtIGFy
ZSA0SyBhbGlnbmVkDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICogIC0gZG9uJ3Qgb3Zl
cmxhcA0KPiA+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgICAqICAtIGFyZSBpbiBhZGRyZXNzIGFz
Y2VuZGluZyBvcmRlci4NCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICAgKi8NCj4gPiA+ID4g
PiA+ID4gPiArICAgICAgICAgICBpZiAoV0FSTl9PTl9PTkNFKCFpc19jbXJfb2soY21yKSkpDQo+
ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICBnb3RvIGVycjsNCj4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gV2h5IGRvZXMgY21yX2FycmF5WzBdIGdldCBhIHBhc3Mgb24gdGhlIGVt
cHR5IGFuZCBzYW5pdHkgY2hlY2tzPw0KPiA+ID4gPiANCj4gPiA+ID4gVERYIE1DSEVDSyB2ZXJp
ZmllcyBDTVJzIGJlZm9yZSBlbmFibGluZyBURFgsIHNvIHRoZXJlIG11c3QgYmUgYXQgbGVhc3Qg
b25lDQo+ID4gPiA+IHZhbGlkIENNUi4NCj4gPiA+ID4gDQo+ID4gPiA+IEFuZCBjbXJfYXJyYXlb
MF0gaXMgY2hlY2tlZCBiZWZvcmUgdGhpcyBsb29wLg0KPiA+IA0KPiA+IEkgdGhpbmsgeW91J3Jl
IGNvbmZ1c2luZyB0d28gc2VwYXJhdGUgdGhpbmdzLiAgTUNIRUNLIGVuc3VyZXMgdGhhdCB0aGVy
ZQ0KPiA+IGlzIGNvbnZlcnRpYmxlIG1lbW9yeS4gIFRoZSBDTVJzIHRoYXQgdGhpcyBjb2RlIGxv
b2tzIGF0IGFyZSBzb2Z0d2FyZQ0KPiA+IChURCBtb2R1bGUpIGRlZmluZWQgYW5kIGNyZWF0ZWQg
c3RydWN0dXJlcyB0aGF0IHRoZSBPUyBhbmQgdGhlIG1vZHVsZSBzaGFyZS4NCg0KTm90IHN1cmUg
d2hldGhlciBJIGNvbXBsZXRlbHkgZ290IHlvdXIgd29yZHMsIGJ1dCB0aGUgQ01ScyBhcmUgZ2Vu
ZXJhdGVkIGJ5IHRoZQ0KQklPUywgdmVyaWZpZWQgYW5kIHN0b3JlZCBieSB0aGUgTUNIRUNLLiBU
aHVzIHRoZSBDTVIgc3RydWN0dXJlIGlzIGFsc28NCm1lYW5pbmdmdWwgdG8gdGhlIEJJT1MgYW5k
IHRoZSBNQ0hFQ0ssIGJ1dCBub3QgVERYIG1vZHVsZSBkZWZpbmVkIGFuZCBjcmVhdGVkLg0KDQpU
aGVyZSBhcmUgY291cGxlIG9mIHBsYWNlcyBpbiB0aGUgVERYIG1vZHVsZSBzcGVjIHdoaWNoIHNh
eXMgdGhpcy4gT25lIGV4YW1wbGUNCmlzICJUYWJsZSAzLjE6IFR5cGljYWwgSW50ZWwgVERYIE1v
ZHVsZSBQbGF0Zm9ybS1TY29wZSBJbml0aWFsaXphdGlvbiBTZXF1ZW5jZSINCmFuZCAiMTMuMS4x
LiBJbml0aWFsaXphdGlvbiBhbmQgQ29uZmlndXJhdGlvbiBGbG93Ii4gVGhleSBib3RoIG1lbnRp
b246DQoNCiJCSU9TIGNvbmZpZ3VyZXMgQ29udmVydGlibGUgTWVtb3J5IFJlZ2lvbnMgKENNUnMp
OyBNQ0hFQ0sgY2hlY2tzIHRoZW0gYW5kDQpzZWN1cmVseSBzdG9yZXMgdGhlIGluZm9ybWF0aW9u
LiINCg0KQWxzbywgIjIwLjguMyBDTVJfSU5GTyI6DQoNCiJDTVJfSU5GTyBpcyBkZXNpZ25lZCB0
byBwcm92aWRlIGluZm9ybWF0aW9uIGFib3V0IGEgQ29udmVydGlibGUgTWVtb3J5IFJhbmdlDQoo
Q01SKSwgYXMgY29uZmlndXJlZCBieSBCSU9TIGFuZCBjaGVja2VkIGFuZCBzdG9yZWQgc2VjdXJl
bHkgYnkgTUNIRUNLLiINCg0KPiA+IA0KPiA+IFRoaXMgY21yX2FycmF5W10gc3RydWN0dXJlIGlz
IG5vdCBjcmVhdGVkIGJ5IE1DSEVDSy4NCg0KUmlnaHQuDQoNCkJ1dCBUREguU1lTLklORk8gb25s
eSAiUmV0cmlldmUgSW50ZWwgVERYIG1vZHVsZSBpbmZvcm1hdGlvbiBhbmQgY29udmVydGlibGUN
Cm1lbW9yeSAoQ01SKSBpbmZvcm1hdGlvbi4iIGJ5IHdyaXRpbmcgQ01ScyB0byB0aGUgYnVmZmVy
IHByb3ZpZGVkIGJ5IHRoZSBrZXJuZWwNCihjbXJfYXJyYXlbXSkuDQoNClNvIG15IHVuZGVyc3Rh
bmRpbmcgaXMgdGhlIGVudHJpZXMgaW4gdGhlIGNtcl9hcnJheVtdIGFyZSBqdXN0IHRoZSBzYW1l
IENNUnMNCnRoYXQgYXJlIHZlcmlmaWVkIGJ5IHRoZSBNQ0hFQ0suDQoNCj4gPiANCj4gPiBHbyBs
b29rIGF0IHlvdXIgY29kZS4gIENvbnNpZGVyIHdoYXQgd2lsbCBoYXBwZW4gaWYgY21yX2FycmF5
WzBdIGlzDQo+ID4gZW1wdHkgb3IgIWlzX2Ntcl9vaygpLiAgVGhlbiBjb25zaWRlciB3aGF0IHdp
bGwgaGFwcGVuIGlmIGNtcl9hcnJheVsxXQ0KPiA+IGhhcyB0aGUgc2FtZSBoYXBwZW4uDQo+ID4g
DQo+ID4gRG9lcyB0aGF0IGVuZCByZXN1bHQgcmVhbGx5IGp1c3RpZnkgaGF2aW5nIHNlcGFyYXRl
IGNvZGUgZm9yDQo+ID4gY21yX2FycmF5WzBdIGFuZCBjbXJfYXJyYXlbPjBdPw0KDQpPbmUgc2xp
Z2h0IGRpZmZlcmVuY2UgaXMgY21yX2FycmF5WzBdIG11c3QgYmUgdmFsaWQsIGJ1dCBjbXJfYXJy
YXlbPjFdIGNhbiBiZQ0KZW1wdHkuIEFuZCBmb3IgY21yX2FycmF5Wz4wXSB3ZSBhbHNvIGhhdmUg
YWRkaXRpb25hbCBjaGVjayBhZ2FpbnN0IHRoZSBwcmV2aW91cw0Kb25lLg0KDQo+ID4gDQo+ID4g
PiA+ID4gPiA+ID4gKyAgICAgICAgICAgcHJldl9jbXIgPSAmY21yX2FycmF5W2kgLSAxXTsNCj4g
PiA+ID4gPiA+ID4gPiArICAgICAgICAgICBpZiAoV0FSTl9PTl9PTkNFKChwcmV2X2Ntci0+YmFz
ZSArIHByZXZfY21yLT5zaXplKSA+DQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY21yLT5iYXNlKSkNCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAg
ICAgICAgICAgIGdvdG8gZXJyOw0KPiA+ID4gPiA+ID4gPiA+ICsgICB9DQo+ID4gPiA+ID4gPiA+
ID4gKw0KPiA+ID4gPiA+ID4gPiA+ICsgICAvKiBVcGRhdGUgdGhlIGFjdHVhbCBudW1iZXIgb2Yg
Q01ScyAqLw0KPiA+ID4gPiA+ID4gPiA+ICsgICAqYWN0dWFsX2Ntcl9udW0gPSBpOw0KPiA+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gPiBUaGF0IGNvbW1lbnQgaXMgbm90IGhlbHBmdWwuICBZZXMsIHRo
aXMgaXMgbGl0ZXJhbGx5IHVwZGF0aW5nIHRoZSBudW1iZXINCj4gPiA+ID4gPiA+IG9mIENNUnMu
ICBMaXRlcmFsbHkuICBUaGF0J3MgdGhlICJ3aGF0Ii4gIEJ1dCwgdGhlICJ3aHkiIGlzIGltcG9y
dGFudC4NCj4gPiA+ID4gPiA+IFdoeSBpcyBpdCBkb2luZyB0aGlzPw0KPiA+ID4gPiANCj4gPiA+
ID4gV2hlbiBidWlsZGluZyB0aGUgbGlzdCBvZiAiVERYLXVzYWJsZSIgbWVtb3J5IHJlZ2lvbnMs
IHRoZSBrZXJuZWwgdmVyaWZpZXMgdGhvc2UNCj4gPiA+ID4gcmVnaW9ucyBhZ2FpbnN0IENNUnMg
dG8gc2VlIHdoZXRoZXIgdGhleSBhcmUgdHJ1bHkgY29udmVydGlibGUgbWVtb3J5Lg0KPiA+ID4g
PiANCj4gPiA+ID4gSG93IGFib3V0IGFkZGluZyBhIGNvbW1lbnQgbGlrZSBiZWxvdzoNCj4gPiA+
ID4gDQo+ID4gPiA+ICAgICAgICAgLyoNCj4gPiA+ID4gICAgICAgICAgKiBXaGVuIHRoZSBrZXJu
ZWwgYnVpbGRzIHRoZSBURFgtdXNhYmxlIG1lbW9yeSByZWdpb25zLCBpdCB2ZXJpZmllcw0KPiA+
ID4gPiAgICAgICAgICAqIHRoZXkgYXJlIHRydWx5IGNvbnZlcnRpYmxlIG1lbW9yeSBieSBjaGVj
a2luZyB0aGVtIGFnYWluc3QgQ01Scy4NCj4gPiA+ID4gICAgICAgICAgKiBVcGRhdGUgdGhlIGFj
dHVhbCBudW1iZXIgb2YgQ01ScyB0byBza2lwIHRob3NlIGVtcHR5IENNUnMuDQo+ID4gPiA+ICAg
ICAgICAgICovDQo+ID4gPiA+IA0KPiA+ID4gPiBBbHNvLCBJIHRoaW5rIHByaW50aW5nIENNUnMg
aW4gdGhlIGRtZXNnIGlzIGhlbHBmdWwuICBQcmludGluZyBlbXB0eSAoemVybykgQ01Scw0KPiA+
ID4gPiB3aWxsIHB1dCBtZWFuaW5nbGVzcyBsb2cgdG8gdGhlIGRtZXNnLg0KPiA+IA0KPiA+IFNv
IGl0J3MganVzdCBhYm91dCBwcmludGluZyB0aGVtPw0KPiA+IA0KPiA+IFRoZW4gcHV0IGEgZGFu
ZyBzd2l0Y2ggdG8gdGhlIHByaW50IGZ1bmN0aW9uIHRoYXQgc2F5cyAicHJpbnQgdGhlbSBhbGwi
DQo+ID4gb3Igbm90Lg0KDQpZZXMgY2FuIGRvLiBDdXJyZW50bHkgInByaW50IHRoZW0gYWxsIiBp
cyBvbmx5IGRvbmUgd2hlbiB0aGUgQ01SIHNhbml0eSBjaGVjaw0KZmFpbHMuIFdlIGNhbiB1bmNv
bmRpdGlvbmFsbHkgInByaW50IHZhbGlkIENNUnMiIGlmIHdlIGRvbid0IG5lZWQgdGhhdCBjaGVj
ay4NCg0KPiA+IA0KPiA+IC4uLg0KPiA+ID4gPiA+ID4gQWxzbywgSSBzYXcgdGhlIGxvb3AgYWJv
dmUgY2hlY2sgJ2Ntcl9udW0nIENNUnMgZm9yIGlzX2Ntcl9vaygpLiAgTm93LA0KPiA+ID4gPiA+
ID4gaXQnbGwgcHJpbnQgYW4gJ2FjdHVhbF9jbXJfbnVtPTEnIG51bWJlciBvZiBDTVJzIGFzIGJl
aW5nDQo+ID4gPiA+ID4gPiAia2VybmVsLWNoZWNrZWQiLiAgV2h5PyAgVGhhdCBtYWtlcyB6ZXJv
IHNlbnNlLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhlIGxvb3AgcXVpdHMgd2hlbiBpdCBzZWVzIGFu
IGVtcHR5IENNUi4gIEkgdGhpbmsgdGhlcmUncyBubyBuZWVkIHRvIGNoZWNrDQo+ID4gPiA+IGZ1
cnRoZXIgQ01ScyBhcyB0aGV5IG11c3QgYmUgZW1wdHkgKFREWCBNQ0hFQ0sgdmVyaWZpZXMgQ01S
cykuDQo+ID4gDQo+ID4gT0ssIHNvIHlvdSdyZSBnb2luZyB0byBnZXQgc29tZSBtb3JlIGhvbWV3
b3JrIGhlcmUuICBQbGVhc2UgZXhwbGFpbiB0bw0KPiA+IG1lIGhvdyBNQ0hFQ0sgYW5kIHRoZSBD
TVIgYXJyYXkgdGhhdCBjb21lcyBvdXQgb2YgdGhlIFREWCBtb2R1bGUgYXJlDQo+ID4gcmVsYXRl
ZC4gIEhvdyBkb2VzIHRoZSBvdXRwdXQgZnJvbSBNQ0hFQ0sgZ2V0IHR1cm5lZCBpbnRvIHRoZSBp
bi1tZW1vcnkNCj4gPiBjbXJfYXJyYXlbXSwgc3RlcCBieSBzdGVwPw0KPiA+IA0KDQooUGxlYXNl
IGFsc28gc2VlIG15IGFib3ZlIHJlcGx5KQ0KDQoxLiBCSU9TIGdlbmVyYXRlcyB0aGUgQ01ScyBh
bmQgcGFzcyB0byB0aGUgTUNIRUNLDQoyLiBNQ0hFQ0sgdmVyaWZpZXMgQ01ScyBhbmQgc3RvcmVz
IHRoZSAiQ01SIHRhYmxlIGluIGEgcHJlLWRlZmluZWQgbG9jYXRpb24gaW4NClNFQU1SUuKAmXMg
U0VBTUNGRyByZWdpb24gc28gaXQgY2FuIGJlIHJlYWQgbGF0ZXIgYW5kIHRydXN0ZWQgYnkgdGhl
IEludGVsIFREWA0KbW9kdWxlIiAoMTMuMS40LjEgSW50ZWwgVERYIElTQSBCYWNrZ3JvdW5kOiBD
b252ZXJ0aWJsZSBNZW1vcnkgUmFuZ2VzIChDTVJzKSkuDQozLiBUREguU1lTLklORk8gY29waWVz
IHRoZSBDTVJzIHRvIHRoZSBidWZmZXIgcHJvdmlkZWQgYnkgdGhlIGtlcm5lbA0KKGNtcl9hcnJh
eVtdKS4NCg0KPiA+IEF0IHRoaXMgcG9pbnQsIEkgZmVhciB0aGF0IHlvdSdyZSBvZmZlcmluZyB1
cCBNQ0hFQ0sgbGlrZSBpdCdzIGEgYmFnIG9mDQo+ID4gbWFnaWMgYmVhbnMgcmF0aGVyIHRoYW4g
cmVhbGx5IHRydWx5IHRoaW5raW5nIGFib3V0IHRoZSBjbXJfYXJyYXlbXSBkYXRhDQo+ID4gc3Ry
dWN0dXJlLiAgSG93IGl0IGlzIGdlbmVyYXRlZD8gIEhvdyBtaWdodCBpdCBiZSBicm9rZW4/IFdo
byBtaWdodA0KPiA+IGJyZWFrIGl0PyAgIElmIHNvLCB3aGF0IHRoZSBrZXJuZWwgc2hvdWxkIGRv
IGFib3V0IGl0Pw0KDQpPbmx5IGtlcm5lbCBidWcgY2FuIGJyZWFrIHRoZSBjbXJfYXJyYXlbXSBJ
IHRoaW5rLiBBcyBkZXNjcmliZWQgaW4gIjEzLjEuNC4xDQpJbnRlbCBURFggSVNBIEJhY2tncm91
bmQ6IENvbnZlcnRpYmxlIE1lbW9yeSBSYW5nZXMgKENNUnMpIiwgTUNIRUNLIHNob3VsZCBoYXZl
DQpndWFyYW50ZWVkIHRoYXQ6DQoJLSB0aGVyZSBtdXN0IGJlIG9uZSBDTVINCgktIENNUiBpcyBw
YWdlIGFsaWduZWQNCgktIENNUnMgZG9uJ3Qgb3ZlcmxhcCBhbmQgaW4gYWRkcmVzcyBhc2NlbmRp
bmcgb3JkZXINCg0KVGhlIG9ubHkgbGVnYWwgdGhpbmcgaXMgdGhlcmUgbWlnaHQgYmUgZW1wdHkg
Q01ScyBhdCB0aGUgdGFpbCBvZiB0aGUgY21yX2FycmF5W10NCmZvbGxvd2luZyBvbmUgb3IgbW9y
ZSB2YWxpZCBDTVJzLg0KDQo+ID4gDQo+ID4gDQo+ID4gPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ID4gPiA+ICsgICAvKg0KPiA+ID4gPiA+ID4gPiA+ICsgICAgKiB0cmltX2VtcHR5X2NtcnMoKSB1
cGRhdGVzIHRoZSBhY3R1YWwgbnVtYmVyIG9mIENNUnMgYnkNCj4gPiA+ID4gPiA+ID4gPiArICAg
ICogZHJvcHBpbmcgYWxsIHRhaWwgZW1wdHkgQ01Scy4NCj4gPiA+ID4gPiA+ID4gPiArICAgICov
DQo+ID4gPiA+ID4gPiA+ID4gKyAgIHJldHVybiB0cmltX2VtcHR5X2NtcnModGR4X2Ntcl9hcnJh
eSwgJnRkeF9jbXJfbnVtKTsNCj4gPiA+ID4gPiA+ID4gPiArfQ0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiBXaHkgZG9lcyB0aGlzIGJvdGggbmVlZCB0byByZXNwZWN0IHRoZSAidGR4X2Ntcl9u
dW0gPSBvdXQucjkiIHZhbHVlDQo+ID4gPiA+ID4gPiAqYW5kKiB0cmltIHRoZSBlbXB0eSBvbmVz
PyAgQ291bGRuJ3QgaXQganVzdCBpZ25vcmUgdGhlICJ0ZHhfY21yX251bSA9DQo+ID4gPiA+ID4g
PiBvdXQucjkiIHZhbHVlIGFuZCBqdXN0IHRyaW0gdGhlIGVtcHR5IG9uZXMgZWl0aGVyIHdheT8g
IEl0J3Mgbm90IGxpa2UNCj4gPiA+ID4gPiA+IHRoZXJlIGlzIGEgYmlsbGlvbiBvZiB0aGVtLiAg
SXQgd291bGQgc2ltcGxpZnkgdGhlIGNvZGUgZm9yIHN1cmUuDQo+ID4gPiA+IA0KPiA+ID4gPiBP
Sy4gIFNpbmNlIHNwZWMgc2F5cyBNQVhfQ01ScyBpcyAzMiwgc28gSSBjYW4gdXNlIDMyIGluc3Rl
YWQgb2YgcmVhZGluZyBvdXQgZnJvbQ0KPiA+ID4gPiBSOS4NCj4gPiANCj4gPiBCdXQgdGhlbiB5
b3Ugc3RpbGwgaGF2ZSB0aGUgInRyaW1taW5nIiBjb2RlLiAgV2h5IG5vdCBqdXN0IHRydXN0ICJy
OSINCj4gPiBhbmQgdGhlbiBheGUgYWxsIHRoZSB0cmltbWluZyBjb2RlPyAgSGVjaywgYW5kIG1v
c3Qgb2YgdGhlIHNhbml0eSBjaGVja3MuDQo+ID4gDQo+ID4gVGhpcyBjb2RlIGNvdWxkIGJlIGEg
KmxvdCogc21hbGxlci4NCg0KQXMgSSBzYWlkIHRoZSBvbmx5IHByb2JsZW0gaXMgdGhlcmUgbWln
aHQgYmUgZW1wdHkgQ01ScyBhdCB0aGUgdGFpbCBvZiB0aGUNCmNtcl9hcnJheVtdIGZvbGxvd2lu
ZyBvbmUgb3IgbW9yZSB2YWxpZCBDTVJzLiDCoA0KDQpCdXQgd2UgY2FuIGFsc28gZG8gbm90aGlu
ZyBoZXJlLCBidXQganVzdCBza2lwIGVtcHR5IENNUnMgd2hlbiBjb21wYXJpbmcgdGhlDQptZW1v
cnkgcmVnaW9uIHRvIGl0IChpbiBuZXh0IHBhdGNoKS4NCg0KT3IsIHdlIGRvbid0IGV2ZW4gbmVl
ZCB0byBleHBsaWNpdGx5IGNoZWNrIG1lbW9yeSByZWdpb24gYWdhaW5zdCBDTVJzLiBJZiB0aGUN
Cm1lbW9yeSByZWdpb25zIHRoYXQgd2UgcHJvdmlkZWQgaW4gdGhlIFRETVIgZG9lc24ndCBmYWxs
IGludG8gQ01SLCB0aGVuDQpUREguU1lTLkNPTkZJRyB3aWxsIGZhaWwuIFdlIGNhbiBqdXN0IGRl
cGVuZCBvbiB0aGUgU0VBTUNBTEwgdG8gZG8gdGhhdC4NCg0KDQo=
