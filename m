Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAAB2A8544
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgKERqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:46:35 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:2338
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbgKERqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 12:46:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyuicWtNwAqycmlpNZs0R60UVLPEm9E5CsPaoN5QBzT4t0hlvfU4HB9wqCHuPfq96j2+RyzyAKP9G9rGZO8hA4/1cS135z8+sWZ0rXn+f/bjnydiX3s60wqASQLvFhD4eElgyjTmwYNLTGPIh60+6sSDN9m7uuOTr9NqgS1DRudguBv63zZFXGkXObJwkcfwUOMsRZ6Vnt874DFLAJw7yuLQnspHg13619MtNBVDi+dYS2NaeMWM8z1L8eDyEcQMXSAe+DZJd32Havdzx3Sd11NVZOEdYQh7YEJDUff4SSj8BraZ6qPN2CL/r7IbBqthpCOfeYXFbjZgH8bVMeSqaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgeFgxqq+wSK2CFhMOqCNbS/EQmzkCM6Bzu/b47qbFE=;
 b=RoQyL28MKj9PN8WP9/2nIhckrfzxL4OCrs1TWvbjkQXl3GVZqYng+WzdR85VJT2YXtolTtoP7KLL3V0wbV779wjxijodlU7T6wCnF1VPP/fEknKsX78SPmTrDcteQLZk4VB7ZgkU/C2FQlTs9Avp8e60xNUq6vs5lTIzNcbaZ4zhk3CXrunkjdT3uvfD2OFKjb1QICenOAbyprGR/KcAPLRophYYbdmCayQ2wJMZ/pLPuxUFV3Hq4nedNqSD0t5nwbu+kFF3Xkm8WjMn9Yv3zlxKypJszsnHNEpWiXiG/BelAPRpnbJlIub9984p4R7wVYQpUTY3ZH8GHUkPldmywQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgeFgxqq+wSK2CFhMOqCNbS/EQmzkCM6Bzu/b47qbFE=;
 b=hxJTTTUA8vrYQ2rKAgQb813FQfaPrliYsII18XtdkeBGRgiG0SMWTHOfREnJcl1FpnRK6El7suXu7QzQfKrixZ3hcNxcskV9Lr2yqLwg3fNRIrpR0zwYwpsIxHM7aOC4gw9JRG9aQvHcdWMXRMWSiJdFG+8eqX/Ve+T0sRvN0kQ=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 5 Nov
 2020 17:46:31 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f428:769b:3e9:8300%5]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 17:46:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <160459347763.31546.3911053208379939674@vm0>
References: <20200907131613.12703-1-joro@8bytes.org> <20200907131613.12703-2-joro@8bytes.org> <160459347763.31546.3911053208379939674@vm0>
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
Date:   Thu, 05 Nov 2020 11:46:22 -0600
Message-ID: <160459838221.32459.11606589589391494084@vm0>
User-Agent: alot/0.9
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: DM6PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:5:134::43) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.11) by DM6PR13CA0066.namprd13.prod.outlook.com (2603:10b6:5:134::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Thu, 5 Nov 2020 17:46:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de89faf0-76d6-44d2-1a20-08d881b2ba37
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB41348D6DC83F9BCA6D92921695EE0@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5uMbG+FPKzx5I7OVtHx7khZYpk/TO4I+7zGEu/naaPjSlkulJDh2jPHrS/RE62H8CGQD1JrjX9f2kO8gvSfi6F7FbHQk1zl+X+6BsLOT+yi3Au5axkv7unSVXy8zc1C/PYIt/iRoq1zxubm59kvQy4udwxR8tP6CoJA9LyKnsxSsWg43ISUMp+0/X+NTfiVVt5GXQD6uv8u3CE+BcTTIUnyYF0I7TPxRV1BEblc532+TQdt1au3op6PgtRezKTQOUOYtTVr+E/e+erI+eKn4LE7tkYyIZqi3m0IiVg33O9+jnQcQCH72rOVohZ4DIqN4wTmnjTVcCovyJK4YyWM8E639ZZW3IO6yUpMxZiz6Lxsl08y1H2R/yJALQZljyWDrvsvUKhg/48+OqLS3tAZ2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(316002)(54906003)(8936002)(7416002)(9686003)(2906002)(16526019)(186003)(44832011)(26005)(6496006)(52116002)(45080400002)(956004)(86362001)(66946007)(4326008)(66556008)(66476007)(5660300002)(8676002)(478600001)(6486002)(6666004)(966005)(33716001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I0ZluAaTj+X7+/KhWqZBY2mjnZfXrfunxCKi947PtLMbEaj5o6dp81B6lpx/0gY1A0mWn7EWFpl42S+PIIEPI/9hjNsu0+5RDqe0luTmhmyKSS+1yl9wR4ELtrFiHjCEGpusGnLZ3qtVRjwoxFgRfYrw31qkbGKwdVauQ//844D506lxVVe+9ou8ow+MYheel5R8/HW4VWMV1hT51tr/Uk3JqVFZ1oKzIj0kMWHLRaSWdJKRG2r+E1dGxwANr4fZtJNIknc0F5o4cdVE7YmZJ0rbEM8j1lGJ+RoSE06l3mo4mwffbvXkItGv9YF49PTitKYzp8pZtZ5FxLwzqF4+skRsLXchbszX0n8EQGfkd6jf22O1ZRltUYMn+pX7IMyCAP/DvFedqZJ8Z5pASHnJ790zA2wZRDu5/8xykCLf5eWHBFfSdDQeMjkHuUU8K9UrdQGSuthMMl3zg9EFquBC9M7G3b3yEBYbv5IEvQIG5CnGTsEoRraevDHG/valoPzXRfCHdUXbyG9/UfC9CEMQlwInnnLkuCp38PhTY/JXMbsy5UVL778xFhDQZ2LEjpOD5twxhTZBQU5P67dAzUAMGm5epCAGmfrFnLvaOFEVdGib6uv//HReQOY8r3YTD8onNw5Yxh/II6SWPkHauZmaqA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de89faf0-76d6-44d2-1a20-08d881b2ba37
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 17:46:30.9623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HssWLMo6RC0c9HrC8n5ly9JEqTJu3929zDwJhg93zZZDAzwWj4EHdhRNWE+BxSG2+cKr9Dg8FTxlIqnV/9nzkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Michael Roth (2020-11-05 10:24:37)
> Quoting Joerg Roedel (2020-09-07 08:15:02)
> > From: Joerg Roedel <jroedel@suse.de>
> >=20
> > Do not allocate a vmcb_control_area and a vmcb_save_area on the stack,
> > as these structures will become larger with future extenstions of
> > SVM and thus the svm_set_nested_state() function will become a too larg=
e
> > stack frame.
> >=20
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > ---
> >  arch/x86/kvm/svm/nested.c | 47 +++++++++++++++++++++++++++------------
> >  1 file changed, 33 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index fb68467e6049..28036629abf8 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1060,10 +1060,14 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> >         struct vmcb *hsave =3D svm->nested.hsave;
> >         struct vmcb __user *user_vmcb =3D (struct vmcb __user *)
> >                 &user_kvm_nested_state->data.svm[0];
> > -       struct vmcb_control_area ctl;
> > -       struct vmcb_save_area save;
> > +       struct vmcb_control_area *ctl;
> > +       struct vmcb_save_area *save;
> > +       int ret;
> >         u32 cr0;
> >=20
> > +       BUILD_BUG_ON(sizeof(struct vmcb_control_area) + sizeof(struct v=
mcb_save_area) >
> > +                    KVM_STATE_NESTED_SVM_VMCB_SIZE);
> > +
> >         if (kvm_state->format !=3D KVM_STATE_NESTED_FORMAT_SVM)
> >                 return -EINVAL;
> >=20
> > @@ -1095,13 +1099,22 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> >                 return -EINVAL;
> >         if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM=
_VMCB_SIZE)
> >                 return -EINVAL;
> > -       if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
> > -               return -EFAULT;
> > -       if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
> > -               return -EFAULT;
> >=20
> > -       if (!nested_vmcb_check_controls(&ctl))
> > -               return -EINVAL;
> > +       ret  =3D -ENOMEM;
> > +       ctl  =3D kzalloc(sizeof(*ctl),  GFP_KERNEL);
> > +       save =3D kzalloc(sizeof(*save), GFP_KERNEL);
> > +       if (!ctl || !save)
> > +               goto out_free;
> > +
> > +       ret =3D -EFAULT;
> > +       if (copy_from_user(ctl, &user_vmcb->control, sizeof(*ctl)))
> > +               goto out_free;
> > +       if (copy_from_user(save, &user_vmcb->save, sizeof(*save)))
> > +               goto out_free;
> > +
> > +       ret =3D -EINVAL;
> > +       if (!nested_vmcb_check_controls(ctl))
> > +               goto out_free;
> >=20
> >         /*
> >          * Processor state contains L2 state.  Check that it is
> > @@ -1109,15 +1122,15 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> >          */
> >         cr0 =3D kvm_read_cr0(vcpu);
> >          if (((cr0 & X86_CR0_CD) =3D=3D 0) && (cr0 & X86_CR0_NW))
> > -                return -EINVAL;
> > +               goto out_free;
> >=20
> >         /*
> >          * Validate host state saved from before VMRUN (see
> >          * nested_svm_check_permissions).
> >          * TODO: validate reserved bits for all saved state.
> >          */
> > -       if (!(save.cr0 & X86_CR0_PG))
> > -               return -EINVAL;
> > +       if (!(save->cr0 & X86_CR0_PG))
> > +               goto out_free;
> >=20
> >         /*
> >          * All checks done, we can enter guest mode.  L1 control fields
> > @@ -1126,15 +1139,21 @@ static int svm_set_nested_state(struct kvm_vcpu=
 *vcpu,
> >          * contains saved L1 state.
> >          */
> >         copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> > -       hsave->save =3D save;
> > +       hsave->save =3D *save;
> >=20
> >         svm->nested.vmcb =3D kvm_state->hdr.svm.vmcb_pa;
> > -       load_nested_vmcb_control(svm, &ctl);
> > +       load_nested_vmcb_control(svm, ctl);
> >         nested_prepare_vmcb_control(svm);
> >=20
> >  out_set_gif:
> >         svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET=
));
> > -       return 0;
> > +
> > +       ret =3D 0;
> > +out_free:
> > +       kfree(save);
> > +       kfree(ctl);
>=20
> This change seems to trigger a crash via smm-test.c (and state-test.c) KV=
M
> selftest when we call vcpu_load_state->KVM_SET_NESTED_STATE. I think what=
's
> happening is we are hitting the 'goto out_set_gif;' and then attempting t=
o
> free save and ctl, which are still uninitialized at that point:=20

Sorry, looks like this one was already fixed upstream by

  d5cd6f34014592a232ce79dc25e295778bd43c22

Please ignore.

>=20
> [ 1999.801176] APIC base relocation is unsupported by KVM
> [ 1999.828562] BUG: unable to handle page fault for address:
> fffff12379020288
> [ 1999.841968] #PF: supervisor read access in kernel mode
> [ 1999.847693] #PF: error_code(0x0000) - not-present page
> [ 1999.853426] PGD 0 P4D 0
> [ 1999.856252] Oops: 0000 [#1] SMP NOPTI
> [ 1999.861366] CPU: 112 PID: 10162 Comm: smm_test Tainted: G
> E     5.9.1-amdsos-build31t0+ #1
> [ 1999.871655] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS
> RXM0092B 10/27/2020
> [ 1999.880694] RIP: 0010:kfree+0x5b/0x3c0
> [ 1999.884876] Code: 80 49 01 dc 0f 82 70 03 00 00 48 c7 c0 00 00 00 80
> 48 2b 05 97 4a 1c 01 49 01 c4 49 c1 ec 0c 49 c1 e4 06 4c 03 25 75 4a 1c
> 01 <49> 8b 44 24 08 48 8d 50 ff a8 01 4c 0f 45 e2 49 8b 54 24 08 48 8d
> [ 1999.906674] RSP: 0018:ffffb7004d9d3cf8 EFLAGS: 00010282
> [ 1999.912502] RAX: 0000723d80000000 RBX: 000000004080aebf RCX:
> 0000000002000000
> [ 1999.920464] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 000000004080aebf
> [ 1999.929335] RBP: ffffb7004d9d3d28 R08: ffff8de1c2a43628 R09:
> 0000000000000000
> [ 1999.937298] R10: 0000000000000000 R11: 0000000000000000 R12:
> fffff12379020280
> [ 1999.945258] R13: ffffffffc0f6626a R14: 0000000000000000 R15:
> ffffb7004d9d3db0
> [ 1999.953221] FS:  00007f231b4c1740(0000) GS:ffff8de20e800000(0000)
> knlGS:0000000000000000
> [ 1999.963255] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1999.969667] CR2: fffff12379020288 CR3: 0000001faf5aa006 CR4:
> 0000000000770ee0
> [ 1999.977627] PKRU: 55555554
> [ 1999.980644] Call Trace:
> [ 1999.983384]  svm_leave_nested+0xea/0x2f0 [kvm_amd]
> [ 1999.988743]  kvm_arch_vcpu_ioctl+0x6fd/0x1260 [kvm]
> [ 1999.995026]  ? avic_vcpu_load+0x20/0x130 [kvm_amd]
> [ 2000.000372]  kvm_vcpu_kick+0x705/0xae0 [kvm]
> [ 2000.005216]  __x64_sys_ioctl+0x91/0xc0
> [ 2000.009470]  do_syscall_64+0x38/0x90
> [ 2000.013461]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 2000.019090] RIP: 0033:0x7f231b5db50b
> [ 2000.024052] Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00
> 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f
> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
> [ 2000.045005] RSP: 002b:00007ffc01de6918 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [ 2000.053453] RAX: ffffffffffffffda RBX: 0000000002147880 RCX:
> 00007f231b5db50b
> [ 2000.062375] RDX: 0000000002148c98 RSI: 000000004080aebf RDI:
> 0000000000000009
> [ 2000.070335] RBP: 000000000214d0c0 R08: 00000000004103f8 R09:
> 0000000000000000
> [ 2000.078296] R10: 0000000000000000 R11: 0000000000000246 R12:
> 00007ffc01de6960
> [ 2000.087278] R13: 0000000000000002 R14: 00007f231b711000 R15:
> 0000000002147880
> [ 2000.095244] Modules linked in: nls_iso8859_1(E) dm_multipath(E)
> scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) intel_rapl_msr(E)
> intel_rapl_common(E) amd64_edac_mod(E) kvm_amd(E) kvm(E) joydev(E)
> input_leds(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E)
> aesni_intel(E) crypto_simd(E) cryptd(E) glue_helper(E) hid_generic(E)
> efi_pstore(E) rapl(E) ipmi_si(E) ipmi_devintf(E) ipmi_msghandler(E)
> usbhid(E) hid(E) ast(E) drm_vram_helper(E) drm_ttm_helper(E) ttm(E)
> drm_kms_helper(E) cec(E) i2c_algo_bit(E) fb_sys_fops(E) syscopyarea(E)
> sysfillrect(E) sysimgblt(E) wmi_bmof(E) e1000e(E) i2c_piix4(E) ccp(E)
> wmi(E) mac_hid(E) sch_fq_codel(E) drm(E) ip_tables(E) x_tables(E)
> autofs4(E)
> [ 2000.164824] CR2: fffff12379020288
> [ 2000.168522] ---[ end trace c5975ced3c660340 ]---
>=20
> > +
> > +       return ret;
> >  }
> >=20
> >  struct kvm_x86_nested_ops svm_nested_ops =3D {
> > --=20
> > 2.28.0
> >=20
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
