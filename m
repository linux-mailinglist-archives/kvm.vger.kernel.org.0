Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A29525665
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 22:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358319AbiELUeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 16:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbiELUef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 16:34:35 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AEA2764D5;
        Thu, 12 May 2022 13:34:34 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CFc86b030319;
        Thu, 12 May 2022 13:33:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=TtdX9jckTJkGWZTN8Nxe688u38w2pHN+8FA0ncZ515k=;
 b=lW3m5tPQcE2hxngOg4FanKY3wyQ60NYMnOoWNanE+9Zr9tHvo0w6kPeHxKqaQYk5lnuk
 onLUSp+U4T+uDqsUGVBFZnQjqdkE5GTXI5zrhGyetYXxpwYc029lc1A2lUtwn4Sm4CrI
 BPQKjguP2qAWStq34DjfkKA0c3lK5y7iQkEhSLuryxFI8qWL8n+QcGHfODRjGhMwbleO
 yNyHMRlGcQUJMpUE5bzYCaq71+EckScsIPrthlDj4lxfZ+53Q4pYUykFJrM93yUsxWuz
 L0AkhTjeksXe8ifseEDqZkrL49rkhoVDC/T3tC3+Nu12TDyCGz8lgkHH61t1tSfk3edl 0w== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwqufushs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 13:33:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFqZDcKz7Y7RBe0eG10ucX1rhUGCjbu2tsG8N5R4owT5+MqybIVNxgovQCr26NwS5PLlKjTMbVkWWJof4LDB5soPAaksDYNhFBwav7IqEoN226kM/r7nPnZa/D8g/6vUA+JOAbFWij0et+iTTjd+RCOu4KKxwl/zlxlCcE3fUetZQg+zPcQGtjC6OyOPX6MiEYCUtEm89Qwjdw2TiRLQiHyJJmGodJ/DMazHvbKQowNc3WPh3OFaFKhSI5pzxPKxLMSBUvAItoTSnYMohrUmqCfw0hYDarS9a32y8Da8/6ArJ125q69KYze28RNp4Hq2QVY5Dp+sKE/b8jxuLY35cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TtdX9jckTJkGWZTN8Nxe688u38w2pHN+8FA0ncZ515k=;
 b=oc+X+4Y/y6islEGI96YvJYuh3Va86IAIgjyXBOnPf59+F479fZyfZJGjOk6GYeQMOVH0hUHQKJ+nMJ/f2/612XUqIgJRDl1eOu0kWlm0EApuOIyCnYRVQt9BEMJ29980zpzNB6zzQaUIY7cNWaa7mXyq89meb+fcZcqnbMH/k+dJemuagKa69ofhwuk+KimqeHzfIBZxK17a6UIduG42nPp6BbHAw5FffYTvB8qpJzXODYGz0hWowYmQM20f2n9bsfy64rRI8FQZFyxzPCrGimoOhyEJZTsf5rxtPN/nSHMHwKJ/3uQSVOivetrqP0mDeFIUCPIRNR/fNh/OwlsINw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by MN2PR02MB6062.namprd02.prod.outlook.com (2603:10b6:208:1bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 20:33:43 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 20:33:43 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Sean Christopherson <seanjc@google.com>,
        Jon Kohler <jon@nutanix.com>, Jonathan Corbet <corbet@lwn.net>,
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
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAIAABIOAgAAFnoCAAAHEAA==
Date:   Thu, 12 May 2022 20:33:43 +0000
Message-ID: <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
 <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
In-Reply-To: <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52ffe1d4-76bd-436a-438c-08da3456b4f1
x-ms-traffictypediagnostic: MN2PR02MB6062:EE_
x-microsoft-antispam-prvs: <MN2PR02MB6062B5085FAD823FBA5578F1AFCB9@MN2PR02MB6062.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dOH0MpOuiJtOyjhm/deKGXzWqd4izMBH8iobZRMZR2xZ3n07Q0eVphw2bkbl6MNI7TGzoCg3Ct6w1O7hP52/0cHXT/HwMIhdP/h20nicgwRrkXE7oIiVX/F7xYCVp04hU9C6FJFjNd6qFkbOAN5rMlTgEgKNg8OUqW3ty5vQi3ShD0JZUEYH4uLWmmtajCRtG+IIVsSTW98ESC2YH/X4gKmIh/45XGM/iJ/UOk0YBLHgJKweYgRK3GjxoKqUG4jT2KhJ+z9wT7VTb0DS0m4aSs1hAy5q+VEurPaUp1qJuOnKH/8r4gY/T13Ue+U+saIfhiyYvw8SYH3L7YeqtspztUgyNTXibrk4ibt77Q57lXHbyn1HFF7xI+o8o0O17JrRBtpSZ60dl71biS1enOibrv1MT+vFlLWoUix9Gi1gQQOlamZU0xjq9N+fvcEtApz4RZf/+BWgDXkC+qgSdqL1+ukYpqo/ze99QdEPDRVLV9Dcb1hZgJFc3nm4eZ1ZUYxwpvzjWVbk6UXFKtI3frAb3t91q98E2t1pglenWJyMuG9rWCgNwz4n+jbFEBntMjQFJnrJLXPVcoG8wxZUNzwMwpUy5cKu7Zrgz1yQVa4kGkfwqmMIGFm2KAUumVpjaG0xhsnq31CypDgsf76I1KWCbPaCwx+3a2F+62jWv66YU1Pz1dBGqtaf2F+Tlw5qMZRfGxSmHZ3nUUdigv+SHWSWKgYYOti+o+Lp7FZ+x2bR605p976EeZYi7huqfxS+z9Rz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(38070700005)(38100700002)(6506007)(53546011)(54906003)(6486002)(86362001)(71200400001)(508600001)(91956017)(4326008)(66556008)(8936002)(2616005)(8676002)(76116006)(66946007)(66476007)(316002)(6916009)(66446008)(6512007)(64756008)(36756003)(83380400001)(122000001)(5660300002)(2906002)(7416002)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGJFYUlpdG5wUGJ5dlBMRGFxSy9tVXJGN2J5d3hBME1pdXdCMkN6bFpTVnR0?=
 =?utf-8?B?THJmSDZWbVdxZjhMdzd0ck1zckgrVk1PQndHU3BDZXlWY1dRMFpocGgwbnZ5?=
 =?utf-8?B?azdHYyt6a2ZiaGV6SS9sSDQyNmdEMjB1cU9IWTE2cTBReGtiYnVwVHV6SjBN?=
 =?utf-8?B?UUZkY2sxVG1mNUN6QmhySkFHa1pIeWxHR00xejRrWnVaUjhxNXI2czR2a05t?=
 =?utf-8?B?MnowVUVzMXlCelFwMXBlcHk4OFkyeVVvMlZYay9YWHFTekM2ZGxzK1RlWWZx?=
 =?utf-8?B?TGl5V0dqR0RqN0hVRVNRNW5HQmxHV05uMnVVK09yd3NHTVJGcWViNUJ0NTRm?=
 =?utf-8?B?QncyeHRwSnZwZHhQOEtHU3BqL01JRkVBV2RJQWpUM05ETW8rRSs0VG5wMDdq?=
 =?utf-8?B?bVI3SU9uYW4zL2dobnFSaGgzMEM5UWREdnp3NXlWYWs5OWV0Q3BaaVp1OHNo?=
 =?utf-8?B?eFdvVnhzQ2w2MzFodlNRbVVzc3daeXhGVGQ1Y0RaU2N5YWhZbWJzVythdjNO?=
 =?utf-8?B?ZjZ6UDkzUlVFM1ViQlJrcnE1Z2pSN1UvV21UT2pPM3dNRTB4YW5RazI3OW1B?=
 =?utf-8?B?RjdlOFJINzVhVFkyTldpVDhZZUpZSTVOTGFGV1JRRjdsaXpXbG1SVDFVSzJq?=
 =?utf-8?B?cm55WjBua1NHS2RsN1pTMkJtK1k3ci93VlFnRnBPUlVtaFlSQUpDay9FY3ZR?=
 =?utf-8?B?RWRPcStocG9ZR1V5eW1KREJpbkNBRnV1RXpYc0RTeERDOWF0YkRxOVZSdVFj?=
 =?utf-8?B?dXBQNWc0VVBnR0sraGtVemppYkdmb3BlWmhsbVBMaGozRG1KZVVtUTFHOW41?=
 =?utf-8?B?WXp5Q0ZpK21jNEtLQVllZ2VOSTkyVHZ4clhmSHQzeWVwUnF1bEpLZ2cvNTBY?=
 =?utf-8?B?NmFpSnNaaTNROVhGT3ZCUGZYblI2eVBjVXFZUWM3N0NKTjZ3MGlqc25YS0dM?=
 =?utf-8?B?NGNKdkcyU0ZZZDRKUTd2anZVNGp2RFAzdzZSWUxFSHRVL2ltWGpnWXAzQ2dV?=
 =?utf-8?B?YUYxV1dzSVdxVXlQbUFHS0dRdGFYSXB5K3dBcStpU3ZFZ1pKZXoxZEdES0FF?=
 =?utf-8?B?cXlTN20wSWgrM011c21ZUEFMWlE2bWR5UWZPK05LZkNRSmIxL2VWcVNLZzEv?=
 =?utf-8?B?RzRzY2NEenlvMzJNK1g1T2JLY212OE5RSm9ZaG5iQVZIZHl2YnVvbTZ0N2d3?=
 =?utf-8?B?ZytSeTFER2trRnlrbUZYT2lpaWowT3I5TjF0V2FtNFE3UGg4eG1VOWhTSVZY?=
 =?utf-8?B?bFpIQUlBN1gyUW41RmgyU2xZSk1GNFNZUDhtaUF4eFlndFNjTTE4TjdLc1p0?=
 =?utf-8?B?aEJyUDdlWlVHS0pXcjRyK3J4WUk4UUFxQVh6eWxXa3JLemtkb2tmeTNvNUJQ?=
 =?utf-8?B?QU1tTTlrODlTNW52c2ZIWW9Qd2lEa1c5OVNqcGJqSXkzNU1KamVkSHFMVWQ1?=
 =?utf-8?B?M0k5NlJTeXJXNWV5NWphKzBwbXlXc3BLUVBBZzdOWlpNTG10N2Y4SjNxNGVw?=
 =?utf-8?B?NTNuN1VCN2FiOFF6NDl1djhtd0xxMFdWa0JON296dHFKWHdFNTBtNW1PeUJu?=
 =?utf-8?B?Q1pjZFZXT1UwVjA1MmM4eG1EM0J3Vi9welRCdkhDVlN1SzM3aStkWkZsSFd4?=
 =?utf-8?B?TGI3UWRnc29hcUVUcGFFbG44R1d5VzJvem16ck4wS3RXZHBLM1IyVGZ1eG9z?=
 =?utf-8?B?U25kVGlCRWFwaDZvWTREaUlqQmh3Vmo1R2VQNkt4ZFVGeTEwbUJLNmovSGY4?=
 =?utf-8?B?NVhGSWc5ZDZOU3RKVGlWR2x5MHdPL1NQeWJjNWlvcDNjbzNzdnErS0IwQ0th?=
 =?utf-8?B?dm8xZFNoQUsrdTNURjI5WE00eFRZY093N1JDMFQ0YkkzNDh5dDVldkF2MTJ4?=
 =?utf-8?B?ZzBEZFRwVFB1YVA0ek0yWnMrZjN1aDFLWnlQNHpIT0kwWWdqR2g2dWttS2tS?=
 =?utf-8?B?YjRmUHAyQXBNVVphU0VSVGRiNGVoYlRkQzNwV1VIZEFZMTZQNlgxcWRGdU5U?=
 =?utf-8?B?alg2a3QwQk1mdFFVSDQ3L2VLYUZvOVJnY2ZFR2RyRmN5dXpqanBJV2xVMTdv?=
 =?utf-8?B?aFlRZllhWElSdTFKcU4vaTBYNU5VcS9JN1ViS01oMFV0dVVvZlNJWFFCTEZK?=
 =?utf-8?B?eFgwQkxFc2E1b2pOYkdTenVNUDRySENwQlZZNnV1NDNoRkYvSDZFTVJ5aFQy?=
 =?utf-8?B?VU9pd1I5bW5jN3RXaGZKSWloZ1RLTUs0WEkzTmxzTjJtTlN6T2EzaHJrdHJT?=
 =?utf-8?B?SlliWHR6dTU4Q2p2UGNSaUhYWURnRThZMFo4MEZOMjZ2QzJZREpMZEhHS3pN?=
 =?utf-8?B?TmtWTzRTdnF6a0J0UDNMeDJEdXJ4bGxqRVIwOHZxdnRlaVNZbkxXY0ZhSEkr?=
 =?utf-8?Q?HX3FrVFlzDUhlShtAsVFZS2srKDfrdaT87LFv944TbYti?=
x-ms-exchange-antispam-messagedata-1: jJBaq7yr6AHW4KK8hFE4fIRNI4d/1lCuiXdnsEyY8GZRf1OvWKRZ5Ao5
Content-Type: text/plain; charset="utf-8"
Content-ID: <715F3CB3D285AF41AD67E11FC5F9727A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ffe1d4-76bd-436a-438c-08da3456b4f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 20:33:43.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fdMWZPoayrTm0PrrA59CKmd70M4wC3LU1hFzxLqKS12yLzyIhHn8wur678kunqgWhOHTJI3UteuccB7aFR4nKxJl2Sx/OAuu9nRhdSCKeQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6062
X-Proofpoint-GUID: fZ6MNxvscv4A-aw7PYO-THmTf2GkE59B
X-Proofpoint-ORIG-GUID: fZ6MNxvscv4A-aw7PYO-THmTf2GkE59B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_17,2022-05-12_01,2022-02-23_01
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

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCA0OjI3IFBNLCBKaW0gTWF0dHNvbiA8am1hdHRzb25A
Z29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIE1heSAxMiwgMjAyMiBhdCAxOjA3IFBN
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4+IA0KPj4g
T24gVGh1LCBNYXkgMTIsIDIwMjIsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4gDQo+Pj4gDQo+Pj4+
IE9uIE1heSAxMiwgMjAyMiwgYXQgMzozNSBQTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+IHdyb3RlOg0KPj4+PiANCj4+Pj4gT24gVGh1LCBNYXkgMTIsIDIwMjIsIFNl
YW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4+PiBPbiBUaHUsIE1heSAxMiwgMjAyMiwgSm9u
IEtvaGxlciB3cm90ZToNCj4+Pj4+PiBSZW1vdmUgSUJQQiB0aGF0IGlzIGRvbmUgb24gS1ZNIHZD
UFUgbG9hZCwgYXMgdGhlIGd1ZXN0LXRvLWd1ZXN0DQo+Pj4+Pj4gYXR0YWNrIHN1cmZhY2UgaXMg
YWxyZWFkeSBjb3ZlcmVkIGJ5IHN3aXRjaF9tbV9pcnFzX29mZigpIC0+DQo+Pj4+Pj4gY29uZF9t
aXRpZ2F0aW9uKCkuDQo+Pj4+Pj4gDQo+Pj4+Pj4gVGhlIG9yaWdpbmFsIGNvbW1pdCAxNWQ0NTA3
MTUyM2QgKCJLVk0veDg2OiBBZGQgSUJQQiBzdXBwb3J0Iikgd2FzIHNpbXBseQ0KPj4+Pj4+IHdy
b25nIGluIGl0cyBndWVzdC10by1ndWVzdCBkZXNpZ24gaW50ZW50aW9uLiBUaGVyZSBhcmUgdGhy
ZWUgc2NlbmFyaW9zDQo+Pj4+Pj4gYXQgcGxheSBoZXJlOg0KPj4+Pj4gDQo+Pj4+PiBKaW0gcG9p
bnRlZCBvZmZsaW5lIHRoYXQgdGhlcmUncyBhIGNhc2Ugd2UgZGlkbid0IGNvbnNpZGVyLiAgV2hl
biBzd2l0Y2hpbmcgYmV0d2Vlbg0KPj4+Pj4gdkNQVXMgaW4gdGhlIHNhbWUgVk0sIGFuIElCUEIg
bWF5IGJlIHdhcnJhbnRlZCBhcyB0aGUgdGFza3MgaW4gdGhlIFZNIG1heSBiZSBpbg0KPj4+Pj4g
ZGlmZmVyZW50IHNlY3VyaXR5IGRvbWFpbnMuICBFLmcuIHRoZSBndWVzdCB3aWxsIG5vdCBnZXQg
YSBub3RpZmljYXRpb24gdGhhdCB2Q1BVMCBpcw0KPj4+Pj4gYmVpbmcgc3dhcHBlZCBvdXQgZm9y
IHZDUFUxIG9uIGEgc2luZ2xlIHBDUFUuDQo+Pj4+PiANCj4+Pj4+IFNvLCBzYWRseSwgYWZ0ZXIg
YWxsIHRoYXQsIEkgdGhpbmsgdGhlIElCUEIgbmVlZHMgdG8gc3RheS4gIEJ1dCB0aGUgZG9jdW1l
bnRhdGlvbg0KPj4+Pj4gbW9zdCBkZWZpbml0ZWx5IG5lZWRzIHRvIGJlIHVwZGF0ZWQuDQo+Pj4+
PiANCj4+Pj4+IEEgcGVyLVZNIGNhcGFiaWxpdHkgdG8gc2tpcCB0aGUgSUJQQiBtYXkgYmUgd2Fy
cmFudGVkLCBlLmcuIGZvciBjb250YWluZXItbGlrZQ0KPj4+Pj4gdXNlIGNhc2VzIHdoZXJlIGEg
c2luZ2xlIFZNIGlzIHJ1bm5pbmcgYSBzaW5nbGUgd29ya2xvYWQuDQo+Pj4+IA0KPj4+PiBBaCwg
YWN0dWFsbHksIHRoZSBJQlBCIGNhbiBiZSBza2lwcGVkIGlmIHRoZSB2Q1BVcyBoYXZlIGRpZmZl
cmVudCBtbV9zdHJ1Y3RzLA0KPj4+PiBiZWNhdXNlIHRoZW4gdGhlIElCUEIgaXMgZnVsbHkgcmVk
dW5kYW50IHdpdGggcmVzcGVjdCB0byBhbnkgSUJQQiBwZXJmb3JtZWQgYnkNCj4+Pj4gc3dpdGNo
X21tX2lycXNfb2ZmKCkuICBIcm0sIHRob3VnaCBpdCBtaWdodCBuZWVkIGEgS1ZNIG9yIHBlci1W
TSBrbm9iLCBlLmcuIGp1c3QNCj4+Pj4gYmVjYXVzZSB0aGUgVk1NIGRvZXNuJ3Qgd2FudCBJQlBC
IGRvZXNuJ3QgbWVhbiB0aGUgZ3Vlc3QgZG9lc24ndCB3YW50IElCUEIuDQo+Pj4+IA0KPj4+PiBU
aGF0IHdvdWxkIGFsc28gc2lkZXN0ZXAgdGhlIGxhcmdlbHkgdGhlb3JldGljYWwgcXVlc3Rpb24g
b2Ygd2hldGhlciB2Q1BVcyBmcm9tDQo+Pj4+IGRpZmZlcmVudCBWTXMgYnV0IHRoZSBzYW1lIGFk
ZHJlc3Mgc3BhY2UgYXJlIGluIHRoZSBzYW1lIHNlY3VyaXR5IGRvbWFpbi4gIEl0IGRvZXNuJ3QN
Cj4+Pj4gbWF0dGVyLCBiZWNhdXNlIGV2ZW4gaWYgdGhleSBhcmUgaW4gdGhlIHNhbWUgZG9tYWlu
LCBLVk0gc3RpbGwgbmVlZHMgdG8gZG8gSUJQQi4NCj4+PiANCj4+PiBTbyBzaG91bGQgd2UgZ28g
YmFjayB0byB0aGUgZWFybGllciBhcHByb2FjaCB3aGVyZSB3ZSBoYXZlIGl0IGJlIG9ubHkNCj4+
PiBJQlBCIG9uIGFsd2F5c19pYnBiPyBPciB3aGF0Pw0KPj4+IA0KPj4+IEF0IG1pbmltdW0sIHdl
IG5lZWQgdG8gZml4IHRoZSB1bmlsYXRlcmFsLW5lc3Mgb2YgYWxsIG9mIHRoaXMgOikgc2luY2Ug
d2XigJlyZQ0KPj4+IElCUELigJlpbmcgZXZlbiB3aGVuIHRoZSB1c2VyIGRpZCBub3QgZXhwbGlj
aXRseSB0ZWxsIHVzIHRvLg0KPj4gDQo+PiBJIHRoaW5rIHdlIG5lZWQgc2VwYXJhdGUgY29udHJv
bHMgZm9yIHRoZSBndWVzdC4gIEUuZy4gaWYgdGhlIHVzZXJzcGFjZSBWTU0gaXMNCj4+IHN1ZmZp
Y2llbnRseSBoYXJkZW5lZCB0aGVuIGl0IGNhbiBydW4gd2l0aG91dCAiZG8gSUJQQiIgZmxhZywg
YnV0IHRoYXQgZG9lc24ndA0KPj4gbWVhbiB0aGF0IHRoZSBlbnRpcmUgZ3Vlc3QgaXQncyBydW5u
aW5nIGlzIHN1ZmZpY2llbnRseSBoYXJkZW5lZC4NCj4+IA0KPj4+IFRoYXQgc2FpZCwgc2luY2Ug
SSBqdXN0IHJlLXJlYWQgdGhlIGRvY3VtZW50YXRpb24gdG9kYXksIGl0IGRvZXMgc3BlY2lmaWNh
bGx5DQo+Pj4gc3VnZ2VzdCB0aGF0IGlmIHRoZSBndWVzdCB3YW50cyB0byBwcm90ZWN0ICppdHNl
bGYqIGl0IHNob3VsZCB0dXJuIG9uIElCUEIgb3INCj4+PiBTVElCUCAob3Igb3RoZXIgbWl0aWdh
dGlvbnMgZ2Fsb3JlKSwgc28gSSB0aGluayB3ZSBlbmQgdXAgaGF2aW5nIHRvIHRoaW5rDQo+Pj4g
YWJvdXQgd2hhdCBvdXIg4oCcY29udHJhY3TigJ0gaXMgd2l0aCB1c2VycyB3aG8gaG9zdCB0aGVp
ciB3b3JrbG9hZHMgb24NCj4+PiBLVk0gLSBhcmUgdGhleSBleHBlY3RpbmcgdXMgdG8gcHJvdGVj
dCB0aGVtIGluIGFueS9hbGwgY2FzZXM/DQo+Pj4gDQo+Pj4gU2FpZCBhbm90aGVyIHdheSwgdGhl
IGludGVybmFsIGd1ZXN0IGFyZWFzIG9mIGNvbmNlcm4gYXJlbuKAmXQgc29tZXRoaW5nDQo+Pj4g
dGhlIGtlcm5lbCB3b3VsZCBhbHdheXMgYmUgYWJsZSB0byBBKSBpZGVudGlmeSBmYXIgaW4gYWR2
YW5jZSBhbmQgQikNCj4+PiBhbHdheXMgc29sdmUgb24gdGhlIHVzZXJzIGJlaGFsZi4gVGhlcmUg
aXMgYW4gYXJndW1lbnQgdG8gYmUgbWFkZQ0KPj4+IHRoYXQgdGhlIGd1ZXN0IG5lZWRzIHRvIGRl
YWwgd2l0aCBpdHMgb3duIGhvdXNlLCB5ZWE/DQo+PiANCj4+IFRoZSBpc3N1ZSBpcyB0aGF0IHRo
ZSBndWVzdCB3b24ndCBnZXQgYSBub3RpZmljYXRpb24gaWYgdkNQVTAgaXMgcmVwbGFjZWQgd2l0
aA0KPj4gdkNQVTEgb24gdGhlIHNhbWUgcGh5c2ljYWwgQ1BVLCB0aHVzIHRoZSBndWVzdCBkb2Vz
bid0IGdldCBhbiBvcHBvcnR1bml0eSB0byBlbWl0DQo+PiBJQlBCLiAgU2luY2UgdGhlIGhvc3Qg
ZG9lc24ndCBrbm93IHdoZXRoZXIgb3Igbm90IHRoZSBndWVzdCB3YW50cyBJQlBCLCB1bmxlc3Mg
dGhlDQo+PiBvd25lciBvZiB0aGUgaG9zdCBpcyBhbHNvIHRoZSBvd25lciBvZiB0aGUgZ3Vlc3Qg
d29ya2xvYWQsIHRoZSBzYWZlIGFwcHJvYWNoIGlzIHRvDQo+PiBhc3N1bWUgdGhlIGd1ZXN0IGlz
IHZ1bG5lcmFibGUuDQo+IA0KPiBFeGFjdGx5LiBBbmQgaWYgdGhlIGd1ZXN0IGhhcyB1c2VkIHRh
c2tzZXQgYXMgaXRzIG1pdGlnYXRpb24gc3RyYXRlZ3ksDQo+IGhvdyBpcyB0aGUgaG9zdCB0byBr
bm93Pw0KDQpZZWEgdGhhdHMgZmFpciBlbm91Z2guIEkgcG9zZWQgYSBzb2x1dGlvbiBvbiBTZWFu
4oCZcyByZXNwb25zZSBqdXN0IGFzIHRoaXMgZW1haWwNCmNhbWUgaW4sIHdvdWxkIGxvdmUgdG8g
a25vdyB5b3VyIHRob3VnaHRzIChrZXlpbmcgb2ZmIE1TUiBiaXRtYXApLg0KDQo=
