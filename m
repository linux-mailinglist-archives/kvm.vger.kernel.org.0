Return-Path: <kvm+bounces-16197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F25488B644E
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 23:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F79B1C22393
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 21:07:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C49184110;
	Mon, 29 Apr 2024 21:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d0cvUxCU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1228317BB1D
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 21:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714424577; cv=none; b=SlTjgAcIz9ikEcYNLa3Q+mLOcLX+11o/9DkIwEj5yQO+hBbC3pOUAL7e0f3AA9WhHbvtJ7YzWOHQycbrQcingMQNIV818HgVKh8ocql9+qpeLWmHlZ9yTPHmMlaq75PcNSaUJx/0sHR8DvBWIHIPxIHG/R+UeuzRInWuGLfTG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714424577; c=relaxed/simple;
	bh=PPVNvn0DIhv6FGN+XyDmmtWyNnzYHJ1RnYM4N8RhC9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oLzVMgmLKg474epmwBrfeF0ZfosQm38SNjgzupg/rVK4g7B6Bf11VZ8a5wgXDL43xxUDvNA13rack0ndijl7bBBWbbbQ/hcflGPKWtNx9l/u+50hs3ivnBtdjfIdMqpQ6u3XHXQBX7PG0pNTGXo32onKx6xqbgHubzhy/bFVzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d0cvUxCU; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2b743d8e3so50997275ad.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 14:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714424575; x=1715029375; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xw3vIJGY2NNuKaQ6MudNnqR6rpTRdltf5mCEUSFWvc4=;
        b=d0cvUxCUEqzsngCAPrB36e/r44+gq9tjbGqxxj3oQhk5/cAMIVHxxqzOhRduJhcr2/
         6UfwTs7WOqFCw0m5oKcS5uFMb17XVkNYWdhdntj3hYG73UMRP23sIS3WpM8M/udsy+HT
         ew8SoxkHyS3WJ90IlG4STUDHv3mYRnyYAxMuFj2+hEGz36GDTwidr3KYsKSkRRoXSEHI
         8cNjvasB/ODaWhd9KCy48VO+4kNgWC6AFYGI2bS/8eStafqDpsH4wqtza9Z0kYyFtdjU
         h8bnLiRGMdZYt2ijgiI3QX5FWYZWYb7bvh9zQ4x0PGIx8wuAwsxRsZdpfAXfWOOBxue+
         nCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714424575; x=1715029375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xw3vIJGY2NNuKaQ6MudNnqR6rpTRdltf5mCEUSFWvc4=;
        b=ZtEDcJ30dz2VAh3R+A7e4Sx35zrtIHi2FhZo8qDBMJVK8cMpdf60xci8ySTXck9KOV
         Xy9jcp5iwLbKKZBTQAxNT+TIEDpz1goexNf2Wwyt0gVHg10z38t9UN7GGpR71mkEI+0E
         7pz0XvxJoeNNZLKLUFx5FAa/JK6E+VEcxH+snCXZotu/rcRKQkwolqWnnY5eig4id7+c
         L5TUxoNiypA7d/CiBizHl6eRZUgdGacUplXhBRtSGRb8yqIUNk+b3qg7nTYgqBdBdMW5
         3FVQ7FXDK7LJXTn08AXydAS+Vk3mOEDpIa7KKSZPzP4mEqsRIk6K4w65GJCymsB2xhV2
         Z/uQ==
X-Gm-Message-State: AOJu0YzPaEJASK/ixz7vCu6oOCCMoEYBWWEZu5lBcRCg7AZ5qBPyUvR3
	kGTizdrgKW0jXccueK2U91bBhuV1OjwCMpvixg7ogv/F6xxUjCTbJFJ0U8oN4sytKhIC3WIe0VZ
	IQw==
X-Google-Smtp-Source: AGHT+IFAPa05P5Phibajkpgu95FpzO3FVIMmtbzX/atvNPTvVmV0SeqoPEqwME76DtqNEjJ0m8ryHAcldiI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d509:b0:1eb:7b9:4f7d with SMTP id
 b9-20020a170902d50900b001eb07b94f7dmr971010plg.11.1714424575332; Mon, 29 Apr
 2024 14:02:55 -0700 (PDT)
Date: Mon, 29 Apr 2024 13:45:25 -0700
In-Reply-To: <20240423190308.2883084-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423190308.2883084-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <171442341918.161544.2844726781684658994.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftest: Define _GNU_SOURCE for all selftests code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 23 Apr 2024 12:03:08 -0700, Sean Christopherson wrote:
> Define _GNU_SOURCE is the base CFLAGS instead of relying on selftests to
> manually #define _GNU_SOURCE, which is repetitive and error prone.  E.g.
> kselftest_harness.h requires _GNU_SOURCE for asprintf(), but if a selftest
> includes kvm_test_harness.h after stdio.h, the include guards result in
> the effective version of stdio.h consumed by kvm_test_harness.h not
> defining asprintf():
> 
> [...]

Applied to kvm-x86 selftests_utils, thanks!

[1/1] KVM: selftest: Define _GNU_SOURCE for all selftests code
      https://github.com/kvm-x86/linux/commit/730cfa45b5f4

--
https://github.com/kvm-x86/linux/tree/next

