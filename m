Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE3647029
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 13:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiLHM4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 07:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLHM4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 07:56:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1779668688;
        Thu,  8 Dec 2022 04:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670504178; x=1702040178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=o69zYnoqrHKBw0Ql9SScBRTEuFJa68QM8Ir/hQfvEas=;
  b=D7TxXDw1QWyjeJHLo+r2miBuJ2T/ar8Nag/AYWTBz+0HhCNpz6aYtusP
   FnP9e6fvWZt0yiw4GgxD2aLfuJPa+biQ7VdH1qUO5y80oGpXE4LYynGdz
   Nz/DVgYKySh4mlrDJvagZC9CqbMD2gbXTD9jnijFiEo0g3sFkzxUH5cEG
   +KZ9w2DhFse4etkylrbBtFZ6Q9AlX5p2WXZqIpf/Nkiwe5inhUFp5GbjI
   MPVDn5hH4ziNTOQHkTgNYYvOSPy7gvzhA8ofKtu9kxBa9iYobN1G5iAtt
   kYlvhYcLO+uAie0mJofK7DbFjId92EeOb7BDsbasC2Vu2PxO7sThPjKlm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="379323991"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="379323991"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 04:56:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="624689818"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="624689818"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 04:56:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 04:56:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 04:56:16 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 04:56:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 04:56:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dbic/uFr+RL1PCHRow1FET7nwEdZwwNr+I5Js9YRDDZKnIQ1/DUv23yZj4ZbhNixtptuMPV0xNnGM2RH/XBW1YyomZo9uDCFiaqt8bLz0aWhMokyy+RzfKLuIfy3W5CT92P3Cya9p0B4tGk95subcHNhRWFha3BsI//N+o9gbS3roAwAWn3JiPLi6oBtIGVimOAFPCn6/R9garrw2G2Nj5ZGeaLr7PZH7dKZ5KfuZS1bOFINNdQkaOo4XMcjO6IZKJmln7hIVdH3tlzba7tHQ/ZtcnULwDzuNDK+phz8biiDs3gu4i15jT85DE58eJFVGWlnrjKiZJDaMeQ672qciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o69zYnoqrHKBw0Ql9SScBRTEuFJa68QM8Ir/hQfvEas=;
 b=QOfsMdEihmM8j+8SptOshExwJUSMrtGpy4BKsndSTbq8GLuSe+sFL6kyirbC5WjJsh6qrABxfNsXW3+r7IKoQuBIe6LPArO9x0cvUrWPEBDZQjzJPTJ4YIilrYrvQU9fDdSX8ZHfQ/IwhumIp6JottcBKrCGAamemXfgDfER5qsiIetT1WQUP2Lsw8tDr5xh7D16EQ4dG9DkMlUKrQXhSkyquJoksQrNDOKLbH0thuzV+fabmAg8YhBqi9TeeR1607Jr2Is2O8C8XYRrZugLW0pEnQH2jkQ+zKDiZ59xQFEf39RX8Xdm0V0lpLaTcNs3ATvdqlS2ZjdbvN+5pWhtIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4640.namprd11.prod.outlook.com (2603:10b6:806:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 12:56:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 12:56:09 +0000
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Thread-Topic: [PATCH v7 11/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Thread-Index: AQHY/T3ORWilVlKW4kyc0A5kdGk0eq5NGDiAgADmkYCABotngIAAaI+AgAAB1QCAAAiegIANa7YAgAGleYA=
Date:   Thu, 8 Dec 2022 12:56:08 +0000
Message-ID: <702c11db9820a074aee31c2958a565b21299607f.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <32c1968fe34c8cf3cb834e3a9966cd2a201efc5b.1668988357.git.kai.huang@intel.com>
         <6d4d429a-ade2-771d-0e4c-788bef45041a@intel.com>
         <35aee96c1bb56322191ae442f3928d7dff064a92.camel@intel.com>
         <9a653cd2-70df-8c55-ac7d-5ddcb3b18b0c@intel.com>
         <60deb2ffe15e71bc91727aa04298c79f21a58c83.camel@intel.com>
         <e49829fc-e488-3a65-b6fd-f02e964bdb4a@intel.com>
         <02d2a49cbd319814a7afdf57ca3cc9809123952a.camel@intel.com>
         <98935273b05feb55fc52c69a48d31018e0124e58.camel@intel.com>
In-Reply-To: <98935273b05feb55fc52c69a48d31018e0124e58.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4640:EE_
x-ms-office365-filtering-correlation-id: 9abb5224-0292-49a7-91c8-08dad91b9340
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TIKkbpyKGVzPVDBzXa2lVrnFCmzsfYE0lPQtCLzZs6Jl5vm768/8dsTX54tvWLSOHoJzJebHuuLhrE0EGpT1y3uZiSDEQmMhrojGSNkv7n0JhjETyGx0B0pLYV+O9YN1XzZpLesWIB8UiYstPaRPNqOHFc9mKwCxhKaOU86jTGTlK7502Gp+p4E/70z+fN7eti1dSq+hyaJ1yJDAiDLSLgx55VwRxhNJ45C4kXSLsz0K6u1Q9YnEutWp2psIgRjFRjTZh7WhMaiIDVFMu+4wITJn02aZbZzIcRPOXxG7TCD0WLTm3Qht+/iJ54kZb9WSk1dDo1tSRlP20eU0d9kl5w4Vhqn+2VpZKNoOGrXVFvTR3Y505GdrjdO75CU0wpTYDw2DcMoUL0p1fIPitF8FUJuC5BwWDZynaYEu3n/NC8/cnfyY8JJb4qkR6Bil4nIgER1iKjhwadV9+UGMYNyJXA4hti67soSUPCyi2CIdUBR/L7FxB1Ygw7/I9brC8AiY01W+HM8moRUDDZR8lrdxcYYW4+OkSi2kAN5R4DDvRbEH+tbKsN+oLosCaYRY8aVL5I7OufuV3t3LtC0pXJyZdAB9VAdTN1WlzhyPySBBDcAEE7VMYGhL+2gzGx548VRZKms7ceJrz8CQ1eqPrLBE111TcoW29tw8sZ5vW68oDEy30paq+Gwg5sWWb2chdA40auvldFZvj/oD+Iy8MXVQ6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(66556008)(2906002)(36756003)(186003)(86362001)(76116006)(41300700001)(4326008)(71200400001)(64756008)(66446008)(122000001)(8676002)(8936002)(66476007)(2616005)(7416002)(316002)(6486002)(5660300002)(478600001)(54906003)(53546011)(6506007)(82960400001)(110136005)(91956017)(38100700002)(26005)(66946007)(6512007)(38070700005)(4001150100001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVpOVy9aci9TZ0dSWHBjVllOZzZkWFhua25ZVmVKN0U0VWRyb3Q5VHBPUlJz?=
 =?utf-8?B?NkxrTFFuMFRlMC9VeTQ4blVXN0R4YWV2TU52dmQ2SGE5bUk2UG9aQnRLekJh?=
 =?utf-8?B?Mi9xZmtyQktBZ29TTjN3dHFBMFN6MGV3bXA2YXRMbXNRRU92K2lYK09KMmln?=
 =?utf-8?B?dHpxUldseGVpSDYvVW80WWxzamswUEUrcHdZZ1QxTjhJRm1SVE5GeDNKUHRX?=
 =?utf-8?B?a2c2WEpPRWZpRU1ZN0MxTTN6VzdJc1VYcU8wK3Z6QVQ5elRlRXI5bi9qMzd1?=
 =?utf-8?B?MGJCb2pmcWVOSFFWOW1EYTNMeFkrbERTRGFHbHNJQ0RQaXVKS0kyR2w2L3dS?=
 =?utf-8?B?VGkwZ3VTWnFJSk12NTNlS2FwalgzaUpwRGw0SE9FQ0VUTXJ5aUhCVi80SHNL?=
 =?utf-8?B?anVuZ1BrTHJtWEVHWi85aTRsUDNGTzFrQUtCVE1DZ0JuVWpWdjVxbFZKRUNu?=
 =?utf-8?B?dnhtRUQ1cWdCTktNWUpGa3duY2NWRGl4NzloZUplMTcwdkxVczYzMmFrOVdu?=
 =?utf-8?B?cDVsdVk3azRtZmFWeC9rbDF0Z3lweDlZZ1hxL2I2bytrN052R1JXWS8zS1lz?=
 =?utf-8?B?Q0M2Z2llc0JiclY4SGJUTDh5bFZFQlByYWsvOWZYYTdjVk4rQ212MEQ3elhZ?=
 =?utf-8?B?dTdBVERQOUVYLzZwUVcrTnByQnRKMkpwSnlZcVVlakhZN3ZHQTRvWC9lQjFq?=
 =?utf-8?B?SUxXUG9kTTY1ZlFpc1QyS0RMVVJiY0MyWjdPeGxVZXhrb0F6ZktEbTd6c0JW?=
 =?utf-8?B?RU9POEtqcDBxb0JSMDJJS05takwzRW1qNlcxR0dTVENVSmZ5ZU41cFFBVzRZ?=
 =?utf-8?B?K1lGRTZjUkNRcDVUaGFSNHNMRTJtYmpnNk5WNzZkWFRzdmE3WmRBVG1PWmc1?=
 =?utf-8?B?N0xPcEk2eXJHYndoQ0xWdjVEMXh6cDZtWkg2MTF0RHd5bFBUc2lzc2gvbjlm?=
 =?utf-8?B?SHlBcWhTbGtML20xbU9xTTF3aXROVjdXV2EzSkJpUVNvTXZXL3ErcUx1UXVT?=
 =?utf-8?B?SXo1bmRlL1diejJ1R1d5TDM4UDhod1l5cUFNTVBFclNxaERDbHlFSytBZ29O?=
 =?utf-8?B?TjU5ZzFISncwZFZSZ1B3dmtsMzY0bjVnT1lPVFRoRUNweUpSUzl5UFVobVVs?=
 =?utf-8?B?dUc2ZGpJTi85alJJbmF1SlVnaVBRQjh3K25lM29SMlpvcnM3WnpnTTRaSkh6?=
 =?utf-8?B?WDkxNjQ1NWxuckthNUxQNG5kQTd6K1haY3FyeW1FeGovMnJ4VlZtdEl3Rmpi?=
 =?utf-8?B?cmg1clBpbDIrUDk3ejdMUmg0Yit2TGpFRkFuZkdQeGR1ME1nSnhickg3WlY0?=
 =?utf-8?B?ZG5wa0VxM2Z5TDlIbEt1bXFxMDEyTitMMTAwU045LzBTc0wramxkVk4xNDVO?=
 =?utf-8?B?bS9IcVpLK3dYTkdUL1pDY2FqWXlkUU9sZHptdGRwSkNIanp0U3BlMFd3VFVa?=
 =?utf-8?B?cno4TDJ5WlVtS0txdkFWYzFEUlZjRTRsTTdQRHNYUDVqMEFKSDhvVTBmTEt4?=
 =?utf-8?B?akYxNytHcFl5YmVlNHc3OXlsd1RydWhqOEhjUGxxaUZ1bERtZnpidHJvdjhy?=
 =?utf-8?B?dElTbDdUQkFQV2NEZmoxZnlENG9EV01lY0M1d01qMXdzMFdsRUVLSzVDNjRC?=
 =?utf-8?B?N2RDcGxUTnpkWjZzZnB0a3NnN2RCdnNoNUFnOVhJaU1WTGRqU1dMazlINUlr?=
 =?utf-8?B?SlcreXBiNkJtYS9HY29aY0xWTGcyUjhadGx4TEh4WVBiWUZWQzhkK1RSUFVT?=
 =?utf-8?B?RlExaGxnWlA1YlkyNHNVWC9FTFNyYnc3Zy80SWZwa3pqajVYL2h4R1JJYWtV?=
 =?utf-8?B?SzRHT2FtaXl5b01XMHpHS3UxT0lyN0NKZVhXRUcreWw3eU52cUxhK0NjQ2NV?=
 =?utf-8?B?T0FobzBlT3dwSlErd3VHS3k2YWN3ZUZUTVhRZThnNkhZWTJEZmdUS3ZoMmVI?=
 =?utf-8?B?UXJqY3pXaFIvY3lqQ1VBcXNSenRaL3Z0SFFLWWVaU2JVYlV2aHJvSHRLZTl5?=
 =?utf-8?B?R3VWQUpjWjhBV2d6QkJ5K2M4ZHo5L25RYUZjNUcwbXpYNWdObXFzK1RpTlN3?=
 =?utf-8?B?RlBxKzF1NCtuc3MyZGI1Z0ppTXdZaUdGcTdPa3JBR2I0M3U0TDFhbkNNRXpi?=
 =?utf-8?B?Sit4WjFiYko4eVFYeXArbmpSb2pxOXFvUXJiTnlJQWs5Vzg4OFE5WDlRMDAy?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99DE6D91B8159046AF5552CF80613B2D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abb5224-0292-49a7-91c8-08dad91b9340
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 12:56:08.3704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +j2UFDb7MmScKBHsk1rm2gnrjakNQnnj7jqJWNZAssR3ULfAteYltvDHUOfYIHuiGStgfciUjoOAiRjfq+QJJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4640
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTEyLTA3IGF0IDExOjQ3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBNb24sIDIwMjItMTEtMjggYXQgMjI6NTAgKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
T24gTW9uLCAyMDIyLTExLTI4IGF0IDE0OjE5IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
PiA+IE9uIDExLzI4LzIyIDE0OjEzLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gPiBBcG9sb2dp
emUgSSBhbSBub3QgZW50aXJlbHkgc3VyZSB3aGV0aGVyIEkgZnVsbHkgZ290IHlvdXIgcG9pbnQu
ICBEbyB5b3UgbWVhbg0KPiA+ID4gPiBzb21ldGhpbmcgbGlrZSBiZWxvdz8NCj4gPiA+IC4uLg0K
PiA+ID4gDQo+ID4gPiBObywgc29tZXRoaW5nIGxpa2UgdGhpczoNCj4gPiA+IA0KPiA+ID4gc3Rh
dGljIGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gPiA+IHsNCj4gPiA+IAlzdGF0aWMgc3Ry
dWN0IHRkc3lzaW5mb19zdHJ1Y3QgdGR4X3N5c2luZm87IC8qIHRvbyByb3R1bmQgZm9yIHRoZSBz
dGFjayAqLw0KPiA+ID4gICAgICAgICAuLi4NCj4gPiA+ICAgICAgICAgdGR4X2dldF9zeXNpbmZv
KCZ0ZHhfc3lzaW5mbywgLi4uKTsNCj4gPiA+ICAgICAgICAgLi4uDQo+ID4gPiANCj4gPiA+IEJ1
dCwgYWxzbywgc2VyaW91c2x5LCAzayBvbiB0aGUgc3RhY2sgaXMgKmZpbmUqIGlmIHlvdSBjYW4g
c2h1dCB1cCB0aGUNCj4gPiA+IHdhcm5pbmdzLiAgVGhpcyBpc24ndCBnb2luZyB0byBiZSBhIGRl
ZXAgY2FsbCBzdGFjayB0byBiZWdpbiB3aXRoLg0KPiA+ID4gDQo+ID4gDQo+ID4gTGV0IG1lIHRy
eSB0byBmaW5kIG91dCB3aGV0aGVyIGl0IGlzIHBvc3NpYmxlIHRvIHNpbGVudCB0aGUgd2Fybmlu
Zy4gIElmIEkNCj4gPiBjYW5ub3QsIHRoZW4gSSdsbCB1c2UgeW91ciBhYm92ZSB3YXkuICBUaGFu
a3MhDQo+IA0KPiBIaSBEYXZlLA0KPiANCj4gU29ycnkgdG8gZG91YmxlIGFza2luZy4NCj4gDQo+
IEFkZGluZyBiZWxvdyBidWlsZCBmbGFnIHRvIE1ha2VmaWxlIGNhbiBzaWxlbnQgdGhlIHdhcm5p
bmc6DQo+IA0KPiBpbmRleCAzOGQ1MzRmMmMxMTMuLmY4YTQwZDE1ZmRmYyAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L01ha2VmaWxlDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC9NYWtlZmlsZQ0KPiBAQCAtMSwyICsxLDMgQEANCj4gICMgU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPiArQ0ZMQUdTX3RkeC5vICs9IC1XZnJhbWUtbGFyZ2Vy
LXRoYW49NDA5Ng0KPiANCj4gU28gdG8gY29uZmlybSB5b3Ugd2FudCB0byBhZGQgdGhpcyBmbGFn
IHRvIE1ha2VmaWxlIGFuZCBqdXN0IG1ha2UgdGR4X3N5c2luZm8NCj4gYW5kIHRkeF9jbXJfYXJy
YXkgYXMgbG9jYWwgdmFyaWFibGVzPw0KDQpIaSBEYXZlLA0KDQpJIGZvdW5kIGlmIEkgZGVjbGFy
ZSBURFNZU0lORk9fU1RSVUNUIGFuZCBDTVJfQVJSQVkgYXMgbG9jYWwgdmFyaWFibGUgKG9uIHRo
ZQ0Kc3RhY2spLCB0aGUgVERILlNZUy5JTkZPIGZhaWxlZCBpbiBteSB0ZXN0aW5nIGR1ZSB0byAn
aW52YWxpZCBvcGVyYW5kJyBvZiB0aGUNCmFkZHJlc3Mgb2YgVERTWVNJTkZPX1NUUlVDVC4gIElm
IEkgZGVjbGFyZSB0aGVtIGFzIHN0YXRpYywgdGhlIFNFQU1DQUxMIHdvcmtzLg0KDQpJIGhhdmVu
J3QgbG9va2VkIGludG8gdGhlIHJlYXNvbiB5ZXQgYnV0IEkgc3VzcGVjdCB0aGUgYWRkcmVzcyBp
c24ndCBhbGlnbmVkIChJDQp1c2VkIF9fcGEoKSB0byBnZXQgdGhlIHBoeXNpY2FsIGFkZHJlc3Mp
LiAgSSdsbCB0YWtlIGEgbG9vayBhbmQgcmVwb3J0IGJhY2suDQoNCkluIHRoZSBtZWFudGltZSwg
ZG8geW91IGhhdmUgYW55IGNvbW1lbnRzPyAgU2hvdWxkIEkgc3RpbGwgcHVyc3VlIHRvIGtlZXAg
dGhlbQ0KYXMgbG9jYWwgdmFyaWFibGUgb24gdGhlIHN0YWNrPw0KDQpUaGFua3MuDQoNCj4gDQo+
IEFub3RoZXIgcmVhc29uIEkgYW0gZG91YmxlIGFza2luZyBpcywgJ3RkeF9nbG9iYWxfa2V5aWQn
IGluIHRoaXMgc2VyaWVzIGNhbiBhbHNvDQo+IGJlIGEgbG9jYWwgdmFyaWFibGUgaW4gaW5pdF90
ZHhfbW9kdWxlKCkgYnV0IGN1cnJlbnRseSBpdCBpcyBhIHN0YXRpYyAoYXMgS1ZNDQo+IHdpbGwg
bmVlZCBpdCB0b28pLiAgSWYgSSBjaGFuZ2UgdG8gdXNlIGxvY2FsIHZhcmlhYmxlIGluIHRoZSBw
YXRjaA0KPiAieDg2L3ZpcnQvdGR4OiBSZXNlcnZlIFREWCBtb2R1bGUgZ2xvYmFsIEtleUlEIiBs
aWtlIGJlbG93Og0KPiANCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ICsr
KyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAtNTAsOSArNTAsNiBAQCBzdGF0
aWMgREVGSU5FX01VVEVYKHRkeF9tb2R1bGVfbG9jayk7DQo+ICAvKiBBbGwgVERYLXVzYWJsZSBt
ZW1vcnkgcmVnaW9ucyAqLw0KPiAgc3RhdGljIExJU1RfSEVBRCh0ZHhfbWVtbGlzdCk7DQo+ICAN
Cj4gLS8qIFREWCBtb2R1bGUgZ2xvYmFsIEtleUlELiAgVXNlZCBpbiBUREguU1lTLkNPTkZJRyBB
QkkuICovDQo+IC1zdGF0aWMgdTMyIHRkeF9nbG9iYWxfa2V5aWQ7DQo+IC0NCj4gIC8qDQo+ICAg
KiB0ZHhfa2V5aWRfc3RhcnQgYW5kIG5yX3RkeF9rZXlpZHMgaW5kaWNhdGUgdGhhdCBURFggaXMg
dW5pbml0aWFsaXplZC4NCj4gICAqIFRoaXMgaXMgdXNlZCBpbiBURFggaW5pdGlhbGl6YXRpb24g
ZXJyb3IgcGF0aHMgdG8gdGFrZSBpdCBmcm9tDQo+IEBAIC05MjgsNiArOTI1LDcgQEAgc3RhdGlj
IGludCBpbml0X3RkeF9tb2R1bGUodm9pZCkNCj4gICAgICAgICAgICAgICAgIF9fYWxpZ25lZChD
TVJfSU5GT19BUlJBWV9BTElHTk1FTlQpOw0KPiAgICAgICAgIHN0cnVjdCB0ZHN5c2luZm9fc3Ry
dWN0ICpzeXNpbmZvID0gJlBBRERFRF9TVFJVQ1QodGRzeXNpbmZvKTsNCj4gICAgICAgICBzdHJ1
Y3QgdGRtcl9pbmZvX2xpc3QgdGRtcl9saXN0Ow0KPiArICAgICAgIHUzMiBnbG9iYWxfa2V5aWQ7
DQo+ICAgICAgICAgaW50IHJldDsNCj4gIA0KPiAgICAgICAgIHJldCA9IHRkeF9nZXRfc3lzaW5m
byhzeXNpbmZvLCBjbXJfYXJyYXkpOw0KPiBAQCAtOTY0LDcgKzk2Miw3IEBAIHN0YXRpYyBpbnQg
aW5pdF90ZHhfbW9kdWxlKHZvaWQpDQo+ICAgICAgICAgICogUGljayB0aGUgZmlyc3QgVERYIEtl
eUlEIGFzIGdsb2JhbCBLZXlJRCB0byBwcm90ZWN0DQo+ICAgICAgICAgICogVERYIG1vZHVsZSBt
ZXRhZGF0YS4NCj4gICAgICAgICAgKi8NCj4gLSAgICAgICB0ZHhfZ2xvYmFsX2tleWlkID0gdGR4
X2tleWlkX3N0YXJ0Ow0KPiArICAgICAgIGdsb2JhbF9rZXlpZCA9IHRkeF9rZXlpZF9zdGFydDsN
Cj4gDQo+IEkgZ290IGEgd2FybmluZyBmb3IgdGhpcyBwYXJ0aWN1bGFyIHBhdGNoOg0KPiANCj4g
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jOiBJbiBmdW5jdGlvbiDigJhpbml0X3RkeF9tb2R1
bGXigJk6DQo+IGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYzo5Mjg6MTM6IHdhcm5pbmc6IHZh
cmlhYmxlIOKAmGdsb2JhbF9rZXlpZOKAmSBzZXQgYnV0IG5vdA0KPiB1c2VkIFstV3VudXNlZC1i
dXQtc2V0LXZhcmlhYmxlXQ0KPiAgIDkyOCB8ICAgICAgICAgdTMyIGdsb2JhbF9rZXlpZDsNCj4g
ICAgICAgfCAgICAgICAgICAgICBefn5+fn5+fn5+fn4NCj4gDQo+IFRvIGdldCByaWQgb2YgdGhp
cyB3YXJuaW5nLCB3ZSBuZWVkIHRvIG1lcmdlIHRoaXMgcGF0Y2ggdG8gdGhlIGxhdGVyIHBhdGNo
DQo+ICh3aGljaCBjb25maWd1cmVzIHRoZSBURE1ScyBhbmQgZ2xvYmFsIGtleWlkIHRvIHRoZSBU
RFggbW9kdWxlKS4NCj4gDQo+IFNob3VsZCBJIG1ha2UgdGhlIHRkeF9nbG9iYWxfa2V5aWQgYXMg
bG9jYWwgdmFyaWFibGUgdG9vIGFuZCBtZXJnZSBwYXRjaA0KPiAieDg2L3ZpcnQvdGR4OiBSZXNl
cnZlIFREWCBtb2R1bGUgZ2xvYmFsIEtleUlEIiB0byB0aGUgbGF0ZXIgcGF0Y2g/DQoNCkFuZCBm
b3IgdGhpcyBvbmUsIGlmIHdlIG1lcmdlIHRoZSB0d28gcGF0Y2hlcyB0aGVuIGluIGZhY3Qgd2Ug
Y2FuIGp1c3QgcmVtb3ZlDQondGR4X2dsb2JhbF9rZXlpZCcgYnV0IHVzZSAndGR4X3N0YXJ0X2tl
eWlkJyBkaXJlY3RseS4gIEkgaGF2ZSBhbHJlYWR5IGRvbmUgaW4NCnRoaXMgd2F5LiAgQW55IGNv
bW1lbnRzIHBsZWFzZSBsZXQgbWUga25vdy4gIFRoYW5rcyBmb3IgeW91ciB0aW1lLg0KDQo=
