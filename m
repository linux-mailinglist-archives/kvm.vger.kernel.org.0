Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE4F2940FF
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395098AbgJTRBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 13:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395094AbgJTRBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 13:01:10 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65653C0613CE
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1325325pll.11
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 10:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9vfxdnRCLsliVllqt/rhZ7KYxjMhIVE68F6rGYVRGI8=;
        b=c4SWT7SE6bL+6PNYDzpJ6TlgbtT73FuFzyvk9J1igWT3KUmasgTurJVm/AIkw3em+h
         MIwe8tfpZu/kigbbr3k5Vct5Pkl65y+DGZZLCmueW5xKQMFgiojz2BupFYiqNGXkl3eB
         bra6py56A4YVL8MTB8KkXcwYVVyRF5CV+nYPbg9D/1ium83fI7UrGIlQ6ZrPfUNxrvYX
         xWSCsaetiSB05dKeeNJoLcZnfxzy1fmVnqG31tqd/0XphHsrGDYeACt0PbJ9V6pkJ3Yc
         TwXKBmaqKi1pkKaoF/NAWDlXsu19WM1H6BooydwZ4tSA2HSpfY2cWZsk+jpsEz/8HlWD
         NUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9vfxdnRCLsliVllqt/rhZ7KYxjMhIVE68F6rGYVRGI8=;
        b=omrD7sJ54o6nn2wE4c1C6JGySFd6ibQqj67DKUCUiDa9ryhCPanQCM7DE0dpQuDLrI
         gDGHUF06lw2wVb79EBRt/vnVq9HbUYcgA2GU8UwB+a5kFd3OaJDkhjhkF5ZTvU9u3NQo
         KhaYUJwgYt5Au7Rx0bkpMo7ZoKGPxBmasorFeeuSFyEZRKQcLa9GupTccu6Ceq/f02BG
         8BXEEXby1odtj7HrBbHmJfC90la+oqONgLGqpo1EvFzYb+n51YJCI6/xSEqdzrzlksRy
         scg/kXk1vTE1tp65C1pQZnp+X3lx5TICfmFZQ2S2lVAd+2cdiHndHo/TjwfprIdA0P5q
         L8og==
X-Gm-Message-State: AOAM531jMmfNQkUdYsenbwQZESGvnFZeuKTTKL4UUh3RIwbAqPzMqRZf
        WClFi29dBjP+q0u/5lpSL7seUianbL0=
X-Google-Smtp-Source: ABdhPJwiTW478eHb035jsmIY5P9juzumk5Lm7S0w1b/UrmSeJgsmdmd/ZaKLAyxhaadizHpiCeJt9g==
X-Received: by 2002:a17:90a:bb0e:: with SMTP id u14mr3608130pjr.112.1603213269952;
        Tue, 20 Oct 2020 10:01:09 -0700 (PDT)
Received: from localhost.localdomain ([103.248.31.132])
        by smtp.googlemail.com with ESMTPSA id x29sm2766161pfp.152.2020.10.20.10.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 10:01:09 -0700 (PDT)
From:   Amey Narkhede <ameynarkhede03@gmail.com>
To:     qemu-devel@nongnu.org, ameynarkhede03@gmail.com
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/2] kvm: Add ioeventfd read test code
Date:   Tue, 20 Oct 2020 22:30:56 +0530
Message-Id: <20201020170056.433528-3-ameynarkhede03@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020170056.433528-1-ameynarkhede03@gmail.com>
References: <20201020170056.433528-1-ameynarkhede03@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kvm_set_ioeventfd_read and
dummy_notifier_read functons to test ioeventfd
read support. When the guess writes to address
provided in kvm_set_ioeventfd_read function,
dummy_notifier_read prints to stdio.

Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
---
 accel/kvm/kvm-all.c | 55 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9ef5daf4c5..357e74d84c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1006,6 +1006,43 @@ static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
     return val;
 }
 
+static void dummy_notifier_read(EventNotifier *n)
+{
+    printf("Received ioeventfd read event\n");
+    event_notifier_test_and_clear(n);
+}
+
+static int kvm_set_ioeventfd_read(int fd, hwaddr addr, uint64_t val,
+				  uint64_t size, bool datamatch)
+{
+	int ret;
+	struct kvm_ioeventfd ioevent = {
+        	.datamatch = datamatch ? adjust_ioeventfd_endianness(val, size) : 0,
+		.dataread = val,
+		.addr = addr,
+		.len = size,
+		.flags = KVM_IOEVENTFD_FLAG_DATAREAD,
+		.fd = fd,
+	};
+
+	if (!kvm_enabled()) {
+		return -ENOSYS;
+	}
+
+	if (datamatch) {
+            ioevent.flags |= KVM_IOEVENTFD_FLAG_DATAMATCH;
+	}
+
+	ret = kvm_vm_ioctl(kvm_state, KVM_IOEVENTFD, &ioevent);
+
+	if (ret < 0) {
+		return -errno;
+	}
+
+	return 0;
+}
+
+
 static int kvm_set_ioeventfd_mmio(int fd, hwaddr addr, uint32_t val,
                                   bool assign, uint32_t size, bool datamatch)
 {
@@ -2012,6 +2049,7 @@ static int kvm_init(MachineState *ms)
     KVMState *s;
     const KVMCapabilityInfo *missing_cap;
     int ret;
+    int efd = -1;
     int type = 0;
     const char *kvm_type;
     uint64_t dirty_log_manual_caps;
@@ -2253,6 +2291,22 @@ static int kvm_init(MachineState *ms)
     }
 
     cpus_register_accel(&kvm_cpus);
+
+    EventNotifier *e = g_malloc0(sizeof(EventNotifier));
+    ret = event_notifier_init(e, false);
+    if (ret < 0) {
+	printf("Failed to initialize EventNotifier\n");
+    }
+    else {
+        AioContext *ctx = qemu_get_aio_context();
+        efd = event_notifier_get_fd(e);
+        aio_set_event_notifier(ctx, e, false, dummy_notifier_read, NULL);
+        ret = kvm_set_ioeventfd_read(efd, 0xff01003f, 123, 8, false);
+        if (ret < 0)
+            printf("ioeventfd read failed\n");
+    }
+
+
     return 0;
 
 err:
@@ -2268,6 +2322,7 @@ err:
     return ret;
 }
 
+
 void kvm_set_sigmask_len(KVMState *s, unsigned int sigmask_len)
 {
     s->sigmask_len = sigmask_len;
-- 
2.28.0

