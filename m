Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C90A528D00
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 20:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344838AbiEPS2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 14:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344897AbiEPS2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 14:28:40 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A51A3E5DD;
        Mon, 16 May 2022 11:28:28 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIHIck017337;
        Mon, 16 May 2022 11:27:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=DdET28op3sXbkq3r0lhDDOv9CAxvSsaicEYzbEsT8Uk=;
 b=QWfNLSKiKocRHhbD+IHT5hmV00VcKVhzuqBVwpgF7UrMLYIIsV/hUf5cZEX01gHqFBgi
 LlVsNX22GR37cuMmrl2XDm1LomaBTA4JPYVokDmxarVsZWl7kO8prxGziNC++RakMMdr
 4uyYxk0zNEssbERN6JilseUU1Ze6KvyGd50QLodJdpNVDdPvd826WV8uI0u/L2YnxdL+
 R41GkhxUAd/mS2f6nRX0qfnOcInVxeRvh1IqsPwVvhe1k5oULaen+KSrPQzhrDQWQen1
 Qyye+0TtZ3q+PlEb+OZ30zQ5BWI8tDMA8Ut7WmIOo8zRJ8qMd3ge4dxVvwILzOvbZ4CJ /Q== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3g28b945te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 11:27:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8TsLI9MMKjhdimHBj5t7y6ErxBf8vHZtadcMPglpvOVURRJidvvnsbRIrd/+q34+B2T/Va2JlEhI1j56Igy6Me6/DTM6FUDDqgEHQ3vJSxIY8iUdnLdg+AHayNcN/Fes2DXpcij1Zg8Q4l0AQSoYzYXjclZP+3Bh0ssJrXrS9uuH+NqpxWwZ9+mh6GJBbxn8cd5FBv3W22IHLx1ESfpbgnKYXkMPEiiYCQHLiPa0wTmBG9iu8Xv5HrikA/hMxKm7KK56Eln2TXLSirS1r8hm2of4e1smdru/esMI0EBMvvhcljlXYIDquf0n88MDnjwUjZqOwcXWfJvcoHcGoLMZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdET28op3sXbkq3r0lhDDOv9CAxvSsaicEYzbEsT8Uk=;
 b=MlopU7Jg2uTrc8ZWRyzUBj7FkHltPWrGiSLGVqjLXrNLPhl3/Oo3w/Ec6/N6MU5/9H6OhHCM6+jGap5MCaG9RK94Jj/WSeOa6sNU6eIgLeBjFb4qSEU9H8L35xaG/cxHlYUhEHXQp36JJ/yinZ15vUqatreGnqUJSPgjhpBXQ/chRUU9k3gYsZL2o4oaobBB+OBBimTViF/QcGDFS8c0wfO+xkhRcXeVIFMpXEtIS0W7zQnS3g7W7dnjWihMdlgmGakuAyFA2/ZvG6THy7Nj1NIQXrPAqfO5b11savIenvRKXKH/WvfCBgxNkSTKhDaGaRlQS90nRzoKQRUqALR/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from BL0PR02MB4579.namprd02.prod.outlook.com (2603:10b6:208:4b::10)
 by BYAPR02MB5958.namprd02.prod.outlook.com (2603:10b6:a03:125::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 18:27:22 +0000
Received: from BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f]) by BL0PR02MB4579.namprd02.prod.outlook.com
 ([fe80::fd14:ff80:d4d9:c81f%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 18:27:22 +0000
From:   Jon Kohler <jon@nutanix.com>
To:     Jon Kohler <jon@nutanix.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Topic: [PATCH] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Thread-Index: AQHYZigD50jTp0T7q026slKeRH2Mca0h2NmA
Date:   Mon, 16 May 2022 18:27:22 +0000
Message-ID: <6794E98B-2B96-4AF6-AF4E-BE15574CA081@nutanix.com>
References: <20220512174427.3608-1-jon@nutanix.com>
In-Reply-To: <20220512174427.3608-1-jon@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a497185f-cc10-4d7f-b969-08da3769b826
x-ms-traffictypediagnostic: BYAPR02MB5958:EE_
x-microsoft-antispam-prvs: <BYAPR02MB595827C87A71E306900D5678AFCF9@BYAPR02MB5958.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MHv8CIE7tjbrIzZEWgFEZTrp0uW0ywP1ifhfz9pxad0u+Y0B4RkqI772N6mMheiG0w7r9/lqIrtCAAm9zCoqrpqRbpJzHVnt84TiykPDHLrBRbHCvshUrovl72PLfXSxoVysL1Cr6/zPWqI40t2ebn0apF/TKjTbIDARIMI55bxnr04NE1JyhxfDQBoCVZAzGrk+bwMkIcyXGaF9pZWtbNIYKciWzmtVT3+X68tDVi89YgBq09k5ubViOjv3FUrP5LypvoBC4CQwkb8q+tkAftMNz/GBX3lWf7l7Dr0BXwIZkdgfgQycnPXkBdtBaSHy4LIrzeCaF5VLpslUZcecFOHgrtrh2XQQFHsrWc+2SlnNfSuFsWdF/irey6XpZxoM3WuXg5mY9zgvdmoFK9lvWKLNDNjxA6DpDb3nKkoavnwplrYRvRc5WsDByX+FBxQ7MIAWT8r4kmJ+dGCouCIoLBTnFhaOuqqoYdN8IaEnG2/hqNKi2vsBt3mxdFlLye77CaERjD6cegKhuh+oks2htp2d9u54o7SXuAmTYzx1uUTnyypGlMSiyczdU7jRjrzmBUfhKEFw7xZSob57UJxIFQtX5Pgd9etgvoIDlZms44n8Ac3fvFaU+zPdQB3+XypWnoDZQQBHukNDQ8hCMulcuzmgnx6VMSHir70yePESyjUBGsoKOWncnggEYxF1MEmsWDqiXWDKcAJjh0tsgEC45tce0YJqRoGBVXVg6Ty75kCdKXkTPluqfWKGGp4XftBg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR02MB4579.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(6486002)(71200400001)(6200100001)(53546011)(6506007)(122000001)(54906003)(8936002)(86362001)(7416002)(316002)(83380400001)(36756003)(38100700002)(38070700005)(66446008)(8676002)(64756008)(4326008)(6862004)(2616005)(66946007)(91956017)(66556008)(76116006)(66476007)(2906002)(37006003)(5660300002)(33656002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MWHEFKmPTE1Ee9xyqra9LHdGGpd/Y66Uy7O/xMtU96fnGU4C+bHxizcznWHo?=
 =?us-ascii?Q?VI15vZwxkrfYE5MnSeInAZlO1hKRgISr1DKeDhibcJqDDcmRaAUAxG5sBm/y?=
 =?us-ascii?Q?o+ZnfRb/m8Lr6i9qajtc3tAG+r0Dr/mje1QstL7V/0GjbRPimc5pLyccmovj?=
 =?us-ascii?Q?pltiCTH7yhzgJTCH5lN051N/fUvYDbk2Qx5H1GDY7GNoX0drEUlS1vFJorKC?=
 =?us-ascii?Q?rUdS+ka/+lx2gv2gxzj0deMJIGlVFkm+OjvoJfehz9c1RQc68LKteohc7g4Z?=
 =?us-ascii?Q?DBdLUx7NJZ9TPL7zp1QnV2qFhzBR/68qFA0BAFoL046OtQNmq0JMMf6W7z3y?=
 =?us-ascii?Q?09BXRozfm+H2zXqZEB424l6X4PXnkiO09BwktmEClLnbwb7ooiSxBXxtV9QP?=
 =?us-ascii?Q?OajkbsGOEK+18ZuAhTNLCun0nur5sEIRsN8s4xLJcaMTtIrOnkDJTLuvmrWF?=
 =?us-ascii?Q?XqoUevhc+m86sflXzIKuo+543onoAYyfF2tk2uX6bUHcbiqHO5VFK8p3dQa7?=
 =?us-ascii?Q?S9jF3YM3QPxADRN0P2wvTg/dCCwIJUWtPkb7U07S4E/y0/oqZWglJoJ0IFjr?=
 =?us-ascii?Q?H5P+cWXAEsqcSMmh0Fp1BcAPwA7C++tgkw3b3HNayc3a1bnpMzVvbIrXBecG?=
 =?us-ascii?Q?9eWhzSd34tkR1E7QRLcdu7PsF+JNdh52W474mZonU0KdQBWmmPaRMsKO83mm?=
 =?us-ascii?Q?dSVG0gybjbpSy9qsLCCtXJPniJCtr4V9JsN7kdyuHOERjMxttKJ+0hL59Gzx?=
 =?us-ascii?Q?nBaiWuJqtnkfyTRbsFhi9y8HncRU8ftj+kL+jVSJfZOGwaUVHmfHx9Kybba8?=
 =?us-ascii?Q?fxVIe/M5X9pRNJ+2HFAz+3J0lrnAm3tVQ1/4QKZNw2FJG8TkjnN+OLexAT8L?=
 =?us-ascii?Q?9WXJn1is5c1xmy0onOUEh8uh6veaR3J1iVrPC44RS8iT3KCGYEaoPK8kes72?=
 =?us-ascii?Q?qKbR7TyliHgjedqa56hbbIqNv1Eqe1H5FbP82E5ZKRVr4b+NLBxDyzci21ld?=
 =?us-ascii?Q?QuBveq6DrAgCWgBFiOZrsd5WrJ/d/pwJ//sbQqdG0o/OvLZwQwleDFICEa8t?=
 =?us-ascii?Q?uweM0S8FC9b5yMiziKTURI4dctCqPCzoRTebYH3X5A8HtAY3FsVc6OV5Vd+K?=
 =?us-ascii?Q?KEhw3Wi44HbdWnJISFJPgjOe1uGuQxZul6p3I9gryHvA1qej2LwI+MAjqdCB?=
 =?us-ascii?Q?TAXp0fmaDJDmvvYCJVoW5uKX3MxPhxs6D/1x6zT1ogjDZsVoyON93xlmOnXb?=
 =?us-ascii?Q?ZeatOGFn8dlLJiNxD5RllWtTXRQ41f89/2Y6+d3lVTzSoiifrj2IDCBap6s7?=
 =?us-ascii?Q?esuFy8YlV6Vh6VX6CfQwDALlplpipnyvXTkBt3cCwEgxHJlcTCJ0USG7MLUq?=
 =?us-ascii?Q?u+s2K2qV9FQITa8pkbTZOyWKuL3+wAdUQO3VLJwt2XjZ0r72j0Y+YymWxOn1?=
 =?us-ascii?Q?Ft9XVhdtUuQpAbZz6pT37ZPvK5PBXQHWC1IRdcKMdRgzjiEochPt2MJoYF19?=
 =?us-ascii?Q?FHzH2mo3VopoFerIX8krVtUxLGPwSzcG7UVPWYpHxdYzVJrJKod1YsZa1mWS?=
 =?us-ascii?Q?abtERj3VWkcUD8eqLqB2v3SwAzftciTMmXOBb1Cdz9wEe83LRSUzjtZgGXmy?=
 =?us-ascii?Q?nirLQzWwxGNPzgVyy0rJzWU0tO5dc41TNENgkYMZfjLckV2P+WqE+Ydo1nMh?=
 =?us-ascii?Q?ZWz6GMVspDj5729ddop0cFm86COsOeYVRfM906N1DaB9AIKJ5B8ySdrsZa+Z?=
 =?us-ascii?Q?lZ09ze/wh7azh2uiDSgRQOAwjHW+2ORK4wl8SyyrBbnDcQgA4k92PqWtTOlb?=
x-ms-exchange-antispam-messagedata-1: SSB5brWlHPP1EMryay209ME7q6U2tWWXPPVWbnqCV86l913qurE1vCa/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF7E5EC50E7B3D46A63C321F197D0D1C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR02MB4579.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a497185f-cc10-4d7f-b969-08da3769b826
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 18:27:22.6673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8BwErKsCzLYr7aaTpSwehMlLhVVqiyxajdco73jXHYc9yjT9gFTx1/+sCdqVFICzTJovKKLvR4wq3n0z3CPoESa3iSJEwBNm/CenTqAlZ5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5958
X-Proofpoint-GUID: VkjuEnapeUscx5NpAWmJF63EqwXFTM01
X-Proofpoint-ORIG-GUID: VkjuEnapeUscx5NpAWmJF63EqwXFTM01
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On May 12, 2022, at 1:44 PM, Jon Kohler <jon@nutanix.com> wrote:
>=20
> Avoid expensive rdmsr on every VM Exit for MSR_IA32_SPEC_CTRL on
> eIBRS enabled systems iff the guest only sets IA32_SPEC_CTRL[0] (IBRS)
> and not [1] (STIBP) or [2] (SSBD) by not disabling interception in
> the MSR bitmap.
>=20
> eIBRS enabled guests using just IBRS will only write SPEC_CTRL MSR
> once or twice per vCPU on boot, so it is far better to take those
> VM exits on boot than having to read and save this msr on every
> single VM exit forever. This outcome was suggested on Andrea's commit
> 2f46993d83ff ("x86: change default to spec_store_bypass_disable=3Dprctl s=
pectre_v2_user=3Dprctl")
> however, since interception is still unilaterally disabled, the rdmsr
> tax is still there even after that commit.
>=20
> This is a significant win for eIBRS enabled systems as this rdmsr
> accounts for roughly ~50% of time for vmx_vcpu_run() as observed
> by perf top disassembly, and is in the critical path for all
> VM-Exits, including fastpath exits.
>=20
> Update relevant comments in vmx_vcpu_run() with appropriate SDM
> references for future onlookers.
>=20

Gentle ping on this one

> Fixes: 2f46993d83ff ("x86: change default to spec_store_bypass_disable=3D=
prctl spectre_v2_user=3Dprctl")
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> ---
> arch/x86/kvm/vmx/vmx.c | 46 +++++++++++++++++++++++++++++++-----------
> 1 file changed, 34 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d58b763df855..d9da6fcecd8c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2056,6 +2056,25 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
> 		if (kvm_spec_ctrl_test_value(data))
> 			return 1;
>=20
> +		/*
> +		 * For Intel eIBRS, IBRS (SPEC_CTRL_IBRS aka 0x00000048 BIT(0))
> +		 * only needs to be set once and can be left on forever without
> +		 * needing to be constantly toggled. If the guest attempts to
> +		 * write that value, let's not disable interception. Guests
> +		 * with eIBRS awareness should only be writing SPEC_CTRL_IBRS
> +		 * once per vCPU per boot.
> +		 *
> +		 * The guest can still use other SPEC_CTRL features on top of
> +		 * eIBRS such as SSBD, and we should disable interception for
> +		 * those situations to avoid a multitude of VM-Exits's;
> +		 * however, we will need to check SPEC_CTRL on each exit to
> +		 * make sure we restore the host value properly.
> +		 */
> +		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) && data =3D=3D BIT(0)) {
> +			vmx->spec_ctrl =3D data;
> +			break;
> +		}
> +
> 		vmx->spec_ctrl =3D data;
> 		if (!data)
> 			break;
> @@ -6887,19 +6906,22 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *v=
cpu)
> 	vmx_vcpu_enter_exit(vcpu, vmx);
>=20
> 	/*
> -	 * We do not use IBRS in the kernel. If this vCPU has used the
> -	 * SPEC_CTRL MSR it may have left it on; save the value and
> -	 * turn it off. This is much more efficient than blindly adding
> -	 * it to the atomic save/restore list. Especially as the former
> -	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
> -	 *
> -	 * For non-nested case:
> -	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
> -	 * save it.
> +	 * SDM 25.1.3 - handle conditional exit for MSR_IA32_SPEC_CTRL.
> +	 * To prevent constant VM exits for SPEC_CTRL, kernel may
> +	 * disable interception in the MSR bitmap for SPEC_CTRL MSR,
> +	 * such that the guest can read and write to that MSR without
> +	 * trapping to KVM; however, the guest may set a different
> +	 * value than the host. For exit handling, do rdmsr below if
> +	 * interception is disabled, such that we can save the guest
> +	 * value for restore on VM entry, as it does not get saved
> +	 * automatically per SDM 27.3.1.
> 	 *
> -	 * For nested case:
> -	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> -	 * save it.
> +	 * This behavior is optimized on eIBRS enabled systems, such
> +	 * that the kernel only disables interception for MSR_IA32_SPEC_CTRL
> +	 * when guests choose to use additional SPEC_CTRL features
> +	 * above and beyond IBRS, such as STIBP or SSBD. This
> +	 * optimization allows the kernel to avoid doing the expensive
> +	 * rdmsr below.
> 	 */
> 	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
> 		vmx->spec_ctrl =3D native_read_msr(MSR_IA32_SPEC_CTRL);
> --
> 2.30.1 (Apple Git-130)
>=20

