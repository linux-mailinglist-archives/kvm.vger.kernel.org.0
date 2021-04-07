Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D6357540
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 21:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355775AbhDGTzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:55:35 -0400
Received: from mail-bn8nam12on2113.outbound.protection.outlook.com ([40.107.237.113]:5792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355767AbhDGTzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 15:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbfoYRqzJZ4iLY+N+ekozcgRvcYoIJx+bspST3XFRqVkpMK7T3v9RCXMFWod0Nq9kltJXye+agemPzf/3hu1JWxaq/7MLiFMBZgtA0U/EnvY6ojvHqv7sjawZnTv0kqmMyT/FLpYzaOMMWD30H2GgnIJ/ZEYHxeoCH55o5cqX97uRaPihhUweGmMb2/gih+jNUvi6AwkbsjFpO8wcwHh4ORD4BJtwoPRV6/lPLhA4nAlOcrOEuF0/VNISSEy5Gho4Av8eVfMeIwfcBa5Ry4rfWW3+GWghRXiVVBHGFGNqCxIOEw53nYLVCn33IV/yM2P/7J/Ewgub/bUJL3CVhOBvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS3Snl0WRmCkrwthc6gbQXBTEbAwWZhdPXrF2StLGg0=;
 b=I41x0Nt41mc2dX5O2Pgn/y7peDsDHEulL1MrNnCSFbPZBIb4uipxKcIbm60Nz5be3zkjPwUltO2OaqvUN5gdanGOge35RDH4fcDvn78gUTP+0SICaPoHGcASVJeEDQozZdvl8ozClcp9g3CYp/+7IdqvSpnu47qeOOoCQ9NsMpyFe5/mPyUUrNnjFh+YK01pg3gWBGJRyJYScyIsvU+7JNn8BJKBch8jlRukr09UvtRAWQa242nPAbjXCQMDyQd1+yec9YFejZiQY6RNzFfUUsj2YRrCYtwst7tryZVizP2P0pG80HZWvTIM5r/mcIpjgu1CTQnaBuoH6v4RygaMKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS3Snl0WRmCkrwthc6gbQXBTEbAwWZhdPXrF2StLGg0=;
 b=BiPuIrZamy3yfQJBCF2ObnXqs1+S7RuIUbdCC5LB5ro3KOtEQEUTCWZS3J8N+qB7S71FVktsLZJoP1nOxn661u7ABqzectT5wOwe5dY8UBhvoRBpylkFY62cYQoMh+ChuY8IKfbi+D8u7rteUV6aPKiKy9y8a0ymthRlpdF5mqE=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0285.namprd21.prod.outlook.com (2603:10b6:300:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.5; Wed, 7 Apr
 2021 19:55:15 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::5874:413c:8f1b:6b0b]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::5874:413c:8f1b:6b0b%3]) with mapi id 15.20.4042.004; Wed, 7 Apr 2021
 19:55:15 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        vkuznets <vkuznets@redhat.com>,
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
Subject: RE: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
Thread-Topic: [PATCH 1/7] hyperv: Detect Nested virtualization support for SVM
Thread-Index: AQHXK7whxv0u/iBNREG0GmXfpyQUWaqpd0gQ
Date:   Wed, 7 Apr 2021 19:55:15 +0000
Message-ID: <MWHPR21MB159327E855DAC5BEE4B8A38DD7759@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
In-Reply-To: <e14dac75ff1088b2c4bea361954b37e414edd03c.1617804573.git.viremana@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c801a024-d991-47cd-8ff9-5a01b77ecd6c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T19:51:18Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ed8bcf5-ca3d-4268-37ac-08d8f9ff1025
x-ms-traffictypediagnostic: MWHPR21MB0285:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB0285ADBBB8C85FEF488D04E8D7759@MWHPR21MB0285.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fMU29jfGX04QJ0aDndlJQVuRsGoWn+GapG1rD7eCzRwGOGc+wG6oPHfxut5yLo/0EvCvcd2Q1EcvcHbbaQZ2WVnPZzrtBQC1Q29fHqqZRs5VmEzMt0Brpf0Y0dYD0eboX+MiLHFh0tlulRz/1+/A84AMEP4fXwNKgx6cC+DksESg0YywtaSp0+R7DBQ+T4QjPiZQSFocf8kjLzC+h6Ecr4uL7E8y67r/7RGZqQUbo+ioWCl9sEhX2cyhkpVaLGpbwflDSKMe9DU6LyA/96y1oN/qRrD5P/ZV9oT9W90cEZHY1S2F29OSEPaEHwLzDD9HE+QIpKIu78kjJGRa6How28rgpnaZgNmCrMjZnnAzRpNimakqpBTBR8EvMlcAe46WeZnDBwYaLkRVKQGxTOlVpWN1Umpl4yWuNJ/36Funpb1xdnPfPyAKJZ6Hh3PjX8GWy2aHx8wrvWfhSpGQYqRnbuOFX5Ji7rdRQgQa7rKWFakuIvM4WHf4ri3QbVbSw1dLs2rHzTkcUJkz+QdOSPOhHZ2kUf+idGLN9Hnx269HHfpx5YJ1ul292dwokQJwXbRJbAHVwKPa4qHMrB/sulr+g+sWbcP0VKpBjFBBKG4xEZzD3uI0FQoFTojDQ6NQMfkbz330TXscVeIOV7GYzrGWHPQ25NGujL3XMfnSW28AoFgVyqKRctqkN7hMkEG+Wz8c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(110136005)(54906003)(66946007)(52536014)(2906002)(5660300002)(316002)(66476007)(66556008)(86362001)(66446008)(64756008)(76116006)(7696005)(8990500004)(8936002)(8676002)(26005)(186003)(6506007)(7416002)(6636002)(38100700001)(82960400001)(82950400001)(478600001)(71200400001)(10290500003)(4326008)(55016002)(9686003)(33656002)(921005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?L1SWy1ByP2QgL5wIS2A48G0y+diTuTS6rHmTFS5Uur9vi3oYDpTuL4C/B5tA?=
 =?us-ascii?Q?WFY5gSI4wXZb3aMUFVXznyCdUv80e0nQVxizBt65w5WxS1SaaeHGqWsbccXi?=
 =?us-ascii?Q?1qHa7JCWJFHIVumKEhrNi7CdtBAh4VdE90G4k5+yygtTTk8TBCXLp78tvpMJ?=
 =?us-ascii?Q?JoATwSjDA7+tVeZ4L19bnKA4m4HnswzP496BznemxwmKu1A9iBPCByflk4EG?=
 =?us-ascii?Q?HkA1QVBuP8ufE/23KzonLURT4G4N638KP4YrB4FkeRZss98b2V7jY2LNe2RU?=
 =?us-ascii?Q?85L7+SVemiK8GQaypYkhM5+mf9s8hASuEG/suNoBEIs9GIXImRIqVoyWNL1E?=
 =?us-ascii?Q?JRJMoPS2rOmbA+oagHz9rc0OjXuyiILMK8UvnbwBC4KBwYaJKn5Itt8AVSSd?=
 =?us-ascii?Q?9ZsqqyHxLD4rXgiDY2AB/tJueScnHd/yugESpIa2Hz8gM5nh7Ez6kAxXPw6m?=
 =?us-ascii?Q?eWZDLDsDIrOI85CNEWAY4vebVVk8UUpI9ljJPOlopAdVA7bd3fqdzzQHNgO9?=
 =?us-ascii?Q?PkplYyFHxO3FuK6sW/WhR17Z/2iyEKUuTCkfaxvi1VfQ0GM8VlW+wuwtm5Zx?=
 =?us-ascii?Q?u9x5qHOIeCBWIspywhPNIrF93VHVmt3zR5H1BuvD+adA8gmcXEKOULs2ksHI?=
 =?us-ascii?Q?Ruu+tT3whjtlhbLW1L8TjjxmO2P+qq3XtrCY1aliYWLbsWNasX9FqSOQ0g3I?=
 =?us-ascii?Q?4Cw/PWGC61mXLK4ksI6mpy+WEvgyH46E9wXgRQ+zBQJ1fmlaUNDZSjw3pzkH?=
 =?us-ascii?Q?OPByiGaI64OoAcT0WwTe1gE5E1czITSLmz2wtzo35QxmkJS3mmfrqR4M4ea5?=
 =?us-ascii?Q?XRu+JY23ZCdqsV+nF+++ZkEN+SCV7UnijcJq9aZ5e7hMrrp41hUGBec398lK?=
 =?us-ascii?Q?dZb/R+UM8d4wjw0bo+AWPCeaO9DgjdH3TvGjujn97h3K+aUdjKen8wmESvm6?=
 =?us-ascii?Q?7tLJVeCGgX7XYhuGuc3BxXuxwCcVdnQKC5hlJaRv9pN/26MYsAAr/hJIhaP/?=
 =?us-ascii?Q?pIZl3vdZkk4gzXE3tSidqUTM5tC6BcPfk1LttS3SqX4v782zNjwDtD6ZAZWR?=
 =?us-ascii?Q?iVBlsS+YzgQWTV4B2jE3uR06gRPDUoYpWZpuBx8G8JMrTcRcGF3MKrpcXlNy?=
 =?us-ascii?Q?8ujdn2ItEk9uuTFGkarbUOa/cXNCjOkDhXfMj8D+EWLlQdwzFUPkpE71g6SP?=
 =?us-ascii?Q?vx1Lx5Ktn59z07LKXNaxxf27qLNlkFDRL2d5bRlD0wefknXLBiJPZtadG3Es?=
 =?us-ascii?Q?lt/b+3Fa/+9bqtBdqhfsyNfpbltQLjEpuquimPrOoGF7N2UUEX2zc5YqDnjG?=
 =?us-ascii?Q?IfqQNlTaZW5IaVmTzS+YB47g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed8bcf5-ca3d-4268-37ac-08d8f9ff1025
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 19:55:15.4617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SuOjODKRY5lvP8K6ZNpfi6R3Umf3DmGbKwM8q5IusP/wX0MU4HEWgrfHbyWOAM698yTEnRYcOKahJAm6Yp15D2rnJdkzU8FRY6SREOT6FJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Wednesday, April =
7, 2021 7:41 AM
>=20
> Detect nested features exposed by Hyper-V if SVM is enabled.
>=20
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyper=
v.c
> index 3546d3e21787..4d364acfe95d 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -325,9 +325,17 @@ static void __init ms_hyperv_init_platform(void)
>  			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
>  	}
>=20
> -	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
> +	/*
> +	 * AMD does not need enlightened VMCS as VMCB is already a
> +	 * datastructure in memory. We need to get the nested
> +	 * features if SVM is enabled.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_SVM) ||
> +	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
>  		ms_hyperv.nested_features =3D
>  			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
> +		pr_info("Hyper-V nested_features: 0x%x\n",

Nit:  Most other similar lines put the colon in a different place:

		pr_info("Hyper-V: nested features 0x%x\n",

One of these days, I'm going to fix the ones that don't follow this
pattern. :-)

> +			ms_hyperv.nested_features);
>  	}
>=20
>  	/*
> --
> 2.25.1

