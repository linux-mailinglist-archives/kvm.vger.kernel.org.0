Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3507D36487B
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbhDSQq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhDSQq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:46:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A21C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:46:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m12so3934063pgr.9
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xSlyB4P0G/WrfcLUFinVhQXsCE+nJszuAgypZLVBnVU=;
        b=iDkAqoiZ6bul6KXKes6zI3JouVgKSRp2H64T+PDK3rpI3QDuN6Lv1Rfo77HVBk1Psh
         v7jY8LElACmCJRdyH7HQ8o0dnesoDKKb/wiClqqpKtvRJKmoa5QUoBQOsXrW9zf70r9L
         RYtQENW+5scgjnQ0e8JwJePToM1vqhVCOc3ZqC4K9JtnlPhZEG6pgImOg77WBorTlbML
         EBsD9sweq+RZp+qHKTpaqrXtoDGN4NuzkuTq98qpjlTCWSHd30yH114LduZceWSdHvrN
         F8w1UEFMjHexMVuKd4ZVxv0lPLz4aeOPSW2l4hWn7CKmrLlypwDwOFWMtnujdYl7e+MX
         EfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xSlyB4P0G/WrfcLUFinVhQXsCE+nJszuAgypZLVBnVU=;
        b=KFZy7Rpp6/ssnPpKJCoMZxsgOnyzoz6a4dwguVPD7l+LBBb8QbK4XFwKmfZTLYmcya
         JZXH/SFqjxpF3lkxl6QkOFFaRUrG1KSy/ZBkPoImIMvUabjj+cnTtI4iII8mWZQoxvKJ
         mKzIUJMHyMZsgyZEzwfZnkIdwuGdqytNofsR+geOVjd9EGANrL7ffhXwAk1/EuaQzPmr
         SMrr6MimI+9/0qMp6/1Gr7gUds8OP6mfpJ3Gxv1gUy3YvA4fxQpIZDISX2mOTeV6CSoR
         ApfL8rXwRss++Tkv1X15x3oPeCeWiopvvAvchlReIQCqwU9GLIqVCGEU0Xe9wyQl0NbJ
         k9TA==
X-Gm-Message-State: AOAM532YWC3NKT3XJd4bMkrqELk68GAOnvtrUe/e7nUSQOdtuNyPrgSu
        lrs+p4aKfvBirQgYXDiiBUkaU53tPoOPnA==
X-Google-Smtp-Source: ABdhPJyIjXgV+MKm6CuefcRdh+X6pOaE7m13nHjQ9xP5+mcXVn538rwvOnOoJ0qcyodvPYuTsp191Q==
X-Received: by 2002:a62:2f43:0:b029:253:b67f:2eb2 with SMTP id v64-20020a622f430000b0290253b67f2eb2mr20892047pfv.75.1618850786972;
        Mon, 19 Apr 2021 09:46:26 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t19sm13498952pfg.38.2021.04.19.09.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:46:26 -0700 (PDT)
Date:   Mon, 19 Apr 2021 16:46:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     kvm@vger.kernel.org
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
Message-ID: <YH2z3uuQYwSyGJfL@google.com>
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 17, 2021, Arnabjyoti Kalita wrote:
> Hello all,
> 
> I'm having a requirement to record values obtained by reading tsc clock.
> 
> The command line I use to start QEMU in KVM mode is as below -
> 
> sudo ./qemu-system-x86_64 -m 1024 --machine pc-i440fx-2.5 -cpu
> qemu64,-vme,-x2apic,-kvmclock,+lahf_lm,+3dnowprefetch,+vmx -enable-kvm
> -netdev tap,id=tap1,ifname=tap0,script=no,downscript=no -device
> virtio-net-pci,netdev=tap1,mac=00:00:00:00:00:00 -drive
> file=~/os_images_for_qemu/ubuntu-16.04.server.qcow2,format=qcow2,if=none,id=img-direct
> -device virtio-blk-pci,drive=img-direct
> 
> I am using QEMU version 2.11.92 and the guest kernel is a
> 4.4.0-116-generic. I use the CPU model "qemu64" because I have a
> requirement to create a snapshot of this guest and load the snapshot
> in TCG mode. The generic CPU model helps, in this regard.
> 
> Now when the guest is running, I want to intercept all rdtsc
> instructions and record the tsc clock values. I know that for this to
> happen, the CPU_BASED_RDTSC_EXITING flag needs to exist for the
> particular CPU model.
> 
> How do I start adding support for causing VMEXIT upon rdtsc execution?

This requires a KVM change.  The below should do the trick.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2854b5..f000728e4319 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2453,7 +2453,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
              CPU_BASED_MWAIT_EXITING |
              CPU_BASED_MONITOR_EXITING |
              CPU_BASED_INVLPG_EXITING |
-             CPU_BASED_RDPMC_EXITING;
+             CPU_BASED_RDPMC_EXITING |
+             CPU_BASED_RDTSC_EXITING;

        opt = CPU_BASED_TPR_SHADOW |
              CPU_BASED_USE_MSR_BITMAPS |
@@ -5194,6 +5195,15 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
        return kvm_skip_emulated_instruction(vcpu);
 }

+static int handle_rdtsc(struct kvm_vcpu *vcpu)
+{
+       u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());
+
+       kvm_rax_write(vcpu, tsc & -1u);
+       kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
+       return kvm_skip_emulated_instruction(vcpu);
+}
+
 static int handle_apic_access(struct kvm_vcpu *vcpu)
 {
        if (likely(fasteoi)) {
@@ -5605,6 +5615,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
        [EXIT_REASON_INVD]                    = kvm_emulate_invd,
        [EXIT_REASON_INVLPG]                  = handle_invlpg,
        [EXIT_REASON_RDPMC]                   = kvm_emulate_rdpmc,
+       [EXIT_REASON_RDTSC]                   = handle_rdtsc,
        [EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
        [EXIT_REASON_VMCLEAR]                 = handle_vmx_instruction,
        [EXIT_REASON_VMLAUNCH]                = handle_vmx_instruction,
 
> I see that a fairly recent commit in QEMU helps adding nested VMX
> controls to named CPU models, but not "qemu64". Can I extend this
> commit to add these controls to "qemu64" as well? Will making this
> change immediately add support for intercepting VMEXITS for "qemu64"
> CPU?

Are you actually running a nested guest?
