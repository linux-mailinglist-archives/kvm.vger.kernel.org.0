Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA12A8373
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 17:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgKEQYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 11:24:51 -0500
Received: from mail-dm6nam11on2079.outbound.protection.outlook.com ([40.107.223.79]:3363
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725998AbgKEQYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 11:24:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxUl7VO1GOIk8iTyoHnVoF+Oz1aHHYE/LG8phagyfYVyh/xCu2Tf+iHTxgdtlRFPu8Vm6lFQDx1865bMY4z4FIPNWNZWNRDyLyIJmlrf16kZGMjv1AvKpHyR24hY2PjnzlAWsHnO85129Y7fX+wUlqPCOMl7i8VbyMROdQb1t0ojgiQqgbiunFvnfhrdM+22lD2y/WPdWfPrIRP+2wcPoX/+yAZLIuZGkzGrgNhdLiDsLTsRu+R51/BoF0cA3RWtisHHtzO9OxyW3nWIX5DLY15IeM//K1sln0rgkJgzzHI33ibZvk7Qesugrhs9X2i7hU+qEqs6tys84VDNO33eig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJc7gEbm2tcUmlViMIvZJbrv0LCzo1HFLCAJJofeYpU=;
 b=JLNvjH8hu36aNlWaMPpxKDjnkTXAJc+eBiHh3yjyjOulEZXEfij/ujbOXySdltkOehQn/x1naSVuBRokgMSuDqD1VcARkMfnv8KtW+tvM37Dfj9yuCBFBATHFZyvjbk8MhaxKK74MiMXJvMYwmYpR/oidmPr75sde4B7HBD++FDYkbvvxvip57zhhubqpZlfINngsqgdmKMrRicRF1JLKg32d8CNh7m9xmMI+qK5ilaeMjmC34rXmqVJ+pDyBZcgX1R0K2yUgUY84ZRvixhf+pJjfSfnnDb+e3M3JtiDMm/xRTxkbtETMwcCBKs/f6wfJirm+wS8gM579ZuplR/mOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJc7gEbm2tcUmlViMIvZJbrv0LCzo1HFLCAJJofeYpU=;
 b=jzl9pRPw9TSIsTzvKLQtH1kHomu4vbDJ1TaGI3fDi63BQbvLI9Bdky44blvIvbIjDf+zJ9Ud/rVoHMzPAlSioFrrDIPNDK+0XjyFKMilR3CwxikQY9MVTgeR/tsB4qjIaLVZEvbe1jGHStJMJL1gEqrts/5YwA+ZQuzbf92nkpU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4037.namprd12.prod.outlook.com (2603:10b6:610:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 5 Nov
 2020 16:24:47 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300%5]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 16:24:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200907131613.12703-2-joro@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org> <20200907131613.12703-2-joro@8bytes.org>
Subject: Re: [PATCH v7 01/72] KVM: SVM: nested: Don't allocate VMCB structures on stack
From:   Michael Roth <michael.roth@amd.com>
Cc:     Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Mike Stunes <mstunes@vmware.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Cfir Cohen <cfir@google.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        virtualization@lists.linux-foundation.org,
        Martin Radev <martin.b.radev@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, hpa@zytor.com,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
To:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Date:   Thu, 05 Nov 2020 10:24:37 -0600
Message-ID: <160459347763.31546.3911053208379939674@vm0>
User-Agent: alot/0.9
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: DM5PR2201CA0013.namprd22.prod.outlook.com
 (2603:10b6:4:14::23) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.11) by DM5PR2201CA0013.namprd22.prod.outlook.com (2603:10b6:4:14::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 16:24:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 83695f21-09dc-4325-ea34-08d881a74fbe
X-MS-TrafficTypeDiagnostic: CH2PR12MB4037:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4037CBC47826D8C4547C9BA895EE0@CH2PR12MB4037.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qw7SEMUz+sMPZ8RWo4Hk+fAngsfgCtIcXfeYIgLpG33POoNpCKIGU6aAGpdJks5bBLpZAFCy+iSihq2i/LkTSil8zeGniEhHuhDlzuPHPD6czGOjSbJOfnfPzmyZ3v9Li0PES0NWqCyh9Ij447yDe52ESrBD1g63UB8mSztMYZpiAgK1o8hB+eHRBH2xRhwaPvdM1lcpj1dB9ql7yLu3AF/7BIwVgbEnHqA4aaWzlTbPxcaKB04WubRcqh70zzLM2dWtBcBbg3siMvig/e64cslTPCWwSp1KuylrhZPDgcaFtkU20eWl9a9hCnXXYg4TCQC0CERv5NOBbxxX2XjGS4l6wrZduaFI3/4Qo4axBEk+eZnCDS0aBiVeOrdZZZoSyWicaKi9mzLuZiWfXp0r6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(8936002)(6496006)(966005)(45080400002)(83380400001)(52116002)(316002)(9686003)(2906002)(478600001)(44832011)(86362001)(7416002)(186003)(6666004)(5660300002)(54906003)(26005)(6486002)(66476007)(66946007)(4326008)(66556008)(8676002)(956004)(33716001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B6Qaedp9pGnjh0PpGQvZnNXKxJAJpzcUNGf2dRpsqiCiEhcxPKdoLLDqtXYK3WgcLfBC2J52HlA51g+th7iwIb0uY2PNn/k/Qv5ubqA3J7m1Yg4ypEaLjuKnyVbTdJRS5H+wnghEep9jo7CSXm3cFaFQEwiNX15p9O0wFBP1XIaBsydCl4E+dEQ9AFmR+AfPoOicZCtFruxvUCdtLocjTcDJcUk3FzoslJf9SABWf3+IvzOee2GPpp9meAQvEdtBB1VTY3/K7zlH5V+RrsDKTe40bVHHUvPDq5e+pqlHX6dgPCvqs7mbct3vYZwUORZywBbMe5loLMs1FnV+AuYIFdr/ijd1dyIrWcOUXWU7Eoed6HuUzitxI4mDss0BHgXYrICXkYoe6v3Uw2y8+tECMpqT+12ONxgFlDrb8JTzlxXLDu5/ozOtKQzQbeHNOb41YXqwVJByq/1wwSgNwhbRQdoC5xwwYEEt7O2cDXQNVMv10KRYngjG05dVehtVswGLBo1NyBv5+fxdgfkuW96Sl8ImUpU2M0vZ3SNgtft32iZhQBpq3eqnQCW/46m8MrFVWPA4ZfG7BoP+mAK9XHHL3r3Z5I3Nklz/FFMXo4fYya8tb5m/mD2S4xmBi47o5hM8VVSPRf/tmWxUmEh8h9SE+g==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83695f21-09dc-4325-ea34-08d881a74fbe
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 16:24:47.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsY384IZNGBR4tSkS/Ni17iFztgeQZKFfWMWNPFUq9u1FQJxA8OmQ6vn02tUkpW7FqFat5UV+GgkLplEcq8AxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4037
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Joerg Roedel (2020-09-07 08:15:02)
> From: Joerg Roedel <jroedel@suse.de>
>=20
> Do not allocate a vmcb_control_area and a vmcb_save_area on the stack,
> as these structures will become larger with future extenstions of
> SVM and thus the svm_set_nested_state() function will become a too large
> stack frame.
>=20
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kvm/svm/nested.c | 47 +++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 14 deletions(-)
>=20
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fb68467e6049..28036629abf8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1060,10 +1060,14 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
>         struct vmcb *hsave =3D svm->nested.hsave;
>         struct vmcb __user *user_vmcb =3D (struct vmcb __user *)
>                 &user_kvm_nested_state->data.svm[0];
> -       struct vmcb_control_area ctl;
> -       struct vmcb_save_area save;
> +       struct vmcb_control_area *ctl;
> +       struct vmcb_save_area *save;
> +       int ret;
>         u32 cr0;
>=20
> +       BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct vmc=
b_save_area) >
> +                    KVM_STATE_NESTED_SVM_VMCB_SIZE);
> +
>         if (kvm_state->format !=3D KVM_STATE_NESTED_FORMAT_SVM)
>                 return -EINVAL;
>=20
> @@ -1095,13 +1099,22 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
>                 return -EINVAL;
>         if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_V=
MCB_SIZE)
>                 return -EINVAL;
> -       if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
> -               return -EFAULT;
> -       if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
> -               return -EFAULT;
>=20
> -       if (!nested_vmcb_check_controls(&ctl))
> -               return -EINVAL;
> +       ret  =3D -ENOMEM;
> +       ctl  =3D kzalloc(sizeof(*ctl),  GFP_KERNEL);
> +       save =3D kzalloc(sizeof(*save), GFP_KERNEL);
> +       if (!ctl || !save)
> +               goto out_free;
> +
> +       ret =3D -EFAULT;
> +       if (copy_from_user(ctl, &user_vmcb->control, sizeof(*ctl)))
> +               goto out_free;
> +       if (copy_from_user(save, &user_vmcb->save, sizeof(*save)))
> +               goto out_free;
> +
> +       ret =3D -EINVAL;
> +       if (!nested_vmcb_check_controls(ctl))
> +               goto out_free;
>=20
>         /*
>          * Processor state contains L2 state.  Check that it is
> @@ -1109,15 +1122,15 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
>          */
>         cr0 =3D kvm_read_cr0(vcpu);
>          if (((cr0 & X86_CR0_CD) =3D=3D 0) && (cr0 & X86_CR0_NW))
> -                return -EINVAL;
> +               goto out_free;
>=20
>         /*
>          * Validate host state saved from before VMRUN (see
>          * nested_svm_check_permissions).
>          * TODO: validate reserved bits for all saved state.
>          */
> -       if (!(save.cr0 & X86_CR0_PG))
> -               return -EINVAL;
> +       if (!(save->cr0 & X86_CR0_PG))
> +               goto out_free;
>=20
>         /*
>          * All checks done, we can enter guest mode.  L1 control fields
> @@ -1126,15 +1139,21 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
>          * contains saved L1 state.
>          */
>         copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> -       hsave->save =3D save;
> +       hsave->save =3D *save;
>=20
>         svm->nested.vmcb =3D kvm_state->hdr.svm.vmcb_pa;
> -       load_nested_vmcb_control(svm, &ctl);
> +       load_nested_vmcb_control(svm, ctl);
>         nested_prepare_vmcb_control(svm);
>=20
>  out_set_gif:
>         svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET))=
;
> -       return 0;
> +
> +       ret =3D 0;
> +out_free:
> +       kfree(save);
> +       kfree(ctl);

This change seems to trigger a crash via smm-test.c (and state-test.c) KVM
selftest when we call vcpu_load_state->KVM_SET_NESTED_STATE. I think what's
happening is we are hitting the 'goto out_set_gif;' and then attempting to
free save and ctl, which are still uninitialized at that point:=20

[ 1999.801176] APIC base relocation is unsupported by KVM
[ 1999.828562] BUG: unable to handle page fault for address:
fffff12379020288
[ 1999.841968] #PF: supervisor read access in kernel mode
[ 1999.847693] #PF: error_code(0x0000) - not-present page
[ 1999.853426] PGD 0 P4D 0
[ 1999.856252] Oops: 0000 [#1] SMP NOPTI
[ 1999.861366] CPU: 112 PID: 10162 Comm: smm_test Tainted: G
E     5.9.1-amdsos-build31t0+ #1
[ 1999.871655] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS
RXM0092B 10/27/2020
[ 1999.880694] RIP: 0010:kfree+0x5b/0x3c0
[ 1999.884876] Code: 80 49 01 dc 0f 82 70 03 00 00 48 c7 c0 00 00 00 80
48 2b 05 97 4a 1c 01 49 01 c4 49 c1 ec 0c 49 c1 e4 06 4c 03 25 75 4a 1c
01 <49> 8b 44 24 08 48 8d 50 ff a8 01 4c 0f 45 e2 49 8b 54 24 08 48 8d
[ 1999.906674] RSP: 0018:ffffb7004d9d3cf8 EFLAGS: 00010282
[ 1999.912502] RAX: 0000723d80000000 RBX: 000000004080aebf RCX:
0000000002000000
[ 1999.920464] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000000004080aebf
[ 1999.929335] RBP: ffffb7004d9d3d28 R08: ffff8de1c2a43628 R09:
0000000000000000
[ 1999.937298] R10: 0000000000000000 R11: 0000000000000000 R12:
fffff12379020280
[ 1999.945258] R13: ffffffffc0f6626a R14: 0000000000000000 R15:
ffffb7004d9d3db0
[ 1999.953221] FS:  00007f231b4c1740(0000) GS:ffff8de20e800000(0000)
knlGS:0000000000000000
[ 1999.963255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1999.969667] CR2: fffff12379020288 CR3: 0000001faf5aa006 CR4:
0000000000770ee0
[ 1999.977627] PKRU: 55555554
[ 1999.980644] Call Trace:
[ 1999.983384]  svm_leave_nested+0xea/0x2f0 [kvm_amd]
[ 1999.988743]  kvm_arch_vcpu_ioctl+0x6fd/0x1260 [kvm]
[ 1999.995026]  ? avic_vcpu_load+0x20/0x130 [kvm_amd]
[ 2000.000372]  kvm_vcpu_kick+0x705/0xae0 [kvm]
[ 2000.005216]  __x64_sys_ioctl+0x91/0xc0
[ 2000.009470]  do_syscall_64+0x38/0x90
[ 2000.013461]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2000.019090] RIP: 0033:0x7f231b5db50b
[ 2000.024052] Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
[ 2000.045005] RSP: 002b:00007ffc01de6918 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[ 2000.053453] RAX: ffffffffffffffda RBX: 0000000002147880 RCX:
00007f231b5db50b
[ 2000.062375] RDX: 0000000002148c98 RSI: 000000004080aebf RDI:
0000000000000009
[ 2000.070335] RBP: 000000000214d0c0 R08: 00000000004103f8 R09:
0000000000000000
[ 2000.078296] R10: 0000000000000000 R11: 0000000000000246 R12:
00007ffc01de6960
[ 2000.087278] R13: 0000000000000002 R14: 00007f231b711000 R15:
0000000002147880
[ 2000.095244] Modules linked in: nls_iso8859_1(E) dm_multipath(E)
scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) intel_rapl_msr(E)
intel_rapl_common(E) amd64_edac_mod(E) kvm_amd(E) kvm(E) joydev(E)
input_leds(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E)
aesni_intel(E) crypto_simd(E) cryptd(E) glue_helper(E) hid_generic(E)
efi_pstore(E) rapl(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E)
usbhid(E) hid(E) ast(E) drm_vram_helper(E) drm_ttm_helper(E) ttm(E)
drm_kms_helper(E) cec(E) i2c_algo_bit(E) fb_sys_fops(E) syscopyarea(E)
sysfillrect(E) sysimgblt(E) wmi_bmof(E) e1000e(E) i2c_piix4(E) ccp(E)
wmi(E) mac_hid(E) sch_fq_codel(E) drm(E) ip_tables(E) x_tables(E)
autofs4(E)
[ 2000.164824] CR2: fffff12379020288
[ 2000.168522] ---[ end trace c5975ced3c660340 ]---

> +
> +       return ret;
>  }
>=20
>  struct kvm_x86_nested_ops svm_nested_ops =3D {
> --=20
> 2.28.0
>=20
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
