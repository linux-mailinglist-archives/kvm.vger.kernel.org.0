Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C31E4E75A5
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354125AbiCYPEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237981AbiCYPEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:04:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69E536455
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648220593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p+rP9gOSBTxLRSnxe4t4T/FVsOhdBct7MjxHdJUH/ew=;
        b=YgbVu++o7tl8kx6yVrS0SZmK/iMLoruFNZrrSU26TfP1vp7WsG72c7Gl2Zm6GAGt5rDVc7
        HHcA4h4hrv9YhTmOMIs8Z9/f+2YXTEfyW1djs71qzPBJlXusURydHmm2Lg+5pGHFemYxhy
        wAFekw65JicZRXzDW8Y2DujanGVrqu4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-xz_b1B16PC-KY-7n19yfNw-1; Fri, 25 Mar 2022 11:03:12 -0400
X-MC-Unique: xz_b1B16PC-KY-7n19yfNw-1
Received: by mail-wm1-f72.google.com with SMTP id o10-20020a1c4d0a000000b0038c6e5fcbaeso2796468wmh.9
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p+rP9gOSBTxLRSnxe4t4T/FVsOhdBct7MjxHdJUH/ew=;
        b=n2zrvPScVZR820DmTuq9ugyHjMGIo7isqu4hjhNxyYi3TkUKH2BoPWPufo/ClCW3LO
         zVk65/RMjt286r9ptki+V/bZmgdXTc0Nq8pVJec5GzS7jpVzBItwzRKROWHlmKbknLkP
         LWzlnTUQXZAChPu7wte+Fx1Qnx1jDHQRM7D15DOAt6sK6EFTvAy1ogAFlwgwTecGCiuG
         Xnj1TJoAHho4IbS3+DC/bUfz+HJMVdgKOPMN58EjOZtLXaGMhFMVOo1TuvyKJqYkZwVR
         LSGwSL7nxS27BYTMnZXaz2J4CdRJtIlHLvorbxIJt0eoQEwOUFXwOZ7r1dRg7zNQt4vH
         u71g==
X-Gm-Message-State: AOAM5301hVwpaovT1zgY5fXWPQdmhNHrb+zqHCBQQb0hrmtO/H6WoJOl
        y2xj0luDE4eCptiL7wCTdtZEs/PIV5v6CgF3C2QXpYAPTGSyf+vRlY8nfhQ9EY09Ic811RHsWOv
        YFf//A6B98Ip0
X-Received: by 2002:a5d:64af:0:b0:205:8246:8316 with SMTP id m15-20020a5d64af000000b0020582468316mr9822852wrp.624.1648220589503;
        Fri, 25 Mar 2022 08:03:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqOZTSSevUNj57oorGfuqPziU84TMmmNL5hG6gbqHrYulEEbIgY/ihiHd+9r7R8oqM5cjtBg==
X-Received: by 2002:a5d:64af:0:b0:205:8246:8316 with SMTP id m15-20020a5d64af000000b0020582468316mr9822682wrp.624.1648220587795;
        Fri, 25 Mar 2022 08:03:07 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm5193603wrz.2.2022.03.25.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 08:03:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
In-Reply-To: <Yj0FYSC2sT4k/ELl@google.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
 <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
 <Yj0FYSC2sT4k/ELl@google.com>
Date:   Fri, 25 Mar 2022 16:03:06 +0100
Message-ID: <87r16qnkgl.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

...

So I went back to "KVM: x86/mmu: Zap only TDP MMU leafs in
kvm_zap_gfn_range()" and confirmed that with the patch in place Hyper-V
always crashes, sooner or later. With the patch reverted (as well as
with current 'kvm/queue') it boots.

>
> Actually, since this is apparently specific to kvm_zap_gfn_range(), can you add
> printk "tracing" in update_mtrr(), kvm_post_set_cr0(), and __kvm_request_apicv_update()
> to see what is actually triggering zaps?  Capturing the start and end GFNs would be very
> helpful for the MTRR case.
>
> The APICv update seems unlikely to affect only Hyper-V guests, though there is the auto
> EOI crud.  And the other two only come into play with non-coherent DMA.  In other words,
> figuring out exactly what sequence leads to failure should be straightforward.

The tricky part here is that Hyper-V doesn't crash immediately, the
crash is always different (if you look at the BSOD) and happens at
different times. Crashes mention various stuff like trying to execute
non-executable memory, ...

I've added tracing you've suggested:
- __kvm_request_apicv_update() happens only once in the very beginning.

- update_mtrr() never actually reaches kvm_zap_gfn_range()

- kvm_post_set_cr0() happen in early boot but the crash happen much much
  later. E.g.:
...
 qemu-system-x86-117525  [019] .....  4738.682954: kvm_post_set_cr0: vCPU 12 10 11
 qemu-system-x86-117525  [019] .....  4738.682997: kvm_post_set_cr0: vCPU 12 11 80000011
 qemu-system-x86-117525  [019] .....  4738.683053: kvm_post_set_cr0: vCPU 12 80000011 c0000011
 qemu-system-x86-117525  [019] .....  4738.683059: kvm_post_set_cr0: vCPU 12 c0000011 80010031
 qemu-system-x86-117526  [005] .....  4738.812107: kvm_post_set_cr0: vCPU 13 10 11
 qemu-system-x86-117526  [005] .....  4738.812148: kvm_post_set_cr0: vCPU 13 11 80000011
 qemu-system-x86-117526  [005] .....  4738.812198: kvm_post_set_cr0: vCPU 13 80000011 c0000011
 qemu-system-x86-117526  [005] .....  4738.812205: kvm_post_set_cr0: vCPU 13 c0000011 80010031
 qemu-system-x86-117527  [003] .....  4738.941004: kvm_post_set_cr0: vCPU 14 10 11
 qemu-system-x86-117527  [003] .....  4738.941107: kvm_post_set_cr0: vCPU 14 11 80000011
 qemu-system-x86-117527  [003] .....  4738.941218: kvm_post_set_cr0: vCPU 14 80000011 c0000011
 qemu-system-x86-117527  [003] .....  4738.941235: kvm_post_set_cr0: vCPU 14 c0000011 80010031
 qemu-system-x86-117528  [035] .....  4739.070338: kvm_post_set_cr0: vCPU 15 10 11
 qemu-system-x86-117528  [035] .....  4739.070428: kvm_post_set_cr0: vCPU 15 11 80000011
 qemu-system-x86-117528  [035] .....  4739.070539: kvm_post_set_cr0: vCPU 15 80000011 c0000011
 qemu-system-x86-117528  [035] .....  4739.070557: kvm_post_set_cr0: vCPU 15 c0000011 80010031
##### CPU 8 buffer started ####
 qemu-system-x86-117528  [008] .....  4760.099532: kvm_hv_set_msr_pw: 15

The debug patch for kvm_post_set_cr0() is:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa4d8269e5b..db7c5a05e574 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -870,6 +870,8 @@ EXPORT_SYMBOL_GPL(load_pdptrs);
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0)
 {
+       trace_printk("vCPU %d %lx %lx\n", vcpu->vcpu_id, old_cr0, cr0);
+
        if ((cr0 ^ old_cr0) & X86_CR0_PG) {
                kvm_clear_async_pf_completion_queue(vcpu);
                kvm_async_pf_hash_reset(vcpu);

kvm_hv_set_msr_pw() call is when Hyper-V writes to HV_X64_MSR_CRASH_CTL
('hv-crash' QEMU flag is needed to enable the feature). The debug patch
is:

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a32f54ab84a2..59a72f6ced99 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1391,6 +1391,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
 
                        /* Send notification about crash to user space */
                        kvm_make_request(KVM_REQ_HV_CRASH, vcpu);
+                       trace_printk("%d\n", vcpu->vcpu_id);
                }
                break;
        case HV_X64_MSR_RESET:

So it's 20 seconds (!) between the last kvm_post_set_cr0() call and the
crash. My (disappointing) conclusion is: the problem can be anywhere and
Hyper-V detects it much much later.

-- 
Vitaly

