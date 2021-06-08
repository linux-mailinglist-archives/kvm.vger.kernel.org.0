Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7339FCF9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhFHRB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:01:57 -0400
Received: from mail-bn8nam11on2132.outbound.protection.outlook.com ([40.107.236.132]:25361
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231261AbhFHRB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 13:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clbPomjn/LY7iPLj8NWrX1jrDBCzKTd7CygLR3zvxdN/Lxl3V9wUo1xOaMgNC+FYVPFyxbiqPWz3t7jRna44vVmyhoVZbbYtbrT/OD3s9zxJotpCTwbkJthzMfIX9Y+6NIaJTf7WU9nVfVZJI0YpwT+2bWtgimvkGAqlOXguuOEGdeed4J3CaV3nzMliMkXH6ML8zFQ/OBqV1jr+3TL0/5foiePQMnOxTmVxdSg11zju6Aff7gavnwJK/5wj4C0TIOLAJy3RQSFsAjISDkVptvoHyradwk5M25IgMJpF/uXOOC5rDwacbLF2oNCjUSISXG0YNHVWjW6EqlTQozglsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmcDGhcHGJEC+mUJuTkh8VrCfq4ZnHmT+GN/MqLf4qc=;
 b=RJoC5yvJFm/5WM2AUO/DwHHuCK7YAT2UjK9Icox1510qy4q1jxB5TpTK/4mbEpro1qJ6T3CKkKOm7LMxnuw+MCPWDTCOVYcDPYUXVWS6Sl5ynwfD3Mi8pqscSEnOIsqV+peNEEvmAllUdZruoGL91srX3L5/cCjWBji57ORSoWrVFQNKx/PCK1e9tzeZkgyU4dfgrE7KzEDNAcbUWZMDhU0v0rX2wSGQdUX0ApfgQURsmIOSN/XOQOTNdSLIO1sw3UrqKzJx5ParG5A2uZDjCb9jzI7XN0aLM+k+nc199rxKklDU0myFf72Rc5wt7odjMl6CuaAXjb4vmIWr2TVmOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmcDGhcHGJEC+mUJuTkh8VrCfq4ZnHmT+GN/MqLf4qc=;
 b=VB0KDtnMQKmLJRXk63RdAH4s7GzgP2C4+EB+jxcuDgxiX1Wd6tCFf7pYgRrFoXB/JkX5RYFhxF4m+N0uG9kL9PLsFrs1gcp4QLU7q4WxTmqNSd2pc/iSWk9c86VfnxbCx+/fRu2AoXNafDEZ+60D8stMjlR6RDMHR2pm37q1o70=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0157.namprd21.prod.outlook.com (2603:10b6:300:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.7; Tue, 8 Jun
 2021 16:59:58 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2%9]) with mapi id 15.20.4242.007; Tue, 8 Jun 2021
 16:59:58 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        KY Srinivasan <kys@microsoft.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v5 1/7] hyperv: Detect Nested virtualization support for
 SVM
Thread-Topic: [PATCH v5 1/7] hyperv: Detect Nested virtualization support for
 SVM
Thread-Index: AQHXWIs1pHYQBeeDJkCXI/lF0JMlLqsKW7Ow
Date:   Tue, 8 Jun 2021 16:59:58 +0000
Message-ID: <MWHPR21MB1593B9B7F9BD133C55F287CAD7379@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <43b25ff21cd2d9a51582033c9bdd895afefac056.1622730232.git.viremana@linux.microsoft.com>
In-Reply-To: <43b25ff21cd2d9a51582033c9bdd895afefac056.1622730232.git.viremana@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2272bfa0-82f4-460d-8e75-ef2a323d253c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-08T16:50:32Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d35b0285-4738-46af-7ae2-08d92a9ed8f1
x-ms-traffictypediagnostic: MWHPR21MB0157:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0157F44F1A04DDF5C483BC7BD7379@MWHPR21MB0157.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfvNYYz+fiLTsr/n/0lkU4uOWiP2nWvCktL88fQrqq7IFM/mc1WUs8z0EuOQ154efqI0VDtlb7gwlK3dKAEArcyXlWdofypn2fIqmYlXUFSo74sHsGqXGPv1z+M4DS8iwX/SQOGnMAt2RnkH4xeWLPnWY7jsD8SRuH5v1Cd4KXzjBlTdGDvzTyHvm/J3LBr/5Bfl2wW8Ete2MAcTwrvIhY2NTJ7k4a+uwfATeWwStgQGzyU6MyeQjCVmLvDo6kAGN/2TKxhWf1EIfuFssyLiTv3CElh6CWjE/t0Vf5gw1nPtG3agpDkbG+vpk71KlTJS//bp3+Rd0z8XdMLquFmr6k/MRBGAXTtyjE//Z7O8iyN707s0yrlVEoFz9co5+klCdHIxBSgBnniqgj/6TqGM/R6aULuqRsBxgjkEW1sZc3ftDYahv7M986kAAJ9vaoBHvcfXhICTc4dzrkSqhS2QIbEMunf5gssaSQnPAD5VQ8xNmkvLZj9+kV5PDRD54AIIzScfnE0l1zUhKEi1nECxqtYinrdL3ncZjpKNfMdx/1RcWmYs9Vp/eu1T37vE1bS26BHXNMzYEtzjOI0nZowDX5dMZoZB1UQDakv7SqlksDpdsttz/NwO39e4i4WswcSj6cIhgX+M8AB45rBmmkl8lTqWO/1ySctVPzwAN49aD+oTC8fuxKBXDmUdLa2hX4n/9dbIqdOSauu9mYu+XZCF2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(4326008)(76116006)(66946007)(8990500004)(7696005)(9686003)(66556008)(83380400001)(71200400001)(478600001)(82960400001)(82950400001)(52536014)(186003)(6636002)(33656002)(8676002)(110136005)(8936002)(6506007)(86362001)(921005)(122000001)(66446008)(5660300002)(38100700002)(55016002)(316002)(7416002)(64756008)(2906002)(54906003)(26005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ta8kMxwKZ2HWM0LEATqbWfBUPcAIJUKQZwp+UggA9zUF4fRkDgyX9tcu8CEa?=
 =?us-ascii?Q?NDfzs/sslBICyND94WArwkDhZQezSQ/bn9aExbuP7IHp5oAXVROtw8tFbbBb?=
 =?us-ascii?Q?8Wu6xXB6pKQr1qAI7lTW5DIpicQcmjh4UEhaI1JONv3WJXKvr+ohWNQqJVJv?=
 =?us-ascii?Q?F4euWK/4M2N+NQS9EseOjkD16JmQ9lh6B2ugiHk+7fGivIBnY+aDemKm2Sok?=
 =?us-ascii?Q?sRxDfbSEBpO0NGLmWFjIoTULNYL9bpmWRddx6F7C0v/lE1SrmJeNAZMQcfKA?=
 =?us-ascii?Q?eN9nHLDk9KWEi5NzGlF+E3fyX5fn0nLEfYmZ9eaJ4AVgOIaJeX09XaQT79hJ?=
 =?us-ascii?Q?SE+/K0srgOWeuv9bH5Erx9vTuMie0Jib9ROCQMdMSUgJSOwRwLlk/kjGlHMj?=
 =?us-ascii?Q?5oR930anoMBW7Wyw3TY200oUcUgwga/pe26LIke7hKx5y7p/bG1odM4rvgRz?=
 =?us-ascii?Q?QmQifaMJ2pRw23R/nqjBvcNZoWjJnVEGZGzOevpi0zfS3nSlKIu5usPUB9uN?=
 =?us-ascii?Q?1xvM5866VwPaKmfnSSxCeDbqxI4/f7EshjlxV7qlzRUDLVBgiagH/z4RJ2RQ?=
 =?us-ascii?Q?JBsqAf6zwQt9Y30GStQVJY80OAYLMDoidTkEP4XILL6LX86pOhAAFMRkAf+n?=
 =?us-ascii?Q?6OPjILxTLlR0kEuxSB9TqDC9YH5lIO+ZnTSS9mOjejgg8InzjMaGqVQKAT1+?=
 =?us-ascii?Q?2GTDMAfE3ousue07XzFpTavvyyWjTojsjQGuzOYRUcxzs09T5+CorVogptff?=
 =?us-ascii?Q?P7+mklaivjCLxFkETUcGCiluKGQ6paaM6j/mlBpP2egkYCoa7ddA0Z32UE1v?=
 =?us-ascii?Q?VTuJk4esyMS9E9n5w23MtHYCvas20sc2/flTHkUV/PXjZ1jflJzu4Un8Vk0/?=
 =?us-ascii?Q?qpOmJJF7D7c1zhoB++J+/vwN2JCrpgxamYUBetCLTHM2ly/7wdZ39KQag71D?=
 =?us-ascii?Q?ievHtHX1A0fZev/bCU4Yj2w4BINtpBdgF0VmGg8xEtY0idEF+gdn/+vq4zB7?=
 =?us-ascii?Q?3PweWRTajZXVG9iRDMMrBhyUk3M4ztq+Irx0X7tB7aIesdoJwJalbjK1VlsD?=
 =?us-ascii?Q?kqFEAOmxpnBPSHqd3NAr4LsG+8q+6a1nHQXI5d3Mekvt0LxMEyBde41eEPJq?=
 =?us-ascii?Q?WE9WliDZWp/YRzmWeq+CK+77ujshOITlSES8EJr1jzNa0suZDAXnofYmzJLM?=
 =?us-ascii?Q?78cL2Q7f2IJCAYPRdzQzQJceQoGRBbvyohCw+ijYD/73igLZtfa6UciPZ1RN?=
 =?us-ascii?Q?tHHyxOwMeDh2+SnVNfzq84ArWepgSd+XdTNucgprZiA2unfooo8mO1OaLAwu?=
 =?us-ascii?Q?OcchpDhqZsKIRj9glSz87o8b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35b0285-4738-46af-7ae2-08d92a9ed8f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 16:59:58.0310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jsELYnRgHPh2iKoQc7BOWEEztnIvBIyJyVbsHYN2rFFBQe/5zzdHKHEiospJJ7IIHD8XsAi87TR0HHV3mt2/gzYKpKLljGGiZ3JJeZ21uak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Thursday, June 3,=
 2021 8:15 AM
>=20
> Previously, to detect nested virtualization enlightenment support,
> we were using HV_X64_ENLIGHTENED_VMCS_RECOMMENDED feature bit of
> HYPERV_CPUID_ENLIGHTMENT_INFO.EAX CPUID as docuemented in TLFS:

s/docuemented/documented/

>  "Bit 14: Recommend a nested hypervisor using the enlightened VMCS
>   interface. Also indicates that additional nested enlightenments
>   may be available (see leaf 0x4000000A)".
>=20
> Enlightened VMCS, however, is an Intel only feature so the above
> detection method doesn't work for AMD. So, use the
> HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.EAX CPUID information ("The
> maximum input value for hypervisor CPUID information.") and this
> works for both AMD and Intel.
>=20
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 22f13343b5da..c268c2730048 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -252,6 +252,7 @@ static void __init hv_smp_prepare_cpus(unsigned int m=
ax_cpus)
>=20
>  static void __init ms_hyperv_init_platform(void)
>  {
> +	int hv_max_functions_eax;
>  	int hv_host_info_eax;
>  	int hv_host_info_ebx;
>  	int hv_host_info_ecx;
> @@ -269,6 +270,8 @@ static void __init ms_hyperv_init_platform(void)
>  	ms_hyperv.misc_features =3D cpuid_edx(HYPERV_CPUID_FEATURES);
>  	ms_hyperv.hints    =3D cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
>=20
> +	hv_max_functions_eax =3D
> cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS);
> +
>  	pr_info("Hyper-V: privilege flags low 0x%x, high 0x%x, hints 0x%x, misc=
 0x%x\n",
>  		ms_hyperv.features, ms_hyperv.priv_high, ms_hyperv.hints,
>  		ms_hyperv.misc_features);
> @@ -298,8 +301,7 @@ static void __init ms_hyperv_init_platform(void)
>  	/*
>  	 * Extract host information.
>  	 */
> -	if (cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS) >=3D
> -	    HYPERV_CPUID_VERSION) {
> +	if (hv_max_functions_eax >=3D HYPERV_CPUID_VERSION) {
>  		hv_host_info_eax =3D cpuid_eax(HYPERV_CPUID_VERSION);
>  		hv_host_info_ebx =3D cpuid_ebx(HYPERV_CPUID_VERSION);
>  		hv_host_info_ecx =3D cpuid_ecx(HYPERV_CPUID_VERSION);
> @@ -325,9 +327,11 @@ static void __init ms_hyperv_init_platform(void)
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>  	}
>=20
> -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> +	if (hv_max_functions_eax >=3D HYPERV_CPUID_NESTED_FEATURES) {
>  		ms_hyperv.nested_features =3D
>  			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
> +		pr_info("Hyper-V: Nested features: 0x%x\n",

Nit:  Drop the colon after "Nested features".  Current code isn't very cons=
istent
but I'm trying to establish the pattern of "Hyper-V:" followed by names and
values, with multiple name/value pairs separated by a comma.

> +			ms_hyperv.nested_features);
>  	}
>=20
>  	/*
> --
> 2.25.1

Nits notwithstanding,

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

