Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FC3634BB1
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 01:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiKWAbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 19:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiKWAbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 19:31:05 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D216EC6567;
        Tue, 22 Nov 2022 16:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669163464; x=1700699464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hCtDwL9m+P+nX6Fp/auhOaBc8RomBoLhIHt/3UFPLXU=;
  b=Iehig3OuF2mhFEk0K92BI11DYp8g3iFFruRa4UdC0m1VM+FvnsTvw8FB
   hZj4fAGSo9vseGvdGmnjXKCLYbGLBPOL7NZpyX9CeXP4djQfW2OYcgkgx
   izu9XxaSM/ksp9LwUu46Br43DVMtytpvBSOdAYcHzd0Zf5nvAIsN4RSyn
   n+m+wJ8cWwLFGrXEXbOmrmUW6FeGuqP0BNwoC7IbLgHHcatz1AiPLvLhs
   lisjPt49+cbwO9Hmrv4IAeHuIy/LHhjRW4/rHEfNzDuFyUsbL3fJzoIAm
   cd2OetouiypecejJMVGzpZSCh8qouhoIEu4TXdcGgHP+mWrXRH7mO0NiZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315099852"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="315099852"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 16:31:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="766522183"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="766522183"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 22 Nov 2022 16:31:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 16:31:03 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 16:31:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 16:31:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 16:31:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVTA8jScmea0trY+QgvHFmsDDlHjzPQDMXZieVOEYqXEPrdYNUPIxreQx0rGkL3CAzjHt7iOb9+Jv1ih8SM/AHM8OhW1vIna4MklVAZGoyn+6mqDy0+3kgPwdIzOszrPzibTbj6AW0c0uF7o+zp4M8SmHJUsv3C1WtE911APpXcjrGyp51j+VaszQDzXmi43aeawVcJVsaDmuwRORwJHCr01/aPtU5F++8TYnIIQ3gGtw/ubIRp4G+NahB2jV3nBYtjMciYzF9sVPvoG2dElUlaqo6RxvAEbX7c63IAYg3bUeO/QVI9dODraKV0OcJseotpt83H2RbRlTrd+StYJeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCtDwL9m+P+nX6Fp/auhOaBc8RomBoLhIHt/3UFPLXU=;
 b=QMzSb7HYukpRO2EvctDqV3mUE2Z+lT9Nff8z4vsy5FSRjNYh7rDUpLpKSEmSyjCy0JiGDxowDS27bZbe6kWcZkchGiSZAZLNiXDaYA+IT/qJ/j6vAvNKPI7o8AZjDtW/I3MB2VF0NQ4UlyxgrDCs+VS8D8FLFzSohCWZbHvfeD/foUx8olb7lZGEDiAO4pzG/lCTxW3NBlJ+GiaFYjXCFVYZiK41dE6MUa3lJSsqF7FzE2u7cd71SroffvLhR7d4K++AgGNIMhfPUDdQsq84nRZEPt8dl0rzuXm9Q+jVwveUF5xkGkQRawz0SENc0cmAFq7mYpHe2Z0OmumKb6MHXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6108.namprd11.prod.outlook.com (2603:10b6:a03:489::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 00:30:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 00:30:59 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v7 04/20] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHY/T29USV2IuUHCEyPQthCEbaZH65Kp9QAgAAYugCAAFUUgIAASuaAgABKsYA=
Date:   Wed, 23 Nov 2022 00:30:58 +0000
Message-ID: <246a4eaac29855c522bd26627b03418cb7ead66f.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <d26254af8e5b3dcca8a070703c5d6d04f48d47a9.1668988357.git.kai.huang@intel.com>
         <Y3yQKDZFC8+oCyqK@hirez.programming.kicks-ass.net> <87edtvgu1l.ffs@tglx>
         <19d93ff0-df0d-dc9d-654b-a9ca6f7be1d0@intel.com> <87mt8ig3ja.ffs@tglx>
In-Reply-To: <87mt8ig3ja.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6108:EE_
x-ms-office365-filtering-correlation-id: b08a178f-cb81-489e-66b8-08dacce9fe19
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SpxV8LjbJBigcLzcZIDrB6oUJfUFsJ8YhjLsyRyqJefTOkceNcFXD6LiW+ExhBRl2drx/sSOE7e8AwaLPz+8G9VWuwm9N4mJsX+CWs2QtW+3SOZwExPM8HuMG26hCx/dAoLXbW7+AIvumlnSXMO1l0XMIIMyrDEfw/VzeNK/g8GDwgmZ5dPvg/fWzA9KAxtMgv5TMaA63xXUYPinMamgjfLzrBuNibrxZEOU/HNWLWyWjVzVBGUB1c8m3SEHiYy3q3sc9gKhHfLtS7tOBosjC/jH0mDlx2KJ1L15uVdq9Emu5rph9HIevkWgTOnPdIMoT0fS9O7oF1UnUX4I+Oq1R1acHxRtZRqMOaHuCMyyOJOg3br3NDnVjV8z7rjzu9n4lEqHJpyYo6TpiMg1JebzWg0RQ36ZjhBq4ZeqwGlUInK82sklEHPyKFfHMesdkXLbjugOtSw1qNgb6nkXak1lQd9u0KjwIfPWo+pdIi9955lhZdbV5RHWLbMKunXdiKpqBH2c0jHOOKRrscTWPD2z2pxTlIqLngT8eNxBYuszr6K3YnU4aRv2r4STt5DF48wLjgzjNsKhP5skkyeDozRKIbAsVhH5QqoTE7tl0zFYPitonsyPZD7CRXcy4NO4KEiKdu4W4NyM0fAwXxA2CUGqUgV+na2W+NDrBSx3Paif1VDwKoRCcfVTobs2d7rsNQ4dHRFLfGYu+zIgl77VB8FYhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199015)(6512007)(2616005)(83380400001)(82960400001)(122000001)(76116006)(64756008)(2906002)(186003)(26005)(38100700002)(4001150100001)(7416002)(5660300002)(71200400001)(6506007)(66556008)(54906003)(6486002)(41300700001)(8676002)(316002)(66946007)(478600001)(66446008)(8936002)(4326008)(66476007)(6636002)(110136005)(91956017)(36756003)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVlvVFFYQktZOHVYd09KY1ZUd3dVMk55Y2ZaaUNKMjhVOHJlOW5KWGpiN01G?=
 =?utf-8?B?L1ZOekxjQll3THNGc2o0QWVKWWl4Nk5pYlFCNVNRc1djeFRIZFIyMHVycmVo?=
 =?utf-8?B?SkNEUERWRDRtUVVRamVhZE53eUM2blVYb3VwTVJnYUpNR2J2UU5McHNFcFFV?=
 =?utf-8?B?Zmp4dnRsTE84ZExxWWpYV2dxL3BRMG8rcUZQVCs1MWN6dWI0eFg0dTBKcVZo?=
 =?utf-8?B?T1hsWnFNTVdpdmUyaXFVdFRsaGphdnFkUEpOM3hVNkovNlZ4R1ROclRhNTFI?=
 =?utf-8?B?UTl3NERXY2h6Z1pOdDV6bWllTHgvN0o3M21XR2d5TTF5R3d1N2w3Uks2Z0cz?=
 =?utf-8?B?WHZJUmthODFiZUlaZ1hvS3VQbHFma3pLdjVCQS94eE02OW13dks3TW9USVBD?=
 =?utf-8?B?WHQrSGZDYzFudXVrYVBpeGYxSTZjdFlFcmdBMk41SkhPUHVVUldNYVdsVEx5?=
 =?utf-8?B?eVVIQ1o0dms5Zjg5YW5TOTRWakFsT080V0pYMW1ZbXFyNnh2TXp3OHV2MnBu?=
 =?utf-8?B?NkJ2RFdqZmNPbEpwbG9meEM3NjZDQy9zdG9hTXMyZU5qYkl1U2VxaFV4Ry80?=
 =?utf-8?B?Yks3Q1NsdnMweE1zbEFMYk92ZmdtVVdhUW9yWUY2dFhmcEtpbHA5K2ttc2tH?=
 =?utf-8?B?MVNWaFdIRUwrOFJOT0x0S0VUZFo2RDE4OWVjTGU5N1V6aHBzbkpHejNxa011?=
 =?utf-8?B?N00vL2ZkeG9Jbk1ob0Zya2R0MWticFJvOXRSRkRwOFNUbDBVT0l1K3V2alQ4?=
 =?utf-8?B?SFE1YzNFd3BsdTFyUkNXM2lxVDdiNVV1eXJDSzJrQVZacnowZGo0WnpDNWp5?=
 =?utf-8?B?NHNRMllkK2ZlOGczaElXK1R6RVN5NVNRWnltYVVhc0lMWWp1UzkwWGtMOCtP?=
 =?utf-8?B?d2Mzc3lRSmVDUG1qa0dmVFhwZnNKdTYvSHIzOTMraXVrT2lUMHZpdHU1UlZR?=
 =?utf-8?B?clBLa2VKaHN3amcxWTF1TnhaNStnQk9UNFRLbjJUdGVoVmlrZmJLTkU1ZklP?=
 =?utf-8?B?M2cyZEl2d1N5cUhxU1AvRUVWcWJQdE9aL3NOMU5GTGlXZEZVUy9Zd2JpdzRJ?=
 =?utf-8?B?SVpobzM3R1ljWDI0ZFJVVjRQT08wUHAyMUlPT25Lc2ZsYVBWWkl0VmoxWEZt?=
 =?utf-8?B?R2hoQWpQYmp4bWgwNWllZE9Rbnh6ZlZ2OTZHRVF5TEtYYU1nU0JzMzJXY2w3?=
 =?utf-8?B?UlVpUUl6eStMZ2U4MGFLOVg2N2ZvREFic1BQTWgwRW55WGFnRmtMY0IxYVR5?=
 =?utf-8?B?aUZlVXNzKzdoeWUweWpnZ2Z1NkphWGVkNUhTakRXYWw2cHB2eHMwcVdneXZX?=
 =?utf-8?B?T0MzWnBNTU1BMmk5Qm9lL01JR1dDNFh3MW1YMHlaOEYrOGxXeGQ3Z2FBSFlT?=
 =?utf-8?B?YU1VblJsQk52a0ZnM0IwR1RjbFE4am5MTzNrem4wVXhWWjZIb2pTVzdncVZD?=
 =?utf-8?B?MWFxb3N5Y1poZUtKaFRpTWlIeTFwN2xJbE1uVlNjMzAyWnhJNHNqS0RteGlB?=
 =?utf-8?B?Tm5TWnA4dGtiRStMK3M2Wk9qNkgybFNMS2hWTlpzbXJXeXU4T25pb1A4SHpx?=
 =?utf-8?B?b0lEV1B2aU55cUNRNmpTZXNJOTJxNlcwWTRTdXA0WnFRdHJhclhvb2paTmth?=
 =?utf-8?B?Y0pkUHkvNEdMMm1vZDJiQ2pvNXc0VXNDV0ZhcGlSZW5CUVFsT3VORFpMMVY3?=
 =?utf-8?B?b3BnYWljNlVSek1qMmdaRkNNSkJROHErYUFKa2hheno0ajM5ZnpNSTFIaUlk?=
 =?utf-8?B?blZmUFNDRXc0eGlDVHFTUko4Zm4vMitpNmNpV0gweDI0MVM5VDdaUXRtZzhi?=
 =?utf-8?B?ZVl5dlhnWmx5aG02S1QxYUhqTjhOeVhoWWUxKzkyaS95SS9WMk5vMlVtUXEr?=
 =?utf-8?B?V0hlZDk3a0RPYU5RTEorN3FHdGI1bFZTT3lQNEo3Zk1WR29vQWREempXM0pF?=
 =?utf-8?B?NDJMK1oxa1UyUU9kSnBUYXdRVXpsYkVBZjVIL2RzNEpPcStuRXJ6VEF3cWM3?=
 =?utf-8?B?M1ljSjR3cGxzR2l6bEE1QnMzTWhvRTBXR0EwbktqclFYZGN0anVpSG1ES1BM?=
 =?utf-8?B?VUdpVnlpdUhmWkFPeUFJMnI3aHNZRTRnQW8wUEJjV2pjQUhnbHFnaDIzMWxx?=
 =?utf-8?B?b1QvKzRTT2RRNUxwM0xHL3BFRmRzWFZ6S3d1MnpJV3RvRGllcUJVWUpxMU9q?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C5FCDB32EC81741987C1A481E156E12@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08a178f-cb81-489e-66b8-08dacce9fe19
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 00:30:58.8714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OrwNUpA4IZBJA9KFfocr1z7qU5/Pf100KmCQ2ImC0/Er0PLk3328cbYjV5PtkJELZnq89s+JFJx/coloDO5gVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDIxOjAzICswMTAwLCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+ID4gPiDCoMKgwqDCoCBpZiAodGR4X2dsb2JhbF9kYXRhX3B0ci0+bnVtX29mX2luaXRfbHBz
IDwgdGR4X2dsb2JhbF9kYXRhX3B0ci0NCj4gPiA+ID5udW1fb2ZfbHBzKQ0KPiA+ID4gwqDCoMKg
wqAgew0KPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCBURFhfRVJST1IoIk51bSBvZiBpbml0aWFsaXpl
ZCBscHMgJWQgaXMgc21hbGxlciB0aGFuIHRvdGFsIG51bSBvZg0KPiA+ID4gbHBzICVkXG4iLA0K
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB0ZHhfZ2xvYmFs
X2RhdGFfcHRyLT5udW1fb2ZfaW5pdF9scHMsDQo+ID4gPiB0ZHhfZ2xvYmFsX2RhdGFfcHRyLT5u
dW1fb2ZfbHBzKTsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqAgcmV0dmFsID0gVERYX1NZU19DT05G
SUdfTk9UX1BFTkRJTkc7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gRVhJVDsNCj4gPiA+
IMKgwqDCoMKgIH0NCj4gPiANCj4gPiB0ZHhfZ2xvYmFsX2RhdGFfcHRyLT5udW1fb2ZfaW5pdF9s
cHMgaXMgaW5jcmVtZW50ZWQgYXQgVERILlNZUy5JTklUDQo+ID4gdGltZS7CoCBUaGF0IGlmKCkg
aXMgY2FsbGVkIGF0IFRESC5TWVMuQ09ORklHIHRpbWUgdG8gaGVscCBicmluZyB0aGUNCj4gPiBt
b2R1bGUgdXAuDQo+ID4gDQo+ID4gU28sIEkgdGhpbmsgeW91J3JlIHJpZ2h0LsKgIEkgZG9uJ3Qg
c2VlIHRoZSBkb2NzIHRoYXQgYWN0dWFsbHkgKmV4cGxhaW4qDQo+ID4gdGhpcyAieW91IG11c3Qg
c2VhbWNhbGwgYWxsIHRoZSB0aGluZ3MiIHJlcXVpcmVtZW50Lg0KPiANCj4gVGhlIGNvZGUgYWN0
dWFsbHkgZW5mb3JjZXMgdGhpcy4NCj4gDQo+IEF0IFRESC5TWVMuSU5JVCB3aGljaCBpcyB0aGUg
Zmlyc3Qgb3BlcmF0aW9uIGl0IGdldHMgdGhlIHRvdGFsIG51bWJlcg0KPiBvZiBMUHMgZnJvbSB0
aGUgc3lzaW5mbyB0YWJsZToNCj4gDQo+IHNyYy92bW1fZGlzcGF0Y2hlci9hcGlfY2FsbHMvdGRo
X3N5c19pbml0LmM6DQo+IA0KPiDCoMKgwqAgdGR4X2dsb2JhbF9kYXRhX3B0ci0+bnVtX29mX2xw
cyA9IHN5c2luZm9fdGFibGVfcHRyLQ0KPiA+bWNoZWNrX2ZpZWxkcy50b3RfbnVtX2xwczsNCj4g
DQo+IFRoZW4gVERILlNZUy5MUC5JTklUIGluY3JlbWVudHMgdGhlIGNvdW50IG9mIGluaXRpYWxp
emVkIExQcy4NCj4gDQo+IHNyYy92bW1fZGlzcGF0Y2hlci9hcGlfY2FsbHMvdGRoX3N5c19scF9p
bml0LmM6DQo+IA0KPiDCoMKgwqAgaW5jcmVtZW50X251bV9vZl9scHModGR4X2dsb2JhbF9kYXRh
X3B0cikNCj4gwqDCoMKgwqDCoMKgIF9sb2NrX3hhZGRfMzJiKCZ0ZHhfZ2xvYmFsX2RhdGFfcHRy
LT5udW1fb2ZfaW5pdF9scHMsIDEpOw0KPiANCj4gRmluYWxseSBUREguU1lTLkNPTkZJRyBjaGVj
a3Mgd2hldGhlciBfQUxMXyBMUHMgaGF2ZSBiZWVuIGluaXRpYWxpemVkLg0KPiANCj4gc3JjL3Zt
bV9kaXNwYXRjaGVyL2FwaV9jYWxscy90ZGhfc3lzX2NvbmZpZy5jOg0KPiANCj4gwqDCoMKgIGlm
ICh0ZHhfZ2xvYmFsX2RhdGFfcHRyLT5udW1fb2ZfaW5pdF9scHMgPCB0ZHhfZ2xvYmFsX2RhdGFf
cHRyLQ0KPiA+bnVtX29mX2xwcykNCj4gDQo+IENsZWFybHkgdGhhdCdzIG5vd2hlcmUgc3BlbGxl
ZCBvdXQgaW4gdGhlIGRvY3VtZW50YXRpb24sIGJ1dCBJIGRvbid0DQo+IGJ1eSB0aGUgJ2FyY2hp
dGVjdHVyYWx5IHJlcXVpcmVkJyBhcmd1bWVudCBub3QgYXQgYWxsLiBJdCdzIGFuDQo+IGltcGxl
bWVudGF0aW9uIGRldGFpbCBvZiB0aGUgVERYIG1vZHVsZS4NCg0KSGkgVGhvbWFzLA0KDQpUaGFu
a3MgZm9yIHJldmlldyENCg0KSSBhZ3JlZSBvbiBoYXJkd2FyZSBsZXZlbCB0aGVyZSBzaG91bGRu
J3QgYmUgc3VjaCByZXF1aXJlbWVudCAobm90IDEwMCUgc3VyZQ0KdGhvdWdoKSwgYnV0IEkgZ3Vl
c3MgZnJvbSBrZXJuZWwncyBwZXJzcGVjdGl2ZSwgInRoZSBpbXBsZW1lbnRhdGlvbiBkZXRhaWwg
b2YNCnRoZSBURFggbW9kdWxlIiBpcyBzb3J0IG9mICJhcmNoaXRlY3R1cmFsIHJlcXVpcmVtZW50
IiAtLSBhdCBsZWFzdCBJbnRlbCBhcmNoDQpndXlzIHRoaW5rIHNvIEkgZ3Vlc3MuDQoNCj4gDQo+
IFRlY2huaWNhbGx5IHRoZXJlIGlzIElNTyBaRVJPIHJlcXVpcmVtZW50IHRvIGRvIHNvLg0KPiAN
Cj4gwqAxKSBUaGUgVERYIG1vZHVsZSBpcyBnbG9iYWwNCj4gDQo+IMKgMikgU2VhbS1yb290IGFu
ZCBTZWFtLW5vbi1yb290IG9wZXJhdGlvbiBhcmUgc3RyaWN0bHkgYSBMUCBwcm9wZXJ0eS4NCj4g
DQo+IMKgwqDCoCBUaGUgb25seSBhcmNoaXRlY3R1cmFsIHByZXJlcXVpc2l0ZSBmb3IgdXNpbmcg
U2VhbSBvbiBhIExQIGlzIHRoYXQNCj4gwqDCoMKgIG9idmlvdXNseSB0aGUgZW5jcnlwdGlvbi9k
ZWNyeXB0aW9uIG1lY2hhbmljcyBoYXZlIGJlZW4gaW5pdGlhbGl6ZWQNCj4gwqDCoMKgIG9uIHRo
ZSBwYWNrYWdlIHRvIHdoaWNoIHRoZSBMUCBiZWxvbmdzLg0KPiANCj4gSSBjYW4gc2VlIHdoeSBp
dCBtaWdodCBiZSBjb21wbGljYXRlZCB0byBhZGQvcmVtb3ZlIGFuIExQIGFmdGVyDQo+IGluaXRp
YWxpemF0aW9uIGZhY3QsIGJ1dCB0ZWNobmljYWxseSBpdCBzaG91bGQgYmUgcG9zc2libGUuDQoN
CiJrZXJuZWwgc29mdCBvZmZsaW5lIiBhY3R1YWxseSBpc24ndCBhbiBpc3N1ZS4gIFdlIGNhbiBi
cmluZyBkb3duIGEgbG9naWNhbCBjcHUNCmFmdGVyIGl0IGdldHMgaW5pdGlhbGl6ZWQgYW5kIHRo
ZW4gYnJpbmcgaXQgdXAgYWdhaW4uDQoNCk9ubHkgYWRkL3JlbW92YWwgb2YgcGh5c2ljYWwgY3B1
IHdpbGwgY2F1c2UgcHJvYmxlbTrCoA0KDQpURFggTUNIRUNLIHZlcmlmaWVzIGFsbCBib290LXRp
bWUgcHJlc2VudCBjcHVzIHRvIG1ha2Ugc3VyZSB0aGV5IGFyZSBURFgtDQpjb21wYXRpYmxlIGJl
Zm9yZSBpdCBlbmFibGVzIFREWCBpbiBoYXJkd2FyZS4gIE1DSEVDSyBjYW5ub3QgcnVuIG9uIGhv
dC1hZGRlZA0KQ1BVLCBzbyBURFggY2Fubm90IHN1cHBvcnQgcGh5c2ljYWwgQ1BVIGhvdHBsdWcu
DQoNCldlIHRyaWVkIHRvIGdldCBpdCBjbGFyaWZpZWQgaW4gdGhlIHNwZWNpZmljYXRpb24sIGFu
ZCBiZWxvdyBpcyB3aGF0IFREWC9tb2R1bGUNCmFyY2ggZ3V5cyBhZ3JlZWQgdG8gcHV0IHRvIHRo
ZSBURFggbW9kdWxlIHNwZWMgKGp1c3QgY2hlY2tlZCBpdCdzIG5vdCBpbiBsYXRlc3QNCnB1Ymxp
YyBzcGVjIHlldCwgYnV0IHRoZXkgc2FpZCBpdCB3aWxsIGJlIGluIG5leHQgcmVsZWFzZSk6DQoN
CiINCjQuMS4zLjIuICBDUFUgQ29uZmlndXJhdGlvbg0KDQpEdXJpbmcgcGxhdGZvcm0gYm9vdCwg
TUNIRUNLIHZlcmlmaWVzIGFsbCBsb2dpY2FsIENQVXMgdG8gZW5zdXJlIHRoZXkgbWVldCBURFji
gJlzDQpzZWN1cml0eSBhbmQgY2VydGFpbiBmdW5jdGlvbmFsaXR5IHJlcXVpcmVtZW50cywgYW5k
IE1DSEVDSyBwYXNzZXMgdGhlIGZvbGxvd2luZw0KQ1BVIGNvbmZpZ3VyYXRpb24gaW5mb3JtYXRp
b24gdG8gdGhlIE5QLVNFQU1MRFIsIFAtU0VBTUxEUiBhbmQgdGhlIFREWCBNb2R1bGU6DQoNCsK3
ICAgICAgICAgVG90YWwgbnVtYmVyIG9mIGxvZ2ljYWwgcHJvY2Vzc29ycyBpbiB0aGUgcGxhdGZv
cm0uDQrCtyAgICAgICAgIFRvdGFsIG51bWJlciBvZiBpbnN0YWxsZWQgcGFja2FnZXMgaW4gdGhl
IHBsYXRmb3JtLg0KwrcgICAgICAgICBBIHRhYmxlIG9mIHBlci1wYWNrYWdlIENQVSBmYW1pbHks
IG1vZGVsIGFuZCBzdGVwcGluZyBldGMuDQppZGVudGlmaWNhdGlvbiwgYXMgZW51bWVyYXRlZCBi
eSBDUFVJRCgxKS5FQVguDQpUaGUgYWJvdmUgaW5mb3JtYXRpb24gaXMgc3RhdGljIGFuZCBkb2Vz
IG5vdCBjaGFuZ2UgYWZ0ZXIgcGxhdGZvcm0gYm9vdCBhbmQNCk1DSEVDSyBydW4uDQoNCk5vdGU6
ICAgICBURFggZG9lc27igJl0IHN1cHBvcnQgYWRkaW5nIG9yIHJlbW92aW5nIENQVXMgZnJvbSBU
RFggc2VjdXJpdHkNCnBlcmltZXRlciwgYXMgY2hlY2tlZCBteSBNQ0hFQ0suICBCSU9TIHNob3Vs
ZCBwcmV2ZW50IENQVXMgZnJvbSBiZWluZyBob3QtYWRkZWQNCm9yIGhvdC1yZW1vdmVkIGFmdGVy
IHBsYXRmb3JtIGJvb3RzLg0KDQpUaGUgVERYIG1vZHVsZSBwZXJmb3JtcyBhZGRpdGlvbmFsIGNo
ZWNrcyBvZiB0aGUgQ1BV4oCZcyBjb25maWd1cmF0aW9uIGFuZA0Kc3VwcG9ydGVkIGZlYXR1cmVz
LCBieSByZWFkaW5nIE1TUnMgYW5kIENQVUlEIGluZm9ybWF0aW9uIGFzIGRlc2NyaWJlZCBpbiB0
aGUNCmZvbGxvd2luZyBzZWN0aW9ucy4NCiINCg0KPiANCj4gVERYL1NlYW0gaXMgbm90IHRoYXQg
c3BlY2lhbC4NCj4gDQo+IEJ1dCB3aGF0J3MgYWJzb2x1dGVseSBhbm5veWluZyBpcyB0aGF0IHRo
ZSBkb2N1bWVudGF0aW9uIGxhY2tzIGFueQ0KPiBpbmZvcm1hdGlvbiBhYm91dCB0aGUgY2hvaWNl
IG9mIGVuZm9yY2VtZW50IHdoaWNoIGhhcyBiZWVuIGhhcmRjb2RlZA0KPiBpbnRvIHRoZSBTZWFt
IG1vZHVsZSBmb3Igd2hhdGV2ZXIgcmVhc29ucy4NCj4gDQo+IE1heWJlIEkgb3Zlcmxvb2tlZCBp
dCwgYnV0IHRoZW4gaXQncyBkZWZpbml0ZWx5IHdlbGwgaGlkZGVuLg0KDQpJdCBkZXBlbmRzIG9u
IHRoZSBURFggTW9kdWxlIGltcGxlbWVudGF0aW9uLCB3aGljaCBURFggYXJjaCBndXlzIHRoaW5r
IHNob3VsZCBiZQ0KImFyY2hpdGVjdHVyYWwiIEkgdGhpbmsuDQoNCg0K
