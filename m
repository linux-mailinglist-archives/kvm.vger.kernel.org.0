Return-Path: <kvm+bounces-66278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 17123CCD16F
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 19:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F309305393D
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 18:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44292DC350;
	Thu, 18 Dec 2025 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fqbRPGx7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oL394i59"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C02B28F935
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766081139; cv=none; b=u8blMvfsVEqd2mglh32Lsd/pHboxdAaNXZyG3KjCT1S9TEMD5QMB8KXwVLY266BmRUBE0txPVlY/TKDEuNbTQVazVzeidFf32qxyrsQyoU6CR7Jp09+RgTwcnSltY/X4i0DJ9S7Okz6oF1PH1c6qMhIfFAsKhu6vBLV4i0SyY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766081139; c=relaxed/simple;
	bh=xmYOMNFHN1lXh8qQVMe/a0YvFpBwXUEZ9EWbcLuTSNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hqgl7ylOLiu4dkB6UxmvnO9vNDnpF2hBUZ5zYWiTtoDDgA8nnhIJ4aln5mq7f4usfDR0sDE1OVVjuGwdtqLTxUwN2OvKxk3npXRyIBthBbW5nOV+9hpnWA9LVKdnSyd0ergMOg5YMfWmDuEwpRjlDhy/MQsZ8u1U0gHQGZE8MDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fqbRPGx7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oL394i59; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766081135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mS9ZsdA2eBNv425it5KvbIT3E2uGN+dBApP1jACRs0I=;
	b=fqbRPGx7gLG4PcocRzm/+VFxmUuRtNUFgtoplM9PTD7cVuVPk5pKZehHOU+KnV3EwVKunX
	0jvWcAr0xLT/jEs8ghBs3brngX84eYLE+eiJ3/k2FbQfklmqw9wHaRi7Qag4gdRKFeCOhV
	9dHg6Gx0lXUj3DtdkEqseRCYE5WjUhc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-HGxd0e2eNoaO8s2wm245YA-1; Thu, 18 Dec 2025 13:05:33 -0500
X-MC-Unique: HGxd0e2eNoaO8s2wm245YA-1
X-Mimecast-MFC-AGG-ID: HGxd0e2eNoaO8s2wm245YA_1766081132
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477c49f273fso12669165e9.3
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 10:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766081132; x=1766685932; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mS9ZsdA2eBNv425it5KvbIT3E2uGN+dBApP1jACRs0I=;
        b=oL394i59OK77+ylY1Zszhi51bpX4CKh34VR9V77Ygaygsesr3dDCgRQbL0T6HkcChe
         DoY+Qw7H7a9+hdtv+H6AG0Qy5PfH9bDEZ/iXOhj4gB0JdBjNx6MUYL+lAB+WJp+MigkM
         nESODQHRpM80FT6EaDexLpmEiNV0eWODmsi6PW+E8vsaRaQoMW0ewWVmqrqTqpwlewQf
         DfjSV3l+oY0YEsIZy4QYlRQBoy4frRsUtvl3GGu91poPjI/zUtkZlf1OmvNhzIK+fDia
         t8RDnvM8mJVEkHhjpXkTOrcSWDhBh0lxPfR/9L/AXa7ygt9q8vVzHHmeHkM61CvD2hOW
         SXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766081132; x=1766685932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mS9ZsdA2eBNv425it5KvbIT3E2uGN+dBApP1jACRs0I=;
        b=hXmx0Gjx5u27tWFyAkZWen+QtVjOsAqjz7uC2akptXt59D+3cVRSFsn9Xy7oHZN5xh
         FHx1zas8B/1kdQQpbivLEl70PZhAATkde13zvTzj/Gp43bhsbviScD8OCxQ9yQehINjW
         u0jcsF8iNw83j9URc12AlAByAmXL/hd9IFxZRVSL+H4TDkHZv7grgWXuF0fdnUa4Tj21
         wwTDEY3KSQhvU94P5THc3bvkGfzokQPvhMt/yG7LmOVg0rynF9pb9WXasJZFC/LjdEyO
         Ydft2xi2+Q5Q1fe51qpcOaRp9imS5X7qHKU0VFlU/ehuQNef0xHjP/LTdX1ir6g8EI1I
         mimQ==
X-Gm-Message-State: AOJu0Yz23+914YGPHsSPN+cRdH+JamnwZS+sb1R/ZzszxZcAFV/dZBWf
	XwU2mLM3GUGiun3jOWEzLJb719zPrv+z5KKjPKZmOk5AhvLk6qlsMPMLxQ7fkZvngLYi1slNhp6
	hKqUXk+RMNESSOf9nbaEKIycEIrRPwyQRHro4x4H0vM/hGCU5xaUi6V5t48MrNu4+e+quFewDNj
	5Dg4XXaFgyH7jaTGxedhfVgh/i5QCs
X-Gm-Gg: AY/fxX4qG/sBmVjWWig8iFAs4PICCSc0fDeNBHg5JTnOeJ7hDRN6aPYpcMb07GQIhR3
	HfDTP/48T0i34lIMBL+ZfYqkFj1kZoifzH2g5dgI2Q5LLPHh4thHHa/KRqOiZJt8miC+hDmF5kd
	4NOeNTyCpSxA8ZY+pAnnYIFXoXlZAocbX6w4rCoxLVOscswq3B+paHQTBjqWZP5lrnnoyKJtF8C
	msUUJjMDl6czka1Qn47uWATelAU6q40+R3OCitZLPTOvmZBTL6GDTSKIlJ0oKK+Mhad
X-Received: by 2002:a05:600c:3b94:b0:471:13fa:1b84 with SMTP id 5b1f17b1804b1-47d19566b00mr549955e9.12.1766081132362;
        Thu, 18 Dec 2025 10:05:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDQLeXdFMcRYZ76WZxNlkGh4aH6cmhZ3m9ZuzozCIIkK4DBUyPzmqh5U4QIfr0rOu2y933vrjH7TppucFt4v0=
X-Received: by 2002:a05:600c:3b94:b0:471:13fa:1b84 with SMTP id
 5b1f17b1804b1-47d19566b00mr549705e9.12.1766081131918; Thu, 18 Dec 2025
 10:05:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210170552.970155-1-seanjc@google.com>
In-Reply-To: <20251210170552.970155-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 18 Dec 2025 19:05:20 +0100
X-Gm-Features: AQt7F2rQhu7KN-5O7f-1zqFIroH8mjwe0rMyw-KLmGdyRJne6FC2dRWJiK3F-wc
Message-ID: <CABgObfYsyATBr43PnSjsAx9ReJ_nhfD5osANOB0GhSQ_0+2DeA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86 and guest_memfd fixes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 6:06=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a variety of fixes for 6.19, all for pre-existing bugs.  Note=
,
> the KVM_MEM_GUEST_MEMFD fix changes KVM's ABI, but I don't see any way th=
at
> userspace could successfully use the broken behavior, and the intent and
> documentation was always that KVM_MEM_GUEST_MEMFD memslots would be immut=
able.
>
> The following changes since commit 32bd348be3fa07b26c5ea6b818a161c142dcc2=
f2:
>
>   KVM: Fix last_boosted_vcpu index assignment bug (2025-11-25 09:15:38 +0=
100)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.19-rc1
>
> for you to fetch changes up to 29763138830916f46daaa50e83e7f4f907a3236b:
>
>   KVM: nVMX: Immediately refresh APICv controls as needed on nested VM-Ex=
it (2025-12-08 06:56:29 -0800)

Pulled, thanks. I waited to see if anyone would send something else
but things have been calm.

Paolo

> ----------------------------------------------------------------
> KVM fixes for 6.19-rc1
>
>  - Add a missing "break" to fix param parsing in the rseq selftest.
>
>  - Apply runtime updates to the _current_ CPUID when userspace is setting
>    CPUID, e.g. as part of vCPU hotplug, to fix a false positive and to av=
oid
>    dropping the pending update.
>
>  - Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot, as it's =
not
>    supported by KVM and leads to a use-after-free due to KVM failing to u=
nbind
>    the memslot from the previously-associated guest_memfd instance.
>
>  - Harden against similar KVM_MEM_GUEST_MEMFD goofs, and prepare for supp=
orting
>    flags-only changes on KVM_MEM_GUEST_MEMFD memlslots, e.g. for dirty lo=
gging.
>
>  - Set exit_code[63:32] to -1 (all 0xffs) when synthesizing a nested
>    SVM_EXIT_ERR (a.k.a. VMEXIT_INVALID) #VMEXIT, as VMEXIT_INVALID is def=
ined
>    as -1ull (a 64-bit value).
>
>  - Update SVI when activating APICv to fix a bug where a post-activation =
EOI
>    for an in-service IRQ would effective be lost due to SVI being stale.
>
>  - Immediately refresh APICv controls (if necessary) on a nested VM-Exit
>    instead of deferring the update via KVM_REQ_APICV_UPDATE, as the reque=
st is
>    effectively ignored because KVM thinks the vCPU already has the correc=
t
>    APICv settings.
>
> ----------------------------------------------------------------
> Dongli Zhang (2):
>       KVM: VMX: Update SVI during runtime APICv activation
>       KVM: nVMX: Immediately refresh APICv controls as needed on nested V=
M-Exit
>
> Gavin Shan (1):
>       KVM: selftests: Add missing "break" in rseq_test's param parsing
>
> Sean Christopherson (6):
>       KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPU=
ID{,2}
>       KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtim=
e updates
>       KVM: Disallow toggling KVM_MEM_GUEST_MEMFD on an existing memslot
>       KVM: Harden and prepare for modifying existing guest_memfd memslots
>       KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-E=
xits
>       KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (f=
ailed VMRUN)
>
>  arch/x86/kvm/cpuid.c                         | 11 +++++++++--
>  arch/x86/kvm/svm/nested.c                    |  4 ++--
>  arch/x86/kvm/svm/svm.c                       |  2 ++
>  arch/x86/kvm/svm/svm.h                       |  7 ++++---
>  arch/x86/kvm/vmx/nested.c                    |  3 ++-
>  arch/x86/kvm/vmx/vmx.c                       |  9 ---------
>  arch/x86/kvm/x86.c                           |  7 +++++++
>  tools/testing/selftests/kvm/rseq_test.c      |  1 +
>  tools/testing/selftests/kvm/x86/cpuid_test.c | 15 +++++++++++++++
>  virt/kvm/kvm_main.c                          | 17 ++++++++++++++++-
>  10 files changed, 58 insertions(+), 18 deletions(-)
>


