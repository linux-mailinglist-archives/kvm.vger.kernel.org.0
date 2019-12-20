Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E491283BF
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfLTVRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:17:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727632AbfLTVQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:16:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576876608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=HMekUgRCWD9Gxpup3oXHh6jBbxI2Q9JFTM2nV18c3LO3xtuppTYRFoD0YOu6hhyvHvcucT
        rrbQb38KbGYkilRcjhuFn+DC25PVem4SuCnHThCTYsxJ0/nkJagh5AMRlpw87Z9GeuzHaF
        l8614txs2Nna8PKYjygstASQR49+//s=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-jpYC070IO3abGVJuLeLv-g-1; Fri, 20 Dec 2019 16:16:47 -0500
X-MC-Unique: jpYC070IO3abGVJuLeLv-g-1
Received: by mail-qt1-f199.google.com with SMTP id g21so4135757qtq.18
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtGsufOEBQRYi5aVidxZ4SgIBK6STwpDg+qKmGEtjBY=;
        b=tNvLDMinA8IHJqZPXgQPI1xWn7z53dLg1GjqEuHxGFgbSGPzpMZgS8hi3lPirn3uXs
         0WY6Ox7iYI06Nf7Ehw4o8BSRkjxsuLM+f4H0s6C62zLU2B4GYqrDdiCuW5y1moR4ru99
         cJ8Ux4CMTJ9vaYivFqrHZyDbQpPbjKb1E9gIB16fFkTMcYMh0skbf0iKY/SBblpIx+hi
         Mky/JIUhseJdiBo/ayzHYMJxVdLt+Rhdo2h7Z9D/MspDu6MnIj6WXBCoowrikTOcx4vK
         v0xTsyymgj7Mw0MwIx80BHwexma2Xs1Xa14jjqKCWnVUKZ9uNxUtnG2yxYYZKhWN/KDf
         3Eyw==
X-Gm-Message-State: APjAAAXyC0LuXTw+HF3heHHJtBaPpry+NRhkFGbMO+YR/PYxKkyed80z
        9z+bm2dT98zVHI+okYtwhB6vNBOC2sZsAdnL9VtlPjFES19b9VK6kwN6fvYCHZfHDjn4NgW/x3H
        Ipu58d23UOXft
X-Received: by 2002:ac8:21ad:: with SMTP id 42mr13496928qty.109.1576876605306;
        Fri, 20 Dec 2019 13:16:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqyxJfdY2npnw+WJJ9LGUDhDJ3GdAKvxfRcNwnEPLa3VNxEWmU6aap1rDqvacndG3g4E/rZL+Q==
X-Received: by 2002:ac8:21ad:: with SMTP id 42mr13496910qty.109.1576876605131;
        Fri, 20 Dec 2019 13:16:45 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id d25sm3385231qtq.11.2019.12.20.13.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:16:44 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v2 05/17] KVM: Add build-time error check on kvm_run size
Date:   Fri, 20 Dec 2019 16:16:22 -0500
Message-Id: <20191220211634.51231-6-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220211634.51231-1-peterx@redhat.com>
References: <20191220211634.51231-1-peterx@redhat.com>
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

