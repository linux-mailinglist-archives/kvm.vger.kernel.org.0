Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A147CAD44
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbjJPPT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbjJPPTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB0BF9
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8ikJQCC5TLkL7JR5JlTU3UpA6g8LaKWjgM9/evGEzFk=; b=aGOU43EkvyJiadbd3LlgugWndr
        4xurUA890xm0/ENhk99UVqAb54O6T00LyeHtXfR8m3GM6lFk6OtKRHZ5HDxMqzKrpTPqvg5curQTr
        rIV6Rucgz20nRUsiqKnlZowMUo/NLQs17ZwN1GSv1fANshFRCM9lfJKWuQM8Ra8d0q9BT36RFta0K
        HgM66p0WtsRQkI9a/yI/ofe75YSiQI0/JmLUayOl4LbMquRoXLqmWyDFtxA6W3xa50XAID32EGqMX
        D1y4MMKSArdJ+xYoB6kSbjUQ7fDqJ6/e+9bWR4mjrbKDiSh7b0s3OvJc+W87KuuuGX5pAcILS2i5L
        20Sx+dJw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0067AK-2I;
        Mon, 16 Oct 2023 15:19:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNC-0005ni-0J;
        Mon, 16 Oct 2023 16:19:14 +0100
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
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 10/12] hw/xen: automatically assign device index to console devices
Date:   Mon, 16 Oct 2023 16:19:07 +0100
Message-Id: <20231016151909.22133-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Now that we can reliably tell whether a given device already exists, we
can allow the user to add console devices on the command line with just
'-device xen-console,chardev=foo'.

Start at 1, because we can't add the *primary* console; that's special
because the toolstack has to set up the guest end of that.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/char/xen_console.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/hw/char/xen_console.c b/hw/char/xen_console.c
index 2825b8c511..1a0f5ed3e1 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -333,6 +333,22 @@ static char *xen_console_get_name(XenDevice *xendev, Error **errp)
 {
     XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
 
+    if (con->dev == -1) {
+        char name[11];
+        int idx = 1;
+
+        /* Theoretically we could go up to INT_MAX here but that's overkill */
+        while (idx < 100) {
+            snprintf(name, sizeof(name), "%u", idx);
+            if (!xen_backend_exists("console", name)) {
+                con->dev = idx;
+                return g_strdup(name);
+            }
+            idx++;
+        }
+        error_setg(errp, "cannot find device index for console device");
+        return NULL;
+    }
     return g_strdup_printf("%u", con->dev);
 }
 
-- 
2.40.1

