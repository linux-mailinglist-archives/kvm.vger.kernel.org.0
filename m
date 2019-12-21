Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C18512866A
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 02:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLUBt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 20:49:57 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43530 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726905AbfLUBtz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 20:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576892994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=M6W8TCcogAD/Xt6j195wtlZzuP2ij99aJE4OTI7wnMGU+HpDvQQ6hiFQi0qONi1r8zzOQY
        RZOjbGbfCJbK92HxnSdUS1oRVSw2f5/y0nGQaV9Pf42ze7WSKMdFiGzmNxrgZFYKvPsnCF
        FCklH/84LMzpS1e/KtZWbpFQs28ZGCQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-CW4GbpVeMS-htSU_7HnY7A-1; Fri, 20 Dec 2019 20:49:53 -0500
X-MC-Unique: CW4GbpVeMS-htSU_7HnY7A-1
Received: by mail-qv1-f69.google.com with SMTP id j10so348891qvi.1
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 17:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=IlYaqZ3ni9JnrwyKIqa5aGsRVjMGf+p9s0Wm/9dMkUlT6lmAf4U20VxvBzwhrCiPv7
         +eJKdsXD8w2Rs/adYh7wf8NFXy7ADNM/wHQObsBb+hbdgSfHKm5rNiV7vsOZKhiBuKGg
         IIbdhFdD9BsSc1QKqqL4Q3170KJdPE8GhMkz+VWHnas/iW1486T6/WnRCtXqpwOSMMir
         UPGuV9d9eLt0VaPCvGzFAAeqF3reb6puZlZP/QJFwvwgn5HWI1QSLWng/52CnX+RGoOY
         aqfdvZ2T7GNM5gYVGQzVTBsLJzQ8l1pnfXz/V1OQNDpsqUAGXnalzFBJqaJpBBazyIKe
         EUKg==
X-Gm-Message-State: APjAAAXA3s+8Zq1UGvTX6Fj0VGbDvj448CCLYKKeMujz/KVOWN7BG5VR
        4qP7hsbbJHF+FQeak6AhtL7qDUuvX1B8jC4JjZW8w4+Z2B8UDU5TCmq6QFZdVfTp7z/ctFlEhke
        2SJWjq9F607JN
X-Received: by 2002:a05:620a:1415:: with SMTP id d21mr15599592qkj.17.1576892992029;
        Fri, 20 Dec 2019 17:49:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBTIArtN4lEEvPhJ1OsMpqJjIbDkpETEk2hJbP6m1uKORdGncfp8pEiB1fiQ0lbIaC1pBwiQ==
X-Received: by 2002:a05:620a:1415:: with SMTP id d21mr15599581qkj.17.1576892991799;
        Fri, 20 Dec 2019 17:49:51 -0800 (PST)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id e21sm3396932qkm.55.2019.12.20.17.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 17:49:51 -0800 (PST)
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
Subject: [PATCH RESEND v2 05/17] KVM: Add build-time error check on kvm_run size
Date:   Fri, 20 Dec 2019 20:49:26 -0500
Message-Id: <20191221014938.58831-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's already going to reach 2400 Bytes (which is over half of page
size on 4K page archs), so maybe it's good to have this build-time
check in case it overflows when adding new fields.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cea4b8dd4ac9..c80a363831ae 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -338,6 +338,7 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->pre_pcpu = -1;
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
+	BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
-- 
2.24.1

