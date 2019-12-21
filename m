Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFEE128679
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfLUBuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:50:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28903 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726613AbfLUBts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 20:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=gvGicvQjbuqEeaL0fZ+IX0/0vUHCTKl4ikEYU34Fd2/AD6VbMEKDOUBFzk4A7ig1DUI25w
        ImIDjGDmpgNiz66JsWy3QOZGkHdv6v/m16OhPkFGhKDfPFDZir2oZJPlArl7AkdYCnp9Rq
        9MuKP+0FJMrPGWUlSgpE031syyZT3+o=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-sEqscXwiPQONxZSpWc9tzA-1; Fri, 20 Dec 2019 20:49:45 -0500
X-MC-Unique: sEqscXwiPQONxZSpWc9tzA-1
Received: by mail-qv1-f69.google.com with SMTP id f16so7171166qvr.7
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5u+NdTdcxJqnd4CDcK36kvrGYVN4B69rZJAB5gjRDOQ=;
        b=WAJ+isn+iO9K4yzb6ftbeKFsAj9TcrTgtD4O17k4eKN6ZQtjysJI8wyxYtYMxPpdFx
         /RWv1hSE4e7qk+caiKqw/ns+jt+PXPQDoO+MW1mZzpdgjx+8tVs6P4TgI1NaPmIckOpu
         6iUUO/9RurA/6meXj5JLCoA3m95T2GWqmxHTlvbXkjGK7g7CYDZj3CHNkNe8ROv2wRRp
         sTo/UqdcIz4+L+R/V0xPmLF/WRn3zkCluy0J6tJEv5hoVSe2DPRyl0g9Q/WftKWMC1ws
         lu+q2cqjodzt8UQcgu1hHBL74OlAqrOU5q7LShz3sCMwVbe+hDQPATYFeyeJ12b6ZTsQ
         /nrw==
X-Gm-Message-State: APjAAAU+hpmcjAGqP/RcI3pXzrimVacMnua1UpK0cEPqwJ282odWUBDm
        WB1pSRmgX38aJuYOXmgrwSBDwDQtxsJpMyoXifHg+t/qA34Tjm93Sss5AzfChs7vHRJCdDWLmFt
        UlIhbRi91Qwp2
X-Received: by 2002:a05:620a:634:: with SMTP id 20mr7129944qkv.269.1576892984497;
        Fri, 20 Dec 2019 17:49:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzi7/gDaYgNg0pHa+V7FOPwTChgJ98Acb8wMgEHent4TmIHneaBgF7FVuz9dNugS/zXI4cUAw==
X-Received: by 2002:a05:620a:634:: with SMTP id 20mr7129928qkv.269.1576892984288;
        Fri, 20 Dec 2019 17:49:44 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:43 -0800 (PST)
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
Subject: [PATCH RESEND v2 01/17] KVM: Remove kvm_read_guest_atomic()
Date:   Fri, 20 Dec 2019 20:49:22 -0500
Message-Id: <20191221014938.58831-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
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

