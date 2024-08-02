Return-Path: <kvm+bounces-23162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8ECE9465EE
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D6C1C217F8
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9942613C909;
	Fri,  2 Aug 2024 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D+eBdBYv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A84413A878
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638465; cv=none; b=dxVUz62yzQ0JspiN0YiHa4XYy9bctR1Njz0PxXqXgA8chLS5UnvO8rczoJbQRFtNvuQcTm5ivwUwc8/3GsQOUQd6vxoexBEXap+Lw/lMYGrVjBBK/x3NNYleNspe8hPKfwwMuZZXzJfs52o4zsisun9ts++teQHannMPOxWdMpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638465; c=relaxed/simple;
	bh=v3acPLwhV+gpk7Lv0W7XpGHBnCDV1cxxTMNqqwFABeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKlPEhXOx8OurN2he/2Qpmpk/DZWfMocfizr7Kdw5XcWYrQHboUvXJsRdw21d2FLDEHR4StKiSv8JQyUR669h7n97F6Ub7JArFjLRDF8CDlhCj/BB8bOtSxbUEarb4Bz8HsQcvUlRKDCBKrvQLHqQA71z02l5G7K3auFZzrHXm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D+eBdBYv; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66a2aee82a0so175886337b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 15:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638463; x=1723243263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WUTD+PpdYxApWk0wW3A8Rkz7siPlFF3F1FyTT2F4Hns=;
        b=D+eBdBYvfe9D1HyqfwH0yalrqb0f0SRsI2PfzgbBvLptpTI/mW+d/QwDuoQRZh6K+i
         6+sETDRneB8rEyHZgRfgspCHbX5/O7tx+nkFVJmDIoyuGQZiR/ZRreDvYwKPsrQJnuaj
         A3UJ4gGVrI7A8J9mETCWNEKXi+dxwpKxcdcn54MK0BSm2lWmqCVElXzkCIMx0oIG+ogp
         yoGXScaOZ9/zcbsz22JRdtzmxIj04tdFDZsOmU0yX+bycrB6/ljqmYpev/ys3oMUI5bO
         rebdd/kE96CZSiU4SQSP9u66rkx9eOHhTYGXc14Jr82c69Uguo9mGtp1hQYx6wdhqoQX
         1eMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638463; x=1723243263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUTD+PpdYxApWk0wW3A8Rkz7siPlFF3F1FyTT2F4Hns=;
        b=Puzg+6qh8OfcUdzTpwL0yrf6KsekgcSvk0fsVIQY0HHHkZvTRpwEeKznfEMNvWCyA8
         PmnGRaQWVtpvQTUbhIO+qH555a9GvvrAw/94Th3MITpei9+jgdIOhu3CgLT/5H+9YIe7
         43xWHmwTxq2KdxPOgAHqYS3T+0AN6AhV7YRyvHtnEnqdjVrkqX8+VZr8wgL8EEcBi7S3
         hPvJZklOH2UgJE6ohafR0ga/2pq5BPwSW9C9B8FsiLQS8B05zJnaYymSc1Pg/IufHC27
         puD9iGkFmh96bg6XSBq5eSwxjNsTneM/j7ETT+4nHQo8ruAecTVD62id6NJ2Mybp6bWr
         cwNQ==
X-Gm-Message-State: AOJu0Yzw29ZXu6ghhLqv3RlSvT6/rRs1J9f+l4Lar64hfQtjsM/UIBIm
	/HNVAaioV9kR1raAYogFTjeWGffYi8tg0fLGspX1BUFQ2bBRN4KHdaBc9bL/k2V3ZbZocqvLlEk
	uGwuMDkwLQw==
X-Google-Smtp-Source: AGHT+IFKNhjc3bbOHyYY5UfiMGDF2uVqzD6G4qc/2EsStmrwR8+ngkVWR6nBrvU9pNgNKVw3FEM43mqMAO/ycg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:dd1:b0:665:a4a4:57c1 with SMTP
 id 00721157ae682-6895f02c633mr602787b3.2.1722638462564; Fri, 02 Aug 2024
 15:41:02 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:30 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-3-amoorthy@google.com>
Subject: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Although arm64 doesn't currently use memory fault exits anywhere,
it's still valid to advertise the capability: and a subsequent commit
will add KVM_EXIT_MEMORY_FAULTs to the stage-2 fault handler

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..49c504b12688 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8128,7 +8128,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN will fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7ca776b51ec..4121b5a43b9c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
-- 
2.46.0.rc2.264.g509ed76dc8-goog


