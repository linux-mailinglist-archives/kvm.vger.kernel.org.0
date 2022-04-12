Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A744FE58C
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbiDLQL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 12:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiDLQL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 12:11:27 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D104026C0;
        Tue, 12 Apr 2022 09:09:06 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23CAfG7E013657;
        Tue, 12 Apr 2022 09:08:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=SqaUbVl0PxYj+lGheoX8yK59449jidZnPHG6ByPu3Zk=;
 b=N7+JR31+1UM/5d0L+K7q8aJmROMZJ7ro0uoVpsLLe8I6nQvbtQlJNW0CuKoC6uW5pYgy
 hld2jUlNvM52H2A39Z8oSPsvdvfJw/a3MqBW4+tvzSTAX0Zwko6LypxUlbB8CvW/vkGG
 WUx4yh4nUDgFQ0GWkkg1hbcvSHUcMVEtXnHCTf5qMNiFxeq/KPjuqrz4WvAZHzw0X1bD
 p6HsHaY4nwIRy72yMITieszST5zbXxTWV4oFWK+G3wAjJnzOZmxiqcEpsoHtHqxeG1az
 qjNFYV5Es+CHcQgAQ8YwvZl2YchSrtUcXZY77MG/FSZWfcCnCIWODvHBlKbpMPG+KtsF xg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb9nxxkkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 09:08:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJ8zmDO9OZshwgk8ILCLX0rQ1s7Vg/LF1AX1D8ex0AZ5Acyokmx1J2ywSIb5hnYbi3swthkJQ8ShXyi0NBvgQ2CF4DDjuTk1J4CeltMdRyQuWHdm9UTTLzk7+8jkrttyJJUXPPTOWjgmohzbOSa07Jtv1UZcA5gypBMf/ySIEQd+C5BLhWmlswJWSwKFOKHC/9KkGc0Ee4f8x5VzPaOISzO+YVB6aZ03VDTltg1Ey0zUFX+8FmleTHBiHUsDDpAMjufHBaJZluz/lKkpgICDG633znWHTOct/bxa/zKT/1aaffeRz+BR0Gmh1SMlpVMSB7hcPvH7NzM2qgrea3U/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqaUbVl0PxYj+lGheoX8yK59449jidZnPHG6ByPu3Zk=;
 b=TidwUE+KEXvQRtxT/OPLm6QtGt13pgFmY4ze/s1iwAnR1YnYJhuDFKA1Gsf74gI2HgScFE1I0urqjWoF6pu+t++xo1JIO1vfCAuWgcotS4G2IH/Nt44PrNyfEArd+egIJeO+Ir+11AWWJt0EjM/nk2l57Hzbn+kIaQDta0CRi2EalZ3ERmlD1UQjf8kG6VHXle3i6KiUnQfDWB+NTmoAid4z/hwC+u1/LIknfZQUhemtmbpVUuhaPLIbGORoDwijXtS61xEi5wGgTJsFD+RIX09vpNke62oFS9DiNzn39gOmKARRv6E8eoOhOYlKjBtHQNvESNHOiRDvCFV4D9xOfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MN2PR02MB6752.namprd02.prod.outlook.com (2603:10b6:208:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 16:08:32 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 16:08:32 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Dave Hansen <dave.hansen@intel.com>
CC:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Topic: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Index: AQHYTc5N3PtRLPD03UaoXnwsq2NUS6zrGJQAgAACcQCAAEXKgIAA6CmAgAAmhACAAAQCgA==
Date:   Tue, 12 Apr 2022 16:08:32 +0000
Message-ID: <28C45B75-7FE3-4C79-9A29-F929AF9BC5A8@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
 <90457491-1ac3-b04a-856a-25c6e04d429a@intel.com>
In-Reply-To: <90457491-1ac3-b04a-856a-25c6e04d429a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 551d7da5-86da-4a0d-b737-08da1c9eb103
x-ms-traffictypediagnostic: MN2PR02MB6752:EE_
x-microsoft-antispam-prvs: <MN2PR02MB6752DB7AA6CF8DDCC14C1AB5AFED9@MN2PR02MB6752.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mayWX5lvcmUPaWf0YmO1xdm72Ed5fS9JsNDcIfdAUpdbsr2uFlwTsQd2We9TxqULovIiUpXv76yLj5k+5+GtXnBumD4cDR+/SZsWIeilzljwzOcUjLGtdQlI0CJhUIydRVvSlGo3e1h2re7tyiPLLOAE8V0nUIdIrPjfR0rUYHbyNt7CXy1d183FzGLHSIJxJp70s1g8cw2ReU1C/K+hPMDNDPWz7k8jUp9K0ZtcIXZuE+Ma3Tgi6irhvUUQZsYGuvFMmM0sA84I3mCjklHTDMMpFtzzlQuvEmOAxl6sVYI/tMRs+T1p+e9IUXGUJ5amPIeuQiK/Paojy4AdMXnRkQJylsDwYjoW580OkYh4HrtRk5D2M24dcmwNJS0laebTP46TFImJm+vJgyPgVCutFkm3Ed1W3k8bbu4bxaDGJn1L2zax0fkPsPUhlX//G/zdbC/MArOgbpqLziCFRGBk1xscWDAoZJ9L0kQTc1rnZr9B7In8Vgmou7vgQUo1+Dt7xnUrGh8+Pp5F++Wmifx+N3BnLFgfXQtiEH9/1ki/+8SlClTICP9olojfpdncQ9UMVGxLwjAPVh5ggUeph7muiFKz2ylaMCouszNxBCTAh1W9H/5SqniUAZE5Sy3PUYn8/JpbEz/xh8Cir0tF5auCxFyPA38uNVoi5n5Zyr2VS0yNlx1ZIvi9Xm6m5aR2v2PBxeVwm0d27n8vCj/+961J1bHO3iV1bbLBdYZyV8ouDVjzRpF7/YEuq0k0WESkGfjG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(91956017)(64756008)(8676002)(66446008)(66556008)(33656002)(76116006)(66476007)(66946007)(83380400001)(53546011)(508600001)(8936002)(2906002)(122000001)(2616005)(6486002)(5660300002)(86362001)(6512007)(6506007)(316002)(7416002)(38100700002)(54906003)(38070700005)(6916009)(71200400001)(36756003)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aC9tQlM0b1VnMUYrV3lCODhmTTJkdWxrOVBHSkZXUVhjZmdsL0ErRDFzazhk?=
 =?utf-8?B?WHh6MEdmSSt2dEdpSzVaU3IwRlNwNExCV2FhSldDV1BrSFdmS1JDd1NpaVNO?=
 =?utf-8?B?bjhwZDdPMER5ODhra0U3bzlLakN1UEU5WkdyMzBSOFUweDgwdEUwQk93OExG?=
 =?utf-8?B?Qmp6eHAwcDRrZHdUWWthWWFuRW9rbjJlZ1h3TkJyRTlkSkdGVkRLS2RkMkpw?=
 =?utf-8?B?Q3FVU2FtK0RNRDZHcUJoQ2F5M3F0YXlnQ1B1QkczQWpQSHh5ZzBrQzZiR1RB?=
 =?utf-8?B?VTZ4dGpRUEZlUTB4Q1RiQTVjOGZHNzRvSnBRZUtGdzMvc01UbG9taHZWWlZW?=
 =?utf-8?B?d0s4N0o5b2lzdXFQdUZ1bEY4ZCtBUlA3TlQzR1dJL0NFNDlFaTZxOWpjckFT?=
 =?utf-8?B?UkYycEJMYnVEaHNlZmlrUUF0dDR5YXplWi9CUUVMeko4WGp5UEszN1kwTzJv?=
 =?utf-8?B?V1VxSm56ZnJ5Nm1rZU00Z1B1OVdOM0U2WjlRS2txZnh6b1YzLzFvTGNlVDZP?=
 =?utf-8?B?L2U5a1FUbVBUYWVFR1VsVERwcis0THhSbU1TSE9Sd013VmhyVFB3bzFrZUJT?=
 =?utf-8?B?ZjV2bnp3bjBUbVZXc0xtTHBvdXUyZ2x4M21iZ0twbnNoeFNoWENWdldSN1NJ?=
 =?utf-8?B?dnRTeDh3RkIrL2IzU0RvMUY3cWZ3enpkcFlZQ1Y0QVFqTVFhZjJDUzREWTJT?=
 =?utf-8?B?SHBuZmZ0WGxBYXZKUVdmem1uRUc2NDhpSVkvQXZTbXY1dnRLRUNqaDZ5eTdD?=
 =?utf-8?B?L2QyN1BXbUovWUtyRU0xRUI2VVdKSkdON1N3VU1qdk5XREhKK1dsZzFGVnA4?=
 =?utf-8?B?andIazVxS3RRTDBObHZ6d0dFb1RmU2VSU1NFM0lJNC9HczZzK1A1bUIybitT?=
 =?utf-8?B?Yy9mZE4wTzMxMUliYlBxVVRXN0p0WXM1RzRVMFgydG02NklNVGFDOW5aeE9D?=
 =?utf-8?B?bno4cVNNd1N0b2lRYlpHOXRrcWcvRVo5SUJXYmVHOEswOUc5NWFuZ0dPSGxU?=
 =?utf-8?B?Y3RvWDhLTTNOT0xoKy9vaDJvd2hoU0xCdEFMaWZXOFBueVBmQ21TeUR5VEpi?=
 =?utf-8?B?RCtwT044YW5aTlAxb2d2YzZxalVEbU1UamFZdlNDYW81aGZYZnVaaXUyd2VV?=
 =?utf-8?B?NFh6a0JlcXByb1VCVGRPMWFQclZqODVjb2NYOThOaU1SVHRvN1U0Tkp6RHBw?=
 =?utf-8?B?dUhyQnZNVktxYXo0WVRGM3hPOXRySFduY0VRSmI3TU5pdzdKSHlaNnh6aENG?=
 =?utf-8?B?YTN1QVowMlB6c0Jja3orTHlRN3FqNExPTkprd1ZxakhuR2RzMnZQcWxwUkNh?=
 =?utf-8?B?S2VWRnRET1BnK3dlTGZyNmFacVQyalJoaG5RTzBtbjVhWU9sVVk1dUg2YTB3?=
 =?utf-8?B?MVdEWEFGRWRxUmp3ZnhwRnZmQTdNSnhPWVdvaE9NU2xzdWtqaGp1TjI2N1li?=
 =?utf-8?B?SWlLd01jNTlXbDZPQ2Z6ZkQyd2Y5V1R4QnhYR3QySndsRnlwL2ZMb1ZmYmUy?=
 =?utf-8?B?N3h4bEFjZDlqNmNzaUdvS2R3anRuOHVOZ3VnemZsTEZXbzEwT3Z1QkROV3dp?=
 =?utf-8?B?WkFzbnBYNzVOUjRwWHJtRjZDVVlZQUUxZWpJaDJkbzlQL2ZXK203TjBQL3VM?=
 =?utf-8?B?dVpqZUdhWm1ieklGTjNZSlAzbUwrZXlRQ2ZaamRZVVhCSUNvUVZ5VEE0YTJU?=
 =?utf-8?B?NFhxOW5lRytzbHFxcEJoVTgzbFora3hpby8xNXNWalN6VTZzaTg2Y0U1WWhI?=
 =?utf-8?B?MG9GcEhPZkRYYzh4dlB0WXJZYW5EdW5RRWxJZWszVXF0ZDFpcGhrbjZ4WTZX?=
 =?utf-8?B?UTlWc041TGNhaWRQalk0YnNsOEQ4S29IQ2FxcWVLdWFmUVhna05QMzMzK3pn?=
 =?utf-8?B?MGNZTTl3UkdkVm5QUUpmUWM0VlQ3bnlBMEpNbWF1MjV0Ui8vR004bm44TVFW?=
 =?utf-8?B?RFhLWFRFT0c5Y0ZpUWhqcFpmM2pHeGc0ZTBmbVJTOWI5ZnpMcGNKYzNmNHg3?=
 =?utf-8?B?eXY2cWdUL05WQ0hwekJUdE1HYU1JMTNrT3FUVzlpM1pPNitaWUxRSXhVNnRw?=
 =?utf-8?B?MzFYYTRmdERlUWRqcEVSZzkrZmllSVdqWlFtZzNKa2lMWnFHWjBaWGlwdTkr?=
 =?utf-8?B?ZzY1V2hIbEcydWc5YkhQekMxMjJmL2lqQTFvQXhxMU5BUUkwTjNNbjllL1pM?=
 =?utf-8?B?QVZpN1hiWGZiRjdXR2VjNDVDUXNZM3VoQndQMzk5U2hqZEFWVE5uQjI1eDNU?=
 =?utf-8?B?ZjE1NzhOT1M1QTJ4U0FyQ2ZSMld5eGV6VnJXSnNEWmRJTWlZaGxBeFFXNmFo?=
 =?utf-8?B?SytNZEk3eEhpT25qTVU0eVI0SmpTdHNEVllVbmdKeG0weFZ6bHVoNmVPSXRI?=
 =?utf-8?Q?oUt2+b+HO3F9EsfAijsQ1lrYE2DZQ5EVDof2HBfgU6eeq?=
x-ms-exchange-antispam-messagedata-1: l+Rpo5C5Ok0w6n0IKVhFICwkx3rgV4huheIB+EEh7vyKvGvg7eU2vPFD
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2CE43FD8D22344F92F1C7ED4670C0E1@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 551d7da5-86da-4a0d-b737-08da1c9eb103
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 16:08:32.5942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6gwsDPNwB1AynesgDz5aI2rwGLOe/lhyc0XNkpJ0UrwajRXiwyoVT6JdsLyP/KMlvYXGDgHxQXsfRp8zozDJ2BqmFl3Ke1xoAKxHpLyquc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6752
X-Proofpoint-GUID: KlrjF2jDKhnPUZGbW5vuD0Sf1mRQ0O9Z
X-Proofpoint-ORIG-GUID: KlrjF2jDKhnPUZGbW5vuD0Sf1mRQ0O9Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
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

DQoNCj4gT24gQXByIDEyLCAyMDIyLCBhdCAxMTo1NCBBTSwgRGF2ZSBIYW5zZW4gPGRhdmUuaGFu
c2VuQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiA0LzEyLzIyIDA2OjM2LCBKb24gS29obGVy
IHdyb3RlOg0KPj4gU28gbXkgdGhlb3J5IGhlcmUgaXMgdG8gZXh0ZW5kIHRoZSBsb2dpY2FsIGVm
Zm9ydCBvZiB0aGUgbWljcm9jb2RlIGRyaXZlbg0KPj4gYXV0b21hdGljIGRpc2FibGVtZW50IGFz
IHdlbGwgYXMgdGhlIHRzeD1hdXRvIGF1dG9tYXRpYyBkaXNhYmxlbWVudCBhbmQNCj4+IGhhdmUg
dHN4PW9uIGZvcmNlIGFib3J0IGFsbCB0cmFuc2FjdGlvbnMgb24gWDg2X0JVR19UQUEgU0tVcywg
YnV0IGxlYXZlDQo+PiB0aGUgQ1BVIGZlYXR1cmVzIGVudW1lcmF0ZWQgdG8gbWFpbnRhaW4gbGl2
ZSBtaWdyYXRpb24uDQo+PiANCj4+IFRoaXMgd291bGQgc3RpbGwgbGVhdmUgVFNYIHRvdGFsbHkg
Z29vZCBvbiBJY2UgTGFrZSAvIG5vbi1idWdneSBzeXN0ZW1zLg0KPj4gDQo+PiBJZiBpdCB3b3Vs
ZCBoZWxwLCBJJ20gd29ya2luZyB1cCBhbiBSRkMgcGF0Y2gsIGFuZCB3ZSBjb3VsZCBkaXNjdXNz
IHRoZXJlPw0KPiANCj4gU3VyZS4gIEJ1dCwgaXQgc291bmRzIGxpa2UgeW91IHJlYWxseSB3YW50
IGEgbmV3IHRkeD1zb21ldGhpbmcgcmF0aGVyDQo+IHRoYW4gdG8gbXVjayB3aXRoIHRzeD1vbiBi
ZWhhdmlvci4gIFN1cmVseSBzb21lb25lIGVsc2Ugd2lsbCBjb21lIGFsb25nDQo+IGFuZCBjb21w
bGFpbiB0aGF0IHdlIGJyb2tlIHRoZWlyIFREWCBzZXR1cCBpZiB3ZSBjaGFuZ2UgaXRzIGJlaGF2
aW9yLg0KDQpHb29kIHBvaW50LCB0aGVyZSB3aWxsIGFsd2F5cyBiZSBhIHNxdWVha3kgd2hlZWwu
IEnigJlsbCB3b3JrIHRoYXQgaW50byB0aGUgUkZDLA0KSeKAmWxsIGRvIHNvbWV0aGluZyBsaWtl
IHRzeD1jb21wYXQgYW5kIHNlZSBob3cgaXQgc2hhcGVzIHVwLiANCg0KVG8gYmUgZmFpciB0aG91
Z2gsIHRoaXMgY29tbWl0IEnigJltIHBhdGNoaW5nIHdpdGggdGhpcyBzZXJpZXMgd291bGQgYnJl
YWsNCnNldHVwcyBhcyB0aGV5IGFwcGx5IDUuMTQrIGFuZCB0aGUgbWljcm9jb2RlIHVwZGF0ZSwg
YnV0IHlvdSBoYXZlIGEgDQpnb29kIHBvaW50IGZvciBjZXJ0YWluLg0KDQo+IA0KPiBNYXliZSB5
b3Ugc2hvdWxkIGp1c3QgcGF5IHRoZSBvbmUtdGltZSBjb3N0IGFuZCBtb3ZlIHlvdXIgd2hvbGUg
ZmxlZXQNCj4gb3ZlciB0byB0c3g9b2ZmIGlmIHlvdSB0cnVseSBiZWxpZXZlIG5vYm9keSBpcyB1
c2luZyBpdC4NCj4gDQoNClRydXN0IG1lLCBJ4oCZZCBsb3ZlIHRvIGRvIHRoYXQ7IGhvd2V2ZXI6
DQpXZeKAmXZlIHRob3VzYW5kcyBvZiBob3N0cyBhY3Jvc3MgdGhvdXNhbmRzIG9mIHVuaXF1ZSBj
dXN0b21lcnMsDQp3aGljaCBhcmVuJ3QgbWFuYWdlZCBhcyBhIGNlbnRyYWxpemVkIHNlcnZpY2Ug
KGN1c3RvbWVycyBtYW5hZ2UgdGhlbSBkaXJlY3RseSksDQpzbyBkb2luZyB0aGF0IHdvdWxkIHJl
cXVpcmUgZWFjaCBpbmRpdmlkdWFsIGN1c3RvbWVyIHRvIG9yZ2FuaXplIGEgZnVsbCBwb3dlcg0K
Y3ljbGUgZm9yIGFsbCBvZiB0aGVpciBWTXMgcHJpb3IgdG8gYW4gdXBncmFkZSB0byB0c3g9b2Zm
IGhvc3RzLg0KDQpUaGF0IHNhaWQsIHdlIGFyZSBtYXJjaGluZyBpbiB0aGF0IGRpcmVjdGlvbiwg
d2UncmUgc2hpcHBpbmcgYSBjb250cm9sIHBsYW5lDQp1cGRhdGUgdGhhdCB3aWxsIG1hc2sgSExF
IGFuZCBSVE0gYWZ0ZXIgcG93ZXIgY3ljbGVzLCBidXQgdGhhdCByZXF1aXJlcw0KY3VzdG9tZXJz
IHRvIGFwcGx5IHRoYXQgY29udHJvbCBwbGFuZSB1cGRhdGUsIHRoZW4gcG93ZXIgY3ljbGUgZXZl
cnl0aGluZy4gSnVzdA0KbWVhbnMgdGhhdCB3ZSd2ZSBiZWd1biB0aGUgZmVhdHVyZSBkZXByZWNh
dGlvbiBub3csIGl0IHdpbGwgdGFrZSB5ZWFycyB0byBmdWxseQ0KYmxlZWQgb2ZmIHdpdGhvdXQg
aGF2aW5nIGN1c3RvbWVycyB0byBtaWNybyBtYW5hZ2UgZnVsbCBwb3dlciBjeWNsZXMuDQoNCg==
