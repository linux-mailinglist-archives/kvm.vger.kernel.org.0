Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB217D7011
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234704AbjJYOvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbjJYOvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0846B0
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cMQamAmGxVX8j1TYaTFUxDpxUmOm6N6treNgi5dENCI=; b=WtDuCSvr5Q0uexpCx5QwfNxVZy
        ROoD7PbXDpLBTHv10a4sb52qOcYxP7sVaVH/NJGwCgJ77PtptHAmxIq1lmRxaLvn1/sAI4mNcVa5y
        12MBgl4J0jy+1GLBWvXaSTgc4K1BCjA/Yzihw3gyve96vcuHO9XMDH9OrxcLxgRE8veib5GQ8ptb2
        hY7TYHtsyq18aAgKXiMYIlQ+358roX1Kia+c+gpKgmAlDKQ8yBhxawYBqJm5uBrelE/kfRoCjO185
        nYGVKukjvboJ/wX9kHgvqrqfE/NVMb6HDHzCd7q1HBeO/OLNaZ1qtk3OhrwOmFOTaGnRChQkaQuje
        9y7XfXuw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvfDY-009Nmf-Ta; Wed, 25 Oct 2023 14:50:44 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDY-002dEJ-0I;
        Wed, 25 Oct 2023 15:50:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v3 06/28] hw/xen: take iothread mutex in xen_evtchn_reset_op()
Date:   Wed, 25 Oct 2023 15:50:20 +0100
Message-Id: <20231025145042.627381-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
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

The xen_evtchn_soft_reset() function requires the iothread mutex, but is
also called for the EVTCHNOP_reset hypercall. Ensure the mutex is taken
in that case.

Fixes: a15b10978fe6 ("hw/xen: Implement EVTCHNOP_reset")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/i386/kvm/xen_evtchn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 3d6f4b4a0a..b2b4be9983 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -1135,6 +1135,7 @@ int xen_evtchn_reset_op(struct evtchn_reset *reset)
         return -ESRCH;
     }
 
+    QEMU_IOTHREAD_LOCK_GUARD();
     return xen_evtchn_soft_reset();
 }
 
-- 
2.40.1

