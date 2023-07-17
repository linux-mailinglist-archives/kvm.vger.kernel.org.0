Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF67569CF
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 19:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjGQRFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 13:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjGQRFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 13:05:11 -0400
Received: from BL0PR02CU006.outbound.protection.outlook.com (mail-eastusazon11013009.outbound.protection.outlook.com [52.101.54.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE173101
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 10:05:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLHzX4u/95zbaYzpSxP0HUs+UlquJt6fWrOp2N0XeyM+dvSZzUx/P1TXjJbkPMRx/KFyuH1DuUpVf8gC42bYI2gdhkWjIjogJbTUiQJ4Zni3cH+6Fd0MtaRLjyVOdV8AlBS2OZUK92f1M8Tfb8qnVg/GRxV3+AU+zBH5YS7yJNdcmmj/yzy7NipM47zKg3R7Xz/M4lIsgQP6eSc1jztfirqoo5qOa9ajVOm4Wglut3A00h1dgwtT4SujQnli10bp65ves8/VMxBgXvuvmzxt8lANWTwxbxlCM4XG5eFDRM2l1EgvAuTiFLzxvqbLdsamZSTxjXRh1HQS5Xm6yLgPZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIpTiER+uL1On0m//e1/ULEd4tFQlQHPjbEVefg27Bs=;
 b=neChzCfU6a9PTUWOTt2b6nh2KaIF4ozpU7tXlM6hhSdsnU8AalwGyCnd+glFWCFeiRX6mF8KZJyEW82JlllSZVQLDlaWbCvZkGBwcY7J3QyFoNXOJ1RcI2HnImXNf9brMcPpwIOQM69Tf8IFxMBOiECtl3080zj+IjhRduCcGAbtI6OcYgjMj7sA90ExI991RPwILwazW+Qb/pHoljXN6XElBfewfFXsGAFFDuYw1Ns4+p3WcwnfV/8jGTkWnP5QB0a915UkzKnUPp7YUEcyYs5Mhd+GrSYXXZin12aYW4R1BaS0v3u7gHk5l/seM+wgjfsP7DRjWIl+YXhP/BRPdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIpTiER+uL1On0m//e1/ULEd4tFQlQHPjbEVefg27Bs=;
 b=xaN3ggPQxil3MnLKkufQ1kYsc63tavdKKQoD1BK97Ar/q+oCe/30wLA/lhqLq37q0x1UdX4GCLNaYIfSa6JWiZnxj6fY6eeA7D3XKhr6ipjySQ3hD+S2hUg1OV5if0GCeY/kvl5T+IuFQOM+MeJJA6//mA/VFFk4vd7DKRcl/J4=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by SA1PR05MB8000.namprd05.prod.outlook.com (2603:10b6:806:1a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 17:05:07 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 17:05:07 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>
CC:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Topic: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Index: AQHZoLuTHvENrVBKJ02px/P+RINq6q+5OzeAgAAQOACABGkToYAAAHsAgAAhxwCAAIlkAA==
Date:   Mon, 17 Jul 2023 17:05:06 +0000
Message-ID: <4C6E9B6F-1879-48FB-98B6-6F271982067D@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
 <20230717-52b1cacc323e5105506e5079@orel>
 <20230717-085f1ee1d631f213544fed03@orel>
 <8d4c1105-bf9b-d4b0-a2a3-be306474bf56@arm.com>
In-Reply-To: <8d4c1105-bf9b-d4b0-a2a3-be306474bf56@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|SA1PR05MB8000:EE_
x-ms-office365-filtering-correlation-id: 7988180f-0f1d-4070-b0eb-08db86e7f89d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 84BO2AAmAmZNm2g3ai4YuMFByuShOM9nTSQBG5kGPpZT3YNYrwfxooqLEzT+3FKM+4+h2F61u6X9y3eACDmGwyzSCK7uhO4aEnroVCs8dznpPMTC1Wam+HfURfi5c2KcA5gERoGjlLbuNFRRRRvddWJm1YadGNF6ZYiTbba5PJ+OA+994H/wfwcMCiVWAmLHNZ/qJy3wvHf1KPPLysfR50BSc3oOAs5kGSS0Q6wzM1fLa45IF4WmBoTzFA0Lh4yQM8FvrkcArrF3K6y/795zmg+nFk425aFXrjEvAtuwswrap/jtGLmf/TzxpTQMEpBYBcV/o5uE8kKVlPuBHoNTAVoYvyvNud4eRKos6AryCABv7rMI+T5nQYXJiCflEXlystxx8G/RV/VUGq0ARntABijq+jiqhg2kHtV4CFNlMba0aLp2PB1eRtbRPCZo3D5T+VHgE0GyFDiS+/Ojdpmiw2dSHkieJ4k5t64yOcHgr3o0AymON5gvV3nV3j+sw/7lROzzE96PuLVRTP96pIYtzKeUulVOh+UvhxB5PtB/vP3PhWC2VqS6S6gRFCI5xlHSj3rcHYB1FHttSTrqajFjSXrEFTiW90I6l3tbvh5GAxAdyQFsB3jMDLY8UFH/04+FnqKxB98TK/iYZUenUEquI3GLyTp0ijuJP8ib0iav9EbHtvX+L61a/9qHozly3+1egkBm/LRbgCrmdphvZGwK9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(478600001)(71200400001)(6486002)(54906003)(110136005)(2616005)(33656002)(86362001)(36756003)(38070700005)(2906002)(186003)(53546011)(6506007)(6512007)(26005)(64756008)(38100700002)(122000001)(66446008)(4326008)(66556008)(76116006)(66476007)(66946007)(41300700001)(316002)(8676002)(5660300002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3l2UnZEMEltWFhaSmdsOVo0anVlcXNOQjVpdkFsYkl2QjJNT0lBMjVrVmdn?=
 =?utf-8?B?S25HT1l3TUwrVFBNU21YcmVTQWdESUtEWHJzWFd6RjF1b3JyWlNZaDlMN2Mr?=
 =?utf-8?B?NmZhOTRQZlp1SVJaM1FLSS9lUDlYNmhZajl2TWY5S2hmNTNvSnErL2tSRVJZ?=
 =?utf-8?B?ajVRdTdkUXNVdCtNa2F1VjVZQ1cwdTJrSmloSW0yZ2toNERGbTMyTFJ0ZVFm?=
 =?utf-8?B?TjdzeFl5QkxYdy9iMmhncjJuSkdnMjYzZWhtazFNWkl1WjJ3OTdndXV4SVNq?=
 =?utf-8?B?ajFmclRDR0lzN3lzWHcyNXVDUnpZU1orUnlGcVQ5UkxnL0xvWWxTMElXNjBC?=
 =?utf-8?B?MXM0aHUyQWVkNElRM1d0RUlIdm1FOWFBRE5uUVREWTF2bVlFazlkRXdkNXpo?=
 =?utf-8?B?c25iT0NNbG9yQ3ptc0NlRFltVExDNU45eHFxTWRCRDdsN0ZXTDk4VC9lSnN6?=
 =?utf-8?B?ZFprL2diZHIvekZhQU9wM0FkNGJrUGhIOXUzWE5JbmVyT3BieUg3bWhjUmdK?=
 =?utf-8?B?VnpCa3cweUZna200MmZndkNOazVzOEw0cndWQlorV2EwSGswSlR6WWRaZmth?=
 =?utf-8?B?b3M4amFRQ2tmQm9uMm16bGVob3BrTFV1VXFqMUhLK1RkS0RUVG1aL0k5Y3ZQ?=
 =?utf-8?B?enp2UkQ0NTVsWDVXUzByVnJDeHJxNWRGV2lCMiswZ0JTdU1DK1RNWW9oeTFF?=
 =?utf-8?B?UVVWc2tBbjhXVTZySXVkTi94T2dnWUZiT3hFbUw1aU52ZGZBcDZ3ait0S29S?=
 =?utf-8?B?c2JqeUptMXAwMkEvYTdoVit0eTZSRGJMcFprSzd2a3EyZGN0NXhoaU1vVEFv?=
 =?utf-8?B?eVFOVDE5TzA0QzQ4TXdQemMyQlBtQjdWK0ZaejA0RHhyWXRFVU8wc2YvZDY3?=
 =?utf-8?B?N25xUXBwb3pSQzN1eUdacUdPbExXR1FVS09xZWswc3YyNUZZQVFzb1FKNW83?=
 =?utf-8?B?eWRMeUdqQURjcy9GaDY3azhVZys0ei9nWWdyMm84Vy9OV1lNSVREQ2RCYktE?=
 =?utf-8?B?ZjdQODNMSDNSVVdrOFUyMHFUQkdaTTRUUzBxSktwdVNMZ3JTb0w1OS9ZY2dR?=
 =?utf-8?B?cTlQNzl0c3BFYWxvMnhPQ2Zjdy9PT0owbEc4WmNYZEpjMEdXRmxIaXFmZ2o0?=
 =?utf-8?B?Zm9LY2lBOUR6a3cwN1k4azRJdTlFcllqa1EwMDgvQzZybDczUk5LdEF6djZX?=
 =?utf-8?B?WXZFblVWYUUreXJDQlNMMHZQeHBnMDcvNllHRTFvMlIyVCtSTVRLbUk5ZDlo?=
 =?utf-8?B?S0NiYkI4T2hjRXNrckdnaFNseEpEdk95ME9lZGMvZ2x6cU1uTTBSWVJ1NDNi?=
 =?utf-8?B?YUJYR2k3bVJ0SStacEpaNlJ2anVyM1ZHVGdYbnRHUHZPQXVZZFNkNVNmREFT?=
 =?utf-8?B?ZURLUTB4WVcrQWtQRFFNdFozODBXSmMwTHFnaDBYajhVRERmeDRzQzMyOHpp?=
 =?utf-8?B?b2JYTjZzS1hIb2lDZVhjVGFQYUM5UGgxMnBhK2dkT3FNTUNVc05CR0h6SldN?=
 =?utf-8?B?M2JtSnhpYjN1Sld6aTdBbU4vRlFTVTBhZnFGZGZUcjdmeEhRUmo0bGpOQk9Q?=
 =?utf-8?B?TUZ1N1pWRFdOY05rZHg2U2hWeFk0Z2xCbUtTVDlSUStQaUpTUER3eUQ2NmVU?=
 =?utf-8?B?LzVxbkRxTG9Bei9HSmV6ZFNVODdKWUJVZzA0MWZuaktIdXJEMGZHRGMyN2dI?=
 =?utf-8?B?RUVnbFlNaUNPK1FWVGQrdjU1V1hFdTByNWxQajdyT3N0a2hkV3pyVmFiRHpv?=
 =?utf-8?B?eEJWYzdwY0YvSU91WlZvRW1ZWXJINW1yTVlWWHNHTWx6cUhxRFlIcEtBNXVP?=
 =?utf-8?B?V2N5RXQxNUJHYjBTdTRJYVRaMmltK2NGWVhuSjVqbTRpMWNZRWNjaTNOM2h4?=
 =?utf-8?B?c3pORjl1Snh5UGF2bFBqdS83dTVXcm92OEJzYmM3Y2VDR3JhdUVBZ1B5VUZI?=
 =?utf-8?B?S0svM0NnMHYwV1ZXNEExMjFPNzNxM0I0NitHNkIzdXE4N0hFd2tYRWNXQ0tS?=
 =?utf-8?B?YXV6RVZiOG13WUtWbWpqQXZnOFJBMFRDYVhvVXIrdUpZZDlwaElQd3RMSzk3?=
 =?utf-8?B?VXVTR0tDZ29mY1NZOTNXaTgvWXV1VEZEYnMvUExDYjBWbGxJdjJPeCtjZUpB?=
 =?utf-8?Q?M7NQ3YmEweFok2UY+k7tlyOV9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF94CE8AD837194282E4860929DB30DE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7988180f-0f1d-4070-b0eb-08db86e7f89d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2023 17:05:06.9418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCFW0ekl5IFrSyq9R1I4Ey77yCyAsFuCNa78fTiZchkt8Jk3SFlmjIDN0vwlnCAwIugeL3TjxEI2ahL4Ec4V8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR05MB8000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Q29tYmluaW5nIHRoZSBhbnN3ZXJzIHRvIEFuZHJldyBhbmQgTmlrb3MuDQoNCk9uIEp1bCAxNywg
MjAyMywgYXQgMTo1MyBBTSwgTmlrb3MgTmlrb2xlcmlzIDxuaWtvcy5uaWtvbGVyaXNAYXJtLmNv
bT4gd3JvdGU6DQo+IA0KPj4+IA0KPj4+IFdvdWxkIHlvdSBtaW5kIHJlcG9zdGluZyB0aGlzIGFs
b25nIHdpdGggdGhlIEJTUyB6ZXJvaW5nIHBhdGNoLCB0aGUNCj4+PiB3YXkgSSBwcm9wb3NlZCB3
ZSBkbyB0aGF0LCBhbmQgYW55dGhpbmcgZWxzZSB5b3UndmUgZGlzY292ZXJlZCB3aGVuDQo+Pj4g
dHJ5aW5nIHRvIHVzZSB0aGUgRUZJIHVuaXQgdGVzdHMgd2l0aG91dCBRRU1VPyBXZSdsbCBjYWxs
IHRoYXQgb3VyDQo+Pj4gZmlyc3Qgbm9uLVFFTVUgRUZJIHN1cHBvcnQgc2VyaWVzLCBzaW5jZSB0
aGUgZmlyc3QgRUZJIHNlcmllcyB3YXMNCj4+PiBvbmx5IHRhcmdldGluZyBRRU1VLg0KDQpJIG5l
ZWQgdG8gcmVoYXNoIHRoZSBzb2x1dGlvbiB0aGF0IHlvdSBwcm9wb3NlZCBmb3IgQlNTIChpZiB0
aGVyZSBpcw0KYW55dGhpbmcgc3BlY2lhbCB0aGVyZSkuIEkgaGFkIGEgZGlmZmVyZW50IHdvcmth
cm91bmQgZm9yIHRoYXQgaXNzdWUsDQpiZWNhdXNlIElJUkMgSSBoYWQgc29tZSBpc3N1ZXMgd2l0
aCB0aGUgemVyb2luZy4gSeKAmWxsIGdpdmUgaXQgYW5vdGhlcg0KDQo+PiANCj4+IE9oLCBhbmQg
SSBtZWFudCB0byBtZW50aW9uIHRoYXQsIHdoZW4gcmVwb3N0aW5nIHRoaXMgcGF0Y2gsIG1heWJl
IHdlDQo+PiBjYW4gY29uc2lkZXIgbWFuYWdpbmcgc2N0bHIgaW4gYSBzaW1pbGFyIHdheSB0byB0
aGUgbm9uLWVmaSBzdGFydCBwYXRoPw0KPj4gDQoNCkkgYW0gYWZyYWlkIG9mIHR1cm5pbmcgb24g
cmFuZG9tIGJpdHMgb24gU0NUTFIuIEFyZ3VhYmx5LCB0aGUgd2F5IHRoYXQNCnRoZSBub24tZWZp
IHRlc3Qgc2V0cyB0aGUgZGVmYXVsdCB2YWx1ZSBvZiBTQ1RMUiAod2l0aCBubyBuYW1pbmcgb2Yg
dGhlDQpkaWZmZXJlbnQgYml0cykgaXMgbm90IHZlcnkgZnJpZW5kbHkuDQoNCkkgd2lsbCBoYXZl
IGEgbG9vayBvbiB0aGUgb3RoZXIgYml0cyBvZiBTQ1RMUiBhbmQgc2VlIGlmIEkgY2FuIGRvIHNv
bWV0aGluZw0KcXVpY2sgYW5kIHNpbXBsZSwgYnV0IEkgZG9u4oCZdCB3YW50IHRvIHJlZmFjdG9y
IHRoaW5ncyBpbiBhIHdheSB0aGF0IG1pZ2h0DQpicmVhayB0aGluZ3MuDQoNCj4gDQo+IE5hZGF2
LCBpZiB5b3UgYXJlIHJ1bm5pbmcgYmFyZW1ldGFsLCBpdCBtaWdodCBiZSB3b3J0aCBjaGVja2lu
ZyB3aGF0IEVMDQo+IHlvdSdyZSBydW5uaW5nIGluIGFzIHdlbGwuIElmIEhXIGlzIGltcGxlbWVu
dGluZyBFTDIsIEVGSSB3aWxsIGhhbmRvdmVyDQo+IGluIEVMMi4NCg0KSSBkb27igJl0LiBJIHJ1
biB0aGUgdGVzdCBvbiBhIGRpZmZlcmVudCBoeXBlcnZpc29yLiBXaGVuIEkgZW5hYmxlZCB0aGUg
eDg2DQp0ZXN0cyB0byBydW4gb24gYSBkaWZmZXJlbnQgaHlwZXJ2aXNvciB5ZWFycyBhZ28sIHRo
ZXJlIHdlcmUgbWFueSBtYW55DQp0ZXN0IGFuZCByZWFsIGlzc3VlcyB0aGF0IHJlcXVpcmVkIG1l
IHRvIHJ1biBLVk0tdW5pdC10ZXN0cyBvbiBiYXJlDQptZXRhbCAtIGFuZCB0aGVyZWZvcmUgSSBm
aXhlZCB0aGVzZSB0ZXN0cyB0byBydW4gb24gYmFyZS1tZXRhbCBhcyB3ZWxsLg0KDQpXaXRoIEFS
TSwgZXhjbHVkaW5nIHRoZSBCU1MgYW5kIHRoZSBTQ1RMUiBpc3N1ZSwgSSBkaWRu4oCZdCBlbmNv
dW50ZXIgYW55DQphZGRpdGlvbmFsIHRlc3QgaXNzdWVzLiBTbyBJIGRvbuKAmXQgaGF2ZSB0aGUg
bmVlZCBvciB0aW1lIHRvIGVuYWJsZSBpdA0KdG8gcnVuIG9uIGJhcmUtbWV0YWzigKYgc29ycnku
DQog
