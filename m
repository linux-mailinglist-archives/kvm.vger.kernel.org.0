Return-Path: <kvm+bounces-44159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4603EA9B086
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 336E77AA6C4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0643728CF5E;
	Thu, 24 Apr 2025 14:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QSVzhmLG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6447289364
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504049; cv=none; b=UP9gG1eyXxvXfQjZXBL+XiJS2qB8p3RZ3VA95BqkapKx6ZC4BmJ1gRU5n1U/hHRMDu6ASwqDm2yCWS6TeUG1yNGxEuWgOquLzgWXHnpaayai0ccmAfH4wZ7iijBHf89JWo97LJ/G01KgPQBV+CCsw2WMuoDb/Tp5yUFCgG7QxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504049; c=relaxed/simple;
	bh=m+fPEAqeKx8MI3a+lqdiH9/ulP+VSGYzhW8y82AELSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GU5az0BY3FLKOXauP+uJVDVyxPm09ORxyBZq11OdaYiLYzwhWNzOLoiZfoqKGDdJabDuXYwQ34lzePcBsbSwRlIthcTtbOW6CpJ+rAJ+xEheMDTnxQW0mrE+XbtfBxOWffJ6Xq8P4w5CBF1vyTfUJTUqsiS+VYYr+rnqjut6yEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QSVzhmLG; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so877759f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504044; x=1746108844; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+XE4xl5smx9gWubImYnQvAwnhzC9G4S+d/giF3voQDM=;
        b=QSVzhmLG80Fx0P05gKPq2TWi04hwkFYKyLuhUtoU4bhDSfHBBssAdoNA1EsFtqRqMb
         krd4u2GshbDYbYBaOEvxEIh/a3rYMWfdSym4kAhgTHT9hbzXRC+cWulnVsKu9l9xe7fN
         pwfo/P5YhTjdzA6a0BH8jCZEuKy+4NkyumE4WtXIoY6vGSZfVuyfqGJlq7+QqyWpX5aU
         Vq6y+p72perGggywfEZRwaHYBC3pRyljQ6h/CBeyoONmdVAkrSzBqN1cZzIC35vbYd+t
         ns1rQajDhaC1yX+Zuowhp4FtD8MgA2+69cQmTHE9dQzuSZ2EqeM+fLsiCI/ov9l77cdD
         b7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504044; x=1746108844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+XE4xl5smx9gWubImYnQvAwnhzC9G4S+d/giF3voQDM=;
        b=cqkji5EFf1s62doaqmQTT2VUWUs42TrWZ22NdTzSpCwPeNl0PnglWnIKHnUgr40q4I
         rB2jdyiOHTlAtjGMoidE1dioVHZfeZKIOva3gehdaQRm4gQ18TDs4RbnKpfOcGCUoF3S
         YJrKK44fPEs8uH0osghMl3mdC6BE6g7YfMJayMbztWiv7o7NHvRV+tk8EiZRpjmNJ9Qm
         x+4BoIkLdPdpvz79AnZ5Y/2eWo2dZ8y/8E6vQbkQ/uPPA8NfTBzOOoKtu698qKVr3qry
         9fJUBXiXY7l79IEGJUUMgc8QJ8XVOpqNLrxMSnhIpM11BOQmbW1OWyhErZX5hmNZlOVk
         nboA==
X-Forwarded-Encrypted: i=1; AJvYcCWfvPL7XX4puAeNgXtAueHq7VChiUtr9DcHCUyd3X2zlidwRZm5u06hNXBmDicTQC4NFUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcATOuJG98VNImNQCYrKja1M5NNvT6uZ40IaYsDrCIjBVcK6n7
	ZYm6qcv/XbgB+jPkZRWs2vk5CpjTziwk2OqOPFHkCYqDXBkysg8eJyKJXpbvaF8=
X-Gm-Gg: ASbGncv/OAs84QTqiFfWY1wYnyf3Hh8Umik7zJFQzqMzbXr5Dac4vlv+ve7VzoR5tXe
	HuRLZQ1KYSdzti+yFfXwJTVCJev2n4EhDA7IgHF9upKRGwj+iVL0lNAsSyqA6hXiTPqB5VykarR
	3RM5uu3dTZBzWWb5SrdMSUGe6iF2vWcGFqcueH7QK3gzEZU/JWaB3BSGl9rQ4DU6YQeUsfr2ne7
	3JUBAWoStza0w9kj2zo9On1gyBfpy9qF0tPPqTrEccnAcuYbe81dReBohfq3FRNnfQmZmvYm9Gi
	+kwc1l6ojuifDtmXI3j19vlGuyiwVReluPw/WJKsmpnDYtn/Abuqn4eJKmd0fA+1o7rFF3Zrfh8
	094MZZrXB8qYCJBHd
X-Google-Smtp-Source: AGHT+IE3uJouYJ/7M/rrSd1eFvrf/qS5HF+61EQrttb/wpTbAdACHBohOTrf1XeLM5WbZ4ptiBZEjw==
X-Received: by 2002:a5d:5985:0:b0:391:2ab1:d4c2 with SMTP id ffacd0b85a97d-3a06cfabac2mr2257224f8f.37.1745504043594;
        Thu, 24 Apr 2025 07:14:03 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:03 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 14/34] gunyah: Add resource manager RPC core
Date: Thu, 24 Apr 2025 15:13:21 +0100
Message-Id: <20250424141341.841734-15-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

The resource manager is a special virtual machine which is always
running on a Gunyah system. It provides APIs for creating and destroying
VMs, secure memory management, sharing/lending of memory between VMs,
and setup of inter-VM communication. Calls to the resource manager are
made via message queues.

This patch implements the basic probing and RPC mechanism to make those
API calls. Request/response calls can be made with gh_rm_call.
Drivers can also register to notifications pushed by RM via
gh_rm_register_notifier

Specific API calls that resource manager supports will be implemented in
subsequent patches.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/Makefile   |   4 +-
 drivers/virt/gunyah/rsc_mgr.c  | 724 +++++++++++++++++++++++++++++++++
 include/linux/gunyah_rsc_mgr.h |  27 ++
 3 files changed, 754 insertions(+), 1 deletion(-)
 create mode 100644 drivers/virt/gunyah/rsc_mgr.c
 create mode 100644 include/linux/gunyah_rsc_mgr.h

diff --git a/drivers/virt/gunyah/Makefile b/drivers/virt/gunyah/Makefile
index 34f32110faf9..c2308389f551 100644
--- a/drivers/virt/gunyah/Makefile
+++ b/drivers/virt/gunyah/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_GUNYAH) += gunyah.o
+gunyah_rsc_mgr-y += rsc_mgr.o
+
+obj-$(CONFIG_GUNYAH) += gunyah.o gunyah_rsc_mgr.o
diff --git a/drivers/virt/gunyah/rsc_mgr.c b/drivers/virt/gunyah/rsc_mgr.c
new file mode 100644
index 000000000000..75fc86887868
--- /dev/null
+++ b/drivers/virt/gunyah/rsc_mgr.c
@@ -0,0 +1,724 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/completion.h>
+#include <linux/gunyah.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <linux/gunyah_rsc_mgr.h>
+
+/* clang-format off */
+#define RM_RPC_API_VERSION_MASK		GENMASK(3, 0)
+#define RM_RPC_HEADER_WORDS_MASK	GENMASK(7, 4)
+#define RM_RPC_API_VERSION		FIELD_PREP(RM_RPC_API_VERSION_MASK, 1)
+#define RM_RPC_HEADER_WORDS		FIELD_PREP(RM_RPC_HEADER_WORDS_MASK, \
+						(sizeof(struct gunyah_rm_rpc_hdr) / sizeof(u32)))
+#define RM_RPC_API			(RM_RPC_API_VERSION | RM_RPC_HEADER_WORDS)
+
+#define RM_RPC_TYPE_CONTINUATION	0x0
+#define RM_RPC_TYPE_REQUEST		0x1
+#define RM_RPC_TYPE_REPLY		0x2
+#define RM_RPC_TYPE_NOTIF		0x3
+#define RM_RPC_TYPE_MASK		GENMASK(1, 0)
+
+#define GUNYAH_RM_MAX_NUM_FRAGMENTS		62
+#define RM_RPC_FRAGMENTS_MASK		GENMASK(7, 2)
+/* clang-format on */
+
+struct gunyah_rm_rpc_hdr {
+	u8 api;
+	u8 type;
+	__le16 seq;
+	__le32 msg_id;
+} __packed;
+
+struct gunyah_rm_rpc_reply_hdr {
+	struct gunyah_rm_rpc_hdr hdr;
+	__le32 err_code; /* GUNYAH_RM_ERROR_* */
+} __packed;
+
+#define GUNYAH_RM_MSGQ_MSG_SIZE 240
+#define GUNYAH_RM_PAYLOAD_SIZE \
+	(GUNYAH_RM_MSGQ_MSG_SIZE - sizeof(struct gunyah_rm_rpc_hdr))
+
+/* RM Error codes */
+enum gunyah_rm_error {
+	/* clang-format off */
+	GUNYAH_RM_ERROR_OK			= 0x0,
+	GUNYAH_RM_ERROR_UNIMPLEMENTED		= 0xFFFFFFFF,
+	GUNYAH_RM_ERROR_NOMEM			= 0x1,
+	GUNYAH_RM_ERROR_NORESOURCE		= 0x2,
+	GUNYAH_RM_ERROR_DENIED			= 0x3,
+	GUNYAH_RM_ERROR_INVALID			= 0x4,
+	GUNYAH_RM_ERROR_BUSY			= 0x5,
+	GUNYAH_RM_ERROR_ARGUMENT_INVALID	= 0x6,
+	GUNYAH_RM_ERROR_HANDLE_INVALID		= 0x7,
+	GUNYAH_RM_ERROR_VALIDATE_FAILED		= 0x8,
+	GUNYAH_RM_ERROR_MAP_FAILED		= 0x9,
+	GUNYAH_RM_ERROR_MEM_INVALID		= 0xA,
+	GUNYAH_RM_ERROR_MEM_INUSE		= 0xB,
+	GUNYAH_RM_ERROR_MEM_RELEASED		= 0xC,
+	GUNYAH_RM_ERROR_VMID_INVALID		= 0xD,
+	GUNYAH_RM_ERROR_LOOKUP_FAILED		= 0xE,
+	GUNYAH_RM_ERROR_IRQ_INVALID		= 0xF,
+	GUNYAH_RM_ERROR_IRQ_INUSE		= 0x10,
+	GUNYAH_RM_ERROR_IRQ_RELEASED		= 0x11,
+	/* clang-format on */
+};
+
+/**
+ * struct gunyah_rm_message - Represents a complete message from resource manager
+ * @payload: Combined payload of all the fragments (msg headers stripped off).
+ * @size: Size of the payload received so far.
+ * @msg_id: Message ID from the header.
+ * @type: RM_RPC_TYPE_REPLY or RM_RPC_TYPE_NOTIF.
+ * @num_fragments: total number of fragments expected to be received.
+ * @fragments_received: fragments received so far.
+ * @reply: Fields used for request/reply sequences
+ */
+struct gunyah_rm_message {
+	void *payload;
+	size_t size;
+	u32 msg_id;
+	u8 type;
+
+	u8 num_fragments;
+	u8 fragments_received;
+
+	/**
+	 * @ret: Linux return code, there was an error processing message
+	 * @seq: Sequence ID for the main message.
+	 * @rm_error: For request/reply sequences with standard replies
+	 * @seq_done: Signals caller that the RM reply has been received
+	 */
+	struct {
+		int ret;
+		u16 seq;
+		enum gunyah_rm_error rm_error;
+		struct completion seq_done;
+	} reply;
+};
+
+/**
+ * struct gunyah_rm - private data for communicating w/Gunyah resource manager
+ * @dev: pointer to RM platform device
+ * @tx_ghrsc: message queue resource to TX to RM
+ * @rx_ghrsc: message queue resource to RX from RM
+ * @active_rx_message: ongoing gunyah_rm_message for which we're receiving fragments
+ * @call_xarray: xarray to allocate & lookup sequence IDs for Request/Response flows
+ * @next_seq: next ID to allocate (for xa_alloc_cyclic)
+ * @recv_msg: cached allocation for Rx messages
+ * @send_msg: cached allocation for Tx messages. Must hold @send_lock to manipulate.
+ * @send_lock: synchronization to allow only one request to be sent at a time
+ * @send_ready: completed when we know Tx message queue can take more messages
+ * @nh: notifier chain for clients interested in RM notification messages
+ */
+struct gunyah_rm {
+	struct device *dev;
+	struct gunyah_resource tx_ghrsc;
+	struct gunyah_resource rx_ghrsc;
+	struct gunyah_rm_message *active_rx_message;
+
+	struct xarray call_xarray;
+	u32 next_seq;
+
+	unsigned char recv_msg[GUNYAH_RM_MSGQ_MSG_SIZE];
+	unsigned char send_msg[GUNYAH_RM_MSGQ_MSG_SIZE];
+	struct mutex send_lock;
+	struct completion send_ready;
+	struct blocking_notifier_head nh;
+};
+
+/* Global resource manager instance */
+struct gunyah_rm *gunyah_rm;
+EXPORT_SYMBOL_GPL(gunyah_rm);
+
+/**
+ * gunyah_rm_error_remap() - Remap Gunyah resource manager errors into a Linux error code
+ * @rm_error: "Standard" return value from Gunyah resource manager
+ */
+static inline int gunyah_rm_error_remap(enum gunyah_rm_error rm_error)
+{
+	switch (rm_error) {
+	case GUNYAH_RM_ERROR_OK:
+		return 0;
+	case GUNYAH_RM_ERROR_UNIMPLEMENTED:
+		return -EOPNOTSUPP;
+	case GUNYAH_RM_ERROR_NOMEM:
+		return -ENOMEM;
+	case GUNYAH_RM_ERROR_NORESOURCE:
+		return -ENODEV;
+	case GUNYAH_RM_ERROR_DENIED:
+		return -EPERM;
+	case GUNYAH_RM_ERROR_BUSY:
+		return -EBUSY;
+	case GUNYAH_RM_ERROR_INVALID:
+	case GUNYAH_RM_ERROR_ARGUMENT_INVALID:
+	case GUNYAH_RM_ERROR_HANDLE_INVALID:
+	case GUNYAH_RM_ERROR_VALIDATE_FAILED:
+	case GUNYAH_RM_ERROR_MAP_FAILED:
+	case GUNYAH_RM_ERROR_MEM_INVALID:
+	case GUNYAH_RM_ERROR_MEM_INUSE:
+	case GUNYAH_RM_ERROR_MEM_RELEASED:
+	case GUNYAH_RM_ERROR_VMID_INVALID:
+	case GUNYAH_RM_ERROR_LOOKUP_FAILED:
+	case GUNYAH_RM_ERROR_IRQ_INVALID:
+	case GUNYAH_RM_ERROR_IRQ_INUSE:
+	case GUNYAH_RM_ERROR_IRQ_RELEASED:
+		return -EINVAL;
+	default:
+		return -EBADMSG;
+	}
+}
+
+static int gunyah_rm_init_message_payload(struct gunyah_rm_message *message,
+					  const void *msg, size_t hdr_size,
+					  size_t msg_size)
+{
+	const struct gunyah_rm_rpc_hdr *hdr = msg;
+	size_t max_buf_size, payload_size;
+
+	if (msg_size < hdr_size)
+		return -EINVAL;
+
+	payload_size = msg_size - hdr_size;
+
+	message->num_fragments = FIELD_GET(RM_RPC_FRAGMENTS_MASK, hdr->type);
+	message->fragments_received = 0;
+
+	/* There's not going to be any payload, no need to allocate buffer. */
+	if (!payload_size && !message->num_fragments)
+		return 0;
+
+	if (message->num_fragments > GUNYAH_RM_MAX_NUM_FRAGMENTS)
+		return -EINVAL;
+
+	max_buf_size = payload_size +
+		       (message->num_fragments * GUNYAH_RM_PAYLOAD_SIZE);
+
+	message->payload = kzalloc(max_buf_size, GFP_KERNEL);
+	if (!message->payload)
+		return -ENOMEM;
+
+	memcpy(message->payload, msg + hdr_size, payload_size);
+	message->size = payload_size;
+	return 0;
+}
+
+static void gunyah_rm_abort_message(struct gunyah_rm *rm)
+{
+	kfree(rm->active_rx_message->payload);
+
+	switch (rm->active_rx_message->type) {
+	case RM_RPC_TYPE_REPLY:
+		rm->active_rx_message->reply.ret = -EIO;
+		complete(&rm->active_rx_message->reply.seq_done);
+		break;
+	case RM_RPC_TYPE_NOTIF:
+		fallthrough;
+	default:
+		kfree(rm->active_rx_message);
+	}
+
+	rm->active_rx_message = NULL;
+}
+
+static inline void gunyah_rm_try_complete_message(struct gunyah_rm *rm)
+{
+	struct gunyah_rm_message *message = rm->active_rx_message;
+
+	if (!message || message->fragments_received != message->num_fragments)
+		return;
+
+	switch (message->type) {
+	case RM_RPC_TYPE_REPLY:
+		complete(&message->reply.seq_done);
+		break;
+	case RM_RPC_TYPE_NOTIF:
+		blocking_notifier_call_chain(&rm->nh, message->msg_id,
+					     message->payload);
+
+		kfree(message->payload);
+		kfree(message);
+		break;
+	default:
+		dev_err_ratelimited(rm->dev,
+				    "Invalid message type (%u) received\n",
+				    message->type);
+		gunyah_rm_abort_message(rm);
+		break;
+	}
+
+	rm->active_rx_message = NULL;
+}
+
+static void gunyah_rm_process_notif(struct gunyah_rm *rm, const void *msg,
+				    size_t msg_size)
+{
+	const struct gunyah_rm_rpc_hdr *hdr = msg;
+	struct gunyah_rm_message *message;
+	int ret;
+
+	if (rm->active_rx_message) {
+		dev_err(rm->dev,
+			"Unexpected new notification, still processing an active message");
+		gunyah_rm_abort_message(rm);
+	}
+
+	message = kzalloc(sizeof(*message), GFP_KERNEL);
+	if (!message)
+		return;
+
+	message->type = RM_RPC_TYPE_NOTIF;
+	message->msg_id = le32_to_cpu(hdr->msg_id);
+
+	ret = gunyah_rm_init_message_payload(message, msg, sizeof(*hdr),
+					     msg_size);
+	if (ret) {
+		dev_err(rm->dev,
+			"Failed to initialize message for notification: %d\n",
+			ret);
+		kfree(message);
+		return;
+	}
+
+	rm->active_rx_message = message;
+
+	gunyah_rm_try_complete_message(rm);
+}
+
+static void gunyah_rm_process_reply(struct gunyah_rm *rm, const void *msg,
+				    size_t msg_size)
+{
+	const struct gunyah_rm_rpc_reply_hdr *reply_hdr = msg;
+	struct gunyah_rm_message *message;
+	u16 seq_id;
+
+	seq_id = le16_to_cpu(reply_hdr->hdr.seq);
+	message = xa_load(&rm->call_xarray, seq_id);
+
+	if (!message || message->msg_id != le32_to_cpu(reply_hdr->hdr.msg_id))
+		return;
+
+	if (rm->active_rx_message) {
+		dev_err(rm->dev,
+			"Unexpected new reply, still processing an active message");
+		gunyah_rm_abort_message(rm);
+	}
+
+	if (gunyah_rm_init_message_payload(message, msg, sizeof(*reply_hdr),
+					   msg_size)) {
+		dev_err(rm->dev,
+			"Failed to alloc message buffer for sequence %d\n",
+			seq_id);
+		/* Send message complete and error the client. */
+		message->reply.ret = -ENOMEM;
+		complete(&message->reply.seq_done);
+		return;
+	}
+
+	message->reply.rm_error = le32_to_cpu(reply_hdr->err_code);
+	rm->active_rx_message = message;
+
+	gunyah_rm_try_complete_message(rm);
+}
+
+static void gunyah_rm_process_cont(struct gunyah_rm *rm,
+				   struct gunyah_rm_message *message,
+				   const void *msg, size_t msg_size)
+{
+	const struct gunyah_rm_rpc_hdr *hdr = msg;
+	size_t payload_size = msg_size - sizeof(*hdr);
+
+	if (!rm->active_rx_message)
+		return;
+
+	/*
+	 * hdr->fragments and hdr->msg_id preserves the value from first reply
+	 * or notif message. To detect mishandling, check it's still intact.
+	 */
+	if (message->msg_id != le32_to_cpu(hdr->msg_id) ||
+	    message->num_fragments !=
+		    FIELD_GET(RM_RPC_FRAGMENTS_MASK, hdr->type)) {
+		gunyah_rm_abort_message(rm);
+		return;
+	}
+
+	memcpy(message->payload + message->size, msg + sizeof(*hdr),
+	       payload_size);
+	message->size += payload_size;
+	message->fragments_received++;
+
+	gunyah_rm_try_complete_message(rm);
+}
+
+static irqreturn_t gunyah_rm_rx(int irq, void *data)
+{
+	enum gunyah_error gunyah_error;
+	struct gunyah_rm_rpc_hdr *hdr;
+	struct gunyah_rm *rm = data;
+	void *msg = &rm->recv_msg[0];
+	size_t len;
+	bool ready;
+
+	do {
+		gunyah_error = gunyah_hypercall_msgq_recv(rm->rx_ghrsc.capid,
+							  msg,
+							  sizeof(rm->recv_msg),
+							  &len, &ready);
+		if (gunyah_error != GUNYAH_ERROR_OK) {
+			if (gunyah_error != GUNYAH_ERROR_MSGQUEUE_EMPTY)
+				dev_warn(rm->dev,
+					 "Failed to receive data: %d\n",
+					 gunyah_error);
+			return IRQ_HANDLED;
+		}
+
+		if (len < sizeof(*hdr)) {
+			dev_err_ratelimited(
+				rm->dev,
+				"Too small message received. size=%ld\n", len);
+			continue;
+		}
+
+		hdr = msg;
+		if (hdr->api != RM_RPC_API) {
+			dev_err(rm->dev, "Unknown RM RPC API version: %x\n",
+				hdr->api);
+			return IRQ_HANDLED;
+		}
+
+		switch (FIELD_GET(RM_RPC_TYPE_MASK, hdr->type)) {
+		case RM_RPC_TYPE_NOTIF:
+			gunyah_rm_process_notif(rm, msg, len);
+			break;
+		case RM_RPC_TYPE_REPLY:
+			gunyah_rm_process_reply(rm, msg, len);
+			break;
+		case RM_RPC_TYPE_CONTINUATION:
+			gunyah_rm_process_cont(rm, rm->active_rx_message, msg,
+					       len);
+			break;
+		default:
+			dev_err(rm->dev,
+				"Invalid message type (%lu) received\n",
+				FIELD_GET(RM_RPC_TYPE_MASK, hdr->type));
+			return IRQ_HANDLED;
+		}
+	} while (ready);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t gunyah_rm_tx(int irq, void *data)
+{
+	struct gunyah_rm *rm = data;
+
+	complete(&rm->send_ready);
+
+	return IRQ_HANDLED;
+}
+
+static int gunyah_rm_msgq_send(struct gunyah_rm *rm, size_t size, bool push)
+{
+	const u64 tx_flags = push ? GUNYAH_HYPERCALL_MSGQ_TX_FLAGS_PUSH : 0;
+	enum gunyah_error gunyah_error;
+	void *data = &rm->send_msg[0];
+	bool ready;
+
+	lockdep_assert_held(&rm->send_lock);
+
+again:
+	wait_for_completion(&rm->send_ready);
+	gunyah_error = gunyah_hypercall_msgq_send(rm->tx_ghrsc.capid, size,
+						  data, tx_flags, &ready);
+
+	/* Should never happen because Linux properly tracks the ready-state of the msgq */
+	if (WARN_ON(gunyah_error == GUNYAH_ERROR_MSGQUEUE_FULL))
+		goto again;
+
+	if (ready)
+		complete(&rm->send_ready);
+
+	return gunyah_error_remap(gunyah_error);
+}
+
+static int gunyah_rm_send_request(struct gunyah_rm *rm, u32 message_id,
+				  const void *req_buf, size_t req_buf_size,
+				  struct gunyah_rm_message *message)
+{
+	size_t buf_size_remaining = req_buf_size;
+	const void *req_buf_curr = req_buf;
+	struct gunyah_rm_rpc_hdr *hdr =
+		(struct gunyah_rm_rpc_hdr *)&rm->send_msg[0];
+	struct gunyah_rm_rpc_hdr hdr_template;
+	void *payload = hdr + 1;
+	u32 cont_fragments = 0;
+	size_t payload_size;
+	bool push;
+	int ret;
+
+	if (req_buf_size >
+	    GUNYAH_RM_MAX_NUM_FRAGMENTS * GUNYAH_RM_PAYLOAD_SIZE) {
+		dev_warn(
+			rm->dev,
+			"Limit (%lu bytes) exceeded for the maximum message size: %lu\n",
+			GUNYAH_RM_MAX_NUM_FRAGMENTS * GUNYAH_RM_PAYLOAD_SIZE,
+			req_buf_size);
+		dump_stack();
+		return -E2BIG;
+	}
+
+	if (req_buf_size)
+		cont_fragments = (req_buf_size - 1) / GUNYAH_RM_PAYLOAD_SIZE;
+
+	hdr_template.api = RM_RPC_API;
+	hdr_template.type = FIELD_PREP(RM_RPC_TYPE_MASK, RM_RPC_TYPE_REQUEST) |
+			    FIELD_PREP(RM_RPC_FRAGMENTS_MASK, cont_fragments);
+	hdr_template.seq = cpu_to_le16(message->reply.seq);
+	hdr_template.msg_id = cpu_to_le32(message_id);
+
+	ret = mutex_lock_interruptible(&rm->send_lock);
+	if (ret)
+		return ret;
+
+	do {
+		*hdr = hdr_template;
+
+		/* Copy payload */
+		payload_size = min(buf_size_remaining, GUNYAH_RM_PAYLOAD_SIZE);
+		memcpy(payload, req_buf_curr, payload_size);
+		req_buf_curr += payload_size;
+		buf_size_remaining -= payload_size;
+
+		/* Only the last message should have push flag set */
+		push = !buf_size_remaining;
+		ret = gunyah_rm_msgq_send(rm, sizeof(*hdr) + payload_size,
+					  push);
+		if (ret)
+			break;
+
+		hdr_template.type =
+			FIELD_PREP(RM_RPC_TYPE_MASK, RM_RPC_TYPE_CONTINUATION) |
+			FIELD_PREP(RM_RPC_FRAGMENTS_MASK, cont_fragments);
+	} while (buf_size_remaining);
+
+	mutex_unlock(&rm->send_lock);
+	return ret;
+}
+
+/**
+ * gunyah_rm_call: Achieve request-response type communication with RPC
+ * @rm: Pointer to Gunyah resource manager internal data
+ * @message_id: The RM RPC message-id
+ * @req_buf: Request buffer that contains the payload
+ * @req_buf_size: Total size of the payload
+ * @resp_buf: Pointer to a response buffer
+ * @resp_buf_size: Size of the response buffer
+ *
+ * Make a request to the Resource Manager and wait for reply back. For a successful
+ * response, the function returns the payload. The size of the payload is set in
+ * resp_buf_size. The resp_buf must be freed by the caller when 0 is returned
+ * and resp_buf_size != 0.
+ *
+ * req_buf should be not NULL for req_buf_size >0. If req_buf_size == 0,
+ * req_buf *can* be NULL and no additional payload is sent.
+ *
+ * Context: Process context. Will sleep waiting for reply.
+ * Return: 0 on success. <0 if error.
+ */
+int gunyah_rm_call(struct gunyah_rm *rm, u32 message_id, const void *req_buf,
+		   size_t req_buf_size, void **resp_buf, size_t *resp_buf_size)
+{
+	struct gunyah_rm_message message = { 0 };
+	u32 seq_id;
+	int ret;
+
+	/* message_id 0 is reserved. req_buf_size implies req_buf is not NULL */
+	if (!rm || !message_id || (!req_buf && req_buf_size))
+		return -EINVAL;
+
+	message.type = RM_RPC_TYPE_REPLY;
+	message.msg_id = message_id;
+
+	message.reply.seq_done =
+		COMPLETION_INITIALIZER_ONSTACK(message.reply.seq_done);
+
+	/* Allocate a new seq number for this message */
+	ret = xa_alloc_cyclic(&rm->call_xarray, &seq_id, &message, xa_limit_16b,
+			      &rm->next_seq, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	message.reply.seq = lower_16_bits(seq_id);
+
+	/* Send the request to the Resource Manager */
+	ret = gunyah_rm_send_request(rm, message_id, req_buf, req_buf_size,
+				     &message);
+	if (ret < 0) {
+		dev_warn(rm->dev, "Failed to send request. Error: %d\n", ret);
+		goto out;
+	}
+
+	/*
+	 * Wait for response. Uninterruptible because rollback based on what RM did to VM
+	 * requires us to know how RM handled the call.
+	 */
+	wait_for_completion(&message.reply.seq_done);
+
+	/* Check for internal (kernel) error waiting for the response */
+	if (message.reply.ret) {
+		ret = message.reply.ret;
+		goto out;
+	}
+
+	/* Got a response, did resource manager give us an error? */
+	if (message.reply.rm_error != GUNYAH_RM_ERROR_OK) {
+		dev_warn(rm->dev, "RM rejected message %08x. Error: %d\n",
+			 message_id, message.reply.rm_error);
+		ret = gunyah_rm_error_remap(message.reply.rm_error);
+		kfree(message.payload);
+		goto out;
+	}
+
+	/* Everything looks good, return the payload */
+	if (resp_buf_size)
+		*resp_buf_size = message.size;
+
+	if (message.size && resp_buf) {
+		*resp_buf = message.payload;
+	} else {
+		/* kfree in case RM sent us multiple fragments but never any data in
+		 * those fragments. We would've allocated memory for it, but message.size == 0
+		 */
+		kfree(message.payload);
+	}
+
+out:
+	xa_erase(&rm->call_xarray, message.reply.seq);
+	return ret;
+}
+
+int gunyah_rm_notifier_register(struct gunyah_rm *rm, struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&rm->nh, nb);
+}
+EXPORT_SYMBOL_GPL(gunyah_rm_notifier_register);
+
+int gunyah_rm_notifier_unregister(struct gunyah_rm *rm,
+				  struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&rm->nh, nb);
+}
+EXPORT_SYMBOL_GPL(gunyah_rm_notifier_unregister);
+
+static int gunyah_platform_probe_capability(struct platform_device *pdev,
+					    int idx,
+					    struct gunyah_resource *ghrsc)
+{
+	int ret;
+
+	ghrsc->irq = platform_get_irq(pdev, idx);
+	if (ghrsc->irq < 0) {
+		dev_err(&pdev->dev, "Failed to get %s irq: %d\n",
+			idx ? "rx" : "tx", ghrsc->irq);
+		return ghrsc->irq;
+	}
+
+	ret = of_property_read_u64_index(pdev->dev.of_node, "reg", idx,
+					 &ghrsc->capid);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to get %s capid: %d\n",
+			idx ? "rx" : "tx", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int gunyah_rm_probe_tx_msgq(struct gunyah_rm *rm,
+				   struct platform_device *pdev)
+{
+	int ret;
+
+	rm->tx_ghrsc.type = GUNYAH_RESOURCE_TYPE_MSGQ_TX;
+	ret = gunyah_platform_probe_capability(pdev, 0, &rm->tx_ghrsc);
+	if (ret)
+		return ret;
+
+	enable_irq_wake(rm->tx_ghrsc.irq);
+
+	return devm_request_irq(rm->dev, rm->tx_ghrsc.irq, gunyah_rm_tx, 0,
+				"gunyah_rm_tx", rm);
+}
+
+static int gunyah_rm_probe_rx_msgq(struct gunyah_rm *rm,
+				   struct platform_device *pdev)
+{
+	int ret;
+
+	rm->rx_ghrsc.type = GUNYAH_RESOURCE_TYPE_MSGQ_RX;
+	ret = gunyah_platform_probe_capability(pdev, 1, &rm->rx_ghrsc);
+	if (ret)
+		return ret;
+
+	enable_irq_wake(rm->rx_ghrsc.irq);
+
+	return devm_request_threaded_irq(rm->dev, rm->rx_ghrsc.irq, NULL,
+					 gunyah_rm_rx, IRQF_ONESHOT,
+					 "gunyah_rm_rx", rm);
+}
+
+static int gunyah_rm_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	gunyah_rm = devm_kzalloc(&pdev->dev, sizeof(*gunyah_rm), GFP_KERNEL);
+	if (!gunyah_rm)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, gunyah_rm);
+	gunyah_rm->dev = &pdev->dev;
+
+	mutex_init(&gunyah_rm->send_lock);
+	init_completion(&gunyah_rm->send_ready);
+	BLOCKING_INIT_NOTIFIER_HEAD(&gunyah_rm->nh);
+	xa_init_flags(&gunyah_rm->call_xarray, XA_FLAGS_ALLOC);
+
+	device_init_wakeup(&pdev->dev, true);
+
+	ret = gunyah_rm_probe_tx_msgq(gunyah_rm, pdev);
+	if (ret)
+		return ret;
+	/* assume RM is ready to receive messages from us */
+	complete(&gunyah_rm->send_ready);
+
+	ret = gunyah_rm_probe_rx_msgq(gunyah_rm, pdev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static const struct of_device_id gunyah_rm_of_match[] = {
+	{ .compatible = "gunyah-resource-manager" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, gunyah_rm_of_match);
+
+static struct platform_driver gunyah_rm_driver = {
+	.probe = gunyah_rm_probe,
+	.driver = {
+		.name = "gunyah_rsc_mgr",
+		.of_match_table = gunyah_rm_of_match,
+	},
+};
+module_platform_driver(gunyah_rm_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Gunyah Resource Manager Driver");
diff --git a/include/linux/gunyah_rsc_mgr.h b/include/linux/gunyah_rsc_mgr.h
new file mode 100644
index 000000000000..87e919cc1e28
--- /dev/null
+++ b/include/linux/gunyah_rsc_mgr.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+#ifndef __GUNYAH_RSC_MGR_H
+#define __GUNYAH_RSC_MGR_H
+
+#include <linux/notifier.h>
+#include <linux/types.h>
+
+#define GUNYAH_VMID_INVAL U16_MAX
+
+struct gunyah_rm;
+
+extern struct gunyah_rm *gunyah_rm;
+
+int gunyah_rm_notifier_register(struct gunyah_rm *rm,
+				struct notifier_block *nb);
+int gunyah_rm_notifier_unregister(struct gunyah_rm *rm,
+				  struct notifier_block *nb);
+
+
+int gunyah_rm_call(struct gunyah_rm *rsc_mgr, u32 message_id,
+		   const void *req_buf, size_t req_buf_size, void **resp_buf,
+		   size_t *resp_buf_size);
+
+#endif
-- 
2.39.5


