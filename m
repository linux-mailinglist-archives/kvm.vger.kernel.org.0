Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2136A5F3A7B
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 02:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJDATz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 20:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiJDATv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 20:19:51 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56063B49D;
        Mon,  3 Oct 2022 17:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQiZCd/Uh5bRd+4d7oXqpdQVGiBfC7DDhOKJ/yK7aN88euOb0L+8+/ZZZhkrVttgcjRXRDKwWRqH3lPO/fxwkR9EZGixPsd2SbAe0N3IIYLCmg1pCo55TU+r+mQJ9Zr0GDAexqf8ELodJM+6Q7fv48tp6i/5160NFc9cMbtZbhllS1juQyQv1fIEabLp2+xUyCVjEw4lJRghf3ZsjE7GYyC3z2ATe3R3e2r5U7au/c4XY6ifnvtDocWjJeXU6vBtGWq5Xq10uoqXpBFruTS6auz3Kvk57SuUXOUqvGGopWtGtG1Qo5F6sEjHp1QhEToNb4eznt6ij9BSJvhvfViTHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0UkDABw6ohtJ22tdaxOAXwyPxZuELnjvmHTTEte5wQ=;
 b=QD5Q4msO1l7Wsb36AnPhMkKI2+Ll7pCrk083nLSScpqaC5zF4+YSFsJxSRRNb1bM8Z12QWAWuhuTHr7X080OIcQfYy/nvcErlWguPqqDnCc7deUEGIChZPOzZwf38xiOeDrU2sw5WubWIhDpSl8YI7sj3pgknu452n5FyNQFbVdVw91v96plYtI3E7jXqeY529S2huS+PsKGuJwwa/VLPIk3jobbIUrcIcG0grtG0q/RqcWruJQG6MQ4CzkNA0Nb9o54Mw692ixL0v4wyByhOkKZ19Hu5lIGv0JU3zN8UfEgV0/+/b42mNru9PmdenAmZzllAEFuxKb6ywose2fw8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0UkDABw6ohtJ22tdaxOAXwyPxZuELnjvmHTTEte5wQ=;
 b=VxG3iK/QXShXAm1LUbrhUbNOb+/YLgZt9QtTI4E/g1l7RSlsmwbJuorXmxPVkt+ClM5p8x0Pt26Puy9zaFBnnXcrP45OOixpAMy4A/FpLG+/ILz7jD+QjLuTYe6yU0fu48SlS94hTBrOl3S42SBIk/hDONBSvEApafk5xl9TmEs=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by MWHPR05MB2797.namprd05.prod.outlook.com (2603:10b6:300:60::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.8; Tue, 4 Oct
 2022 00:19:47 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::942c:7d1b:6b3d:85b6%7]) with mapi id 15.20.5709.008; Tue, 4 Oct 2022
 00:19:47 +0000
From:   Nadav Amit <namit@vmware.com>
To:     "H. Peter Anvin" <hpa@zytor.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Ajay Kaher <akaher@vmware.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "er.ajay.kaher@gmail.com" <er.ajay.kaher@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jailhouse-dev@googlegroups.com" <jailhouse-dev@googlegroups.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "acrn-dev@lists.projectacrn.org" <acrn-dev@lists.projectacrn.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Topic: [PATCH v2] x86/PCI: Prefer MMIO over PIO on all hypervisor
Thread-Index: AQHYx28G+J2WSwxm3kmFzqoOhSDYUK3dXFQAgBj77YCABouGgIAAKhGAgAA7TgCAAAYigIAAJ+qAgAAH8wA=
Date:   Tue, 4 Oct 2022 00:19:46 +0000
Message-ID: <CD4F5AD2-AEC6-47B6-AFA0-98DCE2AE1A84@vmware.com>
References: <9FEC6622-780D-41E6-B7CA-8D39EDB2C093@vmware.com>
 <87zgf3pfd1.fsf@redhat.com> <B64FD502-E794-4E94-A267-D690476C57EE@vmware.com>
 <87tu4l9cfm.fsf@redhat.com> <04F550C5-786A-4B8E-9A88-EBFBD8872F16@vmware.com>
 <42CFC548-F8FE-4BD9-89AB-198B2B3F1091@zytor.com>
 <AD04C0EF-E3E0-4DE2-A812-B05382D6F7C2@vmware.com>
 <8859A371-E810-4720-AAFD-06603816AA53@zytor.com>
In-Reply-To: <8859A371-E810-4720-AAFD-06603816AA53@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8531:EE_|MWHPR05MB2797:EE_
x-ms-office365-filtering-correlation-id: 86993544-9e91-40af-e4bd-08daa59e24e9
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7N80bXbU2EmPnlovtiK8XuGaqXR93zh9Zg48ngcf6BB3WjKehE9ucL1exMPTFrEJDw3EgmbfxTKKsc7CwjOR6b5qdPF1UsX+1wpBsj2/xedB+2AgkCVHl6yl+LWeCHwT3H4p1Q3OFOCMaDCmJI49kJf+YnwVQclaTd19IF6ceNsrZjAG1fmT+4YsJohKJvpL/MXBmL5EOCrZiOoOiwh+2XnluvrGRvWBezzz/cKHuf7eYsO6D5XyQdG1kAUHkDPbS7AJMBQhrbQFkgnlx4A3KCA9yOYE7268unahm1wphyp5jcJUUWPcFcl4WaGGLGcLracIr0ifKnTmQHwEOOdZtdLnVrWNOvOTnu6zmVW2rNe1dstbPeFvUmhz9H4v46Oh/5KH9Pt5dizLmJgy4pKW6OXD+xGvlxqiVH3FoT7UuX8ikyV5s9jOHSMR4e9Kx2FXXIR06pYTRxfaiTCE0ofCdWQjs2prEkfiGbaSJfeAbePLEgQq0CZEOmgnanWGQGVVutRrc73/ZGB1AT8yLw1+5bE71myKv2GjsmYkSfWFiGISqxB2jmXTpu/VPsQnOQM1dZACsC4kG2n5oKj40Obe8O0wBaqkPOGO9/73pqn46jjUOv28X6usFTQCvvgYQqYPT9qPq8Dqulm7iUrrK/fAymohvS73/6tzJDupQArmScpCPUAytNy6MjbB6gc0CV5ExD2FzH6gbhJzBiDOnRXfIUiTKcaY5dbl8eWHNVvCqdLhczwBgqBT5YrUVMdIHwKt2LLOwHYXR/0NvpY1daxIBP/vgLVLZh3goBIMG7bvOCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199015)(83380400001)(2616005)(186003)(38070700005)(38100700002)(122000001)(7416002)(8936002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(5660300002)(41300700001)(2906002)(478600001)(71200400001)(26005)(6506007)(6512007)(6916009)(53546011)(54906003)(316002)(6486002)(36756003)(33656002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUhoRUEzeGdRdy9xTi9MNXNHbEF2bEJpZjJWdmg3ZWU4QW5OdFJaK01DelRG?=
 =?utf-8?B?UTJYTTFYQmk3eldoYlpwbjhiQjVIeEhyYjl2SFluZFBFaHhueDBtck83b0xU?=
 =?utf-8?B?Y01wRG9tVVRwcGFNS2EweGJGZTZJR2graDVKeEdub1o1dHM0MXFDYTBFSTZp?=
 =?utf-8?B?cytaVHdJZnRBYmZhN2tUdDhIdlQvbllGWU1VZmZ1c282RkYrNHVpdmJDSEx6?=
 =?utf-8?B?NHlDbTZzVzR0SWhkUE9rc1BlTGo3Z1VkbFdLUXNGQlc3RG4xWVhyU3Y0Q1lS?=
 =?utf-8?B?U2RIdUtVdWNhVzRFV2hUNG9PbGd0QXgrU3NVbXdnWDhjbERhOUpxcmx0cjk2?=
 =?utf-8?B?Tmh3aDdZRExhK3htS2xCSmVHNjlNTk9wY2xaQXo5elN1bzBTSzIyK2kxN29i?=
 =?utf-8?B?dU9DUklsUE0rRFgvY3c5UlJpWkcyb2VqUURpTkMwekRXZmZ1eVVpWlFneWJF?=
 =?utf-8?B?N3hua2ZReHF3ME94VTJ0TnVCdFoxYTl4WGZWRk9QK2RwWDUwa3BmbUlSZzZs?=
 =?utf-8?B?NFdIeUlKNFZPdWZLR01YOENUWHBNNG11WW54cGoydWdpemtFbzZyR0Ruam9Y?=
 =?utf-8?B?VGV1ZnR0MVVzTG03YlFtb2FSSnNzb1MwSGNqZEJLUkNnUnVWTFpXUkR4SUVZ?=
 =?utf-8?B?eGRtK1l2cThyZ3c2MUZDNERlTXVkbUtmRHl3ajF0bHFpZ0o2N2lDODUzSVlG?=
 =?utf-8?B?cWpCeXpxa1lNVVNISTlBd2dMb040SldLT0N0L3lPWHZReHc3aDc4bW85L0VO?=
 =?utf-8?B?NkJvNnRKcmwxTGlGUHNVaEJzTm9ZajR5eWV0SWdxNXBuNG9ZZkRQK3dRam51?=
 =?utf-8?B?UWp6RGRDY1pBMnluTnNpV3cwNmVrWnphajBOWjdEK1UzRWcvZmNxRUhHZ2Nw?=
 =?utf-8?B?RjVibXdFMmw2VHRnVTNvSlpJNUNORk1QaWNaWTNvY1A1OFhmZFhUWmlaSHFL?=
 =?utf-8?B?QVNBSjNzMjFKU2hOdU5pa1pYd3phVHNoZXZ1L1IrNmtDekQ2Z2xuVDBNOVpt?=
 =?utf-8?B?cVZkRnA0TDRzUkZMLzlPNW1SY0VXWlVBaWJOREtkTEdDN1MvY1IzQ0Eza3c4?=
 =?utf-8?B?ejJTRXJVV3kvMEdYaEkwZW1Oc3hScFpkN0NoSlN6eFI3R3J0cmZyeXpTanBJ?=
 =?utf-8?B?Z1VLSWZpdHdxWXVzaFBsVnA5TDZHTFloakpVQ2NBVUZkODkrNEJIdW53TEpw?=
 =?utf-8?B?N29yYzYxVGs3Yi9wOEF3SUloZWRvNjJwNHA1RC9pMFpQNm12bnFVZFZGQmtV?=
 =?utf-8?B?ak1mbVE3ckRzekhlWXBzYUprQnZQM0NlUHU4bm8vV1NzMG1nakYwM3RqUWhR?=
 =?utf-8?B?NE1EN3haOEtEZk9nUmk3RmxMd2NzN1E2R3dldU9oNlhOVDRhZm1VK056QmRL?=
 =?utf-8?B?bkRiNEN3V0FHOHAxSlppVEFlZG5ISnZNRVpiZnZMWnpuWWcrWFFMZWkxSmQ5?=
 =?utf-8?B?V2pBVWRpd1NKcWtaTzBYc2s2YWk1U2N0ZEN3T2pyR0JRczZlRkVGWTNFYzdB?=
 =?utf-8?B?dkc1MzVXTzV5OGtmWk9naGdFQk00dE43SzF1ZGFFeGJPaXYrNlk4WCtiTk92?=
 =?utf-8?B?Sm1iamVxWUpLcDRxWVVlL3lEYjdOUS8wZnlseE9UY2h5SDRRamJpOXk1bmxr?=
 =?utf-8?B?a21YSHN3N2pQUElMSHRNMXZvK3g1OVdVSTZWSUp1TklUVWtDaHRpK3hLbGox?=
 =?utf-8?B?dS9rZmJBa1Q1ZHltRFhRMm41bk0rblZGa1lJSzV0dlFXYWJkWVlVRTY3U2E2?=
 =?utf-8?B?MUFIblZ3bWpXbXZwVVlSMmNxY2RjSmhHcDBFZlBtTnJTczJCZGEvNVJCanRk?=
 =?utf-8?B?dUVaTm82TTRrMzdBRkZrdjJyRTBWZFBuaUxKVkI3b3BFd08wbXE1UFJXQlM0?=
 =?utf-8?B?a1Q1T0Z1RGdyeEY2MkV0eXdOUlQ0WEhXSWVIV1FhYnM0N2k3T0JNdUI2U2NH?=
 =?utf-8?B?aW1ZV2FHZTcwODdSMlNQWHJ0N09oY2RPNEpoQmpReG1JSXpGT1JuY3loOVoz?=
 =?utf-8?B?eElRU3JpRUdiZjVyVEc1T2syZTUzNDVJdHB5UGxBSTA4cG13ZC9sTUIwb1Zv?=
 =?utf-8?B?SXdZZ3k4dnJXK25kOW1kbnVoMFVob0ZLV0M5S1BXMGhKS1BQemNyRldnWGtp?=
 =?utf-8?Q?BcZyoJ3RGEu3sHL91TgjwcoUJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2B1F25462B88D4794E529D8DBDA59C6@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86993544-9e91-40af-e4bd-08daa59e24e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 00:19:46.8445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Csdm8jE2Q4IDVUn8fk5GivlsK2y6kcs/AII07MLZtqoTtkZlDHo4RlL5iyR1FH7c11pin3Acq+hQBB+J/oIbaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2797
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gT2N0IDMsIDIwMjIsIGF0IDQ6NTEgUE0sIEguIFBldGVyIEFudmluIDxocGFAenl0b3IuY29t
PiB3cm90ZToNCg0KPiDimqAgRXh0ZXJuYWwgRW1haWwNCj4gDQo+IE9uIE9jdG9iZXIgMywgMjAy
MiAyOjI4OjQwIFBNIFBEVCwgTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNvbT4gd3JvdGU6DQo+
PiBPbiBPY3QgMywgMjAyMiwgYXQgMjowNiBQTSwgSC4gUGV0ZXIgQW52aW4gPGhwYUB6eXRvci5j
b20+IHdyb3RlOg0KPj4gDQo+Pj4g4pqgIEV4dGVybmFsIEVtYWlsDQo+Pj4gDQo+Pj4gT24gT2N0
b2JlciAzLCAyMDIyIDEwOjM0OjE1IEFNIFBEVCwgTmFkYXYgQW1pdCA8bmFtaXRAdm13YXJlLmNv
bT4gd3JvdGU6DQo+Pj4+IE9uIE9jdCAzLCAyMDIyLCBhdCA4OjAzIEFNLCBWaXRhbHkgS3V6bmV0
c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPiB3cm90ZToNCj4+Pj4gDQo+Pj4+PiBOb3QgbXkgYnV0
IHJhdGhlciBQQ0kgbWFpbnRhaW5lcidzIGNhbGwgYnV0IElNSE8gZHJvcHBpbmcgJ2NvbnN0JyBp
cw0KPj4+Pj4gYmV0dGVyLCBpbnRyb2R1Y2luZyBhIG5ldyBnbG9iYWwgdmFyIGlzIG91ciAnbGFz
dCByZXNvcnQnIGFuZCBzaG91bGQgYmUNCj4+Pj4+IGF2b2lkZWQgd2hlbmV2ZXIgcG9zc2libGUu
IEFsdGVybmF0aXZlbHksIHlvdSBjYW4gYWRkIGENCj4+Pj4+IHJhd19wY2lfZXh0X29wc19wcmVm
ZXJyZWQoKSBmdW5jdGlvbiBjaGVja2luZyBzb21ldGhpbiB3aXRoaW4gJ3N0cnVjdA0KPj4+Pj4g
aHlwZXJ2aXNvcl94ODYnIGJ1dCBJJ20gdW5zdXJlIGlmIGl0J3MgYmV0dGVyLg0KPj4+Pj4gDQo+
Pj4+PiBBbHNvLCBwbGVhc2UgY2hlY2sgQWxleCcgcXVlc3Rpb24vc3VnZ2VzdGlvbi4NCj4+Pj4g
DQo+Pj4+IEhlcmUgaXMgbXkgdGFrZSAoYW5kIEFqYXkga25vd3MgcHJvYmFibHkgbW9yZSB0aGFu
IG1lKToNCj4+Pj4gDQo+Pj4+IExvb2tpbmcgYnJpZWZseSBvbiBNQ0ZHLCBJIGRvIG5vdCBzZWUg
YSBjbGVhbiB3YXkgb2YgdXNpbmcgdGhlIEFDUEkgdGFibGUuDQo+Pj4+IFRoZSB0d28gb3B0aW9u
cyBhcmUgZWl0aGVyIHRvIHVzZSBhIHJlc2VydmVkIGZpZWxkICh3aGljaCB3aG8ga25vd3MsIG1p
Z2h0DQo+Pj4+IGJlIHVzZWQgb25lIGRheSkgb3Igc29tZSBPRU0gSUQuIEkgYW0gYWxzbyBub3Qg
ZmFtaWxpYXIgd2l0aA0KPj4+PiBQQ0lfQ09NTUFORC5NRU1PUlk9MCwgc28gQWpheSBjYW4gaG9w
ZWZ1bGx5IGdpdmUgc29tZSBhbnN3ZXIgYWJvdXQgdGhhdC4NCj4+Pj4gDQo+Pj4+IEFueWhvdywg
SSB1bmRlcnN0YW5kIChhbHRob3VnaCBub3QgcmVsYXRlKSB0byB0aGUgb2JqZWN0aW9uIGZvciBh
IG5ldyBnbG9iYWwNCj4+Pj4gdmFyaWFibGUuIEhvdyBhYm91dCBleHBsaWNpdGx5IGNhbGxpbmcg
dGhpcyBoYXJkd2FyZSBidWcgYSDigJxidWfigJ0gYW5kIHVzaW5nDQo+Pj4+IHRoZSBwcm9wZXIg
aW5mcmFzdHJ1Y3R1cmU/IENhbGxpbmcgaXQgZXhwbGljaXRseSBhIGJ1ZyBtYXkgZXZlbiBwdXNo
IHdob2V2ZXINCj4+Pj4gY2FuIHRvIHJlc29sdmUgaXQuDQo+Pj4+IA0KPj4+PiBJT1csIGhvdyBh
Ym91dCBkb2luZyBzb21ldGhpbmcgYWxvbmcgdGhlIGxpbmVzIG9mIChub3QgdGVzdGVkKToNCj4+
Pj4gDQo+Pj4+IA0KPj4+PiAtLSA+OCAtLQ0KPj4+PiANCj4+Pj4gU3ViamVjdDogW1BBVENIXSB4
ODYvUENJOiBQcmVmZXIgTU1JTyBvdmVyIFBJTyBvbiBWTXdhcmUgaHlwZXJ2aXNvcg0KPj4+PiAN
Cj4+Pj4gLS0tDQo+Pj4+IGFyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmggfCAxICsN
Cj4+Pj4gYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYyAgICAgICB8IDIgKysNCj4+Pj4gYXJj
aC94ODYva2VybmVsL2NwdS92bXdhcmUuYyAgICAgICB8IDIgKysNCj4+Pj4gYXJjaC94ODYvcGNp
L2NvbW1vbi5jICAgICAgICAgICAgICB8IDYgKysrKy0tDQo+Pj4+IDQgZmlsZXMgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9jcHVmZWF0dXJlcy5oDQo+Pj4+IGluZGV4IGVmNDc3NWM2ZGIwMS4uMjE2YjZmMzU3YjZkIDEw
MDY0NA0KPj4+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oDQo+Pj4+
ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4+Pj4gQEAgLTQ2MCw1
ICs0NjAsNiBAQA0KPj4+PiAjZGVmaW5lIFg4Nl9CVUdfTU1JT19VTktOT1dOICAgICAgICAgIFg4
Nl9CVUcoMjYpIC8qIENQVSBpcyB0b28gb2xkIGFuZCBpdHMgTU1JTyBTdGFsZSBEYXRhIHN0YXR1
cyBpcyB1bmtub3duICovDQo+Pj4+ICNkZWZpbmUgWDg2X0JVR19SRVRCTEVFRCAgICAgICAgICAg
ICAgWDg2X0JVRygyNykgLyogQ1BVIGlzIGFmZmVjdGVkIGJ5IFJFVEJsZWVkICovDQo+Pj4+ICNk
ZWZpbmUgWDg2X0JVR19FSUJSU19QQlJTQiAgICAgICAgICAgWDg2X0JVRygyOCkgLyogRUlCUlMg
aXMgdnVsbmVyYWJsZSB0byBQb3N0IEJhcnJpZXIgUlNCIFByZWRpY3Rpb25zICovDQo+Pj4+ICsj
ZGVmaW5lIFg4Nl9CVUdfRUNBTV9NTUlPICAgICAgICAgICAgIFg4Nl9CVUcoMjkpIC8qIEVDQU0g
TU1JTyBpcyBidWdneSBhbmQgUElPIGlzIHByZWZlcmFibGUgKi8NCj4+Pj4gDQo+Pj4+ICNlbmRp
ZiAvKiBfQVNNX1g4Nl9DUFVGRUFUVVJFU19IICovDQo+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rZXJuZWwvY3B1L2NvbW1vbi5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9jb21tb24uYw0KPj4+
PiBpbmRleCAzZTUwOGYyMzkwOTguLmM5NDE3NWZhMzA0YiAxMDA2NDQNCj4+Pj4gLS0tIGEvYXJj
aC94ODYva2VybmVsL2NwdS9jb21tb24uYw0KPj4+PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2NvbW1vbi5jDQo+Pj4+IEBAIC0xMjk5LDYgKzEyOTksOCBAQCBzdGF0aWMgdm9pZCBfX2luaXQg
Y3B1X3NldF9idWdfYml0cyhzdHJ1Y3QgY3B1aW5mb194ODYgKmMpDQo+Pj4+IHsNCj4+Pj4gICAg
IHU2NCBpYTMyX2NhcCA9IHg4Nl9yZWFkX2FyY2hfY2FwX21zcigpOw0KPj4+PiANCj4+Pj4gKyAg
ICAgIHNldHVwX2ZvcmNlX2NwdV9idWcoWDg2X0JVR19FQ0FNX01NSU8pOw0KPj4+PiArDQo+Pj4+
ICAgICAvKiBTZXQgSVRMQl9NVUxUSUhJVCBidWcgaWYgY3B1IGlzIG5vdCBpbiB0aGUgd2hpdGVs
aXN0IGFuZCBub3QgbWl0aWdhdGVkICovDQo+Pj4+ICAgICBpZiAoIWNwdV9tYXRjaGVzKGNwdV92
dWxuX3doaXRlbGlzdCwgTk9fSVRMQl9NVUxUSUhJVCkgJiYNCj4+Pj4gICAgICAgICAhKGlhMzJf
Y2FwICYgQVJDSF9DQVBfUFNDSEFOR0VfTUNfTk8pKQ0KPj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva2VybmVsL2NwdS92bXdhcmUuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMNCj4+
Pj4gaW5kZXggMDIwMzllYzM1OTdkLi44OTAzNzc2Mjg0YTYgMTAwNjQ0DQo+Pj4+IC0tLSBhL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMNCj4+Pj4gKysrIGIvYXJjaC94ODYva2VybmVsL2Nw
dS92bXdhcmUuYw0KPj4+PiBAQCAtMzg1LDYgKzM4NSw4IEBAIHN0YXRpYyB2b2lkIF9faW5pdCB2
bXdhcmVfc2V0X2NhcGFiaWxpdGllcyh2b2lkKQ0KPj4+PiAgICAgICAgICAgICBzZXR1cF9mb3Jj
ZV9jcHVfY2FwKFg4Nl9GRUFUVVJFX1ZNQ0FMTCk7DQo+Pj4+ICAgICBlbHNlIGlmICh2bXdhcmVf
aHlwZXJjYWxsX21vZGUgPT0gQ1BVSURfVk1XQVJFX0ZFQVRVUkVTX0VDWF9WTU1DQUxMKQ0KPj4+
PiAgICAgICAgICAgICBzZXR1cF9mb3JjZV9jcHVfY2FwKFg4Nl9GRUFUVVJFX1ZNV19WTU1DQUxM
KTsNCj4+Pj4gKw0KPj4+PiArICAgICAgc2V0dXBfY2xlYXJfY3B1X2NhcChYODZfQlVHX0VDQU1f
TU1JTyk7DQo+Pj4+IH0NCj4+Pj4gDQo+Pj4+IHN0YXRpYyB2b2lkIF9faW5pdCB2bXdhcmVfcGxh
dGZvcm1fc2V0dXAodm9pZCkNCj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3BjaS9jb21tb24u
YyBiL2FyY2gveDg2L3BjaS9jb21tb24uYw0KPj4+PiBpbmRleCBkZGI3OTg2MDMyMDEuLmJjODFj
ZjRjMTAxNCAxMDA2NDQNCj4+Pj4gLS0tIGEvYXJjaC94ODYvcGNpL2NvbW1vbi5jDQo+Pj4+ICsr
KyBiL2FyY2gveDg2L3BjaS9jb21tb24uYw0KPj4+PiBAQCAtNDAsNyArNDAsOCBAQCBjb25zdCBz
dHJ1Y3QgcGNpX3Jhd19vcHMgKl9fcmVhZF9tb3N0bHkgcmF3X3BjaV9leHRfb3BzOw0KPj4+PiBp
bnQgcmF3X3BjaV9yZWFkKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVkIGludCBidXMsIHVu
c2lnbmVkIGludCBkZXZmbiwNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBpbnQgcmVnLCBpbnQgbGVuLCB1MzIgKnZhbCkNCj4+Pj4gew0KPj4+PiAtICAg
ICAgaWYgKGRvbWFpbiA9PSAwICYmIHJlZyA8IDI1NiAmJiByYXdfcGNpX29wcykNCj4+Pj4gKyAg
ICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcgPCAyNTYgJiYgcmF3X3BjaV9vcHMgJiYNCj4+Pj4g
KyAgICAgICAgICAoYm9vdF9jcHVfaGFzX2J1ZyhYODZfQlVHX0VDQU1fTU1JTykgfHwgIXJhd19w
Y2lfZXh0X29wcykpDQo+Pj4+ICAgICAgICAgICAgIHJldHVybiByYXdfcGNpX29wcy0+cmVhZChk
b21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOw0KPj4+PiAgICAgaWYgKHJhd19wY2lf
ZXh0X29wcykNCj4+Pj4gICAgICAgICAgICAgcmV0dXJuIHJhd19wY2lfZXh0X29wcy0+cmVhZChk
b21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVuLCB2YWwpOw0KPj4+PiBAQCAtNTAsNyArNTEsOCBA
QCBpbnQgcmF3X3BjaV9yZWFkKHVuc2lnbmVkIGludCBkb21haW4sIHVuc2lnbmVkIGludCBidXMs
IHVuc2lnbmVkIGludCBkZXZmbiwNCj4+Pj4gaW50IHJhd19wY2lfd3JpdGUodW5zaWduZWQgaW50
IGRvbWFpbiwgdW5zaWduZWQgaW50IGJ1cywgdW5zaWduZWQgaW50IGRldmZuLA0KPj4+PiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCByZWcsIGludCBsZW4s
IHUzMiB2YWwpDQo+Pj4+IHsNCj4+Pj4gLSAgICAgIGlmIChkb21haW4gPT0gMCAmJiByZWcgPCAy
NTYgJiYgcmF3X3BjaV9vcHMpDQo+Pj4+ICsgICAgICBpZiAoZG9tYWluID09IDAgJiYgcmVnIDwg
MjU2ICYmIHJhd19wY2lfb3BzICYmDQo+Pj4+ICsgICAgICAgICAgKGJvb3RfY3B1X2hhc19idWco
WDg2X0JVR19FQ0FNX01NSU8pIHx8ICFyYXdfcGNpX2V4dF9vcHMpKQ0KPj4+PiAgICAgICAgICAg
ICByZXR1cm4gcmF3X3BjaV9vcHMtPndyaXRlKGRvbWFpbiwgYnVzLCBkZXZmbiwgcmVnLCBsZW4s
IHZhbCk7DQo+Pj4+ICAgICBpZiAocmF3X3BjaV9leHRfb3BzKQ0KPj4+PiAgICAgICAgICAgICBy
ZXR1cm4gcmF3X3BjaV9leHRfb3BzLT53cml0ZShkb21haW4sIGJ1cywgZGV2Zm4sIHJlZywgbGVu
LCB2YWwpOw0KPj4+IA0KPj4+IEFsc28uLi4gYW55IHJlYXNvbiB3ZSBjYW4ndCBqdXN0IHNldCBy
YXdfcGNpX29wcyA9PSByYXdfZXh0X3BjaV9vcHMgZm9yIHRoZSBjYXNlIHdoZW4gdGhlIGxhdHRl
ciBpcyBwcmVmZXJyZWQsIGFuZCBkaXNwZW5zZSB3aXRoIHRoZSBjb25kaXRpb25hbHMgaW4gdGhl
IHVzZSBwYXRoPyBTaW1pbGFybHksIHJhd19leHRfcGNpX29wcyBjb3VsZCBiZSBwb2ludGVkIHRv
IGVycm9yIHJvdXRpbmVzIGluc3RlYWQgb2YgbGVmdCBhdCBOVUxMLg0KPj4gDQo+PiBJIHVuZGVy
c3Rvb2QgZnJvbSBBamF5IHRoYXQgdGhlIGluaXRpYWxpemF0aW9uIG9mIHJhd19leHRfcGNpX29w
cyBjYW4gYmUNCj4+IGRvbmUgYWZ0ZXIgdGhlIGh5cGVydmlzb3IgaW5pdGlhbGl6YXRpb24gdGFr
ZXMgcGxhY2UsIHNvIGRvaW5nIHdoYXQgZXhhY3RseQ0KPj4gd2hhdCB5b3UgcHJvcG9zZWQgYnkg
aXMgbm90IHBvc3NpYmxlLiBJdCBjYW4gcHJvYmFibHkgYmUgcmVzb2x2ZWQsIGJ1dCBJIGRvDQo+
PiBub3QgdGhpbmsgdGhlIGVuZCByZXN1bHQgd291bGQgYmUgc2ltcGxlciBvciBjbGVhbmVyLiBJ
IHRoaW5rIHRoYXQgdGhlIOKAnGJ1Z+KAnQ0KPj4gc29sdXRpb24gcmVhbGx5IGNvbnZleXMgdGhl
IGJlaGF2aW9yLg0KPj4gDQo+PiBJSVVDIHBlcmZvcm1hbmNlIHdvdWxkIG5vdCBiZSBub3RpY2Vh
YmxlIGFmZmVjdGVkIGJ5IDIgbW9yZSBjb25kaXRpb25hbA0KPj4gYnJhbmNoZXMuDQo+IA0KPiBJ
c24ndCB0aGF0IGV4YWN0bHkgd2hhdCB5b3Ugd291bGQgd2FudD8hPw0KDQpUd28gYnJhbmNoZXMg
KHdoaWNoIGFyZSBwcm9iYWJseSBtb3N0bHkgcHJlZGljdGVkIGNvcnJlY3RseSkgYXJlDQppbmV4
cGVuc2l2ZSAobmFub3NlY29uZHM/KQ0KDQpDYXVzaW5nIGEgVk0tZXhpdCwgYW5kIHRoZSB3aG9s
ZSBtZXNzIG9mIGhhbmRsaW5nIGl0IGluIHRoZSBoeXBlcnZpc29yDQoocG90ZW50aWFsbHkgdGhl
IHVzZXJzcGFjZSBwYXJ0IG9mIHRoZSBoeXBlcnZpc29yKSBpcyBleHBlbnNpdmUNCihtaWNyb3Nl
Y29uZHMpLiBJSVVDLCBBamF5IHdhbnRzIHRvIGxldCByZWFkcyB0byBwYXNzIHRocm91Z2ggdG8g
bWVtb3J5LA0KYXZvaWRpbmcgdGhlc2UgVk0tZXhpdHMuDQoNCg==
