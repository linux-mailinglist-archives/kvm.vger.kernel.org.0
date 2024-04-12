Return-Path: <kvm+bounces-14545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 587E08A335D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 18:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B9301C23B6D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29781494AC;
	Fri, 12 Apr 2024 16:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igQKvmAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0F1487F6
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712938382; cv=none; b=A1N+OVGFFPokYAGzYQDiG+HmN3Z7ghdo6lkudoS246D0tIqF7wvM1pcDo9PiK/MUA8YIhifExbKgXd2qYoz4mZGyb66lSyhYaBXmGn8IKNd6NqVKe/MG7eB/01wEGHCMdQw5NXqiXkrKLSL+wkMiA1AxfolDXA7G1w73A3yE4yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712938382; c=relaxed/simple;
	bh=JUAb3dDy1N/9Q0YxYcJFUW6DkcDpSJqxaRJJn6vMMAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A8PQXl/mvkgGHzJrIZK+xJ4JeM2kQlV3GWJ6qmYWopqKsmnCEb9HHrhXQ2jsHfoKXwxh0rh0W19TC0U5vPabkWpILAJX1b5jbHu+lIEbUNDCPJOrJVOxkvhZraeSlMgSLjCDiwPTc1xAvGSNO1lgPPD0T8wECF0Sa5XZlCV/Ufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=igQKvmAg; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-34665dd7744so774874f8f.1
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 09:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712938379; x=1713543179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oek0e1IBHpQeCv1bDHie33lhT/ah3GHCrkshzPUX0sY=;
        b=igQKvmAg6GozJO1XKE3H31zK3o3Y7qHuvTz7NVxEPXpEsHishzP+qFZu77vQwZwkqH
         lm66WqVQsHlqcghK2S+vccANHbAxkFs4F24R/qVHp1JKZIOathCKfKVoxrEKmqRmpNvu
         LIogKc3M/IqYY4SJ+Y2GK1H3mxamvCao/0KkZmHmnjmhlIz2fhnPWMGtCcf7mFm9E85p
         FzhqhCpH4nbQ6VpxFeGAB/KxGjmkAHcyHiNXZ0qkMx0bel2zhJ4JKw7Vr3XBPlRYNPhH
         HKm6LjXhZs3FDmXGpKkNsahapyuZyutiSlH7kk5yYiNbcdFK50GAyRHCDqgvrnKjjqXc
         JMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712938379; x=1713543179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oek0e1IBHpQeCv1bDHie33lhT/ah3GHCrkshzPUX0sY=;
        b=ae8o8b258s8KFrfrca50nHjq8CpHkHnESaUI9/bIk/wL5ze2QFz14gwfBOBRU1P4OP
         RHx9gpqW2riI+4jgptkjiY+2jekcRFKh7kGeE6DnHtAsvD0jo3klwyX63VEKs3P/xo2g
         E4MZt8E5FaVIcjRDuwocfMWeHAMxYOo8dIgGdprExzJsIBrEd7OpgEXNMyER/gY634RB
         7EQWQw53crhZCkgm7Dqa9ntumY9SvvVPcZ/UdgLe5GXR1Xbi7tEWHm1W1aBsS5R7b5NM
         sLdabvh+2/5bMl7mCbPF0PSHcw/MFZbq4olbzIhUpYRq8AdGymq10s7fINAI79Fvzdtt
         OeVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD6HAlzsPDr8T12ijBPNcvcokTVNWx1BmYX4/0cwk1mxSUFxJ+3MCV8s+Vv3H+GJ3no83btxBQHhrA/EVdK+eJPO9G
X-Gm-Message-State: AOJu0YxB0++vtpUn2+w0jZANqrkXw2XujYdfTS7rn0eoQBDhfFN4FwFi
	7IVhC59+AFqqUbpSs1YzUkRAMJC59V2C3uVMm3YW6o18WNMVVlWELzBdBka+wDENs9/hbVP0U2S
	C8bxSKpI6tP9r/H7NmFwv3nHAsAXRzVZsFgG0
X-Google-Smtp-Source: AGHT+IFP5uj2/wvMXnNxI+HIzNkEwizN6W5dIx3FNY6TjbApmK4RJGr4PGJ0AYqOYLXJgQtovDAYuFHRiSFGG3KX/Y0=
X-Received: by 2002:a05:6000:18d1:b0:346:92f2:af8 with SMTP id
 w17-20020a05600018d100b0034692f20af8mr2010055wrq.1.1712938379295; Fri, 12 Apr
 2024 09:12:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
 <CALzav=c_qP2kLVS6R4VQRyS6aMvj0381WKCE=5JpqRUrdEYPyg@mail.gmail.com>
 <Zg7fAr7uYMiw_pc3@google.com> <be8f55c6-dd28-ba94-b64f-ed86de680902@loongson.cn>
In-Reply-To: <be8f55c6-dd28-ba94-b64f-ed86de680902@loongson.cn>
From: David Matlack <dmatlack@google.com>
Date: Fri, 12 Apr 2024 09:12:31 -0700
Message-ID: <CALzav=d=tZaa4rf67NQ0kYDs9R7wbCO-G0QeUvcLM+RUdPfAzg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
To: maobibo <maobibo@loongson.cn>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 7:26=E2=80=AFPM maobibo <maobibo@loongson.cn> wrote:
>
>
>
> On 2024/4/5 =E4=B8=8A=E5=8D=881:10, Sean Christopherson wrote:
> > On Thu, Apr 04, 2024, David Matlack wrote:
> >> On Tue, Apr 2, 2024 at 6:50=E2=80=AFPM maobibo <maobibo@loongson.cn> w=
rote:
> >>>> This change eliminates dips in guest performance during live migrati=
on
> >>>> in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
> >>>> 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, w=
hich
> >>> Frequently drop/reacquire mmu_lock will cause userspace migration
> >>> process issuing CLEAR ioctls to contend with 160 vCPU, migration spee=
d
> >>> maybe become slower.
> >>
> >> In practice we have not found this to be the case. With this patch
> >> applied we see a significant improvement in guest workload throughput
> >> while userspace is issuing CLEAR ioctls without any change to the
> >> overall migration duration.
> >
> > ...
> >
> >> In the case of this patch, there doesn't seem to be a trade-off. We
> >> see an improvement to vCPU performance without any regression in
> >> migration duration or other metrics.
> >
> > For x86.  We need to keep in mind that not all architectures have x86's=
 optimization
> > around dirty logging faults, or around faults in general. E.g. LoongArc=
h's (which
> > I assume is Bibo Mao's primary interest) kvm_map_page_fast() still acqu=
ires mmu_lock.
> > And if the fault can't be handled in the fast path, KVM will actually a=
cquire
> > mmu_lock twice (mmu_lock is dropped after the fast-path, then reacquire=
d after
> > the mmu_seq and fault-in pfn stuff).
> yes, there is no lock in function fast_page_fault on x86, however mmu
> spinlock is held on fast path on LoongArch. I do not notice this,
> originally I think that there is read_lock on x86 fast path for pte
> modification, write lock about page table modification.

Most[*] vCPU faults on KVM/x86 are handled as follows:

- vCPU write-protection and access-tracking faults are handled
locklessly (fast_page_fault()).
- All other vCPU faults are handled under read_lock(&kvm->mmu_lock).

[*] The locking is different when nested virtualization is in use, TDP
(i.e. stage-2 hardware) is disabled, and/or kvm.tdp_mmu=3DN.

> >
> > So for x86, I think we can comfortably state that this change is a net =
positive
> > for all scenarios.  But for other architectures, that might not be the =
case.
> > I'm not saying this isn't a good change for other architectures, just t=
hat we
> > don't have relevant data to really know for sure.
>  From the code there is contention between migration assistant thread
> and vcpu thread in slow path where huge page need be split if memslot is
> dirty log enabled, however there is no contention between migration
> assistant thread and vcpu fault fast path. If it is right, negative
> effect is small on x86.

Right there is no contention between CLEAR_DIRTY_LOG and vCPU
write-protection faults on KVM/x86. KVM/arm64 does write-protection
faults under the read-lock.

KVM/x86 and KVM/arm64 also both have eager page splitting, where the
huge pages are split during CLEAR_DIRTY_LOG, so there are also no vCPU
faults to split huge pages.

>
> >
> > Absent performance data for other architectures, which is likely going =
to be
> > difficult/slow to get, it might make sense to have this be opt-in to st=
art.  We
> > could even do it with minimal #ifdeffery, e.g. something like the below=
 would allow
> > x86 to do whatever locking it wants in kvm_arch_mmu_enable_log_dirty_pt=
_masked()
> > (I assume we want to give kvm_get_dirty_log_protect() similar treatment=
?).
> >
> > I don't love the idea of adding more arch specific MMU behavior (going =
the wrong
> > direction), but it doesn't seem like an unreasonable approach in this c=
ase.
> No special modification for this, it is a little strange. LoongArch page
> fault fast path can improve later.

Sorry, I don't follow exactly what you mean here. Are you saying
Sean's patch is not required for LoongArch and, instead, LoongArch
should/will avoid acquiring the mmu_lock when handling
write-protection faults?

