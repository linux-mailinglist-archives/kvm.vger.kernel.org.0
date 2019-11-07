Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 151DAF2BDF
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 11:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbfKGKKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 05:10:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfKGKKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 05:10:38 -0500
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66ED67C0A7
        for <kvm@vger.kernel.org>; Thu,  7 Nov 2019 10:10:38 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id b10so497274wmh.6
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 02:10:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OCIqyJJdOW00bPyctKLkzxNP0EVAczBbs1eO7W8t2tM=;
        b=fR1iY418qnY1SqGTZxoHbg0xOsXSpsGp5mtMZ1+R1MrbR5s6tWbya2DzF66Yx2Zr/v
         Fh+SkF2dE1SFfwe3QPXWyHPQ4myBp31GhGionLGVsLWGJR+KqTocuqT78LIEoJCaKhvY
         l6xguKfjBbmbo2jnBBNzsJG+RO3s83lhKOEsC2spTp+0ZDN2XfsWrl8/s8/0WFd47+Sw
         oawjFyr2v6Bkl6kvtjdXqYmfi3YPsygXjix2WlEGrUDJ2CEfNo+xcsqNj9bkk5jwPAiS
         DwkrY6eptIz+xc1MXzDTq+moZLw0q7PvHxjFuR85BiIqL42fe12a09pSkyL5/kB84Pvk
         9Ytg==
X-Gm-Message-State: APjAAAUblPHbUQ1kuAcyFaeJ3rG3EGfXXvF85a9+JVYyaBRdZZTFKtJx
        bhzd7Ph+JXLvoGsRQ6ASa3sYvfnNLNT2JGP5Yq6cQTtt53zDsLboYiO6Zjqt97rk6IYBLEeAHd7
        Xc4hzCqyq2KI0
X-Received: by 2002:a5d:6789:: with SMTP id v9mr2001967wru.344.1573121436852;
        Thu, 07 Nov 2019 02:10:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVrO1kZIfHP7MQ5tgPYumXgK/TKMlvQ8AyGBFuR4+U8dCNxxCN3OTkTO6xgcYkWl6NDneBuw==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr2001944wru.344.1573121436558;
        Thu, 07 Nov 2019 02:10:36 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y17sm1836077wrs.58.2019.11.07.02.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 02:10:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: coalesced_mmio: cleanup kvm_coalesced_mmio_init()
Date:   Thu,  7 Nov 2019 11:10:34 +0100
Message-Id: <20191107101034.29675-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Neither 'ret' variable nor 'out_err' label is really needed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 virt/kvm/coalesced_mmio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 8ffd07e2a160..00c747dbc82e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -110,14 +110,11 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct page *page;
-	int ret;
 
-	ret = -ENOMEM;
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page)
-		goto out_err;
+		return -ENOMEM;
 
-	ret = 0;
 	kvm->coalesced_mmio_ring = page_address(page);
 
 	/*
@@ -128,8 +125,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	spin_lock_init(&kvm->ring_lock);
 	INIT_LIST_HEAD(&kvm->coalesced_zones);
 
-out_err:
-	return ret;
+	return 0;
 }
 
 void kvm_coalesced_mmio_free(struct kvm *kvm)
-- 
2.20.1

