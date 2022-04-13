Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A714FF708
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbiDMMq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 08:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiDMMqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 08:46:23 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E66205F8;
        Wed, 13 Apr 2022 05:44:02 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23D7ADKw016149;
        Wed, 13 Apr 2022 05:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=vbcvuf+cN43GaXfMR48g2yqP8b8OYZGnMzI1U0qN9n4=;
 b=kbJvpAn+4UYwIa80vqTmaoKIIOcxKaPhX0rtn0lDdB5kYHxyJoc8irXUGfqakvrP5Vtx
 AvKtoEArIL6ahTscRMVyiGeual/6AJjm8NQ3dIdiZvPAP0s9cUtuQIPcx4Xup3bjt2N1
 ecfJ6OwL0TVnHkPOcuvCb4/0AnRQ8i8Ljo3VYIhjof2TUtjnmvLiuKEetP6327/7omcC
 W7U06WO2o4z2uT71ZEeToEDAIlqUPaYX3OlKFIQ2USMKYyrheq8+MSqV3zsCls5Hbl/U
 +Paegadjqw6iylszJWE/eq4dcCwdzhCjnkUvxxtKY9kLHM6QAGuYeQ2RuWMUGwoCGUGs 0A== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fb9ny0tbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 05:43:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zir9PGgC7hpZAyE+qSO2uZCiMVVaxC1WrVRbMPuZw9JHvzF4sgwTqI/G0fFBcEUBRB6vGcSdKjDxDUl1DwsskpKD2v0T1ksMweo+R7H+V/IQQcL4JeVBJRxrMik3uerHO7q/MVXenW9E5to8AHC+lfcNBAEMcQ2uyusVHW0fyryTkEFV9OFPt4DKRKz69selnUV4PD770sCnrwHW7WZNDV/j5FTUrrS/OdhsMxUL5zPZXUwGuXmRZsH+Z22/KpZwlk3cYcluwWlSd4XOIzTCVYrrg140uIWZv0/QGnYunfo19yBrpwPFAG7jJXO4ftE5kfDtkcxEZ1g2D7oGDxSV3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbcvuf+cN43GaXfMR48g2yqP8b8OYZGnMzI1U0qN9n4=;
 b=kRzk5NVI11Pvq+ysvLcQp+Pp54gZVbjVxKA5goKF9Vch2gFJkSB7lbnzHpk5DpE8DtWIOWHul8IC6GF3xiLkIH+7epIZvbD+imggayCW7QMty0W3Nvai9Nx5s1nbCUWo21GrGBMZQHu49H3JjGzOXsBZXbcs2l7Gz3CYoQ2FpNcK683tC0k3S5Tv2ql6yWINXNNFkliZaICxquKL3qgqhUkBEII2KLH304ExXTtfdTxe2Lbvqc9RPRmqCk3DVpKpB6n4QZn00kIz+KBi/K4LDXZjhFIBN+sREf36FrAAG8rHenx0xE4RCLzwNM4/3VhMGuOyIHeHF1n/LtWUdR8OBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by DM5PR02MB2634.namprd02.prod.outlook.com (2603:10b6:3:3e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 12:43:24 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::b970:801c:2b4e:d3cf%4]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 12:43:23 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC:     Jon Kohler <jon@nutanix.com>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Topic: [PATCH] x86/tsx: fix KVM guest live migration for tsx=on
Thread-Index: AQHYTc5N3PtRLPD03UaoXnwsq2NUS6zrGJQAgAACcQCAAEXKgIAA6CmAgAB2foCAAQ0KgA==
Date:   Wed, 13 Apr 2022 12:43:22 +0000
Message-ID: <7061BD1A-A206-4087-ADC9-055776251430@nutanix.com>
References: <20220411180131.5054-1-jon@nutanix.com>
 <41a3ca80-d3e2-47d2-8f1c-9235c55de8d1@intel.com>
 <AE4621FC-0947-4CEF-A1B3-87D4E00C786D@nutanix.com>
 <e800ba74-0ff6-8d98-8978-62c02cf1f8ea@intel.com>
 <1767A554-CC0A-412D-B70C-12DF0AF4C690@nutanix.com>
 <20220412204025.evmoxjr5beqindro@guptapa-desk>
In-Reply-To: <20220412204025.evmoxjr5beqindro@guptapa-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6be0821-b102-4eaa-efa1-08da1d4b32b8
x-ms-traffictypediagnostic: DM5PR02MB2634:EE_
x-microsoft-antispam-prvs: <DM5PR02MB2634E5AEA01B88F08F80DB6BAFEC9@DM5PR02MB2634.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y4ddLpXe0+yuay34dOO0rJcVY0XFlqpm/6q1xe8ZhUflGYNhdRT26DV+Gt/Y8NvVhg5MgVFJGEKwg3ofUZSJChs9yiMQeyGDwl+NqYUGJi4dT3AfLfN/AiI1PC2Z73PA9oH9FQmSSniu64H2IX2Stwru+G666dF+54Mpw+n8P8cKsalmTjigQfP27En8AK4XH2h4MK471wBKedlZji+3lZJVE0m9vN4Dt6PNIUOFqdZY6EqDFlz1JhPVfh70X2VC3++2FovrSI4OqccwLf3lIjw5V4hnvw6iCICd408i6Ok1UC2OZwd1AkCrmUuODWfmV9RN/PsnTbk9ScAVq1J6+wqlufeSUrOJXllEHoburpbqPYDMTAy56TjBWkdLcgiMmVbpDczp/+s+qMsjiQu4v/68w2cYPvZzKxboZZkimRopWWDrb5oOljU6PocbpXn1+Uxl8vu9b4yfwRfPFHDG2wlx+dnRDVbh47Nbg4/s9kHLVlLg9hmNJFw2sk1Aei3Db1DBQfI7GNiAFFBk/UJXBJqcnmDamK/Kns7TtCiBrvhTtIh8gX/nyeASv0UWL3ujIRP59VDu7V5HeOxelY9INFUSDGfA5R7jPVvQMO6QhF1kun9GcNDal42zEygIEKgryLWd0rP3AmCszIu4MnDRU+OHS1WXWgyWaASvHD0mOXqDOb2FJDkXTNK5waJ/GBOwXrl3F/key47dolat7EnV3rgHf5YemFDWoAR67Imk2tSz0fatMa+Gm18mlZP4gm8WqQVDQ2mXUAIEh1JrYxjhn/EWvu6vEI648p04v/4Mpj+l38LH68wsTMXqnRDaWcFWDM/rDfczP3Uwv30tKjiJXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(38070700005)(186003)(71200400001)(966005)(6486002)(508600001)(6916009)(316002)(6506007)(86362001)(54906003)(33656002)(6512007)(53546011)(66556008)(66476007)(66946007)(64756008)(8676002)(66446008)(4326008)(91956017)(76116006)(2906002)(36756003)(38100700002)(8936002)(83380400001)(7416002)(122000001)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0ttV3VKM0l5aTljRklYS1BUaTloa2ZpTTdZZ2xjZ2d6cEpKV1RlT2ZnNmRG?=
 =?utf-8?B?czFFTnprZ1VpZURYdVR2ajI3eWNsRkxtbHc4SHY3UHJISHFnYnpud2hmTzNl?=
 =?utf-8?B?eFN1MlBiUXNFaFIxTzJ3eU1hbjlZWXd6bnM1bWZEc1plTStDY0JzRnl1MFZZ?=
 =?utf-8?B?Wm0zNkpFNWU3cHkxSnU0dmo1dXd6KzVQRVF5LzcvbWhPYVV0ei9ZSzMrQUla?=
 =?utf-8?B?R2ttNEpBd01pQ0VUSnRIWUkyK1FJMXczSWl3WUZDL0VJYlpURUtDYURqK0JK?=
 =?utf-8?B?emN3d0pUa2tiWHVxVDgzclBoRWtVM1EvM0Q2N2RNN2JaSVFYVml5QUhpNGtk?=
 =?utf-8?B?VHozb216RTVIdG8wcFU5eG8wZmw3Nk8wVndPNGR6c1BwZ2JlSU1aaWlEUE5n?=
 =?utf-8?B?RVRGNEgwa0xEL25SVUFrNldXTGdGYS9yL2o3TTd0Y2VoTmtmSUN5ajlRZ1B3?=
 =?utf-8?B?VWhRVU5qVjc0eXl2eUpLVlhXNUo3cHIxbWNtM3FsMU5Hb1RVeFhDUkVzSk8r?=
 =?utf-8?B?OFY0YTk3bFVvOXBzOGkyQnkyUW1MV3dnbmpVc0dINDlqbHhRbU9OclB2Q0xF?=
 =?utf-8?B?V0ZzeUVNeG04d3lkdkt5dWN1SUxXWTBsQ25YczBKRVhicjBKcXFUY2gxQk44?=
 =?utf-8?B?M1hGSFp1d1BGc3p3Vk50bWNyWDRmYkVYK3U0Z3FtdHVVQTBKN2pkMUh6djB4?=
 =?utf-8?B?VmY4RU1JM3gxNnI3NUJIVGVCVXRWTnJRditoVWF1bFY4RE1WM3lwdVQ4dFFI?=
 =?utf-8?B?L0o1ZkUweFFnV0h5LzE3cXVtYktQY1M1ZzJuNzR6eXo3WjFxcW1TUXZyK2Fa?=
 =?utf-8?B?cEpBdlpGNk00a1hkQXhyZ3ZwQUdkbmxLZmJyZ0xoMXk5UitxM1FtNDdWd09n?=
 =?utf-8?B?SSsyWXNoODR2RXFWMFZvYndVMFhTRkV2UEVINDlPcmh5a1RnaEVPZFBUVlAv?=
 =?utf-8?B?d2tyOHJKMUxFcmNFZFNOUnhyamJpN0ZYWThpM3BHWDRkSWlaa0s4cm5iRUZ0?=
 =?utf-8?B?WHpFU1M2RHVsUVNlRG1nTVpzK2pzRG1TVlNscG1GYkhFMHF5SzZTYlNqUlha?=
 =?utf-8?B?OFcwVmtsd1U5V1lFTU1zK0lmVFZqYk0yY2l0SGJSdjJEYzRvUDlDbzJsclIz?=
 =?utf-8?B?ZTNmRno4aENIdmhGRmlma2k0U1ExdGhucG94Nm9XZzlGcHVlVlY3WjY4TE5w?=
 =?utf-8?B?SkpjUUZxZUt6RWlqUXlhUGhPSFFNUFdjci8vVy80WE1NUzY1SzRvVkRBT0Uw?=
 =?utf-8?B?cFpORVBVZFFKeXYxTmpWbVdGZHZ0cFpLOEkyV1JpcXAxNlJmUWQ1UjVrc3g1?=
 =?utf-8?B?eEZOZjRFWnpqVm8wMDFEUVpGeTg4UU5rRW9hYUVaU0xJaVBnaXFUdXkxbEpY?=
 =?utf-8?B?UExreUNua2V5QmhpQkZ1RHJCd0hLYkhHRTZwckFnWmVGSzNINXM0QTdjZ2pL?=
 =?utf-8?B?RktmVUtHUWtUeUc0TUovVzlBOTMrb0tGaWZRVFQyWUZGQThySVFzT1lBcDc1?=
 =?utf-8?B?bVE1UGZrRWlBSFp3QnYzNjd3cXZuOENtNm9VMENQM3ZtOWNKWDBONGF4SDRh?=
 =?utf-8?B?d2d4bmwrYURlN2hIemtjZ0ZjVWpKUkJVcmd1L3JTYTV5RzZDSXhBaDZGY0NY?=
 =?utf-8?B?djFZZWhqR3N1UVR5eDlVK0E1RG5ZMGdvV2U3d1M0WWZVb0RhL244bW1Ja3Q5?=
 =?utf-8?B?Vkx2c2lkVTR5WUt5aHUvZE5PdXJ5a0NNdnZxQXF4Q2FPMkJaU3hSeHFwbnRw?=
 =?utf-8?B?cUwzNXRVdVVFMHhtdXA2T3ltcTl4WVBnOWJOR2pmeFZjSU42d0hmNjZINExR?=
 =?utf-8?B?MHhrZkNzQTBSUmVpU1BWNFplMDI2V0gvNzNlYXo4L29lUEFpRm5lVFZZTndx?=
 =?utf-8?B?RVJzRlRIb203LzBDeXdPT3YzaDBIVDgxRVI3MmFuU1BQRnBGdEpvNHUrTzBX?=
 =?utf-8?B?MFlHV2lvTU5CTW9QdWhFbllaMkVmSC9ZRjZYaGY5MGNlNTRpUlBiODBkYmhw?=
 =?utf-8?B?NHFMd21PTzBvOXE3Qkhsa3FHclpNVjROKy9Odm9SY3JEb2s3TG5ZbzFTYTAx?=
 =?utf-8?B?YmlTMnROZWhmeVlhTFd2V3dia0h0NGo3eFRnZ2dBcGthYXA3ZEpiUWI4ekVB?=
 =?utf-8?B?dEc5RnFQMElhcDV3UVFQY3lYR2k4ZjBJQWdMQTZKSVdJOU9YOEFOZk5BZkMr?=
 =?utf-8?B?Q21vVld4am1yb0YrcHo0NTNwSGx2MWFMWEZKN3lHbmpYMzFjVHlIaHlUZ3NE?=
 =?utf-8?B?NFZTRTd5KzZDb3g3TTIweml3Z3ZQOS9lUWdQMTBESEdDd1hsamRxdlYvSGds?=
 =?utf-8?B?Q2tWWkM3YS9wS25tM1hOVWhYQzdkcnZyQzg3ZElPdnVtY1k5aU5RdWlvWDk5?=
 =?utf-8?Q?VKpa1l+2zrzf3E3//65BCp0AsVeSbxol6yZQUyTQz2heD?=
x-ms-exchange-antispam-messagedata-1: eZXCGuCkzc9afpVpvJYpS7xic7f7uRWvHA4tjwt0bEEF40mvno1rAS7L
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9CA89D9683F964D97AD53611ABF3CC5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6be0821-b102-4eaa-efa1-08da1d4b32b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 12:43:22.9111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ibPa8iJaVX2aR8IVYQfac4nSYSskfqjqZw08uP6J9l/Vqb/QwRb0jNvHtjGI7Ajx3Qsu3BmHz76a+QjntU2PRBNSwwjvsozMrMuOmCvFrus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2634
X-Proofpoint-GUID: y0FLV8d0i9P_ayYvq8OzDDdUYPvhRZw9
X-Proofpoint-ORIG-GUID: y0FLV8d0i9P_ayYvq8OzDDdUYPvhRZw9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-13_01,2022-04-13_01,2022-02-23_01
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

DQoNCj4gT24gQXByIDEyLCAyMDIyLCBhdCA0OjQwIFBNLCBQYXdhbiBHdXB0YSA8cGF3YW4ua3Vt
YXIuZ3VwdGFAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIFR1ZSwgQXByIDEyLCAy
MDIyIGF0IDAxOjM2OjIwUE0gKzAwMDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiANCj4+IA0KPj4+
IE9uIEFwciAxMSwgMjAyMiwgYXQgNzo0NSBQTSwgRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGlu
dGVsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gNC8xMS8yMiAxMjozNSwgSm9uIEtvaGxlciB3
cm90ZToNCj4+Pj4gQWxzbywgd2hpbGUgSeKAmXZlIGdvdCB5b3UsIEnigJlkIGFsc28gbGlrZSB0
byBzZW5kIG91dCBhIHBhdGNoIHRvIHNpbXBseQ0KPj4+PiBmb3JjZSBhYm9ydCBhbGwgdHJhbnNh
Y3Rpb25zIGV2ZW4gd2hlbiB0c3g9b24sIGFuZCBqdXN0IGJlIGRvbmUgd2l0aA0KPj4+PiBUU1gu
IE5vdyB0aGF0IHdl4oCZdmUgaGFkIHRoZSBwYXRjaCB0aGF0IGludHJvZHVjZWQgdGhpcyBmdW5j
dGlvbmFsaXR5DQo+Pj4+IEnigJltIHBhdGNoaW5nIGZvciByb3VnaGx5IGEgeWVhciwgY29tYmlu
ZWQgd2l0aCB0aGUgbWljcm9jb2RlIGdvaW5nDQo+Pj4+IG91dCwgaXQgc2VlbXMgbGlrZSBUU1ji
gJlzIG51bWJlcmVkIGRheXMgaGF2ZSBjb21lIHRvIGFuIGVuZC4NCj4+PiANCj4+PiBDb3VsZCB5
b3UgZWxhYm9yYXRlIGEgbGl0dGxlIG1vcmUgaGVyZT8gIFdoeSB3b3VsZCB3ZSBldmVyIHdhbnQg
dG8gZm9yY2UNCj4+PiBhYm9ydCB0cmFuc2FjdGlvbnMgdGhhdCBkb24ndCBuZWVkIHRvIGJlIGFi
b3J0ZWQgZm9yIHNvbWUgcmVhc29uPw0KPj4gDQo+PiBTdXJlLCBJJ20gdGFsa2luZyBzcGVjaWZp
Y2FsbHkgYWJvdXQgd2hlbiB1c2VycyBvZiB0c3g9b24gKG9yDQo+PiBDT05GSUdfWDg2X0lOVEVM
X1RTWF9NT0RFX09OKSBvbiBYODZfQlVHX1RBQSBDUFUgU0tVcy4gSW4gdGhpcyBzaXR1YXRpb24s
DQo+PiBUU1ggZmVhdHVyZXMgYXJlIGVuYWJsZWQsIGFzIGFyZSBUQUEgbWl0aWdhdGlvbnMuIFVz
aW5nIG91ciBvd24gdXNlIGNhc2UNCj4+IGFzIGFuIGV4YW1wbGUsIHdlIG9ubHkgZG8gdGhpcyBi
ZWNhdXNlIG9mIGxlZ2FjeSBsaXZlIG1pZ3JhdGlvbiByZWFzb25zLg0KPj4gDQo+PiBUaGlzIGlz
IGZpbmUgb24gU2t5bGFrZSAoYmVjYXVzZSB3ZSdyZSBzaWduZWQgdXAgZm9yIE1EUyBtaXRpZ2F0
aW9uIGFueWhvdykNCj4+IGFuZCBmaW5lIG9uIEljZSBMYWtlIGJlY2F1c2UgVEFBX05PPTE7IGhv
d2V2ZXIgdGhpcyBpcyB3aWNrZWQgcGFpbmZ1bCBvbg0KPj4gQ2FzY2FkZSBMYWtlLCBiZWNhdXNl
IE1EU19OTz0xIGFuZCBUQUFfTk89MCwgc28gd2UncmUgc3RpbGwgc2lnbmVkIHVwIGZvcg0KPj4g
VEFBIG1pdGlnYXRpb24gYnkgZGVmYXVsdC4gT24gQ0xYLCB0aGlzIGhpdHMgdXMgb24gaG9zdCBz
eXNjYWxscyBhcyB3ZWxsIGFzDQo+PiB2bWV4aXRzIHdpdGggdGhlIG1kcyBjbGVhciBvbiBldmVy
eSBvbmUgOigNCj4+IA0KPj4gU28gdHN4PW9uIGlzIHRoaXMgb2RkYmFsbCBmb3IgdXMsIGJlY2F1
c2UgaWYgd2Ugc3dpdGNoIHRvIGF1dG8sIHdlJ2xsIGJyZWFrDQo+PiBsaXZlIG1pZ3JhdGlvbiBm
b3Igc29tZSBvZiBvdXIgY3VzdG9tZXJzIChidXQgVEFBIG92ZXJoZWFkIGlzIGdvbmUpLCBidXQN
Cj4+IGlmIHdlIGxlYXZlIHRzeD1vbiwgd2Uga2VlcCB0aGUgZmVhdHVyZSBlbmFibGVkIChidXQg
bm8gb25lIGxpa2VseSB1c2VzIGl0KQ0KPj4gYW5kIHN0aWxsIGhhdmUgdG8gcGF5IHRoZSBUQUEg
dGF4IGV2ZW4gaWYgYSBjdXN0b21lciBkb2Vzbid0IHVzZSBpdC4NCj4+IA0KPj4gU28gbXkgdGhl
b3J5IGhlcmUgaXMgdG8gZXh0ZW5kIHRoZSBsb2dpY2FsIGVmZm9ydCBvZiB0aGUgbWljcm9jb2Rl
IGRyaXZlbg0KPj4gYXV0b21hdGljIGRpc2FibGVtZW50IGFzIHdlbGwgYXMgdGhlIHRzeD1hdXRv
IGF1dG9tYXRpYyBkaXNhYmxlbWVudCBhbmQNCj4+IGhhdmUgdHN4PW9uIGZvcmNlIGFib3J0IGFs
bCB0cmFuc2FjdGlvbnMgb24gWDg2X0JVR19UQUEgU0tVcywgYnV0IGxlYXZlDQo+PiB0aGUgQ1BV
IGZlYXR1cmVzIGVudW1lcmF0ZWQgdG8gbWFpbnRhaW4gbGl2ZSBtaWdyYXRpb24uDQo+IA0KPiBU
aGlzIHdvbid0IGhlbHAgb24gQ0xYIGFzIHNlcnZlciBwYXJ0cyBkaWQgbm90IGdldCB0aGUgbWlj
cm9jb2RlIGRyaXZlbg0KPiBhdXRvbWF0aWMgZGlzYWJsZW1lbnQuIE9uIENMWCBDUFVJRC5SVE1f
QUxXQVlTX0FCT1JUIHdpbGwgbm90IGJlIHNldC4NCj4gDQo+IFdoYXQgY291bGQgd29yayBvbiBD
TFggaXMgVFNYX0NUUkxfUlRNX0RJU0FCTEU9MSBhbmQNCj4gVFNYX0NUUkxfQ1BVSURfQ0xFQVI9
MC4gVGhpcyBjYW4gYmUgZG9uZSBmb3IgdHN4PWF1dG8gb3Igd2l0aCBhIG5ldyBtb2RlDQo+IHRz
eD1mYWtlfGNvbXBhdC4gSU1PLCBhZGRpbmcgYSBuZXcgbW9kZSB3b3VsZCBiZSBiZXR0ZXIsIG90
aGVyd2lzZQ0KPiB0c3g9YXV0byBiZWhhdmlvciB3aWxsIGRpZmZlciBkZXBlbmRpbmcgb24gdGhl
IGtlcm5lbCB2ZXJzaW9uLg0KDQpUaGFua3MgZm9yIHRoZSBndWlkYW5jZSwgUGF3YW4sIEkgYXBw
cmVjaWF0ZSBpdC4gVGhpcyBpcyBleGFjdGx5IHRoZQ0KYXBwcm9hY2ggbXkgb3RoZXIgcGF0Y2gg
aXMgdGFraW5nLiBOZWVkIHRvIGRvIGEgYml0IG1vcmUgcmV2aWV3IGFuZA0KdGVzdGluZyBhbmQg
aWxsIGdldCB0aGUgUkZDIG91dA0KDQo+IA0KPiBQcm92aWRlZCB0aGF0IHNvZnR3YXJlIHVzaW5n
IFRTWCBpcyBmb2xsb3dpbmcgYmVsb3cgZ3VpZGFuY2UgWypdOg0KPiANCj4gIFdoZW4gSW50ZWwg
VFNYIGlzIGRpc2FibGVkIGF0IHJ1bnRpbWUgdXNpbmcgVFNYX0NUUkwsIGJ1dCB0aGUgQ1BVSUQN
Cj4gIGVudW1lcmF0aW9uIG9mIEludGVsIFRTWCBpcyBub3QgY2xlYXJlZCwgZXhpc3Rpbmcgc29m
dHdhcmUgdXNpbmcgUlRNIG1heQ0KPiAgc2VlIGFib3J0cyBmb3IgZXZlcnkgdHJhbnNhY3Rpb24u
IFRoZSBhYm9ydCB3aWxsIGFsd2F5cyByZXR1cm4gYSAwDQo+ICBzdGF0dXMgY29kZSBpbiBFQVgg
YWZ0ZXIgWEJFR0lOLiBXaGVuIHRoZSBzb2Z0d2FyZSBkb2VzIGEgbnVtYmVyIG9mDQo+ICB0cmFu
c2FjdGlvbiByZXRyaWVzLCBpdCBzaG91bGQgbmV2ZXIgcmV0cnkgZm9yIGEgMCBzdGF0dXMgdmFs
dWUsIGJ1dCBnbw0KPiAgdG8gdGhlIG5vbnRyYW5zYWN0aW9uYWwgZmFsbCBiYWNrIHBhdGggaW1t
ZWRpYXRlbHkuDQo+IA0KPiBUaGFua3MsDQo+IFBhd2FuDQo+IA0KPiBbKl0gVEFBIGRvY3VtZW50
OiBzZWN0aW9uIC0+IEltcGxpY2F0aW9ucyBvbiBJbnRlbCBUU1ggc29mdHdhcmUNCj4gICAgaHR0
cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX193d3cuaW50
ZWwuY29tX2NvbnRlbnRfd3d3X3VzX2VuX2RldmVsb3Blcl9hcnRpY2xlc190ZWNobmljYWxfc29m
dHdhcmUtMkRzZWN1cml0eS0yRGd1aWRhbmNlX3RlY2huaWNhbC0yRGRvY3VtZW50YXRpb25faW50
ZWwtMkR0c3gtMkRhc3luY2hyb25vdXMtMkRhYm9ydC5odG1sJmQ9RHdJRGFRJmM9czg4M0dwVUNP
Q2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT0teXkzZ3BVT0c3VzJzNzli
RTNLVG56ZDloMzJ4MDM4TTVDa1BraEZzVVcyMk1XV3pjZjNTb1g2QW4yODM1enJuJnM9dDg1YzBx
Qk1vc3JZX1V2RVZHemtSNGoxMjVhR2ZIanUzU0ZFRVBBSW1wUSZlPQ0KDQo=
