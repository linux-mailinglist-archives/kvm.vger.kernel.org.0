Return-Path: <kvm+bounces-4963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 757FE81A669
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 18:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A82571C251E3
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7FD47A7B;
	Wed, 20 Dec 2023 17:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="rEh/C1FU"
X-Original-To: kvm@vger.kernel.org
Received: from forward202c.mail.yandex.net (forward202c.mail.yandex.net [178.154.239.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ECB47A54
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from forward102b.mail.yandex.net (forward102b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d102])
	by forward202c.mail.yandex.net (Yandex) with ESMTP id A6BBA65DA5
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 20:32:13 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-91.myt.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:581d:0:640:bf96:0])
	by forward102b.mail.yandex.net (Yandex) with ESMTP id 5605D60910;
	Wed, 20 Dec 2023 20:32:05 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.myt.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 4WRPGCC1MSw0-luNpen2o;
	Wed, 20 Dec 2023 20:32:04 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1703093524; bh=/Ow7h+7kjCXvhE5m0tBOIjU/JKovnbmEoE3iQyYvcbA=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=rEh/C1FU+tIqjm1AKZntM/8UYKwrY10g4TeWX6StSB1sXeQ8FIUfvsOGojt7xF/a4
	 hM5h1Mor+QuSB579Uls5YoEG05K4pkMLXUgZmF1L5hj1XibwrxnN7d3blGeytCBPgI
	 SNpWcN2mv3X9hgGcjK+cjLi2HfiPx7t8tuA3eIhk=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.myt.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] kvm: fix kvmalloc_array() arguments order
Date: Wed, 20 Dec 2023 20:30:55 +0300
Message-ID: <20231220173059.529601-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with gcc version 14.0.0 20231220 (experimental)
and W=1, I've noticed the following warning:

virt/kvm/kvm_main.c: In function '__kvm_mmu_topup_memory_cache':
virt/kvm/kvm_main.c:424:53: warning: 'kvmalloc_array' sizes specified with 'sizeof'
in the earlier argument and not in the later argument [-Wcalloc-transposed-args]
  424 |                 mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
      |                                                     ^~~~

Since 'n' and 'size' arguments of 'kvmalloc_array()' are multiplied
to calculate the final size, their actual order doesn't affect the
result and so this not a bug. But it's better to be fixed anyway.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3b1b9e8dd70c..0ae8e742e9eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -421,7 +421,7 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
 		if (WARN_ON_ONCE(!capacity))
 			return -EIO;
 
-		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
+		mc->objects = kvmalloc_array(capacity, sizeof(void *), gfp);
 		if (!mc->objects)
 			return -ENOMEM;
 
-- 
2.43.0


