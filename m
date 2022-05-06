Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D551DC6A
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443103AbiEFPrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443115AbiEFPrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:47:21 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5806D870;
        Fri,  6 May 2022 08:43:35 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246Cx8jO010197;
        Fri, 6 May 2022 08:43:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=g6Z4GVqvPKCNRpVfz9yJWdnJBOWU123Zs/yTkiZzA3I=;
 b=E4s+KPWZdhgiXpIyVkVx3RjmGdDIPYAZwkcJqxAlx5chGukMXNNWnrfrmS3e36E6x6rx
 3R1ppKrOHQrehGj63saT5FQ5o62zdFiHSLnUnB64otNpiS7BDHui/PLzb0YvFFGLtTXO
 ERHDgCLbZBr8XQ2QjZ6mFpqIsnvv4FJxV+kWKCe+AgwjzOG1ib/GLBLYD2JNuYY4W9AP
 hqsukFDZdOjUowTlHpgk2Gm+8dxp7xt+vZCZjmhVtJLKQMkSGu0cqY16xEzrpkDvtOqg
 fH4soC/E/GZwP1KGgAaI8MBiZbChWNrZlnFP4Frgn8HeRbP7cpmTcI3fv6SZSsFvyJxR Kg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fvjdqt7wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 08:43:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHjKgC+PLt2EXLISOKngInrdKd0Gpah37+iQFIqRMpb3TIIH6/LfgtsM3bltWM384xlgy35dp2hlEUm5+GGViTfFSoqlPNx4mrWe5mTC86xvqwMu6yJN09S2xx0BhWlV33hOxVV51s6ICRn8zzte72LU9GWr/64PU3AFXxpIj0U1kRAnaiurr2Pmsv9Chm4ErGXLZyh02IhboupDVQ5U5xrPgbSAHyNFhvrX/kcgukY2R5L7T4KxxFxIRbGnTFLDlWLMTZvvZx4vF4Oko2lO6AdP0WeoK9RS1EneQRouKkFlBjWps5L5HM2Rc+3OBH2nEs/imlCl8fG8edt/4QdP6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6Z4GVqvPKCNRpVfz9yJWdnJBOWU123Zs/yTkiZzA3I=;
 b=RsYSR4A8mlBsCkg5dRTRQuQAAGMqv/UMMcCidyPu3g1ke7hIhzQSHYzIdKdWoXSGf9uxTJ7czGbw7k4/eYH34LNia1vz1lb7qLg2yMIsaRrC+POJuILmiebhXgRja5K1FmnUkcR2JJqSeDnV+Pfqy5KVWOhtMHuxZw5sEZZo/EGSr5NhywOYqY1VNp1goIoYn/+GstIbU4mAPZMokVtVHr6UDpBW+EtphnoIYyPEPJjf5PPIQzvYL5flep3tY3vCtsMBUnKydL5h3ZOqLNKpAj7Gcq8xAAo/1JkQ0blHlumljtlocqZjWoe2H6eTMwza6qa+FCEV3RfGv39WXe193Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA1PR02MB8576.namprd02.prod.outlook.com (2603:10b6:806:1fc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 6 May
 2022 15:42:59 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5206.025; Fri, 6 May 2022
 15:42:59 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Thread-Topic: [PATCH] KVM: X86: correct trace_kvm_pv_tlb_flush stats
Thread-Index: AQHYX+SdgNMP1X+6KkawcgehKjrXJq0PQWOAgAAse4CAAIFbAIACEOqA
Date:   Fri, 6 May 2022 15:42:59 +0000
Message-ID: <C8885C42-26FE-4BD3-80B1-2B8C7C413A21@nutanix.com>
References: <20220504182707.680-1-jon@nutanix.com>
 <YnL0gUcUq5MbWvdH@google.com>
 <8E192C0D-512C-4030-9EBE-C0D6029111FE@nutanix.com>
 <87h7641ju3.fsf@redhat.com>
In-Reply-To: <87h7641ju3.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6082024a-ac40-49ce-6b54-08da2f771951
x-ms-traffictypediagnostic: SA1PR02MB8576:EE_
x-microsoft-antispam-prvs: <SA1PR02MB8576880EDCBAB056F687D0C4AFC59@SA1PR02MB8576.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8inSZ5GHx+Sja2el5yf9PHw5mWxETeWebrWnlZbtx9YQMdR2t3044Y4az/HUjElyRbu62DCuW2M7EP82ClEx9WDla+6jPmrNU45aGD6uNCFs40duz/9aH9g4KmWvntMGTHTixJlesY6BcGC1sLGql43qrYN2a5EMKMxyoAD2iDbE2kgXgBfalN8iJDHoHkp9jjCuRorxSQQTINJhLc0OjD05CLO4WI6jub4RcuNhc9FElI1RRUmEfNc5jiBe9+3dcbK6AMdS+C8V0q/gALjdqtTj5rw6lQYLfUN/6bWazDYv5PJhnJlXn02vSjAUcsxPy+K3P7DpHSSRc93z9Wz1aB46YHvsEHCSxtM8n+L55YKKu11xa2gzX19hJ3uMl5ut+oD2M5SoTJ/kDLa4IcoJ+3/RTsYjzlgGyrwxqNh4BlKkOJpeLXa460xyDF/+f5RKKAPmAfsAv1t/Pxt8voaos5iDh3DM+h6HjTlkqtNCa1UN+g0iNZrqDuqctG2ujuTAcdjfVqKS7fg2EsY/tbyBZf8qc0LJ9Im+13VDE5Sfyjc/u8jHDjBeyBzr7YlERGk3IYYW5VmHaZNLsI8QBa/NHcX4M9sItVBdgvKPSDTv4Me/ruz1JQj+KnIpHd2tCpDnQZi7pGciOxy/+4sVInmzyravFvfNpGGBOt2EW0D9b1D9YW9z3cJkuAqeElptM3BOAnwqYSSR70L5KZg1mEZb8A4Y3ux42YoqXp+LFcm9oA4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(7416002)(186003)(5660300002)(8936002)(316002)(8676002)(4326008)(66446008)(64756008)(66476007)(66556008)(76116006)(83380400001)(66946007)(91956017)(86362001)(36756003)(508600001)(54906003)(38070700005)(38100700002)(6916009)(2906002)(6486002)(71200400001)(6512007)(6506007)(33656002)(122000001)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVNta1hiZW9HblFrajZ6M0pmRjdZUzN2Z1JHTjFIUjFyVVcrUHFIM1cwclVj?=
 =?utf-8?B?VnI5QmNrMkNLNlJCN0FxK3JScnlCdTVmUG1XdUp6OTMrbFJyNXJHN0lGWkli?=
 =?utf-8?B?TXUzTVVFVFE2R2NMTkRUVklkSGZyT3J1cUxWeTZSZ2dMUXJ5TUdwdklWSThi?=
 =?utf-8?B?RjNaaGFDVjFRVktGWEg4VkM5NU91V2JScmUwRVNaNVUrRU4rMjBwazFsang2?=
 =?utf-8?B?Q0c0dEVuOU9wcDVyVWdIMmEyRUVuSHJNVGxKMVVtVDVIR1NsSDRJb3pYUzVS?=
 =?utf-8?B?cEZ3S01TT2Y2N2VucXdEOFQ5NG5SakVyV0ZpWFl3VGYxSzBUbERENGhCUk1m?=
 =?utf-8?B?K1FOM0lTNm0vSnIvZTVvaC9JeHIzd2J5Z2ZZSVV2djlrZmZhdEEzdW9kTlFT?=
 =?utf-8?B?eEhZMmNZK2pBVXZIVWVpcVhMeDlQcndIUnBVSnl0R2F4MVdhaHVqYkNCM3Rk?=
 =?utf-8?B?WkQ2c0tmZFAyWi9BV1FjUFlDVmp5aCt5d3NSeWd0MmNGcU96dEZ1d3cyY3R3?=
 =?utf-8?B?NldCdHgzRkNLNkptWmtkNExIVUlnV2NxaHdXNFV6YVJvNUEyZnI2SHlURzNq?=
 =?utf-8?B?MWp5NkR6aFNCdjJVcm5XcmdyZTJ2T3hKYXBwVThOOHJCbjQremx1QS9pbitv?=
 =?utf-8?B?cEhvSHRSc3lWWDNJZnlhUmtzRnN0aFpSTjhRY3pVVThTYnBkUFhhdlJNc0Qw?=
 =?utf-8?B?b0plREhEZ3Z0WnV2NENhcFhxMVVtMmlXN2JtNWZzS3NDRkR2RkxxUzMzdCtt?=
 =?utf-8?B?QnVPV2ZzNm41REJtaFJDWWt0S0xwQkZ2blEyYkVTeWhjdHo2SzdNVUxZYnV3?=
 =?utf-8?B?NkhZMlJERmhkY00yZ2ZjQ0Z5eTlabFI3Z0xKSVdBY05WREJLNFpMbDZKNytz?=
 =?utf-8?B?M1hpNDQrdkZkbUhjUlh1b1VISWJ2VGVaUXdiaWhpWkJ0SnRIMEdNcDI5WWVF?=
 =?utf-8?B?R1laTlJLRHRBbnFWM3hrc0ljYlN3cHVJb2dFNjR3YjJBTWNpM0FjWCtYbmxj?=
 =?utf-8?B?b0pZT0FHNmE5TmFWWnEyRHJoTUtLWDBNQ3pkbjVOcTNDeGtuUm9pc0pnQUJD?=
 =?utf-8?B?SWFMaUkyVzFJdlJuWnF5bkFBSi9KZkFoVVBtdzE1UUczMGRtekpiRVVZM0hR?=
 =?utf-8?B?VUNjUWl4RWNKYlFPODJYWGh4SlhLTkZMdUpYS0l0KzNqN2M2VXFYMW91TEU5?=
 =?utf-8?B?L3RrcEE1Y3ZHVlZVblpRVUdJK2NJV1h0UzJoVTVCUkYyV0l4cG40VTFyUFov?=
 =?utf-8?B?SGdyN2NaV3JDTy9qeVFXcXlZVm4vaU5RYjVUdWdGeUF2NXREVnRud1hGMnJ4?=
 =?utf-8?B?RVU3dGk0bVN4d1lxaXNrYjJJOTBGc2NUQkV5QVl2SlFtekMyaGdNZ3V5SGkz?=
 =?utf-8?B?YWJlZUkyZTBmYy9vclU0a2dKYzlPa2VTVjNYaFlPd0haMFBNZmRySXNzWG91?=
 =?utf-8?B?ekFxamJRQ2puV2JBL3ZsNUhDM3M4R1hEY2JIUXhxOFlTayt2MlpDRGk0ZVo2?=
 =?utf-8?B?OE1DejRVc2Q5ai9BbE41a1dtL28vb1lCc0FXQVhoYThsN252bk5qdnNYY2Zp?=
 =?utf-8?B?RHpSR0F0RVFuNmZtL1ZxMVNkR2RJQ2JGNEMrbXdXbzBDZHZ1OTY4d3BBSmxM?=
 =?utf-8?B?TWNGL3VEUkRPc3YvWVJtZ2lHZ0s5Y1pncG9zbElsRnIzdDc0bVpFekVLOFEx?=
 =?utf-8?B?d2pOK1VUMVV0T2VCdFJJYmcwaHY5MXV3YnRuWFY1ckR3bjIyUW8xSEQreGFR?=
 =?utf-8?B?NUpmaFhEVm8zSlRGRWtYK0p3VkdWeG5lSTZSaWZNQWhaS0lDWWQ2N1ppMk9r?=
 =?utf-8?B?aGhuUlNzZEd3NmV0K1BDRngzTHlNa3VSL29MV1YrNnNUQ0ZhSGMwVnlGWjFl?=
 =?utf-8?B?NlhqTVV0eldmSGNFYWxHdnVDSmYvcEFTVDJTc21wMTQyaUFBeG5GM0pHQ2dE?=
 =?utf-8?B?dHVhNVNZSmNlMzBjUFdCb2xSMDc0SlV1TWRGdWdlaVA0eEZERkhQY2hYWCtX?=
 =?utf-8?B?cFlUUlhjYm10dklPMmJDZnZNaEZ4aHBPNFFIUE5aZjkvK0gvL2xSWGx4Umt2?=
 =?utf-8?B?QnhhdDNnNW5YK0x3UDd4dEZkQkFObnpYK3p3MkxOSFcyTnJlQXNFVXZMdTNO?=
 =?utf-8?B?SEhGR1l1UVNZcnE5eHRrb3ZCZWN1c2NkVmFpVGE3QktIUi8zdEFsbkpVM3hG?=
 =?utf-8?B?NmRscTB4VmdmbzdWMTNWMkkrMzd5TSt2YmdkN2N0UmlMeUZOWGhsSFZiOWhJ?=
 =?utf-8?B?Ky9BcWZRUThtdWx2eUNsb3YySXNTOHg0VXJ3QXUvYmgxMytEUmVVcFdteXhM?=
 =?utf-8?B?R0RWSVl5Vmk0b3FyZm9wTjNuVG54KzJjN1Bxa1l3MXI1ZFFnejlySUdRR3lw?=
 =?utf-8?Q?qztUpa5I14aa1X9/n0Thv5iiQDPG8LKMAw2hzC9tx6MnK?=
x-ms-exchange-antispam-messagedata-1: Bgzjngay4RQ8Bk35gGl7G13mHAaiE7vJkb761pRuVz1RUiVeWNoUuUtV
Content-Type: text/plain; charset="utf-8"
Content-ID: <576DEAB0FAD1A64D8A22A79831153262@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6082024a-ac40-49ce-6b54-08da2f771951
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 15:42:59.8570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bFrTVsOnq9pcLqZAKWDxumw8ygCkwCNnU8CHy19zW4ekEnz2SY3v01NfBO0FMt9M5CJFDg2UZdiEuCnRYyp4/c++TuVps7TWvd8hF6yhJ5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8576
X-Proofpoint-GUID: 2UZyixq9-2RsKnxDoZMfH0V0OYvOkzwv
X-Proofpoint-ORIG-GUID: 2UZyixq9-2RsKnxDoZMfH0V0OYvOkzwv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_04,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gTWF5IDUsIDIwMjIsIGF0IDQ6MDkgQU0sIFZpdGFseSBLdXpuZXRzb3YgPHZrdXpu
ZXRzQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29t
PiB3cml0ZXM6DQo+IA0KPj4+IE9uIE1heSA0LCAyMDIyLCBhdCA1OjQ3IFBNLCBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+IA0KPiAuLi4NCj4g
DQo+PiANCj4+IFRoZSBuZXQgcHJvYmxlbSBoZXJlIGlzIHJlYWxseSB0aGF0IHRoZSBzdGF0IGlz
IGxpa2VseSBpbmNvcnJlY3Q7IGhvd2V2ZXIsDQo+PiBvbmUgb3RoZXIgb2RkaXR5IEkgZGlkbuKA
mXQgcXVpdGUgdW5kZXJzdGFuZCBhZnRlciBsb29raW5nIGludG8gdGhpcyBpcyB0aGF0DQo+PiB0
aGUgY2FsbCBzaXRlIGZvciBhbGwgb2YgdGhpcyBpcyBpbiByZWNvcmRfc3RlYWxfdGltZSgpLCB3
aGljaCBpcyBvbmx5IGNhbGxlZA0KPj4gZnJvbSB2Y3B1X2VudGVyX2d1ZXN0KCksIGFuZCB0aGF0
IGlzIGNhbGxlZCAqYWZ0ZXIqDQo+PiBrdm1fc2VydmljZV9sb2NhbF90bGJfZmx1c2hfcmVxdWVz
dHMoKSwgd2hpY2ggYWxzbyBjYWxscw0KPj4ga3ZtX3ZjcHVfZmx1c2hfdGxiX2d1ZXN0KCkgaWYg
cmVxdWVzdCA9PSBLVk1fUkVRX1RMQl9GTFVTSF9HVUVTVA0KPj4gDQo+PiBUaGF0IHJlcXVlc3Qg
bWF5IGJlIHRoZXJlIHNldCBmcm9tIGEgZmV3IGRpZmZlcmVudCBwbGFjZXMuIA0KPj4gDQo+PiBJ
IGRvbuKAmXQgaGF2ZSBhbnkgcHJvb2Ygb2YgdGhpcywgYnV0IGl0IHNlZW1zIHRvIG1lIGxpa2Ug
d2UgbWlnaHQgaGF2ZSBhDQo+PiBzaXR1YXRpb24gd2hlcmUgd2UgZG91YmxlIGZsdXNoPw0KPj4g
DQo+PiBQdXQgYW5vdGhlciB3YXksIEkgd29uZGVyIGlmIHRoZXJlIGlzIGFueSBzZW5zZSBiZWhp
bmQgbWF5YmUgaG9pc3RpbmcNCj4+IGlmIChrdm1fY2hlY2tfcmVxdWVzdChLVk1fUkVRX1NURUFM
X1VQREFURSwgdmNwdSkpIHVwIGJlZm9yZQ0KPj4gT3RoZXIgdGxiIGZsdXNoZXMsIGFuZCBoYXZl
IGl0IGNsZWFyIHRoZSBGTFVTSF9HVUVTVCBpZiBpdCB3YXMgc2V0Pw0KPiANCj4gSW5kZWVkLCBp
ZiB3ZSBtb3ZlIEtWTV9SRVFfU1RFQUxfVVBEQVRFIGNoZWNrL3JlY29yZF9zdGVhbF90aW1lKCkg
Y2FsbA0KPiBpbiB2Y3B1X2VudGVyX2d1ZXN0KCkgYmVmb3JlIGt2bV9zZXJ2aWNlX2xvY2FsX3Rs
Yl9mbHVzaF9yZXF1ZXN0cygpLCB3ZQ0KPiBjYW4gcHJvYmFibHkgZ2V0IGF3YXlzIHdpdGgga3Zt
X21ha2VfcmVxdWVzdChLVk1fUkVRX1RMQl9GTFVTSF9HVUVTVCwNCj4gdmNwdSkgaW4gcmVjb3Jk
X3N0ZWFsX3RpbWUoKSB3aGljaCB3b3VsZCBoZWxwIHRvIGF2b2lkIGRvdWJsZSBmbHVzaGluZy4N
Cg0KVGhhbmtzLCBWaXRhbHksIEnigJlsbCByZXdvcmsgdGhpcyBvbmUgYW5kIGluY29ycG9yYXRl
IHRoYXQuIEluIHRoZSBtZWFuIHRpbWUsIGRvIHlvdQ0KaGF2ZSBhbnkgc3VnZ2VzdGlvbnMgb24g
U2VhbidzIGNvbmNlcm4gYWJvdXQgbG9zaW5nIHRoZSB0cmFjZSBpbiBzaXR1YXRpb25zDQp3aGVy
ZSBwdiB0bGIgZmx1c2hpbmcgaXNu4oCZdCBoYXBwZW5pbmc/DQoNCj4gDQo+IC0tIA0KPiBWaXRh
bHkNCj4gDQoNCg==
