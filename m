Return-Path: <kvm+bounces-40455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA2BA5742E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74F983B13AA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8B12580CE;
	Fri,  7 Mar 2025 21:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B1DF5/xd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3437A256C93
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384599; cv=none; b=MZpApMu85kV99xTePWSTei/e7n2RWG4r/sJ+j3fpk7OpLK59ilhE4/iWNG7EMqb5Aogtqoe0i5+bKP1G2Pn6P8hR0J+FDYJxjEhK+oBuf6kwHoiSw8v6Bqd0Kc5i4XgcTn/Q/2is2uu+fEKgYnPEwnyFZ7j/I0xlS8veFkmQI2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384599; c=relaxed/simple;
	bh=f6ywhfIHAeGjN6dW94oj9dG+w9FoBwMOqVbaNl3zrqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgAxy75hq5lYVK5F9qcm2ePBJTeAtaN+t2wjtnSCRbVDok/PmGCavG0KsNBC1bzwqmkLyRwP+KVMZdnhEu3pSUMmnWQgq9TQwV+O1CU0MfIUZcuR1ICz2mk4XPB+Z6qhzFcIH9q5KwqTl9SO22isF6ZsT1Ck0nh83QERRZlF+DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B1DF5/xd; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22398e09e39so44399495ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384597; x=1741989397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=B1DF5/xdIhZZIBiC516dvMWDf8InRuFfq5M065d9LxLUCIpEolUuRXZ1UUpf0VgrNV
         IQZLYfgTPqwTN+1xkCL9AvXc/aVN5+iYCi1clFIVDWb0fPEocz9QyKqNTDISO/6izvAz
         uMFZsZ61jY2loJ14xgbXYo/rxriZqluXcHDDfTWhqUvf3miHIQ+jPz2U2nLjOVC73aiQ
         aRQXmzi6Azq7fRnhuLaYiBbflRazI1HoHIB8REcgUDdumUtmusUZaGfVsYOxQiVV8S8f
         l7PTEXN+yihfyF95/+Ok02I+DUdhnHgjkcsOss1MH9488Y+PY4aV0vIag713g9Skje6Z
         D/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384597; x=1741989397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUvuEjETtAwgjY+HHVzD3fRoYrhNXj1rMDKPunM+tus=;
        b=ZIQGJ+nsb6j8wf71xjjg2s/Gr5IRKcqlziFH8uuLnCzLqVPryxvRlSjKHB1sXrJzvY
         uU1viosz4IphNzWjxhUgR5d/sPF18c6J8kJ6qvYGWLonHm17q3O68iTm9zP6UHZrdBnT
         E/oe1P15SEYdTwUDpt+NzAzIxq44wl4XH2WuQx20ZX3OvxiD3LJrmy4XeXIg3R2pIbS0
         b+AfOhxZZt4SELnBYLkdktpLziDDGjcHnoI1R8TMMR4mqACLIIb0UWTwoRq5AAv7oP0Z
         SDb6JFwpmTlj25Egk2Gx/qP2PosVoQf/nV3ZjoliFUOwPaqGd8WwhivuuOdDmizAXQ/+
         PIdw==
X-Forwarded-Encrypted: i=1; AJvYcCXG1F4KTlWxl05eMZWf5e1JXl8FB7nF7vl9QrliQTePxXg/fI61p1MTBTOHK0FfYaTGERs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWwTQre5M9WOSmwVkiR4Dfs1W0iEDHGAjrWbVFLjvm6wfnOTIB
	VIQUaUF0/ts1hVgnaGskKB7GPS4u4ONKC7c5xoRyRCsMFXk/1IKrM2xqqkE0+6o=
X-Gm-Gg: ASbGncskn3bmhwdgudJoN0HAwqR4Hupz/xY5OQLlUShCbSsW5w6nVKnFAz7ZR+oLly1
	/SGAtmBWB7r+XNM9NOoLJWYNbmoMAHlVugsgDMHBVKz7GwRc4NZzsful3fIjsSW4JrigrYXp++q
	Wrlfzn7jBtU35nNx1Y2rv3peNifURhOFnHWHWWin/aHfrtX/r/fb5e/vO7yhRR3UioIuF9B0M3K
	vp+B7jUSJK6xNfIW7cgWxeA1WIJeh8NEwHKocUT3Gwy3pXrV9231qEdwNjEc6icRu3xXy6Oa7yO
	8v3bV9eNId+tUyiUiH/bzHLEOjreY37cgOjMRIBTqghJ
X-Google-Smtp-Source: AGHT+IHLPRxB/7hl1LzXp8g7IAxNiV/3hkTKlh4ALyWckQE4KO22jH6W1sRSH0NFB/92LHK2TzzblQ==
X-Received: by 2002:a05:6a00:b86:b0:736:50c4:3e0f with SMTP id d2e1a72fcca58-736aaa373b8mr6645441b3a.10.1741384597425;
        Fri, 07 Mar 2025 13:56:37 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:37 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition from target/i386
Date: Fri,  7 Mar 2025 13:56:20 -0800
Message-Id: <20250307215623.524987-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
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


