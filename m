Return-Path: <kvm+bounces-61178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFECC0F21C
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 29A574FF6E1
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7CC307481;
	Mon, 27 Oct 2025 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WFXq94ps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357E330E84B
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761580080; cv=none; b=GMbUpfUnMMsyt8m5oGXjGRW8+Rz0SffTTAfBsvPrtc3tZ46jQ9VDi4QSr1y3WDd4hUoy3sVUn93K8dAKoHNwgy31aMKPc08jtW0lL17T5OcON2OW31kOTSEqYdT0hwSzUvUk0ND9qHK4XxzESt8uIKKsErrpddNDHo5mVGm5vUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761580080; c=relaxed/simple;
	bh=jUaiW9lqSQS1Oj0Eaoh8uhE0DelXJJqmvaTSm7DfvVQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DeJNiwSOGMAEm2kXeq1KLetVOWzc+pgw3f8pAd6eYzyv9ZczqrnzqnnMiwAq1/TX/1ddvvGdHKP4eV6CkKf4pMpfnqd6S4pBYrMOH76QviOplGGGazQAERfV6KTcKXzs5XCAiy1Dt8LSZLPj3YCAXV7hx669LTUw7WeNjyZbd2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WFXq94ps; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so11253422a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 08:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761580078; x=1762184878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnzsxybDeKG1oOJcG0y21sahWDFsAwqRP5PEZtZbf4c=;
        b=WFXq94ps4NL+1983o8eGQiM/7gjsS6tT2Qd2O5ao0UdMRnwdeyyNYojcJ7jf6oDP3f
         4E5QRfZSoxaIw4ocbayiboNFN4iuHkzj/aD66lCzTgtMomWJ+/KflmL9slOcfblxWofd
         jIYewDt+28XHZA0IVaV8mhff60+dH4V+hqFL+BuA+z9BaLSMD0IH2XZ3JLtN+AzHrPFI
         TqIEk1ocYyrPU0qqvanZ8L5XqdvHe7LwJRF7/xwJAzULWdg9uIRJh4LO2fGDS0oO2aaX
         Rkkqre8kZ50b+sn4A/EfknjAyMzkI3uJy0Zbp2CX6IB61qmpoppH8wjBlxPbxNMqWSw5
         28CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761580078; x=1762184878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnzsxybDeKG1oOJcG0y21sahWDFsAwqRP5PEZtZbf4c=;
        b=fY8uAHFredkQSWJCbJmynhsYo4OMQ5zgRSBuPcw8uinOjT8Ub39l1OPvPaUZMy8mnu
         5ZgQX2oQXUv1Ob8z+GePUrLbP+dca5YeF8vadBbADLpQVI8UM6ARe6IlXap5bGQxOs+g
         I/hVUDfpd4soFamIjBl3WtYn6HgA5XNHZwVxnAZgi+DqaWH5tRCiwEJqQEQiJsYQKI+/
         8qUkQ/CNdLy8d9y3/W0AZN37AgddItvfoMLZ5cZxRyN9avGQBJiSz7TgcXkKjB1y5ZhM
         FcvU/KphXWdcPCR4DLoTtPosV+awcB2fX+NNzypipZ5kE/kK4/eVxI+qJJbEkcYbnGOM
         Pcug==
X-Forwarded-Encrypted: i=1; AJvYcCXp/K9LU4BciXFi/hIThlNlOP8V4sSvkdZOaTLUhsPDdQ8jCZDmbCn5DgCd7tKQQYhac0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRQAKBzg1VrwsGbdH4v86F8yBtBXanRg0bfV9ZdRZ5HpG01MQU
	SkFlTRmQ9geMVvbM6WktaNxpPn/ieQhzey5V0XLK1g+7eWwJlNbqwU4ji6aOKzczYR+IM43D9bo
	wLq7mJw==
X-Google-Smtp-Source: AGHT+IHl16tKONmKijCTu4LZb8/4c+bLrSwe0ea2hWg5FkgglrkjODrmoI58wyKv7NlI3ade8ZztX9R2hB8=
X-Received: from pjbqa18.prod.google.com ([2002:a17:90b:4fd2:b0:327:e021:e61d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3807:b0:32e:a5ae:d00
 with SMTP id 98e67ed59e1d1-34027a03311mr384491a91.13.1761580078517; Mon, 27
 Oct 2025 08:47:58 -0700 (PDT)
Date: Mon, 27 Oct 2025 08:47:56 -0700
In-Reply-To: <20250912222525.2515416-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912222525.2515416-1-dmatlack@google.com>
Message-ID: <aP-ULL69aQfCOwCb@google.com>
Subject: Re: [PATCH 0/2] KVM: selftests: Link with VFIO selftests lib and test
 device interrupts
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 12, 2025, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/kvm/selftests/vfio_pci_irq_test/v1

...

> David Matlack (2):
>   KVM: selftests: Build and link sefltests/vfio/lib into KVM selftests
>   KVM: selftests: Add a test for vfio-pci device IRQ delivery to vCPUs
> 
>  tools/testing/selftests/kvm/Makefile.kvm      |   6 +-
>  .../testing/selftests/kvm/vfio_pci_irq_test.c | 507 ++++++++++++++++++
>  2 files changed, 512 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/vfio_pci_irq_test.c
> 
> 
> base-commit: 093458c58f830d0a713fab0de037df5f0ce24fef
> prerequisite-patch-id: 72dce9cd586ac36ea378354735d9fabe2f3c445e
> prerequisite-patch-id: a8c7ccfd91ce3208f328e8af7b25c83bff8d464d

Please don't base series on prerequisite patches unless there is a hard dependency.

  ffdc6a9d6d9eb20c855404e2c09b6b2ea25b4a04 KVM: selftests: Rename $(ARCH_DIR) to $(SRCARCH)
  9dc0c1189dfa1f4eef3856445fa72c9fb1e14d1c Revert "KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR"

By all means, do testing on top of such patches if that's what your environment
effectively dictates, but rebase/drop such prereqs before posting, as they add
noise and friction.  E.g. these patches don't apply cleanly on kvm-x86/next due
to the prereqs.

