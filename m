Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568401F5ACE
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 19:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgFJRzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 13:55:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48798 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726095AbgFJRzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 13:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591811740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fT7MJxxe/N/GC6AUG3wTzK87t8/hohYB8InpgjdJuSE=;
        b=Y0D40yWXtiHwnfRMbdQWAiPQmnf0jxowC9I8FgwVi5hG8p0JUuZxrG44UCY4A/VJTH0cLG
        Q8YG19DutJDfiV44eDV1Mf8pSf5PWUMQCRmFK25M4VRqEZGMeZ5y2GZzRVlHWoihMb8yXD
        0IMbcMhoulhGGcq0/ZMlcOKjl6UxNfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-4-i27Ty0MxuQ6YUuacqyWQ-1; Wed, 10 Jun 2020 13:55:39 -0400
X-MC-Unique: 4-i27Ty0MxuQ6YUuacqyWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89904461;
        Wed, 10 Jun 2020 17:55:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 415317BA14;
        Wed, 10 Jun 2020 17:55:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: async_pf: Cleanup kvm_setup_async_pf()
Date:   Wed, 10 Jun 2020 19:55:31 +0200
Message-Id: <20200610175532.779793-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

schedule_work() returns 'false' only when the work is already on the queue
and this can't happen as kvm_setup_async_pf() always allocates a new one.
Also, to avoid potential race, it makes sense to to schedule_work() at the
very end after we've added it to the queue.

While on it, do some minor cleanup. gfn_to_pfn_async() mentioned in a
comment does not currently exist and, moreover, we can check
kvm_is_error_hva() at the very beginning, before we try to allocate work so
'retry_sync' label can go away completely.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/async_pf.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index f1e07fae84e9..ba080088da76 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -164,7 +164,9 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (vcpu->async_pf.queued >= ASYNC_PF_PER_VCPU)
 		return 0;
 
-	/* setup delayed work */
+	/* Arch specific code should not do async PF in this case */
+	if (unlikely(kvm_is_error_hva(hva)))
+		return 0;
 
 	/*
 	 * do alloc nowait since if we are going to sleep anyway we
@@ -183,24 +185,15 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	mmget(work->mm);
 	kvm_get_kvm(work->vcpu->kvm);
 
-	/* this can't really happen otherwise gfn_to_pfn_async
-	   would succeed */
-	if (unlikely(kvm_is_error_hva(work->addr)))
-		goto retry_sync;
-
 	INIT_WORK(&work->work, async_pf_execute);
-	if (!schedule_work(&work->work))
-		goto retry_sync;
 
 	list_add_tail(&work->queue, &vcpu->async_pf.queue);
 	vcpu->async_pf.queued++;
 	kvm_arch_async_page_not_present(vcpu, work);
+
+	schedule_work(&work->work);
+
 	return 1;
-retry_sync:
-	kvm_put_kvm(work->vcpu->kvm);
-	mmput(work->mm);
-	kmem_cache_free(async_pf_cache, work);
-	return 0;
 }
 
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
-- 
2.25.4

