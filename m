Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A852320A32
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 13:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhBUML5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 07:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhBUMLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 07:11:54 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD55C061574
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:13 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id g1so41272421ljj.13
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TQuhSuGZ+mKlsZSP2ivNdXF1vnj7kB1aS+u79shP5tY=;
        b=fCvC53zD00KR1tYz1c3TCCyZQIzAtoYXP1MA1fH7Mw2ILg6jyjw/iQ5hvdrehrQLO1
         Vad/Re8+fv1f4FKQWg6DIl2KMwFsNulJkiBQ8gMzKAKXpIA07W+BGHgdd7VTc/7lYppb
         SX4zBSuyGhFqb+Ha9Z/daxTW1011Uas4c7HYE59NHzSyxU2HshmpEHr+oahJFjQ+C5w2
         YcydsvQ8lbogXDBBgselTqNTbt33k6QujkakONwT/vBEq+V7dvRYAfgjTrseWa/fFZOl
         7jzUxUM4bj52WLcUl7wnOv4hdxaBZADsc+ItF0QjjfY9ZlhVJnJGqIjIjMYSJCw+h+MA
         plrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TQuhSuGZ+mKlsZSP2ivNdXF1vnj7kB1aS+u79shP5tY=;
        b=nObvlO61r2fLah7+NPqxeiGt7OlG4YMfsJq6C/ip6d62nZmKMmQAzt3+Ei61KNs+ux
         do+sFQnIVsPxtfSR4dwnu8BS+0QAgqN3DHNUXQ7U7ORyrRd5xNrQpbMbIJsw46HJRuVf
         vRJbzgOVH+/s+/+1cWj7lhCpO5+4n0myl0PipU8LkJXQs4RehkXsEcXEOkN3/7M75cOH
         T1VsxURyRtmkM0nPzpovsoDip3V9NIr+kJW1FbNfWjJ+N2IVoNxxfhT/aHywXND1HjsC
         yxzz/GkNFLjxhYg0HakBSDwHRtJgErl1IMEWs1h4FdvzyyI3GNM5f+nV0/DUn5onTraX
         QQ8w==
X-Gm-Message-State: AOAM533yZmFVfNoUTbe3tR73461eyIJPqOrM6J5j2hm5qQTgqwP9CdXH
        POOPAv3ONE3wOZVDrLygJAion8jLNH1zbrol
X-Google-Smtp-Source: ABdhPJw5h0UBuW4StEwspWfbFq1J8eQ42K1WV/BO/MLa0arZ3vTUxNTkGlAPqGCIrdG8WWgiEpMKPA==
X-Received: by 2002:a2e:6a11:: with SMTP id f17mr11795841ljc.14.1613909472134;
        Sun, 21 Feb 2021 04:11:12 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id q6sm1547715lfn.23.2021.02.21.04.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:11:11 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v3 3/5] KVM: implement wire protocol
Date:   Sun, 21 Feb 2021 15:04:39 +0300
Message-Id: <dad3d025bcf15ece11d9df0ff685e8ab0a4f2edd.1613828727.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ioregionfd blocking read/write operations.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
v3:
 - change wire protocol license
 - remove ioregionfd_cmd info and drop appropriate macros
 - fix ioregionfd state machine
 - add sizeless ioregions support
 - drop redundant check in ioregion_read/write()

 include/uapi/linux/ioregion.h |  30 +++++++
 virt/kvm/ioregion.c           | 162 +++++++++++++++++++++++++++++++++-
 2 files changed, 190 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/ioregion.h

diff --git a/include/uapi/linux/ioregion.h b/include/uapi/linux/ioregion.h
new file mode 100644
index 000000000000..58f9b5ba6186
--- /dev/null
+++ b/include/uapi/linux/ioregion.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
+#ifndef _UAPI_LINUX_IOREGION_H
+#define _UAPI_LINUX_IOREGION_H
+
+/* Wire protocol */
+
+struct ioregionfd_cmd {
+	__u8 cmd;
+	__u8 size_exponent : 4;
+	__u8 resp : 1;
+	__u8 padding[6];
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
+#endif
diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index e09ef3e2c9d7..1e1c7772d274 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <kvm/iodev.h>
 #include "eventfd.h"
+#include <uapi/linux/ioregion.h>
 
 void
 kvm_ioregionfd_init(struct kvm *kvm)
@@ -40,18 +41,175 @@ ioregion_release(struct ioregion *p)
 	kfree(p);
 }
 
+static bool
+pack_cmd(struct ioregionfd_cmd *cmd, u64 offset, u64 len, u8 opt, u8 resp,
+	 u64 user_data, const void *val)
+{
+	switch (len) {
+	case 0:
+		break;
+	case 1:
+		cmd->size_exponent = IOREGIONFD_SIZE_8BIT;
+		break;
+	case 2:
+		cmd->size_exponent = IOREGIONFD_SIZE_16BIT;
+		break;
+	case 4:
+		cmd->size_exponent = IOREGIONFD_SIZE_32BIT;
+		break;
+	case 8:
+		cmd->size_exponent = IOREGIONFD_SIZE_64BIT;
+		break;
+	default:
+		return false;
+	}
+
+	if (val)
+		memcpy(&cmd->data, val, len);
+	cmd->user_data = user_data;
+	cmd->offset = offset;
+	cmd->cmd = opt;
+	cmd->resp = resp;
+
+	return true;
+}
+
+enum {
+	SEND_CMD,
+	GET_REPLY,
+	COMPLETE
+};
+
+static void
+ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa_t addr, u8 state, void *val)
+{
+	vcpu->ioregion_ctx.is_interrupted = true;
+	vcpu->ioregion_ctx.val = val;
+	vcpu->ioregion_ctx.state = state;
+	vcpu->ioregion_ctx.addr = addr;
+	vcpu->ioregion_ctx.in = in;
+}
+
 static int
 ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	      int len, void *val)
 {
-	return -EOPNOTSUPP;
+	struct ioregion *p = to_ioregion(this);
+	union {
+		struct ioregionfd_cmd cmd;
+		struct ioregionfd_resp resp;
+	} buf;
+	int ret = 0;
+	int state = SEND_CMD;
+
+	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
+		vcpu->ioregion_ctx.is_interrupted = false;
+
+		switch (vcpu->ioregion_ctx.state) {
+		case SEND_CMD:
+			goto send_cmd;
+		case GET_REPLY:
+			goto get_repl;
+		default:
+			return -EINVAL;
+		}
+	}
+
+send_cmd:
+	memset(&buf, 0, sizeof(buf));
+	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
+		      1, p->user_data, NULL))
+		return -EOPNOTSUPP;
+
+	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
+	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
+	if (signal_pending(current) && state == SEND_CMD) {
+		ioregion_save_ctx(vcpu, 1, addr, state, val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.cmd)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+	if (!p->rf)
+		return 0;
+
+get_repl:
+	memset(&buf, 0, sizeof(buf));
+	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+	state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
+	if (signal_pending(current) && state == GET_REPLY) {
+		ioregion_save_ctx(vcpu, 1, addr, state, val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.resp)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+
+	memcpy(val, &buf.resp.data, len);
+
+	return 0;
 }
 
 static int
 ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		int len, const void *val)
 {
-	return -EOPNOTSUPP;
+	struct ioregion *p = to_ioregion(this);
+	union {
+		struct ioregionfd_cmd cmd;
+		struct ioregionfd_resp resp;
+	} buf;
+	int ret = 0;
+	int state = SEND_CMD;
+
+	if (unlikely(vcpu->ioregion_ctx.is_interrupted)) {
+		vcpu->ioregion_ctx.is_interrupted = false;
+
+		switch (vcpu->ioregion_ctx.state) {
+		case SEND_CMD:
+			goto send_cmd;
+		case GET_REPLY:
+			goto get_repl;
+		default:
+			return -EINVAL;
+		}
+	}
+
+send_cmd:
+	memset(&buf, 0, sizeof(buf));
+	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
+		      p->posted_writes ? 0 : 1, p->user_data, val))
+		return -EOPNOTSUPP;
+
+	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
+	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
+	if (signal_pending(current) && state == SEND_CMD) {
+		ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
+		return -EINTR;
+	}
+	if (ret != sizeof(buf.cmd)) {
+		ret = (ret < 0) ? ret : -EIO;
+		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+	}
+
+get_repl:
+	if (!p->posted_writes) {
+		memset(&buf, 0, sizeof(buf));
+		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+		state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
+		if (signal_pending(current) && state == GET_REPLY) {
+			ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
+			return -EINTR;
+		}
+		if (ret != sizeof(buf.resp)) {
+			ret = (ret < 0) ? ret : -EIO;
+			return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		}
+	}
+
+	return 0;
 }
 
 /*
-- 
2.25.1

