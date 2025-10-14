Return-Path: <kvm+bounces-60018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D54BDA6EB
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 17:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 91202504158
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 15:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8040F30274D;
	Tue, 14 Oct 2025 15:28:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B862FFF87;
	Tue, 14 Oct 2025 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760455690; cv=none; b=kU668W+KJOecpy9vLz5YlxlfvnkDDAi328pkvd7jd/xnlLPZAhENGplhkfeW06kzpwxKenWvjQqilAz1mavCJU6gvDQ1hUht941yS0okN5m3uMU/yNetf6VOSISSgMfv4/cdD//CgiJMKb5Wzoqku5uc2LV7tsfyD1FgM+mdsM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760455690; c=relaxed/simple;
	bh=2gwkqKgmkP93tErYouCSL+EKMNFEFMnu3v8rIzZDWWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=soOinV0oUrKGcDZUP23uGDaZAVsh3LPqR6dLLa8jL6PrNVQRDmnbt1F0gKZMM/3nIoLhPw13bwBsG3G9KORntgudcftU/AxFxqdzeZsGKX/Z610eiT/9xLQjvLlOb0b7Im+dDi8Tt+vN883LcaH2KnraXaJ6T9GZ3ueMQYKGfbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B4A91A9A;
	Tue, 14 Oct 2025 08:27:58 -0700 (PDT)
Received: from JFWG9VK6KM.emea.arm.com (JFWG9VK6KM.cambridge.arm.com [10.1.27.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4303F66E;
	Tue, 14 Oct 2025 08:28:05 -0700 (PDT)
From: Leonardo Bras <leo.bras@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] doc/kvm/api: Fix VM exit code for full dirty ring
Date: Tue, 14 Oct 2025 16:28:02 +0100
Message-ID: <20251014152802.13563-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While reading the documentation, I saw a exit code I could not grep for, to
figure out it has a slightly different name.

Fix that name in documentation so it points to the right exit code.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6ae24c5ca559..3382adefc772 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8503,21 +8503,21 @@ It's not necessary for userspace to harvest the all dirty GFNs at once.
 However it must collect the dirty GFNs in sequence, i.e., the userspace
 program cannot skip one dirty GFN to collect the one next to it.
 
 After processing one or more entries in the ring buffer, userspace
 calls the VM ioctl KVM_RESET_DIRTY_RINGS to notify the kernel about
 it, so that the kernel will reprotect those collected GFNs.
 Therefore, the ioctl must be called *before* reading the content of
 the dirty pages.
 
 The dirty ring can get full.  When it happens, the KVM_RUN of the
-vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+vcpu will return with exit reason KVM_EXIT_DIRTY_RING_FULL.
 
 The dirty ring interface has a major difference comparing to the
 KVM_GET_DIRTY_LOG interface in that, when reading the dirty ring from
 userspace, it's still possible that the kernel has not yet flushed the
 processor's dirty page buffers into the kernel buffer (with dirty bitmaps, the
 flushing is done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
 needs to kick the vcpu out of KVM_RUN using a signal.  The resulting
 vmexit ensures that all dirty GFNs are flushed to the dirty rings.
 
 NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
-- 
2.50.1 (Apple Git-155)


