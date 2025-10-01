Return-Path: <kvm+bounces-59348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55542BB167B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F3763AAA0E
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6F5280CC8;
	Wed,  1 Oct 2025 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CNu0czQQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBDA34BA32
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759341322; cv=none; b=hqkHeK/M03mVU0PokaynEsbDcUkXmQvbqdoDze60aKdcdFAIeZGJ0yQdtCxbfgODUwmpTmBPGwxZo3i5f7XH2hb17FD0+8u4WXhlnrgr6j+HRs4j/gxJg/LBs8rL2PAZOK8ZuzWe65kvyY/A7XsnfrNA2WagphlYvDlHUtxcfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759341322; c=relaxed/simple;
	bh=RLJB04zsfmjnLU28BQFqPocNRh5UssJSNCzKG8MgGoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAoN4INIx35Ka2KJswnzcHDx6wWwwXghWdjmGouO1m9KyyxbPdkRa5ds4NPhgM+urn046iS/yR4QVq3K+6R6a6TJkAVou6W9IPjeCt6FFBeA6WugO42J9/0UCjLKg7mg8scwN0lqYLpCZO2AwjbwVgPr3bLZcCQ2H+4ecOWjSIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CNu0czQQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-46e504975dbso612265e9.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759341318; x=1759946118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkQiV8/WxMAsAF/tO7oGNDf2WwINp6DCDeDQzDnnWeY=;
        b=CNu0czQQJ85sxnoIoPXdqB0+hDnnY0RxqzJoQi6ePgA9WC5ztF7sqn8mbfq+YnFam0
         Zq8UKsYVd/zIiFnJdC5wLdldPuRooXuqjWurcOvlTKdE6u91xe7O5yP9ETG3TOLS8DdF
         UT0dKQQ+HlGY+PDTcQfdijZJWLUp+SYtSvTnJwxR97OPHo0/TsaSdjkM6CPwv6rdNmiz
         pOZpWKQO0pte9FZh2wdgpjU9J4DxSX78C52dSpxPS23XzaNwXqg7CSaDLLIWEmQYbqm2
         77ao5V1gBoQc3xoD3Ax/nm0z9I45CHWlTPtiGZWE1Uao/YRhWBXrK07/91EW/HPC7H+E
         xNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759341318; x=1759946118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkQiV8/WxMAsAF/tO7oGNDf2WwINp6DCDeDQzDnnWeY=;
        b=Q+e1lYn16TEr5/nHCtMtJeplkTLujp8W0j5t+j9oH/PKtydVWAgWNdNLzDsB7NSn8g
         kENbEaxQPg7BcWMAd+eDnAwrxbABd1b3myys2ErwQbv9P7QWCkCoWWXrYegPa8tiWz7+
         VSf6/wnuvn+LVIOgK3xVRg5xjiIxVv5dI1Nhiaf248ynjtp/Vl0j68dAM/mNY7zlCeza
         nZumAxpyZMDo0+scZ8483G5h3V+emhfYweahx6uFAfVmlFrlRKMXcdv9qdLa7QUEEOPs
         B2qLIc5VC0/oVJUGpj9FEuIpEfTdHnw9xdMasV0ao6np7T8LTgZZtaa7EtVwOISIw2IC
         g84Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6yKmUV6dSBZ6fGlZjVn8V3HSY3WWYyx0uq7mMR82XdgHR2i2Jhg5ykk2AAL0U4Uq34A4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9Lxa/wyPgpHCMPHZ3DGIBOlqVARF6Hj3OWIGa0MnUiDodpGT+
	lhy4YZekl6K0/HMpPCnP/gXRuzubeu21L4Tr2R5eD/qEkxMSJFX3kg8lQEsq3R+tIn4=
X-Gm-Gg: ASbGnctHTPqMC8/2OR73Iut6dijT1VCzqI5B+4t0SELlTp3rWl+vZEE1CCThKP8YPl1
	OFZw2r5+jRLsRkCi+Z6pOLxNwiK1pz6ISayiALf5CWlnMtWxcYePlS4Wnb/3RD4XJhpv3Wj5Zor
	bONB1DkWV4N1x9RiWtg4j/0F5TLJZLFmyoarC+aKlWAAHhWYEQZbRJWfZCiLpj1dUN+FBbO+QtK
	joA58cZPu3PMhvx+z9PI/ePh7ABjNquryD39pbz9e4+sEhddkVojeWMP5lqSerBAQ7ckKZOwOeY
	BjAh+irCnAWq+HM9nFNJfwNQibfhel7z27kWpZl/yfpNbh+mS8lttyPDxu6LtAk6anyHvusM5TK
	QfYma/4zE36CEhkJAN/YlgS7faviTGq9iJCGTLVP4QD4JZ6B65GJXVNoVUZwvT2acGC0UO9Wt1I
	RA0sW9B7m6QGKkdJyVuzp/2KWjcQ==
X-Google-Smtp-Source: AGHT+IHHgUi4fwM6+XTet857QFCrk3UGmPYPPJoZifC7y5X6DWSEAq4/DeuzncR1cjyeDBGduhFF9g==
X-Received: by 2002:a5d:64e6:0:b0:3ec:e152:e2ce with SMTP id ffacd0b85a97d-4255780b3bfmr3329278f8f.32.1759341318066;
        Wed, 01 Oct 2025 10:55:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f02a8sm90075f8f.39.2025.10.01.10.55.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 10:55:17 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	qemu-ppc@nongnu.org,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Eric Farman <farman@linux.ibm.com>,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v2 05/18] target/arm/tcg/mte: Include missing 'exec/target_page.h' header
Date: Wed,  1 Oct 2025 19:54:34 +0200
Message-ID: <20251001175448.18933-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001175448.18933-1-philmd@linaro.org>
References: <20251001175448.18933-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "exec/target_page.h" header is indirectly pulled from
"system/ram_addr.h". Include it explicitly, in order to
avoid unrelated issues when refactoring "system/ram_addr.h":

  target/arm/tcg/mte_helper.c:815:23: error: use of undeclared identifier 'TARGET_PAGE_MASK'
    815 |     prev_page = ptr & TARGET_PAGE_MASK;
        |                       ^
  target/arm/tcg/mte_helper.c:816:29: error: use of undeclared identifier 'TARGET_PAGE_SIZE'
    816 |     next_page = prev_page + TARGET_PAGE_SIZE;
        |                             ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/tcg/mte_helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 302e899287c..7d80244788e 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -21,6 +21,7 @@
 #include "qemu/log.h"
 #include "cpu.h"
 #include "internals.h"
+#include "exec/target_page.h"
 #include "exec/page-protection.h"
 #ifdef CONFIG_USER_ONLY
 #include "user/cpu_loop.h"
-- 
2.51.0


