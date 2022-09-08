Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7F5B2459
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiIHRX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 13:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiIHRXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 13:23:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4E6EB87E
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 10:23:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so3165053pjh.3
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 10:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=0RNd0xzxjuuqcXZ1VJEa1kbSJZUe0y9yps+WlJN0nCg=;
        b=AStEFPv3MsxwGRwF6reOs3E+AdAfGuwDLh3caMiejk1AmBHiCn4VVhxqlp/ipyPW+d
         EPhoNhRoA4JdlYbMqQ0UGdAgtGVg2UsQKmzZVzpjN+lTIP0NlfHdQ2yGQ9DrAMMZ30SX
         uVZn2PHOdKJH++hE5CJ9+N3tFc2EL55mtTCFyhMMJ/ZJXJxHJJq1slFtGD0R6hQJv/75
         G9q2wrKRrF0ZC4YJlHGPxq7hI2S05U46l/XA4fssLZKW3eieAVQXjbGZ8At1MpgD8cAn
         d6f8yXUmqBASFtgYVVdQbPKpy6PUJjv4u0x36I0pllO7F8dpz3qXfLyOqsnYn9L52vcV
         SaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0RNd0xzxjuuqcXZ1VJEa1kbSJZUe0y9yps+WlJN0nCg=;
        b=UPREW2pWqVhV8IZGn+NmUeCK2F5xgytFTTGLxhzl1nhmkwByrmsNjvzhzszZB7vYya
         AP3auWWQIb3ZPQlVd4gW9bTOlISZ03tCiqZ70oOOm3iKp6yL/glc0z0+7RaHQJr6U+Rw
         HgCK/DrxFo5GTx7YT4Oi3GqXDjez+AwpOnNhEMgHr9nbI2DGTkssLY/Hbr4LJJB2icq7
         OYcfSUa/+rMvywd0xWhJEjRrJgTQFUs6g+vPuVVa62j0adTpSv+of1P6I4Kg58y6GiE3
         xQCAuHd3R24zsJ3Zhytro6sft24JnKrwT2UA+ciCN0PYInhj4W0lAgAkm1Ios50TUPub
         WmQQ==
X-Gm-Message-State: ACgBeo3caX/owVJ3jNFdXPjkIPOy9Q+2vuVzz261agk3PHzZG8R+vh2d
        eSE93ZcKorKdnrcNyVtbNEVop2eBK4EPfg==
X-Google-Smtp-Source: AA6agR5F50kewz5m2ZSHQ7DFQHRcr0K1iO6dsHody3ESwzgSbB/84P12G79GhGBm3Z71Gvuxpfg94Q==
X-Received: by 2002:a17:902:be01:b0:176:8bc3:b379 with SMTP id r1-20020a170902be0100b001768bc3b379mr10154520pls.109.1662657831302;
        Thu, 08 Sep 2022 10:23:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00172dc6e1916sm9901814pln.220.2022.09.08.10.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 10:23:50 -0700 (PDT)
Date:   Thu, 8 Sep 2022 17:23:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM/VMX: Do not declare vmread_error asmlinkage
Message-ID: <YxolI46A4Vvh1gW2@google.com>
References: <20220817144045.3206-1-ubizjak@gmail.com>
 <YxDSTU+pWBdZgs/Q@google.com>
 <CAFULd4aQvHczwv1rZz6QJ6wEfjd0ORB_3rQdmP-PtfasNxe3rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4aQvHczwv1rZz6QJ6wEfjd0ORB_3rQdmP-PtfasNxe3rw@mail.gmail.com>
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

On Thu, Sep 01, 2022, Uros Bizjak wrote:
> On Thu, Sep 1, 2022 at 5:40 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Aug 17, 2022, Uros Bizjak wrote:
> > > There is no need to declare vmread_error asmlinkage, its arguments
> > > can be passed via registers for both, 32-bit and 64-bit targets.
> > > Function argument registers are considered call-clobbered registers,
> > > they are saved in the trampoline just before the function call and
> > > restored afterwards.
> > >
> > > Note that asmlinkage and __attribute__((regparm(0))) have no effect
> > > on 64-bit targets. The trampoline is called from the assembler glue
> > > code that implements its own stack-passing function calling convention,
> > > so the attribute on the trampoline declaration does not change anything
> > > for 64-bit as well as 32-bit targets. We can declare it asmlinkage for
> > > documentation purposes.
> >
> > ...
> >
> > > diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
> > > index 5cfc49ddb1b4..550a89394d9f 100644
> > > --- a/arch/x86/kvm/vmx/vmx_ops.h
> > > +++ b/arch/x86/kvm/vmx/vmx_ops.h
> > > @@ -10,9 +10,9 @@
> > >  #include "vmcs.h"
> > >  #include "../x86.h"
> > >
> > > -asmlinkage void vmread_error(unsigned long field, bool fault);
> > > -__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
> > > -                                                      bool fault);
> > > +void vmread_error(unsigned long field, bool fault);
> > > +asmlinkage void vmread_error_trampoline(unsigned long field,
> > > +                                     bool fault);
> > >  void vmwrite_error(unsigned long field, unsigned long value);
> > >  void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
> > >  void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
> >
> > If it's ok with you, I'll split this into two patches.  One to drop asmlinkage
> > from vmread_error(), and one to convert the open coded regparm to asmlinkage.
> 
> Sure, please go ahead.

On second thought, even though "__attribute__((regparm(0)))" doesn't actually do
anything for 64-bit targets, I'd prefer to keep the open coded weirdness _because_
the whole thing is open coded weirdness.  The attribute isn't strictly necessary
for 32-bit targets either since the CALL is emitted from inline assembly.  

I now remember that I added the explicit regparm(0) to try and document that
vmread_error_trampoline() _always_ passes params on the stack, even for 64-bit
targets, i.e. even if "asmlinkage" is a nop.

Alternatively, given that the trampoline exists purely to support inline asm, i.e.
should never be called from C code in any circumstance, what about turning the
function declaration into an opaque symbol and then writing a proper comment.

That way, attempting to invoke vmread_error_trampoline() from C yields:

arch/x86/kernel/../kvm/vmx/vmx_ops.h: In function ‘__vmcs_readl’:
arch/x86/kernel/../kvm/vmx/vmx_ops.h:113:2: error: called object ‘vmread_error_trampoline’ is not a function or function pointer
  113 |  vmread_error_trampoline(field, false);
      |  ^~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kernel/../kvm/vmx/vmx_ops.h:33:22: note: declared here
   33 | extern unsigned long vmread_error_trampoline;
      |                      ^~~~~~~~~~~~~~~~~~~~~~~
---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 8 Sep 2022 10:17:40 -0700
Subject: [PATCH] KVM: VMX: Make vmread_error_trampoline() uncallable from C
 code

Declare vmread_error_trampoline() as an opaque symbol so that it cannot
be called from C code, at least not without some serious fudging.  The
trampoline always passes parameters on the stack so that the inline
VMREAD sequence doesn't need to clobber registers.  regparm(0) was
originally added to document the stack behavior, but it ended up being
confusing because regparm(0) is a nop for 64-bit targets.

Opportunustically wrap the trampoline and its declaration in #ifdeffery
to make it even harder to invoke incorrectly, to document why it exists,
and so that it's not left behind if/when CONFIG_CC_HAS_ASM_GOTO_OUTPUT
is true for all supported toolchains.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S |  2 ++
 arch/x86/kvm/vmx/vmx_ops.h | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..24c54577ac84 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -269,6 +269,7 @@ SYM_FUNC_END(__vmx_vcpu_run)
 
 .section .text, "ax"
 
+#ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 /**
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
@@ -317,6 +318,7 @@ SYM_FUNC_START(vmread_error_trampoline)
 
 	RET
 SYM_FUNC_END(vmread_error_trampoline)
+#endif
 
 SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	/*
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index ec268df83ed6..7ea99e6b4908 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -11,14 +11,28 @@
 #include "../x86.h"
 
 void vmread_error(unsigned long field, bool fault);
-__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
-							 bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
 void invvpid_error(unsigned long ext, u16 vpid, gva_t gva);
 void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
 
+#ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+/*
+ * The VMREAD error trampoline _always_ uses the stack to pass parameters, even
+ * for 64-bit targets.  Preserving all registers allows the VMREAD inline asm
+ * blob to avoid clobbering GPRs, which in turn allows the compiler to better
+ * optimize sequences of VMREADs.
+ *
+ * Declare trampoline as an opaque label as it's not safe to call from C code;
+ * there is no way to tell the compiler to pass params on the stack for 64-bit
+ * targets.
+ *
+ * void vmread_error_trampoline(unsigned long field, bool fault);
+ */
+extern unsigned long vmread_error_trampoline;
+#endif
+
 static __always_inline void vmcs_check16(unsigned long field)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,

base-commit: d2a22504d86e106c63236e4d6a085c2ac91bfa73
-- 

