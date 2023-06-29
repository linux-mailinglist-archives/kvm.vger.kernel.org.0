Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58E3742367
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 11:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjF2Jp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 05:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjF2JpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 05:45:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824112118;
        Thu, 29 Jun 2023 02:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688031910; x=1719567910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jmdWu4fawQIuDXCIJ/LqQeRhnbWudzBLe98s4ZYvpf4=;
  b=nkkstVFe+cz0ZYZSsDE6S0T/QORxJOfrXv5J6QoGDAuucO1iA85pmfuK
   CWcxejjzGIj+Min5/sv2fDHchV5e47Ut7Pcsf5hO05EmHNDkGsO9Zuqfn
   2cH3TG2mycigvXLdiOhxfEZq8+xnxfIAGqaekLCe9vPdv7kADiHJF5Cq+
   zmPWiN/WzMC73dGwj3cEtwOLkvBPRFXUXcfRkC52nKZ0ZI6rHieQjol0q
   YNMaZ9mf33fV6LSdiKL3N0lGORlWyFstSJM6m0qSEBpxBAX9J6tY5pPIj
   ptvLsciD/5sykFvglpdH6xw+UL7cugFJLXZhOycknTHfa2EqNSrcw2gtL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360916829"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="360916829"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 02:45:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="782625073"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="782625073"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2023 02:45:09 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 02:45:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 02:45:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 29 Jun 2023 02:45:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 29 Jun 2023 02:45:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbD9LnbrBNlFW5rzZ76Jy487h4Y6G0b0Mpxa0ha84N7IVMq9BNG/pAdvhMcXhp6e/G9FyL3NSdKkwgkUvyZ0HCb8NtUqwP2fB02IT5Y+cTJ6tZJJUAAuIMHKSRVPkxTTGYgGb8KuNKMYNt29xn61U8QQsNFpmLOEPLI+nCEr7hsIJNO4x5vMdSh6TZdjVRl7VX2BI6mlzz5EIYHKKwbLP555S49lSowsS6Pkl0jxv4y6LWrgmZJbjif8xk8B4fReaTZR4EkFVY4otIq9h86TxR1aK6ym10xJH/QDBNqTbeQgAwbN9sghsdIyO2/PQc4LCrOB3ujwC+mDKKjAxtpxRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmdWu4fawQIuDXCIJ/LqQeRhnbWudzBLe98s4ZYvpf4=;
 b=QzykBwvY0060rNjlQdleZyAz4+uSRIjGtLPimlt/QWh0jTcmcuQzeePO2gkTBjhdf8xtXr3BI3RIgzct/v/yi2kOEpGjgeoPUoG6tOd7zeIbIqMtjoqhDP2UFYXDhcY0mlmAEYjS+UPQUi6NtJHG9tJ2ZqK7cmNjqVHev0hEY+nD3MwlWJZyrTq+H9vzYKQphMO/ZariuMNEKSLXQfMNsn0ncSyYuSuvlozT+CmKWQ26s2EPpQbi0QJEt68tkSQNO6J/dp00AxMsaa8/tnjon50SSi2lYJuZ21zI48yZhCdBCHceg59bRl0FrH4EqK27mI/JZ+FVJyxfnk9cWkxnjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6750.namprd11.prod.outlook.com (2603:10b6:806:266::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 29 Jun
 2023 09:45:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 09:45:05 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Huang, Ying" <ying.huang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bp@alien8.de" <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v12 19/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZqDW1qzOe/uWSAkmVYoaVetZlS6+f8x4AgAEtegCAACbjgIAARNkA
Date:   Thu, 29 Jun 2023 09:45:04 +0000
Message-ID: <e093e75f09e738c3b6e28c0f6cec991ecff15243.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <28aece770321e307d58df77eddee2d3fa851d15a.1687784645.git.kai.huang@intel.com>
         <1662a5ef-c333-d6d6-7605-060f4bcca6fd@suse.com>
         <8a1d39c7641b0ba2be3191599a114bebfa3ffca5.camel@intel.com>
         <3afbb049ba3a848bb0befd7056ced519c7aa8991.camel@intel.com>
In-Reply-To: <3afbb049ba3a848bb0befd7056ced519c7aa8991.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6750:EE_
x-ms-office365-filtering-correlation-id: f659e1f9-ac09-4f59-b57e-08db78858460
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Jf0LdE71aovKIr1UCZOCpJX1LfMX2mdThmKPSv1B056WF3v/L3KrH7K3J4jjL+bkFWj7C3nSHm9BlKxGP0wppV0qcOCd0IsKAIbSRRpv8OQRo8IxbHTJPLiVvDC1qHSk1FavRcpyEV4gntqdN3C9lDDg7IknHyg+U1MoLbTvxo//wfjstuHAkUuQR6LlOl+RbPhEKn82qLYA2vXU8e3Q+wPnRMn4CK80Su/jk+uNrj1jD4RKHjcYQfWCzOXykazTuJqh+j+o2P2mliDYVURwmaAvV1Vnb0ju3iwvkJwRztnp2j1im2+HCiEGNxQpMmAld0W45PSsg6ptFm++y/koY6FiNSpKFyJJP4nNfp8STo9O4YManaK71xGXMQ6mi5xn8lqwOrUGTIYoBf9PgS3AbJ77Y4fh+3QMOjfPOt+sQah2K52rE5DdK3j86+Qmhrz6EXjhv/O6KxIZ4kAQAGxal2vmi7Ii1+rXlCAz92PaYeImcUQjxIahpcV7l1vqar4Hy5svm3pZ19aUWySVZDM7KHi6Dl2d3Y1CIHGqXhPSVqo0vbDJTJBvB7Xm/CFl6Y0j8iMUc34eaeAswJ1sC3FPh9bhezhzahNB9hH5llYoQTKlbmcaFksh+/AnP1WegDO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199021)(26005)(54906003)(110136005)(6486002)(186003)(122000001)(2616005)(82960400001)(38100700002)(83380400001)(71200400001)(6506007)(86362001)(41300700001)(2906002)(64756008)(478600001)(38070700005)(66556008)(66446008)(91956017)(66476007)(316002)(76116006)(4326008)(36756003)(66946007)(6512007)(7416002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEFOQjJ0YlBzYWZXeDJ0dW5xSFJsOGcrWGVjaXhxbzk2cnhKNkIrRlc3VHBM?=
 =?utf-8?B?U0Z3MnRLVVI2MjJYbFVnZDNYWkJmRDNKcjJhQ29RNEIyQStRVDdEa0sxbXNw?=
 =?utf-8?B?QmthcVRldjIxUThtcndSZS9BenVKMWJZamJ4K2h3TEl2TWtwcStJbEpNclQw?=
 =?utf-8?B?VWZzd1hoRzBUelByNlNQMXcxcm00S2tTSm5iaFdsMWVlVit0Y1d0a0FyWmdR?=
 =?utf-8?B?UW04bjdYRGY0L0tHT3JrVE4rNWN1SWl1SXphSitjYWZzd1RyajBxbFJlQk83?=
 =?utf-8?B?ZmtUKzBtM0xaUjdUT1o3ZFk2RDVxZHAra2czQkRRTlpWcTlkV254TmJCNnRi?=
 =?utf-8?B?c2FVMmFrdTVTdTVXd0h2TkNwWkltUnBpTEVCRnpWQ1RoaUdUN2tUTVV6dHJS?=
 =?utf-8?B?anhPbXUvcEFhYi9wOXczVFVIaFpMai92VDZ5TWVUcmg0V1lTRCsrakpVaW4z?=
 =?utf-8?B?MkNlckZxUTQ1MGFTT0hPUktQQ0VvUkhzdzZobWVLb3lDd3o3cEowaktNNWJq?=
 =?utf-8?B?ZFZQWWlReGppQlg1R0JCaVptbnl0Vnd5UUFESG16QUY5MmZBVDBSbU5CVkZB?=
 =?utf-8?B?WEJjUldubXdBSUJyYWUwa2JxQ3AxUk5ZSWpPTElGV3FFdUpYc0pOLzhobith?=
 =?utf-8?B?Q3pPOXBzYmFpaXpXcEZ0NTdSeFhmL3dDcTZCVlJSd280Q2JQNWdnM0JJbDN0?=
 =?utf-8?B?aCttTDU0clFseU9HU1p2VXFOYm1OVXdzSkVGUDU5bFVzN2g3SDIyZEZROG9n?=
 =?utf-8?B?UEdUQ3lwTFNBWi9VVGRMeTZwdlhSeTBKR21mci9iQytvN3g0Z2ZBQUF1emli?=
 =?utf-8?B?azI3Sk5RVjhyY3lDVWVsWTBGbklwZXdaay91bXRkdkRYWlo3cW15dTdSUnMw?=
 =?utf-8?B?NGpCb2dZa0R6ZitZM3JlSllDbTM4S2lmT2Eydmk5SWFKdHh2QkNsaEVkQmRK?=
 =?utf-8?B?YWFxR0UxNzJkK2M2dGYxUkIxUmJjOTNwZ2FVa2xyTlNVZXdGaS82ZDZIMHFU?=
 =?utf-8?B?aGoyV2VqNjF4cWJ4Q24yNUNnSld1SEVQZHZSTEFveVB4MkppQllXTnB1REVk?=
 =?utf-8?B?cGhzRFZhbUlsQm9ZdUtXdk1WbklFMTUwcVpTaHlURE4wRHlvYStnNTF3UzhL?=
 =?utf-8?B?VmRaMit6Z1dORWNmcGVPNHVKQ0V6eEJCRmRrVG1GVytxYktrZ2d3eElFTUwx?=
 =?utf-8?B?U1puRWZ0c1hvL3dLNmpVL0dMNUREenVDMjVIMVpPaktiaTdrUWIycnM1a2xh?=
 =?utf-8?B?UUcramxtd1grMjYwNzFJRURUdE9EV1o3MXBSelhvbTNhaTNkdlQranBtWURO?=
 =?utf-8?B?eU9jVGUyU296b3Qvd3VTREoxR3plNkVwd2VYUnVXT2pHRFZpMkxoRkh5SmRv?=
 =?utf-8?B?aFpnT0Z5VFhYYyt2K2p5RFo1bzRHQWpKMHZ5WTJCbjdPeTltMkQwRFRwbkZi?=
 =?utf-8?B?SVZXc2w0eGRTNnllek5rN2hNQXlvQ3lKTU5rak96ekY2TElTclRYOHBVUHMr?=
 =?utf-8?B?ZUNBcUZ6WDRUTmQzVVhqaUUxaDhKR0FCNjhNNHRINDd6V3pHQkt0djRZUkxp?=
 =?utf-8?B?YjBibkxWc3lBbU96eENkN1g3c3E0dVhPaW95dzJCaWxkYjBrbWZ4OVRkQ0pz?=
 =?utf-8?B?cW5GK2Z4Q2ZkdmM3dHZ1RzZPQU1jQkVrQlYwdVZzL3ZiL0lPUWtxaytYb0pI?=
 =?utf-8?B?cjJXRENzY2M4YXYvaEdzSjlCLy9oR1FpakJtZmRlbGsxYUFqKy80bmVMOXZS?=
 =?utf-8?B?UHBDbnllME5jQXgwdUZCei9RcC9VTjBaSTNEdUx4TnlhV3IwQ1R2K1NlcjZk?=
 =?utf-8?B?WFMzU2tGZ29qWDF0UkdLY3BpZUlqNFhmWDNNZU1MMlBQb2RSNlh6RkM0cStr?=
 =?utf-8?B?K3JXMWtFeGxZbWFMMTYvQ1JrV2prTHE3US9iK1pLMklUREtMQUxkZTYxUlVU?=
 =?utf-8?B?ZXM4cFBJWTBZY1Q2STRqZklZbzFHUHl1VVhDd2srTFRiamZXRWMyM3cvWklr?=
 =?utf-8?B?VHZYbGR1dzJTUjlXWDRwdnNJcWpzVnhMNmdGZStJOWJ2VjZPZVVzQ2lXRHBn?=
 =?utf-8?B?ZlhCa01Fak1jYVEycHhZYUVTbys5NW1vSmdVdW1sWDV4SkN5djgyQkw1bFpy?=
 =?utf-8?B?NzUrNzVsZnRnUGtEd1RWZ3MwOFJtaUlWajhpbGpjbHd5andGWWs0Y1UrZDFu?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A8775ABB511F34A9E5F507F7BE19B8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f659e1f9-ac09-4f59-b57e-08db78858460
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 09:45:04.9572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uuIGTchYFaVYzEP3BjtyIirKiw5w+vVm845a2AuuVX5rGJmXsdJ/6JSdS1mODjco2a98rq7NnG9lKnrPxamPPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6750
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTI5IGF0IDA1OjM4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjMtMDYtMjkgYXQgMDM6MTkgKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
T24gV2VkLCAyMDIzLTA2LTI4IGF0IDEyOjIwICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gPiA+ICsJYXRvbWljX2luY19yZXR1cm4oJnRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtKTsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiDCoMKgwqAJLyogQ29uZmlnIHRoZSBrZXkgb2YgZ2xvYmFsIEtl
eUlEIG9uIGFsbCBwYWNrYWdlcyAqLw0KPiA+ID4gPiDCoMKgwqAJcmV0ID0gY29uZmlnX2dsb2Jh
bF9rZXlpZCgpOw0KPiA+ID4gPiDCoMKgwqAJaWYgKHJldCkNCj4gPiA+ID4gQEAgLTExNTQsNiAr
MTE2NywxNSBAQCBzdGF0aWMgaW50IGluaXRfdGR4X21vZHVsZSh2b2lkKQ0KPiA+ID4gPiDCoMKg
wqAJICogYXMgc3VnZ2VzdGVkIGJ5IHRoZSBURFggc3BlYy4NCj4gPiA+ID4gwqDCoMKgCSAqLw0K
PiA+ID4gPiDCoMKgwqAJdGRtcnNfcmVzZXRfcGFtdF9hbGwoJnRkeF90ZG1yX2xpc3QpOw0KPiA+
ID4gPiArCS8qDQo+ID4gPiA+ICsJICogTm8gbW9yZSBURFggcHJpdmF0ZSBwYWdlcyBub3csIGFu
ZCBQQU1Ucy9URE1ScyBhcmUNCj4gPiA+ID4gKwkgKiBnb2luZyB0byBiZSBmcmVlZC7CoCBNYWtl
IHRoaXMgZ2xvYmFsbHkgdmlzaWJsZSBzbw0KPiA+ID4gPiArCSAqIHRkeF9yZXNldF9tZW1vcnko
KSBjYW4gcmVhZCBzdGFibGUgVERNUnMvUEFNVHMuDQo+ID4gPiA+ICsJICoNCj4gPiA+ID4gKwkg
KiBOb3RlIGF0b21pY19kZWNfcmV0dXJuKCksIHdoaWNoIGlzIGFuIGF0b21pYyBSTVcgd2l0aA0K
PiA+ID4gPiArCSAqIHJldHVybiB2YWx1ZSwgYWx3YXlzIGVuZm9yY2VzIHRoZSBtZW1vcnkgYmFy
cmllci4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+ID4gKwlhdG9taWNfZGVjX3JldHVybigmdGR4X21h
eV9oYXNfcHJpdmF0ZV9tZW0pOw0KPiA+ID4gDQo+ID4gPiBNYWtlIGEgY29tbWVudCBoZXJlIHdo
aWNoIGVpdGhlciByZWZlcnMgdG8gdGhlIGNvbW1lbnQgYXQgdGhlIGluY3JlbWVudCANCj4gPiA+
IHNpdGUuDQo+ID4gDQo+ID4gSSBndWVzcyBJIGdvdCB5b3VyIHBvaW50LiAgV2lsbCB0cnkgdG8g
bWFrZSBiZXR0ZXIgY29tbWVudHMuDQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gwqDCoCBvdXRfZnJl
ZV9wYW10czoNCj4gPiA+ID4gwqDCoMKgCXRkbXJzX2ZyZWVfcGFtdF9hbGwoJnRkeF90ZG1yX2xp
c3QpOw0KPiA+ID4gPiDCoMKgIG91dF9mcmVlX3RkbXJzOg0KPiA+ID4gPiBAQCAtMTIyOSw2ICsx
MjUxLDYzIEBAIGludCB0ZHhfZW5hYmxlKHZvaWQpDQo+ID4gPiA+IMKgwqAgfQ0KPiA+ID4gPiDC
oMKgIEVYUE9SVF9TWU1CT0xfR1BMKHRkeF9lbmFibGUpOw0KPiA+ID4gPiDCoMKgIA0KPiA+ID4g
PiArLyoNCj4gPiA+ID4gKyAqIENvbnZlcnQgVERYIHByaXZhdGUgcGFnZXMgYmFjayB0byBub3Jt
YWwgb24gcGxhdGZvcm1zIHdpdGgNCj4gPiA+ID4gKyAqICJwYXJ0aWFsIHdyaXRlIG1hY2hpbmUg
Y2hlY2siIGVycmF0dW0uDQo+ID4gPiA+ICsgKg0KPiA+ID4gPiArICogQ2FsbGVkIGZyb20gbWFj
aGluZV9rZXhlYygpIGJlZm9yZSBib290aW5nIHRvIHRoZSBuZXcga2VybmVsLg0KPiA+ID4gPiAr
ICovDQo+ID4gPiA+ICt2b2lkIHRkeF9yZXNldF9tZW1vcnkodm9pZCkNCj4gPiA+ID4gK3sNCj4g
PiA+ID4gKwlpZiAoIXBsYXRmb3JtX3RkeF9lbmFibGVkKCkpDQo+ID4gPiA+ICsJCXJldHVybjsN
Cj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICogS2VybmVsIHJlYWQvd3JpdGUg
dG8gVERYIHByaXZhdGUgbWVtb3J5IGRvZXNuJ3QNCj4gPiA+ID4gKwkgKiBjYXVzZSBtYWNoaW5l
IGNoZWNrIG9uIGhhcmR3YXJlIHcvbyB0aGlzIGVycmF0dW0uDQo+ID4gPiA+ICsJICovDQo+ID4g
PiA+ICsJaWYgKCFib290X2NwdV9oYXNfYnVnKFg4Nl9CVUdfVERYX1BXX01DRSkpDQo+ID4gPiA+
ICsJCXJldHVybjsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qIENhbGxlZCBmcm9tIGtleGVjKCkg
d2hlbiBvbmx5IHJlYm9vdGluZyBjcHUgaXMgYWxpdmUgKi8NCj4gPiA+ID4gKwlXQVJOX09OX09O
Q0UobnVtX29ubGluZV9jcHVzKCkgIT0gMSk7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlpZiAoIWF0
b21pY19yZWFkKCZ0ZHhfbWF5X2hhc19wcml2YXRlX21lbSkpDQo+ID4gPiA+ICsJCXJldHVybjsN
Cj4gPiA+IA0KPiA+ID4gSSB0aGluayBhIGNvbW1lbnQgaXMgd2FycmFudGVkIGhlcmUgZXhwbGlj
aXRseSBjYWxsaW5nIG91ciB0aGUgb3JkZXJpbmcgDQo+ID4gPiByZXF1aXJlbWVudC9ndWFyYW50
ZWVzLiBBY3R1YWxseSB0aGlzIGlzIGEgbm9uLXJtdyBvcGVyYXRpb24gc28gaXQgDQo+ID4gPiBk
b2Vzbid0IGhhdmUgYW55IGJlYXJpbmcgb24gdGhlIG9yZGVyaW5nL2ltcGxpY2l0IG1iJ3MgYWNo
aWV2ZWQgYXQgdGhlIA0KPiA+ID4gImluY3JlbWVudCIgc2l0ZS4NCj4gPiANCj4gPiBXZSBkb24n
dCBuZWVkIGV4cGxpY2l0IG9yZGVyaW5nL2JhcnJpZXIgaGVyZSwgaWYgSSBhbSBub3QgbWlzc2lu
ZyBzb21ldGhpbmcuIA0KPiA+IFRoZSBhdG9taWNfe2luYy9kZWN9X3JldHVybigpIGFscmVhZHkg
bWFkZSBzdXJlIHRoZSBtZW1vcnkgb3JkZXJpbmcgLS0gd2hpY2gNCj4gPiBndWFyYW50ZWVzIHdo
ZW4gQHRkeF9tYXlfaGFzX3ByaXZhdGVfbWVtIHJlYWRzIHRydWUgX2hlcmVfLCB0aGUgVERNUnMv
UEFNVHMgbXVzdA0KPiA+IGJlIHN0YWJsZS4NCj4gPiANCj4gPiBRdW90ZWQgZnJvbSBEb2N1bWVu
dGF0aW9uL2F0b21pY190LnR4dDoNCj4gPiANCj4gPiAiDQo+ID4gIC0gUk1XIG9wZXJhdGlvbnMg
dGhhdCBoYXZlIGEgcmV0dXJuIHZhbHVlIGFyZSBmdWxseSBvcmRlcmVkOyAgwqANCj4gPiANCj4g
PiAgLi4uDQo+ID4gDQo+ID4gRnVsbHkgb3JkZXJlZCBwcmltaXRpdmVzIGFyZSBvcmRlcmVkIGFn
YWluc3QgZXZlcnl0aGluZyBwcmlvciBhbmQgZXZlcnl0aGluZyAgIA0KPiA+IHN1YnNlcXVlbnQu
IFRoZXJlZm9yZSBhIGZ1bGx5IG9yZGVyZWQgcHJpbWl0aXZlIGlzIGxpa2UgaGF2aW5nIGFuIHNt
cF9tYigpICAgICANCj4gPiBiZWZvcmUgYW5kIGFuIHNtcF9tYigpIGFmdGVyIHRoZSBwcmltaXRp
dmUuDQo+ID4gIg0KPiA+IA0KPiA+IA0KPiA+IEFtIEkgbWlzc2luZyBhbnl0aGluZz8gDQo+IA0K
PiBPSyBJIGd1ZXNzIEkgZmlndXJlZCBvdXQgYnkgbXlzZWxmIGFmdGVyIG1vcmUgdGhpbmtpbmcu
ICBBbHRob3VnaCB0aGUNCj4gYXRvbWljX3tpbmN8ZGVjfV9yZXR1cm4oKSBjb2RlIHBhdGggaGFz
IGd1YXJhbnRlZWQgd2hlbiBAdGR4X21heV9oYXNfcHJpdmF0ZV9tZW0NCj4gaXMgdHJ1ZSwgVERN
UnMvUEFNVHMgYXJlIHN0YWJsZSwgYnV0IGhlcmUgaW4gdGhlIHJlYWRpbmcgcGF0aCwgdGhlIGNv
ZGUgYmVsb3cNCj4gDQo+IAl0ZG1yc19yZXNldF9wYW10X2FsbCgmdGR4X3RkbXJfbGlzdCk7DQo+
IA0KPiBtYXkgc3RpbGwgYmUgZXhlY3V0ZWQgc3BlY3VsYXRpdmVseSBiZWZvcmUgdGhlIGlmICgp
IHN0YXRlbWVudCBjb21wbGV0ZXMNCj4gDQo+IAlpZiAoIWF0b21pY19yZWFkKCZ0ZHhfbWF5X2hh
c19wcml2YXRlX21lbSkpDQo+IAkJcmV0dXJuOw0KPiANCj4gU28gd2UgbmVlZCBDUFUgbWVtb3J5
IGJhcnJpZXIgaW5zdGVhZCBvZiBjb21waWxlciBiYXJyaWVyLg0KPiANCg0KKFNvcnJ5IGZvciBt
dWx0aXBsZSByZXBsaWVzKQ0KDQpIbW0uLiByZWFkaW5nIHRoZSBTRE0gbW9yZSBjYXJlZnVsbHks
IHRoZSBzcGVjdWxhdGl2ZSBleGVjdXRpb24gc2hvdWxkbid0DQptYXR0ZXIuICBJdCBtYXkgY2F1
c2UgaW5zdHJ1Y3Rpb24vZGF0YSBiZWluZyBmZXRjaGVkIHRvIHRoZSBjYWNoZSwgZXRjLCBidXQg
dGhlDQppbnN0cnVjdGlvbiBzaG91bGRuJ3QgdGFrZSBlZmZvcnQgdW5sZXNzIHRoZSBhYm92ZSBi
cmFuY2ggcHJlZGljYXRpb24gdHJ1bHkNCnR1cm5zIG91dCB0byBiZSB0aGUgcmlnaHQgcmVzdWx0
Lg0KDQpXaGF0IG1hdHRlcnMgaXMgbWVtb3J5IHJlYWRzL3dyaXRlcyBvcmRlci4gIE9uIHg4Niwg
cGVyIFNETSBvbiBzaW5nbGUgcHJvY2Vzc29yDQood2hpY2ggaXMgdGhlIGNhc2UgaGVyZSkgYmFz
aWNhbGx5IHJlYWRzL3dyaXRlcyBhcmUgbm90IHJlb3JkZXJlZDoNCg0KIg0KSW4gYSBzaW5nbGUt
cHJvY2Vzc29yIHN5c3RlbSBmb3IgbWVtb3J5IHJlZ2lvbnMgZGVmaW5lZCBhcyB3cml0ZS1iYWNr
IGNhY2hlYWJsZSwNCnRoZSBtZW1vcnktb3JkZXJpbmcgbW9kZWwgcmVzcGVjdHMgdGhlIGZvbGxv
d2luZyBwcmluY2lwbGVzIC4uLjoNCuKAoiBSZWFkcyBhcmUgbm90IHJlb3JkZXJlZCB3aXRoIG90
aGVyIHJlYWRzLg0K4oCiIFdyaXRlcyBhcmUgbm90IHJlb3JkZXJlZCB3aXRoIG9sZGVyIHJlYWRz
Lg0K4oCiIFdyaXRlcyB0byBtZW1vcnkgYXJlIG5vdCByZW9yZGVyZWQgd2l0aCBvdGhlciB3cml0
ZXMsIHdpdGggdGhlIGZvbGxvd2luZw0KICBleGNlcHRpb25zOg0KICAoc3RyaW5nIG9wZXJhdGlv
bnMvbm9uLXRlbXBvcmFsIG1vdmVzKQ0KLi4uDQoiDQoNClNvIGluIHByYWN0aWNlIHRoZXJlIHNo
b3VsZCBiZSBubyBwcm9ibGVtLiAgQnV0IEkgd2lsbCBqdXN0IHVzZSB0aGUgY29ycmVjdA0KYXRv
bWljX3Qgb3BlcmF0aW9ucyB0byBmb3JjZSBhIG1lbW9yeSBiYXJyaWVyIGhlcmUuDQo=
