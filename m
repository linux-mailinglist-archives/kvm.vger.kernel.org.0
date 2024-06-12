Return-Path: <kvm+bounces-19431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48FF490504F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E81E51F229A7
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 10:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499DA16F0D9;
	Wed, 12 Jun 2024 10:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUuQ7s4D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1318116E89A
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 10:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718187601; cv=none; b=V9zVqcJgZ6JdXODczMVwdrHEJYvfo5FUhlGvtatCqzfACSY2DZve25r+6DJkAENic2bkhzFt0UEZ4y5jjNK/kI4aJYUSUeZ/u0vH3+EkhgDFBW2pPykEFciXFJ2v09HI7ALwO3Ja8Pxvb2tvw/+VwIuoRbvNhnqzpjf+snGcQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718187601; c=relaxed/simple;
	bh=DX/O7qdeD+FQnP5bOkwHHDCOlfBR2tLube9EHjIQaGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZmnBOMLNFxO+PjJ436hBwWqIqWjy2qAVK07J966RvGOuirCRe9cKc27kEZXxhlpaTH9nFYeJU48s8Zz+4rZ8CZp0Kgy8jtoyrjh116UgnFA/05P+cPczpgd12Kk3XMry4kZTYKQb35911mrzxsSW+5Wqt3SmeqPpf9S8p2gxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUuQ7s4D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718187598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rlCA4Ke/T+ZDAWf9BXbMMIWFjo2hQeBwjaAKfsSA+oo=;
	b=EUuQ7s4DbQL9C9G0i8NnmGSe3ZCIHQhfLTwgH9r4zPCYhSr1CaITof31+c1jRMBK78vaQe
	CGdYfKyQRPxuCiRwwutgBRKy56/veRYJHtACN7NLggXKh1NvB0fUEhSpA1+96/6M/jq53n
	3IEZ7SYBET/JeHU4m83LRTAKW6Z8ANc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-0_Mse4DLN4SEE1HVt3W2eQ-1; Wed, 12 Jun 2024 06:19:56 -0400
X-MC-Unique: 0_Mse4DLN4SEE1HVt3W2eQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3605cad23e0so226946f8f.0
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 03:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718187594; x=1718792394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlCA4Ke/T+ZDAWf9BXbMMIWFjo2hQeBwjaAKfsSA+oo=;
        b=PEWzGsprOf7Znk0KouAzRx9ng+Qy/bjA4ozOPWF56fLh9mRzyJuuL2cUAfb3lpf6JU
         NtFv58K+A7nY/53P41P5Oy3vYCL94+UB3PHfTL86wc2UgL3JNA9j+K27EeIItMn0eL5r
         E1BMCl2s7AdWu2d+cZsbKgg6gNEQ7o9sBoxA1YfCVUrgw8zNkWCDwx0MJs55KQY8qJ9B
         ggvv5pXMTN7vqRjv0y2TBlXfBs5SE2D7NGK4aejQ/qVXDvmFZuSI7LGnK9uvzeEt8xUA
         AyyDrIiq8ibDIOxUdw8CBQ0dezxDGMvMq/6W02/ZQkhx2IUZgQ0/yUqj+Wa6rwhIyWi0
         oAjg==
X-Forwarded-Encrypted: i=1; AJvYcCUIe95wyHvKAKuQgltGq5CxglsjnMHKC7PPm/rVnQU5PnBYyb6PbCAADK+I8HjKpcZgCT283eVqXiRciN6Caw1hcdCH
X-Gm-Message-State: AOJu0YxfP8DLEHwNyYsb5CA0aDEb9Y4ywETlUd35QvL6r25HoWS9zmZI
	Nymqj+SDnaqYRrj0qNDJdXzNLLqOCW1rnUrhu0gJme0YzaGBIDSuEtEDCEz4VzlZ0fvGR3CfPFw
	hKpwAzN3YLpj+I7EMG+0GHS22TTBRuw3ngh8CNZV0qcgPzHtWAytX0ZktMucaEGdMgq9taBxzzM
	4LwJqI0HpEwghj85zX6LvINVNv
X-Received: by 2002:a05:6000:e88:b0:35f:2a56:5b79 with SMTP id ffacd0b85a97d-35f2b273b4amr4502035f8f.7.1718187594635;
        Wed, 12 Jun 2024 03:19:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZpg528uDd1HmlAAgn89ZTKSCBFChZd9Ec0DZSO29p+hI7l0SubcoOJXePMPSepx3Lew2dyQ/uR3zLtRgWLJM=
X-Received: by 2002:a05:6000:e88:b0:35f:2a56:5b79 with SMTP id
 ffacd0b85a97d-35f2b273b4amr4502019f8f.7.1718187594339; Wed, 12 Jun 2024
 03:19:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507133103.15052-1-wei.w.wang@intel.com> <171805499012.3417292.16148545321570928307.b4-ty@google.com>
In-Reply-To: <171805499012.3417292.16148545321570928307.b4-ty@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 12 Jun 2024 12:19:43 +0200
Message-ID: <CABgObfZCNN4AdzGavqzFANCLq4E5pi+h2+mr9-cysZrFk6bUzw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] KVM/x86: Enhancements to static calls
To: Sean Christopherson <seanjc@google.com>
Cc: Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2024 at 3:23=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, 07 May 2024 21:31:00 +0800, Wei Wang wrote:
> > This patchset introduces the kvm_x86_call() and kvm_pmu_call() macros t=
o
> > streamline the usage of static calls of kvm_x86_ops and kvm_pmu_ops. Th=
e
> > current static_call() usage is a bit verbose and can lead to code
> > alignment challenges, and the addition of kvm_x86_ prefix to hooks at t=
he
> > static_call() sites hinders code readability and navigation. The use of
> > static_call_cond() is essentially the same as static_call() on x86, so =
it
> > is replaced by static_call() to simplify the code. The changes have gon=
e
> > through my tests (guest launch, a few vPMU tests, live migration tests)
> > without an issue.
> >
> > [...]
>
> Applied to kvm-x86 static_calls.  I may or may not rebase these commits
> depending on what all gets queued for 6.10.  There are already three conf=
licts
> that I know of, but they aren't _that_ annoying.  Yet.  :-)

I think it's best if we apply them directly (i.e. not through a pull
request), on top of everything else in 6.11.

Paolo


