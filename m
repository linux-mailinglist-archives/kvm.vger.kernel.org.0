Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3BA12838B
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfLTVDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:03:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50966 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727730AbfLTVDe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=hov/puDtQHvNvWohlhaKQ3YJmaHFG7oHz1Chhy1SMre/gyIWSWLxg3wOPvbXPuTe3MZPDF
        hAbqcvanMcrcpMKAbS+QmRoQtqj3MKB822n0FnpjBPcACXsqpsyUrq4Wv9/3QV5eMaWtQ7
        BDz5C8pnlcYFgtaECJvGpGgp7aoPj44=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-wb3gFqIjPBWklJFfeB_KtQ-1; Fri, 20 Dec 2019 16:03:31 -0500
X-MC-Unique: wb3gFqIjPBWklJFfeB_KtQ-1
Received: by mail-qv1-f72.google.com with SMTP id di5so1662368qvb.3
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:03:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=RqHdWa3C67jDbAxE5qBKvQ2HeotB80h4OiIy6rDdMxq9AtJKq3sdvyN8bUzcqd+UkB
         CniOKVSC4j49ejY+jBDADopXzStE7zsbC2hgMzKZZf/F3nVO/I/KNyeKHysfay1nY0KD
         evXTs7uWn9CsFoa4lWZu4jtCMlOzu7O/B1BX5uUjWgfROW6HcLzp7RIbbymh6+/xZ4As
         cPffHFiH+vLIoWmiDHH2hz32PPiV7iGLhl1ueLrjrUS1EjPn1nNQl5y7JzRPfll+jdr2
         rw+ceXQe0YGW3WCBaX7LJbuIfMFCo/ausJRL34JQWpK1+ty+v5abBtJJmD35WXwQrgN0
         pONw==
X-Gm-Message-State: APjAAAWu1sD7HxCbmqzWOqF9vjHjxEBUBZw0omUWU0bVMnUBSJ/ljKJw
        XZxMflC6NQM2lDZIgRSqItp66DnUUCdYW0Owd851NYlywtOKuHfFRSVi8CRoq9vMJesQtdPTFDn
        tXk1GXe4I4w5s
X-Received: by 2002:ac8:4456:: with SMTP id m22mr13436033qtn.362.1576875810875;
        Fri, 20 Dec 2019 13:03:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwjedy9vJO9QU3awwLVGvmg81TcgWXkz+6waubY5bhmdyM90H3Ldeop7O/CBvSPdtrUYJzuww==
X-Received: by 2002:ac8:4456:: with SMTP id m22mr13436025qtn.362.1576875810722;
        Fri, 20 Dec 2019 13:03:30 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a9sm3061018qtb.36.2019.12.20.13.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:03:29 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v2 01/17] KVM: Remove kvm_read_guest_atomic()
Date:   Fri, 20 Dec 2019 16:03:10 -0500
Message-Id: <20191220210326.49949-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210326.49949-1-peterx@redhat.com>
References: <20191220210326.49949-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_read_guest_atomic() because it's not used anywhere.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/kvm_host.h |  2 --
 virt/kvm/kvm_main.c      | 11 -----------
 2 files changed, 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d41c521a39da..2ea1ea79befd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -730,8 +730,6 @@ void kvm_get_pfn(kvm_pfn_t pfn);
 
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
-int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
-			  unsigned long len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 			   void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13efc291b1c7..7ee28af9eb48 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2039,17 +2039,6 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
 	return 0;
 }
 
-int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
-			  unsigned long len)
-{
-	gfn_t gfn = gpa >> PAGE_SHIFT;
-	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
-	int offset = offset_in_page(gpa);
-
-	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
-}
-EXPORT_SYMBOL_GPL(kvm_read_guest_atomic);
-
 int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       void *data, unsigned long len)
 {
-- 
2.24.1

