Return-Path: <kvm+bounces-68230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 930ACD2782A
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD13830A089D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096F73D6461;
	Thu, 15 Jan 2026 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQiYAgTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C9C4C81
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500480; cv=none; b=U2LISYTOHs2BUN4Y/K6ZJbu6OMfZq7pNaKNqmGGwP8Yq59N4G5VrGaHNSPIdANCSZwsDoZreXsSUzjCtAZridasWQwDxuDsZiF7YpRd5gYAqIOg1r4mIE2D6ogk1hblm+vHxZR/o4uGny23pnGarknH1YikEwn3Ukto7jnE1lqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500480; c=relaxed/simple;
	bh=boHXuFdfq1eZeeQ+Kw09uZN9fSSFb8/1/tOhIclkLZ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IOECsYitly8ygYkEaCFS8RDiwiEgi8haybiKcgQyL9Xhvp1fVGo/mllceFKiZALHuTacQZtnUhTokJUkm5Pfjhoa6kMq8xRZ01XYhPLnHPvZ2ki6AE3Z9+xa4rz4p1Q7AF+MqU9FhhQMzmbd/C7M5ppUD2lFXQznKvXsN+tE3Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQiYAgTQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337375d953so666065a12.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500478; x=1769105278; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X1All7C7wDUzRYi0q94v+2h4Zkg3zXfCYN6C7icdLAI=;
        b=aQiYAgTQPapZDuB5rGnAf3RZv4UkIBhc16VIKRz0CDo/KBeHdR+whCdC1neVeTVTyZ
         o7bDapNz3ZAh/mZK8IYb1NxhXXKd27rweuhAKOq6I1MSLwf1gQo3Lm0NoHZt7lFZjLM2
         nwRXkM3t56zhoRMDI4/psn369irMyg2IFLgycampJYdhvfZHDGgex9AIdm4sZgH/gTaS
         7xFnN1fn9TaO7uArpm7XfPjLYlrPrVDPOXJHfUvPqMxDA6LFFUUAKVtavOP0K7DAoqsC
         kTycVYfzaHYMnMc2Vext2X1Ik/b3UVzAdIqN94gBkOXgnJSyDLT5O1Oy1/fP+6VoW7Ax
         pYog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500478; x=1769105278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X1All7C7wDUzRYi0q94v+2h4Zkg3zXfCYN6C7icdLAI=;
        b=WBEBv2vUCarsoSlmkwphDcNDGKJ0gX43sC5INImYVjYLEihVbUuC06Od/JQN897ZsR
         172hj53/Y0rgFHApr6bv+2GHfZd1O66kst8jQrIIMixl9CUfVgWREWVh/RQDkfabfNfV
         djQ2yjdgc4tQnxnWOiqraTYjO/mhosFSAeG88JfujCCokjPoHnG6os/qFFUeyaU+NLaV
         tJ/UplBjubxb1b6Al/7kIZUiDcyCrxbqRpjsjmTu5YOjCDbAPGpfW/LR5ZNNLa1/bZPE
         ETayPWMIHFpFQ0FAplw5zFeUEe2XEbDPOMzOqvlPjqje5SGx8dGREY2yHyHoXr5XweiY
         ur8w==
X-Forwarded-Encrypted: i=1; AJvYcCU6FOyaD+MRn/hbBWKKC5wy01Ine3mLMXPeZeVBI6BwVpFm8v0S942Ef1gwpFbktnvuvSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzojYkWXD+shjrfdFqBP1nxn7E7E3Rrm7xEt/mijDQfQiaiTjs
	yBl00QcUM+CqWzFoIPXRX2oGh+hDQ91J8cON8FdzGIpMnBazPXwU7Inw2yCL/7U4LmfugQrA9gE
	yE2h8Uw==
X-Received: from pjbev7.prod.google.com ([2002:a17:90a:eac7:b0:34c:4419:4aa3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6da8:b0:38b:e759:c2ba
 with SMTP id adf61e73a8af0-38e00d1b92fmr30027637.41.1768500478359; Thu, 15
 Jan 2026 10:07:58 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:40 -0800
In-Reply-To: <20260113172807.2178526-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113172807.2178526-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849721787.705259.1172944415596561626.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nSVM: Drop redundant/wrong comment in nested_vmcb02_prepare_save()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 13 Jan 2026 17:28:07 +0000, Yosry Ahmed wrote:
> The comment above DR6 and DR7 initializations is redundant, because the
> entire function follows the same pattern of only initializing the fields
> in vmcb02 if the vmcb12 changed or the fields are dirty, which handles
> the first execution case.
> 
> Also, the comment refers to new_vmcb12 as new_vmcs12. Just drop the
> comment.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: nSVM: Drop redundant/wrong comment in nested_vmcb02_prepare_save()
      https://github.com/kvm-x86/linux/commit/f00ccdede3c8

--
https://github.com/kvm-x86/linux/tree/next

