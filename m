Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F0474CF5
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 22:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhLNVHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 16:07:39 -0500
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:53000
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237749AbhLNVHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 16:07:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3IxS9mxghQRt8MwCMXpVUF6prm3iV0ExyYXTaOMWeGqdYvF2JThjIPtPMMPKDX8mFr37HhngfLKZ8KtQ7xcRfrKJG9DahinZqVq9j3+Qy35JAVm1XpiPKNVLHGlsdYL9G0TnVEDTeIyvlaJcGRwYfQ1vGnqTKTyeIZ/HoGox2BT8EHWeWKBJUMYCDUc6vgCE+VkjFLVGnqOEqmFJr20IWLeVi7IGDCspiI6KgiUTyizA4XCsip62agXlTsFvTTb91E0PByTCDsYQY7cGOcYn20JQisJNH6iR0f5wkTSIB5uxvLJnsCT2Ul3ldPBeCXq0Xf8j+Ycd29y7n8PJ74DLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcKRWPkKReWh03REwGTDAGnUPxsNVimZ7tdr5twEHLE=;
 b=YElKE3aK+xvcHRlhJcdTyKgEOW1HXBmrlhjPB9HED/7h1YHW17KTtVItlhPVA7OjvoakjbMrNcfeiAY953T8bcEjECp8sv3rbPtysrSYN4z4C3lOoyVPWaiovHswashfwo1j6rHYxAYFmgpuVUTihA5utOZ3obExV07vYfemkzr5bivNGHm8TwcvP5B4BjSOzTXUZ6eLFkmmmtL6RICRWl9hSAmUDRUevNYqCgc5NsUo1tqC1Mxy5c06GuNiDjuwpAoTj3j7pscSLgt7JZw1Sxor3MUTXlDwRiUxL+9EbP0cqdHPHxCh1cfrLpiKcxYOAjKejLvdfxy7+pbqVc5ktQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcKRWPkKReWh03REwGTDAGnUPxsNVimZ7tdr5twEHLE=;
 b=UqXak89wo6Ya7TuRcgHi/Qm+5R8yPa3f59rl17Be1WWiYPqqLZe42xe70w+Q9p/QIItnyJpxTouYLzKC1xQrArxzJACbUr+7TTFN71IlfMQdjf8aifTHqnsF6ZHhJZTUI5ajiYDTQRHPGTnqE5mJz5gIB9Q+hiBqEKLf1TrWd6eCB1WJ5afkC96xWm4zwvhO4/YcNh3tqmycSnDtzlqnXQ20iphsr+jsxa/+gGwsX7eDkAVsIHTP0M4yLpCktes/tfw7uNzlVqU0Dark6NXr/s23E37lXGlZ5xVk4iAow7GgaGeAFJn6Uj1oq8oAUb/1HWmgdyfpACRchZZ40G4o0A==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM5PR12MB1513.namprd12.prod.outlook.com (2603:10b6:4:d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Tue, 14 Dec 2021 21:07:36 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 21:07:36 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] KVM: x86: add kvm per-vCPU exits disable capability
Thread-Topic: [RFC PATCH] KVM: x86: add kvm per-vCPU exits disable capability
Thread-Index: AQHX8JtYjBglrMieUkS/P7QtoxwNoKwyV06AgAAdI3A=
Date:   Tue, 14 Dec 2021 21:07:36 +0000
Message-ID: <DM6PR12MB3500E1787271F74A4976143ECA759@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211214033227.264714-1-kechenl@nvidia.com>
 <Ybjoy5h9a8nKK9X4@google.com>
In-Reply-To: <Ybjoy5h9a8nKK9X4@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49583caf-6a06-408b-a0c3-08d9bf45c128
x-ms-traffictypediagnostic: DM5PR12MB1513:EE_
x-microsoft-antispam-prvs: <DM5PR12MB1513B44698DF1BC0BA426661CA759@DM5PR12MB1513.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SJqUow6bNVlOuvHjLW4dg1o9rXVUcDO9GyIgwsc06knwptQvnrsD2V6wmF16OJd9CtjWoPqCCAnDBt1sCT8/tHbUkav+1b69T9PdlkOqh0+/+TmqNOA7D/z+XDxjcncCSrrXjCBrt7DDmcYcQbhInIZwCZOackJdDX70YiTfXf17Uokwzmae5rWgzbnZl72C2b3qCUT7emKcfyMcL3fLLsy0ul4VBWq/RaxBdPx1AVX6O533VmuKoPxl2Lh/+jwJbEGcyTDFhivut9yotO5jZGhmK/1ETJvMmeLcQKsZFwVlXhCX70tTBhhsnoyU/AqUBf4IJ5QJ8SJPtQJeeJ4BrhQYcg5Fd5jck2q7P4iv1C1nLHCfuSBDOxw8fLbCTh6eJ+BJfFzE5IQWHfk0WV+MgwVk1+HqvVjtq/CIVyo8z6R6IeRCGdl8QIOWUHy+zo996XSi7wfsCJi8X5V9mbMNndLTlElqhrtoP0jen7syjKQGsccy4e8XssX1GOGzJzAZHYExI/hJXz3rlK0yi3rcue7lkSn7pSR6tFRv4wq5UyeUAnlztlkeP2eMqzfQgixvSUyNXJzCfzYsdoTttPDb0dzwGzc4hj9JhFjfQ3KXpWO3krvWlWCwpGmhlTDloyjN1BGLv6Qbk5BLOx/f0m+0rSFFQNxwzQ+PojmqLJoUzQKd2CEWZ9OELoJ5gY/zl2If6C305Bz1fTrdRw+Rmk+wXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66476007)(66946007)(71200400001)(8676002)(2906002)(53546011)(7696005)(38070700005)(86362001)(54906003)(8936002)(4326008)(33656002)(316002)(5660300002)(64756008)(66556008)(26005)(6916009)(38100700002)(9686003)(186003)(508600001)(83380400001)(52536014)(66446008)(6506007)(122000001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?436rD4pOq9rQ2bAoIpr1ZHkDyKlkZpLAC5c39jAxO3WUBcPr4qOnIOFjuhm3?=
 =?us-ascii?Q?2Y4H3v5ObulV9cQPN3slPLj160EutwWJglkDWuzDxXqkG4Bsz0Rj7G5tTtkx?=
 =?us-ascii?Q?y4jhfdcj1OM6uJYpyaQ8+jsngTPCbWx1U0kposSMlZ2EHgx2Ja14lLj8btrk?=
 =?us-ascii?Q?q8sK8fIEEZ6QiA2U32sCEKm6zWF85orXXlbMNMTsLQ3AaC0kQMi6VVwUg1JL?=
 =?us-ascii?Q?CkrvYti0FoYoC+oeo6WL7Eu2R1rNht2ThGBPFuOW0Lay2JsjXhBpgkzmJHFX?=
 =?us-ascii?Q?SlV71OS4YkN/XNuj3Jcnc6lXuvqRRLtRQFbdDNb5+gbOTpZra4RpNeySmflN?=
 =?us-ascii?Q?lUBXkAmJIHBi632fDhoQs+BGgME3u3XGoty8lhiHRcXrzGGpnJDczaq9xfxN?=
 =?us-ascii?Q?TZZO0LZwIn9VGA8cGQmVaLXEvAexx3783CxDvSB523xx6/WHj5xC4COeqJE7?=
 =?us-ascii?Q?nV/NVjhjf7PE3pijeMZ1LA2i7kw6ZDy0GLEZ+SWHPsVofXDXpVaKXPd3KlZD?=
 =?us-ascii?Q?Or/MHZaIwRcLdABlgBsGjRd9SAbNdxnhccgbohT9sMGhUQb3HnTypHy3Otpk?=
 =?us-ascii?Q?5d76zKypSqpoNHjLIADPcTdFBq4H+MN5DKDa6oJttSOy6zhHd0/YDJMLhtPt?=
 =?us-ascii?Q?LYs4cnI9x4rGwE8EQMSfSyIUcXinXb87uDSP36p1ZPC4VCqTrMhIU9L59jKf?=
 =?us-ascii?Q?yNnBgtAeFib7KtxSGwT4sDAt3Fw+p3G3WPF/FmQ0vsRElVP2yaMahc59zD0A?=
 =?us-ascii?Q?slcSbt1/ayugeyLLR0hGsDd8ivdMIoX7dps6COtRaU7C4ZFxP1w0r4f+JLri?=
 =?us-ascii?Q?BZhaGSNqsJUW1QzZJnkt2QBJIt+/KzBLS/BCYmcwky9/1vV4AhKr+97ynTau?=
 =?us-ascii?Q?EiEwdKhAwlQVZAGWUQkeazJKDlAPe4OCsx+u6PKgEqj02OmTBIeh1ZB4j/Xt?=
 =?us-ascii?Q?Y7QGNGQDXYdSXGCk0xDDR3Yia86+S6QVOSshYcALtHoi1NTS4G2Xx4+X0AKr?=
 =?us-ascii?Q?DvCDrF0C6pxnsbO9PPhEc9UFK9RtLO+IhU7xvik9KU/XY8GudZxFDc3swb+F?=
 =?us-ascii?Q?j369Tlb0Ma/CxtxCHR0Fjznj1+XbtYv5eM9JUyT/nid5ficQuflmDhZ2eDRK?=
 =?us-ascii?Q?2zLNUjEbQ0Gl1tJTWCX1MEKN7oh0LquDowZIJKHFUfRO04SiOtuOdP7DPB2Y?=
 =?us-ascii?Q?389DIfbArui1o1vhp/9CeY/qKC0hnYJPRGrtlauEqzT+GPTsEGoWfFSMPJlN?=
 =?us-ascii?Q?fxxBNGeBdUoelCTmP4onv62s6Zolo4aUCcNvMTlBthoutoxKYBhilRX5Vzic?=
 =?us-ascii?Q?inG9Zc1du8gBmrYZ9sgUxdKx6oeWjtefZuTKN7AuylNLYOxAk2Sb5ISg7UGZ?=
 =?us-ascii?Q?dUok3nOBdmeyeYzTnSQtSpXW8ZRd1EHqZDsYQJtchK8O2ZfISdvX0yoM1l5g?=
 =?us-ascii?Q?s/bT2ewdzQq+HCHxJzdF4n5MAx9/NHGRzwh5gadU43/+XOqUcmHSf1astVb4?=
 =?us-ascii?Q?Gsk3uHFI8GPPiZRZ3zIAvBpeiBU4wbhXhYPp1owfRg3dJAntZ0+lsQ5CGWjY?=
 =?us-ascii?Q?nBKTgDp2jgr4dtKOVSMyoMxdBBjpneTbd8EZBoHPjihgh6wJUzSxOdPSSiqD?=
 =?us-ascii?Q?JGSnUbY640Skz41V9jvH5fg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49583caf-6a06-408b-a0c3-08d9bf45c128
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 21:07:36.2856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wP1o0WAnrLaAYb5F1MefPlLplBbt3BwKiVoevzwOcw4N52uNiyVuwryfb7RO36mEZwzBdv8dS2131Ggc+jcm1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Tuesday, December 14, 2021 10:56 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wanpengli@tencent.com;
> rkrcmar@redhat.com; vkuznets@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH] KVM: x86: add kvm per-vCPU exits disable
> capability
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Mon, Dec 13, 2021, Kechen Lu wrote:
> > ---
> >  Documentation/virt/kvm/api.rst  | 8 +++++++-
> > arch/x86/include/asm/kvm_host.h | 1 +
> >  arch/x86/kvm/cpuid.c            | 2 +-
> >  arch/x86/kvm/svm/svm.c          | 2 +-
> >  arch/x86/kvm/vmx/vmx.c          | 4 ++--
> >  arch/x86/kvm/x86.c              | 5 ++++-
> >  arch/x86/kvm/x86.h              | 5 +++--
> >  include/uapi/linux/kvm.h        | 4 +++-
> >  8 files changed, 22 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst index aeeb071c7688..9a44896dc950
> > 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6580,6 +6580,9 @@ branch to guests' 0x200 interrupt vector.
> >
> >  :Architectures: x86
> >  :Parameters: args[0] defines which exits are disabled
> > +             args[1] defines vCPU bitmask based on vCPU ID, 1 on
> > +                     corresponding vCPU ID bit would enable exists
> > +                     on that vCPU
> >  :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
> >
> >  Valid bits in args[0] are::
> > @@ -6588,13 +6591,16 @@ Valid bits in args[0] are::
> >    #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
> >    #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
> >    #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> > +  #define KVM_X86_DISABLE_EXITS_PER_VCPU         (1UL << 63)
>=20
> This doesn't scale, there are already plenty of use cases for VMs with 65=
+
> vCPUs.
> At a glance, I don't see anything fundamentally wrong with simply support=
ing
> a vCPU-scoped ioctl().
>=20

Yeah, scale is the problem for using a 64bit mask, so in this RFC patch I u=
se rol64(1UL, vcpu->vcpu_id) to rotating left shift the vCPU ID bits. But s=
eems doing it through vcpu ioctl makes more sense.

From my understanding, so we could add a new vcpu ioctrl e.g. KVM_DISABLE_E=
XITS, with parameter flag which exists to be disabled, e.g. struct exits_in=
_guest (in), or even without parameter just like you mentioned, pick up the=
 per-VM cap flag the userspace set.=20

> The VM-scoped version already has an undocumented requirement that it
> be called before vCPUs are created, because neither VMX nor SVM will
> update the controls if exits are disabled after vCPUs are created.  That =
means
> the flags checked at runtime can be purely vCPU, with the per-VM flag
> picked up at vCPU creation.
>=20
> Probably worth formalizing that requirement too, e.g.
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> 85127b3e3690..6c9bc022a522 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5775,6 +5775,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
>                         break;
>=20
> +               mutex_lock(&kvm->lock);
> +               if (kvm->created_vcpus)
> +                       goto disable_exits_unlock;
> +
>                 if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
>                         kvm_can_mwait_in_guest())
>                         kvm->arch.mwait_in_guest =3D true; @@ -5785,6 +57=
89,8 @@ int
> kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
>                         kvm->arch.cstate_in_guest =3D true;
>                 r =3D 0;
> +disable_exits_unlock:
> +               mutex_unlock(&kvm->lock);
>                 break;
>         case KVM_CAP_MSR_PLATFORM_INFO:
>                 kvm->arch.guest_can_read_msr_platform_info =3D cap->args[=
0];

Got it. Will add this explicit requirement check as a subpatch in next vers=
ion.

Thanks for the quick review!

Best Regards,
Kechen
