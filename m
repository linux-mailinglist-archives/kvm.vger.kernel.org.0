Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865651F5943
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFJQlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 12:41:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40441 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726095AbgFJQlf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 12:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591807294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JjmEXwM2z+xW1VlWIW84dTFtD9mhLZeCe5kD1Da0GoU=;
        b=PCJVU6gTARkLBeTSc4H1dlsXrEe8I1OsyNWQ+f0JRgADF05R/AOrV30s+f8tqWfz8GRp4B
        BIyvHG1Zt6zwYikyEYH7Y8paBq5fWi7FNHc6bAApHTMdihDTfDtR4xZTs/xEnAm9OcsJrf
        /l2qOnfUmJYraU9yLuYaGJTmymfU4VQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-ShVyT7k7OSCrrFC0vmj9gw-1; Wed, 10 Jun 2020 12:41:32 -0400
X-MC-Unique: ShVyT7k7OSCrrFC0vmj9gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D24791B2C980;
        Wed, 10 Jun 2020 16:41:30 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC5017C3B9;
        Wed, 10 Jun 2020 16:41:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Bandeira Condotta <mcondotta@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: selftests: fix sync_with_host() in smm_test
Date:   Wed, 10 Jun 2020 18:41:16 +0200
Message-Id: <20200610164116.770811-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was reported that older GCCs compile smm_test in a way that breaks
it completely:

  kvm_exit:             reason EXIT_CPUID rip 0x4014db info 0 0
  func 7ffffffd idx 830 rax 0 rbx 0 rcx 0 rdx 0, cpuid entry not found
  ...
  kvm_exit:             reason EXIT_MSR rip 0x40abd9 info 0 0
  kvm_msr:              msr_read 487 = 0x0 (#GP)
  ...

Note, '7ffffffd' was supposed to be '80000001' as we're checking for
SVM. Dropping '-O2' from compiler flags help. Turns out, asm block in
sync_with_host() is wrong. We us 'in 0xe, %%al' instruction to sync
with the host and in 'AL' register we actually pass the parameter
(stage) but after sync 'AL' gets written to but GCC thinks the value
is still there and uses it to compute 'EAX' for 'cpuid'.

smm_test can't fully use standard ucall() framework as we need to
write a very simple SMI handler there. Fix the immediate issue by
making RAX input/output operand. While on it, make sync_with_host()
static inline.

Reported-by: Marcelo Bandeira Condotta <mcondotta@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/smm_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 36314152943d..ae39a220609f 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -47,10 +47,10 @@ uint8_t smi_handler[] = {
 	0x0f, 0xaa,           /* rsm */
 };
 
-void sync_with_host(uint64_t phase)
+static inline void sync_with_host(uint64_t phase)
 {
 	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
-		     : : "a" (phase));
+		     : "+a" (phase));
 }
 
 void self_smi(void)
-- 
2.25.4

