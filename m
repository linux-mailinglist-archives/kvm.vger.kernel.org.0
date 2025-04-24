Return-Path: <kvm+bounces-44149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A202A9B060
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD0937B0B0E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:14:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B6527F724;
	Thu, 24 Apr 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TMpYcwLk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077941C5D53
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504034; cv=none; b=UG+lfaZMU3oQFil02LSHEJ+7XqQy2OqRsTagra0giw9VMA6eCUPWyY7t4gxEP34d53tXsHnQHtsw/qccZKCQkFYgVXVFZ+rauzJJsU2dWcfGpuS5TGjoXeGNOOaCtLxlcD3J/Tuzp4oQQyhN09brK9XbYyexhYd37u5tXyAr7T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504034; c=relaxed/simple;
	bh=yHQVbNXozVjVHt5pOWEf6CFk11nfYNM4wHopdbI5gbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+lOvLYC7PSVNfBL2pSu3FXXwc6412t2X+396qiNGNaH96bXrlqPXwlQ6QmQl39xzFGIcLi1Rho7x97z6XqqlTDAX/nsgFnNSv1U/WQA8evdw/Zd6pBEN3mDIXlqyIOQyqTvD8tSBbRsH3wn7nF7exQ52z5Yzr4fq4QAhPdPRSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TMpYcwLk; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39c1ee0fd43so952673f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504030; x=1746108830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlljNambtbwwvkzAI4LjAz2eo7Ti1KUJrgs8M2UB6Bg=;
        b=TMpYcwLkfLTj/ATVziMuksWaNsV3xs053pw6b7Tre2eq7ME2fqLNfMFtBGsCfJ0eLv
         YaiXKTnIikVyMFLz6c8RFczV2dxEuTPlqUn0VbE8hvXxjTAi2mOelNzXjdxPAmnkSCfd
         3LifOZSqAm46lqRHFyEjsJsmzn/kOOCCpL0PCLxtWs3mOsRWSy+t7/E8RaWNKpD4LyWW
         QEM8MkS1ukD7WBR9ph7HvsZQWjM1KNmig+Vr6IRoe9cSARPdbP8NtrVV38KehoUVsO5h
         vE9r4xl6/rZ+05p1xaciTkPpWpp6a1HaUXeVGrmcWltf1wygu6Br9SLBLSbQuwtYg8jY
         0m/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504030; x=1746108830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlljNambtbwwvkzAI4LjAz2eo7Ti1KUJrgs8M2UB6Bg=;
        b=WEH488gVKtlIYwSMomW30fv93K1DFlfWgjIfd0APn6RMA4WsyNhQpgfTj7Yr+lPs2n
         b1CTIjGV0J3l27pdHeoZ3wiVg6hQN3+IA9Fr2niS9bhfRDThdwjNacMmDQ+11E7yIsv7
         hGWjrrgu+TaicovB29fBgcY8jk4LCdkSctEHV6GkExtI6BMDpXMOjLyZjjRRAm/gkYJ6
         ++7OATKP1C43yMZ0lvErGhOl+gZ3qNlkZJybd3FcukuOWa7MUjsotw6kt1KpFMp2rQc1
         6EWS54M1iXnZ9cn916LAZe3v1TeUZHfPBhJJMGiZs2Rc+XSL9sCjltfqovA3aqk/E782
         uKxw==
X-Forwarded-Encrypted: i=1; AJvYcCWWtLPzIq32aLoEIS39yNxlxymf8QK7bQTLeL2hLvS6KdY1rq9TnPIw00zdFx7Ob0nms5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy79euEhGLwvoXYXV39cWj5JHg16cWC7muFo90KZzuyr/6Z+4EV
	WBrxuzx4jzjuLfREczj5SrsDGrH67rP8oCROQnbHRrQWe59QRvdobm9Go2oQ180=
X-Gm-Gg: ASbGncvAAIkPtb+KTwClB5gyFEzqH7yDZbzue/fgAKYlmQIBfaCPm9JBr5RP5OxAIAn
	Kz1g1D8WnOTBE83tdF38z3kSWU3NaInQxI+1kI8lm9JXiphwBvC0BhyzX4fnJGtIVpB0KqCyZCX
	/9EILTSMu5c+GHvSsmCBjrly4VcW8lGEF/P/UP4kmdAYfSGsH0VdueTq7KlbZ6vGW7ZjQNjROc1
	dPkDlIekKxB1rk93zTbk4NSYHRF7u15vVT4/x+rg080GHnIqs3K3kxBGV8b3gBOhMw7VIXAIIxm
	YAioRgIX8owxctB0+MB4a7lqQDneCUQXNZPcVuIIVqd6m7GZSJPIrE0qwsYH5+QprcnOaq7TYRv
	GCQSndcsso7SLFUWG
X-Google-Smtp-Source: AGHT+IGjTSYHUF3tyGvvpZJy9ttFB+SjTk/OBEoax4K5qs9LZf6N8lXayXTA0lInN+EeJy++KbQTNQ==
X-Received: by 2002:a05:6000:18a2:b0:391:47d8:de2d with SMTP id ffacd0b85a97d-3a06cf5ed4cmr2481988f8f.23.1745504030257;
        Thu, 24 Apr 2025 07:13:50 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:49 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 04/34] KVM: Add weak stubs for irqchip-related functions for Gunyah builds
Date: Thu, 24 Apr 2025 15:13:11 +0100
Message-Id: <20250424141341.841734-5-karim.manaouil@linaro.org>
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

The generic KVM core code (e.g., kvm_main.c and eventfd.c) calls into
irqchip-specific helpers such as kvm_set_irq(), kvm_irq_map_gsi(), and
kvm_irq_map_chip_pin(). These functions are defined in kvm_irqchip.c,
which is not required or compiled when porting KVM to run on top of the
Gunyah hypervisor.

To allow building the KVM core code without linking errors in such
configurations, provide weak stub implementations of these functions
in eventfd.c. These stubs return appropriate default values (e.g., -ENXIO
or -1) to indicate that the functionality is not available.

This allows the KVM core to build successfully for platforms that do
not use the in-kernel irqchip support, such as Gunyah.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 virt/kvm/eventfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index d6702225e7f2..2a658d8277ed 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -56,6 +56,26 @@ kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 	return true;
 }
 
+int __attribute__((weak))
+kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
+		bool line_status)
+{
+	return -ENXIO;
+}
+
+int __attribute__((weak))
+kvm_irq_map_gsi(struct kvm *kvm,
+		struct kvm_kernel_irq_routing_entry *entries, int gsi)
+{
+	return 0;
+}
+
+int __attribute__((weak))
+kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	return -1;
+}
+
 static void
 irqfd_inject(struct work_struct *work)
 {
-- 
2.39.5


