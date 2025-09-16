Return-Path: <kvm+bounces-57653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15255B58951
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:28:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 617C216CA54
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEF51AAE28;
	Tue, 16 Sep 2025 00:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LWMtOmsm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0A1A2545
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982477; cv=none; b=an8oUdZBpjH0jTvIs6mppee1vF4swoZCqyi/W1TR1maPHs2uFaJ50KIkY6nyi1MsBSSRiZblokkZ5eX5MibXwWERftN6S6Ticni/9iGo+2Bk6uKmCNEROm8GvtdDqRzunBiv7Ss05Ou4oWTfaWDYbSKr7O4K2eHPH15xLpqshd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982477; c=relaxed/simple;
	bh=PzUM3Cfsli7E9k7NP7Lepm6+OszCbs2678LuFeoy1AE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=lwL/iqZuwp7Gj0LUGPX26FZnCzEqJQbBxGU/cugF9pFzS6yw6uZBBl/SkVaidYIl7hGqknbxe8W014goY8J8y/5Napq/4LwRYgf+HtIYgHYpgHkxAAb4F4gKL0Ym92mwmbO7yAYkMYOLJO0XVIC3gxVzMTPCYHZzbbsJU7Otbfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LWMtOmsm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so3383497a12.3
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982476; x=1758587276; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=baDObaahxYUAyV7C9udP7HlsTUog1DJ+CNfR158Eu7k=;
        b=LWMtOmsm0W1XqTiTYbK5snJ0wy1zhAjgPww41YxQvEj2waZKWDDmYdOl4w9LghCw6j
         9PUXSVwFXH5I7KYjIFJmqh4kEs2lFdP15iiqwPmkMp7d/E2ALhsPqL5Lp7Fjc7OQlG+A
         7rBTvH9zW5olaN3hi5/1MW/8TyWJw7XQX1vAlqfZ0qzNCDgDL1Bgxh6HoH9QCRR4LZPN
         qYMpkyFv8q1Rm9vjHc1UshaiNfpTgmhnxXfb3VGpwNYLUrlT3nJfH01cfYgOUga9vPqe
         5Cdk38qELjbBjz/N5BEG0UF/Wf+DtOPpymEGHXjaZEgB5rTRlxp973QwKgPlUp2zhIA9
         MH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982476; x=1758587276;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=baDObaahxYUAyV7C9udP7HlsTUog1DJ+CNfR158Eu7k=;
        b=OtjCTzA5uRPnsI0hes3Cwmkchw+X+DCc3+BdQESuCcbbS6aFK31isZVO7rFqOdyX2g
         0xac4QbXcCHyvjWUw0g30aUGB2GQccqkdWqOQpwQJfFcEjPyK7KT1C+b82kceunFR6SU
         z+uWl3skIPX91gHPZ62+28nBFC1TMwGNKUjuks5Dlg3ERRRw8y6DG63fk4fisJxH4L8z
         aZMp3NLmkPU2yIf/uaC2eJUR8z7K50Kb3QtbPf3NUpzLGtBg7d8I0Cb29f6eNxAMWOn7
         5eXatOKoUEj0LiRimmSYgP2qLlm4eZJWvEBhB74YU6dIOWBBVdiYu0B2bdpwGVuICM+r
         zIPw==
X-Forwarded-Encrypted: i=1; AJvYcCUyss7InGbnNVccq1hltRLTbvaBpH4IPzgx4Lov0MJYBuoyBOPtsZayw09h4zvHTMpQ1Jw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYYqMYPpOcKx8PlQeZ4rOeuZ4TagLmAmuZx6pxw/ynvs3TVUt+
	zsPt+nVq5UBKEjkiSwyJIyqjYl2FUNHptzlutrs86arR4+Hm+NCEstSrm79ZpeSkCD735V3Y0//
	QLyU7iw==
X-Google-Smtp-Source: AGHT+IGB7LEdNHh9ns9vVvTdWH2C6Q76XFb2XcrJauMeliLMD0z0q/tWVuKSzCyaknAjl1QtXFxCe/nWT/Q=
X-Received: from pjg16.prod.google.com ([2002:a17:90b:3f50:b0:32e:5d96:8a6f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9187:b0:262:23dd:2ed0
 with SMTP id adf61e73a8af0-26223dd328amr12071862637.31.1757982475753; Mon, 15
 Sep 2025 17:27:55 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:39 -0700
In-Reply-To: <20250901131604.646415-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250901131604.646415-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798207153.624508.1085968130364515751.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: hyper-v: Use guard() instead of mutex_lock() to
 simplify code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Liao Yuanhong <liaoyuanhong@vivo.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 01 Sep 2025 21:16:04 +0800, Liao Yuanhong wrote:
> Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
> error handling to just return in case of error. No need for the
> 'out_unlock' label anymore so remove it.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify code
      https://github.com/kvm-x86/linux/commit/864384e97981

--
https://github.com/kvm-x86/linux/tree/next

