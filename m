Return-Path: <kvm+bounces-13954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCE689D031
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF46E2833CB
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D87B51C43;
	Tue,  9 Apr 2024 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFnE3gBV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1D5102E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628192; cv=none; b=cXAO65Q6J9DTWecvGuI065HvI8rcU9f2xkZp8hn1EJaeNbI3WD3rseZGa3WBNaOCWnVLM3L9ctePZx2lM7/A0BhOs6eJX4RSKxmIZYeQXF4bXB91kBC/a2Sfwj8N3pF8WlEcWNuJ90rPU95F9hsPwZFi6bcqfcF3931dfyrBs0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628192; c=relaxed/simple;
	bh=s6JCMHopGKvv+h6UvSK6+8Hj2XBavUOyse9O+LcG2qU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aVDX3PdwZhECNYynf2AgwuHWfcJDpZKdhOQI0LH4vrKWjlc2a8zCt9AEcBUtnybzzeMdGzUsBbHDXAkG/Hy+LyINvHJ5poE+D6zFDDMkc07IGMK2fs5kEG0YtaQmXRq31bOzxErVW/GclRGu+8Sp81EVvJEDmxxfAQzX84bATkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFnE3gBV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcdc3db67f0so7392504276.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628190; x=1713232990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+dYGiBB5WEe23eQKCk+AT9ArmcLUKHwTSwwrcv8shC4=;
        b=HFnE3gBVl/mU9wjEUWKjq/JG+yIuzC/Ep1bP4K4/4I4yGSqa7hhfcJUMxehygdlN2b
         K7oUNEOTXCQAwN2WSPdY6ApV8Urhp5QMbuHSSEfYhSzIZr+oCpHKuIX6G28fwakpi1+J
         +K4sFsRL7VelshO/Xfq5YuIOWUQt0v176Wk4Sku3Pex3NOXphjtMDBoXcV3YVumAMsvz
         DmLEMzce0FdPLGVPH8tjpcKrEUqHHFrFF6NIxxlObaKaL6Ihue9MfmjsTLUuBJ3gDYeF
         KjhTuF04jkK84hGe0tH4Mq5aofyKj8MqCVu3n1aYjqniXdAKq5IWlB8cfbq92RC5iWMB
         Gj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628190; x=1713232990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dYGiBB5WEe23eQKCk+AT9ArmcLUKHwTSwwrcv8shC4=;
        b=nXzZK06amPKgmEU82SseyLdAAsuwdbth0H4HququDOrgmeBAD8G+1YXmeJvY97yAIm
         6yMFCP3a3t7UzOC+wkEJYuqQdPx/VtA+4UGxS6SZnbU34vyaFP8tQcg6RCZCTd+efGgN
         zZ7mTsa9mD/AjrQk97ICT0tqP6swRHCfZPfos7/b/LLY4XJEp1lIClZZKfFsL9uKtev+
         2PNvG83s5xS0SdJtfbDCgS5cQnRr4Mu+4X2QO6HZqR6CRJE+vtIF5CqkG8XtXADKXEIk
         TNGE6W/VtLzhVijuR68t7nrbxSlT4JxsyDcZX+LciQ5aLYNHel7qnLF9AjX4aIIPj6bO
         Ipow==
X-Gm-Message-State: AOJu0YyuOh5FwxM3kyEFPUMIJsMn3NGa7HgqS4wF1b+pDxASIRkudojV
	pLVKIepYBjGrO8Ecv60qvc2dD3o/RxfB4lPkjfluf/ijeEYTtsi36WMpJbn9pwr5czSitBO7sKJ
	yUQ==
X-Google-Smtp-Source: AGHT+IHXUgDFD9+foe26N5SSBEEkmvNe2Y/m36FLIFGhNlsrXE2qb+7BnrYxDBtt06/NynQa5KXqx130Fhc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8b88:0:b0:dc7:463a:46d2 with SMTP id
 j8-20020a258b88000000b00dc7463a46d2mr306086ybl.0.1712628190038; Mon, 08 Apr
 2024 19:03:10 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:37 -0700
In-Reply-To: <20240307005833.827147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307005833.827147-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262710736.1419672.15334456430797702599.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Disable support for adaptive PEBS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 06 Mar 2024 16:58:33 -0800, Sean Christopherson wrote:
> Drop support for virtualizing adaptive PEBS, as KVM's implementation is
> architecturally broken without an obvious/easy path forward, and because
> exposing adaptive PEBS can leak host LBRs to the guest, i.e. can leak
> host kernel addresses to the guest.
> 
> Bug #1 is that KVM doesn't doesn't account for the upper 32 bits of
> IA32_FIXED_CTR_CTRL when (re)programming fixed counters, e.g
> fixed_ctrl_field() drops the upper bits, reprogram_fixed_counters()
> stores local variables as u8s and truncates the upper bits too, etc.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/pmu: Disable support for adaptive PEBS
      https://github.com/kvm-x86/linux/commit/9e985cbf2942

--
https://github.com/kvm-x86/linux/tree/next

