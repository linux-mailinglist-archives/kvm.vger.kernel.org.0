Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33CA6AC345
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCFObb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCFOb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:31:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31687271C;
        Mon,  6 Mar 2023 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678113047; x=1709649047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HAbXORyUFz2bfGYq1jRJF40SuOrwJOBOetSw281OqQs=;
  b=XT7eb3stvbKsoYslXS+DvPjvaGQk9tcyAad4HDTRQpxf1cCGkyyh7mSz
   rzmQLYRyxuhPG3C/O6yu9/stAWH8qnkwXHNC8fRyxFVtU6vFjdyZD96c/
   Uap9YYH6Y59N2ruADwczT6ALgAFi+sT/HN1o20+zvdJv7wGFPekxFURJI
   V8l5w1BrmJoN0BBBAj1N1hV2+Pd2Zl/3xmFzBi+PArRNUqiuzZ6V8Jra5
   m9UppUJ8bo4S7NfVOTfTxso3+AoAo0yJAkl6t/liWvlGS6INFjeQS6fBC
   eCE12pIf+Qx1xzmaRwSS8z6MkJawto+ruose3T7W8g3ZDMTDnJOIwjhVN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="319394442"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="319394442"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:26:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="678493229"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="678493229"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 06 Mar 2023 06:26:36 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 06:26:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 06:26:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 06:26:36 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 06:26:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acR1Ac+FNCJNBLOll7QOTWc2drMWSbi+y+TAZLj4lYX12T+gWRvtWT+LcEdOExXci/+4jK53NnflkKDCI9fmhdfnSrWQj0+RnIFB2530KeXXwpZXItC6SQ0Ysusctpt4L9bY4M/U8B1AeJ++nkdQcRTlrA7FVGlFDbIOCeDx9sdeXeGqwyp7yq7OcDPbcwMDhzh1aMBs0DtfYKKTnK0Ql4/tKpT3b3kQsbkmektEKcaL+5wr6MELMKI2mAdVDtCBmOMkhiMCzGFHC05sCPrOzk8CmGEHJ/N8AMknW4PQTBo9k6tK8T5DZiYOLtfZd9CiPFXNw5mpqF7peevTq4kOnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAbXORyUFz2bfGYq1jRJF40SuOrwJOBOetSw281OqQs=;
 b=Bs0ioTxFWUlLfGe3midUkm3ZUN1gI13qtN4/9uNN0iKp+951e036VmU5pQVjmVvKp8Sw6R82cVptjO9qqn5yi1bm90ZzQBb56qJAs1KyMc8DF3rplVvEZ48rwoF15HgwBLtLMKIfyo0Bzc/2bq8FXBP6GlHI3xhJspeBPE5zvqIGOEgmOUm1gnTzCVyZGUWNtNcpkYkfSGrvW1ZlgmyszC7b7YNlcVwVfGubTEKnTDTJJ7jEnTEzeMJRuyQaj6TD5hHUT2Vss76RNeQoFD74CqP8U7+6TVgc3R8wvpOJDxgga6AUew8SLXuQFKmgdaikmhbHMvkQNjq9egREy8Zp9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6414.namprd11.prod.outlook.com (2603:10b6:930:36::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 14:26:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6156.026; Mon, 6 Mar 2023
 14:26:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NKpCAgAA2qfCAABiqAIAAFhiAgADtdoCAAJGdgIAArgoAgAAIV4CAAD0ugIAAibCAgB1jw4A=
Date:   Mon, 6 Mar 2023 14:26:31 +0000
Message-ID: <1c4c029f82ced6ab6cf6b70748deb7fbecf1a1c2.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
         <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
         <BL1PR11MB59789A024CFA9E9DE715C2F1F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
         <af6034c3-98a3-239b-2c79-ff878f5d9673@intel.com>
         <43fec733ea5331c6de4592dbf44a62e0c61eecb1.camel@intel.com>
         <Y+uWu9hLMZ35JHlY@hirez.programming.kicks-ass.net>
         <0795f69fd0ff8ccdd40cc7a3d6cc32da47e6d929.camel@intel.com>
         <Y+yi4B+P9K2FXNqt@hirez.programming.kicks-ass.net>
         <24bd9d546d07b57387ecd990746061ae35ce5fa5.camel@intel.com>
         <Y+zdMZjApMWJ97GP@hirez.programming.kicks-ass.net>
         <f23b0da7099f0560d5c70e5ed5e0ea190e2c61cf.camel@intel.com>
In-Reply-To: <f23b0da7099f0560d5c70e5ed5e0ea190e2c61cf.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6414:EE_
x-ms-office365-filtering-correlation-id: 7fb4800c-1b48-4cc5-c365-08db1e4ec83b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9uG+ph3LQ/nr3ND+DBsOioCfBoguQ03n88pfT2gk5BlHL6dr1cPvo3FuHvc1UbHKvp26ijBmUELCQcXuiVKX1jumJqG+DH6G6bpE09XFKfm5lBEdnrK5+FmYWBuKBH/Gc35Rgj2ykZMxa2iAKYYpD1pNAk18kS8xcCe6ztsM5FJJNJ9ABWX2h4ll2Na4OcizjXpkhnjVfmRjfwpSWUrraILoVdPOjAKMlU4hpTcKnbRHc/N+Cki09uA1KB7Gf5Rqs6U8xQVQns76egeCwy3xHGlswwFnwAs8LjQ8IMyiRaTp0VMFQkDLQ9MhuMjhyk6PnN9DPrTVUk7/Slon2v4bjl5Rff1rLv1Yb4iA5fgsmQU15WvHHPQvWIu7FtfzJUO+X+t0O+0eDXUz8IlsQvfT2WFTQ2ObMYuJcM88BGMv055N7lwL6R5Z2WuoSHXICGSUvm2ZKzlwDEFRqRZRcTfxabjmCetWGLag6OCX8lis/rOvy+Jd4Y3gFeTEU/jBCQJXNulEgu1x2Dco9LMfRkD+iP8KbTwmMWsdOS0rpjEih/SXarFmZEwEOTOs4STDYADebsgcQnxwaY56ZWA3HcQ0MODu13SVuIh3Xrf98Y0bnhfEBLjaAd+dMlcWM127GmTGQ1DDzQOwNJS110hoGmstxBS4rARbBImsONlEgQPZL1kf6SCJvH66Uy1IoQnArcpFnTX+/3oJNB1zRmAmuAQ/VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199018)(36756003)(4326008)(76116006)(66946007)(66556008)(6916009)(41300700001)(64756008)(8936002)(66446008)(66476007)(8676002)(2906002)(4744005)(5660300002)(7416002)(122000001)(86362001)(82960400001)(38100700002)(38070700005)(71200400001)(6486002)(478600001)(54906003)(316002)(91956017)(83380400001)(6506007)(2616005)(6512007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXgzTnBBbEY4anV2ZS83dk40SDNvb010M1NVdWlKMVh2Q1k4UloxNUo3Rlgx?=
 =?utf-8?B?emN5d0VFMHdSeGx2OFRsVjgxRjJNQ3BzQTQ0UWM3T29tOVFKNjZKZ3NiL2tW?=
 =?utf-8?B?dUtCODlITXd0WmphOTdUMW94bEpEM2dZUWY0NVlNRTdGT0hrREtMTXdVajNZ?=
 =?utf-8?B?OS84L3p2K1diZ2wvdGdHWUw2cG5UbzFBQnhqRWgxRXVtaDlnSWlnRllKalZP?=
 =?utf-8?B?NTltREhvR3ZLU1FyU2dwVXlqUWVPRWJoTHpMcXdYZHRFTnE3WElCMnBpbnY4?=
 =?utf-8?B?MEFPVzF0a05XNjFlU2ZWTkJRTUpKdlN2NlNZdjZzcE9DQUluYzk0R05zZTQy?=
 =?utf-8?B?UXBjTzBxSURmYlQrWW1vRWdBcTZFM0pCWWp2TEhPR1M0dm92M1N6blZBWlJL?=
 =?utf-8?B?ejJYcitoeitDSkdidTZzT2ppZTVJanE1NGpoVzk4NGJ2bitjc1JDenhmV1NQ?=
 =?utf-8?B?M2xOTGgzY2FyZlVWcVNNdnEzdC9HU3NQYkVqMGhTL1VvQWwrNUlMMkFYTG1j?=
 =?utf-8?B?OXhRczlESHJzc0MyUldhRGVZVnNMSGU3RG5pQWx6NUo2dnVTcGdpMUMyTDh6?=
 =?utf-8?B?MVQwQm1ES09KR0kzUjhKbEdoQ3VzcTF0bFJnTmdkWEVwUGV4Z3pQYXRMdzlF?=
 =?utf-8?B?VGN6RmVXWWF6a0E1NFQ4LzM5WkUrbkhNdzdVdHVKRFBieUlsWHlNeWRkYkNJ?=
 =?utf-8?B?MFZENkxQcVFXNG1UbzAwUTVlWDkzUzFPY2h6M3JmOWViOTdOUUV0TGtMQStr?=
 =?utf-8?B?MWIydkpzZWtnOUFkWDdWK3JaNmx3eXQxRzhGTEZHWjZVQ1lXOVJmcE5UWW1N?=
 =?utf-8?B?U3g1TVMrV1F1aWdxaVFseTBpWnl3WEQ4bStGSmx3b1o2ayt2alNpdGtFd25p?=
 =?utf-8?B?RDd6SzFsZFh4c1VXUWRyMDdHd1RPVkZtbm01dDFaUUtFZ1NVOUtvRTVQc2Fx?=
 =?utf-8?B?dE5GWVpYcGtmdXp1ZEVNZEN6MW0wa1BHNllDUWVJcFR0WTlDL1B2TzA3OUs1?=
 =?utf-8?B?b1BnMjdma3Q2aVVMa09UV21JdDBPY2kxaG1tQ3l5YXIzNDBZK0ZoRVJpVFNm?=
 =?utf-8?B?cFdkdXFROEtkY1FxZFNVUlprVHA4N2tKWi9BakJJdkhaTlBVbkNlUmN6TFJm?=
 =?utf-8?B?TWJFWHJ4VDV5WE5TcXZOSTgrbUREODk0S3h6L3RmK3psZXE4UkgwTmpZN3Bz?=
 =?utf-8?B?VkZjdUp1YWdJOVlkbHU4MmVzVjg4VzBiaHNYRktyMHZRaHpJalBhK1ZTL3hm?=
 =?utf-8?B?TzNTYkpIY1BKcDBHVGxoUE1VTnZTa21xUHYwVUtDTVRUN1FHRkJKWFpGaFha?=
 =?utf-8?B?akxNOFpGS3lBUzRWZkNzalFyZzlQYWsyaXREZHdGZ09FRmxjZC85TW12SHkv?=
 =?utf-8?B?NmhpTnRCODRheXNzQlhxaERaNS9oUzF4K1hwSHM3UXhkYi8vZGNSa254N3V6?=
 =?utf-8?B?K1prM2RURk5INFVsRzhLUmdVYVhlNVkvVHJaU0ZpU05lN05NSU1xZjIxYmph?=
 =?utf-8?B?MzdRcm0vN2ZnMnI4RkhWZm1wVkFmVlFmNEhKWG0yd2N5WW1qUHpYd3BOVHB2?=
 =?utf-8?B?eWRmbTJIdkxrVm1YdzhteGp6MmpZdi9rdmMxWC9XR3dCTkp6OEFXdFM5UXBP?=
 =?utf-8?B?MkxnMVZNSW5qNnVqZ1JHMnBiV2RiV1U4VHVieGFVSXRuZ3F5TEM2RTJ4K2w3?=
 =?utf-8?B?c08vR0hEc3J4M0VuV3h1a2tiUkdVUjdJYURKbUNCNE1kWGN2cFBDNUgydXky?=
 =?utf-8?B?WTNUR3RObHY0UDB1cm5WNUd4V1RqRldlZy9jS2RqNGdWNlJkOThqM1g2Y0Yw?=
 =?utf-8?B?TlNDeUNKa3JSWFpnSFdvMUxGT2lKT2cxc2o3Rm1PSlJXVzlLei9HNzRVZmo3?=
 =?utf-8?B?dGV2SEtURnRMTUh6Tis0OGRUZjRUenhyVnpWQVhTM0UvcUZLM2gwRm1lUHNE?=
 =?utf-8?B?eGdXWkhmdHRTTzVDaVpmNW91WGF3SGsxVFhReHBmMlZUV1dEbWNXRkVFd3ZB?=
 =?utf-8?B?TjBITWYzRXdyWHIyeHUxTHh3bVlSdFovTWFNQ2lnNWhHanViNkxBVHZ4WUtE?=
 =?utf-8?B?OFVDZVZhSDFlRjJ2WnhaNWwrZjFEMHNmWC93OUxUTCtVaGs2U3ZKZVZrVVpH?=
 =?utf-8?B?ZzB5MENDMUdwcEd0SS9IQXhVWFRiVkRpa3RXSWRkekRYamF1UHVnVUtlaVV0?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD0544BA797EE8489EF29284BF06DDE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb4800c-1b48-4cc5-c365-08db1e4ec83b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 14:26:31.8543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DSiWnSM1mjBf21yH8pdhd2nAzWWgpF7v7qtbX/ka7q8JFTdB1swfqKEGRy2j85UnzHKA5FuAX+XXcjvWDj9fVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6414
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAyLTE1IGF0IDIxOjM3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjMtMDItMTUgYXQgMTQ6MjUgKzAxMDAsIFBldGVyIFppamxzdHJhIHdyb3RlOg0K
PiA+IE9uIFdlZCwgRmViIDE1LCAyMDIzIGF0IDA5OjQ2OjEwQU0gKzAwMDAsIEh1YW5nLCBLYWkg
d3JvdGU6DQo+ID4gPiBZZXMgYWdyZWVkLiAgWW91ciBjb2RlIGJlbG93IGxvb2tzIGluZGVlZCBi
ZXR0ZXIuICBUaGFua3MhDQo+ID4gPiANCj4gPiA+IFdvdWxkIHlvdSBtaW5kIHNlbmQgbWUgYSBw
YXRjaCBzbyBJIGNhbiBpbmNsdWRlIHRvIHRoaXMgc2VyaWVzLCBvciB3b3VsZCB5b3UNCj4gPiA+
IG1pbmQgZ2V0IGl0IG1lcmdlZCB0byB0aXAveDg2L3RkeCAob3Igb3RoZXIgYnJhbmNoIEkgYW0g
bm90IHN1cmUpIHNvIEkgY2FuDQo+ID4gPiByZWJhc2U/DQo+ID4gDQo+ID4gSnVzdCB0YWtlIHRo
ZSBwYXRjaCwgYWRkIHlvdXIgY29tbWVudHMgYW5kIHRlc3QgaXQuLiBlbmpveSEgOi0pDQo+IA0K
PiBUaGFuayB5b3UhIEknbGwgYXQgbGVhc3QgYWRkIHlvdXIgU3VnZ2VzdGVkLWJ5IDopDQoNCkhp
IFBldGVyLA0KDQpBZnRlciBkaXNjdXNzaW5nIHdpdGggS2lyaWxsLCBJIGNoYW5nZWQgdGhlIHdh
eSBvZiBob3cgdG8gaGFuZGxlIHRoZSBwZXItY3B1DQppbml0aWFsaXphdGlvbiwgYW5kIGluIHRo
ZSBuZXcgdmVyc2lvbiAodjEwLCBqdXN0IHNlbnQpIEkgZG9uJ3QgbmVlZCB0aGUNCnNjaGVkdWxl
X29uX2VhY2hfY3B1X2NvbmRfbG9ja2VkKCkgYW55bW9yZSwgYmVjYXVzZSBJIGVzc2VudGlhbGx5
IG1vdmVkIHN1Y2gNCmhhbmRsaW5nIG91dCBvZiBURFggaG9zdCBzZXJpZXMgdG8gS1ZNLiAgSSds
bCB1c2UgeW91ciBwYXRjaCBpZiB0aGUgcmV2aWV3IGZvdW5kDQp3ZSBzdGlsbCBuZWVkIHRvIGhh
bmRsZSBpdC4gIFRoYW5rcyEgIA0K
