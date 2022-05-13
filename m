Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4BC5265F5
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 17:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381932AbiEMPWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 11:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381922AbiEMPWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 11:22:51 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F8767D3B;
        Fri, 13 May 2022 08:22:49 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D8nDUr013934;
        Fri, 13 May 2022 08:21:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=LhbnfsDbSu6+rHFDCycfGIKJSDg+SyE+po39nmJmHf8=;
 b=uJl19bxcquwqjAM2raTLXwGZYZBmC9bKs6oagUz6SS+O1k6hLCjNP/V2JrjcxoHePkgm
 zjHjkr1n4OTXo7FHWAjUhBxnX3Akzmqe575RjW6PDmu3wS+xiGTeM99uqM3PlpKIUJ+a
 eNKhnC3Q4wpxMV+PZzPUHo6y3pcXVYGc7u4a7foYfdlfIVF5AZH3aOYYogP67Ri0tgdB
 g73TbiwoqoYwPFD09hOhU+P6yw8T8liRjpNV0gYjYwQaAWH0SXK6BbSUSJyQNPNFa+yx
 8wluRJ/q7PwiTJPIHmXQJufUIkbb3S2p04Ct6adXpiqzu478ZixnocEntI+DZrQjooZs Eg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fwrdpdq4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 08:21:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rl1wpCMsUymYhaxIvRTgDsG5JiPMx+4oYtunHZlkMNKejCYBB3v/GPbyQ/DV4aGl+qnxj3IsV9s/H/K2pIhXxI5Zm3WViixGdGRw7OoAIzpdc4A9R0v6yaiHH4yfEixoHzsHWq+HAEhuFFaavW/blp/MOoZ6/n1ZAGkwquqqE2yN0o0FFhncwnf2jIo1CQ4eLBTUb6g5FqbrrgUD3JF1b3uKcDWuNgBsHjbuSJdifsvbMmvoPxs3dXOA5+M0vGLFA++fmG3px73RbHxFfpZNV2z9YFzwGUSIzvFSSUNwAamYRX0SooHIq3Uvn1yymcbiiUWm8iJ+N6rFZlcr0wkw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhbnfsDbSu6+rHFDCycfGIKJSDg+SyE+po39nmJmHf8=;
 b=RmSsc9QsJ7tngKt0XO+VXU/dfO4OTiWXNkAAE7OSBtz5UvDMIYWD77R1LRlXadi29uq+egwGPyN/PZz8btePjCTCdFLAoJKgTOuXNUxGqFRuqowUxS8a0mBI+QPEX4cUB4qxraFSmQMNoxjUtQnQEv21l4ZhpGz1KoP3BdlfyqHsDZUv07ddU//O276Uw9XnSdAT4rp4s3dylXQoMZhd7ZWjPSpLVQgPIBbyxt23STsD+A7gNut8U2uapsFMgNlIYNj+i++bxAi4MfsoTreySAKd9d9hTB9E2snVV19TBK/KawEQlCSzUkmcFfuoOFvv5h6JAK4W6jOSyAROBVmj4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from DM6PR02MB4585.namprd02.prod.outlook.com (2603:10b6:5:28::17) by
 SA1PR02MB8431.namprd02.prod.outlook.com (2603:10b6:806:1f6::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Fri, 13 May 2022 15:21:38 +0000
Received: from DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::a549:abb3:747c:d53f]) by DM6PR02MB4585.namprd02.prod.outlook.com
 ([fe80::a549:abb3:747c:d53f%5]) with mapi id 15.20.5227.023; Fri, 13 May 2022
 15:21:38 +0000
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
Thread-Index: AQHYZjCCNu0C0Uz/6UepE20RTbQUAK0boCkAgAACRQCAAARvAIAABIOAgAAFnoCAAAHEAIAAOOoAgAAO2YCAACYTgIAAA2+AgAAIzACAAMESgA==
Date:   Fri, 13 May 2022 15:21:38 +0000
Message-ID: <73BC3891-34DC-4EB7-BD1C-5FD312A8F18A@nutanix.com>
References: <20220512184514.15742-1-jon@nutanix.com>
 <Yn1fjAqFoszWz500@google.com> <Yn1hdHgMVuni/GEx@google.com>
 <07BEC8B1-469C-4E36-AE92-90BFDF93B2C4@nutanix.com>
 <Yn1o9ZfsQutXXdQS@google.com>
 <CALMp9eRQv6owjfyf+UO=96Q1dkeSrJWy0i4O-=RPSaQwz0bjTQ@mail.gmail.com>
 <C39CD5E4-3705-4D1A-A67D-43CBB7D1950B@nutanix.com>
 <CALMp9eRXmWvrQ1i0V3G738ndZOZ4YezQ=BqXe-BF2b4GNo1m3Q@mail.gmail.com>
 <DEF8066B-E691-4C85-A19A-9F5222D1683D@nutanix.com>
 <CALMp9eTwH9WVD=EuTXeu1KYAkAUuXdnmA+k9dti7OM+u=kLKHQ@mail.gmail.com>
 <CD2EB6FA-E17F-45BA-AC70-92CCB12A16C4@nutanix.com>
 <CALMp9eQAFz_wzC_SMiWD5KqP3=m+VceP=+6=RWEFbN2m7P7d+w@mail.gmail.com>
In-Reply-To: <CALMp9eQAFz_wzC_SMiWD5KqP3=m+VceP=+6=RWEFbN2m7P7d+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: caf078df-d44d-452d-9fba-08da34f44682
x-ms-traffictypediagnostic: SA1PR02MB8431:EE_
x-microsoft-antispam-prvs: <SA1PR02MB8431B3A8811A244917A30B43AFCA9@SA1PR02MB8431.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aghp2SRVunZnhvYdi1vxhQ6xIIo9zd2mppJustaCVznBcjL7yqZOUsHqNXWQNisvcMWZ7GFu/fELnoPdO5qzTSkIaqumJVfd4FcJqi+amwwTIfIBxeYsQl6wT2Ih7Y+pUgULkrPclFy6Zn7WPZPksVXe89C96Y7Ya116EgyOV7Z7vC6QZxD5KrfYxKwLKTGNvO010cl2h3WRdg7SD0HTFyB3xBwP1LIESHa4oBOov92TmGNmF+Hhd8R42b7/7+Eek4/cSBKs7lonqMEnf3TiLQLK3bo/hoYT/iaZS5jCWH1W6q93H8TA8RIe2fPiZbg7vi5mJhXzgXVa0LAIvfEppqEam9j69iCe8PO7MrJK5/ZnjXixev72FhJO2VbqVCztcfEnTECbQgW6MIOTIfkrgLRNm3w7ulsmzO6cNlXSMyVTOV3uXVu4kVnPkUPA4Lq6Z3KdW4ooxQxsIw7Dt1m9XW44p26SN3gHwXszwq1t2fdh8nb6uQdLIdy1VkuKRBod4jXC5Tw8hes3FB/EHpWLicHrG9jdPj3RPtsDyu8VFp6JZ3HphTpaAoyqGN+AkM/tU6Le37+gWlY/0PSPIU0T4jRfRsGP8VUsXJz3k9QVoHb2k2vuZ8Jv/cQjFJr7wNAxiX/kzgEqAjX5LdEjVfwj/wKW3IsmLNfkB/KxNBx6mt02t8KvnDl7SJgRxwrhEnjFiXmMcVuFcL37IV09uDi38sowpaKj3tz7Gq4wFyZT3CxitObVFsxGCTLbDe7uOkuD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR02MB4585.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66946007)(8936002)(6916009)(86362001)(6512007)(66476007)(316002)(64756008)(2616005)(76116006)(66446008)(4326008)(8676002)(91956017)(54906003)(53546011)(122000001)(2906002)(6506007)(71200400001)(36756003)(38100700002)(38070700005)(6486002)(508600001)(33656002)(83380400001)(7416002)(5660300002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFBvRDhGK1o1b3phZTVpeE1ENnA1Q2NJUkczaUpNNlMvcVY3dzN1ZGNIT1Jo?=
 =?utf-8?B?SXR6c21Odk11dTd3WTMzWUo5YUsyaTl5dDF2MHUvNThEYlNDOStCQ2NvaGZz?=
 =?utf-8?B?bU9UQXJmclVBQVJlTTRhSUFXSVhIYzdNNTBiQzNPUEJrekkrcURibnBMRnBh?=
 =?utf-8?B?d2IvTGVpNkJ3b0pmSWNZRkQ2djZyak84WDFTdVl2dGl6dHBtNjZhQlV1eUhO?=
 =?utf-8?B?R1dYb0NHcUFWTVZVdzc3T3loVi9LcXpScHY1ZWlZRW9IcjIzUG40L1lWUVls?=
 =?utf-8?B?Q2dBeUZUcXFkdEtna1ZWK2ZuTlVGR0pqNExXcnJ3M2tVeEFTQndYaHJmQzVp?=
 =?utf-8?B?NmswVmQvc3FqRlU1Skxycyt4WWxsT3NUU1F1N1RacTZjb1lkMnp4cnMzeDFC?=
 =?utf-8?B?ejBDVyttbkd4b3k0eEpDUnNwaEJLRlhHcHVzMFRaMlM3Z3NmaVhjaVdBWWpD?=
 =?utf-8?B?NEpUVlFzZGphN1NlMXcrb2s0L25jM3Fqb0dPeWExL0dGME0rNXBmenRxT0sz?=
 =?utf-8?B?VlRGUFB1cTNsazRBK0xnK2JQeUpwQzk5ZllyWlVxdGdGekFQdDhWZW9HVStt?=
 =?utf-8?B?UDQrWTdqREE5LzZmVE10bUNQWHo4WFlYWldEMExuQVpaMXJlc1MzRnV3THkx?=
 =?utf-8?B?aHc3RTZwT0d6a3NtZVc0L1FHc0hMcWdzYXM3bUs0V0FtY1ZrK1BtUUNqRmd5?=
 =?utf-8?B?K0VIWC9jd0tuQ3FQTXBodnBGOWtZOEdrOEFuV05MTU51MzlpcC9CVWExS0hv?=
 =?utf-8?B?c2VGU1ZTNWVJTzZVdE9kekJkMXZpT01LVVlsdUZDSGZwYnhqZXRSZG9qcm4y?=
 =?utf-8?B?TVY0VE5wNWZNNGpoRFhYRnRtRXJ0em9TUUt3TmVjT0F6Tnlqd1E2UUtGcW1Y?=
 =?utf-8?B?WjFid1lET3dSTVF3bUM4bEhFbEpSQy9KZ0h6S3h3UG5hQUxQcS9UNW9nZ0RV?=
 =?utf-8?B?ZVNQUm1KMzdvZWlXSDVWeS9JeFFzZ1RnNGhsbGUrT1lsZDN3UnlRSU1zbjcr?=
 =?utf-8?B?ZTE3NEp2TmJpcDRlZlNDUTUybkY2bnNXZVhoYWphTDVuYTlYaXZhYW9BN3pX?=
 =?utf-8?B?dzRVeTRxalc3d01OOEtrb2h6TUNqK0UydGhqMjNIeGZLcm14TnI1SkJlN040?=
 =?utf-8?B?ZWJSZ0RzQUdEc1BHd1NIckdXUXBZOS80c2llZ1ZQaEFOMlhaOHdFWm5NSk5Q?=
 =?utf-8?B?ZHNjSldZc1hwNVg3RmEzbnBsbDNHWFVVSVRmOFp6YXFVRXRnTUF2ZTEwU0xh?=
 =?utf-8?B?eG45WGdmOU5rd2hUdEtPa0hNNjJGYnNrWTMzeXZNa0JTK3FUSnY0RTNOM0FR?=
 =?utf-8?B?WjZkL0FjQktUTEZEQTBsMjJyYmVBUVpXcGtENVl4SWNadWhYQlBhNEl6MHph?=
 =?utf-8?B?WFNwYVlsdlNPanpBV0JSRHBZeHU2aXVIcFF4Y3pkTkJscTNBTmpKalhlTi9q?=
 =?utf-8?B?M2hkU2JsbjhtL05yd2djWGFlWUh0VERydWZ3ZHVBbmNRcXpEemExcHIyYkJh?=
 =?utf-8?B?SUY2NDI3OEhOdy9rQ0Z6REk0M25Tby9YSUdBd3NDWFJoby84L3ZWazUwc2Fj?=
 =?utf-8?B?akFtLzM5Y2dsZzZwWTUwaUowbnNYZjRJN2l4VVBWS3VDTnlMSCtYTmtHNkhX?=
 =?utf-8?B?K1U2ZnJDb1VZa1E0Ly8xL1hWQWo2NG5hdDZmcWwzTm9HTW81RCtoYUtiakZG?=
 =?utf-8?B?d1dubVVmU0lOT0VKaDhIMVJmTEZqcHRTa1RBQkJQTzQ2Wi9MY2tDa0hFUnFz?=
 =?utf-8?B?VEtjUWN4T2RaOTBWTEx2cTJ4Y2FMQ0pjY2VEclJTVGdHd1k4aTFSTWQrYlU2?=
 =?utf-8?B?aUk2cmx2ek9pYVh0SU1ldk8wM29pc2lIdjNMWFBPMWRSN3VCTEtha3U4K2xM?=
 =?utf-8?B?Vno2TWJ5STN6Z3o4RzMrR1p3NDRuRkgvSEpPZENOYlVBRlhCU2F0S1F6M0VD?=
 =?utf-8?B?VWhIUDNLNVI0ZmJwUkpBTUZwL0xBWS9XaG5Da0M5Mi9zRUNzb0Uvck9rSkJk?=
 =?utf-8?B?VDUxUDdPWU4rQmtQcndoTldkaG5qUitHbGtYOFViQVdZdTEvZnJxVjBXdjhN?=
 =?utf-8?B?aFY3b3pVZkxlbC9uZkNDS0pURTdhSjJTR2dlZ005c1JEM2VnQzVCWjBQMVRi?=
 =?utf-8?B?U1pCUWQ1bmdYMXpBSU1OTHV1bUR5aVhWNldOOTBnQ1ZuL1NFY2lmNjRDWC96?=
 =?utf-8?B?eW1hckdnSDFMT29IOTkwckZVTEtjYytMcnZ0V0NwWW1yR1ZHQy8wcll2a1lQ?=
 =?utf-8?B?NUxPcm9peG9XMlVsT1dZajVKTXM3Sm5RZExTMU1xaGk2ZzY1VUpZRGdRUnl5?=
 =?utf-8?B?dWJjbDBJSC9kSjh1RStaQWNpY3FJaExVVVEzUDVTZlo4Q1RaZW5mdHBBUTJD?=
 =?utf-8?Q?urDJEIvKGIjgKCxhKerg+RuKTiXrk8VzFwRm47DrKjNS/?=
x-ms-exchange-antispam-messagedata-1: hB85/AXHXDQA8QkqObpFPk8JtvCVrWMV4w/Hm2ZJeBafCOQsYnfyqqkG
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B925CBBBF1FCA40BA383232E3A80AA1@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB4585.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caf078df-d44d-452d-9fba-08da34f44682
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 15:21:38.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P73G6YtnhaEAxdjWWcLltysBQTQaQs41DlrxN0tJuI1J9vruTg0PlSgheJ7ko09s5icZnvLm0pvcnw9gy2PEnEdSJR5zzaEf8mPaVPTqpRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8431
X-Proofpoint-GUID: ljN90TbLzaD6zbQ5aJxidRSIlhRmYTG4
X-Proofpoint-ORIG-GUID: ljN90TbLzaD6zbQ5aJxidRSIlhRmYTG4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-13_01,2022-02-23_01
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

DQoNCj4gT24gTWF5IDEyLCAyMDIyLCBhdCAxMTo1MCBQTSwgSmltIE1hdHRzb24gPGptYXR0c29u
QGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBNYXkgMTIsIDIwMjIgYXQgODoxOSBQ
TSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4gDQo+PiANCj4+IA0KPj4+
IE9uIE1heSAxMiwgMjAyMiwgYXQgMTE6MDYgUE0sIEppbSBNYXR0c29uIDxqbWF0dHNvbkBnb29n
bGUuY29tPiB3cm90ZToNCj4+PiANCj4+PiBPbiBUaHUsIE1heSAxMiwgMjAyMiBhdCA1OjUwIFBN
IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4+IFlvdSBtZW50
aW9uZWQgaWYgc29tZW9uZSB3YXMgY29uY2VybmVkIGFib3V0IHBlcmZvcm1hbmNlLCBhcmUgeW91
DQo+Pj4+IHNheWluZyB0aGV5IGFsc28gY3JpdGljYWxseSBjYXJlIGFib3V0IHBlcmZvcm1hbmNl
LCBzdWNoIHRoYXQgdGhleSBhcmUNCj4+Pj4gd2lsbGluZyB0byAqbm90KiB1c2UgSUJQQiBhdCBh
bGwsIGFuZCBpbnN0ZWFkIGp1c3QgdXNlIHRhc2tzZXQgYW5kIGhvcGUNCj4+Pj4gbm90aGluZyBl
dmVyIGdldHMgc2NoZWR1bGVkIG9uIHRoZXJlLCBhbmQgdGhlbiBob3BlIHRoYXQgdGhlIGh5cGVy
dmlzb3INCj4+Pj4gZG9lcyB0aGUgam9iIGZvciB0aGVtPw0KPj4+IA0KPj4+IEkgYW0gc2F5aW5n
IHRoYXQgSUJQQiBpcyBub3QgdGhlIG9ubHkgdmlhYmxlIG1pdGlnYXRpb24gZm9yDQo+Pj4gY3Jv
c3MtcHJvY2VzcyBpbmRpcmVjdCBicmFuY2ggc3RlZXJpbmcuIFByb3BlciBzY2hlZHVsaW5nIGNh
biBhbHNvDQo+Pj4gc29sdmUgdGhlIHByb2JsZW0sIHdpdGhvdXQgdGhlIG92ZXJoZWFkIG9mIElC
UEIuIFNheSB0aGF0IHlvdSBoYXZlIHR3bw0KPj4+IHNlY3VyaXR5IGRvbWFpbnM6IHRydXN0ZWQg
YW5kIHVudHJ1c3RlZC4gSWYgeW91IGhhdmUgYSB0d28tc29ja2V0DQo+Pj4gc3lzdGVtLCBhbmQg
eW91IGFsd2F5cyBydW4gdHJ1c3RlZCB3b3JrbG9hZHMgb24gc29ja2V0IzAgYW5kIHVudHJ1c3Rl
ZA0KPj4+IHdvcmtsb2FkcyBvbiBzb2NrZXQjMSwgSUJQQiBpcyBjb21wbGV0ZWx5IHN1cGVyZmx1
b3VzLiBIb3dldmVyLCBpZiB0aGUNCj4+PiBoeXBlcnZpc29yIGNob29zZXMgdG8gc2NoZWR1bGUg
YSB2Q1BVIHRocmVhZCBmcm9tIHZpcnR1YWwgc29ja2V0IzANCj4+PiBhZnRlciBhIHZDUFUgdGhy
ZWFkIGZyb20gdmlydHVhbCBzb2NrZXQjMSBvbiB0aGUgc2FtZSBsb2dpY2FsDQo+Pj4gcHJvY2Vz
c29yLCB0aGVuIGl0ICptdXN0KiBleGVjdXRlIGFuIElCUEIgYmV0d2VlbiB0aG9zZSB0d28gdkNQ
VQ0KPj4+IHRocmVhZHMuIE90aGVyd2lzZSwgaXQgaGFzIGludHJvZHVjZWQgYSBub24tYXJjaGl0
ZWN0dXJhbA0KPj4+IHZ1bG5lcmFiaWxpdHkgdGhhdCB0aGUgZ3Vlc3QgY2FuJ3QgcG9zc2libHkg
YmUgYXdhcmUgb2YuDQo+Pj4gDQo+Pj4gSWYgeW91IGNhbid0IHRydXN0IHlvdXIgT1MgdG8gc2No
ZWR1bGUgdGFza3Mgd2hlcmUgeW91IHRlbGwgaXQgdG8NCj4+PiBzY2hlZHVsZSB0aGVtLCBjYW4g
eW91IHJlYWxseSB0cnVzdCBpdCB0byBwcm92aWRlIHlvdSB3aXRoIGFueSBraW5kIG9mDQo+Pj4g
aW50ZXItcHJvY2VzcyBzZWN1cml0eT8NCj4+IA0KPj4gRmFpciBlbm91Z2gsIHNvIGdvaW5nIGZv
cndhcmQ6DQo+PiBTaG91bGQgdGhpcyBiZSBtYW5kYXRvcnkgaW4gYWxsIGNhc2VzPyBIb3cgdGhp
cyB3aG9sZSBlZmZvcnQgY2FtZQ0KPj4gd2FzIHRoYXQgYSB1c2VyIGNvdWxkIGNvbmZpZ3VyZSB0
aGVpciBLVk0gaG9zdCB3aXRoIGNvbmRpdGlvbmFsDQo+PiBJQlBCLCBidXQgdGhpcyBwYXJ0aWN1
bGFyIG1pdGlnYXRpb24gaXMgbm93IGFsd2F5cyBvbiBubyBtYXR0ZXIgd2hhdC4NCj4+IA0KPj4g
SW4gb3VyIHByZXZpb3VzIHBhdGNoIHJldmlldyB0aHJlYWRzLCBTZWFuIGFuZCBJIG1vc3RseSBz
ZXR0bGVkIG9uIG1ha2luZw0KPj4gdGhpcyBwYXJ0aWN1bGFyIGF2ZW51ZSBhY3RpdmUgb25seSB3
aGVuIGEgdXNlciBjb25maWd1cmVzIGFsd2F5c19pYnBiLCBzdWNoDQo+PiB0aGF0IGZvciBjYXNl
cyBsaWtlIHRoZSBvbmUgeW91IGRlc2NyaWJlIChhbmQgb3RoZXJzIGxpa2UgaXQgdGhhdCBjb21l
IHVwIGluDQo+PiB0aGUgZnV0dXJlKSBjYW4gYmUgY292ZXJlZCBlYXNpbHksIGJ1dCBmb3IgY29u
ZF9pYnBiLCB3ZSBjYW4gZG9jdW1lbnQNCj4+IHRoYXQgaXQgZG9lc27igJl0IGNvdmVyIHRoaXMg
Y2FzZS4NCj4+IA0KPj4gV291bGQgdGhhdCBiZSBhY2NlcHRhYmxlIGhlcmU/DQo+IA0KPiBUaGF0
IHdvdWxkIG1ha2UgbWUgdW5oYXBweS4gV2UgdXNlIGNvbmRfaWJwYiwgYW5kIEkgZG9uJ3Qgd2Fu
dCB0bw0KPiBzd2l0Y2ggdG8gYWx3YXlzX2licGIsIHlldCBJIGRvIHdhbnQgdGhpcyBiYXJyaWVy
Lg0KDQpPayBnb3RjaGEsIHdoaWNoIEkgdGhpbmsgaXMgYSBnb29kIHBvaW50IGZvciBjbG91ZCBw
cm92aWRlcnMsIHNpbmNlIHRoZQ0Kd29ya2xvYWQocykgYXJlIGVzcGVjaWFsbHkgb3BhcXVlLiAN
Cg0KSG93IGFib3V0IHRoaXM6IEkgY291bGQgd29yayB1cCBhIHY1IHBhdGNoIGhlcmUgd2hlcmUg
dGhpcyB3YXMgYXQgbWluaW11bQ0KYSBzeXN0ZW0gbGV2ZWwga25vYiAoc2ltaWxhciB0byBvdGhl
ciBtaXRpZ2F0aW9uIGtub2JzKSBhbmQgZG9jdW1lbnRlZA0KSW4gbW9yZSBkZXRhaWwuIFRoYXQg
d2F5IGZvbGtzIHdobyBtaWdodCB3YW50IG1vcmUgY29udHJvbCBoZXJlIGhhdmUgdGhlDQpiYXNp
YyBhYmlsaXR5IHRvIGRvIHRoYXQgd2l0aG91dCByZWNvbXBpbGluZyB0aGUga2VybmVsLiBTdWNo
IGEg4oCca25vYuKAnSB3b3VsZA0KYmUgb24gYnkgZGVmYXVsdCwgc3VjaCB0aGF0IHRoZXJlIGlz
IG5vIGZ1bmN0aW9uYWwgcmVncmVzc2lvbiBoZXJlLg0KDQpXb3VsZCB0aGF0IGJlIG9rIHdpdGgg
eW91IGFzIGEgbWlkZGxlIGdyb3VuZD8NCg0KVGhhbmtzIGFnYWluLCANCkpvbg0KDQo+IA0KPj4+
IA0KPj4+PiBXb3VsZCB0aGlzIGJlIHRoZSBleHBlY3RhdGlvbiBvZiBqdXN0IEtWTT8gT3IgYWxs
IGh5cGVydmlzb3JzIG9uIHRoZQ0KPj4+PiBtYXJrZXQ/DQo+Pj4gDQo+Pj4gQW55IGh5cGVydmlz
b3IgdGhhdCBkb2Vzbid0IGRvIHRoaXMgaXMgYnJva2VuLCBidXQgdGhhdCB3b24ndCBrZWVwIGl0
DQo+Pj4gb2ZmIHRoZSBtYXJrZXQuIDotKQ0KPj4gDQo+PiBWZXJ5IHRydWUgOikNCj4+IA0KDQo=
