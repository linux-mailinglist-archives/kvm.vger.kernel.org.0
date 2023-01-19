Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B4672F17
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 03:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjASCkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 21:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjASCka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 21:40:30 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB5059259;
        Wed, 18 Jan 2023 18:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674096029; x=1705632029;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JKdooXNqgcnncM9S6ZvI5EAyD8bSGwNvizMF1iRC6/U=;
  b=D8ft6QDPD9DWQQmro6xXhZ4VaN880k76n4I4DpXDesXDSlObkeTPHx8q
   VjwL6vTBqh8yAlD1v4MjCcDv56brxteiLheUm7IK8XRerxKcSbRY5X/zj
   5e3/p7eKCVAXeTAGh5kn75ghWuldRKsYYN9O7l9YzQt+zIAGJRYpMajqi
   cH/IdisB/ZPAbftv2VtF1XWK/uT3LMMos5WVOPGKyex7ZzFGEnBd7/9kK
   ovaKmR0NAXcQkfTMp6wCAILpsAIZ1NaAcm931ItJlXer2K2qglVBYzpC6
   hz9v/0DYIfxZNs74QFSuv9ViO1dX+h82InKe+tHp3cnCVhoTmy/HxGt89
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="304857043"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="304857043"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 18:40:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="802459885"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="802459885"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jan 2023 18:40:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 18:40:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 18:40:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 18:40:20 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 18:40:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zju4jlZfTUMmJTPdZysod7yMnomfQU1yDU4AXqForVwPpmZLKT8S6/IKs6tvu+TlEbtgastkBEnW8P5bMIIAueut6Z6djvXoNrIYqX/NCpcFIO2fq4H+ct62q8xx9JzvK2FHELUimd7zRJm9tJMYMg/AU9frJx3BBQ5smI/80VO97W+dom4A7yEK+JTUXuWV//9TXGAzfgtuv1/zGvLNRZluzFvi7LQT0VZHiUXaoMICNb74EEZL7kxkYQxHKAQQr6KL+aNMmNOKu5nTRaAWx8ex/IzqYOUbXd0v8wRF8aUSRtpomE0dPfV9WZPPukmXoEAz1ECtBfdrJd6n00Yo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKdooXNqgcnncM9S6ZvI5EAyD8bSGwNvizMF1iRC6/U=;
 b=k9ZbUVU4Pm0yEmlA7ReMEVt0X4HELs4nUXRHMmecNb6OdqqYW/zfpKxrrRcSlIUSiP+OitVPBNQWFSdu74yp51sxrFGBNtF8kW6F9lp0vtNEYpFscgWNCer4Y/Lw5FZnir8MmGlgbVqd8PlYOd4aaWY2V3mhL+ndX4kg678fV4R3sDkfDq+pfI5G7t8x6mY1ne/nuhmiiLoJoPkUUMKffYG8rRCIVMRX8D4CYDbcR11OST0FnZl+GzJbyuFA87GSKCp6nFbAeIkcMC1KUc1ICFJ4LD9GjX+tSX/lYtbDLwoIfSGP5nSews87TtfpEmXFlI8PXWMWEexK7bGXtwYNbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4925.namprd11.prod.outlook.com (2603:10b6:a03:2df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 02:40:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 02:40:17 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 016/113] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Topic: [PATCH v11 016/113] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Index: AQHZJqTwAeom7RMUz0mEVml2aXul+q6lEW6A
Date:   Thu, 19 Jan 2023 02:40:17 +0000
Message-ID: <19645255d65fdfd184b92b5192cac83a27c430fb.camel@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
         <e846968f2e1c554b3ecc1a876e0bb691727d34fc.1673539699.git.isaku.yamahata@intel.com>
In-Reply-To: <e846968f2e1c554b3ecc1a876e0bb691727d34fc.1673539699.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4925:EE_
x-ms-office365-filtering-correlation-id: 4d505b49-9a65-4a4a-afad-08daf9c68054
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cJ6vgco/6VmQTCTan85CG6eJSEW+4pfFZEh8M6K4HHDOVFcJKOYDEbFpADy5w8uw66d/DoJLoxjBMg3rN7VkYIa+oCtrDYgcDlf6fJDmLcXOZl7wR/7vbzY0asjgNsoRBXBkL4+9qnMN6EQnQFLv0xVWC7WqO9YNLKZEwcHM1U/o710ZCKVmD1u116lMXpYYXDKlu7GIMe5q46dGYOLUTwdBMr/fBnbkkqSW7nZPbIe6bU6S57H9713gmC+FkXZutUwU2IuMK6EqMNU6thqSIAdPqgaOjuSQJ0PqfKtbZB/nLf8H3/mtigfTrG2H4J8KWKpNHOCftXIcc74bZXEE/o60nDhOFdiPcDLKs7pF3kwXCdRgOfQTy5og9vGLno7/oyI2as/xh/jb49tDekqp+On16hy/EQ1EifsvbZLGeFtmv5PVcDsaU4J5IZqJD8ST78Z9XsbXIVNsZnYwgFHvqtI0mO2vG7dvvlcaf2fHdvjcSBiWb43SD3yzOwpoRUN0mVJzf8SKy86nuWJoXOwBGwrlOgukwEzEZGTo5nd1mOSufAm+0lpaEkSrHUm7gv3kQrEBjSYdOv0S5VtTEU8Ckvrv+XFAlNyVqUNY/2hRtkG2D+l4utEJYA9kd2gviPQ1HxRYH+K6yQBKmrsLZk42jW8oar3SWTn7TC5Q+u2+rgdS7o33n0zQCyzY6HTQVNdgR6xplUkSNTGYLEh6JMnzTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199015)(38070700005)(86362001)(5660300002)(41300700001)(8936002)(122000001)(82960400001)(36756003)(38100700002)(6486002)(71200400001)(478600001)(110136005)(54906003)(6636002)(83380400001)(6512007)(6506007)(26005)(186003)(4326008)(8676002)(316002)(64756008)(66556008)(66946007)(66446008)(66476007)(76116006)(91956017)(2616005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXM2M0hyVEl4VXk2SmtHa0c1cWZuMWFjNlcyc2ZTUGNOWGR3cVc3cUJ2Z1Vt?=
 =?utf-8?B?RzNudUxjTHZPYjZRcTVyKy9ZUVNIeGZjL2haUUZrVkhLQWZ6Z2psT0pxVEUx?=
 =?utf-8?B?YU9tVVdmWXAzMGo3dU9QOW5zeUcyQk9XWjFlaEFZbTVjdll2d0VCRVA1OWpy?=
 =?utf-8?B?REIrVms5NlFkU0h1S1pEZW90cFFZbXhRaFlZaTg2S3RzeEtXN0UwZWYvTDFL?=
 =?utf-8?B?ZnZldXozQXVyc2xVNWkwb3F3elY3Ym0veHFNOGdYbUNnQU9QYVdLVlJLdUxn?=
 =?utf-8?B?TlBwcC9OQ0pyNzlHaW4rc0N0cUNxdzdFdEZYSk9ncHBoMkxqdFMwNWdlSzJh?=
 =?utf-8?B?T0NoRUhjRzFRdVpwUS9pYWQybFh2NTRUQk9kbFZLbGpNbnoxdWxnOG1kUTBa?=
 =?utf-8?B?elZsdlNZMTMvNlhtOWo4UUxFa3Q4bTZPNGtCT0pJNDBWM1dNSU9WNHgySGR3?=
 =?utf-8?B?VlhDQmxPZXhsUWNRdjV2Yll5dFVxQXd6NTlmL2xOcEsyZitrY0dLcTVhSDZL?=
 =?utf-8?B?WGtUM1Y0UlZsQzVZbitFcld4QjJsRzVWTTJBNWJCMURJdlp3WW4rdmo3VEFv?=
 =?utf-8?B?VVR0M2RUdS91dVk0aHlCVFdkdmdTYll2UG9UeXA3RTFjOEdZcmRGcVVydStZ?=
 =?utf-8?B?VjZzVzh2SGszNFdyZDZUUTJDeU5rK3VlUERJdnVjbTZqbi9kVzI0R1hCdzlR?=
 =?utf-8?B?UU1BUDRsSU12aEloNTJMZnR6bkp5a0ZJRktmdk5HN0Fmay80Sys0YWdKSEFk?=
 =?utf-8?B?T3FLZXQ4dzM3TTZUeVlpblZJV2k5WmVZa0haY28rbmhseDRnWld6eWhUYm5i?=
 =?utf-8?B?dWRROEV0UkJVQkRKNHhTM1NTRGR5VThoZndwUEtoMVBwdlg2VHRCTGQyaE54?=
 =?utf-8?B?eXd4bkwvanoxKzBmRndlUWFhZ3IzS05oMkg3bG5lMUVFQ3B6NWRydk9MQlN0?=
 =?utf-8?B?WGZacWdiMUNLTjFVdDA3YWl4L1E0cDJocWZOZTRJQWdCVHBtYzliYVZWMnFT?=
 =?utf-8?B?Z1FuTnZ3UVlvSDVqdmZTRVdFUkVJMVFnZGl1K0lwcDlzNVZUYmx5eTM0ZlRR?=
 =?utf-8?B?UFBNVHpaSjJSNlZsbThRcFFMTUNSUlJpbDREZXMydmpHeER6SE51Ky9VOXJ6?=
 =?utf-8?B?WVAxaVZzTnhURHNreW5ZcTZERmNuY1FyaHlPdzZLQ2krMGZTMytIWVZmL0E3?=
 =?utf-8?B?VjBDWE1Kc3Nmc3hnOHNlbVUyNFFmRTBEckRGaTBvd2ljVk9OT2lUZGJKTENU?=
 =?utf-8?B?OHRweUFFSEQ1Y1BYZ1Zla2ZueGMwL0hybXV0ak1EY3R0cVdvYmZNTFNZaHZ5?=
 =?utf-8?B?VmtaQmo1c0tyVkU0dnh3L0wyQ3k2OHNIWmlYQktKaXRDbUZjdTN0WVNCV1Zy?=
 =?utf-8?B?NWxTZCtIRDUzQThkVWlCbjJqek5CN29mRXpxTitoUmdtdVFRdmdSd00xQkZq?=
 =?utf-8?B?dHpGdkZUT3FPdkNLcWd0a2hlLy9iaysxZ3dDcXdoMFVMT0VST0pPQnZudThl?=
 =?utf-8?B?VXVYeTBoeG9FUThZaXVNWnpVVE9FUW9RUkxBTSt0eFJEV2ZBQlJ5WTB1VWth?=
 =?utf-8?B?RjNpREdISU9lVms5c2pVSmZlWmI4akN3RU16VnE4UGt6UHFlcVgwb1N2NGY4?=
 =?utf-8?B?SSt1QXNzYk94N0RIT3dTU3JUQXVpY0ovVXFmVGxxb2ZCV0lvNWdOQmhFYWN2?=
 =?utf-8?B?S2dFbVdON2pzYkVWMWU2T0lCKzFCb3FRS0tQMzZ5NHVMY1hUOC92eFBNb0s2?=
 =?utf-8?B?amhidkVIK2NPZWp6SkdmZHVoWGFyM1BOSFg1Wk5VNXlrNlp4RTZqNnRNbzhC?=
 =?utf-8?B?UDFDTUoxOUpFRWtpWEtFdWNCQ1hkVEFvenRybEkvSVc4ZjBhcGFrQU5GbU9H?=
 =?utf-8?B?YklVNUlBUG1WTG16WUZBcUV0Q2R4Y05HUVFrTWZiV0V6enRDZy9Lbk9BeGlN?=
 =?utf-8?B?NWIyTFBkQThZTSs2OGd0dzN4OVI4OXM2K3g3a1R1UEdXaTlOZUZzY1NDRDVU?=
 =?utf-8?B?QmJuaGNvSEwrN3h5OGNQdm5sd0t2YTh0MVZ2ZXUxZFhDOEVmNURQaG85UXpO?=
 =?utf-8?B?NXh2Q2NLLzU0aUc0TTVTVGYyM3RENEhuOTZRN1RYOEJkSUJGcHRUSEtvTFla?=
 =?utf-8?B?c0RGaHBxSkEvajUzazBxcHQyR0p4dVhUcGhHYk15bmV2blRaSFROUHpaRGFm?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <14E13A8B693D68429475ADD7F94F5EAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d505b49-9a65-4a4a-afad-08daf9c68054
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 02:40:17.7596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FqfsU29UGVlBb94P+tYZgyul5/AkNzcg146+akKRHAw1pieH3GwTEMDggFBiJYkxjXaXiUWXwGr0KxPMG75kOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4925
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTEyIGF0IDA4OjMxIC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBBZGQgYSBwbGFjZSBob2xkZXIgZnVuY3Rpb24gZm9yIFREWCBzcGVjaWZpYyBW
TS1zY29wZWQgaW9jdGwgYXMgbWVtX2VuY19vcC4NCj4gVERYIHNwZWNpZmljIHN1Yi1jb21tYW5k
cyB3aWxsIGJlIGFkZGVkIHRvIHJldHJpZXZlL3Bhc3MgVERYIHNwZWNpZmljDQo+IHBhcmFtZXRl
cnMuDQo+IA0KPiBLVk1fTUVNT1JZX0VOQ1JZUFRfT1Agd2FzIGludHJvZHVjZWQgZm9yIFZNLXNj
b3BlZCBvcGVyYXRpb25zIHNwZWNpZmljIGZvcg0KPiBndWVzdCBzdGF0ZS1wcm90ZWN0ZWQgVk0u
ICBJdCBkZWZpbmVkIHN1YmNvbW1hbmRzIGZvciB0ZWNobm9sb2d5LXNwZWNpZmljDQo+IG9wZXJh
dGlvbnMgdW5kZXIgS1ZNX01FTU9SWV9FTkNSWVBUX09QLiAgRGVzcGl0ZSBpdHMgbmFtZSwgdGhl
IHN1YmNvbW1hbmRzDQo+IGFyZSBub3QgbGltaXRlZCB0byBtZW1vcnkgZW5jcnlwdGlvbiwgYnV0
IHZhcmlvdXMgdGVjaG5vbG9neS1zcGVjaWZpYw0KPiBvcGVyYXRpb25zIGFyZSBkZWZpbmVkLiAg
SXQncyBuYXR1cmFsIHRvIHJlcHVycG9zZSBLVk1fTUVNT1JZX0VOQ1JZUFRfT1ANCj4gZm9yIFRE
WCBzcGVjaWZpYyBvcGVyYXRpb25zIGFuZCBkZWZpbmUgc3ViY29tbWFuZHMuDQo+IA0KPiBURFgg
cmVxdWlyZXMgVk0tc2NvcGVkIFREWC1zcGVjaWZpYyBvcGVyYXRpb25zIGZvciBkZXZpY2UgbW9k
ZWwsIGZvcg0KPiBleGFtcGxlLCBxZW11LiAgR2V0dGluZyBzeXN0ZW0td2lkZSBwYXJhbWV0ZXJz
LCBURFgtc3BlY2lmaWMgVk0NCj4gaW5pdGlhbGl6YXRpb24uDQoNClRoZXJlJ3MgZ3JhbW1hciBp
c3N1ZSBpbiB0aGUgbGFzdCBwYXJhZ3JhcGguICBQbGVhc2UgdXNlIGdyYW1tYXIgY2hlY2suDQoN
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRl
bC5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC9tYWluLmMgICAgfCAgOSArKysrKysr
KysNCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgICAgIHwgMjYgKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gIGFyY2gveDg2L2t2bS92bXgveDg2X29wcy5oIHwgIDQgKysrKw0KPiAgMyBm
aWxlcyBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3ZteC9tYWluLmMgYi9hcmNoL3g4Ni9rdm0vdm14L21haW4uYw0KPiBpbmRleCAxNjA1
M2VjM2UwYWUuLjc4MWZiYzg5NjEyMCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9t
YWluLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC9tYWluLmMNCj4gQEAgLTM3LDYgKzM3LDE0
IEBAIHN0YXRpYyBpbnQgdnRfdm1faW5pdChzdHJ1Y3Qga3ZtICprdm0pDQo+ICAJcmV0dXJuIHZt
eF92bV9pbml0KGt2bSk7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgdnRfbWVtX2VuY19pb2N0
bChzdHJ1Y3Qga3ZtICprdm0sIHZvaWQgX191c2VyICphcmdwKQ0KPiArew0KPiArCWlmICghaXNf
dGQoa3ZtKSkNCj4gKwkJcmV0dXJuIC1FTk9UVFk7DQo+ICsNCj4gKwlyZXR1cm4gdGR4X3ZtX2lv
Y3RsKGt2bSwgYXJncCk7DQo+ICt9DQo+ICsNCj4gIHN0cnVjdCBrdm1feDg2X29wcyB2dF94ODZf
b3BzIF9faW5pdGRhdGEgPSB7DQo+ICAJLm5hbWUgPSBLQlVJTERfTU9ETkFNRSwNCj4gIA0KPiBA
QCAtMTc5LDYgKzE4Nyw3IEBAIHN0cnVjdCBrdm1feDg2X29wcyB2dF94ODZfb3BzIF9faW5pdGRh
dGEgPSB7DQo+ICAJLnZjcHVfZGVsaXZlcl9zaXBpX3ZlY3RvciA9IGt2bV92Y3B1X2RlbGl2ZXJf
c2lwaV92ZWN0b3IsDQo+ICANCj4gIAkuZGV2X21lbV9lbmNfaW9jdGwgPSB0ZHhfZGV2X2lvY3Rs
LA0KPiArCS5tZW1fZW5jX2lvY3RsID0gdnRfbWVtX2VuY19pb2N0bCwNCj4gIH07DQoNCklJVUMs
IG5vdyBib3RoIEFNRCBhbmQgSW50ZWwgaGF2ZSBtZW1fZW5jX2lvY3RsKCkgY2FsbGJhY2sgaW1w
bGVtZW50ZWQsIHNvIHRoZQ0KS1ZNX1g4Nl9PUF9PUFRJT05BTCgpIG9mIGl0IGNhbiBiZSBjaGFu
Z2VkIHRvIEtWTV9YODZfT1AoKSwgYW5kIHRoZSBmdW5jdGlvbg0KcG9pbnRlciBjaGVjayBjYW4g
YmUgcmVtb3ZlZCBpbiB0aGUgSU9DVEw6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9rdm0teDg2LW9wcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtLXg4Ni0NCm9wcy5o
DQppbmRleCA4ZGMzNDVjYzYzMTguLmE1OTg1MmZiNWUyYSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2t2bS14ODYtb3BzLmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bS14ODYtb3BzLmgNCkBAIC0xMTYsNyArMTE2LDcgQEAgS1ZNX1g4Nl9PUChlbnRlcl9zbW0pDQog
S1ZNX1g4Nl9PUChsZWF2ZV9zbW0pDQogS1ZNX1g4Nl9PUChlbmFibGVfc21pX3dpbmRvdykNCiAj
ZW5kaWYNCi1LVk1fWDg2X09QX09QVElPTkFMKG1lbV9lbmNfaW9jdGwpDQorS1ZNX1g4Nl9PUCht
ZW1fZW5jX2lvY3RsKQ0KIEtWTV9YODZfT1BfT1BUSU9OQUwobWVtX2VuY19yZWdpc3Rlcl9yZWdp
b24pDQogS1ZNX1g4Nl9PUF9PUFRJT05BTChtZW1fZW5jX3VucmVnaXN0ZXJfcmVnaW9uKQ0KIEtW
TV9YODZfT1BfT1BUSU9OQUwodm1fY29weV9lbmNfY29udGV4dF9mcm9tKQ0KZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggYzkzNmY4ZDI4
YTUzLi5kZmEyNzllMzU0NzggMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCisrKyBi
L2FyY2gveDg2L2t2bS94ODYuYw0KQEAgLTY5MzcsMTAgKzY5MzcsNiBAQCBsb25nIGt2bV9hcmNo
X3ZtX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLA0KICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0K
ICAgICAgICB9DQogICAgICAgIGNhc2UgS1ZNX01FTU9SWV9FTkNSWVBUX09QOiB7DQotICAgICAg
ICAgICAgICAgciA9IC1FTk9UVFk7DQotICAgICAgICAgICAgICAgaWYgKCFrdm1feDg2X29wcy5t
ZW1fZW5jX2lvY3RsKQ0KLSAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQotDQogICAg
ICAgICAgICAgICAgciA9IHN0YXRpY19jYWxsKGt2bV94ODZfbWVtX2VuY19pb2N0bCkoa3ZtLCBh
cmdwKTsNCiAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAgfQ0KDQpbc25pcF0NCg0K
