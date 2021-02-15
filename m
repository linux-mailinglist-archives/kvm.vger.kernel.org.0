Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAEC31BF9D
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhBOQo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 11:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22024 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229931AbhBOQnx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 11:43:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613407336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p9NpBjihp4L1LCfyFyPncXipOV2lf7taXzySW8ZeP4U=;
        b=b6rd4F7qD4q5d5wmrZX/HZCjOb4mB19KIQwpUMhwYAJV/JpkNOQGi6gm65PxEha7ftyhoz
        Ww2vBBhSQDcGPNaaN/RVs6uVYFw3lV+dHsopG1cH5yZ/nvrUosCNixGpkruO1vi7KerooM
        ShYC0Hu4tx9vee+9GqUKLc065fzwjCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-YPZQay9xMYq7SdXdom77kQ-1; Mon, 15 Feb 2021 11:42:14 -0500
X-MC-Unique: YPZQay9xMYq7SdXdom77kQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5368585EE62;
        Mon, 15 Feb 2021 16:42:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEF0110016F6;
        Mon, 15 Feb 2021 16:42:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] selftests: kvm: avoid uninitialized variable warning
Date:   Mon, 15 Feb 2021 11:42:12 -0500
Message-Id: <20210215164212.1126177-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The variable in practice will never be uninitialized, because the
loop will always go through at least one iteration.

In case it would not, make vcpu_get_cpuid report an assertion
failure.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index de0c76177d02..a8906e60a108 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -720,7 +720,8 @@ struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct kvm_cpuid2 *cpuid;
-	int rc, max_ent;
+	int max_ent;
+	int rc = -1;
 
 	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 
-- 
2.26.2

