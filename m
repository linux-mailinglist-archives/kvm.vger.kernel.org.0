Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04DF4FC52C
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 21:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349682AbiDKTiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 15:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349678AbiDKTiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 15:38:16 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4D01D307;
        Mon, 11 Apr 2022 12:36:00 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23BHe2M4022558;
        Mon, 11 Apr 2022 12:35:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=gW3N2LhZzagP1MIw0V0XBYEJqiVTSBD9mWeoRYp3sek=;
 b=m2+Ra9OB9wx2ySywwZ1Ge//XadTQzDLhYQwjGhteNoBtEv7m6yaL4Kgo3E3ClOZZdzN9
 Kr9PFeEocShWHeQAcxNOrk9HQanP9BuMzHaFj5T44Kg3wAa1C+L0S55UC6aJxgG92461
 4H985p6k7pCaOVwihb3Dz+Xlx2o1Ll0aQlbv4knvWjlEo7l6f1Kd/LKqX5gx+RL8+CYi
 1xLLUeTV71dsQJNlPtH89CtkRZmHhaFjaqypt0v8wGQuR1/YVPo+W115MsD1PhdU+Maa
 a2Dfb5iLa+dszalMVLewbfYmKh8nggkiAGKYoI21Hn77g6IwT7zObTbXIjE+vdgDruw6 5A== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb97dm8gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 12:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMAh0fRp8eQJsZLbujTrU+XaUheyTiWBFj9y6psFXi0CxDE06M36We4sH0g1ktdPtD2gF3f6mOZpuX437phej3RMTWFo5K30LaKg5+b9C6Sj0AUuNHYssNu9G8UCqSTog87uAcikYXpGjwKncFc5Uzynt4bN8eLj2PVbbYMP/3qxpvut/BP9CHaNWuL8JfLZWw/izggE5FhgMay9Q+OxJRfGKu/WwM3waXUbX0ZVV0iUCQ8bbRM0Iv/i07SH4gazeoHqgVM/cycOlLsqJ3Dv81zu8xySZOTufXiSnZPYTyaADkTSTX1v9SV2anNMXfZUbbNkjDuqoAeg4B+VUGvDQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gW3N2LhZzagP1MIw0V0XBYEJqiVTSBD9mWeoRYp3sek=;
 b=aDZdPP/s2DgjnN1jXHUEYKKfZItPJEUqOGAO2scWWrLySrGIo3nlmaSoxv5jxjfamSf2C1wCTz9QdJexWfeorbRosZPb/llCulbMBA3cvi0/l2yrwtU3MaH2vW/BxFcl9HDes5lqTvFSwYbZO88jJAkyo8eStqt68NViaf2yy2PIG/+vgrJzqPARLXsPBQJ4YZduXPEURwkdcoEk9zPa8gdVt8mwTNDt4vdE5raDYA4l4tdEEUfAxqPtrKheticccwg248RSWzGCvyOS2FDpYiooDUxCkcHwBIF1tj6Egdvd42Zj8LFE3Yb5ujm6Qd8ScusFydZCGkjR/Paw6QjchQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SN6PR02MB5680.namprd02.prod.outlook.com (2603:10b6:805:df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 19:35:37 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 19:35:37 +0000
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
Thread-Index: AQHYTc5N3PtRLPD03UaoXnwsq2NUS6zrGJQAgAACcQA=
Date:   Mon, 11 Apr 2022 19:35:37 +0000
Message-ID: <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
In-Reply-To: <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac5aa270-7466-48ca-9a89-08da1bf2748b
x-ms-traffictypediagnostic: SN6PR02MB5680:EE_
x-microsoft-antispam-prvs: <SN6PR02MB568028B619B48AB79E27789DAFEA9@SN6PR02MB5680.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rnJxL1kHys0TJVhSg19T0mHwVWk/nzRfb7IAzuDeO2w6iV4eTippEX25ijuOV7N9pDLulU/gBfAOUU/yBCEtMMtxAMx9hr7VlBxsFSYbHQQeRkV/MRco4I6KWNkUUBi0FXbhRB6Z3nZyFU5X+ramdlitXDioTVpXDZ22pm+aEa+PBP5/c6gYbbS9U5kfSF58FukwjENcorcL4J4lbQBL6xS7t9dI8Tjf8epDxNUadS9GE6alYU4MngE0VszAmzTe261T9YyAMZjkVZ40hv6sLSScpxglGTF+EXP/HvDLDH3We8Ieh4PgyWisLbAIndv6kNaY69Vg2KUZkNJrWeTmCog7tmGarVyO1V5RnnIBluxQqDDKjqMqx5Fa9499/WozoyCLS0a0V46hSIK5aXNz4q4/RfcszFRdokwTmR3S7znVNfkKRpVmcXv/KCrXY/LWAYW3YEnmVtdcUnVZfQg4HuZ1bF+3lWsklBLV+gkRSOcY1LLenhHKt+ZwwYPallwWvS3EWUpPDRoM3lQtNFdM0ymHCfQZegR7Z2k0Wr73CDX0aGEUmlSTmswZSCpVShAhx5zNsHx2yIUa0oJNzZhz/rZJc5rnh7bu4UCpdFMa1/UOsEr/9CpFEmnyzFvc/gW9z6kLCv01QBCr6Cy4Iex/62qLrDIFtptlNVb/dLn6Xopcy8y9eJkTaZtK0jfpFN57O2gccEK5aBqfXf0B/mRdECs8J2rfIb0tMTDNCWQJqBgcpwIMeW58IfNqPaviDVkg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(53546011)(2616005)(6506007)(186003)(64756008)(66476007)(66946007)(4326008)(8936002)(8676002)(66446008)(66556008)(2906002)(5660300002)(7416002)(71200400001)(83380400001)(76116006)(86362001)(91956017)(508600001)(6486002)(6916009)(316002)(54906003)(33656002)(38100700002)(122000001)(36756003)(38070700005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGFDbndWMHEvaXQ5T1JWS2J1NENwLzNUWVJsVU9QVFBaZE5xdlNzdGcyclZy?=
 =?utf-8?B?ckMwRWFzNXRJR1gwY2FDZ28rbjhPZjFvcFVNU0tkcmJtN01OK3VJMEd1aTJk?=
 =?utf-8?B?cGo2NmF4Nnh3WGpZWHEvdEdHTlU4RG0rNjdmSitmVHhpM3NleTBad05TWnFI?=
 =?utf-8?B?YU9nQW9NdWRZK3QwdEFaOWwraCs4bjFTU0t2ajM0QTU1OW85OTA5WHB3VTNk?=
 =?utf-8?B?NmliVFduNkRnZDBqQ0ttcktob3lOM2puQXhGblhReWk2TUk2c1JCbXZsZFp2?=
 =?utf-8?B?S0FZcGQzTllUZlRtK1hKS3hRWmxZaVEyWDlGRE50R2tyaTlBbEJqb2Zub1Vw?=
 =?utf-8?B?alUvMGwrR1R6NC9KanNBM3I1V3NWQ29IZDl1cGxMMVFGVDVqdXFsZXd1dVVi?=
 =?utf-8?B?d0N3MW9RWituaHJWS3puRzlxN0tZRmY4V2FaQWZDeE9rdUFobGdZWmNQMjcw?=
 =?utf-8?B?QStoOEhSdDFvTm9CZFArMVU1QlpzTUk3RHdXdk56SFZTV25ob21oNlk4WTZX?=
 =?utf-8?B?UTV4U1IxdWxUTThvMlJxV2h4dzUwelRHR3RicDBKZk5lTVBJVlZxOWlTbmwr?=
 =?utf-8?B?enZybyt1ays5ak9URURYWVlZYUtjMzc5K2M3QllVaHNrTGdXOWFDSlIxdWcw?=
 =?utf-8?B?Wi95R28zdmZSNTVzSjdRcFg0azhhQTNKeW9oREVLN0tiRjgxa1hxcTR1ZVRr?=
 =?utf-8?B?dHY5ajhpZU9jUEVRNWQ3ZC9hK2M0bGdQSTBTdERjOU5qRGZTL05pS010TDNj?=
 =?utf-8?B?cGhPY1ZNWi9QbGxkTHJ1R3BHQURIWGNiSnEyYmRtZ25DMlVUVEZucDQ2QThC?=
 =?utf-8?B?bEpEVE9nWlI1Q1dmanBYR1Y5TFRiTU9qVmNGNWVFV040OWdMaldITFNacUFR?=
 =?utf-8?B?NUxzVUF2RFgvdDF1WDZKeXJOWkNlYnhVKzlWR05GdHZOSTErSmhFRTBVdFVo?=
 =?utf-8?B?T25LaXVrY1NXQXB0NG5OL20xaFFFUmd0S0o1Wk9PbjVCazlhNVFNVDM1bDZ0?=
 =?utf-8?B?ZUpKR0ZITGZ1UFVSQXFEMUZKREM3VCtyT0NhY0ZkNWpYRHZuMGRjV1Faby9J?=
 =?utf-8?B?ZmxWbUZnamhEdmZUVitwT2NacFVOVVRxdDkwVTdUc2E2Sy9STDJlcy9yM3Vv?=
 =?utf-8?B?K0NTZ3Y5dUZwdFJ5Ymxucm1kYXJGRlg2ZUJNV0pYSUIvTFdHRVZzalMvd3dV?=
 =?utf-8?B?OE1zYlllRzQ0M1UxVkRhQis3b2lJcUdIdEdBQWxJRnFNVm14U2IyQWhQNXl0?=
 =?utf-8?B?cFVIRURHUHI3NEVZS09tb2RGK0w4eVAyUTRodFNxVjJyMGpyZTFmSFdrMTdm?=
 =?utf-8?B?cVB1eEdxdWdrYllFa0RwUWRFUkdMS2RmRmtjN2czd0NvSmk1K2JaeEZpaXl1?=
 =?utf-8?B?VUQzN29DT1lzeHVjSHhxK09ZTUZaU05rc2tOZDhCMnlsSm1HbnUwQ2NsYVZ2?=
 =?utf-8?B?TTErNDlkdGxFTmxyODdPRlIxSmg1Z2F5WGlkanpWTUxXZVlvSTJhNHBEcHlP?=
 =?utf-8?B?TENIdlNtU2RNbmZyYlRielZXU2pxbUZJSlR6VXZSYmxhQ3ZNanl0Z2RFQm1O?=
 =?utf-8?B?NHZvNnVWeWV0M0k5TCtnVGdocGNybDd0TEdEeWpHbzlBY3VqSGpLOEhZc1hM?=
 =?utf-8?B?QTFNZ2FYRDc3VmcvbVNzNnZGVUp6aXVVaGVIbEJvOWl3S2tUaWVzc1ZwaXcv?=
 =?utf-8?B?TXZaS0gzSHZyRUVCYlE5QkdJWXZyWmhPK3VPV2xqTFdyRmJjVDBXZDdqOTN2?=
 =?utf-8?B?bFhYcGk1cXR2bHY1eG1XQTZHaitZbVF1UXRaM0U0QjI3UzRwQTcrTFd0TG1F?=
 =?utf-8?B?b3RFcVF4cHNwOW9lWENRbzFHKzBxVzhUNm9vdEtDYTZFd0RBbXA3Uk9UdVBr?=
 =?utf-8?B?YnZPQVBtbUtxUGprS09xZWhBYWdWYklHRmJFTWE4UWZkYm51VVV0aHJ0alFD?=
 =?utf-8?B?Z3JhTkxvRmtYMzZOeURRQ3kvTW1CWE9rc1RYdzZOcGgzSHlBQWtZWC93ek9U?=
 =?utf-8?B?Y3RVWmVMNFprZ3dTRHk0djNDR01FUSt6dU83TyswTXFWOEFoQkZ2Q2w1RlEw?=
 =?utf-8?B?b0FjZWo4dEdsNFFUeDVxS2F3N0dUcUtoUXNoSjlYQWEzVzdDS3RsVjJxay83?=
 =?utf-8?B?M2RXVFhmRkJ4bGlrVUx6Qmp0SVRoRDBxWktKWjluc2VPc2JkVDhiUDNZWjNr?=
 =?utf-8?B?SUJ1OUxzV2JVWU91cGd5Y0QxdmEzNWtCVUNNdXZ6R1NyVmFlWTJBNGJNU2Js?=
 =?utf-8?B?RWtqbzZ5VmVoMXl1bFZOSHl6SkFyYjBXVEN2MXhiS0JuUFk1cHhFaVpRNGVP?=
 =?utf-8?B?Nm54SEhjYU5odmdoOFBZUWpENUorNHhYQ2ZnRFhGOU4wMldUMnkvZzFhV2p0?=
 =?utf-8?Q?AlJ8390uakt/5LJxuYyBL8BqSFOZT/ESN69eetbcfasdo?=
x-ms-exchange-antispam-messagedata-1: 6mbyprjRUL1kN7qt3z8hx8tV5dpXIYCeBJdyFVJNiSrhzpHReAdf0X4a
Content-Type: text/plain; charset="utf-8"
Content-ID: <B50C4D15F9AA8A49A9DB3A8D76A72798@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5aa270-7466-48ca-9a89-08da1bf2748b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 19:35:37.7063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nMHpGHfVGn19HkfMVgAmuHXeLBJJGqc+wY/WzrXoPkWgzAom6DDAIIfpzDw2VE7NIhcI/Eqyu4gcPuygPpW73IXUCyBAJR0nVTmrRpoEDrY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5680
X-Proofpoint-ORIG-GUID: 5jV3mqgHBvKd948_WswspKbAMZh4WONd
X-Proofpoint-GUID: 5jV3mqgHBvKd948_WswspKbAMZh4WONd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_08,2022-04-11_01,2022-02-23_01
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

DQoNCj4gT24gQXByIDExLCAyMDIyLCBhdCAzOjI2IFBNLCBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5z
ZW5AaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIDQvMTEvMjIgMTE6MDEsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+PiBzdGF0aWMgZW51bSB0c3hfY3RybF9zdGF0ZXMgeDg2X2dldF90c3hfYXV0b19t
b2RlKHZvaWQpDQo+PiB7DQo+PiArCS8qDQo+PiArCSAqIEhhcmR3YXJlIHdpbGwgYWx3YXlzIGFi
b3J0IGEgVFNYIHRyYW5zYWN0aW9uIGlmIGJvdGggQ1BVSUQgYml0cw0KPj4gKwkgKiBSVE1fQUxX
QVlTX0FCT1JUIGFuZCBUU1hfRk9SQ0VfQUJPUlQgYXJlIHNldC4gSW4gdGhpcyBjYXNlLCBpdCBp
cw0KPj4gKwkgKiBiZXR0ZXIgbm90IHRvIGVudW1lcmF0ZSBDUFVJRC5SVE0gYW5kIENQVUlELkhM
RSBiaXRzLiBDbGVhciB0aGVtDQo+PiArCSAqIGhlcmUuDQo+PiArCSAqLw0KPj4gKwlpZiAoYm9v
dF9jcHVfaGFzKFg4Nl9GRUFUVVJFX1JUTV9BTFdBWVNfQUJPUlQpICYmDQo+PiArCSAgICBib290
X2NwdV9oYXMoWDg2X0ZFQVRVUkVfVFNYX0ZPUkNFX0FCT1JUKSkgew0KPj4gKwkJdHN4X2NsZWFy
X2NwdWlkKCk7DQo+PiArCQlzZXR1cF9jbGVhcl9jcHVfY2FwKFg4Nl9GRUFUVVJFX1JUTSk7DQo+
PiArCQlzZXR1cF9jbGVhcl9jcHVfY2FwKFg4Nl9GRUFUVVJFX0hMRSk7DQo+PiArCQlyZXR1cm4g
VFNYX0NUUkxfUlRNX0FMV0FZU19BQk9SVDsNCj4+ICsJfQ0KPiANCj4gSSBkb24ndCByZWFsbHkg
bGlrZSBoaWRpbmcgdGhlIHNldHVwX2NsZWFyX2NwdV9jYXAoKSBsaWtlIHRoaXMuICBSaWdodA0K
PiBub3csIGFsbCBvZiB0aGUgc2V0dXBfY2xlYXJfY3B1X2NhcCgpJ3MgYXJlIGluIGEgc2luZ2xl
IGZ1bmN0aW9uIGFuZA0KPiB0aGV5IGFyZSBwcmV0dHkgZWFzeSB0byBmaWd1cmUgb3V0Lg0KPiAN
Cj4gVGhpcyBzZWVtcyBsaWtlIGxvZ2ljIHRoYXQgZGVzZXJ2ZXMgdG8gYmUgYXBwZW5kZWQgZG93
biB0byB0aGUgbGFzdCBpZigpDQo+IGJsb2NrIG9mIGNvZGUgaW4gdHN4X2luaXQoKSBpbnN0ZWFk
IG9mIHNxdWlycmVsZWQgYXdheSBpbiBhICJnZXQgbW9kZSINCj4gZnVuY3Rpb24uICBEb2VzIHRo
aXMgd29yaz8NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3LCBEYXZlLiBXYXMgdHJ5aW5nIHRvIG1h
a2UgdGhlIGNoYW5nZSBzaW1wbGUNCndpdGgganVzdCBhIGN1dC1uLXBhc3RlIG9mIGV4aXN0aW5n
IGNvZGUgZnJvbSBvbmUgcGxhY2UgdG8gdGhlIG90aGVyLA0KYnV0IEkgc2VlIHdoYXQgeW914oCZ
cmUgc2F5aW5nLiBZZWEsIEkgY2FuIHJld29yayB0aGUgbG9naWMgYXMgeW91DQpzdWdnZXN0ZWQs
IEnigJlsbCBzZW5kIG91dCBhIHYyIHBhdGNoLg0KDQpBbHNvLCB3aGlsZSBJ4oCZdmUgZ290IHlv
dSwgSeKAmWQgYWxzbyBsaWtlIHRvIHNlbmQgb3V0IGEgcGF0Y2ggdG8gc2ltcGx5DQpmb3JjZSBh
Ym9ydCBhbGwgdHJhbnNhY3Rpb25zIGV2ZW4gd2hlbiB0c3g9b24sIGFuZCBqdXN0IGJlIGRvbmUg
d2l0aA0KVFNYLiBOb3cgdGhhdCB3ZeKAmXZlIGhhZCB0aGUgcGF0Y2ggdGhhdCBpbnRyb2R1Y2Vk
IHRoaXMgZnVuY3Rpb25hbGl0eQ0KSeKAmW0gcGF0Y2hpbmcgZm9yIHJvdWdobHkgYSB5ZWFyLCBj
b21iaW5lZCB3aXRoIHRoZSBtaWNyb2NvZGUgZ29pbmcNCm91dCwgaXQgc2VlbXMgbGlrZSBUU1ji
gJlzIG51bWJlcmVkIGRheXMgaGF2ZSBjb21lIHRvIGFuIGVuZC4gDQoNClRoYXQgY291bGQgZ3Jl
YXRseSBzaW1wbGlmeSB0aGUga2VybmVscyBoYW5kbGluZyBvZiBUQUEgb24gc3lzdGVtcw0KdGhh
dCBoYXZlIEFSQ0hfQ0FQX1RTWF9DVFJMX01TUi4NCg0KVGhvdWdodHM/DQoNCj4gICAgICAgIGlm
ICh0c3hfY3RybF9zdGF0ZSA9PSBUU1hfQ1RSTF9ESVNBQkxFKSB7DQo+IAkJLi4uDQo+ICAgICAg
ICB9IGVsc2UgaWYgKHRzeF9jdHJsX3N0YXRlID09IFRTWF9DVFJMX0VOQUJMRSkgew0KPiAJCS4u
LgkNCj4gICAgICAgIH0gZWxzZSBpZiAodHN4X2N0cmxfc3RhdGUgPT0gVFNYX0NUUkxfUlRNX0FM
V0FZU19BQk9SVCkgew0KPiAJCXRzeF9jbGVhcl9jcHVpZCgpOw0KPiANCj4gCQlzZXR1cF9jbGVh
cl9jcHVfY2FwKFg4Nl9GRUFUVVJFX1JUTSk7DQo+IAkJc2V0dXBfY2xlYXJfY3B1X2NhcChYODZf
RkVBVFVSRV9ITEUpOw0KPiAJfQ0KPiANCg0K
