Return-Path: <kvm+bounces-44177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB32A9B0BD
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90F093BE2E2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EF2296D2A;
	Thu, 24 Apr 2025 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cu5ALZQi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4E82957A2
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504072; cv=none; b=hRc7lONdgH69pd2eM2iN1QyYtX34VYt/ExZT23Q9Ncn2oKkjcPFC1kFaSWyrjyxm4BDNh2iiNyEKoXoo9gqlJCKYRxuib7UWMmuJN0UcH7gCboxcNp3pvHK0Tq899Tr+qII+mVS7Rw5gYKYVQf7oyg6vlvz3aQTd4WkPEOG3C+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504072; c=relaxed/simple;
	bh=D+WfMC8Jh2PxaUkmB3v59ZfRR9QkXj4ch9yqlrdrhtI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AmnW3dnks/kylES9roW6zWhouAfuIv8iva8xUexVRJIZOo8Msy8wOlnAG2tpmBgtr6FxhhjoCNkEdSkax69rUCHPG0csS6bf3xZjk1h0ShWjt0ZOVNo63z5sUxFKfvlRVuaP7sLdBRyhDJhn8Cr2UeQ7gXnEP1x9HHY0IGXveyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cu5ALZQi; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so754795f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504068; x=1746108868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa6gfxRAjkR7wfTiIJFT8jbfGXVVwGTh4OuP6vCgukQ=;
        b=cu5ALZQiIvlO6N17My54QqYBjdiqAlejII9I8zQrhp2pVmzqF+hSfAfcV/5EziFzLU
         HmeTtCwOQjWkkrPhOQMNCO82OS8I6W+dXyRNbCFcrb0mNF7klQL+wk3qmhDVWZ9nKJxD
         cECOGDSYt8P9TYQ0I5tS4Vh7MWWCPiG2tjUwfDYm8YmczxC1zKKXNFsfvanK/KPrvSnE
         hbEuun554g2wES6pGRLaz5MU1gdlj8xo69Pa6LH9iGHhqQir7aSxe/vOHN1G1c7DhIzv
         3+N4PlbC2aobhj+JT5f8pjOv7GHH4FkWZ5UcApKcq5rjRT/mUl1qL8Bmtb+XHj2aB8Vy
         nHlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504068; x=1746108868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oa6gfxRAjkR7wfTiIJFT8jbfGXVVwGTh4OuP6vCgukQ=;
        b=FgCizq3gBtglOHRKqyfoQvzXchx19JAHuJJx89IQr2y9t1REOmrVaUMYiZ7fFPsC4P
         +MIKWiwiLAyCSsHXviZti8cMMoX1TXzUWtWsSTnN+ZmW2/KyFbyTVU3X5j5TjTaDC1hl
         1aRg606gyHqO1WBNrnWioTe/9JSNwJxG+Jf/NdLuk/T35calgtBcgAGWObxv20grs/g5
         C4R1XsNRV3VuLAiGsKdRp6r2AmjPq7ILpOAf98PJgGbTR11Ni2Nkl5MNUgLGYgp2loS4
         SKBW19MyPeUVrhprvDoLv6VreY076KhD/NvM7qphHOrwo8hwmhIahqI+Czec+gNHFID7
         vkew==
X-Forwarded-Encrypted: i=1; AJvYcCV1LStoS2EwKWo0gHeCnaD3vt0G5XLdjEd8atr1esck4aa3Lrbbe05ifH+7zwBP31rJlsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlfP0rlVdLGu1GyixSfeA5nRd3f1eyZxVrvfkGJvWA5HS+5TFr
	4nl9LlosgFcipMzAinH1PFIEeC7itQ4txC+l2KLmFgbV1w7wtXWtfECZgZeafQFMdo6/G7mgPLF
	3
X-Gm-Gg: ASbGncsK21EiIFGLird0/4ItDTE+1F7mmAesuK7TbAoxB9uku3wXk5Gyh3Zm5dSos7Z
	z22qakWYBQbykqmfSF2n7fp1RF2XOMe+za2Rf0fV4XoTLt6T+tgC1FsnzmK8WTcHFhYD/m2mGhX
	v0AV4bUzvxQVC3F5Ti6XVEaZmf9SQ4Ohb2Owg4NN5HnQZ3KQfhlTzvs9pMV+31qBgFJfdlB4eio
	99FRupLJz3q567NVul4s2D3q4E6c7mcNY3Q3AxB0gCdToW0OtXbCq1wdB/An8AYEX/a5j/UgCKj
	kRQIa4802zN5u0vkqqSq/R+TfrzhwmGOlKh3B+kwnkHmqc6RtUAiLkhhMCKpxJAVayGLua2jJ53
	q6IpbqBDIAeU28nQY
X-Google-Smtp-Source: AGHT+IERVpNU2DILo0bvt8R4DAynThAP/fjqterv2/ng44U7A/g/KpyVK5SJtSkw42xdSMDhah0Vrw==
X-Received: by 2002:a05:6000:1acb:b0:391:2f15:c1f4 with SMTP id ffacd0b85a97d-3a06cfad64amr2138772f8f.55.1745504067786;
        Thu, 24 Apr 2025 07:14:27 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:27 -0700 (PDT)
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
	Alex Elder <elder@linaro.org>
Subject: [RFC PATCH 32/34] gunyah: Add hypercalls for sending doorbell
Date: Thu, 24 Apr 2025 15:13:39 +0100
Message-Id: <20250424141341.841734-33-karim.manaouil@linaro.org>
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

Gunyah doorbells allow a virtual machine to signal another using
interrupts. Add the hypercalls needed to assert the interrupt.

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/gunyah/gunyah_hypercall.c | 38 ++++++++++++++++++++++++++++
 include/linux/gunyah.h               |  5 ++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/gunyah/gunyah_hypercall.c b/arch/arm64/gunyah/gunyah_hypercall.c
index 38403dc28c66..3c2672d683ae 100644
--- a/arch/arm64/gunyah/gunyah_hypercall.c
+++ b/arch/arm64/gunyah/gunyah_hypercall.c
@@ -37,6 +37,8 @@ EXPORT_SYMBOL_GPL(arch_is_gunyah_guest);
 
 /* clang-format off */
 #define GUNYAH_HYPERCALL_HYP_IDENTIFY		GUNYAH_HYPERCALL(0x8000)
+#define GUNYAH_HYPERCALL_BELL_SEND		GUNYAH_HYPERCALL(0x8012)
+#define GUNYAH_HYPERCALL_BELL_SET_MASK		GUNYAH_HYPERCALL(0x8015)
 #define GUNYAH_HYPERCALL_MSGQ_SEND		GUNYAH_HYPERCALL(0x801B)
 #define GUNYAH_HYPERCALL_MSGQ_RECV		GUNYAH_HYPERCALL(0x801C)
 #define GUNYAH_HYPERCALL_ADDRSPACE_MAP		GUNYAH_HYPERCALL(0x802B)
@@ -64,6 +66,42 @@ void gunyah_hypercall_hyp_identify(
 }
 EXPORT_SYMBOL_GPL(gunyah_hypercall_hyp_identify);
 
+/**
+ * gunyah_hypercall_bell_send() - Assert a gunyah doorbell
+ * @capid: capability ID of the doorbell
+ * @new_flags: bits to set on the doorbell
+ * @old_flags: Filled with the bits set before the send call if return value is GUNYAH_ERROR_OK
+ */
+enum gunyah_error gunyah_hypercall_bell_send(u64 capid, u64 new_flags, u64 *old_flags)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_BELL_SEND, capid, new_flags, 0, &res);
+
+	if (res.a0 == GUNYAH_ERROR_OK && old_flags)
+		*old_flags = res.a1;
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_bell_send);
+
+/**
+ * gunyah_hypercall_bell_set_mask() - Set masks on a Gunyah doorbell
+ * @capid: capability ID of the doorbell
+ * @enable_mask: which bits trigger the receiver interrupt
+ * @ack_mask: which bits are automatically acknowledged when the receiver
+ *            interrupt is ack'd
+ */
+enum gunyah_error gunyah_hypercall_bell_set_mask(u64 capid, u64 enable_mask, u64 ack_mask)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_BELL_SET_MASK, capid, enable_mask, ack_mask, 0, &res);
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_bell_set_mask);
+
 /**
  * gunyah_hypercall_msgq_send() - Send a buffer on a message queue
  * @capid: capability ID of the message queue to add message
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 72aafc813664..26fdfa3174da 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -329,6 +329,11 @@ gunyah_api_version(const struct gunyah_hypercall_hyp_identify_resp *gunyah_api)
 void gunyah_hypercall_hyp_identify(
 	struct gunyah_hypercall_hyp_identify_resp *hyp_identity);
 
+enum gunyah_error gunyah_hypercall_bell_send(u64 capid, u64 new_flags,
+					     u64 *old_flags);
+enum gunyah_error gunyah_hypercall_bell_set_mask(u64 capid, u64 enable_mask,
+						 u64 ack_mask);
+
 /* Immediately raise RX vIRQ on receiver VM */
 #define GUNYAH_HYPERCALL_MSGQ_TX_FLAGS_PUSH BIT(0)
 
-- 
2.39.5


