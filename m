Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0543274ADB
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgIVVKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 17:10:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44028 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbgIVVKm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 17:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600809041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J4J8G6o2dkeXApdrpwNMYr32HCaxlIvTLSvlampSyz8=;
        b=h34blopni2cehWC+v0W6weyLjby3exOgrwj0h8v2jtVb3y6SA/doA3ec23YVVmmvteYSfT
        IfrLA3Rkq0VPVEEhMGnOBGcSN7nxePWpvU5J00dJAZvcClruq2StFhK5JHgKZoezvuEy9P
        62We4orISdqtm9kQtZHl+xlpRl4/AyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-9sgPgTtBPaKfihsZ6OypDQ-1; Tue, 22 Sep 2020 17:10:37 -0400
X-MC-Unique: 9sgPgTtBPaKfihsZ6OypDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F711106F71C;
        Tue, 22 Sep 2020 21:10:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A38E5577A;
        Tue, 22 Sep 2020 21:10:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v6 1/4] KVM: x86: xen_hvm_config: cleanup return values
Date:   Wed, 23 Sep 2020 00:10:22 +0300
Message-Id: <20200922211025.175547-2-mlevitsk@redhat.com>
In-Reply-To: <20200922211025.175547-1-mlevitsk@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
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
index 17f4995e80a7e..063d70e736f7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2694,24 +2694,19 @@ static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
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

