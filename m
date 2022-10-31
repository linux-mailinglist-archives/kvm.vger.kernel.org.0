Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AF7613493
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 12:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiJaLgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 07:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJaLgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 07:36:42 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010FDE0A1
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 04:36:40 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N19xv71JRzpW4m;
        Mon, 31 Oct 2022 19:33:07 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 19:36:38 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>, <hpa@zytor.com>, <cuigaosheng1@huawei.com>
CC:     <kvm@vger.kernel.org>
Subject: [PATCH] KVM: x86: fix undefined behavior in bit shift for __feature_bit
Date:   Mon, 31 Oct 2022 19:36:38 +0800
Message-ID: <20221031113638.4182263-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in arch/x86/kvm/reverse_cpuid.h:101:11
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 kvm_set_cpu_caps+0x15a/0x770 [kvm]
 hardware_setup+0xa6f/0xdfe [kvm_intel]
 kvm_arch_hardware_setup+0x100/0x1e80 [kvm]
 kvm_init+0xdb/0x560 [kvm]
 vmx_init+0x161/0x2b4 [kvm_intel]
 do_one_initcall+0x76/0x430
 do_init_module+0x61/0x28a
 load_module+0x1f82/0x2e50
 __do_sys_finit_module+0xf8/0x190
 __x64_sys_finit_module+0x23/0x30
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fixes: a7c48c3f56db ("KVM: x86: Expand build-time assertion on reverse CPUID usage")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 arch/x86/kvm/reverse_cpuid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..ebd6b621d3b8 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -98,7 +98,7 @@ static __always_inline u32 __feature_bit(int x86_feature)
 	x86_feature = __feature_translate(x86_feature);
 
 	reverse_cpuid_check(x86_feature / 32);
-	return 1 << (x86_feature & 31);
+	return 1U << (x86_feature & 31);
 }
 
 #define feature_bit(name)  __feature_bit(X86_FEATURE_##name)
-- 
2.25.1

