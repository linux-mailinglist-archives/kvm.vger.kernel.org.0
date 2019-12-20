Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB71283AF
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfLTVQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:16:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29419 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727595AbfLTVQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576876605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=OdPMIm/IrbSygJdO9G0M8xjpNB6HAdr6hPftFHxvQXODcwJMLa1HUKlSh+qP6gHdcVVmlK
        TUJovzz284nWXDZ8Ya4RzU1FNbmUQI9OWFGDS4Y6gwTFCfeu8WM+/DfG9jinvD8vBe0hv/
        4FcSobNsic2q6pMeqKWhV9jlmDFnjko=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-ZE1i7bR3PjGIkYeos_CW8Q-1; Fri, 20 Dec 2019 16:16:41 -0500
X-MC-Unique: ZE1i7bR3PjGIkYeos_CW8Q-1
Received: by mail-qv1-f70.google.com with SMTP id v5so6749943qvn.21
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:16:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=hqa8hbAAykD1MszuOGtJltU05+nR8wS5IVzJk3pblNKfJr4ng6qCuFI4trUsPkKpQ3
         pH3HM5wL2rChbbTvnnqvDOGqXDmTTne8D64iS34MKyF/Q9pCYHJXEncIWZ5DQO0Gm/Dx
         C1min/wGxB12/g45Z9DgW4inPtPpbgFiIcp0GipK67ZMi3fzONF8syXcWvu8fg2b/CA+
         WzAF1/w+rtS0iMV4y/1DxdYZnhaTCEzDCPU91l+IL6DJq4SH5o+MHx3u6zw7cJvqUJO1
         M7DSKIz/CA6lSmCPybMF+PgpHbUhoQ9eAHcr8jazpIrG+dgo/+Kzehcrt1lAlxKYnEg9
         1KlA==
X-Gm-Message-State: APjAAAWl41ou72v1JvUnR5QdoPpaeIIpeOybTH+1CsXxHw+lbhgul5fN
        /OhjxVDZBHmloBGduj7b2UAw27oHEiCQSCqRQjFpP0bKgyTwDWTXDmFWKIDu7eY16MwJLQ2cGRf
        qRdF8M8Cu6bVn
X-Received: by 2002:a37:b283:: with SMTP id b125mr15582015qkf.352.1576876600404;
        Fri, 20 Dec 2019 13:16:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqq3JoIUjXp2hoYBTRFQiEJY1jwKxiTuHZFetaPNnJ4sDqpMkgZlBdB0zLL7zuFba+vifoJg==
X-Received: by 2002:a37:b283:: with SMTP id b125mr15581997qkf.352.1576876600127;
        Fri, 20 Dec 2019 13:16:40 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm3385231qtq.11.2019.12.20.13.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:16:39 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v2 02/17] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Fri, 20 Dec 2019 16:16:19 -0500
Message-Id: <20191220211634.51231-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
References: <20191220211634.51231-1-peterx@redhat.com>
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
index 7ca8831c7d1a..09bdc5c91650 100644
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
 	TP_PROTO(struct kvm_vcpu *vcpu, gva_t gva, u32 error_code,
@@ -274,12 +271,10 @@ TRACE_EVENT(
 	),
 
 	TP_printk("vcpu %d gva %lx error_code %s sptep %p old %#llx"
-		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  " new %llx ret %d", __entry->vcpu_id,
 		  __entry->gva, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
-		  __entry->old_spte, __entry->new_spte,
-		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
-	)
+		  __entry->old_spte, __entry->new_spte, __entry->retry)
 );
 
 TRACE_EVENT(
-- 
2.24.1

