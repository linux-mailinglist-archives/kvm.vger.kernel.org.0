Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CAB5E6F86
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIVWSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiIVWSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:18:30 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021014.outbound.protection.outlook.com [52.101.57.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21D91129E3;
        Thu, 22 Sep 2022 15:18:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4RwAGaBWOYSDK785Kab6MQ/wHJ785/CDe92FstvLzYW2PSmpJGGvUNLyNS1rWQR+Gefln2ECj2G3vRSjDHRdudw6Q8GsiS2df7/P+G63rrwLOzeszwOIgH62d5jTOYasEKY4e//T+VFEBXszdHSTRPoERoXFC3LFINbJ4SpcH6c5iz4gsALQDXs5oPi1Hj6l6m5jbnwRcNHh9ck1uIvDaJX3bRXRI+eoCEVm8JJ0xJmBt38EGR6CBQzwymX2bvEV1pGQsei6f0EMh5RHKsIaEccKyNMFA9FVxvE6Mw74OJSfip/LE8omQG5tQ2/YJSaZBs4cr4kr3L8+p0BWmTLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkWEC8JyIxlVlHnjTBAByf069Dk5aNzF71+ySt1kj78=;
 b=NyUIb2mxxLNYP8dfUv4s9b9PQufNUB16HMITUnDUq5/QOoW3X3eqDNYUNx+SFep1bAbSlMY/sIr7Qh2NHfCBakJFQSg01INE3Q3ibXneQpuezKTeeNImaAqJ6vKlDOoz7R/CNFAiRyPWL2xlbnWc2+hedKDm7nVVf2Mjin66x9B0eTXVbw1y1yR+6wPzDSwIzhvQ6zDgrt0b41mAk9umNiZQW22cuNmb+BfThFBXtsDHEkU5CubXPp/PVeLcK3KuYJHzBXqt2GKYloLhs+nWLzegGC5c8cSDpgSQbrU9wUDzqsGsCn9VM/1Mp7btThBYZ6sHVMVZbdKctDw7DvUjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkWEC8JyIxlVlHnjTBAByf069Dk5aNzF71+ySt1kj78=;
 b=jVLYe+OU3tHQJyfZBYou2pr7F87R3Xa9IanesUSQMZ4P0VP3h8WUQ9IiwZ3rcVFen9z5FGqkXliwlapHVIiFU13Ov8hNyhVRWzshhZ3/M964iers5c5JYaI7nQktxa/gaIwosXU/L1o3gzUtJAQhrHP2Qvrab8HVr2fA3cRgG5M=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM6PR21MB1356.namprd21.prod.outlook.com (2603:10b6:5:175::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.7; Thu, 22 Sep
 2022 22:18:26 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::17f5:70e:721f:df7e%4]) with mapi id 15.20.5676.007; Thu, 22 Sep 2022
 22:18:26 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sean Christopherson <seanjc@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] x86/hyperv: Move VMCB enlightenment definitions to
 hyperv-tlfs.h
Thread-Topic: [PATCH 1/4] x86/hyperv: Move VMCB enlightenment definitions to
 hyperv-tlfs.h
Thread-Index: AQHYzfcFS7KKXV9VWkGP+Jw6clQHxa3sBRhw
Date:   Thu, 22 Sep 2022 22:18:26 +0000
Message-ID: <BYAPR21MB1688D04068DBA520366DA205D74E9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20220921201607.3156750-1-seanjc@google.com>
 <20220921201607.3156750-2-seanjc@google.com>
In-Reply-To: <20220921201607.3156750-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=850cbeca-dbc5-4a4b-a8b1-58328c09455d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-22T22:13:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM6PR21MB1356:EE_
x-ms-office365-filtering-correlation-id: 281da924-cb8f-4d8f-19e9-08da9ce85ec8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EoYHN10R+YC4v8XanvNw/5A97XYmPQxd8ZaKFyGUZX9R7EL7G8Q7SQCzgn7QR8Uu0UJD4vx7ohh2CEY01W9L7ZUPp2XrzCOag7+hWil+7uwFm87BITtvknQrI/6+D+/ZSaA0Nnr/oHt2ZjSy+UjWPUggoyR0A7PNW0d8VqNmuLHE+C8aG4b2JQV7/eTj+2Bq7ljLxhOhH6/wiDNycUsUrJNFsHfprILnBosVMhiAJuK1AcnrNURRE1Yl1lqtwgDKWxuHIEtjpo0kkz+upQ2wFVpkzEqR0up1XygNzFNB2GPX6PEEPG1eo7qbDGTuaU5f/ny24zCkVXfB1AswsvQ35ou00Lammo7pVfit4mEF4dLJphEv7envbD6xEtMWjj/C1f6N7NaCmFVWvrrGUYzjfn5yTYaV/qGkn+3Vxk1mZbyFzj+ZlF1hycw7gYslwgF8p9BvVjLJtuZUPdfvR8GB5PDBSVgRAf6fhzK2Kh7NB0cy6LsXojfJ2gwNct0NMuCBhu2fsOIXJrr8KiJqsgGvyYi2xv8OhViDqjurEMGrWAvDqd8e2tTRdVZOQFHnA+DZHfpc8Q3wV9WPak8XfR7k4xOEWY1r5fTM0FV4EM2uPphS04De8Rbb9uGDLevuboIb8lp9SAOz9xSBo8IcfnbBhcFkP5won5tAac5pOXAwwUNuRDiy+QrOQqJqC2YgJrrY4JAPBkJ6mknts+l0njpPJNpdhhrQMecjgZtzRvJt4bqGPNUwx6A3P963A78m5e52Hy1cn9AYDGGGWtY0wkjQMqy0lzFkRKl1csT2cuwp/2ADkoTv+GZqL6XeXLBQfjR+NZOfXmT6U1Z6hWcH3ngdQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199015)(110136005)(316002)(54906003)(66946007)(10290500003)(66556008)(76116006)(966005)(478600001)(71200400001)(38100700002)(5660300002)(41300700001)(186003)(26005)(8936002)(82960400001)(8990500004)(2906002)(52536014)(7696005)(8676002)(6506007)(82950400001)(9686003)(4326008)(33656002)(66446008)(83380400001)(66476007)(122000001)(55016003)(64756008)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rJpeChYUKoMIF0VxnkPBGvvT0wtSI3f5NwsW0js3daR4pt1a3L1/IGeeyhN4?=
 =?us-ascii?Q?Zd7+s+1CxHVqKXRUoANgTMc+iZEQ0rUkl2FsMyX6HXBp2e43GuehQew9LWJc?=
 =?us-ascii?Q?z6xgMY9UdQM8+DO7YPOviZHXTY8/fbtpHDdFBgbNs+/SmlY5XqR71+pVhjR2?=
 =?us-ascii?Q?iQV4hooqqZZCjFRq2E8cd2ULHqRRCvMf08RxFx+7WrWcC07jmeFEBMPvgcvI?=
 =?us-ascii?Q?SVFxbK4rvNw6IzUQ0Oax45WOFTy5aqY0Ro4xQVuHRAQWfgTdeWieeTE4RuHM?=
 =?us-ascii?Q?k7a/k6lbe8tWsmStOoGrSTXTbRg8QGo9+Fw97d+lIBD7AZlpuv/g/uI7pkS1?=
 =?us-ascii?Q?cwJgndoLCEJq14aXWHIVAcJoEhb9HnSFHYoq9mogkWZDgPUnf8MgpX1OglEF?=
 =?us-ascii?Q?L/MI7C/7Q116dI99a/f1xyxrhlkwUO3xim+ulWH0cVy3PozH1U1LDXtwmrJ/?=
 =?us-ascii?Q?swC6vcOTOSZUbD+05zV3fCWHM0ipGjagCV38p+x/9ak4KT906+6TFerNNTza?=
 =?us-ascii?Q?5O/FftBfIFXKdte+8Di/iLetKhVKFRrIVWr3uD4SNLaelrp3LjL5LapJ41be?=
 =?us-ascii?Q?ZR/B55eK7VPvqISsyf2Ao32O0FuS2NK4QE4IOS5qmcSzVGo6ffP8TSfirw+I?=
 =?us-ascii?Q?FmtTLsXmXJPheLtNvrVZkK0Grl448MVhwKfBzqaiSB3XCbrDiwzEYn56kT0u?=
 =?us-ascii?Q?mvd4pIZd8WokfcBzHsB3nGWs+SB06HV/XryMYsesfUJVgJW9z2u543fs6pC+?=
 =?us-ascii?Q?u7wrttBJE1r3hPimjl2v50TTMs8tIts/qof3vn6PShlXKcUodpJVwBcJqejC?=
 =?us-ascii?Q?tqqPsRz9KdfsLNJrNprG7TByzSpG7USceAEx8D5AjVLTx2wosmhST5zxZjUR?=
 =?us-ascii?Q?ShXS7GxyhCrUfVmUy/bm7GyiG/mKMU26VTb+A6zWdjyaXeiCe1pxOp3QHmoK?=
 =?us-ascii?Q?Qf60jg57oVGJMJZNyTQ/YwN/85CeoZJ8E+mRKEfNBEGGXjnXTOa2TRHPrcDg?=
 =?us-ascii?Q?s7SQfEIrrjbzdKyqTnulElqT9ypad/Obpf3qEPqvnNu+MgftMRQ1p1JjqFWA?=
 =?us-ascii?Q?vyMpQySiVxt6KMfuvQmTqTMY0bYMyEnJQKiaZ7lEeHqpfNx33KjTy08H+rAo?=
 =?us-ascii?Q?mjJwIX/tuli7iUm49Be+IdbkkOhFRRCXl89VTtyPxBJWXKFxv1Fmg+pWMM8P?=
 =?us-ascii?Q?4//FlQLstLyDACZ240BCW+pPEVgsHf1381I+BXUj7M+4Nqsd5NlQ0zO7fu07?=
 =?us-ascii?Q?5c9x+nPpHhVCjVeTAvjmf8kcProraG9ytxUvQDlMnHSsripgwVYG02fj2ySH?=
 =?us-ascii?Q?XvUr9timi4EU5Vg5rSZ88xz4ur8WJ6hJZm9IUdAcGpWt/ADuhAABaB3ot+CT?=
 =?us-ascii?Q?rk5V4lJrFphW+N5dyOH/yt+yHq4NA0W6hl5vf6KPGWHNKa/d4gqOJrvcVfqH?=
 =?us-ascii?Q?qy4hksXE1DRSi78QpBZw4b6L+V4L+GqMImDRrqcw3sgPrYkEi0tIG+ckdlbm?=
 =?us-ascii?Q?D4gkSVsJpZV4UrgUwMkK+WwK7XTZrgNG53GJeuQgtV4W7B80aKlpi8OUiP/Y?=
 =?us-ascii?Q?jkz4SLqoy8TlHUZaIICTJPvzD2gOvmO8EVH/cN1W++OQNWvMCR6NcPBEGSj6?=
 =?us-ascii?Q?MQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281da924-cb8f-4d8f-19e9-08da9ce85ec8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 22:18:26.2551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PaeID98yQOAaomdg+/s5DSnztvb1Q4bjb3V8MtFQv0TSCEvCmHo6uYO55mKpoP+apSLzvGbfbT0Ne55mXJ/92WzMbG/0nD9cQCIOHXRTE88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1356
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com> Sent: Wednesday, September 21=
, 2022 1:16 PM
>=20
> Move Hyper-V's VMCB enlightenment definitions to the TLFS header; the
> definitions come directly from the TLFS[*], not from KVM.
>=20
> No functional change intended.
>=20
> [*] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/t=
lfs/datatypes/hv_svm_enlightened_vmcb_fields>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 22 +++++++++++++++++++
>  arch/x86/kvm/svm/hyperv.h          | 35 ------------------------------
>  arch/x86/kvm/svm/svm_onhyperv.h    |  3 ++-
>  3 files changed, 24 insertions(+), 36 deletions(-)
>  delete mode 100644 arch/x86/kvm/svm/hyperv.h
>=20
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hy=
perv-tlfs.h
> index 0a9407dc0859..4c4f81daf5a2 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -584,6 +584,28 @@ struct hv_enlightened_vmcs {
>=20
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL			0xFFFF
>=20
> +/*
> + * Hyper-V uses the software reserved 32 bytes in VMCB control area to e=
xpose
> + * SVM enlightenments to guests.
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
> +/*
> + * Hyper-V uses the software reserved clean bit in VMCB.
> + */
> +#define VMCB_HV_NESTED_ENLIGHTENMENTS		31

Is it feasible to change this identifier so it starts with HV_ like
everything else in this source code file, such as
HV_VMCB_NESTED_ENLIGHTENMENTS?  It doesn't look like it is
used in very many places. =20

> +
>  struct hv_partition_assist_pg {
>  	u32 tlb_lock_count;
>  };
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> deleted file mode 100644
> index 7d6d97968fb9..000000000000
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * Common Hyper-V on KVM and KVM on Hyper-V definitions (SVM).
> - */
> -
> -#ifndef __ARCH_X86_KVM_SVM_HYPERV_H__
> -#define __ARCH_X86_KVM_SVM_HYPERV_H__
> -
> -#include <asm/mshyperv.h>
> -
> -#include "../hyperv.h"
> -
> -/*
> - * Hyper-V uses the software reserved 32 bytes in VMCB
> - * control area to expose SVM enlightenments to guests.
> - */
> -struct hv_enlightenments {
> -	struct __packed hv_enlightenments_control {
> -		u32 nested_flush_hypercall:1;
> -		u32 msr_bitmap:1;
> -		u32 enlightened_npt_tlb: 1;
> -		u32 reserved:29;
> -	} __packed hv_enlightenments_control;
> -	u32 hv_vp_id;
> -	u64 hv_vm_id;
> -	u64 partition_assist_page;
> -	u64 reserved;
> -} __packed;
> -
> -/*
> - * Hyper-V uses the software reserved clean bit in VMCB
> - */
> -#define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
> -
> -#endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h
> b/arch/x86/kvm/svm/svm_onhyperv.h
> index e2fc59380465..8d02654ad6f8 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -8,8 +8,9 @@
>=20
>  #if IS_ENABLED(CONFIG_HYPERV)
>=20
> +#include <asm/mshyperv.h>
> +
>  #include "kvm_onhyperv.h"
> -#include "svm/hyperv.h"
>=20
>  static struct kvm_x86_ops svm_x86_ops;
>=20
> --
> 2.37.3.968.ga6b4b080e4-goog

