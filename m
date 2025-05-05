Return-Path: <kvm+bounces-45432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 548CAAA9939
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02E17189243A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 16:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206721A316C;
	Mon,  5 May 2025 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="liVHA4Cb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC0E19341F
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462893; cv=none; b=DluHKcizqUanzJgsEqi69GhnzDRg9tj+OlrLjFBH8YDGLJl4JbBpgaFoGEEauCl1dWL9pe6hE8EXODJLk8K4NGKfGCTRFBsw9+AI17u2adlX6mIjQzP1eyf3NS3mbbswJV5DIe992MTl6Gt/vR6XUrqYeQpJkoJLOJdbgxp/Iss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462893; c=relaxed/simple;
	bh=A12Scv7ytXIGYDwUN8lKj7+z0agiYKiJJY2n1zzTEjo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gb3L2l3tyZZ3GbnHahsyoo0l4N2ceo7LgU43WgL92/IgNYHh4ZiLu76qFUjO0jyYi5e/bVRinr8S8jcqWqHC9cmklaYdoo65Z+5bOiMse48Zvqx7QNtk1VO8Mw+xuxrWN4snmUEpA2ZarWyFHUQhgdiQS/VF2SzO8To2fnKIcH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=liVHA4Cb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73dcce02a5cso2791784b3a.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746462891; x=1747067691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiBa6zb0lDhzXPXRhzuTGt3+NvizFZFKEQdim+eMko8=;
        b=liVHA4Cb8KgkaE1Z3lPjR3fwJ4RNQSiUqpQEmpccnLQNOj3FEiIEOriQt9/Niy8Sia
         HscqqDHgfMd68aultyVNJm1Q8US81EO6ZHCS1r8m+PioKK1bX+yRgntyVaOFytvs03z+
         Iys3XQ1XtFgJBaQnxm619spbWHWrNX4o9sNngPhwaDxXGwolDQQbN7hLEKsUcCB7YHBr
         IcrahmaIeitK24qPfAsDk+fcMRXM217gTIvMgf/GK5kNSC9+sPcsTElxthp1l+dOmfSW
         EE6t86iT2X19HkhyQAuANm+cFA9rwBbCcZguUaB7Cjv4JFUwzSr/GomsdE9qxm921vjD
         c7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462891; x=1747067691;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eiBa6zb0lDhzXPXRhzuTGt3+NvizFZFKEQdim+eMko8=;
        b=jxkaT6fzjcPApUMeiPBQr34TA0qwyvE2iXnE0vH73imz2m9l6NcIhjEIGA5QUx5RRr
         rR32YRMmIj8uzk/aLVTdJSKwL84VR9f8fCiAC5ECsFRbTZUQEH8kaOnoGxMx+OUHCDjp
         eWgeY+uTEC0FLJ/ezfK04O9fF3ZflwpO4xIra2cXTA0Y5zCn5+diN1mlutw5UMcwB2jA
         PbFxTIcORA17XhpY49CAgHLQBuul7rBRQaQ//RhUb/nX+KFyEakbamJW7GhXLB/YMss/
         D+mPscxf9rETOERc74SOScmBaoq/PEPLQjmsbjUQMspfWA8Qie60rK9X4Jq0oD6ddRnG
         sn3A==
X-Forwarded-Encrypted: i=1; AJvYcCVfWcvh34yaaCOFfrobBjgfZnC85wOToPKuBZwzH8e5x2VL946V9Y5l9J/nZpBfzHjstgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YymbFVmmU2M8uh//VUdkwPpWdTuN2CDuhxZwv7T/j28q0+PmotK
	Gyvfhrh9hly3qtYDD93kvVrZXVoLpM5Ac1lvDDpJgPdld0GBFaTfp27xpy8dJyEGk3U6vsJ/BcU
	VIQ==
X-Google-Smtp-Source: AGHT+IGYJWs2r6Yy1GErbwJ4rX8nNUsnKXyjBwCp0QzTIRA6FoH/LhpBo27Spr+rArx9lXGnAWetGjkoXS8=
X-Received: from pfde21.prod.google.com ([2002:aa7:8c55:0:b0:736:3a40:5df5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:90d7:0:b0:740:6f69:dce9
 with SMTP id d2e1a72fcca58-7406f69decbmr8901171b3a.0.1746462891238; Mon, 05
 May 2025 09:34:51 -0700 (PDT)
Date: Mon, 5 May 2025 09:34:49 -0700
In-Reply-To: <CALMp9eS7XHpFWMAtnJPQijYO1TVW25-UGmFqc33eAeb1AE_9YA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-2-jmattson@google.com>
 <aBAIL6oGYJ7IV85X@google.com> <CALMp9eS7XHpFWMAtnJPQijYO1TVW25-UGmFqc33eAeb1AE_9YA@mail.gmail.com>
Message-ID: <aBjoqW6qzoc2RGrZ@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2025, Jim Mattson wrote:
> On Mon, Apr 28, 2025 at 3:58=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 88a9475899c8..1675017eea88 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -481,25 +481,15 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu =
*vcpu, u64 nsec)
> >             __rem;                                              \
> >          })
> >
> > -static inline bool kvm_mwait_in_guest(struct kvm *kvm)
> > -{
> > -       return kvm->arch.mwait_in_guest;
> > -}
> > -
> > -static inline bool kvm_hlt_in_guest(struct kvm *kvm)
> > -{
> > -       return kvm->arch.hlt_in_guest;
> > -}
> > -
> > -static inline bool kvm_pause_in_guest(struct kvm *kvm)
> > -{
> > -       return kvm->arch.pause_in_guest;
> > -}
> > -
> > -static inline bool kvm_cstate_in_guest(struct kvm *kvm)
> > -{
> > -       return kvm->arch.cstate_in_guest;
> > -}
> > +#define BUILD_DISABLED_EXITS_HELPER(lname, uname)                     =
         \
> > +static inline bool kvm_##lname##_in_guest(struct kvm *kvm)            =
         \
> > +{                                                                     =
         \
> > +       return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_##uname=
;        \
> > +}
> > +BUILD_DISABLED_EXITS_HELPER(hlt, HLT);
> > +BUILD_DISABLED_EXITS_HELPER(pause, PAUSE);
> > +BUILD_DISABLED_EXITS_HELPER(mwait, MWAIT);
> > +BUILD_DISABLED_EXITS_HELPER(cstate, CSTATE);
>=20
> The boilerplate is bad, but that's abhorrent.

Assuming it's the macros you hate, keep the "u64 disabled_exits" change but
manually code all of the getters?

