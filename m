Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9368C49CDFE
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 16:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242772AbiAZPW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 10:22:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242766AbiAZPWW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 10:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643210542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7YfDmRYUeL6C1bhQyvjZ7nwHEcc8cuHsnQU1AfTtDw=;
        b=QUC/Ycn4n31nUi+z/m1tl2ZNC4lf8ZFMVDQCTsEJBF9eet71ODUiUKTia4DpVSYJ/zz5+L
        wBxYSbUo0vA3qTsdqWrmtpUnihAdyehJm3RSMIwYLVUhjHTMV9KrpBducmsH07wyLBRvSc
        jwfRZ6cfZOaX0HYCS5PrE6Q7/+CcZEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-yBUUM5_ROCaIIDFpCT9wAQ-1; Wed, 26 Jan 2022 10:22:19 -0500
X-MC-Unique: yBUUM5_ROCaIIDFpCT9wAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C30C519611C6;
        Wed, 26 Jan 2022 15:22:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDAC134D59;
        Wed, 26 Jan 2022 15:22:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yang.zhong@intel.com, seanjc@google.com
Subject: [PATCH 3/3] selftests: kvm: check dynamic bits against KVM_X86_XCOMP_GUEST_SUPP
Date:   Wed, 26 Jan 2022 10:22:10 -0500
Message-Id: <20220126152210.3044876-4-pbonzini@redhat.com>
In-Reply-To: <20220126152210.3044876-1-pbonzini@redhat.com>
References: <20220126152210.3044876-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide coverage for the new API.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/arch/x86/include/uapi/asm/kvm.h             |  3 +++
 tools/include/uapi/linux/kvm.h                    |  1 +
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 +++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 2da3316bb559..bf6e96011dfe 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -452,6 +452,9 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
+/* attributes for system fd (group 0) */
+#define KVM_X86_XCOMP_GUEST_SUPP	0
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 9563d294f181..b46bcdb0cab1 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1133,6 +1133,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
+#define KVM_CAP_SYS_ATTRIBUTES 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c1d1c195a838..9f000dfb5594 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -667,8 +667,23 @@ static bool is_xfd_supported(void)
 
 void vm_xsave_req_perm(int bit)
 {
+	int kvm_fd;
 	u64 bitmask;
 	long rc;
+	struct kvm_device_attr attr = {
+		.group = 0,
+		.attr = KVM_X86_XCOMP_GUEST_SUPP,
+		.addr = (unsigned long) &bitmask
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	rc = ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
+	close(kvm_fd);
+	if (rc == -1 && (errno == ENXIO || errno == EINVAL))
+		exit(KSFT_SKIP);
+	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
+	if (!(bitmask & (1ULL << bit)))
+		exit(KSFT_SKIP);
 
 	if (!is_xfd_supported())
 		exit(KSFT_SKIP);
-- 
2.31.1

