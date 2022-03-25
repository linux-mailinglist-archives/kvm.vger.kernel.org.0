Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C574E6B8A
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 01:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354460AbiCYAc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244461AbiCYAc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 20:32:27 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AB7BB0A5
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 17:30:54 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s11so5175538pfu.13
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 17:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sT++Sbv3yv44jpWPDzJCjmE016t10eGwjWsnnphuwaI=;
        b=WSJ1niw8OUOyRcVJUbvnRomTn0ej0KhsbUD4z63aV8mZ4NTlYRsFFurxEoMFEz/1FO
         t41bPWORqiEAiqyouh+sh+pVv47TiassUGvfzgSGjEU1KXfhNFzpX82K3Z30U6hxSIYJ
         /wY0B5Kamw0RjswuwHv+EPzqQlCySGI6Rfg7b2X9YK5b+bbvorC0fU8I8R0T03j22IIe
         dWLfVe7uW3agUoTJhyeVYpmT0echkCcD8jOm0L4FGs8EBnjfahZOLUP9F6rjMQ334VjC
         8MSEOLovNB12yXiMXgwttg/NounBtQZmO1rhnk159ykEA+TqddCPM4ZnXh4bCR0FVWWt
         D8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sT++Sbv3yv44jpWPDzJCjmE016t10eGwjWsnnphuwaI=;
        b=rgaWlBIbomZ2+I3jJ/KVQwsIembc4ZJqUyy6WGeKh1Dij7zcFg8pAlcjkmiG/+UrKn
         zgYqVKqsylfWHMzBtitjnc1bHyOVor2Ex8SqGL+l9Szroj6PMDNHOnJGGEFj6GmN448D
         xCquDlGVF8mq8JI/y3xglWf2u+VKlXAfvy/U6cKLovZj2LYXBEin5o/SRjkpGrv0DMBY
         hFWcrLJajIZxr3HLogHcA4+sxU5FyDRKN4ElGn0xQ9aK3f2YclnntQ7WwH2LAzCcHGQh
         bW2VfbPlBARPAcwGKyzQFHDztwMrdITUXkTwO8ihILqKinnrTO3oblr7U/lahSbdFrKJ
         Hrhw==
X-Gm-Message-State: AOAM531bcxmVtXlm4fqk5N2C9w1TyhBIX/YeiN5NH56FmjOBBrojxYPR
        A46as9XVV3W1O1xPTd//C7/upw==
X-Google-Smtp-Source: ABdhPJxe96HNwHbTg/0Xb4UdP7lNM9iHwkgp7D4qTbrNEMngQ6im+BNpVB7p3IkqteiEZhYT4n4f+g==
X-Received: by 2002:a65:654f:0:b0:378:b8f6:ebe4 with SMTP id a15-20020a65654f000000b00378b8f6ebe4mr5903840pgw.399.1648168253483;
        Thu, 24 Mar 2022 17:30:53 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u14-20020a056a00124e00b004fab8f3245fsm4966035pfi.149.2022.03.24.17.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 17:30:52 -0700 (PDT)
Date:   Fri, 25 Mar 2022 00:30:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     SU Hang <darcy.sh@antgroup.com>
Cc:     kvm@vger.kernel.org,
        =?utf-8?B?6LWW5rGf5bGx?= <jiangshan.ljs@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: X86: use EPT_VIOLATION_* instead of 0x7
Message-ID: <Yj0NOQOYEAG+Dz7+@google.com>
References: <20220321094203.109546-1-darcy.sh@antgroup.com>
 <20220321094203.109546-2-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321094203.109546-2-darcy.sh@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022, SU Hang wrote:
> Use symbolic value, EPT_VIOLATION_*, instead of 0x7
> in FNAME(walk_addr_generic)().
> 
> Signed-off-by: SU Hang <darcy.sh@antgroup.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 7853c7ef13a1..2e2b1f7ccaca 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -531,7 +531,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
>  		if (fetch_fault)
>  			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
> -		vcpu->arch.exit_qualification |= (pte_access & 0x7) << 3;

Oof.  I suspect this was done to avoid conditional branches, but more importantly...

> +		if (pte_access & ACC_USER_MASK)
> +			vcpu->arch.exit_qualification |= EPT_VIOLATION_READABLE;
> +		if (pte_access & ACC_WRITE_MASK)
> +			vcpu->arch.exit_qualification |= EPT_VIOLATION_WRITABLE;
> +		if (pte_access & ACC_EXEC_MASK)
> +			vcpu->arch.exit_qualification |= EPT_VIOLATION_EXECUTABLE;

This is subtly wrong.  pte_access is the raw RWX bits out of the EPTE, walker->pte_access
is the version that holds ACC_*_MASK flags after running pte_access through
FNAME(gpte_access).

I'm definitely in favor of a cleanup.  What about formalizing the shift and using
VMX_EPT_RWX_MASK both here and in the generation of the mask for use in KVM's
EPT violation handler?


From: Sean Christopherson <seanjc@google.com>
Date: Thu, 24 Mar 2022 17:23:18 -0700
Subject: [PATCH] KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX
 bits

Derive the mask of RWX bits reported on EPT violations from the mask of
RWX bits that are shoved into EPT entries; the layout is the same, the
EPT violation bits are simply shifted by three.  Use the new shift and a
slight copy-paste of the mask derivation instead of completely open
coding the same to convert between the EPT entry bits and the exit
qualification when synthesizing a nested EPT Violation.

No functional change intended.

Cc: SU Hang <darcy.sh@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h     | 8 ++------
 arch/x86/kvm/mmu/paging_tmpl.h | 8 +++++++-
 arch/x86/kvm/vmx/vmx.c         | 4 +---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a6789fe9b56e..6c23905d5465 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -543,17 +543,13 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_ACC_READ_BIT	0
 #define EPT_VIOLATION_ACC_WRITE_BIT	1
 #define EPT_VIOLATION_ACC_INSTR_BIT	2
-#define EPT_VIOLATION_READABLE_BIT	3
-#define EPT_VIOLATION_WRITABLE_BIT	4
-#define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_RWX_SHIFT		3
 #define EPT_VIOLATION_GVA_VALIDATION_BIT 7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
 #define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
-#define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
-#define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
-#define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
 #define EPT_VIOLATION_GVA_VALIDATION	(1 << EPT_VIOLATION_GVA_VALIDATION_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 3c7f2d12b883..90a8e2bb1a3a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -529,7 +529,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
 		if (fetch_fault)
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
-		vcpu->arch.exit_qualification |= (pte_access & 0x7) << 3;
+
+		/*
+		 * Note, pte_access holds the raw RWX bits from the EPTE, not
+		 * ACC_*_MASK flags!
+		 */
+		vcpu->arch.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
+						 EPT_VIOLATION_RWX_SHIFT;
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84a7500cd80c..6c554d2a2038 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5410,9 +5410,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification &
-		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
-			EPT_VIOLATION_EXECUTABLE))
+	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
 		      ? PFERR_PRESENT_MASK : 0;

 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?

base-commit: 7cd469b5705bcfa65c3055f899c9e3e751053051
--
