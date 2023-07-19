Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47AD7758D49
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 07:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjGSFnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 01:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGSFnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 01:43:15 -0400
Received: from CO1PR02CU002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DCB1FD5
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 22:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6+De2PSWyRLp+JmEf6hzvjuGwfCElxTIxcfFEEwZRczNf8RFSlNlUC1CsZj3FJmruzgzA8rii9ybC/Wx3EDoJpsE16yGUMvO8QyiUmAOOj8nIw9SB4uq8dXeG+KsiaVpRdR7cnwHrOGXzJCMl0A0l84zXVpqmlEhMi34CnZdKLbEgbL9J0iOnhPfob9Y+Cc9ZOOKaBG3swTj+1ULMO9jG7N9F46AcEs8zYKiN0iJaENRakLKn6xaScZFKk1AH6IwqU+iL+SV7s9cjL/WNNWdBbzLr0yexB60TBjLLpKXzPstX7V2gdcd5cTyKWoCzBeSSejYceIth80/jtecuzGjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxW6g1BscNsY/FDbHSkxdL4fgyiNbPvoTqKchVzSubk=;
 b=I/DNK/YbW/p8BxoR8KTX3OJgqZaN9n4zPd2FEO0ECUatJks3PZIUXhYauYWHfkQqwI6NZNBVZc08GolSkM7n/248Z/9Txp5vNjqfkcJeAVJesw1+IetIuK2PuH59dlZDVEttaeAU8UxzOqqwLbKuO5Qg2zji0v0fKFk1x9bp2PbCC1l7JLEifxcl0+TmvNm4W1qk7UGwDSx7NTLDD2Te5ow5rMQvXmoGNE9BkIfIqcmZTjeJvncj82UjO2JOnTdoOCm045gqtEYB1GhxpSvoyseudPCFKh2f9vncStXH9YuHCNvkssQNh+LCOtRGzmTGyMUrG/pZZK4ZGi6jy+hzAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxW6g1BscNsY/FDbHSkxdL4fgyiNbPvoTqKchVzSubk=;
 b=FQWfy8xDVYoPTN5qnkXzEq5pkBdD3LKHorkMEllUZVUNnf/DIiNF/2qVAlndAtFeLQc9LgZRayxTrC8ZfzPdESyn14UPaqgT+oQm4mWz5tfNQyKry9dB7VIg9y+j1o6jlTsvLoNMla3N66CVkHIMCBJRcx3UAzQyE/Pf7SO0q1w=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by DS0PR05MB9543.namprd05.prod.outlook.com (2603:10b6:8:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 05:42:59 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::45c9:cdc8:ff01:5e8a%6]) with mapi id 15.20.6588.031; Wed, 19 Jul 2023
 05:42:59 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
CC:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Shaoqin Huang <shahuang@redhat.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Topic: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Index: AQHZoLuTHvENrVBKJ02px/P+RINq6q+5OzeAgAAQOACABGkToYAAAHsAgAAhxwCAAY/sMIABX4yA
Date:   Wed, 19 Jul 2023 05:42:59 +0000
Message-ID: <02111DF8-0D75-46C3-B5DD-A0FCE026263F@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
 <20230717-52b1cacc323e5105506e5079@orel>
 <20230717-085f1ee1d631f213544fed03@orel>
 <8d4c1105-bf9b-d4b0-a2a3-be306474bf56@arm.com>
 <4C6E9B6F-1879-48FB-98B6-6F271982067D@vmware.com>
 <ZLZQ6r4-9mVdg4Ry@monolith.localdoman>
In-Reply-To: <ZLZQ6r4-9mVdg4Ry@monolith.localdoman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|DS0PR05MB9543:EE_
x-ms-office365-filtering-correlation-id: 060ee822-74f7-45e0-07cd-08db881b02d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLp+a8mzWPubD1LUIsDlM507eh4WG2AmPkwH5XbckvjBnDR5u6hirJcCmMWm4cK6lT1qMBB20/tFkmz64TDsh6ZGY6YuOpeDiodUKVEIrypc6BzWu4RCv/NoDOQ8giWUx1vR+ONCaEooPEabzDXVKs4xD/ZBB6kGHg/8lYpSmxUo1MwhA/ivx4w1b1crTQxNnzhiqmvW+DHZxjPG/tnrboA1fHkY5s0asFK8/UA2NzG/RVsrYVU/idoyIZdF6YQeSMZiw7A7KEIQL23IaA+jEdj15k5DZ7Uti+a2sKr/IXk44oIgo11AYktRducm96TWVOz5hJ5OkjQVqKWT2nkI0eLSwJp/2+JNKn3LLvTeL34z/sQ3l4BhLMHftS4ALWRIGgwoBjBngFvSJZBzjkc9OPwYBdYD79dKtt8N6cAAchcmf3RIh5vCIRHLWaSmZyC3DstS0tCveW+fVL17JeJ/IOtQHMWe+GEvkgPVtqIrM1pQgvbD1yi2Q9qpsYwPeK8KYE2hP3TeKMX2GlqUH8qXq+tiVIYh/nLm+zJIqKTx5qIYSdugdPgUWAKVlO2obATq9oEVjydgmooIrfO0gMbnqS84fTc5rfSGlc1wpP7OeM8bFS0QiFuBX80VvzTBZ6j51DUjYzMTVRLc/p5E1HGV1kZOUSnjC3GCBIcxiHVhl8odVpDLsjyIh9THbGoTMedC1tbvPik04vkXjmFSdIn/uQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199021)(71200400001)(478600001)(6486002)(54906003)(83380400001)(2616005)(36756003)(33656002)(86362001)(38070700005)(2906002)(6506007)(26005)(186003)(53546011)(6512007)(38100700002)(122000001)(6916009)(76116006)(4326008)(66946007)(66556008)(64756008)(66476007)(316002)(41300700001)(66446008)(8936002)(8676002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVNBTHFQenhtdVNONWh2ZTVycUEzUG92dm9QRDF1Ym5IRXRwaS9IcEhDRXdY?=
 =?utf-8?B?MGRneFZkc3RUeTBXek45ay9lOFJUeVVyRUdhbkNuL2EydXpXNDJNdXVmWDdS?=
 =?utf-8?B?SEIwVUZwY080dDFPSWNRcEg1ZEJHUHB0Y3B2QW1RY25MbVhQYmNuOHJWRStP?=
 =?utf-8?B?ZXRLZ25SenBvc0dWMWl0NEJteUprNTZpMTlBMitHcU1CSVh3UHBqOVlsVk1v?=
 =?utf-8?B?RGs5RDlIN3dpRGtqNjJmS1h0TmNLdkZnUmhsM1lYdkVpUmNGSUtsMzNyOHJj?=
 =?utf-8?B?cHBnSjlUczJZNEE5ZzBZTlRJdVFLRGtrQ1lKZUdibXRWYVN3ZytyUVM2bmt6?=
 =?utf-8?B?YllIWlR3c1IyN2E0aTFqdlEwTmtKS1JYUnYvZEFPOUl5UUZOamRBUUpDL3Ay?=
 =?utf-8?B?aG5vVUwrRW0zZjZnSDhJQ0pRSVU3MUFGYWxGTUk2M0IvQ1QxSi9ON2QrdG1a?=
 =?utf-8?B?QVM0MVd5bVhMSzRKZ3pJaTFPUzBiSnVNcHFUNmJQTXNJWS9OMkFzS3lCa084?=
 =?utf-8?B?NzFxeG5temwwRkFrYmZaMEtGVjIxaDB0QS9vSCsvQXJuUlRBVWVBd1laeVVT?=
 =?utf-8?B?RldTZzhpaXFqT1JyTmtTQndHRng1SFhLNjBtY3A1YXRHYks4ZzJSdUVnd0gx?=
 =?utf-8?B?TUNRT2FoaWEzeEJGdnhFcm9TMnBtU1lPYlhIWFl4ZHU2VkVyMU05a0RjUjNm?=
 =?utf-8?B?Z2FuNkY5MkJCZzhPT01xZyt5TzI5YVN6bnpOcFBiTXhhNGZZaGl3c3VCazcv?=
 =?utf-8?B?N1o1Tk5KMWMyN21VN2ZOZXVaK0FiOTRTczVmUzJKaEtZU1lWUUp4djg2TURy?=
 =?utf-8?B?Z2VtbXI3bzdTaDU4TzAwK29zekhsdWpXa2xreXBlYWpHOVUyVS9YWWlRb1lP?=
 =?utf-8?B?aWVGSjNrTUJpdlZwNzNiUURRSm43ZTlOWFNBTkZSZmtEWkZvdnJZYm1xZzdF?=
 =?utf-8?B?SEx5SnVuaEdyaS9SME5xVDROc04wUGtaS3NVaUtIUi9hTFlkWVFnSVhQdHcr?=
 =?utf-8?B?eGp2TXJBejR0ZE1jZDJsc2UrNjdGQU9zN0JvS0RiVW1VcDA3bmxBWldsVUN6?=
 =?utf-8?B?bVVyQmh2OUtKaGd4Ky94c2tpa3FlWHIvMHRMakRHcTFva0pzckNFVVB3T2V6?=
 =?utf-8?B?UUxnRUZFNVNhS2tsTTR3OHJoWkl0YjZUbXZBTzBoWTV6WWU1ME13UjFVRVdR?=
 =?utf-8?B?TFV1NHhQSjlFZzRyd3h1cktRMTVhVFFqWHZGaHRNN2xRZ2kvdm04Z0N5MkpN?=
 =?utf-8?B?L2VNWGp6RjIzaU05Q1lnanZ5RXZZOVlOMXloREdreUdxQkhyM2xyME83eFZ6?=
 =?utf-8?B?NSsxZ0NJV1VrOGRBLzduMWVNVDJBVXNvcWhTZmc1cUsxUkpxYzVBNFRwSlB4?=
 =?utf-8?B?NzJJbkxoSUhvK1ZubmdPank4dDNIeVlBYis2a2JmY3RBcmF4ajRnUGtFL3p0?=
 =?utf-8?B?eHFhNklhRnd4TzdBNERUNm5LRDdvSXVtUm9TL3lLa2ZSa1lVcnpWR29GYWZD?=
 =?utf-8?B?cEYraURpVFE5RytrK25FUktPYjBCTGN3MlJjYlNZcjIzaUV1Vk5uaUwwdjMz?=
 =?utf-8?B?M0ZvY2xBcjU1c1lGL2ZMTGN5WXE0MExKTGRqL3BFc292bHdpT3JuLyt4NE5R?=
 =?utf-8?B?bnlYUHM4RU05L1RkbWFBcmgxcHRsaHNzeGNZZzhTZnhYV0U4alFFQWI4TmF3?=
 =?utf-8?B?S0g2ek9qaXVTMnlNK3BIcHJtT3lvZGNuS1dLUmFUM2paQU1WT0QxMGY0Mnpx?=
 =?utf-8?B?S1pvVkcvZnRKQVJVam9iN3o0bnlUWEcrVlNPOUY0ZHM2VG9VeElibTZ5OVRD?=
 =?utf-8?B?K1d5T3QrWGF0YzR4QjB0TmRRZmlFa2FtRTBvSGZ1MWwrTFI5V0RoNTd5aklH?=
 =?utf-8?B?MUY3T1V0ajhvV21nZE9IbHRhZzZqRkhyVi9OYW1RZFNrMklQeVhVU1hraXVz?=
 =?utf-8?B?M0krTmo0K2JuNlp5MlBTZTQxaklCUGNqTStpTjR6YTZjYWJiWjNWSTVtdzhH?=
 =?utf-8?B?L2FyRTFJRksrVzZMVlVudWNwc0g2UFZLcXNtQTlmT29UdENQRndQTnBvODdo?=
 =?utf-8?B?ckRHTzg4RnZaNk8vaUY1SGowaWRTb2xzSExzL3JPdlZTdW1JN2lyMFViTU9u?=
 =?utf-8?Q?1r3vJGMmFrw9P3xCVWRLW9G0D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AAE54B521384214DBB244E3F1246BCE3@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060ee822-74f7-45e0-07cd-08db881b02d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2023 05:42:59.5724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s8lUveRkrWgKkD07zi/dGl7F8UwqKceTMo76WClDeEqzPpLf01ttm9d228Dz7ECFdBYOkojENug8WPI+SQ6PGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR05MB9543
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gSnVsIDE4LCAyMDIzLCBhdCAxOjQ0IEFNLCBBbGV4YW5kcnUgRWxpc2VpIDxhbGV4
YW5kcnUuZWxpc2VpQGFybS5jb20+IHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBPbiBNb24sIEp1
bCAxNywgMjAyMyBhdCAwNTowNTowNlBNICswMDAwLCBOYWRhdiBBbWl0IHdyb3RlOg0KPj4gQ29t
YmluaW5nIHRoZSBhbnN3ZXJzIHRvIEFuZHJldyBhbmQgTmlrb3MuDQo+PiANCj4+IE9uIEp1bCAx
NywgMjAyMywgYXQgMTo1MyBBTSwgTmlrb3MgTmlrb2xlcmlzIDxuaWtvcy5uaWtvbGVyaXNAYXJt
LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4+PiANCj4+Pj4+IFdvdWxkIHlvdSBtaW5kIHJlcG9zdGlu
ZyB0aGlzIGFsb25nIHdpdGggdGhlIEJTUyB6ZXJvaW5nIHBhdGNoLCB0aGUNCj4+Pj4+IHdheSBJ
IHByb3Bvc2VkIHdlIGRvIHRoYXQsIGFuZCBhbnl0aGluZyBlbHNlIHlvdSd2ZSBkaXNjb3ZlcmVk
IHdoZW4NCj4+Pj4+IHRyeWluZyB0byB1c2UgdGhlIEVGSSB1bml0IHRlc3RzIHdpdGhvdXQgUUVN
VT8gV2UnbGwgY2FsbCB0aGF0IG91cg0KPj4+Pj4gZmlyc3Qgbm9uLVFFTVUgRUZJIHN1cHBvcnQg
c2VyaWVzLCBzaW5jZSB0aGUgZmlyc3QgRUZJIHNlcmllcyB3YXMNCj4+Pj4+IG9ubHkgdGFyZ2V0
aW5nIFFFTVUuDQo+PiANCj4+IEkgbmVlZCB0byByZWhhc2ggdGhlIHNvbHV0aW9uIHRoYXQgeW91
IHByb3Bvc2VkIGZvciBCU1MgKGlmIHRoZXJlIGlzDQo+PiBhbnl0aGluZyBzcGVjaWFsIHRoZXJl
KS4gSSBoYWQgYSBkaWZmZXJlbnQgd29ya2Fyb3VuZCBmb3IgdGhhdCBpc3N1ZSwNCj4+IGJlY2F1
c2UgSUlSQyBJIGhhZCBzb21lIGlzc3VlcyB3aXRoIHRoZSB6ZXJvaW5nLiBJ4oCZbGwgZ2l2ZSBp
dCBhbm90aGVyDQo+PiANCj4+Pj4gDQo+Pj4+IE9oLCBhbmQgSSBtZWFudCB0byBtZW50aW9uIHRo
YXQsIHdoZW4gcmVwb3N0aW5nIHRoaXMgcGF0Y2gsIG1heWJlIHdlDQo+Pj4+IGNhbiBjb25zaWRl
ciBtYW5hZ2luZyBzY3RsciBpbiBhIHNpbWlsYXIgd2F5IHRvIHRoZSBub24tZWZpIHN0YXJ0IHBh
dGg/DQo+Pj4+IA0KPj4gDQo+PiBJIGFtIGFmcmFpZCBvZiB0dXJuaW5nIG9uIHJhbmRvbSBiaXRz
IG9uIFNDVExSLiBBcmd1YWJseSwgdGhlIHdheSB0aGF0DQo+IA0KPiBXaGF0IGRvIHlvdSBtZWFu
IGJ5IHR1cm5pbmcgb24gcmFuZG9tIGJpdHMgb24gU0NUTFI/IEFsbCB0aGUgZnVuY3Rpb25hbA0K
PiBiaXRzIGFyZSBkb2N1bWVudGVkIGluIHRoZSBhcmNoaXRlY3R1cmUuIFNhbWUgZ29lcyBmb3Ig
UkVTMSAoaXQncyBpbiB0aGUNCj4gR2xvc3NhcnkpLg0KPiANCj4+IHRoZSBub24tZWZpIHRlc3Qg
c2V0cyB0aGUgZGVmYXVsdCB2YWx1ZSBvZiBTQ1RMUiAod2l0aCBubyBuYW1pbmcgb2YgdGhlDQo+
PiBkaWZmZXJlbnQgYml0cykgaXMgbm90IHZlcnkgZnJpZW5kbHkuDQo+IA0KPiBUaGF0J3MgYmVj
YXVzZSBhcyB0aGUgYXJjaGl0ZWN0dXJlIGdldHMgdXBkYXRlZCwgd2hhdCB1c2VkIHRvIGJlIGEg
UkVTMSBiaXQNCj4gYmVjb21lcyBhIGZ1bmN0aW9uYWwgYml0LiBUaGUgb25seSBzYW5lIHdheSB0
byBoYW5kbGUgdGhpcyBpcyB0byBkaXNhYmxlDQo+IGFsbCB0aGUgZmVhdHVyZXMgeW91IGRvbid0
IHN1cHBvcnQsICoqYW5kKiogc2V0IGFsbCB0aGUgUkVTMSBiaXRzIChhbmQNCj4gY2xlYXIgUkVT
MCBiaXRzKSwgdG8gZGlzYWJsZSBhbnkgbmV3bHkgaW50cm9kdWNlZCBmZWF0dXJlcyB5b3UgZG9u
J3Qga25vdw0KPiBhYm91dCB5ZXQgd2hpY2ggd2VyZSBsZWZ0IGVuYWJsZWQgYnkgc29mdHdhcmUg
cnVubmluZyBhdCBhIGhpZ2hlciBwcml2aWxlZ2UNCj4gbGV2ZWwuDQo+IA0KPiBZb3UgY2FuIHNl
bmQgYSBwYXRjaCBpZiB5b3Ugd2FudCB0byBnaXZlIGEgbmFtZSB0byB0aGUgYml0cyB3aGljaCBo
YXZlDQo+IGJlY29tZSBmdW5jdGlvbmFsIHNpbmNlIFNDVExSX0VMMV9SRVMxIHdhcyBpbnRyb2R1
Y2VkLg0KDQpJIGNhbiBnaXZlIGl0IGEgcXVpY2sgc2hvdCwgYnV0IEkgZG8gbmVlZCB0byBjbGFy
aWZ5IHNvbWV0aGluZy4gQWx0aG91Z2gNCkkgaGF2ZSByYXRoZXIgZGVlcCBrbm93bGVkZ2Ugb2Yg
eDg2IGFyY2hpdGVjdHVyZSB3aXRoIG92ZXIgMjAgeWVhcnMgb2YNCmV4cGVyaWVuY2UsIG15IGV4
cGVyaWVuY2Ugd2l0aCBBUk0gaXMgbGltaXRlZCB0byAyIHdlZWtzLiBBbmQgSSBkb27igJl0IGV2
ZW4NCmhhdmUgYW4gZW52aXJvbm1lbnQgaW4gd2hpY2ggSSBjYW4gcnVuIEtWTStBUk0uDQoNClNv
IEkgYW0gbm90IGluY2xpbmVkIHRvIHJldmFtcCBjb2RlIHRoYXQgd2FzIGFjdHVhbGx5IGp1c3Qg
YWRkZWQgdG8NCmt2bS11bml0LXRlc3RzLiBJIHdpbGwgYXR0ZW1wdCB0byByZWZhY3RvciB0aGUg
Y29kZSB0byBzb2x2ZSBib3RoIHRoZQ0KQlNTIGFuZCBTQ1RMUiBpc3N1ZXMgaW4gRUZJIHVuZGVy
IHRoZXNlIGxpbWl0YXRpb25zLg0KDQo=
