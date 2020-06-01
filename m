Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5851EA747
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgFAPre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 11:47:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbgFAPre (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 11:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591026452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3CnZZGZdEnXK3gksb+xJ+ZM+qYctQV1EojEAwTVHULU=;
        b=G3nJ86NCEGD87yo1FCCcl5m5b9o+8EhVrWK1Uh3wMzlsF92JXiMp7VJw3UVrTOYf8s2MCb
        KCH3uqMBXbDEhCWHBdWUR5z3p76RxFuVTcQwNBcYW/nyoSawZVC9cp6f6jgOyyqQMRWthW
        W4folI/hVSs2wddggt44CmHVHApghjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-7Xci_c89NmSrIrh2KVb8sw-1; Mon, 01 Jun 2020 11:47:31 -0400
X-MC-Unique: 7Xci_c89NmSrIrh2KVb8sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0834108C303;
        Mon,  1 Jun 2020 15:47:29 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBF8410013D9;
        Mon,  1 Jun 2020 15:47:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Subject: [PATCH] KVM: selftests: fix rdtsc() for vmx_tsc_adjust_test
Date:   Mon,  1 Jun 2020 17:47:26 +0200
Message-Id: <20200601154726.261868-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_tsc_adjust_test fails with:

IA32_TSC_ADJUST is -4294969448 (-1 * TSC_ADJUST_VALUE + -2152).
IA32_TSC_ADJUST is -4294969448 (-1 * TSC_ADJUST_VALUE + -2152).
IA32_TSC_ADJUST is 281470681738540 (65534 * TSC_ADJUST_VALUE + 4294962476).
==== Test Assertion Failure ====
  x86_64/vmx_tsc_adjust_test.c:153: false
  pid=19738 tid=19738 - Interrupted system call
     1	0x0000000000401192: main at vmx_tsc_adjust_test.c:153
     2	0x00007fe1ef8583d4: ?? ??:0
     3	0x0000000000401201: _start at ??:?
  Failed guest assert: (adjust <= max)

The problem is that is 'tsc_val' should be u64, not u32 or the reading
gets truncated.

Fixes: 8d7fbf01f9afc ("KVM: selftests: VMX preemption timer migration test")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 7cb19eca6c72..82b7fe16a824 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -79,7 +79,7 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
 static inline uint64_t rdtsc(void)
 {
 	uint32_t eax, edx;
-	uint32_t tsc_val;
+	uint64_t tsc_val;
 	/*
 	 * The lfence is to wait (on Intel CPUs) until all previous
 	 * instructions have been executed. If software requires RDTSC to be
-- 
2.25.4

