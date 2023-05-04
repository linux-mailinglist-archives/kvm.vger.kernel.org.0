Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4F6F63F4
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 06:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjEDESF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 00:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjEDESD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 00:18:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D319BE;
        Wed,  3 May 2023 21:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683173882; x=1714709882;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=rMDln4xRbkZfRtIxYxSbCTAJbo7XWlKq7qO6j8MX5Kk=;
  b=cMsuOr3pbIlcOpwgXfJYn0n83tX+vqlPBxAhPLgjIWjiGPMkrQW4ycx+
   Gff/1SG5u/Sc1xfM1JkcD9ewEp2mFUMdjV8Yq9ptHxwrRx+8ZkD+20YSS
   9l7BkOsvdfIebjU8QbPJWLPuUdX6uH56BU2er3FTvKt52F2+InPWP8IGC
   kF6ax3IjWQdKXyEdbsQy8Vlml8ZrPRfLgWXutJS1iO5iJeBW4+wDMmdcM
   BpodxRH1yxGmt4kzmXjNbditdjyzBEp8+7SValEXynkNTBmgeWuRaobtF
   JO7CJRCDmbAhfidn2Gwzrz9RrX975HaFyacCacD+SthlL1HOvrVaq3hAQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="347649033"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="347649033"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 21:18:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="766402896"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766402896"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 03 May 2023 21:18:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 21:18:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 21:18:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 21:18:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 21:18:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grAbzVifOVF6+oPMs/Hh+O3LCeirVVEhhKza3qt1qHN1ERNPQmDliDbrWf446uco435GKbTYyFN0LYSxHCmo5F5itsPC9+ZHMlpfUMOjapGMZ1M5P8EI3H8W32vMXkq29LWZmWwgcqmZfcFvsX05scNAGHc/ylzN/8BoUG94KyNpOlJUpHWPv9NSvhsyyiy4lNZUjyuByP2QxwUruHKrFaKh1QsSRfD6yZUGsRRbBziwjbP0r4PonbvmkekcqLxgmYJ8go2v+QycmKlPaqFaUI2Veg+VQ5ZxaFPuTP5llgraG3dmcOrX7wJI3rp4NWbtdDUr7vw1vJtUIbUy3XZ5qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMDln4xRbkZfRtIxYxSbCTAJbo7XWlKq7qO6j8MX5Kk=;
 b=NUiqxUXiAJWhCdAQncE8p9cl5FE+B9DdgRaADsVjCr7M23nSHR2W3mZGIt7lUaxeI3mW8aTGEmG7Df2syuLNbLf3jP5ShUtP25poielWKcwMxIUN9ILvji8pDlPOTURG3qBHfnMrA2F2pTvKDB85BquH6sx0Y0X/5uqNe1lbIP+Cofj4Hi7Laz5eg5nQCdP7eg1yUV2h8B8xqaXOnv3N8IwDyxeTyEVnyJTiMWz98rESDMS09xVgyArDxp0wTTbrBZDTs7yyETXhqsaCEfd39uOFxKI/SvCzNYrIXfLYtrVGZLTsXv/s4JdcAX0Y0Y3QcVnqPuPv7EwSdZY6WlvyGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8207.namprd11.prod.outlook.com (2603:10b6:8:164::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Thu, 4 May
 2023 04:17:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::33bf:d30c:12fd:b7e3%6]) with mapi id 15.20.6340.031; Thu, 4 May 2023
 04:17:58 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Thread-Topic: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack
 MSR access
Thread-Index: AQHZdHFyi6vR/qt18UeCPYYHW6Q6nK9I2oYAgACJ34CAADGHgA==
Date:   Thu, 4 May 2023 04:17:57 +0000
Message-ID: <04be1306737a8db851874ff9283401d67edb34b8.camel@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
         <20230421134615.62539-22-weijiang.yang@intel.com>
         <175c826d59f1ac77fa588908d3768ffc2e79268e.camel@intel.com>
         <c9747bd0-2a1e-a7ef-4775-b5ca7c00b24e@intel.com>
In-Reply-To: <c9747bd0-2a1e-a7ef-4775-b5ca7c00b24e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8207:EE_
x-ms-office365-filtering-correlation-id: ff37f560-b017-4ebe-2d29-08db4c568aa7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E/Enh+Vw7uIHsNyHwdJUzhOTjH+lhVx/WCU7p8OKh72FUd76+XBMKrHUdI1YmYlIod+aYza4zyKErPAJDpSqPJgswDhjy1p+lamZgvrDR0Dp58jd5JJFnnE26JHBMJK1l9aAjeGzjK5Bpm939JYaRGf43Zdv1SQqVboY5xE3Hdn0aWpqADChIrQJ+6CHboTfQbeF723mV4THUArv5MPzGwmlunWsnGaVBYZiOU87IE19x0WjoGNHci7AbclY8HIw68qQcP9mtZjHUjoKUViko8Pch3oGql23bx5DuL+TXLj+ywAGTzrYVuQLfYoOtIXFvpMxmpLZQmkgXTA2VAEnmXX7JrFZ3RNfIFJzROBZ4f4l/QSrgr0u1K+RYcYSl33/7UaKaVI5y7s6zSO/393SA1FfI3GeFsBd/B/BpHmeQc6pLF4MIfTNz0903nrL6FW7hgXHINOU9xjOe4ev9jGy6ldHIwVy9LxUX1X+dpSX32/0+q6ZMNs7sc70DFWd4a6STYHcWpUMJObLaAuw/16Bz+cL5VxBk/fQOwzdATHloKEo5JWqyWu+CloXeKFEkEstrwpGVMPFlpvb5Jb2G5kofPMyZUrX5Xe9JwiBLkYZkI8EG47xRVqGWXfigHgJqQ1y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199021)(6512007)(6506007)(26005)(82960400001)(122000001)(186003)(53546011)(38100700002)(83380400001)(966005)(38070700005)(41300700001)(8936002)(5660300002)(36756003)(2616005)(2906002)(478600001)(110136005)(71200400001)(316002)(6486002)(8676002)(921005)(66946007)(91956017)(86362001)(66556008)(66476007)(66446008)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGg4UTVtQS9RYnU0Vzl1dTJHWEJhS01DY1lIR3Vsc1RTdTBPMzVwT2VhUGIy?=
 =?utf-8?B?eEw3Mi9kdkVmaEtYcS9KZnV5d0pyamJ4cWY5cVUzci9kZkF3ekFmOGJwRlB1?=
 =?utf-8?B?ZUJ0Ky9tSmtkcHRpR0lrVW5aa1VhWG0zekpBdnJpVHErSjdhTWRmdkRXR1Ry?=
 =?utf-8?B?UmJZakc4dUxMMXJFbHVVV1NZdFJXTTAyYTIzQmJiWFFMOE1FRlVnY0I4VEk2?=
 =?utf-8?B?Q3l6RXdXM1MrOXI5Q1hucDdQK1AxWmJPSDRmdTZJVHp5ZThnRzU3UXpKbC8x?=
 =?utf-8?B?MEJmaVQ4WVdYaUhPMFo3U3lqRFc1MXJUWGJpSUVPYXN2anZPT0VmaFB5UnVQ?=
 =?utf-8?B?U2tIckJ5UXQ3UzV2ZXVsWWd6b1NPaXR1eE9VTU9ISGNmN2QzT2dlbmhYNTdi?=
 =?utf-8?B?b3FwQlhna1prZEVIS2pobitjdUluNjdXN0NjSjVnMU9ucEhXWVpIVXFScTd2?=
 =?utf-8?B?Y1loUGtuQkk0blpzZDN0Ukp0VG8xRFNyenh6QnFXT3ozSXJ4Z2VDRGJrem1U?=
 =?utf-8?B?SmFxTXBsb212bVRWa045TDJCd2FtZjdXd1pJSEY1YzRINStmOVc1VU55RnJj?=
 =?utf-8?B?WmZSOEhJZTF6SUdCb1N0anVFdDZGWFY3WmFXclRpaXM4YXI3VDdFSVY2djh2?=
 =?utf-8?B?bVpjZ05QM0RudUx2SzZDaXBtbWlzVWpGMXUxZVNVVzlPZXJOOHR0STcyTTZO?=
 =?utf-8?B?a2MrUGlWZm5Rc2VvcG5RUFVTMXlqSDdvdEF0OW1OWXBJTXpMOUhpQW1QbjFX?=
 =?utf-8?B?dGhtL3I4eXRBZGdoY3hxK1BnaTR6T2dndjZxK1E0bHEyTGxTd1VUSDJoRTNh?=
 =?utf-8?B?SnYrWGhkc3d5M05VcURzMlU2V0Y5ZWNqTVhiOTNEcjJsRDhYQjVyNHdiVG5x?=
 =?utf-8?B?U2IxZG9DQ3JrTGZ0bVVIVGpmYU9sRmx5RENjdjdQSzJtV2N5QmZMeXNmN2ZC?=
 =?utf-8?B?Q2tUTGNSOEkwT1hJckNSdE5nS3Vhdzd5amllNmwrUnhsQmJ5eU9CN250NDRI?=
 =?utf-8?B?Q0N6b01NZmhicGV0SU5lNjM4UzBNaUF5TkNJZE04TWtkM3VqTklZd0lsUXNw?=
 =?utf-8?B?NlhKcy9mN1FGNU4vN0VBQ1pYaWY5VDJ0UWx5VEZFOGdCUDIxR3Fmbm1QU1Zx?=
 =?utf-8?B?eVRBQ2svR3EzV3JRck5oNkJVWlpWSUhoaEg4OXhqQXJOREdFZGsvbkswVjA3?=
 =?utf-8?B?UWl1dVl5K0pMSjdIZ0c5OU14Sm5odGxLUHN3QkdzODN5V0MxV1FNdHIyK3JH?=
 =?utf-8?B?TWdsa096K3BlWEsyemtNT1FVVDgxZkNPcWgyLy9ERDZBeklMQXlEeUl5M3lR?=
 =?utf-8?B?OEQ5RmNHYUFTT3RYRnJjMDlaZ1VFTjZUOWZGb1dzaWRFdEUzdVJXNXdDRzJ6?=
 =?utf-8?B?a1p0eFhIUmdyUmdUdVdKTGIxVld3QTNXQTlXVUhaY0gyK0VOd2ZuV1pmWkk5?=
 =?utf-8?B?bzV2dGpzN1hXcjRQTmZtOTZiQ1Nlc3pxS28wMEhJRHIrakhzWHNLbnpJMk1w?=
 =?utf-8?B?WTRhM3dhRzhSeEN4UjYxcURnQUt6dXlDdEg4YkNZcFJSNjVldFBSSDh6TCt2?=
 =?utf-8?B?RXcrckNPUHg3Zis4SlFxb2VOY1ZkMzlnSVREVmxIK1FNREwrQjJnVUhpcjZN?=
 =?utf-8?B?QW5keFluRVVpbU5zZVhuTjAwOWhsQS93a2o0cUJRMklmNVpqejZxR1VNaWhi?=
 =?utf-8?B?QXdMOTQ1dzVaMXp3QnJycDNEQ2Yzckd3RzIvOG43aHd2S3BvcVhMdnhXS3pG?=
 =?utf-8?B?V2dYWGhWYy9UQlJ3cXBkcDFKZk1Xdzd2YjhKVHhldExEVVEvRGtwZENPYVZR?=
 =?utf-8?B?V0gvRVlJSk9VZXAwU1lQemhKRDUzZ3BESGRkY2o4SlBwQVFZdUcrQVkvVHZn?=
 =?utf-8?B?MXFORlhNNGtFNHRhOW40U2E1cjJOVjNQeVRCMlFtdkM1MGRPK2tLMlQyZnlM?=
 =?utf-8?B?aTVqZ052ZWVJb1ozbjdNa2FBeEsydzBrWkh4RW5uK1JLakc3bE9yRjVjbWpN?=
 =?utf-8?B?NFdVTXdpUjJCVzBZVEU1NkJ5UFkxS242ejdmTkJjNDlPakVZblZyVHhjT3Nl?=
 =?utf-8?B?Szhuc2h2b2d2L285SFpKWW9hYVphb00wd0hYOVE1RjBoWnJSdkNzTzRBNjUx?=
 =?utf-8?B?a0V4QUprUjkrRE9VWi9GZXBWNHAzQ0EzSEdWZjdTS2IxdVQrZ1N3OERya2JG?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8FEA62FC349754E8B4CE10632FA7DCB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff37f560-b017-4ebe-2d29-08db4c568aa7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 04:17:57.9594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PgGlXiSIs5BkE4yeBtQ/dLJJzijaaFzkt7GYYSFFVuFV7SuEpe4hSD04yViEO6AjNaYuVcId4BSup2rCn4k2TFKamdv9yOWfUv0IdxwbXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8207
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTA0IGF0IDA5OjIwICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gDQo+IE9uIDUvNC8yMDIzIDE6MDcgQU0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+
IE9uIEZyaSwgMjAyMy0wNC0yMSBhdCAwOTo0NiAtMDQwMCwgWWFuZyBXZWlqaWFuZyB3cm90ZToN
Cj4gPiA+ICsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoGluY3B0ID0gIWlzX2NldF9zdGF0ZV9zdXBw
b3J0ZWQodmNwdSwNCj4gPiA+IFhGRUFUVVJFX01BU0tfQ0VUX0tFUk5FTCk7DQo+ID4gPiArwqDC
oMKgwqDCoMKgwqBpbmNwdCB8PSAhZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1NI
U1RLKTsNCj4gPiA+ICsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHZteF9zZXRfaW50ZXJjZXB0X2Zv
cl9tc3IodmNwdSwgTVNSX0lBMzJfSU5UX1NTUF9UQUIsDQo+ID4gPiBNU1JfVFlQRV9SVywgaW5j
cHQpOw0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgdm14X3NldF9pbnRlcmNlcHRfZm9yX21zcih2Y3B1
LCBNU1JfSUEzMl9QTDBfU1NQLA0KPiA+ID4gTVNSX1RZUEVfUlcsIGluY3B0KTsNCj4gPiA+ICvC
oMKgwqDCoMKgwqDCoHZteF9zZXRfaW50ZXJjZXB0X2Zvcl9tc3IodmNwdSwgTVNSX0lBMzJfUEwx
X1NTUCwNCj4gPiA+IE1TUl9UWVBFX1JXLCBpbmNwdCk7DQo+ID4gPiArwqDCoMKgwqDCoMKgwqB2
bXhfc2V0X2ludGVyY2VwdF9mb3JfbXNyKHZjcHUsIE1TUl9JQTMyX1BMMl9TU1AsDQo+ID4gPiBN
U1JfVFlQRV9SVywgaW5jcHQpOw0KPiA+ID4gwqAgwqB9DQo+ID4gV2h5IGlzIHRoaXMgdGllZCB0
byBYRkVBVFVSRV9NQVNLX0NFVF9LRVJORUw/IEkgZG9uJ3Qga25vdyBob3cgdGhlDQo+ID4gU1ZN
DQo+ID4gc2lkZSB3b3JrcywgYnV0IHRoZSBob3N0IGtlcm5lbCBkb2Vzbid0IHVzZSB0aGlzIHhm
ZWF0dXJlLiBKdXN0IG5vdA0KPiA+IGNsZWFyIG9uIHdoYXQgdGhlIGludGVudGlvbiBpcy4gV2h5
IG5vdCB1c2UNCj4gPiBrdm1fY2V0X2tlcm5lbF9zaHN0a19zdXBwb3J0ZWQoKSBhZ2Fpbj8NCj4g
DQo+IEkgZG9uJ3Qga25vdyBob3cgU1ZNIHN1cHBvcnRzIHN1cGVydmlzb3IgU0hTVEsgZWl0aGVy
LCBoZXJlIGp1c3QNCj4gZm9sbG93cyANCj4gdGhlIHNwZWMuDQoNCldoYXQgYXNwZWN0IG9mIHRo
ZSBzcGVjIGlzIHRoaXM/DQoNCj4gDQo+IHRvIGFkZCB0aGUgZGVwZW5kZW5jeSBjaGVjay4gTWF5
YmUgeW91J3JlIHJpZ2h0LCBJIG5lZWQgdG8gdXNlIA0KPiBrdm1fY2V0X2tlcm5lbF9zaHN0a19z
dXBwb3J0ZWQoKQ0KPiANCj4gaW4gbXkgcGF0Y2ggc2V0IGFuZCBsZWF2ZSB0aGUgd29yayB0byBT
Vk0gZW5hYmxpbmcgcGF0Y2hlcy4gSSdsbA0KPiBjaGFuZ2UgDQo+IGl0LCB0aGFua3MhDQoNCk9o
LCBJIHNlZSB0aGUgdGhlIFNWTSBwYXRjaCBbMF0gaXMgYWRkaW5nIFhGRUFUVVJFX01BU0tfQ0VU
X0tFUk5FTCB0bw0Ka3ZtX2NhcHMuc3VwcG9ydGVkX3hzcyBhcyBsb25nIGFzIGt2bV9jcHVfY2Fw
X2hhcyhYODZfRkVBVFVSRV9TSFNUSykuDQpBbmQgaXQgZG9lcyBub3QgbG9vayB0byBiZSBjaGVj
a2luZyBYU1MgaG9zdCBzdXBwb3J0IGxpa2UgaG93IA0Ka3ZtX2NhcHMuc3VwcG9ydGVkX3hzcyBp
cyBzZXQgaW4geW91ciBwYXRjaC4gSXQgc2hvdWxkIGRlcGVuZCBvbiBob3N0DQpzdXBwb3J0LCBy
aWdodD8gSXMgdGhhdCB0aGUgaW50ZW50IG9mIGt2bV9jYXBzLnN1cHBvcnRlZF94c3M/DQoNClNl
cGFyYXRlIGZyb20gYWxsIHRoYXQsIHRoZSBjb2RlIGFib3ZlIGlzIGluIFZNWCwgc28gbm90IHN1
cmUgaG93IGl0DQphZmZlY3RzIFNWTSBpbiBhbnkgY2FzZS4NCg0KSSBtaWdodCBiZSBjb25mdXNl
ZCBoZXJlLiBUaGUgY29kZSBqdXN0IGxvb2tlZCBzdXNwaWNpb3VzLg0KDQpbMF0NCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2t2bS8yMDIyMTAxMjIwMzkxMC4yMDQ3OTMtOC1qb2huLmFsbGVuQGFt
ZC5jb20vDQo=
