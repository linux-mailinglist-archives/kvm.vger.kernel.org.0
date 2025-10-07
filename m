Return-Path: <kvm+bounces-59562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F9EBC0967
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B7953C5518
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7142868B5;
	Tue,  7 Oct 2025 08:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FEvnOamd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A5286D57
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759824983; cv=none; b=qNK1pYI3nYd/5XSDUGhWC7X5WdRwaghoHEeadknh5rwGDQAb3yXKsOSyNYAUu6zm91f5+rvdmUfrfhRgZo9zkQbGJ+kypxpkAPUog5oMpC5IPPINAD8kb7oAnZ0+cg5oLwGLXCi7XG5qJYQOjTMMT3FJOCIRBlnysr4HNg16msk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759824983; c=relaxed/simple;
	bh=Cu9WoDis0IeIopYQl0shBD107PqRlttPuR5SKC6D990=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r8p92Y97FJzynPKJE5OUqdsCC7XoSGTOrtgFnTePzF5n9o/uGPqeIWoI262mXBotBwnMWtUtoDcIkI5V9Jv866xZAa5QMG2ugxY8VjIsu8vXlatN4SxFaCuq5N75GCK5CeebpHlmWU6xTWxQAg24tw8ywKASjMLd3k6VjpvWUmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FEvnOamd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso38701645e9.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 01:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759824979; x=1760429779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XK3NTl2B3zTpPA8Q4QoS/MR0UKSoTctc+BHX4wlh/xE=;
        b=FEvnOamdBUg0ogfp0G+ec9pbwY1yPUOWveN9jlo830MIOyikROh5Km1u780WBvCLzL
         uMDidz0zE6Q+G88Eo+Ci1Df4e2AKfLNAy6fxIOXcq2g9TCE94YLKY9+9L4FOZlGQZUav
         79n2fo9MUruqQOEqF7Y9V3yHylve1lFPB9/q/CB0XTzqVr5PvCK4CwRZ2z33bxK9G5cX
         PUgCYDz9/T0urmZSQMIO1Wx2V0I+t0Ximhs+of7V5En4FKQh4jHczYYCzSk4BDHy48YP
         uSbhfDbHplANiLRup/1BQtscytMcpLQLRmwyR8SXD2wEG3qIJcSMgvGDN0zq5Lf2PqcU
         d9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759824979; x=1760429779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XK3NTl2B3zTpPA8Q4QoS/MR0UKSoTctc+BHX4wlh/xE=;
        b=QhYkH8jFE2cI5T/t9mapZH5shCA1hg9S6XfO0dqOB4LUwMk28AJS+pviHY1+DwV9L1
         90YjRtzhD9UI9o9XAjEJSaMfSPld3BQbtEjlbsTXy8tH0mJuGJyAY+b38NgEcC1PyElu
         tKYm983R4BcOZKxL4SIVtI2m7B+wVMOtkbdO+cJEtGYi/DMoSKQ2Vhwg+L2ttjpFeNsT
         whVtTO95a0hWm92QgHRUrtTgrAkk/2yETMq8ya1p3G8R8FB4kwMMesVNiMhmvFZfFBSs
         YEca4+Uf5RpXbhu/P/8vJcARFdx0krxUm4KaDTGqeQKZfQ+SbT4yd4RKJyIXqCT8x1Yr
         T+rg==
X-Forwarded-Encrypted: i=1; AJvYcCX7g3CzVCOri4zb4jSQzv8V1dYgwMmFuTNaoAdxNQGtkbQ/4G5oV/rd18n4fxi866TVCX4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSKauP3ayzvcr+2i/KkFBDcKxg+/mwISMI0qy1jFT4NMHeexhI
	0IQG594OkxPh0pnPhl2yaBrrHcaQhnQZjNBnLDXVeieWHM9YRrTeAghC6LATvUG1dtE=
X-Gm-Gg: ASbGncvGF2xm5z0FQICZTJHZE4JLupznbQ1522MrjeRtitssUImi5dCPOoGibGSPqGR
	OTRVUbjUAlElO7VKqndtf665ENv6DFP/66tjdg4O5DPj0B/LcvvU78PP1VNOzqK/jVtZsiRZx/T
	/RUsnTWhcQy5SKJlB3VevcTVP5nYwBnQHyYcZ/6gpA4bm01tQODjD9KqMDKdsjrakBvGWhvu3Wu
	2WJfXz6V+aLMyBliZ+9NlJsCnRFDqD0+XK2hvFKGWyRwdZgKBnkauZ1o7wNFAkztHAsduo4yuqo
	I4oxnvX9/EmVlRY/zr1Az82pWT/odCrI+Ljjdc21Cy74z/Fd9PyTtdukG1E0FEWvrE/H5Ceq75A
	/PviyKeJlvzk4u4iPVWvaGIrKP4Di9rfbdqiSfiIJCm9wm6DVrqfD/3IrqNyDr3s76sSzsCTUMo
	0fmKYxpZccYXGr/D7jLewoahCx
X-Google-Smtp-Source: AGHT+IERVc3C2yNd3DcAeDNZ7zbSciuCigfwYIc8ze9WnpdAZv9l9FsjkHi9L+VcMIyxbope5cQePA==
X-Received: by 2002:a05:600c:34ce:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-46e711408b5mr109040775e9.18.1759824978832;
        Tue, 07 Oct 2025 01:16:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a029a0sm289392805e9.13.2025.10.07.01.16.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 01:16:18 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	qemu-riscv@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 0/3] accel/kvm: Cleanups around kvm_arch_put_registers()
Date: Tue,  7 Oct 2025 10:16:13 +0200
Message-ID: <20251007081616.68442-1-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Extracted from a bigger series aiming to make accelerator
synchronization of vcpu state slightly clearer. Here KVM
patches around kvm_arch_put_registers():
- Move KVM_PUT_[RESET|RUNTIME|FULL]_STATE to an enum
- Factor common code out of kvm_cpu_synchronize_post_*()

Philippe Mathieu-Daudé (3):
  accel/kvm: Do not expect more then KVM_PUT_FULL_STATE
  accel/kvm: Introduce KvmPutState enum
  accel/kvm: Factor kvm_cpu_synchronize_put() out

 include/system/kvm.h       | 16 +++++++------
 accel/kvm/kvm-all.c        | 47 +++++++++++++++-----------------------
 target/i386/kvm/kvm.c      |  6 ++---
 target/loongarch/kvm/kvm.c |  8 +++----
 target/mips/kvm.c          |  6 ++---
 target/ppc/kvm.c           |  2 +-
 target/riscv/kvm/kvm-cpu.c |  2 +-
 target/s390x/kvm/kvm.c     |  2 +-
 8 files changed, 41 insertions(+), 48 deletions(-)

-- 
2.51.0


