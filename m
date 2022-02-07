Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBE64AC9F6
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 20:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbiBGTzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 14:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241667AbiBGTvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 14:51:10 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21C0C0401DA
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 11:51:09 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id e6so14815684pfc.7
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 11:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vzlzaB5S/veay9fPsYouwaa7Ye2duYzjZ7MsDyh1dr4=;
        b=DWvVdPKojL+uX+8p3r/iCjkHgAERiMri1PzoB/Zo0kSnzI46zwpN2j6TOjDnLPvwVf
         hAbDf2McKmU2wDKHc+DePunkStheTMA5WRL1xC6HZRU5UBDR2TbsJO1UPDT1jxnBUXMV
         WhX37VktCtbWWXdlT+u9fYjz806AJFbK+zXU/1L6ZZeHcj0C/iES3inbmXTCs+1MTMjP
         XZk9QIg6fRn7NLS2LC5rdI80mmJXYEW5tlbZbrl99GdkVMk8BOgyhLlPPL2DSq0BCxIN
         yiN8vAxFu2y8FTQtM7uDKGpGPF0cehnZuJEoyK5Qk+/nuFvzXpsVX5Ozn1xE1xE7acTH
         fPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vzlzaB5S/veay9fPsYouwaa7Ye2duYzjZ7MsDyh1dr4=;
        b=V3+4Tmr+px916ICHp+x2FMe0IXZTS4JGrKmUnfYYp3T8Tvv29XDkoxiKAw42WQUwHA
         wIZy0JJLocM/u6O9AsGrsvmruVWxDK1CyF/RKq6R0lZS2t7MhnlGV30aotXbfZFaDdTd
         oOxkvzRIGEomGRsD2XiJRcolhWpuHBpCH+9ZwoUrPbbmdg5V9wT6V24i2HLZBDlQqe+M
         7+OnsvhCvCd3mfexrY4mGShuAtSuSdb5ynmp4mMIBih7W1O1pbHqBqgivw3nQbLCYzMf
         r44Px21ilgYn3uuLw7i3ldw1j+coPsCwDzh7EJJ9VFUuu/Gl/wbXdgFU2LOS/hkE8PVL
         iqzw==
X-Gm-Message-State: AOAM531yR3zlpe3l4RSzlWd1OoON4f47m4p7BK4iwWtyUL4sejkOwdbx
        OwucnsHnsqP4B/mGr71az0l58tOQDn1feg==
X-Google-Smtp-Source: ABdhPJxckrgaXyzE7hXmoCqcM4bymTTt+24ecIBSNEEEv8MA5Bd9AJg0cUoNit9K9VB1eF832B7YIQ==
X-Received: by 2002:a05:6a00:244e:: with SMTP id d14mr968685pfj.45.1644263469165;
        Mon, 07 Feb 2022 11:51:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c18sm12636184pfp.181.2022.02.07.11.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:51:08 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:51:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Fix wrong privilege check for code segment
 in __load_segment_descriptor()
Message-ID: <YgF4KX90nxxyaDcN@google.com>
References: <cover.1642669684.git.houwenlong.hwl@antgroup.com>
 <ed8917d7bab80a1c1a130beae45c7d6ecdef47fc.1642669684.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed8917d7bab80a1c1a130beae45c7d6ecdef47fc.1642669684.git.houwenlong.hwl@antgroup.com>
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

On Thu, Jan 20, 2022, Hou Wenlong wrote:
> Code segment descriptor can be loaded by jmp/call/ret, iret
> and int. The privilege checks are different between those
> instructions above realmode. Although, the emulator has
> use x86_transfer_type enumerate to differentiate them, but
> it is not really used in __load_segment_descriptor(). Note,
> far jump/call to call gate, task gate or task state segment
> are not implemented in emulator.
> 
> As for far jump/call to code segment, if DPL > CPL for conforming
> code or (RPL > CPL or DPL != CPL) for non-conforming code, it
> should trigger #GP. The current checks are ok.
> 
> As for far return, if RPL < CPL or DPL > RPL for conforming
> code or DPL != RPL for non-conforming code, it should trigger #GP.
> Outer level return is not implemented above virtual-8086 mode in
> emulator. So it implies that RPL <= CPL, but the current checks
> wouldn't trigger #GP if RPL < CPL.
> 
> As for code segment loading in task switch, if DPL > RPL for conforming
> code or DPL != RPL for non-conforming code, it should trigger #TS. Since
> segment selector is loaded before segment descriptor when load state from
> tss, it implies that RPL = CPL, so the current checks are ok.
> 
> The only problem in current implementation is mssing RPL < CPL check for
> far return. However, change code to follow the manual is better.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/emulate.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 864db6fbe8db..b7ce2a85e58e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1631,14 +1631,28 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
>  		if (!(seg_desc.type & 8))
>  			goto exception;
>  
> -		if (seg_desc.type & 4) {
> -			/* conforming */
> -			if (dpl > cpl)
> -				goto exception;
> -		} else {
> -			/* nonconforming */
> -			if (rpl > cpl || dpl != cpl)
> -				goto exception;

A comment here would be mildly helpful, e.g.

		/* RET can never return to an inner privilege level. */
> +		if (transfer == X86_TRANSFER_RET && rpl < cpl)
> +			goto exception;

And then as a follow-up patch, I think we can/should move the unhandled outer
privilege level logic here to make it easier to understand why the checks for RET
are incomplete, e.g.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a885b53dc7cc..a7cecd7beb91 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1631,8 +1631,15 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
                if (!(seg_desc.type & 8))
                        goto exception;

-               if (transfer == X86_TRANSFER_RET && rpl < cpl)
-                       goto exception;
+               if (transfer == X86_TRANSFER_RET) {
+                       /* RET can never return to an inner privilege level. */
+                       if (rpl < cpl)
+                               goto exception;
+                       /* Outer-privilege level return is not implemented */
+                       if (rpl > cpl)
+                               return X86EMUL_UNHANDLEABLE;
+               }
+
                if (transfer == X86_TRANSFER_RET || X86_TRANSFER_TASK_SWITCH) {
                        if (seg_desc.type & 4) {
                                /* conforming */
@@ -2227,9 +2234,6 @@ static int em_ret_far(struct x86_emulate_ctxt *ctxt)
        rc = emulate_pop(ctxt, &cs, ctxt->op_bytes);
        if (rc != X86EMUL_CONTINUE)
                return rc;
-       /* Outer-privilege level return is not implemented */
-       if (ctxt->mode >= X86EMUL_MODE_PROT16 && (cs & 3) > cpl)
-               return X86EMUL_UNHANDLEABLE;
        rc = __load_segment_descriptor(ctxt, (u16)cs, VCPU_SREG_CS, cpl,
                                       X86_TRANSFER_RET,
                                       &new_desc);
