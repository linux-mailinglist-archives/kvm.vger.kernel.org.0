Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945D1179704
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgCDRt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:49:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729600AbgCDRt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 12:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=GHnVeEFJSTGLz91LkNZEHvh2zeylxJCjSuMipTyfiyRxY6hWmTJsXNDuyBI4QENpB4a18j
        f0I6mTOp95Ze2n6Ar/iBRha3T0O493d/6WoqddVELKryW4r5wcH2v77gkvFWf4ePb2XTG5
        iSuiVhb/mKP3/kuV76jeKDAOJ2NuQ7o=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-I6GU12VgOFC8gqPqTlBX3A-1; Wed, 04 Mar 2020 12:49:54 -0500
X-MC-Unique: I6GU12VgOFC8gqPqTlBX3A-1
Received: by mail-qv1-f70.google.com with SMTP id l7so1418237qvt.22
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:49:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zL6sq31OFwBXF/RS7PK1GArrpq69jRR45bepTSw46TU=;
        b=oeGU5gVGBGFkH56B/RnNO3o+PqhLJ0ugZ0ya4bHFCuOOFJlXXpz9ZUJcvGEaQhm1kL
         3Yun1sqbPiV6IE+vBfRKw5JP3cVLUUwltWBjrb8ThjESdKkr3F9+7LwpgUSoO8vZYRpR
         IoLN+LPyNan1Qnoi/RscRX5KTJmmaseJE5npifi6mYdAU17ZFP/b1KxjKXIQN8OdkKpl
         0aLmLvAignWINtN27HbqSh+TLUHZgehS3lkuiO4327x/UOpkNStViRuzdf0eDUiYMWKd
         Qq+GyWDiw4b90/tCT1rNMBR2HvTkwhO9aTQJPINb6cifTHyFH1kom81TTwIkfNl8OfaD
         GsvA==
X-Gm-Message-State: ANhLgQ2YNo87UC14d4pCbq1xAT6yzwW1P9pnXHQGdjwBs3EHh08Npi6i
        +2il+uWM3wlZWufYrpk46zwAI/WDttVV96L/NmHZqrbC7xqnsJbzWBRjnPhlA62VSoqKa9R13Tc
        zlV5PcsnpqK3F
X-Received: by 2002:ac8:534b:: with SMTP id d11mr3512254qto.101.1583344194069;
        Wed, 04 Mar 2020 09:49:54 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsEcJ8+mn9bDrZSYhkrNp5+S9+YoenWyrwAv3oEiBqUoFFjT9yfw5nnfEEcipf3nFOz7+yVbQ==
X-Received: by 2002:ac8:534b:: with SMTP id d11mr3512237qto.101.1583344193844;
        Wed, 04 Mar 2020 09:49:53 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id j4sm6990420qtv.45.2020.03.04.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:49:53 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Wed,  4 Mar 2020 12:49:34 -0500
Message-Id: <20200304174947.69595-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
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

