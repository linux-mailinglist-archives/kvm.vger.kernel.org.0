Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F2E449E91
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 23:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbhKHWJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 17:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhKHWJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 17:09:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B7BC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 14:06:48 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id x131so12200851pfc.12
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 14:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bUBDJ2EfUrCCQV5R6IbbAxg+gz+7wwLlrF1tUpsYKDM=;
        b=dgBLRKsd1dMCNu/RrFM/XQsHbBnQ9EMKmFeq5CFJ5HsaVhQY/2GXeRLrMx+Xv2xAzu
         CFbNzDn+pBoXr3/N+F3bmVjaedAviVTueL25KnG+sAG6T70HppaaR0nyYMiiD7+4m6Tj
         fWCuZbHp43+euVmg+CGGC4V+frNq4Sn1ZlN9sXInlxs9UUhSTE/8FYIYOUvaS+ItutQE
         Qw/nURx3cghwa1Z9q9iEY0p4suJXq1FptokmIz2WW/KrUWTwtTlpDDrITUFXT8CJKZok
         lfRGrxYbIGOj8rPiX9TZctJzy3veJqghEbr3zWATtdd4ocMJI6Ba5NE/tRGm79LeBt+k
         3LgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bUBDJ2EfUrCCQV5R6IbbAxg+gz+7wwLlrF1tUpsYKDM=;
        b=7TT1eLEMqcZPpuPfDxpSnEWUnX12xMOYw9JvHXidzOCGT/4U/JA3JpKcB26OedagTO
         uRFjTI+HWXhlj8sZ8gxXHKqtuUFja7D5IY5JrFjnRAdVrYmML2hKES1/Oiex3l1b+kRD
         Ca/1NAoU3RBenJb3L7CaymHizxgHNQVpNN1xKCNHc+K2YwsZxTvPx9lqf47Q3yRLkSsY
         TRNxCyW9S1L8z1+c38UfM1vbqRg+5aYRCUfeYzjT0u4bVneB5tM4aqpxasQOzGXU4lm0
         Q97I63jwwB243wk1AbEtEurSgWOrDYiNIjnlSEVCUvMboe/2v4sOo90G6aUPUrD/e8rY
         SQPw==
X-Gm-Message-State: AOAM532d0Dtx1dob5UG3984h2yNU6iCuw/hrmiBJgnWxLfBMzOtOla98
        2TXBuBrqfhFeuIipzCr+teWtGw==
X-Google-Smtp-Source: ABdhPJwcIb/uo/j5Cwc7ERq37GlT6jr3E59ZOOFCPEphErWVsaJeJ0sPLotGQx2j6AiacS/9MjNLLA==
X-Received: by 2002:a62:ea16:0:b0:47b:f3d7:7a9 with SMTP id t22-20020a62ea16000000b0047bf3d707a9mr2697131pfh.60.1636409207322;
        Mon, 08 Nov 2021 14:06:47 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mp12sm285426pjb.39.2021.11.08.14.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 14:06:46 -0800 (PST)
Date:   Mon, 8 Nov 2021 22:06:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Handle dynamic MSR intercept toggling
Message-ID: <YYmfcptFm/ptCZQ8@google.com>
References: <20210924204907.1111817-1-seanjc@google.com>
 <20210924204907.1111817-2-seanjc@google.com>
 <87k0hioasv.fsf@vitty.brq.redhat.com>
 <YYldZjBA0YOHjUdZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYldZjBA0YOHjUdZ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021, Sean Christopherson wrote:
> On Mon, Nov 08, 2021, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > > @@ -6749,7 +6686,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> > >  	 * save it.
> > >  	 */
> > > -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> > > +	if (unlikely(cpu_has_vmx_msr_bitmap() &&

There's another bug lurking here.  If vmcs12 disables MSR bitmaps, then KVM also
disables MSR bitmaps in vmcs02, ergo checking if MSR bitmaps are supported is
incorrect.  KVM needs to check if MSR bitmaps are enabled for the current VMCS.

> > > +		     vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
> > > +					       MSR_IA32_SPEC_CTRL)))
> 
> Ugh, I inverted the check, '1' == intercept.  IIRC, I open coded the intercept
> check because SPEC_CTRL is really the only case where should be reading _only_
> the current VMCS's MSR bitmap.
> 
> I'll spin a new version of the series and test with SPEC_CTRL disabled in a VM,
> and maybe revist my reasoning for this.
> 
> Thanks!
> 
> > >  		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> > 
> > I smoke-tested this patch by running (unrelated) selftests when I tried
> > to put in into my 'Enlightened MSR Bitmap v4' series and my dmesg got
> > flooded with:
> > 
> > [   87.210214] unchecked MSR access error: RDMSR from 0x48 at rIP: 0xffffffffc04e0284 (native_read_msr+0x4/0x30 [kvm_intel])
> > [   87.210325] Call Trace:
> > [   87.210355]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
> > [   87.210405]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
> > [   87.210466]  vcpu_enter_guest+0x98c/0x1380 [kvm]
> > [   87.210631]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
> > [   87.210678]  ? vmx_vcpu_load+0x21/0x60 [kvm_intel]
> > [   87.210729]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
> > [   87.210844]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
> > [   87.210950]  __x64_sys_ioctl+0x83/0xb0
> > [   87.210996]  do_syscall_64+0x3b/0x90
> > [   87.211039]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [   87.211093] RIP: 0033:0x7f6ef7f9a307
> > [   87.211134] Code: 44 00 00 48 8b 05 69 1b 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 1b 2d 00 f7 d8 64 89 01 48
> > [   87.211293] RSP: 002b:00007ffcacfb3b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [   87.211367] RAX: ffffffffffffffda RBX: 0000000000a2f300 RCX: 00007f6ef7f9a307
> > [   87.211434] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
> > [   87.211500] RBP: 0000000000000000 R08: 000000000040e769 R09: 0000000000000000
> > [   87.211559] R10: 0000000000a2f001 R11: 0000000000000246 R12: 0000000000a2d010
> > [   87.211622] R13: 0000000000a2d010 R14: 0000000000402a15 R15: 00000000ffff0ff0
> > [   87.212520] Call Trace:
> > [   87.212597]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
> > [   87.212683]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
> > [   87.212789]  vcpu_enter_guest+0x98c/0x1380 [kvm]
> > [   87.213059]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
> > [   87.213141]  ? schedule+0x44/0xa0
> > [   87.213200]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
> > [   87.213428]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
> > [   87.213633]  __x64_sys_ioctl+0x83/0xb0
> > [   87.213705]  do_syscall_64+0x3b/0x90
> > [   87.213766]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > ...
> > 
> > this was an old 'E5-2603 v3' CPU. Any idea what's wrong?
