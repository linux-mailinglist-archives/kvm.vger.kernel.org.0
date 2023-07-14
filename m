Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917AA7542B2
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 20:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbjGNSmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 14:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbjGNSma (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 14:42:30 -0400
Received: from MW2PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6191BEB
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 11:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpGa1QsdkbsF86wP+XGvTjEnmRPjCdvxUyB/kgxJBjI3CisDE9QTnAi9zAY8UnAnmIufD3mmQumbkBgctPwoQk8ef6rCAFeU+BtYeG2pYK+FW4vzmUI4gu7TONyutFgtZiJq84eTT6J+ZHnUi/ztPI4tyMY/Nb12fYnydF1LQjK5/Y3/ekd6m7g4qM/p5hHwp0Tol7nxQBEXrIQ8p79AMV9hpiYo5mq2TgV2VO2yxiSlNZgNovVNaDKmXjLIWtLkA2VZCYMcqUMVhGCgi4OKNH95rF1t6PKzLS7uRBUxMv27PNr7KzTME5ZBL3QyOyOy0mIbmUcjZdSutMQgzA3BBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HcIFFdjBu3uaW6+UMJa6utqIzwYi5IV5eWym1OjCKU=;
 b=ER3weaYQboheanw4oL52ioJa+pxoD4QOQvjc67rrziftpSSB+MeJ+GQ+W9D8G5Qf1wBQakiaqeTh15ZUy/DjoFI4vrpShralXin4zSeA7T7zfKb8dVYr62va/QLGxcUsogsYfCirGiydart+WkD72dsnoFVuEgj3MDsf4IwenODYvSdWhTVSvsClodhzeAYKgZNMk+PDCGK3w6ZEnuZ6N7OAYD3R43EwBOXwWXmEHtNvKzEW59KSMRWiduysa/eC/lVvr0h24UR26TcYxmNSe72uaShXZIU3Su81ItqQu+RRTJz7RT7tELEECtklPpvyiUBY1Csx2rqOWQKgsTtnGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HcIFFdjBu3uaW6+UMJa6utqIzwYi5IV5eWym1OjCKU=;
 b=nfTrIM/jwnTgkRwl8XV9g1DlZJjYLB2qxyZ8CnO5Hoq+GHMs3lHb3SZAMLzzkL4zg2bpZ7KoEcxu+9rJiVKA0jLnbl/82q9v82zvssKLAnqMFZXnUsaq3/zuNeYF+shfPkz2GXaeFHNwpALxjffwLLoV0R3xEffOaRDNrzXlKnQ=
Received: from SA1PR05MB8534.namprd05.prod.outlook.com (2603:10b6:806:1dd::19)
 by PH7PR05MB9250.namprd05.prod.outlook.com (2603:10b6:510:1f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 18:42:25 +0000
Received: from SA1PR05MB8534.namprd05.prod.outlook.com
 ([fe80::b4eb:7a17:62c8:72c9]) by SA1PR05MB8534.namprd05.prod.outlook.com
 ([fe80::b4eb:7a17:62c8:72c9%3]) with mapi id 15.20.6588.027; Fri, 14 Jul 2023
 18:42:25 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Shaoqin Huang <shahuang@redhat.com>
CC:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Topic: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Thread-Index: AQHZoLuTHvENrVBKJ02px/P+RINq6q+5OzeAgAAQOACAAHjqAA==
Date:   Fri, 14 Jul 2023 18:42:25 +0000
Message-ID: <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
In-Reply-To: <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR05MB8534:EE_|PH7PR05MB9250:EE_
x-ms-office365-filtering-correlation-id: a2208e29-e9ea-4480-2d3d-08db849a112b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O2fcitZiyodhSssTR9oZp5Ab1sHAwPScWpZu0GfjS6SPFCBYLgMmn7V1Na4si0iEH41D6TqB2xfGT1SkKzEF1Cn7YTtkazc3aUM2UyecjufULZY1frrU16Ymtm+bn+63TnxpQ6mecJ9+3cMaof9uP28cP9eCbO68StjfiJ2nCBFBRTOBK4K3L+Gt0j/xYTt3NPdRCEg4DyKeUYCM9G3avCuLNyS0vu3mfAaidbUYfodizIdqPbFjxWUrfGH8x8c0yOs5kI+vfiTrfF6oVndLKTzptuKz+glCOeuygobGkza+XC4/yqGglccDamAAEKyk94uF1OJ1+QpengLq/AAEpqyrwZEI7kHBFnZVmIGd8T6ppC6EBiz5hwVaDAj5vR7hGjSB9lS/o1z+hSHzQmBJumlkqyYExS4sO3ylbaDY7Q75nmpfaVPKt2I39lw+kwLrLIcPIWsdos7b0GZy1hZMxnJSKv8kCLTWEG9FsIOuQAG0F7S8SwxMTikeE/Of6Esdptsns6bW7UDqwrPFn/5aFdqh2e/7eFSH1jyjNKM+b0QaiJKm8mYwCqz+0+4M+qWcHDDbmwkLfCEmTN/d9VfoXWLvCuF02XmeCfrFCtIoA8udYdcq4IBM4CBap4pnziEJPQVki+L4s8F6tsHEFhE3K/5GLIHgwa4ud41UAf3cIppAxc/rJT7mUqydL81IXowvsFaqBe7e4CzAqVCh+qcLkYLBRd7+xOtCPDfF7vLoRG36yfeLmT51+GFCWkg5dc7q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR05MB8534.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199021)(6486002)(54906003)(71200400001)(91956017)(478600001)(2616005)(36756003)(33656002)(38070700005)(86362001)(2906002)(76116006)(6506007)(186003)(53546011)(26005)(6512007)(966005)(38100700002)(99936003)(64756008)(122000001)(6916009)(4326008)(66476007)(66946007)(41300700001)(66446008)(8936002)(5660300002)(316002)(8676002)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czRZNmwrYWFCTFIyeEF5RmlvRnpxQ0dGdHdGcEZiMXZEYldIUzFFajVHWmlh?=
 =?utf-8?B?VW5NTUhKYk5DK2VWL1JpdVRJbzI1R1AyQnVlcFVMVEIvWS9pR2xkazJxWFVh?=
 =?utf-8?B?SStmc2h6b1RsbkZ5K2hSL1dQcjNvME1aa1F1Qm5TRmMyaC9GS1lBRW4rYS9p?=
 =?utf-8?B?dFF6MlJsTDVEV054a2FXTGk2RnFGZDlvVFpCOG9IUkwrb09CMTFBa1ZPR2pW?=
 =?utf-8?B?YldaQzlhdzlvb0xMM0VYeGRCU0pRZmkvUDJ2WldscVJVUElKWjNIVi9ia2VD?=
 =?utf-8?B?Um1RSGo1NGFOS1dVQmNNQlZBVE8zZEx1Y2V5NEIyQnhjQ2MyQUJKclpRWWtu?=
 =?utf-8?B?Q1BvbHk5UGc0OURpUHliV2lXSW0xaVNQaHhTM2U0ZXpBa3ZCZS9mZVJaalBK?=
 =?utf-8?B?RE1LN21ST3cvWUFQMEV1a01wRFA2UlRwWUdPdjNHaUZXSGR1R1A3a0sxSFdY?=
 =?utf-8?B?UWZOMmRaUXg0cVZBQjNLNWN1THR5S0RRbEVxeTIzbWhNVFMyelZ0MjdIbWdH?=
 =?utf-8?B?S3BpTWk4V2xMVXhHcURIM3htbWwwRUJBT1Y5TFMrQk1iRWREQmhSUmRNM1U3?=
 =?utf-8?B?NFZVV0d5c0xnVjhWODFEWVpMT3dwYUNTRmNtYW9sOHllRFBqSnhseUlvb2Ev?=
 =?utf-8?B?SEhiMjF3cDA2QW5JT2pScFlZcmNJdE8xVmFMV1lPaG1tUE9GSFdjODVPOUxJ?=
 =?utf-8?B?RlczOWZKdzUxUjJGbmRsVzN3clNFOEVXajdOenNoUUlWOHNhakJNSHg0NDBt?=
 =?utf-8?B?OEMwZ3BOT1RmRjhRdHp4NXN5WW5pZlFXN2g0dlBLNkhnM2RpME5OampwM3Bu?=
 =?utf-8?B?Y1BMRE1CbGNmL2k1S3hGbUdqTTRjMFFRY1dpMnI4b3NvK2dhdEtBQUhmY2dt?=
 =?utf-8?B?TzhSQ0dPOElaT3hVSzRhSklTOEoweHo4RE9XZXNNTnh0bmZYWDZYOFJYREJ3?=
 =?utf-8?B?T3VBNUZZc1cyTmJucXFTSUxJdlFCa0FlZ3lMdWhhalM3c3VVem5jRWF3d2Ns?=
 =?utf-8?B?dXhkZEM5UGpHdWtueDQzOGNKMDhST3dTRW9FT3cvMDI2aUxjV29DdTZjTy9R?=
 =?utf-8?B?RXV4d2QxTlJRK3Bta0Z2eFYrUlkwYXNkVElyWlRYQkM0cllwUGFRbHcxSi9n?=
 =?utf-8?B?cC9vVGczWFdoRUM5ZG85VlQvcktZdWtBV3hTYVVZTXpkWlBJM2ZaWnBqWlhZ?=
 =?utf-8?B?WHMycnY4anU0MUlrOFNuVGRIdjVCQ1JSTTZVM25kSFM1YW5hQWNPTXdyTlNo?=
 =?utf-8?B?WkJqOFM3L1ZmcTRnUTRoU1hxRHhFT0hyUmFENmNoY3Vpc0tXSSttaWZrb0Vo?=
 =?utf-8?B?QnoxODhKYlVEWjlkc1dEclFleWt4aXFWRVcydFJYV0IvcVNQSEE3RHU5MldW?=
 =?utf-8?B?cDlVMkYzVGRHeVNrUjBJRFZ2aFpvNUN3S0NkZ2theitHeHRhNE1rV2lLQ09u?=
 =?utf-8?B?ZnFiYUg3ODJwQlRqclU5M3hUTkRKY1Bwb1ZTT0V0ZUFyTG1Xck1WK1RWNnBD?=
 =?utf-8?B?a1IyeHhHTFg3UXVLc0tQNE8rYmkwUm5zdllUeFluakdwejhlN1NTZlhoL2NP?=
 =?utf-8?B?NStKSXBqeUFMMjJFOVBCaUJ1ZXZ5YndtRmNLdU9rOFpyS0FwcU5oZFBQbE9E?=
 =?utf-8?B?Zy8reUFKM2xnK2dvTktGK2pWMjBETXB6aDNrQzk5QkNsdURZaGZqVW1mUnBP?=
 =?utf-8?B?VC9JM2wxU0ZNbGlHeW5Od3BpRVpVeDBGVlNwbkFyMzhVR01EMkI2M2xML2F4?=
 =?utf-8?B?SDB0QVJmNGZ2UWtKektVOXA5aGY4RzNiMCtNOFlXazc1UERmSjlOVG1oSWY2?=
 =?utf-8?B?V0xhVlVGSkRUWCt2dERxQXBwbFVGajlFUUswQTRIeGxNK1VlNEpZamJrRmhx?=
 =?utf-8?B?aE9Cc1l3SFNHUE4zbkhqVlVLSm9OSG1vcUVkTmQvbzhrWVhjSjVaVzE3S3FF?=
 =?utf-8?B?R0ZiYVNHYTdreVVISnREZC94QytFRWdkNEx6WC9YSUhVandXWjJoMW5sa3VS?=
 =?utf-8?B?V1pqeWJiMWwwMFRWdnhRanpNY0NBSWlQYWtrRlRyQ2F0WnU0aE9xY3Z6WG9i?=
 =?utf-8?B?STdvUzBYM1F1SUY2czF3Wkp1TXZWMFBjRTBIUExRZXZmZzBsMnhQTURzZURm?=
 =?utf-8?Q?P1tMPi4f1EmaudXqSG/MZHfpO?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_9AEB8435-B951-44A4-8DE9-F5DA77F1B210";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR05MB8534.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2208e29-e9ea-4480-2d3d-08db849a112b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2023 18:42:25.0669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N8YLGGBpFgmrYWc2wKMntnWD+CIHYSGwJ64KfBG2G+BqDgZP8Asfc0SoH7+QJy4uFzxrSNcyGorwZuTMxXFx/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR05MB9250
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

--Apple-Mail=_9AEB8435-B951-44A4-8DE9-F5DA77F1B210
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jul 14, 2023, at 4:29 AM, Shaoqin Huang <shahuang@redhat.com> =
wrote:
>=20
> !! External Email
>=20
> Hi,
>=20
> On 7/14/23 18:31, Alexandru Elisei wrote:
>> Hi,
>>=20
>> On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
>>> From: Nadav Amit <namit@vmware.com>
>>>=20
>>> Do not assume PAN is not supported or that sctlr_el1.SPAN is already =
set.
>>=20
>> In arm/cstart64.S
>>=20
>> .globl start
>> start:
>>         /* get our base address */
>>      [..]
>>=20
>> 1:
>>         /* zero BSS */
>>      [..]
>>=20
>>         /* zero and set up stack */
>>      [..]
>>=20
>>         /* set SCTLR_EL1 to a known value */
>>         ldr     x4, =3DINIT_SCTLR_EL1_MMU_OFF
>>      [..]
>>=20
>>         /* set up exception handling */
>>         bl      exceptions_init
>>      [..]
>>=20
>> Where in lib/arm64/asm/sysreg.h:
>>=20
>> #define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | =
_BITUL(20) | \
>>                          _BITUL(22) | _BITUL(23) | _BITUL(28) | =
_BITUL(29))
>> #define INIT_SCTLR_EL1_MMU_OFF  \
>>                         SCTLR_EL1_RES1
>>=20
>> Look like bit 23 (SPAN) should be set.
>>=20
>> How are you seeing SCTLR_EL1.SPAN unset?
>=20
> Yeah. the sctlr_el1.SPAN has always been set by the above flow. So =
Nadav
> you can describe what you encounter with more details. Like which =
tests
> crash you encounter, and how to reproduce it.

I am using Nikos=E2=80=99s work to run the test using EFI, not from =
QEMU.

So the code that you mentioned - which is supposed to initialize SCTLR -
is not executed (and actually not part of the EFI image).

Note that using EFI, the entry point is _start [1], and not =E2=80=9Cstart=
=E2=80=9D.

That is also the reason lack of BSS zeroing also caused me issues with =
the
EFI setup, which I reported before.



[1] =
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/arm/efi/crt=
0-efi-aarch64.S#L113


--Apple-Mail=_9AEB8435-B951-44A4-8DE9-F5DA77F1B210
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmSxlwYACgkQHaAqSaba
D1r3Pw/+IyfyCR20RKKCzVIjxlrfLXm4SfiUVZVULd9aJuU7JPJpoH/zKUh1okVz
MrT08j5+K5ndGvFv9vs6lBuDrkI+xWtzaw9CQWMeMCLl7zIiH4crcaNFOPqAeqKa
l41olufyNw2sAXxTniwcfBMctE0Vri2DDHx8hopbe4ko8mdB/y4WnODwLZAE9C5o
jwaGs9XI8hbk5BWk98/FXj8uv3AjxPb1td2cuzXlc///xdZYdyU6n+eN8EYIxLHy
MYr30Of1wRy68RJfOOeUzv989m2/KOyCov3V5nXczBrERTTfUsgX9F3SaP/J5SlE
20+iPXKJSSWC2mHOOCVtcRHmIojl+BQd4jSekeQsBaA3fjDqfJr3XfZnUNtSFjc0
KhfjG/qRfRgxA60H2VjJBV2xphSvLWXindQbZ71KE4FoToB7tCv/Sny9TKJ8xiV4
XLSt090Aotwz0DznW0IRml3gQsqZLTMANtSuqrEZWizu9TzSLFUwyf4QUXbyZasC
7ghlKyhaf4MrKscYLw+s+3DanPbR0REPURGQU4/U5IMkcLTicSkdjSJGDrFuQtgZ
ye7QRcvd+3aQW3vrn+mCbYjpq6WGxEEaazu+uWfKerZOroE+fUU4EHHVZb5PiF96
JrrET3f1xipKnr+OFBhb4vnyB8K6L+NGE2GEdnz9/b+IbwINBUM=
=Ttxx
-----END PGP SIGNATURE-----

--Apple-Mail=_9AEB8435-B951-44A4-8DE9-F5DA77F1B210--
