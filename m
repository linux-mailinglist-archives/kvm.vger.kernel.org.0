Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A18539184
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 15:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344611AbiEaNMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 09:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344605AbiEaNMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 09:12:20 -0400
X-Greylist: delayed 1595 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 06:12:19 PDT
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449FB60045;
        Tue, 31 May 2022 06:12:17 -0700 (PDT)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1nw1F3-0003Pr-Ez; Tue, 31 May 2022 12:44:57 +0000
Received: from 54-240-197-226.amazon.com ([54.240.197.226] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1nw1F3-0006Db-3n; Tue, 31 May 2022 12:44:57 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: PIT: Preserve state of speaker port data bit
Date:   Tue, 31 May 2022 13:44:21 +0100
Message-Id: <20220531124421.1427-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the state of the speaker port (0x61) data bit (bit 1) is not
saved in the exported state (kvm_pit_state2) and hence is lost when
re-constructing guest state.

This patch removes the 'speaker_data_port' field from kvm_kpit_state and
instead tracks the state using a new KVM_PIT_FLAGS_SPEAKER_DATA_ON flag
defined in the API.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
 Documentation/virt/kvm/api.rst  |  4 +++-
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/i8254.c            | 10 +++++++---
 arch/x86/kvm/i8254.h            |  1 -
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 28b547a9d96a..8659dbfd3095 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2998,7 +2998,9 @@ KVM_CREATE_PIT2. The state is returned in the following structure::
 Valid flags are::
 
   /* disable PIT in HPET legacy mode */
-  #define KVM_PIT_FLAGS_HPET_LEGACY  0x00000001
+  #define KVM_PIT_FLAGS_HPET_LEGACY     0x00000001
+  /* speaker port data bit enabled */
+  #define KVM_PIT_FLAGS_SPEAKER_DATA_ON 0x00000002
 
 This IOCTL replaces the obsolete KVM_GET_PIT.
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..1b30c222d51c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -306,7 +306,8 @@ struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
 
-#define KVM_PIT_FLAGS_HPET_LEGACY  0x00000001
+#define KVM_PIT_FLAGS_HPET_LEGACY     0x00000001
+#define KVM_PIT_FLAGS_SPEAKER_DATA_ON 0x00000002
 
 struct kvm_pit_state2 {
 	struct kvm_pit_channel_state channels[3];
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 1c83076091af..e0a7a0e7a73c 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -591,7 +591,10 @@ static int speaker_ioport_write(struct kvm_vcpu *vcpu,
 		return -EOPNOTSUPP;
 
 	mutex_lock(&pit_state->lock);
-	pit_state->speaker_data_on = (val >> 1) & 1;
+	if (val & (1 << 1))
+		pit_state->flags |= KVM_PIT_FLAGS_SPEAKER_DATA_ON;
+	else
+		pit_state->flags &= ~KVM_PIT_FLAGS_SPEAKER_DATA_ON;
 	pit_set_gate(pit, 2, val & 1);
 	mutex_unlock(&pit_state->lock);
 	return 0;
@@ -612,8 +615,9 @@ static int speaker_ioport_read(struct kvm_vcpu *vcpu,
 	refresh_clock = ((unsigned int)ktime_to_ns(ktime_get()) >> 14) & 1;
 
 	mutex_lock(&pit_state->lock);
-	ret = ((pit_state->speaker_data_on << 1) | pit_get_gate(pit, 2) |
-		(pit_get_out(pit, 2) << 5) | (refresh_clock << 4));
+	ret = (!!(pit_state->flags & KVM_PIT_FLAGS_SPEAKER_DATA_ON) << 1) |
+		pit_get_gate(pit, 2) | (pit_get_out(pit, 2) << 5) |
+		(refresh_clock << 4);
 	if (len > sizeof(ret))
 		len = sizeof(ret);
 	memcpy(data, (char *)&ret, len);
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 394d9527da7e..a768212ba821 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -29,7 +29,6 @@ struct kvm_kpit_state {
 	bool is_periodic;
 	s64 period; 				/* unit: ns */
 	struct hrtimer timer;
-	u32    speaker_data_on;
 
 	struct mutex lock;
 	atomic_t reinject;
-- 
2.20.1

