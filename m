Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB9128387
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLTVCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727422AbfLTVBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=fNYWrw5qfL3/XbVBGlXSem0gmj2Ftrav4SJ8/nRY0p+9jOcPZgarhiqpBEhUDfLZFb/vcS
        RSQ/uantnIgt9PUzXJAfsnoDWRQjzYtwd5eMTjzR2feQnKTsLOK55oc2/j+UZ+x82gryNW
        Pv88dYD6vczxYFeL0fyZkN0l8agqTZg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-Lx9IvbrxOOi0p0UI5zVTBw-1; Fri, 20 Dec 2019 16:01:51 -0500
X-MC-Unique: Lx9IvbrxOOi0p0UI5zVTBw-1
Received: by mail-qk1-f197.google.com with SMTP id n128so6735442qke.19
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:01:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=V1Gjmfnvikemx41IX79lWkwCxsivHbc/XpFfD0xH9vfs2aFcJgfPg5jugrcCxW5D9k
         7nAiOU/ztpXqPotwWoPTkjy0vrNqKE3k9oqqtmQyRMGsL62mU3LjRp5azx9yWEsa7W1y
         ycrN3tas1xcbbX7vEtyR7QoGE8Wotm1cmCu8bVCEhiZJ/EiO/Mo2Si3XCPcb4Hg5L7Tf
         0WvnfEtAneRXou/yOar+ZLivd83ojd/d1TE7fPaUedZsOF/cWw0AIV4wU+X/bWQis8JO
         AWv4DcgKCviRmwO7gpx559EStwirc6aJG1EdB0tXaQdkq6aOF59ZLgSmtDdzwXq9IUqG
         MaCQ==
X-Gm-Message-State: APjAAAX3tL8gGhPjTOicqMRl7wpNE5vUdydhRz1l4+SCbMcSVOmSsc0/
        epKuCBNwmyhSXTCMkdUxFs+w/VQd0eboLVMfP0WJvXiO4YaRIGKhEkhFBldZPg678Hl9BnBkxwy
        4Se80+YKmLdsD
X-Received: by 2002:ac8:7201:: with SMTP id a1mr13291512qtp.51.1576875710501;
        Fri, 20 Dec 2019 13:01:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRoak70ZtDSXTrsL5BKFgZ8eU8b8vS29Tx8wICbfjkV/PqQRqigL5g2qPUrK/6ZAtRLM0GFw==
X-Received: by 2002:ac8:7201:: with SMTP id a1mr13291492qtp.51.1576875710346;
        Fri, 20 Dec 2019 13:01:50 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:49 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 01/17] KVM: Remove kvm_read_guest_atomic()
Date:   Fri, 20 Dec 2019 16:01:31 -0500
Message-Id: <20191220210147.49617-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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

