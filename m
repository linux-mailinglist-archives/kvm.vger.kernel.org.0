Return-Path: <kvm+bounces-50883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24655AEA7C5
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F03C67AD600
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4902F3649;
	Thu, 26 Jun 2025 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uA30aR6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9312F2341
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968358; cv=none; b=b6vmejNtJ64L0ZLB//7Hkwz2/XpwHB529yAPZANeCTUI0fsF7Gh8afGhM0/tme7j5XUKeGRWv5BCuo1txBSuUBKTywRV9o3lqBKDNbG5g8yZrKzRQvI2z0MNaLg7lL/EVqrfRjv0cTLl0L4upUJw7zKiWmpA+xYQAHea9rbwnh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968358; c=relaxed/simple;
	bh=bO4sw7/hINJdmJB2o7i6RovRyFWviPuCwq5wxaiI8Bs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X2z6e/wX/Xs1KnTgbx9eMdxHg4qWry01TwAilUq6wmOeWhqTQ+E8USQCwjjQ3kL1C1fsZLAXDx6TOHehtWS66sb6hkyqawXMjIRsWYteFsSwLUPZqhZ4FW5zdlF4XhX15ZMpsZIEGEVmlmxuFr5ZvGrZ0HG/8YZRYtqyAD/JzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uA30aR6o; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-2eb585690dcso1062057fac.2
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968355; x=1751573155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zPJCCS28P/ht0GkmQnG+3GK0DAvT59T6hS3LwMCctEw=;
        b=uA30aR6oR2954HYTfYQXRlZ9wSLECWkJcxPAMzuDhZX9Y7SnOvdyn2Qwx23mcMrtc7
         va0uaFC4HOee3koJunfQpLs0vibX8CFz2mZR/lru52ZcQXMDflDaw3ga2G73FCTzUB/F
         eKyEhO/Sc+tomQMz1OvSrpQeWBxYBEzJgs71gxIAHTF8FwbOnFfD4x8UvKu2JJtEEjcc
         06jQx/mdhl/lg6LycCNrMJi+gy5fw7BF2MWtEyY0NGyWR5tUXEoXI+04UxzJsWnrMM+E
         +P5lMMu5VUIMfLHzqvLE2bxxi72vIkngI2Nz6C3/3fOyMtBXqGsL9gRTUKgxUXsQtuxQ
         g4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968355; x=1751573155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zPJCCS28P/ht0GkmQnG+3GK0DAvT59T6hS3LwMCctEw=;
        b=BLSjJcGi95wTgSUE05g5f5yS7QTSggPkc74mZEab8GJcBRnU6Zzk+HLjubV6P+MDTw
         vfrjmeoPUianNki9JFWNzw5woyR0ElldjIpVvfrFp7iUrl4xX5yVxbatPAy4uPCO1c3Z
         fgGm6aNMafF4Kdz5HOB6aydfUqBgL2PSy0RRGQiyqVvnPz+5kJIIMefzG0gAE5T49IRG
         8ZDVbqrNHIGLiNi4fhyujKQf20w6whpRbj/7xGb6DZ7KvlP2gq1wBqgbd0ZXJ+0axXyV
         bJCKZonWod77IxFDshyuqY+z70B2mdeGVpXTtJ6E3C7FrKRDUuGSvObP7gdXqtOMP+Uk
         P+Tg==
X-Gm-Message-State: AOJu0Yy+bhugeuIRoRKkmaZQwLdmgRsaitbRvMY5iVdvLX84AcYIiIoG
	z31HTr5q3od3sW0Zmm0/GcF43E6RQm6WMbzgTikuzQzuv+l2PAng2ZEdCQ3OqsUjOvLHGD3MGEu
	nK82esPG5OaViIzourP2Xg8QcJBVwe84/5BaPmOmQOQS3Or6OGIsOZs49GufKC9i8nhzn2XpbzE
	41fRxUL/cKP56CbSAsh6Y3pIiSw7fAKeWcHpQvQlHEyO9Pr0rHt6F0ckOVIPk=
X-Google-Smtp-Source: AGHT+IEAValjLvIQUTTrl0WGiv7qDA/VK+W0m1ZQUDRoDH/VSaq0CR37ZF/2z6Fxf5GRvTFbBupf/JJhqDdR5wa1WQ==
X-Received: from oabxc6.prod.google.com ([2002:a05:6870:ce06:b0:2e8:ed52:15c9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:7050:10b0:2ef:eddd:690d with SMTP id 586e51a60fabf-2efeddd6bf1mr119143fac.24.1750968354720;
 Thu, 26 Jun 2025 13:05:54 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:39 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-4-coltonlewis@google.com>
Subject: [PATCH v3 03/22] KVM: arm64: Define PMI{CNTR,FILTR}_EL0 as undef_access
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because KVM isn't fully prepared to support these yet even though the
host PMUv3 driver does, define them as undef_access for now.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76c2f0da821f..99fdbe174202 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3092,6 +3092,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
+	{ SYS_DESC(SYS_PMICNTR_EL0), undef_access },
+	{ SYS_DESC(SYS_PMICFILTR_EL0), undef_access },
+
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
-- 
2.50.0.727.gbf7dc18ff4-goog


