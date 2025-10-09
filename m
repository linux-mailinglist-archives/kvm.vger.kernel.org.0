Return-Path: <kvm+bounces-59681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2FEBC750A
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 05:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 999064E4479
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 03:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9454323ED5E;
	Thu,  9 Oct 2025 03:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Y+mgxs1P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E523D7DE
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 03:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759981505; cv=none; b=QoTlnnDUVpHo2l7UTMeKV1l69aE6KWh4Kd7EgvQBZxWg+oFHrPhJshv2KGKlZDzekmK5ECyEL0Dd9KnOwEOedQ9ZEmHyLhKrW1y4z/HsBixQqe2t/U8DLBL39fSVjcxrm1xqRg11P3cd8h9ON4mXbt51waAJ34l5m/6csBxJYvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759981505; c=relaxed/simple;
	bh=DpanDiMZhUUk3zEffcPES+lkCNzRVL2bCq0yL2Hxy4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cIVDqNsEcmTA1E6TDc5LOCpgIQcHkkgKhG1fYUchxz1acmf4P8I+3YlVCm671HBANiutJ/jvGsbqqYQa1LJ8NE/JjuQOgxj3raojhNA1AnKQywZu31imuUDTkpyWbPx8OMWDVAhLb58zC4vjqMeOKaMzjF4DoneSZT0ExNvrqIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Y+mgxs1P; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3b1eac8460so10140066b.2
        for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 20:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1759981501; x=1760586301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgazUsX6nXA6fvwy3J8doaRtuDTiOUHYXTvWKBELRWc=;
        b=Y+mgxs1PvbaHI12kdKk3P8uUJ/6NNmQ5Ch0+iUauZf5TCAGlZd26rjFXLdaJ1rKAC8
         zDYJodsN8DGRQf4H3oc6VMygwI6yJTFOFryvupSkayfjmqNi5Knh78hyS8K+v0e+mXhG
         1tEN66N0gTtiMtyJGhriaiuDIiU1V9cuViHjkk9ebCWKmfWoREg0V6lhM2I9wdujsYRZ
         V7wje6WeLFwrXNgZ5SkFXPSV/wOLdp/CvIvKF5JWgovVoNcorZTkrKaCi5TmMKADfbms
         ZJDb68TiMgSvDb7HGX0C1uALQFLhS6ylpA6or3YQ4yuoehhgc5uHaGb4Pe4BTlSMSKG5
         CMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759981501; x=1760586301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgazUsX6nXA6fvwy3J8doaRtuDTiOUHYXTvWKBELRWc=;
        b=JQg5nqVkEobRf8GuXp3EPFEMbyrFTEBA96UIyyjZBiCK5jNqj+CDlm6uBiFDw3baqQ
         uWW9vBxxsBxUg57rk3wuITFmOuCKAjlsRifXD4fSts3LfCE6WglQy9NwHHwuEfBdaZAz
         GCMFj6wK1u2+w/YWCNQlxOkY1iaOARBIFHqTFeADdFzaNbpBCXUdvTyPUj3DrfYlDh5I
         MlrrOhbUPLPGLkZuULPnZJdTXSfTiJg8o3x5e2GFDhq2++gMLiceRZa2QMZH73N0iO3V
         AUYcZL554nnaV2dSHY6tI4K7FldDuKKjzERElF3RkZbKPi1QCjrt8dxMSiLZyiPxHZmG
         pUYw==
X-Forwarded-Encrypted: i=1; AJvYcCXEBgbt0++XxUQLEy8RqwT8Tfb9G+OAa5N2WjWfL83gPp7AlEskcZxhV7qdns2M9KzGSZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy1fSzROAvdQJMsUkmJDw9PsgZMvLLs9ZM2XA1rcemQMbqM55o
	UZf5hMR3rQ4Yo1d5JRPuCpKm7WCATYCMzQircYgDKJagD5ahKbQFkHIeqjnHS4NBjZjSh0pfCDT
	DoRKcp7+4isdJ+Vi77vy6G+B5l92jfJUjyo486cvwTQ==
X-Gm-Gg: ASbGncvzM2yQpldtZI94xKurS5FJKyTecWxD5eI3PMcY06gBTekKIlra75TI0ZXuts+
	qlZskS3A1cexAmONg3ZG/fGvM5E4zF9lk7UVfOFM91lyKa7V48C7EPhxIzY/WcobtTxhwtfLDlD
	A/O3IewkHHu5gEQr33sPyL2NvJZCq5Px51yQ6GFsZkLrLMkfa54N5T5hDqgjfTFuH1Wi1QcB3cl
	w1NSLFmxxbppXMBIWBjkOTCON89k74TwO1aeQDleSwJ3n6KPlUDfAhiUWLUJiwv
X-Google-Smtp-Source: AGHT+IEGMOeaML20pVvPWOqRJshHUFB5+UuoOYxfjuuPO1jO1YbLOUEBpmc8L6oAvnUEMyXSU/5qHk87oY7S0OQVRIE=
X-Received: by 2002:a05:6402:40c1:b0:638:e8af:35c7 with SMTP id
 4fb4d7f45d1cf-639d5b576b3mr2679243a12.2.1759981501601; Wed, 08 Oct 2025
 20:45:01 -0700 (PDT)
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
 <CAMGffE=P5HJkJxh2mj3c_oh6busFKYb0TGuhAc36toc5_uD72w@mail.gmail.com> <aOaJbHPBXHwxlC1S@google.com>
In-Reply-To: <aOaJbHPBXHwxlC1S@google.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 9 Oct 2025 05:44:50 +0200
X-Gm-Features: AS18NWDgOTqs4ewR-JWQBp9ELSSjrqsvDevjk_4T65q0Brc2iTIh5tMVCXtHLFE
Message-ID: <CAMGffEn1i-qTVRD+9PWDfNUMvbBCp9dV2f=Cgu=VLtoHs-6JTA@mail.gmail.com>
Subject: Re: Hang on reboot in multi-core FreeBSD guest on Linux KVM host with
 Intel Sierra Forest CPU
To: Sean Christopherson <seanjc@google.com>
Cc: fanwenyi0529@gmail.com, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Wed, Oct 8, 2025 at 5:55=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Trimmed Cc: to drop people from the original thread.  In the future, just=
 start
> a new bug report.  Piggybacking a 10 year old bug just because the sympto=
ms are
> similar does more harm than good.  Whatever the old thread was chasing wa=
s already
> fixed, _10 years_ ago; they were just trying to identy exactly what commi=
t fixed
> the problem.  I.e. whatever they were chasing _can't_ be the same root ca=
use,
> because even if it's literally the same code bug, it would require a code=
 change
> and thus a regression between v4.0 and v6.1.
Thx for the reply,  it makes sense. I will remember this next time.
>
> On Wed, Oct 08, 2025, Jinpu Wang wrote:
> > On Wed, Oct 8, 2025 at 2:44=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com>=
 wrote:
> > > Sorry for bump this old thread, we hit same issue on Intel Sierra For=
est
> > > machines with LTS kernel 6.1/6.12, maybe KVM comunity could help fix =
it.
>
> Are there any host kernels that _do_ work?  E.g. have you tried a bleedin=
g edge
> host kernel?
I will try linus/master today.
>
> > > ### **[BUG] Hang on FreeBSD Guest Reboot under KVM on Intel SierraFor=
est (Xeon 6710E)**
> > >
> > > **Summary:**
> > > Multi-cores FreeBSD guests hang during reboot under KVM on systems wi=
th
> > > Intel(R) Xeon(R) 6710E (SierraForest). The issue is fully reproducibl=
e with
> > > APICv enabled and disappears when disabling APICv (`enable_apicv=3DN`=
). The
> > > same configuration works correctly on Ice Lake (Xeon Gold 6338).
>
> Does Sierra Forest have IPI virtualization?  If so, you could try running=
 with
> APICv enabled, but enable_ipiv=3Dfalse to specifically disable IPI virtua=
lization.
Yes, it does:
$  grep . /sys/module/kvm_intel/parameters/*
/sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr:N
/sys/module/kvm_intel/parameters/dump_invalid_vmcs:N
/sys/module/kvm_intel/parameters/emulate_invalid_guest_state:Y
/sys/module/kvm_intel/parameters/enable_apicv:Y
/sys/module/kvm_intel/parameters/enable_ipiv:Y
/sys/module/kvm_intel/parameters/enable_shadow_vmcs:Y
/sys/module/kvm_intel/parameters/ept:Y
/sys/module/kvm_intel/parameters/eptad:Y
/sys/module/kvm_intel/parameters/error_on_inconsistent_vmcs_config:Y
/sys/module/kvm_intel/parameters/fasteoi:Y
/sys/module/kvm_intel/parameters/flexpriority:Y
/sys/module/kvm_intel/parameters/nested:Y
/sys/module/kvm_intel/parameters/nested_early_check:N
/sys/module/kvm_intel/parameters/ple_gap:128
/sys/module/kvm_intel/parameters/ple_window:4096
/sys/module/kvm_intel/parameters/ple_window_grow:2
/sys/module/kvm_intel/parameters/ple_window_max:4294967295
/sys/module/kvm_intel/parameters/ple_window_shrink:0
/sys/module/kvm_intel/parameters/pml:Y
/sys/module/kvm_intel/parameters/preemption_timer:Y
/sys/module/kvm_intel/parameters/sgx:N
/sys/module/kvm_intel/parameters/unrestricted_guest:Y
/sys/module/kvm_intel/parameters/vmentry_l1d_flush:not required
/sys/module/kvm_intel/parameters/vnmi:Y
/sys/module/kvm_intel/parameters/vpid:Y

I tried to disable ipiv, but it doesn't help. freebsd hang on reboot.
sudo modprobe -r kvm_intel
sudo modprobe  kvm_intel enable_ipiv=3DN
/sys/module/kvm_intel/parameters/enable_ipiv:N

Thx!

