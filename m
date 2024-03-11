Return-Path: <kvm+bounces-11531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F885877F02
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4B961F21B4C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FBF3B78E;
	Mon, 11 Mar 2024 11:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTz+UNg+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1C724A11;
	Mon, 11 Mar 2024 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710156743; cv=none; b=pZOicNUR2gr2EeaRzkyvWJqmmDsNvJAxB5YoCHdcWTh97MPnsYA4yjRvYNeAjI+nLfpXk5NLz8kGPLBv2YEav9JAst1bCj2EF4n0c5fydSNt07WJUr466hHARPLnH/RFswJGq3M2yh/GmCe5hlANVWINwT0s3bSsw8vOcMR188Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710156743; c=relaxed/simple;
	bh=5BrCRh28BJUr6J5THiQ7LAX6u8wTo67DMh4LQ2zpXic=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=na0z7bOEvceijGyHdVhUbTh+4SZpFAkynb1dp2lNemXv0o5eWJ7J05r+octSEfrRADon+YA6ZaC30eRLNp7M+KYwDg2es/yiQteVqIN5l21ZE5YCb9YkgTOajM3REaR5s6A+tEhc+iHf469F91inmfW9PExY6X9eEll1CVavEIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTz+UNg+; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dd6412da28so20977225ad.3;
        Mon, 11 Mar 2024 04:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710156742; x=1710761542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nPxarOGHNi8/phOxHc8/TqNc9y5wB5j9HDUxvMf3rik=;
        b=ZTz+UNg+rgHYYsk0EoEYC3vGz5EQGhDTLHlFRgro72o+DxjdEYggy6dU5V519pA3MU
         JFk92INV3q5cC8V6M0KJRQLpD3AiVW6ZtBLDwM4ZxbFaiVFv4Dx1pBBYNvPqxVpUh6ob
         3mJoUKy0bU4RCW00sz+jw6e8F6p7CEMJtn1LjNCLqBWyHVQvS66f+2TB+Nezrl53j7SX
         uo3UOC04ohWyPitzaE0QQtpljOKAw5AlqpCMHcHC8dotpOQiKeJgc1BlsOMVSG5N6tR4
         SCjSSUgj6yadR0dXPCAvxLT0nIuMQFlFHG2eYA2ZAAJ5f5RzNkVZe6uj8CLKsd2qTe3m
         ta8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710156742; x=1710761542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nPxarOGHNi8/phOxHc8/TqNc9y5wB5j9HDUxvMf3rik=;
        b=i90eEl5kiB7+m0X17y9tFsRJynCLfm3f/vhcS9F/FLSdzprDfceHK0EcKO8KrM0/h2
         uYcf899EqmSC31JmLXnaT6kFIHtr6iXxUOyrUxe8J2+bCvke0qX9EOMKZWL8ia2G+exH
         d6sEtdkk6gNe8jEvRnW8EN/p0v0BNJLo0Cs5L887OQv0N6WKlF928VH/ksSVMQb36zxO
         YLsvcUvdrIEybn3HuFwCnPnjSEah90LQsa2C31rVoauIxs+1KHl1IXUDB1GPeX/HGzHa
         gHtV2aNT9HcbSPjegHbuD481aC4DiTQMJdCYww5V0ZC/5BQ7c02zXZyFSqC10Q5/qf8k
         CY2g==
X-Forwarded-Encrypted: i=1; AJvYcCUD3f+VPsqrn6HIi8+Nq6dOQmXVEIVpX+hWuFh3WKsdv2RAWyyQgJc2aLHhh6gMfcv9LByTlg9Adq3oi5hh2fZmrNNKFJIi6TvykDAEj6RwLTgP0xeyIgGTOOlDTK0j4sIh
X-Gm-Message-State: AOJu0YxkfWW/wzztqPwuHXQQXtlpqbz1gAS4ggxDzHqVyHQlhKg/B3Io
	jWJtWFhWFVx83MDT5KrarxE9Y6XUGWVegyBbaENPb5e85AqSknlU
X-Google-Smtp-Source: AGHT+IHgLrWm/4T2DKwMkMFqBOs5Q6muAJVKzFIDgcl2mISGH6Gl/iuqJ3XHv2cG1Bufi2DyDKYykw==
X-Received: by 2002:a17:903:2790:b0:1dd:a3d4:9545 with SMTP id jw16-20020a170903279000b001dda3d49545mr83212plb.54.1710156741730;
        Mon, 11 Mar 2024 04:32:21 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e5c300b001dda32430b3sm1459042plf.89.2024.03.11.04.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:32:21 -0700 (PDT)
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
Subject: [v4 0/3] KVM: irqchip: synchronize srcu only if needed
Date: Mon, 11 Mar 2024 19:31:43 +0800
Message-Id: <20240311113146.997631-1-foxywang@tencent.com>
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
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 7 files changed, 25 insertions(+), 17 deletions(-)

-- 
2.39.3


