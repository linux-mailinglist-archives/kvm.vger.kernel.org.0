Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A87444CB
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 00:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjF3WYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 18:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjF3WX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 18:23:59 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6BC3AB2
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 15:23:58 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-3a04cb10465so1670136b6e.3
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 15:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688163838; x=1690755838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eM6Qetv/mAEF2QVjfd/Gc1RFfslFXXvgrJyZmHlJgtI=;
        b=I2kxrW2JAu7+5BqJReJ/8zEO3HwEWg9108eJiNYUFOy6vOVTpgxKcOBkY/dR2Q6SAv
         zdMgDLd5kOypYMR+xafnxhHwL4rd8HLX05Rs3L7pzpK1ll+V6goduU34sEj214i8KH+Z
         YtO2kwqPwd9jj/gYhr+VDVjmTHRPeFIjmp4uP0g33sBWW60ilOKO1sOmZYjozhSu2juQ
         NhyPTnJxv16YWnNu4cLPN7MH7MokVui7H3i/Drr2TZOW+F9L93dAdUa44GRzyfseF0YS
         p4cUCy0R4btfHRuqlxHCKoL5TNDI5ici5Hj+59AivLqw4MGg9tavsSeZCRWK1Vx1M7Hs
         xz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688163838; x=1690755838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eM6Qetv/mAEF2QVjfd/Gc1RFfslFXXvgrJyZmHlJgtI=;
        b=j7xXqovBZ1EdkwqnRRMmi2cYvRDDQXR+p6bRDrgc0Y/9UZ41mYkbEFcDF//PrXPwu6
         WzJXqS9lriMwgx27WvZrnJcWi90vXr/0TI9tIKAAPyvr2dvw+B9MFIJdvPDwsHwIIFjl
         y0jOE5DOs1+oy1jBss1DyUDtOgit13P9PixH7zoO5bh8CTR5fNJxGZxA1PnyVsEMX/Ow
         tPzl/ZyRqKtN8jO6jXBqhBjODriXij3EaqmzuoAG+o/ymz0QQCx4aLC7Y4pVEHlgabXX
         KWMKNlrm41zSrSCG9Bt7xB0Re4o3nqS5aaIGRDKrbNroISgegFgC18N8I5NbwycsiTJS
         8nVA==
X-Gm-Message-State: AC+VfDyHuMD4f6LlP1whAj3+NQaxwmHxZ3iPiW9zVznIffANJ2s5q26O
        tuH9lsnTXpFxorCTKkdxWEQ=
X-Google-Smtp-Source: ACHHUZ4hC+WkSpUQDT6n+qpxrPYlsqh0pjjDshsURYQy3btYeUUQGyiZJlBYnCV2FXHbCl8bumB3bw==
X-Received: by 2002:a54:4e8d:0:b0:3a0:5723:e649 with SMTP id c13-20020a544e8d000000b003a05723e649mr3607190oiy.9.1688163837850;
        Fri, 30 Jun 2023 15:23:57 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id 21-20020aa79215000000b006687f6727e1sm10349840pfo.206.2023.06.30.15.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 15:23:57 -0700 (PDT)
Date:   Fri, 30 Jun 2023 15:23:55 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Qi Ai <aiqi.i7@bytedance.com>, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, fengzhimin@bytedance.com,
        cenjiahui@bytedance.com, fangying.tommy@bytedance.com,
        dengqiao.joey@bytedance.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
Message-ID: <20230630222355.GI3436214@ls.amr.corp.intel.com>
References: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
 <ZJ6rBwy9p5bbdWrs@chao-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZJ6rBwy9p5bbdWrs@chao-email>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 06:14:31PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Fri, Jun 30, 2023 at 03:26:12PM +0800, Qi Ai wrote:
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> > 	 * Returns vCPU specific APICv inhibit reasons
> > 	 */
> > 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
> >+
> >+	void (*clear_hlt)(struct kvm_vcpu *vcpu);
> 
> add this new ops to arch/x86/include/asm/kvm-x86-ops.h, and declare it
> optional, i.e.,
> 
> KVM_X86_OP_OPTIONAL(...)
> 
> 
> > };
> > 
> > struct kvm_x86_nested_ops {
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 44fb619803b8..11c2fde1ad98 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -8266,6 +8266,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
> > 	.complete_emulated_msr = kvm_complete_insn_gp,
> > 
> > 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> >+
> >+	.clear_hlt = vmx_clear_hlt,
> > };
> > 
> > static unsigned int vmx_handle_intel_pt_intr(void)
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 7f70207e8689..21360f5ed006 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -11258,6 +11258,12 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> > 	vcpu->arch.exception_vmexit.pending = false;
> > 
> > 	kvm_make_request(KVM_REQ_EVENT, vcpu);
> >+
> >+	if (kvm_x86_ops.clear_hlt) {
> >+		if (kvm_vcpu_is_bsp(vcpu) && regs->rip == 0xfff0 &&
> 
> it is weird this applies to BSP only.
> 
> >+				!is_protmode(vcpu))
> >+			kvm_x86_ops.clear_hlt(vcpu);
> 
> Use static_call_cond(kvm_x86_clear_hlt)(vcpu) instead.
> 
> It looks incorrect that we add this side-effect heuristically here. I
> am wondering if we can link vcpu->arch.mp_state to VMCS activity state,
> i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
> sets VMCS activity state to active.

Yes, when vcpu is reset should be checked by mp-state change. Strictly we should
clear other guest non-register state strictly.  interruptibility state, pending
debug exceptions, and guest interrupt status.  In practice, those status other
than hlt wouldn't matter much, though.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
