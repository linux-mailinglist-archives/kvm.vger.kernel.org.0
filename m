Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1872A6D04D3
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjC3MgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjC3MgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:36:01 -0400
Received: from out0-209.mail.aliyun.com (out0-209.mail.aliyun.com [140.205.0.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49A7681;
        Thu, 30 Mar 2023 05:35:59 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.S2zl1PU_1680179755;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.S2zl1PU_1680179755)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 20:35:55 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Disallow enable KVM_CAP_X86_DISABLE_EXITS capability after vCPUs have been created
Date:   Thu, 30 Mar 2023 20:35:52 +0800
Message-Id: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disable PAUSE/MWAIT/HLT exits after vCPUs have been created is useless,
because PAUSE/MWAIT/HLT intercepts configuration is not changed after
vCPU created.  And two vCPUs may have inconsistent configuration if
disable PAUSE/MWAIT/HLT exits between those two vCPUs creation. Since
it's a per-VM capability, all vCPUs should keep same configuration, so
disallow enable KVM_CAP_X86_DISABLE_EXITS capability after vCPUs have
been created.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 Documentation/virt/kvm/api.rst | 3 ++-
 arch/x86/kvm/x86.c             | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a69e91088d76..95a683a27cf2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7179,7 +7179,8 @@ branch to guests' 0x200 interrupt vector.
 
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
-:Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+:Returns: 0 on success, -EINVAL when args[0] contains invalid exits or
+	  any vCPUs have been created.
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c0ff40e5345..7e97595465fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6275,6 +6275,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
 
@@ -6296,6 +6299,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];

base-commit: 27d6845d258b67f4eb3debe062b7dacc67e0c393
-- 
2.31.1

