Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF173B4148
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhFYKR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:17:56 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:6083 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFYKRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:17:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1624616135; x=1656152135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gojSS2OyTyAP5gmkFDKD8MsYdNtGHCgL8o38XcphUVg=;
  b=qaJfiL/52UGE9SsoXCMQU55OX+fFkHI//VZsWlDIHmM/u8TwPs+shGeF
   p54rBWhOEuniBgMsdajDKG1dYJWYfLmGUYRET/SHzJahfjy4v06fg08Xp
   C35gYGtE12BGzLy7FaJisKx1scRHAOg3iOKOUkCjwfJ5Qc7RHrTKex04h
   Q=;
X-IronPort-AV: E=Sophos;i="5.83,298,1616457600"; 
   d="scan'208";a="121286488"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-c5104f52.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 25 Jun 2021 10:15:34 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-c5104f52.us-west-2.amazon.com (Postfix) with ESMTPS id E6AF0A0646;
        Fri, 25 Jun 2021 10:15:33 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.69) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 25 Jun 2021 10:15:28 +0000
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
Subject: [PATCH v2 3/6] kvm/i386: Stop using cpu->kvm_msr_buf in kvm_put_one_msr()
Date:   Fri, 25 Jun 2021 12:14:38 +0200
Message-ID: <3d53e2f2c73c8ecc8adab0c50b23fa4f613a2f08.1624615713.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1624615713.git.sidcha@amazon.de>
References: <cover.1624615713.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D14UWC004.ant.amazon.com (10.43.162.99) To
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
index c676ee8b38..03202bd06b 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2578,12 +2578,16 @@ static void kvm_msr_entry_add(X86CPU *cpu, uint32_t index, uint64_t value)
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



