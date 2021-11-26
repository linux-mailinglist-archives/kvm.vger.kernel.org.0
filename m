Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0B045F31E
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhKZRpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 12:45:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhKZRna (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 12:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637948416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQdg5fJJJalZgdk7/Dz8jdU4YnFhsfNkMpDrBm8mB5U=;
        b=K5lsyk+aJXZUfB91U2boWHyNurHBoJyLtertUyyq3DJU/TL883dCc6kz6o0jDm8tkXl6SB
        SPAIHTBDFdJhN6ws5ouTktVgLSpC7tBhJghrrwgijuO9NjoBEPoMRKWqMg9DuH8xlp4wiz
        Nb3iAXLfvTj/6ZFEW6oBiem2qZWF96g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-tzUQyjUsOCucaVTGYQbqSQ-1; Fri, 26 Nov 2021 12:40:13 -0500
X-MC-Unique: tzUQyjUsOCucaVTGYQbqSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF4FE612A0;
        Fri, 26 Nov 2021 17:40:09 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09A875D9CA;
        Fri, 26 Nov 2021 17:39:50 +0000 (UTC)
Message-ID: <93344a29-0231-0e38-0951-1519ff6979a8@redhat.com>
Date:   Fri, 26 Nov 2021 18:39:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 3/4] KVM: x86: Use different callback if msr access
 comes from the emulator
Content-Language: en-US
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
 <34208da8f51580a06e45afefac95afea0e3f96e3.1635842679.git.houwenlong93@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <34208da8f51580a06e45afefac95afea0e3f96e3.1635842679.git.houwenlong93@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/21 10:15, Hou Wenlong wrote:
> If msr access triggers an exit to userspace, the
> complete_userspace_io callback would skip instruction by vendor
> callback for kvm_skip_emulated_instruction(). However, when msr
> access comes from the emulator, e.g. if kvm.force_emulation_prefix
> is enabled and the guest uses rdmsr/wrmsr with kvm prefix,
> VM_EXIT_INSTRUCTION_LEN in vmcs is invalid and
> kvm_emulate_instruction() should be used to skip instruction
> instead.
> 
> As Sean noted, unlike the previous case, there's no #UD if
> unrestricted guest is disabled and the guest accesses an MSR in
> Big RM. So the correct way to fix this is to attach a different
> callback when the msr access comes from the emulator.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---

Queued with a small tweak: complete_emulated_msr_access is a version
of kvm_complete_insn_gp for emulated instructions, so call it
complete_emulated_insn_gp and give it an err argument.

Also I renamed __complete_emulated to complete_userspace_rdmsr, since
it applies also to the "fast" case.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e651ff56b4ad..3928c96d28be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -711,6 +711,17 @@ int kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err)
  }
  EXPORT_SYMBOL_GPL(kvm_complete_insn_gp);
  
+static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
+{
+	if (err) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
+				       EMULTYPE_COMPLETE_USER_EXIT);
+}
+
  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
  {
  	++vcpu->stat.pf_guest;
@@ -1816,7 +1827,7 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
  }
  EXPORT_SYMBOL_GPL(kvm_set_msr);
  
-static void __complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
  {
  	if (!vcpu->run->msr.error) {
  		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
@@ -1826,37 +1837,24 @@ static void __complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
  
  static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
  {
-	if (vcpu->run->msr.error) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
-				       EMULTYPE_COMPLETE_USER_EXIT);
+	return complete_emulated_insn_gp(vcpu, vcpu->run->msr.error);
  }
  
  static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
  {
-	__complete_emulated_rdmsr(vcpu);
-
+	complete_userspace_rdmsr(vcpu);
  	return complete_emulated_msr_access(vcpu);
  }
  
-static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
+static int complete_fast_msr_access(struct kvm_vcpu *vcpu)
  {
-	return complete_emulated_msr_access(vcpu);
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
  }
  
  static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
  {
-	__complete_emulated_rdmsr(vcpu);
-
-	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
-}
-
-static int complete_fast_wrmsr(struct kvm_vcpu *vcpu)
-{
-	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
+	complete_userspace_rdmsr(vcpu);
+	return complete_fast_msr_access(vcpu);
  }
  
  static u64 kvm_msr_reason(int r)
@@ -1931,7 +1929,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
  	} else {
  		/* MSR write failed? See if we should ask user space */
  		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
-				       complete_fast_wrmsr, r))
+				       complete_fast_msr_access, r))
  			return 0;
  		/* Signal all other negative errors to userspace */
  		if (r < 0)
@@ -7429,7 +7427,7 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
  	r = kvm_set_msr(vcpu, msr_index, data);
  
  	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
-				    complete_emulated_wrmsr, r)) {
+				    complete_emulated_msr_access, r)) {
  		/* Bounce to user space */
  		return X86EMUL_IO_NEEDED;
  	}

