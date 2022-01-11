Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1D248A7C7
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348215AbiAKGi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:38:57 -0500
Received: from mail-sn1anam02on2051.outbound.protection.outlook.com ([40.107.96.51]:22197
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbiAKGi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:38:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROuVflYrHiO/ibphWcsJUxqIYPePHxRxH/Rd6nDL/AAfeF3mrxkPniXzuG/bttnSrHnwQEjGy+BarCHUFeBqgCc8DiQInuGzD4sCqo6hMrF+I7EHSTkgkSvR7AVGWZs+VCEn/gzn1pJ53Viu1xjV12bkoG3F5SFPVEtlC8D6D2vu+u8GWWffRSFmwqteVT1/4obaXU0KepTYbU+FHnJroinJe16h6SFpgPU89MmLCwgyTr5oJsxVdd9vzkYrRSavYOyTuM+Q6umfGkrLCSl2KbykH9mqDepUMY4oEVq4IbtO4Rqab2mImZe+jNla8g/kGUt3oKh6e8s7LzxK6YjzRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swjwLUJ9d6T2If0t8c+9NcanCjV6WQUU3oshXQGs7CY=;
 b=XMKjAxmhObs9PVWk8JCIorcwhtf9WtVWTPG3ffvYF96ObwMB0skwBluYxDRq4JE/vHahi6QNGBa80XkKRaa7+sxHbKN2Irio7RCzf/DqEVZlihkDMfi9kVFKEhENS2gBSkl2krhKGJo9HKPlk5Su9i1IcTiCSN8Hc73ZgAesVZpKnheNHKVrtsbL9F7yaNMi14/A5xSeWLnlr2TrYy9h3j7Kx0bI2bfK+PLfGnrG4duT2eaeccG7BNxP9+0HpEwSnOEuCO+f1MeXln4/RB2kNXoWxZKM6uAS3iJgNIXt/jHbn9x2uDSH4DSBj6GsnMezdDTbM8Qy5S7Q8VASDphCpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swjwLUJ9d6T2If0t8c+9NcanCjV6WQUU3oshXQGs7CY=;
 b=AgpZtfdRxGC5R7Vs3QY/AdYvPp7+L/2hPXyALTOxJeZL9oeCCCBlyVMUPFVcmKVka+1/GGrOPBH4wcF1WiOojRvOYgttOZup1qtYBE7LcwUq9WeeJiqF+/ZXxuPh9+0QZQNCC02Lx3euzEUsL+6nT2uDVvdXhbQoKMuhHIohYBV7AFZQYdpjyHmhmaouTKleTNMc0dyzK2R0JygbUAhFGvrv796MBQKwzLSNvvoxXDKHWVu/E5HTmQthjQ2foMICOrCdA9r7AzZvkRpr5dRzRtVTU+vw7plBhQC2Oe3VLLEIrWZfYoCQ/CDq2uvVwtjxQUQRwZxGivyXkF5qWyCPkg==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 06:38:55 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 06:38:55 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 1/3] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Topic: [RFC PATCH v2 1/3] KVM: x86: only allow exits disable before
 vCPUs created
Thread-Index: AQHX9kn82651Wm3jGUmxPNyi1Gl7yqxcuSyAgAAILOA=
Date:   Tue, 11 Jan 2022 06:38:54 +0000
Message-ID: <DM6PR12MB3500C42C449D46AB22B7AB8ACA519@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-2-kechenl@nvidia.com> <Ydx/21chyOGW8hoZ@google.com>
In-Reply-To: <Ydx/21chyOGW8hoZ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07e20e5-8313-46ec-aaf7-08d9d4cd09f6
x-ms-traffictypediagnostic: DM6PR12MB3033:EE_
x-microsoft-antispam-prvs: <DM6PR12MB30337E8FF10834862D1106C1CA519@DM6PR12MB3033.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hLIv7SoJeEbjdwlCsEeS2P2qNfgznEYM0aiB9NqHZcqO1n8RTKfhFgtDE/ZBd/JDX2FtWrDykZBL0VgEZkueX4HESeKrZddI775H2YK+9P3gUVKgMESP1qQyNCPj1YLgOzDNWzZqatNJ+/mVPjQAw8oOynjKJLBHSlEfMD8U4jnBjT4/1S//1Gxsq6lhaaW4mxjv0m6x5VWGwPlSuxCmXBdLDZZ/qW9bscbJ+auMFDI/HGWQr2xTngFpt/lt0QswHqEuX8ZR3pdyP1g6umOHhh0ZZZFiyAB10awmTgI2ic3WjDUdcjBJBJJnIFSCXImX0+FUItAUiW6sutjsAEQAPvCG9xT7XHt+rqSfxQnjs2a02Ua/FntncQZ20hLIMXkOQAk3T+soIY8/+djtrgsjeaG9h5mnxpQ9fQG6uXD1f4haZK7fuCZV8XbfBgVJNsnliHKpJe0GWR0HiLyP/xjHAUS4GW5m7PwwvgVbMy4WyIDVi6bHdwzZkAkHoMC73iyDLTKkAsK+35vTZF5fuedNqekIxyV7eaK8X1WxvQgJcO3/FQT09FFtz4z5dLh7yEhrkUUM8JZn3Npfn/b9tRKN1cKm2d6txlTGiU8UxG7+NH+fRD2u+dwHcDTa0XlSWSBedMDtxZDqywuLtA30W2IJJBNUj11qsagnV4SO0IW96TMHTg3ld9Aw6fHlQJy1fIiyxiFKR61Sb5hr0gyd61VniA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(9686003)(6916009)(122000001)(66556008)(66446008)(64756008)(38070700005)(53546011)(8676002)(71200400001)(38100700002)(6506007)(66476007)(33656002)(83380400001)(2906002)(86362001)(66946007)(4326008)(8936002)(5660300002)(26005)(508600001)(7696005)(186003)(52536014)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+ULDVIMJvy4lR9jhpefW5YUJr4VeNM4XcJ6nlR8fYslqkY5LyDoR6yNgi8/+?=
 =?us-ascii?Q?YM81/zOzw7UzPLln2oG1D59tfatuaOfpdqhaAlPyadg7WS6TsQFsqG8JSG5U?=
 =?us-ascii?Q?Ga8f1OYjRlS+HGHJwFLratD2tw/DW7PtfIxl2GqCpNaNGcACnAHFIQEPQDQ1?=
 =?us-ascii?Q?QBKlILL6phxsCAPQiusm1BA/9MUSvXdQFLAu3TciKDWBtp+IZTsu0re800kE?=
 =?us-ascii?Q?b6xctRgKw5dDGGu2Ijzp6BQ5UhuHSXAFmtdp+pxUGQnHe6olgGJUA3DiflU1?=
 =?us-ascii?Q?/6uvIrHpY5iZDPjaM+t9gIYhi9rFWMVJ1qx0BIKmWEJTILwofhk257Fuwgsi?=
 =?us-ascii?Q?OvNOn5LwYAMZT+ujjnfeP57ALNueGaJTQtLSEj/pnqD8APAp89ok62EOoVN+?=
 =?us-ascii?Q?skuRGpBMW1ts5sBvIja3in+xxgUyFN7+JAtn9L/4rGF9M+55iRT6Q6a0h5UL?=
 =?us-ascii?Q?wa48YZbwFPD0B0IodsrYS4yz2kEyyPdMjaaczQNfy83lhO0RSdTDkHBrXEBh?=
 =?us-ascii?Q?BV1LxnqRgJDUY8RtYU5N759ZKPndtyAdXjJ1Z0RGs9jlCZOaGj8yKDn3srfl?=
 =?us-ascii?Q?yFVXai+d3a+o8MwDQ/izwRiRcWoTv4OXbhMwd9A1DZqYaPGCS59DCIq+1LSH?=
 =?us-ascii?Q?eyIO3+i5H79R1AUonTCAN2YXOrOLK+lO9K2qnmzh/7GERTH7UHvtZWAJetH5?=
 =?us-ascii?Q?PvRLkuw9Ah/x8T1l4VS0X0GOXPPwVgnXZ5iFg11xT2p3DzA5HJomuBF2GZ1f?=
 =?us-ascii?Q?JUwGtbr0bJOSMAxPrsCrd02G57GsmErJ3BSu+WeoN2b5aNJiKbGRkTrgjg0N?=
 =?us-ascii?Q?iE1xwAjeGivNt5YF1421mqdpSx4mn2mVB6x/iN9WIHiJ2/CPjM7zZQbArcZD?=
 =?us-ascii?Q?VeJBM4dBHjwB0/2WPyZLtLMi5+HQIuYWMTtKCx+3x5zcaCDKGoDg3as0YJt6?=
 =?us-ascii?Q?uwjTnZ1hjE9oglmUYjD/Vqi25KYJuTdetINnkRg0edLPhRUnCR/zJrCsyRo5?=
 =?us-ascii?Q?u2YSwqjOqejmkcpblYbUFV+QIYI0VgkJOHjqxtJ4LGrCU55fAn3Mk4+3zM66?=
 =?us-ascii?Q?l67ApY9Sw3LbiUk7OfbHe2DSg6+ik/VmWDs/Ns/WoF2vTWAlBk3ceLZzi70e?=
 =?us-ascii?Q?m7Rxkb+ujH2TugVt0TtO0U/9gwtk/hhkSPI6aHgN4Y1XjsbUPpcJTNRrl5D7?=
 =?us-ascii?Q?JJlHancmBF6YcqsJGWyYUiK93j80t+YlCTRbySrnumrcFV5SQkaTqR3HzJN5?=
 =?us-ascii?Q?e2KkXNBhI2NeiqKXdg/IrUVaZhLrnt4YdgtP5p5XAzJ4T76b3rPdfF78XdCz?=
 =?us-ascii?Q?bcLl2igqCpSXUMGB6xMRC9fXiRSNet5MvlQmCnH8zUdbc3Zb/dOHWII65I83?=
 =?us-ascii?Q?qa4bni6wlo9DWHxbxlEG0jxejYENkZHZriroT1suckEouSKvWQdE/Irt0ZkP?=
 =?us-ascii?Q?PfAHtU9qOkEeBil4S+gtWI83SGl026nOe+8NY78O+6Y494xe4vppDrHcVgZM?=
 =?us-ascii?Q?VlPdn+eQ94iFsVYELVpPgfRadPEyDn8e//OQBHc1KottlFiag4QYry6M/Blm?=
 =?us-ascii?Q?bT8MxCxgvYpDZQnOKYleNzOoED0QXJv6syeZtN94dWbBSghdeZGwdDarVJIa?=
 =?us-ascii?Q?xKNjH5B+FPV1giOreAHOsDY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07e20e5-8313-46ec-aaf7-08d9d4cd09f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 06:38:54.9711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L66EEgOBSvFSTxkKCHBSTR7bqGN6iRGEkAPecq174froNIEVpxZmZndbFI01fsVHkM9sdxIM7sInoZ1Yl0LDAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, January 10, 2022 10:50 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wanpengli@tencent.com;
> vkuznets@redhat.com; mst@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v2 1/3] KVM: x86: only allow exits disable before
> vCPUs created
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Dec 21, 2021, Kechen Lu wrote:
> > Since VMX and SVM both would never update the control bits if exits
> > are disable after vCPUs are created, only allow setting exits disable
> > flag before vCPU creation.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>=20
> For this to carry my SOB, I should be attributed as the author, or add a
> Co-developed-by: for me.  I'm also totally ok with a Suggested-by: or
> Reported-by:
>=20

My apologies for putting incorrect SOB format :P Will fix it!

> And we should at least have
>=20
>   Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
> intercepts")
>=20

Ack! Will mention it in the description.

> andy maybe Cc: stable@vger.kernel.org, though I'm not entirely sure this =
is
> stable material as it could in theory do more harm than good if there's a
> busted userspace out there.
>=20

I see, will cc stable mailing list. IMO with this patch, incorrect behavior=
 from userspace
only cause the set flag "ineffective", not sure if this breaks some userspa=
ce seriously.

Best Regards,
Kechen

> If this doesn't carry my SOB...
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>=20
> > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 1 +
> >  arch/x86/kvm/x86.c             | 6 ++++++
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst index aeeb071c7688..d1c50b95bbc1
> > 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6581,6 +6581,7 @@ branch to guests' 0x200 interrupt vector.
> >  :Architectures: x86
> >  :Parameters: args[0] defines which exits are disabled
> >  :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
> > +          or if any vCPU has already been created
> >
> >  Valid bits in args[0] are::
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > 0cf1082455df..37529c0c279d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5764,6 +5764,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> >                       break;
> >
> > +             mutex_lock(&kvm->lock);
> > +             if (kvm->created_vcpus)
> > +                     goto disable_exits_unlock;
> > +
> >               if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
> >                       kvm_can_mwait_in_guest())
> >                       kvm->arch.mwait_in_guest =3D true; @@ -5774,6
> > +5778,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> >                       kvm->arch.cstate_in_guest =3D true;
> >               r =3D 0;
> > +disable_exits_unlock:
> > +             mutex_unlock(&kvm->lock);
> >               break;
> >       case KVM_CAP_MSR_PLATFORM_INFO:
> >               kvm->arch.guest_can_read_msr_platform_info =3D
> > cap->args[0];
> > --
> > 2.30.2
> >
