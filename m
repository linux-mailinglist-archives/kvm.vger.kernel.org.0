Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E0418D61E
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCTRmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:42:50 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27504 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgCTRmu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 13:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584726169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ef36637kDnXkE6FllS0yNPka1X9FChEYgiakf6+7Z7c=;
        b=EXteLxpIPtvpvuZEpCDVmeV2uOacj9OqidEjQBwSo0KCmWWQ8kt2vqFUnpSZGwDt0yEMd3
        IRCpOHiMq2I+M9RalrsJjo1bcIAnPTyQ9bP3KfBYw0td4tJtvxq6TSJhqqMLl4iElLatZD
        5fLn436FeLEV6dUcK5301FNIwD8T+uE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-JCGm1F3lNn-DLjAE_M3WPg-1; Fri, 20 Mar 2020 13:42:47 -0400
X-MC-Unique: JCGm1F3lNn-DLjAE_M3WPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97C389B823;
        Fri, 20 Mar 2020 17:42:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3932D19757;
        Fri, 20 Mar 2020 17:42:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: SVM: document KVM_MEM_ENCRYPT_OP, let userspace detect if SEV is available
Date:   Fri, 20 Mar 2020 13:42:45 -0400
Message-Id: <20200320174245.5220-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace has no way to query if SEV has been disabled with the
sev module parameter of kvm-amd.ko.  Actually it has one, but it
is a hack: do ioctl(KVM_MEM_ENCRYPT_OP, NULL) and check if it
returns EFAULT.  Make it a little nicer by returning zero for
SEV enabled and NULL argument, and while at it document the
ioctl arguments.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../virt/kvm/amd-memory-encryption.rst        | 25 +++++++++++++++++++
 arch/x86/kvm/svm.c                            |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index d18c97b4e140..c3129b9ba5cb 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -53,6 +53,29 @@ key management interface to perform common hypervisor activities such as
 encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
 information, see the SEV Key Management spec [api-spec]_
 
+The main ioctl to access SEV is KVM_MEM_ENCRYPT_OP.  If the argument
+to KVM_MEM_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
+and ``ENOTTY` if it is disabled (on some older versions of Linux,
+the ioctl runs normally even with a NULL argument, and therefore will
+likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEM_ENCRYPT_OP
+must be a struct kvm_sev_cmd::
+
+       struct kvm_sev_cmd {
+               __u32 id;
+               __u64 data;
+               __u32 error;
+               __u32 sev_fd;
+       };
+
+
+The ``id`` field contains the subcommand, and the ``data`` field points to
+another struct containing arguments specific to command.  The ``sev_fd``
+should point to a file descriptor that is opened on the ``/dev/sev``
+device, if needed (see individual commands).
+
+On output, ``error`` is zero on success, or an error code.  Error codes
+are defined in ``<linux/psp-dev.h>`.
+
 KVM implements the following commands to support common lifecycle events of SEV
 guests, such as launching, running, snapshotting, migrating and decommissioning.
 
@@ -90,6 +113,8 @@ Returns: 0 on success, -negative on error
 
 On success, the 'handle' field contains a new handle and on error, a negative value.
 
+KVM_SEV_LAUNCH_START requires the ``sev_fd`` field to be valid.
+
 For more details, see SEV spec Section 6.2.
 
 3. KVM_SEV_LAUNCH_UPDATE_DATA
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 91000501756e..f0aa9ff9666f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7158,6 +7158,9 @@ static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	if (!svm_sev_enabled())
 		return -ENOTTY;
 
+	if (!argp)
+		return 0;
+
 	if (copy_from_user(&sev_cmd, argp, sizeof(struct kvm_sev_cmd)))
 		return -EFAULT;
 
-- 
2.18.2

