Return-Path: <kvm+bounces-68286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C69CD2B2D1
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 05:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF4EB301F8D9
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 04:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75987342C8F;
	Fri, 16 Jan 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cuN7iSoz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CFF322B67
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 04:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536529; cv=pass; b=MCafQvxH+48LV8TOPoqxx8lm6Itva+t4zjPl8RQ540KdadG0gvwFmSbwLtdGst+0BInxk591EXzLfLNr8mXY+LZB6cOIM2k72rCC7Tj/Nf2O+SvRIn0N+QmjBwfNICGOWjGFnQftRsjkB8H9g8xduRUl76PXiFg9G7uEK54ozak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536529; c=relaxed/simple;
	bh=gcymO8sHuZHD/0eIBqHyPY2wUAyeD3kg4ZgHuJZwI4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Bxx5ztC3tab9ycrL4cg0H9NivyIUhwxVErITSKO3X/RKoikDpazck2n5lQkXEKv/ZOpUt4Wbqn1gajnjLEPTdp8BDTTANLk8/TJsmxHmMIt5FubT6ICYyJW8ZxEWPe8iO7Ojs4YFaJehzlC2DfO+PE7mBa5i8XxuU5xFMhz8DK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cuN7iSoz; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b66d427e9so2847a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 20:08:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768536526; cv=none;
        d=google.com; s=arc-20240605;
        b=OGx8ZGbWWOWmswW4PMrt3NXdG+ECYL57cahXIQSpdf7sjR0h+JZEHKzAqKLs5eaqM8
         flypTrGNw1oB4q4HDTawR1lSzXF9B7BUJ61z6TSkKNaojDbsnQA5ocb6tzehjiA6T3We
         G0v40wFI8O/+5ZBFnO7SJMBaGsuazatUwXoSsdO3rZAO37s0YB2DdX/RM6i8tzjkZUp1
         bu5yZm+bLjUVbyBahvBxJ/f/IN9YwFFndLZgmXo5fcxdaR9PEZPdXzN0197O8VSDcHwV
         FACTJ8YIaLxsf0k+Qv9lqCqVo1rnXD6VlIn6Wfo9OEynD+34a0kfyKNOWhcrhuj3CPAb
         epzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jteGael7iAM+Ic4XgubDec8+SIAMb6wVEDTLznw2Hvk=;
        fh=S19jNUF9fpK4ZKF5rZCKa4aZ3DQaylO00yy5f60am9A=;
        b=Ahomf7VPuSfxOp3qhrpBQRUMA83griPYMgITRI4nbtrnGvxKO98kFdU9ASd6eGmbWd
         MdJ7dTQJYP/4GPSRWInFwS5jrSTsihVUa5biOf8rHUnj+AI6wvwV/m5MsC9GDkxkTFUH
         V215uEYzdXgG49F57Dcw7TkOL/w/JzDo/AKRJVLLyUUKtp7hUyBMpfhcek/2Svsobvyn
         bggk4bL0QuZx6XT47AF0VChniOHdhgYWmpsCukkDr3dY9FuB9+azkiGpb6I0iflOShVT
         /xTk+OC0SpjglJsngU2XcmWKuCf3D9XzyrwSdfC3pdWvgVc1ZiMHEqEClVAwnb4g/MuI
         wwlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768536526; x=1769141326; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jteGael7iAM+Ic4XgubDec8+SIAMb6wVEDTLznw2Hvk=;
        b=cuN7iSoznbLRFbttQl3l2ZzsTjOlbUaEekSSiOO5hPszSg0aC5dAG6pSv07aLQM+3P
         TDXR081GskG6ZxFLZWzJCIQcO4dByUkJwrN56527irxxJFEWeBgC1P8f4gqAt0Y2L12W
         pd3Ab+UsH8VkWgqR+HHNXEhifs6M0rOwzqCAgKU3iE7q9+CWfxo4j8NDw9gFqn0t2p1r
         J4znhFT4Qcyyf5Ju+zukMcJoftdjWJ4YQ1Vg7OtAv/pbzErrdQ9OXRjrBB5ohc0BM7Vf
         rkLdasd8MfZwPhooPpniVqe5kSdfVg3jM7AFjwyfOb7dEQ8tipIltb1s6Am8D0HHP/Kw
         rdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768536526; x=1769141326;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jteGael7iAM+Ic4XgubDec8+SIAMb6wVEDTLznw2Hvk=;
        b=sWBeZwsGhdLO8Gbbf275r5fAYCZNYqLzy4MbHmrWA0rFhoYXwNsP3Hviho4os+4K/f
         AAl9KTWNJWXvY+ocZJv1vl9o472sxms2HLn2P/nrGqb0hUkoUToIvJnxW7XZwSpVMIXR
         4sWboZJRGICiSXX+HCRj137S4kaq7IebJq18Qo5jU21eXqBOygcsH1EDFlwIDh/272uT
         N7ROSOpleNP5CVkxvfH8zJ/Wqsl5fIuJrOv++K2piOBSumkLypWhNboHRXp5Gj4lY/IQ
         JZnndayleBSDbW46ik+BK1ktjZxv4wHvYISzfAMStAvqOJbhdCVdsLfbEN9yXHmQ3vDs
         SS5g==
X-Forwarded-Encrypted: i=1; AJvYcCUqy+bKsLRXPBmz72Mu/1+HuLyJeEZoejvSGkRA6k2K3o/1ffXuWzTxcf7PLaDE1gdqPlE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLzXOM+jMzxiWCLjiDc+SDvQhubw3oqi3NbAXHhqRdnqPf63Y+
	Ad/jOIOaIiGdHLbb73l4a4C9LEb091YPqSR7jinqLGsXyMZpwK6C8gKNBGOu/2jnMYWufzpk6WC
	1hK1jQrEbude6H1g7iCW4TMKlMMWH4X1FfMdpXX/d
X-Gm-Gg: AY/fxX64qK4eMjQM/J2tsw34+7xsW9rEVrQHoucFBKGsQHjrDLAUr2lkV4NySjq1P7T
	FCL3FI7pJVq4YAOoO0cbF9UtrZhmt1kVrkwlJWTSIyK8O5008ZdhS5l5dF7a7meI0iKspYW35yy
	PYrxo60Yn/Ke0YKZ0YxdUETlmwsjwgaM8xIvEA3qXM7C2IMtQulnONF+6VchPPLdAjGtwv0aPf8
	1MlqcMwN9v31Qvn4pLRSIvzki2FGwW4Bm42B67fM5rnLQ1dp2am9H1AqdDdIOwdLNr/l2HzueLB
	Er+fag==
X-Received: by 2002:aa7:ce1a:0:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-655250edcf6mr10540a12.7.1768536526341; Thu, 15 Jan 2026
 20:08:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-2-jmattson@google.com>
In-Reply-To: <20260115232154.3021475-2-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 15 Jan 2026 20:08:34 -0800
X-Gm-Features: AZwV_Qiyq77W87Fw0Hqa_LDIQdFvkrquc9Zy1Y8YNrsVZ9dQ1TDzaCisflOneZM
Message-ID: <CALMp9eSMxNcV-5fcE3EUqCeoQz4m1v3j3j_2jNNv1KViJVXakw@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 3:22=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> When the vCPU is in guest mode with nested NPT enabled, guest accesses to
> IA32_PAT are redirected to the gPAT register, which is stored in
> vmcb02->save.g_pat.
>
> Non-guest accesses (e.g. from userspace) to IA32_PAT are always redirecte=
d
> to hPAT, which is stored in vcpu->arch.pat.
>
> This is architected behavior. It also makes it possible to restore a new
> checkpoint on an old kernel with reasonable semantics. After the restore,
> gPAT will be lost, and L2 will run on L1's PAT. Note that the old kernel
> would have always run L2 on L1's PAT.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7041498a8091..3f8581adf0c1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2846,6 +2846,13 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>         case MSR_AMD64_DE_CFG:
>                 msr_info->data =3D svm->msr_decfg;
>                 break;
> +       case MSR_IA32_CR_PAT:
> +               if (!msr_info->host_initiated && is_guest_mode(vcpu) &&
> +                   nested_npt_enabled(svm))
> +                       msr_info->data =3D svm->vmcb->save.g_pat; /* gPAT=
 */
> +               else
> +                       msr_info->data =3D vcpu->arch.pat; /* hPAT */
> +               break;
>         default:
>                 return kvm_get_msr_common(vcpu, msr_info);
>         }
> @@ -2929,14 +2936,24 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, str=
uct msr_data *msr)
>
>                 break;
>         case MSR_IA32_CR_PAT:
> -               ret =3D kvm_set_msr_common(vcpu, msr);
> -               if (ret)
> -                       break;
> +               if (!kvm_pat_valid(data))
> +                       return 1;
>
> -               svm->vmcb01.ptr->save.g_pat =3D data;
> -               if (is_guest_mode(vcpu))
> -                       nested_vmcb02_compute_g_pat(svm);
> -               vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> +               if (!msr->host_initiated && is_guest_mode(vcpu) &&
> +                   nested_npt_enabled(svm)) {
> +                       svm->vmcb->save.g_pat =3D data; /* gPAT */
> +                       vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> +               } else {
> +                       vcpu->arch.pat =3D data; /* hPAT */
> +                       if (npt_enabled) {
> +                               svm->vmcb01.ptr->save.g_pat =3D data;
> +                               vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_NPT=
);
> +                               if (is_guest_mode(vcpu)) {

Oops. That should be "is_guest_mode(vcpu) && !nested_npt_enabled(svm)".

> +                                       svm->vmcb->save.g_pat =3D data;
> +                                       vmcb_mark_dirty(svm->vmcb, VMCB_N=
PT);
> +                               }
> +                       }
> +               }
>                 break;
>         case MSR_IA32_SPEC_CTRL:
>                 if (!msr->host_initiated &&
> --
> 2.52.0.457.g6b5491de43-goog
>

