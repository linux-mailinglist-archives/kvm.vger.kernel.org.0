Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36947525920
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 02:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359807AbiEMAvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 20:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241356AbiEMAvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 20:51:36 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC36D5E77F;
        Thu, 12 May 2022 17:51:32 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CNepDS023466;
        Thu, 12 May 2022 17:50:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=1eqz2cQegHK6WnFIcp1auUL+mVBkwybqvFJiM9mIWz4=;
 b=hPgUsjYCZjNdwur1wCSsKr24s0nIc7euI5IQIWNfEwVxYYgoWNT6AGQHYrdcsFAtacCW
 ZLqfmbhV13gyC+roilpv16JtH/wpvVwDuqGDTeaTvjgwq5MoGSKRzEClB/uU7Sb0PLG4
 qXfmMQ6z4p4GYwLa0DG0Ef04W+sw7xSOg3Ap4pcNUgo3IMN9B21VJ/VQZQSqe/l+PLys
 /wgqOeM6vy4SyjDu8KE20LYlSL64JZViSBVts4aPWfU1KqS8PQxUNWsgOSAB++N4DlEX
 fgO+82MwUIuW+Crqr4Ojjg3cF297SP7jDd7cftCZ9D5B4b4VtcdXISdnHA8ZhqfSgbQO Tw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwr3fv89y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 17:50:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpT8Uz9Z3iNuoT010L+APS8Qjf0bIdoRjSFv3MI6tYHb/WCV1kPxosq6cjzplyvqiBN3U65OxK9eOZ5DGbQITAttStldxe45zY1FF+fSnKoDLPf63h6N7EoYEcYnrqQEVo1pigbucXKm5w9uPaTcxj0dApQU5/c8ykA7OOjUssNMWXgzf1CWkwBya9GJWrLkhYEFxN+f1CqzX6vZFtPOXUbpNeBYR8gEAGwfPcPT9nH/rsBXCQAE+zoVNBo7xwYCJrzmTq3VYNb3WdHB8/9I/WdIbt+m66XgVHEHUu6Er8yqCpL29PYZ54N/qjZhjlwn7TCBUw73/TGrZvSxWethaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eqz2cQegHK6WnFIcp1auUL+mVBkwybqvFJiM9mIWz4=;
 b=VHgS887cb8QSw4nf2+5x0mpMXm2cWTd3fbT5PXyDoEEFyEJWoOXUpQDyaU0pntkILr3bQ9eaVzJXI6kqwso8J7GcF2tbdmVi/RaZ5Bk1jpQ2hGaMO/dct4EFRZeaElpwDaPVt3Cmyr71uBXL8O5okutArTJJ7a5+YT7A4Oh235vTfxop5ziEAvJWR0k22VOfuZ83FFF7zT+tig/GfHB8hfeack66j8ePR3talv4vNhROpdrkM1kRp61lQKlnbmoBuSImx/vXTImnTjy+JB8cFWmPPGI8TuXcWEw8zdNJ3LBFS6pl2PJy+sOpoEidUP030Ilnfs02WR7P/vVr+3D45A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB5682.namprd02.prod.outlook.com (2603:10b6:208:83::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Fri, 13 May
 2022 00:50:35 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Fri, 13 May 2022
 00:50:35 +0000
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
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAIAABIOAgAAFnoCAAAHEAIAAOOoAgAAO2YA=
Date:   Fri, 13 May 2022 00:50:34 +0000
Message-ID: <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
 <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
 <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
In-Reply-To: <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 920e2482-ff1f-4beb-5463-08da347a96fc
x-ms-traffictypediagnostic: BL0PR02MB5682:EE_
x-microsoft-antispam-prvs: <BL0PR02MB5682F5EF4E2F685BED431AC1AFCA9@BL0PR02MB5682.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aB6Hh91utCIgWYyQXMSMpagjmtTeHqVyGEQTDT6W4sr9i11qc2t6x00zKgbs9lYqON8H3K5z3FbkWpXqW/G5TncLmuOvcAKrGe3LUKiRe+7EPWOBn7ScFRStyZnsrugPt5eiH33RDwGTi6pu7HKcy3SyDV01vlOVynCqXU8NgY6fescieyRA7VHZY9IRZkKyauqTGevIL3FV7KHzYqyrZT16Cm9x+EPk0jX2bn/dnF2jnzRNeoXdlW3nOxDzyvN4AO/b3UEcGfGMy/7m54VCtiPCKSCoNmou5bGRsDt6NMvbuS/GSY0oYEcz67TG9P0GVgaXID7/fE2EIauWa7DJ48TdgLup9M0AL6xnWq02tt8nqjmS/4TQpInD187n2MWqDqXRUK7n8uVEsZeVB+zEGjPI3UAtJ2VRnf8WsdwhvUqiL7fUhi0tQkm2izEDZo5zaevrUW0speb9dv5Eb6QHCGSpVS1C/o5ZbJOZwWlXsKyy3KKE7h1ndKTFNxMnsqUhAvUZRksxVsFb5P5oprWv3Z7CQacuCHOnZ96pJkZESBDUludaS0RuCGKUjI1J3K/VaOF84Ucg6O6VV2T7qRJgE6I4kUM9oxEiFUPRyuMy8z0Ttb49U50StnZUWgmRpiGtNsGjKPUiSG5WGrLCNeGh+g/EAs3yvmMX0pkjTbJOw8g1cf4XuLQs49v75I7tNqaVpSeFW9+D2bd4PUtB4xF1uk/l2/slXiUsnrY3fJAprpo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6506007)(8936002)(2616005)(6512007)(38100700002)(38070700005)(2906002)(186003)(86362001)(7416002)(36756003)(5660300002)(6916009)(66556008)(76116006)(4326008)(66446008)(66946007)(66476007)(8676002)(316002)(33656002)(64756008)(122000001)(508600001)(6486002)(83380400001)(54906003)(71200400001)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGc1NE81N0dmNkYwd3hnZloyUklsQkk4bkFqQ3BkUzhlOTBBQ0RZbVZtVGJL?=
 =?utf-8?B?VitVWnFkWG8xZjdmL0RFbTNrc3hUMHRxNm4vZFA3TFhPaHJCbmZWMnE1elgz?=
 =?utf-8?B?QXlNZVFRN3FoRk5PUUZFZkFmUEQzM0xBWCtJOFVMU3E5enVXTzdlMGtjZkxO?=
 =?utf-8?B?c0d0TU9lRW5HTjNGSmIvZ1FiZzl6VDN2b2t1dHlOVExOMkNQTTZIblpwZzdq?=
 =?utf-8?B?MVQwQkk0SWFlRDZsTGM2RzVHanFHNHJ2OTRWeFJaZ3p2Q0VKVEJHaHNZNkVR?=
 =?utf-8?B?N05qbG45aStxbzg4SWZMbWVxZ21ZQWZHa3hUMHZkTXVIbE8zSzJDOHc0Vll4?=
 =?utf-8?B?WDlJTnZkZCtqdUcvcVk5MTQyTEc4NjNZYlJRODEvUXdGdHVtUVJ4aGdmMkZo?=
 =?utf-8?B?TG5PamdBMGpLa0laYWVXeHdCUE1aWFRld2FYM2dPaUxSNjJqcW1OM2JMRWZr?=
 =?utf-8?B?K0dWSjVYUzN6aVhaLzlwdmN0SGRYZkUrSzRDaENpUDNiQlJULzhPV3BTeFgr?=
 =?utf-8?B?cU1KQyt3cGhXMDZibjB1SzRkd29JOHNScERHZk5rVHcvKzNqd1kwODFJOGN6?=
 =?utf-8?B?ckhQSG4zRHY5YkZXcjB1YlVoeCt3ZFhrcVpxZlkxSmF6ckhYZ0tZRUVabWt2?=
 =?utf-8?B?Y3FLaDdiejR3WE8wSzRrdTRIVHJSMTFEaWJkZ2VhVTA1VzJlMmhXNGJTNkpL?=
 =?utf-8?B?MEdOTXRuLy9yNnJsRzNZQTczQUZEd01rL2RGMjk1QXVoeWxHSndTNEQ0TFZw?=
 =?utf-8?B?VmY1c3BoUmtXZFh5VUtBeHB4TVVxSjRRUkRWdjBsM2hsNGNPVGVRUmtzZEEw?=
 =?utf-8?B?YXNnY0IycWthZUxzOVl0V1ppTWtIS3N5Z0lCME10TEtxbmRMeXAvNy9jVm5F?=
 =?utf-8?B?VG1xbksrQkZXM0ExMXNKUWVtZzRiRG5PSGlQa1FZelVMbW9HM1FlOW5zTDQz?=
 =?utf-8?B?U1I5REtqNzdGai9LYy9BWC9iMGpXRkwvZ2xiVHpPR3BweEtDY2hxNzEzK054?=
 =?utf-8?B?RUZWZXZET3BRK0cvZFVwOURXM0pwdEJRczVJZm4zQmxPb2xLbzB5WXdVNHhn?=
 =?utf-8?B?d1UrZ2V4NVg2RTdTVkdHWlFzM0NTVzZuejlTMmI1K1p6TWlDYzF6RXllN0tL?=
 =?utf-8?B?dVEyZnVKc1V6YXJ1WEU0YVQySThqYUFMS0RZMGlUWDlBWVVkMVEyQmZLZytp?=
 =?utf-8?B?OFVHT0tjMk5DUnRkV09BdDEyOHhTOGRLSFpKTFpCSjhEL011TzBueXRYNlVw?=
 =?utf-8?B?Tys2NU1BNkNzejJoQmVSV2tNWWZ3b0lERDE2dzdWOU9DZDNqUmViMkJXSElD?=
 =?utf-8?B?UlA0UW1QVDdGbkY1UFdDMU5ENU9pUjJWRGRPYnQxdHZJTDlvUUJrN0kwZ2Z1?=
 =?utf-8?B?NmMvdzczTHB6TVVBY29HMkVpSHhBdnY1SU5mdXhBVTVlWE43YjdObnlWZWZN?=
 =?utf-8?B?UVBnMWN6S1hRd1M4Z3BHRlRXcXJiSHpPU2JQcVVIQkFXMUhXS2tINDhUTXRL?=
 =?utf-8?B?bUJDUkZpY1RCNnkzakhFTXg5TjAvcXY3UXFBcDcvRnUwMGhESnBRRDFZTTZQ?=
 =?utf-8?B?MjRGZFpKV0xuOFB5bXZqQklneE81VEFPVDJsNDJWQlpGQmFWMXdURmozZDZr?=
 =?utf-8?B?UWRsd01HdWxIU0lHRmw0SnRCdk0zSmMwZjh5VkJhZk4zR013bFh5QTRoRWVY?=
 =?utf-8?B?QlY3bXlGTG5oQzFOZm9XMU14Q3J2b2dnMm1jZjNLY3VIOGF6ZmwweWpnUkl3?=
 =?utf-8?B?WWxJVngybjlVY2QrWnhBQ0RPeFp3dGFZRGs1R3UwelE4cEdDa0Zpdy83eG5v?=
 =?utf-8?B?aFFaQVFjOUVhN0JSdUpzY25hZDhEc1hmdGs5ZVAzMW9kajZ2T3pnR0IxRlRM?=
 =?utf-8?B?c3l2R2ZEdDU3T09QWmVUeExGUmJyUTR2T0JUSFVaazBBWFBJamlUK0tFN3Fh?=
 =?utf-8?B?Z2dOdmlkQTFDNE1EaThEM0pmZ0Y3S2xkU3RyVkxsN091ODNaa3ZoaExjWERn?=
 =?utf-8?B?YndPelpDc3o3N0VIa0hISEdER3c4WjlnTitBK0RyODd4ZzhrWHpSUGR5TkRx?=
 =?utf-8?B?NVdtZXVuYy9IRWJ0b2JFTE5OOFlDWGZvQlFoY0x3RVYxaS9KczVnV0Qzb3F2?=
 =?utf-8?B?TjdsRTZrRHQzd2czMkdtdW10dC95SDJ4WjZwNStwdGNqSWZTSjl3TThJNkpp?=
 =?utf-8?B?QlgyVlFUK1B2M3hnYjhvN3FVNEh0VWwrSGJBUExzOTNuNGRjMU83TmFMRUwx?=
 =?utf-8?B?S3J6S2F2clYvNmVVTFpteC9YRVk0dUJUU2ZGS0EwU0FFN0hrcHNIZ2l0Q0lV?=
 =?utf-8?B?ZkhnK1NMRy93UzFGenMzZnJiUnBwWUx0d2cwS29GOEFPZTBVb0Q1L0RWbDlO?=
 =?utf-8?Q?J0jJK2CjRpdszzeif3QRblYjhsNNZu7dM7q/9LnLaclnC?=
x-ms-exchange-antispam-messagedata-1: uZbJHDFdoIaNwkXiYC8Hluzr8Pk8uRwxiIM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <535038539A08C24D9882B03B7514BC25@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920e2482-ff1f-4beb-5463-08da347a96fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 00:50:34.9963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Py87YECQi7/dTBwP+/Pru77JPam2QZVoL8XngyHhhnPDsAX+kAYVhuJPmFQbOeZNcxnkk8yUfvmGBUSlLdlgFPQfCx1oP1VuDrhefJG4Kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB5682
X-Proofpoint-GUID: MhichCgmNVL2CK_itj3BlZWE9bCGaIUs
X-Proofpoint-ORIG-GUID: MhichCgmNVL2CK_itj3BlZWE9bCGaIUs
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

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCA3OjU3IFBNLCBKaW0gTWF0dHNvbiA8am1hdHRzb25A
Z29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIE1heSAxMiwgMjAyMiBhdCAxOjM0IFBN
IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IA0KPj4gDQo+Pj4g
T24gTWF5IDEyLCAyMDIyLCBhdCA0OjI3IFBNLCBKaW0gTWF0dHNvbiA8am1hdHRzb25AZ29vZ2xl
LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gVGh1LCBNYXkgMTIsIDIwMjIgYXQgMTowNyBQTSBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4+IA0KPj4+
PiBPbiBUaHUsIE1heSAxMiwgMjAyMiwgSm9uIEtvaGxlciB3cm90ZToNCj4+Pj4+IA0KPj4+Pj4g
DQo+Pj4+Pj4gT24gTWF5IDEyLCAyMDIyLCBhdCAzOjM1IFBNLCBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4+Pj4gDQo+Pj4+Pj4gT24gVGh1LCBNYXkg
MTIsIDIwMjIsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4+Pj4+IE9uIFRodSwgTWF5
IDEyLCAyMDIyLCBKb24gS29obGVyIHdyb3RlOg0KPj4+Pj4+Pj4gUmVtb3ZlIElCUEIgdGhhdCBp
cyBkb25lIG9uIEtWTSB2Q1BVIGxvYWQsIGFzIHRoZSBndWVzdC10by1ndWVzdA0KPj4+Pj4+Pj4g
YXR0YWNrIHN1cmZhY2UgaXMgYWxyZWFkeSBjb3ZlcmVkIGJ5IHN3aXRjaF9tbV9pcnFzX29mZigp
IC0+DQo+Pj4+Pj4+PiBjb25kX21pdGlnYXRpb24oKS4NCj4+Pj4+Pj4+IA0KPj4+Pj4+Pj4gVGhl
IG9yaWdpbmFsIGNvbW1pdCAxNWQ0NTA3MTUyM2QgKCJLVk0veDg2OiBBZGQgSUJQQiBzdXBwb3J0
Iikgd2FzIHNpbXBseQ0KPj4+Pj4+Pj4gd3JvbmcgaW4gaXRzIGd1ZXN0LXRvLWd1ZXN0IGRlc2ln
biBpbnRlbnRpb24uIFRoZXJlIGFyZSB0aHJlZSBzY2VuYXJpb3MNCj4+Pj4+Pj4+IGF0IHBsYXkg
aGVyZToNCj4+Pj4+Pj4gDQo+Pj4+Pj4+IEppbSBwb2ludGVkIG9mZmxpbmUgdGhhdCB0aGVyZSdz
IGEgY2FzZSB3ZSBkaWRuJ3QgY29uc2lkZXIuICBXaGVuIHN3aXRjaGluZyBiZXR3ZWVuDQo+Pj4+
Pj4+IHZDUFVzIGluIHRoZSBzYW1lIFZNLCBhbiBJQlBCIG1heSBiZSB3YXJyYW50ZWQgYXMgdGhl
IHRhc2tzIGluIHRoZSBWTSBtYXkgYmUgaW4NCj4+Pj4+Pj4gZGlmZmVyZW50IHNlY3VyaXR5IGRv
bWFpbnMuICBFLmcuIHRoZSBndWVzdCB3aWxsIG5vdCBnZXQgYSBub3RpZmljYXRpb24gdGhhdCB2
Q1BVMCBpcw0KPj4+Pj4+PiBiZWluZyBzd2FwcGVkIG91dCBmb3IgdkNQVTEgb24gYSBzaW5nbGUg
cENQVS4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFNvLCBzYWRseSwgYWZ0ZXIgYWxsIHRoYXQsIEkgdGhp
bmsgdGhlIElCUEIgbmVlZHMgdG8gc3RheS4gIEJ1dCB0aGUgZG9jdW1lbnRhdGlvbg0KPj4+Pj4+
PiBtb3N0IGRlZmluaXRlbHkgbmVlZHMgdG8gYmUgdXBkYXRlZC4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+
IEEgcGVyLVZNIGNhcGFiaWxpdHkgdG8gc2tpcCB0aGUgSUJQQiBtYXkgYmUgd2FycmFudGVkLCBl
LmcuIGZvciBjb250YWluZXItbGlrZQ0KPj4+Pj4+PiB1c2UgY2FzZXMgd2hlcmUgYSBzaW5nbGUg
Vk0gaXMgcnVubmluZyBhIHNpbmdsZSB3b3JrbG9hZC4NCj4+Pj4+PiANCj4+Pj4+PiBBaCwgYWN0
dWFsbHksIHRoZSBJQlBCIGNhbiBiZSBza2lwcGVkIGlmIHRoZSB2Q1BVcyBoYXZlIGRpZmZlcmVu
dCBtbV9zdHJ1Y3RzLA0KPj4+Pj4+IGJlY2F1c2UgdGhlbiB0aGUgSUJQQiBpcyBmdWxseSByZWR1
bmRhbnQgd2l0aCByZXNwZWN0IHRvIGFueSBJQlBCIHBlcmZvcm1lZCBieQ0KPj4+Pj4+IHN3aXRj
aF9tbV9pcnFzX29mZigpLiAgSHJtLCB0aG91Z2ggaXQgbWlnaHQgbmVlZCBhIEtWTSBvciBwZXIt
Vk0ga25vYiwgZS5nLiBqdXN0DQo+Pj4+Pj4gYmVjYXVzZSB0aGUgVk1NIGRvZXNuJ3Qgd2FudCBJ
QlBCIGRvZXNuJ3QgbWVhbiB0aGUgZ3Vlc3QgZG9lc24ndCB3YW50IElCUEIuDQo+Pj4+Pj4gDQo+
Pj4+Pj4gVGhhdCB3b3VsZCBhbHNvIHNpZGVzdGVwIHRoZSBsYXJnZWx5IHRoZW9yZXRpY2FsIHF1
ZXN0aW9uIG9mIHdoZXRoZXIgdkNQVXMgZnJvbQ0KPj4+Pj4+IGRpZmZlcmVudCBWTXMgYnV0IHRo
ZSBzYW1lIGFkZHJlc3Mgc3BhY2UgYXJlIGluIHRoZSBzYW1lIHNlY3VyaXR5IGRvbWFpbi4gIEl0
IGRvZXNuJ3QNCj4+Pj4+PiBtYXR0ZXIsIGJlY2F1c2UgZXZlbiBpZiB0aGV5IGFyZSBpbiB0aGUg
c2FtZSBkb21haW4sIEtWTSBzdGlsbCBuZWVkcyB0byBkbyBJQlBCLg0KPj4+Pj4gDQo+Pj4+PiBT
byBzaG91bGQgd2UgZ28gYmFjayB0byB0aGUgZWFybGllciBhcHByb2FjaCB3aGVyZSB3ZSBoYXZl
IGl0IGJlIG9ubHkNCj4+Pj4+IElCUEIgb24gYWx3YXlzX2licGI/IE9yIHdoYXQ/DQo+Pj4+PiAN
Cj4+Pj4+IEF0IG1pbmltdW0sIHdlIG5lZWQgdG8gZml4IHRoZSB1bmlsYXRlcmFsLW5lc3Mgb2Yg
YWxsIG9mIHRoaXMgOikgc2luY2Ugd2XigJlyZQ0KPj4+Pj4gSUJQQuKAmWluZyBldmVuIHdoZW4g
dGhlIHVzZXIgZGlkIG5vdCBleHBsaWNpdGx5IHRlbGwgdXMgdG8uDQo+Pj4+IA0KPj4+PiBJIHRo
aW5rIHdlIG5lZWQgc2VwYXJhdGUgY29udHJvbHMgZm9yIHRoZSBndWVzdC4gIEUuZy4gaWYgdGhl
IHVzZXJzcGFjZSBWTU0gaXMNCj4+Pj4gc3VmZmljaWVudGx5IGhhcmRlbmVkIHRoZW4gaXQgY2Fu
IHJ1biB3aXRob3V0ICJkbyBJQlBCIiBmbGFnLCBidXQgdGhhdCBkb2Vzbid0DQo+Pj4+IG1lYW4g
dGhhdCB0aGUgZW50aXJlIGd1ZXN0IGl0J3MgcnVubmluZyBpcyBzdWZmaWNpZW50bHkgaGFyZGVu
ZWQuDQo+Pj4+IA0KPj4+Pj4gVGhhdCBzYWlkLCBzaW5jZSBJIGp1c3QgcmUtcmVhZCB0aGUgZG9j
dW1lbnRhdGlvbiB0b2RheSwgaXQgZG9lcyBzcGVjaWZpY2FsbHkNCj4+Pj4+IHN1Z2dlc3QgdGhh
dCBpZiB0aGUgZ3Vlc3Qgd2FudHMgdG8gcHJvdGVjdCAqaXRzZWxmKiBpdCBzaG91bGQgdHVybiBv
biBJQlBCIG9yDQo+Pj4+PiBTVElCUCAob3Igb3RoZXIgbWl0aWdhdGlvbnMgZ2Fsb3JlKSwgc28g
SSB0aGluayB3ZSBlbmQgdXAgaGF2aW5nIHRvIHRoaW5rDQo+Pj4+PiBhYm91dCB3aGF0IG91ciDi
gJxjb250cmFjdOKAnSBpcyB3aXRoIHVzZXJzIHdobyBob3N0IHRoZWlyIHdvcmtsb2FkcyBvbg0K
Pj4+Pj4gS1ZNIC0gYXJlIHRoZXkgZXhwZWN0aW5nIHVzIHRvIHByb3RlY3QgdGhlbSBpbiBhbnkv
YWxsIGNhc2VzPw0KPj4+Pj4gDQo+Pj4+PiBTYWlkIGFub3RoZXIgd2F5LCB0aGUgaW50ZXJuYWwg
Z3Vlc3QgYXJlYXMgb2YgY29uY2VybiBhcmVu4oCZdCBzb21ldGhpbmcNCj4+Pj4+IHRoZSBrZXJu
ZWwgd291bGQgYWx3YXlzIGJlIGFibGUgdG8gQSkgaWRlbnRpZnkgZmFyIGluIGFkdmFuY2UgYW5k
IEIpDQo+Pj4+PiBhbHdheXMgc29sdmUgb24gdGhlIHVzZXJzIGJlaGFsZi4gVGhlcmUgaXMgYW4g
YXJndW1lbnQgdG8gYmUgbWFkZQ0KPj4+Pj4gdGhhdCB0aGUgZ3Vlc3QgbmVlZHMgdG8gZGVhbCB3
aXRoIGl0cyBvd24gaG91c2UsIHllYT8NCj4+Pj4gDQo+Pj4+IFRoZSBpc3N1ZSBpcyB0aGF0IHRo
ZSBndWVzdCB3b24ndCBnZXQgYSBub3RpZmljYXRpb24gaWYgdkNQVTAgaXMgcmVwbGFjZWQgd2l0
aA0KPj4+PiB2Q1BVMSBvbiB0aGUgc2FtZSBwaHlzaWNhbCBDUFUsIHRodXMgdGhlIGd1ZXN0IGRv
ZXNuJ3QgZ2V0IGFuIG9wcG9ydHVuaXR5IHRvIGVtaXQNCj4+Pj4gSUJQQi4gIFNpbmNlIHRoZSBo
b3N0IGRvZXNuJ3Qga25vdyB3aGV0aGVyIG9yIG5vdCB0aGUgZ3Vlc3Qgd2FudHMgKUlCUEIsIHVu
bGVzcyB0aGUNCj4+Pj4gb3duZXIgb2YgdGhlIGhvc3QgaXMgYWxzbyB0aGUgb3duZXIgb2YgdGhl
IGd1ZXN0IHdvcmtsb2FkLCB0aGUgc2FmZSBhcHByb2FjaCBpcyB0bw0KPj4+PiBhc3N1bWUgdGhl
IGd1ZXN0IGlzIHZ1bG5lcmFibGUuDQo+Pj4gDQo+Pj4gRXhhY3RseS4gQW5kIGlmIHRoZSBndWVz
dCBoYXMgdXNlZCB0YXNrc2V0IGFzIGl0cyBtaXRpZ2F0aW9uIHN0cmF0ZWd5LA0KPj4+IGhvdyBp
cyB0aGUgaG9zdCB0byBrbm93Pw0KPj4gDQo+PiBZZWEgdGhhdHMgZmFpciBlbm91Z2guIEkgcG9z
ZWQgYSBzb2x1dGlvbiBvbiBTZWFu4oCZcyByZXNwb25zZSBqdXN0IGFzIHRoaXMgZW1haWwNCj4+
IGNhbWUgaW4sIHdvdWxkIGxvdmUgdG8ga25vdyB5b3VyIHRob3VnaHRzIChrZXlpbmcgb2ZmIE1T
UiBiaXRtYXApLg0KPj4gDQo+IA0KPiBJIGRvbid0IGJlbGlldmUgdGhpcyB3b3Jrcy4gVGhlIElC
UEJzIGluIGNvbmRfbWl0aWdhdGlvbiAoc3RhdGljIGluDQo+IGFyY2gveDg2L21tL3RsYi5jKSB3
b24ndCBiZSB0cmlnZ2VyZWQgaWYgdGhlIGd1ZXN0IGhhcyBnaXZlbiBpdHMNCj4gc2Vuc2l0aXZl
IHRhc2tzIGV4Y2x1c2l2ZSB1c2Ugb2YgdGhlaXIgY29yZXMuIEFuZCwgaWYgcGVyZm9ybWFuY2Ug
aXMgYQ0KPiBjb25jZXJuLCB0aGF0IGlzIGV4YWN0bHkgd2hhdCBzb21lb25lIHdvdWxkIGRvLg0K
DQpJ4oCZbSB0YWxraW5nIGFib3V0IHdpdGhpbiB0aGUgZ3Vlc3QgaXRzZWxmLCBub3QgdGhlIGhv
c3QgbGV2ZWwgY29uZF9taXRpZ2F0aW9uLg0KDQpUaGUgcHVycG9zZWQgaWRlYSBoZXJlIHdvdWxk
IGJlIHRvIGxvb2sgYXQgdGhlIE1TUiBiaXRtYXAgdGhhdCBpcw0KcG9wdWxhdGVkIGZyb20gdGhl
IGd1ZXN0IHdyaXRpbmcgSUJQQiB0byB0aGF0IHZDUFUgYXQgbGVhc3Qgb25jZQ0KaW4gaXRzIGxp
ZmV0aW1lLCBhbmQgdGhhdCBhIHNlY3VyaXR5IG1pbmRlZCB3b3JrbG9hZCB3b3VsZCBpbmRlZWQN
CmNvbmZpZ3VyZSBJQlBCLg0KDQpFdmVuIHdpdGggdGFza3NldCwgb25lIHdvdWxkIHRoaW5rIHRo
YXQgYSBzZWN1cml0eSBtaW5kZWQgdXNlciB3b3VsZA0KYWxzbyBzZXR1cCBJQlBCIHRvIHByb3Rl
Y3QgaXRzZWxmIHdpdGhpbiB0aGUgZ3Vlc3QsIHdoaWNoIGlzIGV4YWN0bHkgDQp3aGF0IHRoZSBs
aW51eCBhZG1pbiBndWlkZSBzdWdnZXN0cyB0aGF0IHRoZXkgZG8gKGluIHNwZWN0cmUucnN0KS4N
Cg0KVGFraW5nIGEgc3RlcCBiYWNrIGFuZCBnb2luZyBiYWNrIHRvIHRoZSBncm91bmQgZmxvb3I6
DQpXaGF0IHdvdWxkIGJlIChvciBzaG91bGQgYmUpIHRoZSBleHBlY3RhdGlvbiBmcm9tIHRoZSBn
dWVzdCBpbg0KdGhpcyBleGFtcGxlIGZvciB0aGVpciBvd24gc2VjdXJpdHkgY29uZmlndXJhdGlv
bj8NCg0KaS5lLiB0aGV5IGFyZSB1c2luZyB0YXNrc2V0IHRvIGFzc2lnbiBzZWN1cml0eSBkb21h
aW4gMCB0byB2Y3B1IDAgYW5kDQpzZWN1cml0eSBkb21haW4gMSB0byB2Y3B1IDEuIFdvdWxkIHdl
IGV4cGVjdCB0aGVtIHRvIGFsd2F5cyBzZXQgdXANCmNvbmRfaWJwYiAoYW5kIHByY3RsL3NlY2Nv
bXApIHRvIHByb3RlY3QgYWdhaW5zdCBvdGhlciBjYXN1YWwgdXNlcg0Kc3BhY2UgdGhyZWFkcyB0
aGF0IGp1c3QgbWlnaHQgc28gaGFwcGVuIHRvIGdldCBzY2hlZHVsZWQgaW50byB2Y3B1MC8xPw0K
T3IgYXJlIHdlIGV4cGVjdGluZyB0aGVtIHRvIGNvbmZpZ3VyZSBhbHdheXNfaWJwYj8NCg0KSW4g
c3VjaCBhIHNlY3VyaXR5IG1pbmRlZCBzY2VuYXJpbywgd2hhdCB3b3VsZCBiZSB0aGUgZXhwZWN0
YXRpb24NCm9mIGhvc3QgY29uZmlndXJhdGlvbj8NCg0KSWYgbm90aGluZyBlbHNlLCBJ4oCZZCB3
YW50IHRvIG1ha2Ugc3VyZSB3ZSBnZXQgdGhlIGRvY3MgY29ycmVjdCA6KQ0KDQpZb3UgbWVudGlv
bmVkIGlmIHNvbWVvbmUgd2FzIGNvbmNlcm5lZCBhYm91dCBwZXJmb3JtYW5jZSwgYXJlIHlvdQ0K
c2F5aW5nIHRoZXkgYWxzbyBjcml0aWNhbGx5IGNhcmUgYWJvdXQgcGVyZm9ybWFuY2UsIHN1Y2gg
dGhhdCB0aGV5IGFyZQ0Kd2lsbGluZyB0byAqbm90KiB1c2UgSUJQQiBhdCBhbGwsIGFuZCBpbnN0
ZWFkIGp1c3QgdXNlIHRhc2tzZXQgYW5kIGhvcGUNCm5vdGhpbmcgZXZlciBnZXRzIHNjaGVkdWxl
ZCBvbiB0aGVyZSwgYW5kIHRoZW4gaG9wZSB0aGF0IHRoZSBoeXBlcnZpc29yDQpkb2VzIHRoZSBq
b2IgZm9yIHRoZW0/DQoNCldvdWxkIHRoaXMgYmUgdGhlIGV4cGVjdGF0aW9uIG9mIGp1c3QgS1ZN
PyBPciBhbGwgaHlwZXJ2aXNvcnMgb24gdGhlDQptYXJrZXQ/DQoNCkFnYWluIG5vdCB0cnlpbmcg
dG8gYmUgYSBoYXJkIGhlYWQsIGp1c3QgdHJ5aW5nIHRvIHdyYXAgbXkgb3duIGhlYWQNCmFyb3Vu
ZCBhbGwgb2YgdGhpcy4gSSBhcHByZWNpYXRlIHRoZSB0aW1lIGZyb20gYm90aCB5b3UgYW5kIFNl
YW4hIA0KDQpDaGVlcnMsDQpKb24NCg0K
