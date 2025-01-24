Return-Path: <kvm+bounces-36573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F264A1BCA3
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9075B188E103
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:11:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E992253F3;
	Fri, 24 Jan 2025 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T4q3XRny"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4142253E9
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 19:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737745883; cv=none; b=tWrmN332sUHm0UkoBzDKf/HKUAXuwTPLC9a3jZt4MlBcUqPsAc87GN/b/5byMOxxGYwf6U57cSXh/dckPWN3fbYyuWVBFkr5yOKRSnM26lHQvAenV2MGDh24Lqg/zqtPAGo7mZxKGN1uGZ0SO/wjBP00zkUkw67j8FXYsUN8QUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737745883; c=relaxed/simple;
	bh=27nAJiwy8vNl5ENOjGy1QEtnVVB2ty2t0SrZitqHlPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eCNMqcn5pV1+6Pd8Q9mT4VKf5MoVU0yXJoIPM6wQjT/1KqtdIL1NYWXGzaNkAIIg2PIvrBLosQnTpifwmd8NCYoGSFxy3T1kwZbZYyKTEPLGGqDLWuJdc1JBmFMton524MdGGQF2HTa5vfbzIXy1l3rJRBOfjabwRhkPWuLDFpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T4q3XRny; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737745880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fFGYjJI+yyYMmuqTYYSVTNPCKJfp068RQBYfyuIBjkM=;
	b=T4q3XRnyObwnz4pGRA/BOCipd7SxNRB5SNqovyyhrA92beRYdkG+StXANPrshZPcagAnRK
	JoC027fAJJpxUhyf4o4s2wuBJudjzw3LwH13JD1bbho9dIeZ6GYCbCPvhD3DmDTnLqk2Jd
	gOBRHMeXM0E+YB1HevYsFOOkocjMnMY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-575-X02C7rrwMdKW3_1z0OzNHw-1; Fri,
 24 Jan 2025 14:11:15 -0500
X-MC-Unique: X02C7rrwMdKW3_1z0OzNHw-1
X-Mimecast-MFC-AGG-ID: X02C7rrwMdKW3_1z0OzNHw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AAC51801F26;
	Fri, 24 Jan 2025 19:11:12 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E27DC19560A7;
	Fri, 24 Jan 2025 19:11:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com
Subject: [PATCH 2/2] Documentation: explain issues with taking locks inside kvm_lock
Date: Fri, 24 Jan 2025 14:11:09 -0500
Message-ID: <20250124191109.205955-3-pbonzini@redhat.com>
In-Reply-To: <20250124191109.205955-1-pbonzini@redhat.com>
References: <20250124191109.205955-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

kvm_lock should be used sparingly, and it is easy to protect
vm_list walks with kvm_get_kvm and kvm_put_kvm.  Make it
a hard rule to drop kvm_lock before taking another mutex,
and document it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index c56d5f26c750..f94aad9b95ab 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -26,13 +26,6 @@ The acquisition orders for mutexes are as follows:
   are taken on the waiting side when modifying memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
-cpus_read_lock() vs kvm_lock:
-
-- Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
-  being the official ordering, as it is quite easy to unknowingly trigger
-  cpus_read_lock() while holding kvm_lock.  Use caution when walking vm_list,
-  e.g. avoid complex operations when possible.
-
 For SRCU:
 
 - ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
@@ -59,6 +52,23 @@ On x86:
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
 
+In particular no other mutex should be taken inside kvm_lock, and the
+amount of code that can be run inside kvm_lock should be limited; this
+is because ``cpus_read_lock()`` might be triggered unknowingly and cause
+a circular dependency.  For example, if you take ``kvm->slots_lock``
+inside ``kvm_lock``, the following can happen on x86:
+
+- ``kvm->srcu`` is synchronized with ``kvm->slots_lock`` taken
+- you wait for ``kvm->slots_lock`` with ``kvm_lock`` taken
+- ``__kvmclock_cpufreq_notifier()`` waits for ``kvm_lock`` and
+  is called within ``cpus_read_lock()``.
+- ``KVM_RUN`` can trigger static key updates, which call ``cpus_read_lock()``,
+  with ``kvm->srcu`` taken
+- therefore ``synchronize_srcu(&kvm->srcu)`` never completes.
+
+This rule applies to all architectures.
+
+
 2. Exception
 ------------
 
@@ -238,6 +248,9 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
+                - kvm_createvm_count
+                - kvm_active_vms
+:Comment:       Do not take any mutex inside.
 
 ``kvm_usage_lock``
 ^^^^^^^^^^^^^^^^^^
-- 
2.43.5


