Return-Path: <kvm+bounces-55889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB16B3876C
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 18:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6B0E1B2683F
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6795D30FC1E;
	Wed, 27 Aug 2025 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUPkMt8G"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4621A0711
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310950; cv=none; b=GYrKYAahwQCK8j6qCLd2Kum9o9OQF6SHF7hLiTpKefnC4AcOaT1evpZjRQtm2qOV5AcRNb2aU1xDmfVoXgNvOPosmOYiGo6pVgwWekEtI8LlPfp4CUmayTNchtU1T7cQl9zkd+bo8y7+XQgKHuhBcXLRAdj9ZzzIGxz286rA4fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310950; c=relaxed/simple;
	bh=wlTH+5UGUT9Xvxi73T4MXazMDiYu+KQldwNPj3NcMc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUIkxOMH+F9xBbBmGN8nFI8/ViSYxf1RiQjeyCbJnH50VTm6kMtxDD4PDolpj5vXwhrnq83wgTmLek0B0q1HggsmeqDD2VM7F0COoUTquw4a2Wc1GLmDMuJp/yyP4bglmzBPJHoHUX5N/rKz7pZ5fWy4gSr45uD65LzTa2CPwt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUPkMt8G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756310948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aziSJBo5W0zZFPc57AR4Qia1md3fUN9PvjS7bGiGW2g=;
	b=CUPkMt8GPzznpwpYnwLR+9r3NvPWyVl40otQ5GCE+xF0Qr3YsEYddCLTsUmYfNTw/1HI94
	up4UKWnNymv3TpD4XF3VPXJP3IhO9uwjNr1BUc0WbdEeS3q6Es/8jsQvRRyhZY2+/Ffgai
	A7fqcF+PMKtiQguOGdB8m6uYcvG1gps=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-dvA64a8PPseYr47fjtjfzA-1; Wed, 27 Aug 2025 12:09:06 -0400
X-MC-Unique: dvA64a8PPseYr47fjtjfzA-1
X-Mimecast-MFC-AGG-ID: dvA64a8PPseYr47fjtjfzA_1756310945
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b71fe31ffso5236925e9.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 09:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756310944; x=1756915744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aziSJBo5W0zZFPc57AR4Qia1md3fUN9PvjS7bGiGW2g=;
        b=XQxZaKRHv1WoLf2uX5cM31dxZJJvhVB2zrhEQtQxmJ1wLQKBg4I1zcdLPCF8NoH6UA
         dQCYaFhV/KWlMM+45rHq45eH5qKGyBvCVVQj6+dFLUOaWTGG7puSGxZmFqSf6YxOQsnu
         7ucESGte7ZQXEKQDeF/Agup2LL3KNA6rKzQW4qmjIIpkcXu/2nYK+IqN3NgAvbtz3G0P
         nN9IbT8jlwX/4kP3/2zQTVi3Qcu7cLXz/FC5QOMD55tdjclt+Lbtf6UKW89PDDbld9I4
         qk9v2nqZHuWeLbmHq5qcPZCW5WeF/qiNKMyx4qxN2ISGI0jNedZ8bO9BNwzTnuyv8uBu
         QvZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5W15SFWcEsgYumXIn6Pa1muzgvApTAApBCKe6YA3psF03vtWeE+sXty+rGP4mmRaqUZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY/6RBN9evq5m4/I0azQVrMAX1vkhsXK55aOgyrQoeuR+CQhuC
	WEXGTdZoQytrrZ/K78FnyEatWHSgEVrwAhb6pCiTwvSr6vKY6aoo/3Ot8XiGX3SKk6WMMmDEG1K
	08iKEclQyPxCrJxyscVcyuTto+Z/xSMev7Q/gUpVC+9CFJaFx4grv/hUQTBPzBQ2Scqw4z10jru
	bPLdTZOQ8A5Vihx6EJ4m6GnB7OAXZJu627NssN
X-Gm-Gg: ASbGnctdKPKFULcLOcVU5UZarYVhTxqhKWH4rPeC9R68Lh4x/Cpj1kpPqwGd8/hK9vB
	f4KUmHD1HFV9948tQezVetBR3fkZKKFRu8r6WX7BQREpj6BTTld21UHLPbgfJPJrcIP6zn4Ort8
	hzJSGlo8Mcx/+WWCwV4sQn4xwv/TGiNH9LlIbz/Ul5VWFhKKK+XyyZClGRRpGFYRVeNFtJKhhla
	fXbk9yIkuiBeJP8ckGdZQmG
X-Received: by 2002:a05:6000:4283:b0:3ca:3206:292 with SMTP id ffacd0b85a97d-3ca3206064fmr8023185f8f.48.1756310943671;
        Wed, 27 Aug 2025 09:09:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyzruEFQtE9U3R7B7rCEUd8qatzIadAOnmk2mQCbEKGI0DFr7kcsvt9yS7Q0qnfidsQFJAmgRQ1SijtcNlzA4=
X-Received: by 2002:a05:6000:4283:b0:3ca:3206:292 with SMTP id
 ffacd0b85a97d-3ca3206064fmr8023149f8f.48.1756310943213; Wed, 27 Aug 2025
 09:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827152754.12481-1-lifei.shirley@bytedance.com> <aK8r11trXDjBnRON@google.com>
In-Reply-To: <aK8r11trXDjBnRON@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Aug 2025 18:08:51 +0200
X-Gm-Features: Ac12FXyXHiiKVDGGLGUulr7kfdt9R7TiAvRQk5lVCccDer67HJTPi0VyzHtDREc
Message-ID: <CABgObfYqVTK3uB00pAyZAdX=Vx1Xx_M0MOwUzm+D1C04mrVfig@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Latch INITs only in specific CPU states in KVM_SET_VCPU_EVENTS
To: Sean Christopherson <seanjc@google.com>
Cc: Fei Li <lifei.shirley@bytedance.com>, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, liran.alon@oracle.com, 
	hpa@zytor.com, wanpeng.li@hotmail.com, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 6:01=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Aug 27, 2025, Fei Li wrote:
> > Commit ff90afa75573 ("KVM: x86: Evaluate latched_init in
> > KVM_SET_VCPU_EVENTS when vCPU not in SMM") changes KVM_SET_VCPU_EVENTS
> > handler to set pending LAPIC INIT event regardless of if vCPU is in
> > SMM mode or not.
> >
> > However, latch INIT without checking CPU state exists race condition,
> > which causes the loss of INIT event. This is fatal during the VM
> > startup process because it will cause some AP to never switch to
> > non-root mode. Just as commit f4ef19108608 ("KVM: X86: Fix loss of
> > pending INIT due to race") said:
> >       BSP                          AP
> >                      kvm_vcpu_ioctl_x86_get_vcpu_events
> >                        events->smi.latched_init =3D 0
> >
> >                      kvm_vcpu_block
> >                        kvm_vcpu_check_block
> >                          schedule
> >
> > send INIT to AP
> >                      kvm_vcpu_ioctl_x86_set_vcpu_events
> >                      (e.g. `info registers -a` when VM starts/reboots)
> >                        if (events->smi.latched_init =3D=3D 0)
> >                          clear INIT in pending_events
>
> This is a QEMU bug, no?

I think I agree.

> IIUC, it's invoking kvm_vcpu_ioctl_x86_set_vcpu_events()
> with stale data.

More precisely, it's not expecting other vCPUs to change the pending
events asynchronously.

> I'm also a bit confused as to how QEMU is even gaining control
> of the vCPU to emit KVM_SET_VCPU_EVENTS if the vCPU is in
> kvm_vcpu_block().

With a signal. :)

Paolo


