Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431C4357545
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 21:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355779AbhDGT42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:56:28 -0400
Received: from mail-bn8nam12on2094.outbound.protection.outlook.com ([40.107.237.94]:1120
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233786AbhDGT4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 15:56:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Odgw3TRoPe4AUc4QOZJgt1by7UI3jrBvGw0g41QKEkdMWk7GdT9aCPb78Z7lc7ic/PQ3JutOdZm05WkTAYmkaaqHRAylKQIegg9QNE9r1pVE9nybgAbtsS2GxFUdV1ngsGzheTwV2KKSz4ojGcZ1BTVtX/ppJMUrF6GVwwJTLK9fNN796t/1R2Ekx4p7seA9F9zaioJblKZon/kQLzArZO+TZj/oaz1h5wxbup3ceYgIrcbv67f2DY+L6aVGB70PoqpTaAvn5hWvbVFOOyXtz9TbU/6AMXJq4CfUJrkUkFYjfQkdtYQG5mXPHnNNaHut3Qn5OWBmhMnO1PBRQP8MFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLuTkBjtLMKbRvUd22kgm6VivljHkOiuFpjtd2X9IWs=;
 b=EQW1EIEUKOBD7uCeXdhVLeo4wXQjVwJDn0+w9ZlM7Rs8GQQJRT2OhqdrDb8ZRiShaftodY5hZDRCqzGwRKvJt+gP9rfg44N+MgixjB4I7Iuwkg+LO9Xw6yvYu4cxOviwdmnn0hNMyF9v+dOIM6Kdku1HdrBa0i/HtjENpjmq6OZAISQ7YGLpCtr1ziRJ+4WEJ0G8lzjkIM3DNEt+AbsFkErQTyw/ThANuVV40hYLMt8pFOuO2/1lqrUkoj2IJP5VVDPyqVe6SNCDI35emvUiS+RZeyKdMqmkh+1XVC9Nrbm6YhStMRV+X2jKA8wvBUYLoDiquqEFvlp/xlqeEk4a1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLuTkBjtLMKbRvUd22kgm6VivljHkOiuFpjtd2X9IWs=;
 b=BvTsOY3ZCMPk/3Y5zUFpPicgqlviVjQGYxJXTctKVN/acScYflKHcu4UGp4ruxDRB6H9qTbspj23C/APqHgLLEgJL3rl47rCgjIMcHseU33WkDNWZHqLEJNl+FMkbf0S90HQTKjlZjq0ZrVvRrKpMW5RhGy30BZ4DCPuxUYi13E=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MWHPR21MB0285.namprd21.prod.outlook.com (2603:10b6:300:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.5; Wed, 7 Apr
 2021 19:56:05 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::5874:413c:8f1b:6b0b]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::5874:413c:8f1b:6b0b%3]) with mapi id 15.20.4042.004; Wed, 7 Apr 2021
 19:56:04 +0000
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
Subject: RE: [PATCH 2/7] hyperv: SVM enlightened TLB flush support flag
Thread-Topic: [PATCH 2/7] hyperv: SVM enlightened TLB flush support flag
Thread-Index: AQHXK7whbuQnG4kFtUSh7sAvOHJr76qpeGhg
Date:   Wed, 7 Apr 2021 19:56:04 +0000
Message-ID: <MWHPR21MB159384D7BF8D845AE8085573D7759@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <cover.1617804573.git.viremana@linux.microsoft.com>
 <2f896dc4e83197f4fe40c08c45e38bbdcc5c0dbe.1617804573.git.viremana@linux.microsoft.com>
In-Reply-To: <2f896dc4e83197f4fe40c08c45e38bbdcc5c0dbe.1617804573.git.viremana@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e3dd0429-5053-4b21-b30e-f2fa0ed0c522;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T19:55:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93706ec7-d3db-4206-0127-08d8f9ff2d95
x-ms-traffictypediagnostic: MWHPR21MB0285:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR21MB028552C40C61B113645CE2BDD7759@MWHPR21MB0285.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NJGn57zVmk4zs3LOOKaXadyYDHCoZSN8WuzaoOd6HJvr8q60egHc2SaauPAUqG0Adva0pnqTwLwiRptZjiVQKYRByAKsCWYdoiRCnUuSzVqJR1aPygD6bg8RDaYOUyqV5f2IHnCtW0a0ggmXBnTr5XDfHuZr05SGAG9FLxznTd0p2j2RThzfjFW1qubs/WF77XeztHTOmAJLzJQsYFcIcxVCiJYRvRXW31bTuz/8NTUqWSFvefJoNF2w+wFEqgAQWZhnhjGkWXzTFocxrMfSBi2BPzB52QzrGkUim3MsT8tC1HX9Wqg5FGJeX7asnGXzXKSmUiWWvmsQJF5LgqfVg8g5G7xCajPQAH3rf8YaYJEZxu/BPCPPQeYyDuYdSPgtkjROKj6cuwKitdm1EZEgFG5NpFR/AFfkRqXzoPROVKdFEGSpUC/mWIXraypISmmfyJObzMVTwsPdgpBo/9a/mU3NGPrOXryDcz6b7LDzcQuL5EVkOw0qsRqkVRf06oT6PUeECTspfN2TsajL6U2W92EoeeD3u+3q3voHOoSuZoFImdn7T61QVbOK4ECELzPKYEw0w3/qw43AbWidcpmyI9EHwiAXykR/YcM1yEsq6e5zFHSQ39T1ObwBQKelLVb4ODpcWINLWByAXIhBvSaAf0soPX7SdIY7QLMueY5wsi93XTmAIOHAla9Q++m+YA3F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(110136005)(54906003)(66946007)(52536014)(2906002)(5660300002)(316002)(66476007)(66556008)(86362001)(66446008)(64756008)(76116006)(7696005)(8990500004)(8936002)(8676002)(26005)(186003)(6506007)(7416002)(6636002)(38100700001)(82960400001)(82950400001)(478600001)(71200400001)(10290500003)(4326008)(55016002)(9686003)(33656002)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YzEoQ/NoHbNguXK+3dxcrlfgs2R0Oozowq99eAqWmPQ1z3l+ZCoX5jjkvQuw?=
 =?us-ascii?Q?OIS92C+MS+b96KMTQPfL/dECwJxZ9sdnwHqb65vWODLMAONowrNWUAUgKHli?=
 =?us-ascii?Q?Ddorfo+vKDnnBgvJtY8YXk98LFeP2kC65uHenRr5DrfDq4AwDHyfl3ptgVBm?=
 =?us-ascii?Q?QcWwjdNPkoKek9MOT4dgKJ31d3YcdhZDyHpHO6RUVEExR7WYfcySdkzXPR3A?=
 =?us-ascii?Q?g3znG+l2gFCkTgInSpI6nBQ3kJsl2sJhYaWWgnx8l1+wk3A+oOrP34H/s5bw?=
 =?us-ascii?Q?YBXDulz1j9dmhJibl6KYFgmtjsc5wIBuwgRhhUjh2gI4QfuyrGTl/5RXvQ2D?=
 =?us-ascii?Q?eV/biw/haZ0b3Y8NPUX71GrWzB1qfwj2FaJj6IrAlCLyKL09yAAF7+AeVV7n?=
 =?us-ascii?Q?yT1N/lPoBRdp2CAiRAeiTKnfWEeXLr67ckWut8kOV/ssy4wghFD+azR51hAx?=
 =?us-ascii?Q?fTgoPaB6oUjGPinlAnosW0OGkU1S2DfBEuifjCb+Rpdqvvc0cWDR2sFQfMGx?=
 =?us-ascii?Q?hVkGkpXajN1MhJJO41YZGaUiw1CyaWr9Kuy9EoG+jZP5Yh2c57rE8AzgDHT9?=
 =?us-ascii?Q?UhyCWAG9vBNNn36LslpRIC6J3g3hjMJjQeDqZOC7y0gsX3loQRjs/PXVc/is?=
 =?us-ascii?Q?ZdctVUM41YND8Sz5SSxf0dqhduViFzwqzVF7mfz1USXYQreD0Jw272XDnAMZ?=
 =?us-ascii?Q?mwPYdHu92kEi/r1nLUyywJQ6SQxiZSHTQ7iAW8351kvI3ORL9vawV7cy+B57?=
 =?us-ascii?Q?x8kFhxEDhrgfdpw9044LNb2I1wsFA/p3XKYHP11C+eQwI+QLFiAiw8g680Fr?=
 =?us-ascii?Q?UxIxvUfs2LfM16b7nPnByMN/uR5+jBRdyK/xY/myfSXSM8k/mEREnJTDuJ5h?=
 =?us-ascii?Q?E4krLhoeqewLn2HQlfTCCr//+EPvcWcYu1CIpoWJ3L9kx8i70bKgj2rwSn2m?=
 =?us-ascii?Q?0BjL+mbUSe2gcprEdkI7QHpr5s88Q7kZXj5PARoDBT3kJYU8/OrphRP3Exe7?=
 =?us-ascii?Q?bladelIxeJmgId55r2WdQTPbHoUmF4DaIani4+6S9HY4Y66Kd6ZPU7qaimVc?=
 =?us-ascii?Q?eYyFRS5s6sPPoW2HSz9hp1B80QafNo2HWGNS6D5vOyzPwFpyrtPF3m200hhG?=
 =?us-ascii?Q?Bp5U17/K+KjuZ0R4hV3y28niyu4q00ylGWOUGGy3ueN9iLn5kmjRhXd1wuWD?=
 =?us-ascii?Q?uNDTSTK/hPuDyaQTiiIQz5kPENJIaQdv+9NpaI771koEFMiLZUeNx3z9Sr7e?=
 =?us-ascii?Q?3RxPIBN2YCdEzG+yQMT0Hmnap92RTVA4AGgapB7fKNNhKLri5fs1U2eqLv65?=
 =?us-ascii?Q?0WlasdbaLpjHf3/a+G69B1JP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93706ec7-d3db-4206-0127-08d8f9ff2d95
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 19:56:04.8622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wnskEbbGNYGrEKnYPh0Vj+2a2SI8vpcP241XFG96eKfhi7meltxiGxVygLvDN9TZ1X64M+S/USGxB0LHBEdMjnakt6lZt/MHO30BlocigM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Wednesday, April =
7, 2021 7:41 AM
>=20
> Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
> support for enlightened TLB flush. With this enligtenment enabled,

s/enligtenment/enlightenment/

> ASID invalidations flushes only gva->hpa entries. To flush TLB entries
> derived from NPT, hypercalls should be used
> (HvFlushGuestPhysicalAddressSpace or HvFlushGuestPhysicalAddressList)
>=20
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 606f5cc579b2..005bf14d0449 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -133,6 +133,15 @@
>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>=20
> +/*
> + * This is specific to AMD and specifies that enlightened TLB flush is
> + * supported. If guest opts in to this feature, ASID invalidations only
> + * flushes gva -> hpa mapping entries. To flush the TLB entries derived
> + * from NPT, hypercalls should be used (HvFlushGuestPhysicalAddressSpace
> + * or HvFlushGuestPhysicalAddressList).
> + */
> +#define HV_X64_NESTED_ENLIGHTENED_TLB			BIT(22)
> +
>  /* HYPERV_CPUID_ISOLATION_CONFIG.EAX bits. */
>  #define HV_PARAVISOR_PRESENT				BIT(0)
>=20
> --
> 2.25.1

