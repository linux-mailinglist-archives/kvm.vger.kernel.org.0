Return-Path: <kvm+bounces-4721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29742816FD3
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 14:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCC7D2850BF
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 13:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2FAE73474;
	Mon, 18 Dec 2023 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="G8fim5ol"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8945D757
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 12:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3366e78d872so36400f8f.3
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 04:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1702904160; x=1703508960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qFlMLW3lbmBOgbrUvyiSRqYIDiG+lqtsuLXo/LJqdTg=;
        b=G8fim5ol2FISZOH8HVSQF7dHsc/9lf6RZ0x0DET8P5HtLFLhxvQ8Di5OLmJHlVY+8o
         CwFzH6tIz9EkF4dh1lZTGS8rD+IZEOrIxrKz8x/1drWuTPFGKyRCq7drL84+SXvnGdNa
         N/xLoEadgpxPFqcVPBmv1wg/6yMlzeqYKi1TDf6IUjY1Y13KDNjb1vi3ajYDZ2wDh7jg
         BzZmReZ7yB6W9Ldf82Vs4hXJXqcrWfEgMCrRrtS8shCnyfMVhszbq/ailKT/qCyq0B24
         qZrXnYt82ptGlapY6LaTNxIuSkTPBrIjcQFILBuiBLe7r6NWI+NdbodzSO8iJ6oaueCw
         qJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702904160; x=1703508960;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFlMLW3lbmBOgbrUvyiSRqYIDiG+lqtsuLXo/LJqdTg=;
        b=WPkEo0hdcs4g/8hQI4FtKo/fJuPXfcIhd1urucbOCc/77pJ+Z+6b2tbk4Ym01vKSLz
         FwCEn0PVpLq9a7aQ+FB5DVeyXvn2D5lVbvsUZwC3uE07wVvY1Y/gJo9FNj3zL5LrnwUD
         MgejeGtjxz+xUpyj/QflalkY5s/LSuWT0PJSMWkeCJ+aRtT14vYfcaqNrXOF+lNb8X2o
         y01N+VKh+WzhhzRKAjFMr4EuuqJUPnpGnDsp/OIR2wISitSQx3qzpbKU2ya2Nnuvqae6
         +tcTjDsnCHu5LC9IVX/GCIrSGejQyWoNn0DaJj83BlUq9A5ZDBqrEoCGa4I9xJ6AQgmo
         WHrQ==
X-Gm-Message-State: AOJu0Yy/BdTV1NQrCaUokhafQSiZyx0Bx/yJKj1nCwhfXKfElZwAUIln
	xbzWxkEHRHqDHk2T0hsbuhDSx5rPjcUpAYmf2ic=
X-Google-Smtp-Source: AGHT+IGwAQOTBL28mytqsSh5lYWCWCkPsaMTwMqsNSCTjBAnflwOT/lIdoZf3ECbdtkDuftxJPN+oA==
X-Received: by 2002:a7b:c5ca:0:b0:40c:3ced:ebd7 with SMTP id n10-20020a7bc5ca000000b0040c3cedebd7mr4045978wmk.247.1702904159957;
        Mon, 18 Dec 2023 04:55:59 -0800 (PST)
Received: from lb02065.fritz.box ([2001:9e8:1422:6200:7919:37b:2a37:376])
        by smtp.gmail.com with ESMTPSA id e6-20020adf9bc6000000b003366cac55f4sm1244304wrc.107.2023.12.18.04.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 04:55:59 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86/msr: Fix typo in output SMR
Date: Mon, 18 Dec 2023 13:55:59 +0100
Message-Id: <20231218125559.604107-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

s/SMR/MSR
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 x86/msr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 3a041fab160a..08e087176b25 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -90,7 +90,7 @@ static void test_wrmsr(u32 msr, const char *name, unsigned long long val)
 	unsigned char vector = wrmsr_safe(msr, val);
 
 	report(!vector,
-	       "Expected success on WRSMR(%s, 0x%llx), got vector %d",
+	       "Expected success on WRMSR(%s, 0x%llx), got vector %d",
 	       name, val, vector);
 }
 
@@ -99,7 +99,7 @@ static void test_wrmsr_fault(u32 msr, const char *name, unsigned long long val)
 	unsigned char vector = wrmsr_safe(msr, val);
 
 	report(vector == GP_VECTOR,
-	       "Expected #GP on WRSMR(%s, 0x%llx), got vector %d",
+	       "Expected #GP on WRMSR(%s, 0x%llx), got vector %d",
 	       name, val, vector);
 }
 
@@ -109,7 +109,7 @@ static void test_rdmsr_fault(u32 msr, const char *name)
 	unsigned char vector = rdmsr_safe(msr, &ignored);
 
 	report(vector == GP_VECTOR,
-	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
+	       "Expected #GP on RDMSR(%s), got vector %d", name, vector);
 }
 
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
-- 
2.34.1


