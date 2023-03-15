Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24B6BADF0
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 11:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjCOKm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 06:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjCOKmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 06:42:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3BF64B16;
        Wed, 15 Mar 2023 03:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678876934; x=1710412934;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GvneFpO0jobsIlunl5rxrYy/rni02pQELgYzEZTZTXk=;
  b=L1xlRKas9ju7dcSDJ2JZZs1BR8uq3Qvq9AugGa2FHlF3wycuC8wBAKcs
   +lYML/Tvwbre+BfG1qUc+pFkCM/z2QYrh6BSr/7gwgtt4v77KpvTcElOp
   nlngL7JTsM1CvjKdMFpRUx4y8FZbQW08GcuHRhozA4pensarBnN8DJfiK
   Rt5JlqFtN/WWT+DufXp14ay8IG884qoBJQL3jQCpdTxrxR6yt2fAzx9gb
   KrTpYQDWY3Js8UXk+UubH/uUNUBPe/+hrTCaAd7a1hVD6X7ru2S4Wmwrl
   WY+4BJHlptk/Z820xXppjpJc+ZfStqjbIhIxB9rFvsuz/V0cgGKsQrdc2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400250137"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="400250137"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:42:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="822734649"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="822734649"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2023 03:42:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:42:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 03:42:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 03:42:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 03:42:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoygkBO15jzD1iSemZIihyk7auCnA18LS4L496xr5ZCInpzV063zPVIvgBoYW/358NkBPzYCYTIvraXIm1QFrRmNtAb1MJ+KrAWMckZUcVAJUXzMHTBZl6+KB0vptLyYFL7eHT3+jQc5BGS8XRBWx0c+ZPueecYqxDwG5QvLRwzR9BeW8dY0kOWq8SmRv89DW7m+KQNOHZASx67HL8y5wKPgRwqFF9mZr0pySMkj/m2nJSu2uFN893hmTJpVx6MjPBUNYMLyL6kBq1JNOHRv1TP4FwkvWKmxKTwOUpAJNhQg/6jEVehAsmjpyLNcXObAyTQivBaFsUD9LoePjGk3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvneFpO0jobsIlunl5rxrYy/rni02pQELgYzEZTZTXk=;
 b=Dsxt+AEeiFLlC43F1mn0HG3jpJCTW2zK4+fFcU8Yi9j+GhbU/445ISGS3Tld9xFvjjeczg0NYoZyROm+0UFdSBVhZFOBbweMWCfo2XJKSuoHVtJSLFTGoOHLjJ10szIIvQKMLayHkrlWWMeVW8MkqlrpNT94j4dNk9D34jz363dkFYN5BjFnLGp22eqVXNRGwMTN6SGsCy/OmRvbolt/h4bDVi/qIaNmYtYgBrb8BE2sh8A/f3cqUtvFasVbMqQoKqkduOBz3snde86zyLhXDi9tng9oe7bJRn4iXSinnINCH+WwGaAIBnsOgksRuqrBlWMIE74kqGH5WQf2CKHtYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6134.namprd11.prod.outlook.com (2603:10b6:208:3ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Wed, 15 Mar
 2023 10:42:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 10:42:09 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v13 005/113] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Topic: [PATCH v13 005/113] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Thread-Index: AQHZVQwsEyN8OR+uzUGmoOAGwNdYLK77q3uA
Date:   Wed, 15 Mar 2023 10:42:09 +0000
Message-ID: <70caa84177d8d4c3ace65663992ba4d72f939f4e.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <0545bd8a7b851d5b53cea16e7e4624b58dd9b71e.1678643052.git.isaku.yamahata@intel.com>
In-Reply-To: <0545bd8a7b851d5b53cea16e7e4624b58dd9b71e.1678643052.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6134:EE_
x-ms-office365-filtering-correlation-id: 941f985e-d415-4048-a232-08db2541ede1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9NQy/sRlhFgfgoDJlvSI5I9OPB5asTPjgQRgxNXHKX2EHnmuxN3RS9cI9OshFzIgvOvx6Stm2Q8pQqnIMUPDOYMiUOHtJt7RGrW9JmKFBX4qA7C7caUOlLYf8847LmIp3agXksoBv1CEV92Twicq8Z3jQo+L4O1LPGWlhszP6t3c3M6QiWV7HdmMGFP0J2/TsCpB+5q9EWPR8Dkqvhenkjx455LarwgiwUY5kemCuS9Gn2MSTCBLsINEaZxMFXo1W2Rjjak9t8miDd17tc+682QsmnR3Tp7pXyfFm4nRqv9Qc0+X5cbiumiMW1+vOIeXBVN3xfHTHMHL5IkI0XdRWIFR9KMmsllJlV5wro0zV/0wE2/gBnK5PxpZpqg1zarcz9hnCso/pV5QCQU3M0ZIVSOqg4iHCT7kf/AlOW4TF+ULO2J9AJcEO4SSazKt6VgUI/tYUBYSA6H0+eOK67buG0ZhwNETEvivHD1T0P26Rpe99PQJPioMHCJjTlBRWRFXBHcVhjGNnTEayVqRSn9Jt8TQ5e7pkW27soDWTM83Ma/afhsVzwF40g0QRLlDtihSPeVpQks4zaExDahl1QS4v/bKzoj+WNJwxzYPJpex8m4b0+BrZr3vKjp1bjLeelWjIFkVWXNvYI0Jy4FbTKn04pMQJMnbTWzlrxGiDvm+BLRuz3RBSvtH6+tLa9FI2FzyQQr67uqFzFqo2RAs0K+0vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199018)(38070700005)(2906002)(5660300002)(8936002)(26005)(36756003)(4744005)(64756008)(41300700001)(66476007)(66446008)(8676002)(71200400001)(54906003)(110136005)(76116006)(6512007)(316002)(6486002)(478600001)(186003)(66556008)(86362001)(6636002)(4326008)(66946007)(91956017)(6506007)(82960400001)(122000001)(2616005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkJlRFdzZ2tndkQ2ajU2OW5zR1pLdEM4bktwa05aZjhJMXNWUmlkYURNYTV3?=
 =?utf-8?B?TEdBdVdMUW5BZHlTQm10UFZ1L1BZS2FhaS9JaXJCNmJ1RGJEeDNEYnBKUno3?=
 =?utf-8?B?MENhcFYyZ3JId1VCaDRZZU8zU2pwN0ZIWlFGd0xRMEN1b205azlIcWZCZnly?=
 =?utf-8?B?YlliWkU4MFlGdWZYNzJrRk9GS0hSN0VMd0EreUpuTkY4Q0ZvVzhyS0M3S3Ju?=
 =?utf-8?B?TCt2TWpkV1RRWGV3U05kT05Db2tVSkZmTUQxSjUzcUcrQlZOL09UelVHcGFH?=
 =?utf-8?B?RytjSlhxUzZnSlJocDhGZzNqdEQvSnE2V0xEWFpGSys0QWRENHNGOXdBZFM2?=
 =?utf-8?B?a3NCb0w0R0xFVkhEaEVFbUxxdW11YnNTditPbDRIWFZaRldaWGVMQTJpVThm?=
 =?utf-8?B?b2Z0ZzE3OXA5Tk16NlBuUm51YjJENXVuWUF0U0E3d3MzRmd6azNLVmhkRTM3?=
 =?utf-8?B?bE9hNWdxMTdmZW1uM2MzM1lUaE5jdG8zUzRYYnZQNUE0SVZZOGRiMW9hZmRp?=
 =?utf-8?B?S3BIU2hmT0RreVBYZ1NZb2x2UGFnV3QwRm1LWjRSUkhyd3NMZGFiTEFuLzNC?=
 =?utf-8?B?SXR4RFFqUTBZbGVhZVRmWFRLZ0ZoQVpzQmUwSkpCVDhlTkp0eDFPVzNib3JB?=
 =?utf-8?B?dXpMQnloOFgvUERxNzBBTDJ3Y0NHeXZ6OEpBczNQTkN4Z0lrU291b3MwR0JM?=
 =?utf-8?B?Wm0yWXJ3ZHZYVmZkTHZnM293aDk4bGxZTlFEUkJadFEvOWtVWnZUbm9ndG1Y?=
 =?utf-8?B?cXp0OTVTZWtwMERseDFoK1pkK1dHYndEYU5UZDYyM1d5RjhZcm4zVU9lUmQ3?=
 =?utf-8?B?eWtlVTVhVDJuZTV0UEwxS0NyRWRLV040NEZHcnJNWmNBM2Z5cEU3Szd5K1hj?=
 =?utf-8?B?cmxPNXBrRDJyMlplak9JS0dBRHN3dGhaQlRvdnBrUXcvaHhNcFQrTFd1RlhL?=
 =?utf-8?B?OGNDMDJabTNQWGk4WjQydDNMZENRWTc4ZHJZSFdGb3N3QnF2eXNSMTFiMU1P?=
 =?utf-8?B?MFRHTysxM0lzNFVST3lSWGN3RlpOZlVXQkF2T2JiZ05QaDN1MDBmVWtrV3ZJ?=
 =?utf-8?B?OHhHTlZPTkZNR21BcFNVVWZrcm1yQXVIbWxuak9BbEt5ZDExQWVLZCtBa2Ux?=
 =?utf-8?B?QTBCQXZXSzhKTHd5bU9BU2dUVHY5eWFmQkFGaXJFUmhKblh1N25IRjJJU1Q2?=
 =?utf-8?B?b3p0cjF4MVJPWkd2TUduOXFLdlliaU5waEFOSlVFYUV6RW5tdDF6bkZMU0gx?=
 =?utf-8?B?eUFEM1RsbitLUHBkeFRsZk4yczlEQ2pDcTBWTGlubFBuTFp6SDNjMUVJSXlH?=
 =?utf-8?B?WHdEWDRyWTVJTldSL3dibUhJZzU3Z2dKWTVCZXhRNkxDY3FXc1JWZXFrODBP?=
 =?utf-8?B?dnJnbS9acU5PMndpeDg1azlNZFNiaEQ3ZFl6ejlkdUlaQlc1VThkeXNBaHo3?=
 =?utf-8?B?d25wOCtLNkVSWEJPSEFBVlkxdTdRMlU5UDFXdlB4RzBadVI5blBmVFBxcUlm?=
 =?utf-8?B?MTJyeWVBazUvUkMrU3Zlb1EwRHNPRFIzZnJjeVZCOEpKS1IveTQzaEFUVmw0?=
 =?utf-8?B?d0FlSHJVSlQzZXM3R0oyTXB6ODhkRDZZVDR1czE5KzRPdC93RTJoMkVRclFm?=
 =?utf-8?B?QXhONy8zaVNCQW5IWFRFZW1yWWk1RWRTK2hoYTArWmh6RGlMZFgwdWJueWpM?=
 =?utf-8?B?UWIvdVlkTitqdnNEN3Bia2hFU2lCMnpoNkMwYnRhWWlaeVNVTGhPOG0rVnNx?=
 =?utf-8?B?eFhwUG5BZ0JlRjJvbUlreWhmb21lMmRLMm9BZGp0R3dxSzlCUDg4M29GYXVt?=
 =?utf-8?B?WVN6NGJianpLMjcycGx0ZFhFcE4xY1pIRjN6RTU4UU9EQTh0QnRjZDJ4Q1FU?=
 =?utf-8?B?VUJ0VWFSZXhBUW5CU2tMQS96V3h5KzhseG9FNHV1aVRZQ3lqMzZ5aU5WRUZa?=
 =?utf-8?B?UGFMbHkyUmNkbWpJQ2JPa3N4d1k5T3dCU1l5M0NXOXFEK3FtMzZ6emtsNld3?=
 =?utf-8?B?aTZ3UUM2T0RzOHJQd2hBT2ZMV01yUEp2dUloMmY2L05teE9PUk1rcGs1b0lJ?=
 =?utf-8?B?U3ZBQUZjN2NOeU5KTEJuaVpDYmpZeXUxR1BHZzdIQzRvZ0hzM3hDZ1FBSHEy?=
 =?utf-8?B?ZGFES3pBUHJ4SzFXdTVFMlIzWWYyZS9ZeVU3RG83UzlVaEcvc2xwekNBWjlB?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <528DD1F0FB0F5C4C8BF1FA12B19996CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941f985e-d415-4048-a232-08db2541ede1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 10:42:09.6990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AP/ukWtZmddeGaEQlMcNYgjsLZcvrS9vaRTYdreiR1ulVeDGENhp/0ZACwscV3WpnnMjcgHNMmR6091r2KV8ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6134
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIzLTAzLTEyIGF0IDEwOjU1IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpc190ZChzdHJ1Y3Qga3ZtICpr
dm0pDQo+ICt7DQo+ICsJcmV0dXJuIGt2bS0+YXJjaC52bV90eXBlID09IEtWTV9YODZfUFJPVEVD
VEVEX1ZNOw0KPiArfQ0KPiArDQoNCktWTV9YODZfUFJPVEVDVEVEX1ZNIGlzIGRlZmluZWQgaW4g
dGhlIG5leHQgcGF0Y2gsIHdoaWNoIG1lYW5zIHRoaXMgcGF0Y2ggY2Fubm90DQpjb21waWxlLg0K
DQpBbHNvLCB3aHkgS1ZNX1g4Nl9QUk9URUNURURfVk0gPT0gVERYIFZNPw0K
