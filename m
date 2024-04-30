Return-Path: <kvm+bounces-16289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 619F08B8366
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 01:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D9DB282530
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 23:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6292D21C177;
	Tue, 30 Apr 2024 23:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="keeEguSY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474271C0DE5
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521121; cv=none; b=dn0x9J5bS0NlfAAo1F5QL9oOkE2O1pes78P3AGlpIcbqtkmA0ZZPr0i1rURASsPVlVv4TdfcLASzqLu8NB1YvNRdX4VW21SJlARnAqp9x4sTpucfEFtgbMTFswUZ0O19iwxjCTEDp4hK/NpUe8tCyNxV1iadKkNZdFm0dn/ea/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521121; c=relaxed/simple;
	bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqfDtWWc/zKu91ehPIuVE4SQJNMVi8qUtkiSGTedVL7W5Rnae9P9pl9zc0We75yOgaLuHnDUSdMN1DmdliK7Y4SbmCF/XQxP+T1g6+dZKY27JPuZpzL3j5Oe8ZRBW+6DwbFmCs3fbr+1Db5YNAtA/g4bBsPkMChMRwKbTmuHHC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=keeEguSY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de604ccb373so3710654276.2
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521119; x=1715125919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
        b=keeEguSYKiYQkwXHyB2MrirM7L4y/Sp1KZdZTe1Eb1jtwQtnCsDWIpXRReCNmzLntV
         LaN1vRGXt8Ee/+WveDn79hkXqdatNUKk7+0m0ApxnwA8jk6DQGuWU5HiRiaL6ymJyGyO
         Yt0PhkFkEGuLIC0ibsKHgbJN1rI4ul6Y52GkoerHsIkVg62N96JuJrvtFG+j6kgZdV0O
         81+cIaFsJxjWfMEVeJs2y9JYP7Iwp0gOmXtZCf1DO8OjYA9PRLcQ1pnT3fkcWLCI4g2a
         Us1YG8JSmxTJ2OQb9puJS6qNWWaBllS5bnXGdD7qVSx55UTthCEPpOmyKbbveYBZJqEZ
         f5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521119; x=1715125919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2QdI2TgmxQKTHiSdbJTZcZLPJCgb3K62uskVNaaDbcM=;
        b=GhFWJyO3Tp7W8yr0ePNZy54EXyNughqGeIN8eWIpZHgbZCm6ul+Gn8nL454qhsvk/U
         oMwOmDVf2c2CDamcoJSiJmdiauBmy1wlPRRYGmn4zXolA1E7IV4AomkH0VLu2usrSLkQ
         p6t8U9Q7sz27AhG5fQhn/bm4BlpkBAvMFEr5tcUrMnquLIfk9bAIxDqP1tH8ZVdntWX+
         wzSyEcdx153aRtjVlAvzVhl9cytAUV99SDiKefZWcijyRfztJrKFR39Z50D9setX5w7S
         ltycTTDm8MgmYLDLPWeJ4XLyDmUQ8U+0eTfXANR4DII97QWgDj+dbLnoA+3jVNH1nT/I
         d96A==
X-Forwarded-Encrypted: i=1; AJvYcCXj0xtXqM/6znNNWeTQ04Z9RC6dtTRM/umFgVPPXeyEP232UNstjkdrqBBOY+kABmja+k+zW1aqbmC9nUPYr0/BocQR
X-Gm-Message-State: AOJu0YxqOhEduB9sWNEpva5SOn7Z2jJrtUSVb6Y0NFjMewJY4i2qxcxd
	2OXdVvwSdLzx0eEjjZzXwer/0aqnz64dpA3A9k/omGiRcPj4bs/XZD9an+aNpcYSwfLL4Hc37nb
	83g==
X-Google-Smtp-Source: AGHT+IGe0w5VioNgUdFLQOVwPulyr7LeCwc9ZxlwAi+xzV7TnsXxdL7cdDTZYaAKG9NQO48kQtKteAJhBhA=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:2b83:b0:de5:1e69:642c with SMTP id
 fj3-20020a0569022b8300b00de51e69642cmr175231ybb.5.1714521119181; Tue, 30 Apr
 2024 16:51:59 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:18 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-10-edliaw@google.com>
Subject: [PATCH v1 09/10] selftests/tdx: Compile with -D_GNU_SOURCE
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
 tools/testing/selftests/tdx/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/tdx/Makefile b/tools/testing/selftests/tdx/Makefile
index 306e9c4d5ef7..5a084a792a21 100644
--- a/tools/testing/selftests/tdx/Makefile
+++ b/tools/testing/selftests/tdx/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0

-CFLAGS += -O3 -Wl,-no-as-needed -Wall $(KHDR_INCLUDES) -static
+CFLAGS += -O3 -Wl,-no-as-needed -Wall -D_GNU_SOURCE $(KHDR_INCLUDES) -static

 TEST_GEN_PROGS := tdx_guest_test

--
2.45.0.rc0.197.gbae5840b3b-goog


