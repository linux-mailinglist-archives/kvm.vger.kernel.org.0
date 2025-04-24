Return-Path: <kvm+bounces-44158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B49A9B07E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB2E74A45B0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11A627F74A;
	Thu, 24 Apr 2025 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aAsLp2wi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07828288C84
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504046; cv=none; b=bFPgx0MYspszn/mSy+O/rg1KgsznjVJfpGUZ86es+lzIYM8dkEN76cHhMvCKOTU72TCpEcYDxw3LQ/I/I5SjkcRFVvSsR2Ob1UiRAsZ40jUmr5PQ/amSp0Uall4naFNAiygKQzNUdRUohEsYREeEwTCsHxKpHSvswLvXcFdXhh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504046; c=relaxed/simple;
	bh=cRJdZ/BvpG7Nf2HfvkjONlA6iN6G9YZT/kvCa6h8Pqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T6yRULJQ7TsQxXKV6ODxkoEUp0ixzfs63rgB6a/X7MlfGgtbZU4Ct+to6vH+2EEFkCWmJ/0N6mYXDoFdgYafYphtbcYUdPcSZDFyt1M+wrmXQNMXIJzP/42gTkCmWjapVPnHEv1Er0Q4shmV+Yc7qW5ZSMHlIJ7pjDRpTbRhmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aAsLp2wi; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43edb40f357so7371545e9.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504042; x=1746108842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Iugp3VZMso7R61paVQ20sor9LWthQ+vE2iyUDGP7wsk=;
        b=aAsLp2wiL4SnGGfuvk26Iktqh4BJnxFfKcsSxvjPEagGx7fi/GliYmXzZdgxm3FCgY
         R/qwu/efZXZX7uKjiHZUoXchN/W/kcp5mMR2C5anR2hcIJ3vbCm0XaoUacmQvPV2g4gC
         HvHEBkPZop2ckBPqpxuors2ZNP2+rwt8rpotniV0U9YiCzMm2V0lXTsv1bEPFgXatILl
         U/awvhfv2MzQmr0N5FntwhNSvD/lPVBu2z7/NmOrnMklRKIOceLIopPA4Y1gRvEZFHOD
         9Kr+mQE/POTKy/7qng9AwhhvaG/MFOECRAnsoxCXf/aZag79pLOhLgzi7sjdzUZ9WG4K
         /FNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504042; x=1746108842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iugp3VZMso7R61paVQ20sor9LWthQ+vE2iyUDGP7wsk=;
        b=H0wjKCSjti0GI7GXERtufc+Omrl+THvkdKxCxtPVLPM/iS2Htam5D54ZHIkccPDxZF
         RdLRh1uoqOMxjFcbIdtdWFoWqzcHakkfQznBxUCS2nuoSHJPokbUdxiWioiCJDo/iKxt
         YfKK+PwL0grZ+/y8e4AvStDWyQwIH528a+7F9dNR877bOJukgSNKPkaCTUVz86J5Olwc
         HqxRX83dB9BoshIx+kNSGp35jI9ONB5MwFbT+LXR374AJcZOXzYYPOV4QUvSavg03ZA5
         pG+WTybylbsZdRlatloDdEyVAkAta69IgdyUiGoo7Urt7zt1MHsAHYWu1S2FxDILrX+6
         jUaw==
X-Forwarded-Encrypted: i=1; AJvYcCUc595CX1ZfATEM83lI2aN4cQXagdWfqd/nm9+2UscbUhZB/kp7aUKxJJthw3WLSWQaMi4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFfWbl+qOva2I+3w47ycCFlOMKOt28ziTq3COJuRksAMkelsve
	/6GvJzaxeWPBVbPXDoh37OSLZrxaEyqXYT94ygwUnBHag9zTVkckkmPaHDadJaY=
X-Gm-Gg: ASbGnctnfIjhycSrG+EWjpmxZHaCQOj7tHh+aW2ycSnT4tCYjjl99WUmKAfzL/v6njd
	D8mEkzvq+Gzhbmm2PZpLE7Eof2CHf9WmzVzDgZvE6jnAmS75U7Oplntce1kWMKeNPn8IDsOihZG
	FIYdze3EMs92gQHJCKzolkEF22KrEB32DuvaAsMvlZ+WHFKvBfHPJtD+CmMkNOljhIVNSFLVbIj
	w1Xd3XLuearIn12Gnb0Ila41i3q8gxcoPI020s4r/r50q3rRz4lpT2XnDRdbSnxLzJOrlyZ1cEY
	lk+h8r/ssjC4NV0Xa+BHgcOjCec93xo1HiedjG44EYoXG38PvVOAr0bjVbRXCi5CGVQb97jkEFX
	vvddDvHdSSOtE5w8h
X-Google-Smtp-Source: AGHT+IFb5JrKaNG2KfYhmzfwfaDb/IjykBP33KVSW9og9BEhgmgsW+e69hlvAOQj6I5jNodxA+AwfQ==
X-Received: by 2002:a05:600c:c092:b0:43c:e2dd:98ea with SMTP id 5b1f17b1804b1-4409c3b1e1amr23970305e9.22.1745504042259;
        Thu, 24 Apr 2025 07:14:02 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:01 -0700 (PDT)
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
	Elliot Berman <quic_eberman@quicinc.com>,
	Alex Elder <elder@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [RFC PATCH 13/34] gunyah: Add hypercalls to send and receive messages
Date: Thu, 24 Apr 2025 15:13:20 +0100
Message-Id: <20250424141341.841734-14-karim.manaouil@linaro.org>
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

Add hypercalls to send and receive messages on a Gunyah message queue.

Reviewed-by: Alex Elder <elder@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/gunyah/gunyah_hypercall.c | 55 ++++++++++++++++++++++++++++
 include/linux/gunyah.h               |  8 ++++
 2 files changed, 63 insertions(+)

diff --git a/arch/arm64/gunyah/gunyah_hypercall.c b/arch/arm64/gunyah/gunyah_hypercall.c
index d44663334f38..1302e128be6e 100644
--- a/arch/arm64/gunyah/gunyah_hypercall.c
+++ b/arch/arm64/gunyah/gunyah_hypercall.c
@@ -37,6 +37,8 @@ EXPORT_SYMBOL_GPL(arch_is_gunyah_guest);
 
 /* clang-format off */
 #define GUNYAH_HYPERCALL_HYP_IDENTIFY		GUNYAH_HYPERCALL(0x8000)
+#define GUNYAH_HYPERCALL_MSGQ_SEND		GUNYAH_HYPERCALL(0x801B)
+#define GUNYAH_HYPERCALL_MSGQ_RECV		GUNYAH_HYPERCALL(0x801C)
 /* clang-format on */
 
 /**
@@ -58,5 +60,58 @@ void gunyah_hypercall_hyp_identify(
 }
 EXPORT_SYMBOL_GPL(gunyah_hypercall_hyp_identify);
 
+/**
+ * gunyah_hypercall_msgq_send() - Send a buffer on a message queue
+ * @capid: capability ID of the message queue to add message
+ * @size: Size of @buff
+ * @buff: Address of buffer to send
+ * @tx_flags: See GUNYAH_HYPERCALL_MSGQ_TX_FLAGS_*
+ * @ready: If the send was successful, ready is filled with true if more
+ *         messages can be sent on the queue. If false, then the tx IRQ will
+ *         be raised in future when send can succeed.
+ */
+enum gunyah_error gunyah_hypercall_msgq_send(u64 capid, size_t size, void *buff,
+					     u64 tx_flags, bool *ready)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_MSGQ_SEND, capid, size,
+			  (uintptr_t)buff, tx_flags, 0, &res);
+
+	if (res.a0 == GUNYAH_ERROR_OK)
+		*ready = !!res.a1;
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_msgq_send);
+
+/**
+ * gunyah_hypercall_msgq_recv() - Send a buffer on a message queue
+ * @capid: capability ID of the message queue to add message
+ * @buff: Address of buffer to copy received data into
+ * @size: Size of @buff
+ * @recv_size: If the receive was successful, recv_size is filled with the
+ *             size of data received. Will be <= size.
+ * @ready: If the receive was successful, ready is filled with true if more
+ *         messages are ready to be received on the queue. If false, then the
+ *         rx IRQ will be raised in future when recv can succeed.
+ */
+enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
+					     size_t *recv_size, bool *ready)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_MSGQ_RECV, capid, (uintptr_t)buff,
+			  size, 0, &res);
+
+	if (res.a0 == GUNYAH_ERROR_OK) {
+		*recv_size = res.a1;
+		*ready = !!res.a2;
+	}
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_msgq_recv);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Gunyah Hypervisor Hypercalls");
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 33bcbd22d39f..acd70f982425 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -141,4 +141,12 @@ gunyah_api_version(const struct gunyah_hypercall_hyp_identify_resp *gunyah_api)
 void gunyah_hypercall_hyp_identify(
 	struct gunyah_hypercall_hyp_identify_resp *hyp_identity);
 
+/* Immediately raise RX vIRQ on receiver VM */
+#define GUNYAH_HYPERCALL_MSGQ_TX_FLAGS_PUSH BIT(0)
+
+enum gunyah_error gunyah_hypercall_msgq_send(u64 capid, size_t size, void *buff,
+					     u64 tx_flags, bool *ready);
+enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
+					     size_t *recv_size, bool *ready);
+
 #endif
-- 
2.39.5


