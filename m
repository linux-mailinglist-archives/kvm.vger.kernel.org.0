Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAC1373EDD
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhEEPsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:48:16 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:24314 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232410AbhEEPsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:48:15 -0400
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 145FbRZT029694;
        Wed, 5 May 2021 08:46:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=iLBmN4WOFoHoFG2cwWTPE5VKcMJ5VAho0sEWW4zsKAI=;
 b=PeoVHkgfBB952eBN9EYWqF95lHPWU3nAchgrzMJ2vAPNGevZVIRhf6sJgsb+euqX/w3o
 /DXmSnIHEUYRIpfCB2WrDNepNLJ4h4pl022xIauS54XPZb3zJuA5rW1wwdBjqtrR3l0X
 Dxnl8uoLuWJKBgjKgy5ixor+lkwQ638fdKcR2CT7PNhxRZBsufqiPq8WyeEy3vi8v3ZY
 rXpVW3a5fAXlpgTgF9dZmN9HTd1ehKYw01SsYm4L5jCfhQOrEJ3pBQ23g/Se9fQAlZuv
 j6ugu3miqiLKLy1KsJTPdAlzigM8reSveLoS8Qz4hs9DZGPmjQb9k2Cp983cPChAyixl IQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0b-002c1b01.pphosted.com with ESMTP id 38begj1t7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGj1cbb8EVEB1VXzE5fQGa4F5obxdt8VnFD+DDddxSD/sueWgklxoXazDj4WAH/Ris3Jf4EpCzAUrma6uAgxhR9pULmChVbqfPQcSA/utjrKf+/SHQgyMJ6mIV3sVXrAbTV4rWIFTZ2jq2UjLf3q2hY9UXMAJeXKaVVIZ25LkxTVKf3WTrkSulOMB+Oifsequ1CFRp4+U4NzBvf7x9+b0AGCHqNAglB0x0gPxbST6fan58SjUjpcvSxxqQ2qPFqjiOOG1BoCCggoJr0BlR74nVgl427Wlh0xIfJ8q/uIh5kq+np8oqP8OsF1mw+3yhlHDblPVAcbZhZvQzD2khmUew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLBmN4WOFoHoFG2cwWTPE5VKcMJ5VAho0sEWW4zsKAI=;
 b=QPPIdWCD2J+eE5HJV6Z1tjpGRaSmUpCO2hAYSjnUdXpSVnX8YaQzuWNeezzBVCu6okeCDdvAlvnrWTfyV1eWv9nhhjm5PY0J2xVZNj5c1o9m9V0P+A7O1gwV7z4YwltNJPmZrxJDOrRd5gvHV8knaFpS0vN1+xX3xIv/sfa0fJOc5OCx0oSy26mAgVi92od2obhcA7CE5WUe/snbMZwcd6FR94+FsWDAfpdfmiHDLYNizPuZjxRj/REPqbsgYc5d7cyjU0WKNAm8FCUkcT0yeG1PxMWqjZE4fxxQTYxmuKJk4wzrv5TzxadHKC0pRogUr2AW11AJJMBiOAmt/Bwyew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB5588.namprd02.prod.outlook.com (2603:10b6:208:8a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 15:46:13 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4087.043; Wed, 5 May 2021
 15:46:13 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>,
        Bijan Mottahedeh <bijan.mottahedeh@nutanix.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Thread-Topic: [PATCH] kvm: x86: move srcu lock out of kvm_vcpu_check_block
Thread-Index: AQHXPFVoiqAoQuVOv02IuTy+Q4d5+6rNisKAgAER84CABnYtgA==
Date:   Wed, 5 May 2021 15:46:13 +0000
Message-ID: <70B34A15-C4A1-4227-B037-7B26B40EDBFE@nutanix.com>
References: <20210428173820.13051-1-jon@nutanix.com>
 <YIxsV6VgSDEdngKA@google.com>
 <9040b3d8-f83f-beb5-a703-42202d78fabb@redhat.com>
In-Reply-To: <9040b3d8-f83f-beb5-a703-42202d78fabb@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:3d98:afdd:7bc7:8d1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 618b678d-34a8-48eb-4060-08d90fdce9ab
x-ms-traffictypediagnostic: BL0PR02MB5588:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB5588FC85E91ECBE0D303052EAF599@BL0PR02MB5588.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AoLx3bHevr56wTRBjeVXd45rmAdIRnA7t2MeGY+lHYyRtxZMEA4uILJOZ7JKbQf88YO+FheilVqxtEuF/0d4LcCZLU7O3nabFrMmeV0f5c2ZH7V379hdFUYTMBY1Pn119aUpB+pVPzMYL+0nxfnVst6UH05AD4bFNgF31KU+2bk1GyQIA4OYbYGUxN/WpOf183FqefkHL6UqHnw4r1k2OPJuoWglLy/gDmpLNuO3HHHFl2KlCa1bqAD0rKebgXV+r9om1+ovqyVV4mNUqq2srSVDll7bWaLCaRybUp75r9TB25JzqwKrlc7GwBlh2F8WWYGyQ6wGKLdL5diCGcUELtvWmIunMJ+k/veviEXlm/g98TszTUzroEaGNX2eiyn2Hy8vq1Vz5Z/8PTmkcuuuMB+W66y8ph9VwapOJHDPeUo3cMj/IcgennaAysNRwG+RWpalq0EXccBQWZu7xyS0jgIp7VCxyikycjyOZPBzOCW08QlaGBf6i2GXQ5uHqzCthQyYsSg9PZhJUVWlXUIsKtVLEgzBjNwRH/09DUlGtjmDXusGVYUEb2m5p3NmMui3N7hnYjUMyLmiB8gO02dlyowRXkxH8nx/rGNjC2XUuZBKcIc9etlzIzacfz9vmC16f2UxDmc6dAA6Ib5kLGk+kTJoIi+5I9uXw0avEzg+Bts=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(2906002)(66446008)(64756008)(66556008)(66476007)(8936002)(91956017)(478600001)(66946007)(122000001)(4326008)(316002)(38100700002)(76116006)(8676002)(6506007)(71200400001)(36756003)(54906003)(86362001)(33656002)(7416002)(6486002)(6916009)(83380400001)(53546011)(186003)(5660300002)(6512007)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VkhEMWhia01GaVZoZHhZc1pEZGZTWGtXbkdiMld5U1JubDR2bnIzeU9hN2dh?=
 =?utf-8?B?akVBaExmeDFYMG8za1p0dG5MdmVGTGpPUlZGZGhpblpZMWdUUHRuc1F4OWto?=
 =?utf-8?B?dDFPL0FrZzdFZ2pvZ3BaK0djNzBLMUhVN1dYMzVObWZtUzRweldjd1YzZzJy?=
 =?utf-8?B?N3ltRFJwQlJ3eWhBcnJoQ2sxZFlmQ2dTTEVlUnNXOE9yWVRVN2ZOZFhUK2Ur?=
 =?utf-8?B?RTU5QW5NWVl4V0VnQjR1TC9rVG5vK3hldWJyK2F6RXhJR2NKci9JamwxUUVh?=
 =?utf-8?B?Qk9mWnBnaXVXZHJZbVVUbzRLNER4WnFPZVJ6YmtWdFhTN1FEc3lvdUp2VTVo?=
 =?utf-8?B?eXlLREVLc1hVU3RrR0R1MU5ZeDMwL1pqNjY3ZzN0ZkI0SkxaaWVWeXd6dk94?=
 =?utf-8?B?MXBscUNvVUprRDFNMkhRaXNZRmp6QXBPZkxIK2FFWGc2My9aYWtQWGZPbGxt?=
 =?utf-8?B?QjRQSzMvM1JXTk9vTnYyV0ZESEswQlVldHpGRnY4M0FzTG92NHdHVGlXVWth?=
 =?utf-8?B?czVsQmVxS0FDUmZBMndISkZEOEJtVEZvQ2ZqdEFVKzlDNzVmM2czbitJN21w?=
 =?utf-8?B?Ti9TemlCUXpGRVZzcUh1NkVQY0lzU2hqOFg1bkVkUTMxc2hYNjJTQXdqa3dk?=
 =?utf-8?B?US8wNlFCU1lMZTBEU25uQjFGNDJCVzdRaVJRTUVlVnVSa1Bwc2VEcmRUUXh0?=
 =?utf-8?B?aGRGUVIyOHBNNDJ3SGlrbzhKSTFHcWJXUnJqMHhKL1Q0bjgwZ3psdWdQV2R4?=
 =?utf-8?B?aWRQTTdRU2k3REl5OVkvNDF0akNtcHFSb3FhSE02WFhTTWVIVUlWQy9uQTAr?=
 =?utf-8?B?VTRYSmRwNXZWcnk1SFVNaTVkQkYyL0h6eTgwaEtkRDZBUFdUUEN1Y3hTd3pq?=
 =?utf-8?B?bXVIaGlmVERnNHBvYkF5OEExQXBCTXZvKzV4UGhGazBNQ1dtU05qcmpCaDU2?=
 =?utf-8?B?SlVrY3BtUVlZZjYxN011Yk1nMSt0VXpYMnAwWlozWHdHZzF2U3NBLzNZOFQ4?=
 =?utf-8?B?YTQrZDdXU0RKTDBDU0R0RVlqc01zVm83RzlQbHlDUzRvNW9JRlhsUG9GS29F?=
 =?utf-8?B?Nkk5ZUQ5QjdteGQrbWdGRk9HdGgvTHdsSittaUNweTF4dGVneHR4Q2pYcU1q?=
 =?utf-8?B?bWFIQXcyemRadFczRGo2NzhYSFNEYk0zNjZvT25GaDNnRy9pb0Z4QXNVVFlE?=
 =?utf-8?B?cU9JY2RQV1FGYXV4TUZPb1lJVC9NVWJsYjNkc25GVHljWEEyTk9wN0RacG4r?=
 =?utf-8?B?UWR0QnVQdEx5cm95UzdVQzMzTXFIUGhBSDQ3ZXg3RkF6dXdtSzZQdExiZmZT?=
 =?utf-8?B?RE5NUG5KcEFlRjk0WXhvN2g5SWZnSDhvaEoxQTdRdWkra1dzSkttRzQxQ0hh?=
 =?utf-8?B?Z1ViSGYzNVRiL2tNQVBiKzNZeHIya1hGdi9FQS9aaStNTjRmQ0xlT3FNM1hC?=
 =?utf-8?B?ZVJVMzhMTXJuQy90TzlhZEpQZ3k5S2RHbVU3Y09oK3E2TTdES0VHaVcreHV0?=
 =?utf-8?B?TnNGNU53bDVTRkVaY0J2NG1YM3VnZWN2ei9hMmJMOGo5eDkwQ3BnNXJGS3lr?=
 =?utf-8?B?bDJiM2FraFBNTnZkT2s1dmticGdmNFIvSFZESllTVHliRUVOazB5azl2NG9F?=
 =?utf-8?B?OE91Q2Q5YUhteU5lVzV2S2RDdWxBTjFQcTR5TEpFYlNINDAzNjd0bzJNTGF4?=
 =?utf-8?B?N0JSOStYbW9yRDk4amRTZG5OOXRYQVo0QS9oOHhFbUV2cU9xYk8xNk5JbWJq?=
 =?utf-8?B?TlpTWU4zc3RCaVRMRWVIc2hKbEtab1F4NzRSWFhSOEM5VjZhcUFSbmpDVjE5?=
 =?utf-8?B?am40M1ViQUcvTU9JMGZaeHRnWlFKMWl5MmdaS2pvMDZIZFgvOUtOYUNiZDBH?=
 =?utf-8?B?OEpscWxWd0hoWU5HaGFsQlJaZ2hBQjVqY29QYTJtVzZXYWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16738AD0E8C5E4458A3B3E5C38F73033@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 618b678d-34a8-48eb-4060-08d90fdce9ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2021 15:46:13.4853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iKBQkgm8cEHmysJdYBR89sLo0b65nOHiMkhbTmu6a/VLi51Ct47IYhH5S0QyYHFQwZuJQb+s18/L8UE/rSNgbjc43gvIw94MzKVwx0ylDHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5588
X-Proofpoint-GUID: vb630NPwV7E5fC4D_Vaho7-iqzfGmn7b
X-Proofpoint-ORIG-GUID: vb630NPwV7E5fC4D_Vaho7-iqzfGmn7b
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_09:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDEsIDIwMjEsIGF0IDk6MDUgQU0sIFBhb2xvIEJvbnppbmkgPHBib256aW5p
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gMzAvMDQvMjEgMjI6NDUsIFNlYW4gQ2hyaXN0
b3BoZXJzb24gd3JvdGU6DQo+PiBPbiBXZWQsIEFwciAyOCwgMjAyMSwgSm9uIEtvaGxlciB3cm90
ZToNCj4+PiBUbyBpbXByb3ZlIHBlcmZvcm1hbmNlLCB0aGlzIG1vdmVzIGt2bS0+c3JjdSBsb2Nr
IGxvZ2ljIGZyb20NCj4+PiBrdm1fdmNwdV9jaGVja19ibG9jayB0byBrdm1fdmNwdV9ydW5uaW5n
IGFuZCB3cmFwcyBkaXJlY3RseSBhcm91bmQNCj4+PiBjaGVja19ldmVudHMuIEFsc28gYWRkcyBh
IGhpbnQgZm9yIGNhbGxlcnMgdG8gdGVsbA0KPj4+IGt2bV92Y3B1X3J1bm5pbmcgd2hldGhlciBv
ciBub3QgdG8gYWNxdWlyZSBzcmN1LCB3aGljaCBpcyB1c2VmdWwgaW4NCj4+PiBzaXR1YXRpb25z
IHdoZXJlIHRoZSBsb2NrIG1heSBhbHJlYWR5IGJlIGhlbGQuIFdpdGggdGhpcyBpbiBwbGFjZSwg
d2UNCj4+PiBzZWUgcm91Z2hseSA1JSBpbXByb3ZlbWVudCBpbiBhbiBpbnRlcm5hbCBiZW5jaG1h
cmsgWzNdIGFuZCBubyBtb3JlDQo+Pj4gaW1wYWN0IGZyb20gdGhpcyBsb2NrIG9uIG5vbi1uZXN0
ZWQgd29ya2xvYWRzLg0KPj4gLi4uDQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYu
YyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4+IGluZGV4IGVmYzdhODJhYjE0MC4uMzU0ZjY5MGNj
OTgyIDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPj4+ICsrKyBiL2FyY2gv
eDg2L2t2bS94ODYuYw0KPj4+IEBAIC05MjczLDEwICs5MjczLDI0IEBAIHN0YXRpYyBpbmxpbmUg
aW50IHZjcHVfYmxvY2soc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
Pj4gIAlyZXR1cm4gMTsNCj4+PiAgfQ0KPj4+IA0KPj4+IC1zdGF0aWMgaW5saW5lIGJvb2wga3Zt
X3ZjcHVfcnVubmluZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+Pj4gK3N0YXRpYyBpbmxpbmUg
Ym9vbCBrdm1fdmNwdV9ydW5uaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBhY3F1aXJl
X3NyY3UpDQo+Pj4gIHsNCj4+PiAtCWlmIChpc19ndWVzdF9tb2RlKHZjcHUpKQ0KPj4+IC0JCWt2
bV94ODZfb3BzLm5lc3RlZF9vcHMtPmNoZWNrX2V2ZW50cyh2Y3B1KTsNCj4+PiArCWlmIChpc19n
dWVzdF9tb2RlKHZjcHUpKSB7DQo+Pj4gKwkJaWYgKGFjcXVpcmVfc3JjdSkgew0KPj4+ICsJCQkv
Kg0KPj4+ICsJCQkgKiBXZSBuZWVkIHRvIGxvY2sgYmVjYXVzZSBjaGVja19ldmVudHMgY291bGQg
Y2FsbA0KPj4+ICsJCQkgKiBuZXN0ZWRfdm14X3ZtZXhpdCgpIHdoaWNoIG1pZ2h0IG5lZWQgdG8g
cmVzb2x2ZSBhDQo+Pj4gKwkJCSAqIHZhbGlkIG1lbXNsb3QuIFdlIHdpbGwgaGF2ZSB0aGlzIGxv
Y2sgb25seSB3aGVuDQo+Pj4gKwkJCSAqIGNhbGxlZCBmcm9tIHZjcHVfcnVuIGJ1dCBub3Qgd2hl
biBjYWxsZWQgZnJvbQ0KPj4+ICsJCQkgKiBrdm1fdmNwdV9jaGVja19ibG9jayA+IGt2bV9hcmNo
X3ZjcHVfcnVubmFibGUuDQo+Pj4gKwkJCSAqLw0KPj4+ICsJCQlpbnQgaWR4ID0gc3JjdV9yZWFk
X2xvY2soJnZjcHUtPmt2bS0+c3JjdSk7DQo+Pj4gKwkJCWt2bV94ODZfb3BzLm5lc3RlZF9vcHMt
PmNoZWNrX2V2ZW50cyh2Y3B1KTsNCj4+PiArCQkJc3JjdV9yZWFkX3VubG9jaygmdmNwdS0+a3Zt
LT5zcmN1LCBpZHgpOw0KPj4+ICsJCX0gZWxzZSB7DQo+Pj4gKwkJCWt2bV94ODZfb3BzLm5lc3Rl
ZF9vcHMtPmNoZWNrX2V2ZW50cyh2Y3B1KTsNCj4+PiArCQl9DQo+Pj4gKwl9DQo+PiBPYnZpb3Vz
bHkgbm90IHlvdXIgZmF1bHQsIGJ1dCBJIGFic29sdXRlbHkgZGV0ZXN0IGNhbGxpbmcgY2hlY2tf
ZXZlbnRzKCkgZnJvbQ0KPj4ga3ZtX3ZjcHVfcnVubmluZy4gIEkgd291bGQgbXVjaCBwcmVmZXIg
dG8gbWFrZSBiYWJ5IHN0ZXBzIHRvd2FyZCBjbGVhbmluZyB1cCB0aGUNCj4+IGV4aXN0aW5nIG1l
c3MgaW5zdGVhZCBvZiBwaWxpbmcgbW9yZSB3ZWlyZG5lc3Mgb24gdG9wLg0KPj4gSWRlYWxseSwg
QVBJQ3Ygc3VwcG9ydCB3b3VsZCBiZSBmaXhlZCB0byBub3QgcmVxdWlyZSBhIGRlZXAgcHJvYmUg
aW50byBuZXN0ZWQNCj4+IGV2ZW50cyBqdXN0IHRvIHNlZSBpZiBhIHZDUFUgY2FuIHJ1bi4gIEJ1
dCwgdGhhdCdzIHByb2JhYmx5IG1vcmUgdGhhbiB3ZSB3YW50IHRvDQo+PiBiaXRlIG9mZiBhdCB0
aGlzIHRpbWUuDQo+PiBXaGF0IGlmIHdlIGFkZCBhbm90aGVyIG5lc3RlZF9vcHMgQVBJIHRvIGNo
ZWNrIGlmIHRoZSB2Q1BVIGhhcyBhbiBldmVudCwgYnV0IG5vdA0KPj4gYWN0dWFsbHkgcHJvY2Vz
cyB0aGUgZXZlbnQ/ICBJIHRoaW5rIHRoYXQgd291bGQgYWxsb3cgZWxpbWluYXRpbmcgdGhlIFNS
Q1UgbG9jaywNCj4+IGFuZCB3b3VsZCBnZXQgcmlkIG9mIHRoZSBtb3N0IGVncmVnaW91cyBiZWhh
dmlvciBvZiB0cmlnZ2VyaW5nIGEgbmVzdGVkIFZNLUV4aXQNCj4+IGluIGEgc2VlbWluZ2x5IGlu
bm9jdW91cyBoZWxwZXIuDQo+PiBJZiB0aGlzIHdvcmtzLCB3ZSBjb3VsZCBldmVuIGV4cGxvcmUg
bW92aW5nIHRoZSBjYWxsIHRvIG5lc3RlZF9vcHMtPmhhc19ldmVudHMoKQ0KPj4gb3V0IG9mIGt2
bV92Y3B1X3J1bm5pbmcoKSBhbmQgaW50byBrdm1fdmNwdV9oYXNfZXZlbnRzKCk7IEkgY2FuJ3Qg
dGVsbCBpZiB0aGUNCj4+IHNpZGUgZWZmZWN0cyBpbiB2Y3B1X2Jsb2NrKCkgd291bGQgZ2V0IG1l
c3NlZCB1cCB3aXRoIHRoYXQgY2hhbmdlIDotLw0KPj4gSW5jb21wbGV0ZSBwYXRjaC4uLg0KPiAN
Cj4gSSB0aGluayBpdCBkb2Vzbid0IGV2ZW4gaGF2ZSB0byBiZSAqbmVzdGVkKiBldmVudHMuICBN
b3N0IGV2ZW50cyBhcmUgdGhlIHNhbWUgaW5zaWRlIG9yIG91dHNpZGUgZ3Vlc3QgbW9kZSwgYXMg
dGhleSBhbHJlYWR5IHNwZWNpYWwgY2FzZSBndWVzdCBtb2RlIGluc2lkZSB0aGUga3ZtX3g4Nl9v
cHMgY2FsbGJhY2tzIChlLmcuIGt2bV9hcmNoX2ludGVycnVwdF9hbGxvd2VkIGlzIGFscmVhZHkg
Y2FsbGVkIGJ5IGt2bV92Y3B1X2hhc19ldmVudHMpLg0KPiANCj4gSSB0aGluayB3ZSBvbmx5IG5l
ZWQgdG8gZXh0ZW5kIGt2bV94ODZfb3BzLm5lc3RlZF9vcHMtPmh2X3RpbWVyX3BlbmRpbmcgdG8g
Y292ZXIgTVRGLCBwbHVzIGRvdWJsZSBjaGVjayB0aGF0IElOSVQgYW5kIFNJUEkgYXJlIGhhbmRs
ZWQgY29ycmVjdGx5LCBhbmQgdGhlbiB0aGUgY2FsbCB0byBjaGVja19uZXN0ZWRfZXZlbnRzIGNh
biBnbyBhd2F5Lg0KPiANCj4gUGFvbG8NCg0KWyByZXNlbmRpbmcgYXMgbXkgZWRpdG9yIHN3aXRj
aGVkIHRvIGh0bWwgOiggXQ0KDQpUaGFua3MsIFBhb2xvLCBTZWFuLiBJIGFwcHJlY2lhdGUgdGhl
IHByb21wdCByZXNwb25zZSwgU29ycnkgZm9yIHRoZSBzbG93IHJlcGx5LCBJIHdhcyBvdXQgd2l0
aCBhIGhhbmQgaW5qdXJ5IGZvciBhIGZldyBkYXlzIGFuZCBhbSBjYXVnaHQgdXAgbm93LiANCg0K
SnVzdCB0byBjb25maXJtIC0gSW4gdGhlIHNwaXJpdCBvZiBiYWJ5IHN0ZXBzIGFzIFNlYW4gbWVu
dGlvbmVkLCBJ4oCZbSBoYXBweSB0byB0YWtlIHVwIHRoZSBpZGVhIHRoYXQgU2VhbiBtZW50aW9u
ZWQsIHRoYXQgbWFrZXMgc2Vuc2UgdG8gbWUuIFBlcmhhcHMgd2UgY2FuIGRvIHRoYXQgc21hbGwg
cGF0Y2ggYW5kIGxlYXZlIGEgVE9ETyBkbyBhIHR1bmV1cCBmb3IgaHZfdGltZXJfcGVuZGluZyBh
bmQgdGhlIG90aGVyIGRvdWJsZSBjaGVja3MgUGFvbG8gbWVudGlvbmVkLg0KDQpPciB3b3VsZCB5
b3UgcmF0aGVyIHNraXAgdGhhdCBhcHByb2FjaCBhbmQgZ28gcmlnaHQgdG8gbWFraW5nIGNoZWNr
X25lc3RlZF9ldmVudHMgZ28tYXdheSBmaXJzdD8gR3Vlc3NpbmcgdGhhdCBtaWdodCBiZSBhIGxh
cmdlciBlZmZvcnQgd2l0aCBtb3JlIG51YW5jZXMgdGhvdWdoPw0KDQpIYXBweSB0byBoZWxwLCB0
aGFua3MgYWdhaW4sDQpKb24NCg0KPiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14
L25lc3RlZC5jIGIvYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYw0KPj4gaW5kZXggMDAzMzlkNjI0
YzkyLi4xNWY1MTQ4OTEzMjYgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L25lc3Rl
ZC5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+PiBAQCAtMzc3MSwxNSAr
Mzc3MSwxNyBAQCBzdGF0aWMgYm9vbCBuZXN0ZWRfdm14X3ByZWVtcHRpb25fdGltZXJfcGVuZGlu
ZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgICAgICAgICAgICAgICB0b192bXgodmNwdSkt
Pm5lc3RlZC5wcmVlbXB0aW9uX3RpbWVyX2V4cGlyZWQ7DQo+PiAgfQ0KPj4gLXN0YXRpYyBpbnQg
dm14X2NoZWNrX25lc3RlZF9ldmVudHMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gK3N0YXRp
YyBpbnQgX192bXhfY2hlY2tfbmVzdGVkX2V2ZW50cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGJv
b2wgb25seV9jaGVjaykNCj4+ICB7DQo+PiAgICAgICAgIHN0cnVjdCB2Y3B1X3ZteCAqdm14ID0g
dG9fdm14KHZjcHUpOw0KPj4gICAgICAgICB1bnNpZ25lZCBsb25nIGV4aXRfcXVhbDsNCj4+IC0g
ICAgICAgYm9vbCBibG9ja19uZXN0ZWRfZXZlbnRzID0NCj4+IC0gICAgICAgICAgIHZteC0+bmVz
dGVkLm5lc3RlZF9ydW5fcGVuZGluZyB8fCBrdm1fZXZlbnRfbmVlZHNfcmVpbmplY3Rpb24odmNw
dSk7DQo+PiAgICAgICAgIGJvb2wgbXRmX3BlbmRpbmcgPSB2bXgtPm5lc3RlZC5tdGZfcGVuZGlu
ZzsNCj4+ICAgICAgICAgc3RydWN0IGt2bV9sYXBpYyAqYXBpYyA9IHZjcHUtPmFyY2guYXBpYzsN
Cj4+ICsgICAgICAgYm9vbCBibG9ja19uZXN0ZWRfZXZlbnRzID0gb25seV9jaGVjayB8fA0KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB2bXgtPm5lc3RlZC5uZXN0ZWRfcnVu
X3BlbmRpbmcgfHwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2V2
ZW50X25lZWRzX3JlaW5qZWN0aW9uKHZjcHUpOw0KPj4gKw0KPj4gICAgICAgICAvKg0KPj4gICAg
ICAgICAgKiBDbGVhciB0aGUgTVRGIHN0YXRlLiBJZiBhIGhpZ2hlciBwcmlvcml0eSBWTS1leGl0
IGlzIGRlbGl2ZXJlZCBmaXJzdCwNCj4+ICAgICAgICAgICogdGhpcyBzdGF0ZSBpcyBkaXNjYXJk
ZWQuDQo+PiBAQCAtMzgzNyw3ICszODM5LDcgQEAgc3RhdGljIGludCB2bXhfY2hlY2tfbmVzdGVk
X2V2ZW50cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgICAgICAgIH0NCj4+ICAgICAgICAg
aWYgKHZjcHUtPmFyY2guZXhjZXB0aW9uLnBlbmRpbmcpIHsNCj4+IC0gICAgICAgICAgICAgICBp
ZiAodm14LT5uZXN0ZWQubmVzdGVkX3J1bl9wZW5kaW5nKQ0KPj4gKyAgICAgICAgICAgICAgIGlm
ICh2bXgtPm5lc3RlZC5uZXN0ZWRfcnVuX3BlbmRpbmcgfHwgb25seV9jaGVjaykNCj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+PiAgICAgICAgICAgICAgICAgaWYg
KCFuZXN0ZWRfdm14X2NoZWNrX2V4Y2VwdGlvbih2Y3B1LCAmZXhpdF9xdWFsKSkNCj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgIGdvdG8gbm9fdm1leGl0Ow0KPj4gQEAgLTM4ODYsMTAgKzM4ODgs
MjMgQEAgc3RhdGljIGludCB2bXhfY2hlY2tfbmVzdGVkX2V2ZW50cyhzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpDQo+PiAgICAgICAgIH0NCj4+ICBub192bWV4aXQ6DQo+PiAtICAgICAgIHZteF9jb21w
bGV0ZV9uZXN0ZWRfcG9zdGVkX2ludGVycnVwdCh2Y3B1KTsNCj4+ICsgICAgICAgaWYgKCFjaGVj
a19vbmx5KQ0KPj4gKyAgICAgICAgICAgICAgIHZteF9jb21wbGV0ZV9uZXN0ZWRfcG9zdGVkX2lu
dGVycnVwdCh2Y3B1KTsNCj4+ICsgICAgICAgZWxzZSBpZiAodm14LT5uZXN0ZWQucGlfZGVzYyAm
JiB2bXgtPm5lc3RlZC5waV9wZW5kaW5nKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUJV
U1k7DQo+PiAgICAgICAgIHJldHVybiAwOw0KPj4gIH0NCj4+ICtzdGF0aWMgYm9vbCB2bXhfaGFz
X25lc3RlZF9ldmVudChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiArew0KPj4gKyAgICAgICBy
ZXR1cm4gISFfX3ZteF9jaGVja19uZXN0ZWRfZXZlbnRzKHZjcHUsIHRydWUpOw0KPj4gK30NCj4+
ICsNCj4+ICtzdGF0aWMgaW50IHZteF9jaGVja19uZXN0ZWRfZXZlbnRzKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4+ICt7DQo+PiArICAgICAgIHJldHVybiBfX3ZteF9jaGVja19uZXN0ZWRfZXZl
bnRzKHZjcHUsIGZhbHNlKTsNCj4+ICt9DQo+PiArDQo+PiAgc3RhdGljIHUzMiB2bXhfZ2V0X3By
ZWVtcHRpb25fdGltZXJfdmFsdWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gIHsNCj4+ICAg
ICAgICAga3RpbWVfdCByZW1haW5pbmcgPQ0KPj4gQEAgLTY2MjcsNiArNjY0Miw3IEBAIF9faW5p
dCBpbnQgbmVzdGVkX3ZteF9oYXJkd2FyZV9zZXR1cChpbnQgKCpleGl0X2hhbmRsZXJzW10pKHN0
cnVjdCBrdm1fdmNwdSAqKSkNCj4+ICB9DQo+PiAgc3RydWN0IGt2bV94ODZfbmVzdGVkX29wcyB2
bXhfbmVzdGVkX29wcyA9IHsNCj4+ICsgICAgICAgLmhhc19ldmVudCA9IHZteF9oYXNfbmVzdGVk
X2V2ZW50LA0KPj4gICAgICAgICAuY2hlY2tfZXZlbnRzID0gdm14X2NoZWNrX25lc3RlZF9ldmVu
dHMsDQo+PiAgICAgICAgIC5odl90aW1lcl9wZW5kaW5nID0gbmVzdGVkX3ZteF9wcmVlbXB0aW9u
X3RpbWVyX3BlbmRpbmcsDQo+PiAgICAgICAgIC50cmlwbGVfZmF1bHQgPSBuZXN0ZWRfdm14X3Ry
aXBsZV9mYXVsdCwNCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4
Ni9rdm0veDg2LmMNCj4+IGluZGV4IGE4MjlmMWFiNjBjMy4uNWRmMDEwMTJjYjFmIDEwMDY0NA0K
Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMN
Cj4+IEBAIC05MzEwLDYgKzkzMTAsMTAgQEAgc3RhdGljIGludCB2Y3B1X2VudGVyX2d1ZXN0KHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgIHVwZGF0ZV9j
cjhfaW50ZXJjZXB0KHZjcHUpOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2xhcGlj
X3N5bmNfdG9fdmFwaWModmNwdSk7DQo+PiAgICAgICAgICAgICAgICAgfQ0KPj4gKyAgICAgICB9
IGVsc2UgaWYgKGlzX2d1ZXN0X21vZGUodmNwdSkpIHsNCj4+ICsgICAgICAgICAgICAgICByID0g
a3ZtX2NoZWNrX25lc3RlZF9ldmVudHModmNwdSk7DQo+PiArICAgICAgICAgICAgICAgaWYgKHIg
PCAwKQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmVxX2ltbWVkaWF0ZV9leGl0ID0gdHJ1
ZTsNCj4+ICAgICAgICAgfQ0KPj4gICAgICAgICByID0ga3ZtX21tdV9yZWxvYWQodmNwdSk7DQo+
PiBAQCAtOTUxNiw4ICs5NTIwLDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IHZjcHVfYmxvY2soc3Ry
dWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiAgc3RhdGljIGlubGluZSBi
b29sIGt2bV92Y3B1X3J1bm5pbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gIHsNCj4+IC0g
ICAgICAgaWYgKGlzX2d1ZXN0X21vZGUodmNwdSkpDQo+PiAtICAgICAgICAgICAgICAga3ZtX2No
ZWNrX25lc3RlZF9ldmVudHModmNwdSk7DQo+PiArICAgICAgIGlmIChpc19ndWVzdF9tb2RlKHZj
cHUpICYmDQo+PiArICAgICAgICAgICAoa3ZtX3Rlc3RfcmVxdWVzdChLVk1fUkVRX1RSSVBMRV9G
QVVMVCwgdmNwdSkgfHwNCj4+ICsgICAgICAgICAgICBrdm1feDg2X29wcy5uZXN0ZWRfb3BzLT5o
YXNfZXZlbnQodmNwdSkpKQ0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPj4gICAg
ICAgICByZXR1cm4gKHZjcHUtPmFyY2gubXBfc3RhdGUgPT0gS1ZNX01QX1NUQVRFX1JVTk5BQkxF
ICYmDQo+PiAgICAgICAgICAgICAgICAgIXZjcHUtPmFyY2guYXBmLmhhbHRlZCk7DQo+IA0KDQo=
