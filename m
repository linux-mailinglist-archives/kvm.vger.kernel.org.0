Return-Path: <kvm+bounces-9937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 525D1867988
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07A531F24EF6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103B0133411;
	Mon, 26 Feb 2024 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QF+Gbx4K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5D604DA
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 14:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959000; cv=none; b=h2ggTarv73v6+kuiIicF1qgIPT4WxoAgzpBCHySO6kjotK0EMDZZJv2xKIQIwRj5isQ2Npw+Wgq7sZ9rKeTtU7tpiJ6Fe2fhIWDn687nFiPU4MK/uTnY4i09kmgwXaeHrVuyIV5z7E60OaEq6dwKjcsT2PTrqQyBogOEZMRWFao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959000; c=relaxed/simple;
	bh=4h1uS0OB13pX9giRpnNIP+0vjTvNS7C6s/4bG7aHMC4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rdk4HRo+0nQJiJJ9hP/H6DWUM5SuigR2xAj0am4XXA7tYnpT65Go05SRm52/XEjo8OtY3X/aidUNXsziiVOyqqMPH0pGK3plAfEqkKwKCy3sLXDnxAiDzFvJrFwFH1yBF3sig98rwShTzLIshdd5dR09sDX3NybhIJ/Dr5809XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QF+Gbx4K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708958997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oATdMi/DAQW7XnfLe/Ii99PaynQWsTmEg5BInunlmU4=;
	b=QF+Gbx4K5mogkEIW1Pp6ei16tU1GcimrnoL4+FfNd5Y9qt2AssognxKX8Be+3zdr0TChFY
	KqRc7N0RGcw4qS/QdVnJuOfvhUUrpvuGqH7K3h6idmgkVg/g7ARfkgXpD85+1UBJXIj50V
	OKgrKdYX1wzXv2n0ytcRE6CRWXz5xuc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-0GAlBIh1PjieN-Uf9B1rzw-1; Mon, 26 Feb 2024 09:49:48 -0500
X-MC-Unique: 0GAlBIh1PjieN-Uf9B1rzw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33de2d9bc74so269900f8f.1
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 06:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958987; x=1709563787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oATdMi/DAQW7XnfLe/Ii99PaynQWsTmEg5BInunlmU4=;
        b=KBUMcKqkwIXVBs9YSUtEc2tIuwCPaP27JXll5flT2ryP9uOsZR//dMMtyrk2KBjE4N
         QEvZFofD3sr0NrCkpVLSYcTWNO/I2cjl71dT37cfGN+LHk2kQmAewxDw4/wIEo47yqFL
         EHj6zTMH+SH0wQAMcyBy0gvFGDQ9HLUTLtYFf4uTilxIO8uxkzXmz7h7PShD+snVE5Ll
         eJOc9BqeMEFdxIQF0VcObrfa3FdtnDoou6SZaACVYSrMOt+Lti9pyw3nB+68/1tibwFo
         gjHz8pcAcpidViRtny6TPpyYeXbCOdmZMuYAR+8Ck2116UP+GfyyLABVXC+okNG9GARb
         Krew==
X-Forwarded-Encrypted: i=1; AJvYcCU3O8RCPXu1ixGsLm6Q6duB8TLWMsDgoNjqWkLu3LRnHp8ynYUy39gAxdNE7SHbpv7fNHJuicrEqnymEaWGzK0ThX2E
X-Gm-Message-State: AOJu0YyILGbRoJNIoTTpbrDxXoUULmTqRKuUqGBRjHWqevJQ5N0xUB6s
	znPcjFJmLskT/J4Go/DbJxZi5smOCVBrvdZaPEl2NdQvx9UgH/Pb5vdWpPTqOCdM5xL4vCxRyYr
	WXqU1WK7DDpTsCugmHjurKayr60fq119qKfs/FQDD/WyDuhrKr63J0Xvfk/w3B2A2wyQwxu14gY
	3zZodB9YXw0RAj3QrgKn0ji28V
X-Received: by 2002:a05:6000:542:b0:33d:222d:f380 with SMTP id b2-20020a056000054200b0033d222df380mr4786193wrf.0.1708958987318;
        Mon, 26 Feb 2024 06:49:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEh1Jo6dbimJnw7JwSkOJS+Z5z3FdkvM8eJF2SdeZSsY3mQqYpqZsnBJ6rTceTsgNv069XIT5VJPEbSzHHuOsY=
X-Received: by 2002:a05:6000:542:b0:33d:222d:f380 with SMTP id
 b2-20020a056000054200b0033d222df380mr4786172wrf.0.1708958987010; Mon, 26 Feb
 2024 06:49:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 26 Feb 2024 15:49:34 +0100
Message-ID: <CABgObfaSGOt4AKRF5WEJt2fGMj_hLXd7J2x2etce2ymvT4HkpA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/73] KVM: x86/PVM: Introduce a new hypervisor
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, x86@kernel.org, 
	Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 3:34=E2=80=AFPM Lai Jiangshan <jiangshanlai@gmail.c=
om> wrote:
> - Full control: In XENPV/Lguest, the host Linux (dom0) entry code is
>   subordinate to the hypervisor/switcher, and the host Linux kernel
>   loses control over the entry code. This can cause inconvenience if
>   there is a need to update something when there is a bug in the
>   switcher or hardware.  Integral entry gives the control back to the
>   host kernel.
>
> - Zero overhead incurred: The integrated entry code doesn't cause any
>   overhead in host Linux entry path, thanks to the discreet design with
>   PVM code in the switcher, where the PVM path is bypassed on host events=
.
>   While in XENPV/Lguest, host events must be handled by the
>   hypervisor/switcher before being processed.

Lguest... Now that's a name I haven't heard in a long time. :)  To be
honest, it's a bit weird to see yet another PV hypervisor. I think
what really killed Xen PV was the impossibility to protect from
various speculation side channel attacks, and I would like to
understand how PVM fares here.

You obviously did a great job in implementing this within the KVM
framework; the changes in arch/x86/ are impressively small. On the
other hand this means it's also not really my call to decide whether
this is suitable for merging upstream. The bulk of the changes are
really in arch/x86/kernel/ and arch/x86/entry/, and those are well
outside my maintenance area.

Paolo


