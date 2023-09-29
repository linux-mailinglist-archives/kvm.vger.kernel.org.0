Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F151F7B3BDF
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 23:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjI2VTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 17:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjI2VTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 17:19:44 -0400
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2132.outbound.protection.outlook.com [40.107.127.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB831AA
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 14:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvKMKMNWS4wKJummH4Bih42R4t1xl8LiDD2aJZfHPSxgkdhWc4MOAShAQiy7jpLUdCEX/84x2kpb8fjKO+WsJhCEqnqdydmj/jm8Eu/gKM4yTwuiuNAn8OKMfFEBpyyMhCSwYlw65w/Q783HYwCBxg69Q/XEeCfnRRda2y4hYuAKCJNEc0oGHoUo6m1PyRZ3XO8Oyx7fNXTcKR2fOmUYSyDkoHbV3M5R3xBvQrUsU3r7UuUxr33vhJhOXIxp4fuJgqKzr/vG9Hyn5wpIwpC4gdevvWtiULfOn9WF6sBeYZ8UzAjIhg0s7TYiEljsaVkHBNqB1Dc9M2b8T4Ecu/UL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LxTdjSlEbDwwjskGJVqCxNncT1WUECWiSHS133JlVo=;
 b=cns/tbawY6oD7yw0JZNuzSG1f51JxKqEqkYwXHReEpsrnN39b9bVM/DW86CI+LyTbFJ3i6ihpHkeXhnmmx2m0883V9ri88y43p4iwtScBKtSUqkNg68MZ24+xFkOGU+bWT7HSulp4zZhQe6oyqlI189QFgbRbPcuYPC87/R+d9055bVchKwuwe53U7jW0QUXN0AE8mhwxXfcEriq/jqszeL1nVJN6wvibVYjhj4pYyqNMPoLoKodh3Dkxqw73FqLh+MsUHgBznSBQ3FtpVlYaM5MENRehA9+tOYCb+UqPIH/IV3GKZrOHCSyTgr+IXbTM//hAoiPAvS1mdrAkuDDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nio.io; dmarc=pass action=none header.from=nio.io; dkim=pass
 header.d=nio.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nio.io; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LxTdjSlEbDwwjskGJVqCxNncT1WUECWiSHS133JlVo=;
 b=MiNq9YZOQqzQtyKMP3mU1X9zKUD56DbHhx1Pdee0d/wIZSpzadJFamF1unyskC0rrqdpMQR2fFNk1EYFnGA/e/J3ujGVnXddcQvj89YEY+k1P7YC1n/oZPwUuglgnJzFP8bHYo9pdeG5oow2GKGH8g1rodl1aQon1PdwEkUHH+s=
Received: from FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:73::12)
 by BEVP281MB3473.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.27; Fri, 29 Sep
 2023 21:19:38 +0000
Received: from FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM
 ([fe80::f456:c24:7c9b:d966]) by FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM
 ([fe80::f456:c24:7c9b:d966%5]) with mapi id 15.20.6838.028; Fri, 29 Sep 2023
 21:19:38 +0000
From:   Matthias Rosenfelder <matthias.rosenfelder@nio.io>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Thread-Topic: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Thread-Index: AQHZ8xUpYeZOzJqeV0mvBZBYrVbSDQ==
Date:   Fri, 29 Sep 2023 21:19:37 +0000
Message-ID: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_Enabled=True;MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_SiteId=ea1b2f97-423f-4ab3-bf6d-45a36c09ce34;MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_SetDate=2023-09-29T21:19:37.129Z;MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_Name=NIO
 Public
 (L1);MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_ContentBits=0;MSIP_Label_82b19b76-e224-40c8-9ee1-78f1a6cbd1b3_Method=Privileged;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nio.io;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRYP281MB3146:EE_|BEVP281MB3473:EE_
x-ms-office365-filtering-correlation-id: cdc85167-bf19-424c-ded3-08dbc131c94f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9ixdXOjYpD9BqffsZgrTbcK8scUL9QWMb/NzgBQuSQ0vK58/lrM8pqMF1FlNLOHHzgFuVD/Xl/vVaCANSS2/i9JzIGYMbZwZecXM9DymLEn85HdI0mt7lv4naspeyBULiY5y2swpD/bIgfu7Eaqc06JnxlZSyVmoUaHWXR8xzfDVKAjtQzNhJZJr7o7ivbETtSrV3XlevAeyogE6qSmjrmPqY7hY5T7xroIZSQDId8M9WIJc6PL/T0HWXwEzdI7ySbDXroYD9KYMCSpX/ighCB+bTroLRXbi2MRo6rrlE1nCRLMjYmAEmdQVlNvMSc9PLBThZ/MMim9qvIun0e6kZjW83YuvPLi4Hmp6yH5AV96mzYjiA+uV622nwn8JKN6EGJbD+LSiloJCbZpINcwX9A69ncA0mfTQo7Pr3QhceDvj+Rc4oezcjgjftlcycuklQCrfDpW7RVni0x02gpeYTbpL1c1oTE7R3jTQyC7ruy6fLirHDi14UE9hY3sNrMPM5ZuW2+hu4IsKyo4w7tBB7OYSLSnzdgvsS508Fp/z0PYhutRbazHogPx8PwXIeSXRYHYKbZroQN+/7Dt4MDzSQ8tiMTpvJXf7Y452Ki9CmP0IfdPKH6EoqxMRrDbSw/wjw2AAk3Pf+gRCrlAgjAX8UBdL8GYg4ZFr3Hzqn1w1Ag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(376002)(39850400004)(366004)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(5660300002)(52536014)(44832011)(2906002)(8676002)(4326008)(8936002)(41300700001)(54906003)(64756008)(316002)(6916009)(66556008)(66946007)(66476007)(76116006)(55016003)(66446008)(66574015)(33656002)(71200400001)(83380400001)(9686003)(99936003)(122000001)(38070700005)(7696005)(6506007)(86362001)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFhPRFhGUU95YUkrR3BuNUg3cnBCTGUzZ2o1UUFZeUxHL1RZZWJ2TDlrWWlJ?=
 =?utf-8?B?ZVA0YkVKYVZWb3BQalhDcHhQalpTcE1hOWJJdFdMVGZhMnZxMnB2dnE1RHB4?=
 =?utf-8?B?RWtTOHpGRHUzY3FnUVc4eTREVitUUE83YXdSSTdxVU5SV2ZzT3NUWWhNeDRT?=
 =?utf-8?B?MXcxRWVWL1huVE43QzNRTjRYQkZVZXB3QStCQUt4cXdOdmRSK2V5MmloMnhS?=
 =?utf-8?B?d2hKWlZhejRtREhLUUxaZmxtWlQ1RTN0M3F6anpBd2dNU2ErRTBiNjhXZDVx?=
 =?utf-8?B?dEZFem95ajJRWUVzcElheTNaWWdPWFR0NUNId2tKWXJRWEtUOUxtMmhoZHFi?=
 =?utf-8?B?ZXNTZmxIdnJnMVYrSkphdmk5S0w1SXk1UEV3N3RJcEVQa0x2QWxrSCtFUEFI?=
 =?utf-8?B?TEoyay9yOHA5YmQrcHoxU21JbTUxY1ZWb2NlcmZ3Qm8xREV1NkZpTHBIRVd0?=
 =?utf-8?B?eWJQV2tDUGgwVFpDYUZ3eTYwMTNMdUVoRisrRnJoS3pPVWIrSVVWY2JXNFhl?=
 =?utf-8?B?bFBOK3M0N1NZOWcxUHoyc1RTNjRhT2JXSVE0aTZmVUpkQURxQjZpS1phTks1?=
 =?utf-8?B?d2pEM3FUZWZ5bGNTQXRCZVNpdnlhOFlMbWRjdC9JYjMxTjV2UDg4dEtxSUlt?=
 =?utf-8?B?TUtaQVo2TkhUTHVnMFZxNTNzQlFOd0k5aTRaa3BiTWQ4ajVNTVZIZUkyak5O?=
 =?utf-8?B?VkoyMWFZN2NGOTh0c3BmaHlBbkxldXdKK0RUTUpzbUJQaG4yR1FxNEYxWWFM?=
 =?utf-8?B?czdVMWhSWFZDYXlLOS9XRGJqVFAwMC83cDIxMDBDYmw5bDRBWFRHQjluenNz?=
 =?utf-8?B?bmFvZVc2RW5pQ0NMNG9xK0I2a0lBNWRhVWRuR3pCcW1nVEoxWE1ZSEFkYkJH?=
 =?utf-8?B?bGhxSVZ0N05sbjgxRURFemk2MlpBN3kzZmk5enF6UkpodTR0V3ZyQzRJQXg2?=
 =?utf-8?B?dXRuYmY3bkNUTGQvT2xlc3RRd1ZpNm1FOTI2ME5OT2ZYVkhLM0VwZDNheTVG?=
 =?utf-8?B?NFZzdmFNZVFIbTJoSnpGemJCYUx5VFQrTGs5cjhOblJ1SmI0N21HbVUzQjVI?=
 =?utf-8?B?ZU1lbWJpdHZjY0FuOEpGZlRpUWVISGZRWmptd3AwejlsYzNuQUVTQ3lFWFhO?=
 =?utf-8?B?MytLa2N5dm5DZzZValdwVUIxV0pzSTc0MzJVdWp6UzVzMG1QQUYxMHNaMzZo?=
 =?utf-8?B?SHBHYXUrQjJrZnJKWVRhVEk0UDZpZFQ5dk11UHoxU3kyakE4ekxCM3VaR2JD?=
 =?utf-8?B?bUNnVDFvT2kyWnlQcnVveUVjSFdQY1oxNXJxY20wM1piYnk4SmRtSS9pZk1T?=
 =?utf-8?B?UE1WZlhhUnBHVGFWNHBkblcreW5rRS9qM1IvZUVHSG1adVNFR0llK2JUVlM2?=
 =?utf-8?B?NkdzbFBmekd4NW5NTzR3WWxkVWRQTlJYT3c0b3ZIVDI2S2dyVlQrQ1BlcTZ0?=
 =?utf-8?B?QkgyOUdXcFdHbVdMN1hPTjErcFljeURqdFRRenpvb1p1WnphSy92aU9mZ2Qw?=
 =?utf-8?B?Y0toU2ZaSDRRbTFPRkJ0Z2w1aTA2dEk1QzdqN292V20yVWExS2dDRkRBTSs2?=
 =?utf-8?B?WmtjdGV5WmgyRnJ2ZkxncDNMOGVkL0RsQmNubTVNc3gvNVp3STlWUUVwTEtm?=
 =?utf-8?B?a2xpRGdlOERPRkZCME1pNFhhcXpZeStHelRtbkx4ZHBtcXlKR1czcFE5TkVR?=
 =?utf-8?B?TUh0WDVwc0xCVVFvY1Viamx4YUFLdHhRZ0Qwa29INmlFaGJBRFl3RnpKY25Z?=
 =?utf-8?B?eDRFb2VRamdSRnZPZ0ZSRTB3MUFoODE2bmV4NUsxZ3V3ejBVcWpEU0N1MEhh?=
 =?utf-8?B?blhPb2pNd1RZUzlkRGNNK1VhRElHeHk3WWZMUGRwVkJ3TlFmTUlieENCMmV1?=
 =?utf-8?B?aWNyK3Z0L3RKVHBLQmFyT01QcStPbjhnVkVyaDZHS0thOFdOTjByNk9hL1Va?=
 =?utf-8?B?dlVrVlNpc09pYkRTZUpYbjd5UzByVkJTcUQ1QSsxYmRWWVE0ZStIZ3ZrdVN6?=
 =?utf-8?B?RXFPcEtHeTZHYnlNTFIzUjFXWndNSGtlN3NmdUx5Y3ozQmdpS3U1MnpPUnR0?=
 =?utf-8?B?RjFsSFRJNUFtZUx1c3BQUzhHdkhuM1JiUEN1RWNTNEc2TjRWL1NkU1hLcENs?=
 =?utf-8?B?bHNwei9MRXhBb1NMT2k5YXBxTURieDREanRIQnM1Q09Ea0JqSGtZK1N6endV?=
 =?utf-8?Q?e0DGiTYeQHOTNcWcWRllzzdWoD4XIZluovBSDXA4Rqm0?=
Content-Type: multipart/mixed;
        boundary="_002_FRYP281MB31463EC1486883DDA477393DF2C0AFRYP281MB3146DEUP_"
MIME-Version: 1.0
X-OriginatorOrg: nio.io
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc85167-bf19-424c-ded3-08dbc131c94f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2023 21:19:37.7751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ea1b2f97-423f-4ab3-bf6d-45a36c09ce34
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JE7zGC8rxcu3b84uVJm2D66VplwFlNDajHYtBqVHmr7D8f8Cq064doxlCbP+v7RX+XSZWhAADHV+kmnpbKLnbz73Zf/0OYNZLf/1rrrYiSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEVP281MB3473
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--_002_FRYP281MB31463EC1486883DDA477393DF2C0AFRYP281MB3146DEUP_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCkkgdGhpbmsgb25lIG9mIHRoZSB0ZXN0IGNvbmRpdGlvbnMgZm9yIHRoZSBLVk0g
UE1VIHVuaXQgdGVzdCAiYmFzaWNfZXZlbnRfY291bnQiIGlzIG5vdCBzdHJvbmcgZW5vdWdoLiBJ
dCBvbmx5IGNoZWNrcyB3aGV0aGVyIGFuIG92ZXJmbG93IG9jY3VycmVkIGZvciBjb3VudGVyICMw
LCBidXQgaXQgc2hvdWxkIGFsc28gY2hlY2sgdGhhdCBub25lIGhhcHBlbmVkIGZvciB0aGUgb3Ro
ZXIgY291bnRlcihzKToNCg0KcmVwb3J0KHJlYWRfc3lzcmVnKHBtb3ZzY2xyX2VsMCkgJiAweDEs
DQrigILigILigILigILigILigIIiY2hlY2sgb3ZlcmZsb3cgaGFwcGVuZWQgb24gIzAgb25seSIp
Ow0KDQpUaGlzIHNob3VsZCBiZSAiPT0iIGluc3RlYWQgb2YgIiYiLg0KDQpOb3RlIHRoYXQgdGhp
cyB0ZXN0IHVzZXMgb25lIG1vcmUgY291bnRlciAoIzEpLCB3aGljaCBtdXN0IG5vdCBvdmVyZmxv
dy4gVGhpcyBzaG91bGQgYWxzbyBiZSBjaGVja2VkLCBldmVuIHRob3VnaCB0aGlzIHdvdWxkIGJl
IHZpc2libGUgdGhyb3VnaCB0aGUgInJlcG9ydF9pbmZvKCkiIGEgZmV3IGxpbmVzIGFib3ZlLiBC
dXQgdGhlIGxhdHRlciBkb2VzIG5vdCBtYXJrIHRoZSB0ZXN0IGZhaWxpbmcgLSBpdCBpcyBwdXJl
bHkgaW5mb3JtYXRpb25hbCwgc28gYW55IHRlc3QgYXV0b21hdGlvbiB3aWxsIG5vdCBub3RpY2Uu
DQoNCg0KSSBhcG9sb2dpemUgaW4gYWR2YW5jZSBpZiBteSBlbWFpbCBwcm9ncmFtIGF0IHdvcmsg
bWVzc2VzIHVwIGFueSBmb3JtYXR0aW5nLiBQbGVhc2UgbGV0IG1lIGtub3cgYW5kIEkgd2lsbCB0
cnkgdG8gcmVjb25maWd1cmUgYW5kIHJlc2VuZCBpZiBuZWNlc3NhcnkuIFRoYW5rIHlvdS4NCg0K
QmVzdCBSZWdhcmRzLA0KDQpNYXR0aGlhcw0KW0Jhbm5lcl08aHR0cDovL3d3dy5uaW8uaW8+DQpU
aGlzIGVtYWlsIGFuZCBhbnkgZmlsZXMgdHJhbnNtaXR0ZWQgd2l0aCBpdCBhcmUgY29uZmlkZW50
aWFsIGFuZCBpbnRlbmRlZCBzb2xlbHkgZm9yIHRoZSB1c2Ugb2YgdGhlIGluZGl2aWR1YWwgb3Ig
ZW50aXR5IHRvIHdob20gdGhleSBhcmUgYWRkcmVzc2VkLiBZb3UgbWF5IE5PVCB1c2UsIGRpc2Ns
b3NlLCBjb3B5IG9yIGRpc3NlbWluYXRlIHRoaXMgaW5mb3JtYXRpb24uIElmIHlvdSBoYXZlIHJl
Y2VpdmVkIHRoaXMgZW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBhbmQg
ZGVzdHJveSBhbGwgY29waWVzIG9mIHRoZSBvcmlnaW5hbCBtZXNzYWdlIGFuZCBhbGwgYXR0YWNo
bWVudHMuIFBsZWFzZSBub3RlIHRoYXQgYW55IHZpZXdzIG9yIG9waW5pb25zIHByZXNlbnRlZCBp
biB0aGlzIGVtYWlsIGFyZSBzb2xlbHkgdGhvc2Ugb2YgdGhlIGF1dGhvciBhbmQgZG8gbm90IG5l
Y2Vzc2FyaWx5IHJlcHJlc2VudCB0aG9zZSBvZiB0aGUgY29tcGFueS4gRmluYWxseSwgdGhlIHJl
Y2lwaWVudCBzaG91bGQgY2hlY2sgdGhpcyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGZvciB0
aGUgcHJlc2VuY2Ugb2YgdmlydXNlcy4gVGhlIGNvbXBhbnkgYWNjZXB0cyBubyBsaWFiaWxpdHkg
Zm9yIGFueSBkYW1hZ2UgY2F1c2VkIGJ5IGFueSB2aXJ1cyB0cmFuc21pdHRlZCBieSB0aGlzIGVt
YWlsLg0K

--_002_FRYP281MB31463EC1486883DDA477393DF2C0AFRYP281MB3146DEUP_
Content-Type: text/x-patch;
	name="0001-kvm-unit-test-pmu-Fix-test-condition.patch"
Content-Description: 0001-kvm-unit-test-pmu-Fix-test-condition.patch
Content-Disposition: attachment;
	filename="0001-kvm-unit-test-pmu-Fix-test-condition.patch"; size=1171;
	creation-date="Fri, 29 Sep 2023 21:15:01 GMT";
	modification-date="Fri, 29 Sep 2023 21:15:01 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwYTNjYTRjODg4MThlNzUyY2E2M2RlZTNkNTA5NDVhMjZhMTZkMjliIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0aGlhcyBSb3NlbmZlbGRlciA8bWF0dGhpYXMucm9zZW5m
ZWxkZXJAbmlvLmlvPgpEYXRlOiBUdWUsIDI2IFNlcCAyMDIzIDE5OjA3OjE4ICswMjAwClN1Ympl
Y3Q6IFtrdm0tdW5pdC10ZXN0cyBQQVRDSF0gYXJtOiBQTVU6IEZpeCB0ZXN0IGNvbmRpdGlvbgoK
VGhlIHRlc3QgZGVzY3JpcHRpb24gc2F5czogImNoZWNrIG92ZXJmbG93IGhhcHBlbmVkIG9uICMw
IG9ubHkiLApidXQgdGhlIHRlc3QgY29uZGl0aW9uIGFjdHVhbGx5IHRlc3RzOiAiY2hlY2sgb3Zl
cmZsb3cgaGFwcGVuZWQKQVQgTEVBU1Qgb2YgIzAsIG1heWJlIG9mIHNvbWUgb3RoZXIgY291bnRl
cnMgYXMgd2VsbC4iClRoaXMgYmFzaWNhbGx5IGRpc3JlZ2FyZHMgYW55IG92ZXJmbG93IG9mIG90
aGVyIGNvdW50ZXJzLCBidXQgaXQKc2hvdWxkIGVuc3VyZSB0aGF0IHRoZXJlIGFyZSBub25lLgoK
V2l0aCB0aGUgdXBkYXRlZCB0ZXN0IGNvbmRpdGlvbiB0aGUgdGVzdCB3aWxsIGZhaWwgaWYgdGhl
cmUgd2FzIGFuCm92ZXJmbG93IG9mIGNvdW50ZXIgIzEsIHRvby4KClNpZ25lZC1vZmYtYnk6IE1h
dHRoaWFzIFJvc2VuZmVsZGVyIDxtYXR0aGlhcy5yb3NlbmZlbGRlckBuaW8uaW8+Ci0tLQogYXJt
L3BtdS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvYXJtL3BtdS5jIGIvYXJtL3BtdS5jCmluZGV4IGIxNjRmMjEuLjE5
NTZiNDIgMTAwNjQ0Ci0tLSBhL2FybS9wbXUuYworKysgYi9hcm0vcG11LmMKQEAgLTUzMiw3ICs1
MzIsNyBAQCBzdGF0aWMgdm9pZCB0ZXN0X2Jhc2ljX2V2ZW50X2NvdW50KGJvb2wgb3ZlcmZsb3df
YXRfNjRiaXRzKQogCQkgICAgcmVhZF9yZWduX2VsMChwbWV2Y250ciwgMSkpOwogCiAJcmVwb3J0
X2luZm8oIm92ZXJmbG93IHJlZyA9IDB4JWx4IiwgcmVhZF9zeXNyZWcocG1vdnNjbHJfZWwwKSk7
Ci0JcmVwb3J0KHJlYWRfc3lzcmVnKHBtb3ZzY2xyX2VsMCkgJiAweDEsCisJcmVwb3J0KHJlYWRf
c3lzcmVnKHBtb3ZzY2xyX2VsMCkgPT0gMHgxLAogCQkiY2hlY2sgb3ZlcmZsb3cgaGFwcGVuZWQg
b24gIzAgb25seSIpOwogfQogCi0tIAoyLjM0LjEKCg==

--_002_FRYP281MB31463EC1486883DDA477393DF2C0AFRYP281MB3146DEUP_--
