Return-Path: <kvm+bounces-58688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22417B9B65B
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 20:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5661F4E81C1
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 18:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5B232F480;
	Wed, 24 Sep 2025 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P9Qzs41f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57F632ED2A
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 18:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758737290; cv=none; b=OrkIp7cG/NZ7uGbJe53E6cVRxZ7FBPhksAjwm8e5Ii5CR/rQLekrAVdpUA3uqp5ecRnguKSFvr5N3Df3z9OBWav2JpeWadsFe4j+Cqnl86LsKL3HZtdiF24LzFmCGdTAa0xptHLUprS/yAkjWaxmFATpDqFGHH2GTcUlc9EIHrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758737290; c=relaxed/simple;
	bh=WbrpXw7uGEedja6sryJIlijHjH7y3h6T6Btd6J3NpBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X5WPKcpE9yzmEPTCRnKa2UT3W9D4vs48XFulqyz0t1qPQY9vke9WebEO3KDTchQlrmUGQSqArjs8hqLaHgmahsmwpeNEjRjValoxYwKCGvadaxlU5hERMFd+7QG9U27X2pFABMeYp6E6v/axtKY6BDIeGT2BstJtzQJjjUwdBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P9Qzs41f; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-268141f759aso693555ad.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 11:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758737287; x=1759342087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E114FBK/ER4h0NxFE7k/vJ0RM740rgem63GVoGqlxQY=;
        b=P9Qzs41f4GlAS7183jz4uMCIJvODeIMvmUOmndRh6UUmC1XtwsvY3yKiHdFwpVclQN
         aNAfs0850cw1CZolYC1NMLwj3TBgWakDt9Z0QBA6H0dPLR8k7sPYk3OVZaCfAulQojfi
         AZo+Kgoul7689SieZwLjrBAus3emb3sSjCAk192K+IJppNxQaVcCwSG5Rf6k2eH4VJkx
         2Tg8oZzao7V4pE75TheHddNI/2lbwF0Jxy8nzAFQV0j3tZo+elsAwigV+S5bSVKOD7TS
         Nk7WKkt1e0ILdYeNOSYmGhQMwaagBZ70RNot6SrnjjBfNamHkZr4ChyKgWfXbY/mNVeV
         KhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758737287; x=1759342087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E114FBK/ER4h0NxFE7k/vJ0RM740rgem63GVoGqlxQY=;
        b=lcNHdwHjT753bZQ4pHktmM6FBn3roZcilNwIhSO7mdKZL1j4RhRbdkQkcAVSVEmvKA
         ooS1F+mx0g0l8e9gfvZdahD6k/11zc1a6Tv5s0SUQ5u95lPOgCxYgUzRKNkPJg4NBsH8
         1UxkNAOMgz3R5kSOpxvjI9GkM37dI0wR2q3C1hxAw9papRT3ZMYE38H70ze7WCNs2Un/
         fP4cO+UaXvLZI7/XCrhJlY8bxsBURbpxBtvuj2YcnzcOL7Iz97akrQ0WMEi921P/tnfV
         NjbSVl4VkfypJ8sTNegKHvgJjfNj8CM3QgM8LYYGQJ3rrN5Y2jbligP0aW4SOCNHSikg
         N50A==
X-Forwarded-Encrypted: i=1; AJvYcCU4o81fw11MSeAlWicgTrqed7aFSKB1AodWBLA/uatX2C7V3/Ib8EWxGuMf16gh6GyssCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx35SSdt2susoG+BqJ5OMprKZfrZ0NBXAJTYnzrAegsh2Vt7qrN
	66vAhIIcyJlE7Spfo5Spx8lj/d8+iSa214f1BRLmB21uS3akoB7V4I7TAabGwR583wZrgFh6WUB
	rA0k0LQ==
X-Google-Smtp-Source: AGHT+IEQILa7qWwOhEOCXJrBhALpzVM3hyQ7cpSMcpqaqrRIUDlUUT4XRCks8JQbnx6Az52uCL5tJS7hm04=
X-Received: from plxe12.prod.google.com ([2002:a17:902:ef4c:b0:267:dbc3:f98d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e548:b0:272:1320:121f
 with SMTP id d9443c01a7336-27ed49ed435mr6197535ad.27.1758737287040; Wed, 24
 Sep 2025 11:08:07 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:07:30 -0700
In-Reply-To: <20250909003952.10314-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909003952.10314-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <175873635915.2146060.11822371958338127087.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Fix hypercalls docs section number order
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux KVM <kvm@vger.kernel.org>, 
	Linux Documentation <linux-doc@vger.kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 09 Sep 2025 07:39:52 +0700, Bagas Sanjaya wrote:
> Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
> documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
> KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
> so that the former should be 7th.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Fix hypercalls docs section number order
      https://github.com/kvm-x86/linux/commit/86bcd23df9ce

--
https://github.com/kvm-x86/linux/tree/next

