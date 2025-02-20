Return-Path: <kvm+bounces-38809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFD9A3E889
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:31:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0577A701C64
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6F3268FE2;
	Thu, 20 Feb 2025 23:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ia1GbXzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81717267B7C
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 23:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094210; cv=none; b=ckATTxhkwURozar/o60VKkS1dV9N1Wg3fzKTkGt33cq2kXfl32xbEmH8WFGfDdvQRDyfW9BVa+ljRfWZuwrTcit6S21UaNASvj4moTbts1fLDhDOr9RBf8Qs21prRyNyCADqVq6loAh+4BVBNGA/Qw7GcMWshHMRRN3IV+pOuoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094210; c=relaxed/simple;
	bh=mWRk++/bQqQgZy4LEk1jYBf4PCsHJwDN0tHvqsBCXpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NQGAlkOFPDTycffZUvuFQGMdGM1wzzxZz/lbFanotQ/bBSo+Q7rI3C3KSCf4DB1RxKFoHgj8tlmGHBVrnHWk3MF/zbJqDp/1X/SCyOWQizlwjRcTzuDnXMs8bE/Mdr8BhdYyFjVLKRg7SgF1mBRM9Xipj11LqHCLyMIoihmHXxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ia1GbXzP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc2fee4425so5046271a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 15:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740094208; x=1740699008; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZY+qAPOicOUq8p2LK8IeikgixBi4lx8HxmpqAWAHnA=;
        b=Ia1GbXzPQkYnqpRUXSv00oTDw1Z7TgorBuB+rDKsg1oze0neVXL2viJKZ2dBHked1B
         V3mTwNaHRbCAunS3QCnIBBhUU956LuCx3mvXASnU7I5bBnB8mkv+HsyajH6byxy8lrHQ
         fee2gzxtqPAjiI7gXaayG61JNHDp4ZS9yNs8AIe0qY6Y8FgHAzo4kwuZOyUy+qhSqgSx
         rkxkjg663mNrRv9mtirtTjPFOv2M6Unhh4+wISteBqs6C6MOwJ+eusSSLgOSM6LRE7mY
         NvAQqckkCjmV9ESOAZwA7hemitwXpT17Uwisyjy9agxmgNhTUXXALMrwal4Ah2hxigGQ
         2Hww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740094208; x=1740699008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZY+qAPOicOUq8p2LK8IeikgixBi4lx8HxmpqAWAHnA=;
        b=SNxadWpBZctj2LsZOSn6tK0j4qEO5NccJhjlMvSuvd7azBuV4DacmtjerNKCupBCjc
         4FMbrM9yvNRjZOeGGHIfMJ3AX2XGNCHnOAgWOubdNEOIKZJD54eAI1f4AqmRqqVzeymG
         SRTafrMiNPoEapn9rPxIqHTLoWfVEKnhyegjVwmNC5sEXMcioW5TZhxK1QtVbqZ8vD8w
         uT4PkOsva5qsKlFfHEhMrNDXDD4fOYppXhPPQd1sEni2bWbaY37wkKyhEfyXIqdjK0Gn
         fCkWa1NqIPKNm4hHe+A6qnKhOqYqdV97Z60dS0fKCGdb4P9ifOaI2eKkCowviGXFYYRs
         qbTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyFi52x56QwQjCNUctjF8U+XqQPhemBBRcTtnJjtSmrB9B/tUiyjKQJ6+6JZrGIACDUwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz54AnrcNSmA3X5f0uvFjwXFz1rAlEKB7A/OmMy9ilfkYiJYo/a
	Yfn7jB3LCwt0zOhQ7420lZGpQOH7Br5QgD/E5eC59CiiIzd/BYfWuO0EjJ4+DlEgv8ccyO4flF5
	Xk1n++0l6pQ==
X-Google-Smtp-Source: AGHT+IEBaG/uVrgEVEadJS5uoF6GF3zEvxqFSthLZ+KCQQjV/E6qlAa7wWQxBxQYuGn6ZWD8KVd4x5+IgTERjw==
X-Received: from pjbpt3.prod.google.com ([2002:a17:90b:3d03:b0:2fc:13d6:b4cb])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e4f:b0:2fc:b40:339a with SMTP id 98e67ed59e1d1-2fce78a95d5mr1872440a91.10.1740094207918;
 Thu, 20 Feb 2025 15:30:07 -0800 (PST)
Date: Thu, 20 Feb 2025 23:29:59 +0000
In-Reply-To: <20250220232959.247600-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220232959.247600-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250220232959.247600-3-jiaqiyan@google.com>
Subject: [RFC PATCH v3 3/3] Documentation: kvm: new UAPI when arm64 guest
 consumes UER
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, duenwen@google.com, rananta@google.com, 
	jthoughton@google.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the documentation for new UAPI when guest consumes uncorrectable
but recoverable memory error (UER). This new UAPI enables userspace
to inject SEA into the guest.

Tested: make htmldocs and proofreading

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 Documentation/virt/kvm/api.rst | 38 +++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b52eb77e29cb..20c7049508484 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1288,16 +1288,40 @@ ARM64:
 
 User space may need to inject several types of events to the guest.
 
+Inject SError
+~~~~~~~~~~~~~
+
 Set the pending SError exception state for this VCPU. It is not possible to
 'cancel' an Serror that has been made pending.
 
-If the guest performed an access to I/O memory which could not be handled by
-userspace, for example because of missing instruction syndrome decode
-information or because there is no device mapped at the accessed IPA, then
-userspace can ask the kernel to inject an external abort using the address
-from the exiting fault on the VCPU. It is a programming error to set
-ext_dabt_pending after an exit which was not either KVM_EXIT_MMIO or
-KVM_EXIT_ARM_NISV. This feature is only available if the system supports
+Inject SEA
+~~~~~~~~~~
+
+- If the guest performed an access to I/O memory which could not be handled by
+  userspace, for example because of missing instruction syndrome decode
+  information or because there is no device mapped at the accessed IPA, then
+  userspace can ask the kernel to inject an external abort using the address
+  from the exiting fault on the VCPU.
+
+- If the guest consumed an uncorrectable memory error, and RAS extension in
+  Trusted Firmware choosed to notify PE with SEA, KVM and core kernel may have
+  to handle the memory poison consumption when host APEI was unable to claim
+  the SEA. For the following type of faults, KVM sends SIGBUS to current thread
+  (i.e. VMM in EL0) with si_code=BUS_OBJERR:
+
+  - Synchronous external abort
+
+  - Synchronous parity or ECC error on memory access
+
+  If the memory error's physical address is available, si_addr will be the
+  error's host virtual address in VM's memory space; otherwise si_addr is zero.
+  When userspace vCPU thread is interrupted by such SIGBUS, it can ask KVM to
+  replay an external abort into guest.
+
+It is a programming error to set ext_dabt_pending after an exit which was not
+KVM_EXIT_MMIO, not KVM_EXIT_ARM_NISV, and not interrupted by BUS_OBJERR SIGBUS.
+
+This feature is only available if the system supports
 KVM_CAP_ARM_INJECT_EXT_DABT. This is a helper which provides commonality in
 how userspace reports accesses for the above cases to guests, across different
 userspace implementations. Nevertheless, userspace can still emulate all Arm
-- 
2.48.1.658.g4767266eb4-goog


