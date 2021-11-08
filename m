Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E075449AB9
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 18:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhKHR1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 12:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhKHR1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 12:27:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B01C061714
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 09:24:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so9336660pjc.4
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 09:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4EbD7aqTQKxclsPLCjVFRazOOf7SVm4FlHdT4M8Q2OE=;
        b=UJm8tlekg3RcDJN6+qUt+cpMTkF4V/Hj+tnGbZFokcB4SAQcj3P6+RI/2cLOYGqTC5
         bCzuHg8QbDSjgI2zeVkvP9HVJWKs17hjbDs9+kt0rALTnmBPHce6tq8pHh7CDN2piT9n
         9OwAqtKhOEBQvAw8eMCmPOqKEU9O2fvB7caD2N3d38GnhYlW+XChRzNd4HPEClxkA/QP
         nk8aRKuAysvXR6jYDvC11oc2qJr3ATPSy/IO3dfxS0tPhk2CCWjL7HbpwRoVsycH2a+Z
         9DOSeKbufz52wK6GOc5E7tNdBvICz0zV+AsyvDO045LarEbbiHRc/0guA0a45WahOxso
         Eheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4EbD7aqTQKxclsPLCjVFRazOOf7SVm4FlHdT4M8Q2OE=;
        b=XorOYb1FlhL12nwVwGhMCzOTCYLOdAdycppp1D++OMnB7ClVvI/ZOrfB8fVhg41OBU
         4eSoD5qm6YUYH+V5a7/h8vCxTa5Yx9eRXvubtDBufh8XH7IYVRvR0i5il+pB/VNkvQjD
         I7QBHv0E4hm6kKn38ChNAtLsv0lXM2P/KWJuFd3JSrnOo3lCQwRrwGP/mtP9ST1hUdE6
         9va7Jh+eIuldgS59LNWVU8fjgOES1zizxRguA8E0w37yOTfYZvUqubPkp2bHTmDzeoDd
         2gZzxlvKfSc9HUAx1Nvad8e18WQ/UGarjn/4J8AFQd9ObsyEjHW6tGYnIQecDHQwQF6e
         EaVA==
X-Gm-Message-State: AOAM530c9nP3CfSA1suyFTGryOMl5g4da5k54dbobEeSaqG4MmdXZhnG
        SCmXoKvIZ3yO92pYPZd8icN6nagdDENXSw==
X-Google-Smtp-Source: ABdhPJzzJsPhO6l9Wzpus0ydSjqjfOxWycpAvNYAImmWhmgSVDVbcAmYrgi+e+A2wwKWC+cYPJFipg==
X-Received: by 2002:a17:902:e547:b0:141:ddbc:a8d6 with SMTP id n7-20020a170902e54700b00141ddbca8d6mr812890plf.27.1636392298669;
        Mon, 08 Nov 2021 09:24:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v22sm16321575pff.93.2021.11.08.09.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:24:58 -0800 (PST)
Date:   Mon, 8 Nov 2021 17:24:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Handle dynamic MSR intercept toggling
Message-ID: <YYldZjBA0YOHjUdZ@google.com>
References: <20210924204907.1111817-1-seanjc@google.com>
 <20210924204907.1111817-2-seanjc@google.com>
 <87k0hioasv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0hioasv.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 08, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -6749,7 +6686,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
> >  	 * save it.
> >  	 */
> > -	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
> > +	if (unlikely(cpu_has_vmx_msr_bitmap() &&
> > +		     vmx_test_msr_bitmap_write(vmx->loaded_vmcs->msr_bitmap,
> > +					       MSR_IA32_SPEC_CTRL)))

Ugh, I inverted the check, '1' == intercept.  IIRC, I open coded the intercept
check because SPEC_CTRL is really the only case where should be reading _only_
the current VMCS's MSR bitmap.

I'll spin a new version of the series and test with SPEC_CTRL disabled in a VM,
and maybe revist my reasoning for this.

Thanks!

> >  		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
> 
> I smoke-tested this patch by running (unrelated) selftests when I tried
> to put in into my 'Enlightened MSR Bitmap v4' series and my dmesg got
> flooded with:
> 
> [   87.210214] unchecked MSR access error: RDMSR from 0x48 at rIP: 0xffffffffc04e0284 (native_read_msr+0x4/0x30 [kvm_intel])
> [   87.210325] Call Trace:
> [   87.210355]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
> [   87.210405]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
> [   87.210466]  vcpu_enter_guest+0x98c/0x1380 [kvm]
> [   87.210631]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
> [   87.210678]  ? vmx_vcpu_load+0x21/0x60 [kvm_intel]
> [   87.210729]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
> [   87.210844]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
> [   87.210950]  __x64_sys_ioctl+0x83/0xb0
> [   87.210996]  do_syscall_64+0x3b/0x90
> [   87.211039]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   87.211093] RIP: 0033:0x7f6ef7f9a307
> [   87.211134] Code: 44 00 00 48 8b 05 69 1b 2d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 1b 2d 00 f7 d8 64 89 01 48
> [   87.211293] RSP: 002b:00007ffcacfb3b18 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   87.211367] RAX: ffffffffffffffda RBX: 0000000000a2f300 RCX: 00007f6ef7f9a307
> [   87.211434] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000007
> [   87.211500] RBP: 0000000000000000 R08: 000000000040e769 R09: 0000000000000000
> [   87.211559] R10: 0000000000a2f001 R11: 0000000000000246 R12: 0000000000a2d010
> [   87.211622] R13: 0000000000a2d010 R14: 0000000000402a15 R15: 00000000ffff0ff0
> [   87.212520] Call Trace:
> [   87.212597]  vmx_vcpu_run+0xcc7/0x12b0 [kvm_intel]
> [   87.212683]  ? vmx_prepare_switch_to_guest+0x138/0x1f0 [kvm_intel]
> [   87.212789]  vcpu_enter_guest+0x98c/0x1380 [kvm]
> [   87.213059]  ? vmx_vcpu_put+0x2e/0x1f0 [kvm_intel]
> [   87.213141]  ? schedule+0x44/0xa0
> [   87.213200]  kvm_arch_vcpu_ioctl_run+0xdf/0x580 [kvm]
> [   87.213428]  kvm_vcpu_ioctl+0x274/0x660 [kvm]
> [   87.213633]  __x64_sys_ioctl+0x83/0xb0
> [   87.213705]  do_syscall_64+0x3b/0x90
> [   87.213766]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> ...
> 
> this was an old 'E5-2603 v3' CPU. Any idea what's wrong?
