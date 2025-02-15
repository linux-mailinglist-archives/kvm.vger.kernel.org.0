Return-Path: <kvm+bounces-38236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE357A36AB0
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D607618936DB
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E81F81732;
	Sat, 15 Feb 2025 01:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w/Chh4V1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0643A26AFC
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739582081; cv=none; b=iWkcpDJ4ujULtL4i7SR/rdNTwDnqLn5TVPNK8TWk32BYJl/8r1/DY5CnWSyXL6Y/c14EQy1OZNdF4M7dwbkUpF/zdvfyfjJRO2hsm00uVvZ0AQixI1hGQ1CsvHXELUntbesEGZ3dKX7dcC/8e91ohXfuEWmEIDIk4D5MPSsHcZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739582081; c=relaxed/simple;
	bh=fXAP+EFhzTA0wWutw9G/BqB7OpJJNUcHbfw6HUvM/u0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KK6AFeUhdFOfZ2NWaYMUd7CkvpVdyV9nh5uKgTgVESe/YGn4PJynLq9nxt+yaVzcxZHYFoCm3+NEhMT46KBOgYrOGZ53WUNtRBfSseYj6NiJtX69JSSUb04g+1tmd9cZ8VN6fzaBEZpchR9p0+6Y/9smasTPhH4ln4PJJ8PV92Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w/Chh4V1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc318bd470so2657727a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739582079; x=1740186879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFW8HcMPEFBtu4QpEr86rSfrtjpZ1XO/Hv2S9x6GxYY=;
        b=w/Chh4V1OcgTXYzkhQop6nSdGibpqCorYCkWnTiql2j9CimJ7ojfP5o6c2zOcbUf9c
         KpXHlS1lYIg7JK/RONInq4saQFVVzd/EAz+YVv1iY7RyPpHk3bJ0iQ2H1s63Kc6xKfCA
         eHACaV3ZGyme5Vv/E1F4pUIg5M5xWjKXgHHHwM1vWNJupFInBppHddO/YRl2j0XuwFBx
         gEFkVkZwmpeFhkjmx+uURAi57RU9L147dHhN9QKM7N5MD2xhG/pEmINj7T5smaJwd0y/
         FgyLa/MqnYaxUzMlp6BCNVjPtXUoiqTdBh405eA2R/VhwWbw98jWTquEcsepCDsMa97+
         HqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739582079; x=1740186879;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFW8HcMPEFBtu4QpEr86rSfrtjpZ1XO/Hv2S9x6GxYY=;
        b=HpxNiy5nAGzFt4bbkgPaxh4B8R1iVyv4DBLh3auFtETdc3rw5lijFlEN2u6Zxr2v5p
         6ZWfj+mJCKAcyUBD0Z1ZuGIu1wvVVfSfc2TDn9xetJ86r1Jh0PtfEPbIxFJQrgn1YTFP
         NfEdtVy+a5ffkssTRdVgVYpVaibOFV1RXFr86pJFQ+UzyFSX6DLuu5pikPmYgwl1MBZx
         RvcMxTGhrkh/SFb83V6BY/FCzl54YFjcO0jGIe6r51BTluvnsQYz8cN3ACHKmZwuQTuM
         yi4XAfipjbDHEotcn9omA8AFQXwF1VrGwFfayygLDJmKEZRQVS7hx8XueHISL2cxkrLY
         e8pQ==
X-Gm-Message-State: AOJu0YzgwoqLv1Bmiji8DhlOj96b2ghnf/g5729owgECQVIG/k+y9Pf8
	0WCrrBcHa05ZHZmMGbd4JrFONiBRwHe9fh+9rdgn5Nq47VYf8GdRs7j2BmFWPFSDhC+J2/3ol3K
	7Jg==
X-Google-Smtp-Source: AGHT+IH3KMxbwmXsOp13PDSlvkQwNBb95UY8fwQIbGWuhZj5HiS3WvB0Cvx3flqG2Ernendo6FqCfQgrnW4=
X-Received: from pght6.prod.google.com ([2002:a63:eb06:0:b0:ad5:4620:b05d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a9:b0:1e1:e2d8:fd1d
 with SMTP id adf61e73a8af0-1ee8cc031aamr2720410637.33.1739582079524; Fri, 14
 Feb 2025 17:14:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:14:32 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215011437.1203084-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: x86/xen: Restrict hypercall MSR index
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"

Harden KVM against goofy userspace by restricting the Xen hypercall MSR
index to the de facto standard synthetic range, 0x40000000 - 0x4fffffff.
This obviously has the potential to break userspace, but I'm fairly confident
it'll be fine (knock wood), and doing nothing is not an option as letting
userspace redirect any WRMSR is at best completely broken.

Patches 2-5 are tangentially related cleanups.

v2:
 - Collect reviews. [Paul, David]
 - Add proper #defines for the range. [David]
 - Drop the syzkaller/stable tags (rely on disallow host writes to fix the
   syzkaller splat]. David

v1: https://lore.kernel.org/all/20250201011400.669483-1-seanjc@google.com

Sean Christopherson (5):
  KVM: x86/xen: Restrict hypercall MSR to unofficial synthetic range
  KVM: x86/xen: Add an #ifdef'd helper to detect writes to Xen MSR
  KVM: x86/xen: Consult kvm_xen_enabled when checking for Xen MSR writes
  KVM: x86/xen: Bury xen_hvm_config behind CONFIG_KVM_XEN=y
  KVM: x86/xen: Move kvm_xen_hvm_config field into kvm_xen

 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/include/uapi/asm/kvm.h |  3 +++
 arch/x86/kvm/x86.c              |  4 ++--
 arch/x86/kvm/xen.c              | 29 +++++++++++++++++++----------
 arch/x86/kvm/xen.h              | 17 +++++++++++++++--
 5 files changed, 41 insertions(+), 16 deletions(-)


base-commit: 3617c0ee7decb3db3f230b1c844126575fab4d49
-- 
2.48.1.601.g30ceb7b040-goog


