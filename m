Return-Path: <kvm+bounces-56742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3764EB4325C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BE067B9887
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5847426CE37;
	Thu,  4 Sep 2025 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="Vzl3F4bU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E8265284
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756967078; cv=none; b=uh3/tGW3AzVN1G09SC5jPK56E1Q0DH81vpWGg7q4KhVLSR9moI8WDdm/2O7zYKcGLQn/m9NQuUjnOcFgdaagyqAjMOWC/2jBrENYkL6YgpD2Wff71KnEtUHyRasZoz6mZTXoII5QC/oieWpMr9uZngpKBEn5GDDUr8fBrh8PtGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756967078; c=relaxed/simple;
	bh=LvqlNJOB/Ojq07ZIUiyWSozLdIuF8+1QdzHpWK2mEnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S94Fqro5oPiT+4mUFx4i26EQc7Rss9hiYxwol4/Z5/sCQBNB8tFnaISDQjrGghha4GFQVH4QcnG6OBS1/SwV8x2LVVc7IAR0oShi0hnPxw2U5LwQbEIOy1TXnhkywvNd4rCco8gRjSo+AhFUEgrJJXf24sywlxprcMZ2SXYaUsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=Vzl3F4bU; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so1302291a12.0
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756967075; x=1757571875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7qTV76ULDduJGVAW5YsdUFJhj9UbsymbqAIaKqb9Ys=;
        b=Vzl3F4bUO3BAeSqcpf2xjVAms48+M4wOsasIPxWQAmjsyLtpdze8jvlyN8xUX4xCei
         2G2b78d2dxBrx8mOJeiUcS7H2QU4k1s2V3ERX6aOfm1KyH+9O4c4f4i4/zauS/bFK3DW
         fBUX0/Nb8q6PQwGvJlCru8NDugncXCWxhna+T077hoNGn8iGVK5mCRcsYCoxxaOizkHZ
         1HPcviPDlL0FKt6C4h+4cubDclQ8JeVugC12o8/9jRzxD+uwxnssuy3OcfbS9ouD08pj
         nZ56nKALdaLHAZ/ltCRw/yKyMGjc9QdRNFHv1hjbLTVAFaZNqG1LyI4sJ+3VXp/HfHe8
         NLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967075; x=1757571875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7qTV76ULDduJGVAW5YsdUFJhj9UbsymbqAIaKqb9Ys=;
        b=T8Qvq6rq+vgtRAd414g1wwC1Wh1APQB1yGM4G6QoSBFLwMQoT5Kc9R90YhtgOUXlG1
         57/KZcKK5rjc7r9Eq6ceU0G0IFYwTcXQxbol0Csei/MJzTj8gjBmXoIGlrPCQlzoVPnk
         GFIf4AYUY/VQnUKVy2psq52pgV6halVtoYljIobLnT02AjP8Rd3bJZ5K4n+p2HcZhJ6O
         fEt+iFKAXNpdfdhRCjdzf0aGJ9ikECxARH/HCss9txwcdHR9D5Xrq76oO4dI1L09MBG0
         jDp6o3OVh/dBZAowo9ox3rqU9O7C5MhjtY18rk/3p45Tyv3GJXbBWr+7btJjXNFRugXe
         kFMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA4YOXVp5NwG2pJQSVR1u9qcH+XxJbwnVZdgWyygEdj5W3aIBrSzMb/mGggMyKJatAEnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDUDYp9PpBOj2QKrdvp2YQ3KS/4cnkcPEPgStPfyRP3VlyM+zy
	ac2p/P1DAvQivWbwHniSfisK7g69OyhBOnAv3dt1Ly+ku//WI/W78oZggVEFaqvPN+9LgCJ2Jvp
	hWIZYgZ09s1P2iF5yQHQudF4Z9M0pWgHZJH7vbPEU3A==
X-Gm-Gg: ASbGncuGTjFVl1IqfgVdeiUp6sWx+/2nyJBrCWvXkZFQRp48BMFJ4nO0sQT1AXT3/+h
	GOHDIGn8rT1FRxkmRxdDxWGyydc8kxxTrc7D4HHla2r3xV/Ct5vsTaW5ZQKHPHa9MtijQ9AD96K
	0mubZheNI1WbxUVsjgxbw0BVYSZiOfz8mCva5cWnzwfSQGVMVNlqPWV62w2k9Ovy+Ux4cllRHbh
	/m7Isvogo335aZNx7w1
X-Google-Smtp-Source: AGHT+IHoFdxbuDjv07lVFMl22mnM/aIaMh25mvdbBCgh16ExZRzUOIBxo9SxO6MD4xOcEcTHtD3JYnMx67qXTku5mb0=
X-Received: by 2002:a17:902:d50c:b0:248:a642:eeeb with SMTP id
 d9443c01a7336-2493ef4dc88mr252425775ad.15.1756967075366; Wed, 03 Sep 2025
 23:24:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
 <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com> <aLIR3deQPxVI2VrE@google.com>
In-Reply-To: <aLIR3deQPxVI2VrE@google.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Wed, 3 Sep 2025 23:24:24 -0700
X-Gm-Features: Ac12FXyqcoq544W7rcjvkJ9YZPU7FqUqKJEMd-35Lr5ym4GwFkYYv0iByho1HQ4
Message-ID: <CAHBxVyHFkNtFdX-vciPvYnTOH=GXvHVW7hjFrLA4MFr9wqWVvQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/9] KVM: Add a helper function to check if a gpa is in
 writable memselot
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 29, 2025 at 1:47=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Aug 29, 2025, Atish Patra wrote:
> > The arch specific code may need to know if a particular gpa is valid an=
d
> > writable for the shared memory between the host and the guest. Currentl=
y,
> > there are few places where it is used in RISC-V implementation. Given t=
he
> > nature of the function it may be used for other architectures.
> > Hence, a common helper function is added.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> >  include/linux/kvm_host.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 15656b7fba6c..eec5cbbcb4b3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1892,6 +1892,14 @@ static inline bool kvm_is_gpa_in_memslot(struct =
kvm *kvm, gpa_t gpa)
> >       return !kvm_is_error_hva(hva);
> >  }
> >
> > +static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm, gpa=
_t gpa)
> > +{
> > +     bool writable;
> > +     unsigned long hva =3D gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &writ=
able);
> > +
> > +     return !kvm_is_error_hva(hva) && writable;
>
> I don't hate this API, but I don't love it either.  Because knowing that =
the
> _memslot_ is writable doesn't mean all that much.  E.g. in this usage:
>
>         hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &writ=
able);
>         if (kvm_is_error_hva(hva) || !writable)
>                 return SBI_ERR_INVALID_ADDRESS;
>
>         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_=
sta));
>         if (ret)
>                 return SBI_ERR_FAILURE;
>
> the error code returned to the guest will be different if the memslot is =
read-only
> versus if the VMA is read-only (or not even mapped!).  Unless every read-=
only
> memslot is explicitly communicated as such to the guest, I don't see how =
the guest
> can *know* that a memslot is read-only, so returning INVALID_ADDRESS in t=
hat case
> but not when the underlying VMA isn't writable seems odd.
>
> It's also entirely possible the memslot could be replaced with a read-onl=
y memslot
> after the check, or vice versa, i.e. become writable after being rejected=
.  Is it
> *really* a problem to return FAILURE if the guest attempts to setup steal=
-time in
> a read-only memslot?  I.e. why not do this and call it good?
>

Reposting the response as gmail converted my previous response as
html. Sorry for the spam.

From a functionality pov, that should be fine. However, we have
explicit error conditions for read only memory defined in the SBI STA
specification[1].
Technically, we will violate the spec if we return FAILURE instead of
INVALID_ADDRESS for read only memslot.

TBH, I don't save much duplicate code with the new generic API now.
If you don't see if the generic API will be useful in other cases, I
can drop that patch and changes in the steal time code.

[1] https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-stea=
l-time.adoc#table_sta_steal_time_set_shmem_errors
>         if (!kvm_is_gpa_in_memslot(vcpu->kvm, shmem >> PAGE_SHIFT))
>                 return SBI_ERR_INVALID_ADDRESS;
>
>         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zero_=
sta));
>         if (ret)
>                 return SBI_ERR_FAILURE;

