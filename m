Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861F3FFB7D
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 10:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348177AbhICIFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 04:05:03 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:55502 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347900AbhICIEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 04:04:08 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2021 04:04:04 EDT
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-01 (Coremail) with SMTP id qwCowABXazDW1DFh9IwiAA--.56360S2;
        Fri, 03 Sep 2021 15:55:02 +0800 (CST)
From:   Jiang Jiasheng <jiasheng@iscas.ac.cn>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Jiang Jiasheng <jiasheng@iscas.ac.cn>
Subject: [PATCH 4/4] KVM: X86: Potential 'index out of range' bug
Date:   Fri,  3 Sep 2021 07:55:00 +0000
Message-Id: <1630655700-798374-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: qwCowABXazDW1DFh9IwiAA--.56360S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur48uw4fJr47CFy3uw4kWFg_yoWDJFb_CF
        1fZan8Gr9Yvr9avws7A3ySyanY9w40qFW5Gw1rC343J34vyF4UAw4vq3W7Ar12gw40vFW2
        9ry5Gr47Aw4j9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJV
        W0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GF4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
        VjvjDU0xZFpf9x0JUvQ6LUUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_get_vcpu() will call for the array_index_nospec()
with the value of atomic_read(&(v->kvm)->online_vcpus) as size,
and the value of constant '0' as index.
If the size is also '0', it will be unreasonabe
that the index is no less than the size.

Signed-off-by: Jiang Jiasheng <jiasheng@iscas.ac.cn>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0f4a46..c59013c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2871,7 +2871,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				       offsetof(struct compat_vcpu_info, time));
 	if (vcpu->xen.vcpu_time_info_set)
 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
-	if (v == kvm_get_vcpu(v->kvm, 0))
+	if (atomic_read(&(v->kvm)->online_vcpus) > 0 && v == kvm_get_vcpu(v->kvm, 0))
 		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
-- 
2.7.4

