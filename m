Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D492A1848DB
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 15:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgCMOKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 10:10:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbgCMOKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 10:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584108601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F1V8F7R+emEsH2Puu+xTU6xnzq5JbKAu2uhy1Jl9ZpQ=;
        b=RgY8wSeA+NigxyzLgzHCdB+fj82cIJ6Xjt1kNFPaqnuxt04yuiZzwwI97Qmdau5fZFZhZU
        uKeUbUi1ONQqwl4EG12ubOE4Uu/sIwJ3U6RfJjkWrHKF4Wl5AuxvNs2B7lXdNXsx+bp7AR
        IJc9r3qjnArrMINcfhh6DOdAGNBHCXQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-AobhcPTcOnul26uc_4aINg-1; Fri, 13 Mar 2020 10:09:59 -0400
X-MC-Unique: AobhcPTcOnul26uc_4aINg-1
Received: by mail-wr1-f69.google.com with SMTP id u12so1872487wrw.10
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 07:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F1V8F7R+emEsH2Puu+xTU6xnzq5JbKAu2uhy1Jl9ZpQ=;
        b=aeHYUhnUimvRKlKEopLadp2QF/KbD83e2Dh6mOj/Pib04aKM1UEDNY1bxDJnAIP46q
         nPN5SuxyAYAtVo7hHDtyMt28EFc5AROo/c8FpAKIBFMLZ8JTxX3FtKxEA4fyuej6NfzX
         /wi91h2QAcalai9LOGfoWpJB/0FbhbW9bZkLYIDdOlgr3O1MC8aLuqoHVa0oa93Wb0kQ
         qUTWjtKhQTGCAXEMyViWU+xGG50PvExwqIL/q60CI46kfMqKtKoZsuwbShmG7lAK+E4E
         7ii+O9VDLhol6u/0uv7KPPGZi91Ws80VoV51wGrov+xWdVytWKni4Rz0pZz7FTKV+4AP
         XgyQ==
X-Gm-Message-State: ANhLgQ3C3xbE8uQMmKqa52AAzSUUECsCZkZeGWqu6DqYMKqXMmwFJqq1
        XVw6A0kVHFw6p26txtyn1JzXX3vGUYGF2qJfGMiSbPTnYxaMvjl/op7nxaFqfGv3w5BXTWgjZPZ
        nnYgaU0cJRxXQ
X-Received: by 2002:adf:9071:: with SMTP id h104mr18213508wrh.359.1584108597987;
        Fri, 13 Mar 2020 07:09:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvhEwV3TeTg8xQbLJb4GROPa8wOf4t+geLxrOrIV4oik7bg0a3LBUdPL/nDNQ3nNvTxJhw7oQ==
X-Received: by 2002:adf:9071:: with SMTP id h104mr18213482wrh.359.1584108597771;
        Fri, 13 Mar 2020 07:09:57 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k126sm17084484wme.4.2020.03.13.07.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 07:09:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 09/10] KVM: VMX: Cache vmx->exit_reason in local u16 in vmx_handle_exit_irqoff()
In-Reply-To: <20200312184521.24579-10-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com> <20200312184521.24579-10-sean.j.christopherson@intel.com>
Date:   Fri, 13 Mar 2020 15:09:47 +0100
Message-ID: <87h7ysny6s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use a u16 to hold the exit reason in vmx_handle_exit_irqoff(), as the
> checks for INTR/NMI/WRMSR expect to encounter only the basic exit reason
> in vmx->exit_reason.
>

True Sean would also add:

"No functional change intended."

"Opportunistically align the params to handle_external_interrupt_irqoff()."

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d43e1d28bb58..910a7cadeaf7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6287,16 +6287,16 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>  
>  static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> -	enum exit_fastpath_completion *exit_fastpath)
> +				   enum exit_fastpath_completion *exit_fastpath)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u16 exit_reason = vmx->exit_reason;
>  
> -	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +	if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
>  		handle_external_interrupt_irqoff(vcpu);
> -	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
> +	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
>  		handle_exception_nmi_irqoff(vmx);
> -	else if (!is_guest_mode(vcpu) &&
> -		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> +	else if (!is_guest_mode(vcpu) && exit_reason == EXIT_REASON_MSR_WRITE)
>  		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

