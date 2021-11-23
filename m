Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0C5459957
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKWAyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:54:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229779AbhKWAxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m+NOR1Qa7DvdNATRQaylnxWMsvpMhuNDm+7DW2JM0YE=;
        b=S/AD1arUwXtQBsWtCs3v8D4ahs80XmYYqW+gflZboc9W0yCVEyognyXUt7fjetSfqeSv/W
        BUTEVzNBQt9qWkm8sa1QbS8m5FmgBmnr5JoOgWbcM1usIJzrIUF3h1wMmNMXmtoRPvKPin
        8qqtqk9qE0oMULwulSewc35RFScRt4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-5wJ-zTINPOS44e4GkPIdyQ-1; Mon, 22 Nov 2021 19:50:37 -0500
X-MC-Unique: 5wJ-zTINPOS44e4GkPIdyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A064D1023F4D;
        Tue, 23 Nov 2021 00:50:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51AA85C1C5;
        Tue, 23 Nov 2021 00:50:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH 00/12] Fixes for KVM_CAP_VM_MOVE/COPY_ENC_CONTEXT_FROM
Date:   Mon, 22 Nov 2021 19:50:24 -0500
Message-Id: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This turned out to be a bit of a trainwreck, mostly due to
the patches being merged hastily at the end of the merge window.
For this reason, there are a few bugs for intra-host migration
as well.

Compared to the v1 I posted last week, there's many more bugfixes,
and the code I promised to avoid dangling ASIDs when a VM has
mirrors and is migrated.

Paolo

Paolo Bonzini (12):
  selftests: fix check for circular KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
  selftests: sev_migrate_tests: free all VMs
  KVM: SEV: expose KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM capability
  KVM: SEV: do not use list_replace_init on an empty list
  KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
  KVM: SEV: initialize regions_list of a mirror VM
  KVM: SEV: move mirror status to destination of
    KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
  selftests: sev_migrate_tests: add tests for
    KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
  KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs locked
  KVM: SEV: Prohibit migration of a VM that has mirrors
  KVM: SEV: do not take kvm->lock when destroying
  KVM: SEV: accept signals in sev_lock_two_vms

 arch/x86/kvm/svm/sev.c                        | 161 +++++++++--------
 arch/x86/kvm/svm/svm.h                        |   1 +
 arch/x86/kvm/x86.c                            |   1 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 165 ++++++++++++++++--
 4 files changed, 243 insertions(+), 85 deletions(-)

-- 
2.27.0

