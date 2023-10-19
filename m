Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066827CFE56
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346226AbjJSPlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346349AbjJSPlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AE212F
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=myF4kySQnt1R/jNl7y+DJzz8cGVKJ4FVkI+b72NBJHs=; b=motVjdfWE1GstniTdCu1wyhH13
        qEBExY7YPMY43dkg0DEqqvbr9P7356o1yb6boWXyNWqMcVVx/4OPNZcbnpslzrsbD7zzZjOP7aYu9
        TCZ1oeIaBkooBoOYWR3KPNh4kRyJ+oHJN6nm5S+GIb7EsvBYP44PDwj1osnfpYv85OJ3oFzZoUpgq
        VQlR3J8D0afyD12EnD8A7t+S3o2mmRJuAQHycDcUTMaD3CLWvyh+bGwGV4YFBzoIEOevNkv5p7G3r
        IuUA237noQcqX9vza0iCbsgnWJCR5mhcQJKpi0PUmZBjG6pbJVYE5xyvNSBgXvjg/E9MTjWhlnVuE
        VnFlJCiA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qtV8M-007osl-TV; Thu, 19 Oct 2023 15:40:26 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8M-000PuJ-1F;
        Thu, 19 Oct 2023 16:40:26 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v2 10/24] hw/xen: populate store frontend nodes with XenStore PFN/port
Date:   Thu, 19 Oct 2023 16:40:06 +0100
Message-Id: <20231019154020.99080-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is kind of redundant since without being able to get these through
some other method (HVMOP_get_param) the guest wouldn't be able to access
XenStore in order to find them. But Xen populates them, and it does
allow guests to *rebind* to the event channel port after a reset.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/i386/kvm/xen_xenstore.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index ef8aaa4c42..61692d4489 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -1434,6 +1434,7 @@ static void alloc_guest_port(XenXenstoreState *s)
 int xen_xenstore_reset(void)
 {
     XenXenstoreState *s = xen_xenstore_singleton;
+    GList *perms;
     int err;
 
     if (!s) {
@@ -1461,6 +1462,16 @@ int xen_xenstore_reset(void)
     }
     s->be_port = err;
 
+    /* Create frontend store nodes */
+    perms = g_list_append(NULL, xs_perm_as_string(XS_PERM_NONE, DOMID_QEMU));
+    perms = g_list_append(perms, xs_perm_as_string(XS_PERM_READ, xen_domid));
+
+    relpath_printf(s, perms, "store/port", "%u", s->guest_port);
+    relpath_printf(s, perms, "store/ring-ref", "%lu",
+                   XEN_SPECIAL_PFN(XENSTORE));
+
+    g_list_free_full(perms, g_free);
+
     /*
      * We don't actually access the guest's page through the grant, because
      * this isn't real Xen, and we can just use the page we gave it in the
-- 
2.40.1

