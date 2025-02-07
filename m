Return-Path: <kvm+bounces-37604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11076A2C87F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22BE3188C240
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 16:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C4A18A6DF;
	Fri,  7 Feb 2025 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpjB75Eo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC561802DD
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738945282; cv=none; b=Hed4NbpEgUfPeDtoAWfiH0ML4Ab4v2OSllsqfe9at95E6ZbvTDE0G42JkdceQx0jP2XDsacC+cLR5RwgFLfJmGEwrGIcvMqUp/Nn3e/R7vWPmkIeNLSTFAdC3pEaKMkBO7s02NY4WPigWBjJ+Cmo5iazYzJq3SYrBYpuvWN6tQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738945282; c=relaxed/simple;
	bh=9NJbIW8HF1iWtKwqaG6Q5rUnbJq8AVayNgTohN45mS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MrNcodkHjKSP4OwNHLPDolijK//m24x7Yqxy1nR8TXckh0wJwHwTdDnk9ouS5lm96HBX6sUnn2HFg5e7Z/hppDzST/UqXm7s05+mAdEyjiipjB5DAD4mZ85zm8+BIt0ergYrlGFb/17wZCXSGF+AB40JPwKHzEU6Wled+cGtaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UpjB75Eo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738945279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS3mG7q7Qhof/soXKvmjdSRvuo+ZNyeAZO9Cl/N//jo=;
	b=UpjB75EofS0Q+YdkAsHDZKj0F6SmommKxCE0ku5KJVCp9bxe2ERbw3y4ZffDWhWA/qsp/l
	3Xq8zpHRF9k7+ICo7mKHZclygbcAbnVWTzhCa0lcbhQrcOk+zGKu7Fg+Rk7J+ZFnMOQF9C
	WQ1j7oJfsBGsD8kmZY41iZsGbJ3tiD0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-oMh-emOuOZOhvvgumhecOA-1; Fri,
 07 Feb 2025 11:21:18 -0500
X-MC-Unique: oMh-emOuOZOhvvgumhecOA-1
X-Mimecast-MFC-AGG-ID: oMh-emOuOZOhvvgumhecOA
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3713719560B5;
	Fri,  7 Feb 2025 16:21:17 +0000 (UTC)
Received: from dell-r430-03.lab.eng.brq2.redhat.com (dell-r430-03.lab.eng.brq2.redhat.com [10.37.153.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E602F18004A7;
	Fri,  7 Feb 2025 16:21:14 +0000 (UTC)
From: Igor Mammedov <imammedo@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	peterx@redhat.com
Subject: [PATCH v2 09/10] accel/kvm: Assert vCPU is created when calling kvm_dirty_ring_reap*()
Date: Fri,  7 Feb 2025 17:20:47 +0100
Message-ID: <20250207162048.1890669-10-imammedo@redhat.com>
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

Previous commits made sure vCPUs are realized before accelerators
(such KVM) use them. Ensure that by asserting the vCPU is created,
no need to return.

For more context, see commit 56adee407fc ("kvm: dirty-ring: Fix race
with vcpu creation").

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
CC: kvm@vger.kernel.org
CC: peterx@redhat.com
---
 accel/kvm/kvm-all.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433..cb56d120a9 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -831,13 +831,11 @@ static uint32_t kvm_dirty_ring_reap_one(KVMState *s, CPUState *cpu)
     uint32_t count = 0, fetch = cpu->kvm_fetch_index;
 
     /*
-     * It's possible that we race with vcpu creation code where the vcpu is
+     * It's not possible that we race with vcpu creation code where the vcpu is
      * put onto the vcpus list but not yet initialized the dirty ring
-     * structures.  If so, skip it.
+     * structures.
      */
-    if (!cpu->created) {
-        return 0;
-    }
+    assert(cpu->created);
 
     assert(dirty_gfns && ring_size);
     trace_kvm_dirty_ring_reap_vcpu(cpu->cpu_index);
-- 
2.43.0


