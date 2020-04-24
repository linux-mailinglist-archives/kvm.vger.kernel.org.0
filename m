Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286A81B7CA4
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgDXRYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:24:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49744 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727108AbgDXRYf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 13:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587749074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=X97kAjQTRE8bXr/jYZHHtAlVVl/dgOHFGA/rfX34Hrg=;
        b=AuKC80jujjCWoSIgs8rVvQVsANFvUEjYVj8agd+E9XaioG6I8ck9vQsaUYLVCndcpHKx1m
        M5XDwigbpWB9qeOgU0L9Q8XzFnu9AR49QKCG+GmuzLJhpFGNu6eCjtrsA+qrxJ0viZ02m8
        uqkHOUjjfFnv5Rxa9Ubz7uQ8oYrif0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-nv8tM_YhPBWV5WT-sDK--g-1; Fri, 24 Apr 2020 13:24:32 -0400
X-MC-Unique: nv8tM_YhPBWV5WT-sDK--g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B73D353;
        Fri, 24 Apr 2020 17:24:20 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEAA525277;
        Fri, 24 Apr 2020 17:24:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 02/22] KVM: SVM: leave halted state on vmexit
Date:   Fri, 24 Apr 2020 13:23:56 -0400
Message-Id: <20200424172416.243870-3-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to VMX, we need to leave the halted state when performing a vmexit.
Failure to do so will cause a hang after vmexit.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 51cfab68428d..e69e60ac1370 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -472,6 +472,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	leave_guest_mode(&svm->vcpu);
 	svm->nested.vmcb = 0;
 
+	/* in case we halted in L2 */
+	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
 	/* Give the current vmcb to the guest */
 	disable_gif(svm);
 
-- 
2.18.2


