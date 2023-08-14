Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F5477BBA2
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjHNO3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 10:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbjHNO32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 10:29:28 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2077.outbound.protection.outlook.com [40.107.12.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5748E62;
        Mon, 14 Aug 2023 07:29:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFz/jqEuzwgXS86iG3GOyD8z5q/ZYBc9qmQlFtZvxHnARt+b1wWlMvvIi4MRe2Q4rhtsK3WUntmMSnTwtQK7cHQyDPqHvJ9MYV5TNR06p3l0+1R0d/OWL2J6i0wLf5Cv78Rsl7ey/4gLLtC96c2nBKTNq33RG2Gd2qQjx2ZgRQtDwKM3p0ifjgGF9NUq8eXNzal/M/ppd1TQRQBgc3RUBxOj9Y+Vsn2NZimFPtoIpRT1xH3jFbrCBoInn0Trpu3U+In/wl9DX52d8nM5GGa8X7Tr/6xop6/SQlZFF/tAqXYU+zTm3sZv8YrJO8KEJZFCIFSSepAvK1e9MwFJAleQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gC9ClZZWpfhmh77f+I7oY91j+HhE8v6UBnt45KM/LCM=;
 b=Lr3qcpsu5hnOxfbgN1DlYs0EcJhaLcnyGDL5fXXIjYJojN/+83UGoIV6GXaeXIWpXBfFjTR3xmYqAtpJy02KQ460eBs0ZFZpHc4rVBK2NCTszbEBz7E4KzLgmbj+TgreAvitZ53SrnmBAp+Yk6mMlFj5FPeY/wBmExbZeWfuluvTVqx4xZmZvbEBqFPlnjaRJVRxkYMj1/aCIIXDNSY2wAY2UCKc9mxtIcAiA76bhZqAxFFzlUKs58rHQKthQ9niKqcjdN7TorT2+tf6tQ0CNpODEagGcgORvuZk30saR4NIYxMUsgS6LRPthP7oFVblErpg8g5MCg5INwpUD+xEtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gC9ClZZWpfhmh77f+I7oY91j+HhE8v6UBnt45KM/LCM=;
 b=JNjEX5iydhyatPBaICBvxYfgkAiCNoOSn6up1zUN29e157g887PFiYcAHHc+SJS3eWVfw2UtWIfmUa7mnSwMB0A3CflznHj7M4+Gne44ULSdHn8iTchVWdYHr84MONvWIW5DIu5Lga0tRx/U6OzORiZyN3FiOK71CiY1sjzeAhcjqrCIEyaDDtT2kz11kDV6kPf2pOz8T9d6hEBbbzWa6U1PWdZpjMz18AYt3GGWL4hjnZR0J/zLy1H/l1l8rwE6xpqJz9udgs3bDvWQQ8nPeJkWGxk7w9wm8ecfFgNtqMC10NuRb5jpZdZMoBYTcR8H4YIu04/fseFD9ix1c0oG6Q==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB3304.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:121::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.24; Mon, 14 Aug
 2023 14:29:22 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2820:d3a6:1cdf:c60e]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2820:d3a6:1cdf:c60e%7]) with mapi id 15.20.6678.022; Mon, 14 Aug 2023
 14:29:22 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
Thread-Topic: [PATCH] powerpc: Make virt_to_pfn() a static inline
Thread-Index: AQHZypiDkIG7cZNOwUK+M9oQZbZ7Ea/pwuGAgAAfWgA=
Date:   Mon, 14 Aug 2023 14:29:22 +0000
Message-ID: <2e1fcfe4-169f-a52b-8da1-1819962f5783@csgroup.eu>
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
 <87a5uter64.fsf@mail.lhotse>
In-Reply-To: <87a5uter64.fsf@mail.lhotse>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PAZP264MB3304:EE_
x-ms-office365-filtering-correlation-id: 80dc4ba8-ab0e-447b-0691-08db9cd2da66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uErghs/gNfKVUHLlYbNYlzmc+c4xuEHBel+Yi8Z+lCQiMSUdJhDdA78kDIioTzyJiQalwt+xam1+CIUcRHp/fdpvUzAa/0n9eoEUituKJnDfEhoftO84u/pb0J8YHD8jxP/sLPxQTXliCeZ175F+TpyIYDkqlJvdA98W/+mpFYUsZzina/lRDSrP05/2y8NbDMdiD67JzYVJdprAbovHjH+QBRjIiGWEGtJLQVM6R0w6l7CZRgt7XbLg5wp7rncuICnxd6GFB18Q++n9E8mfyOgEv7W9WVZzfjW0IUIEgD6du99d7IFrzeyKb6r3CSMEDGwnC1shp3z9lyymd1wLT5vlxc9SPAXTPmqvAAMxyLvdiXCUhr62ycCmqF1RLPqtTDhj1fSdWX5Ef0pkvK/AY+9fPNjjxSFgq0JaY1AUypAvHiMSB/RPoov21GyKj9NI9vnXLs4hy6/AlHlNL/ErTLVwNrZCSboda147Dn5DhHoK0zN8wvq+N7V6LNxsTwoxHZVB18HQzs3tqaSN6bhHUW/bebUbVB8xxOv82sN1so+DQtciBIfmdNW3PUPlVxnU5y6T2npR4Zj4jJLaatLi2mycrjTryB611xuB8VyYR55YVOZB5eTeso/y9YHCOqlkVQM8p69CMKwaIaSS3ROi/zm+KgxVbXY4NknW6GpYNcMpmXsk3u2dRFr8J9lb+0bD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(346002)(136003)(396003)(376002)(366004)(1800799006)(186006)(451199021)(26005)(6506007)(41300700001)(8936002)(64756008)(66476007)(91956017)(76116006)(66446008)(66556008)(66946007)(316002)(8676002)(6512007)(31686004)(2616005)(83380400001)(71200400001)(6486002)(122000001)(478600001)(110136005)(38100700002)(54906003)(44832011)(31696002)(36756003)(86362001)(4326008)(5660300002)(2906002)(38070700005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bkZTemtXdzY3d1Bwd2VzNUlKN1B4QWNudm9zOEUyQVlYVG00azl0MVRlWkhI?=
 =?utf-8?B?VFlyM1l6cVN4Qk41ZjdEclZwaEdVQ0pKQS8vVi9HNzAyZVRWbnlDeVIvTW12?=
 =?utf-8?B?eWpFRGlsbnhGSFdJYkY3cit6YzhONFdPU1Z1dFYraEd2OWtDWXV3ZE9KSmZy?=
 =?utf-8?B?S2hyS2tsRTZXbnFCSk9mTTVDVXdXUnhibVNIUWpNOXkxNEhscmtSL1ZaeUlx?=
 =?utf-8?B?V3RsYzF2NlFYcVd5RDRMbzkrblBmb0Z2eHFiWUJqVjdLbUlFQnluRFZaTFRL?=
 =?utf-8?B?M2tjQTUxdGo2YmFwTy8vZUZGOUd1RVZ2R3NqcjNGM1llNlBWdk5hUWgxWTlr?=
 =?utf-8?B?YnRZcC94eFlTL1haeWxQN2FBeWNCVmlsaXBlSWxNNTUxdEZhMityY0hEaUhh?=
 =?utf-8?B?Y3E1RHpNUHBQUE5OWlVFekp3SzJUaTQvUEZ4R0pYVHZsS3pZeGJiNFRCbFN5?=
 =?utf-8?B?VVJRMjZHbEJVdWlCR0NCcFVLWUdMdkMrWjJlSlVxcFhYZDVNTEtzN3JYeWoy?=
 =?utf-8?B?endzSXBPWlllYjBtV1dIeHA3R2hxNGRwNFAwbnJBblltOGNCTktGZ2RtYWRw?=
 =?utf-8?B?eGdDQ0RPQXhwV0ZoQU0wZEk0d3BXRThDcElJdlU3ekJMV3RsM2hSTVcvSWxt?=
 =?utf-8?B?S3ptSGhRblVKYXZtaVpxWUVvRFlVd2FhTXNSN3RTbnUyQ1RQY3VKWHJtaGtO?=
 =?utf-8?B?N3NxVHB0azlPN1ZRK2dqT1l3VXFCREVOVFRTcCs1M00yaU9kTUZLMGpBc2xq?=
 =?utf-8?B?cU5TSDlEREtlVlFzL05NaWZHS0MyTzdiRTMzQjdtZjlSMm1pZkpWMlhjZVk0?=
 =?utf-8?B?K1lyZisxQVIxcEo4KzZCUlh5QVh0aExUWFFLMTVZb1NYczVHS05RcEYwcm9V?=
 =?utf-8?B?KzNEVEhGZkZZcWF5VVFscERLemlCS3l0eXFzbHMrVWh2Zi9ucjlZMGt4N0kz?=
 =?utf-8?B?eng2d3JVS3hTY3VNY2dxR05oZlFkVkpiRU1vMDgwa3dJZmFpQ3NEdlRIT0J0?=
 =?utf-8?B?ekp3VktJQnhsMU9PVWszNW15TTRPY2ltU0Fnc2ttVk41OGIyTmYycXc4QmVO?=
 =?utf-8?B?Rm44c1lLQmJyRTFjcEU4OGJYSHZkUTBPL0d3eHNvSGhRdGViVjdWa1VMZXJD?=
 =?utf-8?B?aUdrc0x0U2xkQ1R6RSt6cHFxbjYwSSt6VS84TjdBVmU4YnR5ekNaU2h5dmcz?=
 =?utf-8?B?L21Ga0g5Q1AvMm5yS0lHT1VIaUVFcVVtdGw5bHMyVEVYVDBrZU5waExBVTk5?=
 =?utf-8?B?R1cvNFBGU3V2V0NZbXB5UVFiMHkzTXFMcTk4cHVHR2RzblUrUk4rU0QwZ1Y4?=
 =?utf-8?B?VUQ2RWQyZFhZaGptajN5U01UenpvK1BSUnhCUWVhWENyanEwekRUTGt2Q3Mx?=
 =?utf-8?B?YVVrYUVuQThOM2RsbDcxU1YzYVVaUDR2Tmk1YWsrK2J2VTBQUFIxMEdYdkRX?=
 =?utf-8?B?bWZhYVNDOXVmZ2lYY1F3Qy9PUEU0emNFMzdESjNuMjVsR2t2dnhRYVZvdjJw?=
 =?utf-8?B?bU1uUXZJL2YzcFZNTEVrSlBkTmZPajkwd2xVWVBYcmtwVU53RklqbTlOdER5?=
 =?utf-8?B?NGZWdm5KQlBzRHRBaWhzVkVGTW54ekZWb3h2Wnh5ZUhNNU5NUFM3V0FJenNP?=
 =?utf-8?B?YXNWZmxEUzMvMUxKVTYyMHhsSmJySE1GbkJIck5xcG9WWHAvQW9LNnBOalZx?=
 =?utf-8?B?L0JCSmYxelMvQ3BTaWw2c0UrOWJtQ3FNcmxqcEtxWHVsMnhINGN0dFJreXRu?=
 =?utf-8?B?aVBlT2lmUGFqVXNpZW1XamlCMzByaThZclRwZEs5NUg1OTlsZm1WTW9mb1Vw?=
 =?utf-8?B?eGZoYjlJTTJ5TkJiNS9iUkM3Q0d1cEwvV1hkTHMrNWRtOU0vNngxQUJpSzFo?=
 =?utf-8?B?Q2sxZmlwRDVFdVZyb01NdjVsOVQ5V091QkFtN2E2YnYxUHBJc0hjN1lyVloz?=
 =?utf-8?B?UExXb21KTlQ3OUFnWEhNNWQxZjYzSWk0bjErQThzNHI1VDRsWDNpa21GTEpy?=
 =?utf-8?B?MTBmaFA3b1pEOVkydE1EdnVpTW04TitXNTBhbnpkSUlhNUR2YlUzUE1YdVZr?=
 =?utf-8?B?cU9zVVJQZW1WbGZBcEpGNlJrZW9sYytTdTJVcmJqaDFQNURVekNIRFB6R05M?=
 =?utf-8?Q?UwjPw9KRbjLDqTBaafLRTmKrl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E781171E565CE1449ED6E9E44D73E1B2@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 80dc4ba8-ab0e-447b-0691-08db9cd2da66
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2023 14:29:22.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/dbb0zpVIznNITqZfxOxbJWKU9QG0hM/uuxKwp5keQJ4Ucn7UYrW3Af1fZXQtCTgFKdHVLH4uymza9CSUNtMGfFpqNrjcCFJ4t9hyP4/GA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB3304
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCkxlIDE0LzA4LzIwMjMgw6AgMTQ6MzcsIE1pY2hhZWwgRWxsZXJtYW4gYSDDqWNyaXTCoDoN
Cj4gTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3JnPiB3cml0ZXM6DQo+PiBN
YWtpbmcgdmlydF90b19wZm4oKSBhIHN0YXRpYyBpbmxpbmUgdGFraW5nIGEgc3Ryb25nbHkgdHlw
ZWQNCj4+IChjb25zdCB2b2lkICopIG1ha2VzIHRoZSBjb250cmFjdCBvZiBhIHBhc3NpbmcgYSBw
b2ludGVyIG9mIHRoYXQNCj4+IHR5cGUgdG8gdGhlIGZ1bmN0aW9uIGV4cGxpY2l0IGFuZCBleHBv
c2VzIGFueSBtaXN1c2Ugb2YgdGhlDQo+PiBtYWNybyB2aXJ0X3RvX3BmbigpIGFjdGluZyBwb2x5
bW9ycGhpYyBhbmQgYWNjZXB0aW5nIG1hbnkgdHlwZXMNCj4+IHN1Y2ggYXMgKHZvaWQgKiksICh1
bml0cHRyX3QpIG9yICh1bnNpZ25lZCBsb25nKSBhcyBhcmd1bWVudHMNCj4+IHdpdGhvdXQgd2Fy
bmluZ3MuDQo+IC4uLg0KPj4gZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9w
YWdlLmggYi9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcGFnZS5oDQo+PiBpbmRleCBmMmI2YmY1
Njg3ZDAuLjllZTRiNmQ0YTgyYSAxMDA2NDQNCj4+IC0tLSBhL2FyY2gvcG93ZXJwYy9pbmNsdWRl
L2FzbS9wYWdlLmgNCj4+ICsrKyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9wYWdlLmgNCj4+
IEBAIC05LDYgKzksNyBAQA0KPj4gICAjaWZuZGVmIF9fQVNTRU1CTFlfXw0KPj4gICAjaW5jbHVk
ZSA8bGludXgvdHlwZXMuaD4NCj4+ICAgI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPj4gKyNp
bmNsdWRlIDxsaW51eC9idWcuaD4NCj4+ICAgI2Vsc2UNCj4+ICAgI2luY2x1ZGUgPGFzbS90eXBl
cy5oPg0KPj4gICAjZW5kaWYNCj4+IEBAIC0xMTksMTYgKzEyMCw2IEBAIGV4dGVybiBsb25nIGxv
bmcgdmlydF9waHlzX29mZnNldDsNCj4+ICAgI2RlZmluZSBBUkNIX1BGTl9PRkZTRVQJCSgodW5z
aWduZWQgbG9uZykoTUVNT1JZX1NUQVJUID4+IFBBR0VfU0hJRlQpKQ0KPj4gICAjZW5kaWYNCj4+
ICAgDQo+PiAtI2RlZmluZSB2aXJ0X3RvX3BmbihrYWRkcikJKF9fcGEoa2FkZHIpID4+IFBBR0Vf
U0hJRlQpDQo+PiAtI2RlZmluZSB2aXJ0X3RvX3BhZ2Uoa2FkZHIpCXBmbl90b19wYWdlKHZpcnRf
dG9fcGZuKGthZGRyKSkNCj4+IC0jZGVmaW5lIHBmbl90b19rYWRkcihwZm4pCV9fdmEoKHBmbikg
PDwgUEFHRV9TSElGVCkNCj4+IC0NCj4+IC0jZGVmaW5lIHZpcnRfYWRkcl92YWxpZCh2YWRkcikJ
KHsJCQkJCVwNCj4+IC0JdW5zaWduZWQgbG9uZyBfYWRkciA9ICh1bnNpZ25lZCBsb25nKXZhZGRy
OwkJCVwNCj4+IC0JX2FkZHIgPj0gUEFHRV9PRkZTRVQgJiYgX2FkZHIgPCAodW5zaWduZWQgbG9u
ZyloaWdoX21lbW9yeSAmJglcDQo+PiAtCXBmbl92YWxpZCh2aXJ0X3RvX3BmbihfYWRkcikpOwkJ
CQkJXA0KPj4gLX0pDQo+PiAtDQo+PiAgIC8qDQo+PiAgICAqIE9uIEJvb2stRSBwYXJ0cyB3ZSBu
ZWVkIF9fdmEgdG8gcGFyc2UgdGhlIGRldmljZSB0cmVlIGFuZCB3ZSBjYW4ndA0KPj4gICAgKiBk
ZXRlcm1pbmUgTUVNT1JZX1NUQVJUIHVudGlsIHRoZW4uICBIb3dldmVyIHdlIGNhbiBkZXRlcm1p
bmUgUEhZU0lDQUxfU1RBUlQNCj4+IEBAIC0yMzMsNiArMjI0LDI1IEBAIGV4dGVybiBsb25nIGxv
bmcgdmlydF9waHlzX29mZnNldDsNCj4+ICAgI2VuZGlmDQo+PiAgICNlbmRpZg0KPj4gICANCj4+
ICsjaWZuZGVmIF9fQVNTRU1CTFlfXw0KPj4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyB2
aXJ0X3RvX3Bmbihjb25zdCB2b2lkICprYWRkcikNCj4+ICt7DQo+PiArCXJldHVybiBfX3BhKGth
ZGRyKSA+PiBQQUdFX1NISUZUOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgaW5saW5lIGNvbnN0
IHZvaWQgKnBmbl90b19rYWRkcih1bnNpZ25lZCBsb25nIHBmbikNCj4+ICt7DQo+PiArCXJldHVy
biAoY29uc3Qgdm9pZCAqKSgoKHVuc2lnbmVkIGxvbmcpX192YShwZm4pKSA8PCBQQUdFX1NISUZU
KTsNCj4gDQo+IEFueSByZWFzb24gdG8gZG8gaXQgdGhpcyB3YXkgcmF0aGVyIHRoYW46DQo+IA0K
PiArICAgICAgIHJldHVybiBfX3ZhKHBmbiA8PCBQQUdFX1NISUZUKTsNCg0KRXZlbiBjbGVhbmVy
Og0KDQoJcmV0dXJuIF9fdmEoUEZOX1BIWVMocGZuKSk7DQoNCj4gDQo+IFNlZW1zIHRvIGJlIGVx
dWl2YWxlbnQgYW5kIG11Y2ggY2xlYW5lcj8NCj4gDQo+IGNoZWVycw0K
