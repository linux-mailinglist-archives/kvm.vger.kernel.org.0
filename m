Return-Path: <kvm+bounces-19664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E06BB908A3F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 12:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26A6F285519
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 10:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF7E1946B4;
	Fri, 14 Jun 2024 10:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U3TtmkNs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A4D193099
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 10:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718361577; cv=none; b=m6M4L9qHXWfMzqEwu5ObT5j8o/iDDycpehVGV0/GetPSoNZEUcXNYTItfE4MijmK6CUmnFHwoftfNUQvFib6uQ5DRwaHilrJdY3eoHF4nchUu+jgz73iNtSQ8kVsC0/+/xLx6MKiPPcZl5rebGzTevbWp/yHxGSeuy7xgtQob+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718361577; c=relaxed/simple;
	bh=/GCCN8jL7Y/IEfV9+i0Jq0ctsa3bAQ7MRBdMdvfCly4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u9CRXSUBcDSPAXO5V6AasyX0IJO5Mxyid+dmRWaY9b1z6HW6VIOHpg2/yvcMMTUs4ITNRFYbZc+lwN9gjkCmcr1aZp33XuJEYH0d3cqGhVgL0EcCMP1CA0E72QNIzYtlud8R/hKBKfnEEWDcq7tAUNTSPViJ6wYFgS2+fjCaS14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U3TtmkNs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718361574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bX0Eh7iMeDGS2UEYZBvNcA+ah/v80YAMcEfPqR+uczg=;
	b=U3TtmkNs9x+JP2x9ijQ+483ewDb5kjAQ3W/W3cFPi6Njy1ed+SE3hWBB8pZrXJ5P0wbXe+
	iChiAlFoXUwXl+XmGIhGE9ldrCHLzfpVOjASWASW3SkI+PbU0xQ7yASlMjisqXoo1wU9gv
	MWAFKj1hBi038dn3OW2KcO1cVhYQrUk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-U-QQro7hNG-XAffrrp_98Q-1; Fri,
 14 Jun 2024 06:39:33 -0400
X-MC-Unique: U-QQro7hNG-XAffrrp_98Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13A31195608F;
	Fri, 14 Jun 2024 10:39:32 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.39.193.248])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 372781956050;
	Fri, 14 Jun 2024 10:39:25 +0000 (UTC)
From: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	kvm@vger.kernel.org,
	Markus Armbruster <armbru@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for SEV(-ES) guests
Date: Fri, 14 Jun 2024 11:39:24 +0100
Message-ID: <20240614103924.1420121-1-berrange@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
only have been released for a bit over a month when QEMU 9.1 is
released.

The SEV(-ES) support in QEMU has been present since 2.12 dating back
to 2018. With this in mind, the overwhealming majority of users of
SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
forseeable future.

IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
machine types will be broken out of the box for most SEV(-ES) users.
Even if the kernel is new enough, it also affects the guest measurement,
which means that their existing tools for validating measurements will
also be broken by the new default.

This is not a sensible default choice at this point in time. Revert to
the historical behaviour which is compatible with what most users are
currently running.

This can be re-evaluated a few years down the line, though it is more
likely that all attention will be on SEV-SNP by this time. Distro
vendors may still choose to change this default downstream to align
with their new major releases where they can guarantee the kernel
will always provide the required functionality.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 hw/i386/pc.c      |  1 -
 qapi/qom.json     | 12 ++++++------
 target/i386/sev.c |  7 +++++++
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 0469af00a7..b65843c559 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -82,7 +82,6 @@
 GlobalProperty pc_compat_9_0[] = {
     { TYPE_X86_CPU, "x-l1-cache-per-thread", "false" },
     { TYPE_X86_CPU, "guest-phys-bits", "0" },
-    { "sev-guest", "legacy-vm-type", "true" },
     { TYPE_X86_CPU, "legacy-multi-node", "on" },
 };
 const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
diff --git a/qapi/qom.json b/qapi/qom.json
index 8bd299265e..714ebeec8b 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -912,12 +912,12 @@
 # @handle: SEV firmware handle (default: 0)
 #
 # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
-#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
-#                  state when initializing the VMSA structures, which will
-#                  result in a different guest measurement. Set this to
-#                  maintain compatibility with older QEMU or kernel versions
-#                  that rely on legacy KVM_SEV_INIT behavior.
-#                  (default: false) (since 9.1)
+#                  The newer KVM_SEV_INIT2 interface, from Linux >= 6.10, syncs
+#                  additional vCPU state when initializing the VMSA structures,
+#                  which will result in a different guest measurement. Toggle
+#                  this to control compatibility with older QEMU or kernel
+#                  versions that rely on legacy KVM_SEV_INIT behavior.
+#                  (default: true) (since 9.1)
 #
 # Since: 2.12
 ##
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 004c667ac1..16029282b7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -2086,6 +2086,13 @@ sev_guest_instance_init(Object *obj)
     object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
                                    OBJ_PROP_FLAG_READWRITE);
     object_apply_compat_props(obj);
+
+    /*
+     * KVM_SEV_INIT2 was only introduced in Linux 6.10. Avoid
+     * breaking existing users of SEV, since the overwhealming
+     * majority won't have a new enough kernel for a long time
+     */
+    sev_guest->legacy_vm_type = true;
 }
 
 /* guest info specific sev/sev-es */
-- 
2.45.1


