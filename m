Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE3B65473D
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 21:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235065AbiLVUhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 15:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbiLVUg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 15:36:56 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B021802
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 12:36:54 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJ9-002XCR-SJ
        for kvm@vger.kernel.org; Thu, 22 Dec 2022 21:36:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=d/eoFneG2urlmXWBt8PGcqdVYwM2kJS6R5trW3kXGkw=; b=gVlt0/rvrWCOqTHQpbnKuB7sXS
        T+WBvu+MoUPUffKrNkD3aF/H8S0/j7vJE7Gfo8F/jOmJ9VIcIZe63OLFCFXY97u2Hw33pE8W8wU5r
        L2aT6Xs/EphUUX5JlX7a8Wqwy0v+hjhv2OF91fYJoARtQ9XH4qWUzXdNId2rSUjrFxGVlT7gaYgzb
        OLlDOQwvNkackM5BOk96UYOVMT1UyxNblyPeCgNgh/Em4ak7AR9V3U9SNYs71Y7tn7aK1csFfOGn0
        CJlLJ9IvGtQkgEMacT7VxxSgIG4VhVzfGMZv7ZIlDS2cqKE5/TQCob7WcW7xqmb4icMtl65aCOwN8
        FY+qGigA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p8SJ7-0005EE-29; Thu, 22 Dec 2022 21:36:49 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p8SJ4-0007g4-7W; Thu, 22 Dec 2022 21:36:46 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 2/2] KVM: x86/xen: Simplify eventfd IOCTLs
Date:   Thu, 22 Dec 2022 21:30:21 +0100
Message-Id: <20221222203021.1944101-3-mhal@rbox.co>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221222203021.1944101-1-mhal@rbox.co>
References: <20221222203021.1944101-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Port number is validated in kvm_xen_setattr_evtchn().
Remove superfluous checks in kvm_xen_eventfd_assign() and
kvm_xen_eventfd_update().

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 arch/x86/kvm/xen.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8e17629e5665..87da95ceba92 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1828,9 +1828,6 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
 	int ret = -EINVAL;
 	int idx;
 
-	if (!port || port >= max_evtchn_port(kvm))
-		return -EINVAL;
-
 	idx = srcu_read_lock(&kvm->srcu);
 
 	mutex_lock(&kvm->lock);
@@ -1880,12 +1877,9 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
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
2.39.0

