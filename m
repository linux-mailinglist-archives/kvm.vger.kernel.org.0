Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5276F7447FC
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 10:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjGAIRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 04:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjGAIQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 04:16:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D50DB;
        Sat,  1 Jul 2023 01:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688199415; x=1719735415;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+5rnYZabYK3ndVcS21RDySE1M0PVCAhbAJXrnHEAeBg=;
  b=QPCjIGKU1MnnKhHabtg2HDQ9JcDNXL+bZ4RIo/ecqaTVjN0GUgIC7Yj5
   bTWMSJKxi4WpCu+v094Zxez79ET739vsf6f2s6BSU0wVqTQtLn9YmlA5+
   XiMlLHWce+/QydD1mqGL247kf1IZg3Fl82g+qzbpcHdk6hO8I4mpH3uSn
   WmeIqmJjztKTvmXzY/oDW4sGDBm6x7KwtLEG9T1mmD0dzEJS/UFHposJS
   x97Sa4uGGUwAbKK/37wtpnnltlP7YDq07Vq1a/c53IKHgjfT6NqzE20kw
   0WqdFVRXcrepzlAWjGoT4n80pJdv2SyvJ94CHPmwBREiPQRMnObgxxtpA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="361423095"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="361423095"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 01:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="787976237"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="787976237"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 01 Jul 2023 01:16:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 01:16:53 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 1 Jul 2023 01:16:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Sat, 1 Jul 2023 01:16:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Sat, 1 Jul 2023 01:16:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTNTzyFNJgoCQCWNiuAe32XF8IQsU0K6smsNkLYbcpnIMPmp+QE2b2/q1DTfdy7LWm02tNDzHdmCUbvvPsOenITfQwbvsTYnD8pewkY2FSGx3bpJLPrc/obJzMMqdeDKHqJ7j+iA/w9re9b+XvzW89JxdufWT2x1VlBIJR2tY4P4tZ1oSlSLcjtV+nnTKZb2V4Q6TXNPbksDPU18KVfQuWZ23aAJfUwDGqvtH3gDq3cjSfIjLgIsS0r4Tl6ITGX0hgIdaPQxGs9HmgeOoHhuFsTPfcD9O745FDn97BL07KCyyiOYgd/j20gR/+6Rm/uOvnoon4+jMMLyzwqRE/qbzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+5rnYZabYK3ndVcS21RDySE1M0PVCAhbAJXrnHEAeBg=;
 b=TsVmJS/wduY7RGEiNERDvwgeO0uaIoyTOsq8j9N6/rn2koHhEcmG/B2mnLynucz3Zy/ZixzjotyiO0FVo6qV62T90yppnkccUo9DXKbwzcujzJD9bo2mhej26bHWBNyP4u0qltAQktMuYM9d35AwUzTmtiV8EgBFWDxurgu0HB1DcXXRQ6HTd6nd3Gvo96day3P7Uog8MZkWdGcczHodHshqrhXUNH0VNtTRSd6rXw0omCYjlAungTLdvwL6ujr7kKtv2jrOQB1s4g13RsSdIdxiIrMPf4TEL01qXv1raYV3EwZ2cHFtWchQsFk0ueOetx3YQPKed0WvOcF0Y8UoHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6553.namprd11.prod.outlook.com (2603:10b6:510:1a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Sat, 1 Jul
 2023 08:16:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sat, 1 Jul 2023
 08:16:50 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Topic: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Thread-Index: AQHZqDW2iSvVOZI03kGK/IB0Vnjb6a+gWhoAgABWcYCAAOlagIABiuaAgAADMoCAAFNgAIABHPMA
Date:   Sat, 1 Jul 2023 08:16:50 +0000
Message-ID: <78a1046cffc6db3345a65e98a7565cecb77fa302.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
         <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
         <20230628203823.GR38236@hirez.programming.kicks-ass.net>
         <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
         <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
         <88de636ed40786f40c153b392070357f8b3d6948.camel@intel.com>
         <1121357f-93ad-9016-36be-8bc34c256b16@intel.com>
In-Reply-To: <1121357f-93ad-9016-36be-8bc34c256b16@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6553:EE_
x-ms-office365-filtering-correlation-id: 06ce2303-3f24-49a2-30e6-08db7a0b853c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k0mu4lGQFvxUzNFY0Tl45iFf3yokQl9jW0sEksRp5bKKU3wOCwjOUy0UOlYVa+bsocam2gvjlhYWrw2MPsd9lCdlkOer5Ld3W2X66C17jhILeFVuW3Z9ZtnJiseEes5mu3/jik1cSZQgQO/Zh4v3qo3tMY6quAkzuAitWw0fABg4QVJnoglZNM5OL14BKv9AD127CaU8qazpgBHv+y3BBhagVslP46o3tvFrfqlG7/O5iid8YEgLD9F20y7xaRdo0ec+0dQZwYVWYuDcuF1mxYm3H1yAN9vSC775XPBn4GjNKoIzkNJD8j6zBcadZ3fkUoow2z/YXsxU+YNOJhQTSd/nsEMH5FtDXSG6SPCXLYHFjn6OjarxHualvXs11ILgwI6lEMfiTjgKZzXLry4Sm6Bpls6n4lkaMXWmrE3UKcgZO3MvQoKo32JsAYln7QesNCtTImBrCeW5u/1cwCgL/MMkZfpkFpQMjThKQEsRzEXEoWdgolVs8zTg5hO0tdCa4jt0y799alUOb8YJ4AsjOF+imcJePjTlWJocB+Lhu04RmZ/hQqfOLz/oiWup78ygPWk+HAVwoxxi9vk5e+M9WuoPqVhm9na34QJ0zl9ol/t8jgrJW/PaElMooJn8PUbB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(396003)(136003)(451199021)(41300700001)(4744005)(6486002)(38100700002)(71200400001)(82960400001)(122000001)(2616005)(6506007)(26005)(186003)(53546011)(6512007)(38070700005)(54906003)(110136005)(86362001)(478600001)(316002)(2906002)(36756003)(91956017)(64756008)(66446008)(6636002)(4326008)(66476007)(66556008)(66946007)(76116006)(8676002)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVoyN3l4aE4weGt3WFYzWnowbDFxWW94Q2NYT2Q1Znp6d1BCc1B2QUNyNktN?=
 =?utf-8?B?WjVGNGpLWng0engrZXVQR29sRXJKR0ZkT1d3Ry9PZEp6MnRyOUl4Ti80L2pK?=
 =?utf-8?B?dEdVdTgwWmNQUjJvaWVtRGpEMXJUVE9Ub0dPZ2FORnZqWXEya3BOSHhZeHlt?=
 =?utf-8?B?aFREaWJYZW1GQWpPeGFoeVVOVW9lZHBRaHB5UzdKQ0lkclFJRU96cWh0Kzln?=
 =?utf-8?B?ODM1WThvNE5CbEdwZjd1cERBZHpvR1AyWGNsc2E2bEhRdkthZVN5ZFZocldz?=
 =?utf-8?B?VlUvSlQ4ZWU2M1ZiQnZlekdWa01OdGxScHdCbXNkMTNJQXc4Wm9FRkd4MEVj?=
 =?utf-8?B?QjI5ZWdxL2ZoaENBV1Y4RitYUUNLcDl1MUhIN05CNWNlcHNlaVdpeG93bmti?=
 =?utf-8?B?UFhVcWFqNXNubDlhSklTck42bEZub0J5VkQxcmJSR09kVXFPRUwrWjlEWk45?=
 =?utf-8?B?Y1NqaG90YTdXdzJhRFlxNGxrMXFqY01JaWQ0eHJtZmtjMi9qQzZpZVlXZ3p0?=
 =?utf-8?B?bm4vZDBkR2dQNHFHb2t4UU04NnZsbUM2dk1GMG1aL0hzdFVwQy9YdjNYQlkr?=
 =?utf-8?B?YzhSaWxUc2tKbDJlQTg4TWRGaGNFeXNOc3ZSQTVReGJZNGJIcHpmVy8yUlRs?=
 =?utf-8?B?K0NvazdTL21WSHZlRWU5UjVvR0graWk3bzNVeGRpT3pUMGlEWnBJcWpRdXVu?=
 =?utf-8?B?TXN0NFpJbXhSQ0I3eUMwcVBCclRVUGVFa3FrbjFwZVB5TlZVWmdjVlUvUGVm?=
 =?utf-8?B?b1NyU0RFUGE1dHJhcmpvcnFSaHBMNE5YWjJHbko3UzVINFdrTFZuRTQ4VlJ6?=
 =?utf-8?B?ek9nS0Izc1dRbERCSWJmTlpMZDFFZVdsUHJNdWdoRkhpdkpNUTRNZzNpTjM0?=
 =?utf-8?B?eU4wVGFuYmhDbXg4RmpoWmZTTE5ZV1dGNm5rNy9nQkduYzZLZGVzZGFjNmZh?=
 =?utf-8?B?RXRaTC9DSXNYbUtuWVpZQURteFowbW1CTlNHU0hyWmNqSndjQ1dqbUtkSTl3?=
 =?utf-8?B?Rm9RaHpUYlFWT0taK3ROc1R6WENvNHRGczBVUkhVY20xYVk5Nm5QRzNxdll5?=
 =?utf-8?B?RCtTaHZJRWtPLzhRbVhQaGRrUjVyRG91NmtzSUJoMWtjQUhsZjd1VS9jNFM1?=
 =?utf-8?B?bmN0NVFXZWEyRm9HUXNhSTYwM0xCeXNEMnRoOTVObDBTSHpHUmloQkFoSjgr?=
 =?utf-8?B?dWJGZW1INldOVnZHOVJJY05wN3B5YzZ3NnRpcDhKU3N4WThuRDRxSUhVaTBZ?=
 =?utf-8?B?VFpiNy9VRzQ1dzdXa1ljb1hKVHNTQzlQeXh4SkV5OHNtMnBMSERWL3hkdjgx?=
 =?utf-8?B?amlwVm1zSGJFajR1ek8xbjNGT2hHYnFYUFIxR21aK0tZMlpLZ0hEbWpmaFhJ?=
 =?utf-8?B?RFBxbmxmazRvTEdCbG5rTXdiYVJZVDVGenNpM2wwU0JZcEVqOTQvdDdBT00r?=
 =?utf-8?B?b3QwM0ErcUU3UUF3aFlwR1pnT2pqY2NmWnV1cHl5TWQ4OTlXRGNHR0VGL0xW?=
 =?utf-8?B?Nmt0b3dwSzh0MnJ2K21wME56SjBRbWZnNk80RktBQVBMMFpheTVVOG4wVlpa?=
 =?utf-8?B?ZkJrcXhmV1pKdHlJeVVKbTNQd0s0YmtZRVVJN1JDcDBCeWZ0MHJnYXFjZnp5?=
 =?utf-8?B?YTVkRmdTUC95WnVGdmNYS25OYmlqcExBNWIyNG1XREpGeHlGamF6eGIwSXMz?=
 =?utf-8?B?c1QvYXVyM3BuZndCYkRDakdudzVMSW8rNENrdHlYM2FtK2psdVA5NjROTmhz?=
 =?utf-8?B?NzZrS3NHMGJONUhydzRkT1U0a1o2TGpacXJ0WmR0RTl1RHdMSFgxWWdpL3pv?=
 =?utf-8?B?aktWTzFFNnZQdzBIdmozdEFxcnpROXQ3MWtSenVLZW13UTM4WnJHVmt5bGRS?=
 =?utf-8?B?ZVc1VHNvVk1RMmU4L2ZTRXhWYmZ0TVR3OEFIb2tiVk5uaXo5MkZiZEcwbms1?=
 =?utf-8?B?THM0V25zOTY5TmwxYmxrY0JJN3d1T044b0w3WkxYRFBUYzBEbVhVZTUwY1A4?=
 =?utf-8?B?a1VHdi9SdEVQYitPbGNhcldGZkdFVjIzR1FSYW1QTTJMZ1pTRy80N0V2Ylls?=
 =?utf-8?B?dHJkek8vVW4rMnh1MmdDenk1Wlo3bXU1VjFOYXpkb2NadUlHK0JnNkNQSHN0?=
 =?utf-8?Q?bfDf2TaiWnqSBeCDJZ9zChY91?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48C51344504F8B47AD856974311972B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06ce2303-3f24-49a2-30e6-08db7a0b853c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2023 08:16:50.1435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: soLQlZTrRrimOWhVa/nv6FFXr+VB8uSv/tJqp5yDpdQNy208t+HIljtDepE3G1sEkixPUcCWUpkUpS8GZPfadQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6553
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

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDA4OjE2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8zMC8yMyAwMzoxOCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+IFBsZWFzZSwgYmVjYXVz
ZSAxMiwxNCBhcmUgY2FsbGVlLXNhdmVkLCB3aGljaCBtZWFucyB3ZSBuZWVkIHRvIGdvIGFkZA0K
PiA+ID4gcHVzaC9wb3AgdG8gcHJlc2VydmUgdGhlbSDwn5mBDQo+ID4gWWVzLg0KPiA+IA0KPiA+
IEhvd2V2ZXIgdGhvc2UgbmV3IFNFQU1DQUxMcyBhcmUgZm9yIFREWCBndWVzdCBsaXZlIG1pZ3Jh
dGlvbiBzdXBwb3J0LCAgd2hpY2ggaXMNCj4gPiBhdCBhIHllYXIocyktbGF0ZXIgdGhpbmcgZnJv
bSB1cHN0cmVhbWluZydzIHBvaW50IG9mIHZpZXcuICBNeSB0aGlua2luZyBpcyB3ZQ0KPiA+IGNh
biBkZWZlciBzdXBwb3J0aW5nIHRob3NlIG5ldyBTRUFNQ0FMbHMgdW50aWwgdGhhdCBwaGFzZS4g
IFllcyB3ZSBuZWVkIHRvIGRvDQo+ID4gc29tZSBhc3NlbWJseSBjaGFuZ2UgYXQgdGhhdCB0aW1l
LCBidXQgYWxzbyBsb29rcyBmaW5lIHRvIG1lLg0KPiA+IA0KPiA+IEhvdyBkb2VzIHRoaXMgc291
bmQ/DQo+IA0KPiBJdCB3b3VsZCBzb3VuZCBiZXR0ZXIgaWYgdGhlIFREWCBtb2R1bGUgZm9sa3Mg
d291bGQgdGFrZSB0aGF0IHllYXIgdG8NCj4gZml4IHRoZSBtb2R1bGUgYW5kIG1ha2UgaXQgbmlj
ZXIgZm9yIExpbnV4LiA6KQ0KDQpZZWFoIGFncmVlZC4gIEFuZCB3ZSBjYW4gcHVzaCB0aGVtIHRv
IGRvIHdoZW4gd2UgZmluZCBzb21ldGhpbmcgbmVlZHMgdG8gYmUNCmltcHJvdmVkLiA6KQ0K
