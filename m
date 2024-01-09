Return-Path: <kvm+bounces-5885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB0258287CF
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09C391C242AE
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7553A278;
	Tue,  9 Jan 2024 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgNjG7sO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA413A1A4
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704809492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKkzI2CsoNgX1WJTht9BzlNFsx76EWCSrLu3KlKlb+c=;
	b=DgNjG7sOSWIFAZNWAg0/7nze1TFHZpYTGx/ot8FU2XDknBITUNwGpUOQgpLQYXCu854UsB
	tWVWB6rrq/BAMfspHvSfYdr+bEOeUSzRLQobj0W9roCEoC1aLSM7pHpF8rvS62eUkDIT/k
	v1IUWzfhvOpukV7PofqEd9wgPzfUfik=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-laJp76qrNlyENke7orJW9w-1; Tue, 09 Jan 2024 09:11:28 -0500
X-MC-Unique: laJp76qrNlyENke7orJW9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8C01185A781;
	Tue,  9 Jan 2024 14:11:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.90])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC87D51E3;
	Tue,  9 Jan 2024 14:11:26 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] KVM: selftests: Make hyperv_clock require TSC based system clocksource
Date: Tue,  9 Jan 2024 15:11:20 +0100
Message-ID: <20240109141121.1619463-5-vkuznets@redhat.com>
In-Reply-To: <20240109141121.1619463-1-vkuznets@redhat.com>
References: <20240109141121.1619463-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

KVM sets up Hyper-V TSC page clocksource for its guests when system
clocksource is 'based on TSC' (see gtod_is_based_on_tsc()), running
hyperv_clock with any other clocksource leads to imminent failure.

Add the missing requirement to make the test skip gracefully.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index f5e1e98f04f9..02cc3c560566 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -212,6 +212,7 @@ int main(void)
 	int stage;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_HYPERV_TIME));
+	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-- 
2.43.0


