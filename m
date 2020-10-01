Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF127FE64
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 13:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbgJALaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 07:30:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731983AbgJALaU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 07:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601551819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JIgAnG0/52jvsrYP8foGBjJHRYEGbPqwh/z1E5MmjGk=;
        b=LdMYSudrxnWrvSKk0ymiPJzg4P47kSeVFwYF7zIMQixY4hlMUKGt3lZacjqP+XolYWnlZp
        +pooBaeNynjE/2B363Lrhl9TGS1Stj8BZ0NfYbkjAeDaj0zMl5n4wWBH++YfAmXYbQZd7N
        yZLwPIsH8w5cvVIr3g7ikjUOey0n7+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-yecq4e2ePqSmigsUkz0U4w-1; Thu, 01 Oct 2020 07:30:15 -0400
X-MC-Unique: yecq4e2ePqSmigsUkz0U4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EC231882FA0;
        Thu,  1 Oct 2020 11:30:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67EF171775;
        Thu,  1 Oct 2020 11:30:09 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v7 1/4] KVM: x86: xen_hvm_config: cleanup return values
Date:   Thu,  1 Oct 2020 14:29:51 +0300
Message-Id: <20201001112954.6258-2-mlevitsk@redhat.com>
In-Reply-To: <20201001112954.6258-1-mlevitsk@redhat.com>
References: <20201001112954.6258-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return 1 on errors that are caused by wrong guest behavior
(which will inject #GP to the guest)

And return a negative error value on issues that are
the kernel's fault (e.g -ENOMEM)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a7..09a0cad49af51 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2812,24 +2812,19 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
 	u32 page_num = data & ~PAGE_MASK;
 	u64 page_addr = data & PAGE_MASK;
 	u8 *page;
-	int r;
 
-	r = -E2BIG;
 	if (page_num >= blob_size)
-		goto out;
-	r = -ENOMEM;
+		return 1;
+
 	page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
-	if (IS_ERR(page)) {
-		r = PTR_ERR(page);
-		goto out;
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+
+	if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
+		kfree(page);
+		return 1;
 	}
-	if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE))
-		goto out_free;
-	r = 0;
-out_free:
-	kfree(page);
-out:
-	return r;
+	return 0;
 }
 
 static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
-- 
2.26.2

