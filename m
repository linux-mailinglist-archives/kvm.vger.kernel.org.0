Return-Path: <kvm+bounces-36599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A20A8A1C4ED
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 19:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3DBA166BBA
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 18:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A037E110;
	Sat, 25 Jan 2025 18:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fk8qJ4+6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BC800
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737829930; cv=none; b=bJSWIp6utXgHpbT1CcUirE2LNEwMqDJdHcQUIMbH/mISvoTf8BjbQoZH2FZ77ILlNTex5NpB3g1DazEKZmCv07YJiWkN+CAGieNihGWqIN7gTjY6l6Ay85PPYw3GcqK2Nehv372Y/XdqayhhPBkGn38YGrIhKsyOV20oH+XulKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737829930; c=relaxed/simple;
	bh=cUl0jzJHquJQJUFPHqKgdsRKj3h/BMGrPjJk+bSV9TI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/n4lp4b3AVWYNEdNX/A/wX0m3Ai05ZnlRkeE1xk/Ea9VQE4c/UjVKGVC/yiznQuYlauRTARztQTKS/TeakqnkC1NScm+A8oKmr4asepPMlDYIkKt44MXnnHkApqXwu3NA2AH8ZL+BHKpKZDPOdhw7eQET9v+ncUqH9UrD1HMIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fk8qJ4+6; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab2c9b8aecaso568174366b.0
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737829926; x=1738434726; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hu+HZUUV5L8hgrDCHHTCTp5wNGkBQGspCZ/RHKDZ1z0=;
        b=fk8qJ4+695mtGRj8Hcfi5qR8vTz3cXPTsSJV+xVxzbLtNrEoFxzxWvrwF333+bRwZo
         3onV1IfRohJaKpMnwX+Ya66j1JytU0tP3zkisyEV2/BQvDuq3rV4TvWnpwRm2OkQ9l75
         zxyefRKR7r5QPWM3OJ5SK/cHoye7Rna17ORd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737829926; x=1738434726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hu+HZUUV5L8hgrDCHHTCTp5wNGkBQGspCZ/RHKDZ1z0=;
        b=BfPIo2jWZAV6qMsjoGhvZsyrUDPtv3cK0LKXGtHHn4ifo+QHIHQAlBRgbvTSscXdIp
         1WG+5lDpaIfBec19ijJfp8eauVFBsV3z2XdqOtPnEmNctN0MXFExXyE8K0QtsRda1eo9
         dL36I356H8ffLVVh8AYk7+IMnb6alZJATenfC/QB+Mw90W0+9wKXPk2ZN3vj6on/UQjB
         4nCzhl3O8Xom/FuLEBoYdfmjjMOn3njjXoZIpGpJXYSbwho1yVLPfH92QqXHUk6MaN2w
         cSmZTG/4R9GTp+8iZmW/e32AseTWTgqsn4U4bLEGwf+EL2RvrvJhNYoKhSoQglTUtlyS
         gNPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh+WmqreH47zuSgA1k+zxfo+ExvWKQhCWwQIK4yCWmLQXye3furP7EI0qw0KJZ68tLP0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpjNAtqYou/hvhbMagfHsizYhf3xuX07NBkJnpzK9IoX62nfU7
	M0MF/eh/TbzZO7mjdDrf4BykYdp/+GwfpApd8bz2cYVg3egWH2aJcxcDIrvMUBMZo0obLRHAYZj
	Ao1g=
X-Gm-Gg: ASbGncu+zVP2DnMmMr9SNDh2bNBceZ1+LOYu+fzA3y3Ak4QsecEdH3cy+RvIPlICly1
	P2NudTBFvEVwXvqPp/ikB5eVCVdt4zw9SQMETClfJpuSWzopw1BP4yRBjdRwVbrV6o/7ADPc5Tj
	zJLtAMIQBIyJFyp/viUMuzpMYYjDPdxxjZ9M+P2uCWy2YfoozT/n0geLKlhAYFbq/OeSwoqkc2r
	n2Im+Quo45luKqJGc9LekTZhzYiarq+mlHuiN1lX4cKKDPoYI8NG6GeCgJtlqQfBlIkYV8R58bf
	OjnJTZZx9rHVcH7UhbzdvZlov673Q88pGOPMhIPaCKV5Wse0SMS/CQQ=
X-Google-Smtp-Source: AGHT+IHuIkjqXm4FipJRq5pwHwfZJzP8YEC2WdUxmgYK4sH7Hp5v8LCfZraGufQlgrgnwFMaT2nW/g==
X-Received: by 2002:a17:907:989:b0:a9a:bbcc:5092 with SMTP id a640c23a62f3a-ab38b380857mr3251822066b.39.1737829926337;
        Sat, 25 Jan 2025 10:32:06 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab69b47f622sm8299366b.39.2025.01.25.10.32.05
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2025 10:32:05 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso5986979a12.0
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 10:32:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVlIGNF0ARCruzp509ib+sAzA3WsmfK7RfRilV/ci8v1hFFN7YqewV9Ng25tuYv8ZHJhNE=@vger.kernel.org
X-Received: by 2002:a05:6402:3551:b0:5d1:1f1:a283 with SMTP id
 4fb4d7f45d1cf-5db7d2dc3f1mr31215072a12.4.1737829925423; Sat, 25 Jan 2025
 10:32:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
In-Reply-To: <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2025 10:31:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9fNzDy0dTJzKj3RiSp-puwNawxQ5+ULMvKKjMRV=eqw@mail.gmail.com>
X-Gm-Features: AWEUYZmKfRu1wEsS8o1vL-JVzbFoRXfr0R1dkgjoERXnhnatvqhyXxo_Y96YIAE
Message-ID: <CAHk-=wj9fNzDy0dTJzKj3RiSp-puwNawxQ5+ULMvKKjMRV=eqw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Jan 2025 at 10:12, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Arguably the user space oddity is just strange and Paolo even calls it
> a bug, but at the same time, I do think user space can and should
> reasonably expect that it only has children that it created
> explicitly [..]

Note that I think that doing things like "io_uring" and getting IO
helper threads that way would very much count as "explicit children",
so I don't argue that all kernel helper threads would fall under this
category.

And I suspect that the normal vhost workers fall under that same kind
of "it's like io_uring". If you use VHOST_NEW_WORKER to create a
worker thread, then that's a pretty explicit "I have a child process".

So it's really just that hugepage recovery thread that seems to be a
bit "too" much of an implicit kernel helper thread that user space
kind of gets accidentally and implicitly just because of a kernel
implementation detail.

I'm sure the kvm hack to just start it later (at KVM_RUN time?) is
sufficient in practice, but it still feels conceptually iffy to me.

            Linus

