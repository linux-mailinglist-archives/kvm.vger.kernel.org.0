Return-Path: <kvm+bounces-14293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE10F8A1EEB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E20B4B2E189
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0015E59151;
	Thu, 11 Apr 2024 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QciO199u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A078458AB9
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856595; cv=none; b=PkxFLQl8sk/5xnKujxJDDXy6vLvN9wbENtihxrP4sYn84pfsLE/4nfPKKWOCLAMQl5YEfWxy2tGHrNSL5PzYn8DLADQABhZid7hjxw/xg8Zf/YoGkipkfhmnkF8iMnR6B0sUDcRt4eN4bo7Z66ybmM5HxbFsx++6qpxMsIJDTII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856595; c=relaxed/simple;
	bh=LxpqhNiHAz6SvsLDXG7NrMJEe2ibA6UXfjbUpU8Y7ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uqArunmBD4RCZVv1QjC1Ew7Z5vfKEovchviuy1FA2aYJ0eEzmLwISl7rabvXGvs3ALUkyPMqQ4ZjMqzt5qEk5Lp9TloDqQKd3Jwx4+1i4+EIcf9LPrEm0hRN2V+OsVUjYY5Rzs4C0hd9FrMdC8HafsUf/RayX9mP6VK1lpQ1Wnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QciO199u; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516ef30b16eso75934e87.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856591; x=1713461391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xin2iwTu/4c1Gy3XovoLyL3hBpjPxSwWtnXs1CtSYxs=;
        b=QciO199uQA0lJG8ea6YAXd+jsrJaC+Ke4STyirpzDF/EcUrBYfjsX6wnCj3X1sONn5
         zq71XTuW/iQ/wGzFt3fMeeQEfl5yHnvXSTBjfXYLCR3L83OokYPnPD/yqc/uSWc97He4
         j8s6wH1kuwCAFdGMksW2fXg6EskcvySYSCIQPmHzrkCeXTzfisK71ToRQ7229cQGmFOK
         hhOWD2jVkikDMd19xbFmXdG6s+jHV1iQ0sKJDGKM0vnp+oz0d9chIhBbX6LReH9pf1mo
         LaDQd9Qv3u5e5wTSVVCY/K8fVKa8w5cuQniK68nXH+1GSFQmun2Jcov5uPBya8T9t3xB
         EB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856591; x=1713461391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xin2iwTu/4c1Gy3XovoLyL3hBpjPxSwWtnXs1CtSYxs=;
        b=cIN+dbLR6dsR5FypBpEPIyOMfQ2uv+ldWl/hsIb/aZFIpYtjr7ZsEzCvCQANk+UcqL
         sUd42ICPeP08gFg8Z8sMrot5Z9QFrEbtqrkId1OjXz9/vh6rhksiCoaiLczEQHJuBh1c
         TAKBojx0e3xqOk1b6FqvWx0BKt611g7MYjXD3rRZicv1TSFBcablxJycZ69LzN+JzmGK
         7L+iUoNAnOttUn9btouO6OE7wuvnk6Hh5mNLnQVtRInd3+pNX9W9dlNwJZjO6QcxiW/r
         5ZwDuNnOAA3wXbfguUYywt9b4cP5i42Z4YQ/9n3h/J9K1/+MKZLOI8DhKDJ7bLQz03Y8
         kBfA==
X-Gm-Message-State: AOJu0YzNevWAFfBs+Nm4szc/z+CHGtuxogsynhCpWkMhQs+T2QiZ8edz
	RLzQrILpswNWtz0Lg/gVyrTirtS/GOZQn+3Fi/E+nhdTauFXYWreVF8aRFyx
X-Google-Smtp-Source: AGHT+IED1zcSNLp9rL73aggnjZLBMyXApKckRGHLXhfl3SbYNdBvIw0pykUDBI67RZ8Rp3w270vMzg==
X-Received: by 2002:a05:6512:308f:b0:513:39a0:1fec with SMTP id z15-20020a056512308f00b0051339a01fecmr232477lfd.66.1712856591062;
        Thu, 11 Apr 2024 10:29:51 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:50 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v6 02/11] x86: Move svm.h to lib/x86/
Date: Thu, 11 Apr 2024 19:29:35 +0200
Message-Id: <20240411172944.23089-3-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

This enables sharing common definitions across testcases and lib/.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 {x86 => lib/x86}/svm.h | 0
 x86/svm.c              | 2 +-
 x86/svm_tests.c        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {x86 => lib/x86}/svm.h (100%)

diff --git a/x86/svm.h b/lib/x86/svm.h
similarity index 100%
rename from x86/svm.h
rename to lib/x86/svm.h
diff --git a/x86/svm.c b/x86/svm.c
index e715e270..252d5301 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -2,7 +2,7 @@
  * Framework for testing nested virtualization
  */

-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c81b7465..a180939f 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
--
2.34.1


