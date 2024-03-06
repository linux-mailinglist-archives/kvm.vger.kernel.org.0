Return-Path: <kvm+bounces-11173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5475E873D46
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:18:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 858371C22868
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6515613BAE6;
	Wed,  6 Mar 2024 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dnFJgRoY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B361350F2
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745512; cv=none; b=I+cAT1G9VqORuUlBH6dqu6pNXZD8IOM74K6UcnaMCkmBQYwlLOOR+07RIFUhcKe0uvBwZaMxmC7hkLXcm4BwWiD7gzRr/5JwZUbGsJfN1xndizjh43itJ7gwgzoSE6RFkMFR/B35j8tB7G9zH/Qpw1tNI+WEZx7aOZbZE55TD7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745512; c=relaxed/simple;
	bh=s4pYWHn/5o3FSjDHx4GBeHfBuN4jTTp36urFpUbXCPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JBbr3jw/XK/gAI20vCNxo9wD8UP5jzmL/HrBb/YlQ3RgNl8VCMQfQCxT1PDdLbl/cbtBLH4XzAWIlpqfU/rm94+H96F00D04wrn5/pV0pw7pNONQIbq+5sLovjuOWLzYVtvCscKsCHpfyL7wH9di3pQflZOPJXQV7jj1j5mZZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dnFJgRoY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709745509;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exBXviEnKgq1gjMgXJmrfr2wNDsuwDEWXuLx4QUwZ9Y=;
	b=dnFJgRoY+JKHmKfD4AR+MUyy8BydhN0GV8A9/ev2sYvL+DiaLWkWcXPI3LrD3UpMP7fodO
	sb64nYFZRKqsdmf59MfcIqzJw7Joq4mUGIjyX4g3xF0Ui2hHmFIcpuN9o6/6KF7b3TZ0k5
	WjNP/XgZ1J5FXqYTJvbcLX2iuvqOWtk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-5qr9MfVTO2eA7LKi2HAT0g-1; Wed,
 06 Mar 2024 12:18:26 -0500
X-MC-Unique: 5qr9MfVTO2eA7LKi2HAT0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CEFC1C05146;
	Wed,  6 Mar 2024 17:18:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A05F40C6CB8;
	Wed,  6 Mar 2024 17:18:25 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Metin Kaya <metikaya@amazon.com>
Subject: [PATCH kvm-unit-tests 01/13] x86: hyperv: Use correct macro in checking SynIC timer support
Date: Wed,  6 Mar 2024 18:18:11 +0100
Message-ID: <20240306171823.761647-2-vkuznets@redhat.com>
In-Reply-To: <20240306171823.761647-1-vkuznets@redhat.com>
References: <20240306171823.761647-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Metin Kaya <metikaya@amazon.com>

This commit fixes 69d4bf751641520f5b2d8e3f160c63c8966fcd8b.
stimer_supported() should use HV_X64_MSR_SYNTIMER_AVAILABLE instead of
HV_X64_MSR_SYNIC_AVAILABLE.

Fixes: 69d4bf7 ("x86: Hyper-V SynIC timers test")
Signed-off-by: Metin Kaya <metikaya@amazon.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index e3803e02f4dc..bc165c344a11 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -190,7 +190,7 @@ static inline bool synic_supported(void)
 
 static inline bool stimer_supported(void)
 {
-    return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNIC_AVAILABLE;
+    return cpuid(HYPERV_CPUID_FEATURES).a & HV_X64_MSR_SYNTIMER_AVAILABLE;
 }
 
 static inline bool hv_time_ref_counter_supported(void)
-- 
2.44.0


