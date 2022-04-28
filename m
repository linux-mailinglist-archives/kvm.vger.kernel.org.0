Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0954D51343D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346703AbiD1M4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 08:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346694AbiD1M4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 08:56:15 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE88DAFAE0;
        Thu, 28 Apr 2022 05:52:58 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SAMh1u002388;
        Thu, 28 Apr 2022 05:51:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=h4eqwdWuRHgZUk4ZID62/NEEEewfF4oGG5ZAnMPQjtg=;
 b=pe6g4otRTT9j5p3S2O8YaTAHHDxsIwrHlMwMPAPtNPBQb7zSXLo2UudsbNGZ3YxWISUC
 IOBQnrVAH4wZLv3Mi2DadNq8I5LGYkwyWRFzZhHHa2KBzoL1VtooNRuvdFAgQmP7lnRl
 PRf902jrwYIn1oTgvtMK3ZDjwyidJyGhJJNtvJ1eoHmVaC6NA2giHutJpfosuC5KW8er
 zqwtd+WtA9a6kQeKFewDEr52UCJ0FWKAzhmumXm8TxDqc84de3yckGWHLToFCyCL1GWY
 2OFBpNVKR49eRICI31zHMXy+uAMYKL47cBpSDmTNu+/KSWGeYZibSjhCptGJLBB+cT0P Xw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3fps5bbtg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 05:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMsOg6RVuOm5DSDVSo56sMOkK7KbS6Bu04fgg8hC6rzG9coTRnmZOPL4kjtplKo1VfucirFDhAUeavL58eLrw0J2nWhrtXwXAHK0d7CCcJY3kzq4yKTkS/uJtA3kU98Bs4dqWiylkDN1yoI7Q4LCBY8s1aOMx6jpYUDBX/uj1q1uT6zWhKBRsEUoD4j5qfFgKBJZNJilsx/2JXAQyXm2WAJcyAXySGtbaqOQZAdEj+oEAe1kzDvj5+K8PiTjQGl57+47RCg93MQKn8YWxjn9OKmqePNVYPV/mnbD3aozyP4qjq4sH7xDCBlNey9KEXrGoJ+0jFhHG3kgFk10IkpnsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4eqwdWuRHgZUk4ZID62/NEEEewfF4oGG5ZAnMPQjtg=;
 b=UBBU9jwckB5WybYACKkFlIVtxRKS7h8RVo5DHMRGMQb+B6rMpZSfkqX55elbUS06SJ9LAiN6HsrQtwMYiHn4gA9tEMnfLoo9j+K3QJ60ZhCgzvErpiK+DefaEtR3Q6o3XKFLQDvIGaUSzsRbjBfJMxe+LW3HzdQpanqqvqCKDAm9lnIwIL+8q6IqAyPcWWdaLsoavPZWse1oTGQouxlq52vEeuhuUzGASOh+A7ZJ+M/zAhT71/FhtLdhT/hxA6+S6MUgJPflLd95N8DU9B3DUHvU6k6C7f0+gzcHobfFJ9JGcIz5my14669bo+XmEFbsHM2Q7izzvqaUEmK3quOnrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by SA1PR02MB8416.namprd02.prod.outlook.com (2603:10b6:806:1f7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 12:51:31 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::21f4:4c6:6a43:3882%4]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 12:51:31 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Jon Kohler <jon@nutanix.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Thread-Index: AQHYVmUALWKOwI7bhUetXwvEOXsG/a0FUJIA
Date:   Thu, 28 Apr 2022 12:51:31 +0000
Message-ID: <AB2123F1-F38C-40D2-9EA6-F288B2B845A9@nutanix.com>
References: <20220422162103.32736-1-jon@nutanix.com>
In-Reply-To: <20220422162103.32736-1-jon@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6be7933c-f0ea-43c9-4a47-08da2915d1b6
x-ms-traffictypediagnostic: SA1PR02MB8416:EE_
x-microsoft-antispam-prvs: <SA1PR02MB8416DCE74C5815F9EE6562CBAFFD9@SA1PR02MB8416.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NZspD4deUR/Ft67Jy0bQsDuIMoy+zqvuE3bBaM0vxENTsUBW8WsU2avQYRiumD0Oxq/5R8WeDpjdD3z5jq3AyxV32wBN0izfDy8NuyxnV9cWgAuk6sz6nv69csHYob2oZHn1puu427Ie1+XozN1s1oIpWa3ivtGDCLSoSnc95BS+DXmT+aUuUxtlqyXa7oi1BhQMvGcq6lr2Qrw8Vp+OQRfwDi5/+aECtfZMNaSa3xPL4BZMGdwQQWCWBEV3j1/lY70/GOcmh3A5v0Pk2xWSpYQdAH+M+Dha4ZCheObeS/gvxGLYTdBCOnRtJJ+uSMFgRnqVCbjU86ZTirmnYw2M/QaZ5ZSM3p88WT9bmJkiSaAcgiPK73f4MI8q+eYSi79rc41riqD1aPxAcqbeCs9QpEck2NqPSDB/bpTvkXhNIIchJ2IxFau5aS+3EnbmCJfVrovVdzwkdX6P72UY2gX2ye8QVsK2J/S+piUp6udu5kdi+AxKdgvbPQtrGyboC6W2Cf2SI4V/qLxt9kQTuW+FyjnRr2nDXLlIlxflM9QtMWSRZ4ElXRMzOnLMxo2MDwCu+J3ToSoYW2Q2w0FvB5r+9tE29cHjRk7El4//bXUbOSHL4635vSAaKps4uLw2pdz2/N0STQr1NWDD7j962T73it36HTRYwq+3rMota+ZIeXRSxb8+kKTvlJEpjIvAfgKgj3op7wWy1/SeyKRmp+noI3ZbxgmUxBldo4yS4JylUqM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(53546011)(83380400001)(38100700002)(38070700005)(36756003)(186003)(122000001)(8936002)(6200100001)(5660300002)(7416002)(2906002)(33656002)(71200400001)(6506007)(6486002)(4326008)(66446008)(66476007)(54906003)(2616005)(37006003)(64756008)(76116006)(8676002)(6512007)(6862004)(66946007)(66556008)(316002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+5Mv4DKWuXrAkecHrB2HrAzDJUCQNSzE0xZh2/W/QBuO5oGPwno3dmllI8hT?=
 =?us-ascii?Q?rGDtQQ6bsLo8yCU0BzR8q5AG9hL6Ebo0IKBSiMyqEmParmqqTlxONXfmQkKD?=
 =?us-ascii?Q?XSHzY3D1w0qLYxXcdPJCr57Z/tmknlOcd7iM9NhOWyfF/ZlU6xCve5YRv/Xi?=
 =?us-ascii?Q?Rmn9F+hhTMdTTQ5vYizKj8s0iZjlPkq7caylf3RfQM+hBedBF9gEtihq9kwt?=
 =?us-ascii?Q?qrDStwtLVYXZkgszo+YzwigcaLrzzPz9iIbdnxQJQWhmf5qGjLI6zKwaw813?=
 =?us-ascii?Q?vbdmYB0RjLOc6xwIZP5y1iQ/VWNgVLYgiBzgJDsr0eEbo1K/WsXlGRlLgR/+?=
 =?us-ascii?Q?4ZtuETvDm1NkAb1acZ+xJZLD38Oi27eTSj8dz2OG/VRo4xXsK6HhVG1ygmBo?=
 =?us-ascii?Q?jXeNEpmn+CETn4yLo1AuhKnDF3iGdP3mGF81IeM7GkMrjW1ELb/iLmmwakFQ?=
 =?us-ascii?Q?46X/kyHjF0F5/UyzPY/JYv5+ADJoLKOU46RdqkGXzc+FKC0ihrOS5kS/7KvE?=
 =?us-ascii?Q?4y8ARZsMI9vLlPG2T3xKCpNf6yE9GZBzDQuAMRc6H1SBuhMIetufumaAPJPL?=
 =?us-ascii?Q?KSScaChPSzgHvdwBYjQUiHzjslJdFaxeZ9vSfFyMmBZ6yNC47DiG4FA7pQtu?=
 =?us-ascii?Q?VsMw7NpSohALSndmOuJhbF5GnK82TYZ+D7DdZNi5C7/qsVaTDz7BwzUbo3Tu?=
 =?us-ascii?Q?27ie6dR/ddQG7UqEApboIKB/3saqphrk07cqWHMePIj++7PTl0nmP/sNTl8w?=
 =?us-ascii?Q?NP6V1tT1yUuw3SwWVBajVoUoeAUc7X1ic2JhPOTaxtCb7xaIttrGNYROzxTP?=
 =?us-ascii?Q?uLzT3Y4rHx5qjMWZUytpX63PGjrDSZKg1g0LmhCm1ah3CSO/eibbMqG7ZgJW?=
 =?us-ascii?Q?XwPCnY79ZXhF03zQmpLfwJ+5y6S4STVuQiLoWUXPsSYLzMlWvPjwk3D/N1nG?=
 =?us-ascii?Q?NoLHTuLZeG/eXskt5OD41hN6okJowd8O283fSJp0SuV0BCDswVW/H+apyyji?=
 =?us-ascii?Q?8rrtn2Q9CoOVbdsDOALTq7QJS7RjofrxDyCSZF67hYS3YPlwXFZ+JVXoYIcq?=
 =?us-ascii?Q?FKa+RPG77LfVETW785nf9kwvrqSLepLzIYDZZNxHvFgPOwEL15aBEpS9ptX1?=
 =?us-ascii?Q?0K3ZUGV/zuD99s9UsctFIxb8Y8dcW+auJWYM+68VRWhr+eBb1leVd7zBieWd?=
 =?us-ascii?Q?DCYi3GIrWM4PmYoIOd/G+VQRTKN04HVztF9gyfxZWzFJuETkkHF6X/9NvJep?=
 =?us-ascii?Q?yjQUGgNWes/xiT8D3h2Ts6lNBjaCuzKHI4zffVBNZk5PT0bMP8pTLsHt/GIF?=
 =?us-ascii?Q?zpqI6RIXO6DClcDBxq2Dy0mFoUpOFjXoOM8/zg6kAwr64LfMqQcf0asz3K42?=
 =?us-ascii?Q?6GA9lcXSQglfk8xtt1Z6aWPIrWPF8zhCyVnEQjn/MUOJ81uCIvxolEjL03FP?=
 =?us-ascii?Q?2eG8UD+9XjqhXR3Ny4YhKdAuDPKT467KCdfU1HKfq152lY3fDir7ijDXGGNS?=
 =?us-ascii?Q?ab/JNWrIZVxZlKC9ULniZdQQPrdIClTjyDr4TuNIITqDLf/svPg2nm6fhC/h?=
 =?us-ascii?Q?ChDUxON3oairAm0S8FthCGuJcpJO3b9AX8wLdnn/G0kmfY1wAhhmvM64qBbB?=
 =?us-ascii?Q?duAMmWr2Yds6hqFANP5tCdEC0v4rI8MSFximq5LZHqnk8LURiuZhumboBCJw?=
 =?us-ascii?Q?m3sRakC+zSeKqNuIUkDUsxcTOw32OCcfdOqiz9RHkSkmtCr/zrnSq+He1Zha?=
 =?us-ascii?Q?tXML4Rq/MlPjxIS3fC/WUORZ15V3P/+PlI+U/u2DhpLCk8822E9ygiIexeIE?=
x-ms-exchange-antispam-messagedata-1: 6H0jBBGgAKsNei+OMU1ErdEdL53DxkZDlivz4wwF6u3J664w8zpa0ll6
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0DDE0E715F87EF49BD33FE3C2DD81FBD@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be7933c-f0ea-43c9-4a47-08da2915d1b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 12:51:31.5314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wbgtgtcnKI31uk7AuW2kIuv6TuGN6Mp/j1lVJPYLU4FM4mm7XvoEPMpTsYwbDgId+IBpn1eIg5kTZp5IUi1H2L7yqjkhAkNd8SZ0PYrWv7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8416
X-Proofpoint-GUID: Y3hCIwNqzNdT5yVzvYBXYIGCm1s-WU1c
X-Proofpoint-ORIG-GUID: Y3hCIwNqzNdT5yVzvYBXYIGCm1s-WU1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 22, 2022, at 12:21 PM, Jon Kohler <jon@nutanix.com> wrote:
>=20
> On vmx_vcpu_load_vmcs and svm_vcpu_load, respect user controlled
> configuration for conditional IBPB and only attempt IBPB MSR when
> switching between different guest vCPUs IFF switch_mm_always_ibpb,
> which fixes a situation where the kernel will issue IBPB
> unconditionally even when conditional IBPB is enabled.
>=20
> If a user has spectre_v2_user mitigation enabled, in any
> configuration, and the underlying processor supports X86_FEATURE_IBPB,
> X86_FEATURE_USE_IBPB is set and any calls to
> indirect_branch_prediction_barrier() will issue IBPB MSR.
>=20
> Depending on the spectre_v2_user configuration, either
> switch_mm_always_ibpb key or switch_mm_cond_ibpb key will be set.
>=20
> Both switch_mm_always_ibpb and switch_mm_cond_ibpb are handled by
> switch_mm() -> cond_mitigation(), which works well in cases where
> switching vCPUs (i.e. switching tasks) also switches mm_struct;
> however, this misses a paranoid case where user space may be running
> multiple guests in a single process (i.e. single mm_struct). This
> presents two issues:
>=20
> Issue 1:
> This paranoid case is already covered by vmx_vcpu_load_vmcs and
> svm_vcpu_load; however, this is done by calling
> indirect_branch_prediction_barrier() and thus the kernel
> unconditionally issues IBPB if X86_FEATURE_USE_IBPB is set.
>=20
> Issue 2:
> For a conditional configuration, this paranoid case is nonsensical.
> If userspace runs multiple VMs in the same process, enables cond_ipbp,
> _and_ sets TIF_SPEC_IB, then isn't getting full protection in any case,
> e.g. if userspace is handling an exit-to-userspace condition for two
> vCPUs from different VMs, then the kernel could switch between those
> two vCPUs' tasks without bouncing through KVM and thus without doing
> KVM's IBPB.
>=20
> Fix both by using intermediary call to x86_virt_guest_switch_ibpb(),
> which gates IBPB MSR IFF switch_mm_always_ibpb is true.
>=20
> switch_mm_cond_ibpb is intentionally ignored from the KVM code side
> as it really is nonsensical given the common case is already well
> covered by switch_mm(), so issuing an additional IBPB from KVM is
> just pure overhead.
>=20
> Note: switch_mm_always_ibpb key is user controlled via spectre_v2_user
> and will be true for the following configurations:
>  spectre_v2_user=3Don
>  spectre_v2_user=3Dprctl,ibpb
>  spectre_v2_user=3Dseccomp,ibpb
>=20
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> ---
> v1 -> v2:
> - Addressed comments on approach from Sean.
> v2 -> v3:
> - Updated spec-ctrl.h comments and commit msg to incorporate
>   additional feedback from Sean.
>=20

Gentle ping on this one, thanks, Jon

> arch/x86/include/asm/spec-ctrl.h | 14 ++++++++++++++
> arch/x86/kernel/cpu/bugs.c       |  6 +++++-
> arch/x86/kvm/svm/svm.c           |  2 +-
> arch/x86/kvm/vmx/vmx.c           |  2 +-
> 4 files changed, 21 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/spec-ctrl.h b/arch/x86/include/asm/spec=
-ctrl.h
> index 5393babc0598..99d3341d2e21 100644
> --- a/arch/x86/include/asm/spec-ctrl.h
> +++ b/arch/x86/include/asm/spec-ctrl.h
> @@ -85,4 +85,18 @@ static inline void speculative_store_bypass_ht_init(vo=
id) { }
> extern void speculation_ctrl_update(unsigned long tif);
> extern void speculation_ctrl_update_current(void);
>=20
> +/*
> + * Issue IBPB when switching guest vCPUs IFF switch_mm_always_ibpb.
> + * For the more common case of running VMs in their own dedicated proces=
s,
> + * switching vCPUs that belong to different VMs, i.e. switching tasks,
> + * will also switch mm_structs and thus do IPBP via cond_mitigation();
> + * however, in the always_ibpb case, take a paranoid approach and issue
> + * IBPB on both switch_mm() and vCPU switch.
> + */
> +static inline void x86_virt_guest_switch_ibpb(void)
> +{
> +	if (static_branch_unlikely(&switch_mm_always_ibpb))
> +		indirect_branch_prediction_barrier();
> +}
> +
> #endif
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6296e1ebed1d..6aafb0279cbc 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -68,8 +68,12 @@ u64 __ro_after_init x86_amd_ls_cfg_ssbd_mask;
> DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
> /* Control conditional IBPB in switch_mm() */
> DEFINE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
> -/* Control unconditional IBPB in switch_mm() */
> +/* Control unconditional IBPB in both switch_mm() and
> + * x86_virt_guest_switch_ibpb().
> + * See notes on x86_virt_guest_switch_ibpb() for KVM use case details.
> + */
> DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
> +EXPORT_SYMBOL_GPL(switch_mm_always_ibpb);
>=20
> /* Control MDS CPU buffer clear before returning to user space */
> DEFINE_STATIC_KEY_FALSE(mds_user_clear);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bd4c64b362d2..fc08c94df888 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1302,7 +1302,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, in=
t cpu)
>=20
> 	if (sd->current_vmcb !=3D svm->vmcb) {
> 		sd->current_vmcb =3D svm->vmcb;
> -		indirect_branch_prediction_barrier();
> +		x86_virt_guest_switch_ibpb();
> 	}
> 	if (kvm_vcpu_apicv_active(vcpu))
> 		__avic_vcpu_load(vcpu, cpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 04d170c4b61e..a8eed9b8221b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1270,7 +1270,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int =
cpu,
> 		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
> 		 */
> 		if (!buddy || WARN_ON_ONCE(buddy->vmcs !=3D prev))
> -			indirect_branch_prediction_barrier();
> +			x86_virt_guest_switch_ibpb();
> 	}
>=20
> 	if (!already_loaded) {
> --
> 2.30.1 (Apple Git-130)
>=20

