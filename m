Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC9648A7C0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348188AbiAKGfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:35:53 -0500
Received: from mail-sn1anam02on2085.outbound.protection.outlook.com ([40.107.96.85]:44230
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbiAKGfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:35:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMjYzj+6jfFBJElBuBwvobv55nM7hIxU41+iIBnLQ/NZj4/fck3fiNECVYf3R94uMVlqAySLl8Wk8NeDRNGyUUF71OvIQjM1a9Bdwu8CmnYFqRRGJZ66BIJ0snyg1IewEpQR3thxMWACZpSX/A+PHmaaVCIXzlRJy2VEK+53O6l7BbLSey+Y+LBdDTaBTn6cpyzOi5U9X03LrU0jDnwhDC7v6Hr3KMAYXz2hN6I46W18i6Tg1gS1sRrUT7IpUBJbRMtv4bQb769/4jTAvgXaLzSdGqA3d8zzihBu6jFWScFMHev1p/Ux9l07dyWTnZ6Vo1yY5sG/nMgClZDVaRFF1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TU4bxud+tdKSrIy0sstenOTfJfTcJhclyFPs+oIlA0k=;
 b=lQGEUbANPmMB4rKIuC0hQYGoRVJbV2MeA30ng+k++x13+CIGPaOkrU3MeLPDi6JkWsgAUr3NwFD9TyQ4AW52Y+upFjucnq7OFQI0SWWf/dlWYvqj0Us+iOxrxDACEzEfln8pk7tItXBPykZMMJcWQ2k3p+kxDfuT6WjNAWpKJn48OZce4lVamidiO102sbOcO1cao6x9A4RtCoK44ojkz6HkkBMHhDlpr5inVxC24awVojn+7+Xp07U1D6Gm/5MnTu2TnF5HqPKEoGW9Qu+nE0z8jmWvAYhfDoHBcCCxu4oKIfA3qcsmcr0GKLCWR30XU6ogKUNrdl+HnyK1NmqWEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TU4bxud+tdKSrIy0sstenOTfJfTcJhclyFPs+oIlA0k=;
 b=A+vYY7mvfINdqlAZpdtVuAnqyZZmBJNZ9Lcqm/kotdSWVGtIAqtAfRH2/C3K+zHpRQ1koXubaeHIr6Ejq07e7fp/xiBp3io8Sj4FBsbG78FaHQi2tQ2MLT95kgc2HgMHx7nKDd/e4V/CkS0SnMFwMuJXIDx3gIfib3Y6mlCwL5bGIRnZkzxNgbQyqz5rbLklCHWzrU9JZRHp0d/ST0tJ0AnQGapAij7fCbN9nNr5eoRGEetHmzMsaaCT9S21SfPAk5LIJtrIxW/J4BOV5wJWtEZKk24nDqPLgzMZjtoyx+TiPM7r0m0mcTPXkonXUiNOc9LylBuYcVhr9VyfA8KuPg==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 06:35:49 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 06:35:49 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits disable
 capability
Thread-Topic: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
 disable capability
Thread-Index: AQHX9koEtqUfpyHZkkeby8KEcdrzF6xc3GqAgABfkBA=
Date:   Tue, 11 Jan 2022 06:35:49 +0000
Message-ID: <DM6PR12MB3500F288EB2952476E2F2E61CA519@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-4-kechenl@nvidia.com> <Ydyda6K8FrFveZX7@google.com>
In-Reply-To: <Ydyda6K8FrFveZX7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d870772a-5c25-463e-3900-08d9d4cc9b9c
x-ms-traffictypediagnostic: DM6PR12MB3033:EE_
x-microsoft-antispam-prvs: <DM6PR12MB3033D8E84F23B61AB6AB83EECA519@DM6PR12MB3033.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f6JahrbTxuz+8s1SEOpSyE79FWUbOrXdfaFaAyMha+cAuKd/sy1p9rJPdvRKqdILIlX+3BIK+cSZdgRUiJe8e5n5Re1hgwAvniyF737/guPNQPakUk7GoOhS4waPpcLhR6FZIEzMFBBLaujTJ8wXwekir8i33k3elKqFi4aCTH9L5zqdY0y5lOeN1/RE0baTwcCEXDKwqHrKXJu49+cdakNSGRxki//t6dXpYMxhOiSpNP7IcwcyEi5On/y7yRPNq15t+96g3beoeoIV9HGFLMz7dMmuE/v3GaiAZlnE9YykywApxVJK3cr4+sy/jABxmVVCTK1pv47DGRIq0Y7AggpdsB/QV2MTRWKtUkfOFivB/WrwVL4/XojZujlM2FNmHL+Ixm0Bk9z1KGbmmOT4k3S1UydCQSj3doiqsZDmSo7rYJWTn3LQJe/yNLZ3Qlk8d2dsFYVuV2NwGAnSEXF0VcpoHAyNtrl3NbZSf1KKIZNf/9JzaUsGMCBvQQGmYPIjWl9HEXMpTAo0myz7cijxIycMl1PP727m+FhW2z3pbS2CTIe2EOKbyhXBcEWgohx/h+IaZjyxV5JkZCPYb5WsxgWtVlBuiMITChZf44D5oOdcn/NaFwlpsNrEryS+qb/fYatR+VFRV1c+jNTT3JgqW9/PzZgEYYAEaCaoFdZl/v5wXlEAO5NSqEFKS/dy8VWX4EwZx/pSDtcJx+U6ZB0L5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(9686003)(6916009)(122000001)(66556008)(66446008)(64756008)(38070700005)(53546011)(8676002)(71200400001)(38100700002)(6506007)(66476007)(33656002)(83380400001)(2906002)(86362001)(66946007)(4326008)(8936002)(5660300002)(26005)(508600001)(7696005)(186003)(52536014)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZB/JqFJI10OdCYGsIzrmTyr6PmFaxpnrdUl5f/tTCJBmKKh4ZDoTYn01sY0K?=
 =?us-ascii?Q?aaPwzyelqdr0TAQQkTuyBzvOb0bHhzK/ogCbbdsPz3pKyFai8JjQP5+n+HWs?=
 =?us-ascii?Q?QgNOTDdfvWj6A67X6ga0deVWx0mM2wKLIL7moNxgXq20i34rIdGQcGN0Wiot?=
 =?us-ascii?Q?4/MiAOhgjHIJBBmaDe1XEtjy+PISF9l0vtmb7Tnd2DyKbtSQY73m9e5l9x27?=
 =?us-ascii?Q?PNHACOXCJyfzdyzQcWGTpADXynLuTGsKItJcmfEiSdYrIEvrKaJPaMiH7eIO?=
 =?us-ascii?Q?lzO8pd0FS6szvGoNyyE248boE9brB1tN4LCGyD6bZNI/3z4EtLQpRebK+JDF?=
 =?us-ascii?Q?/EYbkVBUKs14QsKMgR+mVNf+mWfPxC5qYOm0q2cDKxTVVzFsG0SWXZTdteh0?=
 =?us-ascii?Q?X1/Krv9ZCNhJw38rK3T2AbV0nknS9knoJmDkTosTBoW1rZypSdM8Ij/bnXOA?=
 =?us-ascii?Q?/rXecqt7u2Q2MOcAGkXjZQU9zk+n5bE7m1+s1/zuVZ7VzV9NS3HSTl8qVrjl?=
 =?us-ascii?Q?2bEgLQr48NLDBx98Zq8uqcGNnhbQyAigYaRE45+rQLZtzqQB/Kw7rQ6hrWzt?=
 =?us-ascii?Q?1svURjF7rfHulQhFcwt0ev4EX942wDwVkq9Brt26cDLJgy7z6Wkir3jl+Arq?=
 =?us-ascii?Q?saeCSlm80oKC9tDkGgSBoaSM1gIb5JekIlupeS/HRtULBHYTM8CWLKdkWVUO?=
 =?us-ascii?Q?BKDL4H/y+/bHjdGUkgVa4IpTm8NzXFID0u7i5uMyxGxIdHPRITE26ZgZEtTN?=
 =?us-ascii?Q?kPKFH1LoRsg7jXltFvvDB8drEIXt8XrupS4meyjr2fRkMd5RcO79W3K8UrBi?=
 =?us-ascii?Q?Jsv/xZp1qhJ7zlraRbq4fPbBQMf5Zf7E+dcbt5FJ0mH93F0N5qQ1rIzhMh78?=
 =?us-ascii?Q?6t+STKGdiZ0ZdL3cLUPpx7emQvxmSjnPkGCwrN39PYvPsXjFs4b6WwFxxdcS?=
 =?us-ascii?Q?kSnsvQA6b/0h79/9CSW7aJMVsnhhagTO6y9f5JUKebOh61nzuw34uxISw4MV?=
 =?us-ascii?Q?lOMbWlk7pkhcPK8iBZcsRYwiKfm0+63/s3SaNaqdaz2Ssu5x09pS5u4iNY6T?=
 =?us-ascii?Q?SUY4R0QMUDDNZF0FbTZux3ThhXCweZsWWYWVSmkf9fzs5nMKzdU0v+MU2NWQ?=
 =?us-ascii?Q?UGBNGim0saWSnoH+WKSFoClDTlg6KNaW0XdYO+CWU7u8bK7VNqWdev7AwP/W?=
 =?us-ascii?Q?nJTEbSD/ASn7GhtU7kQ5qiGZVy316G0WYju5AgZFNSIiAVOW+9dj71YPyXIR?=
 =?us-ascii?Q?iVPqqfMDae5VHEioGE3TCNxoOW7mIWUa3dGIs4a1g/xWblqb2U6u7dfzQehb?=
 =?us-ascii?Q?D4j0bexV4f1++yDj0lrUgMAPhWh692gQ66pePgxeRpod9LyZqejWk6RxZQTM?=
 =?us-ascii?Q?vJQVkC2XPSetva83SC5bLrdEdEhrcE1y0LCKP4Zpb39ozIPSx3Xb14hn2sll?=
 =?us-ascii?Q?sCdgeYK8z+50yHbh78jmIXwF6L1FFrS5ui0YC9h4YqFVR21qkWLc3kSn2znU?=
 =?us-ascii?Q?IvVZ1WLgstNvlCZVL8Cf0k3kmmi5IXXFs+2Wo1FcY3GQLjK2igMJ3ZBBUHi/?=
 =?us-ascii?Q?b9PA7av7Yvr65ggLGEQ+6UzCTCe1LPcpBIGxoPr7dgrDtfdsJATC1BWmzUOI?=
 =?us-ascii?Q?tUJaLpBgs3ILjXqQYqdCRGE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d870772a-5c25-463e-3900-08d9d4cc9b9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 06:35:49.8134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QHAR/UrXfe318gFEmXI2nh7dkC+jaZdnESU+qJOxqg6AMl0l7rwCIzN3hjXUvQfjy63NixrBt+lD95bDAn0b3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, January 10, 2022 12:56 PM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wanpengli@tencent.com;
> vkuznets@redhat.com; mst@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v2 3/3] KVM: x86: add vCPU ioctl for HLT exits
> disable capability
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Dec 21, 2021, Kechen Lu wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > d5d0d99b584e..d7b4a3e360bb 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5072,6 +5072,18 @@ static int kvm_vcpu_ioctl_enable_cap(struct
> kvm_vcpu *vcpu,
> >                       kvm_update_pv_runtime(vcpu);
> >
> >               return 0;
> > +
> > +     case KVM_CAP_X86_DISABLE_EXITS:
> > +             if (cap->args[0] && (cap->args[0] &
> > +                             ~KVM_X86_DISABLE_VALID_EXITS))
>=20
> Bad alignment, but there's no need for the !0 in the first place, i.e.
>=20
>                 if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
>=20

Ack.

> but that's also incomplete as this path only supports toggling HLT, yet a=
llows
> all flavors of KVM_X86_DISABLE_VALID_EXITS.  Unless there's a good reason
> to not allow maniuplating the other exits, the proper fix is to just supp=
ort
> everything.
>=20

Makes sense. When I implement this patch version, only thinking about the u=
se case of
HLT intercept and want to see more comments if this framework looks good. W=
ill complete
this to support other exits.

> > +                     return -EINVAL;
> > +
> > +             vcpu->arch.hlt_in_guest =3D (cap->args[0] &
> > +                     KVM_X86_DISABLE_EXITS_HLT) ? true : false;
>=20
> Hmm, this behavior diverges from the per-VM ioctl, which doesn't allow re=
-
> enabling a disabled exit.  We can't change the per-VM behavior without
> breaking backwards compatibility, e.g. if userspace does:
>=20
>         if (allow_mwait)
>                 kvm_vm_disable_exit(KVM_X86_DISABLE_EXITS_MWAIT)
>         if (allow_hlt)
>                 kvm_vm_disable_exit(KVM_X86_DISABLE_EXITS_HLT)
>=20
> then changing KVM behavior would result in MWAIT behavior intercepted
> when previously it would have been allowed.  We have a userspace VMM
> that operates like this...
>=20
> Does your use case require toggling intercepts?  Or is the configuration
> static?
> If it's static, then the easiest thing would be to follow the per-VM beha=
vior so
> that there are no suprises.  If toggling is required, then I think the be=
st thing
> would be to add a prep patch to add an override flag to the per-VM ioctl,=
 and
> then share code between the per-VM and per-vCPU paths for modifying the
> flags (attached as patch 0003).
>=20

Our use case for now is static configuration. But since the per-vcpu ioctl =
is
anyhow executed runtime after the vcpu creation, so it is the "toggling" an=
d
needs overrides on some vcpus. "OVERRIDE" flag makes much sense to me,
the macro looks clean and neat for reducing redundant codes. Thanks a lot
for the patch.

> Somewhat related, there's another bug of sorts that I think we can safely=
 fix.
> KVM doesn't reject disabling of MWAIT exits when MWAIT isn't allowed in
> the guest, and instead ignores the bad input.  Not a big deal, but fixing=
 that
> means KVM doesn't need to check kvm_can_mwait_in_guest() when
> processing the args to update flags.  If that breaks someone's userspace,=
 the
> alternative would be to tweak the attached patch 0003 to introduce the
> OVERRIDE, e.g.
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> f611a49ceba4..3bac756bab79 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5053,6 +5053,8 @@ static int kvm_vcpu_ioctl_device_attr(struct
> kvm_vcpu *vcpu,
>=20
>  #define kvm_ioctl_disable_exits(a, mask)                                =
    \
>  ({                                                                      =
    \
> +       if (!kvm_can_mwait_in_guest())                                   =
    \
> +               (mask) &=3D KVM_X86_DISABLE_EXITS_MWAIT;                 =
      \

For some userspace's backward compatibility, adding this tweak to the attac=
hed
Patch 0003 makes sense. BTW, (mask) &=3D KVM_X86_DISABLE_EXITS_MWAIT
seems should be (mask) &=3D ~KVM_X86_DISABLE_EXITS_MWAIT, I guess it's a=20
typo :P. Will include the attached patch 0001 in the next as well. Thanks f=
or
all the help!

Best Regards,
Kechen

>         if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {                   =
    \
>                 (a).mwait_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_MWA=
IT;
> \
>                 (a).hlt_in_guest =3D (mask) & KVM_X86_DISABLE_EXITS_HLT; =
      \
>=20
>=20
> If toggling is not required, then I still think it makes sense to add a m=
acro to
> handle propagating the capability args to the arch flags.
