Return-Path: <kvm+bounces-5882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 144588287C8
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 228BA1C2426D
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DC739AF2;
	Tue,  9 Jan 2024 14:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUZavRBJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC24A39AC0
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704809486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ejfyzVTHu6M3v7OH/x0XnUikfCuEW8k/0GRBV0I9rkQ=;
	b=EUZavRBJWujMPw6x9Zu4mMeHRTxQcw+UKHrKIeaCwyCW8qMVR+nmhE+CVyiQSVvwhEXVci
	1i7ScbtuL4OwYdQjzK6vXot6i7cf2OZTGMptSlFGjwiXmTAGH3DRnTaY+5DBPmNpWcdnqS
	3Y8QWklyt+LCkLNvNaZx+I5fFrsjjMs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-8uN3QetKPrOKezU4fBJbUw-1; Tue, 09 Jan 2024 09:11:23 -0500
X-MC-Unique: 8uN3QetKPrOKezU4fBJbUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A8F6862FD8;
	Tue,  9 Jan 2024 14:11:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.90])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F8B651E3;
	Tue,  9 Jan 2024 14:11:22 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Oliver Upton <oupton@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] KVM: selftests: Fix clocksource requirements in tests
Date: Tue,  9 Jan 2024 15:11:16 +0100
Message-ID: <20240109141121.1619463-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

It was discovered that 'hyperv_clock' fails miserably when the system is
using an unsupported (by KVM) clocksource, e.g. 'kvm-clock'. The root cause
of the failure is that 'hyperv_clock' doesn't actually check which clocksource
is currently in use. Other tests (kvm_clock_test, vmx_nested_tsc_scaling_test)
have the required check but each test does it on its own.

Generalize clocksource checking infrastructure, make all three clocksource
dependent tests run with 'tsc' and 'hyperv_clocksource_tsc_page', and skip
gracefully when run in an unsupported configuration.

The last patch of the series is a loosely related minor nitpick for KVM
code itself.

Vitaly Kuznetsov (5):
  KVM: selftests: Generalize check_clocksource() from kvm_clock_test
  KVM: selftests: Use generic sys_clocksource_is_tsc() in
    vmx_nested_tsc_scaling_test
  KVM: selftests: Run clocksource dependent tests with
    hyperv_clocksource_tsc_page too
  KVM: selftests: Make hyperv_clock require TSC based system clocksource
  KVM: x86: Make gtod_is_based_on_tsc() return 'bool'

 arch/x86/kvm/x86.c                            |  2 +-
 .../testing/selftests/kvm/include/test_util.h |  2 +
 .../selftests/kvm/include/x86_64/processor.h  |  2 +
 tools/testing/selftests/kvm/lib/test_util.c   | 25 ++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 15 ++++++++
 .../selftests/kvm/x86_64/hyperv_clock.c       |  1 +
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 38 +------------------
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  | 19 +---------
 8 files changed, 48 insertions(+), 56 deletions(-)


base-commit: 7f26fea9bc085290e3731501f4f8fc5b82b9d615
-- 
2.43.0


