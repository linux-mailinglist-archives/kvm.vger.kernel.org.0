Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37E72274E
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjFENYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjFENYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:24:03 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED86B7;
        Mon,  5 Jun 2023 06:24:02 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3558hTIW007552;
        Mon, 5 Jun 2023 06:23:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=Pz+Ct+aVpgCFCsCgBx7kdi9oHnBxmlIWjP8+waz+Zak=;
 b=EHWMJokzw1qCnWtsOkvd/V/OruHK57Utw4T4fa+hGhOIlDc113xua733Z52HUHynDLYu
 8zczHPfXn9NaRPBqRQ3X+kYfmDg5vCXXd3AKVm1uA0YZILgTPK9DaMJj+laqgD7Z0Sb8
 A0/E4SuWdj8/RefsbNZDtKj8eVPxeH3+QLYHU376s1ngupjZH6cmVs5J8GyRr5cP9bGi
 Wi6+T9i3ON7t3vFDl+f4o8maqE4IqfmGQJh/bARwszjN6wjqAjLURSn324uqwqLfB9l6
 NY5lask44vwWFIVnoz2wnQuHm5Jz4YYbXXAeCC5Z5S9WN3kqeAfATj3m5G8Pe5FfB8WS qQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3r01urk18x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 06:23:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaKH7aEK0Rqt3EU9kUExHO0IeRjtf8GU/RXGnW7K6rUAuhksPPLF8ElxFJcjTo9ZPGaybOrsr2fQxyD+4+4YaFUTReOx/vQ3iy1UuuNdXku1Ol5tPAkW08axv2YWbIj39W6ZU2VWtQIIj/iFviMkXt6BInridsaucXsUxG2+WnS4kONaoJIYTlBeWyjMJTHl5Br+8hNzt5YkFXAKTZkUurGwMYvrpGNGAithT00fAOQ2mPaob++RGb2dTFjgQQgCbuomraMIh6L2tIwmeumgJFrl0J3EVHWhfF+2G2vYOt9THgfYe5PivrEdDXCTt2lHWuz0u3OfDV5OMrrj260ZUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pz+Ct+aVpgCFCsCgBx7kdi9oHnBxmlIWjP8+waz+Zak=;
 b=k6b985fWvx4QdPpFNitZ84/d30cz1VUPD7+QIgiyQA8GX8+GWuhxWs1wYeYpQe3lQSykieNezFfS+NwNbTUvVH3VIzOXXJckBQ+C+8diR/IC9+WeL5KXxdA6qrajCjBb5oK9q4f/wpzvSXiLiTtdCgGYiCSyNf+ccKkGnrDcq1lp+abXHxeM8U/E0T6yLgLTXKHSm0aFvCsBXz2ceDdtYV6wer6mmyxzowKJyvg3N2qZcV7C9OA2c5Dur9s91PIf6L4oY/Ftj4m3OKYzSBzHisL2pMGsYP2bCSfNJPgUUly3EUkPUZuK3d2asUkrDl3cQid2xg1d35lSAmprDDWZmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz+Ct+aVpgCFCsCgBx7kdi9oHnBxmlIWjP8+waz+Zak=;
 b=x6IE2nx2o+Axw7e9me1xfliMTI3zvm2ih5Hru582EHs/l489J8S2cp4qkrlz8D5BoV9QeUf8Why79wMiTTFHGzJsCorN7N5/hHkBpQyLMInsOaDVF4lSrVaKTXSK/3aEIiPzWF19+jGhtknvN+2n+nNRac2zEQZzqh+NRoH5XmKdM074SyRo337nFyCQovaZ4rc0NLIfj2CIWAkohndIFeSXwq+c9SIuzesjATjdMOrFzV6eaWjpNE1DEvQ/7KbZzDcLdFE5K93KgFXJi0FJ6L30I3TM3NF7q2ehMKUjLZ96eifqhXU693cTq+s74i8AMDic3FR64zISi2SxKzkG9Q==
Received: from DM6PR02MB4585.namprd02.prod.outlook.com (2603:10b6:5:28::17) by
 SA0PR02MB7337.namprd02.prod.outlook.com (2603:10b6:806:ed::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Mon, 5 Jun 2023 13:23:28 +0000
Received: from DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1]) by DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::e48f:7318:a1cf:dbf1%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 13:23:28 +0000
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
Thread-Index: AQHZkzGeQS8mbCm9w0qDUFkji8V8m69zY/WAgABO2ICAAOFbgIAAOsmAgAAE0QCAAA5YAIAHWVYA
Date:   Mon, 5 Jun 2023 13:23:28 +0000
Message-ID: <8AE71A62-1BE3-4D6F-B57C-B5FCEA93169F@nutanix.com>
References: <20230530200152.18961-1-jon@nutanix.com>
 <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
 <F4AFC5EE-9967-4117-BA85-ED82C106575C@nutanix.com>
 <ZHd2P6D142rCByrm@google.com>
 <E17EFDD7-C54A-4532-B1D3-D567557FC54B@nutanix.com>
 <ZHermsSGQBcDD07R@google.com>
 <CBFC095A-10D1-4925-9F28-DEDEBBB38EF8@nutanix.com>
In-Reply-To: <CBFC095A-10D1-4925-9F28-DEDEBBB38EF8@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR02MB4585:EE_|SA0PR02MB7337:EE_
x-ms-office365-filtering-correlation-id: 3107cb1f-a050-48fd-66ea-08db65c80ce9
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odv3LYtsQybRhorVFdD5EzRcXifBrVTZ/IRgDWbo34Ph73W4FhGnkO+4hh5BCzslxZR2th9YNzBUskbN8nkAXorwaiTYWYJFJmodndfUUCrWG9FHEVqsfjAAhtOcW3aIxH5dbzgcPPwBzdQwH6YVCGNYZ+A5NHT7CFioGDVH/A+y+4X8OE71eKG8vFH8YVhjtAmwbTIOns8Hk0pIeeZZ50n4ETClYyhyWrgUohZrAN0drZZvjKDZFeBYwD0EqPzJu7xatojxtC/qY2nasjtvT3Tpm3ApBEicspVCM5fFcfh7zUF3aPPMKZ/LYVtYK+I5c9efEpxCqc5ws4PKVTOmAaw5M5qf4NMOgyFQJuQcGEvf7JBJf0TMiXzuCKJi206bqJtdDQqlOFk3r2PKcwfQYSAX5VbRmD5OXlRJJvNE2m3if28rG0uBAMRbQsF0c9XpycZRB5QRnvq1pGTHO620Flppr4gahrfNg0PvfpzqPjJwoCdZCFcSZGLCVYFIkajn9Mf5hGGfLDJkEC5BcXY5dZ8wGiPdqXPTQWLRaPVxECyf8pL/d9E5fS/ybx9wSkZ/cWEatU5gI7JUtXUbk0oKDPgENw+qRBtJ/y7f17BzTYmIywRjgNUmrgUbo5Aw8bTS50cdtnsDFA92CbnQWi2Mfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4585.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199021)(53546011)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(186003)(83380400001)(71200400001)(478600001)(54906003)(4326008)(66446008)(66476007)(66556008)(64756008)(91956017)(122000001)(6916009)(76116006)(316002)(66946007)(7416002)(8936002)(8676002)(5660300002)(2906002)(33656002)(86362001)(38070700005)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGs1MWt1Z3hCbjMrSU5DaXo4T1VGYU41LzA2NHQ1L3o5Ry9KaEFoVGtaTDdS?=
 =?utf-8?B?MGdncTVvN0N2aksxMVJWZGJ3SlhRODRsZHRlK3gyRVlCV25mYkM0V2hvUVla?=
 =?utf-8?B?YW5RMVVsN3M4VkFXVGkyWHpNNFV3Y0pkOWgvQ3BYd3VqZ20vZFQ4YVZGNjlI?=
 =?utf-8?B?aWRiUUc2Nm9ES1l3MVo2d2pLaXNFWTUzWVk1NEgwMlM2ZW9rV1VPcXR2ZWNw?=
 =?utf-8?B?NUR2VkV2WlhybTBkQkNSdmVjb1VXWWxleGdEYVA3WWZFNlNFRG5GYy9XTTdh?=
 =?utf-8?B?WTdLLzdibXpkNUx2V3ZHR0JmcmxhKzM5QnVwY3FCNS9lUGZkdnFIVVQ4MFc0?=
 =?utf-8?B?MUdTWTh0Y0FMSVBlTUxuWHhtaXdHZW9ZQzlJWlFVMk1DRDl4b3dIZ0Qzdkxv?=
 =?utf-8?B?THd2cjlTdHBjNi9QVWlVTEN1RHBjYXI4bU5NREFYZ1Q5TTl3ckZ6NUJOTUZE?=
 =?utf-8?B?b1RWN2c5UEtwZzVrc2NzeXpjYW9tM1VubjZpT09SL0lNeWI5eHlGTHFNdDNv?=
 =?utf-8?B?MFY2dnQwRjJyK1c4bXQ2MmhyQVp6M3V0cUVBSFl2RkxxQnY1VEwrWjlvTGVP?=
 =?utf-8?B?YTBic1dFdjczRGp4SEVLV2tvcjUyVHJjaEsvdW9rYVVJZG5yemhFVzN6cVd5?=
 =?utf-8?B?OU5kRnFMbDZidnJvUGN2Qkp3Y0dXQlQ5K0h4SVkwbVExeS9Zdlp4aThyWTV0?=
 =?utf-8?B?WUhRTW1Da3FaWTJxaDlLajdrMU14Q1doQzdlcDFPZ09OQjJmS0dkSUFPdEhl?=
 =?utf-8?B?SzFaS2h0eUJ3bGNRR2FqUElkZUI2dmErblFHSjJ2Z3FuS3ArOENmQndjQmNj?=
 =?utf-8?B?T2RjK3ZGNlAreE5KdG9mbEFycUQ3d3dpU0VBUUhMT1FCZ2JHL3VFc1NYcEVB?=
 =?utf-8?B?VjRld1JrK291YTNUS1Q2QVNweG9qOHE5RFJ5Q29UZUt0WWE2cDQwUmp5TXV0?=
 =?utf-8?B?YVZuZG5SRlpYdlRkaCtlVlpMZDFWNGp2KzFxWlMrY0Z6OFlobm5NUSttb3I5?=
 =?utf-8?B?TGlFOGVTN0ZQSnFkU0pWUW94bzV2U3laRFZYL2RpRE11MGRmYjk1NVlja1o2?=
 =?utf-8?B?ZFRMUGM4K3hhVGZ0dmg3bjY0ZzdwYTRQT3BWTGRwODdCT3kwbmVnTkxsZCtW?=
 =?utf-8?B?ajBZQmR0QUs1QWVXTGxhUFFZYU5ZNkcxejF1QURhbzBNTXpZNHNiL0J6NjYz?=
 =?utf-8?B?KytibnRNVWl2Y2pNZHExdHRMZmNvUWRZWTc4dE1BUHduNHc0SDdtWHNOdmVu?=
 =?utf-8?B?WDRmZ2NLNVRkMkVjcWdlL3hkTGNGK2pLbVlnMXhsRHFkWDZ0UGoyMEdhRFg3?=
 =?utf-8?B?M2FQVi9saEt1N3dMRG1Cc0pnZkVNVVZWTit2eVVuTFFJOW9NRVNXa3Z3SGZm?=
 =?utf-8?B?UDZGdVBxaWEyTHBYbVY4VjJCYm1NWWJqRElRb2NMN2lZWHp3N2ZVUTRMUGxn?=
 =?utf-8?B?aXhxUTM3NklsOU1UQUI0azVObEhwcCtkeHV4Y3dBTk5qMFJCRjhYQU5ZVGpX?=
 =?utf-8?B?MGQvRFdublo2TWEwN0pPbkVoM0lYSW0xcjNESGVmWGdhbG9VZmpRWnpLTm9B?=
 =?utf-8?B?dDhYTnpWVXlPcnRpVWNqbU1ENVdZeXB1bTJtZFBteWQrMDVqNW9tYmhQUVRQ?=
 =?utf-8?B?ZHhKbnFDbmN3c0xjWll6VkhCdVVlSHhuVkJ5WVZHTzk5ZkZZNkpuTmhid1Rk?=
 =?utf-8?B?S1JVZ0JWZ1p1RWZ3Mm1mZHFTc2Z2Z0wvSFgrWXlSK0pEUFUrQmFEczJacGFM?=
 =?utf-8?B?TzZPNUw4dTJULzFDaFEydUJlQ0NpRmNhQUtYWFhLVXVvNExmVUx2Nk56MDJt?=
 =?utf-8?B?ZFBCWnExcXUyaXkwQXQ0dHFiVFB6RmMxY2JYbTNCbUFCSFhxWURLQi8xeDNC?=
 =?utf-8?B?UjdWcEIwQWZaZit2ODlvN29QYThSdmVjYURGSmRaeXJ1c2VZM21DcmgxZVps?=
 =?utf-8?B?L21hSjNvK2tndjRzSGMrcFN0aWh5V3p0RGx0M0Z2Q0l1OVUySktXVkxUc0Ro?=
 =?utf-8?B?NFl4UUtMeE05ZzhhNjQ0UGpMdWRwdGFpRm5VU2V6eDduSmU3aUNLeTg4OHRo?=
 =?utf-8?B?cWZtekRDaUNVM3pnQ2RLdU0vSHlXRm1BRDJBdk1yMjBUZFNEa1JJeU1QS1Y0?=
 =?utf-8?B?ZkpPazBJOXd4WlNJa1BtWTZRRUhFY0hPeTkvZHliNGQ4UHBTY3BodzlBTkJT?=
 =?utf-8?B?SElXRkd0V2dVQ1ViRk8vaXJrRFlEbzBQMmFicDFGZHFsR09KMFJ0WDFDYWJu?=
 =?utf-8?B?U0EvK2lRWGVkUW85d0dmTFI4ZUpRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7F3AD4744845249BC1EC72A742E74CA@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4585.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3107cb1f-a050-48fd-66ea-08db65c80ce9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 13:23:28.7284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWNwBBtY/K8XSzTy1AmXB317ooRqlp4VTB84mY4YLbJf9mo/F2DibnpHbKs8jx612PoQq5utkq/Yk5MZ2yjIlOLa8m5SshpxsCha83pXMSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7337
X-Proofpoint-GUID: gob4mSufNvP3p6d3rrYasi3ExpiBnAvc
X-Proofpoint-ORIG-GUID: gob4mSufNvP3p6d3rrYasi3ExpiBnAvc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-05_28,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDMxLCAyMDIzLCBhdCA1OjA5IFBNLCBKb24gS29obGVyIDxqb25AbnV0YW5p
eC5jb20+IHdyb3RlOg0KPiANCj4gDQo+PiANCj4+IFRoZSBDUFVJRCBiaXRzIHRoYXQgZW51bWVy
YXRlIHN1cHBvcnQgZm9yIGEgZmVhdHVyZSBhcmUgaW5kZXBlbmRlbnQgZnJvbSB0aGUgQ1BVSUQN
Cj4+IGJpdHMgdGhhdCBlbnVtZXJhdGUgd2hhdCBYQ1IwIGJpdHMgYXJlIHN1cHBvcnRlZCwgaS5l
LiB3aGF0IGZlYXR1cmVzIGNhbiBiZSBzYXZlZA0KPj4gYW5kIHJlc3RvcmVkIHZpYSBYU0FWRS9Y
UlNUT1IuDQo+PiANCj4+IEtWTSBkb2VzIG1vc3RseSBhY2NvdW50IGZvciBob3N0IFhDUjAsIGJ1
dCBpbiBhIHZlcnkgYWQgaG9jIHdheS4gIEUuZy4gTVBYIGlzDQo+PiBoYW5kbGVkIGJ5IG1hbnVh
bGx5IGNoZWNraW5nIGhvc3QgWENSMC4NCj4+IA0KPj4gCWlmIChrdm1fbXB4X3N1cHBvcnRlZCgp
KQ0KPj4gCQlrdm1fY3B1X2NhcF9jaGVja19hbmRfc2V0KFg4Nl9GRUFUVVJFX01QWCk7DQo+PiAN
Cj4+IFBLVSBtYW51YWxseSBjaGVja3MgdG9vLCBidXQgaW5kaXJlY3RseSBieSBsb29raW5nIGF0
IHdoZXRoZXIgb3Igbm90IHRoZSBrZXJuZWwNCj4+IGhhcyBlbmFibGVkIENSNC5PU1BLRS4NCj4+
IA0KPj4gCWlmICghdGRwX2VuYWJsZWQgfHwgIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9PU1BL
RSkpDQo+PiAJCWt2bV9jcHVfY2FwX2NsZWFyKFg4Nl9GRUFUVVJFX1BLVSk7DQo+PiANCj4+IEJ1
dCB1bmxlc3MgSSdtIG1pc3Npbmcgc29tZXRoaW5nLCB0aGUgdmFyaW91cyBBVlggYW5kIEFNWCBi
aXRzIHJlbHkgc29sZWx5IG9uDQo+PiBib290X2NwdV9kYXRhLCBpLmUuIHdvdWxkIGJyZWFrIGlm
IHNvbWVvbmUgYWRkZWQgQ09ORklHX1g4Nl9BVlggb3IgQ09ORklHX1g4Nl9BTVguDQo+IA0KPiBX
aGF0IGlmIHdlIHNpbXBseSBtb3ZlZCBzdGF0aWMgdW5zaWduZWQgc2hvcnQgeHNhdmVfY3B1aWRf
ZmVhdHVyZXNbXSDigKYgaW50byB4c3RhdGUuaCwgd2hpY2gNCj4gaXMgYWxyZWFkeSBpbmNsdWRl
ZCBpbiBhcmNoL3g4Ni9rdm0vY3B1aWQuYywgYW5kIGRvIHNvbWV0aGluZyBzaW1pbGFyIHRvIHdo
YXQgSeKAmW0gcHJvcG9zaW5nIGluIHRoaXMNCj4gcGF0Y2ggYWxyZWFkeQ0KPiANCj4gVGhpcyB3
b3VsZCBmdXR1cmUgcHJvb2Ygc3VjaCBicmVha2FnZXMgSeKAmWQgaW1hZ2luZT8NCj4gDQo+IHZv
aWQga3ZtX3NldF9jcHVfY2Fwcyh2b2lkKQ0KPiB7DQo+IC4uLg0KPiAgICAvKg0KPiAgICAgKiBD
bGVhciBDUFVJRCBmb3IgWFNBVkUgZmVhdHVyZXMgdGhhdCBhcmUgZGlzYWJsZWQuDQo+ICAgICAq
Lw0KPiAgICBmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRSh4c2F2ZV9jcHVpZF9mZWF0dXJlcyk7
IGkrKykgew0KPiAgICAgICAgdW5zaWduZWQgc2hvcnQgY2lkID0geHNhdmVfY3B1aWRfZmVhdHVy
ZXNbaV07DQo+IA0KPiAgICAgICAgLyogQ2FyZWZ1bDogWDg2X0ZFQVRVUkVfRlBVIGlzIDAhICov
DQo+ICAgICAgICBpZiAoKGkgIT0gWEZFQVRVUkVfRlAgJiYgIWNpZCkgfHwgIWJvb3RfY3B1X2hh
cyhjaWQpIHx8DQo+ICAgICAgICAgICAgIWNwdV9mZWF0dXJlX2VuYWJsZWQoY2lkKSkNCj4gICAg
ICAgICAgICBrdm1fY3B1X2NhcF9jbGVhcihjaWQpOw0KPiAgICB9DQo+IOKApg0KPiB9DQo+IA0K
DQpTZWFuIC0gZm9sbG93aW5nIHVwIG9uIHRoaXMgcm91Z2ggaWRlYSBjb2RlIGFib3ZlLCB3YW50
ZWQgdG8gdmFsaWRhdGUgdGhhdCB0aGlzIHdhcyB0aGUgDQpkaXJlY3Rpb24geW91IHdlcmUgdGhp
bmtpbmcgb2YgaGF2aW5nIGt2bV9zZXRfY3B1X2NhcHMoKSBjbGVhciBjYXBzIHdoZW4gYSBwYXJ0
aWN1bGFyDQp4c2F2ZSBmZWF0dXJlIHdhcyBkaXNhYmxlZD8NCg0K
