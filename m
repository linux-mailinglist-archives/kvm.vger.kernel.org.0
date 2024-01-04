Return-Path: <kvm+bounces-5615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC0B823B62
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 05:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79AA01F2635D
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 04:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CDE19454;
	Thu,  4 Jan 2024 04:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GzQ5b9VD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA6318EA8
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 04:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-556fc91aba9so145688a12.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 20:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704341673; x=1704946473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pa80zVp1sASVI0+tcUUmwCJc5L87w8VTMFw37Sr+KNE=;
        b=GzQ5b9VD49UGIw9NtmXRBUXjGbLNxpzkE4X1WMgfMCBd3ZOM1h1aSOK+taan/sF7w0
         QgC5Y6bK945sOnZ4x1w+h65gjOo/RoSZDw4bSnBGrt1TWwnHieRqpY/+tOfzG8lBKPJ1
         Bt4xsiRQb5EZu9W3juW5qaEj3ToOCt+ner1EvHTjQWYr9FzwZeXtCZQ5VpgqvOV62C3O
         rcu+Y5sOa+oaIFPg38TQfK1IeN/ntfARbuxDYZ2Ni15kZc+KwzR7Nw76wkqi1qnCziP+
         DX9rDHwRVArrpXtqnO5itXtKpUptq5y7LKuVsKBq6nsxGasyLEUvG3p6tpkiz3XNAUG4
         ecmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704341673; x=1704946473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pa80zVp1sASVI0+tcUUmwCJc5L87w8VTMFw37Sr+KNE=;
        b=DIdSl55CvHhcY3pTxKSc56peZXIUTGpL4gEQEW9+MUAvhykPoZfKFdX7og0zlyhRVO
         nQPq91vWdN/DNs8cDAgk9hzK7QePS2NcYD0hCdNN1zJBPXKzS9OKAIkNtvA3wrYFyVXY
         Xi7a4dqDqjkVXzMZEnIerScF5BcJiz+MLlV1ZV+nOx6VrhAMx0H47CVBXDdQdeOER/N9
         bNUwE1nfPfHAihNs20fveTS299yOeLqsMP/CqcruvG2uyfw/Min1NpcA92STkrwzQeYI
         BKaeQf19xy7magDXl7imUrwcdiC3BK3PVWVJ4KXpe1vMnR1t5+WGf+dUZdM7m08m4vjz
         DRlw==
X-Gm-Message-State: AOJu0Yxw615jtgGI1xDWxinrtTAvyKITvQSJdyAMo/dpMbwGPGMUtU+Q
	PnD3qeE8zi3wDzYtM8TgkHvEefMBN7FsVTgIkjaMMi1mO07zSw==
X-Google-Smtp-Source: AGHT+IGqbaB3cK0hkloRLbPE/fYexShynEkCdb1205ZffT+Cv5IQeIFVYZbKEH3BgEviTQDg3kpDQFwaCwE7g4yHJrk=
X-Received: by 2002:a17:907:2597:b0:a26:d607:86e2 with SMTP id
 ad23-20020a170907259700b00a26d60786e2mr6088788ejc.11.1704341673374; Wed, 03
 Jan 2024 20:14:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240103123959.46994-1-liangchen.linux@gmail.com> <ZZV8gz7wSCZCX0GZ@google.com>
In-Reply-To: <ZZV8gz7wSCZCX0GZ@google.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Thu, 4 Jan 2024 12:14:20 +0800
Message-ID: <CAKhg4tJA2TQ_1Zwv2N-PD7dsv_b5OW3Y5uRpnrR2ZOy-63Dsng@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: count number of zapped pages for tdp_mmu
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 11:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +David
>
> On Wed, Jan 03, 2024, Liang Chen wrote:
> > Count the number of zapped pages of tdp_mmu for vm stat.
>
> Why?  I don't necessarily disagree with the change, but it's also not obv=
ious
> that this information is all that useful for the TDP MMU, e.g. the pf_fix=
ed/taken
> stats largely capture the same information.
>

We are attempting to make zapping specific to a particular memory
slot, something like below.

void kvm_tdp_zap_pages_in_memslot(struct kvm *kvm, struct kvm_memory_slot *=
slot)
{
        struct kvm_mmu_page *root;
        bool shared =3D false;
        struct tdp_iter iter;

        gfn_t end =3D slot->base_gfn + slot->npages;
        gfn_t start =3D slot->base_gfn;

        write_lock(&kvm->mmu_lock);
        rcu_read_lock();

        for_each_tdp_mmu_root_yield_safe(kvm, root, false) {

                for_each_tdp_pte_min_level(iter, root,
root->role.level, start, end) {
                        if (tdp_mmu_iter_cond_resched(kvm, &iter, false, fa=
lse))
                                continue;

                        if (!is_shadow_present_pte(iter.old_spte))
                                continue;

                        tdp_mmu_set_spte(kvm, &iter, 0);
                }
        }

        kvm_flush_remote_tlbs(kvm);

        rcu_read_unlock();
        write_unlock(&kvm->mmu_lock);
}

I noticed that it was previously done to the legacy MMU, but
encountered some subtle issues with VFIO. I'm not sure if the issue is
still there with TDP_MMU. So we are trying to do more tests and
analyses before submitting a patch. This provides me a convenient way
to observe the number of pages being zapped.

> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 6cd4dd631a2f..7f8bc1329aac 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -325,6 +325,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_=
ptep_t pt, bool shared)
> >       int i;
> >
> >       trace_kvm_mmu_prepare_zap_page(sp);
> > +     ++kvm->stat.mmu_shadow_zapped;
>
> This isn't thread safe.  The TDP MMU can zap PTEs with mmu_lock held for =
read,
> i.e. this needs to be an atomic access.  And tdp_mmu_unlink_sp() or even
> tdp_unaccount_mmu_page() seems like a better fit for the stats update.
>

Yeah, that's an issue. Perhaps it isn't worth the effort to convert
mmu_shadow_zapped to atomic type or use any concurrency control means.
I will just add an attribute in debugfs to keep track of the number.

> >       tdp_mmu_unlink_sp(kvm, sp, shared);
> >
> > --
> > 2.40.1
> >

