Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A6C268C72
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 15:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgINNno (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 09:43:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37673 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726706AbgINNhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 09:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600090656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VDFf7hbL2ujN8s8a2I30Af1l7eed0ojFf/+W47iXnwU=;
        b=XCB3OD1wrMAXmvrqdT3mF+Op0NNVg2cxuG0a90WxreHN6clAv5Iiq6gQDcXHiByPNzhmCX
        33x9L1DW4QDsSMp0GmGyiUcTvosPbOaG2xOv0CgEvNrzlH6j0FeNNeRE39WAtDldVeIdap
        KvNein1RyVB0GwVqPk+vMjVeQHWyiMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-5ULj2_lnPJOnQqboJzlpJg-1; Mon, 14 Sep 2020 09:37:32 -0400
X-MC-Unique: 5ULj2_lnPJOnQqboJzlpJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5884D425CB;
        Mon, 14 Sep 2020 13:37:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BCD57839F;
        Mon, 14 Sep 2020 13:37:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     x86@kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH tip] KVM: nSVM: avoid freeing uninitialized pointers in svm_set_nested_state()
Date:   Mon, 14 Sep 2020 15:37:25 +0200
Message-Id: <20200914133725.650221-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The save and ctl pointers are passed uninitialized to kfree() when
svm_set_nested_state() follows the 'goto out_set_gif' path. While
the issue could've been fixed by initializing these on-stack varialbles
to NULL, it seems preferable to eliminate 'out_set_gif' label completely
as it is not actually a failure path and duplicating a single svm_set_gif()
call doesn't look too bad.

Fixes: 6ccbd29ade0d ("KVM: SVM: nested: Don't allocate VMCB structures on stack")
Addresses-Coverity: ("Uninitialized pointer read")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Joerg Roedel <jroedel@suse.de>
Reported-by: Colin King <colin.king@canonical.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 598a769f1961..67e6d053985d 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1094,7 +1094,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
 		svm_leave_nested(svm);
-		goto out_set_gif;
+		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
+		return 0;
 	}
 
 	if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
@@ -1150,7 +1151,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!nested_svm_vmrun_msrpm(svm))
 		return -EINVAL;
 
-out_set_gif:
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 
 	ret = 0;
-- 
2.25.4

