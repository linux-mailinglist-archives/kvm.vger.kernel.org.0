Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C698D42FA57
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 19:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhJORhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 13:37:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33441 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237952AbhJORhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 13:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634319293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=euq4VRje+bc25YaKTdy9SOHAdj/WCUtkFXn5dQ91v3U=;
        b=bW5LMDavjvT2KyTAyBVDpRyyjeO5Z3MvLeoW/hrtqP9OSB4mYd7sykKqUON/tiEM5CJjgZ
        UMM/U0I7OgjZvanRxbsZddiyCQC/u8FWSLAc+dpJQBpwarcQFIvjuS8+c8SF8I4Sn1Qjqa
        j4gQjGVph7oNKi/0tHVkU45s10LQBLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-wcyL3WIvPWqzIe-gKNhHBQ-1; Fri, 15 Oct 2021 13:34:49 -0400
X-MC-Unique: wcyL3WIvPWqzIe-gKNhHBQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABF1418414A1;
        Fri, 15 Oct 2021 17:34:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55A725DA61;
        Fri, 15 Oct 2021 17:34:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
Subject: [PATCH] KVM: SEV-ES: Set guest_state_protected after VMSA update
Date:   Fri, 15 Oct 2021 13:34:48 -0400
Message-Id: <20211015173448.144114-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

The refactoring in commit bb18a6777465 ("KVM: SEV: Acquire
vcpu mutex when updating VMSA") left behind the assignment to
svm->vcpu.arch.guest_state_protected; add it back.

Signed-off-by: Peter Gonda <pgonda@google.com>
[Delta between v2 and v3 of Peter's patch, which had already been
 committed; the commit message is my own. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e672493b5d8d..0d21d59936e5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -618,7 +618,12 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	vmsa.handle = to_kvm_svm(kvm)->sev_info.handle;
 	vmsa.address = __sme_pa(svm->vmsa);
 	vmsa.len = PAGE_SIZE;
-	return sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
+	if (ret)
+	  return ret;
+
+	vcpu->arch.guest_state_protected = true;
+	return 0;
 }
 
 static int sev_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
-- 
2.27.0

