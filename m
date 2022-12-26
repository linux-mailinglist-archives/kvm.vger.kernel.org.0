Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0952065625E
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 13:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbiLZMDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 07:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiLZMDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 07:03:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76896302
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 04:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=T09LeAy9NPz3ILbZmugbi6Et0fBLJJYdlvloVwBwbyQ=; b=GzfL7Tax7m0tUQ9fBD5sfN8KQN
        trFKKC97Z/nqo7yCK9L/DA9nDxpztOGO8/veeTIV6qx1L37Kj5Yx7LBWmxmAIIjL0jjcGLgurSCRR
        1hIWkyyPXQpfS7X/zILA+KT4fgrQVczUKVo41q9J2I2FwxD80U3O7faha3jGqIbZfbWmkCrwWjh9G
        hgl4Yor1yZY0+MH2uScBGlkUb9bGv6aD7hnEMmgt50iJj5aeMWNK2AIhdNkEjwhn3U7ddkyS4cNQa
        d7v3cDhOG1IOUCzKkXarXDH/4cLNh9XemvZmvbQ/FnWd9M3mfGTHEv6eg5+65KMzPTTccFRSfuMLt
        EfYGVH6w==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCZ-006e9r-PQ; Mon, 26 Dec 2022 12:03:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p9mCO-004ilu-QB; Mon, 26 Dec 2022 12:03:20 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>
Subject: [PATCH 4/6] KVM: x86/xen: Simplify eventfd IOCTLs
Date:   Mon, 26 Dec 2022 12:03:18 +0000
Message-Id: <20221226120320.1125390-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221226120320.1125390-1-dwmw2@infradead.org>
References: <b36fa02bc338d6892e63e37768bf47f035339e30.camel@infradead.org>
 <20221226120320.1125390-1-dwmw2@infradead.org>
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

From: Michal Luczaj <mhal@rbox.co>

Port number is validated in kvm_xen_setattr_evtchn().
Remove superfluous checks in kvm_xen_eventfd_assign() and
kvm_xen_eventfd_update().

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Message-Id: <20221222203021.1944101-3-mhal@rbox.co>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 9b75457120f7..bddbe5ac5cfa 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1810,9 +1810,6 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	struct evtchnfd *evtchnfd;
 	int ret;
 
-	if (!port || port >= max_evtchn_port(kvm))
-		return -EINVAL;
-
 	/* Protect writes to evtchnfd as well as the idr lookup.  */
 	mutex_lock(&kvm->lock);
 	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
@@ -1858,12 +1855,9 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
 {
 	u32 port = data->u.evtchn.send_port;
 	struct eventfd_ctx *eventfd = NULL;
-	struct evtchnfd *evtchnfd = NULL;
+	struct evtchnfd *evtchnfd;
 	int ret = -EINVAL;
 
-	if (!port || port >= max_evtchn_port(kvm))
-		return -EINVAL;
-
 	evtchnfd = kzalloc(sizeof(struct evtchnfd), GFP_KERNEL);
 	if (!evtchnfd)
 		return -ENOMEM;
-- 
2.35.3

