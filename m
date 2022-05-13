Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C145259FD
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 05:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376687AbiEMDUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 23:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354961AbiEMDUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 23:20:08 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02AE1EEE28;
        Thu, 12 May 2022 20:20:03 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CMtKDC004009;
        Thu, 12 May 2022 20:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=S0RAPzZ9DywYvN1T9Ao6EsM4yd62fUBLriessxcX0hU=;
 b=jPO/VnHBH3THzsMzvhi2ibtWiAZzImUX5HQPmfKSt5Rn9xAcu6TCtvXx4O3XBcTyCNue
 0y9fOEVudYL6skchp2nmwe2kqzUhpU3N2eFbFZLTBwNVqQIOM/7GfXVw/m6d69NnQWYd
 eaZi7L/dxDKs87tgxql7wh0ivFFePxACnSPXHtmH6d5j2WfyLgQQ7YpyuepwABR/llNf
 U0VOFbWXlMga6Vx9gcTHsLN9crotZOMrvPwTOXb5o+kaHgFeKGlWcqZYJELZ3RIjFji9
 7nXIKPOLsK+1N5I0jjy7XwD0gV0d33ACXZmC7cn7MJ8WV18dnwr6I9MdRWmMWe73uaWI OA== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3g08g74urm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 20:19:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxI515bMu7AbB8Nzj/AQKdrNlSB0xo3UJqhY2UpEvWznZKh7W3svjgE6lZseZutUSfNe5zSBig4pG0usLP4j8+y2Wbqe+NnDpbjAQc2kEiP5EkYpiua0q8wP4y+BxS7LvohmdsykwCvyYwiEMTqBBJ6AyDllofF8CWWMIBsYN/Sz+WwAdQiTHx41nVuPvnSIOY59+hYpP12wpLiYoRgUXjwhoTHD176FTYH1yNYdsYFoXmffzCGZtLevlrysllfgIJ2n11f5ruKOd40zx8FAajd6bOvdwMAN64dNU6cbkUuXWVhDX6G3F3NsONmseHyx6POnpU1X0geJjXgvoi4kIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0RAPzZ9DywYvN1T9Ao6EsM4yd62fUBLriessxcX0hU=;
 b=YxIdu3bT32EoUT5Ev1dLFL2wj+HI7qmRR12pBOWkinQoBaXZSz5F42CV3zjduAhctgzwtotRbahZsuxxYbO8dIaTuXEKxJDRZGQ23evFTmbqK5qy0GLSASh2CAeQnqFxgzHIVkH/1eXMtT3h6CK/HBFFVwbYkA5BBGIYAxiVXRL/CikS/D7Uti/W2NEWyOkgFvtEeQM+Q9T70XC+qJq1S9uOo0P2hSM9fmljVnoL7hcuUiR4XyI/COfmDK97ww50c+Dmh/GPVDC+P3m4FvUHPLU7kIGEsKiNII9jROwaEoKJO93aiKF8lgzKg37wE0FXi2zHnnE5iiecbHUFer1d2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BY5PR02MB6676.namprd02.prod.outlook.com (2603:10b6:a03:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 03:19:09 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Fri, 13 May 2022
 03:19:09 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Topic: [PATCH v4] x86/speculation, KVM: remove IBPB on vCPU load
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAIAABIOAgAAFnoCAAAHEAIAAOOoAgAAO2YCAACYTgIAAA2+A
Date:   Fri, 13 May 2022 03:19:08 +0000
Message-ID: <CD2EB6FA-E17F-45BA-AC70-92CCB12A16C4@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
 <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
 <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
 <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com>
 <CALMp9eTwH9WVD=EuTXeu1KYAkAUuXdnmA+k9dti7OM+u=kLKHQ@mail.gmail.com>
In-Reply-To: <CALMp9eTwH9WVD=EuTXeu1KYAkAUuXdnmA+k9dti7OM+u=kLKHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce768b78-e2fb-4d07-071a-08da348f581e
x-ms-traffictypediagnostic: BY5PR02MB6676:EE_
x-microsoft-antispam-prvs: <BY5PR02MB66764616019148D15C407385AFCA9@BY5PR02MB6676.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ptYmV/FOUxNpLmEx36XBlrmvH4WaVl9GJx6YqAuK4eetQTc0FTtMc4dWhHAU99OvJbG08A8S5Z7TmWsmOoyBicFX/wS999RSbVwF4nF3ANWZ/pyi/DadZNMTiur/tr5ZCdzXTkhrbFN7NsCxzIvKXapr2LlWleUhiEohhLdOwg93A4qXJYeFlN3TMcQtpN7jbvblOAvHakLXiTPvwrZ03qAtLZw0qnTbZcgdQeyKhvPxztPlnZYyixQ1OLSdIDEWv8lF29cOVqmwKGGwnjv3TMKge/Rl7ZYQ5vNZTIiB05Tr2UNzkhEmngLCd/Dny2OctNTlBPIwdOwIao0MQpJZYGrjBXbbzWkwKWRBJppEiZTjGuC6XlSbya81DutsgLRmAaFxlFXLgppFxhVTFDlcE3UfZ2q0jl8UvRQk0yYJuIc00xg3Nj6u2UN8hqq0O4nRbsQ9KEGBcpqWyVipPofglol8dWhVUSP0/G7PqNbFTYIQIfK5hDXSFp53JbBF6RqcTYN+9SLYhvHRThBvFSQ7BuF3QmfrlXmFkrtQJ+8bv5idZoxP+oTQkSpb4N4dkKYhlwRlx/yWp47S0qWxZenYvAfDYdEknQ82xt43TW5GqC3U154FZy3GMdt9m0KJOCplk2UonDgzJ+sJ3O46oUmve3BacFPiIUykKlLDb1pkVrXTeqVrYHgj6h4m43/XpQ1cK+FFtLZaOM2/G47JrM19zUOoUnmne5SaMEjMPcEEeDk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66476007)(36756003)(33656002)(64756008)(66946007)(66556008)(5660300002)(66446008)(4326008)(76116006)(91956017)(6486002)(71200400001)(316002)(6916009)(54906003)(2906002)(7416002)(508600001)(122000001)(38070700005)(38100700002)(8936002)(86362001)(6506007)(53546011)(186003)(83380400001)(6512007)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWdzY1VDN0YveUZzd2R1UlQwTHhDK1Q5bm9EbFZBYjRuUWpJTnNPZnB4eG5y?=
 =?utf-8?B?emtHeFRWZEswSlZpbjVyb3lGcmxCNCt3d1hrRWh6aWxiYmNBTjkwTk9qVjNR?=
 =?utf-8?B?M29qY1Z4c21sdWhMWFppaTg2UWRYL3loUnFIZXNNTTJkREdYSUpMdUtDUDJE?=
 =?utf-8?B?bWN0NW9KNkU3aEFlQUpJY2VYMmtubGYraUlwZWF4Ym1WNzlMdlFTTnU4MXM2?=
 =?utf-8?B?Q1BoSElROThEN29wZ0M1RTRaKy9XMmxMVWVsYVh6RzJhbmxibGdwT1UxOEpi?=
 =?utf-8?B?bHlSME1TQ2pPMVhnSDFWK3h6NlhCR0tNTFNSYnFnZEp2SVY1ZE5zQnBFM2VP?=
 =?utf-8?B?c2hOa0FONnM2YUlsVVdRdm1ZYnlQZWFvVkRPU1VuYXg4VWdFMk5wZVpqRDh4?=
 =?utf-8?B?czJsYjNzU2JsZC9aSVFkWmJ6Vkd3TzJkSk1sV3lNbkE0UnU3bm50U3VPM3F1?=
 =?utf-8?B?bVlrekVJRWswR1l2dzdtR3doc1lMRCs5WlBEVHQrNm1OcGtaY2hFVGhIM0NJ?=
 =?utf-8?B?dTlsemphRDZtNDFXaXdUQkhMeDk2azBsSGRxd3VFS2JENDAvN0xIUk11TFdJ?=
 =?utf-8?B?U0dvS0hZTm9PYktXZENUaGlMSXlrUkVaVWNtZ2JWZ2xmOGFMd3VFYlhhY0Z5?=
 =?utf-8?B?WTU4ZGtUbTMyNHNjWEFpZXNZaG5LdjcrRXlUWU1jM0VUZTlZM0FvRVZ0NlpQ?=
 =?utf-8?B?d014Q2pXSDZEVWpZVCtscHBXZm1PWkVLNTVKMVcvWU9XYWYzTEZoUUpZNGFE?=
 =?utf-8?B?aW14bFBPZGY4a3phdkVUN1ZpSm5nd1o1RnpzWERyWnZUS0s5UFdadWZ0MzJh?=
 =?utf-8?B?T3dGZi9qc3RTZVYxN0QxV2UvQzlhT0pTaTBHUjI5dy9EL0JqZGw3aDBoMjQr?=
 =?utf-8?B?dVpxdzZzblpua3VxQUgwRVY1V1dxWFkrd1FDbHRnWURRQUduaHpROHNMZlUy?=
 =?utf-8?B?TFNDZCt2V25zMUJQckZYZEVwS09zT0hXVzErRkFucTJQV1FiN3NHUlJRMUxP?=
 =?utf-8?B?bEJoS0t1SjdpR0ZKeWZXOXYxREVSNVFsMTd6ZFliM1d3S2NDNzkxVE8yRnFn?=
 =?utf-8?B?RmpiVEFhNi9YMGp3Z2lrWEhxczFidldjay9Cdm5KRHNKWk1lSWRlNXVxV1VP?=
 =?utf-8?B?M1d2d2pWU0lDOHJybDVEZEFIbmFEL1ZpUHVtbFRudkRsZDVyU01yaGVPSExz?=
 =?utf-8?B?dnJxajdTS0o3NUE1ak9RcjUwa0tLd3RPNFJoMncvRkJwbmgwemJhdVl3Wk5Y?=
 =?utf-8?B?ZmswbEZIQ21YUnNycUk1RXlTSGlicFdrVVBKdHdjMmNjRHF0ZHRzbVZ3RDJj?=
 =?utf-8?B?bnZuWFpUdGpSNEZaUCtzUElxMUY0QmxEYy9YZDkzNWY0VDFEdjNtRmR4R2RG?=
 =?utf-8?B?UWhaN201c0lEVUNnKzdoQVVDTW5sSHlSczkyYnBrK0dVOWhOSWRiY2tqRFM3?=
 =?utf-8?B?bWt3V0RiSG9xTG1GU25CanNZYzVLZVhoemRQaXdJa2I0V3I0YmVUTlhEWDlV?=
 =?utf-8?B?OC9BM2U0WjdlVmdIbWFMM0k4cmRrcTA2bUdiaVorcmxLcDI3WTdLTWlvUWdU?=
 =?utf-8?B?UmpEanA1MzBaZGRjYWExbE0xM1JIKzhpMk9tcjVLMHlKcGE1U3hXMHFLam5L?=
 =?utf-8?B?S2hHS1FpRFZ1dFA5NFpmVklZY1U5SGJPUHRveGlOQk0vUlR4TUc1MzBMUkF6?=
 =?utf-8?B?Yjl3d3V1NkJPR1pid2Vjc0hOOHlIKys5L2tOMzRqcVgyaWxmc1crT1A5TEx0?=
 =?utf-8?B?QjFYRXVjN052SDZVak51VUt5cHhBa2QvWnU5cTJHMXAxMVJHWFNXZlRwYTkr?=
 =?utf-8?B?RkpwT3VibzI3cURqUzJkMFpSYXhQRXBKOSsxRnl4enBhKzgxRGV1dEl3anRW?=
 =?utf-8?B?b0dKejhCV2dJT3h5cnpMaFprRFpPSWNnUXRiZGUyTVlFam5IMDhHOUkzQ3l1?=
 =?utf-8?B?eDRhZVVWMHVJRHV0NWh1NWlFei9RWW5ySkY4NXJBV29WMVlaWEVYYWpPL1lz?=
 =?utf-8?B?WlpBN25HMFpKcDluRDlFWHZGQ2kyV0lKcXlTUVF3SGJNOHgvbnBIWkVjbXlP?=
 =?utf-8?B?blFEeU1vZ0p1K1liQ0V6UUorcVdZK0p2SEJ3azdCVnVCaStqN2RGcVdIZ1F5?=
 =?utf-8?B?SEZFc0s0VE1ZMFRiUEpGU1hRdG5GV2hsdTJPODlMalZMWHorS1lubi8rVHNs?=
 =?utf-8?B?TGJENDh0N2ZNRkZCelJGZU5IUmFnOWdWVTE4N0JnKzI1WkNoSkwycWRrSnVH?=
 =?utf-8?B?ZlNmOEJrdG8vQzZwSHg5SDlBUGs1amU0c3lCTnZhTXJCL1ZtQ0x2NmhHRmlx?=
 =?utf-8?B?VnVBYnNpbENkZTVSeXZrbmExMTVtbTB2WDg3UFFlU21yMm9vUm1HZlNaUE9z?=
 =?utf-8?Q?SyFv/Cp1BnF5Acqo947pqIoFs2wzEu1rRWAb4AH0MVR7b?=
x-ms-exchange-antispam-messagedata-1: tAlSbtXdvVvfBvChHZ48dhxF5TQ1puX+3Bo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65F8A253BA444841AFEF92959A498173@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce768b78-e2fb-4d07-071a-08da348f581e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 03:19:08.9052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7hkRJJ2yiX6hIjF8S6bod0zhfwT3PorgORYnr7zHkMkRPeFT1nZxa27iiCwbkRpskBmAbed95/oDmU83fZCJO/zHDY0mJpPJLmi3ybZM3co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6676
X-Proofpoint-ORIG-GUID: wAn5GfmB05iiVMkhKPdYtFcwlr33OUiR
X-Proofpoint-GUID: wAn5GfmB05iiVMkhKPdYtFcwlr33OUiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_19,2022-05-12_01,2022-02-23_01
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

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCAxMTowNiBQTSwgSmltIE1hdHRzb24gPGptYXR0c29u
QGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBNYXkgMTIsIDIwMjIgYXQgNTo1MCBQ
TSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPiANCj4+IFlvdSBtZW50aW9u
ZWQgaWYgc29tZW9uZSB3YXMgY29uY2VybmVkIGFib3V0IHBlcmZvcm1hbmNlLCBhcmUgeW91DQo+
PiBzYXlpbmcgdGhleSBhbHNvIGNyaXRpY2FsbHkgY2FyZSBhYm91dCBwZXJmb3JtYW5jZSwgc3Vj
aCB0aGF0IHRoZXkgYXJlDQo+PiB3aWxsaW5nIHRvICpub3QqIHVzZSBJQlBCIGF0IGFsbCwgYW5k
IGluc3RlYWQganVzdCB1c2UgdGFza3NldCBhbmQgaG9wZQ0KPj4gbm90aGluZyBldmVyIGdldHMg
c2NoZWR1bGVkIG9uIHRoZXJlLCBhbmQgdGhlbiBob3BlIHRoYXQgdGhlIGh5cGVydmlzb3INCj4+
IGRvZXMgdGhlIGpvYiBmb3IgdGhlbT8NCj4gDQo+IEkgYW0gc2F5aW5nIHRoYXQgSUJQQiBpcyBu
b3QgdGhlIG9ubHkgdmlhYmxlIG1pdGlnYXRpb24gZm9yDQo+IGNyb3NzLXByb2Nlc3MgaW5kaXJl
Y3QgYnJhbmNoIHN0ZWVyaW5nLiBQcm9wZXIgc2NoZWR1bGluZyBjYW4gYWxzbw0KPiBzb2x2ZSB0
aGUgcHJvYmxlbSwgd2l0aG91dCB0aGUgb3ZlcmhlYWQgb2YgSUJQQi4gU2F5IHRoYXQgeW91IGhh
dmUgdHdvDQo+IHNlY3VyaXR5IGRvbWFpbnM6IHRydXN0ZWQgYW5kIHVudHJ1c3RlZC4gSWYgeW91
IGhhdmUgYSB0d28tc29ja2V0DQo+IHN5c3RlbSwgYW5kIHlvdSBhbHdheXMgcnVuIHRydXN0ZWQg
d29ya2xvYWRzIG9uIHNvY2tldCMwIGFuZCB1bnRydXN0ZWQNCj4gd29ya2xvYWRzIG9uIHNvY2tl
dCMxLCBJQlBCIGlzIGNvbXBsZXRlbHkgc3VwZXJmbHVvdXMuIEhvd2V2ZXIsIGlmIHRoZQ0KPiBo
eXBlcnZpc29yIGNob29zZXMgdG8gc2NoZWR1bGUgYSB2Q1BVIHRocmVhZCBmcm9tIHZpcnR1YWwg
c29ja2V0IzANCj4gYWZ0ZXIgYSB2Q1BVIHRocmVhZCBmcm9tIHZpcnR1YWwgc29ja2V0IzEgb24g
dGhlIHNhbWUgbG9naWNhbA0KPiBwcm9jZXNzb3IsIHRoZW4gaXQgKm11c3QqIGV4ZWN1dGUgYW4g
SUJQQiBiZXR3ZWVuIHRob3NlIHR3byB2Q1BVDQo+IHRocmVhZHMuIE90aGVyd2lzZSwgaXQgaGFz
IGludHJvZHVjZWQgYSBub24tYXJjaGl0ZWN0dXJhbA0KPiB2dWxuZXJhYmlsaXR5IHRoYXQgdGhl
IGd1ZXN0IGNhbid0IHBvc3NpYmx5IGJlIGF3YXJlIG9mLg0KPiANCj4gSWYgeW91IGNhbid0IHRy
dXN0IHlvdXIgT1MgdG8gc2NoZWR1bGUgdGFza3Mgd2hlcmUgeW91IHRlbGwgaXQgdG8NCj4gc2No
ZWR1bGUgdGhlbSwgY2FuIHlvdSByZWFsbHkgdHJ1c3QgaXQgdG8gcHJvdmlkZSB5b3Ugd2l0aCBh
bnkga2luZCBvZg0KPiBpbnRlci1wcm9jZXNzIHNlY3VyaXR5Pw0KDQpGYWlyIGVub3VnaCwgc28g
Z29pbmcgZm9yd2FyZDoNClNob3VsZCB0aGlzIGJlIG1hbmRhdG9yeSBpbiBhbGwgY2FzZXM/IEhv
dyB0aGlzIHdob2xlIGVmZm9ydCBjYW1lDQp3YXMgdGhhdCBhIHVzZXIgY291bGQgY29uZmlndXJl
IHRoZWlyIEtWTSBob3N0IHdpdGggY29uZGl0aW9uYWwNCklCUEIsIGJ1dCB0aGlzIHBhcnRpY3Vs
YXIgbWl0aWdhdGlvbiBpcyBub3cgYWx3YXlzIG9uIG5vIG1hdHRlciB3aGF0Lg0KDQpJbiBvdXIg
cHJldmlvdXMgcGF0Y2ggcmV2aWV3IHRocmVhZHMsIFNlYW4gYW5kIEkgbW9zdGx5IHNldHRsZWQg
b24gbWFraW5nDQp0aGlzIHBhcnRpY3VsYXIgYXZlbnVlIGFjdGl2ZSBvbmx5IHdoZW4gYSB1c2Vy
IGNvbmZpZ3VyZXMgYWx3YXlzX2licGIsIHN1Y2gNCnRoYXQgZm9yIGNhc2VzIGxpa2UgdGhlIG9u
ZSB5b3UgZGVzY3JpYmUgKGFuZCBvdGhlcnMgbGlrZSBpdCB0aGF0IGNvbWUgdXAgaW4NCnRoZSBm
dXR1cmUpIGNhbiBiZSBjb3ZlcmVkIGVhc2lseSwgYnV0IGZvciBjb25kX2licGIsIHdlIGNhbiBk
b2N1bWVudA0KdGhhdCBpdCBkb2VzbuKAmXQgY292ZXIgdGhpcyBjYXNlLiANCg0KV291bGQgdGhh
dCBiZSBhY2NlcHRhYmxlIGhlcmU/DQoNCj4gDQo+PiBXb3VsZCB0aGlzIGJlIHRoZSBleHBlY3Rh
dGlvbiBvZiBqdXN0IEtWTT8gT3IgYWxsIGh5cGVydmlzb3JzIG9uIHRoZQ0KPj4gbWFya2V0Pw0K
PiANCj4gQW55IGh5cGVydmlzb3IgdGhhdCBkb2Vzbid0IGRvIHRoaXMgaXMgYnJva2VuLCBidXQg
dGhhdCB3b24ndCBrZWVwIGl0DQo+IG9mZiB0aGUgbWFya2V0LiA6LSkNCg0KVmVyeSB0cnVlIDop
DQoNCg==
