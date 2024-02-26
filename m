Return-Path: <kvm+bounces-9958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E31F867FEB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:39:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF3B41F25AE2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA27012EBE8;
	Mon, 26 Feb 2024 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s9GyUYEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7E01E500
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708972763; cv=none; b=diQd5Vj2cI7IpIGinmIcgPBsULptm5bCSQEgdpjToWMwhxRiOrfCdruf5EspVXiMIhlJ9hKr9RVhbXOsSawk73aLYEj839l87WRpEERDuiy2eo2QdGn3ldL5Vx/GY8rQ4vMR5a2qE1vkzPLOp0MRpfpyRvtVinUOjyYTvI59TnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708972763; c=relaxed/simple;
	bh=gs/FzsEiJZfJd8QE8n9+L+e5mLQcXVpJxk1gMIJOmQA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Twee6jgHc4TbrFgGKWWSI6Y7ISa1bbLPAUwyU6LSqZL4OFaHyJBhzDMn1szPK8nCLlbn2nXCn3pw44NcyqLoAJKL60XX8n069fJavszM9AWDXgTHr9tILdotYAqWI9dfgnshKGevEGQz7OINpbaxYMMxmzwolJdMcJfkGcXEgzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s9GyUYEo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5efe82b835fso66787317b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 10:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708972761; x=1709577561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SLbLVcdqhNcaIUlfiXVe1bY8Ut+IvQsXIOAAJ+eMeLQ=;
        b=s9GyUYEo72FYlEl2QNs5jJAumgBGOLJOYgCFi8GlZF6W44dNgwisKCEep6NcxcytPh
         ZKFsgUpBqXN9GinTH3QhFG8Uk2HORZiaKYsCxKZs20ChMkNcFXEd4wsulQJy2JK8bARA
         2ktidZ3JGeo8265PqsMj2JD30rxktDRXyjholKENmFWmhayp4vuNMyN/hyr6oLNooKwq
         ZuXL9Rgc6neZHiZy5HpYnu/doGM/JNiEsdwbDOjkgVx73RbqwVFp5pVhNBpzGjYteQ3B
         y5cGtFmzJ2Uh2YS2nb138IC7Qz+Q9AAnPxI2dRObsULKDbp6kcoQ56wocH7dipI+f2RR
         hsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708972761; x=1709577561;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SLbLVcdqhNcaIUlfiXVe1bY8Ut+IvQsXIOAAJ+eMeLQ=;
        b=Q8ocsZcI/LrIppTGDANuiTeBZBoQ20p69UDKMarb/ModCx3aNLbwREJFFh9ys/duzc
         kErjDF/ZUorHQVUBB/QH3c2dn94idAUGiSlrJod15W3xJFmlPXQTcmRWf4ATNS9i3mVY
         /mBYsHVb6f0JvEUgY3+cCALmgYYzYWbv3JvUAwuTU+QvWqKn7zCmWB4K373//VP1SG3V
         GyKT7G86AT7P4Wjdb0b6UktmsoyWDKHh/FyCHp7plN0onft1xnGY03Hco6wI8ac0p+bd
         YwAkAmTRLLEexeCiGhgCey2VegiVU4im7v8o9cNgwqtxBRkn3h2YoicZi7HCHRQr9RV+
         bAZg==
X-Forwarded-Encrypted: i=1; AJvYcCXfSCWAdK+09jIDLQNssm6aEbFfjUn4xdsGahqSoitK0XkfY6RGYsNBqP4XvOehNMwhC3nWZ0bD2dMVHqrWLmNDrXuz
X-Gm-Message-State: AOJu0Yzka4UrVOBxcpWHJUsVnviS4yPudTXbd0JvL0jDBS+2O2lqEkUB
	fmzAN/YX/gshY+CFoSBmamUMXeKcJQUC8ivUhDc5Jv5Q3q0zFujWX8g2wPHY8Bzu0BZ4cApQctd
	o8w==
X-Google-Smtp-Source: AGHT+IGCThJQCfs7KDv+Xut3WTHl2kJbZYnP3+aS3gnJmsKwwJWxJXDJIJte5MMSdzV66oyvp4V8QZqAJXQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:524c:0:b0:608:e4fc:aada with SMTP id
 g73-20020a81524c000000b00608e4fcaadamr1335722ywb.8.1708972761409; Mon, 26 Feb
 2024 10:39:21 -0800 (PST)
Date: Mon, 26 Feb 2024 10:39:19 -0800
In-Reply-To: <20240226180626.GE177224@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <cce34006a4db0e1995ce007c917f834b117b12af.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfbZRO3yiXoHAoHSsBp4sKQY9r4GTLt-SRqevz2c8wOqbQ@mail.gmail.com> <20240226180626.GE177224@ls.amr.corp.intel.com>
Message-ID: <Zdza1xJNlvhl8OZb@google.com>
Subject: Re: [PATCH v18 044/121] KVM: x86/mmu: Assume guest MMIOs are shared
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, erdemaktas@google.com, 
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, 
	hang.yuan@intel.com, tina.zhang@intel.com, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024, Isaku Yamahata wrote:
> On Mon, Feb 12, 2024 at 11:29:51AM +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> > On Tue, Jan 23, 2024 at 12:55=E2=80=AFAM <isaku.yamahata@intel.com> wro=
te:
> > >
> > > From: Chao Gao <chao.gao@intel.com>
> > >
> > > Guest TD doesn't necessarily invoke MAP_GPA to convert the virtual MM=
IO
> > > range to shared before accessing it.  When TD tries to access the vir=
tual
> > > device's MMIO as shared, an EPT violation is raised first.
> > > kvm_mem_is_private() checks whether the GFN is shared or private.  If
> > > MAP_GPA is not called for the GPA, KVM thinks the GPA is private and
> > > refuses shared access, and doesn't set up shared EPT entry.  The gues=
t
> > > can't make progress.
> > >
> > > Instead of requiring the guest to invoke MAP_GPA for regions of virtu=
al
> > > MMIOs assume regions of virtual MMIOs are shared in KVM as well (i.e.=
, GPAs
> > > either have no kvm_memory_slot or are backed by host MMIOs). So that =
guests
> > > can access those MMIO regions.
> >=20
> > I'm not sure how the patch below deals with host MMIOs?
>=20
> It falls back to shared case to hit KVM_PFN_NOSLOT. It will be handled as
> MMIO.
>=20
> Anyway I found it breaks SW_PROTECTED case.  So I came up with the follow=
ing.
> I think we'd like to handle as
>   - SW_PROTECTED =3D> KVM_EXIT_MEMORY_FAULT
>   - SNP, TDX =3D> MMIO.
>  =20

FFS.  Stop lobbing patch bombs and start having actual conversations.

Seriously, the whole point of using mailing lists is to have *discussions* =
and
to coordinate development.  Throwing patches at kvm@ and then walking away =
DOES
NOT WORK.

Putting a "TODO: Drop this patch once the common patch is merged." in the
changelog[1] is not helpful.

Dropping a proposed common uAPI[2] into a 121 patch series without even *ac=
knowledging*
that you received the message DOES NOT WORK.  You didn't even add a Suggest=
ed-by
or Cc: the people who expressed interest.  I can't read minds, and AFAIK no=
 one
else working on KVM is a telepath either.

I do not know to make it any clearer: for TDX support to go anywhere, there=
 needs
to be a _lot_ more communication.

[1] https://lore.kernel.org/all/b2e5c92fd66a0113b472dd602220346d3d435732.17=
08933498.git.isaku.yamahata@intel.com
[2] https://lore.kernel.org/all/8b7380f1b02f8e3995f18bebb085e43165d5d682.17=
08933498.git.isaku.yamahata@intel.com

> -       if (fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->g=
fn)) {
> +       /*
> +        * !fault->slot means MMIO for SNP and TDX.  Don't require explic=
it GPA
> +        * conversion for MMIO because MMIO is assigned at the boot time.=
  Fall
> +        * to !is_private case to get pfn =3D KVM_PFN_NOSLOT.
> +        */
> +       force_mmio =3D !slot &&

NAK, this already got shot down.

https://lore.kernel.org/all/ZcUO5sFEAIH68JIA@google.com

> +               vcpu->kvm->arch.vm_type !=3D KVM_X86_DEFAULT_VM &&
> +               vcpu->kvm->arch.vm_type !=3D KVM_X86_SW_PROTECTED_VM;
> +       if (!force_mmio &&
> +           fault->is_private !=3D kvm_mem_is_private(vcpu->kvm, fault->g=
fn)) {
>                 kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>                 return -EFAULT;
>         }
> =20
> -       if (fault->is_private)
> +       if (!force_mmio && fault->is_private)
>                 return kvm_faultin_pfn_private(vcpu, fault);
>=20
> --=20
> Isaku Yamahata <isaku.yamahata@linux.intel.com>

