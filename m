Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF49755DA2
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 09:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjGQH72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 03:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjGQH7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 03:59:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B238693;
        Mon, 17 Jul 2023 00:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689580763; x=1721116763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9AeGFD2VDAfL3TAZP39AE5IYI3HjvVGspuiKt6HHf+M=;
  b=bLH48+Os7n74F8tlvwODwKPz6N4hkk1hQOS9OXMCOpfiY+HM/BLCxWGy
   ceMncuzWQa8Tr/X+0DN/P+fNR6a/ZgS7DHgd6/ZmVPqEXyoe+tSruU/du
   t1qjE0+PauZZMmeEnRo1Qim0ugGDuWM/vgfXSwVB8AN09By0d+FfmEQGO
   JOSzrSX6MgCTIX3nXdCq40oQBhu0GaBENY4EoPmBibiggCaTHhOV31eF0
   sx1BkA8fjc2Lid4NWY5RJgH9uAsy52eA91cWuaG+iMCq+h+kPB7TemZNZ
   yOZidpe8jXZIMZqUg+2ifmO8JhzrnzqA92QuUg3DyjNUI+cNbb7+NZYBR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="350734005"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="350734005"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 00:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="700418383"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="700418383"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 17 Jul 2023 00:59:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 00:59:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 17 Jul 2023 00:59:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 17 Jul 2023 00:59:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 17 Jul 2023 00:59:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MarlgtQaU/QngV/Ub3UwkvXayQc67F5yKVhY+ud5fKz+hFCWohp3n850Yr4Hh6Z2bx/lcfE7iQr2n+grEoiRzMurstWdiBINi6v4HGTfbI7slrea2Yy4fIgh0+n3etYS2Reh5bHZNbbZLltkOCrAFvQv7Gjp9g7aZvqvO1GcWbNJyaNzOe6fW4t9ZDoNEdXQahFI1XNRPW9O23KqeDyXFRsBBwY4wNhujPCdLu4gvPT+FWlgB7U3ZPIN3wCwD0FFX7r48xfLHtBteoiBXeK13X0N5b3yWWg6s1WRD1Kf4icX92qv7l1ixWBADjxUr7snRfcgzzL0yPYFOg8NHfdLLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AeGFD2VDAfL3TAZP39AE5IYI3HjvVGspuiKt6HHf+M=;
 b=OdFyowPzHHVj569sEYtm75XKr4Z+U9NAyDo2yb0pNdWFo7ZugLSBxlH9jyPzFK104NNdCgdSbTOITwkZRLAkKJrohcA/Ec2fkBWvHA4DRlmIfkPi0uFmnCwNx1OHYh85923QkCU7c4bvseWhUQK82KAvzxVc87KO69mmSIR9oyv3/IYygjk8xTC9jPhdoVJfMzls6FMPXoSbhB1lRqwfbHW5q3TFfL62LgXYctITnNmMNOhLsuBKrqFRhWLk1jTmCATEj5nRxeZO6oUqtdojw8XggoXybrh1LzzTQK87JUd9q6Q7KZcMQUGmw//RsMpAcFxt+pLmzIFA2+O+pwK8Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7900.namprd11.prod.outlook.com (2603:10b6:930:7a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 07:59:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3729:308d:4f:81c8%3]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 07:58:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: RE: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Topic: [PATCH 08/10] x86/tdx: Unify TDX_HYPERCALL and TDX_MODULE_CALL
 assembly
Thread-Index: AQHZtJ1x/DXmlypIv0ScbAwPZVWO1q+6np8AgALp8gCAAAdfgIAAD7Kg
Date:   Mon, 17 Jul 2023 07:58:59 +0000
Message-ID: <BL1PR11MB59788B70FC74249D9F45E066F73BA@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1689151537.git.kai.huang@intel.com>
 <c22a4697cfe90ab4e1de18d27aa48ea2152dbcfa.1689151537.git.kai.huang@intel.com>
 <b95c4169-88c8-219e-87b7-6c4e058c246a@suse.com>
 <71396c8928a5596be70482a467e9ba612286d659.camel@intel.com>
 <6b425468-3aac-0123-c690-df8d750ce29e@suse.com>
In-Reply-To: <6b425468-3aac-0123-c690-df8d750ce29e@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7900:EE_
x-ms-office365-filtering-correlation-id: 6c25f302-ef2c-471e-2133-08db869badba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBjHmozhpJuFsyH+atXHTg9/LF3s/0ZIakG5XdTRk//f/BY7U61AqyiLCArw6ZL4e6D25gcYIOqwakpL1M8SKQ3QNaDegl8ezOaEfOK2LXVJECkssm+sJacfyPpznqgMuFb8CftwKqrvHiHc71wVPPddE8nh6TeOtPzE5h4IBQfyHlq8VSBjzFCrFd4/mxHB6LJ5pyC/3Ceh4G/sieFFZOkAN/YutCHfhOOj4xaxJzG30uRtxvN3OwDLZ9KxvKVZeePI0NWHtCflWrYIW2Mio6pMew0iV2Vw3zndW9VAg8LxktfApMhZ+IoHME8QkceX5i656AmtBlZZvr+whaQU3V8fl5yX2iKwjDBkh/M26OK+vJB6WrMsry5tpUEyD4VLEAMbplMpsDh+I+qBjrLhOtvnnh4CCT++ua3ucoDwQMDX5qga/pYv8hnWfND5ZAJmNz5pcuMNdLJNI53tBC5Kkun7QvRU64N5Qdhsxyw3wLlLCKjPB5FpUMXjZqhviMnkbJkZgoqhfq55A0qpuOQ7OErfAH0fMMy8oUwOwPuSZzV5mCvANJGsf9gvBc7zwyK+durGdR+pxxrsHD/nS+c3nmxx6yXpWXaUtwINAt6+lcr+PSnA77nE3HcEJGzMNVet
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(478600001)(71200400001)(7696005)(110136005)(54906003)(186003)(6506007)(26005)(9686003)(316002)(76116006)(2906002)(41300700001)(64756008)(52536014)(4326008)(66556008)(66946007)(66476007)(66446008)(5660300002)(7416002)(8676002)(8936002)(38100700002)(122000001)(82960400001)(86362001)(38070700005)(83380400001)(55016003)(33656002)(66899021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2d1Z0lJME40QUxWUG5URGZsUTFENzNPa3MxM3k2M1B6b0Q1Y1lCckYzY2Vu?=
 =?utf-8?B?WHdFcHhPQUF1ZWdySEI4RHNzS21maGtWd3VOc3FJbWJhVVMyeVBhQ01pWnVa?=
 =?utf-8?B?cjNZNDE5Sy9YRGVBR3hYdWp4NjNKRlhOZzZ1R0NLRHZ6VDE4ZU5jdXN6ODNP?=
 =?utf-8?B?Q3JFbDdzVHR6YWlSRHZxWnRxYmNuL2tSdWQrN2lTdmh2OFZSUy9MRk94cEJR?=
 =?utf-8?B?Q0xJT3B3Q244azhrUTJQMjNrWmE0eUVtYSswVjFEMC9yKytZNFk0Z2x2aXdp?=
 =?utf-8?B?cGRnMW1LdEI0QklNR1RpL1NkcjNTdEMyemNYbFlqWjQ0SzNlSjV6QzNxVHlG?=
 =?utf-8?B?QXhZaFA4UjFBTkR1TDE5UnkxY1BQenVMUVFEeGY1b3g5dCtXaUpPcm5tbCsy?=
 =?utf-8?B?UUZJQjlCMDBOUWpPR2FSOUNUdDl3bjhndWx0WEZESW1lbHlLdWJSd1M4dHNx?=
 =?utf-8?B?emRKMGRWYmwvTloxSkZ5WDNJYkRMZFlZUWMxRjVaRnRod2xKNURxOFBkcEQ4?=
 =?utf-8?B?NngxNEx2SnpoTTZIZEZ3bHVkVE8rMVpldi9kOEV4UFZ3aGZNTnZQZ01lbTcz?=
 =?utf-8?B?SEVGZXQ4NXZwLzBXRXo3eU9VN3M0NWRqVFR3Zkl6bEtDUWREMzJ1WEFPdkdW?=
 =?utf-8?B?NStadGRuU2pLWGhCUTBuenZuTExZQ2kybit5ZUZOZUszOXI1bFJkcFFUVlRz?=
 =?utf-8?B?VlZyVElHcjdPUmxuUnBIUmdKdUVxK3Fna2J0YzlYRHdwZGoxenNQQ2lFQ1Vk?=
 =?utf-8?B?QURyN205Wk9oSWYraXkzS3dXNHZqT2poekZkbDRyL3NEbzQ3dS9yOFZQYjdZ?=
 =?utf-8?B?SytCbW42MlBFVUFQaTdwL0ppc1RXaFRSQms4Q09hdmJNdVBlVWtzOGtNZGxh?=
 =?utf-8?B?MEFiS0lQZDdlaUJrYzh3NkZnTWJobGZhRVV5cE5zWlpOb0pkbFVjY2EvOHRx?=
 =?utf-8?B?eGMyZHJqM2Rpdk5NeWR2THNBWDczOTgzdlM5R0ZiUXEwQXlyNFNFVi9LNXpw?=
 =?utf-8?B?MzkyazN5TTJudkVSNWgxNVBJeVRWNStweUhqclE2UDFzUUtpejllaTAwY3E3?=
 =?utf-8?B?V2hMSUliMU5DRjIxM2E2ajE0OTB2Yk9uRldDK0w4U1FlbkxHcXllYVRPU01W?=
 =?utf-8?B?WHl4UVZYR1VLK0NpVm1mMEhJaDNUMk1Ba1NiWjA1YnRoOXhnMnpIS2VPUE9r?=
 =?utf-8?B?ZEZmMnByUTJTT0NhdjRtMWZyZ0lNZ1crSTMwY2ZFZldVR3FwbTNwS1g3c0Uw?=
 =?utf-8?B?UFVBR0lsQ1hRYlQxckVxdU1jZ09RRFZyZmo5QW5IREVJZkgwRnpVbk1OSlZl?=
 =?utf-8?B?eDVGNGxLc0hJNzcrbFZ2bCtJbWJvaFBFNFZxa1RmVi9BbCtZT01tNE9DT29U?=
 =?utf-8?B?L0JwWnZyK2NVRXgvOVZKT1VrNyswMU5reEFPYjNLRkRGSnFSMExHbjdPcDdj?=
 =?utf-8?B?NjN4bzRLcU1SL2E5R1BITUsxTEdtK0R6cmxhMzd5NlA3dVNlVmJPRFA5QWp0?=
 =?utf-8?B?VVQwd1Blam9hYjA3aTl3TnFDTTBWV1lwY0dadzhPUU0waWlGY085TzFlNkg5?=
 =?utf-8?B?VC96eWV3STF1dVlOOGFkWGxrTnRXMm9rUk9PMDVaUXk1cmh3VkVHM0FDQVNl?=
 =?utf-8?B?NGJVa1BjTVhSd21WTk5zK0lqMlBwN3ltVitpTnFMZSsxU0pnZm9vRzMvZ2VB?=
 =?utf-8?B?dmZwRStqcTJiSG4xTmxQbi80aFArVlpGSUwxdFF3S2pZcXZ3ZEM0dTdZVnRC?=
 =?utf-8?B?azQvdzJXV2xiQVFJV0tDTkF1U2Y5TERBUElFV1VwMEJmR1dNREdnM1l4Mk5n?=
 =?utf-8?B?YmdWQVNYUE1tMXJpWHdyZ3B5MWIxT2tnMVFzVUN5UHVLc2dKTXJQNEkrOXYr?=
 =?utf-8?B?MEZ5SXpIQ3lEdndSRG0wNnpISFNFcmpPNEhMLzM3T1VEWDBMd2kxQzNQMW14?=
 =?utf-8?B?L0dtOHZYQnIzbHpWQjJHajEzelBGQXZCdEN1dXk0L0lYU1ZIWjh1YThiZ01y?=
 =?utf-8?B?S2Nmd0RyYnF6VmZVdzBjZU5uSGlBSDFQZS9YMDNRV0NpSUk0WnRKendZVTM1?=
 =?utf-8?B?WkFhMGNvaGZhMDIyODJMT3VIRjFlUWhjSEp5ZG16MGJ4dVBJRWFoRDJwUS9l?=
 =?utf-8?Q?cWe3EIci5ZUDbNTb9r9kIdQ35?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c25f302-ef2c-471e-2133-08db869badba
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 07:58:59.5711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JmF+BsB53AqKQSWoBKJjCtnM5q6vKilBzcH/q9gTA+EaBaumKwY0dqfACTdwNE2z6Xwc5JNqDK/EQiOedq5mWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7900
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxNy4wNy4yMyDQsy4gOTozNSDRhy4sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4NCj4gPj4+
ICsvKiBDYWxsZWQgZnJvbSBfX3RkeF9oeXBlcmNhbGwoKSBmb3IgdW5yZWNvdmVyYWJsZSBmYWls
dXJlICovDQo+ID4+PiArc3RhdGljIG5vaW5zdHIgdm9pZCBfX3RkeF9oeXBlcmNhbGxfZmFpbGVk
KHZvaWQpIHsNCj4gPj4+ICsJaW5zdHJ1bWVudGF0aW9uX2JlZ2luKCk7DQo+ID4+PiArCXBhbmlj
KCJURFZNQ0FMTCBmYWlsZWQuIFREWCBtb2R1bGUgYnVnPyIpOyB9DQo+ID4+DQo+ID4+IFNvIHdo
YXQncyB0aGUgZGVhbCB3aXRoIHRoaXMgaW5zdHJ1bWVudGF0aW9uIGhlcmUuIFRoZSBpbnN0cnVj
dGlvbiBpcw0KPiA+PiBub2luc3RyLCBzbyB5b3Ugd2FudCB0byBtYWtlIGp1c3QgdGhlIHBhbmlj
IGNhbGwgaXRzZWxmDQo+ID4+IGluc3RydW1lbnRhYmxlPywgaWYgc28gd2hlcmUncyB0aGUgaW5z
dHJ1bWVudGF0aW9uX2VuZCgpIGNhbDs/Tm8NCj4gPj4gaW5zdHJ1bWVudGF0aW9uX2VuZCgpIGNh
bGwuIEFjdHVhbGx5IGlzIHRoaXMgY29tcGxleGl0eSByZWFsbHkgd29ydGggaXQgZm9yIHRoZQ0K
PiBmYWlsdXJlIGNhc2U/DQo+ID4+DQo+ID4+IEFGQUlDUyB0aGVyZSBpcyBhIHNpbmdsZSBjYWxs
IHNpdGUgZm9yIF9fdGR4X2h5cGVyY2FsbF9mYWlsZWQgc28gd2h5DQo+ID4+IG5vb3QgY2FsbCBw
YW5pYygpIGRpcmVjdGx5ID8NCj4gPg0KPiA+IFcvbyB0aGlzIHBhdGNoLCB0aGUgX190ZHhfaHlw
ZXJjYWxsX2ZhaWxlZCgpIGlzIGNhbGxlZCBmcm9tIHRoZQ0KPiA+IFREWF9IWVBFUkNBTEwgYXNz
ZW1ibHksIHdoaWNoIGlzIGluIC5ub2luc3RyLnRleHQsIGFuZA0KPiA+ICdpbnN0cnVtZW50YXRp
b25fYmVnaW4oKScgd2FzIG5lZWRlZCB0byBhdm9pZCB0aGUgYnVpbGQgd2FybmluZyBJIHN1cHBv
c2UuDQo+ID4NCj4gPiBIb3dldmVyIG5vdyB3aXRoIHRoaXMgcGF0Y2ggX190ZHhfaHlwZXJjYWxs
X2ZhaWxlZCgpIGlzIGNhbGxlZCBmcm9tDQo+ID4gX190ZHhfaHlwZXJjYWxsKCkgd2hpY2ggaXMg
YSBDIGZ1bmN0aW9uIHcvbyAnbm9pbnN0cicgYW5ub3RhdGlvbiwgdGh1cw0KPiA+IEkgYmVsaWV2
ZQ0KPiA+IGluc3RydW1lbnRhdGlvbl9iZWdpbigpIGFuZCAnbm9pbnN0cicgYW5ub3RhdGlvbiBh
cmUgbm90IG5lZWRlZCBhbnltb3JlLg0KPiA+DQo+ID4gSSBkaWRuJ3Qgbm90aWNlIHRoaXMgd2hp
bGUgbW92aW5nIHRoaXMgZnVuY3Rpb24gYXJvdW5kIGFuZCBteSBrZXJuZWwNCj4gPiBidWlsZCB0
ZXN0IGRpZG4ndCB3YXJuIG1lIGFib3V0IHRoaXMuICBJJ2xsIGNoYW5nZSBpbiBuZXh0IHZlcnNp
b24uDQo+ID4NCj4gPiBJbiBmYWN0LCBwZXJoYXBzIHRoaXMgcGF0Y2ggcGVyaGFwcyBpcyB0b28g
YmlnIGZvciByZXZpZXcuICBJIHdpbGwNCj4gPiBhbHNvIHRyeSB0byBzcGxpdCBpdCB0byBzbWFs
bGVyIG9uZXMuDQo+IA0KPiBDYW4ndCB5b3Ugc2ltcGx5IGNhbGwgcGFuaWMoKSBkaXJlY3RseT8g
TGVzcyBnb2luZyBhcm91bmQgdGhlIGNvZGUgd2hpbGUgc29tZW9uZQ0KPiBpcyByZWFkaW5nIGl0
Pw0KDQpJIGNhbiBhbmQgd2lsbCBkby4NCg==
