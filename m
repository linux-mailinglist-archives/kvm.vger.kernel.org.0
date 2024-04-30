Return-Path: <kvm+bounces-16290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B26E8B836D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 01:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A85F1C22512
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 23:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614E93DABEA;
	Tue, 30 Apr 2024 23:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="folleoKM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8C821C18C
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 23:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521126; cv=none; b=nC6Q+1NfrZhIToTbLM19v5WgB1Zm6HDI2X0RTdy3szxJmIpkLOZP/bA0XjUhXRIRYuAcksPqIg+rWUADzMZ6d++uXutWb9Xx/Z3BONzb5jqQXrdiJgFRUZaMD5jfb+vfWz7oBw0pCZc2htf0pipylTD+xlLNDtovIbIYJ2TzGRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521126; c=relaxed/simple;
	bh=Cwp4S5VNvQqFtoPw/nroKEGF2YpUUdO6wVGQiqGsbAY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d7Y+7r/PnTeVzZOb159FDv5IiQfUG4Nz1WcxLvU2wgT4JqN5Kql0Uj8VyuhulrA1MRGxLtdfPprONfz0z3uuMXHvefpEsJZhTGTRMYnTL0xmvWqr8jjdjpxdfhsuuZxXtPbsnNDP/kWI5Wr0OyfoQbHLv29C3OVCv/lQqXm7Beo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=folleoKM; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de60321ce6cso4217453276.1
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521124; x=1715125924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eMZD6S1LecT7yIEbG0UvTaidEBINYi20NzKFmLDZVV4=;
        b=folleoKMFVRvi8dW0bCiqpuMPxaVBXHSqPGhHmRQaNl6zqayRuzzzaiG2Tb3zA83iP
         morx19xZkRe6kEGkwp1Zt+otnWqi/wra9Jb0bO1/Cm/jVdJepjsIOnu97ooL44chizIz
         H/v35//62TlWRSkl0h+OKxiamUjvRTtlnlfn8QDJNf8qbRLbdsmF+tZPhYYzgXZZ/RSo
         YEKSrhK5D5pa9B/One0ZHUJcy8B1+rkGOQPtDSHsZwe9h8sMxuMuxxn/eXV1AwN3nQo0
         wbJ4oDqc8rKxRh8+Zo96DUlmHEPSLi+8zvO0fX9aMDpyv+Eyc3XFv7dDyoeSRtKfGd5h
         YqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521124; x=1715125924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eMZD6S1LecT7yIEbG0UvTaidEBINYi20NzKFmLDZVV4=;
        b=O/CdYBUlKCj3CBbza6pypIZwYuT0fexZ1dugc0hyPG7SScVI/TxaSbp2tk4496n31H
         Ph9aj6ohHCEFBvF8+/Y3++Th+OzcIaO7u3wSas4/eA44ydD+ihkizRvc16VRbd07cY6P
         4c1aNafIXkAjn1jbs31nUSdvwy/boomMdAzre5aojB2ZhkRXrj76SZaqALsZFNPYH3xQ
         Tx83ntxcWLpNt6q1bzjnPVDDyiVs1NpdTB3+sy0YijKrXQsFE2KzHd8r6KDRaWNiTXrk
         WAQo7SHdGqDh86lTeb65DlKUbi5D7T9yt8pxIDSVmpCeMi3l11ME3nOKaE1SgdNRGNA1
         KR7g==
X-Forwarded-Encrypted: i=1; AJvYcCW6qh1RJ15IaTLbJYdXbXzBPKCWLkM1glNhusHuKyt7+AwvO7/Jr1oLKC5Dft/MVhdaRMuFKwKDwqdooFhbCy0W3wlt
X-Gm-Message-State: AOJu0YwL5ZT1AIDZDGebtAKNPON4MkSkXb/fGKq1je4H1fnRHoWTBx3u
	BhfCB5UxfnOyZ0FXpGsQn1puKBu8CPVb+OoH8fxmYIrRS/pD/B5K+LldoqxqmRj3fB9uWLphSFb
	UiA==
X-Google-Smtp-Source: AGHT+IH4VJpB6ZdNUNwNGYphVaIrnOi2jx2Xja9WJZJclJ5U3AS0GX9uELFDr7+Yl08gZsB5HUor9KgguaE=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:154b:b0:de5:3003:4b7b with SMTP id
 r11-20020a056902154b00b00de530034b7bmr333229ybu.1.1714521124169; Tue, 30 Apr
 2024 16:52:04 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:19 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-11-edliaw@google.com>
Subject: [PATCH v1 10/10] selftests/user_events: Compiled with -D_GNU_SOURCE
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Bongsu Jeon <bongsu.jeon@samsung.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Edward Liaw <edliaw@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-sound@vger.kernel.org, 
	linux-input@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
asprintf into kselftest_harness.h, which is a GNU extension and needs
_GNU_SOURCE to either be defined prior to including headers or with the
-D_GNU_SOURCE flag passed to the compiler.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/user_events/Makefile   | 2 +-
 tools/testing/selftests/user_events/abi_test.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/user_events/Makefile b/tools/testing/selftests/user_events/Makefile
index 10fcd0066203..344a71769113 100644
--- a/tools/testing/selftests/user_events/Makefile
+++ b/tools/testing/selftests/user_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
+CFLAGS += -Wl,-no-as-needed -Wall -D_GNU_SOURCE $(KHDR_INCLUDES)
 LDLIBS += -lrt -lpthread -lm

 TEST_GEN_PROGS = ftrace_test dyn_test perf_test abi_test
diff --git a/tools/testing/selftests/user_events/abi_test.c b/tools/testing/selftests/user_events/abi_test.c
index 7288a05136ba..3e3a0327afdc 100644
--- a/tools/testing/selftests/user_events/abi_test.c
+++ b/tools/testing/selftests/user_events/abi_test.c
@@ -5,7 +5,6 @@
  * Copyright (c) 2022 Beau Belgrave <beaub@linux.microsoft.com>
  */

-#define _GNU_SOURCE
 #include <sched.h>

 #include <errno.h>
--
2.45.0.rc0.197.gbae5840b3b-goog


