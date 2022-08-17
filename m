Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB06597A56
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 01:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiHQXn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 19:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiHQXnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 19:43:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C76E33A17;
        Wed, 17 Aug 2022 16:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660779825; x=1692315825;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=s3WlJ/4hyN4x7fW6tKl+fqQLvAzrGnSJgwtVwMM+A+Q=;
  b=BCSKaL7GVT3Sma3x5zlRfNWP85kB5mw9pRj2C6z2k5RPbS3sNAl0TDif
   5uxlAkj6hKF4rWc1v0Zlu4JG6nPhsv6zprV3fP36aKThTL+LPC3o0fee0
   XlQDHkZHERwG0QpoRGYKpX8Og4UXJDrc5K7btS8JeOZ7Fo0zc3jnZOZxv
   LGGt4lc3JUJUlsi8pP6mgrtW6Bld+vqoiFcxShVv1D77m4OT68XvxJZ/U
   A54cHqnU4eo/JYexHuqSOhFgmjWa7Vc6dpHMu/1xMJr85iUICJS1br4x7
   Ijo5EkWmliVoRY3svxs8V/dW6Tm92tbZGzqt2ax1DMBE5ARf4LH2vdfFQ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="292624537"
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="292624537"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 16:43:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="583968489"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 17 Aug 2022 16:43:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 16:43:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 16:43:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 17 Aug 2022 16:43:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 17 Aug 2022 16:43:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neyfFtKif6sc7kIb46aavD0AS6uB0wtwH9M0dyFc7f4SovlEcMAuvjpj7jIFKDKFp3eUJ7dZCS7lhcM3e7rXLEUxkP2zETeIRrzARYHLwRA6friNsEbjDQbIiclyqZPc/oTYQnyQ8YsS3DqX+180lt2lJRVV0iBZ9NM48To8IFSpRzh4c6jOk9ihYDTsENLx9KEQu/rJcS3rhx713HGpH5hweH1oCnx1BcS2tAri61b9NYwJ3mLeSi5K/Q+5B2yAodwAX4LyogpHWWtXCrqgriK52u31m0ajl68WTt4UG0PlOYy/kqA8RvXyK2aKI/3BJCaYNmhqimGI+XwcTdRIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3WlJ/4hyN4x7fW6tKl+fqQLvAzrGnSJgwtVwMM+A+Q=;
 b=NPb/vhzIsw76+IYHcPCl3YksFRH4edds0ALlOJZBKRvRnthSrPrvC5J1h+toruQddGvhC2aTDdxp0ENuSbrL2CN3NRi6rlHVw+d60haY6tcAa3vMQrPdLCki4W/w+0qrFovieNQUabuiM8tq4xTs1b1DZi/V1KMyOV2ithqnvNwaPPYDAEQr339VWBqo7cCU/lhe6/PskTVqgtEfhNkoIHYxPEd7BoNPC+lG3wIAtHtKHv959YcpEZBR7imA0cI7OtN6S3GeeNaBFeHvCSIVBv1FyNbFtWZW6zuifikmklqtIBTlHbkO96jVjMixKEhmc/byBMHTdSVYeYXoXi6RgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH2PR11MB4359.namprd11.prod.outlook.com (2603:10b6:610:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.22; Wed, 17 Aug
 2022 23:43:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 23:43:20 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Shahar, Sagi" <sagis@google.com>
CC:     "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Topic: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Thread-Index: AQHYhihInpjjKWtE90K1bVdlj4yc9a20CiIAgAAPz4A=
Date:   Wed, 17 Aug 2022 23:43:19 +0000
Message-ID: <1a33401208b27c8a0fcd45c061e49c66a14ea6f5.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
         <CAAhR5DEsB_88RukdkdbWxQz6=58b+AgQhGc9GRgvhMV3jq5TFg@mail.gmail.com>
In-Reply-To: <CAAhR5DEsB_88RukdkdbWxQz6=58b+AgQhGc9GRgvhMV3jq5TFg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5783f545-a18f-4424-b946-08da80aa43f8
x-ms-traffictypediagnostic: CH2PR11MB4359:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7TNdvaR+Ojse4GkGT/6OSy11PdY8WW4UZIE0pKEgp6gD81+6ClNB4HHWDkJJw6aYelTEjh6PH1gxBWaiwFHOektgz24qphdRmgt4b6r9cf+obCyoM5Q8B9YEHc1+FGPEQCl8y5U73j6p04G8Oh8U23JHvJkv0i4epENZdzDYqdmJFVxfNHLceMyuguWdkxxCalaL/9BlAHkDgWTaST8sN+m3Zkd/Wd/dPBxRWPECar0cPFhPSqKMJed9i1K7XGWJIAoTmvtxroiC6XzU9TI/MrB1JoTABBcTAEKpW3f49zDn0WGJ4Fq8pvwMN+/UwAiM1yDbpOgnmTPFdTqhgucGdREPOgj4efPleA6wlQx61ASeJrUd/Kz4BZSv77NG95yRA6JXqLm/FRTzQiAFawZ26o1r8Gu2J6C+HDV3Q+mn3hALmA/yDx/VgS2LgtxJgsybtbZT6eJl3TC7VcnCGLXFisAEysBrQ9aYWJKv4U0bH1iiaX1bZIwEU5vVCxVu0BXX8wWmndPcdRga/0/OVqnx4ivFWzHWhdzcQJXrfntHDbnVITS5l6k389qENX4JrILoZ1aAkcNzcIUjgxBVENuRzcc7Lft6+Ax/W5T5lzDOsZhe3dObNupHi9lVYYENViJiaJwSWOpUIcpbclK/R+2Yx/xSVP1/7fi1qeYst2LQNwO1lKtQE1ZYSy2hmQbh0JmAhFFORnIhx7pCnYNWTP2RUB2xW4fn8DxQOTH8id8poUCsnflrSgAuUQZBRvyFcKmlha8gPLLBKArfbT7jufEcWLWqXjK81MoRU+PAnkMYL0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(376002)(346002)(39860400002)(186003)(316002)(71200400001)(6506007)(6486002)(86362001)(41300700001)(478600001)(54906003)(6916009)(2616005)(26005)(6512007)(8936002)(5660300002)(36756003)(2906002)(38070700005)(91956017)(122000001)(66946007)(76116006)(4326008)(66476007)(64756008)(66556008)(8676002)(66446008)(82960400001)(38100700002)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEFHeGw5SDdVVmg3dEVSOVNncy9mVmZKVVhxUFd4K3U2Qit3N3p5cHFMcmdD?=
 =?utf-8?B?Z1R0SUV0WFhvZGVwakRycVB2MUtMbUtqOVpMSFZBSkZjSGVBTGhZd2pLaTNT?=
 =?utf-8?B?MzdYeHlLRHMzMzZXU3EvTG4wVnRoSkVKSmVTRXlzSjBGR0JjN3M5NWdRN29t?=
 =?utf-8?B?VG9IV3dtaDZQbkI2MitZY1ZHWmRPZTlxN1dxdDJnaXlnNzRRYkMvUG9QQVI5?=
 =?utf-8?B?ek5xMjQ2K2w4czBWbjdva3ViYW1Kd1ZNKzRiM1ZPYzNtZUhETEVBU3JYQU1k?=
 =?utf-8?B?UzZxWkhGcHZQdlBxZ0F4U3ZCTUFoOXlZNng3WkRyVVhEWjAxMmIrWFVQYnZY?=
 =?utf-8?B?UmUrcHpmR00rdXZhMm5BRFNpTDJjSzRGSUhudlUxNU9WeU1VZ0hTd3p2U0NO?=
 =?utf-8?B?LzVCOFJaQWxaaGdoQWdQT3JITVFnSncwYzFTVGUrT292Ymdpdi9wczJTM1A2?=
 =?utf-8?B?SHZsN2IxMGRwMG5BZW40T0xUU2s3RHpvdGNXRFBYOEJwN21XdmZRVkZzTTY3?=
 =?utf-8?B?WnhPZGRaSHNYNDZMZ21oTjZTdHFIUXlINGFaQ0FyZmc1S2NHU0JXcms3eG13?=
 =?utf-8?B?WGYwT09ScUVFUTdKdlFyS3RKN3lNdnY5Um0zUk5YYzdKalBWcmFmY0t2NUJL?=
 =?utf-8?B?SzZHR2ZOQ1c5OXlUN0VEM3JuT3poSmdXdElkUXFENWZOMUxFZlpSS1pSNHZY?=
 =?utf-8?B?RDJZZkJvekVLTTBvbmxRd1FiVWxLa0dkN2IwRC9iNXh6YXBjd1ZQeE8xZGVD?=
 =?utf-8?B?RlQ1bXluVm5RbWpoM05iamNsSmw4Sjgva1Z2NWFkVnl0djRmWElqSUFKcVA2?=
 =?utf-8?B?S2lUbzdWRHpNSUVsN1pnTTIwaWx3S1BQR2FvTTBhNHRra3BUbTRXOXlHWENm?=
 =?utf-8?B?TmY1eGFUTFp0NTF4Z0xiUmsyZTlhUEdrTEZhRm9kZHVNSG1EZnpDUTBtSEV2?=
 =?utf-8?B?OUZrbFNQVTlQNXVzU1h1REVQY2dCYkdGSWdlNUNQMTJhbmVCK1VNTDVVMzJY?=
 =?utf-8?B?QWFkTmY1d01OcnVBUTdFQzVSYXl0QmlSZ0l6bkEwN1Q4cXZBY1dWbmgwUkc0?=
 =?utf-8?B?SzdlMFVJL290ZmtUVmdBaXNKUGZiM0lKUWg4VDJoZ2QxdjFBV3E2eEE4Szhz?=
 =?utf-8?B?dTAzTGdVWFZpY1JiM2dpcm5yWnVYb21QU0s3SXJRZExJSW92TkF1Vm1QMzUw?=
 =?utf-8?B?am9mK09aUWFjMG82YjQvUndXQnFwTGdRbnAwU1QxRDliVndNMWR1REFTK1Zo?=
 =?utf-8?B?TWtIdnpzUktSa2xWdmZzb0xMTndldGhJaXNxUHJod1hpc084TGwrRVc3cTZD?=
 =?utf-8?B?bWZNelBLSk1NVUtDd3k4WDl6U0tUK0pZeGd1VkN3RWFsZXM4Y25ySkV5U3hT?=
 =?utf-8?B?QldnUHVvdmJiL0FhejRTaU1icHpJYk9YbUJtK0cyWUUwckNwakRnM2Y0dDRh?=
 =?utf-8?B?eWxVQWRGNFIvVGN0NURidmttM3FadnZaYVpsbEZrN1QvaDk4U3dZc2tYR2ZD?=
 =?utf-8?B?RHlrV01BRVBKU2pPbnZWdmRDR1FLU3NiK05meUJRcExHdGJkdkZndjhLYTMw?=
 =?utf-8?B?QkFSdXJjOURLUW5CREVqQ1ZPN0ZXd3gyN2JwZlNMb3ZzU1Fkem05NlY3cVJy?=
 =?utf-8?B?R0pUU2t1ZHV0cXNkemEyakExdFNKV2NoOEVyckpybStmUGpzQW9ESnFob0Nk?=
 =?utf-8?B?RDl5cHN4WEdqYTAwRXdxbHFZakVhQityandoT2hhZXJjR0dtM3JWN1NYdHNU?=
 =?utf-8?B?bkgzWjlEZldIeGU5R1dyakFKK3dhS2EwN2ZnSU5mZjJERm00bVJLOG1NZmNT?=
 =?utf-8?B?NkFLY0hxazRqdTdwTXp0TmVxTGduUUN4bm9KN3U0OE4xMjFWRXRtdFdKSlhW?=
 =?utf-8?B?Lzh2VnU2YWNQaEJEckd4Y1ljVDVZQ2c2Q3VqY0NZYWJ3dTlTQ2dnaVNjTEQ2?=
 =?utf-8?B?SDNvZVFCSzhqWE5EQ2NWVW8zZHJoUkFIdXRNZnZoc2FuZUdpaFhrTTJzL2xt?=
 =?utf-8?B?cWtiR05MYW5FaTAyTENTclc5RHg4UnA4MjE0S0t5MkczUTJLWE5xckV2bUFV?=
 =?utf-8?B?YmpXVmVSQjRjT1crRHlsNDFNbHRvZVBpb2ZqMXF4Vi8yUXRneWgxVmZFdXdh?=
 =?utf-8?B?OXI2dnB3TElFM1MvcnAwRk0yNU5lbUxaT015M3BZSTB1OVYySkszbFpWaG1v?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF92FB77DDC70440ACAEAB5103570A3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5783f545-a18f-4424-b946-08da80aa43f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 23:43:19.9359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NQl3PWn8zDjvQDWGcLM9B2+HpfMVEq7FtLOO0wpq//rGqY0GLsK+7LEsdg77lGovcadprSs+mAp6nngSEgTZlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4359
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTE3IGF0IDE1OjQ2IC0wNzAwLCBTYWdpIFNoYWhhciB3cm90ZToKPiA+
ICsvKgo+ID4gKyAqIENhbGN1bGF0ZSBQQU1UIHNpemUgZ2l2ZW4gYSBURE1SIGFuZCBhIHBhZ2Ug
c2l6ZS7CoCBUaGUgcmV0dXJuZWQKPiA+ICsgKiBQQU1UIHNpemUgaXMgYWx3YXlzIGFsaWduZWQg
dXAgdG8gNEsgcGFnZSBib3VuZGFyeS4KPiA+ICsgKi8KPiA+ICtzdGF0aWMgdW5zaWduZWQgbG9u
ZyB0ZG1yX2dldF9wYW10X3N6KHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIsCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGVudW0gdGR4X3BhZ2Vfc3ogcGdzeikKPiA+ICt7Cj4gPiArwqDCoMKgwqDCoMKgIHVu
c2lnbmVkIGxvbmcgcGFtdF9zejsKPiA+ICvCoMKgwqDCoMKgwqAgaW50IHBhbXRfZW50cnlfbnI7
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBeCj4gVGhpcyBzaG91bGQgYmUgYW4gJ3Vuc2lnbmVk
IGxvbmcnLiBPdGhlcndpc2UgeW91IGdldCBhbiBpbnRlZ2VyCj4gb3ZlcmZsb3cgZm9yIGxhcmdl
IG1lbW9yeSBtYWNoaW5lcy4KCkFncmVlZC4gIFRoYW5rcy4KCj4gCj4gPiArCj4gPiArwqDCoMKg
wqDCoMKgIHN3aXRjaCAocGdzeikgewo+ID4gK8KgwqDCoMKgwqDCoCBjYXNlIFREWF9QR180SzoK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBhbXRfZW50cnlfbnIgPSB0ZG1yLT5z
aXplID4+IFBBR0VfU0hJRlQ7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVh
azsKPiA+ICvCoMKgwqDCoMKgwqAgY2FzZSBURFhfUEdfMk06Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBwYW10X2VudHJ5X25yID0gdGRtci0+c2l6ZSA+PiBQTURfU0hJRlQ7Cj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ICvCoMKgwqDCoMKgwqAg
Y2FzZSBURFhfUEdfMUc6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYW10X2Vu
dHJ5X25yID0gdGRtci0+c2l6ZSA+PiBQVURfU0hJRlQ7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBicmVhazsKPiA+ICvCoMKgwqDCoMKgwqAgZGVmYXVsdDoKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdBUk5fT05fT05DRSgxKTsKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOwo+ID4gK8KgwqDCoMKgwqDCoCB9Cj4gPiArCj4gPiAr
wqDCoMKgwqDCoMKgIHBhbXRfc3ogPSBwYW10X2VudHJ5X25yICogdGR4X3N5c2luZm8ucGFtdF9l
bnRyeV9zaXplOwo+ID4gK8KgwqDCoMKgwqDCoCAvKiBURFggcmVxdWlyZXMgUEFNVCBzaXplIG11
c3QgYmUgNEsgYWxpZ25lZCAqLwo+ID4gK8KgwqDCoMKgwqDCoCBwYW10X3N6ID0gQUxJR04ocGFt
dF9zeiwgUEFHRV9TSVpFKTsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqAgcmV0dXJuIHBhbXRfc3o7
Cj4gPiArfQo+ID4gKwoK
