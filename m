Return-Path: <kvm+bounces-33505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 376629ED69A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 20:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA56F165506
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337612288EA;
	Wed, 11 Dec 2024 19:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/PB9rO3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AE5210F56
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733945841; cv=none; b=Whh3n5Na3U/yL1YjwzA+5efkFoh61OtF9wubmbL1a8YtySOLvGa7VR/+/qNxBvKULANF944w2YwMpQ9AqQl8mOAIwXtH4JG05Mv/eFdUUrPE0N14ra8Ie3uW84mzr5m2miOFL/9V9B39Z6MFK001xoePxf1lRCKoVBWcLI1mr4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733945841; c=relaxed/simple;
	bh=VhDVTu2AuXYfkTvekSpZLqV8NzNnawdQ4JQwCa4nmSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IqPYsmY8o5qpKWDjkQN6ha1Ii7zJ3asV77Rf0t3Vsn6HMJ1KQrN03pD/+wJJF80LbsGsRSEK2YU1wa8Uqn4T8dSP8+HvWdnnxHF1LdK9Ke3GdNbcMW7nMkhkpi6V9ccAIRPWX+aLM0LDuObebGxNu3/vYiIPdSN4yNm4kHExCoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/PB9rO3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733945839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UEKlIRfFGj9gsIIV+NU+wX1aKTv8UmyhOOg+xZ2JnWc=;
	b=V/PB9rO3CpXciYA6V9B4nhmCdDpIrzhfaAo0H1vKA+XwQuKKy8BYtKO3oH0guBjTvszE4P
	a03lltFioVcIvJWuXT6bfW+EdJOaQUvsZh0MIAH27lx2J0++jtmHZuNJ1VZhcPO3SVE2H5
	dLvw7GaKNZeeEhoMsV0HzSE9WvTJFzs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-61TFV3KWNzGv4b68XKPhjw-1; Wed,
 11 Dec 2024 14:37:14 -0500
X-MC-Unique: 61TFV3KWNzGv4b68XKPhjw-1
X-Mimecast-MFC-AGG-ID: 61TFV3KWNzGv4b68XKPhjw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0A0D1958B13;
	Wed, 11 Dec 2024 19:37:12 +0000 (UTC)
Received: from starship.lan (unknown [10.22.82.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A7501956048;
	Wed, 11 Dec 2024 19:37:11 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/4] KVM: selftests: dirty_log_test: Limit s390x workaround to s390x
Date: Wed, 11 Dec 2024 14:37:04 -0500
Message-Id: <20241211193706.469817-3-mlevitsk@redhat.com>
In-Reply-To: <20241211193706.469817-1-mlevitsk@redhat.com>
References: <20241211193706.469817-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

s390 specific workaround causes the dirty-log mode of the test to dirty all
the guest memory on the first iteration which is very slow when
run nested.

Limit this workaround to s390x.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index aacf80f57439..f60e2aceeae0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -98,6 +98,7 @@ static void guest_code(void)
 	uint64_t addr;
 	int i;
 
+#ifdef __s390x__
 	/*
 	 * On s390x, all pages of a 1M segment are initially marked as dirty
 	 * when a page of the segment is written to for the very first time.
@@ -108,6 +109,7 @@ static void guest_code(void)
 		addr = guest_test_virt_mem + i * guest_page_size;
 		vcpu_arch_put_guest(*(uint64_t *)addr, READ_ONCE(iteration));
 	}
+#endif
 
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
-- 
2.26.3


