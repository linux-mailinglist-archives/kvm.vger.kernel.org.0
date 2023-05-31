Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47946718B9B
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 23:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjEaVLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 17:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjEaVLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 17:11:10 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21831B3;
        Wed, 31 May 2023 14:11:04 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VK4T1v020125;
        Wed, 31 May 2023 14:09:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=9ZsAPNgW0vnSRZ0aKp/4s3pdJe+N2qhWGiswhzhRhuI=;
 b=WlXbaBQ6xgjNv1A56VA603XlykcLxlWEWc66RlYyTqXNb1C7uycowWcu5StCQUWeM44l
 H7tSn3AsRt9j4y3TH4kCsi+KZgTK3sRNAKEOjVKXYOn2Nxl6HQrfSPas8pwKLxDRTpha
 9Z4IZK+H9YEdZjpQ2+VTSW/Pz30U3pgxYHVREg2r9Lkz1c9jVKp3DJdKUEEal5Ind3QY
 5cIAbXL7QrL+S0E6po/K0zKjYy7mnptSqiLFbI1Jg8kuqp0lOBaJZkqOFPHG+SxpkKHw
 hSnZ6hOr7H0NNDhX72AccbgwmCfzLnbhlFm2dGvD+VvIblp+KC8s+TyAzvhrYiei6taE fQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3quhcxtyq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cc2t6h52C/ef+EN+TSQDBt9jz0+K6EjjrHVhQC3H858T5NVldOUwN0GkzR7glqhT+cyJRMGTQLwYvqe9AeQASY22Tyce6gwSzcYshjy+m7GSDarf3674VBUoMWci/aqvidjEBSFQQfvRhP+iHmryU1MQVuuaUFxMgU/A/w49/5n0/9bBCoDyxy4eeNx8pvZJKURSxjw6yUReBSciE0NZLA9rN7aW4ZrTkJW2HeidC0PyzPOGEPVI1vJ5M8eRuzhBJ54QDC4gVHEt1/90RYOIlEWZqs1TIaseYtZHCdYreCJc/FlJCHeuQJm/vSTtAXJQRybHt54TivVOndLKbdSIRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZsAPNgW0vnSRZ0aKp/4s3pdJe+N2qhWGiswhzhRhuI=;
 b=jv3gXr2GI5Gq2IlBaKqiYdj0einqLLGFimzCINbhSiomGRKBY9vNkyj8qC2g8Cw3dF7bb2dKnP0MvHtt8GpCGL9X1SuS83HujIN+VAAP49P5xeU6faWUcW3sewirdJ++DzCGBumyMZAzoV04mQ7WGaVSWtX5VW+opPTBvPYuM3ypC8NRyMk7xiJM/rcSTa2iOEyMk1RqmbpXn1gLqk/xQ+U4wwWLut5LDPW3pbqKjk834b8QW976lZAH1lTC8AY+qEZY4ucst4Jvyg1tlmLKkzVEbjzPSkbCQsFQi7FPBakATWHlRTPKg9q+sGKLzfdTJvY103fH4YxgibzuInJhRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZsAPNgW0vnSRZ0aKp/4s3pdJe+N2qhWGiswhzhRhuI=;
 b=Zpq6apbJ31IeTVGgcnCkkeBDSELMhygGTu56eDfyGIdzUiFb0PDbDjXinl8xTGhvmJM5iW4aOcQGNPrXiF+nDGusW5C4FF5UD3pFPklnue6P3r/+b8tEtWDrLaYszIimjPC1ScUVcrQbrVbDogetu908uSzsDDLTFq3CbZITk4g9TfrPVfSpPotIilqQl9RaY6NXPafj7MSzInBG8ZB9KLuFql1dA9O5XB0FZkatYTsTLGxhi8Ydi2A0SqruxShL3s4QZHvXIP0PM94bsWNi2oTzusfihwvnNS4TlQmiPE7KGcB2zhbGYtNzV69iD2aXkbnL/v0UioAEopBU9t2dtA==
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by CH2PR02MB6759.namprd02.prod.outlook.com (2603:10b6:610:7c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 21:09:56 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b138:ab35:d489:67f%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 21:09:56 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>,
        "neelnatu@google.com" <neelnatu@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Thread-Topic: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK
 set
Thread-Index: AQHZkzGeQS8mbCm9w0qDUFkji8V8m69zY/WAgABO2ICAAOFbgIAAOsmAgAAE0QCAAA5YAA==
Date:   Wed, 31 May 2023 21:09:55 +0000
Message-ID: <CBFC095A-10D1-4925-9F28-DEDEBBB38EF8@nutanix.com>
References: <20230530200152.18961-1-jon@nutanix.com>
 <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
 <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
 <ZHermsSGQBcDD07R@google.com>
In-Reply-To: <ZHermsSGQBcDD07R@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR02MB4579:EE_|CH2PR02MB6759:EE_
x-ms-office365-filtering-correlation-id: 1affcf00-4ca4-4bad-8f37-08db621b6287
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5fIoBOK5eMfyzafcLHXoM4CnffOkgS2zanGQOkZVvTTxdK2/eS2MmjTa0+YMw7toaYtpGwHmZUhPRCWT/CgUQBJvTTgsmJ0gY6QIzFYTAIl52u41uhEc7O6lUpL9imf9+EUTtls+RMF5yBTsG2ILxioV7w2uxo6z3oTftcTFKTQ736Oki6hpcg53Kaaeur9MXAJ/BAyVKdgCz5xUmqPchpwsiOP3wP3O67fWFGDcbmMq5jOCIRf53x0/v7HmjgIB4ct7jp4F95L3Ij2Y/SIxRO1qChnd0EVufgr7aYzzpPUVEpPxEwhXRCr2Yt93tfkUrVhsAUjK/Ohs5584LX67donWuACIYzRDZ8LEeACZpHcXoZupGIDIKjmRiQJxQDI1RQ5VmI5HFAmnRBA7pcchvB/PAIUKBNHgun6mKt7XuT8w72sB7DFj/CRlUfdeICypdfZoboms+st43Cg4/dA6oWZEBsigMQFC+xMPW2yKtw8cJh4u4ByT0AVSGh0x6nrNPrSkV4D2Igs8NKsrU7DEqX4boT0RpDj702sWyJ7hM6lRQwj2TwvK7koHpM9nnrr1jbrAmtNDLRCQL7vq/kuiS/E0wmAX/NchuiNNBZ+ASUC8MBbQR6QpZa7IE+eyLB1UqwBKka36iviFg2rp10vryg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199021)(54906003)(478600001)(71200400001)(2906002)(5660300002)(66446008)(8676002)(7416002)(76116006)(36756003)(8936002)(86362001)(33656002)(38070700005)(91956017)(66946007)(64756008)(66556008)(6916009)(4326008)(66476007)(122000001)(316002)(38100700002)(41300700001)(2616005)(186003)(6512007)(6506007)(6486002)(53546011)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S21UV0JFN0RiS0lLVWE1enlmRXF3SXlLQ3ljWS90b0VQK25WY3U4SzJ6aXpk?=
 =?utf-8?B?dUVaa3VDYllrQ2pFN1BxQmhmMXJrVXZpb05LYmF1cC9UOWdialNrc1RKQVJF?=
 =?utf-8?B?aDgvRENGMGZGRExOdGpkaVBoV01sZEhoOUVZY0hsdnEyNXI2cmprVWQvbDh1?=
 =?utf-8?B?azFTOEVJRkZHOUN6cVFPTGZERmZPS3NBYjh3a3ovd0lXdmppRlFTQWljQ0F1?=
 =?utf-8?B?V2hLTFpaWGpwMFNlcW1PTHFFTTBPbFE3QzB2OEhPdnpqY05SN2prUFFJdTFu?=
 =?utf-8?B?aVN3QWJVVTJZMkJNaDFmd0tvbzZuT1IxZy9RTGxMbEV1Nk5UWjFrdXIvZXBF?=
 =?utf-8?B?Tkd2V203ZmdZUnd6NUVGMmRObVhsdDBub1lPbDAzOExVSThlcDhyKzVDSjBI?=
 =?utf-8?B?ZkFCd2ljTGdFbUtMK2ppUkxLUmhMdmEyek1YUVEzbktLRVd6VHROUCtuS3dG?=
 =?utf-8?B?TkloU09rUS9KN1UreDNZcDhJZDh0bFh3Sy80WU1jS3F4cmxnWHVrazQyaUFz?=
 =?utf-8?B?RjZwcnh6b1RjMmNWVCtZamE3WUFQT2tKRFFOVEc0UkxwQlg0YXAxUjV4a3lu?=
 =?utf-8?B?ZkFJWGF1RldBbzdTUHJhT3RISlMxRmpQazdaa1dzWTRqR2lIL1hkRkNhUHp4?=
 =?utf-8?B?RnNXeFpybHpPUVl6Wi83cjBCMFpmeFBvdnFzYVhyajdPRVdsSmVDN0sxejVn?=
 =?utf-8?B?OVBYVDJhMVlTb3NML0JCYWI1M3lEMzNBK0FXejVQK3MzR2NZWXNlQzk5SFhy?=
 =?utf-8?B?NXdzZmF0VzFTQXhSU2Jyamc5WUh1aFlTRnFvem1FemtyRGJxRnJaWmcvd3Vh?=
 =?utf-8?B?ZFBVZExkTUhTaFEzdmllVlRmaUNabFVHeU1GTFpzNk5sWFlLUlhNb2hwWERv?=
 =?utf-8?B?UTZma2kwYzZMczFJMmthSUJ2OHBCM3FuL3l0V0JEb1BPRGNyZ254NmlzYzFV?=
 =?utf-8?B?Vkd2QzBBdzhMMXRQakZkM294bCt4c1dhWGs5cXIzMk5QRlJkVXh6Qm5UOXJ1?=
 =?utf-8?B?TDdxcC9Oa3V5TjB2b1hVeXZvSXdRQlByS1ZJbUxBOXhJSzduRGxtVFZscGE0?=
 =?utf-8?B?NE9iVVBBalJhQzBmS2R1RjkrOVN0YlRWekduYWg5UWN6b0xwQ1dOV2Y0YWla?=
 =?utf-8?B?UkgxdDN1NzdCYWZMMHFxUWFkbnhtZzRGblRKV0t0NGdYbjFDVDExYURUL0Z1?=
 =?utf-8?B?a2hDTkg3dDlDdVdBbXBBZm10bUIwcFhKS21uNFZSZis3dHp3eVV3M3lyZXQr?=
 =?utf-8?B?aktvTm1TdS9SS1BSR2pjVnl2VkY3Z3ZkSlNTcmhtTFJLcWUzNFRMR1VBeGNH?=
 =?utf-8?B?U2w1SmhoRVh4UXhZRCt0S2FnZzBwSUZOMnJManJaVmpKNFNRcXZmQkMzV1c4?=
 =?utf-8?B?Rm1QeXBiUCs2QXRMVENRYzZxbVQwN3Byb2JVUEdiNDYrWnlSQlhJT2czMnZl?=
 =?utf-8?B?WE1qeDRZRDlmRGcrM3dZbTE3R3BTSTVYQi9CVWY1RklVRUlOK3JLRUsrSG9r?=
 =?utf-8?B?UEQveDkvWCtBOUZ3WURCYVhaWkhHOTZXRFlYNkxLajdQcmI5VDJzMUdOV29J?=
 =?utf-8?B?Y3BwbkVuUmZoV1VqclBiaHBqNXhuNE1xRElqbXEzMEg4SlZpazFudWlsbEtG?=
 =?utf-8?B?RExnY3RyamEyTmNoRzQyZWJacmNYazA1cXJ6Q2dKa3AwdUQzeE5NbGUvQUE3?=
 =?utf-8?B?bzQ4LzN4T1VjME8wbFB5elhkR0dzV1JZT2pWeVpQME9OK2pFZTdIaHlGeG11?=
 =?utf-8?B?SFlMVmlwWXFHODNZTWlneTVkV0F6NXk5ZUthTWVFYll2WE9yaXZsUlJtUy9z?=
 =?utf-8?B?NDkzUG5nbVRnUUdaVGRUbENaeWF5NmIzdTErVFRYVkcrbDJsN1lENithYWdI?=
 =?utf-8?B?RWZKOEpuSFlCZmFvSnc5RlUvQXJhL09ZN25sc0F4VWxyRW8rbmFWTXl1VFpK?=
 =?utf-8?B?dXplL3NkVTVRQVNCcitsVVBKRERqckpUbG1vM1Q5dlV3ZWlCd2RsTUR6dkxp?=
 =?utf-8?B?dWRTcmRUaWRxTVlZeXI2VGFyeTVPSWJqczZpNUJZcGFxbWZvRnZON2xXejNi?=
 =?utf-8?B?c1V1SVdQeDZDUmxJVVVYS0Q0QkJtRHI2T1Z0ZmR2Tk5ZdEhnUGgvQmNLQlkv?=
 =?utf-8?B?aWE0c2NOeS8xZy9tWGd2Vkx0YlZwTDdDamRzNXdBOFpSK0Ezdzh4UmcvSWVZ?=
 =?utf-8?B?RTN4N1NQemdwMXhkSjUrNkRSVjhHUHE1NlBMdHlxWCtUVS84bHBHQnlFeHM4?=
 =?utf-8?Q?LLJhibJKFZoD4nYNXQkNIF7gY1dIWWh/2AUHHHRKcg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A21CA2C4CBE7F147B036CE1B83E02FCB@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1affcf00-4ca4-4bad-8f37-08db621b6287
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 21:09:55.9662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: erAf5rGKu8Ws/c6UsZKfyJDXn8PM5XWndlh5yXUv33ZQB1zr54r+4VEyoRUPcfPW0q0MyY0V7a1qA/A+e9PANaCSAHAdEgBats02Kv7CnFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6759
X-Proofpoint-ORIG-GUID: 4rnQ4GkWTvpTN_BdFG3ov2USF1Kckozt
X-Proofpoint-GUID: 4rnQ4GkWTvpTN_BdFG3ov2USF1Kckozt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_15,2023-05-31_03,2023-05-22_02
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

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCA0OjE4IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAzMSwgMjAyMywgSm9u
IEtvaGxlciB3cm90ZToNCj4+IA0KPj4+IE9uIE1heSAzMSwgMjAyMywgYXQgMTI6MzAgUE0sIFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4+PiBDYXZlYXQg
IzE6IGNwdV9mZWF0dXJlX2VuYWJsZWQoKSBoYXMgYSBmbGF3IHRoYXQncyByZWxldmFudCB0byB0
aGlzIGNvZGU6IGluIHRoZQ0KPj4+IHVubGlrZWx5IHNjZW5hcmlvIHRoYXQgdGhlIGNvbXBpbGVy
IGRvZXNuJ3QgcmVzb2x2ZSAiY2lkIiB0byBhIGNvbXBpbGUtdGltZQ0KPj4+IGNvbnN0YW50IHZh
bHVlLCBjcHVfZmVhdHVyZV9lbmFibGVkKCkgd29uJ3QgcXVlcnkgRElTQUJMRURfTUFTS19CSVRf
U0VUKCkuICBJIGRvbid0DQo+Pj4gc2VlIGFueSBvdGhlciB1c2Ugb2YgY3B1X2ZlYXR1cmVfZW5h
YmxlZCgpIHdpdGhvdXQgYSBoYXJkY29kZWQgWDg2X0ZFQVRVUkVfKiwgYW5kDQo+Pj4gdGhlIGJl
bG93IGNvbXBpbGVzIHdpdGggbXkgY29uZmlnLCBzbyBJIHRoaW5rL2hvcGUgd2UgY2FuIGp1c3Qg
cmVxdWlyZSBhIGNvbXBpbGUtdGltZQ0KPj4+IGNvbnN0YW50IHdoZW4gdXNpbmcgY3B1X2ZlYXR1
cmVfZW5hYmxlZCgpLg0KPj4+IA0KPj4gDQo+PiBZZWEgSSB0aGluayB0aGF0IHNob3VsZCB3b3Jr
LiBJ4oCZbGwgY2x1YiB0aGF0IGludG8gdjIgb2YgdGhpcyBwYXRjaC4NCj4gDQo+IEkgcmVjb21t
ZW5kIGRvaW5nIGl0IGFzIGEgc2VwYXJhdGUgcGF0Y2gsIGhhcmRlbmluZyBjcHVfZmVhdHVyZV9l
bmFibGVkKCkgc2hvdWxkbid0DQo+IGhhdmUgYSBkZXBlbmRlbmN5IG9uIHR3ZWFraW5nIHRoZSB4
ZmVhdHVyZXMgbWFzay4gIEkgdGVzdGVkIHRoaXMgd2l0aCBhbiBhbGx5ZXNjb25maWcNCj4gaWYg
eW91IHdhbnQgdG8gdGhyb3cgaXQgaW4gYXMgYSBwcmVwIHBhdGNoLg0KDQpBY2ssIEnigJlsbCBk
byB0aGF0IGFuZCBtYWtlIHRoaXMgaW50byBhIHNtYWxsIHNlcmllcywgdGhhbmtzIGZvciB0aGUg
aGVscCENCg0KPiANCj4gLS0tDQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bn
b29nbGUuY29tPg0KPiBEYXRlOiBXZWQsIDMxIE1heSAyMDIzIDA5OjQxOjEyIC0wNzAwDQo+IFN1
YmplY3Q6IFtQQVRDSF0geDg2L2NwdWZlYXR1cmU6IFJlcXVpcmUgY29tcGlsZS10aW1lIGNvbnN0
YW50IGluDQo+IGNwdV9mZWF0dXJlX2VuYWJsZWQoKQ0KPiANCj4gQXNzZXJ0IHRoYXQgdGhlIHRv
LWJlLWNoZWNrZWQgYml0IHBhc3NlZCB0byBjcHVfZmVhdHVyZV9lbmFibGVkKCkgaXMgYQ0KPiBj
b21waWxlLXRpbWUgY29uc3RhbnQgaW5zdGVhZCBvZiBhcHBseWluZyB0aGUgRElTQUJMRURfTUFT
S19CSVRfU0VUKCkNCj4gbG9naWMgaWYgYW5kIG9ubHkgaWYgdGhlIGJpdCBpcyBhIGNvbnN0YW50
LiAgQ29uZGl0aW9uaW5nIHRoZSBjaGVjayBvbg0KPiB0aGUgYml0IGJlaW5nIGNvbnN0YW50IGlu
c3RlYWQgb2YgcmVxdWlyaW5nIHRoZSBiaXQgdG8gYmUgY29uc3RhbnQgY291bGQNCj4gcmVzdWx0
IGluIGNvbXBpbGVyIHNwZWNpZmljIGtlcm5lbCBiZWhhdmlvciwgZS5nLiBydW5uaW5nIG9uIGhh
cmR3YXJlIHRoYXQNCj4gc3VwcG9ydHMgYSBkaXNhYmxlZCBmZWF0dXJlIHdvdWxkIHJldHVybiAl
ZmFsc2UgaWYgdGhlIGNvbXBpbGVyIHJlc29sdmVkDQo+IHRoZSBiaXQgdG8gYSBjb25zdGFudCwg
YnV0ICV0cnVlIGlmIG5vdC4NCj4gDQo+IEFsbCBjdXJyZW50IHVzYWdlIG9mIGNwdV9mZWF0dXJl
X2VuYWJsZWQoKSBzcGVjaWZpZXMgYSBoYXJkY29kZWQNCj4gWDg2X0ZFQVRVUkVfKiBmbGFnLCBz
byB0aGlzICpzaG91bGQqIGJlIGEgZ2xvcmlmaWVkIG5vcC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gYXJjaC94
ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oIHwgNyArKysrKy0tDQo+IDEgZmlsZSBjaGFuZ2Vk
LCA1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1
ZmVhdHVyZS5oDQo+IGluZGV4IGNlMGM4ZjdkMzIxOC4uODg2MjAwZmJmOGQ5IDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlLmgNCj4gKysrIGIvYXJjaC94ODYv
aW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oDQo+IEBAIC0xNDEsOCArMTQxLDExIEBAIGV4dGVybiBj
b25zdCBjaGFyICogY29uc3QgeDg2X2J1Z19mbGFnc1tOQlVHSU5UUyozMl07DQo+ICAqIHN1cHBv
cnRpbmcgYSBwb3NzaWJsZSBndWVzdCBmZWF0dXJlIHdoZXJlIGhvc3Qgc3VwcG9ydCBmb3IgaXQN
Cj4gICogaXMgbm90IHJlbGV2YW50Lg0KPiAgKi8NCj4gLSNkZWZpbmUgY3B1X2ZlYXR1cmVfZW5h
YmxlZChiaXQpCVwNCj4gLQkoX19idWlsdGluX2NvbnN0YW50X3AoYml0KSAmJiBESVNBQkxFRF9N
QVNLX0JJVF9TRVQoYml0KSA/IDAgOiBzdGF0aWNfY3B1X2hhcyhiaXQpKQ0KPiArI2RlZmluZSBj
cHVfZmVhdHVyZV9lbmFibGVkKGJpdCkgCQkJCVwNCj4gKyh7CQkJCQkJCQlcDQo+ICsJQlVJTERf
QlVHX09OKCFfX2J1aWx0aW5fY29uc3RhbnRfcChiaXQpKTsJCVwNCj4gKwlESVNBQkxFRF9NQVNL
X0JJVF9TRVQoYml0KSA/IDAgOiBzdGF0aWNfY3B1X2hhcyhiaXQpOwlcDQo+ICt9KQ0KPiANCj4g
I2RlZmluZSBib290X2NwdV9oYXMoYml0KQljcHVfaGFzKCZib290X2NwdV9kYXRhLCBiaXQpDQo+
IA0KPiANCj4gYmFzZS1jb21taXQ6IDM5NDI4ZjZlYTllYWNlOTUwMTE2ODE2Mjg3MTcwNjJmZjdm
NWViNWYNCj4gLS0gDQo+IA0KPj4+IEknbSB0b3RhbGx5IG9rIGdhdGluZyB4ZmVhdHVyZSBiaXRz
IG9uIGNwdV9mZWF0dXJlX2VuYWJsZWQoKSwgYnV0IHRoZXJlIHNob3VsZCBiZQ0KPj4+IGEgcHJl
cCBwYXRjaCBmb3IgS1ZNIHRvIGNsZWFyIGZlYXR1cmVzIGJpdHMgaW4ga3ZtX2NwdV9jYXBzIGlm
IHRoZSBjb3JyZXNwb25kaW5nDQo+Pj4gWENSMC9YU1MgYml0IGlzIG5vdCBzZXQgaW4gdGhlIGhv
c3QuICBJZiBLVk0gZXZlciB3YW50cyB0byBleHBvc2UgYW4geHN0YXRlIGZlYXR1cmUNCj4+PiAo
b3RoZXIgdGhhbiBNUFgpIHRoYXQncyBkaXNhYmxlZCBpbiB0aGUgaG9zdCwgdGhlbiB3ZSBjYW4g
cmV2aXNpdA0KPj4+IGZwdV9faW5pdF9zeXN0ZW1feHN0YXRlKCkuICBCdXQgd2UgbmVlZCB0byBl
bnN1cmUgdGhlICJmYWlsdXJlIiBtb2RlIGlzIHRoYXQNCj4+PiBLVk0gZG9lc24ndCBhZHZlcnRp
c2UgdGhlIGZlYXR1cmUsIGFzIG9wcG9zZWQgdG8gYWR2ZXJ0aXNpbmcgYSBmZWF0dXJlIHdpdGhv
dXQNCj4+PiB3aXRob3V0IGNvbnRleHQgc3dpdGNoaW5nIGl0cyBkYXRhLg0KPj4gDQo+PiANCj4+
IExvb2tpbmcgaW50byB0aGlzLCB0cnlpbmcgdG8gdW5kZXJzdGFuZCB0aGUgY29tbWVudCBhYm91
dCBhIGZlYXR1cmUgYmVpbmcgdXNlZA0KPj4gd2l0aG91dCBjb250ZXh0IHN3aXRjaGluZyBpdHMg
ZGF0YS4gDQo+PiANCj4+IEluIF9fa3ZtX3g4Nl92ZW5kb3JfaW5pdCgpIHdl4oCZcmUgYWxyZWFk
eSBwb3B1bGF0aW5nIGhvc3RfeGNyMCB1c2luZyB0aGUgDQo+PiBYQ1JfWEZFQVRVUkVfRU5BQkxF
RF9NQVNLLCB3aGljaCBzaG91bGQgYmUgcG9wdWxhdGVkIG9uIGJvb3QNCj4+IGJ5IGZwdV9faW5p
dF9jcHVfeHN0YXRlKCksIHdoaWNoIGhhcHBlbnMgYWxtb3N0IGltbWVkaWF0ZWx5IGFmdGVyIHRo
ZSBjb2RlIHRoYXQgSQ0KPj4gbW9kaWZpZWQgaW4gdGhpcyBjb21taXQuIA0KPj4gDQo+PiBUaGF0
IHRoZW4gZmxvd3MgaW50byBndWVzdF9zdXBwb3J0ZWRfeGNyMCAoYXMgd2VsbCBhcyB1c2VyX3hm
ZWF0dXJlcykuIA0KPj4gZ3Vlc3Rfc3VwcG9ydGVkX3hjcjAgaXMgdGhlbiBwbHVtYmVkIGludG8g
X19rdm1fc2V0X3hjciwgd2hpY2ggc3BlY2lmaWNhbGx5IHNheXMNCj4+IHRoYXQgd2XigJlyZSB1
c2luZyB0aGF0IHRvIHByZXZlbnQgdGhlIGd1ZXN0IGZyb20gc2V0dGluZyBiaXRzIHRoYXQgd2Ug
d29u4oCZdCBzYXZlIGluIHRoZQ0KPj4gZmlyc3QgcGxhY2UuDQo+PiANCj4+ICAgIC8qDQo+PiAg
ICAgKiBEbyBub3QgYWxsb3cgdGhlIGd1ZXN0IHRvIHNldCBiaXRzIHRoYXQgd2UgZG8gbm90IHN1
cHBvcnQNCj4+ICAgICAqIHNhdmluZy4gIEhvd2V2ZXIsIHhjcjAgYml0IDAgaXMgYWx3YXlzIHNl
dCwgZXZlbiBpZiB0aGUNCj4+ICAgICAqIGVtdWxhdGVkIENQVSBkb2VzIG5vdCBzdXBwb3J0IFhT
QVZFIChzZWUga3ZtX3ZjcHVfcmVzZXQoKSkuDQo+PiAgICAgKi8NCj4+ICAgIHZhbGlkX2JpdHMg
PSB2Y3B1LT5hcmNoLmd1ZXN0X3N1cHBvcnRlZF94Y3IwIHwgWEZFQVRVUkVfTUFTS19GUDsNCj4+
IA0KPj4gV291bGRu4oCZdCB0aGlzIG1lYW4gdGhhdCB0aGUgKmd1ZXN0KiB4c3RhdGUgaW5pdGlh
bGl6YXRpb24gd291bGQgbm90IHNlZSBhIGdpdmVuDQo+PiBmZWF0dXJlIHRvbyBhbmQgdGFrZSBj
YXJlIG9mIHRoZSBwcm9ibGVtIG5hdHVyYWxseT8NCj4+IA0KPj4gT3IgYXJlIHlvdSBzYXlpbmcg
eW914oCZZCB3YW50IGFuIGV2ZW4gbW9yZSBkZXRhaWxlZCBjbGVhcmluZz8NCj4gDQo+IFRoZSBD
UFVJRCBiaXRzIHRoYXQgZW51bWVyYXRlIHN1cHBvcnQgZm9yIGEgZmVhdHVyZSBhcmUgaW5kZXBl
bmRlbnQgZnJvbSB0aGUgQ1BVSUQNCj4gYml0cyB0aGF0IGVudW1lcmF0ZSB3aGF0IFhDUjAgYml0
cyBhcmUgc3VwcG9ydGVkLCBpLmUuIHdoYXQgZmVhdHVyZXMgY2FuIGJlIHNhdmVkDQo+IGFuZCBy
ZXN0b3JlZCB2aWEgWFNBVkUvWFJTVE9SLg0KPiANCj4gS1ZNIGRvZXMgbW9zdGx5IGFjY291bnQg
Zm9yIGhvc3QgWENSMCwgYnV0IGluIGEgdmVyeSBhZCBob2Mgd2F5LiAgRS5nLiBNUFggaXMNCj4g
aGFuZGxlZCBieSBtYW51YWxseSBjaGVja2luZyBob3N0IFhDUjAuDQo+IA0KPiAJaWYgKGt2bV9t
cHhfc3VwcG9ydGVkKCkpDQo+IAkJa3ZtX2NwdV9jYXBfY2hlY2tfYW5kX3NldChYODZfRkVBVFVS
RV9NUFgpOw0KPiANCj4gUEtVIG1hbnVhbGx5IGNoZWNrcyB0b28sIGJ1dCBpbmRpcmVjdGx5IGJ5
IGxvb2tpbmcgYXQgd2hldGhlciBvciBub3QgdGhlIGtlcm5lbA0KPiBoYXMgZW5hYmxlZCBDUjQu
T1NQS0UuDQo+IA0KPiAJaWYgKCF0ZHBfZW5hYmxlZCB8fCAhYm9vdF9jcHVfaGFzKFg4Nl9GRUFU
VVJFX09TUEtFKSkNCj4gCQlrdm1fY3B1X2NhcF9jbGVhcihYODZfRkVBVFVSRV9QS1UpOw0KPiAN
Cj4gQnV0IHVubGVzcyBJJ20gbWlzc2luZyBzb21ldGhpbmcsIHRoZSB2YXJpb3VzIEFWWCBhbmQg
QU1YIGJpdHMgcmVseSBzb2xlbHkgb24NCj4gYm9vdF9jcHVfZGF0YSwgaS5lLiB3b3VsZCBicmVh
ayBpZiBzb21lb25lIGFkZGVkIENPTkZJR19YODZfQVZYIG9yIENPTkZJR19YODZfQU1YLg0KDQpX
aGF0IGlmIHdlIHNpbXBseSBtb3ZlZCBzdGF0aWMgdW5zaWduZWQgc2hvcnQgeHNhdmVfY3B1aWRf
ZmVhdHVyZXNbXSDigKYgaW50byB4c3RhdGUuaCwgd2hpY2gNCmlzIGFscmVhZHkgaW5jbHVkZWQg
aW4gYXJjaC94ODYva3ZtL2NwdWlkLmMsIGFuZCBkbyBzb21ldGhpbmcgc2ltaWxhciB0byB3aGF0
IEnigJltIHByb3Bvc2luZyBpbiB0aGlzDQpwYXRjaCBhbHJlYWR5DQoNClRoaXMgd291bGQgZnV0
dXJlIHByb29mIHN1Y2ggYnJlYWthZ2VzIEnigJlkIGltYWdpbmU/DQoNCnZvaWQga3ZtX3NldF9j
cHVfY2Fwcyh2b2lkKQ0Kew0KLi4uDQogICAgLyoNCiAgICAgKiBDbGVhciBDUFVJRCBmb3IgWFNB
VkUgZmVhdHVyZXMgdGhhdCBhcmUgZGlzYWJsZWQuDQogICAgICovDQogICAgZm9yIChpID0gMDsg
aSA8IEFSUkFZX1NJWkUoeHNhdmVfY3B1aWRfZmVhdHVyZXMpOyBpKyspIHsNCiAgICAgICAgdW5z
aWduZWQgc2hvcnQgY2lkID0geHNhdmVfY3B1aWRfZmVhdHVyZXNbaV07DQoNCiAgICAgICAgLyog
Q2FyZWZ1bDogWDg2X0ZFQVRVUkVfRlBVIGlzIDAhICovDQogICAgICAgIGlmICgoaSAhPSBYRkVB
VFVSRV9GUCAmJiAhY2lkKSB8fCAhYm9vdF9jcHVfaGFzKGNpZCkgfHwNCiAgICAgICAgICAgICFj
cHVfZmVhdHVyZV9lbmFibGVkKGNpZCkpDQogICAgICAgICAgICBrdm1fY3B1X2NhcF9jbGVhcihj
aWQpOw0KICAgIH0NCi4uLg0KfQ0KDQo=
