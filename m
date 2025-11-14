Return-Path: <kvm+bounces-63163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 543E1C5AD9C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:52:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3978F4F2568
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5AA231836;
	Fri, 14 Nov 2025 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wDFAiu2V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657FB163
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081218; cv=none; b=pIJnx3vkRArswArNpL+dFe8mEQ8V+WIGh28Ui99CyQg+EFwRoMfuypf0KVCCmODYAVirqeEX5h5zEPTrp+DusO922HWxsF28ANIMQJp0i+pI7J3wVEB4OcA/O7BD4EQSIDzeUWUEp4+BWeQl461xmT1MuDdOKsOSogtrmNvf/1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081218; c=relaxed/simple;
	bh=xuW/A/CoBXr3blHfpV0ZmmgBvTNTXsAB1tTeVcs/2wM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=b+9k+LTZQ/mr1wR55z6sdilEVOgh3lkNMuYF2e4yApjyKbzyLH960o+K7jSOC39nR7ZH0fxw3E4qTi0YCP/gFYYmqnv4BnjhYo4grwxp/8/GykQ9q04BRXQ4ZL0pwBohy/wXQTQNHvPiumPGkLByHfJ93RHLSLL8g0s9dyVE640=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wDFAiu2V; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso1765331a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081217; x=1763686017; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgFXV6LwvfkzTRFgtPAzcffYqjt1g92SiFlO8mnbyZw=;
        b=wDFAiu2Vly8MmeXvHId6jZtBBUzTlDYNhKxs/it5QSe8VAAQpzNVDgUkZwNS3Z5TDe
         us1ASNX49+5RMuFV66DFLZWxn2dFcELjKR3GhtM48tJNh/yVn2EvEgxD9F4LHmfq8BdY
         J75P5BfOoJbxxXJCnvOFY2Z3yXVR+FF7MGgIAcugDrle3iK86zK3Ca98/MTU7+q/pW9C
         2uDIvII693OrJHFOE62BZfYtYhVRIC4v1y900iLGkjRBq99KOZvMeBXYpI9YisLdwIok
         mKOfBC8O4R7rldnJfggg1HGiUu3W6jeJldvkLf4B+kjipzwnNOvVt3vZV2iydtBVp8Zu
         xxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081217; x=1763686017;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hgFXV6LwvfkzTRFgtPAzcffYqjt1g92SiFlO8mnbyZw=;
        b=ve9ZWh0yA8vWCr44E46k/1RvFsMSl2TaKLtAZmC2hM/Ml7If8ugGBqOEkM6xM5h7fU
         2EZfnwwtorcf1VjSYHEOI9sK+OKro5nZC98UZtWlNH94cfgWgrEkEfomYuZ4QXJJo26e
         BBT2btQnigOifexDUzQP9TkchG/idAe8ZM/GDoMXXzWBwGNQaLIx4QnLnmnHiQZdfY2D
         OzLsOU8CR3TwwSiGhEGamYgqcbTkkL1oyCWLcc+EOgOyR8AXgKa114PNhAaF8+3Ht8W/
         iZoKZPj6a24I2vEKpzOyIlnbuq5qwcZlj9zKx/z3hVYsNA3zB0eLmk3UyuPwWkTL3CKY
         fXng==
X-Forwarded-Encrypted: i=1; AJvYcCXgEX7oK9Wz8YV2toVwm2qvUHqAu+EFgunnG2x55XodIWGcbGsc/+vAPuxWmUtBK8Y/cyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcQp65r8pWAd2zPmwCa1Xa4Dw4kUF2SObZiuSC2LEx11lIInth
	Y/ux8xFg7oWsPMZDpANY9jo0oAmYZUoZYQmlsyG4ghZAMThNQeIbe4MsEvzcR+NkVwHcP99Bsl1
	PMgrvfw==
X-Google-Smtp-Source: AGHT+IEwge3kE4eVnCB2FvD0RpEP3RCvl2uscTz/Weq21hEltKLZG3VNXOmyjvxdvncvxNZigIHILQktE6Q=
X-Received: from pjrn4.prod.google.com ([2002:a17:90a:b804:b0:340:ad90:c946])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d0a:b0:32e:3552:8c79
 with SMTP id 98e67ed59e1d1-343fa73faebmr1331609a91.29.1763081216745; Thu, 13
 Nov 2025 16:46:56 -0800 (PST)
Date: Thu, 13 Nov 2025 16:46:09 -0800
In-Reply-To: <20250724191557.1990954-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724191557.1990954-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176307989910.1722766.15669216240610494830.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Print error code for unhandled exceptions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="utf-8"

On Thu, 24 Jul 2025 21:15:57 +0200, Mathias Krause wrote:
> Print the error code for unhandled exceptions too, to ease debugging.
> 
> Also use the symbolic name for the #PF vector.

Applied to kvm-x86 next, thanks!

[1/1] x86: Print error code for unhandled exceptions
      https://github.com/kvm-x86/kvm-unit-tests/commit/585ca3bb3b5c

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

