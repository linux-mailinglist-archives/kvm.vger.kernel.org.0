Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9FE48A7C4
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 07:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348208AbiAKGhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 01:37:33 -0500
Received: from mail-sn1anam02on2072.outbound.protection.outlook.com ([40.107.96.72]:9127
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbiAKGha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 01:37:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrfaATAKB+9P1/pcgZxY3+vOuBT8BTx9ueD3WyhS2jWawy53s+K0Qh5G4tVtVm+542Sl4XeZ/GHB3YwnLTYUjFWHdgSvRfVjMCvL2tvCqWD4LkAEFky2hbAkf2RS5FhD25eiLkYrxCnRN/fb7vK7Y6dQ+rUQGjUcCZEKu5RWBROh0W0MAMbkjF4MeYb4Jpt0bVB87miWCFx9aQuNUhbY5ox+DKzPBpgxlOYl7L5CQ9eiubXLzY0prs9OH15AS32MmkrYHsA1I1Z96St7MJ1Ztw+Ye6wA5TabGo5sfkne87t3ITdGZTSJIWPuzTJIcWxOCZ8GNYKjCFcoTqfOP5aaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maw0uCdERl049+zUkHBY8TyxsQ95/HnPQS92UGE5K6Y=;
 b=PaLraeR6eFH1E49BVoIjXJ79d3e0LlV2+WN637xMZ775Bry6PiONoEWFIeTuXDe44f/5jJxNwinXCoSSqAT42Vb4Eiotc34cywymM5bH1oS8buXiUAb2c21ZISnPvfjBf6FkLUI6l929iigm69J7yhaX/R78fUEEagkrN4G4Y0GGROXIQTKqyfz7/29ms9peyEX1CV7CcddeYeUhccUssuA062e5e9d4Cp6kItQ/8O6lKczeSyPwj92GwomjgpLBn9If4RAE0wch0hz58Cpu/0wq1SYlSIwJ+h8fT9HRShzOnLiE1DFVulzCRSAe6Mpt9pqesHN1DsRrxSm50h4Siw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maw0uCdERl049+zUkHBY8TyxsQ95/HnPQS92UGE5K6Y=;
 b=hwE/Hg2JzSDKreIZOwT9gXT1DfE7md6NW4vz56zrGUoDh+cftaBTEQoScW1O3TqzG8K72N3MBRnetVsvkl/aFoGt11atQnMOGCMWLowhJyM0YQuS8Y6z4L8NHR/CR51c3agtPvap3cpEALmY3qo3M/QWU28Er1JRdf+GXkN4vyxo5mY+r90utzyjhsHZx7sF6ymaudJjrtvpKUCfMrzPqOkiJ3MTEFK7AIyK7oAesT7AcItY7bQyyu/fmcdTrO06hGOXYZ7ui5E/URBBEgfHJeFJoLWDcGYQU0xzXGSB7QLKVNCRTA/3El3cA2hGUyO8eJLidddg4QqEccDA0AGucQ==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by DM6PR12MB3033.namprd12.prod.outlook.com (2603:10b6:5:11e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 06:37:28 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9031:757e:d174:3857%7]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 06:37:28 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] KVM: x86: move ()_in_guest checking to vCPU
 scope
Thread-Topic: [RFC PATCH v2 2/3] KVM: x86: move ()_in_guest checking to vCPU
 scope
Thread-Index: AQHX9koCv9hsHIqElEy757jd7+dvuKxcxfUAgABQoJA=
Date:   Tue, 11 Jan 2022 06:37:28 +0000
Message-ID: <DM6PR12MB350042176DA4B2CCFF7B84DBCA519@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
 <20211221090449.15337-3-kechenl@nvidia.com> <YdyKlIHgf3b1K57O@google.com>
In-Reply-To: <YdyKlIHgf3b1K57O@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a934984d-d8f2-41c0-80b4-08d9d4ccd698
x-ms-traffictypediagnostic: DM6PR12MB3033:EE_
x-microsoft-antispam-prvs: <DM6PR12MB303310F37B3BC27404955436CA519@DM6PR12MB3033.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l/6ezrf1VuntWLfnDKNU2XiioI9t3uPVSFfIKIc7dyE5WLtx1zs0BBaFqPrwMCJ0Z3rd55wBfAYv8nZCnv0nfaMEWbKJlqcXpHpIy98YOPhcMKuMeoqnkcQfKvyKAaxAnt7YHSO9T+OgPqQAqG7XY8hhaauKlSsHVoARnujJRZqx4ctH6WVQtJiCwi0N8o6hjuwrSwj6hhdpB2M0+J4ZYGs/k8oz0oCLEq5Q/K1ROP9ujwMx3NFMCxMk9JuoFyYOs3zYW29iLiGC7FwpzNSqwLgsXRlMsgnBHQz9N66UXzhJTvfDd7/B9BahfTvT4Qw6qta/vfRN4Js2sfavc/pJ1gix1uqNz1bqwgoRlzyyMp9aq2m3R9dN7YvGS9DFottbJeHoVqkG4lbTUT9ju9e/xHxyGBjfntueF/BOHWTwf1/s0m1+GzS4Dcc4X2XQGvik85WYysSzDCtLjlSaxVaUKgPcTDm7tBHkjA7zMlzA3jsmctYjZw8vJuZKKfXQNUH5Xl7USrxmpCTENrOtUIXhnRM8sswXeSTc4JB1uWUz1XD+zLfsBfIxxF8TU2AD/rOO5NnSPt0RzpsoUWuy4d7KNwUke7fArU4UJco4EMyB4rSNJQ4Zwy9ImBMDbyC7cK7WqzZ6tj0PtmbBLiN911q7tCugGZYSwgO996GgdFTzgP4A0XunGwPSvOQSWJGlyudcxSIMBPC2f6Ih+CYqPJwheg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(316002)(9686003)(6916009)(122000001)(66556008)(66446008)(64756008)(38070700005)(53546011)(8676002)(71200400001)(38100700002)(6506007)(66476007)(33656002)(83380400001)(2906002)(86362001)(66946007)(4326008)(8936002)(5660300002)(26005)(508600001)(7696005)(186003)(52536014)(55016003)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T0hUlAEm8qqDyE4AbDjqd3fFqCraWJA/VRumdszNhf7SvcJ2s0kI9Fyf1GpR?=
 =?us-ascii?Q?Lbu6sYow0XYKDFeKPXKWCFrl9qONLDD3evwQgu7+fYJcjZKEGDZzhknYKcWx?=
 =?us-ascii?Q?8nVzl3AJCtwmmDkGFyVL/Eq7aGOz5Dtgv3ipwzx/+LHRVEGrOZ41/DCghzka?=
 =?us-ascii?Q?cthKS4RvsXCiMYMrDgu843kGQfquS87N0TXu2mlV7c8mEBU3xoeWAQsf37XC?=
 =?us-ascii?Q?WCw8VCelNvU950GecZCggsruQsASg+meIANiW13rLaobxWZLAYWMQr4vA0Dr?=
 =?us-ascii?Q?9rxdV4+6FTL/DK9z84Ftc0kpbPVrqgNxb1uEyhzYdXRWPDFPiu3F7k3jyea/?=
 =?us-ascii?Q?B5kiLQhpoUsaEt+tPf/T4DTWzIaiJ6mW4AuvLQfAEAbc//op4+tIIYsXaBXc?=
 =?us-ascii?Q?Y0q7NtwItsHb+pB+Viskfg410NNDfBtrnwkCGP/G8KlGhIGVwNnz1OFyNjyy?=
 =?us-ascii?Q?S7RmclAl/saw3dkN7xjQjksK1CP7VyETudr/aGKvevUF4ko0rOfNRDTzvM7N?=
 =?us-ascii?Q?l/HRdiKHaDw9ptvQx2pL8WuiFXO9lkhFHvkeOH5IxHCaXR9mPIdboiGG3Mvq?=
 =?us-ascii?Q?f/ZdOuXtJ3I5dfep8676giUIWwrzJxCPJZSxGuB2V50rJ1wrYE8zl5OUFfZu?=
 =?us-ascii?Q?tLB/sFbrJWs9dS/2F0E/ye8ZSoudyd0oRramudR6RCoPN9SHXGJsDuE+PX19?=
 =?us-ascii?Q?z0vQm1oNtkZCT3lvefut8rIQhsCyWIZ77kmFLBbEdyYStPAPAPrWJfnvM+Mr?=
 =?us-ascii?Q?uEFs7kil66bxLkjIxGYJis+tKkwct5ji1lViuGtY2R0wUmJvQWPN1HnTJNIS?=
 =?us-ascii?Q?u4WG2gByX1TRmgucMI+XflspqAdFceNdArZ4fHWpYI4rT6+2Z1lIaADMmzgg?=
 =?us-ascii?Q?z1t11i7cTuJbIC/jDRFlv9EZ883v/FJQCebjfI4i4l1StErZoDmkH3nwsqPQ?=
 =?us-ascii?Q?kJmI0Kny6i/w+CPMXAeh5Std6tNa1shBJ9spaxd76RFGqHhnFmeywXixs3Gc?=
 =?us-ascii?Q?/Pua8oOvpGTF3pZZ7Et0DsTukNB2iw6TMfDZjFAK67P6CRe+yd6b8vGN2YFC?=
 =?us-ascii?Q?icZ+G6PMtin97HH+LDN5xPgsjbua8CEwTMwK4pRg3WO5Jfghs7hgg0pDeQO8?=
 =?us-ascii?Q?knI8VKjpmL7gShiJ/UHdqL/bDktRpJ6Vfm5S8dofmpDdxTTm/8AgLAYEOebR?=
 =?us-ascii?Q?6MGFa3d76Ti47HOOfOvz4fK9/um5HjnIYY1fzjqByjUkh9RIvPJGjfvnQID5?=
 =?us-ascii?Q?lsmGSf8Nc6nn0rm8OuzU3/3Cu8xH/KhxajQJygzSwlmtRzW9i7ZHb7MpBcdV?=
 =?us-ascii?Q?tfOPaF+pQSUgM24xBkeWOSKryl00MxeH8+fBqQhuWndZgdnk6CjHovat0IIY?=
 =?us-ascii?Q?7Vmx9ClkjVdypMux6pGr5tlyvPaZTZDJS/tlktifREv5A6n06UjwIrSjalcx?=
 =?us-ascii?Q?4Piksx/3RTvVlASiuP041sn4Gbpzht+i1bCsrfq4KMrtaIDxdTzPqVnjAsn3?=
 =?us-ascii?Q?PVCKTqt14mGTyxuo9TAAaWzm9bu7cwysu/2kgd4b3W6r7ASr3jwiH6fPmP0r?=
 =?us-ascii?Q?jMeL3zPCxvecLwwQycfUZ4AcWno6Gm25lts4kIkbNp1yvyGuHiFIGy30riP8?=
 =?us-ascii?Q?GL/4P9OmeWy57vFLn1cUlqg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a934984d-d8f2-41c0-80b4-08d9d4ccd698
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 06:37:28.7590
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m2xUhJgf9EEmmVf/kUF5SkT5farS/QRBwgwivzfgQX8hz6F/IcyluNzQ5oGukufEeCYmk/WoTKcODSV0N6SjNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Monday, January 10, 2022 11:36 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; wanpengli@tencent.com;
> vkuznets@redhat.com; mst@redhat.com; Somdutta Roy
> <somduttar@nvidia.com>; linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v2 2/3] KVM: x86: move ()_in_guest checking to
> vCPU scope
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> The shortlog is weird, I get what you're going for with the "()", but it =
honestly
> looks like a typo :-)  And add "power management" so that there's a bit m=
ore
> context in the shortlog?  Maybe this?
>=20
>   KVM: x86: Move *_in_guest power management flags to vCPU scope
>=20

Ack. Yeah it's a typo :)

> On Tue, Dec 21, 2021, Kechen Lu wrote:
> > For futher extensions on finer-grained control on per-vCPU exits
> > disable control, and because VM-scoped restricted to set before vCPUs
> > creation, runtime disabled exits flag check could be purely vCPU
> > scope.
>=20
> State what the patch does, not what it "could" do.  E.g.
>=20
> Make the runtime disabled mwait/hlt/pause/cstate exits flags vCPU scope t=
o
> allow finer-grained, per-vCPU control.  The VM-scoped control is only
> allowed before vCPUs are created, thus preserving the existing behavior i=
s a
> simple matter of snapshotting the flags at vCPU creation.
>=20

Ack! Thanks for patient refinement on the description wording :P

> A few nits below that aren't even from this path, but otherwise,
>=20
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>=20
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  5 +++++
> >  arch/x86/kvm/cpuid.c            |  2 +-
> >  arch/x86/kvm/lapic.c            |  2 +-
> >  arch/x86/kvm/svm/svm.c          | 10 +++++-----
> >  arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
> >  arch/x86/kvm/x86.c              |  6 +++++-
> >  arch/x86/kvm/x86.h              | 16 ++++++++--------
> >  7 files changed, 33 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h
> > b/arch/x86/include/asm/kvm_host.h index 2164b9f4c7b0..edc5fca4d8c8
> > 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -908,6 +908,11 @@ struct kvm_vcpu_arch {  #if
> > IS_ENABLED(CONFIG_HYPERV)
> >       hpa_t hv_root_tdp;
> >  #endif
> > +
> > +     bool mwait_in_guest;
> > +     bool hlt_in_guest;
> > +     bool pause_in_guest;
> > +     bool cstate_in_guest;
> >  };
> >
> >  struct kvm_lpage_info {
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
> > 07e9215e911d..6291e15710ba 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -177,7 +177,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu
> *vcpu)
> >               best->ebx =3D xstate_required_size(vcpu->arch.xcr0, true)=
;
> >
> >       best =3D kvm_find_kvm_cpuid_features(vcpu);
> > -     if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > +     if (kvm_hlt_in_guest(vcpu) && best &&
> >               (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>=20
> Can you (or Paolo?) opportunistically align this?  And maybe even shuffle=
 the
> check on "best" to pair the !NULL check with the functional check?  E.g.
>=20
>         if (kvm_hlt_in_guest(vcpu) &&
>             best && (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
>                 best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
>=20

Makes sense. Let me align and reform this in this patch.

> >               best->eax &=3D ~(1 << KVM_FEATURE_PV_UNHALT);
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c index
> > f206fc35deff..effb994e6642 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -119,7 +119,7 @@ static bool kvm_can_post_timer_interrupt(struct
> > kvm_vcpu *vcpu)  bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)  {
> >       return kvm_x86_ops.set_hv_timer
> > -            && !(kvm_mwait_in_guest(vcpu->kvm) ||
> > +            && !(kvm_mwait_in_guest(vcpu) ||
>=20
> And another opportunistic tweak?  I'm been itching for an excuse to "fix"=
 this
> particular helper for quite some time :-)
>=20
>         return kvm_x86_ops.set_hv_timer &&
>                !(kvm_mwait_in_guest(vcpu) ||
> kvm_can_post_timer_interrupt(vcpu));
>=20
> That overruns the 80 char soft limit, but IMO it's worth it in this case =
as the
> resulting code is more readable.
>=20

Sure!

Best Regards,
Kechen

>=20
> >                   kvm_can_post_timer_interrupt(vcpu));
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
