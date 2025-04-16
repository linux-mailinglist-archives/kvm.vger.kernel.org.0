Return-Path: <kvm+bounces-43410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 928A1A8B5F3
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 11:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06C87444C92
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34576238C21;
	Wed, 16 Apr 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCGReCd0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9B236426;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796701; cv=none; b=HIyqgFbkgmpTSAA2DoqDY+IF83smhFWBSssq31PFs00cw5eVmfqSaCuAuszthnbfOjEFG/5FzOYRhBKyVuqBaHpYEflzOKauTf8w9UbymQWFezYRRWuS/YOT4i1E2dUcJaEifTVbDJ3AIRfZCoH+D5cOJPYioIF+js0kFOB+YcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796701; c=relaxed/simple;
	bh=yYZIxP4eDVftHS+35Bjf5qEDsqvjLlou31P6uZ50WKA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N6z9elceUNg5dEnc6QYXe6SkajH8FC0gN41KYgmEX/W7UaiLEbNMskKfeRyfBcX7FiqA/uIJo5xzEIpOa6Ot06kJHRDtbI2ntoZu7sCd437G4fAtBByMf6suJX7EOOLom2voNacJJk1eV2dHaThwWclh3Bi8EOMS/N1plpCtiB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCGReCd0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0A10C4CEEE;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744796700;
	bh=yYZIxP4eDVftHS+35Bjf5qEDsqvjLlou31P6uZ50WKA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TCGReCd0cEKmjkNtA7we6hJ+GgtymTTF7EuDFkMlXZKe5wQlwsumnY9tZSo8n/zc0
	 21ZWbI5r6KRGErwMi/dDmuJtq6LOYx5KnF6rQAkObQzUH1wnEbvHi1QdVsGZGj66Wc
	 iY9cZAuM2Paaseb0Z1i6tZQ+1dTavp5c1wjtPZ/oqgkQnPRfMz+OnjllQ1rcVro0rM
	 VZh5ZWbJHfGbIG4RrEM0zxtOdldbySwtzy9Ww0oal39Ur7u7wrd+xv6m+0weZFe85Y
	 psks7hifOw+5lMCNPBDniJkrqtuqj68pw832qf0OXJZFFUQ3CdlwVaxWsWotQ1vOR1
	 c3GCbBPLxVB7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D974C369C4;
	Wed, 16 Apr 2025 09:45:00 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Wed, 16 Apr 2025 17:44:48 +0800
Subject: [PATCH RFC v2 2/5] mm: add __always_inline for
 page_contains_unaccepted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250416-noautoinline-v2-2-e69a2717530f@uniontech.com>
References: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
In-Reply-To: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
To: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2614;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=ttFdjRheVD1OZ/EkBldHAgXU1FfcO+q/qyDgNDO6xxA=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBn/3wWMkdWR1YmxGEaQM5rETmyOEwb9WgsyzPib
 4h8ODg1HWCJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCZ/98FgAKCRB2HuYUOZmu
 i+cdEADNT/9txgL8kjyC/wPjKEbB4hl/RFInpiCxVodRBNIWw5wpfvJ5vsG8gnTV28kQFDiRMbh
 hKll+Yo1pN1WQwmBS3d0F7h/e18CCNShQvLvfLAloblN1i7M1UgnmKeKL76XXDUKRxxqrQeTHDP
 CUMus0UtivuKibqn8CLVq6e5fbJ1RhwPsbv7D70xVHOM74/icwjmj1dPZu6DpYDfV5l00GYGS2b
 RsSbfDKkS9Y3H0ZIRiS3VMyQ2uK/1lqDTRcNw69OTDtKzeRDqUXkzTmAkZ1yo+XWJbU05MQnvN9
 95PO/4u9U8yOzdSEY/JzzWE8B1jzPggCyIQR3AoEtU8sfvLzO8U1ro3Jw17/wQxZ0LL4csNqfmo
 fMDkPLMBwX4axRH3oyhhJpWNuOne+5V4FZe7ofqs5chLYTiWmguAJff7K3CLwNjtYf9wekUajng
 MeEUFOGz9PS4je56fpstwRPl0osMBPmAQhMUflHy8jGVX4Ai+mMmo72HfvLkq7gg2eqgpyQBohN
 pVdOVMQI8YGR2JwWxAFHXkIHE7b4wdHwN4V18J30GXbYxJ/TDPKqwiiNz0eQmx1nF4kWUuws9WK
 FifDNoUxHM5cv3Bi8sey0k3QP5FiIx0iDAMhW+1X3ikwX72hN0Whkhv84Sn5/keiJ0X/R0RCmo5
 d/FA4FSNrATMSUg==
X-Developer-Key: i=chenlinxuan@uniontech.com; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for chenlinxuan@uniontech.com/default with
 auth_id=380
X-Original-From: Chen Linxuan <chenlinxuan@uniontech.com>
Reply-To: chenlinxuan@uniontech.com

From: Winston Wen <wentao@uniontech.com>

On x86_64 with gcc version 13.3.0, I compile mm/page_alloc.c with:

  make defconfig
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once" \
    mm/page_alloc.o

Then I get a compile error:

    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC      mm/page_alloc.o
  In file included from <command-line>:
  mm/page_alloc.c: In function '__free_unaccepted.isra':
  ././include/linux/compiler_types.h:557:45: error: call to '__compiletime_assert_1013' declared with attribute error: BUILD_BUG failed
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |                                             ^
  ././include/linux/compiler_types.h:538:25: note: in definition of macro '__compiletime_assert'
    538 |                         prefix ## suffix();                             \
        |                         ^~~~~~
  ././include/linux/compiler_types.h:557:9: note: in expansion of macro '_compiletime_assert'
    557 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^~~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^~~~~~~~~~~~~~~~~~
  ./include/linux/build_bug.h:59:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     59 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
        |                     ^~~~~~~~~~~~~~~~
  mm/page_alloc.c:7301:9: note: in expansion of macro 'BUILD_BUG'
   7301 |         BUILD_BUG();
        |         ^~~~~~~~~

Marking page_contains_unaccepted with __always_inline and let dead code
elimination remove reference to __free_unaccepted() here.

Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd6b865cb1abfbd3d2ebd67cdaa5f86d92a62e14..7c0934c818ddc719c2dcb813599708f47d56352c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7286,7 +7286,7 @@ static bool __free_unaccepted(struct page *page)
 
 #else
 
-static bool page_contains_unaccepted(struct page *page, unsigned int order)
+static __always_inline bool page_contains_unaccepted(struct page *page, unsigned int order)
 {
 	return false;
 }

-- 
2.48.1



