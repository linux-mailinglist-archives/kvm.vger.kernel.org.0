Return-Path: <kvm+bounces-59619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAAEBC3445
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8962A189A2A0
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286142BD5B4;
	Wed,  8 Oct 2025 04:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cmMQJlLe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7801314A60C
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896441; cv=none; b=vDUCXOG+OJ//emtYljiwXCmZDJomhOmA9LfQFCibZs7Gozt0C0qDVld6u893dm6U4xzkXEls6Zxu94Wb1wQh7OnsbQ13pry0C5ZrQ6Ca9yJRwp0DCCkifiI0qH9mdRdcAL1GUtxJpDgzME7pgfzmlpX3YFrwB4JECjwkQPgL+mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896441; c=relaxed/simple;
	bh=Cu9WoDis0IeIopYQl0shBD107PqRlttPuR5SKC6D990=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FJHkYquNlBDOUQAkcP053JnUwhQezCOWw7eyTeDluycLHk+5TyOFZM/Q6YNZg4FEUj9OeeYwtLbM+2bPVpc+/G9+jH65i0mwkbmQhMyW3ngWMiVEcwap83jkFCAPIIU1B1UW5g97EcO4K0B7NqxMgdFT3ch25IzTjbrOv5iImyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cmMQJlLe; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e37d10f3eso46702785e9.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759896438; x=1760501238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XK3NTl2B3zTpPA8Q4QoS/MR0UKSoTctc+BHX4wlh/xE=;
        b=cmMQJlLeq9IBdid9PR8lJtBpOTpzShXUlvkerXFdGffUefNOGKOE2nQpFiLG+Xg11B
         Q3j7VTKUALu2EaDPdlRJ+qbA26S8/ucHHi+BQzfZBTPU+kSJgBFsTO+tvDfTDPwwFoYn
         whPo5GkPv6krj4X8TVpCkYIbJOFl6odxhyWswIE6H0/q/wNiUHHGq7Tp6/61AopeKKA7
         1iSezxsaaHn/owj+DPjLrl51HwHGjLByLsNoqtZCaegV91nKJk+q8HqF34uPAee2nOyW
         43x3R5Q2nrG40VY2P54JouBGkQvQnMf5MfR+KuKNsVgFrdZZRtT9/X1NgVXMJS4B/aF9
         X4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759896438; x=1760501238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XK3NTl2B3zTpPA8Q4QoS/MR0UKSoTctc+BHX4wlh/xE=;
        b=IgwkDkczuPwSABu1kqr6J1DtTYyhJvpLFJO+zsfWH4JVcRfFC1X8Pg5rGNbvGYUDW7
         2vlItAAY8CFA0A7rIaXYJ3WlHZRIysnD4RdBB2HLsJaYvO5fK6eRQQuqhcBPeeRVuLNi
         Y9/wVSJHY5WDSVDSi7MI/sPnHACqVFifZeFW6uh+E3uSByZnSgCO5R/bcwxS/NlwdxMP
         dX9mprv6Ba+UAkpZwnREM2cCgrLIPxqbui6c1yX/soaica1j0n9WFuNnQxvBMlegWkHC
         5n/tEH6AWxLwJmrYPGPaN9bPUo3hpR6fk9uiC6lkl7rzNKyv5lcYSssgVBFUEgKeDdKA
         zczQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6i8h1LCioLkZuN7/HlGYpZ75m0SfSLJySpqtNtT+LV/oGJsQ63D4PyNnR7AeCVTcdBDo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQuqoSOWVOitl+OfuU1tnanCdawzw3PeQwXB7u5xnlGWvhoq2V
	6SKsFq2IGedyPGpHoyG3N3yqDNXRN7XhLXC23JocjBS9smS0/m6DAzsHzOlqd2qfhb4=
X-Gm-Gg: ASbGncusv8en4glYfu/9CwVfMJys9mvzvB6gnma//xcVUQ/MkX0sUnIuCosv/PHMRmv
	GpO74XxZ6MgTvGsfoXn+IvLE5ol+mT/3mKc3jby6NW+4Ra/tc3xpVtmCDnceFGlIm27hQazfMNa
	Gof4nL/+7AvlMxPKuOUT9rFgjKTUBE5XpiH/RTTDL+vkpMHYS40Dn7tF1xJfCD1PaPHNLpSSCXW
	joANSvT0DBEFCdKzNkPld7H/eubx+nw9O4G6OrOlMK00AD2pkq8PD8f9snXCgwz/n6byTy3iVan
	Lr7fHz0LjuJa9WsiSMmy1FMkDgNxW+wmljxrNzWixJuAx3/banRxyEPlgMfUz7OVbDOBqVImOo9
	8+ID34SFmvT4BddoYX64BCUzLIqd630HQ6MplZTazsu7GrVFLfDCGYGqCmD57osXnGylak3Ija5
	9Pxi7+7nVXjeUuVICm4+at4AaA5/2NgCjNLzA=
X-Google-Smtp-Source: AGHT+IEIXGL3P8t0oTh1p1V3NI6++BW+3/EMw0SpDKt32lyYUyJmhP1y1qCj6ZQSEiMdg1THa01ESw==
X-Received: by 2002:a05:600c:3b07:b0:45d:d97c:236c with SMTP id 5b1f17b1804b1-46fa9af80aemr10434825e9.21.1759896437672;
        Tue, 07 Oct 2025 21:07:17 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9bf6c64sm19154605e9.4.2025.10.07.21.07.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:07:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	kvm@vger.kernel.org,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Song Gao <gaosong@loongson.cn>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 0/3] accel/kvm: Cleanups around kvm_arch_put_registers()
Date: Wed,  8 Oct 2025 06:07:11 +0200
Message-ID: <20251008040715.81513-1-philmd@linaro.org>
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


