Return-Path: <kvm+bounces-16015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2758B2F58
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB46CB22165
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3CC824AF;
	Fri, 26 Apr 2024 04:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RV6jnpJ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528BBEACD;
	Fri, 26 Apr 2024 04:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104988; cv=none; b=gobzSDkvYJVmPmRHxjvQVpdXh6hBW9UFt1hmeQIU01FsDpLDWCcrk2jqVVQjp8+9dmhEV5sm1U8N+573dCQ3Pew15Yrc9Hl1qrT/DAmHL72+t+pwrjD77bfh2REVMM6ulJhw4QoSCh+XnQ+hjJ1MfJtKAjSZ2MOpmVTBBqmL7cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104988; c=relaxed/simple;
	bh=5BrCRh28BJUr6J5THiQ7LAX6u8wTo67DMh4LQ2zpXic=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d0NmpmhtLnTX2MR3V0yyF75Bq0q2aBPm7cpXlrhk6nK7kvJp/b7EuP8woiYs7qR+RzNanEOhUiEKCKS+dULTm5666zd+P/PACKaWy2Kod7e5HJsTKAWXAcEES9NmvdSu/b3V2cTc76o94gIZ0KTdAzfPjvYTZNYxEohrXHEQfTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RV6jnpJ8; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2a2d248a2e1so2096927a91.0;
        Thu, 25 Apr 2024 21:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714104986; x=1714709786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nPxarOGHNi8/phOxHc8/TqNc9y5wB5j9HDUxvMf3rik=;
        b=RV6jnpJ81/eQdWhhBcVB4VfagUzEXzxY5MYSgRaWJam4yPJoANyr5y/SCy6hnuOYjf
         TWqvEF3AByH2jI8YlP1uKpJcu4K3Zf78lHEpvMnAQS2On3Q1ix2OcXpJPucWVw2sgRAC
         +tC3IYsQ9Dg+VzOFSQHCgFHRvm/UNdW/yv4j8tKnF6nRfTvx5WA5zC8eZfZcQacmdeKo
         HCV2n/T2W0/ALwJGUYUSZrFpvW/UI0Zow8At1tHWCfeFeF39tq/Cgr6zHY2cVFj3LhLC
         itjfc/BWhOQ7YgxF6kMy9iO449K55lcfdIVK16pNsXxNuX45yYWeQOHOkVhGfDpbj02M
         xf7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714104986; x=1714709786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nPxarOGHNi8/phOxHc8/TqNc9y5wB5j9HDUxvMf3rik=;
        b=oco3k7ztdMGMrbuIF002Du9s/d2+jxwBzAn83pUeDRcrEacqcf5OHGSx5KA75OTifX
         uv/3NyebvQ815OiENOXlyWudFr3P6W1C/FW5NafpEd3yv8RoJeYSOToYhw5GmChxeSm1
         2/9jEKMfuk+agzrx8kmzH6sAWlXc6ZOOjCcKE2PSGv9Xp1VsTpY/fmvdTTq7qPCxBs2K
         w9saEujYn3TafUmQYooR1f5QIWpFXZ1IertmRIbTbVIyAPZGKzyQygrRcSz5O6utyGVl
         8VdeSqBoXYKVI1Vd4b5KN7nTivdYkIYKyd8H76LPgHaTQ6tFRChbk79FQ6oTdwmL2gfn
         V72w==
X-Forwarded-Encrypted: i=1; AJvYcCWMvWOtviYst0QjASznrwySqQA9J+t7JkjRdk7QJXAVz0APw/UCYtD0ag3GsDFgKCEv6SxlC2DsbfGWgySK4zqpjun1qVvjgSVNoEXzA73rH6Mb6810NX7/aXlbkBAA80Sm
X-Gm-Message-State: AOJu0YxWN6M6ZRSvIT8iN3XpMJoPOm8Hqm2DKgysG4q3yEBwBh6akCQK
	1MCTfk0Pxr+A6vpXgvTPvv2Y7jLK2sH7a5FEBP56O82fyDssZkbQ
X-Google-Smtp-Source: AGHT+IHeG8VpdY6v+rRn/4gP6YO95Bc/nPm6EgDbGfMIbAFq60wqlLb284jt5mRC/V16Pq/FkgWw9Q==
X-Received: by 2002:a17:90a:6fe2:b0:2a4:6ce7:37ad with SMTP id e89-20020a17090a6fe200b002a46ce737admr2778411pjk.5.1714104986454;
        Thu, 25 Apr 2024 21:16:26 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902ec8d00b001e9684b0e07sm9426780plg.173.2024.04.25.21.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:16:26 -0700 (PDT)
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
Subject: [v4 RESEND 0/3] KVM: irqchip: synchronize srcu only if needed
Date: Fri, 26 Apr 2024 12:15:56 +0800
Message-Id: <20240426041559.3717884-1-foxywang@tencent.com>
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


