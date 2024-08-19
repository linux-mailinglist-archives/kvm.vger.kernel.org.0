Return-Path: <kvm+bounces-24543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D7795705E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 18:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DE8C283296
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436BD177999;
	Mon, 19 Aug 2024 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mQ+tIkjT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4824AEF2
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724085202; cv=none; b=ZIUX7iZ0NfNl9KxIhcNaZXbKpYnompE1PUcQbriYKTfz6BrwFOn1xfIVdoBmVtdHOMJ686NPGPOs0ooZ8caiFr022RaTMf2yWmDS96O7Ndt/x0WPizMsFR12sz7+JrhXLIRMG7YDS4jkWNtDejuIGvT85Tx2/auRhp2fa3AsjcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724085202; c=relaxed/simple;
	bh=5w/ixzaqd2fEJi7mnvChP6vlKzaed3No1gqLFeWVQUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G/V1EN3gjL3+nvSy7Din/p0Uf1gFqXy9RTEV05asdzhXwGRL8CGPnqXrXAUW9vT8o7gcQ2oTb3eTKPuTR08qYWQOxr7Wa4LRSVG4SoTR4ghqTYQNdWUY5MDUcE90UtOoBCKr5AVB9CUtVc7fFxRQQM2xwjcfw617OHG8ZE5uA7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mQ+tIkjT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d45935fed4so854152a91.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 09:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724085199; x=1724689999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4p2SIjYuIlCaoRIolQv5TgyKbOPsqVSXeOcL6uydFc0=;
        b=mQ+tIkjTtwGGfbr0G9zsuHBk1n3lByfH+WIZ05TG4Vqtrq4B/Hn2lUxlEnwG09+Qct
         7wkR0K8C/AOotu4EIM3uABjHk/i7HqC3KoU/FuvxYX17hEGhZT/OS1VrlcsRgrDv+Vo0
         DyNDthl2QDRlIHu0LLk/IswUGecYnZAF4FXXYjhkslEiWqe5/vwBPNOoA3AKkMDbAvPo
         YixS2nsiShfC/FveD436Q0ua39C2oOOEnhJckCc3kCgOAQeD16z5rclscyWfvifJo/bR
         hiKEyVKXPYAKsGCJfP6xD70Phnr2QKAFq+O5FJGVhvMD5SU5YAZmyedV2uF8xvp7cMow
         hLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724085199; x=1724689999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4p2SIjYuIlCaoRIolQv5TgyKbOPsqVSXeOcL6uydFc0=;
        b=LMhD6Yy8NwwD92lnIbB09YbSJW1QDxMT3Wjmi67oxj45U+S9fUl0s7U6N4HpvNdpK5
         zE7IfIGf9cuveI8sXI2SqtOA/q6HZCtEyD3/BfeD3Rfmi9AbU5X2RFzSgp1X8ofl3V8S
         67B1NEjkahdu1+HbAxB3dKBzbge+WNO0zHyL6rl6DaNnCaUnlzKu3tHlQ0qmUkFt2p8E
         MvjNAlyCNTMIw6Vq65062V8kzjJBS+PV2KSxCGMScxpC/NutLXBY5Y/f0tmIyXN6AXBM
         0EpHDcVRtMP8ZUCcXvSGfixVvoDisvCXgTbqpvbwnpzUXpxnxDi3VfBtm5h0+rnKsOKg
         TPOA==
X-Forwarded-Encrypted: i=1; AJvYcCXvW+IhGZovngtNC150aXPoqtZc61DBWOh9RSv1Rf+oruaV3kkXmfj0BMSqq2I+/dccQqFVzyL2s9Kzw4LdZi07MVxS
X-Gm-Message-State: AOJu0YxVQfrEX1YVTGWuWdYVcBrBPoJ/VGbNm2PJnK3bbJDDqEgcNc0c
	LW1EvxY+F/5F4OPCvQFkOzzLi1nTJ/PZMATGeOAPDqWfT7zFsOPaf0uYNlk2vvN3rHJZgOTZj2Z
	jiw==
X-Google-Smtp-Source: AGHT+IHXXUvDjnIGWgNHi6tPM6TODiIIkBZkAGdWWZ2nPO179CxiELhSLItCjUB3DxMPDqXY1QGYzaRxHYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1043:b0:2cd:1e0d:a4c7 with SMTP id
 98e67ed59e1d1-2d3dfc1e9b8mr52362a91.1.1724085199152; Mon, 19 Aug 2024
 09:33:19 -0700 (PDT)
Date: Mon, 19 Aug 2024 09:33:17 -0700
In-Reply-To: <20240819093030.2864163-1-usama.anjum@collabora.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240819093030.2864163-1-usama.anjum@collabora.com>
Message-ID: <ZsNzzajqBkmuu5Xm@google.com>
Subject: Re: [PATCH v2] selftests: kvm: fix mkdir error when building for
 unsupported arch
From: Sean Christopherson <seanjc@google.com>
To: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kernel@collabora.com, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>
Content-Type: text/plain; charset="us-ascii"

+KVM arch maintainers

On Mon, Aug 19, 2024, Muhammad Usama Anjum wrote:
> The tests are built on per architecture basis. When unsupported
> architecture is specified, it has no tests and TEST_GEN_PROGS is empty.
> The lib.mk has support for not building anything for such case. But KVM
> makefile doesn't handle such case correctly. It doesn't check if
> TEST_GEN_PROGS is empty or not and try to create directory by mkdir.
> Hence mkdir generates the error.
> 
> mkdir: missing operand
> Try 'mkdir --help' for more information.
> 
> This can be easily fixed by checking if TEST_GEN_PROGS isn't empty
> before calling mkdir.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes since v1:
> - Instead of ignoring error, check TEST_GEN_PROGS's validity first
> ---
>  tools/testing/selftests/kvm/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 48d32c5aa3eb7..9f8ed82ff1d65 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -317,7 +317,9 @@ $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S $(GEN_HDRS)
>  $(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
>  
> +ifneq ($(strip $(TEST_GEN_PROGS)),)
>  $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> +endif

This just suppresses an error, it doesn't fix the underlying problem.  E.g. there
are other weird side effects, such as an above mkdir creating the $(ARCH) directory
even though it shouldn't exist in the end.

It's also very opaque, e.g. without a comment or the context of the changelog,
I'd have no idea what purpose the above serves.

Rather than bury the effective "is this arch supported" check in the middle of
the Makefile, what if we wrap the "real" makefile and include it only for
supported architectures, and provide dummy targets for everything else?

E.g.

---
# SPDX-License-Identifier: GPL-2.0-only
top_srcdir = ../../../..
include $(top_srcdir)/scripts/subarch.include
ARCH            ?= $(SUBARCH)

ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
ifeq ($(ARCH),x86)
        ARCH_DIR := x86_64
else ifeq ($(ARCH),arm64)
        ARCH_DIR := aarch64
else ifeq ($(ARCH),s390)
        ARCH_DIR := s390x
else
        ARCH_DIR := $(ARCH)
endif

include Makefile.kvm
else
all:
clean:
endif
---

And other KVM maintainers, the big question is: if we do the above, would now be
a decent time to bite the bullet and switch to the kernel's canonical arch paths,
i.e. arm64, s390, and x86?  I feel like if we're ever going to get away from
using aarch64, x86_64, and s390x, this is as about a good of an opportunity as
we're going to get.

The annoying x86_64=>x86 alias still needs to be handled to avoid breaking explicit
ARCH=x86_64 builds (which apparently are allowed, *sigh*), but we can ditch ARCH_DIR
and the KVM selftests dirs match tools' include paths.

---
# SPDX-License-Identifier: GPL-2.0-only
top_srcdir = ../../../..
include $(top_srcdir)/scripts/subarch.include
ARCH            ?= $(SUBARCH)

ifeq ($(ARCH),$(filter $(ARCH),arm64 s390 riscv x86 x86_64))
# Top-level selftests allows ARCH=x86_64 :-(
ifeq ($(ARCH),x86_64)
	ARCH := x86
endif
include Makefile.kvm
else
all:
clean:
endif
---

If no one objects or has a better idea, I'll post a series to do the above.

