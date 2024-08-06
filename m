Return-Path: <kvm+bounces-23321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA92948B3F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACDAC284989
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D741BD4E3;
	Tue,  6 Aug 2024 08:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tYPRa2kB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8641BD015
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 08:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722932724; cv=none; b=OeuERWMOXx9Jefguy/o+D1kwmdgELYNngi/qX/kbTOaw9Xotcaimg4jian4Z7g/Ui+8qM1gxEdQxeXjapNH3D4EZ7kix14VNkMD6L6VCvkuuQEDKG7fBkEo1sJ2pyIY4rMWLYSQM62SfDFlWW4FFlkRswCCtu7F5FTzsZh1edvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722932724; c=relaxed/simple;
	bh=k7zHAEEEUxyRomVtvnM2viO2YFKTnrtBHjiLIBw6Z38=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uPxa1Rfo4eji1SFrkRo6dXGkZHseV29lvHoZEWrGVveaDwJ///2u6mZOvBOyM6sYKp4c0maqKuc/+4b/CRQKoVCWQ6JIR/bysCVz3lyTFg9XxD9vKHOKzhylP73TSjh/KDQCZXZd1fJIMl1m/TubaU2rxbPZiyImArmUhAJUaTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tYPRa2kB; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-428f5c0833bso11530885e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 01:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722932721; x=1723537521; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mJJmve+UBZqWHPzqvXAkYx9wHC1+4s/jebXaeWpKSm4=;
        b=tYPRa2kB2odRm+MJ+l681PUDuyo3bcqu/eESNFU6taVOoHz5LAYAbhSqCGA8033Jla
         RqREqsEUfdIM0PbEM4MqsH5VsBeZnroBOHpCPFBxo/IUuFxB86M1shxBXmpHfaNN6fKI
         PqnjUs/RJSgDq8LaSoYAWSuCfg97pnKHR2ZLa/kTQozXbSTxGgTM5Z+Dntypd0s0dWDr
         EpcTrBH0lcgsKJg92ZjF8X8uK6ir6HAW1qo2NPmqGAD0GCSrlZbs9SAt9ObiH3ezsV6T
         YfqlquUFL/j3pLhEP8GPsOzmlMJ49JAeNPFBT+ZPJYIsK0HBlIgIq6Xo3F7erZXDW3GR
         GNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722932721; x=1723537521;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJJmve+UBZqWHPzqvXAkYx9wHC1+4s/jebXaeWpKSm4=;
        b=Vm7TtjFuhznFDlAM/xA5/9gbWDbmZkeEB8P/KoMqEaEsfFD/f1geoTiTJbULPs2BDl
         gvX8PJRoaWviPD8D/JE7ItSTs9Q/9h8ZxMn/Z2gOJRZyywVRhZ7hEt8ozKuiA7ky871a
         YyLHSiaCXVqU5rEQujXzeaOvHYMxIWfUF5hxxhT1c/dEgcgADTQgy8pw2OewSwxYh0Tg
         etsITUkqtySsrqRN9iQnhMeaEdJY8oHRqNSRjLgpbZcvUd1se2F3f/OwdULYFYt4h4HU
         hFfO5aJx7tAcFWdJR+aOFpts62/x5tcgYPKGWXj515BJsvZF9PpwCoRMGxUgNnenVRvZ
         UE4A==
X-Forwarded-Encrypted: i=1; AJvYcCX8gPp0plvjqxJYU/bXggO/4G0WzNHo+pLYPRRZJMHhQ1aGU488Zhiaxor8TA5I8/4or3HdvyLm2NoajqpJN0n42UxO
X-Gm-Message-State: AOJu0YyJ6V6o8qzlQugAN/bswk6R9aEy8so7/t2cyOQ9M0Wl7BnnsfeV
	oXSe+wNuLWm1AdJ2rLDFuNpd2KCEE21jPV3jbOnU70ZAFQdHZO2i2geaOyYtvMRNYlWIBrGaPFQ
	jJfIWzHc6NmUhM+X5TgNsBNRWIhEk9FibVFfB
X-Google-Smtp-Source: AGHT+IEuJVBQVgvvzdKoA/IljQMVSQQCy4ILUfIi4PfR2IcPP3crNOUdNiIGa90I2U+SlhluocGZ2/3ZifLac4nEAJY=
X-Received: by 2002:a05:6000:1151:b0:362:2af4:43cc with SMTP id
 ffacd0b85a97d-36bbbe5be99mr9354068f8f.19.1722932721184; Tue, 06 Aug 2024
 01:25:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-55-seanjc@google.com>
 <ZrFfgzRbiqT-Zi2O@linux.dev>
In-Reply-To: <ZrFfgzRbiqT-Zi2O@linux.dev>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 6 Aug 2024 09:24:43 +0100
Message-ID: <CA+EHjTxZwDOeC94Y1otxcp-mcwUZA=TpQp4pav-E8Xvb2MA64Q@mail.gmail.com>
Subject: Re: [PATCH v12 54/84] KVM: arm64: Mark "struct page" pfns
 accessed/dirty before dropping mmu_lock
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 6 Aug 2024 at 00:26, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> [+cc Fuad]
>
> Fuad, you mentioned in commit 9c30fc615daa ("KVM: arm64: Move setting
> the page as dirty out of the critical section") that restructuring
> around the MMU lock was helpful for reuse (presumably for pKVM), but I
> lack the context there.

That was for some refactoring I'd done later on for mem_aborts in
pKVM. That said, I didn't know at the time that there might be a race
with some filesystems. I'll keep this in mind for the pKVM code we
have for now, and when upstreaming.

Thanks,
/fuad

> On Fri, Jul 26, 2024 at 04:52:03PM -0700, Sean Christopherson wrote:
> > Mark pages/folios accessed+dirty prior to dropping mmu_lock, as marking a
> > page/folio dirty after it has been written back can make some filesystems
> > unhappy (backing KVM guests will such filesystem files is uncommon, and
>
> typo: s/will/with/
>
> > the race is minuscule, hence the lack of complaints).  See the link below
> > for details.
> >
> > This will also allow converting arm64 to kvm_release_faultin_page(), which
> > requires that mmu_lock be held (for the aforementioned reason).
> >
> > Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 22ee37360c4e..ce13c3d884d5 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1685,15 +1685,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >       }
> >
> >  out_unlock:
> > +     if (writable && !ret)
> > +             kvm_set_pfn_dirty(pfn);
>
> I'm guessing you meant kvm_release_pfn_dirty() here, because this leaks
> a reference.
>
> > +     else
> > +             kvm_release_pfn_clean(pfn);
> > +
> >       read_unlock(&kvm->mmu_lock);
> >
> >       /* Mark the page dirty only if the fault is handled successfully */
> > -     if (writable && !ret) {
> > -             kvm_set_pfn_dirty(pfn);
> > +     if (writable && !ret)
> >               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > -     }
> >
> > -     kvm_release_pfn_clean(pfn);
> >       return ret != -EAGAIN ? ret : 0;
> >  }
> >
> > --
> > 2.46.0.rc1.232.g9752f9e123-goog
> >
>
> --
> Thanks,
> Oliver
>

