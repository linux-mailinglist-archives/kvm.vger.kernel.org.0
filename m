Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033AC76A0F6
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 21:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjGaTPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 15:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjGaTPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 15:15:21 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13D8170A
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 12:15:17 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1bbd4f526caso37392275ad.3
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 12:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690830917; x=1691435717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3gmPFpUs5FjlRsy4N0IsYHth1ZOl/shHW+UDrt9Tt4=;
        b=0CrXp9Zf/isH3woU2es67GjItfRo8hz4h1QSMZ4ZV8NFFcuHdH0dqOcX1sSvJtcBlq
         voER/MmRHUGYWgfTdY3RU3WOX+DXq6SYTg8o3OE8EbiMaSAd+pYEiqCQQVcecwD6O3GP
         nCihSXSKxLttFMLrJSKqVyc+4d5KSd8XAAeZFHa10CEsBKc+Jil1LIcmHeXgYVzt+4dQ
         zP+HV+iSIBzlbvkseWoqvcmshIpxz0W/KMAV7BLCZkAt/pCwIMgkilew2v+oxn9TfOvr
         udOHcl8B0uyUm+5p5NoiDDln4nLFXMTADbyoPelf0L0y0wXEkvlzjDbRwILz9gLWOj1D
         tBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690830917; x=1691435717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3gmPFpUs5FjlRsy4N0IsYHth1ZOl/shHW+UDrt9Tt4=;
        b=UFMbnKUGKIRuD02dN9OA0hd/g0+SsKMrf80IQafvcGvE4IikCXfUVCQCCyFvk6/9H4
         eJYUG6Gi+XrlTbFfKao5A/JI0qRyddn/2TXsmbuGeSqLTR26/YpNXSxtQekuCr6MLXrl
         Je0nHJx352Ip2hP/GITzljLELVnoPGA4oB+/RwfIW3yctVv9beSoIzCcU5uPWshTzAxZ
         RVba7fnC2xfLzcSjkepGpzQtcxmKqW6ZMSIChVZCcfVD1bd64Zy5OYC4oPk603ksl3pC
         kijiiv78bmT7mgST9vizjenYm4F41XJd/Jc5NBkNGtES5BcaUdoWXwFhm4ZR4BfGBzw/
         bOHg==
X-Gm-Message-State: ABy/qLZqfklihfhXdkf5F/jf1iZetcjK4xXNdCctGzVyY0JHuaoNns+N
        E5BXywCumvxDGy11UeiptJuc1Evcm+Y=
X-Google-Smtp-Source: APBJJlGQOGA8oK9dJlWafTJyMXxwQrCn3/JyMPaOdL1bOK86rcHZ7/cnDul4O8xISfT2Yiwbt8gKV/A3aII=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:1b8:8c7:31e6 with SMTP id
 u1-20020a170902e5c100b001b808c731e6mr48307plf.1.1690830917394; Mon, 31 Jul
 2023 12:15:17 -0700 (PDT)
Date:   Mon, 31 Jul 2023 12:15:15 -0700
In-Reply-To: <ZKUyH+P2XmsdHp+p@chao-email>
Mime-Version: 1.0
References: <20230630072612.1106705-1-aiqi.i7@bytedance.com>
 <ZJ6rBwy9p5bbdWrs@chao-email> <ZJ9djqQZWSEjJlfb@google.com> <ZKUyH+P2XmsdHp+p@chao-email>
Message-ID: <ZMgIQ5m1jMSAogT4@google.com>
Subject: Re: [PATCH] kvm/x86: clear hlt for intel cpu when resetting vcpu
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Qi Ai <aiqi.i7@bytedance.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
        fengzhimin@bytedance.com, cenjiahui@bytedance.com,
        fangying.tommy@bytedance.com, dengqiao.joey@bytedance.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 05, 2023, Chao Gao wrote:
> On Fri, Jun 30, 2023 at 03:56:14PM -0700, Sean Christopherson wrote:
> >mn Fri, Jun 30, 2023, Chao Gao wrote:
> >> am wondering if we can link vcpu->arch.mp_state to VMCS activity state,
> >
> >Hrm, maybe.
> >
> >> i.e., when mp_state is set to RUNNABLE in KVM_SET_MP_STATE ioctl, KVM
> >> sets VMCS activity state to active.
> >
> >Not in the ioctl(), there needs to be a proper set of APIs, e.g. so that the
> >existing hack works,
> 
> I don't get why the existing hack will be broken if we piggyback on the
> KVM_GET/SET_MP_STATE ioctl(). The hack is for "Older userspace" back to
> 2008. I suppose the "Older userspace" doesn't support disabling hlt exit.

True, it does seem extremely unlikely that the two would collide.  And even if
there is some bizarre userspace that relies on the old hack *and* exposes HLT,
fixing this in set_mpstate() wouldn't make the problem worse, i.e. there's no
reason to hold up the fix.

Qi, for v2, can you handle this in kvm_arch_vcpu_ioctl_set_mpstate() instead of
__set_regs()?  And wire up the new hook to support a static_call(), e.g. I think
the call site would be:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a68d7d99fe..92d255fb00c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11411,6 +11411,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
                vcpu->arch.mp_state = mp_state->mp_state;
        kvm_make_request(KVM_REQ_EVENT, vcpu);
 
+       if (kvm_hlt_in_guest(vcpu->kvm) &&
+           mp_state->mp_state != KVM_MP_STATE_HALTED)
+               static_call_cond(kvm_x86_clear_hlt)(vcpu);
+
        ret = 0;
 out:
        vcpu_put(vcpu);

> >and so that KVM actually reports out to userspace that a
> >vCPU is HALTED if userspace gained control of the vCPU, e.g. after an IRQ exit,
> >while the vCPU was HALTED.  I.e. mp_state versus vmcs.ACTIVITY_STATE needs to be
> >bidirectional, not one-way.  E.g. if a vCPU is live migrated, I'm pretty sure
> >vmcs.ACTIVITY_STATE is lost, which is wrong.
> 
> Yes. Agreed.

Fixing this is going to be painful.  Reporting KVM_MP_STATE_HALTED would cause
problems if a VM is migrated from a KVM with the fix to a KVM without the fix,
as the "bad" KVM wouldn't know it should treat the guest as running and actually
put the vCPU into HLT.  We can't use a new KVM_MP_STATE because that would fully
break migration (*sigh*).

That means we probably need to add a flag somewhere, on top of also teaching KVM
to treat the guest as runnable.  So as above, I think it makes sense to get the
immediate bug fixed and worry about migrating HLT state in the future, especially
since KVM *can't* migrate HLT state on SVM.

> >I'm half tempted to solve this particular issue by stuffing vmcs.ACTIVITY_STATE on
> >shutdown, similar to what SVM does on shutdown interception.  KVM doesn't come
> >anywhere near faithfully emulating shutdown, so it's unlikely to break anything.
> >And then the mp_state vs. hlt_in_guest coulbe tackled separately.  Ugh, but that
> >wouldn't cover a synthesized KVM_REQ_TRIPLE_FAULT.
> 
> I traced the process of guest reboot but I didn't see triple-fault
> VMExit. So, I don't think this can fix the issue.

Ah, right.  No idea why I jumped to the conclusion that there would be a triple
fault, the changelog even specifically calls out that the reboot happens after
kdump runs.  Even if there were a triple fault, that wouldn't cover all vCPUs.
