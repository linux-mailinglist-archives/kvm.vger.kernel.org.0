Return-Path: <kvm+bounces-60034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 56187BDB655
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A218B4FCB16
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 21:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBE4306B39;
	Tue, 14 Oct 2025 21:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IGW0indR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C220A2DAFD6
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476689; cv=none; b=YG/LQxDyQe52XWJ6LTqzJb6Rg6g4NfM+nTjr3ZUDAhG7tW4KmD6ohQLr5gPRECV1CQfZtZ8YJOnfNjVc0K3zfvdIO+y/6hJA7pEZsDdXeNyQYMiGRtn35AvxwfaepxBLL4D74DRZHevxIqoe7b86QUT9Nm801rx2Gjth7RJYfvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476689; c=relaxed/simple;
	bh=083L7UlHy8ud/VqJtkDbCBYK1zS9wxPzWweMPNlHCyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YCti3DuIae2xmOFs1Uy23NpFKnSBGPdvidE3QQRh5m/S/pp42jEpNutoMiqfE3zF2AvHIWjMuB66YQHK1bUcb41ZSKVBSEtwKbvHizgf3limtK+0hRWl8XDx3zo+TAp+zzYKO+qVFnvFPEM1qjT4SdU9jOL64iZQhP7V0plWBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IGW0indR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb2b284e4so16002527a91.1
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 14:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760476687; x=1761081487; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xlGERNRII+tZZoUKxhAJ0CmSBU5xgDfYRhroLSEtCOk=;
        b=IGW0indR4f3Qtw5L73AEnHa/FhaBkltc1vUX2NAxcXIr0NZ9tBpgraEukx7T9NmwpL
         dbIDvi/jBRWLLcHLmT2e3X4+Km7XaJnK5Z4nqj+cLKEqYFbsOJfDwGSbC3UY0b7/Yuz6
         ce36WcqPEaNkvAP2KvbQgc4BMk+N8SyhvKHBLNu6w3PH64g+b3QN2Jp+cn0ALEDr6fYp
         G+lkukgPXvX7KighXHofh3PHR3Hy96oSA7rCBWTrWzllaTSBWw70FzoHsN1j8RX9TPC2
         HTT5irU+hmj4eoLFaD/ucZi05se2+EkdHhIW1Dm2kg71/AQA6P5Wjh11YX6qpQlsvaxL
         UDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760476687; x=1761081487;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xlGERNRII+tZZoUKxhAJ0CmSBU5xgDfYRhroLSEtCOk=;
        b=Zm22gSImW0F/wUOuqW0YNhhjz8smVzulwsDQtTJGJXnpEkzjd3I9bQgnxsg300+xsS
         LuYKtOPHNRH+tiBCGgGtCYz4L9SwGVqZg9c4TJOWP5O1+YXw051IItx3uOscBabTZEAl
         l5Ma4URPw5D3MH8tSirhu9zdCoASHkKmsFX50fuPzq47LtVdnfZLdy6F3/CAphUk8U+Y
         i3DFui1lQr6GTtznYNm0BXMdDRnGTNkGFn5o6He4fBAjdibbeylSF9RF9p8/1o+zCw5r
         Bg284GPbxLMpXLVwvjQfRjy8auu1vUHRFCQ56nGJfBt2B6HWf3/TSd31nR/GTjVDJCh/
         NZMA==
X-Forwarded-Encrypted: i=1; AJvYcCV8Z5lzQWYUo3N9Z4Oq85qJplnCh3w1U/R20oAgiVY4hg4tt4EyXnvS8+16LtvSV8IC3YA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXgC7CM9gGc2V+SGwTM3Em1g9Y6WuVZy5X7WqvSudF3+MDd6Xv
	JEOUBFMdtJLY9fkMvSZtm5zVrZddnj4Kv8fhZ3rHRNHoaqg+MWPFQPA+07qK5/odga3jFBg092m
	oDLo/6Q==
X-Google-Smtp-Source: AGHT+IG6simq09V8B6BXq9E78i3o3CteT1MHIiPYy9wgcsZhby+xY9JMcssCZN/dmYOd+rSpeAMu3Sumo7w=
X-Received: from pjuf1.prod.google.com ([2002:a17:90a:ce01:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcc:b0:33b:6612:67ee
 with SMTP id 98e67ed59e1d1-33b6612716fmr21028640a91.26.1760476687057; Tue, 14
 Oct 2025 14:18:07 -0700 (PDT)
Date: Tue, 14 Oct 2025 14:18:01 -0700
In-Reply-To: <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251009223153.3344555-1-jmattson@google.com> <20251009223153.3344555-3-jmattson@google.com>
 <aO1-IV-R6XX7RIlv@google.com> <CALMp9eRQZuDy8-H3b8tbdZVQSznUK9=yhuBV9vBFAQz3UP+iRg@mail.gmail.com>
Message-ID: <aO6-CbTRPp1ZNIWq@google.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Don't set GIF when clearing EFER.SVME
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025, Jim Mattson wrote:
> On Mon, Oct 13, 2025 at 3:33=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Thu, Oct 09, 2025, Jim Mattson wrote:
> > > Clearing EFER.SVME is not architected to set GIF.
> >
> > But it's also not architected to leave GIF set when the guest is runnin=
g, which
> > was the basic gist of the Fixes commit.  I suspect that forcing GIF=3D1=
 was
> > intentional, e.g. so that the guest doesn't end up with GIF=3D0 after s=
tuffing the
> > vCPU into SMM mode, which might actually be invalid.
> >
> > I think what we actually want is to to set GIF when force-leaving neste=
d.  The
> > only path where it's not obvious that's "safe" is toggling SMM in
> > kvm_vcpu_ioctl_x86_set_vcpu_events().  In every other path, setting GIF=
 is either
> > correct/desirable, or irrelevant because the caller immediately and unc=
onditionally
> > sets/clears GIF.
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index a6443feab252..3392c7e22cae 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1367,6 +1367,8 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
> >                 nested_svm_uninit_mmu_context(vcpu);
> >                 vmcb_mark_all_dirty(svm->vmcb);
> >
> > +               svm_set_gif(svm, true);
> > +
> >                 if (kvm_apicv_activated(vcpu->kvm))
> >                         kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> >         }
> >
>=20
> This seems dangerously close to KVM making up "hardware" behavior, but
> I'm okay with that if you are.

Regardless of what KVM does, we're defining hardware behavior, i.e. keeping=
 GIF
unchanged defines behavior just as much as setting GIF.  The only way to tr=
uly
avoid defining behavior would be to terminate the VM and completely prevent
userspace from accessing its state.

