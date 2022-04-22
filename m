Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F128E50B51A
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377071AbiDVKdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiDVKdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:33:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB3F193E6;
        Fri, 22 Apr 2022 03:30:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b24so9863139edu.10;
        Fri, 22 Apr 2022 03:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UIGF2yrhpVMa0xy286pYYiwJ1gwxTNrWbaIYNQ9PLHg=;
        b=MwH4StWDqbUX02jrMZlu3Oz68cIJ7X1GSNvAHCSv/eTgtvrHJtiNT1Ki6vBmpvbPzd
         ksCsSNt1s2Z7ILLAk2gU3GR3zzAMfoNq6yyqbzG8KMQIjO2pG4ACo+b2U7Kt36Pez2fb
         +/AKGVIfPiDitsetCT50qQiOi0H2NsZtxerygpPgqT/e9kcqR2saOa7ZWPDEF2BaYzIo
         0ONEnrcbRXui2s4MH0XB4vkAB0d67NsClatsm9hlp8A4CO+zSZymw/OUD5nOC9q1FgHk
         8k70W3Yzmm8FDtxXV5RHKGyjBDpT8lTlIWelCVs1USJenkF1Vi0q1s4aHxXrvVRJYe4f
         HO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=UIGF2yrhpVMa0xy286pYYiwJ1gwxTNrWbaIYNQ9PLHg=;
        b=Oifxug5yZ8r3IwS5ND5hOeuoPmmjyGFjy82jrgpfA/iVf3Ak4HjuoHaTrUZ+Eyx4eP
         yyEJwT0/czsY7UFdoc7ASWSE7qhTKng3ur+VWbZ8cU6L1qba8EmOMMDuS48mVRvj2XCs
         alIgF86OoP2YY4udTkEHz/HDxmCQxvw1f5cRBog+0GGZOzloc9T69wfiVlypzGRIv9Vx
         YhloJKE6esWMbf6/Smf+lqJdTvvB23FXRBgXSppJOd/aaVMoyx9+CeFW+tHR8tKpR6D8
         MujAUUtvIVuIVwexJ7JBRueMJYyA72gx1qn26ZI157Wf5LzQXREAOa4bX1opNc4n2SHh
         +qrg==
X-Gm-Message-State: AOAM533J7ARMqM+w5ir6uskN6QgjPh1h3O2uj1imaIzKpjRTl6QZhP9E
        53wEopYaMiMqsdYsSU6jq7KNUce6I6Ko9w==
X-Google-Smtp-Source: ABdhPJwhfYz3XwJfMIDystAbDuo5/DdRKTWOmogmRnohfErMWfPOPJt8VSLoEOcKYsJ8aeOWIjM32w==
X-Received: by 2002:a05:6402:84c:b0:423:e5a2:3655 with SMTP id b12-20020a056402084c00b00423e5a23655mr4159159edz.28.1650623415155;
        Fri, 22 Apr 2022 03:30:15 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d6-20020a170906304600b006ef5da1b1besm608225ejd.221.2022.04.22.03.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:30:14 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Date:   Fri, 22 Apr 2022 12:30:13 +0200
Message-Id: <20220422103013.34832-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_EXIT_SYSTEM_EVENT was introduced, it included a flags
member that at the time was unused.  Unfortunately this extensibility
mechanism has several issues:

- x86 is not writing the member, so it is not possible to use it
  on x86 except for new events

- the member is not aligned to 64 bits, so the definition of the
  uAPI struct is incorrect for 32-bit userspace.  This is a problem
  for RISC-V, which supports CONFIG_KVM_COMPAT.

Since padding has to be introduced, place a new field in there
that tells if the flags field is valid.  To allow further extensibility,
in fact, change flags to an array of 16 values, and store how many
of the values are valid.  The availability of the new ndata field
is tied to a system capability; all architectures are changed to
fill in the field.

For compatibility with userspace that was using the flags field,
a union overlaps flags with data[0].

Supersedes: <20220421180443.1465634-1-pbonzini@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 24 +++++++++++++++++-------
 arch/arm64/kvm/psci.c          |  3 ++-
 arch/riscv/kvm/vcpu_sbi.c      |  3 ++-
 arch/x86/kvm/x86.c             |  2 ++
 include/uapi/linux/kvm.h       |  8 +++++++-
 virt/kvm/kvm_main.c            |  1 +
 6 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 85c7abc51af5..4a900cdbc62e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5986,16 +5986,16 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
 			__u32 type;
-			__u64 flags;
+                        __u32 ndata;
+                        __u64 data[16];
 		} system_event;
 
 If exit_reason is KVM_EXIT_SYSTEM_EVENT then the vcpu has triggered
 a system-level event using some architecture specific mechanism (hypercall
 or some special instruction). In case of ARM64, this is triggered using
-HVC instruction based PSCI call from the vcpu. The 'type' field describes
-the system-level event type. The 'flags' field describes architecture
-specific flags for the system-level event.
+HVC instruction based PSCI call from the vcpu.
 
+The 'type' field describes the system-level event type.
 Valid values for 'type' are:
 
  - KVM_SYSTEM_EVENT_SHUTDOWN -- the guest has requested a shutdown of the
@@ -6010,10 +6010,20 @@ Valid values for 'type' are:
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
 
-Valid flags are:
+If KVM_CAP_SYSTEM_EVENT_DATA is present, the 'data' field can contain
+architecture specific information for the system-level event.  Only
+the first `ndata` items (possibly zero) of the data array are valid.
 
- - KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 (arm64 only) -- the guest issued
-   a SYSTEM_RESET2 call according to v1.1 of the PSCI specification.
+ - for arm64, data[0] is set to KVM_SYSTEM_EVENT_RESET_FLAG_PSCI_RESET2 if
+   the guest issued a SYSTEM_RESET2 call according to v1.1 of the PSCI
+   specification.
+
+ - for RISC-V, data[0] is set to the value of the second argument of the
+   ``sbi_system_reset`` call.
+
+Previous versions of Linux defined a `flags` member in this struct.  The
+field is now aliased to `data[0]`.  Userspace can assume that it is only
+written if ndata is greater than 0.
 
 ::
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index baac2b405f23..708d80e8e60d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -181,7 +181,8 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
-	vcpu->run->system_event.flags = flags;
+	vcpu->run->system_event.ndata = 1;
+	vcpu->run->system_event.data[0] = flags;
 	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index a09ecb97b890..a145f4356453 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -94,7 +94,8 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 
 	memset(&run->system_event, 0, sizeof(run->system_event));
 	run->system_event.type = type;
-	run->system_event.flags = flags;
+	run->system_event.ndata = 1;
+	run->system_event.data[0] = reason;
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6ab19afc638..7f21d9fe816f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10020,12 +10020,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
+			vcpu->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
 		if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
 			vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 			vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
+			vcpu->run->system_event.ndata = 0;
 			r = 0;
 			goto out;
 		}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 91a6fe4e02c0..f903ab0c8d7a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,7 +445,11 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 			__u32 type;
-			__u64 flags;
+			__u32 ndata;
+			union {
+				__u64 flags;
+				__u64 data[16];
+			};
 		} system_event;
 		/* KVM_EXIT_S390_STSI */
 		struct {
@@ -1144,6 +1148,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+/* #define KVM_CAP_VM_TSC_CONTROL 214 */
+#define KVM_CAP_SYSTEM_EVENT_DATA 215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f30bb8c16f26..6d971fb1b08d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4354,6 +4354,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 0;
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
+	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
 	default:
 		break;
-- 
2.35.1
