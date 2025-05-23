Return-Path: <kvm+bounces-47596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E18C2AC2797
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 18:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54A947BDFB1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 16:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BF329711D;
	Fri, 23 May 2025 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0pbeXk8z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA59297A69
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748017511; cv=none; b=DEQNOiJk9MQvDJFaOQ8eo/DH0YYIR/LLaboS6Kl3Kr7NtLJeO0U0foTWAP9fWtezCvjyCxLY4X0rrz3jArxBasoxdyXueuRb3pt1H0Le+1abTUeeg/cF33mhEfkvIgdg6ublLEaVb55YCy5o4Ldh/lh40crsbPE5w23U02EI6nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748017511; c=relaxed/simple;
	bh=x6jih6XATSb1TJ+DjNPTVCHK2DQSo/2Sw+u6I/fV2g8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SRO7ue0SQk4Y+URYDFfX2WDE36o6GrDEI42iyg8Lb0LRuJv0NYFocIRKEk7gZbmu2ACBzZrcYznZ0n1+m0z7FuVQ+1+kzMBatdjE2D7zJXXaO6czBVOtzudeAwIYA0yd+PRQhFpt38tnNuAsCiGyNvfBOktCZ6PvHlOKQ5VA0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0pbeXk8z; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e78145dc4so124577a91.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 09:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748017510; x=1748622310; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vLD2BxtL+oRSlLgncs8WwoIRI1KgiBZ5QnZjhCDIEHA=;
        b=0pbeXk8z8ZyUxxgcsYcae3+xD1OxwAASJFalnANd4+84v0HgrTzLZda1E6ZLK81RPn
         aI6dEfvpNKngWLMYgo3OxEmYNgAeR2PLP5QGvZ+7nrj+D1AdSG9rC9Cs4j5WzP0a1omH
         l5yUoyZOgFytHc/RAjr7aAqZ5e+YdCUDlIkjq3YDj+E5W1+fM8lULWGyIrnc91uJ6Ds8
         ZcYOXuABM+WxgfKuFwjnoxwxWPfLI3p2q9mi1L7alGcjbxPYhtCw7zUNVbwxHP5hU+pr
         rCC9mAmTcuRt2iY66wC3GzcVjAD8n5SanJprW2Bz1C8ei7L+tKyv7xSSEph4+7y/68Fn
         LnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748017510; x=1748622310;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vLD2BxtL+oRSlLgncs8WwoIRI1KgiBZ5QnZjhCDIEHA=;
        b=Gmad2lwGgJzYXqYcwhMpkPABIKvvmZ0Yz4R3MKfOPyt8RsgJFTccbmH/fugo095Zl/
         C9YjfecRmRHObmePCoXuF3QYyDQ7a3C0bpnBpKGtdNTUh6LiKfKUX5lrsPXJqHby4SJR
         jhfakfWmAPr4UkxXV4iCfdUtIj01m/5h8p46GFsxEfw7GNA6abyDym+9fxeT7wglvN4b
         FvnnsuFoeC+qvwWHwO6xzX59CJbCTl8D2FYx4c9hq70QH6uYtqB8ILrBtyJN+Izx4AS1
         expQzM22X/+AD8pVitfqe9MWpyH+6H0JEovN43BEmZywPtV/iLECwrxcACyESQBieQYi
         bz+g==
X-Gm-Message-State: AOJu0YxMIkmh8OnluQybkSebr6NDsAvwefb4AfXHpKjaHGUO5o2fsV/J
	R5l6Skg4M+4Q68GaoAoihTnpk9baMObldjz2Tbt0XUzQaCaaBGyq/SZmAU8PUx6sc6MqqEH6iD7
	qPU0lVg==
X-Google-Smtp-Source: AGHT+IH4TZCMGLjx70ZzhLpT3MqCF42IbUw9jJEnFG7Gzr+Sx7zjmflvZNd7O29c7zvdubJdcna1HLJhIV8=
X-Received: from pjbmf7.prod.google.com ([2002:a17:90b:1847:b0:30e:7b26:f68b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2882:b0:310:7485:e3ba
 with SMTP id 98e67ed59e1d1-3107485e4ccmr21039402a91.28.1748017509728; Fri, 23
 May 2025 09:25:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 May 2025 09:24:59 -0700
In-Reply-To: <20250523162504.3281680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523162504.3281680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523162504.3281680-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.16
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Spurious fault cleanups, and minor fixup for S-EPT.

The following changes since commit 45eb29140e68ffe8e93a5471006858a018480a45:

  Merge branch 'kvm-fixes-6.15-rc4' into HEAD (2025-04-24 13:39:34 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.16

for you to fetch changes up to 6a3d704959bd04ab37fc588aff70b3078f3c90e8:

  KVM: x86/mmu: Use kvm_x86_call() instead of manual static_call() (2025-05-16 13:13:58 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.16:

 - Refine and harden handling of spurious faults.

 - Use kvm_x86_call() instead of open coding static_call().

----------------------------------------------------------------
Sean Christopherson (1):
      KVM: x86/mmu: Use kvm_x86_call() instead of manual static_call()

Yan Zhao (4):
      KVM: x86/mmu: Further check old SPTE is leaf for spurious prefetch fault
      KVM: x86/tdp_mmu: Merge prefetch and access checks for spurious faults
      KVM: x86/tdp_mmu: WARN if PFN changes for spurious faults
      KVM: x86/mmu: Warn if PFN changes on shadow-present SPTE in shadow MMU

 arch/x86/kvm/mmu/mmu.c     |  5 +++--
 arch/x86/kvm/mmu/tdp_mmu.c | 19 +++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

