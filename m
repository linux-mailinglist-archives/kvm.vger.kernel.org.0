Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772C855D9F1
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbiF0UIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbiF0UIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:08:45 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5BC1EC46
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:08:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso13580964pjn.2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/Sf3c5Zk0LFNX9GSYtzXFH4nUnAQ1B2LDNTeB/IEWs8=;
        b=MViUg/5WF6/ng1xNhELGel+Iv1N7WkOJluHad3IVz1ln3kKTCj9KVbhbeSCasEFn6z
         CBis1oC/2V89zTuW4mPdpkb3n2uLJlB07ANnJaB7tgYJ5Zfy5/DhQP+hMc52/zGkb0u3
         9opxvZXRPhOzWuG7SafP9chxBb5fNLlY4iO2IFdL4VQpgz8X7+fzHujpmxsFF1PBO1z9
         4GbWHKYQKfPhHU3xdDWaloM1/yH6ddFYFSIdkGuyJmmCPZyVt5SG4ZwAeMne8aBoskkM
         2aclPZErhwqwr/UJYAK5KI+3nmGqy0J179WHus4qC43U4v8Aw331VWshYGuPJiYy9dfH
         3RUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/Sf3c5Zk0LFNX9GSYtzXFH4nUnAQ1B2LDNTeB/IEWs8=;
        b=lMosrhxsGgvS8j20feFRCB6jI8abRiPV6TPfon0TPC+yCgVduKAtSiUkWgASWOr40S
         i7V8/22xH6bTmEwUMoARARXDb9/8wABrzcOgnRHRmqG2wYNoJuLCkZXzivwbtwNVx+T4
         Kevyl7jMBOZWKLoS113+iTEBAr7bqyXHbaE9Be+68DavAQF8iXKk7+KSd/LEREs35+QR
         eSWCMrHOwWAS873H2yMcRPWEY3wlAwKgr7oA9XQVwA+f+HiVm25ci8Xmrcr+g4UFUHr/
         cYEN4YfOQHoKZyZXf0FcytMQCXGEPe+zukOVC51S9QzxYXCexV7+lsz/JG+nSfS929fC
         uFPw==
X-Gm-Message-State: AJIora8W3N9JLlEbWA9BLEkPpXQ3kYexitNr+8mLX7RrxMkC7H0gJ+CJ
        C7Db2v6dPEH3W0h15t/Nzj0mww==
X-Google-Smtp-Source: AGRyM1tjJzE0TQq8y6dpkOgpqHXOPShmqQ9baFCL3CNH/pxJDz2bHAICTW5aojOapdyvKfEhISZ9JQ==
X-Received: by 2002:a17:902:f689:b0:16a:4021:8848 with SMTP id l9-20020a170902f68900b0016a40218848mr16113284plg.23.1656360523305;
        Mon, 27 Jun 2022 13:08:43 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id h28-20020a63121c000000b004088f213f68sm7527620pgl.56.2022.06.27.13.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:08:42 -0700 (PDT)
Date:   Mon, 27 Jun 2022 20:08:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        syzkaller-bugs@googlegroups.com, "H. Peter Anvin" <hpa@zytor.com>,
        kvm <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Wanpeng Li <kernellwp@gmail.com>
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run (3)
Message-ID: <YroOR4Qky66yqO7P@google.com>
References: <000000000000d05a78056873bc47@google.com>
 <CANRm+Cz9GEhgc_Na3E8DqYBccPTimybeu+idP1hDJSk4jni7ag@mail.gmail.com>
 <e3a1a213-ea9f-dbd8-93be-74e927794090@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3a1a213-ea9f-dbd8-93be-74e927794090@I-love.SAKURA.ne.jp>
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

On Wed, Jun 22, 2022, Tetsuo Handa wrote:
> On 2018/03/28 16:29, Wanpeng Li wrote:
> >> syzbot dashboard link:
> >> https://syzkaller.appspot.com/bug?extid=760a73552f47a8cd0fd9
> >>
> > Maybe the same as this one. https://lkml.org/lkml/2018/3/21/174 Paolo,
> > any idea against my analysis?
> 
> No progress for 4 years. Did somebody check Wanpeng's analysis ?

The most recent failure is a different bug, the splat Wanpeng debugged requires
unrestricted guest to be disabled, whereas this does not.  Somewhat of a side
topic, if the old bug still exists (the syzkaller reproducer fails with invalid
guest state, so it's not clear whether or not the bug is still a problem),
I suspect this hack-a-fix would handle the Real Mode injection case:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 735543df829a..58801d3888c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8209,7 +8209,7 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
        ctxt->_eip = ctxt->eip + inc_eip;
        ret = emulate_int_real(ctxt, irq);

-       if (ret != X86EMUL_CONTINUE) {
+       if (ret != X86EMUL_CONTINUE || vcpu->mmio_needed) {
                kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
        } else {
                ctxt->eip = ctxt->_eip;

If I ever have time and/or get bored, I'll try to repro the realmode bug unless
someone beats me to it.

> Since I'm not familiar with KVM, my questions from different direction...
> 
> 
> 
> syzbot is hitting WARN_ON(vcpu->arch.pio.count || vcpu->mmio_needed) added by
> commit 716d51abff06f484 ("KVM: Provide userspace IO exit completion callback")
> due to vcpu->mmio_needed == true.
> 
> Question 1: what is the intent of checking for vcpu->mmio_needed == false?

It's a sanity check to detect KVM bugs.  If vcpu->mmio_needed is true, KVM needs
to exit to userspace to complete the MMIO operation.  On that exit to userspace,
KVM is supposed to also set a callback to essentially acknowledge that the MMIO
completed.

The issue in this bug is that after setting vcpu->mmio_needed, KVM detects and
injects an exception.  Because of how KVM handles MMIO, unlike MMIO reads, MMIO
writes don't immediately stop emulation.  While odd, it should work because MMIO
writes shouldn't be processed until after all fault checks have passed.  The
underlying bug is that LTR emulation has incorrect ordering and checks for a
non-canonical base _after_ marking the TSS as busy (which triggers MMIO).

So as much as I want to suppress this type of warn by clearing vcpu->mmio_needed
when injecting an exception, I suspect playing whack-a-mole is the right approach
because all those moles are likely bugs :-(  Though one thing we can do is change
the WARN_ON() to a WARN_ON_ONCE() so that kernels outside of panic_on_warn=1 won't
blow up on a buggy/malicious userspace.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 39ea9138224c..09e4b67b881f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1699,16 +1699,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
        case VCPU_SREG_TR:
                if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
                        goto exception;
-               if (!seg_desc.p) {
-                       err_vec = NP_VECTOR;
-                       goto exception;
-               }
-               old_desc = seg_desc;
-               seg_desc.type |= 2; /* busy */
-               ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
-                                                 sizeof(seg_desc), &ctxt->exception);
-               if (ret != X86EMUL_CONTINUE)
-                       return ret;
                break;
        case VCPU_SREG_LDTR:
                if (seg_desc.s || seg_desc.type != 2)
@@ -1749,6 +1739,15 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
                                ((u64)base3 << 32), ctxt))
                        return emulate_gp(ctxt, 0);
        }
+
+       if (seg == VCPU_SREG_TR) {
+               old_desc = seg_desc;
+               seg_desc.type |= 2; /* busy */
+               ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
+                                                 sizeof(seg_desc), &ctxt->exception);
+               if (ret != X86EMUL_CONTINUE)
+                       return ret;
+       }
 load:
        ctxt->ops->set_segment(ctxt, selector, &seg_desc, base3, seg);
        if (desc)


> If we run a reproducer provided by syzbot, we can observe that mutex_unlock(&vcpu->mutex)
> in kvm_vcpu_ioctl() is called with vcpu->mmio_needed == true.
> 
> Question 2: Is kvm_vcpu_ioctl() supposed to leave with vcpu->mmio_needed == false?
> In other words, is doing
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4104,6 +4104,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		r = kvm_arch_vcpu_ioctl(filp, ioctl, arg);
>  	}
>  out:
> +	WARN_ON_ONCE(vcpu->mmio_needed);
>  	mutex_unlock(&vcpu->mutex);
>  	kfree(fpu);
>  	kfree(kvm_sregs);
> 
> appropriate?

It's not appropriate, mmio_needed is actually supposed to be accompanied by a
exit from kvm_vcpu_ioctl() to userspace.
