Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B36217A96B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgCEP5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:57:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726164AbgCEP5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 10:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583423840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKhoQxKzVdv0hd1Nmd+yV7hKjeG+Y4sbHF1K+C0InG0=;
        b=dmL/7bDfMkj8wUtyquZMKEnxss53zK8USeoI42LPfKaDHaGTIV6ySvg5h0QlOpRVSiftpA
        18Jm2ZumVrzNY8LslKICo4mUWZ/SSEuoy6ih0GrekPMc9f61IDQC0RJhoM20jYUFNJQxlg
        VIKN1A24fIX+bTBBYStbZLxYqOZhgVg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-E7nG6v8MMsWzw6u4mfvcAw-1; Thu, 05 Mar 2020 10:57:19 -0500
X-MC-Unique: E7nG6v8MMsWzw6u4mfvcAw-1
Received: by mail-qk1-f200.google.com with SMTP id e13so4064301qkm.23
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:57:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BKhoQxKzVdv0hd1Nmd+yV7hKjeG+Y4sbHF1K+C0InG0=;
        b=qvXFISbftoGuBQHzjf+8kcin2xI+3WbQTISps0vZd4NCCsQcjwci8reTXnzeG0H63T
         /P+lN6Dp8cxAm7o+0+ehq/TM5utfDOW5Vv8DvCw2vRsTgTHFfWKnJbIRAa+P1bJLHUhN
         r/N2ZFMSBEoV2uXMEreQLLsVnI9K2HjBM2aEupEzt6iFKKEYpGIZAyfF20yooAuYQ5So
         k+8GecGqX5x54nu7F+q2uNmvmUjY+O6gqe4WTfmHKuFVZHK3q3acxrDo25McDhXcfMBy
         1GKvwQQ49Vd2QL5rN3Yw8XSgNlcJem8rJ0LM5PTJ6DGU/26gcNsG4xUZsSEifGyaIhSA
         Yvxw==
X-Gm-Message-State: ANhLgQ3GwQzr/bCEUZL4G+kaRef7bm41TXBvjgdUKTjrV7MfY0u/cbC3
        PMDu1JwOFfETKiXpUGtRE+BLZ54KaokB/X7Rc8c87En/a3ktQiJlFPyR0jSP41NE6H1vZKOsRG6
        RQ52BZn8O2Zm/
X-Received: by 2002:a0c:f64e:: with SMTP id s14mr6990174qvm.129.1583423837882;
        Thu, 05 Mar 2020 07:57:17 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtbWhnXso6DibXEzx0MPB5VJm2bB4SiaCiuUwt486jy6wWRPqTydJKvfB1ptF3rG84ssICm/Q==
X-Received: by 2002:a0c:f64e:: with SMTP id s14mr6990149qvm.129.1583423837566;
        Thu, 05 Mar 2020 07:57:17 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id x93sm8030727qte.60.2020.03.05.07.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:57:16 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmiaohe@huawei.com, Paolo Bonzini <pbonzini@redhat.com>,
        peterx@redhat.com
Subject: [PATCH v2 2/2] KVM: Drop gfn_to_pfn_atomic()
Date:   Thu,  5 Mar 2020 10:57:09 -0500
Message-Id: <20200305155709.118503-3-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305155709.118503-1-peterx@redhat.com>
References: <20200305155709.118503-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's never used anywhere now.

Reviewed-by: linmiaohe <linmiaohe@huawei.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb9b2ac0791..3faa062ea108 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -704,7 +704,6 @@ void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
-kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 kvm_pfn_t gfn_to_pfn_prot(struct kvm *kvm, gfn_t gfn, bool write_fault,
 		      bool *writable);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..d29718c7017c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1754,12 +1754,6 @@ kvm_pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);
 
-kvm_pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
-{
-	return gfn_to_pfn_memslot_atomic(gfn_to_memslot(kvm, gfn), gfn);
-}
-EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
-
 kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	return gfn_to_pfn_memslot_atomic(kvm_vcpu_gfn_to_memslot(vcpu, gfn), gfn);
-- 
2.24.1

