Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A544239FDC7
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhFHRfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:35:54 -0400
Received: from mail-mw2nam12on2139.outbound.protection.outlook.com ([40.107.244.139]:30688
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232088AbhFHRfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 13:35:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUywvdZXns5ErjdvPFGZEGcvvB1fKPKpwJmhIFYGWWkRyMgcDAIhuDjrkDaoC1VPLr5Rl7b1ko4CNCoAma77uFmun1IaDlRvpYpVbJYwIXaaoXbVancuGKx3U+j1J1yic3VDCBzk021GHLIN+Ob1EoT4bxfImjrB0Sev8sYwi5/urAvVfZ8u2N+MzbWDin0FazfI/Z5vCDTyJO9lsP4K4MT654g7yAwouDrd+Noy+mNU1kfRdo7oLRcHkoftyYtmuZ6FXyERTCqPo9m5C2A4gZiPE+6lZ8WRX3VTykkR3QRasUJl+yZyq7Ks8O4O9wWF09j7d3jjww4Lq0UDVDchjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yaGHdsDyAjYNaQ9XOD5m7Hj+IORLs6iX/PiYqdnFKg=;
 b=LdsoX2RQhGRZeg5ZLg1DH4oOX+2jJY1GQMOCTO9LJL6sFzXfjBpMLbpenRy5cp9QEBh9b2FGnnOfYr109FHpbJXalSJd/JI6Ld3AOS9cdXwPRmU0rMBmDZRru5i2yTltJEA8+N+Cqg9P4YgjB6DazBnI0w0bQbL8gI7Al8J+jEtGwNEMS5LZI0R3qOpgk86mwcVKAvSsiLmuxUIByVAjoiJ/KuxgNjF8cBr6xTRL6680YcuNhi0BW11cVTe9T7iy+noBteZ21KMcMEofRF8NrO+1HU5BFEEdLKORjlgeI9hLhDdfi/yKrPy/GbnsnJDZuuUCiBp0ZO7RUCD36EtXbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yaGHdsDyAjYNaQ9XOD5m7Hj+IORLs6iX/PiYqdnFKg=;
 b=RWPGZAO+oRf6WxwQXLnkEkuFWcc+fJRA/tn/H36USIunVyvTjvhuEUnR9fgb6ANmzb/hBqDFNUiRBwjAsE1bkeaCfuEmmDEjM62dLk5ilBhkFRBp2vrIgpsjyC5EBt6zpdrIHmZzQlt9PUufPSBsF+0SA41WwcNY1l7oGwrk9o8=
Received: from MWHPR21MB1593.namprd21.prod.outlook.com (2603:10b6:301:7c::11)
 by MW4PR21MB1924.namprd21.prod.outlook.com (2603:10b6:303:7e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.7; Tue, 8 Jun
 2021 17:33:56 +0000
Received: from MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2]) by MWHPR21MB1593.namprd21.prod.outlook.com
 ([fe80::8dbd:8360:af6:b8a2%9]) with mapi id 15.20.4242.007; Tue, 8 Jun 2021
 17:33:56 +0000
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
Subject: RE: [PATCH v5 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Thread-Topic: [PATCH v5 5/7] KVM: SVM: hyper-v: Remote TLB flush for SVM
Thread-Index: AQHXWIs3nDz+pIOoDkaM+lsbJZxERasKZxnw
Date:   Tue, 8 Jun 2021 17:33:56 +0000
Message-ID: <MWHPR21MB1593C3483C62B7567FFE9AF1D7379@MWHPR21MB1593.namprd21.prod.outlook.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <1ee364e397e142aed662d2920d198cd03772f1a5.1622730232.git.viremana@linux.microsoft.com>
In-Reply-To: <1ee364e397e142aed662d2920d198cd03772f1a5.1622730232.git.viremana@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4c7661b7-9680-41e8-b2ab-bde2c1bda1b0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-08T17:31:19Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79b4e86d-e8e6-494a-81f1-08d92aa397ca
x-ms-traffictypediagnostic: MW4PR21MB1924:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW4PR21MB192457360252D65EDFDE8A3BD7379@MW4PR21MB1924.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DMTNjkAsuodkK2bOKDk9JnKJau+ArEWNyFBobx9K61AiIGfZyPOwuHcgVDmH9tuUT5dTZkXWfcQddc0oMCiwNxN9fXXth9a/QtESA4PNrlmQNs5Lt2W5IQFMJO3Kf2JlftmLqt9XtGBX0F3530d19Xozyo36SLAB+ain39/Wh8O4zGldRbtfT5l9yt+ouVeDl5EMPCNfCP2o1pkiibnVvA+d1SF3gLVwX+fE3S/KPd+1e5zME4a4TdSsXtry36nQeH2VmRyCnW/qFenui3iolwPkZuyty727tsr7jVspCwb/P3C1x+yfnmfdcixiDHR9eDf5duDP0qm7n+wJVB2SWqYf+fJegTo5PTDb9KYVvYej+Ynz4HLge2aBxkQC46Qkf8bIMgn8unMHPnqmRDMutNL1dDAaMiCVL2Kwc6eKvDDw8MJXHrLw7dMSpYG0FBCqqoOT4srIqnqVEboGqDVQbgz8m864fDzBLZcMB6MIRS8Aqx3tj/d/lN5Sp43ge/sor4Wd2U1iMFwZzAxJ9foBa5On86D8thtLPpCPdv9D+pslBh/4qsUdNubpdxpGzRdd1mbdQOy4e3/mE5iqtp5Eewp9tdOXgwIt3Sj5NKIF3f/XkOdWNXBl6wbu4Gk02OurJVO28ZYPMxSw8XI16Ro7wFpogcztGFDGB3i7CTQDvsTsFvHpgqhtF2EndDRn7z71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB1593.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(55016002)(82960400001)(82950400001)(86362001)(5660300002)(478600001)(316002)(9686003)(8676002)(110136005)(2906002)(26005)(6636002)(186003)(76116006)(10290500003)(6506007)(122000001)(38100700002)(52536014)(33656002)(7696005)(8936002)(7416002)(66556008)(66476007)(66446008)(71200400001)(64756008)(4326008)(66946007)(921005)(8990500004)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b6ox+8woB4sPVVYAbn8Pg0rZBADNNgquDFEwPn5J41Xc1ts/3rO7xheUADsT?=
 =?us-ascii?Q?R3SBBJ4nZTbcDGPbgFrpD3zmzJHT+58a6W2aHhQJZvXUXV9sDSDXe0dDApWl?=
 =?us-ascii?Q?x3oAUbQSZkjY/PdP+uJ9jRL5qatGkUJaj9jXMXunNLdogGlruM1+VY8auAmN?=
 =?us-ascii?Q?v92VBTe8nlOdldk4hzp+M1FKgrpATzChlhFNAhdTdLR4khsbWRfIxdvPPYzq?=
 =?us-ascii?Q?sUqA02WnoOX8QBIJBDbTT6D0E908ZumPwwZ15sadTeQTPsIojNvWwL0iyWrO?=
 =?us-ascii?Q?rUCRtOMlxMBcmFqKBSJpgWKD3rOW/ta8uhTva8m9CD0U8521IB+/KqnKC6kU?=
 =?us-ascii?Q?LM4uPtF+O8tDvy4MXGsm83ci72xpyAoibi46UD7TgclQpAwpVhrPdJtwF45L?=
 =?us-ascii?Q?XE4VKNM8RIwcBnbeKGzslk2O5RrkAd85Bfhy7dmdOH9v0ny0RerzmjtoXtit?=
 =?us-ascii?Q?WxVFZLop3KSn8chF9Mqovwbzz9ylf32oD2n8xbD2pLvplZp/+8PSnDnXQTaT?=
 =?us-ascii?Q?ZP6yHKBr+Wu7XuimQ78ou2fbXBjA1DpGj1p4HuvxhWUfMSraFVeYWKnqBK63?=
 =?us-ascii?Q?//GgzSzmeWPOfan+6ePK8MMsBwto9KhfNE4iLSPEqtrt61e0E4YvgsIiCaMB?=
 =?us-ascii?Q?c0kDm8r+PFWL4osd/9kR0Sn8KrjAGv3sk9gxaIUFeYymaCC18n0EoNYGS/aw?=
 =?us-ascii?Q?yyTsFRBfmZreTbmWtR1u3teAllCn+FtS0EEmoCsutDRz4aQXH/UwRkj9tfGR?=
 =?us-ascii?Q?MRP9UBTKcrz9Gvr3eGRwjH6W4hz3DC8CdedOp6Va5P4rEVHXzQqzlBVD7tJ/?=
 =?us-ascii?Q?TeQ8CUXcMm4/LH4290OVCNrln2R0EFAxI4rHRQuFbo8+qSTuo+f6fiI7b6Jx?=
 =?us-ascii?Q?CogkmXWHdavfxlsQB+6qxPjwpXKtfj1zYe8tbCbsrisWmxqMxru8DXcviBj/?=
 =?us-ascii?Q?dNH2W4gnMSAVAY0PYjdmt7Z4WopUSiE33ZJ5yO6I5m4iRA8Rqh2R29iJmE8o?=
 =?us-ascii?Q?VmC9Ny5uadTxqUjIfIrB82pXv8W9ueV47yeNtDQCuJ3Uuzm3zjskj38A02dG?=
 =?us-ascii?Q?uV8/k2kvMV9e2CcwwewN4GijtPUaQE2Ki3+nMOk/hOlEL5CoCsRn4jV0ck57?=
 =?us-ascii?Q?RjiM8I9vd3dsPFpWO1gIoXeLkguzTELykTWuja1oqw6jTJeeLQktAZUiApxK?=
 =?us-ascii?Q?l1GjzQm+YGvr8ASTrEzenNhuffYH+ogXfl4T6l5TL/NXjtHd5IGdlfRxyVx4?=
 =?us-ascii?Q?cHRIzr1ULehB9rHKTUbu4OFmTTrKluwEnpvffsZmxQkfPIZUjPrAZ7HQm2po?=
 =?us-ascii?Q?L2b+2OXhStLQzmVpbQpH3n/p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB1593.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b4e86d-e8e6-494a-81f1-08d92aa397ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 17:33:56.2034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Wh42WbORR6/MXJx3rWf97Sh8i7oDRxvLYaZa0x2SYQN1BE6OTbxKqUAUOk5tB9zc6a+YlGf7xZP6krfdurXBHxUDAHYF1uYQvIn23gryh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1924
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com> Sent: Thursday, June 3,=
 2021 8:15 AM
>=20
> Enable remote TLB flush for SVM.
>=20
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/kvm/svm/svm.c          |  9 +++++
>  arch/x86/kvm/svm/svm_onhyperv.h | 66 +++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100644 arch/x86/kvm/svm/svm_onhyperv.h
>=20
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b649f92287a2..a39865dbc200 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -43,6 +43,9 @@
>  #include "svm.h"
>  #include "svm_ops.h"
>=20
> +#include "kvm_onhyperv.h"
> +#include "svm_onhyperv.h"
> +
>  #define __ex(x) __kvm_handle_fault_on_reboot(x)
>=20
>  MODULE_AUTHOR("Qumranet");
> @@ -992,6 +995,8 @@ static __init int svm_hardware_setup(void)
>  	/* Note, SEV setup consumes npt_enabled. */
>  	sev_hardware_setup();
>=20
> +	svm_hv_hardware_setup();
> +
>  	svm_adjust_mmio_mask();
>=20
>  	for_each_possible_cpu(cpu) {
> @@ -1276,6 +1281,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		}
>  	}
>=20
> +	svm_hv_init_vmcb(svm->vmcb);
> +
>  	vmcb_mark_all_dirty(svm->vmcb);
>=20
>  	enable_gif(svm);
> @@ -3884,6 +3891,8 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu,=
 hpa_t
> root_hpa,
>  		svm->vmcb->control.nested_cr3 =3D __sme_set(root_hpa);
>  		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
>=20
> +		hv_track_root_tdp(vcpu, root_hpa);
> +
>  		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
>  		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
>  			return;
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyp=
erv.h
> new file mode 100644
> index 000000000000..57291e222395
> --- /dev/null
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * KVM L1 hypervisor optimizations on Hyper-V for SVM.
> + */
> +
> +#ifndef __ARCH_X86_KVM_SVM_ONHYPERV_H__
> +#define __ARCH_X86_KVM_SVM_ONHYPERV_H__
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +#include <asm/mshyperv.h>
> +
> +#include "hyperv.h"
> +#include "kvm_onhyperv.h"
> +
> +static struct kvm_x86_ops svm_x86_ops;
> +
> +/*
> + * Hyper-V uses the software reserved 32 bytes in VMCB
> + * control area to expose SVM enlightenments to guests.
> + */
> +struct hv_enlightenments {
> +	struct __packed hv_enlightenments_control {
> +		u32 nested_flush_hypercall:1;
> +		u32 msr_bitmap:1;
> +		u32 enlightened_npt_tlb: 1;
> +		u32 reserved:29;
> +	} __packed hv_enlightenments_control;
> +	u32 hv_vp_id;
> +	u64 hv_vm_id;
> +	u64 partition_assist_page;
> +	u64 reserved;
> +} __packed;
> +
> +static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
> +{
> +	struct hv_enlightenments *hve =3D
> +		(struct hv_enlightenments *)vmcb->control.reserved_sw;

Perhaps add a "BUILD_BUG_ON" to verify that struct
hv_enlightenments fits in the space allocated for
vmcb->control.reserved_sw?

> +
> +	if (npt_enabled &&
> +	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
> +		hve->hv_enlightenments_control.enlightened_npt_tlb =3D 1;
> +}
> +
> +static inline void svm_hv_hardware_setup(void)
> +{
> +	if (npt_enabled &&
> +	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
> +		pr_info("kvm: Hyper-V enlightened NPT TLB flush enabled\n");
> +		svm_x86_ops.tlb_remote_flush =3D hv_remote_flush_tlb;
> +		svm_x86_ops.tlb_remote_flush_with_range =3D
> +				hv_remote_flush_tlb_with_range;
> +	}
> +}
> +
> +#else
> +
> +static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
> +{
> +}
> +
> +static inline void svm_hv_hardware_setup(void)
> +{
> +}
> +#endif /* CONFIG_HYPERV */
> +
> +#endif /* __ARCH_X86_KVM_SVM_ONHYPERV_H__ */
> --
> 2.25.1

