Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD09551524B
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379272AbiD2Rfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379607AbiD2Rfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:35:44 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84CC1BE8F;
        Fri, 29 Apr 2022 10:32:24 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TH1qcY025251;
        Fri, 29 Apr 2022 10:31:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=Z2pZQeiu8wvJS/D/ybvSkL6GZT4YzPzvc8OAhxnw90k=;
 b=1+4QhYvuWcSExLNmjHmjUtLWKHQviUqnr4zuCD3sMBXHNKUNtggIrEeaVFK5kXZuWStq
 16OPDtbnewjbtX3Ke7wgBg7rlAz7rJbccDm024M7emafBDm2qyNDyz8mjNqsy4q8Bd+/
 yj7liEWVo4BSWDmK6QFlWLAmAe6xXdNfSIT/Jy5kasfEYJlhsbz9qrOBS62acOff27RJ
 qkzcOcGTdBJTXRUC1BMYmiycuzx/T9aDlLhPeC7uQjZcaUE0ljyy76LyKMY04C+2tyxA
 pT6E6dJOYnfynxDQM3t4zpqTF9Apz7hrZuMEyVnbmX3wVQeSxdPH8xdSrH5MJtff2ltx Tw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fps5beqhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 10:31:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biyZz7dFEFhTa25S9czp+7Co7u33gcmEgnC9OLEsqPx2EK8SG6UYxbeKZT4kubykz6C31G8mplf/FveXbfOJevDnsUzDHgG71OSiKiv8FRBBMthi4bfItf7DVy8v10JuNTibd39sgh5kV7sDbLeFGl89zPYAYkYr60U91p5ivMEogXhph7x4w8KIjPAmJMQZ3xN/wHgTitANuiI5mSMSN7ncGL3YT/dIPfTLzVwXIgGPjHdsQHdRRZnb/3Kxa+PCm9oJOWoMvASKDb14v/3L6UVhtY8Vg/6pQeX7gRKs/EQOnUmqR8/qPu9Kk6uG9OFDarmWUkV4cmc+0b4PtVbNYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2pZQeiu8wvJS/D/ybvSkL6GZT4YzPzvc8OAhxnw90k=;
 b=N6fCu60DF7AbuLD69vjul6kZo2/G17CmV8XHh1/abMedQtYzVDM/gr0I4v9h3gO+a95Y7UcmcUdFjCwRwT8N0ww0u/tKrOpmXH99EzdDFXzOOW696er0LIs/ZdPRwk3+FX6G/Vs+HfLr24HSIBenRIDnC5uLXnnQPoEgpbovrkMerTrBBWpzjAVL9aSrr6kIc/9TyJ+mjhj2mph3AvuqlOggmCXYUMmWsQ65ExDgyMQBHJU7gm9IlktEiWxTA7VjBBA8XGU8ij3ufhgebePRm4J4O60BBtNkkONUGn1YXbpQDh8FKgv+Tof9RBhCPrMHKcIEUxWIZWTpOSRLxDs5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MW4PR02MB7331.namprd02.prod.outlook.com (2603:10b6:303:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Fri, 29 Apr
 2022 17:31:16 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.023; Fri, 29 Apr 2022
 17:31:16 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Topic: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0HKBwAgAAI9IA=
Date:   Fri, 29 Apr 2022 17:31:16 +0000
Message-ID: <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
In-Reply-To: <YmwZYEGtJn3qs0j4@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b9bf414-1b00-4f59-5605-08da2a0610d7
x-ms-traffictypediagnostic: MW4PR02MB7331:EE_
x-microsoft-antispam-prvs: <MW4PR02MB73315AECA34A09491A2496A4AFFC9@MW4PR02MB7331.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WlutdQqIxohmfaUJSDj/3St+qGtqpclCrBNsXr5/mr4ZzlWOVlo27QBk3w6aWo0A1TZAoFIBRO9kfnURPyad8CXrJ4wSa6xARk3tP+t7Kk62Acy+okwe6Zhe7cncf/rV4C6HQgDZK8rBF+FiaotwHdt8bOzeFCcZjrbfLnuY8xFKuByU4pxxjTUPGfCTQKpj1l/Q+pAA3WMIC7ucHyv8oh3ve8i1X2MC9gfUMaW5Vxq6K+RwC3jaZU/DFKxwhcXExzThtHcKw/+QvIYG6jc4D1hnOfnXL+oe8xwj/64FviVAnrQGbzL+aigAnksyIJy1mlGbLoHnfCIRIdg5zFB9OOBYpRDHPS/bEwuhatmlLnaUNXqcokWZOzKgUAjiXQ2/CJdCkBLIQfImhXUyabuIDKm5Fa5ccNKVk+Gf0yxsuU01tT3ffThafpP5AtU+EzdzVr7O/lvJh109HQPDJpCNS3KY9J49JLiTo6c9ULD1enfL8Y4Rz2bgG+cPZ73KbU3EW8i+xPWz5dfp4N0rGV4r0En5wYJ/tsnIgKz5SKi/KMvSH33q9DWR8gMFHQ7LZpWomj7WiY2JGVdhB8iKSB9oiR3RvOa+3KZ8lNVl66SwWDLKCRwpTdO8oJaGhRncyZmFLX4knoOsf46RQiiSUWNRHJHgZaCTc90sref1cDBLeBWWpvOyZ4Kxg86nbjT7NsJyXmZwrM6pFMdz8dItGEg2CuGKAFg0hkWe+DaWOq15UW4SAyFjo/RJcGxIL5QhXOB1QztWQCFY97peG5j/C2l9pYvtHcWDUdZLloZ4FueSusXpq0i/6TaTEqf1lTm+sBvPGLqxDqiwlTjUmcIZuf+Q0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(6512007)(508600001)(91956017)(33656002)(6486002)(53546011)(966005)(6506007)(54906003)(38100700002)(36756003)(316002)(66476007)(66446008)(6916009)(71200400001)(38070700005)(2616005)(7416002)(186003)(83380400001)(8936002)(2906002)(4326008)(8676002)(76116006)(66946007)(86362001)(64756008)(66556008)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzJ3WTBQTGFRZ1F0NWlOb3lidnI5TnpvdjhXT2p1c3p1YTE2YW95Z2F1Vis5?=
 =?utf-8?B?NGhvUjdEVGNvRUwxU1JZcUpYMjQxazdtOXcreE5UOWpzVmcySW90dFRRT2xB?=
 =?utf-8?B?RG5lRngxUmszc0wwVXI3Nk5veFhTeFVkSVo5eW1YZzlpa1lRUFVzQ3R4YVNo?=
 =?utf-8?B?eFhWZWt4Yi85akJZMm9iL3B1VEZ1NG9RMlUvQ3hmdWpqeUhBWXgyWGduOHNt?=
 =?utf-8?B?eGZWSmpZemRoRmZyZG5tcXNSbVlSYWxDOG5xdjhVZTNjeGRkUktPSUF1VEg4?=
 =?utf-8?B?eTRrNFZWdkI1Zm1yZGNGaTZaU2h4S1BUaHppRHZaUzVmeENPOXNtdEVlTE1Y?=
 =?utf-8?B?WnBXRGdQRUdGbWVGTFlxWk1WRU9GMENHUFBSczFvbFZsS0xwV3N5VzBpcUMw?=
 =?utf-8?B?YUhzUk8vdk1uUmozcjBHeWFHTlkyZGpWL3BlZ0NYNnBnRm45elV2cndKb25j?=
 =?utf-8?B?Uk9QSVJTcGJPRVhPNHMyN0wrUkY1N09pTDZRbm9XSWsvZjNTNExKSUpRazRq?=
 =?utf-8?B?ZEFvc3FTRU5WVHRjeU9WVjNreThFaVc3dGpqdDYwUDdhRVJEbTRpUXE0RHJW?=
 =?utf-8?B?bWpmbjc4YUg2SVZ2NmVFalFuSmFMa1VGSGQ0NVhlTmdTWHZKa2JybVZLc2RS?=
 =?utf-8?B?VWJOdEhKUW5tVE8xTTNRclh5SHNqc3NCcE9hRjVXUFRPbzlrUHZTbWlGL3Ja?=
 =?utf-8?B?dFZFdVpIS2oycDRiTUZJRERmREJXMXAwNGFWYjRtNkZadjE5ZXo1UjhFR0ND?=
 =?utf-8?B?emZBQzl5L044cXl4d2YrY1pPSkpPaUU2L2NyOFJJV2c5dkJPdXZFMndzOU1Q?=
 =?utf-8?B?enpzdTN0M1gzd1Z3MkdJeFpMTkhEdzNML3R1dGhhQitiRm8wTGliQlNaWGhs?=
 =?utf-8?B?QU9lNnhaczQrOTNxZTJrTnI3Vy9hdnpCY3dlejBMOU4yTENzcWgxSGZaZmhi?=
 =?utf-8?B?eURnQ245RWs5MVBmU29LUlRTS2VJWGZxRTFqM2hFSDdFdzFTMmw0dVBWUTVq?=
 =?utf-8?B?dGlLMmQxdTdYRTQ4bTR5ZWdXVytXUmtKUlFERjVWbk15WWFPR1BXTi9UVWhB?=
 =?utf-8?B?Qlk0ZEVOd29iNU5RSnh5QUNmemg4UUkxbndiY1RVVHg3VUhkcWpIc1lGYnRj?=
 =?utf-8?B?UjRucmlIQ0pjUlB2Wng2Y1EzeHUrQm9peUpYK3hrL0gyV3hROWJ1T0U5OXd1?=
 =?utf-8?B?ZHc2T1hxSDBhOW1LMnlzRStTRnZPdENYR01mdm04MHY2bU5zSjc4QUgyZ3J6?=
 =?utf-8?B?TmNrWEwxb1JNcUtMQkdoVDRNd0NoWElZOVJteGNuN0FadXg3VFA4blN6cmFK?=
 =?utf-8?B?S0lQUiszYW5nZ3VwU3ZaaGs5clpiWEpLMzlBTStDMWw5SEhyeHVsZC83WDJP?=
 =?utf-8?B?TVhGd01DVUpENFV6VUdtNGNiOFBVUWlMVlg3Q3hHbkROR2R6a2pFa0ZrcFg4?=
 =?utf-8?B?RWlrZW51NWovZGp2b0tXTlNMcCs2SDhDd0poTzl4YUF5QWkvVlA5TUJsbXht?=
 =?utf-8?B?aS8wQzhiZERIS3Z6aHo1cW91ZHhTK0FpQXlXZVczQmdDYSs3dnZhMENUR3Jo?=
 =?utf-8?B?dzkxcldZZzZ1c0x4cmsrMnN0OS83dnBTSU9QMG1KQmo3SmRNR3JRRFhkYTho?=
 =?utf-8?B?akIwd2hhNVZoUDlsR2N2YitOb3FhNWJLSUtMbEpTU0haTXZSOUZ2M0I4T3dv?=
 =?utf-8?B?eVFiNW9FVHpaMDhSWnArVGhDM0c5UkpsNEQxOVU4L1V1bWRBVmhvVWJ3K1R0?=
 =?utf-8?B?eTRSZ3dCbHJRL2ZTbUdaNGdFcjJEaGlzRW9nNUcveEZCWDIxMFZLUnVka3ZL?=
 =?utf-8?B?TkFBVDR0aTVTU1dmSDY3Z0NvREEyZlpQb0NxSnQyWlRUdzJ1a0RyUTk5eENJ?=
 =?utf-8?B?TVIzRmhvNkkwS0p2bkF2L0VzRktQaDZQRC81OWhlOUhpODUxSStjUHVUVzdm?=
 =?utf-8?B?blFhSHlUWVYvbjg5TUsxbEtOcS9xUWxpWUFhRFg5bWxLYzhiNWVCbFAzcVFq?=
 =?utf-8?B?SW1sWXZraXkyWjRMSlpoT0I1WGI3YXdOSXpoMkFnUU42cU9OWUJTL2FzVURH?=
 =?utf-8?B?VzYvMVNka0pLSHpuclZ3VGk5SUVCTXZGNG1zUENtSnBlR0RqbFNSRDlta2pl?=
 =?utf-8?B?WkYyaWFGZHRNNzQrNmNCTVBjNnQyZFJ4OS9HVFBvTkZMRmE0OFZ2ak5Kajlv?=
 =?utf-8?B?aVBuWnFmdEVWMGJUK3dRVlZSdEk4R1hreGh4SVpzMVhsTkJId3J3bzFReEwx?=
 =?utf-8?B?MjB1TTZ2QWFzckRMdnY1dzltUHhHQitpWGU0R01NaUREUmk1bW40eVVPT3Nv?=
 =?utf-8?B?ckM4allzbm5mZXF2T1BFRXhxOEMxbDB5TWd1ZVdHbVB4cUhhaVFMd2RLRzNW?=
 =?utf-8?Q?31VrZKehEj9HtXNwpK+XG1vBpK6dCaEz3/IOZDiglCxpE?=
x-ms-exchange-antispam-messagedata-1: VbzqXPetzQiyhmdbSBVmOCdRiU+f5ef+0nLTEf6ZP8v1NCwdW7M3RDbm
Content-Type: text/plain; charset="utf-8"
Content-ID: <039548F965B27248899B021C1F74C57E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9bf414-1b00-4f59-5605-08da2a0610d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 17:31:16.6595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4A0jHpkRcXJKA48nrgMWLKlHBDAkyCW4c4L1wJnpTLEL5h3Mvt6m2Il49FoEYDwi1Zsb4vGJZDynOmOME9/m1ILzsvXSgZDYFNU4GQlVbik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7331
X-Proofpoint-GUID: _unOXIbw81lL5zXOCemLj1BzcYs33QWe
X-Proofpoint-ORIG-GUID: _unOXIbw81lL5zXOCemLj1BzcYs33QWe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_08,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gT24gQXByIDI5LCAyMDIyLCBhdCAxMjo1OSBQTSwgQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+IHdyb3RlOg0KPiANCj4gT24gRnJpLCBBcHIgMjIsIDIwMjIgYXQgMTI6MjE6MDFQ
TSAtMDQwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IEJvdGggc3dpdGNoX21tX2Fsd2F5c19pYnBi
IGFuZCBzd2l0Y2hfbW1fY29uZF9pYnBiIGFyZSBoYW5kbGVkIGJ5DQo+PiBzd2l0Y2hfbW0oKSAt
PiBjb25kX21pdGlnYXRpb24oKSwgd2hpY2ggd29ya3Mgd2VsbCBpbiBjYXNlcyB3aGVyZQ0KPj4g
c3dpdGNoaW5nIHZDUFVzIChpLmUuIHN3aXRjaGluZyB0YXNrcykgYWxzbyBzd2l0Y2hlcyBtbV9z
dHJ1Y3Q7DQo+PiBob3dldmVyLCB0aGlzIG1pc3NlcyBhIHBhcmFub2lkIGNhc2Ugd2hlcmUgdXNl
ciBzcGFjZSBtYXkgYmUgcnVubmluZw0KPj4gbXVsdGlwbGUgZ3Vlc3RzIGluIGEgc2luZ2xlIHBy
b2Nlc3MgKGkuZS4gc2luZ2xlIG1tX3N0cnVjdCkuDQo+IA0KPiBZb3UgbG9zdCBtZSBoZXJlLiBJ
IGFkbWl0IEknbSBubyB2aXJ0IGd1eSBzbyB5b3UnbGwgaGF2ZSB0byBleHBsYWluIGluDQo+IG1v
cmUgZGV0YWlsIHdoYXQgdXNlIGNhc2UgdGhhdCBpcyB0aGF0IHlvdSB3YW50IHRvIHN1cHBvcnQu
DQo+IA0KPiBXaGF0IGd1ZXN0cyBzaGFyZSBtbV9zdHJ1Y3Q/DQoNClNlbGZ0ZXN0cyBJSVVDLCBi
dXQgdGhlcmUgbWF5IGJlIG90aGVyIFZNTXMgdGhhdCBkbyBmdW5ueSBzdHVmZi4gU2FpZA0KYW5v
dGhlciB3YXksIEkgZG9u4oCZdCB0aGluayB3ZSBhY3RpdmVseSByZXN0cmljdCB1c2VyIHNwYWNl
IGZyb20gZG9pbmcNCnRoaXMgYXMgZmFyIGFzIEkga25vdy4NCg0KPiANCj4gV2hhdCBpcyB0aGUg
cGFyYW5vaWQgYXNwZWN0IGhlcmU/IFlvdSB3YW50IHRvIHByb3RlY3QgYSBzaW5nbGUgZ3Vlc3QN
Cj4gZnJvbSBhbGwgdGhlIG90aGVycyBzaGFyaW5nIGEgbW1fc3RydWN0Pw0KDQpUaGUgcGFyYW5v
aWQgYXNwZWN0IGhlcmUgaXMgS1ZNIGlzIGlzc3VpbmcgYW4gKmFkZGl0aW9uYWwqIElCUEIgb24N
CnRvcCBvZiB3aGF0IGFscmVhZHkgaGFwcGVucyBpbiBzd2l0Y2hfbW0oKS4gDQoNCklNSE8gS1ZN
IHNpZGUgSUJQQiBmb3IgbW9zdCB1c2UgY2FzZXMgaXNu4oCZdCByZWFsbHkgbmVjZXNzYXJpbHkg
YnV0IA0KdGhlIGdlbmVyYWwgY29uY2VwdCBpcyB0aGF0IHlvdSB3YW50IHRvIHByb3RlY3QgdkNQ
VSBmcm9tIGd1ZXN0IEENCmZyb20gZ3Vlc3QgQiwgc28geW91IGlzc3VlIGEgcHJlZGljdGlvbiBi
YXJyaWVyIG9uIHZDUFUgc3dpdGNoLg0KDQoqaG93ZXZlciogdGhhdCBwcm90ZWN0aW9uIGFscmVh
ZHkgaGFwcGVucyBpbiBzd2l0Y2hfbW0oKSwgYmVjYXVzZQ0KZ3Vlc3QgQSBhbmQgQiBhcmUgbGlr
ZWx5IHRvIHVzZSBkaWZmZXJlbnQgbW1fc3RydWN0LCBzbyB0aGUgb25seSBwb2ludA0Kb2YgaGF2
aW5nIHRoaXMgc3VwcG9ydCBpbiBLVk0gc2VlbXMgdG8gYmUgdG8g4oCca2lsbCBpdCB3aXRoIGZp
cmXigJ0gZm9yIA0KcGFyYW5vaWQgdXNlcnMgd2hvIG1pZ2h0IGJlIGRvaW5nIHNvbWUgdG9tZm9v
bGVyeSB0aGF0IHdvdWxkIA0Kc29tZWhvdyBieXBhc3Mgc3dpdGNoX21tKCkgcHJvdGVjdGlvbiAo
c3VjaCBhcyBzb21laG93IA0Kc2hhcmluZyBhIHN0cnVjdCkuDQoNCk9uZSBhcmd1bWVudCBjb3Vs
ZCBqdXN0IHNheSwgbGV04oCZcyBLSVNTIHByaW5jaXBsZSBhbmQgcmlwIHRoaXMgb3V0IG9mDQpL
Vk0gZW50aXJlbHksIGFuZCB1c2VycyB3aG8gZG8gdGhpcyBzaGFyZWQgbW1fc3RydWN0IHN0dWZm
IGNhbiBqdXN0DQprbm93IHRoYXQgdGhlaXIgc2VjdXJpdHkgcHJvZmlsZSBpcyBwb3NzaWJseSBs
ZXNzIHRoYW4gaXQgY291bGQgYmUuIFRoYXQNCndvdWxkIGNlcnRhaW5seSBzaW1wbGlmeSB0aGUg
aGVjayBvdXQgb2YgYWxsIG9mIHRoaXMsIGJ1dCB5b3UgY291bGQgcHJvYmFibHkNCnNldCB5b3Vy
IHdhdGNoIHRvIHRoZSBuZXh0IGVtYWlsIHNheWluZyB0aGF0IHdlIGJyb2tlIHNvbWVvbmVzIHVz
ZQ0KY2FzZSBhbmQgdGhleeKAmWQgYmUgYWxsIGdydW1weS4NCg0KVGhhdOKAmXMgd2h5IHdl4oCZ
dmUgcHJvcG9zZWQga2VlcGluZyB0aGlzIHRvIHRoZSBhbHdheXNfaWJwYiBwYXRoIG9ubHksDQpz
byB0aGF0IGlmIHlvdSBpbnRlbnRpb25hbGx5IGNvbmZpZ3VyZSBhbHdheXNfaWJwYiwgeW914oCZ
cmUgZ29pbmcgdG8gZ2V0DQpiYXJyaWVycyBpbiBib3RoIEtWTSBhbmQgaW4gc3dpdGNoX21tLg0K
DQpTZWFuIGZlZWwgZnJlZSB0byBjaGltZSBpbiBpZiBJIG1pc3NlZCB0aGUgbWFyayB3aXRoIHRo
aXMgZXhwbGFuYXRpb24sDQp5b3XigJl2ZSBnb3QgYSB3YXkgd2l0aCB3b3JkcyBmb3IgdGhlc2Ug
dGhpbmdzIDopDQoNCj4gDQo+PiArLyoNCj4+ICsgKiBJc3N1ZSBJQlBCIHdoZW4gc3dpdGNoaW5n
IGd1ZXN0IHZDUFVzIElGRiBzd2l0Y2hfbW1fYWx3YXlzX2licGIuDQo+PiArICogRm9yIHRoZSBt
b3JlIGNvbW1vbiBjYXNlIG9mIHJ1bm5pbmcgVk1zIGluIHRoZWlyIG93biBkZWRpY2F0ZWQgcHJv
Y2VzcywNCj4+ICsgKiBzd2l0Y2hpbmcgdkNQVXMgdGhhdCBiZWxvbmcgdG8gZGlmZmVyZW50IFZN
cywgaS5lLiBzd2l0Y2hpbmcgdGFza3MsDQo+PiArICogd2lsbCBhbHNvIHN3aXRjaCBtbV9zdHJ1
Y3RzIGFuZCB0aHVzIGRvIElQQlAgdmlhIGNvbmRfbWl0aWdhdGlvbigpOw0KPj4gKyAqIGhvd2V2
ZXIsIGluIHRoZSBhbHdheXNfaWJwYiBjYXNlLCB0YWtlIGEgcGFyYW5vaWQgYXBwcm9hY2ggYW5k
IGlzc3VlDQo+PiArICogSUJQQiBvbiBib3RoIHN3aXRjaF9tbSgpIGFuZCB2Q1BVIHN3aXRjaC4N
Cj4+ICsgKi8NCj4+ICtzdGF0aWMgaW5saW5lIHZvaWQgeDg2X3ZpcnRfZ3Vlc3Rfc3dpdGNoX2li
cGIodm9pZCkNCj4+ICt7DQo+PiArCWlmIChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZzd2l0Y2hf
bW1fYWx3YXlzX2licGIpKQ0KPj4gKwkJaW5kaXJlY3RfYnJhbmNoX3ByZWRpY3Rpb25fYmFycmll
cigpOw0KPiANCj4gSWYgdGhpcyBzd2l0Y2ggaXMgZ29pbmcgdG8gYmUgY29uZGl0aW9uYWwsIHRo
ZW4gbWFrZSBpdCBzbzoNCj4gDQo+IHN0YXRpYyB2b2lkIHg4Nl9kb19jb25kX2licGIodm9pZCkN
Cj4gew0KPiAJaWYgKHN0YXRpY19icmFuY2hfbGlrZWx5KCZzd2l0Y2hfbW1fY29uZF9pYnBiKSkN
Cj4gCQlpbmRpcmVjdF9icmFuY2hfcHJlZGljdGlvbl9iYXJyaWVyKCk7DQo+IH0NCg0KSW4gdGhl
IGNvbnRleHQgb2YgdGhpcyBjaGFuZ2UsIHdlIG9ubHkgd2FudCB0byBkbyB0aGlzIGJhcnJpZXIg
b24gdGhlIGFsd2F5c19pYnBiDQpwYXRoLCBzbyB3ZSB3b3VsZG7igJl0IHdhbnQgdG8gZG8gY29u
dF9pYnBiIGhlcmUsIGJ1dCB5b3UgYnJpbmcgdXAgYSBnb29kIHBvaW50LCANCndlIGNvdWxkIGNo
YW5nZSBpdCB0byB4ODZfZG9fYWx3YXlzX2licGIoKSBhbmQgbW92ZSBpdCB0byBidWdzLmMsIHRo
YXQgd291bGQNCnNpbXBsaWZ5IHRoaW5ncy4gVGhhbmtzLg0KDQo+IA0KPiBhbmQgdGhlcmUncyBu
b3RoaW5nICJ2aXJ0IiBhYm91dCBpdCAtIG1pZ2h0IGFzIHdlbGwgY2FsbCB0aGUgZnVuY3Rpb24N
Cj4gd2hhdCBpdCBkb2VzLiBBbmQgSSdkIHB1dCB0aGF0IGZ1bmN0aW9uIGluIGJ1Z3MuYy4uLg0K
PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvYnVncy5jDQo+PiBpbmRleCA2Mjk2ZTFlYmVkMWQuLjZhYWZiMDI3OWNiYyAx
MDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jDQo+PiArKysgYi9hcmNo
L3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYw0KPj4gQEAgLTY4LDggKzY4LDEyIEBAIHU2NCBfX3JvX2Fm
dGVyX2luaXQgeDg2X2FtZF9sc19jZmdfc3NiZF9tYXNrOw0KPj4gREVGSU5FX1NUQVRJQ19LRVlf
RkFMU0Uoc3dpdGNoX3RvX2NvbmRfc3RpYnApOw0KPj4gLyogQ29udHJvbCBjb25kaXRpb25hbCBJ
QlBCIGluIHN3aXRjaF9tbSgpICovDQo+PiBERUZJTkVfU1RBVElDX0tFWV9GQUxTRShzd2l0Y2hf
bW1fY29uZF9pYnBiKTsNCj4+IC0vKiBDb250cm9sIHVuY29uZGl0aW9uYWwgSUJQQiBpbiBzd2l0
Y2hfbW0oKSAqLw0KPj4gKy8qIENvbnRyb2wgdW5jb25kaXRpb25hbCBJQlBCIGluIGJvdGggc3dp
dGNoX21tKCkgYW5kDQo+PiArICogeDg2X3ZpcnRfZ3Vlc3Rfc3dpdGNoX2licGIoKS4NCj4+ICsg
KiBTZWUgbm90ZXMgb24geDg2X3ZpcnRfZ3Vlc3Rfc3dpdGNoX2licGIoKSBmb3IgS1ZNIHVzZSBj
YXNlIGRldGFpbHMuDQo+PiArICovDQo+PiBERUZJTkVfU1RBVElDX0tFWV9GQUxTRShzd2l0Y2hf
bW1fYWx3YXlzX2licGIpOw0KPj4gK0VYUE9SVF9TWU1CT0xfR1BMKHN3aXRjaF9tbV9hbHdheXNf
aWJwYik7DQo+IA0KPiAuLi4gc28gdGhhdCBJIGRvbid0IGV4cG9ydCB0aGF0IGtleSB0byBtb2R1
bGVzLg0KPiANCj4gSSdkIGxpa2UgdG8gaGF2ZSB0aGUgYmlnIHBpY3R1cmUgY2xhcmlmaWVkIGZp
cnN0LCB3aHkgd2UgbmVlZCB0aGlzLCBldGMuDQoNCk5vIHByb2JsZW0sIGFuZCBJIGFwcHJlY2lh
dGUgdGhlIGhlbHAgYW5kIHJldmlldyEgTGV0IG1lIGtub3cgaWYgdGhlDQphYm92ZSBtYWtlcyBz
ZW5zZSBhbmQgSeKAmW0gaGFwcHkgdG8gaXNzdWUgYSB2NCBwYXRjaCBmb3IgdGhpcy4NCg0KQ2hl
ZXJzLA0KSm9uDQoNCg0KPiBUaHguDQo+IA0KPiAtLSANCj4gUmVnYXJkcy9HcnVzcywNCj4gICAg
Qm9yaXMuDQo+IA0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9
aHR0cHMtM0FfX3Blb3BsZS5rZXJuZWwub3JnX3RnbHhfbm90ZXMtMkRhYm91dC0yRG5ldGlxdWV0
dGUmZD1Ed0lCYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9TkdQUkdHbzM3bVFpU1hnSEtt
NXJDUSZtPVpxaGd5VlhNNXhrcWh4Unlab0ZuNWVkOF95RGhSQUtOcWp0NEp0aHYxVUp4N05Dbmxa
QWtLNV9qSnM0ZE4wV0Emcz1oXzBuaEJjaDJ6bk9OVThOMTNHeFF5eXZTdVNTcTJLcjdZRnBqalI5
dGtvJmU9IA0KDQo=
