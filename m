Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6662A37AC63
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhEKQwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:52:06 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:4488 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKQwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:52:05 -0400
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BGWa3D019537;
        Tue, 11 May 2021 09:49:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=d0xAIKPmP7MI6eaKqBU8xnx/urc1+BfX1WWU5y+a/Qc=;
 b=unVESjtqu1fM/cfYqZmdKjs4Uush9MlG81/sLMUCQA6CEO6movb+zsxtJ+6CeIGJ1MlQ
 EogcpDE77VSitX8A9uV1IsQ+f3gSXz7gIVp+nmDsYaB5l4tkjEceOEShRzD+/FXSWB6w
 FmOf+q25tfuCzMeaa73wdmKXqgUxydD5ZoD84CeSH1TGLH5CqkvRf9mQCleveIS746NZ
 0lsRDkx1uqKAEGrUqNq+Yjwld/MVdSORS234v82aFkF0YNEPsdfmtHDt0X1rH7S4XDFa
 c9vIvyVdCxucs87warBYgohqc9x08waE2rB3AFxG/tf6LUP+7Xr54lOtSfsbVlq7EYuf Pg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38ewh3bwce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 09:49:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hg6ExcMt7tfs/QdvgusxwTCDaHHZ0fUIbVh2UZpm3IHb64+ov6YdZNtMpNqpch1eUyWhans7Qndb/6mf44CQOpJXsbn2w/01HO2oYsWDr3jZHbu5twd6GgK50SoziGujvHkKJlGG1il+DsZVhf6dCoKFe+qAvmxphPDiGVpe+a0eXQWjLYxB4qt152r+8nQOhYCR0y50DI9eIpgcE2zgUUQDJlYN4DPJYJyVMtcORpxKVXaGyWRxrsRRvIXL9SAZBXqSmi4QEv4H77sM9uZfxGrtDewrOxRbz0tdPBYRGaw8dxEWdt5fMboC4J+Mzj1Zs0dj6UAhVf7yV4uSoisAdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0xAIKPmP7MI6eaKqBU8xnx/urc1+BfX1WWU5y+a/Qc=;
 b=L2YL88E+eiK2mCmUU/r9WhHXh/QbrL1LIDMXsl03G/2rOjnjZ2n/sY5sbAE0uDOAqSK3C2l/5zST3034syLtVG3OmjxOCU7buonAtIe8tuqJy8+7tNaNl2zHyNT/ieI+VFMPbSTcAyLyR1Pxs2f+xJqKFGmpBhZe52xfCKYVUjQ6A6aMIGh6H3vU/J9GL9qbBgadR40PRwJxXoqN0JBwt551v18ZREUU72CsEoaxD9ttIRJeUv83jnx0rhhOyuGK1P0QaIiRaFwHvZ56bzhSIHcu9+GkeJXpKAo7a1FcdRI2dnSRzLdW7DzWhYnLLBrMqW2Zs61lsu+cmDXjSNTLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB4274.namprd02.prod.outlook.com (2603:10b6:208:44::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Tue, 11 May
 2021 16:49:20 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 16:49:20 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Juergen Gross <jgross@suse.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Topic: [PATCH v2] KVM: x86: use wrpkru directly in
 kvm_load_{guest|host}_xsave_state
Thread-Index: AQHXRn60EiNtzlJMoki1ZErBKAvrd6refSyAgAABAoA=
Date:   Tue, 11 May 2021 16:49:20 +0000
Message-ID: <3BABBCC3-33EB-4BC4-9384-14746AFE2D1C@nutanix.com>
References: <20210511155922.36693-1-jon@nutanix.com>
 <ab09f739-89fa-901d-9ee3-27a6c674d9a0@intel.com>
In-Reply-To: <ab09f739-89fa-901d-9ee3-27a6c674d9a0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:68d9:a99b:e44a:d275]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64920ee3-185e-410b-2a4f-08d9149cb90e
x-ms-traffictypediagnostic: BL0PR02MB4274:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB427427F0AD8378D0952227BFAF539@BL0PR02MB4274.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bN1IzNQVxiy5CV+8b7b5bZAQAWJfeaPNLyPQpthS8OFZxzWFB+kW6PUir2UAQlpDKNDPSE/9XBnoO9vcaOVUAl8aKDksu71RwhN8arqkOIqjsqxTim3f9cI8zEqY8uXJxMn65AMF9imEzs+xQalUQasmGVqEjJzyvCVAU1lq6rqFG9WD9DHDqQZNhbNLahOVu2QZwN8Va537kEw30wg5DjL3bNHAlliiQugQ5hWCAYodLHsGII+gPT/GvbCqA46IILZDydmfpwB/SpSP9dZ509rrswkH/jWXMB9/D+DClib5P0JeGf82wZzUTEcNDAgDmzFPGuJts50peMhDhPEStrEDvd8P/b5RR1D515CTbNwYE+yoSKmt54vNZlU3CCOeMSk8v9/SKEkytSWEHddM3/rnRrAxwRN9KOwZVzfaJCmnzviOU+LwsKXikHLljWoY2LSafbhtuvnPECD3Ltvs+X1X3j8/uGYHPm/rIf0OFLitZbKdQXwCH7Ga305fLHE/fJITNsBgdX8GWIf+dmB8+D+AywXy+NMZbshQ8sIsRjOGYSWWLXL+BCz6hi0z3zOPu9LA8BIlmlA7o6Jjt4uIcTDylyIILZEItLBFTIggmlxCDy+C4LnY60OSxWwpC67Ye31cb9ePvUu7Pfkku4Z3WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(66446008)(66556008)(498600001)(53546011)(6506007)(2616005)(76116006)(2906002)(6486002)(71200400001)(54906003)(86362001)(64756008)(66946007)(8936002)(33656002)(66476007)(91956017)(122000001)(4744005)(36756003)(38100700002)(7406005)(7416002)(83380400001)(8676002)(6916009)(5660300002)(186003)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm9heG5sdG5QRFk1MnFJTTBXOXlXMm13cjJ4UzYwNEp6WDd2ZG1pdFhFZ2Qz?=
 =?utf-8?B?Y1dWbXNDbC9HdHZSc2EvNElMUVNsTFZJcFArcjZsMzR6U1p3dkVIQ1lPMkox?=
 =?utf-8?B?L2VKV3hoMFBkR0R3dG9udzhlWDEzelF1QkVVTU9DdnFNVXlUNGRtendYb1VF?=
 =?utf-8?B?Q1B6ODhsQVdPdGk0RVdJcFpzRDNsSXpsN2JwVVBya05rSEE5QjlYc3dhb3NR?=
 =?utf-8?B?WElTTnc2L05Vak01VlZ0WkR1L09NNFRMcCtLMko0NWdSeEFsdFZPTUp3VFdi?=
 =?utf-8?B?LzNQSWVXY29BM1lWVXd6N2dMZ1l3TnBMTVpURitSN05hK1FOV0psbWhtNUI3?=
 =?utf-8?B?RWRzK1Y5azlSNzk0MWFwbldRbU05NmRjT1pBQTdtTUFMcHJQZXZBNk5uS1RG?=
 =?utf-8?B?VEhaUk8xakhHYVdSQWhKVTlYcmxOaXNFYjFtYW5OS3cwMWVLZ2VCWUpIWG0r?=
 =?utf-8?B?NUt1WG1qVjF6aWhHTkNycXdvbGN6NnpIQUcxWUZDaUU4ZHRzMHZJcU9DbEdr?=
 =?utf-8?B?TE5jY1lmcENMelpJa0VkU0ZXWmxuanVTMjZlR2wwMXNkUUJwMm54TFYxSnRo?=
 =?utf-8?B?ZmdOWEs1ZzlXWXk5VWYzOS9PVHNHRkZsRVo5ci9ITmFrc3FvZURFWWVOeWNh?=
 =?utf-8?B?QzQ5dllUdUpFajlQR01sd1g1KzBtSndwbUxJdjE4akswci84QXEybnNRUlVp?=
 =?utf-8?B?bE5FM2dkTFBLdjRNclJYenhodmhaUzVIWWVpVjNRZFZlOHpibVdrdjNIZG1L?=
 =?utf-8?B?UWk4bms5aXZ2REZOZWd5bjlkT0ZZazNJSlVsS2FTQUpXOFJ6QThuKzlGc2Zt?=
 =?utf-8?B?SEJWTHJxTy9YNjBuL0ZqcTJ0d205TDhlYUVrbE9ZT0ZNUXlGTW1MRElzWm9F?=
 =?utf-8?B?MUxYaUw4cW01SVJ1Qmx6Mm9LbjVwQ1A4Q1A3WDI0RVpFVmZwOFZLZEVpV1pH?=
 =?utf-8?B?L3hiQy9pcnpPRWdYMm5mL2wyVWRkNkJVaTl6MGhZYnNyVjFMNE9EaDlLWG1S?=
 =?utf-8?B?T2JUVEkyOGlCMHMyazk3VkEzQmxVSmYrQkwvUlFzejR4c2p6TDM1YjlqbTZv?=
 =?utf-8?B?RnV2V2NjSVIxZldKbFJHYXd4NE05MjFPZ1FHbnJROG54N04yR0FNOERDOTlJ?=
 =?utf-8?B?NE0wdnhsaW9nQkYwdVU4cmUxVVp2VUhyeC9jTVljZkZPWmRSZG5VVzNuQ3Zj?=
 =?utf-8?B?QjRzODlCNlNVMjEzWUZ4ZnlEby94aEdobGZWODhDdVo1QlpCckl3SDBvc3E1?=
 =?utf-8?B?TlUyR1dKaXY3bkxxa1ZhaXpRQ2MxNFBrM0RJQ2pqQnh2cndrYWN4c1U4UnUv?=
 =?utf-8?B?YmVGNXNMVG0vVjlURS9vVmttaUVQVWpVbld4dW9ONHJ0ckJLM1AvcmRmVlNG?=
 =?utf-8?B?cU5rcmpkLy9FRlJlbFV1UzV4eUZBYXhCbml6RXFsNG4weCthYi80WFM1QTZE?=
 =?utf-8?B?ZVNVUVVLZ25hUENMSHJVV0kyblVNd1QraVdUMFNaRWtjRE1US3VJTjMvOXhB?=
 =?utf-8?B?Q0hkWWl1bCsvQ29QNVgweWJPT1RLUlkzSEdQU3JaNUlxTUMwRDlQSlJRZS9a?=
 =?utf-8?B?emRveGg3N0pzdngrSW11ZXN2QXlSVHRtV0NWS1RKQk9wTi9uV3lEVWo5M3Bn?=
 =?utf-8?B?dEpMMTRZM09HbkpzUndjRmQrQTRSNFZZL2Q3cE1RYlJCOE1PQUd0dkc0ZGlq?=
 =?utf-8?B?MDJ0SjJneXVTa0pGVUFmT2R1V1oxYWhCOU4xTkU0MzYwbW96NzFEWFl5cjNi?=
 =?utf-8?B?OHZRYmoxVU1nalZsR1ExL05JUDhDOThkTFp6c0VJSlNKYitUYW9ObTN3bXk5?=
 =?utf-8?B?d2NNYzlsNVEyTjhjdXlvMlFzRGFFdmNkYkI0WUZSRkVobTY4YnJyRmVEQURr?=
 =?utf-8?Q?28iXfippKXV4P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36B199B34757B144863EBA470B7DC008@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64920ee3-185e-410b-2a4f-08d9149cb90e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 16:49:20.0953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JoRQOH9PejdrvRUZM8fxsP/fFmDIUTtMLj5eKiZgVNgedV52O9FGx8xDteaRpyVo0zo6WiXgZj3iDarUjphf9fYrYN3DHjGPayDynQ9TsbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4274
X-Proofpoint-ORIG-GUID: _3zsvnZGOPLi0RHu94uvXK1kxJYNcaSC
X-Proofpoint-GUID: _3zsvnZGOPLi0RHu94uvXK1kxJYNcaSC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_04:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDExLCAyMDIxLCBhdCAxMjo0NSBQTSwgRGF2ZSBIYW5zZW4gPGRhdmUuaGFu
c2VuQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiA1LzExLzIxIDg6NTkgQU0sIEpvbiBLb2hs
ZXIgd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+PiBpbmRleCBiMTA5OWYyZDk4MDAu
LjIwZjFmYjhiZTdlZiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BndGFi
bGUuaA0KPj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGd0YWJsZS5oDQo+PiBAQCAtMTUx
LDcgKzE1MSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB3cml0ZV9wa3J1KHUzMiBwa3J1KQ0KPj4g
CWZwcmVnc19sb2NrKCk7DQo+PiAJaWYgKHBrKQ0KPj4gCQlway0+cGtydSA9IHBrcnU7DQo+PiAt
CV9fd3JpdGVfcGtydShwa3J1KTsNCj4+ICsJd3Jwa3J1KHBrcnUpOw0KPj4gCWZwcmVnc191bmxv
Y2soKTsNCj4+IH0NCj4gDQo+IFRoaXMgcmVtb3ZlcyB0aGU6DQo+IA0KPiAJaWYgKHBrcnUgPT0g
cmRwa3J1KCkpDQo+IAkJcmV0dXJuOw0KPiANCj4gb3B0aW1pemF0aW9uIGZyb20gYSBjb3VwbGUg
b2Ygd3JpdGVfcGtydSgpIHVzZXJzOg0KPiBhcmNoX3NldF91c2VyX3BrZXlfYWNjZXNzKCkgYW5k
IGNvcHlfaW5pdF9wa3J1X3RvX2ZwcmVncygpLg0KPiANCj4gV2FzIHRoYXQgaW50ZW50aW9uYWw/
ICBUaG9zZSBhcmVuJ3QgdGhlIGhvdHRlc3QgcGF0aHMgaW4gdGhlIGtlcm5lbCwgYnV0DQo+IGNv
cHlfaW5pdF9wa3J1X3RvX2ZwcmVncygpIGlzIHVzZWQgaW4gc2lnbmFsIGhhbmRsaW5nIGFuZCBl
eGV2ZSgpLg0KDQpUaGF0IHdhc27igJl0IGludGVudGlvbmFsLCBJ4oCZbGwgdGFrZSBhIGxvb2sg
YW5kIHNlbmQgb3V0IGEgdjMgcHJvbnRvLg0KDQpUaGFua3MsIERhdmUNCg0K
