Return-Path: <kvm+bounces-57326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02224B5363E
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630EB161428
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 14:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEE4343D9E;
	Thu, 11 Sep 2025 14:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EbVgVaF0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC132ED3E
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757602176; cv=none; b=aV5pDl/+80gz9pmk3fuvXES11rC8Td6I5WVaa2uS93Q/+V53gaRG68pqj/fzAxPoX0ne/ulsrqJyBoY8ou0j8Yc/yOeVLkq8tVzVyyhebOUYUbohsoXtF836/dGemP3p7Mr+seT5lZIwnFzt46RyEPtgvmKrUT38HVYiBQ9jd/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757602176; c=relaxed/simple;
	bh=ykqcLBsCxyMRFiTl7Thb/eUaBwmC39ARNaHnK0Qqi/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=in/bA7aNVZkEH67MPr1+dB2GB309Bv6eU288JuisLAnrEH7gLBoKuSowkUA3P8CXhfRqaJZ1RzOMVuZtjQL47txZhJmuzjtoaB/BEnmJxEMyj7+8v9OtDoXG9t+IT0SNQML4eHZDfsRy+/6LhNLxTAmar7y0C1hUNmnX37X9dzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EbVgVaF0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757602173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0a4n2ZzYOr7lU8ApVVE4XfictzucsNLVIeb31abwSM=;
	b=EbVgVaF0p0aipt/i5iNGrOFPsPFs3KstxfoSEXmU8x6qC00SxucrMfUQypwKafk6TiroRd
	8C0XAmVWh4DJ3jUEDfiHv+kgYXKw0u+mXEkEWRN6DzX4Ryn2vwMx/vOFl6DoEEEBE1/XZ8
	u+72jFxZ4WZBaVCTDXowQYGpQOqp2yE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-p90-BeJsNrq3R6M-b7RmrA-1; Thu, 11 Sep 2025 10:49:32 -0400
X-MC-Unique: p90-BeJsNrq3R6M-b7RmrA-1
X-Mimecast-MFC-AGG-ID: p90-BeJsNrq3R6M-b7RmrA_1757602171
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so11886025e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 07:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757602171; x=1758206971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0a4n2ZzYOr7lU8ApVVE4XfictzucsNLVIeb31abwSM=;
        b=X+07aD4y8RbGLSAE5dJkO6gx08ZcJuutRajNxURFd3m7TKP83ntdF5gMc3UjtpOP85
         suQd1cX+GztaRKdf6QMP0WsybgHbSien4PhLwryWwtJ6+/TQgHbncHuYpZvyoKGZzVup
         h97F3+Dedea9UJjy0XwRzDfHvWbzlltoL4+p7XZLEJ+4Pdwn2ehmBuM2zHILEXm0RIKC
         pWIHnOMrv4JgIPb6+r0OqAP+v1WX9ErYwFubkS5DovbbLa3yWANG66D/YzXA7ctN7LAL
         LsqlKvdce8adqDAVakpKxjuz4R1hy1WpEDoKwN2iPCsYGDbm9qbuVoUkpLkYoUEpaLOf
         jB/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1GstE13gn8SpGERo9DRhsyRswBVq/D8K+tQ42i5ZSSiEeti8lPgf+qNBguo//BN7FVgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyznWC0aQhek72Ovmxh8R7e4Mno7zF/UsXm0fOQFOCgDLzsXykY
	89QwfgTydiqOLjlRRAcaWd1H9P4ZMnZxBDBE8Vu7jcAZf3FuY42RFq6vua6Y3uJ0+QAzi5yWipp
	Ge24XV//zO4pVbhIzTci4FIbKGxbOTuqS4NAUbWiXeVoXD/8wU5PSG+/kqn5iEA==
X-Gm-Gg: ASbGncuIqCntY0reNbMU2xdnY9rVjKlIDHko8OzYKur39hE/WDsW9g/TpxTMv8HdB/C
	NxAa11IKP92hMyHGKoQGoZ5UY2mZo0dmadMWyFd8Lb5LKGVA64nPR4zpSeU3UplGn1bVydU+WKU
	QkGk9eWgC0P01LaSofPpwjpljBA8kFi7Cq6jSn3S2s7ECtaSSh0e9Ub8fn+Gv/4b0QkS2GQdrFI
	YqQQCYR3TwHE41myRKfZ0yTEcJBqbL1Rat4dhk11TeEcGuEtCs3NbO17lto+9iWUVRz/xep2niG
	NLTm8Bguk2JOikcUJNHqNaj8KKFRcza8Mfo+QfHGRHjS7euVw21+MC44GFLCTPVSCR+vNxTf3FR
	2vt6ASP4A+fXnBmDaufxsSza/RiGX
X-Received: by 2002:a5d:5885:0:b0:3e0:63dc:913c with SMTP id ffacd0b85a97d-3e75e0f0321mr3085772f8f.3.1757602171266;
        Thu, 11 Sep 2025 07:49:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw1IcstkmaYZN9of6DaQnGTrA008KACS07maSaSJLOzYY0ys0I9zEDtisEheF3g2dnd82HYQ==
X-Received: by 2002:a5d:5885:0:b0:3e0:63dc:913c with SMTP id ffacd0b85a97d-3e75e0f0321mr3085750f8f.3.1757602170839;
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
Received: from rh.redhat.com (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0159c27csm14941575e9.8.2025.09.11.07.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 07:49:30 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>
Subject: [PATCH 1/2] target/arm/kvm: add constants for new PSCI versions
Date: Thu, 11 Sep 2025 16:49:22 +0200
Message-ID: <20250911144923.24259-2-sebott@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250911144923.24259-1-sebott@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add constants for PSCI version 1_2 and 1_3.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 target/arm/kvm-consts.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
index c44d23dbe7..239a8801df 100644
--- a/target/arm/kvm-consts.h
+++ b/target/arm/kvm-consts.h
@@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
 #define QEMU_PSCI_VERSION_0_2                     0x00002
 #define QEMU_PSCI_VERSION_1_0                     0x10000
 #define QEMU_PSCI_VERSION_1_1                     0x10001
+#define QEMU_PSCI_VERSION_1_2                     0x10002
+#define QEMU_PSCI_VERSION_1_3                     0x10003
 
 MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
 /* We don't bother to check every possible version value */
-- 
2.42.0


