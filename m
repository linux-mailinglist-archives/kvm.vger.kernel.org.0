Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6EF473F03
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhLNJMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:12:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60431 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230031AbhLNJM3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639473149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8Ir7UDFeagP80xYfjMLyxZDxfSouQKPXPiC+rweHxg=;
        b=K+FWVEZQXFQHKEo1MUcHapSc/R8jd+yIDxOjus+G0rwZz0LVTwOlM7LpjJsy7F8jBBkG9I
        7fpMT5GqNLCYutHUV3m+/BwuQLShB3dwGnl3aFmo19ccJCgXvjQJvyQKfxJIcHtDsW66BA
        eI8RGO9fpgEImnu5n5pkJPWgDwbQib4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-f4mM-RQcPgmrkHnnR_8LTg-1; Tue, 14 Dec 2021 04:12:27 -0500
X-MC-Unique: f4mM-RQcPgmrkHnnR_8LTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05DA5101F012;
        Tue, 14 Dec 2021 09:12:19 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D7C727CDF;
        Tue, 14 Dec 2021 09:12:14 +0000 (UTC)
Message-ID: <90fc3a59f722d97f221bdfe6e856b492e6cd2b6f.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: VMX: Always clear vmx->fail on
 emulation_required
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
Date:   Tue, 14 Dec 2021 11:12:13 +0200
In-Reply-To: <20211207193006.120997-2-seanjc@google.com>
References: <20211207193006.120997-1-seanjc@google.com>
         <20211207193006.120997-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 19:30 +0000, Sean Christopherson wrote:
> Revert a relatively recent change that set vmx->fail if the vCPU is in L2
> and emulation_required is true, as that behavior is completely bogus.
> Setting vmx->fail and synthesizing a VM-Exit is contradictory and wrong:
> 
>   (a) it's impossible to have both a VM-Fail and VM-Exit
>   (b) vmcs.EXIT_REASON is not modified on VM-Fail
>   (c) emulation_required refers to guest state and guest state checks are
>       always VM-Exits, not VM-Fails.
> 
> For KVM specifically, emulation_required is handled before nested exits
> in __vmx_handle_exit(), thus setting vmx->fail has no immediate effect,
> i.e. KVM calls into handle_invalid_guest_state() and vmx->fail is ignored.
> Setting vmx->fail can ultimately result in a WARN in nested_vmx_vmexit()
> firing when tearing down the VM as KVM never expects vmx->fail to be set
> when L2 is active, KVM always reflects those errors into L1.
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 0 PID: 21158 at arch/x86/kvm/vmx/nested.c:4548
>                                 nested_vmx_vmexit+0x16bd/0x17e0
>                                 arch/x86/kvm/vmx/nested.c:4547
>   Modules linked in:
>   CPU: 0 PID: 21158 Comm: syz-executor.1 Not tainted 5.16.0-rc3-syzkaller #0
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   RIP: 0010:nested_vmx_vmexit+0x16bd/0x17e0 arch/x86/kvm/vmx/nested.c:4547
>   Code: <0f> 0b e9 2e f8 ff ff e8 57 b3 5d 00 0f 0b e9 00 f1 ff ff 89 e9 80
>   Call Trace:
>    vmx_leave_nested arch/x86/kvm/vmx/nested.c:6220 [inline]
>    nested_vmx_free_vcpu+0x83/0xc0 arch/x86/kvm/vmx/nested.c:330
>    vmx_free_vcpu+0x11f/0x2a0 arch/x86/kvm/vmx/vmx.c:6799
>    kvm_arch_vcpu_destroy+0x6b/0x240 arch/x86/kvm/x86.c:10989
>    kvm_vcpu_destroy+0x29/0x90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:441
>    kvm_free_vcpus arch/x86/kvm/x86.c:11426 [inline]
>    kvm_arch_destroy_vm+0x3ef/0x6b0 arch/x86/kvm/x86.c:11545
>    kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1189 [inline]
>    kvm_put_kvm+0x751/0xe40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1220
>    kvm_vcpu_release+0x53/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3489
>    __fput+0x3fc/0x870 fs/file_table.c:280
>    task_work_run+0x146/0x1c0 kernel/task_work.c:164
>    exit_task_work include/linux/task_work.h:32 [inline]
>    do_exit+0x705/0x24f0 kernel/exit.c:832
>    do_group_exit+0x168/0x2d0 kernel/exit.c:929
>    get_signal+0x1740/0x2120 kernel/signal.c:2852
>    arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
>    handle_signal_work kernel/entry/common.c:148 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>    exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>    syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
>    do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fixes: c8607e4a086f ("KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry")
> Reported-by: syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index efcc5a58abbc..9e415e5a91ab 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6631,9 +6631,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	 * consistency check VM-Exit due to invalid guest state and bail.
>  	 */
>  	if (unlikely(vmx->emulation_required)) {
> -
> -		/* We don't emulate invalid state of a nested guest */
> -		vmx->fail = is_guest_mode(vcpu);
> +		vmx->fail = 0;
>  
>  		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
>  		vmx->exit_reason.failed_vmentry = 1;

Now after swapping in all of the gory details, this does make sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

