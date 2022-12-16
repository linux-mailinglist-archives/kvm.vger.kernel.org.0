Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6564E56E
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 01:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLPAwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 19:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLPAws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 19:52:48 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE855437A
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 16:52:46 -0800 (PST)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1p5yxu-002d5K-7p; Fri, 16 Dec 2022 01:52:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From; bh=rlkIXPpKwlJWkilWogmTbM2mAa494bBbvJzol6Sp1LU=; b=VFy/13IueiZ3g
        jGwBv0nZXIgsXnpcgwQgEdlS/uiG3VIvu/LXEe+XnRYvNzHF2OtDrzpSevQuGdRy2GZAAOihgBaAl
        jrxRCeIBNcsgsHY8TCCJiITzgiVFJMAGiqH4uLqmb5GpQQqJaFCflEmFp6yIdtHb3yheY41dS4uNc
        r6uaQB+Zupzbyq+H5grwiIxvhVZj9H6kaAMNpqD38ISkKg55UKqP654L++Y/iy+/vno53UaH0B0vH
        JfB3dqW7MCogsBTReF1/ftbmPVomXFOZ1VS7wmphf26AuaVrW3gichytTX7jlVVSAkGZFAj8FdxOQ
        tqUsCT4o/71ChLbTqdj+A==;
Received: from [10.9.9.72] (helo=submission01.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1p5yxr-0005wW-1S; Fri, 16 Dec 2022 01:52:39 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1p5yxk-0003n4-49; Fri, 16 Dec 2022 01:52:32 +0100
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com,
        pbonzini@redhat.com, Michal Luczaj <mhal@rbox.co>
Subject: [PATCH] KVM: x86/xen: Fix memory leak in kvm_xen_write_hypercall_page()
Date:   Fri, 16 Dec 2022 01:52:04 +0100
Message-Id: <20221216005204.4091927-1-mhal@rbox.co>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Release page irrespectively of kvm_vcpu_write_guest() return value.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
# cat /sys/kernel/debug/kmemleak
unreferenced object 0xffff888131eff000 (size 4096):
  comm "xen_hcall_leak", pid 949, jiffies 4294753212 (age 11.943s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000e2915da4>] __kmalloc_node_track_caller+0x44/0xa0
    [<00000000a9f05df2>] memdup_user+0x26/0x90
    [<000000008e647779>] kvm_xen_write_hypercall_page+0xaa/0x160 [kvm]
    [<00000000e5da0818>] vmx_set_msr+0x8d3/0x1090 [kvm_intel]
    [<000000003f0226a5>] __kvm_set_msr+0x6f/0x1a0 [kvm]
    [<00000000d3dc90c4>] kvm_emulate_wrmsr+0x4b/0x120 [kvm]
    [<00000000093585d7>] vmx_handle_exit+0x1b6/0x710 [kvm_intel]
    [<000000006fa8c15e>] vcpu_run+0xfbf/0x16f0 [kvm]
    [<00000000891f7860>] kvm_arch_vcpu_ioctl_run+0x1d2/0x650 [kvm]
    [<000000001b8d2d97>] kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
    [<00000000e7aa7a58>] __x64_sys_ioctl+0x85/0xc0
    [<00000000c41da0be>] do_syscall_64+0x55/0x80
    [<000000001635e1c8>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

 arch/x86/kvm/xen.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f3098c0e386a..61953248bc0c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -879,6 +879,8 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 						 instructions, sizeof(instructions)))
 				return 1;
 		}
+
+		return 0;
 	} else {
 		/*
 		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
@@ -889,6 +891,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
 				  : kvm->arch.xen_hvm_config.blob_size_32;
 		u8 *page;
+		int ret;
 
 		if (page_num >= blob_size)
 			return 1;
@@ -899,12 +902,11 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
-			kfree(page);
-			return 1;
-		}
+		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
+		kfree(page);
+
+		return !!ret;
 	}
-	return 0;
 }
 
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
-- 
2.38.1

