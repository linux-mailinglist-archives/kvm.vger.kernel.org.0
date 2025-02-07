Return-Path: <kvm+bounces-37605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A574AA2C885
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:22:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DBDC188C172
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1891898EA;
	Fri,  7 Feb 2025 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWVulNy8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AE110F1
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 16:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738945288; cv=none; b=f13DdqrC6dXJ/d9cbjo/FncI1STu+x4vyEZdQMrAcL/SiAz6GYNzxcNlzQKv1KTYU6F/U4o29VB+a+eK1AKiQHavj1JFHzAP3sGrqeCtLOHVYyQp5O+zI/Cm0WxsLILLhiCwvuBbwTMKWjCWVOOK8TziC/qHot0vD50Cdoiqjsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738945288; c=relaxed/simple;
	bh=o96xiAGGAf1VbfHWgHYbIYNVLqylg+O4B4Y//biT4pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8BsV6idxw/cl5xHCcGFwkykcfJjLo5yWGEFICln3vuamwG9zmo4cDYzqOuetlUEjTk79j87k98siH6gmKUDDPs/pwugnUQGBMoc1U9HL4wtzQsZ1oYcYc4X45mz4R7zI2kBAyOXpVIbClg+Xz/GdFiyC6SDwNSnKJUjp1dFsSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWVulNy8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738945285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3WVrexRlab32QyhpO6UTZhs06SRUtIvJ5qxTfzSBSSg=;
	b=DWVulNy8o6pjNdhFMmNcUontmIS8VGSfaPJF/UFpPCLqDxQlQedlTh+vHQ9iPiungbqK9S
	uUqaXMOKNrzXc8+lcKKY8hH+JZMTId04LzefugOtRhRXFULENnu+KqCXJNoe+S76YYbgOu
	QqDLjhsai7HjfgYAeNY5UtrK1c7Npw0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326--t9MizpNPHC3KSb7onlIuw-1; Fri,
 07 Feb 2025 11:21:21 -0500
X-MC-Unique: -t9MizpNPHC3KSb7onlIuw-1
X-Mimecast-MFC-AGG-ID: -t9MizpNPHC3KSb7onlIuw
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DC0219560AD;
	Fri,  7 Feb 2025 16:21:19 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C870180087A;
	Fri,  7 Feb 2025 16:21:17 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v2 10/10] accel/kvm: Remove unreachable assertion in kvm_dirty_ring_reap*()
Date: Fri,  7 Feb 2025 17:20:48 +0100
Message-ID: <20250207162048.1890669-11-imammedo@redhat.com>
In-Reply-To: <20250207162048.1890669-1-imammedo@redhat.com>
References: <20250207162048.1890669-1-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

From: Philippe Mathieu-Daudé <philmd@linaro.org>

Previous commit passed all our CI tests, this assertion being
never triggered. Remove it as dead code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
CC: kvm@vger.kernel.org
---
 accel/kvm/kvm-all.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index cb56d120a9..814b1a53eb 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -830,13 +830,6 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
     uint32_t ring_size = s->kvm_dirty_ring_size;
     uint32_t count = 0, fetch = cpu->kvm_fetch_index;
 
-    /*
-     * It's not possible that we race with vcpu creation code where the vcpu is
-     * put onto the vcpus list but not yet initialized the dirty ring
-     * structures.
-     */
-    assert(cpu->created);
-
     assert(dirty_gfns && ring_size);
     trace_kvm_dirty_ring_reap_vcpu(cpu->cpu_index);
 
-- 
2.43.0


