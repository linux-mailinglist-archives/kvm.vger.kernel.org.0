Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD72718A42
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 21:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjEaThB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 15:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjEaThA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 15:37:00 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA32126;
        Wed, 31 May 2023 12:36:59 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJKHf4026777;
        Wed, 31 May 2023 12:36:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=j5+TITpO0zL99JzVfWY8o3LHbjb5sT+oNIF+R7+d4GU=;
 b=zAIIHqzNb4boMvXsmPKgEZQSigZTiqOke0+rMw1vcGBiYXYT6sGC8BGI9pBBgWO8swHt
 F5GckY+4DQ5NqbYug0rhbVoNa1NpHP96n8ATVbgRBwm0c/BDcXowlUCgNj+kTRG6PnYW
 YAmsLKasAcshECJkx/UiIpej3OJAwsewBrrDOlN77TMU6SBQ9q5Xv4WuSzGlG1gs6SEo
 9QiwPt6zEBQxrAz31w5H6ctWMseAoVXoddzOTC+4EnaXuz2AFENSUZDXbGF28Xo5nPJX
 86xES5wlSqoS/IsmIUMGyDFvH8VHb/7iihNxC+fUKvK/KP0vlulh4kF+7CCIFo+nzBPF 4g== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3quh6cjxat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 12:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV1LVEVOm9nm0GBjXfUaOd5tVAjIDyRvSn+2dQd0/cAZNt/iXc2UkMaUHXLwSP2CsNb9AcyNUwY7+MZu0hPWt/mJBZ8miT94PJTRDbUvMTrAiK/qOSoGtxl3fQFLKXLkdTD+ybW2WcKjWEhkWu0er+9N2D7A/qeby+S6CZkVjUu1opGf4iB9FEjuZnYKwuSHFBFiMkhr5lFEo9ivERM7ShHH3VcOCa2eziQgVCNWT21G34DnEx2LMB+CTsJtGTan/kA7JKQX+1GzjYsZQO4xul096EpiyiP5xk6r3giHEF7YnagU/ssbET/zc+XJbHhOC0P5eL6TBsZPDsj3oQVAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5+TITpO0zL99JzVfWY8o3LHbjb5sT+oNIF+R7+d4GU=;
 b=ngiRJa5svpM5i3u7jzXZ/cKIVKvQXWZZLFNtX918wLA98KQnHbxk6LrOdbBOY/D72rbFE85WHPTno+jcmYzFmoe4vKRLLe1DnrmgBdSS/vQ0JgVz9LURFnsoAArJ36YUOSnARhK7FACS5BLZGiXDPHP8GCy3JDVCiKaQ4e7md+mgjxbAflx7sWB7i6B5muTY0NoYGXpJ9/Mzwirf/UGPKkTbWfmNSbMmu3iw8DrgagtbAzeQMC/lOpr2yUHyfgtgyS93XnQ7glaUvYkYcVf/3maQmYm+xCp+/xQ22Gbwv0wmqVWHZ3Yc1/rV8goZ3Y3CYHsWjR4AZ2taZ7JceasHAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5+TITpO0zL99JzVfWY8o3LHbjb5sT+oNIF+R7+d4GU=;
 b=PMXuaIuAOwyvYusWEKN0aFZY5edvRC9FjZ7mCRQAF3asyxk19igzmMnt1ZWkCpIBdKvYp65VmhhIZdRZbNphpqEyndE3G4I9KeyA92CIDmuvg5fq1wmpjUETEUkmaXSBGXn3wBQ0Q1JxErL/MSA9jAfueI4P6TPjF5i9NA5yc/vUbylk3ppRxoBXhPVsxt+Zpdl3fxC/IVduuKtoPbnQE/aLjgoh8weU4eCn3VIKSDe4MWl2LXWv6qE7Op4YYQm3MiGbePBRxFP1oY1JPKfzWE5MNo8boTsomMYyhTyzotHFjbkRiNSOSr8K29pub37aCrd1aHXPn9X6y737MoaTmQ==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA2PR02MB7820.namprd02.prod.outlook.com (2603:10b6:806:14e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 19:36:19 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 19:36:19 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Thread-Topic: [PATCH] KVM: VMX: restore vmx_vmexit alignment
Thread-Index: AQHZk9jCQoRbw9yyaUe0SKmRorIndq90sXmAgAAVLAA=
Date:   Wed, 31 May 2023 19:36:19 +0000
Message-ID: <35A1304F-2021-4062-A66F-30D8CD2F70FB@nutanix.com>
References: <20230531155821.80590-1-jon@nutanix.com>
 <ZHeP75vG8xA+UeHt@google.com>
In-Reply-To: <ZHeP75vG8xA+UeHt@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|SA2PR02MB7820:EE_
x-ms-office365-filtering-correlation-id: 2e3bd9e6-d02a-4f6c-3a22-08db620e4eda
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3cmtvw1PjFatxzXCkALlHZBJ7731FxrP+ZVNibSDhM49FRDRRg2I2wXwaVgzaiuys7o5AMJw3EWroxpFj74P5sR3QBz1/mk3T3siVgto1uyRzUb9b6lvjxgghH3dACnBrmC9T1u7yRZWn3ReOEbzUODT6HvLbJYeXyp8W2wItjLSPqCRhxzv6/sUp8XmRXE36zv6jhG6jnmPmcq0A/cZRXOevY4+WAJ5jtgYRJdBSbYyO6mYA5mtJTAFDgvxtZAiKZjncDiyyCOBNZABy7YYabq8dsxNqCohqQL4YjORaCQDUzxkrXNYYNOQTwxobc567LM0LyO2ndf4Fc7QwwHarvgFueq3o0buBTjOdO5KZb0rxA2ys73ZZx2z3ZuS3324yAj2EbTDRLS4nHt59Y96u71oqfqg1xqgZHAvYMm4BURg/wWu4MSocnsb8zJYODuZnTEMEwcK6IS4zqQYrCX8CRefZEXFXUQnvbPReftSON/szQWG+giys9eFHb3E4nUhJrlM8RUPVtdBLvLgeri7ttPCwZWmnRN6Coyih15GVWi1nJyfRhtcmQdyZu7trYCH4KyQlaZXVRp/WuuYoAI/zJ24Sud1X40qHHPnFI5vtlvOTfuDAtxViYS/8xeLaa9u+p0vJKPtWO7aVMIoai7E+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(376002)(366004)(396003)(451199021)(83380400001)(33656002)(71200400001)(36756003)(64756008)(66946007)(316002)(66446008)(5660300002)(66556008)(66476007)(7416002)(91956017)(6916009)(4326008)(86362001)(38070700005)(8676002)(41300700001)(38100700002)(8936002)(122000001)(6486002)(76116006)(6506007)(186003)(53546011)(2616005)(54906003)(478600001)(2906002)(6512007)(4744005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3Z2VnFueGErdzk5ckJONGJ6emRZUWNsMlZrRCtXcTZhazhLU25mZEQ1NkFS?=
 =?utf-8?B?UFh1L2ZRRTZ2S2h3Yy8wai9YUHVaM2xOOW5WcVRZVUdUOHdCSVBPK0tlVklt?=
 =?utf-8?B?VzJ5VG5WZmxITzZ4clZsM3FGUUJ3Ym5BNHZUc2JnRU1oUG5ZTVhDTXU2Y3pz?=
 =?utf-8?B?eXNxK2pJRnQraE5VcWl6eXpQenE4czJQUENzN0F3N0ZmbXVZVW9rWUZYOWFF?=
 =?utf-8?B?T1FiOVFiNWcwbHJDaFM4VGxOMktGc242SnRINWw1WmFhQ2JZNFRsejlXRGZ0?=
 =?utf-8?B?MjNNbzNNQUtheUhhZEpyWk04UG1TZVEvS0NJZEl2cDgvMGo2UTI2YXBwSVZM?=
 =?utf-8?B?dUdPQlcveGpoRUNkS09JU2xxYmI5ZytVUXBqYU9teTBLckJGNnA4TVhqM2x5?=
 =?utf-8?B?eWl1eDBVT3RhNEMxZ1JGVmpwM3NqUzJHUnVuR2VPbWV3djk1U2gwWlBvN00y?=
 =?utf-8?B?b0xsbWQyYmFRQ1h2dVZIRGRCSmVZcytKUFZ5Zm9rdWNlcXZjSnh6eTZzNlB2?=
 =?utf-8?B?RDZ6Uzl0Y2lzOXZLeE13MlJXNytMKzE4TWc1alYzN09JN0tmL2JlS0lrV1NF?=
 =?utf-8?B?UDFXNXBJelMxU0t6dzMvd1hOMis5eGFtRk5RMTFCM3VtRWlyL1VpbWJWQnNF?=
 =?utf-8?B?QkxKZDMzaUIxaHlramt0cGVOcDh4d3FvYWhhYnl6eFduN01uQVF4c09KVk81?=
 =?utf-8?B?ckRDaFljMFdNa0tGM1VWU0krTnVXYVg0bUMzL3NUYmJsQlFaTEF1VmJPb0Nv?=
 =?utf-8?B?UnlRUG5pV2FWczlTQ2xSNDBKWEhJMmx6YVFGbGsrN29ucnRtYXgzNlo4aExq?=
 =?utf-8?B?T25BbTZNbHFzZGd0dU52Qk1PU3U0c0g5T3AxSlJQaFIrN1NsSUt6am5pSHd1?=
 =?utf-8?B?VmFxT3NZblphemVyNmxNM2ZhM0lyRU8zbEtKbEFOakFuN3A3c0Vvd045d3pI?=
 =?utf-8?B?RVhkU3czbjAzaVlWNWRzNStxWUZrc2xzdXpuZjdjcnBzZ0ZpelJWNi8vVzd5?=
 =?utf-8?B?R3N3cGphUTAxUXA1VFM3dmpXK2lSaXE0dEw4SmdOdjhZRGNKUFFtelRMNXow?=
 =?utf-8?B?cks2R2lxZGhQSXNPeHp6dmRrQXNVV3VDTkRpNkpxcVM1UC9uZGY5dWdYZWps?=
 =?utf-8?B?RFFYV1NPNmhETEhJV2ZtQlQwMzRzMWRvOVNjajcxYUdlSGd1bm5aZjI4NHcy?=
 =?utf-8?B?a2ZwZlJiOGdnV3MvSERLNmp5TjlUR1BjRC94aUxOLzNCYmJ3SmFlaldVSjFR?=
 =?utf-8?B?ckRoVmJMbGdMU0gzSkNxeUxhU1ZRZ3RCYUh6cTV6UDJmZ0JWU2trbVZPM3dI?=
 =?utf-8?B?MGdWTWFuaGtObGVwczdtcko4MisxZ0VpcnZuYitTRWp5emt4UTIwWS9aZzg5?=
 =?utf-8?B?RFpGc294SS9tNmkzSkxRdzUvNVFMLzB0b0E5R0s1MFpZTjhxOXpMb1IyQjZN?=
 =?utf-8?B?RGJFcnVOcm5UcUoveVpNLzJSakxOc1d3ZXJVc0JhVFA0Z1FTTkt1MTliaEZU?=
 =?utf-8?B?QThkamJjblNjQ0l1b1Mxak92TEV6VnhJaWJxcTY1Y1lnMnRoaTJDeG5FMmZi?=
 =?utf-8?B?VFAvNndzQnorL1BuZFFzcnRxL0lyVFRlTXZRcFpBazZDTTFLVEEyVHNEUTV3?=
 =?utf-8?B?TWJXdUJsV0NoZnJYTUo0UU82K1EvODlSSnRIdGpIWmt6ZmhyNjV5cVdSd25L?=
 =?utf-8?B?Z3l1dWZPSFo1cEdwTSttM1NnZlpQbTd4TGdVdythR21zZ0Q1Mm5sWklpZ2R3?=
 =?utf-8?B?UnBFNlpNTEpwTmhDeS9jdDFQeFdrakU5b1g3eXQ1NWJmQXU4THVTck8zR1Bl?=
 =?utf-8?B?R0ptcVduTE9UTXdYM1FxTjJpamlDaXlMRVhYYzZuRG5SandYMjF6TU1XcUM2?=
 =?utf-8?B?cnBiQVc2L0d2RFliYmlZZ09LUzJPZzdnR0t3bnZyWTV2UFJyUHBrWEE3R0lk?=
 =?utf-8?B?VnQzNzdhSUpoakxaZUtWb2JjaGZKYituNmJUN2hrZWUzSlVrMkFqRFJsckJ4?=
 =?utf-8?B?SHFxSkF3Q2JkaXRZNW5ESEVhOE44amRvcnBZTERzRnNES2NvS2RBbW1Va2li?=
 =?utf-8?B?OHZlR3RjUE9SaTYvMWNkSlVhRURDSG1GMU1SQ3NyaHAwQ1NOdHRZRWhqaDNa?=
 =?utf-8?B?QjFSUVlCQ2lESXB6Nnl5bWJ1WWNHZDJLVStqN1ZxZi8wMXR0WWhMV2kyQmZv?=
 =?utf-8?B?cC8rOWI2YVRTcnkzVENQR2N6V09WSENYZFd5ZGJGRWlkd1ZrSGt5UGFZK2Ft?=
 =?utf-8?Q?9R8eq5xQ8vlkJXzKQxOoEyVfZyT7DXOySIWGLtlpb8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A117713CA3380547A62975D8D180A41D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3bd9e6-d02a-4f6c-3a22-08db620e4eda
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 19:36:19.4700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /aAhYxwUCDFobwCl8uBUfHyenK1QGlJ23nUjfLlTYP1Cl7uNhzKmc6mdzV7r7Vnq7IzS2XJSkvioqZZEEOblaoDwy/Ju9iaxhyAzEMIJJh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7820
X-Proofpoint-ORIG-GUID: jGZhRY6tH3PbLS9tWZHi_EtqoCSx94tt
X-Proofpoint-GUID: jGZhRY6tH3PbLS9tWZHi_EtqoCSx94tt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCAyOjIwIFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAzMSwgMjAyMywgSm9u
IEtvaGxlciB3cm90ZToNCj4+IENvbW1pdCA4YmQyMDBkMjNlYzQgKCJLVk06IFZNWDogRmxhdHRl
biBfX3ZteF92Y3B1X3J1bigpIikgY2hhbmdlZA0KPj4gdm14X3ZtZXhpdCBmcm9tIFNZTV9GVU5D
X1NUQVJUIHRvIFNZTV9JTk5FUl9MQUJFTCwgYWNjaWRlbnRhbGx5DQo+PiByZW1vdmluZyAxNiBi
eXRlIGFsaWdubWVudCBhcyBTWU1fRlVOQ19TVEFSVCB1c2VzIFNZTV9BX0FMSUdOIGFuZA0KPj4g
U1lNX0lOTkVSX0xBQkVMIGRvZXMgbm90LiBKb3NoIG1lbnRpb25lZCBbMV0gdGhpcyB3YXMgdW5p
bnRlbnRpb25hbC4NCj4gDQo+IEFueW9uZSBrbm93IGlmIHRoaXMgaXMgdGhpcyBzdGFibGUgbWF0
ZXJpYWwsIG9yIGp1c3QgbmljZSB0byBoYXZlPw0KDQpJ4oCZbSBvbiB0aGUgZmVuY2UsIHRob3Vn
aCBteSB2b3RlIGlzIG5pY2UgdG8gaGF2ZSwgaXRzIGJlZW4gdGhpcyB3YXkgZm9yIGEgd2hpbGUs
IA0Kbm90aGluZyBhY3RpdmVseSBicmVha3Mgb25lIHdheSBvciB0aGUgb3RoZXIsIGFuZCBJIGRv
buKAmXQgdGhpbmsgdGhlcmUgaXMgYSBzcGVjaWZpYw0Kc2VjdXJpdHkgY29uY2Vybi4gSXTigJlz
IHRyaXZpYWwgZW5vdWdoIHRob3VnaCBzbyBpdCBjb3VsZCBlYXNpbHkganVzdCBnbyB0aGUgb3Ro
ZXIgd2F5LiANCg0KV2lsbCBkZWZlciB0byBKb3NoL3RoZSBjcm93ZCBpZiBJ4oCZbSBtaXNzaW5n
IHNvbWV0aGluZyB0aG91Z2gu
