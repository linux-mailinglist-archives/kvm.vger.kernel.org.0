Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6209E6DA7BB
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbjDGCdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbjDGCdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:33:54 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637DA7EFE;
        Thu,  6 Apr 2023 19:33:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x15so38790740pjk.2;
        Thu, 06 Apr 2023 19:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680834831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=//QYOA+X1f9Ckk0li+6bn2pfLRfjDCE1oZeZS4a+0yg=;
        b=D+j6BlkcqP+/kLSGH6nPd28OhSu3Ih+2pt8jAGwgG+A6mMmRLaHoYRNJuhwSdDctKS
         v6RF679AH2lmQOQkdmY/S2beRrIJS6wePXLSFDYbo83detHARdNGneZ1uQz4sEQqn4JR
         /ZQj5peQkAc1jrSJSJDxgjFeNNoclLrZPcvGUYBEhwRvp+e1ChsUtjzYEg9/N68eYwvA
         d+f1qlotAv3gGJmUd3XUVoeSrml7AjK9g7mWmsMaSBLxdCX1GWpUTpDHyDxcsufdhqyk
         LxpCV0lqfYZf2k4Xq8u/7ivrr82gNKz5XtoyXAW0eFOQIzswuGfyYk1tLthpOZ6qY+/f
         3FDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680834831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=//QYOA+X1f9Ckk0li+6bn2pfLRfjDCE1oZeZS4a+0yg=;
        b=UdcLK4OnpcDdM49sb9VwjlwPKR5AJOQt8nQGIAs20ZjXipL2+joUIzpk1hk8ljgxnp
         +Q4A5g8sOT5cJiEyJpiIbBocydMTiitF2RfwucsB7cd5ButeWkCdZLHlF+f/IVHQckDV
         QwdgHIpAq9/m0C/ZFUSOQx0Vyl4QAJN1aCn/T8MDO0p2ZjQXazVAk4k41S/gBWb5zjsC
         aDkosyqc63ZH1fLYqI/VSjM+cLlvNs7dOL6mVnGOWpmr11l6QPuvsDw0OeIAkStOTB3S
         6z8Xtk+fYPnC5TNS799ZsuIuFsuUG6vWHDNwv+8T8SUYXF4iNAso3MGi1a4v8D0Ut/ev
         vbNw==
X-Gm-Message-State: AAQBX9fQz7E8cQWbNoHUvDH803DybuyUTng9nIVCwX18rXfaBWNn6bXW
        WVe77i+kTAWFxdRAxQ8OapHJBFcYcBhYQd4DtFI=
X-Google-Smtp-Source: AKy350aWvW8OCoe6GeHK0oBFNNhJQYEGdalznyrGJqHZYYqINtR9Do+VAxNalOdqSDu9ARrWWVwtGTLjfGp3Ijjp9M4=
X-Received: by 2002:a17:902:b688:b0:1a1:8f72:e9b with SMTP id
 c8-20020a170902b68800b001a18f720e9bmr402799pls.7.1680834830827; Thu, 06 Apr
 2023 19:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <20230403140605.540512-4-jiangshanlai@gmail.com> <20230406210116.GG405948@hirez.programming.kicks-ass.net>
In-Reply-To: <20230406210116.GG405948@hirez.programming.kicks-ass.net>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Fri, 7 Apr 2023 10:33:38 +0800
Message-ID: <CAJhGHyBgJiR3gOsn0XNQqpvmxdG5EdWiK7_+O5u3P-QiCMnf5A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] x86/entry: Implement atomic-IST-entry
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 7, 2023 at 5:01=E2=80=AFAM Peter Zijlstra <peterz@infradead.org=
> wrote:
>
> On Mon, Apr 03, 2023 at 10:06:01PM +0800, Lai Jiangshan wrote:
>
> > diff --git a/arch/x86/entry/Makefile b/arch/x86/entry/Makefile
> > index ca2fe186994b..7cc1254ca519 100644
> > --- a/arch/x86/entry/Makefile
> > +++ b/arch/x86/entry/Makefile
> > @@ -8,11 +8,14 @@ UBSAN_SANITIZE :=3D n
> >  KCOV_INSTRUMENT :=3D n
> >
> >  CFLAGS_REMOVE_common.o               =3D $(CC_FLAGS_FTRACE)
> > +CFLAGS_REMOVE_ist_entry.o    =3D $(CC_FLAGS_FTRACE) $(RETHUNK_CFLAGS)
>
> This ^^^
>
>
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 49ddc4dd3117..50a24cc83581 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -443,6 +443,184 @@ SYM_CODE_END(\asmsym)
>
> > +.macro idtentry_ist vector asmsym cfunc user_cfunc has_error_code:req,=
 stack_offset:req
> > +SYM_CODE_START(\asmsym)
> > +     UNWIND_HINT_IRET_REGS offset=3D\has_error_code*8
> > +     ENDBR
> > +
> > +     /*
> > +      * Clear X86_EFLAGS_AC, X86_EFLAGS_DF and set a default ORIG_RAX.
> > +      *
> > +      * The code setting ORIG_RAX will not be replicated if interrupte=
d.
> > +      */
> > +     ASM_CLAC
> > +     cld
> > +
> > +     .if \has_error_code =3D=3D 0
> > +             pushq   $-1             /* ORIG_RAX: no syscall to restar=
t */
> > +     .endif
> > +
> > +     /*
> > +      * No register can be touched except %rsp,%rflags,%rip before
> > +      * pushing all the registers.  It is indispensable for nested
> > +      * atomic-IST-entry to replicate pushing the registers.
> > +      */
> > +     PUSH_REGS
> > +
> > +     /*
> > +      * Finished pushing register, all registers can be touched by now=
.
> > +      *
> > +      * Clear registers for the C function ist_copy_regs_to_main_stack=
()
> > +      * and the handler to avoid any possible exploitation of any
> > +      * speculation attack.
> > +      */
> > +     CLEAR_REGS
> > +
> > +     /*
> > +      * Copy the pt_regs to the IST main stack including the pt_regs o=
f
> > +      * the interrupted atomic-IST-entris, if any, by replicating.
> > +      */
> > +     movq    %rsp, %rdi                              /* pt_regs pointe=
r on its own IST stack */
> > +     leaq    PTREGS_SIZE-\stack_offset(%rsp), %rsi   /* struct cea_exc=
eption_stacks pointer */
> > +     call    ist_copy_regs_to_main_stack
>
> IIUC you do a CALL+RET here, before you call paranoid_entry ...
>
> > +
> > +     /*
> > +      * Commit stage.
> > +      */
> > +SYM_INNER_LABEL(start_commit_\asmsym, SYM_L_GLOBAL)
> > +     /*
> > +      * Switches to the IST main stack.  Before the switching is done,
> > +      * %rax is the copied pt_regs pointer in IST main stack.
> > +      */
> > +     movq    %rax, %rsp
> > +
> > +     /*
> > +      * The label should be immediate after the instruction that switc=
hes
> > +      * the stack since there is code assuming there is only one singl=
e
> > +      * instruction in the commit stage and the code assumes "%rsp in =
the
> > +      * IST main stack is also the sign of ending a atomic-IST-entry".
> > +      * (The code will be removed in future when %rip-based identifyin=
g
> > +      * is added.)
> > +      */
> > +SYM_INNER_LABEL(commit_\asmsym, SYM_L_GLOBAL)
> > +
> > +     /*
> > +      * Now, it is on the IST main stack.  For the whole kernel, the e=
ntries
> > +      * of the IST exceptions can be seen from here because the inside
> > +      * of the atomic-IST-entry can not be seen from the whole kernel
> > +      * except in the atomic-IST-entry or #DF.
> > +      */
> > +     UNWIND_HINT_REGS
> > +     ENCODE_FRAME_POINTER
> > +
> > +     /*
> > +      * The code setting ORIG_RAX will not be replicated if interrupte=
d.
> > +      * So redo it here.
> > +      */
> > +     .if \has_error_code =3D=3D 0
> > +             movq    $-1, ORIG_RAX(%rsp)     /* ORIG_RAX: no syscall t=
o restart */
> > +     .endif
> > +
> > +     /*
> > +      * If the entry is from userspace, switch stacks and treat it as
> > +      * a normal entry.
> > +      */
> > +     testb   $3, CS(%rsp)
> > +     jnz     .Lfrom_usermode_switch_stack_\@
> > +
> > +     /*
> > +      * paranoid_entry returns GS/CR3/SPEC_CTL information for
> > +      * paranoid_exit in RBX/R14/R15.
> > +      */
> > +     call    paranoid_entry
>
> ... all the way down here, which will do:
>
>   IBRS_ENTER;
>   UNTRAIN_RET_FROM_CALL;
>
> Which thus breaks the whole RetBleed mess, since that must not do RET
> before that happens.

I got it.
I will add the save-stage-3 in the atomic-IST-entry.

The benefit of the new stage:
  Do CR3/GSBASE/IBRS switching in the C atomic-IST-entry.
  (^^^^^ Also the drawback, which complicates the code, and basically needs=
:
   https://lore.kernel.org/lkml/20211126101209.8613-1-jiangshanlai@gmail.co=
m/ )
  The IST main stack can be in the Kernel CR3, not necessarily in the CEA
