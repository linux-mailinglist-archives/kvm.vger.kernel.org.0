Return-Path: <kvm+bounces-44656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5ECAA0132
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F2557ACE99
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 04:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7529B2749F4;
	Tue, 29 Apr 2025 04:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyUVqYls"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5029126FD8D;
	Tue, 29 Apr 2025 04:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745899577; cv=none; b=pFwwZyUzNducPm97OFRzIhtLxtxW6b43Tkh0Qowfp2cNBPlU9gir/CzvoegEfQCQKSNf1tlaoWTDxKk1egWKmSo6wLvWE0OENSQ8vSgcUzU5p4R/CLahwwPhNSyIwtu34ciMuZ9ippRZHoSGZ6Rzsp0aAdDMdawKi4v4pALUDcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745899577; c=relaxed/simple;
	bh=pJ9VpLz2vL2PDt7J0K2cXMYeDKnStbQajileR/wxzK8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CMwpHyCugxficVLcWNaGT+zUJwhXfiCeJU9tdOe6AkRXOZ68lf1K5ADU85r46ErihKvjDPNbdotSMxMN4jEUCvzpMEJ3ENvSNxFg5IXpcOQ7GCvJ8OQ7w6yyNtT4qPxsW0Hn9u1MoivrHRUCXt4rEFhQc1krrwiUR2PYKqrh3Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyUVqYls; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD555C4CEF1;
	Tue, 29 Apr 2025 04:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745899576;
	bh=pJ9VpLz2vL2PDt7J0K2cXMYeDKnStbQajileR/wxzK8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FyUVqYls/+KqU5DpInz9ZWqZ/4CAAzIPkLtTAq2+9vTbtkfDvRR2CjebexTY9QBGl
	 a18CtmbbDxF0tvb3AcYhTkIyRG0rGmIkJvOQyXGZmREvsxGc9clSCgXVDMI44bfCOB
	 RwUBZ5vLAptbw96/QZcz10zYj2Ww1cjxiuhaCIV1kmi57bliowHPSI7urlxZe9vKEG
	 oDldZTQDIsI86OtD5RmJoGS5Kqw98y9Y2hrIZWtmhbDW+Op3bNrJJxNcoQ6l/9xD1A
	 sZMVPjVE+TJH9Zf+qU8izf83pAhbghYD3h20CeX6p7lBgVhUV7G4DchS76qQNbjUfj
	 iEE1ouz0ZXZDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4A1C3ABA6;
	Tue, 29 Apr 2025 04:06:16 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+chenlinxuan.uniontech.com@kernel.org>
Date: Tue, 29 Apr 2025 12:06:06 +0800
Subject: [PATCH RFC v3 2/8] mm: add __always_inline for
 page_contains_unaccepted
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250429-noautoinline-v3-2-4c49f28ea5b5@uniontech.com>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
In-Reply-To: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
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
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Juergen Gross <jgross@suse.com>, 
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>, 
 kasan-dev@googlegroups.com, xen-devel@lists.xenproject.org, 
 Chen Linxuan <chenlinxuan@uniontech.com>, 
 Changbin Du <changbin.du@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2614;
 i=chenlinxuan@uniontech.com; h=from:subject:message-id;
 bh=+y8wKlsn55GLtsirs4Essnozl8lVGDb1RUHKRb3UGRw=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBoEFAvQHTkSNXJxyOgEHVD9PhzBBGToDo54ToKB
 JTzQ3Bt13uJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCaBBQLwAKCRB2HuYUOZmu
 i2wDD/94Tikof0KqTbmGNltSJN0BkZfS5swTBN23SRIvCigAsJMsSAEE8+hsOfF5ug0IHuwNOI/
 1Qnd48PesFnCihU7hm3JfucE304u3ikq3JpHS8byjD3Iq2171RsPQwl30uxz+vEZ8hzs0TpTQBL
 tbOgvO5HS5tVi2N8UEoiRrD/AIGE1AKJx646BKh7BWEfqlVn8Piwh3FS7UZcthV+4LqoV/TILJ5
 CqwIUJDj8ZerV5DorB5SDBkZEPqwYLdujwzVjj9cp8vZwKMj+w/cFPS+07AzMtQNZybB8QumHsU
 DHQmASWQEn05ggN/6NnlkKJvxaDxaREGdoSN4rVPnwenoh7XG44AwW+NWt2oRVUae7CdZaTJ02f
 UozQggCd6pQA5H1c2SG9aalj7diOg0zrkq7srXqL9aVnJGeGkbSHAIxpmoG3bA+uXmBJSKWtr2+
 7DF6eO6UhF2ql4ur4skO7HIRADaqOFdEcIXMoQ8iutz4ml3kKwVIMhsOOAXwoXgNTZw6dPFvTUK
 oOGrXVNKLy/fJX/0x7AiWVUMQSMsG/Kuios2R+atYaJYgzNmP+h2IF2Il+UfCg1zti1vGWy17fO
 jFSai1Av+dm6o4iuFeMJx4Tgo52MAnqfyksIfcNlB+/tDcM4IwZn3C7WTQp9uxdiHyZV0edPtRS
 Z2AKjqx+hU/5gsw==
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
index 5669baf2a6fea75c17b2be426443a6cf29051f52..433dc1936114469a323c8f3659730747965b2c3d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7346,7 +7346,7 @@ static bool __free_unaccepted(struct page *page)
 
 #else
 
-static bool page_contains_unaccepted(struct page *page, unsigned int order)
+static __always_inline bool page_contains_unaccepted(struct page *page, unsigned int order)
 {
 	return false;
 }

-- 
2.43.0



