Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8A7371583
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhECM4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233992AbhECM4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+hgUxmY/DDInazOvSMMBUY4bVl9Fu52GOIKyss39Jo=;
        b=FrhWCAoTb6n/S/FvUnPrem93ClB0WoZnHRUdDBLutbF5Qnju5VygfE3AoT49pgWpzqbh79
        NXT9UKxtgDov49W5LimIEfb6hE+9IMw9FECO4lHt6UAghgcF8WRLuLimunSqs7NeiMM5vG
        nUa4eNZNpWyIvdZQ8UosEhNqKXvcLSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-MDc3fJ_1OmW6vbCXHjZLTw-1; Mon, 03 May 2021 08:55:13 -0400
X-MC-Unique: MDc3fJ_1OmW6vbCXHjZLTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12209818415;
        Mon,  3 May 2021 12:55:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B623705AA;
        Mon,  3 May 2021 12:55:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 4/5] KVM: nSVM: force L1's GIF to 1 when setting the nested state
Date:   Mon,  3 May 2021 15:54:45 +0300
Message-Id: <20210503125446.1353307-5-mlevitsk@redhat.com>
In-Reply-To: <20210503125446.1353307-1-mlevitsk@redhat.com>
References: <20210503125446.1353307-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While after a reset the GIF value is already 1,
it doesn't have to have this value if the nested state
is loaded later.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 32400cba608d..12a12ae940fa 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1314,6 +1314,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	else
 		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
 
+	/* Force L1's GIF to true */
+	svm_set_gif(svm, true);
+
 	svm->nested.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
-- 
2.26.2

