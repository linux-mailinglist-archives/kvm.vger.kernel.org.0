Return-Path: <kvm+bounces-12182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1A38805A5
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 20:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB4D1C2275D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 19:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5514D3B1B2;
	Tue, 19 Mar 2024 19:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTX7v9mA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470C39FED
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877697; cv=none; b=FL4WF2bzHegdvIIfRkh4A8mjmA5KRwuomf+12sKeQLl+igGWiaism2J9LW9kh1y8qaioah2cKGdAJfdpzKCTTvwZP3/gUyj6rNpTIad2O28QSS5gEtTFN4JEcsXAapiGenef08ieOErxyxdo9ZQ0bjrCacnBJoWSQ8bFGBFVhtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877697; c=relaxed/simple;
	bh=mYlKk2l0BwlOcMPHHRe9Lu1kct0DV6YFCdPeelfZ340=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOZ5QwFYrmheHrMCvndFSnx5kj/hyQSSYHAA1ATpnn+nW+n1uLjAHqXQ4yWlSQmP5gbv212wb2H71NTygn2eatOp3pvvSxPTyq9iGKCG7tGbBrEfkhaVD44pUzLfA2tiX3ce0CpmKm72mMfn0OZIakxqt0IrFlQL2Rz4BItu63k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTX7v9mA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710877694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0tBZy10sixK8JirSxxlugqPqYcAtueR8XsprCYR2ss=;
	b=FTX7v9mAOogsKXI/6UMZKpQqz7yEpJIMDlPxFLU/VQxzwBTtbhD3eAlm3A6/jbLODnkIsC
	rJRiphbKftC2DFcBgHwhYnd7Dx1Td4HukKSombPLs835RStpZYB0uLArBIAzhLe7TcP0r5
	GGkHrHrEbByj5yM1lAMCIX4FiIiXOvY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-BPkgWvONOb-iyP019otmtw-1; Tue, 19 Mar 2024 15:48:12 -0400
X-MC-Unique: BPkgWvONOb-iyP019otmtw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40e435a606aso32338355e9.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 12:48:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710877690; x=1711482490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O0tBZy10sixK8JirSxxlugqPqYcAtueR8XsprCYR2ss=;
        b=PZPZmlU/0FCUl8YVQAtDgqD/uuN/lzkvGQfOj9uKEcVwi8/p5AeB4Hnz7gKqoqzHwG
         8hc5dp53GtgkOOMXNCquI1LPDweZnbl7m6FG7Ip5HBfI4SvBz7/jPlmIXAWdZ4g+vi3O
         NaR3Of3jvkjHYNLVc0CK02zUq59OPjE1syACNkm6QoQovKlbTh8bxDVhNsP7YFG3AlCG
         xSITbFURg6PaxA0GQxygH/LeQ1kuYqOr9TcpoD+8Ydmmm83c0KxcIuluIhKQlBKQpUwK
         CmwsjAfsryZqw3w0JnS/UePJ+RyqXTpl6nMLN5MyDAJcXZNB+9oxvlgzsy9tVgLnNdr5
         xXPA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ/ds4hpPyWoPgYjKz1SUDF6gQ/Os/73zdlqjYNp4SNWy1rPX5c9ogd286c5Ww9N9/En4xKaSpP7YrzxvS+r8/cyCT
X-Gm-Message-State: AOJu0Yy8z5XHfCei+kIgUrEjpguff+B8v7GhyDv3AqWlL6NMxvCyMp2J
	y9jKdWU/C1vMR9umh5Xp+S+nk9wVPGoafSouYZ7fzUujKR7ZTkUs4S+QLdRZy8aPHvfOSnG/cri
	paWwlMksTKRH21wf9iaXHAhHhHXTlkLJbJMPyxIvGwlESFOPoUsXUA8M4LEpPlwv6jUVIPTzrl4
	i8N7ET/T1dkNVSeg5CrDCI0t6vKqcfvTym
X-Received: by 2002:a5d:58c2:0:b0:33e:bc7e:cadb with SMTP id o2-20020a5d58c2000000b0033ebc7ecadbmr2385777wrf.41.1710877690731;
        Tue, 19 Mar 2024 12:48:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+QvIljcIX0kbSi4NZsFu/hQLTEFLR7591e9VToTE2vLVQvCgVTTc/SfmfHIllDHxysuZVuJO3Wj60wKhPk2E=
X-Received: by 2002:a5d:58c2:0:b0:33e:bc7e:cadb with SMTP id
 o2-20020a5d58c2000000b0033ebc7ecadbmr2385767wrf.41.1710877690419; Tue, 19 Mar
 2024 12:48:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318233352.2728327-1-pbonzini@redhat.com> <20240318233352.2728327-10-pbonzini@redhat.com>
 <20240319134219.evphel2bmyopdz75@amd.com>
In-Reply-To: <20240319134219.evphel2bmyopdz75@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 19 Mar 2024 20:47:58 +0100
Message-ID: <CABgObfaGT6MBX_0XHmmJzDxFo4pRHED6-U=oGrH24PAqDGrk1A@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] KVM: SEV: sync FPU and AVX state at
 LAUNCH_UPDATE_VMSA time
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, seanjc@google.com, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 2:42=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
> > Since the XSAVE state for AVX is the first, it does not need the
> > compacted-state handling of get_xsave_addr().  However, there are other
> > parts of XSAVE state in the VMSA that currently are not handled, and
> > the validation logic of get_xsave_addr() is pointless to duplicate
> > in KVM, so move get_xsave_addr() to public FPU API; it is really just
> > a facility to operate on XSAVE state and does not expose any internal
> > details of arch/x86/kernel/fpu.
> >
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/fpu/api.h |  3 +++
> >  arch/x86/kernel/fpu/xstate.h   |  2 --
> >  arch/x86/kvm/svm/sev.c         | 36 ++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c         |  8 --------
> >  4 files changed, 39 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/=
api.h
> > index a2be3aefff9f..f86ad3335529 100644
> > --- a/arch/x86/include/asm/fpu/api.h
> > +++ b/arch/x86/include/asm/fpu/api.h
> > @@ -143,6 +143,9 @@ extern void fpstate_clear_xstate_component(struct f=
pstate *fps, unsigned int xfe
> >
> >  extern u64 xstate_get_guest_group_perm(void);
> >
> > +extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr=
);
>
> I get a linker error if I don't add an EXPORT_SYMBOL_GPL(get_xsave_addr)

Indeed, and also the format for the 10-byte x87 registers is... unusual.

I sent a follow up at the end of this thread that includes a fixup for
this patch and the FPU/XSAVE test for SEV-ES.

Paolo


