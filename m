Return-Path: <kvm+bounces-35672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF3AA13D96
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A321675B1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA72422B8CF;
	Thu, 16 Jan 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gTGzNRU+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D8F22ACDC
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737041181; cv=none; b=N54//i6lRbsYrSsfa/9manPShhQ1314oAcI5lJA09voWVDvX8nMCUc2XnJpXw5O0EGfiU7LVh+TralACIeAmUrO5osE1t4nX3UohBJJ4MVWZCTOljhgkRrJPbYl1eizZHukeFb9+ouGxjCKFgjDrpw38fhNOteIl6T6+7pvz0Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737041181; c=relaxed/simple;
	bh=RhOOy9lmiSjVKobRKsfe0pSF6X4eKg4ca2n+GxqM8cM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J7s65gRs3PhusVUqX2fdxgWuTsp7ukcPHnp7969tnjMXyNPq9O/eJDIIYr5a4exwiQOb3l6VTaxJnZSw8TzalYh4IlbDxvZU/wMwmVa8PhusGwWqFkJprr5XAO1t1QhlUF6YozFLx2UxXIpOzzA/jnu7vxoMXwewefjEkwxGaxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gTGzNRU+; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d8f65ef5abso9493756d6.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 07:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737041178; x=1737645978; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7u+x3MkE2/d1WgfPW8yBcqQw0ONZ79mqMOQ0fEliI6Q=;
        b=gTGzNRU+O9mYDF3xvbVJYYH4Lk4LiOX/v8p4uw0yTsgbpJK3LOUegDK3ZwgP8lIQMv
         pt8X4DOGSYeEvaZ/wbfEpelIDRAWRGGC3ZZR4KOjT6nsJdvRtspArP6OQlPbzmOXHVUT
         VDxD2yTRyfsDiULcSE0p51psEsvlNLe7ASFiTyxsCLLVXdFOpkt454rp7qwOv6wwNipP
         lyvw0dtpJbiEDtzPkIh+xIBmTJF/Y2o7nWy7MXgSaMSBxQ2vxbQ94Wn9PXovi5z+Gy8N
         la78FhvzgGjLO/UDIiKzLY9E2VJEQ4AkjZk3g0Kpfh5C/s05nvRw8LvpnscBPvinWiBh
         J7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737041178; x=1737645978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7u+x3MkE2/d1WgfPW8yBcqQw0ONZ79mqMOQ0fEliI6Q=;
        b=CEBdwcYlC9gp7Xa9NwC25XNx/0xtgEcoeNnghngNjPeKyfb7zaqnjgQH2z2U+2f5yL
         //inwxDFFYVE+6mZdMoEoZ1zWsE1FhnbFyP5Gh9gnnLSECfuIvKdBhnuuos4oyLkzybv
         pnhdJbngQXTLswDmct4ECa/fz5HZS3dwm+rPDLcetkB5MaVH4zfjr3Ikf7yupjq1+7vd
         u8EoYJVwVKk6vY5WsK7UR7TR0RcA2Z9BUBhDSx7eRZFs+DrcxROph+yreWtg3gKHqXSd
         fNW5Kwrgr2lSLDeQnibG7BHtsECY/JqqvVf/OU5ulZepLraJDQlgYZriFS7EqDznU8VA
         rxsA==
X-Forwarded-Encrypted: i=1; AJvYcCVMNt6yTG3N2Xt9IuzgzojQRPVfYZqc5heyX8CJIP3p9Z/rYMl+NtA9QmBjae9TQwDDfUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi4CCP1MAaRJxEB3M5NhavQ4BbUZKY0eWjOZbVD8tSeuEpTM62
	afENd161gAsv3eqHo6KZMkaSQHdWvJ5J5v7wzb5cqKI8SkY1HClL2CRHaHL1/E3Ay4x/oMXRCvr
	dz+bMk51wboyzxAqDTAQ6ZW4JryF6xRtZr9Ah
X-Gm-Gg: ASbGncuMqFVBejjTrOfwf3dAI1ETks1OSDZvYqIysKe4rleHqy0ItFWhwBOZBUqNUCX
	AoUafbzASSWb3ShS36/UsO7Vj3LqGKCKb+zA=
X-Google-Smtp-Source: AGHT+IFJJdA052hQRUG4VEnN8RK8MfLIp7aE2ruxupjadKLnn6JTXqFeoq5SBp9WYc+8AZm1k9CNurC9UQJR88kaa+o=
X-Received: by 2002:a05:6214:d4d:b0:6d8:b189:5412 with SMTP id
 6a1803df08f44-6df9b2ddd27mr518390216d6.31.1737041178141; Thu, 16 Jan 2025
 07:26:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
In-Reply-To: <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 16 Jan 2025 07:25:41 -0800
X-Gm-Features: AbW1kva4NTwKGPHHbyWkB7ae4q_qIfDsKbcxyAiYzHgxkzbelPg-7FAxz2aregc
Message-ID: <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 9:27=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> > nested_vmx_transition_tlb_flush() uses KVM_REQ_TLB_FLUSH_CURRENT to
> > flush the TLB if VPID is enabled for both L1 and L2, but they still
> > share the TLB tag. This happens if EPT is disabled and KVM fails to
> > allocate a VPID for L2, so both the EPTP and VPID are shared between L1
> > and L2.
>
> Nit: Combined and guest-physical TLB tags are based on EPTRTA (the new
> acronym for EP4TA), not EPTP. But, in any case, with EPT disabled,
> there are no combined or guest-physical mappings. There are only
> linear mappings.

Interestingly, I did initially write EPTRTA, but I changed it to EPTP
because that is the terminology used in nested_has_guest_tlb_tag().
Anyway, I definitely don't mind changing it to EPTRTA.

>
> > Interestingly, nested_vmx_transition_tlb_flush() uses
> > KVM_REQ_TLB_FLUSH_GUEST to flush the TLB for all other cases where a
> > flush is required.
> >
> > Taking a close look at vmx_flush_tlb_guest() and
> > vmx_flush_tlb_current(), the main differences are:
> > (a) vmx_flush_tlb_current() is a noop if the KVM MMU is invalid.
> > (b) vmx_flush_tlb_current() uses INVEPT if EPT is enabled (instead of
> > INVVPID) to flush the guest-physical mappings as well as combined
> > mappings.
> >
> > The check in (a) is seemingly an optimization, and there should not be
> > any TLB entries for L1 anyway if the KVM MMU is invalid. Not having thi=
s
> > check in vmx_flush_tlb_guest() is not a fundamental difference, and it
> > can be added there separately if needed.
> >
> > The difference in (b) is irrelevant in this case, because EPT being
> > enabled for L1 means that its TLB tags are tagged with EPTP and cannot
> > be used by L2 (regardless of whether or not EPT is enabled for L2).
>
> The difference is also irrelevant because, as you concluded in the
> first paragraph, EPT is disabled in the final block of
> nested_vmx_transition_tlb_flush().

I was trying to explain that even if EPT is enabled, sharing
guest-physical translations between L1 and L2 should never be possible
(and hence we should never worry about flushing these translations in
nested_vmx_transition_tlb_flush()).  Now that I read it again it is
not as clear as I had hoped.

>
> > Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> > nested_vmx_transition_tlb_flush() for consistency. This arguably makes
> > more sense conceptually too -- L1 and L2 cannot share the TLB tag for
> > guest-physical translations, so only flushing linear and combined
> > translations (i.e. guest-generated translations) is needed.
>
> And, as I mentioned above, with EPT disabled, there are no combined or
> guest-physical mappings.
>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> I think the reasoning in the commit message can be cleared up a bit, but.=
..

Agreed :) I am sure Sean will also want changes in the commit message anywa=
y.

>
> Reviewed-by: Jim Mattson <mattson@google.com>

Thanks for the quick review!

