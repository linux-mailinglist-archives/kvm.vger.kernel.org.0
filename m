Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398082E6F92
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 11:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgL2KKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Dec 2020 05:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgL2KKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Dec 2020 05:10:21 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1C7C061793
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:09:41 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h22so29770553lfu.2
        for <kvm@vger.kernel.org>; Tue, 29 Dec 2020 02:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Nw+eSXPW1AWQx8n0iy/pkPpHgQa7fwIT4e6iHXuq40=;
        b=oVTDL0uCKjSQUs0PeRC/TCLefaCnOJWP5lypaOS9Q38E31AFnqkbsAh2NvGS9wyunH
         CvH+0Qq9AjsaZzSzz8SOjY2733KSrxf/60DMduMrh3n/jDjaTG1JUZjLMzBpzbgYenDN
         xPGLQvJe9r38eEFnYAIUvQbxGlt9/BYKTEsE0lYwSdTyh5ghbyK/0E9o3y23lEfI+yTk
         xqJxEpFKajP2bhzp+qfZMz6dcijzVIuOXkxekmHdqzPCqKUgiOh8dmLYqqFwgARCxrIM
         +lDLo7D6I77Fe8DtheXHqZX1r3F13VTX+PH9tD3njMjZtKu5Jm2coMo30pV1U3M4KRD2
         JARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Nw+eSXPW1AWQx8n0iy/pkPpHgQa7fwIT4e6iHXuq40=;
        b=Sh12J0Cb+JZb/8I9qWCGDz36P+41upmndCNHcgk7TAF+FlTwL7+Aeg9rfQzP6xHPJ4
         xW84WepuM5d0w+dQhptT0kxoGLwFIbEKu8WLW1GWLSsbeaEnWwftwBfO90jCFoKeRQqc
         L2baZM4OcT2Z11iqq0OZY7Quj0Ay2J7og5EHqXPDTqTJRuq5FeZWm6FZxdcYfgK0mMh/
         2BEAGKgxNFCPpzkQfAiiETynD0C+Tv6+v5xBKoF6R7tcbjIxKB+do2HiM9ZDwEFSOb3q
         PC4DtHfLvIzlIsxv00tGyPaLOtVEptNPW0dvwbePpPxPztMStHRTrpeZ30+mW7Wvqf/p
         857Q==
X-Gm-Message-State: AOAM533bISzE4fu5rLGWYLatjcTtAyHh47WTMjMVU4viJ/T/P2nRZUpz
        XBBYY+uNSTnZtForA+eN7g8guSQ0aYv6OBYn
X-Google-Smtp-Source: ABdhPJzPaOUdqNHiSIFu/c/0CTBbE6BwPqzxkSdp0Y/Hjb+Mu19qwg0SOLlx/6oUzp+/dUPXb3jkyw==
X-Received: by 2002:a19:c5:: with SMTP id 188mr19555208lfa.511.1609236579434;
        Tue, 29 Dec 2020 02:09:39 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id y13sm5612901lfg.189.2020.12.29.02.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 02:09:38 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC 2/2] KVM: add initial support for ioregionfd blocking read/write operations
Date:   Tue, 29 Dec 2020 13:02:44 +0300
Message-Id: <a13b23ca540a8846891895462d2fb139ec597237.1609231374.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1609231373.git.eafanasova@gmail.com>
References: <cover.1609231373.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 virt/kvm/ioregion.c | 157 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index a200c3761343..8523f4126337 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -4,6 +4,33 @@
 #include <kvm/iodev.h>
 #include "eventfd.h"
 
+/* Wire protocol */
+struct ioregionfd_cmd {
+	__u32 info;
+	__u32 padding;
+	__u64 user_data;
+	__u64 offset;
+	__u64 data;
+};
+
+struct ioregionfd_resp {
+	__u64 data;
+	__u8 pad[24];
+};
+
+#define IOREGIONFD_CMD_READ    0
+#define IOREGIONFD_CMD_WRITE   1
+
+#define IOREGIONFD_SIZE_8BIT   0
+#define IOREGIONFD_SIZE_16BIT  1
+#define IOREGIONFD_SIZE_32BIT  2
+#define IOREGIONFD_SIZE_64BIT  3
+
+#define IOREGIONFD_SIZE_OFFSET 4
+#define IOREGIONFD_RESP_OFFSET 6
+#define IOREGIONFD_SIZE(x) ((x) << IOREGIONFD_SIZE_OFFSET)
+#define IOREGIONFD_RESP(x) ((x) << IOREGIONFD_RESP_OFFSET)
+
 void
 kvm_ioregionfd_init(struct kvm *kvm)
 {
@@ -38,10 +65,100 @@ ioregion_release(struct ioregion *p)
 	kfree(p);
 }
 
+static bool
+pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, int opt, bool resp,
+	 u64 user_data, const void *val)
+{
+	u64 size = 0;
+
+	switch (len) {
+	case 1:
+		size = IOREGIONFD_SIZE_8BIT;
+		*((u8 *)&cmd->data) = val ? *(u8 *)val : 0;
+		break;
+	case 2:
+		size = IOREGIONFD_SIZE_16BIT;
+		*((u16 *)&cmd->data) = val ? *(u16 *)val : 0;
+		break;
+	case 4:
+		size = IOREGIONFD_SIZE_32BIT;
+		*((u32 *)&cmd->data) = val ? *(u32 *)val : 0;
+		break;
+	case 8:
+		size = IOREGIONFD_SIZE_64BIT;
+		*((u64 *)&cmd->data) = val ? *(u64 *)val : 0;
+		break;
+	default:
+		return false;
+	}
+	cmd->user_data = user_data;
+	cmd->offset = offset;
+	cmd->info |= opt;
+	cmd->info |= IOREGIONFD_SIZE(size);
+	cmd->info |= IOREGIONFD_RESP(resp);
+
+	return true;
+}
+
 static int
 ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	      int len, void *val)
 {
+	struct ioregion *p = to_ioregion(this);
+	struct ioregionfd_cmd *cmd;
+	struct ioregionfd_resp *resp;
+	size_t buf_size;
+	void *buf;
+	int ret = 0;
+
+	if ((p->rf->f_flags & O_NONBLOCK) || (p->wf->f_flags & O_NONBLOCK))
+		return -EINVAL;
+	if ((addr + len - 1) > (p->paddr + p->size - 1))
+		return -EINVAL;
+
+	buf_size = max_t(size_t, sizeof(*cmd), sizeof(*resp));
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	cmd = (struct ioregionfd_cmd *)buf;
+	resp = (struct ioregionfd_resp *)buf;
+	if (!pack_cmd(cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
+		      1, p->user_data, NULL)) {
+		kfree(buf);
+		return -EOPNOTSUPP;
+	}
+
+	ret = kernel_write(p->wf, cmd, sizeof(*cmd), 0);
+	if (ret != sizeof(*cmd)) {
+		kfree(buf);
+		return (ret < 0) ? ret : -EIO;
+	}
+	memset(buf, 0, buf_size);
+	ret = kernel_read(p->rf, resp, sizeof(*resp), 0);
+	if (ret != sizeof(*resp)) {
+		kfree(buf);
+		return (ret < 0) ? ret : -EIO;
+	}
+
+	switch (len) {
+	case 1:
+		*(u8 *)val = (u8)resp->data;
+		break;
+	case 2:
+		*(u16 *)val = (u16)resp->data;
+		break;
+	case 4:
+		*(u32 *)val = (u32)resp->data;
+		break;
+	case 8:
+		*(u64 *)val = (u64)resp->data;
+		break;
+	default:
+		break;
+	}
+
+	kfree(buf);
+
 	return 0;
 }
 
@@ -49,6 +166,46 @@ static int
 ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		int len, const void *val)
 {
+	struct ioregion *p = to_ioregion(this);
+	struct ioregionfd_cmd *cmd;
+	struct ioregionfd_resp *resp;
+	size_t buf_size = 0;
+	void *buf;
+	int ret = 0;
+
+	if ((p->rf->f_flags & O_NONBLOCK) || (p->wf->f_flags & O_NONBLOCK))
+		return -EINVAL;
+	if ((addr + len - 1) > (p->paddr + p->size - 1))
+		return -EINVAL;
+
+	buf_size = max_t(size_t, sizeof(*cmd), sizeof(*resp));
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	cmd = (struct ioregionfd_cmd *)buf;
+	if (!pack_cmd(cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
+		      p->posted_writes ? 0 : 1, p->user_data, val)) {
+		kfree(buf);
+		return -EOPNOTSUPP;
+	}
+
+	ret = kernel_write(p->wf, cmd, sizeof(*cmd), 0);
+	if (ret != sizeof(*cmd)) {
+		kfree(buf);
+		return (ret < 0) ? ret : -EIO;
+	}
+
+	if (!p->posted_writes) {
+		memset(buf, 0, buf_size);
+		resp = (struct ioregionfd_resp *)buf;
+		ret = kernel_read(p->rf, resp, sizeof(*resp), 0);
+		if (ret != sizeof(*resp)) {
+			kfree(buf);
+			return (ret < 0) ? ret : -EIO;
+		}
+	}
+	kfree(buf);
+
 	return 0;
 }
 
-- 
2.25.1

