Return-Path: <kvm+bounces-24990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6930F95DA14
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 02:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E4E283718
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C73CA32;
	Sat, 24 Aug 2024 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fvzXj+CR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2043A1388
	for <kvm@vger.kernel.org>; Sat, 24 Aug 2024 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457867; cv=none; b=D9sEESohkPW6i3O1auwv9ZfZLKcvJl87PX09RVP0X1wfK/cGf32GQ5CrkesSmnPgRn++1Id6x24IcBRwYTvGROWhN1S1FDUo3+xjWbKR6/0E4AI3oAFDFlGY+NH54whkk78tuiFK5ARefgW2CjK2xPrgXCu5mEx+5GNUyQbMCgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457867; c=relaxed/simple;
	bh=0xG0S8/UkIkI/nRYACzCp8C8N7AggLP5xaj59lpIjPI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V+gy4skPh7RfEdksaec4PHqWbYgrpgJS1V9VSmwWRWqev+rOipliQizShQ6tIzohTCHF+CgbuLLMeVuSnljmi/mfC6SW0N339N5gbOtRnsOUwQjAqNxsviuAGPoaxXTkFIR9JGcVvzJR/FqwXszcpnJYpUCk49RsMZWw+bYuoJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fvzXj+CR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso1744520a12.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 17:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457865; x=1725062665; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HPpi6gGER7s47NXj3m6rQIuD6YvzPvzRxn85EJyyePU=;
        b=fvzXj+CRfspDc7ZLIX+Nt5R8fFJW9TLJgcSM8RuFdPUE26VEJcSzZjTInNUZ+sUp9S
         G61cNof05US/UNFfq4Q4DxNYM7tWn8wfqAVqQ0dtlYHcztGmLjD1cP869d/YWY4xvGIL
         Y1VSzDgIxFbDSuBd3W0JDj8wTK2oJ+H5Vb63ffx8Tkf7EK9MKOajWDv+GNRMBO3AmNGs
         CYFPe/oztEdC0bhfu/XiN3zKYjZh6v5509vR4BTLKR+y8Ap1tEKb9i/uWWpVRbrk4RI9
         c7YWyOdc2nIrUoNtrCV4hPKnAFqZ9x/VvoOsVGQimE1g46Ii6xKqN4B9LLrql6d5XOZK
         /XTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457865; x=1725062665;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HPpi6gGER7s47NXj3m6rQIuD6YvzPvzRxn85EJyyePU=;
        b=Fy43INxG97YmfeGiiUVYp6my+Ubc4CARv+Y7WjHRjSz740hyzaReDS4CLIKD+4Kugp
         lT62ZKSC6fLZOndHLMiVLdLGu/iHjJcnfYuQ/RwQR8oZVQ/nEGvLzkOF9INCGdaMRmss
         JdqL16sIZKodzvJZXLsUk5voLFBtF+avzC8ZTvOmcPpQ3LEKxYlpq4CfYUAANkRzwu6j
         CrC/y0kpVvhgqunFVHiieKd7kSUVbCkQbijaaRyDB36b1XA9DRfw03cRb30I6hiHplIA
         yPrHq8qxyKvxXeV/+Y503iwBzn8L1tJ7Omw/4Ncf2Y49Dj1fLFpiYn3gY+vQILdDLvHz
         qwZw==
X-Gm-Message-State: AOJu0YzxJh2+R1l8EArrJVUPdfj8vFptJR0cdgUPOVMe6Dc1NXqEjoK9
	/qyVSDAqh5Nk99i+nW7R9c8IVRFhGMufrTHZAz9JLwFyDyQuHfMNvWLQp5EV4FHfn9NyMcdFeBM
	wEw==
X-Google-Smtp-Source: AGHT+IHe496PpSnfuOMQTES9fQcEL6/TNuTZtcXDXXiDKRk8vaQvcRM5m7aPHP5L/bz8nt2U9LNdgkKYoM4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:483:b0:7b8:b174:3200 with SMTP id
 41be03b00d2f7-7cd97d0cc9bmr28126a12.5.1724457864978; Fri, 23 Aug 2024
 17:04:24 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:04:23 -0700
In-Reply-To: <20240820133333.1724191-2-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820133333.1724191-1-ilstam@amazon.com> <20240820133333.1724191-2-ilstam@amazon.com>
Message-ID: <ZskjhzkfQDtJVnDI@google.com>
Subject: Re: [PATCH v3 1/6] KVM: Fix coalesced_mmio_has_room()
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk, nh-open-source@amazon.com, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 20, 2024, Ilias Stamatis wrote:
> The following calculation used in coalesced_mmio_has_room() to check
> whether the ring buffer is full is wrong and only allows half the buffer
> to be used.
> 
> avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
> if (avail == 0)
> 	/* full */
> 
> The % operator in C is not the modulo operator but the remainder
> operator. Modulo and remainder operators differ with respect to negative
> values. But all values are unsigned in this case anyway.
> 
> The above might have worked as expected in python for example:
> >>> (-86) % 170
> 84
> 
> However it doesn't work the same way in C.
> 
> printf("avail: %d\n", (-86) % 170);
> printf("avail: %u\n", (-86) % 170);
> printf("avail: %u\n", (-86u) % 170u);
> 
> Using gcc-11 these print:
> 
> avail: -86
> avail: 4294967210
> avail: 0
> 
> Fix the calculation and allow all but one entries in the buffer to be
> used as originally intended.
> 
> Fixes: 105f8d40a737 ("KVM: Calculate available entries in coalesced mmio ring")
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---

Doh, I applied v2 instead of v3.  Though unless mine eyes deceive me, they're
the same.

