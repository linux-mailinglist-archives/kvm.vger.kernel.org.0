Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EF04D5D56
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 09:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiCKIbV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 03:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiCKIbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 03:31:15 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F761B9882;
        Fri, 11 Mar 2022 00:30:13 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s11so7266163pfu.13;
        Fri, 11 Mar 2022 00:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NsYPjIMYV5tX+pXV9c5Xqy6DdjLmleLEjTqHZPocps0=;
        b=S3MDpP6CG9hy5C3F2jdmw1F5XMoi2qqCEwDIu62mcrMxBW0MQa2eWbFRLpNjkMIpXw
         pyTV0p+3ZwMzIG4FT8wxYYMBK7fL8BtbMVJmjVPiDtu3UDSIUVWV8SffTR5pjo5Wpmux
         pwmnl4Pb0KtNEGe79mJJSVuLbE81u9XqSrjwhDO/r2kyUMzzU9CACsIdUerLf7Wj8cVr
         KoWhHlQR2ELFHFv7UhCo9Hp3DFd5StfFTYaTLGaK9f3IvAgErkHb8CKycYG/hwPbfBNh
         1IkbWFJi5mUTeLXdxEYxjxB9vFdR2Q+8MPkHdRCG30KgSD6LrzUX8c8czAHx2+RsIP9y
         RtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NsYPjIMYV5tX+pXV9c5Xqy6DdjLmleLEjTqHZPocps0=;
        b=d/+gREeM4U36OjP/qETZ32LQwCn6FMdsmrEJuNS2X7cUDkGxKtL8Ns7B6TCD1WsKEE
         C6PLYTMXBcxMb976PjX0X9wk/3AmSif4qoKYBKjt1RV4NohAZnXxkmPBdDHu2G8sz8JD
         srHdnkrlfRrOWhXxV0lahb+u3Vlurmr5kHUKgfFOUu+zB3TIFnmnINwpLldfggoV/YCE
         s62tH4VWMnb77nvAalfEFE8tELibQY9XB52FLPPfsi67hvoPq71Py4o/nUzBdSiEjcQZ
         IuJG0/HBX3oaHDK5ng6PBRFOvBNBHXy4Ay3wrAqQLH5lUvEBt7bScHmK+UodiPJzRdhp
         K0FQ==
X-Gm-Message-State: AOAM532Q1k7VMvwGUac4XM1sDHs6GwrbnUdG5uyTWdsi6DynG6kDPnkz
        19HgCc1vg5/3NMBnJSrzh2RPAfr5dmk=
X-Google-Smtp-Source: ABdhPJw3gCV80jRT9CDgfCsAV9mCk1p3R1GPkSXxWXR1LPAwd+ESOJ8gmooAWRB5PeOLIcEFg9Rxng==
X-Received: by 2002:a05:6a00:10cb:b0:4f7:942:6a22 with SMTP id d11-20020a056a0010cb00b004f709426a22mr9016766pfu.84.1646987412231;
        Fri, 11 Mar 2022 00:30:12 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.googlemail.com with ESMTPSA id l1-20020a17090aec0100b001bfa1bafeadsm9090576pjy.53.2022.03.11.00.30.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:30:12 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/5] KVM: X86: Boost vCPU which is in the critical section
Date:   Fri, 11 Mar 2022 00:29:12 -0800
Message-Id: <1646987354-28644-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
References: <1646987354-28644-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The missing semantic gap that occurs when a guest OS is preempted 
when executing its own critical section, this leads to degradation 
of application scalability. We try to bridge this semantic gap in 
some ways, by passing guest preempt_count to the host and checking 
guest irq disable state, the hypervisor now knows whether guest 
OSes are running in the critical section, the hypervisor yield-on-spin 
heuristics can be more smart this time to boost the vCPU candidate 
who is in the critical section to mitigate this preemption problem, 
in addition, it is more likely to be a potential lock holder.

Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
one VM running benchmark, the other(none-2) VMs running cpu-bound 
workloads, There is no performance regression for other benchmarks 
like Unixbench etc.

1VM:
            vanilla    optimized    improved

hackbench -l 50000
              28         21.45        30.5%
ebizzy -M
             12189       12354        1.4%
dbench
             712 MB/sec  722 MB/sec   1.4%

2VM:
            vanilla    optimized    improved

hackbench -l 10000
              29.4        26          13%
ebizzy -M
             3834        4033          5%
dbench
           42.3 MB/sec  44.1 MB/sec   4.3%

3VM:
            vanilla    optimized    improved

hackbench -l 10000
              47         35.46        33%
ebizzy -M
	     3828        4031         5%
dbench 
           30.5 MB/sec  31.16 MB/sec  2.3%

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c       | 22 ++++++++++++++++++++++
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 425fd7f38fa9..6b300496bbd0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10375,6 +10375,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int kvm_vcpu_non_preemptable(struct kvm_vcpu *vcpu)
+{
+	int count;
+
+	if (!vcpu->arch.pv_pc.preempt_count_enabled)
+		return 0;
+
+	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
+	    &count, sizeof(int)))
+		return (count & ~PREEMPT_NEED_RESCHED);
+
+	return 0;
+}
+
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.irq_disabled || kvm_vcpu_non_preemptable(vcpu))
+		return true;
+
+	return false;
+}
+
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
 	int r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..9f1a7d9540de 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1428,6 +1428,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_boost_candidate(struct kvm_vcpu *vcpu);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9581a24c3d17..ee5a788892e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3545,6 +3545,11 @@ bool __weak kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool __weak kvm_arch_boost_candidate(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
@@ -3580,6 +3585,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
 			    !kvm_arch_vcpu_in_kernel(vcpu))
 				continue;
+			if (!kvm_arch_boost_candidate(vcpu))
+				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
 
-- 
2.25.1

