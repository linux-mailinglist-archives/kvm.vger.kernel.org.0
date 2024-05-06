Return-Path: <kvm+bounces-16711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D978BCBCB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82267B230DE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A100142E6B;
	Mon,  6 May 2024 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fES+0GPN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D68014265C;
	Mon,  6 May 2024 10:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714990699; cv=none; b=VgBpo0BpIk8qmkogNz16Q07QXGq/9AgyOqjeRPbVRkBdtzCeyhbsw9Rcnh/ZAuXSbRkBymoTq94PcXr8xS7Ifgn1l0zaRT/Twj4T0StI4idkbnEHFFyJtfV6oSdN5Lt+5oE8HsmDQDHqGdQmyeUeGaP2UtyKe87MU6ZbwQlk/VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714990699; c=relaxed/simple;
	bh=cv9Xf6RJX2+JfY49KGWLq+dotduUrWooM07XtqS8BxE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PykL0ErLYFlZu1fZ76H2GNBgyMD9fPipvckLeQjSa/Ia4kUyh7m1JGyhZGDatdKa3h52Vq05nyfsIB1XVfjvlkVM1/vm+vgRzDcd9O70FOCXmYmDt1ugqltwpdqFawKbcm5Vtm7PBnBvaJOxHKcDbe+t8PP3pQNkZi1LIVxXDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fES+0GPN; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-61eba9f9c5dso1393622a12.0;
        Mon, 06 May 2024 03:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714990697; x=1715595497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KGGj1ByS8hjIQegHjGWKUfpX6MTSpXK5PbnFS7ZcvUU=;
        b=fES+0GPNjjiCwIxSDnCe7kMID7UcVgixNg7egxEJlBQMJ3zfJIjFnnaMCtB/lg7C2K
         2IgcseNuU40+Nc27Mvm/IVNR9iCMXlf2fdkqwgxADPhTQCtmP+zqsvIqoo8kESwLUIzB
         T/it0fMRTvXIr5bqEPQndxU6MPhwR8WBOtdOneTGz9wbiLG3Jo2Gb+RxIUahMziZ+DGt
         /8K8uaYKMIeww9qIGjI/WPiOjfdOapP7RNsvZ/Yllkw5atV8GYY23ylMOKq67+LcWHRu
         f1VgXvURu8da3Cbp3gh4yyrmshJjpCSMZkJA7A6knNDH98hJapkYjxms47n8CPSJ6c5a
         REOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714990697; x=1715595497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KGGj1ByS8hjIQegHjGWKUfpX6MTSpXK5PbnFS7ZcvUU=;
        b=eepxOKctGtaMXgqzQeK5djW0gp9JZGB2QJhy5YBN7509sp1lf1vZWxaiUjtMylo//i
         5MKYPm2BSr2b60zPAJXWfuJI7nvN7jTs/TiZIQWzWUugKHWX8/owVkMyuBNc/fxFEEZy
         6e/At637QWCXgsqRPeB5mqgRrgky0D2NmBpGkwrPFIBtbxDswwWdqjuaMMKDjgGmmpOl
         9sYGLhsS6RNrh9AATfxm42sKWOT/zrCS+jOhzwbimq+5huOUfnqEGWbqVrrVmDwiHfZV
         Ls31BvQoYTsx/+EDgo1gHY/TfCWAHbfQ1RMrEZYsJUthSaNJcd6tlcxntJxOMs2q5VvB
         JI1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxY5sdz0VMghyIW9iEbXqpavxWfrkVAqseA/KbXXU+Nj6nqpdm/62WK+sNEMxIFYopRwOXuWd/qrzKPUAdQfBko49zzfdr8MAegDdneAhrNzH39qWegFdVT9iZyDiFHcJO
X-Gm-Message-State: AOJu0YzVvqwFqFoGX76NWTSctJoKsQXQAzzMLnzQknOzcxWCSiMbKC5J
	MlNHKP+ydjgNMncx6TvIIK5YxxzHSMEnw8S6VHOZaQk4f8rLa5bd
X-Google-Smtp-Source: AGHT+IGHtyDo9LlPtIqtQ/za3S6BIyAiPCAACtj2WUFhfpBJR45zb3/a8Gn+o7VOLQpXdF+/oItXyA==
X-Received: by 2002:a17:90a:d718:b0:2b0:e3b3:78c2 with SMTP id y24-20020a17090ad71800b002b0e3b378c2mr7354350pju.48.1714990697467;
        Mon, 06 May 2024 03:18:17 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id co18-20020a17090afe9200b002af8f746f28sm9747820pjb.14.2024.05.06.03.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 03:18:17 -0700 (PDT)
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
	imbrenda@linux.ibm.com,
	weijiang.yang@intel.com
Cc: up2wing@gmail.com
Subject: [v5 0/3] KVM: irqchip: synchronize srcu only if needed
Date: Mon,  6 May 2024 18:17:48 +0800
Message-Id: <20240506101751.3145407-1-foxywang@tencent.com>
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

Note: I have no s390 machine so this patch has not been tested
thoroughly on s390 platform. Thanks to Christian for a quick test on
s390 and it still seems to work[1].

Changelog:
----------
v5:
  - rename new function to kvm_init_irq_routing as Sean suggested.
  - move invok of function of setting up empty before kvm_arch_init_vm.
  - Add necessary comment.

v4:
  - replace loop with memset when setup empty irq routing table.

v3:
  - squash setup empty routing function and use of that into one commit
  - drop the comment in s390 part

v2:
  - setup empty irq routing in kvm_create_vm
  - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
  - don't setup irq routing in s390 KVM_CREATE_IRQCHIP

v1:
  https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent.com/

1. https://lore.kernel.org/lkml/f898e36f-ba02-4c52-a3be-06caac13323e@linux.ibm.com/



Yi Wang (3):
  KVM: setup empty irq routing when create vm
  KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
  KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP

 arch/s390/kvm/kvm-s390.c |  9 +--------
 arch/x86/kvm/irq.h       |  1 -
 arch/x86/kvm/irq_comm.c  |  5 -----
 arch/x86/kvm/x86.c       |  3 ---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/irqchip.c       | 23 +++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  9 ++++++++-
 7 files changed, 34 insertions(+), 18 deletions(-)

-- 
2.39.3


