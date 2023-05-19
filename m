Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AF3709F2A
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 20:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjESSio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjESSim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 14:38:42 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021018.outbound.protection.outlook.com [52.101.62.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B451AB;
        Fri, 19 May 2023 11:38:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs8MPAnYDMFR8HCYAj9JhCcAleSVYc76C0mJeYceq5AfC1gwFHoGjidaN8ozb+1Mt/+Ify4MYW9QpiBS9AvfOUQi2mzKAg6f8EUNXv6mxL6aMFh54FWVrewY1SSNaVdKI/zszJ/M4XwYsCbsh7yb0qyEjz82Ik23H3tNtTRvLzLiwyemK0gRXqjfQskbITjCxkJTHZvqbkborAox3mB9Z7/5MzOlKs0EpzdNjvJT6X90cibUYK6gx1z3E5SFsDQKocIPUs/5O7jH6J58OLOPnBvKE8+hQ9AUfaOODAMHDerrnFRNzV8Eh3rx/giQtdYlEl0Nasq6vjQ5bJZDWjZPyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5KP9QP9Htyotwe7qgFbHFanaQ9Soc1DwDIQMcy8i8Q=;
 b=QFftcjc/S4PDy2OZlfLBQioEVeqW2L4roqV30NsGkzwHqewomh3oERMPcBolpZfHkwiDEky7EERNoeMSD/oMXQo/CxZM19VkJXzNX0Yz4haxkoWn13tIYdSbqCxuiXnZFYDJZHEIrV2RgCJ0JS66X5vp4eAhsLZILhB/dZesMODo5UvfZ+gk7puIPA7wJSzDtlO/hmWUTXL+oyR2TYXSA9/UV/zPvUSsjyVkrfTbtK2u3hQsyV4PZVZ25kysmUvSdXc2mzb90TxiB2OWUUrMyxgybPttYaCKTQDnXrCblSNU1OyTJmSWwXv5hG4VBK3kgVEr+dgR2lm1LGlWBYGe4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5KP9QP9Htyotwe7qgFbHFanaQ9Soc1DwDIQMcy8i8Q=;
 b=Rpk4ospS3Bw9YUlG5rswMUo1xSM3zEiqzKj2XQeCN0y5O7mh59rczec7xokBYfkfKoqLX66h2Y28Wa1cxwhWFeFBDd/mCVbw9ztVYkuRY0ZdT+OpfhdH/Zd9M+HlvsuHa8x7t3PBt/N+G+QT0mh489+34vQCIvM0+u+hzoJJb9I=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DS7PR21MB3717.namprd21.prod.outlook.com (2603:10b6:8:91::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.3; Fri, 19 May
 2023 18:38:37 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::a4f7:2466:97b5:bd31%5]) with mapi id 15.20.6433.007; Fri, 19 May 2023
 18:38:37 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
CC:     Mark Rutland <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "kernel@xen0n.name" <kernel@xen0n.name>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "vschneid@redhat.com" <vschneid@redhat.com>,
        "jstultz@google.com" <jstultz@google.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH v2 09/13] clocksource: hyper-v: Adjust
 hv_read_tsc_page_tsc() to avoid special casing U64_MAX
Thread-Topic: [PATCH v2 09/13] clocksource: hyper-v: Adjust
 hv_read_tsc_page_tsc() to avoid special casing U64_MAX
Thread-Index: AQHZij3PCnB4HEkMNUKkj658IQK7Ta9h7VTA
Date:   Fri, 19 May 2023 18:38:37 +0000
Message-ID: <BYAPR21MB16881F78BE5B6D9E9846A438D77CA@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20230519102058.581557770@infradead.org>
 <20230519102715.775630881@infradead.org>
In-Reply-To: <20230519102715.775630881@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=79d277a4-0094-4801-9a99-f9d72aa99d2e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-05-19T18:37:03Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DS7PR21MB3717:EE_
x-ms-office365-filtering-correlation-id: 461e177b-ad27-4196-aeac-08db5898426f
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YbYKv46rxljGFmqezG4B98NMaSrTeK/mE3C2dDX21pBNhebhrKhc9taHwvFFmsHg28qYChG2b5Sg/K7GP3gMRwoH4xPh5iGbH0B6678xXz8gwzGSgPOjlE1kM8NjMdOZE35aQ6B/2vLpzMM/nFTxlPMX/+gSoy5g4JVJoxgZQ9G0kGTxXqNv3hNY4PR5xaB9plZgHAWBHZWJVHBVs4ayJa55g6sgbnyFsRC5Ki9LmJVabWjY5kzGttBFHVzdUCm+JhaBPZR19R/Igbzl/PbkzUCV+50bdu9/41oysC2x8nIe8SCZJwUT41uNYD4qLOTnNJC/LwPTLU+ti9nbJjUzzu0AMGlxBxE3771OfK4qp1ZAuOrtCWrRdg3STLYHkJeFI7JR5ZUxTn50tXmILfppB+r10mJbCLoWopkawt6m5/PdocsHDyZpRfKXM08ggzqRkS1r/QwVC1mKal/eViQ3mkF/ccD/U0QWSVLeTIEZ1/BAp43WpQ3FsTnFnvlPbWUwnXL0c/X3NtMms9QDXv6m1PtZ5+z/V5aC7miALAgzq/b0Dz2CJdQFTbqJOPIa+SD6+TImjTlJfrRytq6thsmIRV52ZJv4v/j+yVNVOHvowcLmmhA+ZPa9upeyzr02ciITXtwuP3wG4qxkWwatwELymtf4Auo/5De732Z9Lo44d6A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(83380400001)(26005)(55016003)(64756008)(66476007)(9686003)(66446008)(54906003)(8676002)(66556008)(478600001)(7696005)(4744005)(5660300002)(7416002)(10290500003)(52536014)(7406005)(186003)(86362001)(76116006)(110136005)(33656002)(8936002)(38070700005)(122000001)(316002)(2906002)(6506007)(8990500004)(38100700002)(41300700001)(4326008)(82960400001)(82950400001)(786003)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVJJbzZLYVdJMndqb25EUmF5N2xOWkx2UnZpRFhVbGZZZjZ0VXFWbWpQWDA5?=
 =?utf-8?B?VVNyaGlGWjBTVEdGbEhWU1MrWkhuNGZYYXZDdUxRd2xjRXFmUWxtODVja2Fx?=
 =?utf-8?B?c3l1UXY5bU52T2FVOHNJRjkycHRRWTFyTjRVQlNIOEpURzRrL2lBZVhuOTl4?=
 =?utf-8?B?cUorNmg1VkVGSnFWL3N3MzE2N0ZLL2RvNWFpeTZzZllxWjlnTEtlcFJRMURB?=
 =?utf-8?B?ZS9lUytkMjZuS3psL3p6MDREdzlaUVlVWnYxOStIMjdIdWdONlRab2tOMC8z?=
 =?utf-8?B?Y3p2Yys4WjlIUEFDMGFiaTZVbXNVbSs5clBtTU9qS3ZNdGF5MFBvemp3em1j?=
 =?utf-8?B?VDF2cDdJenplL01tdEZxenRONlV4dm5uOTBiU0phOEtxUFJVbEdiS2YrblVG?=
 =?utf-8?B?bjhIaUVNajBGa3RuSHJjOE5PK2U4a1B4WXVUWVQxWTBjNmVOSXhPeWZLcGoy?=
 =?utf-8?B?d3JwV2VBUE51N1dNYnZSc0VEUitrSHhkNXVIblhqWGp2dkt0c21DeHRyRkwy?=
 =?utf-8?B?SmVUWUt6Z045dWFWdFlJaEJRbFVaZFpqUng5aytwVjU0ZmgxN0txR0p4Y1Ft?=
 =?utf-8?B?c21UVEw0bWRUS1owc2ZXK0MrZlRvYi9EZ0ttcFM0U3FraGRrcEtMa2JhWGhp?=
 =?utf-8?B?RkVmM01lNjQvc2xVdm5HbUpjZ2lYTkZFdUszZGptNjVUU25vbExaYVliVTNy?=
 =?utf-8?B?Vkp4cmJaSUZzOG5ZbUpDd2ZseGVCTmVlK3NDdXBlMkx4N2M3ZGRhc01zNHUy?=
 =?utf-8?B?SEJLdTRXVDlVaUNHaFA5OVVsR3Qzdi8ydktJU1h0S1crU09RMTdZY0tZQzFl?=
 =?utf-8?B?S05zTXE1RzAyemhHckdNLzAyMTdPcGVpTHVMcmdhS21QMVNEb2hPOGJIT0hI?=
 =?utf-8?B?NGoxVEpjdDVwZWZBMHJocXFyc1BjT2t5RmlHL2ZFdlllUjU1N0lkVTNxRWFq?=
 =?utf-8?B?NlEwRjdkWFZlYSswTGtsZ3RsRnJaT1B2RGZlcFJhV2FKYWR1bW0ra0JLSCs1?=
 =?utf-8?B?eitJc3R3TDVnREQ0MVlhenppSTZvSHVxMU9sR1I2dE9qV0QrZEFibEZpOHMx?=
 =?utf-8?B?UVZiTVVNQzhTRmNBS1pqbHpTNGZiengyandXVUR4S1NjWmdacER4L2lKUUpa?=
 =?utf-8?B?ZHdSdTFlZWdVTG5ZYlBVeFFldTg3T201ZlFud0RmYUltZUJCY283L1AzWncw?=
 =?utf-8?B?c1ozcmU3RFd1Mmc4WmFHR1dQK25zbVVsN3hiLzMwb1FJNmRDYm54YUcwaVVh?=
 =?utf-8?B?YWwrNGlEcHVVVkovbmJHOG9sTkNqLzRRZkdLTUdNSzd2R1NHa3A1S21FSEY2?=
 =?utf-8?B?UjQxblF1VFMvaHJ5YWVVeFVueDBCL1NJS1locFNvLzZpaFVFVUhpRWs4VU9M?=
 =?utf-8?B?MVhlWFpTOFpWUTJuVjcrck1CQkUyUHkzcUtDajBBRitpclBSTHlWRWl2a0ls?=
 =?utf-8?B?SU84UlUraElGb09Kbjd6TXFzQ3l0eGpUQ3F5S1l1NFRMakM1cFlwWWlKWmxO?=
 =?utf-8?B?V1NzNmthdEpKNEZsTFA5KzVUWC9BcnlhcDJQbnRmT1QwOTdqSWtuRU4vMThu?=
 =?utf-8?B?TDZqRWMrRWF0NTlGc0xTNWxHS0paSmFEZ1UwcE1uRWpsaEtPcTZUd0E4YlI5?=
 =?utf-8?B?U3NuV3dsbE8yZEdPL3hDN3EwbnVkY2F3MlV4SzhtUzhlYzk0a0FXZUx0Z3hD?=
 =?utf-8?B?c05TWEtHaXNlS2l2RHRlc2hwMzE4WmxaMkFhWWZiRjZ6RXk1dWVQVjY2SWx3?=
 =?utf-8?B?MkkrMzBhcG1OUzI5ekRXQzI1dGRKaEY5NG5YQmlFQ0hpSTBKeHV0NHdhcUNC?=
 =?utf-8?B?N0dFbzFoM0FyTVhSR2pwK1lBeVErYUFaQW5mSWVEUGVzODNqSlBhdU9xaDVR?=
 =?utf-8?B?ZDdGZG5jaEtCd2hPWHhIN2N6Snc5OXpjcVJwZXhTWmgxK0J5N0hZUXFURnVm?=
 =?utf-8?B?UXV6cmZDTHlEODB1cWIvTEpkSTE1ZkNtemNhV3dlU2o3cVN0ODhMSm5mRzJj?=
 =?utf-8?B?bGd3dStOSmVibHJneEpwYUxPdmgxN2F5VUduUWNFRmNkUUJUTkxmMVh0UUc2?=
 =?utf-8?B?QmNvOSszOGdyQWcrSUczc2w4SW9BalFwOEpzb0N2TTBHTVA2cVRxK093YmNj?=
 =?utf-8?B?dkhKTU9PQUViTFZZb25rNjFjUmpYQXY1OHJrdmZTRldrcGYrTlFHR1lRZUVV?=
 =?utf-8?B?ZEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 461e177b-ad27-4196-aeac-08db5898426f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 18:38:37.5606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sve5yicvcwN75XN3YcKSk/ZwNmbS4eYCvgxfNBf5gcM8CvplXjbSsbMisBoLouuYbLyjrKLftcrdBCnkGULf5RvPrRaSO8x1QBSJsIupbBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3717
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPiBTZW50OiBGcmlkYXks
IE1heSAxOSwgMjAyMyAzOjIxIEFNDQo+IA0KPiBDdXJyZW50bHkgaHZfcmVhZF90c2NfcGFnZV90
c2MoKSAoYWIpdXNlcyB0aGUgKHZhbGlkKSB0aW1lIHZhbHVlIG9mDQo+IFU2NF9NQVggYXMgYW4g
ZXJyb3IgcmV0dXJuLiBUaGlzIGJyZWFrcyB0aGUgY2xlYW4gd3JhcC1hcm91bmQgb2YgdGhlDQo+
IGNsb2NrLg0KPiANCj4gTW9kaWZ5IHRoZSBmdW5jdGlvbiBzaWduYXR1cmUgdG8gcmV0dXJuIGEg
Ym9vbGVhbiBzdGF0ZSBhbmQgcHJvdmlkZQ0KPiBhbm90aGVyIHU2NCBwb2ludGVyIHRvIHN0b3Jl
IHRoZSBhY3R1YWwgdGltZSBvbiBzdWNjZXNzLiBUaGlzIG9idmlhdGVzDQo+IHRoZSBuZWVkIHRv
IHN0ZWFsIG9uZSB0aW1lIHZhbHVlIGFuZCByZXN0b3JlcyB0aGUgZnVsbCBjb3VudGVyIHdpZHRo
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgWmlqbHN0cmEgKEludGVsKSA8cGV0ZXJ6QGlu
ZnJhZGVhZC5vcmc+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vdmRzby9nZXR0aW1l
b2ZkYXkuaCB8ICAgMTAgKysrKysrLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3g4Ni5jICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgIDcgKysrLS0tLQ0KPiAgZHJpdmVycy9jbG9ja3NvdXJjZS9oeXBl
cnZfdGltZXIuYyAgICAgICB8ICAgMTYgKysrKysrKysrKystLS0tLQ0KPiAgaW5jbHVkZS9jbG9j
a3NvdXJjZS9oeXBlcnZfdGltZXIuaCAgICAgICB8ICAgMjQgKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygt
KQ0KPiANCg0KUmV2aWV3ZWQtYnk6IE1pY2hhZWwgS2VsbGV5IDxtaWtlbGxleUBtaWNyb3NvZnQu
Y29tPg0KDQo=
