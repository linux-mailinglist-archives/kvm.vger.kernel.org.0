Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5911C512D0E
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiD1HjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245646AbiD1HjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:39:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E03D9399A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651131352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OqfdA0bLR2lU6dIJnTIPrt1WfOytY9LJKfbf8xcOP6k=;
        b=FO1GvlVd1+aMjqhen1N9epQo10xJSrCv8s5XDvEpl3pOVI9FsU7R1HIJ3I6h2OyjipOnDK
        0hQmjPx4RZHwAhyxQZHAVkKj9is4kWdAt/ttArYqaisqTcPFmu4KfiQn4WlTDjju5swPv3
        KWHKrvygs3g9LbxFZFP13P0F0ATYB08=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-mvpQepD2MrqNQ2MYjfAh-A-1; Thu, 28 Apr 2022 03:35:48 -0400
X-MC-Unique: mvpQepD2MrqNQ2MYjfAh-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42F39811E75;
        Thu, 28 Apr 2022 07:35:48 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F0C7407E240;
        Thu, 28 Apr 2022 07:35:45 +0000 (UTC)
Message-ID: <61ad22d6de1f6a51148d2538f992700cac5540d4.camel@redhat.com>
Subject: Re: [PATCH v2 02/11] KVM: SVM: Don't BUG if userspace injects a
 soft interrupt with GIF=0
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Date:   Thu, 28 Apr 2022 10:35:45 +0300
In-Reply-To: <20220423021411.784383-3-seanjc@google.com>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Don't BUG/WARN on interrupt injection due to GIF being cleared if the
> injected event is a soft interrupt, which are not actually IRQs and thus

Are any injected events subject to GIF set? I think that EVENTINJ just injects
unconditionaly whatever hypervisor puts in it.

Best regards,
	Maxim Levitsky

> not subject to IRQ blocking conditions.  KVM doesn't currently use event
> injection to handle incomplete soft interrupts, but it's trivial for
> userspace to force the situation via KVM_SET_VCPU_EVENTS.
> 
> Opportunistically downgrade the BUG_ON() to WARN_ON(), there's no need to
> bring down the whole host just because there might be some issue with
> respect to guest GIF handling in KVM, or as evidenced here, an egregious
> oversight with respect to KVM's uAPI.
> 
>   kernel BUG at arch/x86/kvm/svm/svm.c:3386!
>   invalid opcode: 0000 [#1] SMP
>   CPU: 15 PID: 926 Comm: smm_test Not tainted 5.17.0-rc3+ #264
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:svm_inject_irq+0xab/0xb0 [kvm_amd]
>   Code: <0f> 0b 0f 1f 00 0f 1f 44 00 00 80 3d ac b3 01 00 00 55 48 89 f5 53
>   RSP: 0018:ffffc90000b37d88 EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: ffff88810a234ac0 RCX: 0000000000000006
>   RDX: 0000000000000000 RSI: ffffc90000b37df7 RDI: ffff88810a234ac0
>   RBP: ffffc90000b37df7 R08: ffff88810a1fa410 R09: 0000000000000000
>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>   R13: ffff888109571000 R14: ffff88810a234ac0 R15: 0000000000000000
>   FS:  0000000001821380(0000) GS:ffff88846fdc0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f74fc550008 CR3: 000000010a6fe000 CR4: 0000000000350ea0
>   Call Trace:
>    <TASK>
>    inject_pending_event+0x2f7/0x4c0 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x791/0x17a0 [kvm]
>    kvm_vcpu_ioctl+0x26d/0x650 [kvm]
>    __x64_sys_ioctl+0x82/0xb0
>    do_syscall_64+0x3b/0xc0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>    </TASK>
> 
> Fixes: 219b65dcf6c0 ("KVM: SVM: Improve nested interrupt injection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 75b4f3ac8b1a..151fba0b405f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3384,7 +3384,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	BUG_ON(!(gif_set(svm)));
> +	WARN_ON(!vcpu->arch.interrupt.soft && !gif_set(svm));
>  
>  	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
>  	++vcpu->stat.irq_injections;


