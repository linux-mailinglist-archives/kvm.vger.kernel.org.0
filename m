Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC01A66627C
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbjAKSHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjAKSG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:06:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D943419017
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sIwFrSB3dAWRGgXHyvaeh8/GR40U/gamS+kA73hvK1o=; b=Ky+aWEKtRaDXl1E1wCUTIFPJSz
        WxWQ5X69gkSjBMuuxyCD9VtaP0ID1tlk4YG+CJB8CJQ+wmJ6aAjVYB5LOG8H3+dbHUcJ1AnZR7j5M
        HVQpgGG/FnErHlcuzAscYDG0ENQFVpTLB5aAwTivozhG+XyisZGj46XuTZCeXH3mKX8ueNKpgpWcP
        NFlCU/SxDILdl/po9tzMPR10N96RavS5vcoHoxSU/Ex2oNLZ2xqel+FOCNEvXFXkno18t4bpr/J/U
        ihOa5Q+IaMe1olRQZ1qQaT4Z2qYq40Y6iOf6IxEtEhFAEpMhdsnfL5oDNWveN0ds8NdCTmHtcOhTK
        59LqEtjg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfVA-004MOu-Vg; Wed, 11 Jan 2023 18:07:05 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfUx-0003kU-61; Wed, 11 Jan 2023 18:06:51 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 3/4] KVM: Ensure lockdep knows about kvm->lock vs. vcpu->mutex ordering rule
Date:   Wed, 11 Jan 2023 18:06:50 +0000
Message-Id: <20230111180651.14394-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230111180651.14394-1-dwmw2@infradead.org>
References: <20230111180651.14394-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Documentation/virt/kvm/locking.rst tells us that kvm->lock is taken outside
vcpu->mutex. But that doesn't actually happen very often; it's only in
some esoteric cases like migration with AMD SEV. This means that lockdep
usually doesn't notice, and doesn't do its job of keeping us honest.

Ensure that lockdep *always* knows about the ordering of these two locks,
by briefly taking vcpu->mutex in kvm_vm_ioctl_create_vcpu() while kvm->lock
is held.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 07bf29450521..5814037148bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3924,6 +3924,13 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	mutex_lock(&kvm->lock);
+
+#ifdef CONFIG_LOCKDEP
+	/* Ensure that lockdep knows vcpu->mutex is taken *inside* kvm->lock */
+	mutex_lock(&vcpu->mutex);
+	mutex_unlock(&vcpu->mutex);
+#endif
+
 	if (kvm_get_vcpu_by_id(kvm, id)) {
 		r = -EEXIST;
 		goto unlock_vcpu_destroy;
-- 
2.35.3

