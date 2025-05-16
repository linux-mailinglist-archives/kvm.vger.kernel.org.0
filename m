Return-Path: <kvm+bounces-46913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC79ABA62A
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B2347AF267
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA73E280034;
	Fri, 16 May 2025 23:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EAfwHezS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA00227B9A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436859; cv=none; b=qUAj7NaTWGkhilMfRoDRI9dC+niKaoADBsoPkAXMBRtZQcrPlYDSzoaXRe5DPJcmLQ8fRvjkvxT1TvCdVm5b+RftVvQgdwEZ6AfVA3wHEyqXI4LCUCmlzV0h6gi+7iVcZQfiYvow2CIrFHnjhjWybH1D6st7bCCz9Mt5VW0wDDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436859; c=relaxed/simple;
	bh=AVnn78Uc3EWeUJSQ7ziRvaqm0OPYoWQKB0eMNz4K9JQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KnLd0+El53xQ8iqrlYAP8Sdi3oVe9cyl9Wh6NbTJDC6eLChvux4gtMNFAmIf0YgtoqXthvtLKbmELjxq1JOz70bVukoJZyXh1H+eHK+4Nnn/q+F9YPz6WWF6bR9Zd8bQLD1xqIYu53fGajS8850mnfXmmjJIk31Fq6FgOAFldXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EAfwHezS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af59547f55bso1540583a12.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436858; x=1748041658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuPZrVo3m9ILiCK6u6rwy2V97Y83MmsuXvc2pUzideg=;
        b=EAfwHezSm9vCY59gWxTn2oVu2ODdv4BTL0jS/G1SOZYpTpd6RqWpd9iiwqG0bLPQR/
         mentDoc2U+AmX3B90Owx/+fohgnxONjEwYnWcn5XMpsy05iUWLCeiLVKQctxWb3K2mpW
         41bp3L0Fg8WTYrOhv78rVUbwPTNjSQrsQwG5hRATJOdPZ59fBe00YIVf9EDiVNYqK6IG
         gsgbXcfLegMmTjJNgwRbyMiq+V2SEB9qd+Ml705SoRlTdLm0Nj1ks0TrQfFUZR3aDwIq
         PHj/THmbaYbhHYmewb4mZvqnWNnV/j7f/tHkpi1qLQUnv/Ua9GPDHiNHU4UMM6s8oIr/
         0amg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436858; x=1748041658;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nuPZrVo3m9ILiCK6u6rwy2V97Y83MmsuXvc2pUzideg=;
        b=r5yLVDFW+z9AG5vSDS7JiXNY10k5KzVosQQAYdtmpaLQ0qnrG9akZuw+RftOyi/7Cj
         ghFoLo7DELOwthH4AkIM5tQNKW9sj/RnE8kYIXULPA+YHaKz9G7txWQlGWANEKC08vFp
         /4G6UV5D/saldn6DnjjD/3Vwcpf2dW5/pJnNXh82QzO6l6BYiaRX/ATxDkWeNryKHaY0
         iAFT6X4/SwUzcRDEdYCIKFFt8VNXCA8YPU8GcP6OEPKAsvVTQ5LQFQ47qd2b2Vzjnc0E
         PMckwqAMylx3RTtly0Eyboih10qVhWT0kA+YDk6r+4vNshA+G01FyWV7hrwvX3Lbuqgy
         XIwg==
X-Gm-Message-State: AOJu0Yzp2zG9TUdc9A7t7gi8VOIk2Rh2YfeTF6FKGGJE8rknKDkRGuzi
	FwSwmSZjk9Z5utQRXpTUE/O/8zSfXNzFuRp6OoUVshOvbgOXrB4RAI2OBiThLMfs7y6RHKDBhgW
	cIHpt8w==
X-Google-Smtp-Source: AGHT+IEva6akKzygsV3eTjAuHUFzTW5RKHcvkYUPembdBdAiDgn0hyDfnrXciaaTEYE+lnp6Pa6eayl2kZA=
X-Received: from pjbse12.prod.google.com ([2002:a17:90b:518c:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a83:b0:2ee:9b09:7d3d
 with SMTP id 98e67ed59e1d1-30e8313da6fmr5609248a91.19.1747436857700; Fri, 16
 May 2025 16:07:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-1-seanjc@google.com>
Subject: [PATCH v2 0/8] irqbypass: Cleanups and a perf improvement
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

The two primary goals of this series are to make the irqbypass concept
easier to understand, and to address the terrible performance that can
result from using a list to track connections.

For the first goal, track the producer/consumer "tokens" as eventfd context
pointers instead of opaque "void *".  Supporting arbitrary token types was
dead infrastructure when it was added 10 years ago, and nothing has changed
since.  Taking an opaque token makes a very simple concept (device signals
eventfd; KVM listens to eventfd) unnecessarily difficult to understand.

Burying that simple behind a layer of obfuscation also makes the overall
code more brittle, as callers can pass in literally anything. I.e. passing
in a token that will never be paired would go unnoticed.

For the performance issue, use an xarray.  I'm definitely not wedded to an
xarray, but IMO it doesn't add meaningful complexity (even requires less
code), and pretty much Just Works.  Like tried this a while back[1], but
the implementation had undesirable behavior changes and stalled out.

Note, I want to do more aggressive cleanups of irqbypass at some point,
e.g. not reporting an error to userspace if connect() fails is awful
behavior for environments that want/need irqbypass to always work.  And
KVM shold probably have a KVM_IRQFD_FLAG_NO_IRQBYPASS if a VM is never going
to use device posted interrupts.  But those are future problems.

v2:
 - Collect reviews. [Kevin, Michael]
 - Track the pointer as "struct eventfd_ctx *eventfd" instead of "void *token".
   [Alex]
 - Fix typos and stale comments. [Kevin, Binbin]
 - Use "trigger" instead of the null token/eventfd pointer on failure in
   vfio_msi_set_vector_signal(). [Kevin]
 - Drop a redundant "tmp == consumer" check from patch 3. [Kevin]
 - Require producers to pass in the line IRQ number.

v1: https://lore.kernel.org/all/20250404211449.1443336-1-seanjc@google.com

[1] https://lore.kernel.org/all/20230801115646.33990-1-likexu@tencent.com
[2] https://lore.kernel.org/all/20250401161804.842968-1-seanjc@google.com

Sean Christopherson (8):
  irqbypass: Drop pointless and misleading THIS_MODULE get/put
  irqbypass: Drop superfluous might_sleep() annotations
  irqbypass: Take ownership of producer/consumer token tracking
  irqbypass: Explicitly track producer and consumer bindings
  irqbypass: Use paired consumer/producer to disconnect during
    unregister
  irqbypass: Use guard(mutex) in lieu of manual lock+unlock
  irqbypass: Use xarray to track producers and consumers
  irqbypass: Require producers to pass in Linux IRQ number during
    registration

 arch/x86/kvm/x86.c                |   4 +-
 drivers/vfio/pci/vfio_pci_intrs.c |  10 +-
 drivers/vhost/vdpa.c              |  10 +-
 include/linux/irqbypass.h         |  46 ++++----
 virt/kvm/eventfd.c                |   7 +-
 virt/lib/irqbypass.c              | 190 +++++++++++-------------------
 6 files changed, 107 insertions(+), 160 deletions(-)


base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
-- 
2.49.0.1112.g889b7c5bd8-goog


