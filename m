Return-Path: <kvm+bounces-59758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 054E1BCBB0A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DC07B4EBD01
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 05:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF1B26B2CE;
	Fri, 10 Oct 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="KvTLIKr+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACAD846F
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 05:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760072700; cv=none; b=J0v0Z6/QyjdxQWVk1rtJ1vzCG7kjNgMXXsKP4GgaPts05sVtdiFhg9+BbFven8CShywzEthZwV5aHpdqqAEG0Y7gyY/WwQXvtUxyjDHLzj69v5WdH2+tCyOGEUVIa1T9t9oLOxhfjf7iy3K7vioo6oIaR7I7lifSIMNR2RHoZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760072700; c=relaxed/simple;
	bh=sukoUEmlpJBcoFi3ZztqJq8ZL1vfcHi/Rx4lZLvz17M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ojYDI2t3Yl4xPmZmkg803Y0KFhv6w4u1pbAseAIUxdbTFa4CQ5nUkB4Kiv3NT69lks++L0tbGAoz2GZiMyfr67oWH7jLonFxuAvoVRzN9h5F5/XYx9Hs/b0lvMmRMymoT7oC7uY+7pDjdwdSl9gYkpLbst96gQBrofLGv9WdWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=KvTLIKr+; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6317348fa4fso325605a12.3
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 22:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1760072697; x=1760677497; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iScQdiaQyWecO5SE+DhQzPQSyWeuSrlTEqA9Wi/oGaw=;
        b=KvTLIKr+ZBAW6mmRBrysi9UinyfBgA7ndLS2CdBsq51xNY/zgZ4lkIobZvNoKV82Du
         DjT2jeSw5ps4M/mmmxvQGGX0rYZyUiT1Qhb5rAxALeRIaB83Ymg5E4/n0AUZyb6kID+A
         u4IppYxC71w9jHYHFdO/IEQsOAlVlFbLPsMpk9vIt6FQK5dMCGei6jXBnYyEU1HyNYt1
         JnrPTcQMQ9xTIOUsrxmx5d5PrrUilImbyANwZcXaYp6+ADv5NuhXZQ0dAKfarUVc+S35
         aopUt1k7D7oTjETHTB3bciEb1dEsBwwVpJsiaDkPN4/NLvnb867fQzSafQpjd1ekhsem
         D7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760072697; x=1760677497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iScQdiaQyWecO5SE+DhQzPQSyWeuSrlTEqA9Wi/oGaw=;
        b=AHcOE+mqScgfvy7rOKP+dEH1IYvB+RJvRWquZbF17oulx2UuFakLL6QTISuMMKp5wr
         zm01czT//9fm9AnBwxe5olo8o6O6On2ZNmMTS+Qy983+Um4kA62rYDm4b+1o+Qdlt2Dy
         Cy/XzfuZO8wzBvL/HjjEqZWXfR8IaNLpR9JQdymyN6dJKnUv2YJn56pqkHU5rCL8pBT7
         G/f+0oCNeBgat0lkESQR0vatYgqARNzAAl/1DMtSUefO5YubSHgNCBGp0R4L1mU2RLMo
         yUZx/KCvMHpY3yFZ7FU+mhBTyp+WsLijBmrKKYZSUBwVfigWFXp8C2U/0qlF3v65L2VZ
         dD8w==
X-Forwarded-Encrypted: i=1; AJvYcCXqx/QOrZoKK/SoVzjYpwQVnmQFYvLSp2mAMIFFJKQFSdWyvgT3um/OwBm8QaQeO/PoKIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtmcoaTsC8lZBN3SII/GJuh5xQT/1MPMyQ0uO2FPisrrKNNRY+
	6zzUnj7Gmr6eOV9zEFOoGceyLNLtY1DKiC2Eaed5CNNTpJCj2B/XSIaplZshNSHa3FffJXn18J/
	98Xth/4sOyYznc2RI2w/VQEScQ0lwwh8hQomYxYRz0g==
X-Gm-Gg: ASbGncu2Hs9dXEkpdp2VXv6Hceik/55vkqMaWRuRn8Uv292pfcefujr4b13KCOC+dIa
	xRjtTgi3ejQibO8faqF9NlsWYbvtsIoZ6F0O/wnkhuFoQcUUJhax1hstGwbETusUir6QbLuhuYi
	Y3/vsuh4I5fGKEpCpkAIwRMTxHBCzrIY4MkYvOMraiVPd3tMcPHn6hzqh16yrfQ9iO51d22BdaF
	NW0C4jL8miOBM68cB3NkQUO7fDl8Jhxgx+/ln9gN5NYUt2H9NeZsc0nFzCrZwtcp2mktA==
X-Google-Smtp-Source: AGHT+IERUSfylrZKarOs8EjjKmpCpOqV6CeRfysHXEI+v+AULEwtabXhj5O899sDvcHO+ArzjLnJK++f8SEqcp+xTuI=
X-Received: by 2002:a05:6402:40c8:b0:637:e9f9:f6f9 with SMTP id
 4fb4d7f45d1cf-639d5c7d43dmr5013572a12.8.1760072696717; Thu, 09 Oct 2025
 22:04:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <539FC243.2070906@redhat.com> <20140617060500.GA20764@minantech.com>
 <FFEF5F78-D9E6-4333-BC1A-78076C132CBF@jnielsen.net> <6850B127-F16B-465F-BDDB-BA3F99B9E446@jnielsen.net>
 <jpgioafjtxb.fsf@redhat.com> <74412BDB-EF6F-4C20-84C8-C6EF3A25885C@jnielsen.net>
 <558AD1B0.5060200@redhat.com> <FAFB2BA9-E924-4E70-A84A-E5F2D97BC2F0@jnielsen.net>
 <CACzj_yVTyescyWBRuA3MMCC0Ymg7TKF-+sCW1N+Xwfffvw_Wsg@mail.gmail.com>
 <CAMGffE=P5HJkJxh2mj3c_oh6busFKYb0TGuhAc36toc5_uD72w@mail.gmail.com>
 <aOaJbHPBXHwxlC1S@google.com> <CAMGffEn1i-qTVRD+9PWDfNUMvbBCp9dV2f=Cgu=VLtoHs-6JTA@mail.gmail.com>
 <CAMGffEmt2ZEL3uxRd+mWkKB=K8Q3seo9Kp-T06rZahxsX4Wm4Q@mail.gmail.com>
 <CAMGffEmin4HAwoQUjkkoq+_z0sherZcCnkXgMu4PahnM8UmO+A@mail.gmail.com> <87bjmg8cev.fsf@redhat.com>
In-Reply-To: <87bjmg8cev.fsf@redhat.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 10 Oct 2025 07:04:45 +0200
X-Gm-Features: AS18NWCzlQ8AibAQgz3QLMk6UWm57XNE8eeW5_SNBVJHjH_LbN6QZFkCWWfK78E
Message-ID: <CAMGffEnAay3_StOKghL=yyayLzaFEnG5jR2o7FzujCOLHv8uLg@mail.gmail.com>
Subject: Re: Hang on reboot in multi-core FreeBSD guest on Linux KVM host with
 Intel Sierra Forest CPU
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, fanwenyi0529@gmail.com, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 2:53=E2=80=AFPM Vitaly Kuznetsov <vkuznets@redhat.co=
m> wrote:
>
> Jinpu Wang <jinpu.wang@ionos.com> writes:
>
> > On Thu, Oct 9, 2025 at 1:21=E2=80=AFPM Jinpu Wang <jinpu.wang@ionos.com=
> wrote:
> >>
> >> On Thu, Oct 9, 2025 at 5:44=E2=80=AFAM Jinpu Wang <jinpu.wang@ionos.co=
m> wrote:
> >> >
> >> > Hi Sean,
> >> >
> >> > On Wed, Oct 8, 2025 at 5:55=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> >> > >
> >> > > Trimmed Cc: to drop people from the original thread.  In the futur=
e, just start
> >> > > a new bug report.  Piggybacking a 10 year old bug just because the=
 symptoms are
> >> > > similar does more harm than good.  Whatever the old thread was cha=
sing was already
> >> > > fixed, _10 years_ ago; they were just trying to identy exactly wha=
t commit fixed
> >> > > the problem.  I.e. whatever they were chasing _can't_ be the same =
root cause,
> >> > > because even if it's literally the same code bug, it would require=
 a code change
> >> > > and thus a regression between v4.0 and v6.1.
> >> > Thx for the reply,  it makes sense. I will remember this next time.
> >> > >
> >> > > On Wed, Oct 08, 2025, Jinpu Wang wrote:
> >> > > > On Wed, Oct 8, 2025 at 2:44=E2=80=AFPM Jack Wang <jinpu.wang@ion=
os.com> wrote:
> >> > > > > Sorry for bump this old thread, we hit same issue on Intel Sie=
rra Forest
> >> > > > > machines with LTS kernel 6.1/6.12, maybe KVM comunity could he=
lp fix it.
> >> > >
> >> > > Are there any host kernels that _do_ work?  E.g. have you tried a =
bleeding edge
> >> > > host kernel?
> >> > I will try linus/master today.
> >> > >
> >> > > > > ### **[BUG] Hang on FreeBSD Guest Reboot under KVM on Intel Si=
erraForest (Xeon 6710E)**
> >> > > > >
> >> > > > > **Summary:**
> >> > > > > Multi-cores FreeBSD guests hang during reboot under KVM on sys=
tems with
> >> > > > > Intel(R) Xeon(R) 6710E (SierraForest). The issue is fully repr=
oducible with
> >> > > > > APICv enabled and disappears when disabling APICv (`enable_api=
cv=3DN`). The
> >> > > > > same configuration works correctly on Ice Lake (Xeon Gold 6338=
).
> >> > >
> >> > > Does Sierra Forest have IPI virtualization?  If so, you could try =
running with
> >> > > APICv enabled, but enable_ipiv=3Dfalse to specifically disable IPI=
 virtualization.
> >> > Yes, it does:
> >> > $  grep . /sys/module/kvm_intel/parameters/*
> >> > /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr:N
> >> > /sys/module/kvm_intel/parameters/dump_invalid_vmcs:N
> >> > /sys/module/kvm_intel/parameters/emulate_invalid_guest_state:Y
> >> > /sys/module/kvm_intel/parameters/enable_apicv:Y
> >> > /sys/module/kvm_intel/parameters/enable_ipiv:Y
> >> > /sys/module/kvm_intel/parameters/enable_shadow_vmcs:Y
> >> > /sys/module/kvm_intel/parameters/ept:Y
> >> > /sys/module/kvm_intel/parameters/eptad:Y
> >> > /sys/module/kvm_intel/parameters/error_on_inconsistent_vmcs_config:Y
> >> > /sys/module/kvm_intel/parameters/fasteoi:Y
> >> > /sys/module/kvm_intel/parameters/flexpriority:Y
> >> > /sys/module/kvm_intel/parameters/nested:Y
> >> > /sys/module/kvm_intel/parameters/nested_early_check:N
> >> > /sys/module/kvm_intel/parameters/ple_gap:128
> >> > /sys/module/kvm_intel/parameters/ple_window:4096
> >> > /sys/module/kvm_intel/parameters/ple_window_grow:2
> >> > /sys/module/kvm_intel/parameters/ple_window_max:4294967295
> >> > /sys/module/kvm_intel/parameters/ple_window_shrink:0
> >> > /sys/module/kvm_intel/parameters/pml:Y
> >> > /sys/module/kvm_intel/parameters/preemption_timer:Y
> >> > /sys/module/kvm_intel/parameters/sgx:N
> >> > /sys/module/kvm_intel/parameters/unrestricted_guest:Y
> >> > /sys/module/kvm_intel/parameters/vmentry_l1d_flush:not required
> >> > /sys/module/kvm_intel/parameters/vnmi:Y
> >> > /sys/module/kvm_intel/parameters/vpid:Y
> >> >
> >> > I tried to disable ipiv, but it doesn't help. freebsd hang on reboot=
.
> >> > sudo modprobe -r kvm_intel
> >> > sudo modprobe  kvm_intel enable_ipiv=3DN
> >> > /sys/module/kvm_intel/parameters/enable_ipiv:N
> >> >
> >> > Thx!
> >> +cc Vitaly
> >> Sorry, I missed one detail, we are use hyper-V enlightment features:
> >> "+hv-relaxed,+hv-vapic,+hv-time,+hv-runtime,hv-spinlocks=3D0x1fff,+hv-=
vpindex,+hv-synic,+hv-stimer,+hv-tlbflush,hv-ipi."
> >>
> >> did a lot tests with different features, and looks the hang is related
> >> to  +hv-synic,+hv-stimer.  hv-synic seems the key which causes boot
> >> hang of Freebsd 14.
> >>
> >> But the problem seems fixed with FreeBSD 15?  I guess it's this fix:
> > https://reviews.freebsd.org/D43508
> >
> >>
> >> Seems it's a bug from freebsd side, rather than on kvm side to me, but
> >> I'm puzzled by disable apicv helps?
>
> In theory, FreeBSD should work well even if KVM is misdetected as
> genuine Hyper-V. Apparently, our emulation is not 1:1 and there are
> subtle differences which cause the hang. I did not look at FreeBSD code
> at all but my wild guess is that SynIC/stimer are not disabled properly
> upon reboot and this causes the problem. If we somehow manage to find
> how genuine Hyper-V's behavior is different, it would make sense to
> update KVM/QEMU to match.
>
> --
> Vitaly
Hi Vitaly,
Thx for the reply, that's another view.
I spent a few hours to build freebsd stable/14 with commit
6744fd8e7503 ("x86/cpu: improve hypervisor detection") applied, the
bug is fixed, no boot hung, and boot is much faster ~ 40 seconds, as
Freebsd 15, without the fix Freebsd takes 150 seconds if sucessfully
boots, and often hang forever during reboot.

Jinpu
>

