Return-Path: <kvm+bounces-44154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89C3DA9B070
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:17:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEAC9201C4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02DC284B4F;
	Thu, 24 Apr 2025 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ntOOgl9n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68B7280A5C
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504041; cv=none; b=hNcMMOxpEcfL/ccrB2k/7QdCsjpFYh/eAvqKcylfpouwZxs+npFzom+erorJUQd2Ac4FwZOXC1RZPp1c+N47rdgwiiL6nKZhTrQZ8XYU9tyQvVttarU2ya1cTqlnB0O+hk/IaeRYn5RCpfw5xUQd7Mlq1cPdXqEi6TZQdoRuXmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504041; c=relaxed/simple;
	bh=nHdCN2XoC/vofWX1JvKbFFkxCi8mZFPmuv+AC6Hf5jo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZQpL8TcJqIiCD2J0ZDBmweEl3El0VPeexRYo2U4B/igGbIACsEKrSLHN8/sjPou/0ab6nIpltQSfupTq/IbpjKXKHcE+/NwzL4Vo40SVOt5Bt2SvWmhAjqJNO/40d62Dxxf5Jh0scsW0uAYu6J0WYsRwWVw1bIJHzmon0lxij9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ntOOgl9n; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso1551354f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504037; x=1746108837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UEu5ZzgQoIbj2nEACS31q52k6ad3AHbKAZTQ1reR+A=;
        b=ntOOgl9n/47oroZlPn6W85vBTzu5j6rwgBhEPREb4qe+N2tqnT4YnQz2DuoRLWKqKE
         OBXxavFaZDwHbMUBy6/cWhwHQ5WvLaNgJ25npQJjfp/ft17XqPt9NoiwflfuD8Zh8kVp
         rlKDeiU34oH6MboBQ2L0v6yiz5rpUdrX6d4/L7lsJxBJwjw3Go1zmnt2zDqnPO4bE+Ja
         3rFMR1TjmrEwKb7z5vPaZ4/B9B8CB5b++pxgnG7+tJ1rSk38I32tp19nAfOLM8peApt2
         krnIwGIp5rlXpsAmiWONQf5GB/0WDGINuZKsk39kuKePSkTXs789DL2q9Y66Sl6J2IQW
         WiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504037; x=1746108837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UEu5ZzgQoIbj2nEACS31q52k6ad3AHbKAZTQ1reR+A=;
        b=X7VXCd2W12MRuzKD78N3+M4mNCKxARpgzXPZl7dcskw7o7Ud6B6nMiT46fwPQoLLhH
         QiM65cVNbml/OTrZdRTrpnGv8CmCMvMx/65AdLTTeotQC7vWFkAP3yMwiYZBxBieMYEl
         wp+RHPO/AxQiiBMq3CVdpKnBd5uRi+ebwr7F9xmPNVFPMP8pV3ak0uc5DtRnKsKAVBhg
         wb2HtuPKyLmdmCpsPYA6iMV6vY/ZvoHLh1D/UkncDtUbcoiTIsPLXLev7UCekScsJHix
         ut+GyhWvV+W4iLzrn0gRIe0LlZd2ZoG/leCfBCJ5hUod3bFyZicRxiPNh8nQjsra6jYs
         QXTw==
X-Forwarded-Encrypted: i=1; AJvYcCWuPJ6A9qzuwTRGNHkT2Z+YXxmmYc8c+wdTRNxry8SWMgVBw6TTCyjX87WqS9s/t/bvmuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoQLSxEy5RcHvCkvOOc3ZHCiYDtygtjmS31GKHnPQRXQeTne8d
	D3tvIlbp8s82fhgYp+96rEmnq2o618AEXMhRjR7tVbbi1szcjDCovH5kwP0MAvo=
X-Gm-Gg: ASbGncspsqimgucbo2cF90wEAUQAu10mEJYk59YNCnbsyBOZTQt6/9+9FHh6374QuRo
	u4+XdKB4n5nTTlp6ZZUB1d4F4Y8QvcMfOakOuurhpfnyosCFWV2n5g+lt3+XQON+BYfCXxvsYqp
	62T5ZcHmDfFXsxV1Bc7PanCjd4a1UZCgK+LI0QUucHZN7CtebSl9USvPhydeZFtnK5Oyu9MItr6
	5fcWh00BE8Q43ZbkeYl02IuqEg0ds6X28OcXPNnbCnxJhkoO9oAKHTAHFQt6ZsuODD4Lqtn61O6
	xJkFmSX3y/I6QksPh57WJW/AP0z7a6qDSFv6Kj0zLN9O0EMnLYI2ma8KjeQeJs+wtkPUktff9IJ
	7DCr8m1Nz/YGZJw4w
X-Google-Smtp-Source: AGHT+IGbR1o2FMJriTxMh0pqGyENTmZYeFEOhlcuDYlWi636WYjhDM2clZgLdfLT+7JHm7l12d/JYg==
X-Received: by 2002:a05:6000:22c4:b0:3a0:3d18:285 with SMTP id ffacd0b85a97d-3a06d6dd54emr2218203f8f.25.1745504036794;
        Thu, 24 Apr 2025 07:13:56 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:56 -0700 (PDT)
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
Subject: [RFC PATCH 09/34] dt-bindings: Add binding for gunyah hypervisor
Date: Thu, 24 Apr 2025 15:13:16 +0100
Message-Id: <20250424141341.841734-10-karim.manaouil@linaro.org>
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

The Gunyah Resource Manager applies a devicetree overlay describing the
virtual platform configuration of the guest VM, such as the message
queue capability IDs for communicating with the Resource Manager. This
information is not otherwise discoverable by a VM: the Gunyah hypervisor
core does not provide a direct interface to discover capability IDs nor
a way to communicate with RM without having already known the
corresponding message queue capability ID. Add the DT bindings that
Gunyah adheres for the hypervisor node and message queues.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 .../bindings/firmware/gunyah-hypervisor.yaml  | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml

diff --git a/Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml b/Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml
new file mode 100644
index 000000000000..cdeb4885a807
--- /dev/null
+++ b/Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml
@@ -0,0 +1,82 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/firmware/gunyah-hypervisor.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Gunyah Hypervisor
+
+maintainers:
+  - Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
+  - Elliot Berman <quic_eberman@quicinc.com>
+
+description: |+
+  Gunyah virtual machines use this information to determine the capability IDs
+  of the message queues used to communicate with the Gunyah Resource Manager.
+  See also: https://github.com/quic/gunyah-resource-manager/blob/develop/src/vm_creation/dto_construct.c
+
+properties:
+  compatible:
+    const: gunyah-hypervisor
+
+  "#address-cells":
+    description: Number of cells needed to represent 64-bit capability IDs.
+    const: 2
+
+  "#size-cells":
+    description: must be 0, because capability IDs are not memory address
+                  ranges and do not have a size.
+    const: 0
+
+patternProperties:
+  "^gunyah-resource-mgr(@.*)?":
+    type: object
+    description:
+      Resource Manager node which is required to communicate to Resource
+      Manager VM using Gunyah Message Queues.
+
+    properties:
+      compatible:
+        const: gunyah-resource-manager
+
+      reg:
+        items:
+          - description: Gunyah capability ID of the TX message queue
+          - description: Gunyah capability ID of the RX message queue
+
+      interrupts:
+        items:
+          - description: Interrupt for the TX message queue
+          - description: Interrupt for the RX message queue
+
+    additionalProperties: false
+
+    required:
+      - compatible
+      - reg
+      - interrupts
+
+additionalProperties: false
+
+required:
+  - compatible
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    hypervisor {
+        #address-cells = <2>;
+        #size-cells = <0>;
+        compatible = "gunyah-hypervisor";
+
+        gunyah-resource-mgr@0 {
+            compatible = "gunyah-resource-manager";
+            interrupts = <GIC_SPI 3 IRQ_TYPE_EDGE_RISING>, /* TX allowed IRQ */
+                         <GIC_SPI 4 IRQ_TYPE_EDGE_RISING>; /* RX requested IRQ */
+            reg = <0x00000000 0x00000000>, /* TX capability ID */
+                  <0x00000000 0x00000001>; /* RX capability ID */
+        };
+    };
-- 
2.39.5


