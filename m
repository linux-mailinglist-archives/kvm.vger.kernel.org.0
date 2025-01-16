Return-Path: <kvm+bounces-35683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01533A141AC
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBEB41884226
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 18:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C5E22F178;
	Thu, 16 Jan 2025 18:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aCqOVWDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36A22CBDC
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737051881; cv=none; b=ZKl7nn12K1nFmPs52Wd7qj6EPJZDAOWGKQMTTrqRQoDioBDJniGfVaJb/m+PuPxTEUZK4Yy5GKA/HsthzoT16vOn2UiVkxADuZvhtINdJsMcWTyYBk8D95NHPE+CPBUaVGcu1YMb4GAg/Ykk9j9js1iryMK1l6R5GxDzmvYRrp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737051881; c=relaxed/simple;
	bh=wcFXog+XZTyzwCAcQOrMPXmF/LVIrIP5IqtFFt1QWPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWfNf1zxgMI/pd06trxno567IoyqDzaLvshPoJ5FaMM7TpEpuuiX5kKGt2RXPCLKwAFTD33IbDJxa3Am0V+bXvWdHr5a2phqyD91DyzFNdStIHu1aJhQN20lWqz+nzBsSAC3a6iUdEYUO0FGZi+g0wFr0fG1Ih6ZO9iLS1y8CdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aCqOVWDg; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6d896be3992so9693496d6.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 10:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737051879; x=1737656679; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02X5/K/iRrzRMKynYm08afP4MDJWTQ27GMmFRfRQUEI=;
        b=aCqOVWDg+SwpLZQhHqoPHHoZyzmVr4fLR04XRpynzPOMkr9ho9pnIretmN9OVYp5OY
         0BYnYXd9bkGtmW8H5gJEG1+PxaKSk0Q1/H3cfZvpvA9sYElgEL2PWWF23mJdPSjTSNqU
         Ow5Jay/UcExSBHg/HT36Esdx+aGXtHeK5/NR9EXcewMpT96ZFZeBFxZ5IrHySSDJ5ovM
         0i2dkQO9m28SQ8v9IStNHvNM/FCat3iLQPcrIoXnrShAxP6eRIrbfteJ9MquStDKo/P6
         Gd4u+kQYaLXJgtOaKK01sETDjyaV4TrZDti8rqPfPgPskbYvRB+m2n9nx7lpkZtX+uMt
         Eb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737051879; x=1737656679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=02X5/K/iRrzRMKynYm08afP4MDJWTQ27GMmFRfRQUEI=;
        b=LKGeVe5S0UH7Im37ue8D7IkDxwGVZlMGNDTcP0CidAndBrigpj3fmbPRdr3XQipH/f
         nrWwe+zfYADljp07Hxkwavq1eCL1E1DHHnYMrmSdXNnGZcDdmGvEb1YcPP/lsN/ND/oF
         Spgr8LCs7TKExVsD5I/1rMqTF6AI6dydcaJAOtkYWKxK1RsDncEY4ms7YxGGef4CbeIT
         6DjTr47N3AdDvFEP/mUT2O14jQRXdQy0HzaiaPZU7fbbfYakoKqfwAXB69x2uKQltoGp
         4qPJSout14Z+/IGjd0+oryPirDS9hvtydAf2a6splqYzy22tQ1klMk4ny5qvuM8iVnDi
         jHAw==
X-Forwarded-Encrypted: i=1; AJvYcCUbPupPkc0GHvYWGS+F8Gw001beK0irDWWfd0/0CorD9KnHCYvfxbNyt6SKH6P9me6CIHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzYFCmaYs1NnLVfzcLfmPVWdz6XrRRnVDgKvte7UCzj224AhSf
	EGKOOzK5RinbtVyeBMxEg3cQzl8YbxCNcxc18idInC5kNwhgtX/vG4E+X2q+sWOyENj9G8dlis/
	xorVWjqw8scKwMuLSI44fprZUl4Dg2j+V8AhS
X-Gm-Gg: ASbGncvXFUoy2j8wO4CqA6yeFOlbI9vPL0+5zMbRfXYc5YjJXClsFtWqIiziZJh8Q4o
	gDZAdBrchUjN9XZXw4KZdwSn3GBQKMgVWGVLzS/JvAgeM8w5DpAnvB6CfEy5987JFG7wQ
X-Google-Smtp-Source: AGHT+IEkMutrjMtGAUd1y2WQ3RCYotpiiUJLbLPBL/OOI1EiU6c7J8rvehHv3fgzzYlynF56uR8hXpHrLRg+OP/DwHU=
X-Received: by 2002:a05:6214:483:b0:6d3:f6bd:ca04 with SMTP id
 6a1803df08f44-6df9b2eb1c3mr495809356d6.40.1737051878971; Thu, 16 Jan 2025
 10:24:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com> <Z4k9seeAK09VAKiz@google.com>
In-Reply-To: <Z4k9seeAK09VAKiz@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 16 Jan 2025 10:24:02 -0800
X-Gm-Features: AbW1kvbOTNptcrKVzGife9iuaD0YeiV8nhujcd5CSH8upFG5n4PmL63WHBa1EF0
Message-ID: <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > On Wed, Jan 15, 2025 at 9:27=E2=80=AFPM Jim Mattson <jmattson@google.co=
m> wrote:
> > > On Wed, Jan 15, 2025 at 7:50=E2=80=AFPM Yosry Ahmed <yosryahmed@googl=
e.com> wrote:
> > > > Use KVM_REQ_TLB_FLUSH_GUEST in this case in
> > > > nested_vmx_transition_tlb_flush() for consistency. This arguably ma=
kes
> > > > more sense conceptually too -- L1 and L2 cannot share the TLB tag f=
or
> > > > guest-physical translations, so only flushing linear and combined
> > > > translations (i.e. guest-generated translations) is needed.
>
> No, using KVM_REQ_TLB_FLUSH_CURRENT is correct.  From *L1's* perspective,=
 VPID
> is enabled, and so VM-Entry/VM-Exit are NOT architecturally guaranteed to=
 flush
> TLBs, and thus KVM is not required to FLUSH_GUEST.
>
> E.g. if KVM is using shadow paging (no EPT whatsoever), and L1 has modifi=
ed the
> PTEs used to map L2 but has not yet flushed TLBs for L2's VPID, then KVM =
is allowed
> to retain its old, "stale" SPTEs that map L2 because architecturally they=
 aren't
> guaranteed to be visible to L2.
>
> But because L1 and L2 share TLB entries *in hardware*, KVM needs to ensur=
e the
> hardware TLBs are flushed.  Without EPT, KVM will use different CR3s for =
L1 and
> L2, but Intel's ASID tag doesn't include the CR3 address, only the PCID, =
which
> KVM always pulls from guest CR3, i.e. could be the same for L1 and L2.
>
> Specifically, the synchronization of shadow roots in kvm_vcpu_flush_tlb_g=
uest()
> is not required in this scenario.

Aha, I was examining vmx_flush_tlb_guest() not
kvm_vcpu_flush_tlb_guest(), so I missed the synchronization. Yeah I
think it's possible that we end up unnecessarily synchronizing the
shadow page tables (or dropping them) in this case.

Do you think it's worth expanding the comment in
nested_vmx_transition_tlb_flush()?

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ed454186e59c..43d34e413d016 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1239,6 +1239,11 @@ static void
nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
         * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
         * KVM was unable to allocate a VPID for L2, flush the current cont=
ext
         * as the effective ASID is common to both L1 and L2.
+        *
+        * Note that even though TLB_FLUSH_GUEST would be correct because w=
e
+        * only need to flush linear mappings, it would unnecessarily
+        * synchronize the MMU even though a TLB flush is not architectural=
ly
+        * required from L1's perspective.
         */
        if (!nested_has_guest_tlb_tag(vcpu))
                kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);

