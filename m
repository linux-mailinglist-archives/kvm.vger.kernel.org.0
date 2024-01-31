Return-Path: <kvm+bounces-7601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B54D844A23
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 22:37:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC205287BC5
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 21:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B62939AFE;
	Wed, 31 Jan 2024 21:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPcGtQY7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2B39846
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706737007; cv=none; b=Dk/+obRLmAqG7olTg7bFV7U2Pi9j6MaL7J6yGgBcnefm7fGoLdi8u45KXFdEm9LAdtnMhVhdbexKJvmfhHG1EzpMfkYhOI6TuDlhUiZniNeX4W+8LDbNJJkSdfgUB7v/oHG4ib2yrnqcLUSBMAJrVU5jR6aCzVF2QU98AnYImq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706737007; c=relaxed/simple;
	bh=YOr5p7OqhyyhW5TZ0msg6DHQwIpWUrFc8I5/ZuxT8lM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HKHbCReQScn9gtbSGiHx1WwWYaaLfVDSU4VMlZvaeThufMsxDXu+I8DiVPKxRaQsrxywkZGf+1lTWFILDIKCYWq/TaK14ox2LuioKgkoaIja13XC70H7bwYFfD1qQL6DpH9+Im5rfrmJ+WgjzWqo4IX/r7oY00dgdGrG6G7+2w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPcGtQY7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706737004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2IICm0xc8cHxl8ntw7Ux3EV0imOL/Y1QKA8M5sz6CME=;
	b=iPcGtQY737yzR64VzDnlJGkqMU/7EwqkMlWovUFyHIGj8EPzQJVRmCLJTwph5LVko09jiF
	7SZgxrz0rLnSDlUp5smobMdsEvcbKL6eGA3nYJuM3AdYnCh14vZhOwXbHcTpvlInMA0F1d
	Y/q3Aujk9RjKlUT+zJt6/c7mcCW2xGg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-7StyiotBP7OD_JLc19Iwxg-1; Wed, 31 Jan 2024 16:36:41 -0500
X-MC-Unique: 7StyiotBP7OD_JLc19Iwxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC83A88B7A5;
	Wed, 31 Jan 2024 21:36:40 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5A9E1121312;
	Wed, 31 Jan 2024 21:36:40 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] kvm: move "select IRQ_BYPASS_MANAGER" to common code
Date: Wed, 31 Jan 2024 16:36:40 -0500
Message-Id: <20240131213640.409682-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

CONFIG_IRQ_BYPASS_MANAGER is a dependency of the common code included by
CONFIG_HAVE_KVM_IRQ_BYPASS.  There is no advantage in adding the corresponding
"select" directive to each architecture.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/Kconfig   | 1 -
 arch/powerpc/kvm/Kconfig | 1 -
 arch/x86/kvm/Kconfig     | 1 -
 virt/kvm/Kconfig         | 1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 6c3c8ca73e7f..46bdbd852857 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,7 +34,6 @@ menuconfig KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
-	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
 	select SCHED_INFO
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 074263429faf..dbfdc126bf14 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -22,7 +22,6 @@ config KVM
 	select KVM_COMMON
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select KVM_VFIO
-	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 
 config KVM_BOOK3S_HANDLER
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 87e3da7b0439..e7cbf011d766 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,7 +29,6 @@ config KVM
 	select HAVE_KVM_PFNCACHE
 	select HAVE_KVM_DIRTY_RING_TSO
 	select HAVE_KVM_DIRTY_RING_ACQ_REL
-	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
 	select KVM_ASYNC_PF
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 184dab4ee871..6408bc5dacd1 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -73,6 +73,7 @@ config KVM_COMPAT
 
 config HAVE_KVM_IRQ_BYPASS
        bool
+       select IRQ_BYPASS_MANAGER
 
 config HAVE_KVM_VCPU_ASYNC_IOCTL
        bool
-- 
2.39.0


