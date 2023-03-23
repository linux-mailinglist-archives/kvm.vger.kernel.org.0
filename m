Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1820B6C733C
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjCWWm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWWmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:42:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD282A994;
        Thu, 23 Mar 2023 15:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679611341; x=1711147341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PcWyzaRC2+5Yck40d0/nVfRziU3shTiYNV/0FGSFjrQ=;
  b=JRbFwoc6EXrKLwUogA/gd0jQ8CB/1aAb8HHmhzeMSuSJ2+0hgkxaefnL
   9L5xHn1LgQb2Lf/4ZKJJn/t5/uOEpTqRyEfyBd5VhgMD98xKTWZuQcE0e
   n4JktQHr1kLk2tkJFQhAi+rLcRZu/yezxzg96rprVSXqaZ98LCGhS8GZZ
   l1M8+hQaZxH12UsUifBrDq48wVRWe4SxxP5glFm3PyGhRhbQd+LroE4M8
   oMAM4tlCi5ELbefL+s0x3D17kN+APBbhpCQi9+QG9wV/iNs7aYSlPWk05
   TZURD7wjkjQwIZGuy6Spd+RHhecjPG0688s66ariDoWt0AWkhjpiu6N7g
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="402223340"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="402223340"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:42:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="682458840"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="682458840"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 23 Mar 2023 15:42:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:42:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:42:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 15:42:19 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 15:42:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPmvZ7ny9T8osiZ4yJ30mjAXZsw2PgblrhWrNMBORSQvvGW0Si4z1SlfQlQKSSgQQqymxm8rW5ouqJ2fA7hsKX8D9/UTkHTGebTOf/IRYcaQZV6T+d3CY9FMkHZB5fvjVYAEjYh6NTOVHGnWnEaH6+p3xBXaulO17VL1Owmkcv4FiphrKhQq5u+aJ9WyaqRaAvC9ryYOe4ItngVFYhyhLdyh9HrDrKcUz5M6AaIbLnghQcFQka782RqHU3WSKcHxFz6odaxJV1YmWs5IpCB1YxmkiwQSFJVNCgqd8Yx+yfJRvzI5KsKiRuDldc8w9oeR8aSvPlibdPADjBhVoKQRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcWyzaRC2+5Yck40d0/nVfRziU3shTiYNV/0FGSFjrQ=;
 b=Y38yggJ4TGIaNyxd11XKuaKsHe2VxABt1FZZRZdOxlkHZaWFBEiy6mpY/qkRC8VcSm/4uVF4iJpHACQIxFsC1wfs0fmYbdTLCfXyHVOxXV0v6Bx4SvBrAaImBFdEpdxL3pPqS2R4u5Fi0yq2BZBy0HO9d2wl0ooCw2xGjD13Jop2YsKuzyQK2++SCY3R4fDWlsQ5coFHc1782RsicWnw08+1Hbk6aFHotAlg2aJEjz0h6ewZxfelYqbYqEZouGQyMRZHHo+/IgG6Lq9rFkQyw8LctCXodOMbcS/0GngwHWew2thpZo17wiV72NaV4xZTS1VERWJozDjwBNHEkKAaEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 22:42:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 22:42:14 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQCAAZ2qAIAAIeiAgADqJACAAUSFAIAMvysAgACLv4CAAAC8AIAACFuA
Date:   Thu, 23 Mar 2023 22:42:14 +0000
Message-ID: <d2c3162f838001f8fa6516dbb7f623a43a3656a3.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
         <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
         <20230313234916.GC3922605@ls.amr.corp.intel.com>
         <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
         <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
         <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
         <141def31-dcbb-70ae-2935-4fb06a986036@intel.com>
         <6be93d78e01906ff5c3714005170d761e5b40d41.camel@intel.com>
         <1e1bec34-36bd-a719-7d3b-23ab268f7092@intel.com>
In-Reply-To: <1e1bec34-36bd-a719-7d3b-23ab268f7092@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM6PR11MB4657:EE_
x-ms-office365-filtering-correlation-id: 356a64fc-d1e3-42d8-ce41-08db2befd923
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIHxbjWQfmvoWPZGwjYqIZOikFFQf7A/ZSYVoW8dapkMWKdhAHNanjLiwbPkLHfbphAsd3YmZ6m/QsUk9FDQ3XjlhQs9tNYOJe3nX89SnQbOEk/eEi2glrKmbVh2RzQJlASurdYklhJABSdfOoiQbaDzusXdpPNjLCXnqFzeWUdbIQN52e3JUWIknWruLTm6W/2e3EpOFAoM5JieE3BJoO+d+ha7xw87titBKNPekkjBZowpUri5vT0fKQ4s0KRMCoy5p6kEhPTm6V8qPSNiE1vzMz20Yd6EtMVjHvFQQ8EZu4vgyurewumdj2f2rW/gssc7fRjNNig0dlgHZ04zMIDL6QMufpR0XTnfEdcejCsREHIkL4xs+aaQ5DX7NFC1VTSRzp+nr99dy1hJUWlV+KhUhW+Oyg2jzUiRQ2Cv0+by7h88wCCcrIuUwb7SCwSKDNrhp2jNYHwvb6sENEQ9zVJqy6g+sqxmQloTMmeP4242oZchmS+YvB5ERqz+Dv6EZnJ4SwFZ4ia4xtnI5rnVhlv3v0ijpWAdZhMEwqo+KLYDcdx85qFtYHOQVWQz7avuLMuSPpdzAl+SvRNu3Fer0+N0linJeeR0gXnNFibju9cypbNktzVDJueYH/EaYGjvegrakENaF9lXjJJInoXOgYGqUQ+L8DGDQLzle9SGrOf2NKLkDDZ7Ond4z9fEHqE5lDb7pqEQtsaaWj0FdobAew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(82960400001)(36756003)(8676002)(38070700005)(86362001)(122000001)(38100700002)(66446008)(7416002)(41300700001)(66556008)(5660300002)(2906002)(64756008)(4326008)(66476007)(71200400001)(8936002)(2616005)(186003)(53546011)(54906003)(66946007)(6506007)(6512007)(110136005)(478600001)(76116006)(316002)(91956017)(6486002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGJyUDlzWFpuaUJpVzJ3Z0gydUhwSTYrcURZdGpVMDg5cWV4ZmQ1SzdrMkY2?=
 =?utf-8?B?SEIvSVpjaFFhTHlBYnBVRDBoZFpVaW1ibkQ2dWRuT3VmYVBwYmpXdHVjM29L?=
 =?utf-8?B?bHgxK0d1TXgzMXkrM216ZmJ3WlZXYmljd2JuakR6cDNJYkU0dSthVnJOOFZI?=
 =?utf-8?B?QS9KVjY1dXoyWUlGQ3dBdWgxa2NuVmpkL0NNeHRYNk4rNmErTWgvamtManBG?=
 =?utf-8?B?bExGUWNZUllxY3Z4ZkdQdWQ4ZXRzZVpKSzZMd2xOK3EybGNVbjRUaFdaSFM4?=
 =?utf-8?B?UFJDZ081SmZqQ2xvSDE3RkJ2UFEyQUJYYVNGUmNFakNscnhEVDAvSGdZMUVW?=
 =?utf-8?B?bU9wSlJXSitUM0syNmh6cXI0ODhWdmQ0R0Uvd283dTZYQTE0RmtFclprSDdT?=
 =?utf-8?B?MSsyYnZZMW0yMmxzbmt5S0ZLdk9aME55YWczd3lhNkFJckI5Z3NjZ0dWb0Fk?=
 =?utf-8?B?UHlHc1hJZXFtaVRHRWhEcWtKSUZyUUZUOE5FMllkOXdkS25wR1F5RGdnaTVk?=
 =?utf-8?B?ZTREYmhlNzIvRHA0dEZ1blEvaU9nZUUyemx1UnJVMThVL01yanE0RGRpMmpl?=
 =?utf-8?B?U05JQ1VyVUJwNTNncWRPOGl1YzVUanBiVG5UVGQzeW01cjQyY2lWeHFub056?=
 =?utf-8?B?R3VFR2IrNS9EeUg1NVI3cG9rdVJFQVR2VEtkdVVpcnF1Uys0K1J2am5MZTlO?=
 =?utf-8?B?bXlVUmRzV2ZpYmhsVDZwT3lZQzRWVjNPVm1URVl0WXQ5UnlPQ2h4SVBmWUZI?=
 =?utf-8?B?NGI1bm10ZGdpbU1QWkozK0tkTWlNMm4vZUF4MHdUZUpFcmliRUEwV2ZMQkZs?=
 =?utf-8?B?YndHTEVQNEY1K084eWJqVzNnSVFrcFhDdEdCM2xiTnJaUStxZGtXZGtPdGVO?=
 =?utf-8?B?QU1za2o0ZkM0enRkZGVkK2tFV3RqckRpTXE0VjF2Yzd1TWQ2YkwyRnp0cklr?=
 =?utf-8?B?aHBVZ0FNb0dzZG1SZGJWbjNsZ0srSEUrdmFEbDl2SFNwbDc3QSs4bUt6SUxH?=
 =?utf-8?B?L0lKMmxjUmdaNlBNK1FoYnMreW53dDFGSTJicWlCM0ZQYW5RSXU2VklaeVZW?=
 =?utf-8?B?VmxQeG1TQXBFVGtjOU5BUEZIckVuLzhEYXNlbXdlUnlqZTBiczJITFJXZGFJ?=
 =?utf-8?B?bUhiOCtQU0o2RnFBUXBXME5ZQjRnci80N05VV1d3ajhVU0grZjF2RTM3a3hV?=
 =?utf-8?B?UVQzdTFSTWRXVVRsc3R2cDZyeWZJaDJoUW0zK0g1VHNoL1pIZm5pazFaM3g4?=
 =?utf-8?B?UGJnODBuM2RGd1pKVWdJTFFiYzc3K253S3pKNENwL2NOT2hieG5McWJjUXd6?=
 =?utf-8?B?bncrNEl1K0QrZ0JVZGorTW5FL0JRVlE5N20zY0pvdWZSeTFCUzlHK2JjbWtr?=
 =?utf-8?B?N3JuMVRPaXc1NXVod1Q1SnNqQVZIQ3NXdnJMR0Rmd0RUczdia1BPWkVOaVlG?=
 =?utf-8?B?TUtoQVNtcXZLR2ZhcDlpZEtXNTk2ZDdvQTJBSkc4YkxvREdiaENTZENlMXVj?=
 =?utf-8?B?bitXVzlQMFJ2ZGtBNWdDbjF2TTVPdkpUSzRJMHczT1p1WGgyR05mcFk4Vmh0?=
 =?utf-8?B?T2F2c0h0M3BabCtiajhBbFU1MkJDZzV6b21Ra29CVkVMZXhxdlZwb21zUGhi?=
 =?utf-8?B?bElNbEVpVlR6UjNCNE5kKzREQUlGS25TT00zN1djVWdKc29EY3RYTy9jakNF?=
 =?utf-8?B?Y05mSmh3Sjk3dmNPQS9WSXBIRTB6V29CNmNvRDJ4NU9DTzdvSGJ3RnBrZm1l?=
 =?utf-8?B?cWdlY3BIbUhtaDVJYkpRUm56WWpDL0Y1d0NiVEVRRG5aemhNQWxDWHZtRHRy?=
 =?utf-8?B?c1gvU3k1S3RLaGhQQjBWcDdnZE8zUm52R1ZIN1EyMm1nRzBtdjBSZE1aRit4?=
 =?utf-8?B?MGtQQUtqOVRiS0ZkNm9HWUREV0RVemYzSlMwM21ENzd6UGlxemdaMGhyUCs0?=
 =?utf-8?B?Tmhsc082UklPUUtadVVDOHpLZk9GYktGQmxTWDZ2WE96VFZxbEU4T2RrSWRZ?=
 =?utf-8?B?OHhRWkZFYVhBQ252VTV0Vzg5VllyUFVOTzFERDRSM0wrVnc4M3cwZTlqVEhD?=
 =?utf-8?B?Ym84NnloUGJHc1BlTzZBNGNqQ25GSkVtZ2ozYWlDc01aS0IxN3NSSTdTWjg0?=
 =?utf-8?B?WENYanZObVQ2NHBoWER4K1E0TTB4WFkzL2hQVTlsMkhSbWs2aWFOUnJiSEx3?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <870466F3264BFA4D93807800A1485D96@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356a64fc-d1e3-42d8-ce41-08db2befd923
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 22:42:14.3081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QP1+qeOLrIrbWEXX/vIZDTNI1r7bo0824wFPEqdUKNbT6/l5M5qsDUhDFHUuNSx4WBc1iu29ZjyxHVUsYzM3vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTIzIGF0IDE1OjEyIC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDMvMjMvMjMgMTU6MDksIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gMSkgSW4gVERILlNZUy5J
TklULCBhc2sgVERYIG1vZHVsZSB0ZWFtIHRvIHJldHVybiBURFhfUk5EX05PX0VOVFJPUFkgaW5z
dGVhZCBvZg0KPiA+IFREWF9TWVNfQlVTWSB3aGVuIHJ1bm5pbmcgb3V0IG9mIGVudHJvcHkuDQo+
ID4gDQo+ID4gMikgSW4gVERILlNZUy5LRVkuQ09ORklHLCBhc2sgVERYIG1vZHVsZSB0byByZXR1
cm4gVERYX1JORF9OT19FTlRST1BZIGluc3RlYWQgb2YNCj4gPiBURFhfS0VZX0dFTkVSQVRJT05f
RkFJTEVEIHdoZW4gcnVubmluZyBvdXQgb2YgZW50cm9weS4gIFdoZXRoZXINCj4gPiBURFhfS0VZ
X0dFTkVSQVRJT05fRkFJTEVEIHNob3VsZCBiZSBzdGlsbCBrZXB0IGlzICB1cCB0byBURFggbW9k
dWxlIHRlYW0NCj4gPiAoYmVjYXVzZSBpdCBsb29rcyBydW5uaW5nIGNvbmN1cnJlbnQgUENPTkZJ
R3MgaXMgYWxzbyByZWxhdGVkKS4NCj4gPiANCj4gPiAzKSBBc2sgVERYIG1vZHVsZSB0byBhbHdh
eXMgcmV0dXJuIFREWF9STkRfTk9fRU5UUk9QWSBpbiBfQUxMXyBTRUFNQ0FMTHMgYW5kDQo+ID4g
a2VlcCB0aGlzIGJlaGF2aW91ciBmb3IgZnV0dXJlIFREWCBtb2R1bGVzIHRvby4NCj4gDQo+IFll
cywgdGhhdCdzIGFsbCBmaW5lLg0KPiANCj4gPiA0KSBJbiB0aGUgY29tbW9uIHNlYW1jYWxsKCks
IHJldHJ5IG9uIFREWF9STkRfTk9fRU5UUk9QWS4NCj4gPiANCj4gPiBJbiB0ZXJtcyBvZiBob3cg
bWFueSB0aW1lcyB0byByZXRyeSwgSSB3aWxsIHVzZSBhIGZpeGVkIHZhbHVlIGZvciBub3csIHNp
bWlsYXINCj4gPiB0byB0aGUga2VybmVsIGNvZGUgYmVsb3c6DQo+ID4gDQo+ID4gI2RlZmluZSBS
RFJBTkRfUkVUUllfTE9PUFMgICAgICAxMA0KPiANCj4gSGVjaywgeW91IGNvdWxkIGV2ZW4ganVz
dCB1c2UgUkRSQU5EX1JFVFJZX0xPT1BTIGRpcmVjdGx5LiAgSXQncw0KPiBoYXJkKGVyKSB0byBi
aWtlc2hlZCB5b3VyIGNob2ljZSBvZiBhIHJhbmRvbSBudW1iZXIgdGhhdCB5b3UgZGlkbid0IGV2
ZW4NCj4gcGljay4NCg0KWWVzIEknbGwganVzdCBpbmNsdWRlIHRoZSBoZWFkZXIgYW5kIHVzZSBp
dC4gIFRoYW5rcy4NCg==
