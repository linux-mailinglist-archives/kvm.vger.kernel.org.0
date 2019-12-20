Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FDF128384
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLTVCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52017 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727569AbfLTVB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 16:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=eso8JP2CrtBIIe2HBbUEfnEm1cYTcKMv0sqOhrbp6Ul+SBv5TAJp64WSmR53fESRekb0GA
        JnfKbqYcN0FFVfdX20RgLOLNu7li5KoZUFat5MmlW/dJvAlyZuLWH56PWKwA6gkNdh9gHF
        xJftIqrHbhqKWvGPo8shhZ4TiYJO4qo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-5UuFT7BUOr67u9u_WIhs9w-1; Fri, 20 Dec 2019 16:01:57 -0500
X-MC-Unique: 5UuFT7BUOr67u9u_WIhs9w-1
Received: by mail-qt1-f200.google.com with SMTP id t4so6800591qtd.3
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:01:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=bTXgv9m1Gea3lKH3ueHBoqYIVg6EX0DPlfpYR6G9DmXGwme6YFyFdnlf1MgEOFU7ji
         cSKrEBmub9pkUgjNJf1EG4QyzGjOh/KOYFBhyOz9EONTWkLPwRCe3WP6JajWMAEruD3L
         IWkoJwuhNzkhmjRzWQ+FMHHD4bFY8cdU2v7l81FKUKEFA0TtZ0RQx2FbnoKkqT+2Nxz9
         YzFNj4Pk2wJKgzAEhmQ5yyIgB+Sa092CCQZl0ZoRyxM8w0YyZlGf8Qw15oa8VeIqmDQa
         Rd/ogGvdvJU8XBl3KxNCVcaswK4yenYdk5Ur43TK4rfVwcubngTDaxo4jeGjNZPxl4vM
         ieCQ==
X-Gm-Message-State: APjAAAUpJyaZeg2Ei1S9sWFK9s+87C8pSwXtPMvdThD0xUKOUAQT14BH
        WL2E4c+Djp/8copzV2WuYheKY3C+2V+KU6LizX467NYWhHtxOiUBKutw5U2CPIP/spsgrfwyFeF
        WL16ecvIwD3+z
X-Received: by 2002:aed:2f01:: with SMTP id l1mr13185487qtd.391.1576875717093;
        Fri, 20 Dec 2019 13:01:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwUjglzhpKCa6NEkGoo+WgRdTpi2Yj49KnA848sGtgvwu9B6qCZKB1sG+DNQuHerE0WraffwA==
X-Received: by 2002:aed:2f01:: with SMTP id l1mr13185466qtd.391.1576875716921;
        Fri, 20 Dec 2019 13:01:56 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:56 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 05/17] KVM: Add build-time error check on kvm_run size
Date:   Fri, 20 Dec 2019 16:01:35 -0500
Message-Id: <20191220210147.49617-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
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

