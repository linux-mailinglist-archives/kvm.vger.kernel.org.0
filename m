Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81F5435CE2
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhJUIb2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231433AbhJUIb1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 04:31:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634804951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PInoKV72OyGR98wYwrqitYj1CXMn3EIDFEwTKRKsKaQ=;
        b=LsM8quC+XBXAH5reowRCUkqBXvdPvvN9M2soxNEHRWw/9rQXp9IUh2NwNp2x9toZLeDncp
        4PBs68/RgJ7EoRzkzkVtgwEwrjqFn3iEzc+pB3uJoqbV5xz7G8veI/vYtUJV93pEgM5sA6
        JsYtBuyG4umZ7UXGmg7ufWKjTb7C/Iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-6nA254J_NQS0E4ZZCwlz3Q-1; Thu, 21 Oct 2021 04:29:05 -0400
X-MC-Unique: 6nA254J_NQS0E4ZZCwlz3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F2C980F04A;
        Thu, 21 Oct 2021 08:29:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65BD019D9F;
        Thu, 21 Oct 2021 08:29:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, zxwang42@gmail.com, marcorr@google.com,
        seanjc@google.com, jroedel@suse.de, varad.gautam@suse.com,
        aaronlewis@google.com
Subject: [PATCH kvm-unit-tests 2/4] x86: fix call to set_gdt_entry
Date:   Thu, 21 Oct 2021 04:28:58 -0400
Message-Id: <20211021082900.997844-3-pbonzini@redhat.com>
In-Reply-To: <20211021082900.997844-1-pbonzini@redhat.com>
References: <20211021082900.997844-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The low four bits of the fourth argument are unused, make them
zero in all the callers.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/desc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index e7378c1..b691c9b 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -336,7 +336,7 @@ void setup_tss32(void)
 	tss_intr.ds = tss_intr.es = tss_intr.fs = tss_intr.ss = 0x10;
 	tss_intr.gs = read_gs();
 	tss_intr.iomap_base = (u16)desc_size;
-	set_gdt_entry(TSS_INTR, (u32)&tss_intr, desc_size - 1, 0x89, 0x0f);
+	set_gdt_entry(TSS_INTR, (u32)&tss_intr, desc_size - 1, 0x89, 0);
 }
 
 void set_intr_task_gate(int e, void *fn)
-- 
2.27.0


