Return-Path: <kvm+bounces-66803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D2ACE8565
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 00:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8CF30301AD22
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 23:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FAE26A088;
	Mon, 29 Dec 2025 23:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/6p9tRd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ArcTywgi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9403B19D065
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767051133; cv=none; b=rXmsflAPnPgAsKCUlUIJRXkmJG5UbhMfeCBs57SqdfF+klsntmCUthdNIyCzS4ZRuL+UuAhyKL3BIoPRvf99s1BuYHc7BsLEdEVRUR2ZwqEEubl9qAG6ckBmT+sEMpBCXP2yfqjIwkGUDutLAZveryuHV/M5QkmZTUwL8aeomGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767051133; c=relaxed/simple;
	bh=VaUTBJSvsXqOdyELu5IE+MD12W5UGzmSoNASfvZi/Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mSOx6Sm7ATqFA3AZwy7adzxAlio1548tx3xDSRlpwN9iS5QlF957p0SnxLHYava5l+PKPLdt8bwy2k5/zxTtYS/GCCLB5+mc5VqFlrvE8WDGWOLMF3naLqch/hnVx1mqdY3hwaDskHEUHQ31AWvTAmNQoZdSmvUEalKJ0Dg1aZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/6p9tRd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ArcTywgi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767051130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v7kyRsrVIZk1FR1ZrY3E5P3tsJBemoVaSOEZHvIsuco=;
	b=W/6p9tRdC+emIKwnwNSq2QjUH9VyxUUpznDV23LIl0fnkidJGEACa+h9N+gl8egsi9Gzwy
	O6zTsCXz5m9QJCFR1HebDtM3gmAsxt9u6CTUnLY8Trd2I5WTofikkORUlOUMMBNbD2xaD/
	1rX3iqOBPB2a4/upEYY8/dwGzYW5jTo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-xeD_Bo36O3Wz6wNhWg31sw-1; Mon, 29 Dec 2025 18:32:09 -0500
X-MC-Unique: xeD_Bo36O3Wz6wNhWg31sw-1
X-Mimecast-MFC-AGG-ID: xeD_Bo36O3Wz6wNhWg31sw_1767051128
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43009df5ab3so5259670f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 15:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767051128; x=1767655928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7kyRsrVIZk1FR1ZrY3E5P3tsJBemoVaSOEZHvIsuco=;
        b=ArcTywgi+CJobT2sNHJBgCjvuqysv5rlATM0usOuA0v4lQ4uUaADb5hH3kw/bzMHJk
         7r6HY/OKxyzWwP+ifWK8mDXNHYxlvF6nP6/mAG+ikngUhF8Lx22pSoatc4ai4S7/YrAC
         flbYQRGHuSCJtQHq54QLXYF2wuVzo2CUj8KMLQk3WagE5N8H4ecjVLb8LSW8PjARh4l7
         A+yvHzOZeFob7ZqeV6EcVr+IDMZ4cJRNQpfvHcbqKMFzMA0xdQS6igOpEXrr0+a02wvU
         +l/F9LYdhe3hTsnxJCX3iuxiF7Zwu29i/AfmpYPR53GAw3xEs7pBRX3jj4t+I506N0QZ
         IMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767051128; x=1767655928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v7kyRsrVIZk1FR1ZrY3E5P3tsJBemoVaSOEZHvIsuco=;
        b=Lhfam2YYbf/I3A2xV6CJOf1VC9YFJ4hgo8LYMPHSOGMNzE66cFjhxPgPyNOp1SG1Cf
         Qq+jjITpT7DzsXnrT8WQ2RDyLRP0TfIfhql+DjSKwOwmDvwvthH6qTt4zj8/MUYkeozf
         vowjqG30Uffhz2cX76UQUPfvDjWLXvLJon9n4Je5Q1aSR8iDgPl85aZRq4z7QEjgVo8U
         qT1ohNWxjZRm0cO/2AsjIl6SjCnlVLAMy5jNIgtEbfCLz+N2VF9bsHxZCQzGM+qUr//O
         AyAcSF15NRp8wW6r2aumFksdNy34VOSKqpWMHT5FovJPo1LGXVaaYBeDqxgz0uTWZE/Q
         vOgA==
X-Forwarded-Encrypted: i=1; AJvYcCVz5/1HVKv9iElJYGSEh02So4Kyh/a8EvS8cjFhaC3hKKgIOeHsNRKMVSfK5bQ+f+fFq/o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrt5LTxAwJmB08fihkueOSSd/myeh09AOfBSdB4r1Q+YOguX5V
	MuOvb0AfRfXxjzsQB/BXSenHgtpWsE92pH6dwFVvnxuYLGfXWzxBGvSnf9b9bs+ksYF/a2DIHtx
	7UVhXT7h+Nj4rPO2oqEI+LC0kIv13DbcSmqEn3zTobDhtQOWP2xXrqPnterWSz/OJ1YGmFkur51
	8rdrlxyLU8bY4U6ICtsVML9VufjAZc
X-Gm-Gg: AY/fxX6O3n+MR06a4dA8O1atelYxVL/7gaqszwnLkmpT+fb/Q1Ba3DaU4Px5O1ZBI1y
	wmMEiP6a6truxxqYcYZOykv9rF46oCx1LkAGfQe+DA21jh6JgFCzbR3e+cCvoPzrL34kMi9Zy2N
	WOiBEKWkkmYm5DSgby+qBNiMeehIi1I9rpl2hZMtxoIHZMfCCta7hDjXVSWLmUcgcjd2ni7vp4c
	xGQCHU1ZjNxUdPqpS8d7kH17Q9tsMWk+odEHrCbbfQCozwJy4iwO9SPb/kuu49lfJNkcg==
X-Received: by 2002:a05:6000:400d:b0:432:8585:6830 with SMTP id ffacd0b85a97d-43285856833mr13154974f8f.45.1767051127757;
        Mon, 29 Dec 2025 15:32:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIxhgixRHcBcMAdNd0UXINlOW3YIfsEpQQ/A6lIz0y288uMkc+e8ZfLSmkvr/4xmOuW9yyMRjTyfAUVWwGL7c=
X-Received: by 2002:a05:6000:400d:b0:432:8585:6830 with SMTP id
 ffacd0b85a97d-43285856833mr13154948f8f.45.1767051126747; Mon, 29 Dec 2025
 15:32:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251224001249.1041934-1-pbonzini@redhat.com> <20251224001249.1041934-3-pbonzini@redhat.com>
 <aVMEcaZD_SzKzRvr@google.com>
In-Reply-To: <aVMEcaZD_SzKzRvr@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Dec 2025 00:31:55 +0100
X-Gm-Features: AQt7F2qTvZTEwMu-0IfQDRQ5ZbN8LxATYy1O8M2J6J0jA7it_Bo-SKmklPWdgEU
Message-ID: <CABgObfa5ViBjb_BnmKqf0+7M6rZ5-M+yOw_7tVK_Ek6tp21Z=w@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86, fpu: separate fpstate->xfd and guest XFD
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 11:45=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> The fix works only because the userspace XFD[18] must be '0' since the ke=
rnel
> never re-disables XFD features after they are enabled.

Yes, this is why I considered XFD[18]=3D1 to be a bug.

> Which is probably fine
> in practice since re-disabling a component for a guest task would need to=
 force
> the guest FPU back into an init state as well, but I don't love the compl=
exity.
>
> This also creates a nasty, subtle asymmetry in KVM's ABI.

I find this second argument more convincing; I preferred the
complexity of an extra field to track guest xfd, to having to patch
xstate_bv.

(Initially I was worried also about mismatches between xstate_bv and
xcomp_bv but those are find; When the compacted format is in use
xcomp_bv[62:0] is simply EDX:EAX & XCR0).

> Lastly, the fix is effectively papering over another bug, which I'm prett=
y sure
> is the underlying issue that was originally encountered.

Yes, I agree this is the most likely scenario. Whether it's papering
over it or otherwise, it depends on what you consider the invariants
to be.

> So, given that KVM's effective ABI is to record XSTATE_BV[i]=3D0 if XFD[i=
]=3D=3D1, I
> vote to fix this by emulating that behavior when stuffing XFD in
> fpu_update_guest_xfd(), and then manually closing the hole Paolo found in
> fpu_copy_uabi_to_guest_fpstate().

I disagree with changing the argument from const void* to void*.
Let's instead treat it as a KVM backwards-compatibility quirk:

    union fpregs_state *xstate =3D
        (union fpregs_state *)guest_xsave->region;
    xstate->xsave.header.xfeatures &=3D
        ~vcpu->arch.guest_fpu.fpstate->xfd;

It keeps the kernel/ API const as expected and if anything I'd
consider adding a WARN to fpu_copy_uabi_to_guest_fpstate(), basically
asserting that there would be no #NM on the subsequent restore.

> @@ -319,10 +319,25 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features=
);
>  #ifdef CONFIG_X86_64
>  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
>  {
> +       struct fpstate *fpstate =3D guest_fpu->fpstate;
> +
>         fpregs_lock();
> -       guest_fpu->fpstate->xfd =3D xfd;
> -       if (guest_fpu->fpstate->in_use)
> -               xfd_update_state(guest_fpu->fpstate);
> +       fpstate->xfd =3D xfd;
> +       if (fpstate->in_use)
> +               xfd_update_state(fpstate);
> +
> +       /*
> +        * If the guest's FPU state is NOT resident in hardware, clear di=
sabled
> +        * components in XSTATE_BV as attempting to load disabled compone=
nts
> +        * will generate #NM _in the host_, and KVM's ABI is that saving =
guest
> +        * XSAVE state should see XSTATE_BV[i]=3D0 if XFD[i]=3D1.
> +        *
> +        * If the guest's FPU state is in hardware, simply do nothing as =
XSAVE
> +        * itself saves XSTATE_BV[i] as 0 if XFD[i]=3D1.

s/saves/(from fpu_swap_kvm_fpstate) will save/

> +        */
> +       if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> +               fpstate->regs.xsave.header.xfeatures &=3D ~xfd;

No objections to this part.  I'll play with this to adjust the
selftests either tomorrow or, more likely, on January 2nd, and send a
v2 that also includes the change from preemption_disabled to
irqs_disabled.

I take it that you don't have any qualms with the new
fpu_load_guest_fpstate function, but let me know if you prefer to have
it in a separate submission destined to 6.20 only.

Paolo


