Return-Path: <kvm+bounces-35883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46BF4A1598B
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43F887A13AE
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01A71D9A49;
	Fri, 17 Jan 2025 22:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V4lKqGhs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4751ABED9
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 22:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737153203; cv=none; b=toKgMbFgTCayfkp90lRp8rBVkAucnqPOzXGI/NwiJ+ThuIxfKtlIWEPGEdH32SDHVtPl3JmT1XYO7a9xVtzE9kJBk5AvqOcjFfiPPvncF8DyVplPZbS9xKybia44FCCg+42+Y0LwoReeeAK7S1vVGrG0vIY+x05eYhUxwgtV5B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737153203; c=relaxed/simple;
	bh=8dPksFh5VXAVNMi+UxcmeDpOQ6ZC1ztsdT0mQD4EGMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ud4g2LL19waFoGZ/NrKAlUX8unKpf38cp4FxK5e0L78oZyPSgKXdQka7OiAd8J0BlMKrNpgrCptdsRSZCZkW0tKHOT1xCWMnUSCTtBqrw951NuXfGS59d/LfCXCBr0rkScGR3kA09fibXK5TjgEmE6psEcIBHuO3v+bgsoikg2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V4lKqGhs; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-51873e55d27so1420671e0c.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 14:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737153201; x=1737758001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fKTj9aIUmokpqqvY/oubYzwNlvznMB4g7/PTWCPpA0=;
        b=V4lKqGhs3Pn/Yhs/UvUt60atyzHiUJDaYOJg2Pl8CfKTvSvNaKjiaMXan5ImcglYZk
         Y64iFBlpWSyW+qcDeGwo0cnpkfOEZFkaWdamlbLhNy5w049iPiJW6JOP/baBhmW2kyAZ
         Q0pucmoGB1NDyPNSJgXSd/XdaNmgEPw498ZHhN7VXsGs7sTDex/r1REaCcK+ndfzaDgO
         eVC5hCi8EKNiqel9YO3IC0rr3u95yFeCev0VdOD/f6f+KBsQnTgL/slF87zqeHYjHiZU
         Ss9XEowhMa1UZgdzibuU4Ml6EeaNunL3D8yfuXaYCmQBpdMpG6oBUAckLA2TvC9lBu4z
         zsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737153201; x=1737758001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fKTj9aIUmokpqqvY/oubYzwNlvznMB4g7/PTWCPpA0=;
        b=Qke2lHPTXeYgs48KLu3/03OWAXxoe17Q6DOZSf+Kb7gcLLD1DrbPqpqt3oWEWbfOGf
         wCSIGNlLgPtQoj3t1gu5ouP+hrummBXRnMIa3lDVef8HMVQRXu7/WOMCT60iuniN/y2C
         tTL67nr/anIWIJ8ayRqeFdwOa7x+vuM2aXXnexyPbEWhSYh/hEADo3sQTTTNfgSgLAVq
         1zjJ6fCcYjG/O+l4HrcGcAPUT6Nk1z5jBEo12FLU+eBA82zLNnbB72AMxmu3OnBNVvz8
         fDso6FXOOX7xUAMTAUCJqp4vxq/b/oPDzB+o+sMRslRLWYEk3me/QUj+e/Uutok4MS7Y
         LIug==
X-Forwarded-Encrypted: i=1; AJvYcCVoLVrwDhMssQNnqbMqAciSdcT9FI/SY8uTcoNhB4NQsdsW99sz3HpBoz4HoTM79uspqmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmkOmtzY2tcXbaBn/ins7aZI0Hg1hZHBEWs7+jEsxSA0SrxJ/j
	GjnwmIudfT+gWZAi6semS+Sw4PAhrTnvxAimPcKbbKaQqh/tpRLMw4PIxifE4y+WV9bMtpB++Dy
	IN7YnjKZJA56XEHfOs9JhP8Gg80GCmYpYVW7/
X-Gm-Gg: ASbGnctMTX071BNfY3MgpXzI0l+CsHY5U6BcCFA4uIyEZAhna9rCYb04iF59lyHBQ8D
	LIvusBSILdGDS/y0M3o9u9nMr9hzm4AsLYwbaZBI9gYQMVw2TOcuEnAZZlRxkdj/Y3VV/2e8=
X-Google-Smtp-Source: AGHT+IFAKm+OdVOTkTC0YGXGpgzeSyrbVTthBDgY9911y/g5Gq9IEucaPKu/P2O2oraInj6B28b+lL9lmrNrRHpKNLg=
X-Received: by 2002:a05:6122:3209:b0:50d:4b8d:6750 with SMTP id
 71dfb90a1353d-51d763558b9mr3856539e0c.1.1737153200930; Fri, 17 Jan 2025
 14:33:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240411140445.1038319-1-szy0127@sjtu.edu.cn> <20240411140445.1038319-3-szy0127@sjtu.edu.cn>
 <Z0-h73xBQgGuAI3H@google.com> <CAGdbjm+GmtYEQJsVspFC3_-5nx83qABDroPmyCHPebiKRt-4HQ@mail.gmail.com>
 <Z1DSgmzo3sX0gWY3@google.com> <CAGdbjm+jyG_V5auZD_MYtMd1j6NXDodTeH1kWGQFWmYRcA5aww@mail.gmail.com>
In-Reply-To: <CAGdbjm+jyG_V5auZD_MYtMd1j6NXDodTeH1kWGQFWmYRcA5aww@mail.gmail.com>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Fri, 17 Jan 2025 14:33:10 -0800
X-Gm-Features: AbW1kvZq4GpB1PF0BpSRrj-yyirvWtNmNhAhY9mAZGQdv9pO5JLC6qJ4sl1i43Y
Message-ID: <CAGdbjm+CHK68W-7SrEYg5sZe5H8ujQL+VPjPL4EM4pSkkqP1tA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] KVM: SVM: Flush cache only on CPUs running SEV guest
To: Sean Christopherson <seanjc@google.com>
Cc: Zheyun Shen <szy0127@sjtu.edu.cn>, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 3:56=E2=80=AFPM Kevin Loughlin <kevinloughlin@googl=
e.com> wrote:
>
> On Wed, Dec 4, 2024 at 2:07=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Dec 04, 2024, Kevin Loughlin wrote:
> > > On Tue, Dec 3, 2024 at 4:27=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > > @@ -2152,7 +2191,7 @@ void sev_vm_destroy(struct kvm *kvm)
> > > > >        * releasing the pages back to the system for use. CLFLUSH =
will
> > > > >        * not do this, so issue a WBINVD.
> > > > >        */
> > > > > -     wbinvd_on_all_cpus();
> > > > > +     sev_do_wbinvd(kvm);
> > > >
> > > > I am 99% certain this wbinvd_on_all_cpus() can simply be dropped.  =
sev_vm_destroy()
> > > > is called after KVM's mmu_notifier has been unregistered, which mea=
ns it's called
> > > > after kvm_mmu_notifier_release() =3D> kvm_arch_guest_memory_reclaim=
ed().
> > >
> > > I think we need a bit of rework before dropping it (which I propose w=
e
> > > do in a separate series), but let me know if there's a mistake in my
> > > reasoning here...
> > >
> > > Right now, sev_guest_memory_reclaimed() issues writebacks for SEV and
> > > SEV-ES guests but does *not* issue writebacks for SEV-SNP guests.
> > > Thus, I believe it's possible a SEV-SNP guest reaches sev_vm_destroy(=
)
> > > with dirty encrypted lines in processor caches. Because SME_COHERENT
> > > doesn't guarantee coherence across CPU-DMA interactions (d45829b351ee
> > > ("KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT
> > > CPUs")), it seems possible that the memory gets re-allocated for DMA,
> > > written back from an (unencrypted) DMA, and then corrupted when the
> > > dirty encrypted version gets written back over that, right?
> > >
> > > And potentially the same thing for why we can't yet drop the writebac=
k
> > > in sev_flush_encrypted_page() without a bit of rework?
> >
> > Argh, this last one probably does apply to SNP.  KVM requires SNP VMs t=
o be backed
> > with guest_memfd, and flushing for that memory is handled by sev_gmem_i=
nvalidate().
> > But the VMSA is kernel allocated and so needs to be flushed manually.  =
On the plus
> > side, the VMSA flush shouldn't use WB{NO}INVD unless things go sideways=
, so trying
> > to optimize that path isn't worth doing.
>
> Ah thanks, yes agreed for both (that dropping WB{NO}INVD is fine on
> the sev_vm_destroy() path given sev_gmem_invalidate() and that the
> sev_flush_encrypted_page() path still needs the WB{NO}INVD as a
> fallback for now).
>
> On that note, the WBINVD in sev_mem_enc_unregister_region() can be
> dropped too then, right? My understanding is that the host will
> instead do WB{NO}INVD for SEV(-ES) guests in
> sev_guest_memory_reclaimed(), and sev_gmem_invalidate() will handle
> SEV-SNP guests.

Nevermind, we can't drop the WBINVD call in
sev_mem_enc_unregister_region() without a userspace opt-in because
userspace might otherwise rely on the flushing behavior; see Sean's
explanation in [0].

So all-in-all I believe...

- we can drop the call in sev_vm_destroy()
- we *cannot* drop the call in sev_flush_encrypted_page(), nor in
sev_mem_enc_unregister_region().

Zheyun, if you get to this series before my own WBNOINVD series [1], I
can just rebase on top of yours. I will defer cutting these unneeded
calls to you and simply replace applicable WBINVD calls with WBNOINVD
in my series.

[0] https://lore.kernel.org/all/ZWrM622xUb4pe7gS@google.com/T/#md364d1fdfc6=
5dc92e306276bd51298cb817c5e53.
[1] https://lore.kernel.org/kvm/20250109225533.1841097-2-kevinloughlin@goog=
le.com/T/
>
> All in all, I now agree we can drop the unneeded case(s) of issuing
> WB{NO}INVDs in this series in an additional commit. I'll then rebase
> [0] on the latest version of this series and can also work on the
> migration optimizations atop all of it, if that works for you Sean.
>
> [0] https://lore.kernel.org/lkml/20241203005921.1119116-1-kevinloughlin@g=
oogle.com/
>
> Thanks!

