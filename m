Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52AB51C3F6
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 17:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381364AbiEEPcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 11:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381377AbiEEPcL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 11:32:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1469A5C373
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 08:28:31 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id p6so4187810plr.12
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+KT4WFZLK+9bXvVvtvjzAWWyt9RTKX24CKgwZm5SlTA=;
        b=OHKlp2KKRZGth2i4kv1eb9rroBYLx9Gf5s4NvkKCVcRu38TJalQPwZm2UPo6gJtN+/
         DwuGi5+LxS5iDAypuHk84HSDX9LUmpdvL+ePJoxKGGbj2PP1mI13cDb20pNRwAHrxpWE
         wcdRzc9/iJdKYDcX9fFxJlFLPj5TwROqAC4vLnoRrJ6HVI3l7novomHykGIFccXQUsL0
         1nsE0JMQQATXaoka4CYGrRJaaffJsL0OUPPisaPypIgX+Qx6UmvQG+o9qjcYa8bkdDPy
         3FNaO0sQQJfDZHgOPMhm6sXPsiZbTMHj/UNwn+X2HvMpxE24iof0ZgnvnimwI02XyNXW
         M9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+KT4WFZLK+9bXvVvtvjzAWWyt9RTKX24CKgwZm5SlTA=;
        b=XjtfA11U2qnnycwVmxBjwEi/BxpoPqPvN+UUTpr6J2cwjk2RIlybOglqz/vGWjl3D1
         JWdI8CGiPP4kCegujf9tG5sOehnQOqnW18ZBwAmP10BOE0KO+xV1WSm6kbR25XBrUxTg
         T3TmoGcogfBbguvLMnn5A+1a6mGKPXyfyC73H26fMKe09E6UdII5lO3MqPJFD7LyS7DT
         VLEbMgBHYP8FTl21kmgL21H8zzWKNro1ymRQ9el8jzq1YUazPNmsTgQYPAJa42pX8lAX
         tVsWkYP42GXVbZqByEe5Avzckknb9FTYB2+hSpRG35FRdFA3F+vgMjPjU9Lw5yrfCJ6O
         /E5Q==
X-Gm-Message-State: AOAM533op6OGE0red1q+qWP/EuTAwZGLzByC0x4OtJcYJLkRZk8fIx84
        a174DHzgX9Pze1DkNO73x3pVEkN+izbg8Q==
X-Google-Smtp-Source: ABdhPJwX92N18CJ3+hdc658Ur1vLroE7M32KqfyijM8XQ/wZ8CpBZm8kUV4kq7odyU+dHSys5I/uHQ==
X-Received: by 2002:a17:90a:ca89:b0:1d9:7d1a:c337 with SMTP id y9-20020a17090aca8900b001d97d1ac337mr6824386pjt.88.1651764510455;
        Thu, 05 May 2022 08:28:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t11-20020a65554b000000b003c14af5062csm1459302pgr.68.2022.05.05.08.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 08:28:29 -0700 (PDT)
Date:   Thu, 5 May 2022 15:28:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: VMX: unify VMX instruction error reporting
Message-ID: <YnPtGrXbef822v7U@google.com>
References: <20220504231916.2883796-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504231916.2883796-1-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 04, 2022, Jim Mattson wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Include the value of the "VM-instruction error" field from the current
> VMCS (if any) in the error message whenever a VMX instruction (other
> than VMREAD) fails. Previously, this field was only reported for
> VMWRITE errors.

Eh, this is pointless for INVVPID and INVEPT, they both have a single error
reason.  VMCLEAR is slightly less pointless, but printing the PA will most likely
make the error reason superfluous.  Ditto for VMPTRLD.

I'm not strictly opposed to printing the error info, but it's not a clear cut win
versus the added risk of blowing up the VMREAD (which is a tiny risk, but non-zero).
And, if we want to do this for everything, then we might as well do it for VMREAD
too.

To reduce the risk of blowing up the host and play nice with VMREAD, what about
adding a dedicated "safe" helper to read VM_INSTRUCTION_ERROR for the error
handlers?  Then modify this patch to go on top...

Compile tested only (I can fully test later today).

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 5 May 2022 08:19:58 -0700
Subject: [PATCH] KVM: VMX: Add a dedicated "safe" helper for
 VMREAD(VM_INSTRUCTION_ERROR)

Add a fully "safe" helper to do VMREAD(VM_INSTRUCTION_ERROR) so that VMX
instruction error handlers, e.g. for VMPTRLD, VMREAD itself, etc..., can
get and print the extra error information without the risk of triggering
kvm_spurious_fault() or an infinite loop (in the VMREAD case).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26ec9b814651..14ac7b8b0723 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -373,6 +373,26 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var);

 void vmx_vmexit(void);

+static u32 vmread_vm_instruction_error_safe(void)
+{
+	unsigned long value;
+
+	asm volatile("1: vmread %1, %0\n\t"
+		     "ja 3f\n\t"
+
+		     /* VMREAD failed or faulted, clear the return value. */
+		     "2:\n\t"
+		     "xorl %k0, %k0\n\t"
+		     "3:\n\t"
+
+		     _ASM_EXTABLE(1b, 2b)
+
+		     : "=&r"(value)
+		     : "r"((unsigned long)VM_INSTRUCTION_ERROR)
+		     : "cc");
+	return value;
+}
+
 #define vmx_insn_failed(fmt...)		\
 do {					\
 	WARN_ONCE(1, fmt);		\
@@ -390,7 +410,7 @@ asmlinkage void vmread_error(unsigned long field, bool fault)
 noinline void vmwrite_error(unsigned long field, unsigned long value)
 {
 	vmx_insn_failed("kvm: vmwrite failed: field=%lx val=%lx err=%d\n",
-			field, value, vmcs_read32(VM_INSTRUCTION_ERROR));
+			field, value, vmread_vm_instruction_error_safe());
 }

 noinline void vmclear_error(struct vmcs *vmcs, u64 phys_addr)

base-commit: 68973d7fff6d23ae4d05708db429c56e50d377e5
--

