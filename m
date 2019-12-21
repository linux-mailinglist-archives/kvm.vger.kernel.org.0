Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089DF128678
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfLUBtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:49:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726733AbfLUBtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:49:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=aFP3kjL6YE9yH1JR/zyOnVr/62+VCOikx7zdrTHsOlezo3ZOCYfn64p2of+1qdecgrGt1L
        ksVCtxwNIuv+N8MzdhaKl0KgCjCvq1rSd5O1clcq/0W3gze/+61vlHNKZVn1UhyJa3sd5s
        WOcdS5JqbbsAdYnivHWppITPknNRE9E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-c-EV2JOZP-aCXhhK8-A5iA-1; Fri, 20 Dec 2019 20:49:47 -0500
X-MC-Unique: c-EV2JOZP-aCXhhK8-A5iA-1
Received: by mail-qk1-f198.google.com with SMTP id l7so7155864qke.8
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m4Ydwgp5PpMnSage4lUP1t9xcFgD9PS/bCLMno8IgRs=;
        b=pMyO/hHJOZlZRAdoF9oysxBVELVbqVqQxrupJuVxqdQtXe3fdoyapTJ8UTyQIp1uBl
         wu3x7yxaOKXPvwccJ8YLrQXjII5d1+rMinVqsGogZ6bUO3zG6YpX3ho/TwI65oQxumnn
         eQBbhTsrKiNuLC5+UOasWA5BWWh7YF6+/vuouvtWFgKGksyipOxE5lf1Ni+4SNDWf4Ru
         1ITZ+FSXlhNz28ddyiTNox/sYJm3nCmN4IiCJMAGCG4DfWyItSAMB2/JvM3BjijlIz8r
         b4tF+/2wt7PwuF1A/nkrmpUqfemUDqJIO7gjiavrXkUswR5DcW94J/dbg6r6ShUjXstW
         OQBg==
X-Gm-Message-State: APjAAAXA22WgQWZP4XqI2eKKiivP4HxkNuIzU7tpGR7qHgKO0cOpvCVu
        YHrdAJ0ojuLPFrZhDoqPgodQSoh2CzaQWzDA/68r9kaFCzx9Mkig2AJjhKO+F7qaaoB2Cxc3byc
        4C6y/HI7qEYAN
X-Received: by 2002:ac8:7a6c:: with SMTP id w12mr14482170qtt.35.1576892986490;
        Fri, 20 Dec 2019 17:49:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqy0xIujDWM8kEgYMZtJXBmHq7FpeBe6JthzaDGA1ivGB+9bq1sOU49m4a67oz82Pg8AlQmsnA==
X-Received: by 2002:ac8:7a6c:: with SMTP id w12mr14482162qtt.35.1576892986329;
        Fri, 20 Dec 2019 17:49:46 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:45 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 02/17] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Fri, 20 Dec 2019 20:49:23 -0500
Message-Id: <20191221014938.58831-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
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

