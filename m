Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522D450558D
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241488AbiDRNMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243951AbiDRNKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEA433917E
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HRGj6ZeyXr2MKkcn+2M4NipClwwwr9qizAjtQu5feTE=;
        b=Ggl63WPdGlig/5+++NFxr/deC+qE7lIoSesqWws+wStzQDRzZlVuUWgvmRHOMUVD4UsjTL
        VnATaxesFpasMV/nTADTzurSZtWu0f3eilU23CZYzOrEj9x6I2B0F1FkHHSGagpXM6qizM
        JwHITeVT4K51rovEKGtybGdRdG3GEN8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-0yj2YEJiMemgVMRe122n-Q-1; Mon, 18 Apr 2022 08:49:52 -0400
X-MC-Unique: 0yj2YEJiMemgVMRe122n-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A2C3299E750;
        Mon, 18 Apr 2022 12:49:51 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F305540F9D60;
        Mon, 18 Apr 2022 12:49:48 +0000 (UTC)
Message-ID: <e28c547ac0c3e69d3c55664069aecbb87aeb2230.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU
 creation to fix a race
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Date:   Mon, 18 Apr 2022 15:49:47 +0300
In-Reply-To: <20220416034249.2609491-4-seanjc@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
         <20220416034249.2609491-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> Make a KVM_REQ_APICV_UPDATE request when creating a vCPU with an
> in-kernel local APIC and APICv enabled at the module level.  Consuming
> kvm_apicv_activated() and stuffing vcpu->arch.apicv_active directly can
> race with __kvm_set_or_clear_apicv_inhibit(), as vCPU creation happens
> before the vCPU is fully onlined, i.e. it won't get the request made to
> "all" vCPUs.  If APICv is globally inhibited between setting apicv_active
> and onlining the vCPU, the vCPU will end up running with APICv enabled
> and trigger KVM's sanity check.
> 
> Mark APICv as active during vCPU creation if APICv is enabled at the
> module level, both to be optimistic about it's final state, e.g. to avoid
> additional VMWRITEs on VMX, and because there are likely bugs lurking
> since KVM checks apicv_active in multiple vCPU creation paths.  While
> keeping the current behavior of consuming kvm_apicv_activated() is
> arguably safer from a regression perspective, force apicv_active so that
> vCPU creation runs with deterministic state and so that if there are bugs,
> they are found sooner than later, i.e. not when some crazy race condition
> is hit.
> 
>   WARNING: CPU: 0 PID: 484 at arch/x86/kvm/x86.c:9877 vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877

I told you that this warning catches bugs. I am not disappointed!

>   Modules linked in:
>   CPU: 0 PID: 484 Comm: syz-executor361 Not tainted 5.16.13 #2
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1~cloud0 04/01/2014
>   RIP: 0010:vcpu_enter_guest+0x2ae3/0x3ee0 arch/x86/kvm/x86.c:9877
>   Call Trace:
>    <TASK>
>    vcpu_run arch/x86/kvm/x86.c:10039 [inline]
>    kvm_arch_vcpu_ioctl_run+0x337/0x15e0 arch/x86/kvm/x86.c:10234
>    kvm_vcpu_ioctl+0x4d2/0xc80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3727
>    vfs_ioctl fs/ioctl.c:51 [inline]
>    __do_sys_ioctl fs/ioctl.c:874 [inline]
>    __se_sys_ioctl fs/ioctl.c:860 [inline]
>    __x64_sys_ioctl+0x16d/0x1d0 fs/ioctl.c:860
>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>    do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The bug was hit by a syzkaller spamming VM creation with 2 vCPUs and a
> call to KVM_SET_GUEST_DEBUG.
> 
>   r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000000000), 0x0, 0x0)
>   r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
>   ioctl$KVM_CAP_SPLIT_IRQCHIP(r1, 0x4068aea3, &(0x7f0000000000)) (async)
>   r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) (async)
>   r3 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x400000000000002)
>   ioctl$KVM_SET_GUEST_DEBUG(r3, 0x4048ae9b, &(0x7f00000000c0)={0x5dda9c14aa95f5c5})
>   ioctl$KVM_RUN(r2, 0xae80, 0x0)
> 
> Reported-by: Gaoning Pan <pgn@zju.edu.cn>
> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
> Fixes: 8df14af42f00 ("kvm: x86: Add support for dynamic APICv activation")
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 753296902535..09a270cc1c8f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11259,8 +11259,21 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
>  		if (r < 0)
>  			goto fail_mmu_destroy;
> -		if (kvm_apicv_activated(vcpu->kvm))
> +
> +		/*
> +		 * Defer evaluating inhibits until the vCPU is first run, as
> +		 * this vCPU will not get notified of any changes until this
> +		 * vCPU is visible to other vCPUs (marked online and added to
> +		 * the set of vCPUs).  Opportunistically mark APICv active as
> +		 * VMX in particularly is highly unlikely to have inhibits.
> +		 * Ignore the current per-VM APICv state so that vCPU creation
> +		 * is guaranteed to run with a deterministic value, the request
> +		 * will ensure the vCPU gets the correct state before VM-Entry.
> +		 */
> +		if (enable_apicv) {
>  			vcpu->arch.apicv_active = true;
> +			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> +		}
>  	} else
>  		static_branch_inc(&kvm_has_noapic_vcpu);
>  


Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

