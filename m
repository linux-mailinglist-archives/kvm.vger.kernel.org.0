Return-Path: <kvm+bounces-34185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3997F9F8863
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 00:13:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AE34188952E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 23:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092961DC9B8;
	Thu, 19 Dec 2024 23:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2sBXEQSz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8021D278B
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 23:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734649989; cv=none; b=TZ37zh1utp9gX4i0WbsRo95FMn1kHF9DeGR1n/eWyf9zpgQNgoCz71aMr/N51UNOT4IpTzFjLPLHLNBZw90n991/Z0/kAp13c8n561irF5JkIAmowdhnr1/Flr9/NJz7Sr/ts/JAbABAffaB4W/MzKljcSs/YtNNVUD1XUzUbbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734649989; c=relaxed/simple;
	bh=vfTOYxh/W8fA0AZ1VgdPTr352ErbEQpVq+gf7IEjRQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=txUh+wfXYeyIJK6F6mlIEQxZtGk8nmSRUGF1tFkKFXq0snimGO195laytk3VLyz1rp2g4nKujf6hyOvsPg4yphB9zo5I3w0pBzin0G0sGx0GtIYOu2fq061PvhJUazcQyifH0IBEATC+ZNdb6NZW2NZb905Ux1LLc9+iLUV4P4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2sBXEQSz; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9e8522445dso264149566b.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 15:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734649985; x=1735254785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mD4Thd4KkzdBJGBYH3K6zTCq+7QOeoHZ6dpA6P0m5yE=;
        b=2sBXEQSzkxwuuzbJJeJ9yEuAoHjPKcgmEW1neHGsAG2gi+tcr4kwD7bjgy+cXOgn5m
         liU13Q5WzX0S+rs4bS4I7PSzefTtraxTTH0qttxou7ot4xGjcIksnzFaBXryXNS/aQ1U
         g9NBaxZoVawvHlnw/+guvKWMyk1FtSHhjdjWNexCTHfwk4fb7++uVw+Wk3YYkaWijgb3
         MO2DJkUEnuH07XvqLJ4/Jmo4vx23vp2LBeTG3SLWFeqTww7eUsKij7vnurHACrKMDnuw
         D69kunSMdxE9MUxG+50Lhe9eR0l0rEnMdlVWn4CZilKaZXXT0SiEiEoikPlnjpt7B2KW
         0QMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734649985; x=1735254785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mD4Thd4KkzdBJGBYH3K6zTCq+7QOeoHZ6dpA6P0m5yE=;
        b=v0ymp4XR/VUsojtjpOb4EMwe2wfAAPXC8DWsam4twjc0VIZgrZfDzWzxCNtFA/l3Df
         uLXRbsxPuC0gT2SUCGN5UVQKOtJe1C2zI4PqhvFCcmICjxCr+cy4SPDF/ov4CeOYSkdN
         o+uXlfTGLbf0rpseAofZEAa0VVFm5Q5ZM5o8kXZfBdqicUZ2qJoq5JhkZ4gBeoFp2kNk
         IIwXGja19ujPukmItdMMe0LOlTB0+tycdHDNYrAQNpDR/wJf8fprM7dvRewT64cW5tbg
         KUh2WUVc3RnTMY9j82Hf6el4cc0pxcaS2lhrOD+f17yuC2hdFIdleFMbBj//vxAt31qa
         Cd1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMSBJkINv1/6WerBLYPqh4TPHt8xUwOaNL5aItqLvjMOkWlFZZdgntJ8F75Kwsn0gPb34=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgCF4rOBRlyfGGUMMMieDboxkVyQ/IvPPqUdGqrqMhPs6ciSCc
	lOe3Lk9PGtBTluNd8RradjunTOCUx6Ry22RTyf5bIBDMNdDT4AccQf2qlQ5MNtBefZLUXrcTXzy
	+0spIxQGsQKc1iPP9AFfp0HAlZDu2FLsVLlik
X-Gm-Gg: ASbGncu//55BlByb+Yt0+0J2eZ8UhKOLwBdmyeWWWGcr8zW5pV9e/rYEYK0R+1hqbVO
	9fNon3YURPiOK9KDp0c8hcNO2r0TdWqsSIRg9tmzp9yOvVuVUuHEZDP/TgBOGdRo=
X-Google-Smtp-Source: AGHT+IGAap4dLIZqyAkAJDuWCVAogXcnseA3ZJrMdxYOYUi/GG/q1lfxHW3tUgVkG41qVSJO7JW5GjpL+2yAH21h7CY=
X-Received: by 2002:a17:907:3607:b0:aa6:88f5:5fef with SMTP id
 a640c23a62f3a-aac2c9948d6mr45830866b.32.1734649985445; Thu, 19 Dec 2024
 15:13:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1734392473.git.ashish.kalra@amd.com> <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
 <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com> <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
In-Reply-To: <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 19 Dec 2024 15:12:54 -0800
X-Gm-Features: AbW1kvZoEAvkgy4KZcubE0kRWNzUwRqTCGcArrMk-RXVnif4_hRKzZpl9mHjKHc
Message-ID: <CAAH4kHYE6WQ3NXm9iwcf1FJo8SioZCU7iyU6=9omQ8YQb+czCA@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 2:04=E2=80=AFPM Kalra, Ashish <ashish.kalra@amd.com=
> wrote:
>
>
>
> On 12/18/2024 7:11 PM, Kalra, Ashish wrote:
> >
> > On 12/18/2024 1:10 PM, Sean Christopherson wrote:
> >> On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >>> On 12/17/2024 3:37 PM, Sean Christopherson wrote:
> >>>> On Tue, Dec 17, 2024, Ashish Kalra wrote:
> >>>>> On 12/17/2024 10:00 AM, Dionna Amalie Glaze wrote:
> >>>>>> On Mon, Dec 16, 2024 at 3:57=E2=80=AFPM Ashish Kalra <Ashish.Kalra=
@amd.com> wrote:
> >>>>>>>
> >>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>>>>
> >>>>>>> The on-demand SEV initialization support requires a fix in QEMU t=
o
> >>>>>>> remove check for SEV initialization to be done prior to launching
> >>>>>>> SEV/SEV-ES VMs.
> >>>>>>> NOTE: With the above fix for QEMU, older QEMU versions will be br=
oken
> >>>>>>> with respect to launching SEV/SEV-ES VMs with the newer kernel/KV=
M as
> >>>>>>> older QEMU versions require SEV initialization to be done before
> >>>>>>> launching SEV/SEV-ES VMs.
> >>>>>>>
> >>>>>>
> >>>>>> I don't think this is okay. I think you need to introduce a KVM
> >>>>>> capability to switch over to the new way of initializing SEV VMs a=
nd
> >>>>>> deprecate the old way so it doesn't need to be supported for any n=
ew
> >>>>>> additions to the interface.
> >>>>>>
> >>>>>
> >>>>> But that means KVM will need to support both mechanisms of doing SE=
V
> >>>>> initialization - during KVM module load time and the deferred/lazy
> >>>>> (on-demand) SEV INIT during VM launch.
> >>>>
> >>>> What's the QEMU change?  Dionna is right, we can't break userspace, =
but maybe
> >>>> there's an alternative to supporting both models.
> >>>
> >>> Here is the QEMU fix : (makes a SEV PLATFORM STATUS firmware call via=
 PSP
> >>> driver ioctl to check if SEV is in INIT state)
> >>>
> >>> diff --git a/target/i386/sev.c b/target/i386/sev.c
> >>> index 1a4eb1ada6..4fa8665395 100644
> >>> --- a/target/i386/sev.c
> >>> +++ b/target/i386/sev.c
> >>> @@ -1503,15 +1503,6 @@ static int sev_common_kvm_init(ConfidentialGue=
stSupport *cgs, Error **errp)
> >>>          }
> >>>      }
> >>>
> >>> -    if (sev_es_enabled() && !sev_snp_enabled()) {
> >>> -        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
> >>> -            error_setg(errp, "%s: guest policy requires SEV-ES, but =
"
> >>> -                         "host SEV-ES support unavailable",
> >>> -                         __func__);
> >>> -            return -1;
> >>> -        }
> >>> -    }
> >>
> >> Aside from breaking userspace, removing a sanity check is not a "fix".
> >
> > Actually this sanity check is not really required, if SEV INIT is not d=
one before
> > launching a SEV/SEV-ES VM, then LAUNCH_START will fail with invalid pla=
tform state
> > error as below:
> >
> > ...
> > qemu-system-x86_64: sev_launch_start: LAUNCH_START ret=3D1 fw_error=3D1=
 'Platform state is invalid'
> > ...
> >
> > So we can safely remove this check without causing a SEV/SEV-ES VM to b=
low up or something.
> >
> >>
> >> Can't we simply have the kernel do __sev_platform_init_locked() on-dem=
and for
> >> SEV_PLATFORM_STATUS?  The goal with lazy initialization is defer initi=
alization
> >> until it's necessary so that userspace can do firmware updates.  And i=
t's quite
> >> clearly necessary in this case, so...
> >
> > I don't think we want to do that, probably want to return "raw" status =
back to userspace,
> > if SEV INIT has not been done we probably need to return back that stat=
us, otherwise
> > it may break some other userspace tool.
> >
> > Now, looking at this qemu check we will always have issues launching SE=
V/SEV-ES VMs
> > with SEV INIT on demand as this check enforces SEV INIT to be done befo=
re launching
> > the VMs. And then this causes issues with SEV firmware hotloading as th=
e check
> > enforces SEV INIT before launching VMs and once SEV INIT is done we can=
't do
> > firmware  hotloading.
> >
> > But, i believe there is another alternative approach :
> >
> > - PSP driver can call SEV Shutdown right before calling DLFW_EX and the=
n do
> > a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX wi=
th
> > SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will also =
allow
> > us to do both SNP and SEV INIT at KVM module load time, there is no nee=
d to
> > do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.
> >
> > This approach should work without any changes in qemu and also allow
> > SEV firmware hotloading without having any concerns about SEV INIT stat=
e.
> >
>
> And to add here that SEV Shutdown will succeed with active SEV and SNP gu=
ests.
>
> SEV Shutdown (internally) marks all SEV asids as invalid and decommission=
 all
> SEV guests and does not affect SNP guests.
>
> So any active SEV guests will be implicitly shutdown and SNP guests will =
not be
> affected after SEV Shutdown right before doing SEV firmware hotloading an=
d
> calling DLFW_EX command.
>

Please don't implicitly shut down VMs. At least have a safe and unsafe
option for dlfw_ex where the default is to not destroy active
workloads.
That's why the 2022 patch series for Intel SGX EUPDATESVN on microcode
hotload was shot down.
It's very rude to destroy running workloads because a system update
was scheduled.

> It should be fine to expect that there are no active SEV guests or any ac=
tive
> SEV guests will be shutdown as part of SEV firmware hotloading while keep=
ing
> SNP guests running.
>
> Thanks,
> Ashish



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

