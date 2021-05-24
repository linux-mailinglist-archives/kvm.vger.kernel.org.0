Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242138F3E4
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhEXT5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 15:57:09 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:22668 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhEXT5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 15:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886141; x=1653422141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jtPJZRoIcIGMgdID0wVBNd10aPPe6ZAomW4bRSwxqzk=;
  b=ccLpSd9r09DCNZf3y3ousrZV7i0quQF+3uXeka4IEbQzhcPO8NJoXaUW
   kDqUE9Jgg1k87zA0xOvAV4cmew7fjxqw4tJRjTlzzd23+qiniGsXJocwT
   mmrSxTlIK8+aUoIMzblD8G5aiXpk//hIDQjiSB+JYwaCDLJ0nHKx7zsj2
   E=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="114312619"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 24 May 2021 19:55:40 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 292A2A2121;
        Mon, 24 May 2021 19:55:37 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.253) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 19:55:33 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 3/6] kvm/i386: Stop using cpu->kvm_msr_buf in kvm_put_one_msr()
Date:   Mon, 24 May 2021 21:54:06 +0200
Message-ID: <04c81a02c19a47e799e06b9c9ccb97e9a77f5927.1621885749.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1621885749.git.sidcha@amazon.de>
References: <cover.1621885749.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D10UWB004.ant.amazon.com (10.43.161.121) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_put_one_msr() zeros cpu->kvm_msr_buf and uses it to set one MSR to
KVM. It is pretty wasteful as cpu->kvm_msr_buf is 4096 bytes long;
instead use a local buffer to avoid memset.

Also, expose this method from kvm_i386.h as hyperv.c needs to set MSRs
in a subsequent patch.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 target/i386/kvm/kvm.c      | 12 ++++++++----
 target/i386/kvm/kvm_i386.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d972eb4705..d19a2913fd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2534,12 +2534,16 @@ static void kvm_msr_entry_add(X86CPU *cpu, uint32_t index, uint64_t value)
     msrs->nmsrs++;
 }
 
-static int kvm_put_one_msr(X86CPU *cpu, int index, uint64_t value)
+int kvm_put_one_msr(X86CPU *cpu, int index, uint64_t value)
 {
-    kvm_msr_buf_reset(cpu);
-    kvm_msr_entry_add(cpu, index, value);
+    uint8_t msr_buf[sizeof(struct kvm_msrs) + sizeof(struct kvm_msr_entry)] = { 0 };
+    struct kvm_msrs *msr = (struct kvm_msrs *)msr_buf;
+
+    msr->nmsrs = 1;
+    msr->entries[0].index = index;
+    msr->entries[0].data = value;
 
-    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
+    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, msr);
 }
 
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value)
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index dc72508389..0c4cd08071 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -40,6 +40,7 @@ void kvm_synchronize_all_tsc(void);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
 
+int kvm_put_one_msr(X86CPU *cpu, int index, uint64_t value);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_enable_x2apic(void);
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



