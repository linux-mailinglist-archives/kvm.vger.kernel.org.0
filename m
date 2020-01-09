Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CEA135BED
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgAIO5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731932AbgAIO5w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRATN7sKWcZdWDij4U02uLG0iob0fByx2e0Dt2ueT/w=;
        b=ifvsF29AAoPaNiAHGjmliWV+BCppV20kafRoHF6alACjBXV07bNOtoAzxGDXao2nxE2uSi
        iU6iq9Xa5yRnDTFiH3vuPbizJJjwZfw+u64FmA7Z8GVnJSz1zw1FqfNt6FO6Ai9bVxdZzE
        1Ci4jtQ1pGzBw4wOHGmqJsAF3OFmwIc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-KWH8Ato6Ntq7kt7gq9iLGQ-1; Thu, 09 Jan 2020 09:57:50 -0500
X-MC-Unique: KWH8Ato6Ntq7kt7gq9iLGQ-1
Received: by mail-qv1-f71.google.com with SMTP id r9so4238977qvs.19
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRATN7sKWcZdWDij4U02uLG0iob0fByx2e0Dt2ueT/w=;
        b=I4BuhdGxmI4+5HPYH3a2oOW8v4ubY1mlF5P0VQ/xNKi+188shBsRllP9Ix87mcAMXQ
         +92KMzhbSo+uQnLZS7sfKYd0vjBrZMW55jaDKPOejaen4MlNWLAPDUKFB2/nOROjVmw6
         nrz6snYvRxmE/XwNjuuSyX3m4Xhx+diB9utpo6aGHwsHkK/X+yMZCvR16N8CMj221DHp
         M6UBjgu4QSS+8PC+Ed9FNPtZWI97AouZqWznxuQ8brQ2le/nxQEPEMC/MB/5Uk6U9Dpc
         Jm68ucC8cNjjMbOoxOyfBOzDz2Fxa0J4BC5OcixBwmLFrbFWw3CiAIgekhlZbXENvn8I
         /pZw==
X-Gm-Message-State: APjAAAVHD7LwWZJXzrrXkdWI67KflxGJEbVe6ED/g08qxNnbVU8PtAzd
        8fLW+xIcvCcT3mKGnJXx72pNTG8dRxZylxo9mt+j6zZpg66yhRvaj9JZicUKH6bCD+R6SYsNPQk
        AZTLJPwySHVt+
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr9511643qkk.159.1578581868294;
        Thu, 09 Jan 2020 06:57:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRbVnZp1vzZ6tL+7JcD0WsY8mA3XV8L6qTwZsx0HCnJl+m4kcc+RK3EtswtsJg3qtmZCifYA==
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr9511621qkk.159.1578581868090;
        Thu, 09 Jan 2020 06:57:48 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:46 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 05/21] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Thu,  9 Jan 2020 09:57:13 -0500
Message-Id: <20200109145729.32898-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It would be clearer to dump the return value to know easily on whether
did we go through the fast path for handling current page fault.
Remove the old two last parameters because after all the old/new sptes
were dumped in the same line.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmutrace.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3c6522b84ff1..456371406d2a 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -244,9 +244,6 @@ TRACE_EVENT(
 		  __entry->access)
 );
 
-#define __spte_satisfied(__spte)				\
-	(__entry->retry && is_writable_pte(__entry->__spte))
-
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
@@ -274,12 +271,10 @@ TRACE_EVENT(
 	),
 
 	TP_printk("vcpu %d gva %llx error_code %s sptep %p old %#llx"
-		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  " new %llx ret %d", __entry->vcpu_id,
 		  __entry->cr2_or_gpa, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
-		  __entry->old_spte, __entry->new_spte,
-		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
-	)
+		  __entry->old_spte, __entry->new_spte, __entry->retry)
 );
 
 TRACE_EVENT(
-- 
2.24.1

