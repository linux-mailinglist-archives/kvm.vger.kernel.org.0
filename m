Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FF0327B3E
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbhCAJwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:52:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234213AbhCAJsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 04:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614592031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DEdSTYhusKIEUQMEWKT8rWFneNNIDo9kNRlrq/JgV74=;
        b=KSSCPMegLMxKaAiG1pehT7m40Tkmzk5WJ0L7epLZtge5X3L3yp9/vDdzMG3QIpC5N8gTkd
        N9B1UWDJzGEozL+pTQbhXmq+UkxUv1tgWgGiHm8ZJzHiJr0a8P1DIGQ2wtZicaT/Jma0uZ
        sx3htWfebUwHIndXT8OnNET6+JMTSlI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-rgkmPpsQNkuntUjFuCrW9Q-1; Mon, 01 Mar 2021 04:47:09 -0500
X-MC-Unique: rgkmPpsQNkuntUjFuCrW9Q-1
Received: by mail-ej1-f71.google.com with SMTP id si4so3972621ejb.23
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 01:47:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DEdSTYhusKIEUQMEWKT8rWFneNNIDo9kNRlrq/JgV74=;
        b=l2B1ysL6KY2DtnStyTp+aONnU6rN5hu9u44Yx5BcRzadu5RbHch16BaX/XoZ4vRA5G
         eO0RBBN7i+yO9jFaZyk0DlHBLFdg98U+0t7MYCnFsmm1y6BSDnhGxSXnDGMa0HnEwUyp
         6iw2G3z6MB/46gBRn6tenHGmJrJWz4vA5nivofVYtBGRzF/+DkQdXj/zRcB5Beili8aX
         4VarrGyLIPFczOrhD2WLrQ45qmC8KBG/YpgM1yyo+osy46SHZBhaUxInEShhWAM3SH1N
         abb0IRA6AfTP+Wkv/+XmNn5aWyWIKsuFbi/f66agYImXWUUMyaNDeQ7vvPRQ7+0/0E/v
         TZBQ==
X-Gm-Message-State: AOAM532C+xzJnh7Ub51mvHWbiC+7FHtgwUyrBL1igZjfdhax3JZSZk/m
        TEsZ/wJ3NTF6P4AAjpkZApwfqqaMni34FeH04rb7xWgR89BNKK+7NAhAhux6ksSgLtLHpc6tFNz
        +CTFXgzHTXw3k
X-Received: by 2002:a17:906:4d44:: with SMTP id b4mr12635051ejv.338.1614592028564;
        Mon, 01 Mar 2021 01:47:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJww4C8e9HKNDgXgmW4+saDJedsySlEms/PREMX3yPjbp5VrNbtcX7+INJgHeyO7isHJIGpong==
X-Received: by 2002:a17:906:4d44:: with SMTP id b4mr12635038ejv.338.1614592028438;
        Mon, 01 Mar 2021 01:47:08 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e18sm13030639eji.111.2021.03.01.01.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 01:47:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: hyper-v: Fix Hyper-V context null-ptr-deref
In-Reply-To: <1614326399-5762-1-git-send-email-wanpengli@tencent.com>
References: <1614326399-5762-1-git-send-email-wanpengli@tencent.com>
Date:   Mon, 01 Mar 2021 10:47:07 +0100
Message-ID: <87lfb7fbok.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Reported by syzkaller:
>
>     KASAN: null-ptr-deref in range [0x0000000000000140-0x0000000000000147]
>     CPU: 1 PID: 8370 Comm: syz-executor859 Not tainted 5.11.0-syzkaller #0
>     RIP: 0010:synic_get arch/x86/kvm/hyperv.c:165 [inline]
>     RIP: 0010:kvm_hv_set_sint_gsi arch/x86/kvm/hyperv.c:475 [inline]
>     RIP: 0010:kvm_hv_irq_routing_update+0x230/0x460 arch/x86/kvm/hyperv.c:498
>     Call Trace:
>      kvm_set_irq_routing+0x69b/0x940 arch/x86/kvm/../../../virt/kvm/irqchip.c:223
>      kvm_vm_ioctl+0x12d0/0x2800 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3959
>      vfs_ioctl fs/ioctl.c:48 [inline]
>      __do_sys_ioctl fs/ioctl.c:753 [inline]
>      __se_sys_ioctl fs/ioctl.c:739 [inline]
>      __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
>      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>      entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Hyper-V context is lazily allocated until Hyper-V specific MSRs are accessed 
> or SynIC is enabled. However, the syzkaller testcase sets irq routing table 
> directly w/o enabling SynIC. This results in null-ptr-deref when accessing 
> SynIC Hyper-V context. This patch fixes it.
>      
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=163342ccd00000
>
> Reported-by: syzbot+6987f3b2dbd9eda95f12@syzkaller.appspotmail.com
> Fixes: 8f014550dfb1 ("KVM: x86: hyper-v: Make Hyper-V emulation enablement conditional")
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/hyperv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 7d2dae9..58fa8c0 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -159,7 +159,7 @@ static struct kvm_vcpu_hv_synic *synic_get(struct kvm *kvm, u32 vpidx)
>  	struct kvm_vcpu_hv_synic *synic;
>  
>  	vcpu = get_vcpu_by_vpidx(kvm, vpidx);
> -	if (!vcpu)
> +	if (!vcpu || !to_hv_vcpu(vcpu))
>  		return NULL;
>  	synic = to_hv_synic(vcpu);
>  	return (synic->active) ? synic : NULL;

Oops, I've missed this path completely. Thanks for the fix!

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

