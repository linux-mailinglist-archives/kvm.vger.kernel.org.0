Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BCC2EBCC5
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 11:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbhAFKwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 05:52:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbhAFKv7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 05:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609930233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZkWA8+ZHcOHmK6kpBpK3Tyn9RuY/ymlxGzls78cNaM=;
        b=dD1njen8jEZNiZTY3x9KmZnwk0i+kXMuOYJqRFy3d1WsPHSwM4g1SqBtTf/2AYQ66QqF4I
        MTf6bX+lTxo8TQtUDPZITMGeR3dduzuee4squCKcHjap/kM37WhjeO1XJNjLE6OCeqBuqd
        W2aAE4lr62boufMY80Tjfm7O5cJt5e4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-j0EnGmzgNnWv-WBRAh8LNA-1; Wed, 06 Jan 2021 05:50:31 -0500
X-MC-Unique: j0EnGmzgNnWv-WBRAh8LNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 743E010054FF;
        Wed,  6 Jan 2021 10:50:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7D6C669FC;
        Wed,  6 Jan 2021 10:50:25 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5/6] KVM: nSVM: always leave the nested state first on KVM_SET_NESTED_STATE
Date:   Wed,  6 Jan 2021 12:50:00 +0200
Message-Id: <20210106105001.449974-6-mlevitsk@redhat.com>
In-Reply-To: <20210106105001.449974-1-mlevitsk@redhat.com>
References: <20210106105001.449974-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This should prevent bad things from happening if the user calls the
KVM_SET_NESTED_STATE twice.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c1a3d0e996add..3aa18016832d0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1154,8 +1154,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return -EINVAL;
 
+	svm_leave_nested(svm);
+
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
 		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 		return 0;
 	}
-- 
2.26.2

