Return-Path: <kvm+bounces-59703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E612BC8C38
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 13:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1137C4F879B
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 11:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9802DFF33;
	Thu,  9 Oct 2025 11:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="G+C2wxQs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1232D6E58
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 11:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760008925; cv=none; b=fkwlxOu9S7i6jUXkWIciruMAB+FiNsQhS2uYINJKXJweiWg8OtJOAbslUZCD9DjT7xHYovyUGHtA0ZdvR4vZHlwRuNqYBOACGDDcizyBdWPcoqYe7k/ZvVW1212LhL7stQIK25dPFrvKT/EAn69ZPexyE407Qfu+FtND6B++7IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760008925; c=relaxed/simple;
	bh=ErU4lw654VyAZDi7wVcxdHxruO1loqWA67S3hT4noSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vGc/63iQUCFlS6F4f4NM6FEALW7PSQnNTTYTnJb8sJKHP8wF0yIVxJrq876lz199XAXUPjZgP1RmfuO/6P/MuY8iugkZNYF4SXL+KVdUSitPu+98ZRxhxHrPoP0SD7dXuTklv9UmV8snRqWHkwfyDl/B0foBDFpK4XWlNWB7uqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=G+C2wxQs; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-634bd26a934so145791a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 04:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1760008921; x=1760613721; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfZE6iML9B9Ue3mbffKK3pISp/+/VS1P47NXc80zsa0=;
        b=G+C2wxQsDfDyQRIX+GI+gf9G0chVo4LeMLDMbB6NL98hVcIQy6CWxvZlUEnLkLWjKS
         JGZsTntp8yF5WT4vC/rlZBsV6iebyfKsXhgwC0g8u2JAO+eSIQhj5mfVhtFLRYwKUBzQ
         3WEn7xeBpjnP97VdKpW0fE0kK1box5YPuJGx6oELoi19fQgaNujVydUThWpr8/YY4uaa
         H4q4ps67cxD3Ym8BGQ6vHoq3yplLyLGyvqKMPjslP2pUkItgc5amg3Fcf86NZzYWjqfv
         I639yZ+sXeRv8dJ9st/uF93euJ7aS9O5loBGEr0UnZqPqV2xZvs1gG3ihuA8Zl671D5/
         AV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760008921; x=1760613721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfZE6iML9B9Ue3mbffKK3pISp/+/VS1P47NXc80zsa0=;
        b=n7BdpvGsMVgLyLBdU1KCkYxT9yqKQkhBFphVuZAf3aXItPZuoP/bZDkjk6d4melpHB
         ID6TKQb34QBqSCFXM62kSgf4GMZ4Q/rEqoRlcXGJujqqFuu+qboD9uKl3HJGGUZtyzKp
         4/9PBXNW6tca0Rhm++1x5e/2Gp+Kp5UKgEqI0/l9H/K/m4T5P4WIOzoduczyNUb6tKjJ
         BjGN/XDkrfrmpaPM88odOZxePBvd/uy8FthTZ46AGpDhMqT+UNqfRHS1JP7HmtsXWR8f
         DFJKy/T+lvLCxQ52pcOxFLb/mERwcF1LtBsRXCH76fsJcmRNlWUSYmbhRZAn9+jMcYs3
         VmGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFZcdbgTDyYeJSa/Ht9z5NJ0UMEX+8GCKj3FyKPsgW7ttjIwP/IHdNojBIyGsLzUEZVIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDTifHDB5O/flqG47G9vNCfhYZTRFwHTY4R9WiR9dawZyLdR5j
	XEzeQth7sZHB1k0acFmLgEvIVzclxLmV8cBVqjcfeOEANyvXc3MRP8cu5ShYz4vQyLZyhyOqcvH
	KaZ9ZHmP04kWMI5xVnGDfj2XoH8r4sceNl08zzAbQjg==
X-Gm-Gg: ASbGncvONsEgLtc/Smgh5J1WPja9w4RNBgBs4sdYQxTdUiSj/4ZrQd8Ea6Ln0Wcmq34
	8S0Qcw7H87lPzE+Urt6AlD1IcyP7ZJNwK3bGci1CFtkaN0kPIOwBkrreejcCo/BshCeyK0dCZ9C
	7wJFzja4itcsQCV8HIt8YfpCKBSjJpV3FWWrQDL2sC5DByZdAPqZYls5pdVuy0h/YJfjPjeJDE4
	2wUGGAiV0uMtn1LguNYTv3YU9uJSOs5Ge68Imj6nbx8mIgVskW0tgbHsFDYPov6
X-Google-Smtp-Source: AGHT+IEWtg6iCIgXsSapKkzgukSJTm4yJYAvEW+SFKlLEkSV8dVJEuv+31I22UcncTcGrxnBi575UEtN45DwJxtGA14=
X-Received: by 2002:a05:6402:2399:b0:639:dbe7:37e6 with SMTP id
 4fb4d7f45d1cf-639dbe73bcbmr2270471a12.2.1760008921446; Thu, 09 Oct 2025
 04:22:01 -0700 (PDT)
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
In-Reply-To: <CAMGffEn1i-qTVRD+9PWDfNUMvbBCp9dV2f=Cgu=VLtoHs-6JTA@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 9 Oct 2025 13:21:50 +0200
X-Gm-Features: AS18NWARL_xe63diYACbpaNo_4POMqNwxhtIptV6jbjGnAzTswFEutdQTgn79zI
Message-ID: <CAMGffEmt2ZEL3uxRd+mWkKB=K8Q3seo9Kp-T06rZahxsX4Wm4Q@mail.gmail.com>
Subject: Re: Hang on reboot in multi-core FreeBSD guest on Linux KVM host with
 Intel Sierra Forest CPU
To: Sean Christopherson <seanjc@google.com>
Cc: fanwenyi0529@gmail.com, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org, 
	vkuznets@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 5:44=E2=80=AFAM Jinpu Wang <jinpu.wang@ionos.com> wr=
ote:
>
> Hi Sean,
>
> On Wed, Oct 8, 2025 at 5:55=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Trimmed Cc: to drop people from the original thread.  In the future, ju=
st start
> > a new bug report.  Piggybacking a 10 year old bug just because the symp=
toms are
> > similar does more harm than good.  Whatever the old thread was chasing =
was already
> > fixed, _10 years_ ago; they were just trying to identy exactly what com=
mit fixed
> > the problem.  I.e. whatever they were chasing _can't_ be the same root =
cause,
> > because even if it's literally the same code bug, it would require a co=
de change
> > and thus a regression between v4.0 and v6.1.
> Thx for the reply,  it makes sense. I will remember this next time.
> >
> > On Wed, Oct 08, 2025, Jinpu Wang wrote:
> > > On Wed, Oct 8, 2025 at 2:44=E2=80=AFPM Jack Wang <jinpu.wang@ionos.co=
m> wrote:
> > > > Sorry for bump this old thread, we hit same issue on Intel Sierra F=
orest
> > > > machines with LTS kernel 6.1/6.12, maybe KVM comunity could help fi=
x it.
> >
> > Are there any host kernels that _do_ work?  E.g. have you tried a bleed=
ing edge
> > host kernel?
> I will try linus/master today.
> >
> > > > ### **[BUG] Hang on FreeBSD Guest Reboot under KVM on Intel SierraF=
orest (Xeon 6710E)**
> > > >
> > > > **Summary:**
> > > > Multi-cores FreeBSD guests hang during reboot under KVM on systems =
with
> > > > Intel(R) Xeon(R) 6710E (SierraForest). The issue is fully reproduci=
ble with
> > > > APICv enabled and disappears when disabling APICv (`enable_apicv=3D=
N`). The
> > > > same configuration works correctly on Ice Lake (Xeon Gold 6338).
> >
> > Does Sierra Forest have IPI virtualization?  If so, you could try runni=
ng with
> > APICv enabled, but enable_ipiv=3Dfalse to specifically disable IPI virt=
ualization.
> Yes, it does:
> $  grep . /sys/module/kvm_intel/parameters/*
> /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr:N
> /sys/module/kvm_intel/parameters/dump_invalid_vmcs:N
> /sys/module/kvm_intel/parameters/emulate_invalid_guest_state:Y
> /sys/module/kvm_intel/parameters/enable_apicv:Y
> /sys/module/kvm_intel/parameters/enable_ipiv:Y
> /sys/module/kvm_intel/parameters/enable_shadow_vmcs:Y
> /sys/module/kvm_intel/parameters/ept:Y
> /sys/module/kvm_intel/parameters/eptad:Y
> /sys/module/kvm_intel/parameters/error_on_inconsistent_vmcs_config:Y
> /sys/module/kvm_intel/parameters/fasteoi:Y
> /sys/module/kvm_intel/parameters/flexpriority:Y
> /sys/module/kvm_intel/parameters/nested:Y
> /sys/module/kvm_intel/parameters/nested_early_check:N
> /sys/module/kvm_intel/parameters/ple_gap:128
> /sys/module/kvm_intel/parameters/ple_window:4096
> /sys/module/kvm_intel/parameters/ple_window_grow:2
> /sys/module/kvm_intel/parameters/ple_window_max:4294967295
> /sys/module/kvm_intel/parameters/ple_window_shrink:0
> /sys/module/kvm_intel/parameters/pml:Y
> /sys/module/kvm_intel/parameters/preemption_timer:Y
> /sys/module/kvm_intel/parameters/sgx:N
> /sys/module/kvm_intel/parameters/unrestricted_guest:Y
> /sys/module/kvm_intel/parameters/vmentry_l1d_flush:not required
> /sys/module/kvm_intel/parameters/vnmi:Y
> /sys/module/kvm_intel/parameters/vpid:Y
>
> I tried to disable ipiv, but it doesn't help. freebsd hang on reboot.
> sudo modprobe -r kvm_intel
> sudo modprobe  kvm_intel enable_ipiv=3DN
> /sys/module/kvm_intel/parameters/enable_ipiv:N
>
> Thx!
+cc Vitaly
Sorry, I missed one detail, we are use hyper-V enlightment features:
"+hv-relaxed,+hv-vapic,+hv-time,+hv-runtime,hv-spinlocks=3D0x1fff,+hv-vpind=
ex,+hv-synic,+hv-stimer,+hv-tlbflush,hv-ipi."

did a lot tests with different features, and looks the hang is related
to  +hv-synic,+hv-stimer.  hv-synic seems the key which causes boot
hang of Freebsd 14.

But the problem seems fixed with FreeBSD 15?  I guess it's this fix:
https://github.com/systemd/systemd/issues/28001

Seems it's a bug from freebsd side, rather than on kvm side to me, but
I'm puzzled by disable apicv helps?

Thx!

