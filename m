Return-Path: <kvm+bounces-7317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A08468400C1
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56AC21F23D40
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 08:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDC255C02;
	Mon, 29 Jan 2024 08:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGN9tsCM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955935577A
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706518737; cv=none; b=n3CvJFxX5SBV+/BPxMhGyDqSAf4wBvwWAkicLeyaFUXA6tHkrjovXwCSnhKmCIeVNH+u2yafqLKNuqgPlAWPtoUdbkgtT8DFHsjyJgyOIwNwDOfan/rqqkcMiLRKS22hpMbQ71LD2XEsw4Ukj8xtC/tY6l4Mg9iE8hYIWxDScwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706518737; c=relaxed/simple;
	bh=YEy86K1x0qazORfLq0lORTS8eMy12FJ8kk0seMZrf18=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXXleJdYuGLiLAEkbuo2Kv0b9vhGArPkkFzPFRJ9/xZxkaTuDunc0EdOGYHhEbbnBftQRkIWXUEOg4R8yOhRzBF1dQ4Sv2/rMZO3ndvmlYdU87jHxLbYTBNXuW6Y/dqM8I6QWGfesX+essl+cecWDJK55emyZxNOqYcxr0n5ZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGN9tsCM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706518734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bzxCsmFGohwMmLt5w9cpmSAACkULFHcmcOvKhkRxwcM=;
	b=DGN9tsCMzxOPgTYD/MJa0x4kXDsH93Hl1LKGg6euMhuhgXskJ6a+aDZTEf/1/GetcvoV0i
	On9xlMnSriWt+EESM7QzRh7DL+aYLCZBpqwbx9WYQn75kF60vRsAk5d2r6s/CUGC5W7Zav
	9BJlgpJHpMdyxmjbStpML+YbrBrWS6k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-lk8hdy6uNzmzfDzAo9nV6g-1; Mon, 29 Jan 2024 03:58:50 -0500
X-MC-Unique: lk8hdy6uNzmzfDzAo9nV6g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CE2E85A597;
	Mon, 29 Jan 2024 08:58:50 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.225.235])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 723FB492BE2;
	Mon, 29 Jan 2024 08:58:49 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Fail tests when open() fails with !ENOENT
Date: Mon, 29 Jan 2024 09:58:47 +0100
Message-ID: <20240129085847.2674082-2-vkuznets@redhat.com>
In-Reply-To: <20240129085847.2674082-1-vkuznets@redhat.com>
References: <20240129085847.2674082-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

open_path_or_exit() is used for '/dev/kvm', '/dev/sev', and
'/sys/module/%s/parameters/%s' and skipping test when the entry is missing
is completely reasonable. Other errors, however, may indicate a real issue
which is easy to miss. E.g. when 'hyperv_features' test was entering an
infinite loop the output was:

./hyperv_features
Testing access to Hyper-V specific MSRs
1..0 # SKIP - /dev/kvm not available (errno: 24)

and this can easily get overlooked.

Keep ENOENT case 'special' for skipping tests and fail when open() results
in any other errno.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
Changes since v1: Use strerror() for 'skip' and rely on the already
existing one in test_assert() for 'fail'. [Sean]
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e066d584c656..e354d1e513ba 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -27,7 +27,8 @@ int open_path_or_exit(const char *path, int flags)
 	int fd;
 
 	fd = open(path, flags);
-	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)", path, errno);
+	__TEST_REQUIRE(fd >= 0 || errno != ENOENT, "Cannot open %s: %s", path, strerror(errno));
+	TEST_ASSERT(fd >= 0, "Failed to open '%s'", path);
 
 	return fd;
 }
-- 
2.43.0


