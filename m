Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05916C23C7
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 22:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjCTVfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 17:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCTVfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 17:35:39 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411DE211C6;
        Mon, 20 Mar 2023 14:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679348107; x=1710884107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7dH5cZnqZD+2Ghu0j/a9wr2juCItsEZ1bRCr9o5QmhY=;
  b=jR5SJjdPuRYTZ4vWe4mWY10AnVFQesNCph8klJ3l+j4RLapZazSxe/3c
   kEjXbow3g9ulFnuJSnVbpRm6Ud2iO/cnFhb9LPNajoQEv1QJK0c1Mlvx2
   pLqXCuSBEJ1VtlBzIIpZzgjmAPHKQpjPv1gwQf9kYiyog1bGrRQyQCPUE
   BVdIod+DGEtXPEaJifOtTjgouv2PmKBvdGUUPrYr2r4c4gg947Pd3Hn7U
   dGG3CosOZYWXXqEdN51h0EJyIcaecmoUXErtzEA/hi1SlPomzqlaWqMtl
   hSkrMRyE88oNXhcK1JCkdCwLj3iMFCW0Ya0LuVPZCL2xTc/GZ89zc58SS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="401357850"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="401357850"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 14:34:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855410603"
X-IronPort-AV: E=Sophos;i="5.98,276,1673942400"; 
   d="scan'208";a="855410603"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 14:34:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 14:34:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 14:34:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 14:34:31 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 14:34:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tw+NQuZwpeFLLryjV/qw2+K6GBe8X3zgcnbg/dJCpsIanUrkU5L9fLOfUnEvOjMDvtjXQWlZLo7KFcFqfgTnInxoyCvN6rUeXlIanSKMT11O5FoaOHdRIb5dAAcAB9rClUjVmsoU5aUm0r4eqESIhZ5DVQvxGDaAL0vFtXKjxcOHAH6RseX8osnNJ8VlifEaZCo3F59NRh3MHIuXTzFzAo6Y+kKo66lc+JO0o+J/nvkvXcVSxTqzZQvOUW0Dc+97s0xoS++6xpRqxXWhP2PjQTYmhdCFb6ruYopr0ZVq4qR6DxrmSlhHeCGPl+kUqEMAOZZa25p7A+Hr2nA2GrrJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dH5cZnqZD+2Ghu0j/a9wr2juCItsEZ1bRCr9o5QmhY=;
 b=WGk4KDu0PZLUCobmlMGUHhaPiljECZrW1hm640ZBIXnUsBPmiKh4IVtr6m1cDbH7apY8EQgtvivBtB+xaP+n3oaiY+7ei7OZFI0kGnoEzq5rYM9//Ssjygn4T9BlA3gKjXQdvqlcEDuf6YsyYJmBGiaJL9/K415BCMUd0DU+lTx/+nHL7OdqlgIpXXD7GybATlCybKOtkaTgd2MsqRz3FBoDg4C8iEeK2Tq29E9PpZhLkd0h8q91DIjBpTT4ksYa0wDY96EmNGNmKAt6qgHw3hsF0LuKrVOA3RA0W2OXjkjOG2JLM7MbCsZ+Sr4ZqWGq0nB+9xQyBhbb46tyvifzPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5205.namprd11.prod.outlook.com (2603:10b6:510:3d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 21:34:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 21:34:28 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gross, Jurgen" <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
Thread-Topic: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
Thread-Index: AQHZUEoEVz7TvG4lT0yKsCx1uIyU/q8DtxCAgAANYwCAAIJ0gA==
Date:   Mon, 20 Mar 2023 21:34:28 +0000
Message-ID: <2b61fec12a3be255327d9e16678c40608ec538f8.camel@intel.com>
References: <20230306163425.8324-1-jgross@suse.com>
         <20230306163425.8324-4-jgross@suse.com>
         <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
         <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
In-Reply-To: <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5205:EE_
x-ms-office365-filtering-correlation-id: 684bca0b-1d41-4724-6b2d-08db298ae289
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1bTyi1XAAhPujmDHneP1QfLewh0A5Vpxr5rrnWwplw+IF9Etp6Y9IchjlbBPkTQ0Z/qgbZxWf46aYD4+pzm/oU3pScb9rDIh3PuoUsZe/U088JyHOvZCTYXQ6mECOFMUNlf3eQBjaEAOKhL3kzVsXh6jFVTpO37O3tx0ajCtySdF3Yfz9rjgZuGtz4OIsCVxByLdu6rXzEzsBcoTrSnKuGPGn+vjNpJoWQTFu46JPUscKwKWsWeUSw5f15jIHsaehxR5qCmLDvNTZDYkWxH3l94HYdTzKj+Ifr6aN/5vwV7/9ViFaH8H6N8T5NlIZsuPPWInqfJByOjKCBJ8BZsl6rQIO4UjHfMe00pcOm7BZJEBh3PuVbLQ0My0u+JB/P8Q7nvhJijLtOG2oqcIzbA+JEjyGcd9SbXBEy08xx2CC2pDiTP2uEWdEJwoyjHZrT6GqWgBiVCI4s5e8x/XsHuGpwVJBp4VWlIGywyHscPb7T4+Tyx9P+FPCAQsd6KzsCQPFpVN2RyQgPF7DQbClY8QT5vflsFy4jhZMNwOMKv+J8POYgAPHjbvt9GAnU1uNEVIHWKU/45pMsrS4dQRa16tcqnqYrnz3+7v9DlguQCPlSc1eVEHNVZGX0xfP79Nhc0TMW3XFWv6ayGUC3G5Md+7he5P3sAX8Dm7+hd5QjiAXNn5fMX0a1NTlvLCIdrMjsxqHDX2xYI8/XhxKxJmAkMtvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(38100700002)(86362001)(122000001)(36756003)(38070700005)(6506007)(82960400001)(4326008)(91956017)(76116006)(7416002)(5660300002)(2906002)(66476007)(64756008)(66556008)(8936002)(66946007)(66446008)(41300700001)(2616005)(186003)(83380400001)(26005)(316002)(6486002)(54906003)(110136005)(71200400001)(6512007)(53546011)(478600001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk5xT3VTNmIvb0VVYk1GVHo2Vyt5MGdoM3pLbXJBTTNVTUp6SGpDTVUrYW45?=
 =?utf-8?B?UFRHeEhjWGdvTFBLd1FJVFRxQU5OUjJPN1N3YlVweHcrLzZEcmRLeTMyQk92?=
 =?utf-8?B?WDFUa04wQTVtRFptTmtUTXJxdVJudmZKcDRlemNkWlJ6U2tBWDBhMHVqWXRl?=
 =?utf-8?B?aFo1RWMzNmxYdlRaUDc2YU82bE1mK2FDMmVzNE9iTDZ5YlVkZS9QcHE2Mld0?=
 =?utf-8?B?bEpzUWcxNGRtSWQzZklSOGtoOFJuRzFTaFZXUTZDeEM4OUdqbnhTNmljaXJC?=
 =?utf-8?B?Y1UwNUhsNU95UE5PaEVnQmdVQmdSMlliRzRQK01GdjZiUXdhaHRjUFdiWDZk?=
 =?utf-8?B?VWpwS2hyVFE2Z0Jhc2JJUCtyeWJxZ0lXT0VTWVlJSmNrQkNRLzdzVjRLNFFL?=
 =?utf-8?B?KzBCTzFGczY0ZEx6bGduNnR5YU9VQ0o4QlpZMWRkNVFhZ3MrREVVd3pUdDJW?=
 =?utf-8?B?Q0lOcEtOeEF5K3l4T1lnT0R4TkxJWWV0b01rbGJuRzBlZFVMTGJ4dktMcFZV?=
 =?utf-8?B?OXFMcHl4ZTdXTmdRdGVKRVdaUkxjNG1aaXlmVjVCdTNjUUJxM0NycHZMY0ZO?=
 =?utf-8?B?d3NHalhRcHF2c3RMSW5tbDlmdmpHeVlQRGZxLzVaTUxEVnBqNHFaMkh3U1lt?=
 =?utf-8?B?MVM1NjF4ZURYakNNR2pXSFd1SjZHNTJ5cWhDcXVpclgwZmQvZWhuYldVb01G?=
 =?utf-8?B?YnJ5NTVRZHlMdHVKK3IrZSs5OVo1dnZiWkhwNWFHS3ViaFZnRlE0UWdIV0kx?=
 =?utf-8?B?WGQyN3BHKy9mS1pyU1pQc0o2UU4zV0k4QjBrMEtXSThydTJsQzdpd0o3dGpD?=
 =?utf-8?B?V2d5TkpDZ3hoTS8za1krR042VXQ2M1VXbDk4L05tZVRrZ3E0VVZIS3A0LzNE?=
 =?utf-8?B?Wm0wR1ZEZEJVT3AyakNhTVBxak14cjI5Z0E0MDJqdG9ZdkxMQ1VZb0dLSnU5?=
 =?utf-8?B?TVQwMWpzMDVZWnpIQ3pzQitnSHlvMTF3Tlh5bXRqYjh5ZzlIWWFsOVBsdnZn?=
 =?utf-8?B?S2tiWTdvNGl0SW9qT1l6UmMwdmpYNWFwbys0bnBCcmpEajk1OGdTekwzdnFE?=
 =?utf-8?B?MXZ0YXdUd3dHa0NzVDYraWtJV25Zc2xWSzNlM3ZrdTAweTdYOXhXR1lxUXhC?=
 =?utf-8?B?Znl2Z2x4aHBFQ0J2NE5hVTNHeGh2MU5OS0ROS25tTVhvNFRiWEJXNzJSYi9m?=
 =?utf-8?B?aDJCeGVlZ0RVbkZpNFpsNG1tTUp5ZDJHWHhNNlF4bzBmMXBiWnhBalE2V1Fo?=
 =?utf-8?B?WHRlRXk5eVBoL2x3c3h1dHdoRU9tYVNzU1Z4NFVSK0VzaXBYM3lxZkhBdkRw?=
 =?utf-8?B?ZGF2R0VRWUJVTEVQMWNEeXp3NEkwcXJiM3RFOW1kOFR2Wk1zRFQxZGp5Y1Nw?=
 =?utf-8?B?L3NkOW1tcFFZSWZZT25YT3FIWnBNQnN1RTJJcmY5UGlBWHdUN2l2V1g2VWVG?=
 =?utf-8?B?ZDNWdHdJcnd2a2lET0RiSm04anZFRlNYUFowMTRyNnJidTR6V3k1YkJGUmRH?=
 =?utf-8?B?aDdlQmFPSTJFT2FONDJNRkpUN3haaFZENXZuVlY1Rmx0ZW93a2FJbHVlQU8z?=
 =?utf-8?B?WjdqQndZc3grd0tsVDl3bFUrZDY0eDQ5Mm4zMS9mcFR5WnRwbTNXOEpCWWJH?=
 =?utf-8?B?VUJ2aUVMUWVvRFZiai9TVU53R3p5Mm81OFhaUHk5Sk55VmxTVGhWTWpvYSts?=
 =?utf-8?B?RDhBSzdNbjBDcjZ5a0ZabTZlUDhnb2ZYS2NranFKOHBhQUptcVFyeVN1VXFq?=
 =?utf-8?B?SUpSNDgwS3NLcHEyNExPdWVaWGIrcWVLcGRuSTg2aG5QZTNWRktJd1c1V1RC?=
 =?utf-8?B?N3BMNExUb2hVaXluU0xza2xnV1plQ2phMmI0S0tkYjIxTWljUGx5WXF2ZUNQ?=
 =?utf-8?B?aW5Ud1dwMEliNmJSUFhhODJzNDEwQmJ6MzFycE5ibWxVUmhMd21sSHRMblkx?=
 =?utf-8?B?MFZ1SndaL1VSMXRmS2F0aUdFOXFYZVMwOHdNb1AzeEM0TVN0R1BPMU93bGFJ?=
 =?utf-8?B?VnIxU09Sd3BKNVkxYXZKL2NGNmpGWU9QbWZpZHpwOWtXUzR2RzNlN2pzaUpS?=
 =?utf-8?B?dlNkRURPRnE1c2RxWDl5dEIvRVhjY2R0cXVvR2tYWmlVaHRGOTE0by8yZE9i?=
 =?utf-8?B?M1pDbkJOZXZjZTdieDJkVG1rbUxQUkIveXRqZTF6NUZmUmxSRENrbDNGOWVx?=
 =?utf-8?B?RUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F4324EF08B7E341927FFB69F4C953C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684bca0b-1d41-4724-6b2d-08db298ae289
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 21:34:28.5470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R9+SVU8orB3OzmJvWsQsBYVj6dufn3MTHlSkroxIWqrrU2a7Hmz88Mh5coKTBSQosXdq0WhIsTVyFt3Mx3morw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5205
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTIwIGF0IDE0OjQ3ICswMTAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
PiBPbiAyMC4wMy4yMyAxMzo1OSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMjMt
MDMtMDYgYXQgMTc6MzQgKzAxMDAsIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+ID4gPiBXaGVuIHJ1
bm5pbmcgdmlydHVhbGl6ZWQsIE1UUlIgYWNjZXNzIGNhbiBiZSByZWR1Y2VkIChlLmcuIGluIFhl
biBQVg0KPiA+ID4gZ3Vlc3RzIG9yIHdoZW4gcnVubmluZyBhcyBhIFNFVi1TTlAgZ3Vlc3QgdW5k
ZXIgSHlwZXItVikuIFR5cGljYWxseQ0KPiA+ID4gdGhlIGh5cGVydmlzb3Igd2lsbCByZXNldCB0
aGUgTVRSUiBmZWF0dXJlIGluIENQVUlEIGRhdGEsIHJlc3VsdGluZw0KPiA+ID4gaW4gbm8gTVRS
UiBtZW1vcnkgdHlwZSBpbmZvcm1hdGlvbiBiZWluZyBhdmFpbGFibGUgZm9yIHRoZSBrZXJuZWwu
DQo+ID4gPiANCj4gPiA+IFRoaXMgaGFzIHR1cm5lZCBvdXQgdG8gcmVzdWx0IGluIHByb2JsZW1z
Og0KPiA+ID4gDQo+ID4gPiAtIEh5cGVyLVYgU0VWLVNOUCBndWVzdHMgdXNpbmcgdW5jYWNoZWQg
bWFwcGluZ3Mgd2hlcmUgdGhleSBzaG91bGRuJ3QNCj4gPiA+IC0gWGVuIFBWIGRvbTAgbWFwcGlu
ZyBtZW1vcnkgYXMgV0Igd2hpY2ggc2hvdWxkIGJlIFVDLSBpbnN0ZWFkDQo+ID4gPiANCj4gPiA+
IFNvbHZlIHRob3NlIHByb2JsZW1zIGJ5IHN1cHBvcnRpbmcgdG8gc2V0IGEgc3RhdGljIE1UUlIg
c3RhdGUsDQo+ID4gPiBvdmVyd3JpdGluZyB0aGUgZW1wdHkgc3RhdGUgdXNlZCB0b2RheS4gSW4g
Y2FzZSBzdWNoIGEgc3RhdGUgaGFzIGJlZW4NCj4gPiA+IHNldCwgZG9uJ3QgY2FsbCBnZXRfbXRy
cl9zdGF0ZSgpIGluIG10cnJfYnBfaW5pdCgpLiBUaGUgc2V0IHN0YXRlDQo+ID4gPiB3aWxsIG9u
bHkgYmUgdXNlZCBieSBtdHJyX3R5cGVfbG9va3VwKCksIGFzIGluIGFsbCBvdGhlciBjYXNlcw0K
PiA+ID4gbXRycl9lbmFibGVkKCkgaXMgYmVpbmcgY2hlY2tlZCwgd2hpY2ggd2lsbCByZXR1cm4g
ZmFsc2UuIEFjY2VwdCB0aGUNCj4gPiA+IG92ZXJ3cml0ZSBjYWxsIG9ubHkgZm9yIHNlbGVjdGVk
IGNhc2VzIHdoZW4gcnVubmluZyBhcyBhIGd1ZXN0Lg0KPiA+ID4gRGlzYWJsZSBYODZfRkVBVFVS
RV9NVFJSIGluIG9yZGVyIHRvIGF2b2lkIGFueSBNVFJSIG1vZGlmaWNhdGlvbnMgYnkNCj4gPiA+
IGp1c3QgcmVmdXNpbmcgdGhlbS4NCj4gPiA+IA0KPiA+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4g
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvZ2VuZXJpYy5jIGIvYXJj
aC94ODYva2VybmVsL2NwdS9tdHJyL2dlbmVyaWMuYw0KPiA+ID4gaW5kZXggZWUwOWQzNTllMDhm
Li40OWI0Y2M5MjMzMTIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L210
cnIvZ2VuZXJpYy5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvZ2VuZXJp
Yy5jDQo+ID4gPiBAQCAtOCwxMCArOCwxMiBAQA0KPiA+ID4gICAjaW5jbHVkZSA8bGludXgvaW5p
dC5oPg0KPiA+ID4gICAjaW5jbHVkZSA8bGludXgvaW8uaD4NCj4gPiA+ICAgI2luY2x1ZGUgPGxp
bnV4L21tLmg+DQo+ID4gPiAtDQo+ID4gPiArI2luY2x1ZGUgPGxpbnV4L2NjX3BsYXRmb3JtLmg+
DQo+ID4gPiAgICNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLWZsYWdzLmg+DQo+ID4gPiAgICNpbmNs
dWRlIDxhc20vY2FjaGVpbmZvLmg+DQo+ID4gPiAgICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5o
Pg0KPiA+ID4gKyNpbmNsdWRlIDxhc20vaHlwZXJ2aXNvci5oPg0KPiA+ID4gKyNpbmNsdWRlIDxh
c20vbXNoeXBlcnYuaD4NCj4gPiANCj4gPiBJcyA8YXNtL21zaHlwZXJ2Lmg+IG5lZWRlZCBoZXJl
Pw0KPiANCj4gWWVzLCBmb3IgaHZfaXNfaXNvbGF0aW9uX3N1cHBvcnRlZCgpLg0KPiANCj4gPiAN
Cj4gPiA+ICAgI2luY2x1ZGUgPGFzbS90bGJmbHVzaC5oPg0KPiA+ID4gICAjaW5jbHVkZSA8YXNt
L210cnIuaD4NCj4gPiA+ICAgI2luY2x1ZGUgPGFzbS9tc3IuaD4NCj4gPiA+IEBAIC0yNDAsNiAr
MjQyLDQ4IEBAIHN0YXRpYyB1OCBtdHJyX3R5cGVfbG9va3VwX3ZhcmlhYmxlKHU2NCBzdGFydCwg
dTY0IGVuZCwgdTY0ICpwYXJ0aWFsX2VuZCwNCj4gPiA+ICAgCXJldHVybiBtdHJyX3N0YXRlLmRl
Zl90eXBlOw0KPiA+ID4gICB9DQo+ID4gPiAgIA0KPiA+ID4gKy8qKg0KPiA+ID4gKyAqIG10cnJf
b3ZlcndyaXRlX3N0YXRlIC0gc2V0IHN0YXRpYyBNVFJSIHN0YXRlDQo+ID4gPiArICoNCj4gPiA+
ICsgKiBVc2VkIHRvIHNldCBNVFJSIHN0YXRlIHZpYSBkaWZmZXJlbnQgbWVhbnMgKGUuZy4gd2l0
aCBkYXRhIG9idGFpbmVkIGZyb20NCj4gPiA+ICsgKiBhIGh5cGVydmlzb3IpLg0KPiA+IA0KPiA+
ICtLVk0gbGlzdCBhbmQgS1ZNIG1haW50YWluZXJzLA0KPiA+IA0KPiA+IElJVUMgaW4gdGhlIG5l
eHQgcGF0Y2gsIFNFVi1TTlAgZ3Vlc3Qgb25seSBzZXRzIGEgc3ludGhldGljIE1UUlIgdy9vIHRl
bGxpbmcgdGhlDQo+ID4gaHlwZXJ2aXNvciAoaHlwZXJ2KS4gIEkgdGhpbmsgdGhpcyB3b3JrcyBm
b3IgU0VWLVNOUCBydW5uaW5nIG9uIHRvcCBvZiBoeXBlcnYNCj4gPiBiZWNhdXNlIHRoZXkgaGF2
ZSBtdXR1YWwgdW5kZXJzdGFuZGluZz8NCj4gPiANCj4gPiBXaGF0IGFib3V0IHRoZSBTTlAgZ3Vl
c3QgcnVubmluZyBvbiBvdGhlciBoeXBlcnZpc29ycyBzdWNoIGFzIEtWTT8NCj4gPiANCj4gPiBT
aW5jZSB0aGlzIGNvZGUgY292ZXJzIFREWCBndWVzdCB0b28sIEkgdGhpbmsgZXZlbnR1YWxseSBp
dCBtYWtlcyBzZW5zZSBmb3IgVERYDQo+ID4gZ3Vlc3QgdG8gdXNlIHRoaXMgZnVuY3Rpb24gdG9v
ICh0byBhdm9pZCAjVkUgSUlVQykuICBJZiB3YW50IHRvIGRvIHRoYXQsIHRoZW4gSQ0KPiA+IHRo
aW5rIFREWCBndWVzdCBzaG91bGQgaGF2ZSB0aGUgc2FtZSBtdXR1YWwgdW5kZXJzdGFuZGluZyB3
aXRoICpBTEwqIGh5cGVydmlzb3IsDQo+ID4gYXMgSSBhbSBub3Qgc3VyZSB3aGF0J3MgdGhlIHBv
aW50IG9mIG1ha2luZyB0aGUgVERYIGd1ZXN0J3MgTVRSUiBiZWhhdmlvdXINCj4gPiBkZXBlbmRp
bmcgb24gc3BlY2lmaWMgaHlwZXJ2aXNvci4NCj4gDQo+IFRoaXMgc2VyaWVzIHRyaWVzIHRvIGZp
eCB0aGUgY3VycmVudCBmYWxsb3V0Lg0KPiANCj4gQm9yaXMgUGV0a292IGFza2VkIGZvciB0aGUg
aHlwZXJ2aXNvciBzcGVjaWZpYyB0ZXN0cyB0byBiZSBhZGRlZCwgc28gSSd2ZQ0KPiBhZGRlZCB0
aGVtIGFmdGVyIGRpc2N1c3NpbmcgdGhlIHRvcGljIHdpdGggaGltIChoZSBpcyB0aGUgbWFpbnRh
aW5lciBvZg0KPiB0aGlzIGNvZGUgYWZ0ZXIgYWxsKS4NCj4gDQo+ID4gRm9yIG5vdyBJIGRvbid0
IHNlZSB0aGVyZSdzIGFueSB1c2UgY2FzZSBmb3IgVERYIGd1ZXN0IHRvIHVzZSBub24tV0IgbWVt
b3J5IHR5cGUNCj4gPiAoaW4gZmFjdCwgS1ZNIGFsd2F5cyBtYXBzIGd1ZXN0IG1lbW9yeSBhcyBX
QiBpZiB0aGVyZSdzIG5vIG5vbi1jb2hlcmVudCBETUEgdG8NCj4gPiB0aGUgZ3Vlc3QgbWVtb3J5
KSwgc28gdG8gbWUgaXQgc2VlbXMgaXQncyBPSyB0byBtYWtlIGEgdW5pdmVyc2FsIG11dHVhbA0K
PiA+IHVuZGVyc3RhbmRpbmcgdGhhdCBURFggZ3Vlc3Qgd2lsbCBhbHdheXMgaGF2ZSBXQiBtZW1v
cnkgdHlwZSBmb3IgYWxsIG1lbW9yeS4NCj4gDQo+IEkgYWdyZWUuDQo+IA0KPiA+IEJ1dCwgSSBh
bSBub3Qgc3VyZSB3aGV0aGVyIGl0J3MgYmV0dGVyIHRvIGhhdmUgYSBzdGFuZGFyZCBoeXBlcmNh
bGwgYmV0d2Vlbg0KPiA+IGd1ZXN0ICYgaHlwZXJ2aXNvciBmb3IgdGhpcyBwdXJwb3NlIHNvIHRo
aW5ncyBjYW4gYmUgbW9yZSBmbGV4aWJsZT8NCj4gDQo+IE1heWJlLiBCdXQgZm9yIG5vdyB3ZSBu
ZWVkIHRvIGhhbmRsZSB0aGUgY3VycmVudCBzaXR1YXRpb24uDQo+IA0KPiANCg0KQWdyZWVkLiAg
VGhhbmtzIGZvciBleHBsYWluaW5nLg0KDQo=
