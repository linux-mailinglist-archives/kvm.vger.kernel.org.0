Return-Path: <kvm+bounces-6846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 053B483AEB0
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 352261C20F2E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 16:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C3197E580;
	Wed, 24 Jan 2024 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="elIUKdpP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9647E570
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706114946; cv=none; b=QTIPLjeRGE6iVwicp0Q3GelRzHBs+NM4oOZ5tfyb07uk6CrxXGIRVu/9Rl2SjtvNTH+xy5igUPt2IGCwb4JeHplXodtAfopOlBiAuY5TkzTPtG8FIyvctCzVqc3Fjs/8A9P9C14X2xeWY9f332TbPKOXDevv8PRs6zs908ge+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706114946; c=relaxed/simple;
	bh=s9KRXH9pAqJym9VChh3bZmkDlYyWfd9kBPwlf56Kdvg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sv/6ufxp4jT/wTukRPI5inkeE7VUyLKGTF2fvbXDMnNxSeKGkDtuCBAwBaBZXmJsS4BFtv5nEhehY5GsFaZprL9QNF4D+MZ23trUEf+fEngdH/WgLpFmP9FucHtG0T+PoyurzXUBGe9NiBBBmRFH5vTcoPOzj7xJbyfFHyRJIdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=elIUKdpP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706114944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x1KzYBefZJni0FCDP73spKMgvjNuzgWQ5eAFD4yX/Vg=;
	b=elIUKdpP4PqwPWAFnxg3I5692VAE21ALODnLRAl3YJbjglhHMdQ/L7sKd2hB6YtfdjNNmv
	JwXOVjl2MjDaoi7Eaqid7XxmISzgK9qsqy0Itiwoa4Vwep0Rh/yoXzH5AaSBJlspKVl84q
	7wSht3cRX7l79AlcipvIQxMj2+WIzEE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-vw52FaqIOo6FU3af-du6_g-1; Wed, 24 Jan 2024 11:49:00 -0500
X-MC-Unique: vw52FaqIOo6FU3af-du6_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53B17108BF31;
	Wed, 24 Jan 2024 16:48:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.249])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CD161C060B1;
	Wed, 24 Jan 2024 16:48:56 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 2/2] KVM: selftests: Fail tests when open() fails with !ENOENT
Date: Wed, 24 Jan 2024 17:48:55 +0100
Message-ID: <20240124164855.2564824-2-vkuznets@redhat.com>
In-Reply-To: <20240124164855.2564824-1-vkuznets@redhat.com>
References: <20240124164855.2564824-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

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
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e066d584c656..f3dfd0d38b7f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -27,7 +27,8 @@ int open_path_or_exit(const char *path, int flags)
 	int fd;
 
 	fd = open(path, flags);
-	__TEST_REQUIRE(fd >= 0, "%s not available (errno: %d)", path, errno);
+	__TEST_REQUIRE(fd >= 0 || errno != ENOENT, "%s not present", path);
+	TEST_ASSERT(fd >= 0, "%s not available (errno: %d)", path, errno);
 
 	return fd;
 }
-- 
2.43.0


