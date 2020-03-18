Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24518A094
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCRQhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:37:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:31286 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbgCRQhj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=f1S2ZcGb/eznpxnamB2o67jeD9sm+wmL3Tt8CgNwexV8q3xaG9DP2aw69JXiSFbX7aRB+C
        IGT+0IPn78wOv6VHGtZGoh4UajG1DTQLl1wV2LvKgmB9VEnY3Nz7t4aXsRrURN2tKA3Vhk
        trfWPrnyo3STXmB1No3SAEvYs9bKOww=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-fkYh-RI7Pde95Oqop3DYnw-1; Wed, 18 Mar 2020 12:37:37 -0400
X-MC-Unique: fkYh-RI7Pde95Oqop3DYnw-1
Received: by mail-wr1-f71.google.com with SMTP id t10so6313230wrp.15
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=NprzEmCqXT6Vgx05Bag9qdQtDSrLAVNfxGtaCpmKZSR3o406GEwwlrB1MmwC99Wn81
         XBtY4IPJnITWPb42WFizmApcnxarNZmYnEEiiecMy8Nr35HfDOKc8R/RShay0OXTV1nG
         iv501pYHOtUJ6sSSg2nBl2Il2eiQ6JAKehz3GH53F7t0AmwhfOX37OIddUT9EwGABDpS
         9uLzHQ8XNioOlvxQPjXpbbP6DWx3xJb1gwRdCap/ZsMwG54lTtD8qt9V0aB8ncqxYhlG
         4eIVUTjNhmLANN8dgIRlVlcjJRM972uYRnRTme+tOxPjbcF/rh/AE7iuoa1aO4ub4OVc
         FWIQ==
X-Gm-Message-State: ANhLgQ2VSNDHdtJKuOk79NFqKLCHwdWrUVgUQsXZ0ylbz+612IdU013z
        FGv0bIx+vSFzoIeC7RecPTT/AEaERJifyfSTIdyYhr4NhREsVmxBGoEHpG+isKYF4/0V9K5pzKI
        dyr34DP2nJC1O
X-Received: by 2002:a7b:c159:: with SMTP id z25mr6176868wmi.102.1584549454928;
        Wed, 18 Mar 2020 09:37:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtaqPeKFAd0yJQbAvVJ4mrbLJ6/dwU/B+4yuG+/8bXFj+8dfwUAPMZMNYYT/9jRyaygaGLA2Q==
X-Received: by 2002:a7b:c159:: with SMTP id z25mr6176842wmi.102.1584549454675;
        Wed, 18 Mar 2020 09:37:34 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id t1sm10315662wrq.36.2020.03.18.09.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:37:33 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Wed, 18 Mar 2020 12:37:07 -0400
Message-Id: <20200318163720.93929-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
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
2.24.1

