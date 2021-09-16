Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3083540D495
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhIPIeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhIPIeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 04:34:04 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B13EC061574
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u19-20020a7bc053000000b002f8d045b2caso3903635wmc.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hovwpv8/OQn6x9tDTolJyyVnUo6SvlNiP0jevbAylog=;
        b=erClmfqNEUMOObMe1K7GB/9ZDK/Bpn0jIKjRgVTUrwxecbSf4ennBcY6kGVG5uujyF
         nRDl+MMcaEq6Q2u2IFxhTN4j/CWFR1tDy59C6QtgBiaCekMVqclEz6DVZHiF5vywCPd8
         hNABUniImH2WmyAq/i02c7mXx8XRqxhFI6BM4r1V/1jYSlwhrI5LUgBSXuweKmKBPKQL
         JVwioVd9Mc0i1bvu1ft0FQfhn/1o/NAaU24LLzAdRN9ZYmTNcld17etIolKiSUM47vvJ
         4X5gxB3+jrkcXDgiRn5DfnTRX/hcHpbYigWAbNnvHbJw78NbTWklR+bmVwgMSA6+sQeY
         52jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hovwpv8/OQn6x9tDTolJyyVnUo6SvlNiP0jevbAylog=;
        b=6eMn/mmPVf7P6jbEt7OBEtHsuCnnnJVztEAqpOiEV7PRGsBu+HVEEpt51FWGC0HZ1m
         C8Qs5BlTq8yySbMvXJndJZs+vCUuTTdzYWk2p8+8Fh6CuRKj7sxZKwVNOyeBU5Gk+GER
         OXg7iFtSvZ8mkPEvnk0464jOgoJOE7p2NaqgFqbIvkwIyqJoPcSJmdSJV1BYvHTmR1kB
         npalv24YY0ygDmML94xzny+5gzfZhOm+HMWUVk++dBngyuf41U65/Om3ziSttRQxCGIi
         2yJXRWZ+TIxF5DTVOHCrf+Wq6Ogx92xkkvkXLLKvKzAlKAXulURkOblVZMqls5hePGU3
         6f3w==
X-Gm-Message-State: AOAM532xHorDkueHsfj2FBkXSHQjSYPcjVUBFj3btIq0oBwWRvleIAuk
        nJSYWxmtbNiLRTMUE+ceImP+T8+QoBwZA88Q
X-Google-Smtp-Source: ABdhPJxMaeryzao83xZ/CCWFrq3FEf6R928NnwHGmexrP11CQvmmCMWxY8XIeY8EA1DvDa1jEdt0fw==
X-Received: by 2002:a1c:4406:: with SMTP id r6mr8718890wma.150.1631781163001;
        Thu, 16 Sep 2021 01:32:43 -0700 (PDT)
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net. [81.187.26.238])
        by smtp.gmail.com with ESMTPSA id u16sm2745555wmc.41.2021.09.16.01.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:32:42 -0700 (PDT)
From:   David Edmondson <dme@dme.org>
X-Google-Original-From: David Edmondson <david.edmondson@oracle.com>
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 1109c181;
        Thu, 16 Sep 2021 08:32:39 +0000 (UTC)
To:     linux-kernel@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v5 3/4] KVM: x86: On emulation failure, convey the exit reason, etc. to userspace
Date:   Thu, 16 Sep 2021 09:32:38 +0100
Message-Id: <20210916083239.2168281-4-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916083239.2168281-1-david.edmondson@oracle.com>
References: <20210916083239.2168281-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Should instruction emulation fail, include the VM exit reason, etc. in
the emulation_failure data passed to userspace, in order that the VMM
can report it as a debugging aid when describing the failure.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Edmondson <david.edmondson@oracle.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/vmx.c          |  5 +--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        |  6 +++
 4 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d22bbeb48f66..297581046460 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1658,6 +1658,9 @@ extern u64 kvm_mce_cap_supported;
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
 					void *insn, int insn_len);
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
+					  u64 *data, u8 ndata);
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99f8f7c4a510..e71f6ccafa5f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5378,10 +5378,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
 		    vcpu->arch.exception.pending) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			vcpu->run->internal.suberror =
-						KVM_INTERNAL_ERROR_EMULATION;
-			vcpu->run->internal.ndata = 0;
+			kvm_prepare_emulation_failure_exit(vcpu);
 			return 0;
 		}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28ef14155726..55fe3203a3c1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7468,29 +7468,78 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
-static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					   u8 ndata, u8 *insn_bytes, u8 insn_size)
 {
-	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
-	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct kvm_run *run = vcpu->run;
+	u64 info[5];
+	u8 info_start;
+
+	/*
+	 * Zero the whole array used to retrieve the exit info, as casting to
+	 * u32 for select entries will leave some chunks uninitialized.
+	 */
+	memset(&info, 0, sizeof(info));
+
+	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
+					   &info[2], (u32 *)&info[3],
+					   (u32 *)&info[4]);
 
 	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	run->emulation_failure.ndata = 0;
+
+	/*
+	 * There's currently space for 13 entries, but 5 are used for the exit
+	 * reason and info.  Restrict to 4 to reduce the maintenance burden
+	 * when expanding kvm_run.emulation_failure in the future.
+	 */
+	if (WARN_ON_ONCE(ndata > 4))
+		ndata = 4;
+
+	/* Always include the flags as a 'data' entry. */
+	info_start = 1;
 	run->emulation_failure.flags = 0;
 
 	if (insn_size) {
-		run->emulation_failure.ndata = 3;
+		BUILD_BUG_ON((sizeof(run->emulation_failure.insn_size) +
+			      sizeof(run->emulation_failure.insn_bytes) != 16));
+		info_start += 2;
 		run->emulation_failure.flags |=
 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
 		run->emulation_failure.insn_size = insn_size;
 		memset(run->emulation_failure.insn_bytes, 0x90,
 		       sizeof(run->emulation_failure.insn_bytes));
-		memcpy(run->emulation_failure.insn_bytes,
-		       ctxt->fetch.data, insn_size);
+		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
 	}
+
+	memcpy(&run->internal.data[info_start], info, sizeof(info));
+	memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
+	       ndata * sizeof(data[0]));
+
+	run->emulation_failure.ndata = info_start + ARRAY_SIZE(info) + ndata;
 }
 
+static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
+{
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
+				       ctxt->fetch.end - ctxt->fetch.data);
+}
+
+void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
+					  u8 ndata)
+{
+	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
+
+void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
+{
+	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -7505,16 +7554,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 
 	if (kvm->arch.exit_on_emulation_error ||
 	    (emulation_type & EMULTYPE_SKIP)) {
-		prepare_emulation_failure_exit(vcpu);
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
 	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
+		prepare_emulation_ctxt_failure_exit(vcpu);
 		return 0;
 	}
 
@@ -12153,9 +12200,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 	 * doesn't seem to be a real use-case behind such requests, just return
 	 * KVM_EXIT_INTERNAL_ERROR for now.
 	 */
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	kvm_prepare_emulation_failure_exit(vcpu);
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8618fe973215..cb032a95aca2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -397,6 +397,11 @@ struct kvm_run {
 		 * "ndata" is correct, that new fields are enumerated in "flags",
 		 * and that each flag enumerates fields that are 64-bit aligned
 		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 *
+		 * Space beyond the defined fields may be used to store arbitrary
+		 * debug information relating to the emulation failure. It is
+		 * accounted for in "ndata" but the format is unspecified and is
+		 * not represented in "flags". Any such information is *not* ABI!
 		 */
 		struct {
 			__u32 suberror;
@@ -408,6 +413,7 @@ struct kvm_run {
 					__u8  insn_bytes[15];
 				};
 			};
+			/* Arbitrary debug data may follow. */
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
-- 
2.33.0

