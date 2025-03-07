Return-Path: <kvm+bounces-40424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA80A5721B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466A53B5DD4
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2701A257438;
	Fri,  7 Mar 2025 19:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iWd0NN6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC12571AD
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741376248; cv=none; b=odHkV7moWtX4OsWYQSmIZ9T4FQOD2PtB7XOtwvqXEfkaaaujZJ4MMJ1Qs0MFiNJm7dLGW0EQWK9B25rRdNHtUsP6Ar4uKLBXzz++L8lLlY4X+k+u40pmd3WbvbNtu6PY28ZTVbT1jRzJYO7nEQZsuJzNP7cinz0HGeOp6SIUHJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741376248; c=relaxed/simple;
	bh=f6ywhfIHAeGjN6dW94oj9dG+w9FoBwMOqVbaNl3zrqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JIaHsh4dDIWG2RfQob69zX5jSPD+65zgJQRYXFqQmzO0OqUaIJBpOLQFPmOPwoXDlYWO29s9SfvV/SmItHEgA0kF/HzusxC2FClC3l/2wqAIrTSiRyfqS7/YHjwTwVKqFfxH9qV3BGmSbYQUbMQORn6lE/T3xczNuvuiB800UfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iWd0NN6G; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2f9b9c0088fso4072367a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741376246; x=1741981046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=iWd0NN6GFqeXFjZvwfJPGgWqnN+ZANjf7BHkWtx/yjQVc49R9SsTf5yfZGbimdCDbb
         1BVCRlRcb5M0h3wnjTrLM8MOGXSmvQpe3raGRKw1eaL1VBpixE9/2GNSuyIwfW1MOsO4
         4u3PUybeNXQ+6+ExlLQZKIQAxhWQoKiecZbSwSDeB6V5T7JVj72lzA/v2aoR/A0MBxbe
         0UJMIelo40e+p7Prav1yReeumHJj+8EyUCZd97rG24cEJ1dFXi+cN9DqkamZOa8P0v5a
         59Knw0Ux8nbVHaUb++lcHm3cYLMza0OOSpleo/pZDwtzlb7slsVIuCGZdSR2x+ViOZOU
         2N5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741376246; x=1741981046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=f0R/WPL0ilUPedsHE6y4OHCq4I0iPcg43ksunJv9v0nojB/It7jztU/zrhM7CjbrG4
         DdREfH6o2Es17tRE/P1AUnNcESBMEHINI8LFORZ2ceUwn5R0sP6Lu6I43sd3n4Vn5nNS
         DNgOiT0hjgBM1oYdc8wEQlfJ6eML0sjsc7AqvA6zoz0B1O3LPvZPr3FSG5Gmk+TYSwO5
         ouhOsKZpDGZu2go1bzsoxE2llRxcYisJ8b5xZKb0MMknfDFhbGiVdupOKBBR3TgeqVjy
         lN8bjzp4ZedMXeECtlygQytD9q/3cge57+y0gXSm3sc8igF8vjiypaPgE4rI1t0jCaGm
         n4IA==
X-Forwarded-Encrypted: i=1; AJvYcCWh15EFU3bmmrMu7+hkYKW98dTSm+6fFYKBpnbDQMNiFuFFa3SiUgagFi89fiA2zoupEa8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0hauWVoiFqYfZQUM2D8M+hYJyHwsDgaB76dMCdYEScpNwXHNC
	sgMEmj7olAScLFW+l4Vn8FufRHyG7r/7z8ec6mPhl8av9fpfN089+4hwv9pqFzU=
X-Gm-Gg: ASbGnctAsA/b3oCsuvqq7k4WC+DZ2dIcrexET6c6ceHsp+jQA+lZPHNPdKKxG0mElaH
	7r6R/lZROzFSV9uuAF7FXM2d90rs9hfjXmKQvsPmg99ZrYPgTbMxyMsgOAu5mdc7LWJOFDV3g9T
	n3LTAQpfcKebv4zYv+C8pPV/RbUv+Lbse5HAU0ms81oHsAk/MEt94Vb2pQcnQKatiJRIF4tx1RD
	iYhFjBUJgq+/iFuYaQNK7AVgKh12QyuIlqxOne/np/flLk2awIrCspazqbo3KUGO7U/JqkuqH2q
	opaH+5uy3oM5Z8buYasEOD+ncyRFF/ap3eUinJjN5blp
X-Google-Smtp-Source: AGHT+IHZK5ChSqOaMo09JMNQrhVS25wP/pkCSoEVH4/5AzuwGO5vlGkUiG7MGthTlS3QETr7obULIA==
X-Received: by 2002:a17:90b:180e:b0:2f9:d0cd:3403 with SMTP id 98e67ed59e1d1-2ffbc1ee5aemr1105732a91.16.1741376246136;
        Fri, 07 Mar 2025 11:37:26 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff693739ecsm3821757a91.26.2025.03.07.11.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:37:25 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: alex.bennee@linaro.org,
	philmd@linaro.org,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
Date: Fri,  7 Mar 2025 11:37:09 -0800
Message-Id: <20250307193712.261415-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
References: <20250307193712.261415-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allows them to be available for common compilation units.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/hyperv/hyperv-proto.h | 12 ++++++++++++
 target/i386/kvm/hyperv-proto.h   | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/hw/hyperv/hyperv-proto.h b/include/hw/hyperv/hyperv-proto.h
index 4a2297307b0..fffc5ce342f 100644
--- a/include/hw/hyperv/hyperv-proto.h
+++ b/include/hw/hyperv/hyperv-proto.h
@@ -61,6 +61,18 @@
 #define HV_MESSAGE_X64_APIC_EOI               0x80010004
 #define HV_MESSAGE_X64_LEGACY_FP_ERROR        0x80010005
 
+/*
+ * Hyper-V Synthetic debug options MSR
+ */
+#define HV_X64_MSR_SYNDBG_CONTROL               0x400000F1
+#define HV_X64_MSR_SYNDBG_STATUS                0x400000F2
+#define HV_X64_MSR_SYNDBG_SEND_BUFFER           0x400000F3
+#define HV_X64_MSR_SYNDBG_RECV_BUFFER           0x400000F4
+#define HV_X64_MSR_SYNDBG_PENDING_BUFFER        0x400000F5
+#define HV_X64_MSR_SYNDBG_OPTIONS               0x400000FF
+
+#define HV_X64_SYNDBG_OPTION_USE_HCALLS         BIT(2)
+
 /*
  * Message flags
  */
diff --git a/target/i386/kvm/hyperv-proto.h b/target/i386/kvm/hyperv-proto.h
index 464fbf09e35..a9f056f2f3e 100644
--- a/target/i386/kvm/hyperv-proto.h
+++ b/target/i386/kvm/hyperv-proto.h
@@ -151,18 +151,6 @@
 #define HV_X64_MSR_STIMER3_CONFIG               0x400000B6
 #define HV_X64_MSR_STIMER3_COUNT                0x400000B7
 
-/*
- * Hyper-V Synthetic debug options MSR
- */
-#define HV_X64_MSR_SYNDBG_CONTROL               0x400000F1
-#define HV_X64_MSR_SYNDBG_STATUS                0x400000F2
-#define HV_X64_MSR_SYNDBG_SEND_BUFFER           0x400000F3
-#define HV_X64_MSR_SYNDBG_RECV_BUFFER           0x400000F4
-#define HV_X64_MSR_SYNDBG_PENDING_BUFFER        0x400000F5
-#define HV_X64_MSR_SYNDBG_OPTIONS               0x400000FF
-
-#define HV_X64_SYNDBG_OPTION_USE_HCALLS         BIT(2)
-
 /*
  * Guest crash notification MSRs
  */
-- 
2.39.5


