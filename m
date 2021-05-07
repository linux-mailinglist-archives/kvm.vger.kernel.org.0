Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2EF376A02
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhEGS2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 14:28:19 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:20622 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229470AbhEGS2S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 14:28:18 -0400
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147IDAjX010922;
        Fri, 7 May 2021 11:26:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=To6h2JjXQ4aPQHrix12cbZY4GhqH5ftikXeYtun9eNU=;
 b=WrZCWDf8LkaVV7LnCCQ/lRS3GSEzSTqVw9sJXfOwSSrEICRRwmyVQI3JhmOt+0xNdAgi
 Efx4yemZ08CxQOr8Q0oQLlfaQuirbbRqR2M/GRc278VesKJPdVjyeLsg5qGVE2Nz7Lbm
 bwHmOqhXBMwXVFkW6CrU0qAlhglgmoED2sGPqnYqAwu7bdjzPHVZb1aaQpcW9Rl/OPob
 1k+MoDkmM5sNodlaz7wQRNb84IlKEdHTlMrnJrb36cPswouIiqGCrFpf7fMk+jQ7DAHm
 6aMehtQGOSXDW63MHAgroLi/2YSdMQO7FtLyZn9yPJ4+cXogWI4+AXvuLO/scPjQaH80 tw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-002c1b01.pphosted.com with ESMTP id 38csqthvq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 May 2021 11:26:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoiUJGuJHcT8LCXg1gKb2Vt6sElToEK/svCexGkheTRXEomtnrd3i0tqmYayxl1DQs5IYhEGUBcQBIgODq7+Q5AGg7SnRwkHK2riI4gE6c+AzPCtYG6XR8L77gdSQwPWYPpVZbS1hGIeZ3cMByEtcE50DwaOWdanRnIHtzKh0rHoLW6Fyd1lzdLRm4If6w8O10cdB2xeQjCbaO3ucsjn2ewoB6Oyd1R7yWwj25bbP6ksPtR1DW5jGMX+XEAE/C7arEz6Bf16ywMx7aD6u6MlDGyGgcn/TcgA7kY9mQfrK4XeR+jJdz6oQMpAcHVn4bcenR81ieGvTWp0WJPkrPSSqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=To6h2JjXQ4aPQHrix12cbZY4GhqH5ftikXeYtun9eNU=;
 b=GftP4qU0JiOvy7Wb9CLfjxwcAcdRV4YoPModc79UsIRNrTP+a1yerxxTbMIh6/rYQv3WFkFKGgz5U1uf51PhTBCWeqoemDgyUazbMOxvH3lL6qyyRymB7TE3ZeBluTUh3VnRZQnPiK9Bn/t8QWGawpAKMfg17JTfvSzbb2cTjs/66GTLPi4Z3HBOs6IrrcS2tuORiaIngEYlnhTWppFQax0lokEqtTPEhT2ldxcFZF/1eyMk/FQAHWBcT38+XmZ6fKMiuQYcRwEExKYv0UHm+L93gWT0uD/BCd9xwI8rI368A6f6waxXTyth5xxsOFBClZKU9PCcOj5W3NvNHPsakg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BL0PR02MB3683.namprd02.prod.outlook.com (2603:10b6:207:48::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Fri, 7 May
 2021 18:26:18 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::75cf:5b99:f963:cc07%5]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 18:26:18 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Venkatesh Srinivas <venkateshs@chromium.org>,
        Jon Kohler <jon@nutanix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in
 vmexit
Thread-Topic: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in
 vmexit
Thread-Index: AQHXQ1KpTcM7v9elUEKaZTZTLSZ4qarYRHKAgAAJ/ICAAAfcgA==
Date:   Fri, 7 May 2021 18:26:18 +0000
Message-ID: <BDF4AF6B-DB1F-4BAF-999E-72CDDF408F37@nutanix.com>
References: <20210507150636.94389-1-jon@nutanix.com>
 <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
 <YJV/sZvgA8uN/23k@google.com>
In-Reply-To: <YJV/sZvgA8uN/23k@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=nutanix.com;
x-originating-ip: [2601:19b:c501:64d0:a9a2:6149:85cc:8a4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f325f1ac-ec36-4ebf-7bd9-08d911859b2b
x-ms-traffictypediagnostic: BL0PR02MB3683:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR02MB368321E86BAE52B84E7DF0BBAF579@BL0PR02MB3683.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:260;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mrCu8wSgPxunrNWkaP5BmJWmOY90wy3fmx+MtVuiRsoLDTws+nutHyTJM10BCx20OlthcLX0kLtVJhOrGM+H1GFU+pZHbCVcd0T2mMx5pRMXAlepJGn6SpDexuUopCWwxW3xFCT66W4dk3A8VD4OObJBZRLaWFa5fHDW2YqB7oyS9L5jy8M+xk1axUucWF1tpZ1HqELCBOhlj06XcbBUlOMecvyeu0qulDN2QSzYKqERFI6II2dmd7W/C1ScYUbKzBSG54jBCtjhxCl87ArRShJNU6Dn9jK2vm2lDQmoFbNA1piT0sMyjEVqulLrrZAEzEF8DsDL3ykl/tyVbeCSAF5RTCgbDPiXFqta4/5h0Ihqv2ghpQczWMgbv/YymG1Ei6j+kJCs3jMaVi5Eivp3QqVTuE0ms0AQJs5cb1nwtjVgxMe8pzgOj4oRXZ4MZSx5dxpM957aNr5VshxGEA+iPl+9TfFEPrR0Xu+6TxZs3VmGcp6r/YNIvgnss/DnG4HmtjfYvlGrQLYO3zm3Nm34mHTE3SoP4LWDBPENcSnTlmHF9Dcj5ayGkbl7vw1lqvWYH7QSlV4om6ZeCfdd/aimjPbJX2q9FsahjyrAd42ncieOGNulSxXgFf4S1LpofxKolEpIMT+lv0GNRu1HV9cbQevAEEsM0jmBflIDzq+JliKUUp4BjxwREiKVLcV/7zC66gVieTRenz68vXtVkYtnRO3I3sJwYKbBmTgnG9I9icZ2Inm+2ud1DUic9CmbL5eB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(36756003)(966005)(33656002)(53546011)(6506007)(86362001)(478600001)(2616005)(186003)(5660300002)(66946007)(8676002)(66556008)(64756008)(83380400001)(66446008)(7416002)(6916009)(54906003)(4326008)(8936002)(316002)(122000001)(38100700002)(6512007)(71200400001)(76116006)(66476007)(6486002)(2906002)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bDTJeJvqCjs+2AyWdbe8Sdy9terJYfyf8HPZsuPU2zFeI3rcJdGWqrPJ3H3m?=
 =?us-ascii?Q?SmzDn8Y49IwRXByjZ41tojuj7++X0RSAOD2AehYmXkaOBkTjWptTbOTSDqM/?=
 =?us-ascii?Q?lhdjg5Pz2lz/q8i9XY4fCTiNuRCZa/x6hRRK4Z3PWp9An5lA9XdFM+JqrsVR?=
 =?us-ascii?Q?uwmECn37BKxdVFWUw6uyVfEnOkPr11rospvyW7TsO2gJPj2yzciCDD7FEllD?=
 =?us-ascii?Q?mwxgVaOttKy9OvY0S0bVXodefPu0CR87rPsMHCPM2t0PfYTw8E5/BTZ+NTzQ?=
 =?us-ascii?Q?RgdNzuFZRL5hBDrPtIsJKssykpdGFW71Wa8vN3wTIaq8jcDHr+JbyNz5seP9?=
 =?us-ascii?Q?HjxolOL4p/4wbVQS+ZPeUK5wBAUekO/o9ovMv4MD5VwlWd0DHQkqa+w4jzLu?=
 =?us-ascii?Q?8swXQ2J/+C/3+3GnJcNu8QRgHpoJZMrgs43UpsOIH/4skAFKOBBs8zmtJny6?=
 =?us-ascii?Q?4be2JW68s9bJjgXgCWtZJAiirm88k4SXpDFeXz01nCXoSWsa2VzAFW+cB2Xv?=
 =?us-ascii?Q?mXjbRM367MCvBG2J4QplZSEKUEcplxXhwZ+YzwpT5gBBupRClULzOqfplKnz?=
 =?us-ascii?Q?fOoBTMwXiOMwhS5DtmaE027uR8WOKDEYWRH6EC2RtjGYZs77UxIfZAlWhjZU?=
 =?us-ascii?Q?LXQFSL835OaQTi0JS40uMiNSuRZ/xPxBXU/ylxT53FOLJGkfOe02bZKMA00K?=
 =?us-ascii?Q?s4TzW8cCGPYjuTBO21OJHEL20Ksm923Kjc7dfCIzIoLwywGWjDb3oNwkJQ+a?=
 =?us-ascii?Q?Raf5Q5JVMcgd06Nl6wBEyupNhqAS+GRjEsv7HzYktvT/qhXACcCimAfs9TVf?=
 =?us-ascii?Q?Si2CWwoBCZpUpTMP9C2Md3QYW9v/wlZUI13q7Wed9OvD3KC3CsQFtWyzftfw?=
 =?us-ascii?Q?GSAnDtpGsbzq/LzPMflg1d79x5DXjs3lWHhaL/7a0xzB20dNdPFqCMXqyEk9?=
 =?us-ascii?Q?jfFHnMuCXOh733OBRNJAQH3rN2BA8ZclEZ+2IZSPKvJYczmwJSR/aG0KXXXp?=
 =?us-ascii?Q?KQCMT30Op6jUjowaMTvuCWsb39YxFbMlzkPkGSwaeXh+a8FXG8MMwrq27ajx?=
 =?us-ascii?Q?zfIqUoFK+2OT1kCNnkky/8sNo/Th0YiAAEWST9bsQbYZy+n3K6jBub6hT/pj?=
 =?us-ascii?Q?Od4NfsljyE7bO7MTjJ0CjqjtbA9nDPS/uTdCI2doAJ3yjBZAjq0lZZauiRYb?=
 =?us-ascii?Q?Z96UiZUJ+vvyvDF7usuj2JzjQI3nynvdhAbitp5PCJqkzL4LoScQvsBP4+Wf?=
 =?us-ascii?Q?eX0OOHLWh4zEh0DtvG52fojOzGPnC2nbUPSJMkkr1jKpZ+kPwfnGEKzNV4I0?=
 =?us-ascii?Q?BQNNUCUVlLahMXeZrAfSHCrprs6mfsYrInkdXqKar6U0n+a9NBBdMf45RDGb?=
 =?us-ascii?Q?zoZyM8AWJy0PAitDJRIt5pCWZXOW1oduO5CgL5gDedI6IldMNw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7B01026D6E4A247BFB02BC13EEB76A2@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f325f1ac-ec36-4ebf-7bd9-08d911859b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 18:26:18.0337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eFQT2Kqx/wcLnR+ClOIsCXM3P0ECicKpZilq413Hq2q3yIAMvDhkPLuP4WXiFreg8jzd5QUyZjJjWkP2GOBM/vUodXxMGyX64slvfV4hfZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB3683
X-Proofpoint-GUID: 1PDzOfH3iI0nC47qmCBMOfshccg61O6B
X-Proofpoint-ORIG-GUID: 1PDzOfH3iI0nC47qmCBMOfshccg61O6B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_07:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 7, 2021, at 1:58 PM, Sean Christopherson <seanjc@google.com> wrote=
:
>=20
> On Fri, May 07, 2021, Venkatesh Srinivas wrote:
>> On Fri, May 7, 2021 at 8:08 AM Jon Kohler <jon@nutanix.com> wrote:
>>>=20
>>> cpufeatures.h defines X86_FEATURE_RSB_CTXSW as "Fill RSB on context
>>> switches" which seems more accurate than using X86_FEATURE_RETPOLINE
>>> in the vmxexit path for RSB stuffing.
>>>=20
>>> X86_FEATURE_RSB_CTXSW is used for FILL_RETURN_BUFFER in
>>> arch/x86/entry/entry_{32|64}.S. This change makes KVM vmx and svm
>>> follow that same pattern. This pairs up nicely with the language in
>>> bugs.c, where this cpu_cap is enabled, which indicates that RSB
>>> stuffing should be unconditional with spectrev2 enabled.
>>>        /*
>>>         * If spectre v2 protection has been enabled, unconditionally fi=
ll
>>>         * RSB during a context switch; this protects against two indepe=
ndent
>>>         * issues:
>>>         *
>>>         *      - RSB underflow (and switch to BTB) on Skylake+
>>>         *      - SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2=
 CPUs
>>>         */
>>>        setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
>>>=20
>>> Furthermore, on X86_FEATURE_IBRS_ENHANCED CPUs && SPECTRE_V2_CMD_AUTO,
>>> we're bypassing setting X86_FEATURE_RETPOLINE, where as far as I could
>>> find, we should still be doing RSB stuffing no matter what when
>>> CONFIG_RETPOLINE is enabled and spectrev2 is set to auto.
>>=20
>> If I'm reading https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__so=
ftware.intel.com_security-2Dsoftware-2Dguidance_deep-2Ddives_deep-2Ddive-2D=
indirect-2Dbranch-2Drestricted-2Dspeculation&d=3DDwIBAg&c=3Ds883GpUCOChKOHi=
ocYtGcg&r=3DNGPRGGo37mQiSXgHKm5rCQ&m=3Dd1CkIBCdVFwUtKYx3SRW9dZD0kA_IX9VKEPG=
2-x4kBo&s=3DKlK_T41o6UVpLhMKDcK9iZfsJnop72K3CveJVIak5K8&e=3D=20
>> correctly, I don't think an RSB fill sequence is required on VMExit on
>> processors w/ Enhanced IBRS. Specifically:
>> """
>> On processors with enhanced IBRS, an RSB overwrite sequence may not
>> suffice to prevent the predicted target of a near return from using an
>> RSB entry created in a less privileged predictor mode.  Software can
>> prevent this by enabling SMEP (for transitions from user mode to
>> supervisor mode) and by having IA32_SPEC_CTRL.IBRS set during VM exits
>> """
>> On Enhanced IBRS processors, it looks like SPEC_CTRL.IBRS is set
>> across all #VMExits via x86_virt_spec_ctrl in kvm.
>>=20
>> So is this patch needed?
>=20
> Venkatesh belatedly pointed out (off list) that KVM VMX stops interceptin=
g
> MSR_IA32_SPEC_CTRL after the first (successful) write by the guest.  But,=
 I=20
> believe that's a non-issue for ENHANCED_IBRS because of this blurb in Int=
el's
> documentation[*]:
>=20
>  Processors with enhanced IBRS still support the usage model where IBRS i=
s set
>  only in the OS/VMM for OSes that enable SMEP. To do this, such processor=
s will
>  ensure that guest behavior cannot control the RSB after a VM exit once I=
BRS is
>  set, even if IBRS was not set at the time of the VM exit.
>=20
> The code and changelog for commit 706d51681d63 ("x86/speculation: Support
> Enhanced IBRS on future CPUs") is more than a little confusing:
>=20
>  spectre_v2_select_mitigation():
> 	if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> 		mode =3D SPECTRE_V2_IBRS_ENHANCED;
> 		/* Force it so VMEXIT will restore correctly */
> 		x86_spec_ctrl_base |=3D SPEC_CTRL_IBRS;
> 		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
> 		goto specv2_set_mode;
> 	}

Thanks Sean, that makes sense. The handling of the MSR part of things
is separate from what I was looking at, which is where it seems like
Intel is still recommending doing an RSB overwrite/stuff even with
eIBRS; however, in KVM we use X86_FEATURE_RETPOLINE to figure
that out, but in bugs.c eIBRS systems skip having set, as
goto specv2_set_mode skips cover retpoline_auto now.

>=20
>  changelog:
> 	Kernel also has to make sure that IBRS bit remains set after
> 	VMEXIT because the guest might have cleared the bit. This is already
> 	covered by the existing x86_spec_ctrl_set_guest() and
> 	x86_spec_ctrl_restore_host() speculation control functions.
>=20
> but I _think_ that is simply saying that MSR_IA32_SPEC_CTRL.IBRS needs to=
 be
> restored in order to keep the mitigations active in the host.   I don't t=
hink it
> contradicts the documentation that says VM-Exit is automagically mitigate=
d if
> IBRS has _ever_ been set.
>=20
> [*] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__software.intel=
.com_security-2Dsoftware-2Dguidance_deep-2Ddives_deep-2Ddive-2Dindirect-2Db=
ranch-2Drestricted-2Dspeculation&d=3DDwIBAg&c=3Ds883GpUCOChKOHiocYtGcg&r=3D=
NGPRGGo37mQiSXgHKm5rCQ&m=3Dd1CkIBCdVFwUtKYx3SRW9dZD0kA_IX9VKEPG2-x4kBo&s=3D=
KlK_T41o6UVpLhMKDcK9iZfsJnop72K3CveJVIak5K8&e=3D

