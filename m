Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCA336B235
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhDZLPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233201AbhDZLPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6QpiXrmkz74Z5aFxXMspDWckRqkg6aIoMxgiuYm/ss=;
        b=ToDYehWJCqyOCXEisK2nrux0d8u9F5uTvSAHz1v2ZTnHJh6oQjVbbZDEmbJbfjtKQO9Uvn
        211L6D6SCHYgw/nn2v2rhh/zrdM3pmH7ktZMK76xHkUkstjXJiFmUFQTUeLoqO7vfE9hIq
        pxVbYJU+osFmbHtkRV8Opw8US4Y0BtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-oHRwvXoNOX6AZc-KWGmTSA-1; Mon, 26 Apr 2021 07:14:18 -0400
X-MC-Unique: oHRwvXoNOX6AZc-KWGmTSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B59610CE780;
        Mon, 26 Apr 2021 11:14:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA21A5D9D0;
        Mon, 26 Apr 2021 11:14:01 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 5/6] KVM: nSVM: avoid loading PDPTRs after migration when possible
Date:   Mon, 26 Apr 2021 14:13:32 +0300
Message-Id: <20210426111333.967729-6-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if new KVM_*_SREGS2 ioctls are used, the PDPTRs are
a part of the migration state and are correctly
restored by those ioctls.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ceb37ed1dc98..9624fa81e830 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1356,7 +1356,8 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (WARN_ON(!is_guest_mode(vcpu)))
 		return true;
 
-	if (!nested_npt_enabled(svm) && is_pae_paging(vcpu))
+	if (vcpu->arch.pdptr_reload_on_nesting_needed &&
+	    !nested_npt_enabled(svm) && is_pae_paging(vcpu))
 		/*
 		 * Reload the guest's PDPTRs since after a migration
 		 * the guest CR3 might be restored prior to setting the nested
-- 
2.26.2

