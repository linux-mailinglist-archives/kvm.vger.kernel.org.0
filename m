Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD283D7F96
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 22:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhG0U6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 16:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0U6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 16:58:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDBAC061764
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 13:58:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so11884566plh.7
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 13:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rtZ6ilnnW0R4aXVdzWkHN+dkrBKyxblhFWn5qJw5BX4=;
        b=lgDVyE1NLxkLWG2sqFWb87AuLtpWxcXQ9YQvnnaZeevh8TU6MQFxItq8qPL/y40F0a
         KpzV2AStmKI2lMuDzchsdfU4Oj6BS3rkzHUY+bXUQr6Crp4W1S1jpv9xQ6MNhLGVDBQq
         I8/+y+ICVTejQZrqekDXLUnflTeDdgN78rPLXmtq85eLCjeMRAThM9yq1aLQkUiFK59V
         ZsYKAWQlQL7Rew3qyHrhoeP/7Yqxpq0XeYPzNgUqq52yw615pdaR5xoBeo4QtbiQg7fV
         uyycy/tsEhHbzv7zHnp1fFzdbGo2FCnFwHGv5NVXh7TyCzPvCfyopMaKQkuU6blx5iG7
         Yftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rtZ6ilnnW0R4aXVdzWkHN+dkrBKyxblhFWn5qJw5BX4=;
        b=h5pGcmKadI9dVE54dTj7qbfr3jieOxrQhKjplT6INCqThZpkf8Z3xpf6pCtXGYP21z
         zYBaNF8Qu+Uet5jeQhCh+88hskeolctjRCGniJXFZMRwDyLACLHj2X65koImLBVJeb94
         6vVwshR7oyKpeqxcwlB9rAb4rItzMdKfbp1O3iNolR0QLROLwniBDLF7g72rrN0qdQun
         FRq+q0NeSHnS394DuimqLHbpeF33nLXJemJVqj6DXNbyNi/r/ABN39YZ489jjxK1hBK9
         MQg01FOGrHbHb6Ec0XFzT4287MZeeUSoJKCeIvUmRCIDOL4Fy31kQiuo/PdHRvsSIUgk
         QWEg==
X-Gm-Message-State: AOAM532jQjwMk+eBeaHGRIGhx8hYIiUfMETlbb59Au+vGXEPyvVkLK4Z
        LZphshEWC2oyY4MnqiOhcCQIEg==
X-Google-Smtp-Source: ABdhPJzh6OjxGy7f1h2oNCfL+fsi5LvPIYZAKSrMhxqwyB80mfW5Co3shaurnzi4pNaF66WuNVCrpQ==
X-Received: by 2002:a17:90a:9314:: with SMTP id p20mr1328661pjo.87.1627419526863;
        Tue, 27 Jul 2021 13:58:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i1sm4385079pfo.37.2021.07.27.13.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:58:46 -0700 (PDT)
Date:   Tue, 27 Jul 2021 20:58:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
Subject: Re: [PATCH v2] KVM: x86: accept userspace interrupt only if no event
 is injected
Message-ID: <YQBzgtBXZ4SIz9jF@google.com>
References: <20210727170620.1643969-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727170620.1643969-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021, Paolo Bonzini wrote:
> Once an exception has been injected, any side effects related to
> the exception (such as setting CR2 or DR6) have been taked place.
> Therefore, once KVM sets the VM-entry interruption information
> field or the AMD EVENTINJ field, the next VM-entry must deliver that
> exception.
> 
> Pending interrupts are processed after injected exceptions, so
> in theory it would not be a problem to use KVM_INTERRUPT when
> an injected exception is present.  However, DOSEMU is using
> run->ready_for_interrupt_injection to detect interrupt windows
> and then using KVM_SET_SREGS/KVM_SET_REGS to inject the
> interrupt manually.  For this to work, the interrupt window
> must be delayed after the completion of the previous event
> injection.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Stas Sergeev <stsp2@yandex.ru>
> Tested-by: Stas Sergeev <stsp2@yandex.ru>
> Fixes: 71cc849b7093 ("KVM: x86: Fix split-irqchip vs interrupt injection window request")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> (cherry picked from commit 043264d97e9ab74cc9661c8b1f9c00c8ce24cad9)

?  I can't find 043264d97e9ab74cc9661c8b1f9c00c8ce24cad9 anywhere.

> ---
>  arch/x86/kvm/x86.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4116567f3d44..5e921f1e00db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4358,8 +4358,18 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  
>  static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * Do not cause an interrupt window exit if an exception
> +	 * is pending or an event needs reinjection; userspace
> +	 * might want to inject the interrupt manually using KVM_SET_REGS
> +	 * or KVM_SET_SREGS.  For that to work, we must be at an
> +	 * instruction boundary and with no events half-injected.
> +	 */
>  	return kvm_arch_interrupt_allowed(vcpu) &&
> -		kvm_cpu_accept_dm_intr(vcpu);
> +		kvm_cpu_accept_dm_intr(vcpu) &&

Opportunistically align this indentation?

> +	        !kvm_event_needs_reinjection(vcpu)

Missing &&, apparently the mysterious cherry-pick didn't go so well :-)

> +	        !vcpu->arch.exception.pending;
> +
>  }
>  
>  static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
> -- 
> 2.27.0
> 
