Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E641F7CFE3C
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346386AbjJSPlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346361AbjJSPlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD629E
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jF67pHzxnrAWKEiszZxt5RKIgpusteGMnWw5yDJqImc=; b=imohxcfvgtCWq+2zIFKG49ThyV
        XP3T0mbUzGafIoUgVEIf2465cbSeAm78X1hwmUxQahR16j7YiaU4r0Gk2qVLKbmHzaZVMBYb+A+UH
        19tWH9EOZYj7xm2ZyAHOAU+Oyb5chRdqPvM9ERgCQWIpvyTuq2IBluPudM0rAaGlDAMqZjkEli+RS
        YpRi2jDv2eTzGGsc+5wCfgmtOS5HAHxT9wM80mUGHemr5aAQ/ItWqmoFJ6HYSwsPZlMEWszuVQlDt
        2DjW5zMibQLcUhji1knXOysxeWn2uzpvR108GmHMt2vpyQopheQTAB7sN5iR1UN0GQOFkwVEIS3f9
        R4Td0/QQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qtV8N-007ot2-OQ; Thu, 19 Oct 2023 15:40:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8N-000PvA-1E;
        Thu, 19 Oct 2023 16:40:27 +0100
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
Subject: [PATCH v2 22/24] tests/avocado: switch to using xen-net-device for Xen guest tests
Date:   Thu, 19 Oct 2023 16:40:18 +0100
Message-Id: <20231019154020.99080-23-dwmw2@infradead.org>
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

Fix the filename in the MAINTAINERS file too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 MAINTAINERS                    | 2 +-
 tests/avocado/kvm_xen_guest.py | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9bd4fe378d..d74043d8a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -476,7 +476,7 @@ S: Supported
 F: include/sysemu/kvm_xen.h
 F: target/i386/kvm/xen*
 F: hw/i386/kvm/xen*
-F: tests/avocado/xen_guest.py
+F: tests/avocado/kvm_xen_guest.py
 
 Guest CPU Cores (other accelerators)
 ------------------------------------
diff --git a/tests/avocado/kvm_xen_guest.py b/tests/avocado/kvm_xen_guest.py
index 5391283113..f098028eeb 100644
--- a/tests/avocado/kvm_xen_guest.py
+++ b/tests/avocado/kvm_xen_guest.py
@@ -61,7 +61,7 @@ def run_and_check(self):
                          '-append', self.kernel_params,
                          '-drive',  f"file={self.rootfs},if=none,format=raw,id=drv0",
                          '-device', 'xen-disk,drive=drv0,vdev=xvda',
-                         '-device', 'virtio-net-pci,netdev=unet',
+                         '-device', 'xen-net-device,netdev=unet',
                          '-netdev', 'user,id=unet,hostfwd=:127.0.0.1:0-:22')
 
         try:
-- 
2.40.1

