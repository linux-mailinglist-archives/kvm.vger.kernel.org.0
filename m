Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C691C1DFB7A
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388087AbgEWW5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388016AbgEWW5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 18:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ble7s/BrlGwUPRHQ34ii4/VsZgKqdI5xssnXt1KNNb0=;
        b=i7qAG21S8ElRH5jg3tJFA514dY73cBaRyuN5fCCKfm+W97cvgP2RYEfMV+PseTq4DX85WY
        mLmj7/kcKJtWpyNBcjF2ksyYgTd5qAh3mpeJxQ3AM70dUqE7GUR/F/R4kkcnOPF9gMFERm
        nB7dBqJIjiFg//KN0RYiDwTJorrYdEc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-3MUodmNfP1uEc7tKxZO6mA-1; Sat, 23 May 2020 18:57:06 -0400
X-MC-Unique: 3MUodmNfP1uEc7tKxZO6mA-1
Received: by mail-qt1-f197.google.com with SMTP id p20so3052254qtq.13
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ble7s/BrlGwUPRHQ34ii4/VsZgKqdI5xssnXt1KNNb0=;
        b=Xd14gj+H4kDIWkku2SgloYhZr7SAVFDWSny/VZihX5jZf8ZnD+JaTA5kW9TJiJAGHU
         QbU8rh3kzOmLQr7JXY2Ykfic3TMexfcfxavI7UIr55lr5MfSCYF3U2DKpBgsq3PJ1WRP
         HjEzSIbt3uHWRYF4gp7XS/wLmivMAqZzMcdwSHT8cO2xJzOGnKtEzEBDqgUDsyEX54xP
         GyDHtIEWTtxcZYSewEt6WD76bh5tACGIt9f9PuHMchJjXQJPKSseqc+lCcQWw5qeltyn
         gn9okx3L7TUz+8RgNlVi4P84d3anSIxVcSLJJwJ8k9hbMR1ua9L9IOFFBe9Lj0wfcVSt
         +N1w==
X-Gm-Message-State: AOAM532D0GfVgMpMcGjcdaYtYeQgi4nn7qBQcA4g1Owywn9dDfXxw8ji
        I3lxQF5CnKUjv8MW/5qHdvgd9cRKcXr9qf4hOBWwASmElrUvGh0o0/5wLbQ3vSWv3zIekKTWhHF
        YEZgY6RjOunal
X-Received: by 2002:ac8:4a88:: with SMTP id l8mr21356368qtq.337.1590274625496;
        Sat, 23 May 2020 15:57:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyfZidmD/ZSQV5cbmCS0RnT9AdYlS2aPMYmebfucXy9aWDUoU3As8I7YtAnly5gG9nM+kp4g==
X-Received: by 2002:ac8:4a88:: with SMTP id l8mr21356349qtq.337.1590274625276;
        Sat, 23 May 2020 15:57:05 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:04 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v9 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Sat, 23 May 2020 18:56:46 -0400
Message-Id: <20200523225659.1027044-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
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
index ffcd96fc02d0..ef523e760743 100644
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
2.26.2

