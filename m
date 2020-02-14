Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C3915D4B0
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBNJ1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 04:27:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgBNJ1R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 04:27:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581672435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9L6+hlfFcwPgS55DrqQw6gYUivMR5YUGI9xhyo/lzU=;
        b=MG+BzmXVHO0m0YJ0DJT85NDuvQ9Cp6ZrX4+nAP/3c8qVG0IqFPrIqHLksJ51lrl39UQ2dA
        TyWo3TArHByn5TA7/OuSlhAzSk6UxpU9+r23m1bEq3GBN8Cm9hbG4kudUoA/ZoYRTirng/
        ihBORyyyHc+ydi20lm0q12AMmBSd0bQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-u3YtcjyxPIWE-lK31sT9QA-1; Fri, 14 Feb 2020 04:27:13 -0500
X-MC-Unique: u3YtcjyxPIWE-lK31sT9QA-1
Received: by mail-wm1-f70.google.com with SMTP id o24so3174108wmh.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 01:27:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W9L6+hlfFcwPgS55DrqQw6gYUivMR5YUGI9xhyo/lzU=;
        b=mvJSrbpNqLu1mQn5q18uxeAP++c+Vcx2rrmJ01JiM91Qm+VVocROObaJw4veF4sL8W
         6aY51a2P23uPngiSRIyRqq0bxpNYl9rwGdSDl0ZyJsMZ5puGMkyufQH0+6outLQkC8Ua
         y6FP6gwsZqCDEIfp7dUy8AC3V6UZfpvQURenDYkKVNaLs0gvAJRMfGTFZKKG1xpSqA6a
         7gpYb4hNehu4BAF1UkFq1/mrzSRRtBe494g60LTvEWWVcENddGDc7an2dbscJSLSuJ4q
         39EWHiA3zbGV0yAEOk2VATu5bRmdmt58oMc8UnLbBKWocG6vzvYByFuAC+zUglaq9lOc
         Hr4w==
X-Gm-Message-State: APjAAAXzlePsbTujuOVDmhhO5wSkpqy1X13oooigVVrdhcDe1bVtDril
        iO7X4gx3ZGCXIAuCSBaRx52jUOtJjoj7mSstG9eApx/KNxDye3Xtyy1whV1O/qTw20EgOGJIu4b
        3YWByia+PF4sy
X-Received: by 2002:adf:cd11:: with SMTP id w17mr3181489wrm.66.1581672432697;
        Fri, 14 Feb 2020 01:27:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyhDe+9WPl/Lr+ImSq5Cn6F33+OBgghSkd5Er/DXRFlffocFuVtQtoh3XDQuBbSH0ZY2PzbZQ==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr3181453wrm.66.1581672432365;
        Fri, 14 Feb 2020 01:27:12 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id c15sm6427554wrt.1.2020.02.14.01.27.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 01:27:11 -0800 (PST)
Subject: Re: [PATCH v2] KVM: X86: Grab KVM's srcu lock when accessing hv
 assist page
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <CANRm+CznPq3LQUyiXr8nA7uP5q+d8Ud-Ki-W7vPCo_BjDJtOSw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7171e537-27f9-c1e5-ae32-9305710be2c7@redhat.com>
Date:   Fri, 14 Feb 2020 10:27:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CznPq3LQUyiXr8nA7uP5q+d8Ud-Ki-W7vPCo_BjDJtOSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 10:16, Wanpeng Li wrote:
> From: wanpeng li <wanpengli@tencent.com>
> 
> For the duration of mapping eVMCS, it derefences ->memslots without holding
> ->srcu or ->slots_lock when accessing hv assist page. This patch fixes it by
> moving nested_sync_vmcs12_to_shadow to prepare_guest_switch, where the SRCU
> is already taken.

Looks good, but I'd like an extra review from Sean or Vitaly.

We also should add a WARN_ON_ONCE that replaces the previous location of
the "if (vmx->nested.need_vmcs12_to_shadow_sync)", but I can do that myself.

Thanks,

Paolo

> It can be reproduced by running kvm's evmcs_test selftest.
> 
>   =============================
>   warning: suspicious rcu usage
>   5.6.0-rc1+ #53 tainted: g        w ioe
>   -----------------------------
>   ./include/linux/kvm_host.h:623 suspicious rcu_dereference_check() usage!
> 
>   other info that might help us debug this:
> 
>    rcu_scheduler_active = 2, debug_locks = 1
>   1 lock held by evmcs_test/8507:
>    #0: ffff9ddd156d00d0 (&vcpu->mutex){+.+.}, at:
> kvm_vcpu_ioctl+0x85/0x680 [kvm]
> 
>   stack backtrace:
>   cpu: 6 pid: 8507 comm: evmcs_test tainted: g        w ioe     5.6.0-rc1+ #53
>   hardware name: dell inc. optiplex 7040/0jctf8, bios 1.4.9 09/12/2016
>   call trace:
>    dump_stack+0x68/0x9b
>    kvm_read_guest_cached+0x11d/0x150 [kvm]
>    kvm_hv_get_assist_page+0x33/0x40 [kvm]
>    nested_enlightened_vmentry+0x2c/0x60 [kvm_intel]
>    nested_vmx_handle_enlightened_vmptrld.part.52+0x32/0x1c0 [kvm_intel]
>    nested_sync_vmcs12_to_shadow+0x439/0x680 [kvm_intel]
>    vmx_vcpu_run+0x67a/0xe60 [kvm_intel]
>    vcpu_enter_guest+0x35e/0x1bc0 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x40b/0x670 [kvm]
>    kvm_vcpu_ioctl+0x370/0x680 [kvm]
>    ksys_ioctl+0x235/0x850
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x77/0x780
>    entry_syscall_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9a66648..6bd6ca4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1214,6 +1214,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> 
>      vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
>      vmx->guest_state_loaded = true;
> +
> +    if (vmx->nested.need_vmcs12_to_shadow_sync)
> +        nested_sync_vmcs12_to_shadow(vcpu);
>  }
> 
>  static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
> @@ -6480,9 +6483,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
>          vmcs_write32(PLE_WINDOW, vmx->ple_window);
>      }
> 
> -    if (vmx->nested.need_vmcs12_to_shadow_sync)
> -        nested_sync_vmcs12_to_shadow(vcpu);
> -
>      if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
>          vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
>      if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
> --
> 2.7.4
> 

