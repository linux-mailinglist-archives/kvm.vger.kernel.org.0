Return-Path: <kvm+bounces-68003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7F5D1C4BA
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 04:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 63CF83033698
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 03:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAC62DCF57;
	Wed, 14 Jan 2026 03:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FfBdIHYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358F51DF985
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 03:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768362494; cv=pass; b=Tf8g9Aeaw22T8ZBghmV5GTc9rSFH3xYqyyRPDRReXsZ4gK+oRJy8rxOtWQeQH6xm3u0H/EcMxQsiWjaCmrnFitn/FYkEyfKMIcEKMbWPBk4VxlQ1XB+O3yoqMan8foNxBg6vNKcgE7NBleW984FLCc1o1hDUY+Ox8kxsD6/8IjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768362494; c=relaxed/simple;
	bh=+8CXAGHlN7h7rhVhzCZo5Odk3sIt9n0hDG3DU7w3Sr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RqhxZXz6QZ7O4JChBuAiVlqZ1X2A6HjnXzf5KWmKQ2/sWBwgyLIme/D+7CB1WordgNIqbsUYbmuvtQc67Jc7FQ525C46/fdIVMEMVMEq8nrvisVaTJjmbrqnK283dEz3qNfrij4tlbmofMiXe8Yt3d4aSWoK0wkVGZgEpNO9HAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FfBdIHYJ; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso3237a12.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 19:48:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768362490; cv=none;
        d=google.com; s=arc-20240605;
        b=UbPqrCWDHmUPQb1SHLUOLmAlNJanAKhkpuvsCVmZDmC6buikyctEU7/LS6xxq9i42E
         sGVwtWxYdz2QX0cs97j72mm9lb5VEgkpIeaYWLRQ5UTT7RzaXdTV5rcsJln5QBNDDUHD
         zDmP7ZlP021x+WOxaS4j5ttkrnxTfjxv40YNGDvLvLx3psYk+HJ2S40ZLAUgZ8boW5+M
         Ell32r0hpu2yGlUxKxSz5IieSQqM0YMw5FfQCUVZ1COQP56Gtk1tP1DDti3JrK6plwsR
         j4oUYi4in+vT50bZ+SElIhxNtV6pycq9f+jQu6lyNH2Q0oApISPV5hC9zBvyfBWsGNKM
         slRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=scD7kn+lNKFJW5bkLd/OkPYs8TXwvlIWtW1Nlv05sh4=;
        fh=XbXuN8gqWmmAAyPTSOid8mcJtOqp78lnUkzOF5sef0g=;
        b=KhEsrcPY9uyE3srsJ7XWH2jD+N3T+Pc601Zf7JkNUuKgHl53xANYKc+hnOnu1WV1qD
         Xt4aGAwHiYAa92enQYE22TvI+Y/6P3plK1eZXZjogVX+x8MY63VHHzGRqSZb6UsSK24J
         /w5X2kN9UEH6igStMvXnuyr/8JNBuaeNlgGet2cwYa14goM0FVAbmxl/VsbGCOgOcve+
         ntBQW2u2Iu29dbXzfOzT6NME54SeyGM2DOoCwQjaZx35Q/ENC+/lrI7d/VLqV9CZZgcP
         ERsxL3tlIBtVA/1SYEUTjLmbw68zlWlBI5U3Q4p+ZPsq9oAxIaxQMLMRhxiOvpJY2VK0
         Y+Fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768362490; x=1768967290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scD7kn+lNKFJW5bkLd/OkPYs8TXwvlIWtW1Nlv05sh4=;
        b=FfBdIHYJlKaJnccVUKhzNbjxwPwRwzXZBK7ubGs5QXWVbZO/FsGRB6Ei5rX2wKCVZt
         ty+aq7tid2Lum1wRyhY4KaSHot3QAICm3HLpB347cPn7p3D543ltIR6PFUzEuI5YCd5h
         X8KtbW+mate4wYnnrh6a7LQ0nRmQ1uuwswbesRsN5SFR1uaDYAQU/fTBHDBdVP+0pOQb
         /wW4M1yjNY5UhAq2o50WeM/tK2fTVN6dZ3MAnrP2A0GRt85uPJDH6jNiGRaHd64TdV6i
         lsMA1Ulg6fo4eziwEd3jzpurZq25USdERt9tot6HJ1Wrr6pzCmhmLHJkfTN05FmiouNn
         YptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768362490; x=1768967290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=scD7kn+lNKFJW5bkLd/OkPYs8TXwvlIWtW1Nlv05sh4=;
        b=iBEwvikS5qfSh2va/yJYPDbcFflDEKnCqLwoRvJmxRzKYRPn3rKfSRM919PgCDV6M6
         UHPzXfmIUsd2QxqHJrYoopd2GQP4Bk44QI88IhzJPs/XBXv3gJqiQKvhrjrBd5+VoAgW
         oV4QOn3ZOODI8Fbu5LzhrhTa03y2ggGvX8pQBOI8/0cE1jrHPQc2pQLdLOQ93LVk78jJ
         NSgqAg7t5k3Q6PygcRmJ7oYenrd0ptoOn11eAfUcxli0mUV15UuMpQvLCf8KMMezYUU4
         aD4AVqvSfAWv+vBkYWtwkOahKwo3EumzQkQw7ZvvrocCvhXhrhaxIlXLyWAjizwCK1e1
         hjeg==
X-Forwarded-Encrypted: i=1; AJvYcCVz2Duhlz/uSYgn3JnJpeRe9+szPaXpMWbc4mkV+OpluZOVNQE8jeiJN2t/rLlas4sKnjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy4PcOuFz/3W74C+EBWBWa1ILi8NbDa4LVftll9hhYlJO+NsAf
	cOoeWSMVHewZajgNb5HbVCNL+ZE48BziE5+cDyeebU8RpDJn79G7A9uXhPXe/bBsYSPb0LcqkpR
	GAoOJb0jrFkNf511yK5Q1zcEu9e0qOLs2+VKmKYXf
X-Gm-Gg: AY/fxX6aavmi0KgYb27WWbDsGuN6mk0Ca8C1huUNAC4VI6U652OKiEf9Ti1VDXHuoE8
	MmDRFPpe8ftovYCKoV9Ql+HbIJaGF5pH2sPaj0msSRJ/ns2hLW6uDcUPiYG4GqZ2PdN7BqINgr2
	hb41GEtHx7e8UeBWDsWk0pgadZfe4OGnj7OhDtOJLLgGq2HXc+2bOcmtpkftN3p8hO1DcTV8qlm
	wk3tUqbxAniR1+cYhcnBqqgmPAWtkxCJzcBtN74f68MpN/0Y/hObfs53hvoTOZT0Q48WNk=
X-Received: by 2002:a05:6402:10c5:b0:645:21c1:97e1 with SMTP id
 4fb4d7f45d1cf-653ebe0df15mr20706a12.18.1768362490453; Tue, 13 Jan 2026
 19:48:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com> <aWbmXTJdZDO_tnvE@google.com>
In-Reply-To: <aWbmXTJdZDO_tnvE@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 13 Jan 2026 19:47:58 -0800
X-Gm-Features: AZwV_QjYk5AB3MTvpGonH_E4zGStZr00TM2lL2gptdhdYaN66acS8j7r7evEsoc
Message-ID: <CALMp9eTYakMk0Bogxa_GdGU5_h4PK-YOXcu-cSQ16m1QcusHxw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 13, 2026, Jim Mattson wrote:
> > Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> > IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Prior to
> > commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> > DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
> > FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coincident
> > with L2's execution.  The quirk is enabled by default for backwards
> > compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 if
> > consistency with WRMSR(IA32_DEBUGCTL) is desired.
>
> It's probably worth calling out that KVM will still drop FREEZE_IN_SMM in=
 vmcs02
>
>         if (vmx->nested.nested_run_pending &&
>             (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
>                 kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
>                 vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugct=
l &
>                                                vmx_get_supported_debugctl=
(vcpu, false)); <=3D=3D=3D=3D
>         } else {
>                 kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
>                 vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_de=
bugctl);
>         }
>
> both from a correctness standpoint and so that users aren't mislead into =
thinking
> the quirk lets L1 control of FREEZE_IN_SMM while running L2.

Yes, it's probably worth pointing out that the VM is now subject to
the whims of the L0 administrators.

While that makes some sense for the legacy vPMU, where KVM is just
another client of host perf, perhaps the decision should be revisited
in the case of the MPT vPMU, where KVM owns the PMU while the vCPU is
in VMX non-root operation.

> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 0521b55d47a5..bc8f0b3aa70b 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(struct =
kvm_vcpu *vcpu,
> >       if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X=
86_CR0_WP)))
> >               return -EINVAL;
> >
> > -     if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> > -         (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > -          CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl,=
 false))))
> > -             return -EINVAL;
> > +     if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
> > +             u64 debugctl =3D vmcs12->guest_ia32_debugctl;
> > +
> > +             /*
> > +              * FREEZE_IN_SMM is not virtualized, but allow L1 to set =
it in
> > +              * L2's DEBUGCTL under a quirk for backwards compatibilit=
y.
> > +              * Prior to KVM taking ownership of the bit to ensure PMC=
s are
> > +              * frozen during physical SMM, L1 could set FREEZE_IN_SMM=
 in
> > +              * vmcs12 to freeze PMCs during physical SMM coincident w=
ith
> > +              * L2's execution.
> > +              */
> > +             if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_F=
REEZE_IN_SMM))
> > +                     debugctl &=3D ~DEBUGCTLMSR_FREEZE_IN_SMM;
> > +
> > +             if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> > +                 CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))
>
> I'm mildly tempted to say we should quirk the entire consistency check in=
stead of
> limiting it to FREEZE_IN_SMM, purely so that we don't have to add yet ano=
ther quirk
> if a different setup breaks on a different bit.  I suppose we could limit=
 the quirk
> to bits that could have been plausibly set in hardware, because otherwise=
 VM-Entry
> using L2 would VM-Fail, but that's still quite a few bits.
>
> I'm definitely not opposed to a targeted quirk though.

I have no preference.

> > +                     return -EINVAL;
> > +     }
> >
> >       if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
> >           CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

