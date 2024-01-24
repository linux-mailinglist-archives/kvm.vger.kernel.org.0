Return-Path: <kvm+bounces-6827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8048E83A7FD
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 222461F22F35
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B28D4F60C;
	Wed, 24 Jan 2024 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVZPvN+v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585DB4F5E9;
	Wed, 24 Jan 2024 11:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706096107; cv=none; b=uxiIYoXDLFTeM/mYxphh/7Un9SkJ/AbA03tW62R2Czw0MoPagY89qWSLZVSDGsOILQ41VS9yi0PPABKSTtKMPIA0yEwK0uleJCddHFe5apg+lCX3Apl47h5uytk7VGRZ3TmZ44B7IcyH/5CxWKnoq5FBFelgjbKu+TDCkRVCPgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706096107; c=relaxed/simple;
	bh=P87B/NJmEx20+ry47oVcoCNzd+QWvtcpba/ysVCMEEc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CP4JKz856rC99QC2iy2fwQIMCKqi8RtXzF05t5D5ICjGGjsJd7UHbEjOW5eS2VE5zoM7wdQjeUhS8xuIS6iNsINrIYXkT6puwW1SDO8uto3oOIwWbp5WUwjQKVsXzHchqY+cOIQadXNcjSHN2PP7ODzPqipYPIVcnJ4SKI3htk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EVZPvN+v; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3bd9030d68fso3264249b6e.3;
        Wed, 24 Jan 2024 03:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706096105; x=1706700905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C9dLmB1UBk2lcc6K0p3fcasn7wjRUeWpHrr479fQHwU=;
        b=EVZPvN+vjkGSqbk0xy1pNd30FiFLn+wCMmNxaisov4PUYZO0M651jiQU+1Yp+pZCIM
         EuL0YppZ2NVcuDDr+mpQrwVYugUD3lU/klLM4Fj3rKw6O8oVZZ0ZoQ6ZMQCsZsakk1SB
         5niPPIvwOjzdf4mWbj+0VarasTrLv0kzXvAAWOoJCRkQbw6a3cHyXXmwmxww3mp6sc7+
         8PRL4lNAj01ZaQLeImX2i/Lvc4k6tMaF7m8FLsTmNznLFd2124a6kliyl8TVt2thezE0
         44EGqsrsGZocF3BE/eEIjqOs/68cVa8+4PfTuAHSuVJP09cWEmgJAEdzIey7ih8o50G/
         77yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706096105; x=1706700905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9dLmB1UBk2lcc6K0p3fcasn7wjRUeWpHrr479fQHwU=;
        b=WK46SV7WhWJ912BAVJERSbFahNE66UoNFz9jIVEizkLVefyMfzTdtdXSx/NjA4SoE6
         bqgVO4nztkh4G3AbojeXm+WN6sy3zc9eBYbG4pW8jgO6M2jfz3/wlSgrxmEcslbxtwzM
         wWdeqCta8uCQGSiZ2XUnvIWtJkA+6FNE7rq5aVJEh4UgCet9O+1koSjkpml41Oin2Y6C
         WwPSMEJwEK7aJ2Iik1x6RAnrlsE2nNWKGzC1zwN8p7wxJHTKg1U2PT8VCLvOpUupPDYB
         +3wZ7qIOsgHNQwlQ4WQxhDU8eKLP39lB3ZHoAKV5SYccT+6cFPYsT4FRla/j+tzGGw88
         Q5YQ==
X-Gm-Message-State: AOJu0YwamzmT651cOwdhYP1a540I6f+O5JB6DgOcYEme8TOHRGJEPIfn
	lA0Qy/qKWXszp0EQiw0xYkkfVjdcx62nam+lywT78qIzzAoyfvBH
X-Google-Smtp-Source: AGHT+IEt3aCxUIfMjDOEuHL1g4y3s4edufzn/iCQAQWHFDxaD8a0GWx+ZQUtTyZrxSqIBvLi9y7ivA==
X-Received: by 2002:a05:6808:3a09:b0:3bd:4df7:db85 with SMTP id gr9-20020a0568083a0900b003bd4df7db85mr1859788oib.69.1706096105325;
        Wed, 24 Jan 2024 03:35:05 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id c15-20020a63d50f000000b00578b8fab907sm11727820pgg.73.2024.01.24.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 03:35:04 -0800 (PST)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wanpengli@tencent.com,
	foxywang@tencent.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Cc: up2wing@gmail.com
Subject: [v3 0/3] KVM: irqchip: synchronize srcu only if needed
Date: Wed, 24 Jan 2024 19:34:43 +0800
Message-Id: <20240124113446.2977003-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

We found that it may cost more than 20 milliseconds very accidentally
to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
already.

The reason is that when vmm(qemu/CloudHypervisor) invokes
KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
might_sleep and kworker of srcu may cost some delay during this period.
One way makes sence is setup empty irq routing when creating vm and
so that x86/s390 don't need to setup empty/dummy irq routing.

Note: I have no s390 machine so the s390 patch has not been tested.

Changelog:
----------
v3:
  - squash setup empty routing function and use of that into one commit
  - drop the comment in s390 part

v2:
  - setup empty irq routing in kvm_create_vm
  - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
  - don't setup irq routing in s390 KVM_CREATE_IRQCHIP

v1: https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent.com/

Yi Wang (3):
  KVM: setup empty irq routing when create vm
  KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
  KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP

 arch/s390/kvm/kvm-s390.c |  9 +--------
 arch/x86/kvm/irq.h       |  1 -
 arch/x86/kvm/irq_comm.c  |  5 -----
 arch/x86/kvm/x86.c       |  3 ---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 7 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.39.3


