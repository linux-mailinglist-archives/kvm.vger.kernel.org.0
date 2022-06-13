Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F3F549C8A
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242563AbiFMTAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242889AbiFMTAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:14 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A82598AE7C;
        Mon, 13 Jun 2022 09:17:18 -0700 (PDT)
Received: from anrayabh-desk.corp.microsoft.com (unknown [167.220.238.193])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7A83620BA5A7;
        Mon, 13 Jun 2022 09:17:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A83620BA5A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655137038;
        bh=meFGhXThMYkI6bGmOB3JmL0xkuk9FE1Fwvyp0NbJeSc=;
        h=From:To:Cc:Subject:Date:From;
        b=UWsF5JAj6tMdsgcX03JWid8sisCep2p0cvz/KbyNaD4oswnfcT99qhcTudmpK3dfW
         KGK1d3gUrcAT8ymgpf/epPzlq75nSXZr+PkzC/0mVyQp/SEP/P7fym6ceV+WI8GOVR
         NJNmk+V37HTwyDUJAgnQE/0R/Z+bQq0jRxgwzBJw=
From:   Anirudh Rayabharam <anrayabh@linux.microsoft.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ilias Stamatis <ilstam@amazon.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     mail@anirudhrb.com, kumarpraveen@linux.microsoft.com,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        wei.liu@kernel.org, robert.bradford@intel.com, liuwe@microsoft.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nVMX: Don't expose TSC scaling to L1 when on Hyper-V
Date:   Mon, 13 Jun 2022 21:46:10 +0530
Message-Id: <20220613161611.3567556-1-anrayabh@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VM entry into an L2 guest on KVM on Hyper-V fails with the following
splat (stripped for brevity) when running cloud-hypervisor tests.

[ 1481.600386] WARNING: CPU: 4 PID: 7641 at arch/x86/kvm/vmx/nested.c:4563 nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
[ 1481.600427] CPU: 4 PID: 7641 Comm: vcpu2 Not tainted 5.15.0-1008-azure #9-Ubuntu
[ 1481.600429] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 07/22/2021
[ 1481.600430] RIP: 0010:nested_vmx_vmexit+0x70d/0x790 [kvm_intel]
[ 1481.600447] Call Trace:
[ 1481.600449]  <TASK>
[ 1481.600451]  nested_vmx_reflect_vmexit+0x10b/0x440 [kvm_intel]
[ 1481.600457]  __vmx_handle_exit+0xef/0x670 [kvm_intel]
[ 1481.600467]  vmx_handle_exit+0x12/0x50 [kvm_intel]
[ 1481.600472]  vcpu_enter_guest+0x83a/0xfd0 [kvm]
[ 1481.600524]  vcpu_run+0x5e/0x240 [kvm]
[ 1481.600560]  kvm_arch_vcpu_ioctl_run+0xd7/0x550 [kvm]
[ 1481.600597]  kvm_vcpu_ioctl+0x29a/0x6d0 [kvm]
[ 1481.600634]  __x64_sys_ioctl+0x91/0xc0
[ 1481.600637]  do_syscall_64+0x5c/0xc0
[ 1481.600667]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1481.600670] RIP: 0033:0x7f688becdaff
[ 1481.600686]  </TASK>

As per the comments in arch/x86/kvm/vmx/evmcs.h, TSC multiplier field is
currently not supported in EVMCS. As a result, there is no TSC scaling
support when KVM is running on Hyper-V i.e. kvm_has_tsc_control is
false.

However, in nested_vmx_setup_ctls_msrs(), TSC scaling is exposed to L1.
When L1 tries to launch an L2 guest, vmcs12 has TSC scaling enabled.
This propagates to vmcs02. But KVM doesn't set the TSC multiplier value
because kvm_has_tsc_control is false. Due to this, VM entry for L2 guest
fails. (VM entry fails if "use TSC scaling" is 1 and TSC multiplier is 0.)

To fix, expose TSC scaling to L1 only if kvm_has_tsc_control.

Fixes: d041b5ea93352 ("KVM: nVMX: Enable nested TSC scaling")
Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f5cb18e00e78..d773ddc6422b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6656,6 +6656,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		      msrs->secondary_ctls_low,
 		      msrs->secondary_ctls_high);
 
+	if (!kvm_has_tsc_control)
+		msrs->secondary_ctls_high &= ~SECONDARY_EXEC_TSC_SCALING;
+
 	msrs->secondary_ctls_low = 0;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
@@ -6667,8 +6670,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_TSC_SCALING;
+		SECONDARY_EXEC_XSAVES;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.34.1

