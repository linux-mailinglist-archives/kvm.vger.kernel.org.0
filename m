Return-Path: <kvm+bounces-11400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DECC876D37
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049581F223E5
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F3A487B4;
	Fri,  8 Mar 2024 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/+BhC5p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C03A4084E
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937433; cv=none; b=Th0E1iV2u8OAnnkLXwfPTUjPu0wyOwbtFjoVppNn4e4wsCeBAdPtTbsq4Z4pO8/r4NmF6AaNInuVprUxne145AkeMCC6y0L6JRmDG3uh6JnbQxgTFrrHDrYAtqu3KlWSQgvpGqXefJxV0pG4yetnnntEFiONPFSZAzpJSV1nOx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937433; c=relaxed/simple;
	bh=uXQXgnPJrZOKe4RbgiP6EoFj6TNvC6MdhGnUCOQc76Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wfv6QLUXw1QWVLGQ3s8YGfME7vo6BbSRJtx8zIVRpEhLx4GIjOOUmBMg6+F52+py4STiopKXiTn6RBoRHqd9+bIntKbxh1plWbUPuNmi6gcWQjKf1MAo851948J2iexKXT60JEtAf1SiCrKcVpIPZ43JGPIOB/ZwxUg+fZG/M7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/+BhC5p; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a01d0a862so21572267b3.0
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937431; x=1710542231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vPbWGBEv8YflAA5jQeJzy8PnVvXeLnvTmYa/ZZ4fLow=;
        b=L/+BhC5pCC2kPV06vo0Omz8nRSwI6LeEvH4hAEizjqGX6PG6MUUAyhA4phWhAUnEhu
         UN1/h9XT9EUZ7rmFtvh+ZYlzfb5/gqHPlH1+KPTGK2OQNNbiJbIKN5L9YAjtqrwQNYMN
         GOIXtJhxcmfQ0BZyQ3R5e14n7ta7opWv7q+BEuXWhVFtccHpsk+qi3QrZC2BStVY9vSX
         sOocFCMMoL1qL2bBcuUOYu5j7V24kL3kc+qtq1N0ZYTcVeRgJLMbwUW4hiu718mZrfAh
         8R4zw7p+hy/FZOuy6hs6ruyLDx0YS8zWI7znJxvfLzPaMYp+F6pckidH+oF9RhuSejqd
         6MpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937431; x=1710542231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPbWGBEv8YflAA5jQeJzy8PnVvXeLnvTmYa/ZZ4fLow=;
        b=vPw7MmG2/Lts8Bb0tKo3cUElTflctxmmyoyXP1OryrElccFGB7RszOmAHkkVFAoZXJ
         eR/PBMuIaivKvq3R37YP0SNg0x5j8149B/ksuD5omyZTsQdyXHkNU26jMAt5WHJcaoAH
         9MOSVwq2NjAkOdApleAPLlEsdDk34lfCviEVLxpZkFbShn5CMv50wfiFlJsvb983/MZx
         JZUdrtuDwd+f3dsADjFw/Yw1AvrHmp7Nz7/WXN+yZWevFuJNVizQUupMlKbfhCg0liVp
         drINRXPdx1TJ1JnAqnVyBR759sJGvJZYfrKeDkYB3RU+sDgfT0hcwc7U3BZg6DaYlXak
         /rNw==
X-Gm-Message-State: AOJu0YxOKeVTYz4HCRoJjRJ+75ovcfSIpY52lJwLWF/obMfTsmvXgjfK
	WLUFULTVuGX2DfjLqoKgniZgo5JDmNjwQEACjX8PO1ogo1IjTJgHTq76ybn2mqlsOpHqwajd6IZ
	EBg==
X-Google-Smtp-Source: AGHT+IHMIR8oStHcy0MnK26a+KwG9Yyh4GDrFB8J/4ynRuCm56DNqKdDcklxmd4n3jkM0bc8TlImx/WLNg0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102b:b0:dc7:3189:4e75 with SMTP id
 x11-20020a056902102b00b00dc731894e75mr29989ybt.3.1709937431047; Fri, 08 Mar
 2024 14:37:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:55 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-3-seanjc@google.com>
Subject: [GIT PULL] KVM: Common MMU changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two small cleanups in what is effectively common MMU code.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-generic-6.9

for you to fetch changes up to ea3689d9df50c283cb5d647a74aa45e2cc3f8064:

  KVM: fix kvm_mmu_memory_cache allocation warning (2024-02-22 17:02:26 -0800)

----------------------------------------------------------------
KVM common MMU changes for 6.9:

  - Harden KVM against underflowing the active mmu_notifier invalidation
    count, so that "bad" invalidations (usually due to bugs elsehwere in the
    kernel) are detected earlier and are less likely to hang the kernel.

  - Fix a benign bug in __kvm_mmu_topup_memory_cache() where the object size
    and number of objects parameters to kvmalloc_array() were swapped.

----------------------------------------------------------------
Arnd Bergmann (1):
      KVM: fix kvm_mmu_memory_cache allocation warning

Sean Christopherson (1):
      KVM: Harden against unpaired kvm_mmu_notifier_invalidate_range_end() calls

 virt/kvm/kvm_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

